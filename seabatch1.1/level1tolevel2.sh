#!/bin/bash


#This script processes MODIS (Aqua and Terra) and SeaWiFS Level-1A files to 
#Level-2.


echo; echo; echo '***** START LEVEL-1A TO LEVEL-2 PROCESSING *****'


###########################################################################
###########################################################################
#Specify the l2gen parameter file.
L2GEN_PARFILE='l2gen_default_parfile'

#If L2GEN_PARFILE is not set to l2gen_default_parfile check that the 
#specified parameter file exists.
if [ $L2GEN_PARFILE != l2gen_default_parfile ]; then
	if [ ! -e $L2GEN_PARFILE ]; then
		echo; echo; echo 'ERROR: L2GEN_PARFILE does not exist:' $L2GEN_PARFILE
		exit 1
	fi
fi	
###########################################################################
###########################################################################


###########################################################################
###########################################################################
#Define variables read in from master_script.sh.
L2GEN_PRDCT_AMNT=${1}
for (( a=0; a < $L2GEN_PRDCT_AMNT; a++ )); do
	PARAMETER=$(( 2 + $a + 1))
	eval L2GEN_PRDCT_ARRAY[$a]=\${$PARAMETER}
done
MODIS_L2GEN_RES=${2}

#Display variables.
echo; echo; echo 'Variables used:'
echo '- L2GEN_PRDCT_AMNT:' $L2GEN_PRDCT_AMNT
echo '- L2GEN_PRDCT_ARRAY:' ${L2GEN_PRDCT_ARRAY[@]}
echo '- MODIS_L2GEN_RES:' $MODIS_L2GEN_RES
###########################################################################
###########################################################################


###########################################################################
###########################################################################
for L1A_FILE in [AST]*.L1A_[GL]AC* S*.L1A_MLAC*; do

	#Check that L1A_FILE is a regular file. There are two situations
	#where it won't be: 1) If no files exist that match the pattern
	#"[AST]*.L1A_[GL]AC*" or 2) If no files exis that match the pattern
	#"S*.L1A_MLAC*. If L1A_FILE is not a regular file then the current
	#itteration of the loop stops, and the next one begins.
	if [ ! -f $L1A_FILE ]; then
		continue
	fi

	echo; echo; echo '***** CURRENT LEVEL-1A FILE:' $L1A_FILE '*****'

	#Determine the sensor of the Level-1A file (MODIS-Aqua, MODIS-Terra,
	#SeaWiFS). This is necessary because MODIS and SeaWiFS Level-1A to
	#Level-2 processing are slightly different.
	SENSOR=$(echo $L1A_FILE | awk '{ print substr( $0, 1, 1 ) }')

	#Process Level-1A MODIS files.	
	if [ $SENSOR = A -o $SENSOR = T ]; then
	
		echo; echo; echo 'MODIS Processing'
		
		#If L2GEN_PARFILE is set to "l2gen_default_parfile" then 
		#construct it.
		if [ $L2GEN_PARFILE = l2gen_default_parfile ]; then
			echo 'l2prod='${L2GEN_PRDCT_ARRAY[@]} > l2gen_default_parfile
			echo 'resolution='$MODIS_L2GEN_RES >> l2gen_default_parfile
		fi
		
		echo; echo; echo 'L2GEN_PARFILE used:' $L2GEN_PARFILE
		cat $L2GEN_PARFILE
		
		#Define the GEO, Level-1B, and Level-2 filenames. These 
		#consist of the base of the input Level-1A filename, 
		#followed by the appropriate suffix.
		BASE=$(echo $L1A_FILE | awk -F. '{ print $1 }')
		GEO_FILE=${BASE}.GEO
		L1B_FILE=${BASE}.L1B_LAC
		L2_FILE=${BASE}.L2_LAC
	
		#Construct a GEO file.
		echo; echo; echo '***** CONSTRUCTING' $GEO_FILE '*****'; echo
		modis_L1A_to_GEO.csh $L1A_FILE -b
		if [ $? -ne 0 ]; then
			echo; echo; echo '***** ERROR: GEO FILE CONSTRUCTION STOPPED ON' $L1A_FILE '*****'
			exit 1
		fi
	
		#Construct the Level-1B file utilizing the Level-1A and GEO 
		#files.
		echo; echo '***** CONSTRUCTING' $L1B_FILE '*****'; echo
		modis_L1A_to_L1B.csh $L1A_FILE $GEO_FILE -b
		if [ $? -ne 0 ]; then
			echo; echo; echo '***** ERROR: LEVEL-1B FILE CONSTRUCTION STOPPED ON' $L1A_FILE '*****'
			exit 1
		fi
		
		#Obtain the proper ancillary files.
		echo; echo; echo '***** OBTAINING ANCILLARY FILES *****'; echo; echo
		ms_met.csh $L1B_FILE
		ms_ozone.csh $L1B_FILE
		ms_oisst.csh $L1B_FILE
	
		#Construct the Level-2 file utilizing the GEO and Level-1B files.
		echo; echo '*****CONSTRUCTING' $L2_FILE '*****'; echo; echo
		l2gen ifile=$L1B_FILE geofile=$GEO_FILE ofile=$L2_FILE \
		par=$L2GEN_PARFILE \
		par=${L1B_FILE}.met_list \
		par=${L1B_FILE}.ozone_list \
		par=${L1B_FILE}.sst_list
		if [ $? -ne 0 ]; then
			echo; echo; echo '***** ERROR: LEVEL-2 FILE CONSTRUCTION STOPPED ON' $L1A_FILE '*****'
			exit 1
		fi
	
		#Remove L2GEN_PARFILE, GEO_FILE, the Level-1B files, and the 
		#met/ozone/sst_list files.
		rm $L2GEN_PARFILE $GEO_FILE *L1B*
			
	fi
		
	#Process Level-1A SeaWiFS files.
	if [ $SENSOR = S ]; then	
		
		echo; echo; echo 'SeaWiFS Processing'
		
		#If L2GEN_PARFILE is set to "l2gen_default_parfile" then 
		#construct it.
		if [ $L2GEN_PARFILE = l2gen_default_parfile ]; then
			echo 'l2prod='${L2GEN_PRDCT_ARRAY[@]} > l2gen_default_parfile
		fi
		
		echo; echo; echo 'L2GEN_PARFILE used:' $L2GEN_PARFILE
		cat $L2GEN_PARFILE
	
		#Define the Level-2 filename. This consists of the base of 
		#the input Level-1A filename, followed by the appropriate 
		#suffix.
		BASE=$(echo $L1A_FILE | awk -F. '{ print $1 }')
		SUFFIX=$(echo $L1A_FILE | awk -F. '{ print $2 }' | cut -c5-)
		L2_FILE=${BASE}.L2_$SUFFIX
		
		#Obtain the proper ancillary files.
		echo; echo; echo '***** OBTAINING  ANCILLARY FILES *****'; echo; echo
		ms_met.csh $L1A_FILE
		ms_ozone.csh $L1A_FILE
		ms_oisst.csh $L1A_FILE
	
		#Construct the Level-2 file utilizing the Level-1A file.
		echo; echo '*****CONSTRUCTING' $L2_FILE '*****'; echo; echo
		l2gen ifile=$L1A_FILE ofile=$L2_FILE \
		par=$L2GEN_PARFILE \
		par=${L1A_FILE}.met_list \
		par=${L1A_FILE}.ozone_list \
		par=${L1A_FILE}.sst_list
		if [ $? -ne 0 ]; then
			echo; echo; echo '***** ERROR: LEVEL-2 FILE CONSTRUCTION STOPPED ON' $L1A_FILE '*****'
			exit 1
		fi
	
		#If L2GEN_PARFILE is set to l2gen_default_parfile remove it.
		if [ $L2GEN_PARFILE = l2gen_default_parfile ]; then
			rm $L2GEN_PARFILE
		fi
		
		#Remove the met/ozone/sst_list files.
		rm *list
				
	fi
			
done
###########################################################################
###########################################################################


echo; echo; echo '***** LEVEL-1A TO LEVEL-2 PROCESSING COMPLETE *****'


exit 0

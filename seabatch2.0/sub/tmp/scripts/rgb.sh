#!/bin/bash




###########################################################################
###########################################################################
#Specify processing parameters here.
MAP='yes'
RESOLUTION='250' #(-1, 250, 500, or 1000)
OUT_FTYPE='24b_hdf' #(8b_hdf, 24b_hdf, jpg, ppm, or flat)

#If MAP is set equal to "yes" then specify the lat/lon bounds of your 
#region of interest. 
NORTH='44.75'
SOUTH='44.65'
EAST='-63.57'
WEST='-63.7'
###########################################################################
###########################################################################




echo; echo; echo 'Running rgb.sh...'




###########################################################################
###########################################################################
if [ $OUT_FTYPE = '8b_hdf' ]; then
	L1BRSGEN_OUT_FTYPE=0
	SUFFIX='hdf'
elif [ $OUT_FTYPE = '24b_hdf' ]; then
	L1BRSGEN_OUT_FTYPE=1
	SUFFIX='hdf'
elif [ $OUT_FTYPE = 'jpg' -o $OUT_FTYPE = 'ppm' ]; then
	L1BRSGEN_OUT_FTYPE=2
	SUFFIX='ppm'
elif [ $OUT_FTYPE = 'flat' ]; then
	L1BRSGEN_OUT_FTYPE=3
	SUFFIX='flat'
fi
###########################################################################
###########################################################################


###########################################################################
###########################################################################
for L1A_FILE in [AST]*.L1A_[GL]AC*; do

	#Check that L1A_FILE is a regular file. There is one situation
	#where it won't be: If no files exist that match the pattern
	#"[AST]*.L1A_[GL]AC*". If L1A_FILE is not a regular file then the 
	#current itteration of the loop stops, and the next one begins.
	if [ ! -f $L1A_FILE ]; then
		continue
	fi

	echo; echo; echo '***** Current Level-1A file:' $L1A_FILE'. *****'
	
	#Define the GEO and Level-1B filenames. These consist of the base 
	#of the input Level-1A filename, followed by the appropriate suffix.
	BASE=$(echo $L1A_FILE | awk -F. '{ print $1 }')
	
	GEO_FILE=${BASE}.GEO
	
	L1B_LAC_FILE=${BASE}.L1B_LAC
	L1B_HKM_FILE=${BASE}.L1B_HKM
	L1B_QKM_FILE=${BASE}.L1B_QKM
	if [ $RESOLUTION = -1 -o $RESOLUTION = 1000 ]; then
		L1B_FILE=$L1B_LAC_FILE
	elif [ $RESOLUTION = 500 ]; then
		L1B_FILE=$L1B_HKM_FILE
	elif [ $RESOLUTION = 250 ]; then
		L1B_FILE=$L1B_QKM_FILE
	fi
	
	if [ $MAP = 'yes' ]; then
		RGB_FILE=${BASE}_mapped.ppm
	elif [ $MAP = 'no' ]; then
		RGB_FILE=${BASE}.$SUFFIX
	fi
	
	#Construct the GEO file.
	echo; echo; echo '***** Constructing' $GEO_FILE'... *****'; echo
	modis_GEO.csh $L1A_FILE -b
	if [ $? -ne 0 ]; then
		echo; echo; echo '***** Error: modis_L1A_to_GEO.csh failed on' $L1A_FILE'. *****'
		echo; echo; echo 'Exiting' $SEADAS'/seabatch1.2/rgb.sh... Exit status: 1.'
		exit 1
	fi
	
	#Construct the Level-1B file utilizing the Level-1A and GEO files.
	echo; echo '***** Constructing' $L1B_LAC_FILE'... *****'; echo
	modis_L1B.csh $L1A_FILE $GEO_FILE -b
	if [ $? -ne 0 ]; then
		echo; echo; echo '***** Error: modis_L1A_to_L1B.csh failed on' $L1A_FILE'. *****'
		echo; echo; echo 'Exiting' $SEADAS'/seabatch1.2/rgb.sh... Exit status: 1.'
		exit 1
	fi
	
	#If MAP is set equal to "yes" then construct the mapped RGB file 
	#utilizing the Level-1B and GEO files.
	if [ $MAP = 'yes' ]; then
		echo; echo; echo '***** Constructing' $RGB_FILE'... *****'; echo; echo
		l1mapgen ifile=$L1B_FILE geofile=$GEO_FILE ofile=$RGB_FILE resolution=$RESOLUTION north=$NORTH south=$SOUTH east=$EAST west=$WEST
	fi
	
	#If MAP is set equal to "no" then construct the unmapped RGB file 
	#utilizing the Level-1B and GEO files.
	if [ $MAP = 'no' ]; then
		echo; echo; echo '***** Constructing' $RGB_FILE'... *****'; echo; echo
		l1brsgen ifile=$L1B_FILE geofile=$GEO_FILE ofile=$RGB_FILE subsamp=1 resolution=$RESOLUTION outmode=$L1BRSGEN_OUT_FTYPE
		if [ $? -ne 0 ]; then
			echo; echo; echo '***** Error: l1brsgen failed on' $L1B_FILE'. *****'
			echo; echo; echo 'Exiting' $SEADAS'/seabatch1.2/rgb.sh... Exit status: 1.'
			exit 1
		fi
	fi
	
	#If OUT_FTYPE is set equal to "jpg", the RGB_FILE just constructed 
	#is a ppm file. Convert RGB_FILE from ppm to jpg.
	if [ $OUT_FTYPE = 'jpg' ]; then
		cat $RGB_FILE | cjpeg > ${BASE}.jpg
		rm $RGB_FILE
	fi
	
	#Remove the "*.L1B*" and ".GEO" files.
	#rm *.L1B* *.GEO
	
done
###########################################################################
###########################################################################

		


echo; echo 'Exiting' $SEADAS'/seabatch1.2/rgb.sh... Exit status: 0.'
exit 0

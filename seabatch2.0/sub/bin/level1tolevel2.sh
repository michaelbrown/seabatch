#!/bin/bash




###########################################################################
###########################################################################
#This script processes MODIS (Aqua and Terra) and SeaWiFS Level-1A files to 
#Level-2.
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#Source the contents of SEABATCH_CONFIGURATION_DIRECTORY.

for SEABATCH_CONFIGURATION_FILE in $SEABATCH_CONFIGURATION_DIRECTORY/*; do
	source $SEABATCH_CONFIGURATION_FILE
done
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#Define SEABATCH_SCRIPT_NAME and SEABATCH_SCRIPT_VERSION, the name and
#version of the current script.

SEABATCH_SCRIPT_NAME=${0}
SEABATCH_SCRIPT_VERSION='2.0'

run_seabatch_script
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#Define SEABATCH_LOG_DIRECTORY, the name of the directory containing the
#log information of the current SeaBatch run. 

SEABATCH_LOG_DIRECTORY=${1}
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#Define and source SEABATCH_PARAMETER_FILE, the SeaBatch parameter file 
#that will be used which contains the user-specified processing variables.

SEABATCH_PARAMETER_FILE=${2}
source $SEABATCH_PARAMETER_FILE
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#Display the processing variables used by level2tolevel3_spatialbin.sh.

echo; echo; seabatch_separator
seabatch_statement "Processing variables used by ${SEABATCH_SCRIPT_NAME}:"
echo
seabatch_statement "- SENSOR: ${SENSOR}"
seabatch_statement "- YEAR: ${YEAR}"
seabatch_statement "- WEST: ${WEST}"
seabatch_statement "- EAST: ${EAST}"
seabatch_statement "- NORTH: ${NORTH}"
seabatch_statement "- SOUTH: ${SOUTH}"
echo "- L2_PRODUCTS: ${L2_PRODUCTS[@]}"
seabatch_statement "- L2_RESOLUTION: ${L2_RESOLUTION}"
seabatch_statement "- L2GEN_PARAMETER_FILE: ${L2GEN_PARAMETER_FILE}"
seabatch_separator
###########################################################################
###########################################################################




###########################################################################
###########################################################################
if [ $SENSOR = 'AQUA' -o $SENSOR = 'TERRA' ]; then
	
	
	
	
	###################################################################
	###################################################################
	echo; echo; seabatch_separator
	seabatch_statement "Begin Level-1 to Level-2 processing of MODIS Level-1A files ..."
	seabatch_separator
	###################################################################
	###################################################################




	###################################################################
	###################################################################
	FILE_TYPE='MODIS Level-1A files'
	FILE_TYPE_PATTERNS=[AT]${YEAR}*.L1A*
	FILE_TYPE_TEXT_FILE=${SEABATCH_LOG_DIRECTORY}'/file_list/modis_l1a.txt'
			
	file_type_list
			
	if [ $FILE_TYPE_FILE_AMOUNT -eq 0 ]; then
		exit 1
	fi
	###################################################################
	###################################################################




	###################################################################
	###################################################################
	while read MODIS_L1A_FILE; do
		
		
		
		
		###########################################################
		###########################################################
		echo; echo; seabatch_separator
		seabatch_statement "Current MODIS Level-1A file: ${MODIS_L1A_FILE}"
		seabatch_separator
		###########################################################
		###########################################################
					
					
					
					
		###########################################################
		###########################################################
		#Define BASENAME, the basename of MODIS_L1A_FILE.
			
		BASENAME=$(echo $MODIS_L1A_FILE | awk -F. '{ print $1 }')
		###########################################################
		###########################################################



































###########################################################################
###########################################################################
#If L2_PROCESSING_TYPE is set to "MODIS" then begin the MODIS Level-1 to
#Level-2 processing.

if [ $L2_PROCESSING_TYPE = 'MODIS' ]; then




	###################################################################
	###################################################################
	echo; echo; separator
	echo 'Begin MODIS Level-1 to Level-2 processing ...'
	separator
	###################################################################
	###################################################################




	###################################################################
	###################################################################
	#If L2GEN_PARAMETER_FILE is set to "default" then construct 
	#"l2gen_default_modis.par".
	
	if [ $L2GEN_PARAMETER_FILE = 'default' ]; then
	
		L2GEN_PARAMETER_FILE='l2gen_default_modis.par'
		
		echo 'l2prod='${L2GEN_PRODUCTS[@]} > ${L2GEN_PARAMETER_FILE}
		echo 'resolution='${L2GEN_RESOLUTION} >> ${L2GEN_PARAMETER_FILE}
		
	fi
	###################################################################
	###################################################################
	
	
	
	
	###################################################################
	###################################################################
	for L1A_FILE in ${SENSOR}${YEAR}*.L1A_[GL]AC*; do
	
	
	
	
	
	
		###########################################################
		###########################################################
		#Define BASE, the basename of L1A_FILE.

		BASE=$(echo $L1A_FILE | awk -F. '{ print $1 }')
		
		#Define GEO_FILE, L1B_LAC_FILE, ANC_FILE, and L2_FILE, the 
		#names of the geolocation, Level-1B LAC (1 km), ancillary, 
		#and Level-2 files that will be constructed, respectively.
		
		GEO_FILE=${BASE}.GEO
		L1B_LAC_FILE=${BASE}.L1B_LAC
		ANC_FILE=${L1B_LAC_FILE}.anc
		L2_FILE=${BASE}.L2_LAC
		###########################################################
		###########################################################
		
		
		
		
		###########################################################
		###########################################################
		#Construct GEO_FILE using the SeaDAS script 
		#modis_L1A_to_GEO.csh.
		
		echo; echo; separator 
		echo 'Constructing' $GEO_FILE '...'
		separator; echo; echo
		
		modis_L1A_to_GEO.csh $L1A_FILE -b
		
		if [ $? -ne 0 ]; then
			SEADAS_SCRIPT_NAME='modis_L1A_to_GEO.csh'
			SCRIPT_ERROR_ACTION='DEFAULT'
			script_error_action $L1A_FILE
		fi
		###########################################################
		###########################################################
		
		
		
		
		###########################################################
		###########################################################
		#Process L1A_FILE from Level-1A to Level-1B using the SeaDAS 
		#script modis_L1A_to_L1B.csh. 
		
		echo; separator
		echo 'Processing' ${L1A_FILE} 'from Level-1A to Level-1B ...'
		separator; echo
		
		modis_L1A_to_L1B.csh $L1A_FILE $GEO_FILE -b
		
		if [ $? -ne 0 ]; then
			SEADAS_SCRIPT_NAME='modis_L1A_to_L1B.csh'
			SCRIPT_ERROR_ACTION='DEFAULT'
			script_error_action $L1A_FILE
		fi
		###########################################################
		###########################################################
		
		
		
		
		###########################################################
		###########################################################
		#Construct ANC_FILE using the SeaDAS script getanc.
		
		echo; echo; separator
		echo 'Constructing' ${ANC_FILE} '...'
		separator; echo; echo
		
		getanc $L1B_LAC_FILE -verbose
		
		if [ $? -ne 0 ]; then
			SEADAS_SCRIPT_NAME='getanc'
			SCRIPT_ERROR_ACTION='DEFAULT'
			script_error_action $L1B_LAC_FILE
		fi
		###########################################################
		###########################################################
		
		
		
		
		###########################################################
		###########################################################
		#Process L1B_LAC_FILE from Level-1B to Level-2 using the 
		#SeaDAS script l2gen.
		
		echo; separator
		echo 'Processing' $L1B_LAC_FILE 'from Level-1B to Level-2 ...'
		separator
		
		echo; echo; separator
		echo 'l2gen parameter file used:' ${L2GEN_PARAMETER_FILE}
		echo
		cat $L2GEN_PARAMETER_FILE
		separator; echo; echo
		
		l2gen ifile=$L1B_LAC_FILE geofile=$GEO_FILE ofile=$L2_FILE \
		par=$ANC_FILE \
		par=$L2GEN_PARAMETER_FILE
		
		if [ $? -ne 0 ]; then
			SEADAS_SCRIPT_NAME='l2gen'
			SCRIPT_ERROR_ACTION='DEFAULT'
			script_error_action $L1B_LAC_FILE
		fi
		###########################################################
		###########################################################
		
		
		
		
		###########################################################
		###########################################################
		#Remove the geolocation, Level-1B (LAC, HKM, and QKM), and 
		#ancillary files.
		
		echo; echo; separator
		echo 'Removing' ${GEO_FILE} '...'
		separator
		
		rm $GEO_FILE
		
		echo; echo; separator
		echo 'Removing the following' L1B files':'
		echo
		ls *.L1B_[A-Z][A-Z][A-Z]
		separator
		
		rm *.L1B_[A-Z][A-Z][A-Z]
		
		echo; echo; separator
		echo 'Removing' ${ANC_FILE} '...'
		separator
		
		rm $ANC_FILE
		###########################################################
		###########################################################
	
	
	
	
	done
	###################################################################
	###################################################################
	
	
	
	
	###################################################################
	###################################################################
	echo; echo; separator
	echo 'MODIS Level-1 to Level-2 processing finished!'
	separator
	###################################################################
	###################################################################
	
	
	
	
	###################################################################
	###################################################################
	#If L2GEN_PARAMETER_FILE is set to "l2gen_default_modis.par" remove 
	#it.
		
	if [ $L2GEN_PARAMETER_FILE = 'l2gen_default_modis.par' ]; then
	
		echo; echo; separator
		echo 'Removing' $L2GEN_PARAMETER_FILE '...'
		separator
			
		rm $L2GEN_PARAMETER_FILE
		
	fi
	###################################################################
	###################################################################
	



fi
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#If L2_PROCESSING_TYPE is set to "SEAWIFS" then begin the SeaWiFS Level-1 
#to Level-2 processing.

if [ $L2_PROCESSING_TYPE = 'SEAWIFS' ]; then




	###################################################################
	###################################################################
	echo; echo; separator
	echo 'Begin SeaWiFS Level-1 to Level-2 processing ...'
	separator
	###################################################################
	###################################################################




	###################################################################
	###################################################################
	#If L2GEN_PARAMETER_FILE is set to "default" then construct 
	#"l2gen_default_seawifs.par".
	
	if [ $L2GEN_PARAMETER_FILE = 'default' ]; then
	
		L2GEN_PARAMETER_FILE='l2gen_default_seawifs.par'
		
		echo 'l2prod='${L2GEN_PRODUCTS[@]} > ${L2GEN_PARAMETER_FILE}
		
	fi
	###################################################################
	###################################################################
	
	
	
	
	###################################################################
	###################################################################
	for L1A_FILE in ${SENSOR}${YEAR}*.L1A_[GL]AC* S${YEAR}*.L1A_MLAC*; do
	
	
	
	
		###########################################################
		###########################################################
		echo; echo; separator
		echo 'Current SeaWiFS Level-1A file:' ${L1A_FILE}
		separator
		###########################################################
		###########################################################
		
		
		
	
		###########################################################
		###########################################################
		#Check that L1A_FILE is a regular file. There are two 
		#situations where it won't be: 1) If no files exist that 
		#match the pattern "${SENSOR}${YEAR}*.L1A_[GL]AC*" or 2) If  
		#no files exist that match the pattern "S${YEAR}*.L1A_MLAC*". 
		#If L1A_FILE is not a regular file then the current 
		#itteration of the loop stops, and the next one begins.
	
		if [ ! -f $L1A_FILE ]; then
			
			echo; echo; separator
			echo ${L1A_FILE} 'is not a regular file. Continuing to next file ...'
			separator
		
			continue
			
		fi
		###########################################################
		###########################################################
	
	
	
	
		###########################################################
		###########################################################
		#Define BASE, the basename of L1A_FILE. Define SUFFIX, the
		#suffix of L1A_FILE.

		BASE=$(echo $L1A_FILE | awk -F. '{ print $1 }')
		SUFFIX=$(echo $L1A_FILE | awk -F. '{ print $2 }' | cut -c5-)
		
		#Define ANC_FILE and L2_FILE, the names of the ancillary and 
		#Level-2 files that will be constructed, respectively.
		
		ANC_FILE=${L1A_FILE}.anc
		L2_FILE=${BASE}.L2_${SUFFIX}
		###########################################################
		###########################################################
		
		
		
		
		###########################################################
		###########################################################
		#Construct ANC_FILE using the SeaDAS script getanc.
		
		echo; echo; separator
		echo 'Constructing' ${ANC_FILE} '...'
		separator; echo; echo
		
		getanc $L1A_FILE
		
		if [ $? -ne 0 ]; then
			SEADAS_SCRIPT_NAME='getanc'
			SCRIPT_ERROR_ACTION='DEFAULT'
			script_error_action $L1A_FILE
		fi
		###########################################################
		###########################################################
		
		
		
		
		###########################################################
		###########################################################
		#Process L1A_FILE from Level-1A to Level-2 using the SeaDAS
		#script l2gen.
		
		echo; separator
		echo 'Processing' $L1A_FILE 'from Level-1A to Level-2 ...'
		separator; echo; echo
		
		echo; echo; separator
		echo 'l2gen parameter file used:' ${L2GEN_PARAMETER_FILE}
		echo
		cat $L2GEN_PARAMETER_FILE
		separator
		
		l2gen ifile=$L1A_FILE geofile=$GEO_FILE ofile=$L2_FILE \
		par=$ANC_FILE \
		par=$L2GEN_PARAMETER_FILE
		
		if [ $? -ne 0 ]; then
			SEADAS_SCRIPT_NAME='l2gen'
			SCRIPT_ERROR_ACTION='DEFAULT'
			script_error_action $L1A_FILE
		fi
		###########################################################
		###########################################################
		
		
		
		
		###########################################################
		###########################################################
		#Remove the ancillary file.
		
		echo; echo; separator
		echo 'Removing' ${ANC_FILE} '...'
		separator
		
		rm $ANC_FILE
		###########################################################
		###########################################################
		
	
	
	
	
	done
	###################################################################
	###################################################################
	
	


	###################################################################
	###################################################################
	echo; echo; separator
	echo 'SeaWiFS Level-1 to Level-2 processing finished!'
	separator
	###################################################################
	###################################################################

	
	
	
	###################################################################
	###################################################################
	#If L2GEN_PARAMETER_FILE is set to "l2gen_default_seawifs.par" 
	#remove it.
		
	if [ $L2GEN_PARAMETER_FILE = 'l2gen_default_seawifs.par' ]; then
	
		echo; echo; separator
		echo 'Removing ' $L2GEN_PARAMETER_FILE '...'
		separator
			
		rm $L2GEN_PARAMETER_FILE
		
	fi
	###################################################################
	###################################################################




fi
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#Define L2_FILE_AMNT, the number of Level-2 files that exist in the current 
#directory. If L2_FILE_AMNT is 0, and END_LEVEL is greater than 2, then 
#this indicates that no Level-2 files exist for Level-2 to Level-3 
#processing. In this case SeaBatch errors.

L2_FILE_AMNT=$(ls ${SENSOR}${YEAR}*.L2_[GL]AC* S${YEAR}*.L2_MLAC* 2>/dev/null | wc -l)

if [ $L2_FILE_AMNT -eq 0 ]; then
	if [ $END_LEVEL -eq 2 ]; then
		
		EXIT_STATUS=0
		
		echo; echo; separator
		echo 'Warning: No Level-2 files were generated!'
		separator
		
	else
		EXIT_STATUS=1
	
		echo; echo; separator
		echo 'Error: No Level-2 files were generated for Level-2 to Level-3 processing!'
		separator
	fi
else
	if [ $END_LEVEL -eq 2 ]; then
		
		EXIT_STATUS=0
	
		echo; echo; separator
		echo $L2_FILE_AMNT 'Level-2 file(s) generated.'
		separator
		
	else
		
		EXIT_STATUS=0
	
		echo; echo; separator 
		echo $L2_FILE_AMNT 'Level-2 file(s) generated for Level-2 to Level-3 processing.'
		separator
		
	fi
fi
###########################################################################
###########################################################################




###########################################################################
###########################################################################
SEABATCH_SCRIPT_EXIT_STATUS=0

exit_seabatch_script
###########################################################################
###########################################################################


#!/bin/bash




###########################################################################
###########################################################################
#This script processes MODIS (Aqua and Terra) Level-0 files to Level-1A. The
#Level-1A files are subsequently extracted to the geographic bounds 
#specified by the processing variables WEST, EAST, NORTH, and SOUTH.
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#Source the files ${SEABATCH}/sub/config/seabatch.cfg and
#${SEABATCH}/master_file.txt.

source ${SEABATCH}'/sub/config/seabatch.cfg'
source ${SEABATCH}'/master_file.txt'
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#Define SEABATCH_SCRIPT_NAME and SEABATCH_SCRIPT_VERSION, the name and
#version of the current script.

SEABATCH_SCRIPT_NAME=${SEABATCH}'/bin/level0tolevel1.sh'
SEABATCH_SCRIPT_VERSION='1.2'

run_seabatch_script
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#Display the processing variables used by level0tolevel1.sh.

echo; echo; separator
echo 'Processing variables used by' ${SEABATCH_SCRIPT_NAME}':'
echo ''
echo '- END_LEVEL:' ${END_LEVEL}
echo '- WEST:' ${WEST} 'E'
echo '- EAST:' ${EAST} 'E'
echo '- NORTH:' ${NORTH} 'N'
echo '- SOUTH:' ${SOUTH} 'N'
separator
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#Begin the MODIS Level-0 to Level-1A processing and file extraction.

echo; echo; separator
echo 'Begin MODIS Level-0 to Level-1A processing and file extraction ...'
separator

for L0_FILE in [AT]*.L0_LAC MOD00.[AP]*.PDS; do

	#Check that L0_FILE is a regular file. There are two situations
	#where it won't be: 1) If no files exist that match the pattern
	#"[AT]*.L0_LAC" or 2) If no files exist that match the pattern
	#"MOD00.[AP]*.PDS". If L0_FILE is not a regular file then the 
	#current itteration of the loop stops, and the next one begins.
	
	if [ ! -f $L0_FILE ]; then
		continue
	fi
	
	echo; echo; separator
	echo 'Current Level-0 file:' ${L0_FILE}
	separator
	
	#Process L0_FILE from Level-0 to Level-1A using the SeaDAS script 
	#modis_L0_to_L1A_GEO.csh.
	
	echo; echo; separator 
	echo 'Processing' $L0_FILE 'from Level-0 to Level-1A...'
	separator
	echo; echo
	
	modis_L0_to_L1A_GEO.csh $L0_FILE
	if [ $? -ne 0 ]; then
		SEADAS_SCRIPT_NAME='modis_L0_to_L1A_GEO.csh'
		SCRIPT_ERROR_ACTION='DEFAULT'
		script_error_action $L0_FILE
	fi
	
	#Define L1A_FILE, the name of the Level-1A file that was just 
	#constructed.
	
	L1A_FILE=[AT]*.L1A_LAC
	
	#Define BASE, the basename of L1A_FILE.
	
	BASE=$(echo $L1A_FILE | awk -F. '{ print $1 }')
	
	#Define GEO_FILE, L1A_FILE_SUB, and GEO_FILE_SUB, the names of the 
	#geolocation file that was just constructed, and the extracted 
	#Level-1A and geolocation files that will be constructed, 
	#respectively. They each consist of BASE with the proper suffix 
	#appended.
	
	GEO_FILE=${BASE}.GEO
	L1A_FILE_SUB=${BASE}.L1A_LAC_sub
	GEO_FILE_SUB=${BASE}.GEO_sub
	
	#Extract the region defined by the processing variables WEST, EAST, 
	#NORTH, and SOUTH from the Level-1A file produced above using the 
	#SeaDAS script modis_L1A_extract.csh. This is necessary due to the 
	#large size of a MODIS Level-1A 5-minute granule.
	
	echo; echo; separator
	echo 'Extracting region' $WEST 'E' $EAST 'E' $NORTH 'N' $SOUTH 'N from' $L1A_FILE'...'
	separator
	echo; echo
	
	modis_L1A_extract.csh $L1A_FILE $GEO_FILE $WEST $SOUTH $EAST $NORTH $L1A_FILE_SUB $GEO_FILE_SUB
	if [ $? -ne 0 ]; then
		SEADAS_SCRIPT_NAME='modis_L1A_extract.csh'
		SCRIPT_ERROR_ACTION='DEFAULT'
		script_error_action $L1A_FILE
	fi
			
done

echo; echo; separator
echo 'MODIS Level-0 to Level-1A processing and file extraction finished!'
separator
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#If any complete Level-1A files exist remove them, as they are big and can 
#be re-generated if needed. In addition, remove the geolocation files (both 
#complete and extracted). This is for filenaming puposes. If processing will 
#continue from Level-1 to Level-2, the proper GEO files will be generated.

echo; echo; separator
echo 'Removing complete Level-1A files, and all (completed and extracted) geolocation files...'
separator

rm -f [AT]*.L1A_LAC *GEO*
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#Define L1A_FILE_SUB_AMNT, the number of extracted Level-1A files (those 
#files that match the pattern "[AT]*.L1A_LAC_sub") that exist in the current 
#directory. If L1A_FILE_SUB_AMNT is 0, and END_LEVEL is greater than 1,
#then this indicates that no extracted Level-1A files exist for Level-1 to
#Level-2 processing. In this case SeaBatch errors.

L1A_FILE_SUB_AMNT=$(ls [AT]*.L1A_LAC_sub 2>/dev/null | wc -l)

if [ $L1A_FILE_SUB_AMNT -eq 0 ]; then
	if [ $END_LEVEL -eq 1 ]; then
		
		EXIT_STATUS=0
		
		echo; echo; separator
		echo 'Warning: No extracted Level-1A files were generated!'
		separator
		
	else
	
		EXIT_STATUS=1
	
		echo; echo; separator
		echo 'Error: No extracted Level-1A files were generated for Level-1 to Level-2 processing!'
		separator
		
	fi
else
	if [ $END_LEVEL -eq 1 ]; then
	
		EXIT_STATUS=0
	
		echo; echo; separator
		echo $L1A_FILE_SUB_AMNT 'extracted Level-1A file(s) generated.'
		separator
		
	else
	
		EXIT_STATUS=0
	
		echo; echo; separator 
		echo $L1A_FILE_SUB_AMNT 'extracted Level-1A file(s) generated for Level-1 to Level-2 processing.'
		separator
		
	fi
fi
###########################################################################
###########################################################################




###########################################################################
###########################################################################
exit_seabatch_script
###########################################################################
###########################################################################

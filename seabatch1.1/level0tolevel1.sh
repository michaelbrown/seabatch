#!/bin/bash


#This script processes MODIS (Aqua and Terra) Level-0 files to Level-1A. 
#The Level-1A files are then sub-scened to the geographic bounds specified 
#by WEST, EAST, NORTH, and SOUTH.


echo; echo; echo '***** START MODIS LEVEL-0 TO LEVEL-1 PROCESSING *****'


###########################################################################
###########################################################################
#Define variables read in from master_script.sh.
WEST=${1}
EAST=${2}
NORTH=${3}
SOUTH=${4}

#Display variables.
echo; echo; echo 'Variables used:'
echo '- WEST:' $WEST 'E'
echo '- EAST:' $EAST 'E'
echo '- NORTH:' $NORTH 'N'
echo '- SOUTH:' $SOUTH 'N'
###########################################################################
###########################################################################


###########################################################################
###########################################################################
#Process the MODIS Level-0 files to Level-1A using the SeaDAS script 
#modis_L0_to_L1A_GEO.csh.

for L0_FILE in [AT]*.L0_LAC MOD00.[AP]*.PDS; do

	#Check that L0_FILE is a regular file. There are two situations
	#where it won't be: 1) If no files exist that match the pattern
	#"[AT]*.L0_LAC" or 2) If no files exist that match the pattern
	#"MOD00.[AP]*.PDS". If L0_FILE is not a regular file then the 
	#current itteration of the loop stops, and the next one begins.
	if [ ! -f $L0_FILE ]; then
		continue
	fi
	
	echo; echo; echo '***** CURRENT LEVEL-0 FILE:' $L0_FILE '*****'; echo
	modis_L0_to_L1A_GEO.csh $L0_FILE
	
	if [ $? -ne 0 ]; then
		echo; echo; echo '***** ERROR: MODIS Level-0 to Level-1 processing stopped on' $L0_FILE '*****'
		exit 1
	fi
			
done
###########################################################################
###########################################################################


###########################################################################
###########################################################################
#Extract the region defined by WEST, EAST, NORTH, and SOUTH from the 
#Level-1A MODIS files produced above using the SeaDAS script 
#modis_L1A_extract.csh. This is necessary due to the large size of a MODIS 
#Level-1A 5-minute granule. 

for L1A_FILE in [AT]*.L1A_LAC; do
	
	#Define the filenames of the input GEO file, and the extracted
	#Level-1A and GEO files. The filenames all consist of the base of 
	#the input Level-1A filename, followed by the appropriate suffix.
	BASE=$(echo $L1A_FILE | awk -F. '{ print $1 }')
	GEO_FILE=${BASE}.GEO
	L1A_FILE_SUB=${BASE}.L1A_LAC_sub
	GEO_FILE_SUB=${BASE}.GEO_sub
	
	echo; echo '***** EXTRACTING REGION' $WEST 'E' $EAST 'E' $NORTH 'N' $SOUTH 'N FROM' $L1A_FILE '*****'; echo; echo
	modis_L1A_extract.csh $L1A_FILE $GEO_FILE $WEST $SOUTH $EAST $NORTH $L1A_FILE_SUB $GEO_FILE_SUB
	
	if [ $? -ne 0 ]; then
		echo; echo; echo '***** ERROR: Level-1 file extraction stopped on' $L1A_FILE '*****'
		exit 1
	fi
		
done
###########################################################################
###########################################################################
	
	
#Remove the complete Level-1A files, which are big and can be generated 
#again if needed. In addition, remove the GEO files (both complete and
#extracted). This is for filenaming puposes. If processing will continue 
#from Level-1 to Level-2, the proper GEO files will be generated.
rm *L1A_LAC *GEO*


echo; echo '***** MODIS LEVEL-0 TO LEVEL-1 PROCESSING COMPLETE *****'


exit 0

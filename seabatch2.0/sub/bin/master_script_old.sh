#!/bin/bash


#You only need to pay attention to the first half of this script, which is
#where you specify your processing parameters.


###########################################################################
###########################################################################
#Specify processing parameters here.

#ALL processing:
OUT_DIR='default'

START_LEVEL=2
END_LEVEL=4

WEST=-66
EAST=-64
NORTH=49
SOUTH=47


#LEVEL-1 to LEVEL-2:
L2GEN_PRDCT_ARRAY=(chlor_a nLw_645)
MODIS_L2GEN_RES=1000


#LEVEL-2 to LEVEL-3: 
L2BIN_RES=1
TMPRL_AVG_ARRAY=(8D MO)


#LEVEL-3 to LEVEL-4:
OUT_PRDCT_ARRAY=(chlor_a)
OUT_FTYPE_ARRAY=(flat kmz png)


#If OUT_FTYPE_ARRAY includes png:
CT_SETTING='default'
CT_SUBDIR_ARRAY=(S)
CT_NUM_ARRAY=(2)
###########################################################################
###########################################################################


#NOTE: You only need to pay attention to the ABOVE code, which is where you
#specify your processing parameters.







###########################################################################
###########################################################################
SEABATCH_VERSION='1.2'
###########################################################################
###########################################################################




###########################################################################
###########################################################################
echo 'SeaBatch v' ${SEABATCH_VERSION}
echo 'Developed by Michael Brown and Jon Grant, Dalhousie University'
echo; echo
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#Check that initial_check.sh exists:
if [ -e ${SEABATCH_DIRECTORY}/bin/initial_check.sh ]; then
	echo '- '${SEABATCH_DIRECTORY}'/bin/initial_check.sh exists'
			
	#If initial_check.sh exists check that it is executable:
	if [ -x ${SEABATCH_DIRECTORY}/bin/initial_check.sh ]; then
		echo '- '${SEABATCH_DIRECTORY}'/bin/initial_check.sh is executable'
	else
		echo; echo; echo 'ERROR: '${SEABATCH_DIRECTORY}'/bin/initial_check.sh is not executable'
		exit 1
	fi
else
	echo; echo; echo 'ERROR: '${SEABATCH_DIRECTORY}'/bin/initial_check.sh does not exist'
	exit 1 
fi
	
#Call initial_check.sh to check the user-specified processing parameters.
${SEABATCH_DIRECTORY}/bin/initial_check.sh $OUT_DIR $START_LEVEL \
$END_LEVEL $WEST $EAST $NORTH $SOUTH ${#L2GEN_PRDCT_ARRAY[@]} \
$MODIS_L2GEN_RES ${#TMPRL_AVG_ARRAY[@]} $L2BIN_RES ${#OUT_PRDCT_ARRAY[@]} \ 
${#OUT_FTYPE_ARRAY[@]} $CT_SETTING ${#CT_SUBDIR_ARRAY[@]} \
${#CT_NUM_ARRAY[@]} $CT_DIR ${L2GEN_PRDCT_ARRAY[@]} ${TMPRL_AVG_ARRAY[@]} \
${OUT_PRDCT_ARRAY[@]} ${OUT_FTYPE_ARRAY[@]} ${CT_SUBDIR_ARRAY[@]} \
${CT_NUM_ARRAY[@]} $SEABATCH_VERSION

if [ $? -ne 0 ]; then
	exit 1
fi
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#Call level0tolevel1.sh to process MODIS Level-0 files to Level-1A.
if [ $START_LEVEL -eq 0 -a $END_LEVEL -ge 1 ]; then

	${SEABATCH_DIRECTORY}/bin/level0tolevel1.sh $END_LEVEL $WEST $EAST \
	$NORTH $SOUTH
	
	if [ $? -ne 0 ]; then
		echo; echo; echo 'Exiting SeaBatch... Exit status: 1.'
		exit 1	
	fi
	 
fi
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#Call level1tolevel2.sh to process MODIS or SeaWiFS Level-1A files to 
#Level-2.
if [ $START_LEVEL -le 1 -a $END_LEVEL -ge 2 ]; then

	${SEABATCH_DIRECTORY}/bin/level1tolevel2.sh $END_LEVEL \
	${#L2GEN_PRDCT_ARRAY[@]} $MODIS_L2GEN_RES ${L2GEN_PRDCT_ARRAY[@]}
	
	if [ $? -ne 0 ]; then
		echo; echo; echo 'Exiting SeaBatch... Exit status: 1.'
		exit 1	
	fi
	
fi
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#Call level2tolevel3.sh to process MODIS or SeaWiFS Level-2 files to 
#Level-3.
if [ $START_LEVEL -le 2 -a $END_LEVEL -ge 3 ]; then

	${SEABATCH_DIRECTORY}/bin/level2tolevel3.sh $END_LEVEL $L2BIN_RES \
	${#TMPRL_AVG_ARRAY[@]} ${TMPRL_AVG_ARRAY[@]}
	
	if [ $? -ne 0 ]; then
		echo; echo; echo 'Exiting SeaBatch... Exit status: 1.'
		exit 1
	fi
	
fi
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#Process MODIS or SeaWiFS Level-3 files to Level-4.
if [ $START_LEVEL -le 3 -a $END_LEVEL -eq 4 ]; then
	
	#Construct the file batchfile_variables.txt which contains the 
	#geographic bounds of your region of interest, the output products 
	#and file types, and the color table information. This file will be 
	#read by the script level3tolevel4_batchfile. 
	
	echo $WEST > batchfile_variables.txt
	echo $EAST >> batchfile_variables.txt
	echo $NORTH >> batchfile_variables.txt
	echo $SOUTH >> batchfile_variables.txt
	
	echo ${#OUT_PRDCT_ARRAY[@]} >> batchfile_variables.txt
	for OUT_PRDCT in ${OUT_PRDCT_ARRAY[@]}; do
		echo $OUT_PRDCT >> batchfile_variables.txt
	done
	
	echo ${#OUT_FTYPE_ARRAY[@]} >> batchfile_variables.txt
	for OUT_FTYPE in ${OUT_FTYPE_ARRAY[@]}; do
		echo $OUT_FTYPE >> batchfile_variables.txt
	done
	
	CT_DIR=$SEADAS'/config/color_luts'
	echo $CT_DIR >> batchfile_variables.txt
	
	echo $CT_SETTING >> batchfile_variables.txt
	
	echo ${#CT_SUBDIR_ARRAY[@]} >> batchfile_variables.txt
	for CT_SUBDIR in ${CT_SUBDIR_ARRAY[@]}; do
		echo $CT_SUBDIR >> batchfile_variables.txt
	done
	
	echo ${#CT_NUM_ARRAY[@]} >> batchfile_variables.txt
	for CT_NUM in ${CT_NUM_ARRAY[@]}; do
		echo $CT_NUM >> batchfile_variables.txt
	done
	
	#Determine whether to use an IDL license or runtime SeaDAS.
	if [ -d $SEADAS/idl_rt ]; then
		BATCH_CMD='seadas -em -b '${SEABATCH_DIRECTORY}'/bin/level3tolevel4_batchfile'
	else
		BATCH_CMD='seadas -b '${SEABATCH_DIRECTORY}'/bin/level3tolevel4_batchfile'
	fi
	
	echo; echo; echo '***** START LEVEL-3 TO LEVEL-4 PROCESSING *****'; echo; echo
	
	#Call level3tolevel4_batchfile to process MODIS or SeaWiFS Level-3 
	#files to Level-4.
	$BATCH_CMD
	
	rm batchfile_variables.txt
	
fi
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#If OUT_DIR does not equal "default" then call cleanup.sh to clean up the 
#current directory by moving all files into the proper sub-directories of 
#OUT_DIR.
if [ $OUT_DIR != default ]; then

	${SEABATCH_DIRECTORY}/bin/cleanup.sh $OUT_DIR $START_LEVEL $END_LEVEL \
	$L2BIN_RES ${#TMPRL_AVG_ARRAY[@]} ${#OUT_PRDCT_ARRAY[@]} \
	${#OUT_FTYPE_ARRAY[@]} ${TMPRL_AVG_ARRAY[@]} \
	${OUT_PRDCT_ARRAY[@]} ${OUT_FTYPE_ARRAY[@]}
	
	if [ $? -ne 0 ]; then
		exit 1
	fi
	
fi
###########################################################################
###########################################################################


echo; echo; echo '***** PROCESSING FINISHED!! *****'

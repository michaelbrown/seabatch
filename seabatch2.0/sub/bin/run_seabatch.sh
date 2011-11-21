#!/bin/bash




###########################################################################
###########################################################################
#This script calls various processing scripts. The scripts which are 
#called, and their order, depends on the user-specified processing 
#variables contained in the SeaBatch parameter file. 
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

SEABATCH_SCRIPT_NAME=${SEABATCH}'/sub/bin/run_seabatch.sh'
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

check_seabatch_parameter_file

source $SEABATCH_PARAMETER_FILE
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#Call initial_check.sh to check the user-specified processing parameters.

${SEABATCH_BIN_DIRECTORY}'/initial_check.sh' $SEABATCH_LOG_DIRECTORY $SEABATCH_PARAMETER_FILE
	
if [ $? -ne 0 ]; then

	SEABATCH_SCRIPT_EXIT_STATUS=1
	exit_seabatch_script

fi
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#If PROCESS is ...

if [ $PROCESS = 'YES' ]; then




	###########################################################################
	###########################################################################
	#Call level1tolevel2.sh to process MODIS or SeaWiFS Level-1A files to 
	#Level-2.

	if [ $START_LEVEL -le 1 -a $END_LEVEL -ge 2 ]; then

		${SEABATCH}'/sub/bin/level1tolevel2.sh' $SEABATCH_LOG_DIRECTORY $SEABATCH_PARAMETER_FILE
	
		if [ $? -ne 0 ]; then
			EXIT_STATUS=1
			exit_seabatch
		fi
	
	fi
	###########################################################################
	###########################################################################




	###########################################################################
	###########################################################################
	#Call level2tolevel3.sh to process MODIS or SeaWiFS Level-2 files to 
	#Level-3.

	if [ $START_LEVEL -le 2 -a $END_LEVEL -ge 3 ]; then

		${SEABATCH_BIN_DIRECTORY}'/level2tolevel3_spatialbin.sh' $SEABATCH_LOG_DIRECTORY $SEABATCH_PARAMETER_FILE
	
		if [ $? -ne 0 ]; then

			SEABATCH_SCRIPT_EXIT_STATUS=1
			exit_seabatch_script

		fi
	
		${SEABATCH_BIN_DIRECTORY}'/level2tolevel3_temporalbin.sh' $SEABATCH_LOG_DIRECTORY $SEABATCH_PARAMETER_FILE
	
		if [ $? -ne 0 ]; then

			SEABATCH_SCRIPT_EXIT_STATUS=1
			exit_seabatch_script

		fi
	
	fi
	###########################################################################
	###########################################################################




fi
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#Process MODIS or SeaWiFS Level-3 files to Level-4.

if [ $LOAD_OUTPUT = 'YES' ]; then

	${SEABATCH_BIN_DIRECTORY}'/load_output_setup.sh' $SEABATCH_LOG_DIRECTORY $SEABATCH_PARAMETER_FILE

	if [ $? -ne 0 ]; then
		EXIT_STATUS=1
		exit_seabatch
	fi

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

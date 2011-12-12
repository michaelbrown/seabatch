#!/bin/bash




###########################################################################
###########################################################################
#This script performs an initial check of the user-specified processing 
#parameters.
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
#Display the processing variables used by initial_check.sh.

echo; echo; seabatch_separator
seabatch_statement "Processing variables used by ${SEABATCH_SCRIPT_NAME}:"
echo
seabatch_statement "- SENSOR: ${SENSOR}"
seabatch_statement "- PROCESS: ${PROCESS}"
seabatch_statement "- LOAD_OUTPUT: ${LOAD_OUTPUT}"
seabatch_statement "- YEAR: ${YEAR}"
seabatch_statement "- WEST: ${WEST}"
seabatch_statement "- EAST: ${EAST}"
seabatch_statement "- NORTH: ${NORTH}"
seabatch_statement "- SOUTH: ${SOUTH}"
seabatch_statement "- START_LEVEL: ${START_LEVEL}"
seabatch_statement "- END_LEVEL: ${END_LEVEL}"
echo "- L2_PRODUCTS: ${L2_PRODUCTS[@]}"
seabatch_statement "- L2_RESOLUTION: ${L2_RESOLUTION}"
seabatch_statement "- L2GEN_PARAMETER_FILE: ${L2GEN_PARAMETER_FILE}"
echo "- SPATIAL_BINS: ${SPATIAL_BINS[@]}"
echo "- TEMPORAL_BINS: ${TEMPORAL_BINS[@]}"
seabatch_statement "- MODIS_SST: ${MODIS_SST}"
seabatch_statement "- L2BIN_PARAMETER_FILE: ${L2BIN_PARAMETER_FILE}"
seabatch_statement "- L3BIN_PARAMETER_FILE: ${L3BIN_PARAMETER_FILE}"
seabatch_statement "- LOADED_FILE_TYPE: ${LOADED_FILE_TYPE}"
echo "- OUTPUT_PRODUCTS: ${OUTPUT_PRODUCTS[@]}"
echo "- OUTPUT_FILE_TYPES: ${OUTPUT_FILE_TYPES[@]}"
echo "- OUTPUT_STATISTICS: ${OUTPUT_STATISTICS[@]}"
seabatch_separator
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#Check processing parameters used for ALL processing.

echo; echo; seabatch_separator
seabatch_statement "Begin checking processing parameters used for ALL processing ..."

echo; seabatch_statement "Checking SENSOR ..."
case $SENSOR in

	'AQUA' | 'AVHRR' | 'TERRA' | 'SEAWIFS')
		seabatch_statement "${SENSOR} is a valid entry."
	;;
	
	*)
		echo; seabatch_statement "ERROR: ${SENSOR} is NOT a valid entry."
		echo; seabatch_statement "It is necessary to fix the SeaBatch parameter file ${SEABATCH_PARAMETER_FILE}."
		echo; seabatch_statement "SeaBatch will be exited."
		
		seabatch_separator
		
		SEABATCH_SCRIPT_EXIT_STATUS=1
		exit_seabatch_script
		
	;;
	
esac

echo; seabatch_statement "Checking PROCESS ..."
case $PROCESS in

	'YES' | 'NO')
		seabatch_statement "${PROCESS} is a valid entry."
	;;
	
	*)
	
		echo; seabatch_statement "ERROR: ${PROCESS} is NOT a valid entry."
		echo; seabatch_statement "It is necessary to fix the SeaBatch parameter file ${SEABATCH_PARAMETER_FILE}."
		echo; seabatch_statement "SeaBatch will be exited."
		
		seabatch_separator
		
		SEABATCH_SCRIPT_EXIT_STATUS=1
		exit_seabatch_script
		
	;;
	
esac

echo; seabatch_statement "Checking LOAD_OUTPUT ..."
case $LOAD_OUTPUT in

	'YES' | 'NO')
		seabatch_statement "${LOAD_OUTPUT} is a valid entry."
	;;
	
	*)
	
		echo; seabatch_statement "ERROR: ${LOAD_OUTPUT} is NOT a valid entry."
		echo; seabatch_statement "It is necessary to fix the SeaBatch parameter file ${SEABATCH_PARAMETER_FILE}."
		echo; seabatch_statement "SeaBatch will be exited."
		
		seabatch_separator
		
		SEABATCH_SCRIPT_EXIT_STATUS=1
		exit_seabatch_script 
	;;
	
esac

echo; seabatch_statement "Checking processing parameters used for ALL processing finished!"
seabatch_separator
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#Check processing parameters used if PROCESS is set to 'YES'.

if [ $PROCESS = 'YES' ]; then

	echo; echo; seabatch_separator
	seabatch_statement "Begin checking processing parameters used if PROCESS is set to 'YES' ..."

	echo; seabatch_statement "Checking START_LEVEL ..."
	case $START_LEVEL in

		'1' | '2')
			seabatch_statement "${START_LEVEL} is a valid entry."
		;;
	
		*)
			echo; seabatch_statement "ERROR: ${START_LEVEL} is NOT a valid entry."
			echo; seabatch_statement "It is necessary to fix the SeaBatch parameter file ${SEABATCH_PARAMETER_FILE}."
			echo; seabatch_statement "SeaBatch will be exited."
		
			seabatch_separator
		
			SEABATCH_SCRIPT_EXIT_STATUS=1
			exit_seabatch_script
		
		;;
	
	esac
	
	echo; seabatch_statement "Checking END_LEVEL ..."
	case $END_LEVEL in

		'2' | '3')
			seabatch_statement "${END_LEVEL} is a valid entry."
		;;
	
		*)
			echo; seabatch_statement "ERROR: ${END_LEVEL} is NOT a valid entry."
			echo; seabatch_statement "It is necessary to fix the SeaBatch parameter file ${SEABATCH_PARAMETER_FILE}."
			echo; seabatch_statement "SeaBatch will be exited."
		
			seabatch_separator
		
			SEABATCH_SCRIPT_EXIT_STATUS=1
			exit_seabatch_script
		
		;;
	
	esac
	
	echo; seabatch_statement "Checking if START_LEVEL and END_LEVEL are set to the same value ..."
	
	if [ $START_LEVEL -eq $END_LEVEL ]; then
	
		echo; seabatch_statement "ERROR: START_LEVEL and END_LEVEL are set to the same value (${START_LEVEL})."
		echo; seabatch_statement "It is necessary to fix the SeaBatch parameter file ${SEABATCH_PARAMETER_FILE}."
		echo; seabatch_statement "SeaBatch will be exited."
		
		seabatch_separator
		
		SEABATCH_SCRIPT_EXIT_STATUS=1
		exit_seabatch_script
		
	else
		echo; seabatch_statement "They are not set to the same value ..."
	fi
	
	echo; seabatch_statement "Checking processing parameters used if PROCESS is set to 'YES' finished!"
	seabatch_separator
	
fi
###########################################################################
###########################################################################

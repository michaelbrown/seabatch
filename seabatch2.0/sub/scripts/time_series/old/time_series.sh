#!/bin/bash




###########################################################################
###########################################################################
#This script FILL IN LATER

FLAT_FILE_XDIM='786'
FLAT_FILE_YDIM='383'

FLAT_FILE_WEST='-134'
FLAT_FILE_EAST='-132'
FLAT_FILE_NORTH='70'
FLAT_FILE_SOUTH='69'

TIME_SERIES_RESOLUTION='SECOND'
TIME_SERIES_START_DATE='2002195123015'
TIME_SERIES_END_DATE='2002204501264'

REGIONS_TEXT_FILE=${SEABATCH}'/sub/scripts/time_series/regions.txt'
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#Source the files ${SEABATCH}/sub/config/seabatch.cfg and REGIONS_TEXT_FILE.

source ${SEABATCH}'/sub/config/seabatch.cfg'
source $REGIONS_TEXT_FILE
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#Define SEABATCH_SCRIPT_NAME and SEABATCH_SCRIPT_VERSION, the name and
#version of the current script.

SEABATCH_SCRIPT_NAME=${SEABATCH}'/bin/sub/time_series/time_series.sh'
SEABATCH_SCRIPT_VERSION='1.2'

run_seabatch_script
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#Display the processing variables used by level1tolevel2.sh.

seabatch_statement ""
seabatch_statement ""
separator
seabatch_statement "Processing variables used by ${SEABATCH_SCRIPT_NAME}:"
seabatch_statement ""
seabatch_statement "- FLAT_FILE_XDIM: ${FLAT_FILE_XDIM}"
seabatch_statement "- FLAT_FILE_YDIM: ${FLAT_FILE_YDIM}"
seabatch_statement "- FLAT_FILE_WEST: ${FLAT_FILE_WEST}"
seabatch_statement "- FLAT_FILE_EAST: ${FLAT_FILE_EAST}"
seabatch_statement "- FLAT_FILE_NORTH: ${FLAT_FILE_NORTH}"
seabatch_statement "- FLAT_FILE_SOUTH: ${FLAT_FILE_SOUTH}"
seabatch_statement "- FLAT_FILE_EAST: ${FLAT_FILE_EAST}"
seabatch_statement "- TIME_SERIES_RESOLUTION: ${TIME_SERIES_RESOLUTION}"
seabatch_statement "- TIME_SERIES_START_DATE: ${TIME_SERIES_START_DATE}"
seabatch_statement "- TIME_SERIES_END_DATE: ${TIME_SERIES_END_DATE}"
seabatch_statement "- REGIONS_TEXT_FILE: ${REGIONS_TEXT_FILE}"
seabatch_statement "- REGION_AMOUNT: ${REGION_AMOUNT}"
#for (( A=1; A<=$REGION_AMOUNT; A++ )); do
#
#	CURRENT_REGION_LATITUDES=($(eval echo \${'REGION_'${A}'_LATITUDES'[@]}))
#	CURRENT_REGION_LONGITUDES=($(eval echo \${'REGION_'${A}'_LONGITUDES'[@]}))
#	
#	seabatch_statement "- REGION_${A}_LATITUDES: ${test_array[@]}"
#	seabatch_statement "- REGION_${A}_LONGITUDES: ${CURRENT_REGION_LONGITUDES[@]}"
#
#done
separator
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#

SEADAS_COMMAND_FILE='time_series_variables.txt'

seabatch_statement ""
seabatch_statement ""
separator
seabatch_statement "Constructing ${SEADAS_COMMAND_FILE} ..."
separator

echo 'FLAT_FILE_XDIM, FLAT_FILE_YDIM:' > $SEADAS_COMMAND_FILE
echo $FLAT_FILE_XDIM >> $SEADAS_COMMAND_FILE
echo $FLAT_FILE_YDIM >> $SEADAS_COMMAND_FILE

echo '' >> $SEADAS_COMMAND_FILE
echo 'FLAT_FILE_WEST, FLAT_FILE_EAST, FLAT_FILE_NORTH, FLAT_FILE_SOUTH:' >> $SEADAS_COMMAND_FILE
echo $FLAT_FILE_WEST >> $SEADAS_COMMAND_FILE
echo $FLAT_FILE_EAST >> $SEADAS_COMMAND_FILE
echo $FLAT_FILE_NORTH >> $SEADAS_COMMAND_FILE
echo $FLAT_FILE_SOUTH >> $SEADAS_COMMAND_FILE

echo '' >> $SEADAS_COMMAND_FILE
echo 'TIME_SERIES_RESOLUTION, TIME_SERIES_START_DATE, TIME_SERIES_END_DATE:' >> $SEADAS_COMMAND_FILE
echo $TIME_SERIES_RESOLUTION >> $SEADAS_COMMAND_FILE
echo $TIME_SERIES_START_DATE >> $SEADAS_COMMAND_FILE
echo $TIME_SERIES_END_DATE >> $SEADAS_COMMAND_FILE

for (( B=1; B<=$REGION_AMOUNT; B++ )); do

	echo '' >> $SEADAS_COMMAND_FILE

	echo 'REGION_'${B}':' >> $SEADAS_COMMAND_FILE

	REGION_LATITUDES=($(eval echo \${'REGION_'${B}'_LATITUDES'[@]}))
	REGION_LONGITUDES=($(eval echo \${'REGION_'${B}'_LONGITUDES'[@]}))

	REGION_LATLON_AMOUNT=${#REGION_LATITUDES[@]}
	echo '' >> $SEADAS_COMMAND_FILE
	echo 'REGION_LATLON_AMOUNT:' >> $SEADAS_COMMAND_FILE
	echo $REGION_LATLON_AMOUNT >> $SEADAS_COMMAND_FILE

	echo '' >> $SEADAS_COMMAND_FILE
	echo 'LATITUDES:' >> $SEADAS_COMMAND_FILE
	for LATITUDE in ${REGION_LATITUDES[@]}; do
		echo $LATITUDE >> $SEADAS_COMMAND_FILE
	done

	echo '' >> $SEADAS_COMMAND_FILE
	echo 'LONGITUDES:' >> $SEADAS_COMMAND_FILE
	for LONGITUDE in ${REGION_LONGITUDES[@]}; do
		echo $LONGITUDE >> $SEADAS_COMMAND_FILE
	done

done
###########################################################################
###########################################################################




###########################################################################
###########################################################################
seadas -em -b $SEABATCH'/sub/scripts/time_series/time_series.sbf'
###########################################################################
###########################################################################


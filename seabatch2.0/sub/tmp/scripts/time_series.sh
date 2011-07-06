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

echo; echo; separator
echo 'Processing variables used by' ${SEABATCH_SCRIPT_NAME}':'
echo ''
echo '- FLAT_FILE_XDIM:' ${FLAT_FILE_XDIM}
echo '- FLAT_FILE_YDIM:' ${FLAT_FILE_YDIM}
echo '- FLAT_FILE_WEST:' ${FLAT_FILE_WEST}
echo '- FLAT_FILE_EAST:' ${FLAT_FILE_EAST}
echo '- FLAT_FILE_NORTH:' ${FLAT_FILE_NORTH}
echo '- FLAT_FILE_SOUTH:' ${FLAT_FILE_SOUTH}
echo '- FLAT_FILE_EAST:' ${FLAT_FILE_EAST}
echo '- TIME_SERIES_RESOLUTION:' ${TIME_SERIES_RESOLUTION}
echo '- TIME_SERIES_START_DATE:' ${TIME_SERIES_START_DATE}
echo '- TIME_SERIES_END_DATE:' ${TIME_SERIES_END_DATE}
echo '- REGIONS_TEXT_FILE:' ${REGIONS_TEXT_FILE}
echo '- REGION_AMOUNT:' ${REGION_AMOUNT}
for (( A=1; A<=$REGION_AMOUNT; A++ )); do

	eval CURRENT_REGION_LATITUDES=\${'REGION_'${A}'_LATITUDES'[@]}
	eval CURRENT_REGION_LONGITUDES=\${'REGION_'${A}'_LONGITUDES'[@]}

	echo '- REGION_'${A}'_LATITUDES:' ${CURRENT_REGION_LATITUDES[@]}
	echo '- REGION_'${A}'_LONGITUDES:' ${CURRENT_REGION_LONGITUDES[@]}

done
separator
###########################################################################
###########################################################################


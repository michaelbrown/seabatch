#!/bin/bash




###########################################################################
###########################################################################
#This script ...
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

SEABATCH_SCRIPT_NAME=${SEABATCH_BIN_DIRECTORY}'/load_output_setup.sh'
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
#Display the processing variables used by load_ouput_setup.sh.

echo; echo; seabatch_separator
seabatch_statement "Processing variables used by ${SEABATCH_SCRIPT_NAME}:"
echo
seabatch_statement "- SENSOR: ${SENSOR}"
seabatch_statement "- WEST: ${WEST}"
seabatch_statement "- EAST: ${EAST}"
seabatch_statement "- NORTH: ${NORTH}"
seabatch_statement "- SOUTH: ${SOUTH}"
seabatch_statement "- LOADED_FILE_TYPE: ${LOADED_FILE_TYPE}"
echo "- OUTPUT_PRODUCTS: ${OUTPUT_PRODUCTS}"
echo "- OUTPUT_FILE_TYPES: ${OUTPUT_FILE_TYPES[@]}"
seabatch_separator
###########################################################################
###########################################################################




###########################################################################
###########################################################################
case $COASTLINE_COLOR in

	'RED')
		COASTLINE_COLOR=1	
	;;

	'GREEN')
		COASTLINE_COLOR=2	
	;;
	
	'BLUE')
		COASTLINE_COLOR=3	
	;;

	'YELLOW')
		COASTLINE_COLOR=4	
	;;

	'PURPLE')
		COASTLINE_COLOR=5	
	;;

	'BLACK')
		COASTLINE_COLOR=6	
	;;
	
	'WHITE')
		COASTLINE_COLOR=7	
	;;
	
	*)
		echo; seabatch_statement "Warning! Valid coastline color NOT identified. The default will be applied ..."
		COASTLINE_COLOR=7
	;;

esac

case $COASTLINE_RESOLUTION in

	'LOW')
		COASTLINE_RESOLUTION=0
	;;

	'HIGH')
		COASTLINE_RESOLUTION=1		
	;;
	
	*)
		echo; seabatch_statement "Warning! Valid coastline resolution NOT identified. The default will be applied ..."
		COASTLINE_RESOLUTION=1
	;;

esac

case $COLOR_BAR_ORIENTATION in

	'HORIZONTAL')
		COLOR_BAR_ORIENTATION='H'
	;;

	'VERTICAL')
		COLOR_BAR_ORIENTATION='V'		
	;;
	
	*)
		echo; seabatch_statement "Warning! Valid color bar orientation NOT identified. The default will be applied ..."
		COLOR_BAR_ORIENTATION='V'
	;;

esac
###########################################################################
###########################################################################




###########################################################################
###########################################################################
if [ $LOADED_FILE_TYPE = 'SEABATCH_L3_BIN' -o $LOADED_FILE_TYPE = 'OBPG_L3_BIN' ]; then

	if [ $LOADED_FILE_TYPE = 'SEABATCH_L3_BIN' ]; then

		FILE_TYPE='SeaBatch Level-3 Binned files'
		FILE_TYPE_PATTERNS=$SEABATCH_L3_BIN_FILE_PATTERNS
		FILE_TYPE_TEXT_FILE=${SEABATCH_LOG_DIRECTORY}'/file_list/seabatch_l3_bin.txt'

	fi
	
	if [ $LOADED_FILE_TYPE = 'OBPG_L3_BIN' ]; then

		FILE_TYPE='OBPG Level-3 Binned files'
		FILE_TYPE_PATTERNS=$OBPG_L3_BIN_FILE_PATTERNS
		FILE_TYPE_TEXT_FILE=${SEABATCH_LOG_DIRECTORY}'/file_list/obpg_l3_bin.txt'

	fi
	
	file_type_list
	
	if [ $FILE_TYPE_FILE_AMOUNT -eq 0 ]; then
		exit
	fi

	while read LOADED_FILE; do

		for OUTPUT_PRODUCT in ${OUTPUT_PRODUCTS[@]}; do

			for OUTPUT_STATISTIC in ${OUTPUT_STATISTICS[@]}; do

				for OUTPUT_FILE_TYPE in ${OUTPUT_FILE_TYPES[@]}; do

					LOAD_OUTPUT_PARAMETER_FILE='load_output_parameter_file.txt'

					echo $LOADED_FILE_TYPE > $LOAD_OUTPUT_PARAMETER_FILE
					echo $SENSOR >> $LOAD_OUTPUT_PARAMETER_FILE
					echo $LOADED_FILE >> $LOAD_OUTPUT_PARAMETER_FILE
					echo $OUTPUT_PRODUCT >> $LOAD_OUTPUT_PARAMETER_FILE
					echo $OUTPUT_STATISTIC >> $LOAD_OUTPUT_PARAMETER_FILE

					run_seadas_batch_file ${SEABATCH_BIN_DIRECTORY}'/basename.sbf'
		
					echo $FORCED_LOAD_X_DIMENSION >> $LOAD_OUTPUT_PARAMETER_FILE
					echo $FORCED_LOAD_Y_DIMENSION >> $LOAD_OUTPUT_PARAMETER_FILE
					echo $MINIMUM_LOAD_DIMENSION >> $LOAD_OUTPUT_PARAMETER_FILE
					echo $WEST >> $LOAD_OUTPUT_PARAMETER_FILE
					echo $EAST >> $LOAD_OUTPUT_PARAMETER_FILE
					echo $NORTH >> $LOAD_OUTPUT_PARAMETER_FILE
					echo $SOUTH >> $LOAD_OUTPUT_PARAMETER_FILE

					run_seadas_batch_file ${SEABATCH_BIN_DIRECTORY}'/load_dimensions.sbf'

					echo '-' >> $LOAD_OUTPUT_PARAMETER_FILE

					echo $OUTPUT_FILE_TYPE >> $LOAD_OUTPUT_PARAMETER_FILE

					case $OUTPUT_FILE_TYPE in

						'KMZ' | 'PNG')
							DISPLAY_SETTING='YES'
						;;

						*)
							DISPLAY_SETTING='NO'
						;;

					esac

					echo $DISPLAY_SETTING >> $LOAD_OUTPUT_PARAMETER_FILE

					obtain_display_settings $LOAD_OUTPUT_PARAMETER_FILE $OUTPUT_PRODUCT

					echo $COASTLINE >> $LOAD_OUTPUT_PARAMETER_FILE
					echo $COASTLINE_COLOR >> $LOAD_OUTPUT_PARAMETER_FILE
					echo $COASTLINE_RESOLUTION >> $LOAD_OUTPUT_PARAMETER_FILE

					echo $COLOR_BAR >> $LOAD_OUTPUT_PARAMETER_FILE
					echo $COLOR_BAR_ORIENTATION >> $LOAD_OUTPUT_PARAMETER_FILE

					run_seadas_batch_file ${SEABATCH_BIN_DIRECTORY}'/load_output.sbf'

					rm $LOAD_OUTPUT_PARAMETER_FILE

				done

			done
		
		done	

	done <$FILE_TYPE_TEXT_FILE

fi
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#

if [ $LOADED_FILE_TYPE = 'OBPG_L3_SMI_OC' -o  $LOADED_FILE_TYPE = 'OBPG_L3_SMI_MODIS_SST' ]; then

	if [ $LOADED_FILE_TYPE = 'OBPG_L3_SMI_OC' ]; then

		FILE_TYPE='OBPG Level-3 SMI Ocean Color files'
		FILE_TYPE_PATTERNS=$OBPG_L3_SMI_OC_FILE_PATTERNS
		FILE_TYPE_TEXT_FILE=${SEABATCH_LOG_DIRECTORY}'/file_list/obpg_l3_smi_oc.txt'
			
		file_type_list

	fi

	if [ $LOADED_FILE_TYPE = 'OBPG_L3_SMI_MODIS_SST' ]; then

		FILE_TYPE='OBPG Level-3 SMI MODIS SST files'
		FILE_TYPE_PATTERNS=$OBPG_L3_SMI_MODIS_SST_FILE_PATTERNS
		FILE_TYPE_TEXT_FILE=${SEABATCH_LOG_DIRECTORY}'/file_list/obpg_l3_smi_modis_sst.txt'
			
		file_type_list

	fi

	while read LOADED_FILE; do

		for OUTPUT_FILE_TYPE in ${OUTPUT_FILE_TYPES[@]}; do

			LOAD_OUTPUT_PARAMETER_FILE='load_output_parameter_file.txt'

			echo $LOADED_FILE_TYPE > $LOAD_OUTPUT_PARAMETER_FILE
			echo $LOADED_FILE >> $LOAD_OUTPUT_PARAMETER_FILE

			echo '-' >> $LOAD_OUTPUT_PARAMETER_FILE
			echo '-' >> $LOAD_OUTPUT_PARAMETER_FILE

			run_seadas_batch_file ${SEABATCH_BIN_DIRECTORY}'/basename.sbf'
		
			echo '-' >> $LOAD_OUTPUT_PARAMETER_FILE
			echo '-' >> $LOAD_OUTPUT_PARAMETER_FILE
			echo '-' >> $LOAD_OUTPUT_PARAMETER_FILE
			echo $WEST >> $LOAD_OUTPUT_PARAMETER_FILE
			echo $EAST >> $LOAD_OUTPUT_PARAMETER_FILE
			echo $NORTH >> $LOAD_OUTPUT_PARAMETER_FILE
			echo $SOUTH >> $LOAD_OUTPUT_PARAMETER_FILE
			echo '-' >> $LOAD_OUTPUT_PARAMETER_FILE
			echo '-' >> $LOAD_OUTPUT_PARAMETER_FILE
			
			if [ $LOADED_FILE_TYPE = 'OBPG_L3_SMI_MODIS_SST' ]; then
				echo $MODIS_SST_QUALITY >> $LOAD_OUTPUT_PARAMETER_FILE
			else
				echo '-' >> $LOAD_OUTPUT_PARAMETER_FILE
			fi

			echo $OUTPUT_FILE_TYPE >> $LOAD_OUTPUT_PARAMETER_FILE

			case $OUTPUT_FILE_TYPE in

				'PNG')
					DISPLAY_SETTING='YES'
				;;

				*)
					DISPLAY_SETTING='NO'
				;;

			esac

			echo $DISPLAY_SETTING >> $LOAD_OUTPUT_PARAMETER_FILE

			echo '-' >> $LOAD_OUTPUT_PARAMETER_FILE

			echo $COASTLINE >> $LOAD_OUTPUT_PARAMETER_FILE
			echo $COASTLINE_COLOR >> $LOAD_OUTPUT_PARAMETER_FILE
			echo $COASTLINE_RESOLUTION >> $LOAD_OUTPUT_PARAMETER_FILE

			echo $COLOR_BAR >> $LOAD_OUTPUT_PARAMETER_FILE
			echo $COLOR_BAR_ORIENTATION >> $LOAD_OUTPUT_PARAMETER_FILE

			run_seadas_batch_file ${SEABATCH_BIN_DIRECTORY}'/load_output.sbf'

		done

	done <$FILE_TYPE_TEXT_FILE
		
fi
###########################################################################
###########################################################################


###########################################################################
###########################################################################
#

if [ $LOADED_FILE_TYPE = 'NODC_PFV5_SST' ]; then

	FILE_TYPE='NODC Pathfinder V5.0/5.1 "All-pixel" SST files'
	FILE_TYPE_PATTERNS=$NODC_PFV5_SST_FILE_PATTERNS
	FILE_TYPE_TEXT_FILE=${SEABATCH_LOG_DIRECTORY}'/file_list/nodc_pfv5.txt'
			
	file_type_list

	while read LOADED_FILE; do

		for OUTPUT_FILE_TYPE in ${OUTPUT_FILE_TYPES[@]}; do

			LOAD_OUTPUT_PARAMETER_FILE='load_output_parameter_file.txt'

			echo $SENSOR > $LOAD_OUTPUT_PARAMETER_FILE
			echo $LOADED_FILE_TYPE >> $LOAD_OUTPUT_PARAMETER_FILE
			echo $LOADED_FILE >> $LOAD_OUTPUT_PARAMETER_FILE
			echo '-' >> $LOAD_OUTPUT_PARAMETER_FILE #OUTPUT_PRODUCT
			echo '-' >> $LOAD_OUTPUT_PARAMETER_FILE #OUTPUT_STATISTIC

			run_seadas_batch_file ${SEABATCH_BIN_DIRECTORY}'/nodc_pfv5_qual_file_id.sbf'
			
			run_seadas_batch_file ${SEABATCH_BIN_DIRECTORY}'/basename.sbf'
			
			echo $FORCED_LOAD_X_DIMENSION >> $LOAD_OUTPUT_PARAMETER_FILE
			echo $FORCED_LOAD_Y_DIMENSION >> $LOAD_OUTPUT_PARAMETER_FILE
			echo $MINIMUM_LOAD_DIMENSION >> $LOAD_OUTPUT_PARAMETER_FILE
			echo $WEST >> $LOAD_OUTPUT_PARAMETER_FILE
			echo $EAST >> $LOAD_OUTPUT_PARAMETER_FILE
			echo $NORTH >> $LOAD_OUTPUT_PARAMETER_FILE
			echo $SOUTH >> $LOAD_OUTPUT_PARAMETER_FILE
			
			run_seadas_batch_file ${SEABATCH_BIN_DIRECTORY}'/load_dimensions.sbf'
			
			echo $AVHRR_SST_QUALITY >> $LOAD_OUTPUT_PARAMETER_FILE
			
			echo '-' >> $LOAD_OUTPUT_PARAMETER_FILE #MODIS_SST_QUALITY
			
			echo $OUTPUT_FILE_TYPE >> $LOAD_OUTPUT_PARAMETER_FILE

			case $OUTPUT_FILE_TYPE in

				'KMZ' | 'PNG')
					DISPLAY_SETTING='YES'
					
					echo $DISPLAY_SETTING >> $LOAD_OUTPUT_PARAMETER_FILE

					obtain_display_settings $LOAD_OUTPUT_PARAMETER_FILE 'sst'

					echo $COASTLINE >> $LOAD_OUTPUT_PARAMETER_FILE
					echo $COASTLINE_COLOR >> $LOAD_OUTPUT_PARAMETER_FILE
					echo $COASTLINE_RESOLUTION >> $LOAD_OUTPUT_PARAMETER_FILE

					echo $COLOR_BAR >> $LOAD_OUTPUT_PARAMETER_FILE
					echo $COLOR_BAR_ORIENTATION >> $LOAD_OUTPUT_PARAMETER_FILE
				;;

				*)
					DISPLAY_SETTING='NO'
					echo $DISPLAY_SETTING >> $LOAD_OUTPUT_PARAMETER_FILE
					
					echo '-' >> $LOAD_OUTPUT_PARAMETER_FILE #DISPLAY_LUT
					echo '-' >> $LOAD_OUTPUT_PARAMETER_FILE #DISPLAY_MIN
					echo '-' >> $LOAD_OUTPUT_PARAMETER_FILE #DISPLAY_MAX
					echo '-' >> $LOAD_OUTPUT_PARAMETER_FILE #DISPLAY_TYPE
					echo '-' >> $LOAD_OUTPUT_PARAMETER_FILE #COASTLINE
					echo '-' >> $LOAD_OUTPUT_PARAMETER_FILE #COASTLINE_COLOR
					echo '-' >> $LOAD_OUTPUT_PARAMETER_FILE #COASTLINE_RESOLUTION
					echo '-' >> $LOAD_OUTPUT_PARAMETER_FILE #COLOR_BAR
					echo '-' >> $LOAD_OUTPUT_PARAMETER_FILE #COLOR_BAR_ORIENTATION
				;;

			esac
			
			run_seadas_batch_file ${SEABATCH_BIN_DIRECTORY}'/load_output.sbf'
			
			rm $LOAD_OUTPUT_PARAMETER_FILE
			
		done

	done <$FILE_TYPE_TEXT_FILE
		
fi
###########################################################################
###########################################################################

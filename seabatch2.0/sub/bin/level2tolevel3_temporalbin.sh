#!/bin/bash




###########################################################################
###########################################################################
#This script temporally bins MODIS (Aqua and Terra) and SeaWiFS Level-2 
#files.
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

SEABATCH_SCRIPT_NAME=${SEABATCH}'/bin/level2tolevel3_temporalbin.sh'
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
#Display the processing variables used by level2tolevel3_temporalbin.sh.

echo; echo; seabatch_separator
seabatch_statement "Processing variables used by ${SEABATCH_SCRIPT_NAME}:"
echo
seabatch_statement "- SENSOR: ${SENSOR}"
seabatch_statement "- YEAR: ${YEAR}"
echo "- SPATIAL_BINS: ${SPATIAL_BINS[@]}"
echo "- TEMPORAL_BINS: ${TEMPORAL_BINS[@]}"
seabatch_statement "- MODIS_SST: ${MODIS_SST}"
seabatch_statement "- L3BIN_PARAMETER_FILE: ${L3BIN_PARAMETER_FILE}"
seabatch_separator
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#Define SENSOR_ABBREVIATION.

if [ $SENSOR = 'AQUA' ]; then

	SENSOR_ABBREVIATION='A'
	
fi

if [ $SENSOR = 'TERRA' ]; then

	SENSOR_ABBREVIATION='T'
	
fi
	
if [ $SENSOR = 'SEAWIFS' ]; then

	SENSOR_ABBREVIATION='S'
	
fi
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#If YEAR is not evenly divisble by four then it is a normal year, i.e. not
#a leap year. Define YEAR_CLASS (NORMAL or LEAP), the type of year. Define 
#YEAR_YEARDAY_AMOUNT, the number of year days in YEAR (365 for normal years 
#and 366 for leap years)

if [ `expr $YEAR % 4` -ne 0 ]; then
	YEAR_CLASS='NORMAL'
	YEAR_YEARDAY_AMOUNT=365
else 
	YEAR_CLASS='LEAP'
	YEAR_YEARDAY_AMOUNT=366
fi
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#Define YEARDAY_ARRAY, the array whose elements range from year days 
#001-366 (NOTE: January 1st is YD 001, and December 31st is YD 365, or YD 
#366 for leap years). The elements of YEARDAY_ARRAY will be referenced to 
#select the proper files when creating the temporal averages.

for (( a=0; a<=365; a++ )); do
	if [ $a -lt 9 ]; then
		YEARDAY_ARRAY[$a]='00'$(( $a + 1 ))
	elif [ $a -ge 9 ] && [ $a -lt 99 ]; then
		YEARDAY_ARRAY[$a]='0'$(( $a + 1 ))
	elif [ $a -ge 99 ]; then
		YEARDAY_ARRAY[$a]=$(( $a + 1 ))
	fi	
done
###########################################################################
###########################################################################




###########################################################################
###########################################################################
if [ $SENSOR = 'AQUA' -o $SENSOR = 'TERRA' ]; then
	
	
	
	
	###################################################################
	###################################################################
	if [ $MODIS_SST = 'NO' ]; then
		echo; echo; seabatch_separator
		seabatch_statement "Begin Level-2 to Level-3 temporal binning of spatially binned MODIS Level-2 Ocean Color files ..."
		seabatch_separator
	fi
	###################################################################
	###################################################################
			
			
			
			
	###################################################################
	###################################################################
	if [ $MODIS_SST = 'SST' -o $MODIS_SST = 'NSST' ]; then

		if [ $MODIS_SST = 'SST' ]; then

			echo; echo; seabatch_separator
			seabatch_statement "Begin Level-2 to Level-3 temporal binning of spatially binned MODIS Level-2 daytime SST (11 micron) files ..."
			seabatch_separator

		fi

		if [ $MODIS_SST = 'NSST' ]; then

			echo; echo; seabatch_separator
			seabatch_statement "Begin Level-2 to Level-3 temporal binning of spatially binned MODIS Level-2 nighttime SST (11 micron) files ..."
			seabatch_separator

		fi
				
	fi
	###################################################################
	###################################################################
			
			
			
			
	###################################################################
	###################################################################
	if [ $MODIS_SST = 'SST4' ]; then
		echo; echo; seabatch_separator
		seabatch_statement "Begin Level-2 to Level-3 temporal binning of spatially binned MODIS Level-2 SST4 (4 micron) files ..."
		seabatch_separator
	fi
	###################################################################
	###################################################################
			
			
			
			
fi
###########################################################################
###########################################################################




###########################################################################
###########################################################################
if [ $SENSOR = 'SEAWIFS' ]; then
	echo; echo; seabatch_separator
	seabatch_statement "Begin Level-2 to Level-3 temporal binning of spatially binned SeaWiFS Level-2 Ocean Color files ..."
	seabatch_separator
fi
###########################################################################
###########################################################################




###########################################################################
###########################################################################
for SPATIAL_BIN in ${SPATIAL_BINS[@]}; do
	
	
	
	
	###################################################################
	###################################################################
	for TEMPORAL_BIN in ${TEMPORAL_BINS[@]}; do
	
	
	
	
		###########################################################
		###########################################################
		if [ $SENSOR = 'AQUA' -o $SENSOR = 'TERRA' ]; then
	
	
	
	
			###################################################
			###################################################
			if [ $MODIS_SST = 'NO' ]; then
				echo; echo; seabatch_separator
				seabatch_statement "Begin Level-2 to Level-3 ${TEMPORAL_BIN} temporal binning of MODIS Level-2 Ocean Color files spatially binned to ${SPATIAL_BIN} km ..."
				seabatch_separator
			fi
			###################################################
			###################################################
			
			
			
			
			###################################################
			###################################################
			if [ $MODIS_SST = 'SST' -o $MODIS_SST = 'NSST' ]; then

				if [ $MODIS_SST = 'SST' ]; then

					echo; echo; seabatch_separator
					seabatch_statement "Begin Level-2 to Level-3 ${TEMPORAL_BIN} temporal binning of MODIS Level-2 daytime SST (11 micron) files spatially binned to ${SPATIAL_BIN} km ..."
					seabatch_separator

				fi

				if [ $MODIS_SST = 'NSST' ]; then

					echo; echo; seabatch_separator
					seabatch_statement "Begin Level-2 to Level-3 ${TEMPORAL_BIN} temporal binning of MODIS Level-2 nighttime SST (11 micron) files spatially binned to ${SPATIAL_BIN} km ..."
					seabatch_separator

				fi
				
			fi
			###################################################
			###################################################
			
			
			
			
			###################################################
			###################################################
			if [ $MODIS_SST = 'SST4' ]; then
				echo; echo; seabatch_separator
				seabatch_statement "Begin Level-2 to Level-3 ${TEMPORAL_BIN} temporal binning of MODIS Level-2 SST4 (4 micron) files spatially binned to ${SPATIAL_BIN} km ..."
				seabatch_separator
			fi
			###################################################
			###################################################
			
			
			
			
		fi
		###########################################################
		###########################################################
		
		
		
		
		###########################################################
		###########################################################
		if [ $SENSOR = 'SEAWIFS' ]; then
			echo; echo; seabatch_separator
			seabatch_statement "Begin Level-2 to Level-3 ${TEMPORAL_BIN} temporal binning of SeaWiFS Level-2 Ocean Color files spatially binned to ${SPATIAL_BIN} km ..."
			seabatch_separator
		fi
		###########################################################
		###########################################################
		
		
		
		
		###########################################################
		###########################################################
		#Define YEAR_TEMPORAL_BIN_AMOUNT, the number of complete 
		#TEMPORAL_BINs within YEAR.
		
		case $TEMPORAL_BIN in
		
			'MONTH')

				YEAR_TEMPORAL_BIN_AMOUNT=12

			;;

			'NS')

				YEAR_TEMPORAL_BIN_AMOUNT=1

			;;

			*)

				TEMPORAL_BIN_SIZE=$(echo $TEMPORAL_BIN | tr -d 'D')
				let YEAR_TEMPORAL_BIN_AMOUNT=$YEAR_YEARDAY_AMOUNT/$TEMPORAL_BIN_SIZE
			
		esac
		
		echo; echo; seabatch_separator
		seabatch_statement "Number of ${TEMPORAL_BIN} bins to be constructed for year ${YEAR}: ${YEAR_TEMPORAL_BIN_AMOUNT}"
		seabatch_separator
		###########################################################
		###########################################################
	
	
	
	
		###########################################################
		###########################################################
		#Define YEARDAY_INDEX, and initially set it to zero. 
		#YEARDAY_INDEX will range from 0 to 365, and is used to 
		#index YEARDAY_ARRAY.
	
		YEARDAY_INDEX=0
		###########################################################
		###########################################################
		
		
		
		
		###########################################################
		###########################################################
		for (( B=0; B<$YEAR_TEMPORAL_BIN_AMOUNT; B++ )); do
		



			###################################################
			###################################################
			echo; echo; seabatch_separator
			seabatch_statement "Current ${TEMPORAL_BIN} temporal bin: #$(( $B+1 ))"
			seabatch_separator
			###################################################
			###################################################
		



			###################################################
			###################################################
			case $TEMPORAL_BIN in
		
				'MONTH')
				
					if [ $YEAR_CLASS = 'NORMAL' ]; then
						MONTH_YEARDAY_AMOUNT_ARRAY=(31 28 31 30 31 30 31 31 30 31 30 31)
					fi
					
					if [ $YEAR_CLASS = 'LEAP' ]; then
						MONTH_YEARDAY_AMOUNT_ARRAY=(31 29 31 30 31 30 31 31 30 31 30 31)
					fi
					
					TEMPORAL_BIN_YEARDAY_AMOUNT=${MONTH_YEARDAY_AMOUNT_ARRAY[$B]}
					
				;;
				
				'NS')
					TEMPORAL_BIN_YEARDAY_AMOUNT=$YEAR_YEARDAY_AMOUNT
				;;
				
				*)
					TEMPORAL_BIN_YEARDAY_AMOUNT=$TEMPORAL_BIN_SIZE
			
			esac
			###################################################
			###################################################
			
			
			
			
			###################################################
			###################################################
			
			###################################################
			###################################################
			
			
			
			
			###################################################
			###################################################
			for (( C=0; C<$TEMPORAL_BIN_YEARDAY_AMOUNT; C++ )); do
			
			
			
			
				###########################################
				###########################################
				YEARDAY=${YEARDAY_ARRAY[$YEARDAY_INDEX]}
				###########################################
				###########################################
				
				
				
				
				###########################################
				###########################################
				if [ $C -eq 0 ]; then
				
					TEMPORAL_BIN_L2BIN_FILE_AMOUNT=0
					YEARDAY_L2BIN_FILE_AMOUNT=0
					
					TEMPORAL_BIN_START_YEARDAY=$YEARDAY
					TEMPORAL_BIN_END_YEARDAY=$YEARDAY
					
					TEMPORAL_BIN_PERIOD=${YEAR}${TEMPORAL_BIN_START_YEARDAY}${YEAR}${TEMPORAL_BIN_END_YEARDAY}
				
				else
				
					if [ $TEMPORAL_BIN != 'NS' ]; then
					
						TEMPORAL_BIN_END_YEARDAY=$YEARDAY
						TEMPORAL_BIN_PERIOD=${YEAR}${TEMPORAL_BIN_START_YEARDAY}${YEAR}${TEMPORAL_BIN_END_YEARDAY}
						
					fi
					
				fi		
				###########################################
				###########################################
				
				
				
				
				###########################################
				###########################################
				if [ $SENSOR = 'AQUA' -o $SENSOR = 'TERRA' ]; then

					if [ $MODIS_SST = 'NO' ]; then
						
						if [ $C -eq 0 ]; then
							L2BIN_TEXT_FILE=${SEABATCH_LOG_DIRECTORY}'/file_list/modis_l2bin_oc_'${SPATIAL_BIN}'km_'${TEMPORAL_BIN}'_'${TEMPORAL_BIN_PERIOD}'.txt'
						else
							
							if [ $TEMPORAL_BIN != 'NS' ]; then

								OLD_L2BIN_TEXT_FILE=$L2BIN_TEXT_FILE
								L2BIN_TEXT_FILE=${SEABATCH_LOG_DIRECTORY}'/file_list/modis_l2bin_oc_'${SPATIAL_BIN}'km_'${TEMPORAL_BIN}'_'${TEMPORAL_BIN_PERIOD}'.txt'
								
								if [ $TEMPORAL_BIN_L2BIN_FILE_AMOUNT -ne 0 ]; then
									mv $OLD_L2BIN_TEXT_FILE $L2BIN_TEXT_FILE
								fi
								
							fi

						fi

						FILE_TYPE="MODIS Level-2 Ocean Color files, spatially binned to ${SPATIAL_BIN} km, corresponding to YD ${YEARDAY}"
						FILE_TYPE_PATTERNS=[AT]${YEAR}${YEARDAY}*'.L2b_OC_'${SPATIAL_BIN}'km'
						FILE_TYPE_TEXT_FILE=$L2BIN_TEXT_FILE
			
						file_type_list
															
					fi
					
					if [ $MODIS_SST = 'SST' -o $MODIS_SST = 'NSST' ]; then

						if [ $MODIS_SST = 'SST' ]; then
						
							if [ $C -eq 0 ]; then
								L2BIN_TEXT_FILE=${SEABATCH_LOG_DIRECTORY}'/file_list/modis_l2bin_sst_'${SPATIAL_BIN}'km_'${TEMPORAL_BIN}'_'${TEMPORAL_BIN_PERIOD}'.txt'
							else
							
								if [ $TEMPORAL_BIN != 'NS' ]; then

									OLD_L2BIN_TEXT_FILE=$L2BIN_TEXT_FILE
									L2BIN_TEXT_FILE=${SEABATCH_LOG_DIRECTORY}'/file_list/modis_l2bin_sst_'${SPATIAL_BIN}'km_'${TEMPORAL_BIN}'_'${TEMPORAL_BIN_PERIOD}'.txt'
									
									if [ $TEMPORAL_BIN_L2BIN_FILE_AMOUNT -ne 0 ]; then
										mv $OLD_L2BIN_TEXT_FILE $L2BIN_TEXT_FILE
									fi
								
								fi

							fi

							FILE_TYPE="MODIS Level-2 daytime SST (11 micron) files, spatially binned to ${SPATIAL_BIN} km, corresponding to YD ${YEARDAY}"
							FILE_TYPE_PATTERNS=[AT]${YEAR}${YEARDAY}*'.L2b_SST_'${SPATIAL_BIN}'km'
							FILE_TYPE_TEXT_FILE=$L2BIN_TEXT_FILE
			
							file_type_list
															
						fi
						
						if [ $MODIS_SST = 'NSST' ]; then
						
							if [ $C -eq 0 ]; then
								L2BIN_TEXT_FILE=${SEABATCH_LOG_DIRECTORY}'/file_list/modis_l2bin_nsst_'${SPATIAL_BIN}'km_'${TEMPORAL_BIN}'_'${TEMPORAL_BIN_PERIOD}'.txt'
							else
							
								if [ $TEMPORAL_BIN != 'NS' ]; then

									OLD_L2BIN_TEXT_FILE=$L2BIN_TEXT_FILE
									L2BIN_TEXT_FILE=${SEABATCH_LOG_DIRECTORY}'/file_list/modis_l2bin_nsst_'${SPATIAL_BIN}'km_'${TEMPORAL_BIN}'_'${TEMPORAL_BIN_PERIOD}'.txt'
									
									if [ $TEMPORAL_BIN_L2BIN_FILE_AMOUNT -ne 0 ]; then
										mv $OLD_L2BIN_TEXT_FILE $L2BIN_TEXT_FILE
									fi
								
								fi

							fi

							FILE_TYPE="MODIS Level-2 nighttime SST (11 micron) files, spatially binned to ${SPATIAL_BIN} km, corresponding to YD ${YEARDAY}"
							FILE_TYPE_PATTERNS=[AT]${YEAR}${YEARDAY}*'.L2b_NSST_'${SPATIAL_BIN}'km'
							FILE_TYPE_TEXT_FILE=$L2BIN_TEXT_FILE
			
							file_type_list
															
						fi

					fi
					
					if [ $MODIS_SST = 'SST4' ]; then
						
						if [ $C -eq 0 ]; then
							L2BIN_TEXT_FILE=${SEABATCH_LOG_DIRECTORY}'/file_list/modis_l2bin_sst4_'${SPATIAL_BIN}'km_'${TEMPORAL_BIN}'_'${TEMPORAL_BIN_PERIOD}'.txt'
						else
							
							if [ $TEMPORAL_BIN != 'NS' ]; then

								OLD_L2BIN_TEXT_FILE=$L2BIN_TEXT_FILE
								L2BIN_TEXT_FILE=${SEABATCH_LOG_DIRECTORY}'/file_list/modis_l2bin_sst4_'${SPATIAL_BIN}'km_'${TEMPORAL_BIN}'_'${TEMPORAL_BIN_PERIOD}'.txt'
								
								if [ $TEMPORAL_BIN_L2BIN_FILE_AMOUNT -ne 0 ]; then
									mv $OLD_L2BIN_TEXT_FILE $L2BIN_TEXT_FILE
								fi
								
							fi

						fi

						FILE_TYPE="MODIS Level-2 SST4 (4 micron) files, spatially binned to ${SPATIAL_BIN} km, corresponding to YD ${YEARDAY}"
						FILE_TYPE_PATTERNS=[AT]${YEAR}${YEARDAY}*'.L2b_SST4_'${SPATIAL_BIN}'km'
						FILE_TYPE_TEXT_FILE=$L2BIN_TEXT_FILE
			
						file_type_list
															
					fi
					
				fi
				
				if [ $SENSOR = 'SEAWIFS' ]; then
				
					if [ $C -eq 0 ]; then
						L2BIN_TEXT_FILE=${SEABATCH_LOG_DIRECTORY}'/file_list/seawifs_l2bin_oc'${SPATIAL_BIN}'km_'${TEMPORAL_BIN}'_'${TEMPORAL_BIN_PERIOD}'.txt'
					else
							
						if [ $TEMPORAL_BIN != 'NS' ]; then

							OLD_L2BIN_TEXT_FILE=$L2BIN_TEXT_FILE
							L2BIN_TEXT_FILE=${SEABATCH_LOG_DIRECTORY}'/file_list/seawifs_l2bin_oc'${SPATIAL_BIN}'km_'${TEMPORAL_BIN}'_'${TEMPORAL_BIN_PERIOD}'.txt'
							
							if [ $TEMPORAL_BIN_L2BIN_FILE_AMOUNT -ne 0 ]; then
								mv $OLD_L2BIN_TEXT_FILE $L2BIN_TEXT_FILE
							fi
								
						fi

					fi

					FILE_TYPE="SeaWiFS Level-2 Ocean Color files, spatially binned to ${SPATIAL_BIN} km, corresponding to YD ${YEARDAY}"
					FILE_TYPE_PATTERNS='S'${YEAR}${YEARDAY}*'.L2b_OC_'${SPATIAL_BIN}'km'
					FILE_TYPE_TEXT_FILE=$L2BIN_TEXT_FILE
			
					file_type_list
				
				fi
				###########################################
				###########################################
				
				
				
				
				###########################################
				###########################################
				YEARDAY_L2BIN_FILE_AMOUNT=$FILE_TYPE_FILE_AMOUNT
				###########################################
				###########################################
				
				
				
				
				###########################################
				###########################################
				if [ $TEMPORAL_BIN = 'NS' ]; then
				
					if [ $TEMPORAL_BIN_L2BIN_FILE_AMOUNT -eq 0 ]; then
						
							TEMPORAL_BIN_START_YEARDAY=$YEARDAY
							TEMPORAL_BIN_END_YEARDAY=$YEARDAY
						
					else
					
						if [ $YEARDAY_L2BIN_FILE_AMOUNT -ne 0 ]; then
							TEMPORAL_BIN_END_YEARDAY=$YEARDAY
						fi
						
					fi
					
					TEMPORAL_BIN_PERIOD=${YEAR}${TEMPORAL_BIN_START_YEARDAY}${YEAR}${TEMPORAL_BIN_END_YEARDAY}
					
					OLD_L2BIN_TEXT_FILE=$L2BIN_TEXT_FILE
					
					if [ $SENSOR = 'AQUA' -o $SENSOR = 'TERRA' ]; then
					
						if [ $MODIS_SST = 'NO' ]; then
							L2BIN_TEXT_FILE=${SEABATCH_LOG_DIRECTORY}'/file_list/modis_l2bin_oc_'${SPATIAL_BIN}'km_'${TEMPORAL_BIN}'_'${TEMPORAL_BIN_PERIOD}'.txt'
						fi
						
						if [ $MODIS_SST = 'SST' -o $MODIS_SST = 'NSST' ]; then

							if [ $MODIS_SST = 'SST' ]; then
								L2BIN_TEXT_FILE=${SEABATCH_LOG_DIRECTORY}'/file_list/modis_l2bin_sst_'${SPATIAL_BIN}'km_'${TEMPORAL_BIN}'_'${TEMPORAL_BIN_PERIOD}'.txt'
							fi

							if [ $MODIS_SST = 'NSST' ]; then
								L2BIN_TEXT_FILE=${SEABATCH_LOG_DIRECTORY}'/file_list/modis_l2bin_nsst_'${SPATIAL_BIN}'km_'${TEMPORAL_BIN}'_'${TEMPORAL_BIN_PERIOD}'.txt'
							fi
							
						fi
						
						if [ $MODIS_SST = 'SST4' ]; then
							L2BIN_TEXT_FILE=${SEABATCH_LOG_DIRECTORY}'/file_list/modis_l2bin_sst4_'${SPATIAL_BIN}'km_'${TEMPORAL_BIN}'_'${TEMPORAL_BIN_PERIOD}'.txt'
						fi
						
					fi
					
					if [ $SENSOR = 'SEAWIFS' ]; then
						L2BIN_TEXT_FILE=${SEABATCH_LOG_DIRECTORY}'/file_list/seawifs_l2bin_oc'${SPATIAL_BIN}'km_'${TEMPORAL_BIN}'_'${TEMPORAL_BIN_PERIOD}'.txt'
					fi
					
					if [ $YEARDAY_L2BIN_FILE_AMOUNT -ne 0 ]; then
						mv $OLD_L2BIN_TEXT_FILE $L2BIN_TEXT_FILE
					fi
					
				fi
				###########################################
				###########################################
				
				
				
				
				###########################################
				###########################################
				TEMPORAL_BIN_L2BIN_FILE_AMOUNT=$(( $TEMPORAL_BIN_L2BIN_FILE_AMOUNT + $YEARDAY_L2BIN_FILE_AMOUNT ))
				###########################################
				###########################################
				
				
				
				
				###########################################
				###########################################
				YEARDAY_INDEX=$(( $YEARDAY_INDEX + 1 ))
				###########################################
				###########################################
				
			
			
			
			done
			###################################################
			###################################################
			
			
			
			
			###################################################
			###################################################
			if [ $SENSOR = 'AQUA' -o $SENSOR = 'TERRA' ]; then
	
				if [ $MODIS_SST = 'NO' ]; then
				
					if [ $TEMPORAL_BIN_L2BIN_FILE_AMOUNT -eq 0 ]; then
					
						echo; echo; seabatch_separator
						seabatch_statement "No MODIS Level-2 Ocean Color files, spatially binned to ${SPATIAL_BIN} km, corresponding to the ${TEMPORAL_BIN} temporal bin YD ${TEMPORAL_BIN_START_YEARDAY} to YD ${TEMPORAL_BIN_END_YEARDAY}, exist!"
						seabatch_separator
						
						continue
					
					else
					
						echo; echo; seabatch_separator
						seabatch_statement "$TEMPORAL_BIN_L2BIN_FILE_AMOUNT MODIS Level-2 Ocean Color file(s), spatially binned to ${SPATIAL_BIN} km, corresponding to the ${TEMPORAL_BIN} temporal bin YD ${TEMPORAL_BIN_START_YEARDAY} to YD ${TEMPORAL_BIN_END_YEARDAY}, exist(s)!"
						echo
						cat $L2BIN_TEXT_FILE
						seabatch_separator
						
							
						
						
						###########################
						###########################
						#Define MODIS_L3BIN_OC_FILE, 
						#the name of the file that 
						#will result from 
						#temporally binning the 
						#above files.
						
						if [ $TEMPORAL_BIN_START_YEARDAY = $TEMPORAL_BIN_END_YEARDAY ]; then
							MODIS_L3BIN_OC_FILE=${SENSOR_ABBREVIATION}${YEAR}${TEMPORAL_BIN_START_YEARDAY}'.L3b_OC_'${SPATIAL_BIN}'km_'${TEMPORAL_BIN}
						else
							MODIS_L3BIN_OC_FILE=${SENSOR_ABBREVIATION}${YEAR}${TEMPORAL_BIN_START_YEARDAY}${YEAR}${TEMPORAL_BIN_END_YEARDAY}'.L3b_OC_'${SPATIAL_BIN}'km_'${TEMPORAL_BIN}
						fi
						###########################
						###########################
						
						
						
						
						###########################
						###########################
						#If L3BIN_PARAMETER_FILE is 
						#set to "DEFAULT" then set 
						#it to "l3bin_modis_oc_default.par".
	
						if [ $L3BIN_PARAMETER_FILE = 'DEFAULT' ]; then
							L3BIN_PARAMETER_FILE=${SEABATCH_PARAMETER_DIRECTORY}'/l3bin_modis_oc_default.par'
						fi
						###########################
						###########################
						
						
						
						
						###########################
						###########################
						#Temporally bin the above
						#files with the SeaDAS
						#script l3bin.
			
						echo; echo; seabatch_separator
						seabatch_statement "Temporally binning the above files (constructing ${MODIS_L3BIN_OC_FILE}) ..."
						seabatch_separator
			
						echo; echo; seabatch_separator
						seabatch_statement "l3bin parameter file used: ${L3BIN_PARAMETER_FILE}"
						echo
						cat $L3BIN_PARAMETER_FILE
						seabatch_separator; echo; echo
			
						l3bin in=$L2BIN_TEXT_FILE out=$MODIS_L3BIN_OC_FILE parfile=$L3BIN_PARAMETER_FILE
			
						if [ $? -ne 0 ]; then
						
							SEADAS_SCRIPT_NAME='l3bin'
							SCRIPT_ERROR_ACTION='DEFAULT'
							script_error_action $MODIS_L3BIN_OC_FILE
							
						fi
						###########################
						###########################

					
					
						
					fi
					
				fi
				
				if [ $MODIS_SST = 'SST' -o $MODIS_SST = 'NSST' ]; then

					if [ $MODIS_SST = 'SST' ]; then
				
						if [ $TEMPORAL_BIN_L2BIN_FILE_AMOUNT -eq 0 ]; then
					
							echo; echo; seabatch_separator
							seabatch_statement "No MODIS Level-2 daytime SST (11 micron) files, spatially binned to ${SPATIAL_BIN} km, corresponding to the ${TEMPORAL_BIN} temporal bin YD ${TEMPORAL_BIN_START_YEARDAY} to YD ${TEMPORAL_BIN_END_YEARDAY}, exist!"
							seabatch_separator
						
							continue
					
						else
					
							echo; echo; seabatch_separator
							seabatch_statement "$TEMPORAL_BIN_L2BIN_FILE_AMOUNT MODIS Level-2 daytime SST (11 micron) file(s), spatially binned to ${SPATIAL_BIN} km, corresponding to the ${TEMPORAL_BIN} temporal bin YD ${TEMPORAL_BIN_START_YEARDAY} to YD ${TEMPORAL_BIN_END_YEARDAY}, exist(s)!"
							echo
							cat $L2BIN_TEXT_FILE
							seabatch_separator
							
						
						
						
							###########################
							###########################
							#Define 
							#MODIS_L3BIN_SST_FILE, the 
							#name of the file that will 
							#result from temporally 
							#binning the above files.
						
							if [ $TEMPORAL_BIN_START_YEARDAY = $TEMPORAL_BIN_END_YEARDAY ]; then
								MODIS_L3BIN_SST_FILE=${SENSOR_ABBREVIATION}${YEAR}${TEMPORAL_BIN_START_YEARDAY}'.L3b_SST_'${SPATIAL_BIN}'km_'${TEMPORAL_BIN}
							else
								MODIS_L3BIN_SST_FILE=${SENSOR_ABBREVIATION}${YEAR}${TEMPORAL_BIN_START_YEARDAY}${YEAR}${TEMPORAL_BIN_END_YEARDAY}'.L3b_SST_'${SPATIAL_BIN}'km_'${TEMPORAL_BIN}
							fi
							###########################
							###########################




							###########################
							###########################
							#If L3BIN_PARAMETER_FILE is 
							#set to "DEFAULT" then set 
							#it to "l3bin_modis_sst_default.par".
	
							if [ $L3BIN_PARAMETER_FILE = 'DEFAULT' ]; then
								L3BIN_PARAMETER_FILE=${SEABATCH_PARAMETER_DIRECTORY}'/l3bin_modis_sst_default.par'
							fi
							###########################
							###########################
						
						
						
						
							###########################
							###########################
							#Temporally bin the above
							#files with the SeaDAS
							#script l3bin.
			
							echo; echo; seabatch_separator
							seabatch_statement "Temporally binning the above files (constructing ${MODIS_L3BIN_SST_FILE}) ..."
							seabatch_separator
			
							echo; echo; seabatch_separator
							seabatch_statement "l3bin parameter file used: ${L3BIN_PARAMETER_FILE}"
							echo
							cat $L3BIN_PARAMETER_FILE
							seabatch_separator; echo; echo
			
							l3bin in=$L2BIN_TEXT_FILE out=$MODIS_L3BIN_SST_FILE parfile=$L3BIN_PARAMETER_FILE
			
							if [ $? -ne 0 ]; then
						
								SEADAS_SCRIPT_NAME='l3bin'
								SCRIPT_ERROR_ACTION='DEFAULT'
								script_error_action $MODIS_L3BIN_SST_FILE
							
							fi
							###########################
							###########################

					
						
						
						fi
					
					fi
					
					if [ $MODIS_SST = 'NSST' ]; then
				
						if [ $TEMPORAL_BIN_L2BIN_FILE_AMOUNT -eq 0 ]; then
					
							echo; echo; seabatch_separator
							seabatch_statement "No MODIS Level-2 nighttime SST (11 micron) files, spatially binned to ${SPATIAL_BIN} km, corresponding to the ${TEMPORAL_BIN} temporal bin YD ${TEMPORAL_BIN_START_YEARDAY} to YD ${TEMPORAL_BIN_END_YEARDAY}, exist!"
							seabatch_separator
						
							continue
					
						else
					
							echo; echo; seabatch_separator
							seabatch_statement "$TEMPORAL_BIN_L2BIN_FILE_AMOUNT MODIS Level-2 nighttime SST (11 micron) file(s), spatially binned to ${SPATIAL_BIN} km, corresponding to the ${TEMPORAL_BIN} temporal bin YD ${TEMPORAL_BIN_START_YEARDAY} to YD ${TEMPORAL_BIN_END_YEARDAY}, exist(s)!"
							echo
							cat $L2BIN_TEXT_FILE
							seabatch_separator
							
						
						
						
							###########################
							###########################
							#Define 
							#MODIS_L3BIN_NSST_FILE, the 
							#name of the file that will 
							#result from temporally 
							#binning the above files.
						
							if [ $TEMPORAL_BIN_START_YEARDAY = $TEMPORAL_BIN_END_YEARDAY ]; then
								MODIS_L3BIN_NSST_FILE=${SENSOR_ABBREVIATION}${YEAR}${TEMPORAL_BIN_START_YEARDAY}'.L3b_NSST_'${SPATIAL_BIN}'km_'${TEMPORAL_BIN}
							else
								MODIS_L3BIN_NSST_FILE=${SENSOR_ABBREVIATION}${YEAR}${TEMPORAL_BIN_START_YEARDAY}${YEAR}${TEMPORAL_BIN_END_YEARDAY}'.L3b_NSST_'${SPATIAL_BIN}'km_'${TEMPORAL_BIN}
							fi
							###########################
							###########################




							###########################
							###########################
							#If L3BIN_PARAMETER_FILE is 
							#set to "DEFAULT" then set 
							#it to "l3bin_modis_nsst_default.par".
	
							if [ $L3BIN_PARAMETER_FILE = 'DEFAULT' ]; then
								L3BIN_PARAMETER_FILE=${SEABATCH_PARAMETER_DIRECTORY}'/l3bin_modis_nsst_default.par'
							fi
							###########################
							###########################
						
						
						
						
							###########################
							###########################
							#Temporally bin the above
							#files with the SeaDAS
							#script l3bin.
			
							echo; echo; seabatch_separator
							seabatch_statement "Temporally binning the above files (constructing ${MODIS_L3BIN_NSST_FILE}) ..."
							seabatch_separator
			
							echo; echo; seabatch_separator
							seabatch_statement "l3bin parameter file used: ${L3BIN_PARAMETER_FILE}"
							echo
							cat $L3BIN_PARAMETER_FILE
							seabatch_separator; echo; echo
			
							l3bin in=$L2BIN_TEXT_FILE out=$MODIS_L3BIN_NSST_FILE parfile=$L3BIN_PARAMETER_FILE
			
							if [ $? -ne 0 ]; then
						
								SEADAS_SCRIPT_NAME='l3bin'
								SCRIPT_ERROR_ACTION='DEFAULT'
								script_error_action $MODIS_L3BIN_NSST_FILE
							
							fi
							###########################
							###########################

					
						
						
						fi
					
					fi

				fi
				
				if [ $MODIS_SST = 'SST4' ]; then
				
					if [ $TEMPORAL_BIN_L2BIN_FILE_AMOUNT -eq 0 ]; then
					
						echo; echo; seabatch_separator
						seabatch_statement "No MODIS Level-2 SST4 (4 micron) files, spatially binned to ${SPATIAL_BIN} km, corresponding to the ${TEMPORAL_BIN} temporal bin YD to YD ${TEMPORAL_BIN_END_YEARDAY}, exist!"
						seabatch_separator
						
						continue
					
					else
					
						echo; echo; seabatch_separator
						seabatch_statement "$L2BIN_FILE_AMOUNT MODIS Level-2 SST4 (4 micron) file(s), spatially binned to ${SPATIAL_BIN} km, corresponding to the ${TEMPORAL_BIN} temporal bin YD ${TEMPORAL_BIN_START_YEARDAY} to YD ${TEMPORAL_BIN_END_YEARDAY}, exist(s)!"
						echo
						cat $L2BIN_TEXT_FILE
						seabatch_separator
							
						
						
						
						###########################
						###########################
						#Define 
						#MODIS_L3BIN_SST4_FILE, the 
						#name of the file that will 
						#result from temporally 
						#binning the above files.
						
						if [ $TEMPORAL_BIN_START_YEARDAY = $TEMPORAL_BIN_END_YEARDAY ]; then
							MODIS_L3BIN_SST4_FILE=${SENSOR_ABBREVIATION}${YEAR}${TEMPORAL_BIN_START_YEARDAY}'.L3b_SST4_'${SPATIAL_BIN}'km_'${TEMPORAL_BIN}
						else
							MODIS_L3BIN_SST4_FILE=${SENSOR_ABBREVIATION}${YEAR}${TEMPORAL_BIN_START_YEARDAY}${YEAR}${TEMPORAL_BIN_END_YEARDAY}'.L3b_SST4_'${SPATIAL_BIN}'km_'${TEMPORAL_BIN}
						fi
						###########################
						###########################




						###########################
						###########################
						#If L3BIN_PARAMETER_FILE is 
						#set to "DEFAULT" then set 
						#it to "l3bin_modis_sst4_default.par".
	
						if [ $L3BIN_PARAMETER_FILE = 'DEFAULT' ]; then
							L3BIN_PARAMETER_FILE=${SEABATCH_PARAMETER_DIRECTORY}'/l3bin_modis_sst4_default.par'
						fi
						###########################
						###########################
						
						
						
						
						###########################
						###########################
						#Temporally bin the above
						#files with the SeaDAS
						#script l3bin.
			
						echo; echo; seabatch_separator
						seabatch_statement "Temporally binning the above files (constructing ${MODIS_L3BIN_SST4_FILE}) ..."
						seabatch_separator
			
						echo; echo; seabatch_separator
						seabatch_statement "l3bin parameter file used: ${L3BIN_PARAMETER_FILE}"
						echo
						cat $L3BIN_PARAMETER_FILE
						seabatch_separator; echo; echo
			
						l3bin in=$L2BIN_TEXT_FILE out=$MODIS_L3BIN_SST4_FILE parfile=$L3BIN_PARAMETER_FILE
			
						if [ $? -ne 0 ]; then
						
							SEADAS_SCRIPT_NAME='l3bin'
							SCRIPT_ERROR_ACTION='DEFAULT'
							script_error_action $MODIS_L3BIN_SST4_FILE
							
						fi
						###########################
						###########################

				
						
						
					fi
					
				fi
				
			fi
			###################################################
			###################################################




			###################################################
			###################################################
			if [ $SENSOR = 'SEAWIFS' ]; then

				if [ $TEMPORAL_BIN_L2BIN_FILE_AMOUNT -eq 0 ]; then
					
					echo; echo; seabatch_separator
					seabatch_statement "No SeaWiFS Level-2 Ocean Color files, spatially binned to ${SPATIAL_BIN} km, corresponding to the ${TEMPORAL_BIN} temporal bin YD ${TEMPORAL_BIN_START_YEARDAY} to YD ${TEMPORAL_BIN_END_YEARDAY}, exist!"
					seabatch_separator
						
					continue
					
				else
					
					echo; echo; seabatch_separator
					seabatch_statement "$TEMPORAL_BIN_L2BIN_FILE_AMOUNT SeaWiFS Level-2 Ocean Color file(s), spatially binned to ${SPATIAL_BIN} km, corresponding to the ${TEMPORAL_BIN} temporal bin YD ${TEMPORAL_BIN_START_YEARDAY} to YD ${TEMPORAL_BIN_END_YEARDAY}, exist(s)!"
					echo
					cat $L2BIN_TEXT_FILE
					seabatch_separator
						
							
						
						
					###########################
					###########################
					#Define 
					#SEAWIFS_L3BIN_OC_FILE, the 
					#name of the file that 
					#will result from 
					#temporally binning the 
					#above files.
						
					if [ $TEMPORAL_BIN_START_YEARDAY = $TEMPORAL_BIN_END_YEARDAY ]; then
						SEAWIFS_L3BIN_OC_FILE=${SENSOR_ABBREVIATION}${YEAR}${TEMPORAL_BIN_START_YEARDAY}'.L3b_OC_'${SPATIAL_BIN}'km_'${TEMPORAL_BIN}
					else
						SEAWIFS_L3BIN_OC_FILE=${SENSOR_ABBREVIATION}${YEAR}${TEMPORAL_BIN_START_YEARDAY}${YEAR}${TEMPORAL_BIN_END_YEARDAY}'.L3b_OC_'${SPATIAL_BIN}'km_'${TEMPORAL_BIN}
					fi
					###########################
					###########################
						
						
						
						
					###########################
					###########################
					#If L3BIN_PARAMETER_FILE is 
					#set to "DEFAULT" then set 
					#it to "l3bin_modis_oc_default.par".
	
					if [ $L3BIN_PARAMETER_FILE = 'DEFAULT' ]; then
						L3BIN_PARAMETER_FILE=${SEABATCH_PARAMETER_DIRECTORY}'/l3bin_seawifs_oc_default.par'
					fi
					###########################
					###########################
						
						
						
						
					###########################
					###########################
					#Temporally bin the above
					#files with the SeaDAS
					#script l3bin.
			
					echo; echo; seabatch_separator
					seabatch_statement "Temporally binning the above files (constructing ${MODIS_L3BIN_OC_FILE}) ..."
					seabatch_separator
			
					echo; echo; seabatch_separator
					seabatch_statement "l3bin parameter file used: ${L3BIN_PARAMETER_FILE}"
					echo
					cat $L3BIN_PARAMETER_FILE
					seabatch_separator; echo; echo
			
					l3bin in=$L2BIN_TEXT_FILE out=$SEAWIFS_L3BIN_OC_FILE parfile=$L3BIN_PARAMETER_FILE
			
					if [ $? -ne 0 ]; then
						
						SEADAS_SCRIPT_NAME='l3bin'
						SCRIPT_ERROR_ACTION='DEFAULT'
						script_error_action $SEAWIFS_L3BIN_OC_FILE
							
					fi
					###########################
					###########################

					
					
						
				fi

			fi
			###################################################
			###################################################
			
			
			
		done	
		###########################################################
		###########################################################
		
		
		
		
		###########################################################
		###########################################################
		if [ $SENSOR = 'AQUA' -o $SENSOR = 'TERRA' ]; then
	
	
	
	
			###################################################
			###################################################
			if [ $MODIS_SST = 'NO' ]; then
				echo; echo; seabatch_separator
				seabatch_statement "Level-2 to Level-3 ${TEMPORAL_BIN} temporal binning of MODIS Level-2 Ocean Color files spatially binned to ${SPATIAL_BIN} km finished!"
				seabatch_separator
			fi
			###################################################
			###################################################
			
			
			
			
			###################################################
			###################################################
			if [ $MODIS_SST = 'SST' -o $MODIS_SST = 'NSST' ]; then

				if [ $MODIS_SST = 'SST' ]; then

					echo; echo; seabatch_separator
					seabatch_statement "Level-2 to Level-3 ${TEMPORAL_BIN} temporal binning of MODIS Level-2 daytime SST (11 micron) files spatially binned to ${SPATIAL_BIN} km finished!"
					seabatch_separator

				fi

				if [ $MODIS_SST = 'SST_NIGHT' ]; then

					echo; echo; seabatch_separator
					seabatch_statement "Level-2 to Level-3 ${TEMPORAL_BIN} temporal binning of MODIS Level-2 nighttime SST (11 micron) files spatially binned to ${SPATIAL_BIN} km finished"
					seabatch_separator

				fi
				
			fi
			###################################################
			###################################################
			
			
			
			
			###################################################
			###################################################
			if [ $MODIS_SST = 'SST4' ]; then
				echo; echo; seabatch_separator
				seabatch_statement "Level-2 to Level-3 ${TEMPORAL_BIN} temporal binning of MODIS Level-2 SST4 (4 micron) files spatially binned to ${SPATIAL_BIN} km finished!"
				seabatch_separator
			fi
			###################################################
			###################################################
			
			
			
			
		fi
		###########################################################
		###########################################################
		
		
		
		
		###########################################################
		###########################################################
		if [ $SENSOR = 'SEAWIFS' ]; then
			echo; echo; seabatch_separator
			seabatch_statement "Level-2 to Level-3 ${TEMPORAL_BIN} temporal binning of SeaWiFS Level-2 Ocean Color files spatially binned to ${SPATIAL_BIN} km finished!"
			seabatch_separator
		fi
		###########################################################
		###########################################################
		
		
		
		
	done	
	###################################################################
	###################################################################
	
	
	
done	
###########################################################################
###########################################################################




###########################################################################
###########################################################################
if [ $SENSOR = 'AQUA' -o $SENSOR = 'TERRA' ]; then
	
	
	
	
	###################################################################
	###################################################################
	if [ $MODIS_SST = 'NO' ]; then
		echo; echo; seabatch_separator
		seabatch_statement "Level-2 to Level-3 temporal binning of spatially binned MODIS Level-2 Ocean Color files finished!"
		seabatch_separator
	fi
	###################################################################
	###################################################################
			
			
			
			
	###################################################################
	###################################################################
	if [ $MODIS_SST = 'SST' -o $MODIS_SST = 'NSST' ]; then

		if [ $MODIS_SST = 'SST' ]; then

			echo; echo; seabatch_separator
			seabatch_statement "Level-2 to Level-3 temporal binning of spatially binned MODIS Level-2 daytime SST (11 micron) files finished!"
			seabatch_separator

		fi

		if [ $MODIS_SST = 'NSST' ]; then

			echo; echo; seabatch_separator
			seabatch_statement "Level-2 to Level-3 temporal binning of spatially binned MODIS Level-2 nighttime SST (11 micron) files finished"
			seabatch_separator

		fi
				
	fi
	###################################################################
	###################################################################
			
			
			
			
	###################################################################
	###################################################################
	if [ $MODIS_SST = 'SST4' ]; then
		echo; echo; seabatch_separator
		seabatch_statement "Level-2 to Level-3 temporal binning of spatially binned MODIS Level-2 SST4 (4 micron) files finished!"
		seabatch_separator
	fi
	###################################################################
	###################################################################
			
			
			
			
fi
###########################################################################
###########################################################################
		
		
		
		
###########################################################################
###########################################################################
if [ $SENSOR = 'SEAWIFS' ]; then
	echo; echo; seabatch_separator
	seabatch_statement "Level-2 to Level-3 temporal binning of spatially binned SeaWiFS Level-2 Ocean Color files finished!"
	seabatch_separator
fi
###########################################################################
###########################################################################




###########################################################################
###########################################################################
#Remove any spatially binned Level-2 files that exist in the current
#directory.

echo; echo; seabatch_separator
seabatch_statement "Removing any spatially binned files that exist in the current directory ..."
seabatch_separator

rm *.L2b*	
###########################################################################
###########################################################################




###########################################################################
###########################################################################
SEABATCH_SCRIPT_EXIT_STATUS=0

exit_seabatch_script
###########################################################################
###########################################################################

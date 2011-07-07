#!/bin/bash




###########################################################################
###########################################################################
#This script spatially bins MODIS (Aqua and Terra) and SeaWiFS Level-2 
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

SEABATCH_SCRIPT_NAME=${SEABATCH_BIN_DIRECTORY}'/level2tolevel3_spatialbin.sh'
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
echo "- SPATIAL_BINS: ${SPATIAL_BINS[@]}"
seabatch_statement "- MODIS_SST: ${MODIS_SST}"
seabatch_statement "- L2BIN_PARAMETER_FILE: ${L2BIN_PARAMETER_FILE}"
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
if [ $SENSOR = 'AQUA' -o $SENSOR = 'TERRA' ]; then
	
	
	
	
	###################################################################
	###################################################################
	if [ $MODIS_SST = 'NO' ]; then
		echo; echo; seabatch_separator
		seabatch_statement "Begin Level-2 to Level-3 spatial binning of MODIS Level-2 Ocean Color files ..."
		seabatch_separator
	fi
	###################################################################
	###################################################################
			
			
			
			
	###################################################################
	###################################################################
	if [ $MODIS_SST = 'SST' -o $MODIS_SST = 'NSST' ]; then

		if [ $MODIS_SST = 'SST' ]; then

			echo; echo; seabatch_separator
			seabatch_statement "Begin Level-2 to Level-3 spatial binning of MODIS Level-2 daytime SST (11 micron) files ..."
			seabatch_separator

		fi

		if [ $MODIS_SST = 'NSST' ]; then

			echo; echo; seabatch_separator
			seabatch_statement "Begin Level-2 to Level-3 spatial binning of MODIS Level-2 nightime SST (11 micron) files ..."
			seabatch_separator

		fi
				
	fi
	###################################################################
	###################################################################
			
			
			
			
	###################################################################
	###################################################################
	if [ $MODIS_SST = 'SST4' ]; then
		echo; echo; seabatch_separator
		seabatch_statement "Begin Level-2 to Level-3 spatial binning of MODIS Level-2 SST4 (4 micron) files ..."
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
	seabatch_statement "Begin Level-2 to Level-3 spatial binning of SeaWiFS Level-2 files ..."
	seabatch_separator
fi
###########################################################################
###########################################################################




###########################################################################
###########################################################################
for SPATIAL_BIN in ${SPATIAL_BINS[@]}; do




	###################################################################
	###################################################################
	if [ $SENSOR = 'AQUA' -o $SENSOR = 'TERRA' ]; then
	
	
	
	
		###########################################################
		###########################################################
		if [ $MODIS_SST = 'NO' ]; then
		
		
		
		
			###################################################
			###################################################
			echo; echo; seabatch_separator
			seabatch_statement "Begin Level-2 to Level-3 ${SPATIAL_BIN} km spatial binning of MODIS Level-2 Ocean Color files ..."
			seabatch_separator
			###################################################
			###################################################
			
			
			
			
			###################################################
			###################################################
			FILE_TYPE='MODIS Level-2 Ocean Color files'
			FILE_TYPE_PATTERNS=$MODIS_L2_OC_FILE_PATTERNS
			FILE_TYPE_TEXT_FILE=${SEABATCH_LOG_DIRECTORY}'/file_list/modis_l2_oc_'${SPATIAL_BIN}'km.txt'
			
			file_type_list
			
			if [ $FILE_TYPE_FILE_AMOUNT -eq 0 ]; then
				exit 1
			fi
			###################################################
			###################################################
			
			
			
			
			###################################################
			###################################################
			while read MODIS_L2_OC_FILE; do
		
		
		
		
				###########################################
				###########################################
				echo; echo; seabatch_separator
				seabatch_statement "Current MODIS Level-2 Ocean Color file: ${MODIS_L2_OC_FILE}"
				seabatch_separator
				###########################################
				###########################################
					
					
					
					
				###########################################
				###########################################
				#Define BASE, the basename of 
				#MODIS_L2_OC_FILE.
			
				BASE=$(echo $MODIS_L2_OC_FILE | awk -F. '{ print $1 }')
				###########################################
				###########################################
					
					
					
					
				###########################################
				###########################################
				#Define MODIS_L2BIN_OC_FILE, the name of 
				#the spatially binned MODIS_L2_OC_FILE.

				MODIS_L2BIN_OC_FILE=${BASE}'.L2b_OC_'${SPATIAL_BIN}'km'
				###########################################
				###########################################
				
				
				
				
				###########################################
				###########################################
				#If L2BIN_PARAMETER_FILE is set to 
				#"DEFAULT" then set it to 
				#"l2bin_modis_oc_default.par".
	
				if [ $L2BIN_PARAMETER_FILE = 'DEFAULT' ]; then
					L2BIN_PARAMETER_FILE=${SEABATCH_PARAMETER_DIRECTORY}'/l2bin_modis_oc_default.par'
				fi
				###########################################
				###########################################
	
					
					
					
				###########################################
				###########################################
				#Spatially bin MODIS_L2_OC_FILE with the 
				#SeaDAS script l2bin.
			
				echo; echo; seabatch_separator
				seabatch_statement "Spatially binning ${MODIS_L2_OC_FILE} at ${SPATIAL_BIN} km (constructing ${MODIS_L2BIN_OC_FILE}) ..."
				seabatch_separator
			
				echo; echo; seabatch_separator
				seabatch_statement "l2bin parameter file used: ${L2BIN_PARAMETER_FILE}"
				echo
				cat $L2BIN_PARAMETER_FILE
				seabatch_separator; echo; echo
			
				l2bin parfile=$L2BIN_PARAMETER_FILE infile=$MODIS_L2_OC_FILE ofile=$MODIS_L2BIN_OC_FILE resolve=$SPATIAL_BIN
			
				if [ $? -ne 0 ]; then

					SCRIPT_NAME='l2bin'
					SCRIPT_ERROR_ACTION='COPY'
					script_error_action $MODIS_L2_OC_FILE

				fi
				###########################################
				###########################################
					
					
					
					
			done <$FILE_TYPE_TEXT_FILE
			###########################################
			###########################################	
				
				
				
					
			###################################################
			###################################################
			echo; echo; seabatch_separator
			seabatch_statement "Level-2 to Level-3 ${SPATIAL_BIN} km spatial binning of MODIS Level-2 Ocean Color files finished!"
			seabatch_separator
			###################################################
			###################################################
		
		
		
		
		fi
		###########################################################
		###########################################################
	
	
	
	
		###########################################################
		###########################################################
		if [ $MODIS_SST = 'SST' -o $MODIS_SST = 'NSST' ]; then
		


		
			###################################################
			###################################################
			if [ $MODIS_SST = 'SST' ]; then




				##########################################
				##########################################
				echo; echo; seabatch_separator
				seabatch_statement "Begin Level-2 to Level-3 ${SPATIAL_BIN} km spatial binning of MODIS Level-2 daytime SST (11 micron) files ..."
				seabatch_separator
				##########################################
				##########################################



			fi
			###################################################
			###################################################




			###################################################
			###################################################
			if [ $MODIS_SST = 'NSST' ]; then




				##########################################
				##########################################
				echo; echo; seabatch_separator
				seabatch_statement "Begin Level-2 to Level-3 ${SPATIAL_BIN} km spatial binning of MODIS Level-2 nighttime SST (11 micron) files ..."
				seabatch_separator
				##########################################
				##########################################



			fi
			###################################################
			###################################################
			
			
			
			###################################################
			###################################################
			FILE_TYPE='MODIS Level-2 SST (11 micron) files'
			FILE_TYPE_PATTERNS=$MODIS_L2_SST_FILE_PATTERNS
			FILE_TYPE_TEXT_FILE=${SEABATCH_LOG_DIRECTORY}'/file_list/modis_l2_sst_'${SPATIAL_BIN}'km.txt'
			
			file_type_list
			
			if [ $FILE_TYPE_FILE_AMOUNT -eq 0 ]; then
				exit 1
			fi
			###################################################
			###################################################
			
			
			
			
			###################################################
			###################################################
			while read MODIS_L2_SST_FILE; do
		
		
		
		
				###########################################
				###########################################
				echo; echo; seabatch_separator
				seabatch_statement "Current MODIS Level-2 SST (11 micron) file: ${MODIS_L2_SST_FILE}"
				seabatch_separator
				###########################################
				###########################################
					
					
					
					
				###########################################
				###########################################
				#Define BASE, the basename of 
				#MODIS_L2_SST_FILE.
			
				BASE=$(echo $MODIS_L2_SST_FILE | awk -F. '{ print $1 }')
				###########################################
				###########################################
					
					
					
					
				###########################################
				###########################################
				#MODIS Level-2 SST (11 micron) files can 
				#consist of just daytime pixels, just 
				#nighttime pixels, or a combination of both. 
				#Define DAYNIGHT (DAY, NIGHT, or MIXED), 
				#which indicates which type of pixels exist 
				#in MODIS_L2_SST_FILE.
			
				DAYNIGHT=$(ncdump -h ${MODIS_L2_SST_FILE} | grep 'Day or Night' | cut -c20)
		
				if [ $DAYNIGHT = 'D' ]; then 
					DAYNIGHT='DAY'
				fi
		
				if [ $DAYNIGHT = 'N' ]; then 
					DAYNIGHT='NIGHT'
				fi
		
				if [ $DAYNIGHT = 'M' ]; then 
					DAYNIGHT='MIXED'
				fi
		
				echo; echo; seabatch_separator
				seabatch_statement "Day or Night field of ${MODIS_L2_SST_FILE} is set to: ${DAYNIGHT}"
				seabatch_separator
				###########################################
				###########################################
					



				###########################################
				###########################################	
				#If MODIS_L2_SST_FILE contains daytime 
				#pixels then spatially bin them.

				if [ $MODIS_SST = 'SST' ]; then


	
					
					###################################
					###################################
					if [ $DAYNIGHT = 'DAY' -o $DAYNIGHT = 'MIXED' ]; then
						


						
						###########################
						###########################
						echo; echo; seabatch_separator
						seabatch_statement "${MODIS_L2_SST_FILE} contains daytime pixels"
						seabatch_separator
						###########################
						###########################

					

					
						###########################
						###########################
						#Define 
						#MODIS_L2BIN_SST_FILE, the 
						#name of the spatially 
						#binned (daytime) 
						#MODIS_L2_SST_FILE.

						MODIS_L2BIN_SST_FILE=${BASE}'.L2b_SST_'${SPATIAL_BIN}'km'
						###########################
						###########################
						
						
						
						
						###########################
						###########################
						#If L2BIN_PARAMETER_FILE 
						#is set to "DEFAULT" then 
						#set it to "l2bin_modis_sst_day_default.par".
	
						if [ $L2BIN_PARAMETER_FILE = 'DEFAULT' ]; then
							L2BIN_PARAMETER_FILE=${SEABATCH_PARAMETER_DIRECTORY}'/l2bin_modis_sst_default.par'
						fi
						###########################
						###########################
					
					
					
					
						###########################
						###########################
						#Spatially bin the daytime 
						#pixels of 
						#MODIS_L2_SST_FILE with 
						#the SeaDAS script l2bin.
			
						echo; echo; seabatch_separator
						seabatch_statement "Spatially binning the daytime pixels of ${MODIS_L2_SST_FILE} at ${SPATIAL_BIN} km (constructing ${MODIS_L2BIN_SST_FILE}) ..."
						seabatch_separator
			
						echo; echo; seabatch_separator
						seabatch_statement "l2bin parameter file used: ${L2BIN_PARAMETER_FILE}"
						echo
						cat $L2BIN_PARAMETER_FILE
						seabatch_separator; echo; echo
			
						l2bin parfile=$L2BIN_PARAMETER_FILE infile=$MODIS_L2_SST_FILE ofile=$MODIS_L2BIN_SST_FILE resolve=$SPATIAL_BIN night=0
			
						if [ $? -ne 0 ]; then
						
							SCRIPT_NAME='l2bin'
							SCRIPT_ERROR_ACTION='COPY'
							script_error_action $MODIS_L2_SST_FILE
							
						fi
						###########################
						###########################
						
						


					else
						

						
						
						###########################
						###########################
						echo; echo; seabatch_separator
						seabatch_statement "${MODIS_L2_SST_FILE} does NOT contain daytime pixels. Continuing to the next MODIS Level-2 SST (11 micron) file ..."
						seabatch_separator

						continue
						###########################
						###########################

						


					fi
					###################################
					###################################
		



				fi
				###########################################
				###########################################



				###########################################
				###########################################	
				#If MODIS_L2_SST_FILE contains nighttime 
				#pixels then spatially bin them.

				if [ $MODIS_SST = 'NSST' ]; then
					
					
					
					
					###################################
					###################################
					if [ $DAYNIGHT = 'NIGHT' -o $DAYNIGHT = 'MIXED' ]; then




						###########################
						###########################
						echo; echo; seabatch_separator
						seabatch_statement "${MODIS_L2_SST_FILE} contains nighttime pixels"
						seabatch_separator
						###########################
						###########################
					
					
					
					
						###########################
						###########################
						#Define 
						#MODIS_L2BIN_NSST_FILE, the 
						#name of the spatially 
						#binned (nighttime) 
						#MODIS_L2_SST_FILE.
	
						MODIS_L2BIN_NSST_FILE=${BASE}'.L2b_NSST_'${SPATIAL_BIN}'km'
						###########################
						###########################
						



						###########################
						###########################
						#If L2BIN_PARAMETER_FILE 
						#is set to "DEFAULT" then 
						#set it to "l2bin_modis_nsst_default.par".
	
						if [ $L2BIN_PARAMETER_FILE = 'DEFAULT' ]; then
							L2BIN_PARAMETER_FILE=${SEABATCH_PARAMETER_DIRECTORY}'/l2bin_modis_nsst_default.par'
						fi
						###########################
						###########################
						
						

						
						###########################
						###########################
						#Spatially bin the 
						#nighttime pixels of 
						#MODIS_L2_SST_FILE with 
						#the SeaDAS script l2bin.
			
						echo; seabatch_separator
						seabatch_statement "Spatially binning the nighttime pixels of ${MODIS_L2_SST_FILE} at ${SPATIAL_BIN} km (constructing ${MODIS_L2BIN_NSST_FILE}) ..."
						seabatch_separator
			
						echo; echo; seabatch_separator
						seabatch_statement "l2bin parameter file used: ${L2BIN_PARAMETER_FILE}"
						echo
						cat $L2BIN_PARAMETER_FILE
						seabatch_separator; echo; echo
			
						l2bin parfile=$L2BIN_PARAMETER_FILE infile=$MODIS_L2_SST_FILE ofile=$MODIS_L2BIN_NSST_L2BIN_FILE resolve=$SPATIAL_BIN night=1
			
						if [ $? -ne 0 ]; then
						
							SCRIPT_NAME='l2bin'
							SCRIPT_ERROR_ACTION='DEFAULT'
							script_error_action $MODIS_L2_SST_FILE
							
						fi
						###########################
						###########################

						


					else
						

						
						
						###########################
						###########################
						echo; echo; seabatch_separator
						seabatch_statement "${MODIS_L2_SST_FILE} does NOT contain nighttime pixels. Continuing to the next MODIS Level-2 SST (11 micron) file ..."
						seabatch_separator

						continue
						###########################
						###########################
						
						


					fi
					###################################
					###################################
						
						
		
		
				fi
				###########################################
				###########################################
					
					
					
			done <$FILE_TYPE_TEXT_FILE
			###################################################
			###################################################
			
			
			
			
			###################################################
			###################################################
			if [ $MODIS_SST = 'SST' ]; then




				##########################################
				##########################################
				echo; echo; seabatch_separator
				seabatch_statement "Level-2 to Level-3 ${SPATIAL_BIN} km spatial binning of MODIS Level-2 daytime SST (11 micron) files finished!"
				seabatch_separator
				##########################################
				##########################################



			fi
			###################################################
			###################################################




			###################################################
			###################################################
			if [ $MODIS_SST = 'NSST' ]; then




				##########################################
				##########################################
				echo; echo; seabatch_separator
				seabatch_statement "Level-2 to Level-3 ${SPATIAL_BIN} km spatial binning of MODIS Level-2 nighttime SST (11 micron) files finished!"
				seabatch_separator
				##########################################
				##########################################



			fi
			###################################################
			###################################################
		
		
		
		fi
		###########################################################
		###########################################################
		
		
		
		
		###########################################################
		###########################################################
		if [ $MODIS_SST = 'SST4' ]; then
		
		
		
		
			###################################################
			###################################################
			echo; echo; seabatch_separator
			seabatch_statement "Begin Level-2 to Level-3 ${SPATIAL_BIN} km spatial binning of MODIS Level-2 SST4 (11 micron) files ..."
			seabatch_separator
			###################################################
			###################################################
			
			
			
			
			###################################################
			###################################################
			FILE_TYPE='MODIS Level-2 SST4 (4 micron)'
			FILE_TYPE_PATTERNS=$MODIS_L2_SST4_FILE_PATTERNS
			FILE_TYPE_TEXT_FILE=${SEABATCH_LOG_DIRECTORY}'/file_list/modis_l2_sst4_'${SPATIAL_BIN}'km.txt'
			
			file_type_list
			
			if [ $FILE_TYPE_FILE_AMOUNT -eq 0 ]; then
				exit 1
			fi
			###################################################
			###################################################
			
			
			
			
			###################################################
			###################################################
			while read MODIS_L2_SST4_FILE; do
		
		
		
		
				###########################################
				###########################################
				echo; echo; seabatch_separator
				seabatch_statement "Current MODIS Level-2 SST4 file: ${MODIS_L2_SST4_FILE}"
				seabatch_separator
				###########################################
				###########################################
			
					
					
					
				###########################################
				###########################################
				#Define BASE, the basename of 
				#MODIS_L2_SST4_FILE.
			
				BASE=$(echo $MODIS_L2_SST4_FILE | awk -F. '{ print $1 }')
				###########################################
				###########################################
					
					
					
					
				###########################################
				###########################################
				#Define MODIS_L2BIN_SST4_FILE, the name of 
				#the spatially binned MODIS_L2_SST4_FILE.

				MODIS_L2BIN_SST4_FILE=${BASE}'.L2b_SST4_'${SPATIAL_BIN}'km'
				###########################################
				###########################################
				



				###########################################
				###########################################
				#If L2BIN_PARAMETER_FILE is set to 
				#"DEFAULT" then set it to 
				#"l2bin_modis_sst4_default.par".
	
				if [ $L2BIN_PARAMETER_FILE = 'DEFAULT' ]; then
					L2BIN_PARAMETER_FILE=${SEABATCH_PARAMETER_DIRECTORY}'/l2bin_modis_sst4_default.par'
				fi
				###########################################
				###########################################
					
					
					
					
				###########################################
				###########################################
				#Spatially bin MODIS_L2_SST4_FILE with the 
				#SeaDAS script l2bin.
			
				echo; echo; seabatch_separator
				seabatch_statement "Spatially binning ${MODIS_L2_SST4_FILE} at ${SPATIAL_BIN} km (constructing ${MODIS_L2BIN_SST4_FILE}) ..."
				seabatch_separator
			
				echo; echo; seabatch_separator
				seabatch_statement "l2bin parameter file used: ${L2BIN_PARAMETER_FILE}"
				echo
				cat $L2BIN_PARAMETER_FILE
				seabatch_separator; echo; echo
			
				l2bin parfile=$L2BIN_PARAMETER_FILE infile=$MODIS_L2_SST4_FILE ofile=$MODIS_L2BIN_SST4_FILE resolve=$SPATIAL_BIN night=1
			
				if [ $? -ne 0 ]; then
				
					SCRIPT_NAME='l2bin'
					SCRIPT_ERROR_ACTION='COPY'
					script_error_action $MODIS_L2_SST4_FILE
					
				fi
				###########################################
				###########################################
					
					
					
					
			done <$FILE_TYPE_TEXT_FILE
			###################################################
			###################################################
				
			
			
			
			###################################################
			###################################################
			echo; echo; seabatch_separator
			seabatch_statement "Level-2 to Level-3 ${SPATIAL_BIN} km spatial binning of MODIS Level-2 SST4 (11 micron) files finished!"
			seabatch_separator
			###################################################
			###################################################
			
			
			
			
		fi
		###########################################################
		###########################################################
		
		
		
	fi
	###################################################################
	###################################################################




	###################################################################
	###################################################################
	if [ $SENSOR = 'SEAWIFS' ]; then




		###########################################################
		###########################################################
		echo; echo; seabatch_separator
		seabatch_statement "Begin Level-2 to Level-3 ${SPATIAL_BIN} km spatial binning of SeaWiFS Level-2 Ocean Color files ..."
		seabatch_separator
		###########################################################
		###########################################################
			
			
			
		
		###########################################################
		###########################################################
		FILE_TYPE='SeaWiFS Level-2 Ocean Color files'
		FILE_TYPE_PATTERNS=$SEAWIFS_L2_OC_FILE_PATTERNS
		FILE_TYPE_TEXT_FILE=${SEABATCH_LOG_DIRECTORY}'/file_list/seawifs_l2_oc_'${SPATIAL_BIN}'km.txt'
			
		file_type_list
			
		if [ $FILE_TYPE_FILE_AMOUNT -eq 0 ]; then
			exit 1
		fi
		###########################################################
		###########################################################
			
			
			
			
		###########################################################
		###########################################################
		while read SEAWIFS_L2_OC_FILE; do
		
		
		
		
			###################################################
			###################################################
			echo; echo; seabatch_separator
			seabatch_statement "Current SeaWiFS Level-2 Ocean Color file: ${SEAWIFS_L2_OC_FILE}"
			seabatch_separator
			###################################################
			###################################################
					
					
					
					
			###################################################
			###################################################
			#Define BASE, the basename of 
			#SEAWIFS_L2_OC_FILE.
			
			BASE=$(echo $SEAWIFS_L2_OC_FILE | awk -F. '{ print $1 }')
			###################################################
			###################################################
					
					
					
					
			###################################################
			###################################################
			#Define SEAWIFS_L2BIN_OC_FILE, the name of 
			#the spatially binned SEAWIFS_L2_OC_FILE.

			SEAWIFS_L2BIN_OC_FILE=${BASE}'.L2b_OC_'${SPATIAL_BIN}'km'
			###################################################
			###################################################
				
				
				
				
			###################################################
			###################################################
			#If L2BIN_PARAMETER_FILE is set to "DEFAULT" then 
			#set it to "l2bin_seawifs_oc_default.par".

			if [ $L2BIN_PARAMETER_FILE = 'DEFAULT' ]; then
				L2BIN_PARAMETER_FILE=${SEABATCH_PARAMETER_DIRECTORY}'/l2bin_seawifs_oc_default.par'
			fi
			###################################################
			###################################################
	
					
					
					
			###################################################
			###################################################
			#Spatially bin SEAWIFS_L2_OC_FILE with the 
			#SeaDAS script l2bin.
			
			echo; echo; seabatch_separator
			seabatch_statement "Spatially binning ${SEAWIFS_L2_OC_FILE} at ${SPATIAL_BIN} km (constructing ${SEAWIFS_L2BIN_OC_FILE}) ..."
			seabatch_separator
			
			echo; echo; seabatch_separator
			seabatch_statement "l2bin parameter file used: ${L2BIN_PARAMETER_FILE}"
			echo
			cat $L2BIN_PARAMETER_FILE
			seabatch_separator; echo; echo
			
			l2bin parfile=$L2BIN_PARAMETER_FILE infile=$SEAWIFS_L2_OC_FILE ofile=$SEAWIFS_L2BIN_OC_FILE resolve=$SPATIAL_BIN
			
			if [ $? -ne 0 ]; then

				SCRIPT_NAME='l2bin'
				SCRIPT_ERROR_ACTION='COPY'
				script_error_action $SEAWIFS_L2_OC_FILE

			fi
			###################################################
			###################################################
					
					
					
					
		done <$FILE_TYPE_TEXT_FILE
		###########################################################
		###########################################################
				
				
				
					
		###########################################################
		###########################################################
		echo; echo; seabatch_separator
		seabatch_statement "Level-2 to Level-3 ${SPATIAL_BIN} km spatial binning of SeaWiFS Level-2 Ocean Color files finished!"
		seabatch_separator
		###########################################################
		###########################################################



	fi
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
		seabatch_statement "Level-2 to Level-3 spatial binning of MODIS Level-2 Ocean Color files finished!"
		seabatch_separator
	fi
	###################################################################
	###################################################################
			
			
			
			
	###################################################################
	###################################################################
	if [ $MODIS_SST = 'SST' -o $MODIS_SST = 'NSST' ]; then

		if [ $MODIS_SST = 'SST' ]; then

			echo; echo; seabatch_separator
			seabatch_statement "Level-2 to Level-3 spatial binning of MODIS Level-2 daytime SST (11 micron) files finished!"
			seabatch_separator

		fi

		if [ $MODIS_SST = 'NSST' ]; then

			echo; echo; seabatch_separator
			seabatch_statement "Level-2 to Level-3 spatial binning of nighttime MODIS Level-2 nighttime SST (11 micron) files finished"
			seabatch_separator

		fi
				
	fi
	###################################################################
	###################################################################
			
			
			
			
	###################################################################
	###################################################################
	if [ $MODIS_SST = 'SST4' ]; then
		echo; echo; seabatch_separator
		seabatch_statement "Level-2 to Level-3 spatial binning of MODIS Level-2 SST4 (4 micron) files finished!"
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
	seabatch_statement "Level-2 to Level-3 spatial binning of SeaWiFS Level-2 files finished!"
	seabatch_separator
fi
###########################################################################
###########################################################################




###########################################################################
###########################################################################
SEABATCH_SCRIPT_EXIT_STATUS=0

exit_seabatch_script
###########################################################################
###########################################################################

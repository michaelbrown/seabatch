#!/bin/bash


#This script performs an initial check of the processing parameters 
#specified by the user in master_script.sh.


SCRIPT_VERSION='1.2'
echo; echo; echo '***** PERFORMING INITIAL CHECK *****'
echo; echo; echo $SEADAS'/seabatch1.2/initial_check.sh' 'v'$SCRIPT_VERSION, SeaBatch v${SEABATCH_VERSION}


###########################################################################
###########################################################################
#Source the file '/.seabatch_variables.txt'

source './seabatch_variables.txt'
###########################################################################
###########################################################################



###########################################################################
###########################################################################
#Display and perform checks on variables used for ALL processing:

echo; echo; echo 'Variables used for ALL processing:'
echo '- OUT_DIR:' $OUT_DIR
echo '- START_LEVEL:' $START_LEVEL
echo '- END_LEVEL:' $END_LEVEL
echo '- WEST:' $WEST 'E'
echo '- EAST:' $EAST 'E'
echo '- NORTH:' $NORTH 'N'
echo '- SOUTH:' $SOUTH 'N'

echo; echo; echo 'Checks performed for ALL processing:'

#If not set to default, check that OUT_DIR exists:
if [ $OUT_DIR = default ]; then
	echo '- OUT_DIR is valid' 
else
	if [ -d $OUT_DIR ]; then
		echo '- OUT_DIR exists'
		
		#If OUT_DIR exists check that cleanup.sh exists:
		if [ -e $SEADAS/seabatch1.1/cleanup.sh ]; then
			echo '- $SEADAS/seabatch1.1/cleanup.sh exists'
			
			#If cleanup.sh exists check that it is executable:
			if [ -x $SEADAS/seabatch1.1/cleanup.sh ]; then
				echo '- $SEADAS/seabatch1.1/cleanup.sh is executable'
			else
				echo; echo; echo 'ERROR: $SEADAS/seabatch1.1/cleanup.sh is not executable'
				exit 1
			fi
		else
			echo; echo; echo 'ERROR: $SEADAS/seabatch1.1/cleanup.sh does not exist'
			exit 1
		fi
	else
		echo; echo; echo 'ERROR: OUT_DIR does not exist'
		exit 1
	fi
fi

#Check that START_LEVEL is valid (0, 1, or 2):
case $START_LEVEL in 
	0 | 1 | 2 | 3)
	echo  '- START_LEVEL is valid'
	;;
	*) 
	echo; echo; echo 'ERROR: START_LEVEL is not valid (Must be 0, 1, or 2)'
	exit 1
	;;
esac

#Check that END_LEVEL is valid (1, 2, 3, or 4):
case $END_LEVEL in 
	1 | 2 | 3 | 4)
	echo '- END_LEVEL is valid'
	;;
	*) 
	echo; echo; echo 'ERROR: END_LEVEL is not valid (Must be 1, 2, 3, or 4)'
	exit 1
	;;
esac

#Check that START_LEVEL is less than END_LEVEL:
if [ $START_LEVEL -lt $END_LEVEL ]; then
	echo '- START_LEVEL is less than END_LEVEL'
else
	echo; echo; echo 'ERROR: START_LEVEL is not less than END_LEVEL'
	exit 1
fi

#Given START_LEVEL, check that files of the proper filename structure exist 
#in the the current directory.
if [ $START_LEVEL = 0 ]; then
	FILE_AMNT=$(ls [AT]*.L0_LAC MOD00.[AP]*.PDS 2>/dev/null | wc -l)
elif [ $START_LEVEL = 1 ]; then
	FILE_AMNT=$(ls [AST]*.L1A_[GL]AC* S*.L1A_MLAC* 2>/dev/null | wc -l)
elif [ $START_LEVEL = 2 ]; then
	FILE_AMNT=$(ls [AST]*.L2_[GL]AC* S*.L2_MLAC* 2>/dev/null | wc -l)
elif [ $START_LEVEL = 3 ]; then
	FILE_AMNT=$(ls [AST]*_*_*.L3 2>/dev/null | wc -l)
fi

if [ $FILE_AMNT -gt 0 ]; then
	echo '-' $FILE_AMNT 'valid files exist for processing in the current directory'
else
	echo; echo; echo 'ERROR: No valid files exist for processing in the current directory'
	exit 1
fi

#This version of SeaBatch is unable to perform any checks on WEST, EAST, 
#NORTH, or SOUTH:
echo '- No checks performed on WEST, EAST, NORTH, or SOUTH'
###########################################################################
###########################################################################


###########################################################################
###########################################################################
#Display and perform checks on variables used for LEVEL-0 to LEVEL-1 
#processing:
if [ $START_LEVEL -eq 0 -a $END_LEVEL -ge 1 ]; then

	echo; echo; echo 'Checks performed for LEVEL-0 to LEVEL-1 processing:'
	
	#Check that level0tolevel1.sh exists:
	if [ -e $SEADAS/seabatch1.1/level0tolevel1.sh ]; then
		echo '- $SEADAS/seabatch1.1/level0tolevel1.sh exists'
			
		#If level0tolevel1.sh exists check that it is executable:
		if [ -x $SEADAS/seabatch1.1/level0tolevel1.sh ]; then
			echo '- $SEADAS/seabatch1.1/level0tolevel1.sh is executable'
		else
			echo; echo; echo 'ERROR: $SEADAS/seabatch1.1/level0tolevel1.sh is not executable'
			exit 1
		fi
	else
		echo; echo; echo 'ERROR: $SEADAS/seabatch1.1/level0tolevel1.sh does not exist'
		exit 1
	fi
fi
###########################################################################
###########################################################################


###########################################################################
###########################################################################
#Display and perform checks on variables used for LEVEL-1 to LEVEL-2 
#processing.
if [ $START_LEVEL -le 1 -a $END_LEVEL -ge 2 ]; then

	echo; echo; echo 'Variables used for LEVEL-1 to LEVEL-2 processing:'
	echo '- L2GEN_PRDCT_ARRAY:' ${L2GEN_PRDCT_ARRAY[@]}
	echo '- MODIS_L2GEN_RES:' $MODIS_L2GEN_RES
	
	echo; echo; echo 'Checks performed for LEVEL-1 to LEVEL-2 processing:'
	
	#Check that level1tolevel2.sh exists:
	if [ -e $SEADAS/seabatch1.1/level1tolevel2.sh ]; then
		echo '- $SEADAS/seabatch1.1/level1tolevel2.sh exists'
			
		#If level1tolevel2.sh exists check that it is executable:
		if [ -x $SEADAS/seabatch1.1/level1tolevel2.sh ]; then
			echo '- $SEADAS/seabatch1.1/level1tolevel2.sh is executable'
		else
			echo; echo; echo 'ERROR: $SEADAS/seabatch1.1/level1tolevel2.sh is not executable'
			exit 1
		fi
	else
		echo; echo; echo 'ERROR: $SEADAS/seabatch1.1/level1tolevel2.sh does not exist'
		exit 1
	fi
	
	echo 'L2GEN PRDCT_ARRAY'
	
	#Check that L2GEN PRDCT_ARRAY is not empty:
	if [ $L2GEN_PRDCT_AMNT -gt 0 ]; then
		echo '     - L2GEN_PRDCT_ARRAY is not empty'
	else
		echo; echo; echo 'ERROR: L2GEN_PRDCT_ARRAY is empty'
		exit 1
	fi
	
	#Check that MODIS_L2GEN_RES is valid (-1, 250, 500, or 1000):
	case $MODIS_L2GEN_RES in 
		-1 | 250 | 500 | 1000)
		echo '- MODIS_L2GEN_RES is valid'
		;;
		*) 
		echo; echo; echo 'ERROR: MODIS_L2GEN_RES is not valid (Must be -1, 250, 500, or 1000)'
		exit 1
		;;
	esac
	
fi
###########################################################################
###########################################################################


###########################################################################
###########################################################################
#Display and perform checks on variables used for LEVEL-2 to LEVEL-3 
#processing:
if [ $START_LEVEL -le 2 -a $END_LEVEL -ge 3 ]; then

	echo; echo; echo 'Variables used for LEVEL-2 to LEVEL-3 processing:'
	echo '- L2BIN_RES:' $L2BIN_RES
	echo '- TMPRL_AVG_ARRAY:' ${TMPRL_AVG_ARRAY[@]}
	
	echo; echo; echo 'Checks performed for LEVEL-2 to LEVEL-3 processing:'
	
	#Check that level2tolevel3.sh exists:
	if [ -e $SEADAS/seabatch1.1/level2tolevel3.sh ]; then
		echo '- $SEADAS/seabatch1.1/level2tolevel3.sh exists'
			
		#If level2tolevel3.sh exists check that it is executable:
		if [ -x $SEADAS/seabatch1.1/level2tolevel3.sh ]; then
			echo '- $SEADAS/seabatch1.1/level2tolevel3.sh is executable'
		else
			echo; echo; echo 'ERROR: $SEADAS/seabatch1.1/level2tolevel3.sh is not executable'
			exit 1
		fi
	else
		echo; echo; echo 'ERROR: $SEADAS/seabatch1.1/level2tolevel3.sh does not exist'
		exit 1
	fi
	
	#Check that L2BIN_RES is valid (H, 1, 2, 4, 9, or 36):
	case $L2BIN_RES in 
		H | 1 | 2 | 4 | 9 | 36)
		echo '- L2BIN_RES is valid'
		;;
		*) 
		echo; echo; echo 'ERROR: L2BIN_RES is not valid (Must be H, 1, 2, 4, 9, or 36)'
		exit 1
		;;
	esac
	
	echo 'TMPRL_AVG_ARRAY:'

	#Check that TMPRL_AVG_ARRAY is not empty:
	if [ $TMPRL_AVG_AMNT -gt 0 ]; then
		echo '     - TMPRL_AVG_ARRAY is not empty'
		
		#If TMPRL_AVG_ARRAY is not empty check that each temporal 
		#average is valid (DAY, 7D, 8D, MO, or NS):
		for (( g=0; g < $TMPRL_AVG_AMNT; g++ )); do
			case ${TMPRL_AVG_ARRAY[$g]} in 
				DAY | 7D | 8D | MO | NS)
				
				#If the temporal average is valid check
				#that it is unique:
				for DUMMY_TMPRL_AVG in ${DUMMY_TMPRL_AVG_ARRAY[@]}; do
					if [ ${TMPRL_AVG_ARRAY[$g]} = $DUMMY_TMPRL_AVG ]; then
						echo; echo; echo 'ERROR:' ${TMPRL_AVG_ARRAY[$g]} 'is not a unique temporal average'
						exit 1
					fi	
				done
				echo '     -' ${TMPRL_AVG_ARRAY[$g]} 'is valid'
				DUMMY_TMPRL_AVG_ARRAY[$g]=${TMPRL_AVG_ARRAY[$g]}
				;;
				*) 
				echo; echo; echo 'ERROR:' ${TMPRL_AVG_ARRAY[$g]} 'is not a valid temporal average (Must be DAY, 7D, 8D, MO, or NS)'
				exit 1
				;;
			esac
		done
		echo '     - All temporal averages are unique'
	else
		echo; echo; echo 'ERROR: TMPRL_AVG_ARRAY is empty'
		exit 1
	fi	
	
fi
###########################################################################
###########################################################################


###########################################################################
###########################################################################
#Display and perform checks on variables used for LEVEL-3 to LEVEL-4 
#processing:
if [ $END_LEVEL -eq 4 ]; then

	echo; echo; echo 'Variables used for LEVEL-3 to LEVEL-4 processing:'
	echo '- OUT_PRDCT_ARRAY:' ${OUT_PRDCT_ARRAY[@]}
	echo '- OUT_FTYPE_ARRAY:' ${OUT_FTYPE_ARRAY[@]}
	echo '- CT_SETTING:' $CT_SETTING
	echo '- CT_SUBDIR_ARRAY:' ${CT_SUBDIR_ARRAY[@]}
	echo '- CT_NUM_ARRAY:' ${CT_NUM_ARRAY[@]}

	echo; echo; echo 'Checks performed for LEVEL-3 to LEVEL-4 processing:'
	
	#Check that level3tolevel4_batchfile exists:
	if [ -e $SEADAS/seabatch1.1/level3tolevel4_batchfile ]; then
		echo '- $SEADAS/seabatch1.1/level3tolevel4_batchfile exists'
			
		#If level3tolevel4 exists check that it is executable:
		if [ -x $SEADAS/seabatch1.1/level3tolevel4_batchfile ]; then
			echo '- $SEADAS/seabatch1.1/level3tolevel4_batchfile is executable'
		else
			echo; echo; echo 'ERROR: $SEADAS/seabatch1.1/level3tolevel4_batchfile is not executable'
			exit 1
		fi
	else
		echo; echo; echo 'ERROR: $SEADAS/seabatch1.1/level3tolevel4_batchfile does not exist'
		exit 1
	fi
	
	CT_DIR=$SEADAS'/config/color_luts'
	
	#Check that CT_DIR exists:
	if [ -d $CT_DIR ]; then
		echo '- /config/color_luts exists'
	else
		echo; echo; echo 'ERROR: /config/color_luts does not exist'
		exit 1
	fi
	
	echo 'OUT_PRDCT_ARRAY:'
	
	#Check that OUT_PRDCT_ARRAY is not empty.
	if [ $OUT_PRDCT_AMNT -gt 0 ]; then
		echo '     - OUT_PRDCT_ARRAY is not empty'
	else
		echo; echo; echo 'ERROR: OUT_PRDCT_ARRAY is empty'
		exit 1
	fi
	
	echo 'OUT_FTYPE_ARRAY:'

	#Check that OUT_FTYPE_ARRAY is not empty:
	if [ $OUT_FTYPE_AMNT -gt 0 ]; then
		echo '     - OUT_FTYPE_ARRAY is not empty'
		
		#If OUT_FTYPE_ARRAY is not empty check that each output 
		#file type is valid (asc, flat, hdf, kmz, or png):
		for (( i=0; i < $OUT_FTYPE_AMNT; i++ )); do
			case ${OUT_FTYPE_ARRAY[$i]} in 
				asc | flat | hdf | kmz | png)
				
				#If the output file type is valid check 
				#that it is unique:
				for DUMMY_OUT_FTYPE in ${DUMMY_OUT_FTYPE_ARRAY[@]}; do
					if [ ${OUT_FTYPE_ARRAY[$i]} = $DUMMY_OUT_FTYPE ]; then
						echo; echo; echo 'ERROR:' ${OUT_FTYPE_ARRAY[$i]} 'is not a unique output file type'
						exit 1
					fi
				done
				echo '     -' ${OUT_FTYPE_ARRAY[$i]} 'is valid'
				DUMMY_OUT_FTYPE_ARRAY[$i]=${OUT_FTYPE_ARRAY[$i]}
				;;
				*) 
				echo; echo; echo 'ERROR:' ${OUT_FTYPE_ARRAY[$i]} 'is not a valid output file type (Must be asc, flat, hdf, kmz, or png)'
				exit 1
				;;
			esac
		done
		echo '     - All output file types are unique'
	else
		echo; echo; echo 'ERROR: OUT_FTYPE_ARRAY is empty'
		exit 1
	fi
	
	#Check that CT_SETTING is valid (default or custom):
	case $CT_SETTING in
		default | custom)
		echo '- CT_SETTING is valid'
		;;
		*)
		echo; echo; echo 'ERROR: CT_SETTING is not valid (Must be custom or default)'
		exit 1
	esac
	
	echo 'CT_SUBDIR_ARRAY:'
	
	#Check that CT_SUBDIR_ARRAY is not empty.
	if [ $CT_SUBDIR_AMNT -gt 0 ]; then
		echo '     - CT_SUBDIR_ARRAY is not empty'
		
		#If CT_SUBDIR_ARRAY is not empty and CT_SETTING is set to
		#default, check that CT_SUBDIR_ARRAY contains only one color
		#table directory.
		if [ $CT_SETTING = default ]; then
			if [ $CT_SUBDIR_AMNT -eq 1 ]; then
				echo '     - CT_SETTING is default and CT_SUBDIR_ARRAY size EQ 1'
			else
				echo; echo; echo 'ERROR: CT_SETTING is default but CT_SUBDIR_ARRAY size is GT 1'
				exit 1
			fi
		
		#If CT_SUBDIR_ARRAY is not empty and CT_SETTING is set to 
		#custom, check that CT_SUBDIR_ARRAY and OUT_PRDCT_ARRAY are 
		#the same size.
		else
			if [ $CT_SUBDIR_AMNT -eq $OUT_PRDCT_AMNT ]; then
				echo '     - CT_SETTING is custom and CT_SUBDIR_ARRAY size EQ OUT_PRDCT_ARRAY size'
			else
				echo; echo; echo 'ERROR: CT_SETTING is custom but CT_SUBDIR_ARRAY size NE OUT_PRDCT_ARRAY size'
				exit 1
			fi
		fi
		
		#If CT_SUBDIR_ARRAY is the correct size check that each 
		#color table sub-directory is valid (C, I, or S).
		for (( j=0; j < $CT_SUBDIR_AMNT; j++ )); do
			case ${CT_SUBDIR_ARRAY[$j]} in 
				C | I | S)
				echo '     -' ${CT_SUBDIR_ARRAY[$j]} 'is valid'
				if [ ${CT_SUBDIR_ARRAY[$j]} = C ]; then
					DUMMY_CT_SUBDIR_ARRAY[$j]=$CT_DIR'/custom'
				elif [ ${CT_SUBDIR_ARRAY[$j]} = I ]; then
					DUMMY_CT_SUBDIR_ARRAY[$j]=$CT_DIR'/idl'
				else
					DUMMY_CT_SUBDIR_ARRAY[$j]=$CT_DIR'/standard'
				fi
				;;
				*) 
				echo; echo; echo 'ERROR:' ${CT_SUBDIR_ARRAY[$j]} 'is not a valid color table sub-directory (Must be C, I, or S)'
				exit 1
				;;
			esac
		done
	else
		echo; echo; echo 'ERROR: CT_SUBDIR_ARRAY is empty'
		exit 1
	fi
	
	echo 'CT_NUM_ARRAY:'
	
	#Check that CT_NUM_ARRAY is not empty.
	if [ $CT_NUM_AMNT -gt 0 ]; then
		echo '     - CT_NUM_ARRAY is not empty'
		
		#If CT_NUM_ARRAY is not empty and CT_SETTING is set to 
		#default, check that CT_NUM_ARRAY contains only one color 
		#table number.
		if [ $CT_SETTING = default ]; then
			if [ $CT_NUM_AMNT -eq 1 ]; then
				echo '     - CT_SETTING is default and CT_NUM_ARRAY size EQ 1'
			else
				echo; echo; echo 'ERROR: CT_SETTING is default but CT_NUM_ARRAY size is GT 1'
				exit 1
			fi
		
		#If CT_NUM_ARRAY is not empty and CT_SETTING is set to 
		#custom, check that CT_NUM_ARRAY and OUT_PRDCT_ARRAY are the 
		#same size.
		else
			if [ $CT_NUM_AMNT -eq $OUT_PRDCT_AMNT ]; then
				echo '     - CT_SETTING is custom and CT_NUM_ARRAY size EQ OUT_PRDCT_ARRAY size'
			else
				echo; echo; echo 'ERROR: CT_SETTING is custom CT_NUM_ARRAY size NE OUT_PRDCT_ARRAY size'
				exit 1
			fi
		fi
		
		#If CT_NUM_AMNT is the correct size check that each color 
		#table number is valid:
		for (( k=0; k < $CT_NUM_AMNT; k++ )); do
			CT_AMNT=$(ls -1 ${DUMMY_CT_SUBDIR_ARRAY[$k]} | wc -l)
			
			if [ ${CT_NUM_ARRAY[$k]} -le $CT_AMNT ]; then
				echo '     - '${CT_NUM_ARRAY[$k]} 'is valid'
			else
				echo; echo; echo 'ERROR:' ${CT_NUM_ARRAY[$k]} 'is not a valid color table number for color table sub-directory' ${CT_SUBDIR_ARRAY[$k]}
				exit 1
			fi
		done	
	else
		echo; echo; echo 'ERROR: CT_NUM_ARRAY is empty'
		exit 1
	fi
	
	#Display the color table(s) that will be used:
	if [ $CT_SETTING = default ]; then
		CT=$(ls -1 ${DUMMY_CT_SUBDIR_ARRAY[0]} | head -${CT_NUM_ARRAY[0]} | tail -1)
		echo '- For all output products use color table' $CT
	else
		for (( l=0; l < $OUT_PRDCT_AMNT; l++)); do
			CT=$(ls -1 ${DUMMY_CT_SUBDIR_ARRAY[$l]} | head -${CT_NUM_ARRAY[$l]} | tail -1)
			echo '- For output product' ${OUT_PRDCT_ARRAY[$l]}' use color table' $CT
		done
	fi
		
fi	
###########################################################################
###########################################################################


echo; echo; echo '***** INITIAL CHECK COMPLETE *****'


exit 0

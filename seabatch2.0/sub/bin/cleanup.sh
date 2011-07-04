#!/bin/bash


#This script constructs sub-directories within OUT_DIR for each level of 
#processed data. The processed data files are then moved into the 
#appropriate location.


echo; echo; echo '***** CLEANING UP CURRENT DIRECTORY *****'
	

###########################################################################
###########################################################################
#Define variables read in from master_script.sh.
OUT_DIR=${1}
START_LEVEL=${2}
END_LEVEL=${3}
L2BIN_RES=${4}

TMPRL_AVG_AMNT=${5}
for (( a=0; a < $TMPRL_AVG_AMNT; a++ )); do
	PARAMETER=$(( 7 + $a + 1))
	eval TMPRL_AVG_ARRAY[$a]=\${$PARAMETER}
done

OUT_PRDCT_AMNT=${6}
for (( b=0; b < $OUT_PRDCT_AMNT; b++ )); do
	PARAMETER=$(( 7 + $TMPRL_AVG_AMNT + $b + 1))
	eval OUT_PRDCT_ARRAY[$b]=\${$PARAMETER}
done

OUT_FTYPE_AMNT=${7}
for (( c=0; c < $OUT_FTYPE_AMNT; c++ )); do
	PARAMETER=$(( 7 + $TMPRL_AVG_AMNT + $OUT_PRDCT_AMNT + $c + 1))
	eval OUT_FTYPE_ARRAY[$c]=\${$PARAMETER}
done

#Define other variables.
SENSOR=$(ls [AST]* | head -1 | awk '{ print substr( $0, 1, 1 ) }')
YEAR=$(ls [AST]* | head -1 | awk '{ print substr( $0, 2, 4 ) }')

#Display variables.
echo; echo; echo 'Variables used:'
echo '- OUT_DIR:' $OUT_DIR
echo '- START_LEVEL:' $START_LEVEL
echo '- END_LEVEL:' $END_LEVEL
echo '- L2BIN_RES:' $L2BIN_RES
echo '- TMPRL_AVG_AMNT:' $TMPRL_AVG_AMNT
echo '- TMPRL_AVG_ARRAY:' ${TMPRL_AVG_ARRAY[@]}
echo '- OUT_PRDCT_AMNT:' $OUT_PRDCT_AMNT
echo '- OUT_PRDCT_ARRAY:' ${OUT_PRDCT_ARRAY[@]}
echo '- OUT_FTYPE_AMNT:' $OUT_FTYPE_AMNT
echo '- OUT_FTYPE_ARRAY:' ${OUT_FTYPE_ARRAY[@]}
echo '- SENSOR:' $SENSOR
echo '- YEAR:' $YEAR
###########################################################################
###########################################################################


###########################################################################
###########################################################################
#Subtract START_LEVEL from END_LEVEL to determine the number of 
#sub-directories within OUT_DIR (ie L1, L2, or L3)to be constructed.
LEVEL_DIR_AMNT=$(( $END_LEVEL - $START_LEVEL ))

for (( d=1; d<=$LEVEL_DIR_AMNT; d++ )); do
	
	LEVEL=$(( $START_LEVEL + $d ))
	
	if [ $LEVEL -le 3 -o \( $LEVEL -eq 4 -a $START_LEVEL -eq 3 \) ]; then
	
		#If LEVEL is equal to 4, then reset it equal to 3.
		if [ $LEVEL -eq 4 ]; then
			LEVEL=3
		fi
	
		#Define LEVEL_DIR.
		LEVEL_DIR=$OUT_DIR/L$LEVEL
		
		#Construct "LEVEL_DIR".
		mkdir $LEVEL_DIR
	
		#If LEVEL is less than 3 then move all the files of that 
		#level into LEVEL_DIR.
		if [ $LEVEL -lt 3 ]; then
		
			echo; echo; echo '***** MOVING THE FOLLOWING LEVEL-'$LEVEL ' FILES *****'
			mv -v ${SENSOR}${YEAR}*.'L'${LEVEL}* $LEVEL_DIR
		
		#If LEVEL equals 3 then for each TMPRL_AVG construct a 
		#sub-directory of the following structure: 
		#"{OUT_DIR}/L3/{TMPRL_AVG}/".
		elif [ $LEVEL -eq 3 ]; then
	
			for TMPRL_AVG in ${TMPRL_AVG_ARRAY[@]}; do
				
				TMPRL_AVG_DIR=${LEVEL_DIR}/${TMPRL_AVG}
				mkdir $TMPRL_AVG_DIR
					
				#Move all the files of the structure 
				#"{SENSOR}{YEAR}*_{L2BIN_RES}_{TMPRL_AVG}.L3" 
				#into TMPRL_AVG_DIR.
				echo; echo; echo '***** MOVING THE FOLLOWING ' $TMPRL_AVG ' FILES *****'
				mv -v ${SENSOR}${YEAR}*_${L2BIN_RES}_$TMPRL_AVG.L3 $TMPRL_AVG_DIR
				
				#If END_LEVEL equals 4 then for each 
				#OUT_PRDCT construct a sub-directory of the 
				#following structure: 
				#"{OUT_DIR}/L3/{TMPRL_AVG}/{OUT_PRDCT}/".
				if [ $END_LEVEL -eq 4 ]; then
				
					for OUT_PRDCT in ${OUT_PRDCT_ARRAY[@]}; do
			
						OUT_PRDCT_DIR=$TMPRL_AVG_DIR/$OUT_PRDCT
						mkdir $OUT_PRDCT_DIR
				
						#For each OUT_FTYPE 
						#construct a sub-directory 
						#of the following structure: 
						#"{OUT_DIR}/L3/{TMPRL_AVG}/{OUT_PRDCT}/{OUT_FTYPE}/".
						for OUT_FTYPE in ${OUT_FTYPE_ARRAY[@]}; do
				
							OUT_FTYPE_DIR=$OUT_PRDCT_DIR/$OUT_FTYPE
							mkdir $OUT_FTYPE_DIR
						
							#Move all the files 
							#of the structure 
							#"{SENSOR}{YEAR}*_{L2BIN_RES}_{TMPRL_AVG}_{OUT_PRDCT}.{OUT_FTYPE}" 
							#into OUT_FTYPE_DIR.
							echo; echo; echo '***** MOVING THE FOLLOWING ' $TMPRL_AVG $OUT_PRDCT $OUT_FTYPE ' FILES *****'
							mv -v ${SENSOR}${YEAR}*_${L2BIN_RES}_${TMPRL_AVG}_${OUT_PRDCT}*.${OUT_FTYPE} $OUT_FTYPE_DIR
					
						done
						
					done
				
				fi 
				
			done
		
		fi
		
	fi
		
done


echo; echo; echo '***** CLEANUP COMPLETE *****'

exit 0

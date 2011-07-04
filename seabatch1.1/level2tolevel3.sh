#!/bin/bash


#This script spatially and temporally bins MODIS (Aqua and Terra) and 
#SeaWiFS Level-2 files.


echo; echo; echo '***** START LEVEL-2 TO LEVEL-3 PROCESSING *****'


###########################################################################
###########################################################################
#Specify the l2bin and l3bin parameter files.
L2BIN_PARFILE='l2bin_default_parfile'
L3BIN_PARFILE='l3bin_default_parfile'
###########################################################################
###########################################################################


###########################################################################
###########################################################################
#Define variables read in from master_script.sh.
L2BIN_RES=${1}
TMPRL_AVG_AMNT=${2}
for (( a=0; a < $TMPRL_AVG_AMNT; a++ )); do
	PARAMETER=$(( 2 + $a + 1))
	eval TMPRL_AVG_ARRAY[$a]=\${$PARAMETER}
done


#Define other variables.
SENSOR=$(ls *L2* | head -1 | awk '{ print substr( $0, 1, 1 ) }')
YEAR=$(ls *L2* | head -1 | awk '{ print substr( $0, 2, 4 ) }')

#Display variables.
echo; echo; echo 'Variables used:'
echo '- L2BIN_RES:' $L2BIN_RES
echo '- TMPRL_AVG_AMNT:' $TMPRL_AVG_AMNT
echo '- TMPRL_AVG_ARRAY:' ${TMPRL_AVG_ARRAY[@]}
echo '- SENSOR:' $SENSOR
echo '- YEAR:' $YEAR
###########################################################################
###########################################################################


###########################################################################
###########################################################################
#If L2BIN_PARFILE is set to "l2bin_default_parfile" then construct it.
#Otherwise check that the specified parameter file exists.
if [ $L2BIN_PARFILE = l2bin_default_parfile ]; then
	if [ $L2BIN_RES = .5 ]; then
		L2BIN_RES=H
	fi
	echo 'resolve='$L2BIN_RES > l2bin_default_parfile
	echo 'prodtype=regional' >> l2bin_default_parfile
	echo 'verbose=1' >> l2bin_default_parfile
elif [ ! -e $L2BIN_PARFILE ]; then
	echo; echo; echo 'ERROR: L2BIN_PARFILE does not exist'
	exit 1		
fi

#If L3BIN_PARFILE is set to "l3bin_default_parfile" then construct it.
#Otherwise check that the specified parameter file exists.
if [ $L3BIN_PARFILE = l3bin_default_parfile ]; then
	echo 'noext=1' > l3bin_default_parfile
elif [ ! -e $L3BIN_PARFILE ]; then
	echo; echo; echo 'ERROR: L3BIN_PARFILE does not exist'
	exit 1		
fi

echo; echo; echo 'L2BIN_PARFILE used:' $L2BIN_PARFILE
cat $L2BIN_PARFILE

echo; echo; echo 'L3BIN_PARFILE used:' $L3BIN_PARFILE
cat $L3BIN_PARFILE
###########################################################################
###########################################################################


###########################################################################
###########################################################################
#Spatially bin the Level-2 files using the SeaDAS script "l2bin".

for L2_FILE in [AST]*.L2_[GL]AC* S*.L2_MLAC*; do

	#Check that L2_FILE is a regular file. There are two situations
	#where it won't be: 1) If no files exist that match the pattern
	#"[AST]*.L2A_[GL]AC*" or 2) If no files exist that match the 
	#pattern "S*.L2A_MLAC*. If L2_FILE is not a regular file then the 
	#current itteration of the loop stops, and the next one begins.
	if [ ! -f $L2_FILE ]; then
		continue
	fi
	
	#Define the filename of the spatially binned file. The filename 
	#consists of the base of the input Level-2 filename, followed by
	#"_L2BIN_RES.L2b".
	echo; echo; echo '***** CURRENT LEVEL-2 FILE:' $L2_FILE '*****'
	BASE=$(echo $L2_FILE | awk -F. '{ print $1 }')
	L2BIN_FILE=${BASE}_${L2BIN_RES}.L2b
		
	#Use the script "l2bin" to spatially bin the Level-2 file.	
	echo; echo; echo '***** CONSTRUCTING' $L2BIN_FILE '*****'; echo;echo
	l2bin infile=$L2_FILE ofile=$L2BIN_FILE parfile=$L2BIN_PARFILE
	if [ $? -ne 0 ]; then
		ls $L2_FILE >> l2bin_error.txt
	fi
	
done

#If L2BIN_PARFILE is set to l2bin_default_parfile remove it.
if [ $L2BIN_PARFILE = l2bin_default_parfile ]; then
	rm $L2BIN_PARFILE
fi
###########################################################################
###########################################################################
	
	
###########################################################################
###########################################################################
#Initialize "YD_ARRAY", whose elements range from year days 001-366 (NOTE: 
#January 1st is YD 001, and December 31st is YD 365, or YD 366 for leap 
#years). The elements of "YD_ARRAY" will be referenced to select the proper 
#files when creating the temporal averages.
for (( b=0; b<=365; b++ )); do
	if [ $b -lt 9 ]; then
		YD_ARRAY[$b]='00'$(( $b + 1 ))
	elif [ $b -ge 9 ] && [ $b -lt 99 ]; then
		YD_ARRAY[$b]='0'$(( $b + 1 ))
	elif [ $b -ge 99 ]; then
		YD_ARRAY[$b]=$(( $b + 1 ))
	fi	
done
###########################################################################
###########################################################################


#Temporally bin the "*.L2bin" files using the SeaDAS script
#"l3bin".	
for TMPRL_AVG in ${TMPRL_AVG_ARRAY[@]}; do		
###########################################################################
###########################################################################
	#If TMPRL_AVG_ARRAY contains the element "DAY" then temporally 
	#bin the "*.L2bin" files into daily averages.	
	if [ $TMPRL_AVG = DAY ]; then
			
		echo; echo; echo '***** CONSTRUCTING DAILY AVERAGES *****'
			
		#For each YD in YD_ARRAY, list all of the "*.L2bin" 
		#files of that year day. This list is output to the file 
		#"l3bin_DAYlist.txt".
		for YD in ${YD_ARRAY[@]}; do 
			
			echo; echo; echo '***** LISTING ALL' ${SENSOR}${YEAR}${YD}'*.L2b FILES *****'
			ls ${SENSOR}${YEAR}${YD}*.L2b | tee -a l3bin_DAYlist.txt
		
			#If "l3bin_DAYlist.txt" is not empty (ie "*.L2bin" 
			#files exist for that year day),then it is input to 
			#the SeaDAS script "l3bin", which temporally bins 
			#the files listed.			
			if [ -s l3bin_DAYlist.txt ]; then
		
				L3BIN_DAYFILE=${SENSOR}${YEAR}${YD}_${L2BIN_RES}_DAY.L3
					
				echo; echo; echo '***** CONSTRUCTING' $L3BIN_DAYFILE '*****'; echo; echo
				l3bin in=l3bin_DAYlist.txt out=$L3BIN_DAYFILE parfile=$L3BIN_PARFILE
				if [ $? -ne 0 ]; then
					echo; echo; echo '***** ERROR: DAILY TEMPORAL BINNING STOPPED ON' $L3BIN_DAYFILE '*****'
					rm l3bin_DAYlist.txt
					exit 1
				fi
					
			fi

			rm l3bin_DAYlist.txt
		
		done
		
	fi
###########################################################################
###########################################################################	
			
			
###########################################################################
###########################################################################	
	#If TMPRL_AVG_ARRAY contains the element "7D" then temporally bin 
	#the "*.L2bin" files into 7-day averages.
			
	if [ $TMPRL_AVG = 7D ]; then
		
		echo; echo; echo '***** CONSTRUCTING 7DAY AVERAGES *****'
	
		SEVENDAY_COUNT=0
	
		#If a year is split into 7-day periods, there are 52. The 
		#first ranges from YD 001 to 007, while the last ranges 
		#from YD 358 to 364.	
		for (( c=1; c<=52; c++ )); do
	
			echo; echo; echo '***** CONSTRUCTING 7DAY AVERAGE #'$c '*****'
	
			#For each SEVENDAY_YD of the current 7-day period,
			#list all of the corresponding "*.L2b" files and 
			#append them to the file "l3bin_7Dlist". Note that 
			#SEVENDAY_COUNT is initially 0, but is incremented 
			#by 1 each time through the proceeding loop.
			#SEVENDAY_COUNT is used to index YD_ARRAY and 
			#define SEVENDAY_YD. Finally, if d is 1 or 7 then  
			#the first or second element respectively of 
			#SEVENDAY_SEDAY_ARRAY is set equal to SEVENDAY_YD. 
			#The two elements of SEVENDAY_SEDAY_ARRAY are used 
			#when constructing the filename of that 7-day 
			#average.		
			for (( d=1; d<=7; d++ )); do
		
				SEVENDAY_YD=${YD_ARRAY[$SEVENDAY_COUNT]}
					
				echo; echo; echo '*****LISTING ALL' ${SENSOR}${YEAR}${SEVENDAY_YD}'*.L2b *****'
				ls ${SENSOR}${YEAR}${SEVENDAY_YD}*.L2b | tee -a l3bin_7Dlist.txt
					
				if [ $d -eq 1 ]; then
					SEVENDAY_SEDAY_ARRAY[0]=$SEVENDAY_YD
				elif [ $d -eq 7 ]; then
					SEVENDAY_SEDAY_ARRAY[1]=$SEVENDAY_YD
				fi
			
				let SEVENDAY_COUNT+=1
		
			done
	
			#If "l3bin_7Dlist.txt" is not empty (ie "*.L2bin"
			#files exist for that 7-day period),then it is input
			#to the SeaDAS script "l3bin", which temporally bins 
			#the files listed.	
			if [ -s l3bin_7Dlist.txt ]; then
				
				L3BIN_7DFILE=$SENSOR$YEAR${SEVENDAY_SEDAY_ARRAY[0]}$YEAR${SEVENDAY_SEDAY_ARRAY[1]}_${L2BIN_RES}_7D.L3
					
				echo; echo; echo '***** CONSTRUCTING' $L3BIN_7DFILE '*****'; echo; echo
				l3bin in=l3bin_7Dlist.txt out=$L3BIN_7DFILE parfile=$L3BIN_PARFILE
				if [ $? -ne 0 ]; then
					echo; echo; echo '***** ERROR: SEVEN-DAY TEMPORAL BINNING STOPPED ON' $L3BIN_7DFILE '*****'
					rm l3bin_7Dlist.txt
					exit 1
				fi
			fi
		
			rm l3bin_7Dlist.txt
					
		done
			
	fi
###########################################################################
###########################################################################

	
###########################################################################
###########################################################################	
	#If TMPRL_AVG_ARRAY contains the element "8D" then temporally bin 
	#the "*.L2bin" files into 8-day averages.
			
	if [ $TMPRL_AVG = 8D ]; then
		
		echo; echo; echo '***** CONSTRUCTING 8DAY AVERAGES *****'
	
		EIGHTDAY_COUNT=0
	
		#If a year is split into 8-day periods, there are 45. The 
		#first ranges from YD 001 to 008, while the last ranges 
		#from YD 353 to 360.	
		for (( e=1; e<=45; e++ )); do
	
			echo; echo; echo '***** CONSTRUCTING 8DAY AVERAGE #'$e '*****'
	
			#For each EIGHTDAY_YD of the current 8-day period,
			#list all of the corresponding "*.L2b" files and 
			#append them to the file "l3bin_8Dlist". Note that 
			#EIGHTDAY_COUNT is initially 0, but is incremented 
			#by 1 each time through the proceeding loop.
			#EIGHTDAY_COUNT is used to index YD_ARRAY and 
			#define EIGHTDAY_YD. Finally, if f is 1 or 8 then  
			#the first or second element respectively of 
			#EIGHTDAY_SEDAY_ARRAY is set equal to EIGHTDAY_YD. 
			#The two elements of EIGHTDAY_SEDAY_ARRAY are used 
			#when constructing the filename of that 8-day 
			#average.		
			for (( f=1; f<=8; f++ )); do
		
				EIGHTDAY_YD=${YD_ARRAY[$EIGHTDAY_COUNT]}
					
				echo; echo; echo '*****LISTING ALL' ${SENSOR}${YEAR}${EIGHTDAY_YD}'*.L2b *****'
				ls ${SENSOR}${YEAR}${EIGHTDAY_YD}*.L2b | tee -a l3bin_8Dlist.txt
					
				if [ $f -eq 1 ]; then
					EIGHTDAY_SEDAY_ARRAY[0]=$EIGHTDAY_YD
				elif [ $f -eq 8 ]; then
					EIGHTDAY_SEDAY_ARRAY[1]=$EIGHTDAY_YD
				fi
			
				let EIGHTDAY_COUNT+=1
		
			done
	
			#If "l3bin_8Dlist.txt" is not empty (ie "*.L2bin"
			#files exist for that 8-day period),then it is input
			#to the SeaDAS script "l3bin", which temporally bins 
			#the files listed.	
			if [ -s l3bin_8Dlist.txt ]; then
				
				L3BIN_8DFILE=$SENSOR$YEAR${EIGHTDAY_SEDAY_ARRAY[0]}$YEAR${EIGHTDAY_SEDAY_ARRAY[1]}_${L2BIN_RES}_8D.L3
					
				echo; echo; echo '***** CONSTRUCTING' $L3BIN_8DFILE '*****'; echo; echo
				l3bin in=l3bin_8Dlist.txt out=$L3BIN_8DFILE parfile=$L3BIN_PARFILE
				if [ $? -ne 0 ]; then
					echo; echo; echo '***** ERROR: EIGHT-DAY TEMPORAL BINNING STOPPED ON' $L3BIN_8DFILE '*****'
					rm l3bin_8Dlist.txt
					exit 1
				fi
			fi
		
			rm l3bin_8Dlist.txt
					
		done
			
	fi
###########################################################################
###########################################################################
				
					
###########################################################################
###########################################################################
	#If "TMPRL_AVG_ARRAY" contains the element "MO" then temporally bin 
	#the "*.L2b" files into monthly averages.
				
		if [ $TMPRL_AVG = MO ]; then
		
			echo; echo; echo '***** CONSTRUCTING MONTHLY AVERAGES *****'
		
			MONTH_COUNT=0
	
			#MONTH_YD_AMNT_ARRAY is a 12 element array where 
			#each element is the number of year days of that 
			#month. If YEAR" is divisible by 4 then it is a 
			#leap year and February has 29 days instead of 28.
			if [ `expr $YEAR % 4` -eq 0 ]; then
					MONTH_YD_AMNT_ARRAY=(31 29 31 30 31 30 31 31 30 31 30 31)
				else 
					MONTH_YD_AMNT_ARRAY=(31 28 31 30 31 30 31 31 30 31 30 31)
			fi
			
			#There are 12 months in a year.
			for (( g=0; g<=11; g++ )); do
			
				echo; echo; echo '***** CONSTRUCTING MONTHLY AVERAGE #'$(( g + 1 )) '*****'
		
				#For each month go through the proceeding
				#loop an amount of times equal to the 
				#number of year days it has. Each time list 
				#all the "*.L2b" files that correspond to 
				#MONTH_YD and append them to the file 
				#"l3bin_MOlist.txt". Note that MONTH_COUNT 
				#is initially 0,but is incremented by 1 each 
				#time through the proceeding loop.
				#MONTH_COUNT is used to index YD_ARRAY 
				#and define MONTH_YD. Finally, if h is 1 
				#or the amount of year days of that month, 
				#then the first or second element 
				#respectively of MONTH_SEDAY_ARRAY is set 
				#equal to MONTH_YD. The two elements of 
				#MONTH_SEDAY_ARRAY are used when 
				#constructing the filename of that monthly 
				#average.	
				for (( h=1; h<=${MONTH_YD_AMNT_ARRAY[$g]}; h++)); do
			
					MONTH_YD=${YD_ARRAY[$MONTH_COUNT]}
					
					echo; echo; echo '***** LISTING ALL' ${SENSOR}${YEAR}${MONTH_YD}'*.L2b *****'
					ls ${SENSOR}${YEAR}${MONTH_YD}*.L2b | tee -a l3bin_MOlist.txt
			
					if [ $h -eq 1 ]; then
						MONTH_SEDAY_ARRAY[0]=$MONTH_YD
					elif [ $h -eq ${MONTH_YD_AMNT_ARRAY[$g]} ]; then
						MONTH_SEDAY_ARRAY[1]=$MONTH_YD
					fi
				
					let MONTH_COUNT+=1
					
				done
			
				#If "l3bin_MOlist.txt" is not empty (ie 
				#"*.L2bin" files exist for that month), then
				#it is input to "l3bin", which temporally 
				#bins the files listed.
			
				if [ -s l3bin_MOlist.txt ]; then
				
					L3BIN_MOFILE=${SENSOR}${YEAR}${MONTH_SEDAY_ARRAY[0]}${YEAR}${MONTH_SEDAY_ARRAY[1]}_${L2BIN_RES}_MO.L3
					
					echo; echo; echo '***** CONSTRUCTING' $L3BIN_MOFILE '*****'; echo; echo
					l3bin in=l3bin_MOlist.txt out=$L3BIN_MOFILE parfile=$L3BIN_PARFILE
					if [ $? -ne 0 ]; then
						echo; echo; echo '***** ERROR: MONTHLY TEMPORAL BINNING STOPPED ON' $L3BIN_MOFILE '*****'
						rm l3bin_MOlist.txt
						exit 1
					fi
					
				fi
		
				rm l3bin_MOlist.txt
				
			done
			
		fi
###########################################################################
###########################################################################


###########################################################################
###########################################################################

	#If TMPRL_AVG_ARRAY contains the element "NS" then temporally bin 
	#ALL the "*.L2b" files into a non-standard average.
	if [ $TMPRL_AVG = NS ]; then
				
		echo; echo; echo '***** CONSTRUCTING NON-STANDARD AVERAGE *****'
		
		#List all the "*.L2b" files in the current directory, and 
		#output them to the file "l3bin_NSlist.txt".
		echo; echo; echo '***** LISTING ALL' ${SENSOR}${YEAR}'*.L2b *****'
		ls ${SENSOR}${YEAR}*.L2b | tee -a l3bin_NSlist.txt
			
		#If "l3bin_NSlist.txt" is not empty (ie "*.L2b" files 
		#exist in the current directory),then it is input to "l3bin" 
		#which temporally bins the files listed.	
		if [ -s l3bin_NSlist.txt ]; then
			
			#The temporal bounds of the non-standard average are 
			#determined by cutting the year day out of the first 
			#and last file listed in "l3bin_NSlist.txt". These 
			#values are placed in the first and second elements 
			#respectively of NS_SEDAY_ARRAY.
			NS_SEDAY_ARRAY[0]=$(cat l3bin_NSlist.txt | head -1 | awk '{ print substr( $0, 6, 3 ) }')
			NS_SEDAY_ARRAY[1]=$(cat l3bin_NSlist.txt | tail -1 | awk '{ print substr( $0, 6, 3 ) }')
				
			L3BIN_NSFILE=${SENSOR}${YEAR}${NS_SEDAY_ARRAY[0]}${YEAR}${NS_SEDAY_ARRAY[1]}_${L2BIN_RES}_NS.L3
				
			echo; echo; echo '*****CONSTRUCTING' $L3BIN_NSFILE '*****'; echo; echo
			l3bin in=l3bin_NSlist.txt out=$L3BIN_NSFILE parfile=$L3BIN_PARFILE
			if [ $? -ne 0 ]; then
				echo; echo; echo '***** ERROR: NON_STANDARD TEMPORAL BINNING STOPPED ON' $L3BIN_NSFILE '*****'
				rm l3bin_NSlist.txt
				exit 1
			fi
				
		fi
			
		rm l3bin_NSlist.txt
		
	fi
###########################################################################
###########################################################################
done
	
		
#If L3BIN_PARFILE is set to l3bin_default_parfile remove it.
if [ $L3BIN_PARFILE = l3bin_default_parfile ]; then
	rm $L3BIN_PARFILE
fi

#Remove the spatially binned Level-2 files.
rm *.L2b

	
echo; echo; echo '***** LEVEL-2 TO LEVEL-3 PROCESSING COMPLETE *****'
		
			
exit 0

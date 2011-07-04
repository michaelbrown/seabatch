#!/bin/bash




###########################################################################
###########################################################################	
#If L2BIN_PARFILE is set to l2bin_default_parfile remove it.
if [ $L2BIN_PARFILE = l2bin_default_parfile ]; then
	rm $L2BIN_PARFILE
fi
###########################################################################
###########################################################################


###########################################################################
###########################################################################
#Check to see whether any spatially-binned Level-2 files (those that match 
#the pattern "*.L2b") were generated. There is one situation when none 
#would have been generated: if l2bin errors on all of the Level-2 files. If
#this is the case then SeaBatch errors.

L2BIN_FILE_AMNT=$(ls *.L2b 2>/dev/null | wc -l)
if [ $L2BIN_FILE_AMNT -eq 0 ]; then
	rm $L3BIN_PARFILE
	echo; echo; echo '***** Error: No spatially-binned Level-2 files were generated. *****'
	echo; echo; echo 'Exiting' $SEADAS'/seabatch1.2/level2tolevel3.sh... Exit status: 1.'
	exit 1
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


#Temporally bin the "*.L2bin" files using the SeaDAS script "l3bin".	
for TMPRL_AVG in ${TMPRL_AVG_ARRAY[@]}; do		
###########################################################################
###########################################################################
	#If TMPRL_AVG_ARRAY contains the element "DAY" then temporally 
	#bin the "*.L2bin" files into daily averages.	
	if [ $TMPRL_AVG = DAY ]; then
			
		echo; echo; echo '***** Constructing daily averages... *****'
			
		#For each YD in YD_ARRAY, list all of the "*.L2bin" 
		#files of that year day. This list is output to the file 
		#"l3bin_DAYlist.txt".
		for YD in ${YD_ARRAY[@]}; do 
			
			echo; echo; echo '***** Listing all' ${SENSOR}${YEAR}${YD}'*.L2b files... *****'
			ls ${SENSOR}${YEAR}${YD}*.L2b | tee -a l3bin_DAYlist.txt
		
			#If "l3bin_DAYlist.txt" is not empty (ie "*.L2bin" 
			#files exist for that year day),then it is input to 
			#the SeaDAS script "l3bin", which temporally bins 
			#the files listed.			
			if [ -s l3bin_DAYlist.txt ]; then
		
				L3BIN_DAYFILE=${SENSOR}${YEAR}${YD}_${L2BIN_RES}_DAY.L3
					
				echo; echo; echo '***** Constucting' $L3BIN_DAYFILE'... *****'; echo; echo
				l3bin in=l3bin_DAYlist.txt out=$L3BIN_DAYFILE parfile=$L3BIN_PARFILE
				if [ $? -ne 0 ]; then
					rm l3bin_DAYlist.txt
					echo; echo; echo '***** Error: l3bin failed on' $L3BIN_DAYFILE'. *****'
					echo; echo; echo 'Exiting' $SEADAS'/seabatch1.2/level2tolevel3.sh... Exit status: 1.'
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
		
		echo; echo; echo '***** Constructing 7-day averages... *****'
	
		SEVENDAY_COUNT=0
	
		#If a year is split into 7-day periods, there are 52. The 
		#first ranges from YD 001 to 007, while the last ranges 
		#from YD 358 to 364.	
		for (( c=1; c<=52; c++ )); do
	
			echo; echo; echo '***** Constructing 7-day average #'$c'... *****'
	
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
					
				echo; echo; echo '***** Listing all' ${SENSOR}${YEAR}${SEVENDAY_YD}'*.L2b... *****'
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
					
				echo; echo; echo '***** Constructing' $L3BIN_7DFILE'... *****'; echo; echo
				l3bin in=l3bin_7Dlist.txt out=$L3BIN_7DFILE parfile=$L3BIN_PARFILE
				if [ $? -ne 0 ]; then
					rm l3bin_7Dlist.txt
					echo; echo; echo '***** Error: l3bin failed on' $L3BIN_7DFILE'. *****'
					echo; echo; echo 'Exiting' $SEADAS'/seabatch1.2/level2tolevel3.sh... Exit status: 1.'
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
		
		echo; echo; echo '***** Constructing 8-day averages... *****'
	
		EIGHTDAY_COUNT=0
	
		#If a year is split into 8-day periods, there are 45. The 
		#first ranges from YD 001 to 008, while the last ranges 
		#from YD 353 to 360.	
		for (( e=1; e<=45; e++ )); do
	
			echo; echo; echo '***** Constructing 8-day average #'$e'... *****'
	
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
					
				echo; echo; echo '***** Listing all' ${SENSOR}${YEAR}${EIGHTDAY_YD}'*.L2b... *****'
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
					
				echo; echo; echo '***** Constructing' $L3BIN_8DFILE'... *****'; echo; echo
				l3bin in=l3bin_8Dlist.txt out=$L3BIN_8DFILE parfile=$L3BIN_PARFILE
				if [ $? -ne 0 ]; then
					rm l3bin_8Dlist.txt
					echo; echo; echo '***** Error: l3bin failed on' $L3BIN_8DFILE'. *****'
					echo; echo; echo 'Exiting' $SEADAS'/seabatch1.2/level2tolevel3.sh... Exit status: 1.'
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
		
			echo; echo; echo '***** Constructing monthly averages... *****'
		
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
			
				echo; echo; echo '***** Constructing monthly average #'$(( g + 1 ))'... *****'
		
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
					
					echo; echo; echo '***** Listing all' ${SENSOR}${YEAR}${MONTH_YD}'*.L2b... *****'
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
					
					echo; echo; echo '***** Constructing' $L3BIN_MOFILE'... *****'; echo; echo
					l3bin in=l3bin_MOlist.txt out=$L3BIN_MOFILE parfile=$L3BIN_PARFILE
					if [ $? -ne 0 ]; then
						rm l3bin_MOlist.txt
						echo; echo; echo '***** Error: l3bin failed on' $L3BIN_MOFILE'. *****'
						echo; echo; echo 'Exiting' $SEADAS'/seabatch1.2/level2tolevel3.sh... Exit status: 1.'
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
				
		echo; echo; echo '***** Constructing non-standard average... *****'
		
		#List all the "*.L2b" files in the current directory, and 
		#output them to the file "l3bin_NSlist.txt".
		echo; echo; echo '***** Listing all' ${SENSOR}${YEAR}'*.L2b... *****'
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
				
			echo; echo; echo '***** Constructing' $L3BIN_NSFILE'... *****'; echo; echo
			l3bin in=l3bin_NSlist.txt out=$L3BIN_NSFILE parfile=$L3BIN_PARFILE
			if [ $? -ne 0 ]; then
				rm l3bin_NSlist.txt
				echo; echo; echo '***** Error: l3bin failed on' $L3BIN_NSFILE '*****'
				echo; echo; echo 'Exiting' $SEADAS'/seabatch1.2/level2tolevel3.sh... Exit status: 1.'
				exit 1
			fi
				
		fi
			
		rm l3bin_NSlist.txt
		
	fi
###########################################################################
###########################################################################
done

	
###########################################################################
###########################################################################		
#Reove any ".L2b" files. If L3BIN_PARFILE is set to l3bin_default_parfile 
#remove it.

#rm *.l2b

if [ $L3BIN_PARFILE = l3bin_default_parfile ]; then
	rm $L3BIN_PARFILE
fi
###########################################################################
###########################################################################


###########################################################################
###########################################################################
#Define L3_FILE_AMNT, the number of Level-3 files (those files that match 
#the pattern "[AST]*_*_*.L3") that exist in the current directory. If 
#L3_FILE_AMNT is 0, and END_LEVEL is greater than 3, then this indicates 
#that no Level-3 files exist for Level-3 to Level-4 processing. In this 
#case SeaBatch errors.There is one situation when no extracted Level-3 
#files would have been generated: if l2bin errors on all of the Level-2 
#files.

L3_FILE_AMNT=$(ls [AST]*_*_*.L3 2>/dev/null | wc -l)

if [ $L3_FILE_AMNT -eq 0 ]; then
	if [ $END_LEVEL -eq 3 ]; then
		echo; echo; echo '***** Warning: No Level-3 files were generated. *****'
		echo; echo; echo 'Exiting' $SEADAS'/seabatch1.2/level2tolevel3.sh... Exit status: 0.'
		echo; echo; echo '***** Level-2 to Level-3 processing complete. *****'
		exit 0
	else
		echo; echo; echo '***** Error: No Level-3 files were generated for Level-3 to Level-4 processing. *****'
		echo; echo; echo 'Exiting' $SEADAS'/seabatch1.2/level2tolevel3.sh... Exit status: 1.'
		exit 1
	fi
else
	if [ $END_LEVEL -eq 3 ]; then
		echo; echo $L3_FILE_AMNT' Level-3 file(s) generated.'
		echo; echo 'Exiting' $SEADAS'/seabatch1.2/level2tolevel3.sh... Exit status: 0.'
		echo; echo; echo '***** Level-2 to Level-3 processing complete. *****'
		exit 0
	else
		echo; echo $L3_FILE_AMNT' Level-3 file(s) generated for Level-3 to Level-4 processing.'
		echo; echo 'Exiting' $SEADAS'/seabatch1.2/level2tolevel3.sh... Exit status: 0.'
		echo; echo; echo '***** Level-2 to Level-3 processing complete. *****'
		exit 0
	fi
fi
###########################################################################
###########################################################################

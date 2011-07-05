#!/bin/bash

function continue_prompt {
	
	CONTINUE=NO
	while [ $CONTINUE = 'NO' ]; do

		echo ''
		echo -n 'Would you like to continue? Enter "y" or "n": '
		read INPUT
	
		case $INPUT in
	
			'y')
				CONTINUE='YES'
			;;
		
			'n')
				echo ''
				echo 'Exiting ...'
				exit
			;;
		
			*)
				clear
				echo 'Invalid response (must be "y" or "n").'
		
		esac
	
	done
	
}	

clear

echo 'Thank you for downloading SeaBatch 2.0!'
echo ''
echo 'This script installs SeaBatch on your system.'

continue_prompt

WORKING_DIRECTORY=$PWD

clear
echo 'Step 1 of 3: Identify SeaBatch Installation Location'
echo ''
echo 'You have chosen to install SeaBatch in the following directory:' 
echo ''
echo $WORKING_DIRECTORY

continue_prompt

clear
echo 'Step 2 of 3: Determine Existence of Configuration Files'

if [ -e ~/.bashrc ]; then

	echo ''
	echo 'The configuration file ~/.bashrc exists.'
	
	continue_prompt
	
else 

	echo ''
	echo 'The configuration file ~/.bashrc does NOT exist.'
	echo ''
	echo 'It is necessary to construct this file.'
	echo ''
	echo 'To accomplish this the following command will be entered:'
	echo ''
	echo 'touch ~/.bashrc'
	
	continue_prompt
	
	touch ~/.bashrc
	
fi

clear
echo 'Step 3 of 3: Modify Configuration Files'
echo ''
echo 'It is necessary to append the following lines to the file ~/.bashrc:'
echo ''
echo 'export SEABATCH='${WORKING_DIRECTORY}
echo 'source ${SEABATCH}/sub/env/seabatch.env'
echo ''
echo 'To accomplish this the following commands will be entered:'
echo ''
echo 'echo' \'\' ' >> ~/.bashrc'
echo 'echo' \''export SEABATCH='\'${WORKING_DIRECTORY} '>> ~/.bashrc'
echo 'echo' \''source ${SEABATCH}/sub/env/seabatch.env'\' '>> ~/.bashrc'

continue_prompt

echo '' >> ~/.bashrc
echo 'export SEABATCH='${WORKING_DIRECTORY} >> ~/.bashrc
echo 'source ${SEABATCH}/sub/env/seabatch.env' >> ~/.bashrc	
			




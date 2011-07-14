#!/bin/bash




##########################################################################
##########################################################################
function prompt {
	
	VALID_INPUT=NO
	while [ $VALID_INPUT = 'NO' ]; do

		echo ''
		echo -n 'Enter "c" to continue or "q" to quit: '
		read INPUT
	
		case $INPUT in
	
			'c')
				VALID_INPUT='YES'
				ACTION='CONTINUE'
			;;
		
			'q')
				VALID_INPUT='YES'
				ACTION='QUIT'
			;;
		
			*)
				echo ''				
				echo 'Invalid response! (must be "c" or "q").'

		esac
	
	done
	
}
##########################################################################
##########################################################################




##########################################################################
##########################################################################
clear

echo 'Thank you for downloading SeaBatch 2.0!'
echo ''
echo 'This script will install SeaBatch on your system.'

prompt

if [ $ACTION = 'EXIT' ]; then
	echo ''
	echo 'Exiting ...'
	exit 
fi

echo ''
echo 'Beginning the installation ...'
##########################################################################
##########################################################################




##########################################################################
##########################################################################
WORKING_DIRECTORY=$PWD

echo ''
echo 'Step 1 of 5: Identify SeaBatch Installation Location'
echo ''
echo 'You have chosen to install SeaBatch here:' $WORKING_DIRECTORY | fold -s -w75
echo ''
echo 'If this is OK then continue the installation.'
echo ''
echo 'If NOT then quit, and refer to the "Installation" section of the manual to start the installation over.' | fold -s -w75 

prompt

if [ $ACTION = 'EXIT' ]; then
	echo ''
	echo 'Exiting ...'
	exit 
fi

INSTALLATION_STEP=0

echo ''
echo 'Step 2 of 5: Identify Unix Shell Environment'
echo ''
echo 'Currently SeaBatch can only be installed on systems utilizing bash as the Unix shell environment' | fold -s -w75 
echo ''
echo 'Your UNIX shell environment is set to:' $SHELL
	
	case $SHELL in

		'/bin/bash')
			
			echo ''
			echo 'This is valid. Continuing the installation ...'

		*)

			echo ''
			echo ''

fi

if [ $ACTION = 'CONTINUE' ]; then

	WORKING_DIRECTORY=$PWD

	clear
	
	echo 'Step 1 of 4: Identify SeaBatch Installation Location'
	echo ''
	echo 'You have chosen to install SeaBatch in the following directory:' 
	echo ''
	echo $WORKING_DIRECTORY
	echo ''
	echo 'If this is OK then continue.'
	echo ''
	echo 'If NOT then quit, and refer to the "Installation" section of the manual to start the installation over.' | fold -s -w75 

	prompt
	
	INSTALLATION_STEP=1
	
fi

if [ $ACTION = 'CONTINUE' ]; then

	clear
	
	echo 'Step 2 of 4: Determine Existence of Configuration Files'
	echo ''
	echo 'Installation of SeaBatch on your system involves modifying your ~/.bashrc configuration file.' | fold -s -w75

	if [ -e ~/.bashrc ]; then

		echo ''
		echo 'Your ~/.bashrc configuration file exists. You may continue the installation.'
	
		prompt
	
	else 

		echo ''
		echo 'Your ~/.bashrc configuration file does NOT exist.'
		echo ''
		echo 'It is necessary to construct this file.'
		echo ''
		echo 'To accomplish this the following command will be entered:'
		echo ''
		echo 'touch ~/.bashrc'
		echo ''
		echo 'If this is OK then continue.'
		echo ''
		echo 'If NOT then quit, and you will be given directions to finish the installation manually.' | fold -s -w75 

		prompt
		
		if [ $ACTION = 'CONTINUE' ]; then
			touch ~/.bashrc
		fi
		
		INSTALLATION_STEP=2
	
	fi

fi

if [ $ACTION = 'CONTINUE' ]; then

	clear
	
	echo 'Step 3 of 4: Clean Up Configuration Files'
	echo ''
	echo 'It is necessary to remove any lines in your ~/.bashrc file that reference SeaBatch' | fold -s -w75
	echo ''
	echo 'Searching for lines ...'
	echo ''
	grep -i 'SEABATCH' ~/.bashrc
	echo ''
	
	if [ $? -ne 0 ]; then
		echo 'None exist. You may continue the installation.'
	fi
	
	if [ $? -eq 0 ]; then
	
		echo 'It is necessary to remove the 
		
	
	
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
			




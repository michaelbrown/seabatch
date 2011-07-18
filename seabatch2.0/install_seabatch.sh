#!/bin/bash




###########################################################################
###########################################################################
#Source the contents of "./sub/cfg".

for SEABATCH_CONFIGURATION_FILE in ./sub/cfg/*; do
	source $SEABATCH_CONFIGURATION_FILE
done
###########################################################################
###########################################################################




##########################################################################
##########################################################################
function prompt {
	
	PROMPT_AMOUNT=1
	VALID_INPUT=NO

	while [ $VALID_INPUT = 'NO' ]; do

		if [ $PROMPT_AMOUNT -eq 1 ]; then
			echo ''
			echo -n '- Enter "c" to continue or "q" to quit: '
			read INPUT
		fi

		if [ $PROMPT_AMOUNT -gt 1 ]; then
			echo ''
			echo -n '- Invalid response! Enter "c" to continue or "q" to quit: '
			read INPUT
		fi
	
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
				PROMPT_AMOUNT=$(( $PROMPT_AMOUNT + 1 ))

		esac
	
	done
	
}

function quit_installation {
	
	echo ''
	seabatch_statement "Quitting the installation ..."
	exit

}
##########################################################################
##########################################################################




##########################################################################
##########################################################################
#Introduction.

clear

seabatch_statement "Thank you for downloading SeaBatch 2.0! This script will guide you through the steps to install SeaBatch on your system."

prompt

if [ $ACTION = 'QUIT' ]; then
	quit_installation
fi
##########################################################################
##########################################################################




##########################################################################
##########################################################################
#Step 1 of 5: Identify Unix Shell Environment.

INSTALLATION_STEP=1

clear

seabatch_statement "Step 1 of 5: Identify Unix Shell Environment"
echo ''
seabatch_statement "- Your UNIX shell environment is set to the following:"
echo ''
seabatch_statement "$SHELL"
	
case $SHELL in

	'/bin/bash')	

		echo ''
		seabatch_statement "- This is valid. You may continue the installation."

		prompt

		if [ $ACTION = 'QUIT' ]; then
			quit_installation
		fi

	;;

	*)

		echo ''
		seabatch_statement "- ERROR: SeaBatch can currently only be installed on systems utilizing bash as the Unix shell environment"
		quit_installation

esac
##########################################################################
##########################################################################




##########################################################################
##########################################################################
#Step 2 of 5: Identify SeaBatch Installation Directory.

INSTALLATION_STEP=2

WORKING_DIRECTORY=$PWD

clear

seabatch_statement "Step 2 of 5: Identify SeaBatch Installation Directory"
echo ''
seabatch_statement "- You have chosen to install SeaBatch in the following directory:"
echo ''
seabatch_statement "$WORKING_DIRECTORY"
echo ''
seabatch_statement "- If this is OK then continue the installation. If NOT then quit, and refer to the \"Installation\" section of the manual to start the installation over."

prompt

if [ $ACTION = 'QUIT' ]; then
	quit_installation
fi
##########################################################################
##########################################################################




##########################################################################
##########################################################################
#Step 3 of 5: Determine Existence of Configuration File.

INSTALLATION_STEP=3

clear

seabatch_statement "Step 3 of 5: Determine Existence of Configuration File"
echo ''
seabatch_statement "- Installation of SeaBatch on your system involves modifying the ~/.bashrc configuration file."

if [ -e ~/.bashrc ]; then

	echo ''
	seabatch_statement "- The ~/.bashrc configuration file exists. You may continue the installation."
	
	prompt
	
else 

	echo ''
	seabatch_statement "- The ~/.bashrc configuration file does NOT exist."
	echo ''
	seabatch_statement "- It is necessary to construct this file. To accomplish this the following command will be entered:"
	echo ''
	seabatch_statement "touch ~/.bashrc"
	echo ''
	seabatch_statement "- If this is OK then continue. If NOT then quit, and you will be given directions perform the installation manually."

	prompt

	if [ $ACTION = 'QUIT' ]; then
		quit_installation
	fi
		
	touch ~/.bashrc
	
fi
##########################################################################
##########################################################################




##########################################################################
##########################################################################
#Step 4 of 5: Clean Up Configuration File.

INSTALLATION_STEP=4

clear

seabatch_statement "Step 4 of 5: Clean Up Configuration File"
echo ''
seabatch_statement "- It is necessary to remove any lines in the ~/.bashrc configuration file that reference SeaBatch."
echo ''
seabatch_statement "- Searching your ~/.bashrc configuration file ..."
	
grep -i 'SEABATCH' ~/.bashrc

if [ $? -eq 0 ]; then
	
	echo ''
	seabatch_statement "- The above lines were found:"
	echo ''

	grep -i 'SEABATCH' ~/.bashrc

	echo ''
	seabatch_statement "- It is necessary to delete the above lines. To accomplish this the following commands will be entered:"
	echo ''
	echo 'grep -i -v "SEABATCH" ~/.bashrc > ~/.bashrc_new'
	echo 'mv ~/.bashrc_new ~/.bashrc'
	echo ''
	seabatch_statement "- If this is OK then continue. If NOT then quit, and you will be given directions perform the installation manually."

	prompt

	if [ $ACTION = 'QUIT' ]; then
		quit_installation
	fi

	grep -i -v "SEABATCH" ~/.bashrc > ~/.bashrc_new
	mv ~/.bashrc_new ~/.bashrc

else

	echo ''
	seabatch_statement "- No lines were found. You may continue the installation."

	prompt

	if [ $ACTION = 'QUIT' ]; then
		quit_installation
	fi

fi
##########################################################################
##########################################################################
	


	
##########################################################################
##########################################################################	
#Step 5 of 5: Modify Configuration File.

INSTALLATION_STEP=5

clear

seabatch_statement "Step 5 of 5: Modify Configuration File"	
echo ''
seabatch_statement "It is necessary to append the following lines to the ~/.bashrc configuration file:"
echo ''
seabatch_statement "export SEABATCH=${WORKING_DIRECTORY}"
seabatch_statement "source ${SEABATCH}/sub/env/seabatch.env"
echo ''
seabatch_statement "To accomplish this the following commands will be entered:"
echo ''
echo "echo '' >> ~/.bashrc"
echo "echo 'export SEABATCH=${WORKING_DIRECTORY}' >> ~/.bashrc"
echo 'echo source ${SEABATCH}/sub/env/seabatch.env\' >> ~/.bashrc'
echo ''
seabatch_statement "- If this is OK then continue. If NOT then quit, and you will be given directions perform the installation manually."

prompt

if [ $ACTION = 'QUIT' ]; then
	quit_installation
fi

echo '' >> ~/.bashrc
echo 'export SEABATCH='${WORKING_DIRECTORY} >> ~/.bashrc
echo 'source ${SEABATCH}/sub/env/seabatch.env' >> ~/.bashrc	
##########################################################################
##########################################################################			

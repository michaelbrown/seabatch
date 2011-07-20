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

	MANUAL_INSTALLATION=${1}

	if [ $MANUAL_INSTALLATION = 'YES' ]; then
	
		clear
	
		seabatch_statement "Steps To Perform A Manual Installation of SeaBatch"
		echo ''
		seabatch_statement "- Construct the ~/.bashrc configuration file (if it does not already exist)."
		echo ''
		seabatch_statement "- Remove any lines in the ~/.bashrc configuration file that reference SeaBatch."
		echo ''
		seabatch_statement "- Append the following lines to the ~/.bashrc configuration file:"
		echo ''
		seabatch_statement "export SEABATCH=${WORKING_DIRECTORY}"
		seabatch_statement "source ${SEABATCH}/sub/env/seabatch.env"
		
	fi
	
	echo ''
	seabatch_statement "Quitting the SeaBatch installation ..."
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
	quit_installation 'NO'
fi
##########################################################################
##########################################################################




##########################################################################
##########################################################################
#Step 1 of 5: Identify Unix Shell Environment.

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
			quit_installation 'NO'
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
	quit_installation 'NO'
fi
##########################################################################
##########################################################################




##########################################################################
##########################################################################
#Step 3 of 5: Determine Existence of Configuration File.

clear

seabatch_statement "Step 3 of 5: Determine Existence Of Configuration File"
echo ''
seabatch_statement "- Installation of SeaBatch on your system involves modifying the ~/.bashrc configuration file."

if [ -e ~/.bashrc ]; then

	echo ''
	seabatch_statement "- The ~/.bashrc configuration file exists. You may continue the installation."
	
	prompt
	
	if [ $ACTION = 'QUIT' ]; then
		quit_installation 'NO'
	fi
	
else 

	echo ''
	seabatch_statement "- The ~/.bashrc configuration file does NOT exist."
	echo ''
	seabatch_statement "- It is necessary to construct this file. To accomplish this the following command will be entered:"
	echo ''
	seabatch_statement "touch ~/.bashrc"
	echo ''
	seabatch_statement "- If this is OK then continue the installation, and the file will be constructed. If NOT then quit, and you will be given directions to perform a manual installation."

	prompt

	if [ $ACTION = 'QUIT' ]; then
		quit_installation 'YES'
	fi
		
	touch ~/.bashrc
	
fi
##########################################################################
##########################################################################




##########################################################################
##########################################################################
#Step 4 of 5: Clean Up Configuration File.

clear

seabatch_statement "Step 4 of 5: Clean Up Configuration File"
echo ''
seabatch_statement "- It is necessary to remove any lines in the ~/.bashrc configuration file that reference SeaBatch."
echo ''
seabatch_statement "- Searching the ~/.bashrc configuration file ..."
echo ''
	
grep -i 'SEABATCH' ~/.bashrc

if [ $? -eq 0 ]; then
	
	echo ''
	seabatch_statement "- The above lines were found. It is necessary to delete them. To accomplish this the following commands will be entered:"
	echo ''
	echo "grep -i -v \"SEABATCH\" ~/.bashrc > ~/.bashrc_new"
	echo "mv ~/.bashrc_new ~/.bashrc"
	echo ''
	seabatch_statement "- If this is OK then continue the installation, and these lines will be deleted. If NOT then quit, and you will be given directions to perform a manual installation."

	prompt

	if [ $ACTION = 'QUIT' ]; then
		quit_installation 'YES'
	fi

	grep -i -v "SEABATCH" ~/.bashrc > ~/.bashrc_new
	mv ~/.bashrc_new ~/.bashrc

else

	seabatch_statement "- No lines were found. You may continue the installation."

	prompt

	if [ $ACTION = 'QUIT' ]; then
		quit_installation 'NO'
	fi

fi
##########################################################################
##########################################################################
	


	
##########################################################################
##########################################################################	
#Step 5 of 5: Modify Configuration File.

clear

seabatch_statement "Step 5 of 5: Modify Configuration File"	
echo ''
seabatch_statement "- It is necessary to append the following lines to the ~/.bashrc configuration file:"
echo ''
seabatch_statement "export SEABATCH=${WORKING_DIRECTORY}"
seabatch_statement "source ${SEABATCH}/sub/env/seabatch.env"
echo ''
seabatch_statement "- To accomplish this the following commands will be entered:"
echo ''
echo "echo 'export SEABATCH='${WORKING_DIRECTORY} >> ~/.bashrc"
echo "echo 'source \${SEABATCH}/sub/env/seabatch.env' >> ~/.bashrc"
echo ''
seabatch_statement "- If this is OK then continue the installation, and these lines will be appended. If NOT then quit, and you will be given directions to perform a manual installation."

prompt

if [ $ACTION = 'QUIT' ]; then
	quit_installation 'YES'
fi

echo 'export SEABATCH='${WORKING_DIRECTORY} >> ~/.bashrc
echo 'source ${SEABATCH}/sub/env/seabatch.env' >> ~/.bashrc	
##########################################################################
##########################################################################




##########################################################################
##########################################################################	
#Finishing up.

clear

seabatch_statement "Installation Successful!"
echo ''
seabatch_statement "- Refer to the manual for directions on how to use SeaBatch."
echo ''
seabatch_statement "- Contact mike@seabatch.com with any questions or suggestions."

source ~/.bashrc

quit_installation 'NO'
##########################################################################
##########################################################################		

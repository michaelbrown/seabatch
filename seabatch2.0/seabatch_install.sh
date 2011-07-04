echo 'Hello and thank you for downloading SeaBatch'

SEABATCH=$PWD
SEABATCH_ENV_FILE=${SEABATCH}'/sub/config/seabatch.env'

echo 'export SEABATCH='${SEABATCH} > ${SEABATCH_ENV_FILE}
echo 'alias seabatch=mkdir log; cp '${SEABATCH}'/master_file.txt log/processing_variables.txt;' ${SEABATCH}'/sub/bin/run_seabatch.sh | tee log/log.txt' >> ${SEABATCH_ENV_FILE}
echo 'source' ${SEABATCH_ENV_FILE} >> ~/.bashrc

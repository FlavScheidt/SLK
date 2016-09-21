#!/bin/bash

. "$SALAAK_HOME/config"

#Directory for the logs
LOG_DIR="$SALAAK_HOME/logs"
if [ ! -d "$LOG_DIR" ]
then
	mkdir "$LOG_DIR"
fi

if [ ${HADOOP_DISTRIBUTED} = "Y" ]
then
	for node in $(cat $HADOOP_HOME/conf/slaves)
	do
		psql -c "INSERT INTO slk_node (NAME) VALUES ('$node')" ${DB_NAME} ${DB_USER}  2>&1 | tee -a ${LOG_DIR}/insert.log
	done
else
	host=$(hostname -f)
	psql -c "INSERT INTO slk_node (NAME) VALUES ('${host}')" ${DB_NAME} ${DB_USER}  2>&1 | tee -a ${LOG_DIR}/insert.log
fi

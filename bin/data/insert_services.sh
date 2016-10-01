#!/bin/bash

. "$SALAAK_HOME/config"

#Directory for the logs
LOG_DIR="$SALAAK_HOME/logs"
if [ ! -d "$LOG_DIR" ]
then
	mkdir "$LOG_DIR"
fi

psql -c "INSERT INTO slk_service (NAME) VALUES ('tasktracker')" ${DB_NAME} ${DB_USER} 2>&1 | tee -a ${LOG_DIR}/insert.log

psql -c "INSERT INTO slk_service (NAME) VALUES ('datanode')" ${DB_NAME} ${DB_USER} 2>&1 | tee -a ${LOG_DIR}/insert.log


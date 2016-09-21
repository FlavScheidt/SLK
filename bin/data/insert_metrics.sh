#!/bin/bash

. "$SALAAK_HOME/config"

#Directory for the logs
LOG_DIR="$SALAAK_HOME/logs"
if [ ! -d "$LOG_DIR" ]
then
	mkdir "$LOG_DIR"
fi

#General
psql -c "INSERT INTO slk_metric (NAME) VALUES ('Instructions Retired')" ${DB_NAME} ${DB_USER}  2>&1 | tee -a ${LOG_DIR}/insert.log
psql -c "INSERT INTO slk_metric (NAME, UNIT) VALUES ('Clock Uhalted', '[MHz]')" ${DB_NAME} ${DB_USER}   2>&1 | tee -a ${LOG_DIR}/insert.log
psql -c "INSERT INTO slk_metric (NAME, UNIT) VALUES ('Clock Unhalted Ref', '[MHz]')" ${DB_NAME} ${DB_USER}  2>&1 | tee -a ${LOG_DIR}/insert.log
psql -c "INSERT INTO slk_metric (NAME, UNIT) VALUES ('Temperature', '[C]')" ${DB_NAME} ${DB_USER}  2>&1 | tee -a ${LOG_DIR}/insert.log
psql -c "INSERT INTO slk_metric (NAME, UNIT) VALUES ('Runtime', '[s]')" ${DB_NAME} ${DB_USER}  2>&1 | tee -a ${LOG_DIR}/insert.log
psql -c "INSERT INTO slk_metric (NAME, UNIT) VALUES ('Runtime Unhalted', '[s]')" ${DB_NAME} ${DB_USER}  2>&1 | tee -a ${LOG_DIR}/insert.log
psql -c "INSERT INTO slk_metric (NAME) VALUES ('CPI')" ${DB_NAME} ${DB_USER}  2>&1 | tee -a ${LOG_DIR}/insert.log

#Architectural
psql -c "INSERT INTO slk_metric (NAME, UNIT) VALUES ('Energy PKG', '[W]')" ${DB_NAME} ${DB_USER}  2>&1 | tee -a ${LOG_DIR}/insert.log
psql -c "INSERT INTO slk_metric (NAME, UNIT) VALUES ('Energy PP0', '[W]')" ${DB_NAME} ${DB_USER}  2>&1 | tee -a ${LOG_DIR}/insert.log

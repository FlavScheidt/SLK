#!/bin/bash

. "$SALAAK_HOME/config"

#Directory for the logs
LOG_DIR="$SALAAK_HOME/logs"
if [ ! -d "$LOG_DIR" ]
then
	mkdir "$LOG_DIR"
fi

cat code-signatures-30GB.csv  | cut -d ';' -f2 | sort | uniq > unique_signatures.tmp

while read line 
do
	psql -c "INSERT INTO slk_code_sign (SIGN) VALUES ('$line')" ${DB_NAME} ${DB_USER} 2>&1 | tee -a ${LOG_DIR}/insert.log
done < <(cat unique_signatures.tmp)

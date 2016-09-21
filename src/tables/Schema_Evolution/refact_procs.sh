#!/bin/bash

. "$SALAAK_HOME/bin/install_functions.sh"
. "$SALAAK_HOME/config"



#Drop Functions
sql="DROP FUNCTION return_metrics_avg(varchar, varchar, varchar)" 
psql -c "$sql" ${DB_NAME} ${DB_USER}

if [ $? -ne 0 ]
then
	echo "[ERROR] Could not destroy function"
else
	echo "[OK] Functions destroyed"
fi

sql="DROP FUNCTION return_plots_avg(varchar, varchar, varchar)" 
psql -c "$sql" ${DB_NAME} ${DB_USER}

if [ $? -ne 0 ]
then
	echo "[ERROR] Could not destroy function"
else
	echo "[OK] Functions destroyed"
fi

sql="DROP FUNCTION return_metrics_comparison(varchar)" 
psql -c "$sql" ${DB_NAME} ${DB_USER}

if [ $? -ne 0 ]
then
	echo "[ERROR] Could not destroy function"
else
	echo "[OK] Functions destroyed"
fi

sql="DROP FUNCTION return_job_avg_time(varchar)" 
psql -c "$sql" ${DB_NAME} ${DB_USER}

if [ $? -ne 0 ]
then
	echo "[ERROR] Could not destroy function"
else
	echo "[OK] Functions destroyed"
fi

sql="DROP FUNCTION return_plot_by_node(varchar, varchar)" 
psql -c "$sql" ${DB_NAME} ${DB_USER}

if [ $? -ne 0 ]
then
	echo "[ERROR] Could not destroy function"
else
	echo "[OK] Functions destroyed"
fi

sql="DROP FUNCTION return_plot_by_service(varchar, varchar)" 
psql -c "$sql" ${DB_NAME} ${DB_USER}

if [ $? -ne 0 ]
then
	echo "[ERROR] Could not destroy function"
else
	echo "[OK] Functions destroyed"
fi

sql="DROP FUNCTION return_energy_by_job(varchar)" 
psql -c "$sql" ${DB_NAME} ${DB_USER}

if [ $? -ne 0 ]
then
	echo "[ERROR] Could not destroy function"
else
	echo "[OK] Functions destroyed"
fi

sql="DROP FUNCTION return_energy_by_code()" 
psql -c "$sql" ${DB_NAME} ${DB_USER}

if [ $? -ne 0 ]
then
	echo "[ERROR] Could not destroy function"
else
	echo "[OK] Functions destroyed"
fi

sql="DROP FUNCTION return_energy_ranking_job(int)" 
psql -c "$sql" ${DB_NAME} ${DB_USER}

if [ $? -ne 0 ]
then
	echo "[ERROR] Could not destroy function"
else
	echo "[OK] Functions destroyed"
fi

sql="DROP FUNCTION return_code_sign_by_query(varchar)" 
psql -c "$sql" ${DB_NAME} ${DB_USER}

if [ $? -ne 0 ]
then
	echo "[ERROR] Could not destroy function"
else
	echo "[OK] Functions destroyed"
fi

sql="DROP FUNCTION return_query_job_by_sign(int)" 
psql -c "$sql" ${DB_NAME} ${DB_USER}

if [ $? -ne 0 ]
then
	echo "[ERROR] Could not destroy function"
else
	echo "[OK] Functions destroyed"
fi

sql="DROP FUNCTION return_energy_ranking_by_size(bigint)" 
psql -c "$sql" ${DB_NAME} ${DB_USER}

if [ $? -ne 0 ]
then
	echo "[ERROR] Could not destroy function"
else
	echo "[OK] Functions destroyed"
fi

sql="DROP FUNCTION return_plots_sum (varchar)" 
psql -c "$sql" ${DB_NAME} ${DB_USER}

if [ $? -ne 0 ]
then
	echo "[ERROR] Could not destroy function"
else
	echo "[OK] Functions destroyed"
fi

sql="DROP FUNCTION return_energy_ranking_job_sum (int)" 
psql -c "$sql" ${DB_NAME} ${DB_USER}

if [ $? -ne 0 ]
then
	echo "[ERROR] Could not destroy function"
else
	echo "[OK] Functions destroyed"
fi

sql="DROP FUNCTION return_energy_ranking_by_size_sum (bigint)" 
psql -c "$sql" ${DB_NAME} ${DB_USER}

if [ $? -ne 0 ]
then
	echo "[ERROR] Could not destroy function"
else
	echo "[OK] Functions destroyed"
fi

sql="DROP FUNCTION return_energy_ranking_sum ()" 
psql -c "$sql" ${DB_NAME} ${DB_USER}

if [ $? -ne 0 ]
then
	echo "[ERROR] Could not destroy function"
else
	echo "[OK] Functions destroyed"
fi


#Create Stored procedures
add_procedures_postgres
echo "[OK] Procedures created on postgreSQL"

#Move the interface web of salaak to the web server

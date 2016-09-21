#!/bin/bash

. "$SALAAK_HOME/config"

#Remove scripts on the hosts
#if [ ${HADOOP_DISTRIBUTED} = "Y" ]
#then
	##Check slaves config
	#for i in $(cat $HADOOP_HOME/conf/slaves)
	#do
		#ssh $i "rm -rf ${HOME}/salaak"
		#if [ $? -ne 0 ]
		#then
			#echo "[ERROR] Enable to remove scripts from slave $i"
		#fi
	#done
#fi
#echo "[OK] Scripts removed from the slaves"

#Remove scripts from hadoop home
rm ${HADOOP_HOME}/clean-dfs.sh
if [ $? -ne 0 ]
then
	echo "[ERROR] Enable to remove script clean-dfs from hadoop home"
fi

rm ${HADOOP_HOME}/kill-everybody.sh
if [ $? -ne 0 ]
then
	echo "[ERROR] Enable to remove script kill-everybody from hadoop home"
fi

echo "[OK] Scripts removed from hadoop home"

#Drop postegres tables
sql="DROP TABLE IF EXISTS slk_query, slk_node, slk_service, slk_metric, slk_exec, slk_plots, slk_metric_values, slk_exec_time, slk_job, slk_code_sign, slk_job_sign CASCADE"
psql -c "$sql" ${DB_NAME} ${DB_USER}

if [ $? -ne 0 ]
then
	echo "[ERROR] Could not destroy the tables"
else
	echo "[OK] Tables droped"
fi

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

#Empty salaak web interface

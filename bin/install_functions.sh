#!/bin/bash

check_microarchitecture()
{
	cpu_info=$(likwid-topology -g| grep -i "CPU type")

	if echo "$cpu_info" | grep -q "IvyBridge EN/EP/EX"
	then
		arch="IvyBridgeS"
	elif echo "$cpu_info" | grep -q "IvyBridge"
	then 
		arch="IvyBridge"
	elif echo "$cpu_info" | grep -q "SandyBridge EP/EN"
	then 
		arch="SandyBridgeS"
	elif echo "$cpu_info" | grep -q "SandyBridge"
	then 
		arch="SandyBridge"
	elif echo "$cpu_info" | grep -q "Haswell EP/EN/EX"
	then 
		arch="HaswellS"
	elif echo "$cpu_info" | grep -q "Haswell"
	then 
		arch="Haswell"
	elif echo "$cpu_info" | grep -q "Broadwell EP"
	then 
		arch="BroadwellS"
	elif echo "$cpu_info" | grep -q "Broadwell"
	then 
		arch="Broadwell"
	elif echo "$cpu_info" | grep -q "Skylake"
	then 
		arch="Skylake"
	else
		echo "[ERROR] Microarchitecture not supported. Cannot install Salaak"
		exit 1
	fi
	
	echo "$arch"
}

check_enviroment_vars()
{
	if [ "$HADOOP_HOME" = "" ]
	then
		echo "[ERROR] Please, set the HADOOP_HOME variable at .bashrc"
		echo "For more info, please read the Hadoop_Help file at docs"
		exit 1
	fi

	if [ "$HIVE_HOME" = "" ]
	then
		echo "[ERROR] Please, set the HIVE_HOME variable at .bashrc"
		echo "For more info, please read the Hive_Help file at docs"
		exit 1
	fi
	
	echo "[OK] Hadoop Enviroment vars"
}

postgres_tables ()
{
	cd ${SALAAK_HOME}/src/tables
	
	for arq in *.sql
	do
		psql -f "${arq}" ${DB_NAME} ${DB_USER} 2>&1 | tee -a ${LOG_DIR}/tables.log
	done
}

add_initial_info_postgres()
{
	cd ${SALAAK_HOME}/bin/data/
	
	for arq in *.sh
	do
		sh ${arq} 
	done
}

add_procedures_postgres()
{
	cd ${SALAAK_HOME}/src/procedures
	
	for arq in *.sql
	do
		psql -f "${arq}" ${DB_NAME} ${DB_USER} 2>&1 | tee -a ${LOG_DIR}/tables.log
	done
}

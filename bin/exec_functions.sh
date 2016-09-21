#!/bin/bash

. "$SALAAK_HOME/config"

savePlot()
{	
	#Log hive
	HIVE_LOG=$(tac $LOG_DIR/execs_${query%.*}.log | grep -n -m 1 "Hive history file=" | cut -d "=" -f2)

	#Query Start
	time_init=$(cat ${HIVE_LOG} | grep -o -P -m 1 'SessionStart .* TIME=.{0,11}' | cut -d '"' -f4 )
	
	#Query
	id_query=$(psql -c "SELECT ID FROM slk_query WHERE name = '$1'" ${DB_NAME} ${DB_USER} | sed '1,2d' | sed '/row/d' | sed '/^$/d' | sed '/./!d' | sed 's/ //g')
	
	# If query does not exists on the database...
	if [ -z "$id_query" ]
	then
		psql -c "INSERT INTO slk_query (NAME) VALUES ('$1')" ${DB_NAME} ${DB_USER}  &>> ${LOG_DIR}/insert.log
		id_query=$(psql -c "SELECT ID FROM slk_query WHERE name = '$1'" ${DB_NAME} ${DB_USER} | sed '1,2d' | sed '/row/d' | sed '/^$/d' | sed '/./!d' | sed 's/ //g')
	fi
	
	# cadastra new execution time
	psql -c "INSERT INTO slk_exec_time (ID_QUERY, TIME_INIT) VALUES ($id_query, $time_init)" ${DB_NAME} ${DB_USER}  &>> ${LOG_EXEC_DIR}/insert.log	
	id_exec_time=$(psql -c "SELECT ID FROM slk_exec_time WHERE ID_QUERY = $id_query and TIME_INIT = '$time_init'" ${DB_NAME} ${DB_USER} | sed '1,2d' | sed '/row/d' | sed '/^$/d' | sed '/./!d' | sed  's/ //g')

	# List of jobs
	njobs=$(tac $LOG_DIR/execs_${query%.*}.log | grep -n -m 1 "Ended Job = job_" |  tail -1 | cut -d "_" -f3 | sed 's/^0*//')

	for i in `seq 1 $njobs`;
	do
		job=$(tac $LOG_DIR/execs_${query%.*}.log | grep -n -m $i "Ended Job = job_" |  tail -1 | cut -d " " -f4)
		querylog=$(find ${HADOOP_HOME}/logs/history/ -maxdepth 1 -name "*${job}*xml" | head -1)
		joblog=$(find ${HADOOP_HOME}/logs/history -iname *${job}*age)
				
		job_init=$(grep "LAUNCH_TIME" ${joblog} | tail -1 | cut -d ' ' -f3 | cut -d '=' -f2 | sed 's/"//g' | cut -c1-10)
		job_end=$(grep "FINISH_TIME" ${joblog} | tail -1 | cut -d ' ' -f3 | cut -d '=' -f2 |  sed 's/"//g'| cut -c1-10)
		
		psql -c "INSERT INTO slk_job (ID_EXEC_TIME, TIME_INIT, TIME_END) VALUES ($id_exec_time, $job_init, $job_end)" ${DB_NAME} ${DB_USER}  &>> ${LOG_EXEC_DIR}/insert.log	
		
		#job_file_name=$( basename ${job_log} )
		
		#mv ${job_log} ${LOG_HIVE_SLK}/$job_file_name
	done

	#Query end
	time_end=$(echo $job_end)

	#List of services
	psql -c "SELECT name FROM slk_service" ${DB_NAME} ${DB_USER} | sed '1,2d' | sed '/row/d' | sed '/^$/d' | sed '/./!d' > services.tmp
	
	for slave in $(cat $HADOOP_HOME/conf/slaves)
	do
		# id slave
		id_slave=$(psql -c "SELECT ID FROM slk_node WHERE name = '$slave'" ${DB_NAME} ${DB_USER} | sed '1,2d' | sed '/row/d' | sed '/^$/d' | sed '/./!d' | sed 's/ //g')
		
		for service in $(cat ./services.tmp)
		do
			# id service
			id_service=$(psql -c "SELECT ID FROM slk_service WHERE name = '$service'" ${DB_NAME} ${DB_USER} | sed '1,2d' | sed '/row/d' | sed '/^$/d' | sed '/./!d' | sed  's/ //g')
		
			# cadastra execução 
			psql -c "INSERT INTO slk_exec (ID_EXEC_TIME, ID_SERVICE, ID_NODE) VALUES ($id_exec_time, $id_service, $id_slave)" ${DB_NAME} ${DB_USER}  &>> ${LOG_EXEC_DIR}/insert.log	
			id_exec=$(psql -c "SELECT ID FROM slk_exec WHERE ID_EXEC_TIME = $id_exec_time and ID_SERVICE = $id_service and ID_NODE = $id_slave" ${DB_NAME} ${DB_USER} | sed '1,2d' | sed '/row/d' | sed '/^$/d' | sed '/./!d' | sed  's/ //g')

			#Plot
			nline1=$(tac $PLOT_DIR/$slave.$service.gnu | grep -n -m 1 "plot" | cut -d ":" -f1)
			nline2=$(cat $PLOT_DIR/$slave.$service.gnu | wc -l)
			
			nline3=$((nline2 - nline1))
			nline=$((nline3 + 3))
			
			stopWriting=1
		
			while read line && [ $stopWriting -eq 1 ]
			do
				if (echo "$line" | grep -q "e")
				then
					stopWriting=0
				else
					arrayLine=($line)
					if [ ${arrayLine[0]} -ge $time_init ]
					then
						psql -c "INSERT INTO slk_plots (ID_EXEC, TIMEST, VAL) VALUES ($id_exec, ${arrayLine[0]}, ${arrayLine[1]})"  ${DB_NAME} ${DB_USER}  &>> ${LOG_EXEC_DIR}/insert.log	
					fi
				fi
			done < <(tail -n "+$nline" $PLOT_DIR/$slave.$service.gnu)
		
			#Metrics

			instr=$(cat $PLOT_DIR/$slave.$service.dat | grep -i -m 2 "INSTR_RETIRED_ANY" | tail -1 | cut -d'|' -f4 | sed '/^$/d' | sed '/./!d' | sed  's/ //g') 
			clk_unhalted=$(cat $PLOT_DIR/$slave.$service.dat | grep -i -m 2 "CPU_CLK_UNHALTED_CORE" | tail -1 | cut -d'|' -f7 | sed '/^$/d' | sed '/./!d' | sed  's/ //g') 			
			clk_unhalted_ref=$(cat $PLOT_DIR/$slave.$service.dat | grep -i -m 2 "CPU_CLK_UNHALTED_REF" | tail -1 | cut -d'|' -f7 | sed '/^$/d' | sed '/./!d' | sed  's/ //g') 
			temp=$(cat $PLOT_DIR/$slave.$service.dat | grep -i -m 2 "TEMP_CORE" | tail -1 | cut -d'|' -f7 | sed '/^$/d' | sed '/./!d' | sed  's/ //g') 
			runtime=$(cat $PLOT_DIR/$slave.$service.dat | grep -i -m 2 "Runtime (RDTSC)" | tail -1 | cut -d'|' -f6 | sed '/^$/d' | sed '/./!d' | sed  's/ //g') 
			runtime_unhalted=$(cat $PLOT_DIR/$slave.$service.dat | grep -i -m 2 "Runtime unhalted" | tail -1 | cut -d'|' -f6 | sed '/^$/d' | sed '/./!d' | sed  's/ //g') 
			cpi=$(cat $PLOT_DIR/$slave.$service.dat | grep -i -m 2 "CPI" | tail -1 | cut -d'|' -f6 | sed '/^$/d' | sed '/./!d' | sed  's/ //g') 
			energy=$(cat $PLOT_DIR/$slave.$service.dat | grep -i -m 5 "Power" | tail -1 | cut -d'|' -f3 | sed '/^$/d' | sed '/./!d' | sed  's/ //g') 
			energy_pp0=$(cat $PLOT_DIR/$slave.$service.dat | grep -i -m 2 "Power PP0" | tail -1 | cut -d'|' -f3 | sed '/^$/d' | sed '/./!d' | sed  's/ //g') 

			id_instr=$(psql -c "SELECT ID FROM slk_metric WHERE name = 'Instructions Retired'" ${DB_NAME} ${DB_USER} | sed '1,2d' | sed '/row/d' | sed '/^$/d' | sed '/./!d' | sed  's/ //g')
			id_clk_un=$(psql -c "SELECT ID FROM slk_metric WHERE name = 'Clock Uhalted'" ${DB_NAME} ${DB_USER} | sed '1,2d' | sed '/row/d' | sed '/^$/d' | sed '/./!d' | sed  's/ //g')
			id_clk_ref=$(psql -c "SELECT ID FROM slk_metric WHERE name = 'Clock Unhalted Ref'" ${DB_NAME} ${DB_USER} | sed '1,2d' | sed '/row/d' | sed '/^$/d' | sed '/./!d' | sed  's/ //g')
			id_temp=$(psql -c "SELECT ID FROM slk_metric WHERE name = 'Temperature'" ${DB_NAME} ${DB_USER} | sed '1,2d' | sed '/row/d' | sed '/^$/d' | sed '/./!d' | sed  's/ //g')
			id_runt=$(psql -c "SELECT ID FROM slk_metric WHERE name = 'Runtime'" ${DB_NAME} ${DB_USER} | sed '1,2d' | sed '/row/d' | sed '/^$/d' | sed '/./!d' | sed  's/ //g')
			id_r_un=$(psql -c "SELECT ID FROM slk_metric WHERE name = 'Runtime Unhalted'" ${DB_NAME} ${DB_USER} | sed '1,2d' | sed '/row/d' | sed '/^$/d' | sed '/./!d' | sed  's/ //g')
			id_cpi=$(psql -c "SELECT ID FROM slk_metric WHERE name = 'CPI'" ${DB_NAME} ${DB_USER} | sed '1,2d' | sed '/row/d' | sed '/^$/d' | sed '/./!d' | sed  's/ //g')
			id_e_pkg=$(psql -c "SELECT ID FROM slk_metric WHERE name = 'Energy PKG'" ${DB_NAME} ${DB_USER} | sed '1,2d' | sed '/row/d' | sed '/^$/d' | sed '/./!d' | sed  's/ //g')
			id_e_pp0=$(psql -c "SELECT ID FROM slk_metric WHERE name = 'Energy PP0'" ${DB_NAME} ${DB_USER} | sed '1,2d' | sed '/row/d' | sed '/^$/d' | sed '/./!d' | sed  's/ //g')
		

			psql -c "INSERT INTO slk_metric_values (ID_EXEC, ID_METRIC, VAL) VALUES ($id_exec, $id_instr, $instr)"  ${DB_NAME} ${DB_USER}  &>> ${LOG_EXEC_DIR}/insert.log	
			psql -c "INSERT INTO slk_metric_values (ID_EXEC, ID_METRIC, VAL) VALUES ($id_exec, $id_clk_un, $clk_unhalted)"  ${DB_NAME} ${DB_USER}  &>> ${LOG_EXEC_DIR}/insert.log	
			psql -c "INSERT INTO slk_metric_values (ID_EXEC, ID_METRIC, VAL) VALUES ($id_exec, $id_clk_ref, $clk_unhalted_ref)"  ${DB_NAME} ${DB_USER}  &>> ${LOG_EXEC_DIR}/insert.log	
			psql -c "INSERT INTO slk_metric_values (ID_EXEC, ID_METRIC, VAL) VALUES ($id_exec, $id_temp, $temp)"  ${DB_NAME} ${DB_USER}  &>> ${LOG_EXEC_DIR}/insert.log	
			psql -c "INSERT INTO slk_metric_values (ID_EXEC, ID_METRIC, VAL) VALUES ($id_exec, $id_runt, $runtime)"  ${DB_NAME} ${DB_USER}  &>> ${LOG_EXEC_DIR}/insert.log	
			psql -c "INSERT INTO slk_metric_values (ID_EXEC, ID_METRIC, VAL) VALUES ($id_exec, $id_r_un, $runtime_unhalted)"  ${DB_NAME} ${DB_USER}  &>> ${LOG_EXEC_DIR}/insert.log	
			psql -c "INSERT INTO slk_metric_values (ID_EXEC, ID_METRIC, VAL) VALUES ($id_exec, $id_cpi, $cpi)"  ${DB_NAME} ${DB_USER}  &>> ${LOG_EXEC_DIR}/insert.log	
			psql -c "INSERT INTO slk_metric_values (ID_EXEC, ID_METRIC, VAL) VALUES ($id_exec, $id_e_pkg, $energy)"  ${DB_NAME} ${DB_USER}  &>> ${LOG_EXEC_DIR}/insert.log	
			psql -c "INSERT INTO slk_metric_values (ID_EXEC, ID_METRIC, VAL) VALUES ($id_exec, $id_e_pp0, $energy_pp0)"  ${DB_NAME} ${DB_USER}  &>> ${LOG_EXEC_DIR}/insert.log	
		done
	done
}

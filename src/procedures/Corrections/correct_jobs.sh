#!/bin/bash

. "$SALAAK_HOME/config"

queries=("q2" "q7" "q11" "q15" "q16" "q17" "q20" "q21" "q22")

for query in ${queries[@]}
do
	j=1
	echo "$query"
	while [ $j -le 7 ]
	do
		#Log hive
		HIVE_LOG=$(tac ./execs_${query}.log | grep -n -m $j "Hive history file=" | cut -d "=" -f2 | tail -1)
		log=$(basename ${HIVE_LOG})
		HIVE_LOG=$(echo "${SALAAK_HOME}/logs/logs_hive/$log")
		#echo "${HIVE_LOG}"
		
		#Query Start
		time_init=$(cat ${HIVE_LOG} | grep -o -P -m 1 'SessionStart .* TIME=.{0,11}' | cut -d '"' -f4 )
		#echo "$time_init"
		
		#Query
		id_query=$(psql -c "SELECT ID FROM slk_query WHERE name = '${query}'" ${DB_NAME} ${DB_USER} | sed '1,2d' | sed '/row/d' | sed '/^$/d' | sed '/./!d' | sed 's/ //g')
		#echo "$id_query"
		
		id_exec_time=$(psql -c "SELECT ID FROM slk_exec_time WHERE id_query = $id_query and time_init = $time_init" ${DB_NAME} ${DB_USER} | sed '1,2d' | sed '/row/d' | sed '/^$/d' | sed '/./!d' | sed 's/ //g')
		#echo "$id_exec_time"
		
		if [ ! -z "$id_query" ]
		then
			psql -c "DELETE FROM slk_job WHERE id_exec_time = ${id_exec_time}" ${DB_NAME} ${DB_USER}
			
			# List of jobs
			if [ "$j" -eq 1 ]
			then
				njobs=$(tac ./execs_${query}.log | grep -n -m $j "Ended Job = job_" |  tail -1 | cut -d "_" -f3 | sed 's/^0*//')
				#echo "	$njobs"
			fi

			
			for i in `seq 1 $njobs`;
			do
				job=$(tac ./execs_${query}.log | grep -n -m $i "Ended Job = job_" |  tail -1 | cut -d " " -f4)
				echo "$job"
				
				querylog=$(find ${HADOOP_HOME}/logs/history/ -maxdepth 1 -name "*${job}*xml" | head -1)
				joblog=$(find ${HADOOP_HOME}/logs/history -iname *${job}*age)
						
				job_init=$(grep "LAUNCH_TIME" ${joblog} | tail -1 | cut -d ' ' -f3 | cut -d '=' -f2 | sed 's/"//g' | cut -c1-10)
				job_end=$(grep "FINISH_TIME" ${joblog} | tail -1 | cut -d ' ' -f3 | cut -d '=' -f2 |  sed 's/"//g'| cut -c1-10)
				
				#echo "		$job_init		$job_end"
				
				psql -c "INSERT INTO slk_job (ID_EXEC_TIME, TIME_INIT, TIME_END) VALUES ($id_exec_time, $job_init, $job_end)" ${DB_NAME} ${DB_USER}  
				
			done
		fi
	
		j=`expr $j + 1`
		echo "$j"
	done
done

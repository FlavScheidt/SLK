#!/bin/bash

. "$SALAAK_HOME/config"
. "$SALAAK_HOME/bin/exec_functions.sh"

#Plots directory
PLOT_DIR="$SALAAK_HOME/plots"
if [ ! -d "$PLOT_DIR" ]
then
	mkdir "$PLOT_DIR"
fi

# Log Directories
LOG_DIR="$SALAAK_HOME/logs"
if [ ! -d "$LOG_DIR" ]
then
	mkdir "$LOG_DIR"
fi

LOG_HADOOP_DIR="$LOG_DIR/hadoop"
if [ ! -d "$LOG_HADOOP_DIR" ]
then
	mkdir "$LOG_HADOOP_DIR"
fi

LOG_EXEC_DIR="$LOG_DIR/exec"
if [ ! -d "$LOG_EXEC_DIR" ]
then
	mkdir "$LOG_EXEC_DIR"
fi

LOG_HIVE_SLK="$LOG_DIR/logs_hive"
if [ ! -d "$LOG_HIVE_SLK" ]
then
	mkdir "$LOG_HIVE_SLK"
fi

LOG_LIK="$LOG_DIR/out_likwid"
if [ ! -d "$LOG_LIK" ]
then
	mkdir "$LOG_LIK"
fi

# Loop on the query drectory
cd ${QUERY_PATH}

for query in *.hive
do
	#Each querry executes 7 times
	echo "************************************************************"
	echo "[INFO] Starting ${query}"
	
	# Logs
	LOG_FILE="${LOG_DIR}/execs_${query%.*}.log"
	LOG_HADOOP="${LOG_DIR}/hadoop.log"
	
	if [ -e "$LOG_FILE" ] 
	then
		timestamp=`date "+%F-%R" --reference=$LOG_FILE`
		backupFile="$LOG_EXEC_DIR/execs_${query%.*}.$timestamp.log"
		mv $LOG_FILE $backupFile
	fi
	
	if [ -e "$LOG_HADOOP" ] 
	then
		timestamp=`date "+%F-%R" --reference=$LOG_HADOOP`
		backupFile="$LOG_HADOOP_DIR/hadoop.$timestamp.log"
		mv $LOG_HADOOP $backupFile
	fi
	
	# Trials
	trial=0
	while [ $trial -lt 1 ]
	do
		trial=`expr $trial + 1`
		echo "	Trial ${trial} of 7"
		
		#If there is any hadoop proccess running,must be stopped
		stop-all.sh &>> $LOG_HADOOP
		$HADOOP_HOME/kill-everybody.sh &>> $LOG_HADOOP
		
		
		# Start hadoop
		start-dfs.sh &>> $LOG_HADOOP
		start-mapred.sh &>> $LOG_HADOOP
		
		# Executes
		hive -f $query &>> $LOG_FILE

		if [ $? -ne 0 ] 
		then 
				echo "		[INFO] Safemode exception. Leaving safemode..."
				hadoop dfsadmin -safemode leave &>> $LOG_HADOOP
				echo "		[INFO] Restarting query"
				hive -f $query &>> $LOG_FILE
				
				if [ $? -ne 0 ]
				then
					echo "		[ERROR] Execution ${trial} of query ${query} failed: $?"
					stop-all.sh &>> $LOG_HADOOP
					$HADOOP_HOME/kill-everybody.sh &>> $LOG_HADOOP
					exit 1
				fi
		fi
	
		echo "		[INFO] Execution $trial of ${query} succesful"
		
		# Stop the server
		stop-all.sh &>> $LOG_HADOOP
		$HADOOP_HOME/kill-everybody.sh &>> $LOG_HADOOP
		
		#Copy all the results to master
		for slave in $(cat $HADOOP_HOME/conf/slaves)
		do
			timestamp=`date "+%F-%R" --reference=${PLOT_DIR}/${slave}.datanode.dat`
			
			backupFile="${LOG_LIK}/${slave}.datanode.dat.$timestamp.log"
			mv ${PLOT_DIR}/${slave}.datanode.dat $backupFile
			
			backupFile="${LOG_LIK}/${slave}.datanode.gnu.$timestamp.log"
			mv ${PLOT_DIR}/${slave}.datanode.gnu $backupFile
			
			backupFile="${LOG_LIK}/${slave}.tasktracker.dat.$timestamp.log"
			mv ${PLOT_DIR}/${slave}.tasktracker.dat $backupFile
			
			backupFile="${LOG_LIK}/${slave}.tasktracker.gnu.$timestamp.log"
			mv ${PLOT_DIR}/${slave}.tasktracker.gnu $backupFile
		
			scp $slave:~/statistics/${slave}.datanode.dat ${PLOT_DIR} &>> $LOG_HADOOP
			scp $slave:~/statistics/${slave}.datanode.gnu ${PLOT_DIR} &>> $LOG_HADOOP
			scp $slave:~/statistics/${slave}.tasktracker.dat ${PLOT_DIR} &>> $LOG_HADOOP
			scp $slave:~/statistics/${slave}.tasktracker.gnu ${PLOT_DIR} &>> $LOG_HADOOP
			
		done
		
		savePlot "${query%.*}"
		
	done
	echo "************************************************************"
	echo " "
	psql -f ${SALAAK_HOME}/src/procedures/Corrections/correct_peaks.sql ${DB_NAME} ${DB_USER} &>> ${LOG_DIR}/update.log
done

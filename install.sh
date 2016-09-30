#!/bin/bash

. "$SALAAK_HOME/bin/install_functions.sh"
. "$SALAAK_HOME/config"

echo "#################################################################"
echo "BEFORE PROCCEDING, PLEASE READ THE INSTALL FILE ON DOC DIRECTORY"
echo "AND BE SURE THAT ALL DEPENDENCIES HAVE BEEN INSTALLED PROPERTELY"
echo "#################################################################"
echo "Want to procced with Salaak install? (Y/N)"

read y_n
lower_y_n=`echo "$y_n" | tr '[:upper:]' '[:lower:]'`

if [ "$lower_y_n" != "y" ]
then
	echo "Leaving..."
	exit 1
fi

#Directory for the logs
LOG_DIR="$SALAAK_HOME/logs"
if [ ! -d "$LOG_DIR" ]
then
	mkdir "$LOG_DIR"
fi

#Directory for the logs
PLOT_DIR="$SALAAK_HOME/plots"
if [ ! -d "$PLOT_DIR" ]
then
	mkdir "$PLOT_DIR"
fi

#Check masters config
#Check the enviroment vars for hadoop and hive
check_enviroment_vars

if [ ${HADOOP_DISTRIBUTED} = "Y" ]
then
	#Check slaves config
	for i in $(cat $HADOOP_HOME/conf/slaves)
	do
		#first makes a copy of all necessary files to the hosts
		#ssh $i 'bash -s' < $SALAAK_HOME/bin/copy_config.sh
		#scp ${SALAAK_HOME}/config $i:~/salaak/config
		#scp ${SALAAK_HOME}/bin/install_functions.sh $i:~/salaak/bin/install_functions.sh
		
		ssh $i 'bash -s' < $SALAAK_HOME/bin/check_at_install.sh
		
		if [ $? -eq 1 ]
		then
			echo "[ERROR] Slaves config"
			echo "Please check the logs at logs directory"
			exit 1
		fi
		
		#Configure Hadoop to run with likwid on the slaves

                echo "scp $SALAAK_HOME/bin/hadoop_bin ${i}:~/hadoop"              
                ssh $i 'bash -s' < $SALAAK_HOME/bin/hadoop_w_likwid.sh

	done
	echo "[OK] Slaves config"
else
	check_microarchitecture
	server_arch=${arq}
	echo "[OK] Microarchitecture $arch"
	
	mv ${HADOOP_HOME}/bin/hadoop ${HADOOP_HOME}/bin/hadoop_original
	cp ${SALAAK_HOME}/bin/hadoop_bin ${HADOOP_HOME}/bin/hadoop
fi

#Copy control scripts to the hadoop dir
cp ${SALAAK_HOME}/scripts/clean-dfs.sh ${HADOOP_HOME}/clean-dfs.sh
if [ $? -ne 0 ]
then
	echo "[ERROR] Unable to copy script clean-dfs to hadoop home"
	exit 1;
fi

cp ${SALAAK_HOME}/scripts/kill-everybody.sh ${HADOOP_HOME}/kill-everybody.sh
if [ $? -ne 0 ]
then
	echo "[ERROR] Unable to copy script kill-everybody to hadoop home"
	rm ${HADOOP_HOME}/clean-dfs.sh
	exit;
fi

echo "[OK] Scripts copied to hadoop home"

#Create postgres tables
postgres_tables
echo "[OK] PostgreSQL tables created succesfully"

##Insert initil info on postgres tables
add_initial_info_postgres
echo "[OK] Initial information inserted on postgreSQL tables"

#Create Stored procedures
add_procedures_postgres
echo "[OK] Procedures created on postgreSQL"

#Move the interface web of salaak to the web server

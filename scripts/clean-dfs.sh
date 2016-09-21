#!/bin/bash

for i in $(cat $HADOOP_HOME/conf/slaves); do 
   ssh $i "rm -vrf ~/tmp/mapred ~/tmp/dfs" 
   ssh $i "pkill -9 java" 
   rm -rf ~/tmp/dfs ~/tmp/mapred
done

hadoop namenode -format

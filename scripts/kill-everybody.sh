#!/bin/bash

for i in $(cat $HADOOP_HOME/conf/slaves); do 
   ssh $i "pkill -9 java"
done

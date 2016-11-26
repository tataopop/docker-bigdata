#!/bin/bash

## sshd ##
/etc/init.d/ssh start


## HADOOP ##
sh $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

$HADOOP_PREFIX/sbin/start-dfs.sh
$HADOOP_PREFIX/sbin/start-yarn.sh


### HIVE ###
hdfs dfs -mkdir       /tmp
hdfs dfs -mkdir -p    /user/hive/warehouse
hdfs dfs -chmod g+w   /tmp
hdfs dfs -chmod g+w   /user/hive/warehouse

schematool -initSchema -dbType derby


### BASH ###

/bin/bash

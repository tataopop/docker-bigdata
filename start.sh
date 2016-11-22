#!/bin/bash

## sshd ##
/etc/init.d/ssh start


## HADOOP ##
$HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

hdfs namenode -format
$HADOOP_PREFIX/sbin/start-dfs.sh
$HADOOP_PREFIX/sbin/start-yarn.sh


/bin/bash

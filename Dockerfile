FROM ubuntu
MAINTAINER tataopop

### system (required) ###
RUN apt-get update && apt-get install -y \
    curl \
    openssh-server \
    rsync \
    vim \
  && rm -rf /var/lib/apt/lists/*

### ssh (required) ###
RUN sed -i 's/prohibit-password/yes/' /etc/ssh/sshd_config
RUN sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
RUN chmod 0600 ~/.ssh/authorized_keys

COPY ssh/config /root/.ssh/

### workspace (required) ###
ENV WORKSPACE /workspace
RUN mkdir $WORKSPACE

### java (required) ###
RUN curl -sL http://download.oracle.com/otn-pub/java/jdk/8u111-b14/jdk-8u111-linux-x64.tar.gz -H 'Cookie: oraclelicense=accept-securebackup-cookie' | tar -xz -C $WORKSPACE
RUN cd $WORKSPACE && ln -s jdk1.8.0_111 java
ENV JAVA_HOME $WORKSPACE/java
ENV PATH $JAVA_HOME/bin:$PATH

### hadoop (required) ###
ENV HADOOP_VERSION 2.7.3
RUN curl -s http://www-us.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz | tar -xz -C $WORKSPACE
RUN cd $WORKSPACE && ln -s hadoop-$HADOOP_VERSION hadoop

ENV HADOOP_PREFIX $WORKSPACE/hadoop
ENV HADOOP_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV PATH $HADOOP_PREFIX/bin:$PATH

COPY hadoop/core-site.xml $HADOOP_CONF_DIR/
COPY hadoop/hdfs-site.xml $HADOOP_CONF_DIR/
COPY hadoop/yarn-site.xml $HADOOP_CONF_DIR/
COPY hadoop/mapred-site.xml $HADOOP_CONF_DIR/

RUN sed -i 's/${JAVA_HOME}/\/workspace\/java/' /workspace/hadoop/etc/hadoop/hadoop-env.sh

RUN hdfs namenode -format

EXPOSE 50030 50070 8020 9000
EXPOSE 8088


### hive (optional) ###
RUN curl -s http://archive.apache.org/dist/db/derby/db-derby-10.4.2.0/db-derby-10.4.2.0-bin.tar.gz | tar -xz -C $WORKSPACE
RUN cd $WORKSPACE && ln -s db-derby-10.4.2.0-bin derby
ENV DERBY_HOME $WORKSPACE/derby
ENV PATH $DERBY_HOME/bin:$PATH
RUN mkdir $DERBY_HOME/data


ENV HIVE_VERSION 2.1.0
RUN curl -s http://www-us.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz | tar -xz -C $WORKSPACE
RUN cd $WORKSPACE && ln -s apache-hive-$HIVE_VERSION-bin hive

ENV HIVE_HOME $WORKSPACE/hive
ENV HIVE_CONF_DIR $HIVE_HOME/conf
ENV PATH $HIVE_HOME/bin:$PATH

RUN cd $HIVE_CONF_DIR && cp hive-env.sh.template hive-env.sh
RUN cd $HIVE_CONF_DIR && cp hive-default.xml.template hive-site.sh
COPY hive/jpox.properties $HIVE_CONF_DIR/

RUN sed -i 's/jdbc:derby:;databaseName=metastore_db;create=true/jdbc:derby:\/\/localhost:1527\/metastore_db;create=true/' $HIVE_CONF_DIR/hive-site.sh
RUN schematool -initSchema -dbType derby

### spark (optional) ###


### zookeeper (optional) ###
# required for kafka #



### kafka (optional) ###



### START ###
COPY start.sh $WORKSPACE/
CMD sh $WORKSPACE/start.sh

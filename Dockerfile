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


EXPOSE 50030 50070 8020 9000
EXPOSE 8088


### spark (optional) ###


### zookeeper (optional) ###
# required for kafka #



### kafka (optional) ###



### START ###
COPY start.sh $WORKSPACE/
CMD sh $WORKSPACE/start.sh

# Creates hadoop 3.0.0
#

FROM ubuntu:latest
MAINTAINER prasanthr

USER root

RUN apt-get update && apt-get install -y \
    curl tar sudo openssh-server openssh-client rsync net-tools vim
#update libselinux. see https://github.com/sequenceiq/hadoop-docker/issues/14
#RUN yum update -y libselinux

#passwordless ssh
#RUN ssh-keygen  -N "" -t rsa -f /root/.ssh/id_rsa 
#RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
#RUN chmod 0600 /root/.ssh/authorized_keys 
#RUN service ssh start

RUN curl -LO http://download.oracle.com/otn-pub/java/jdk/8u101-b13/jdk-8u101-linux-x64.tar.gz  -H 'Cookie: oraclelicense=accept-securebackup-cookie'
#RUN cp ~/tools/installs/jdk-8u101-linux-x64.tar.gz .
RUN tar -xvzf jdk-8u101-linux-x64.tar.gz
RUN rm jdk-8u101-linux-x64.tar.gz
RUN mv jdk1.8.0_101 /usr/
RUN ln -s /usr/jdk1.8.0_101 /usr/java

# hadoop
RUN wget http://download.nextag.com/apache/hadoop/common/hadoop-3.0.0-alpha1/hadoop-3.0.0-alpha1.tar.gz
#RUN cp ~/tools/installs/hadoop-3.0.0-alpha1.tar.gz .
RUN tar -xvzf hadoop-3.0.0-alpha1.tar.gz
RUN mv hadoop-3.0.0-alpha1 /usr/local/
RUN rm hadoop-3.0.0-alpha1.tar.gz
RUN ln -s /usr/local/hadoop-3.0.0-alpha1 /usr/local/hadoop

RUN echo "export JAVA_HOME=/usr/jdk1.8.0_101" >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh
RUN echo "export HADOOP_HOME=/usr/local/hadoop" >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh
RUN echo "export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop" >> /usr/local/hadoop/etc/hadoop/hadoop-env.sh

#conf files
ADD core-site.xml /usr/local/hadoop/etc/hadoop/core-site.xml
ADD hdfs-site.xml /usr/local/hadoop/etc/hadoop/hdfs-site.xml
ADD mapred-site.xml /usr/local/hadoop/etc/hadoop/mapred-site.xml
ADD yarn-site.xml /usr/local/hadoop/etc/hadoop/yarn-site.xml

# Hdfs ports
EXPOSE 50010 50020 50070 50075 50090 8020 9000
# Mapred ports
EXPOSE 19888
#Yarn ports
EXPOSE 8030 8031 8032 8033 8040 8042 8088
#Other ports
EXPOSE 49707 2122

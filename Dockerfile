FROM centos:7

MAINTAINER Sergey Chugay <sergey@chugay.ru>

ARG els_ver=6.3.1

RUN yum update -y && \
 
USER els

WORKDIR /home/els

ENV ELS_TMP=/home/els/els.tmp

RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http:%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u77-b02/jdk-8u171-linux-x64.rpm" \
    && rpm -ivh jdk-8u171-linux-x64.rpm \
    && rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch \
    && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${els_ver}.rpm \
    && rpm -ivh elasticsearch-${els_ver}.rpm \
    && wget https://artifacts.elastic.co/downloads/kibana/kibana-${els_ver}-x86_64.rpm \
    && rpm -ivh kibana-${els_ver}-x86_64.rpm \
    && rm -f *.rpm

VOLUME [ "/home/els" ]

CMD sh /bin/elasticsearch -E http.host=0.0.0.0 --quiet & /bin/kibana --host 0.0.0.0 -Q

EXPOSE 9200 5601
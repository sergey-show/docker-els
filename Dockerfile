FROM sergeyshow/oracle-java8

MAINTAINER Sergey Chugay <sergey@chugay.ru>

ARG ek_version=6.3.1

RUN apk add --quiet --no-progress --no-cache nodejs wget \
 && adduser -D els

USER els

WORKDIR /home/els

ENV ELS_TMP=/home/els/els.tmp

RUN wget -q -O - https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-oss-${ek_version}.tar.gz \
 |  tar -zx \
 && mv elasticsearch-${ek_version} elasticsearch \
 && mkdir -p ${ELS_TMP} \
 && wget -q -O - https://artifacts.elastic.co/downloads/kibana/kibana-oss-${ek_version}-linux-x86_64.tar.gz \
 |  tar -zx \
 && mv kibana-${ek_version}-linux-x86_64 kibana \
 && rm -f kibana/node/bin/node kibana/node/bin/npm \
 && ln -s $(which node) kibana/node/bin/node \
 && ln -s $(which npm) kibana/node/bin/npm

VOLUME [ "/home/els" ]

CMD sh elasticsearch/bin/elasticsearch -E http.host=0.0.0.0 --quiet & kibana/bin/kibana --host 0.0.0.0 -Q

EXPOSE 9200 5601
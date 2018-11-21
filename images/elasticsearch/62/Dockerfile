FROM docker.elastic.co/elasticsearch/elasticsearch:6.2.4
MAINTAINER enrico.simonetti@gmail.com

RUN bin/elasticsearch-plugin remove x-pack

COPY config/elasticsearch/elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml

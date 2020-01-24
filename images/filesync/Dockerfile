FROM debian:10.2
MAINTAINER enrico.simonetti@gmail.com

RUN apt-get update \
    && apt-get install -y \
    rsync \
    unison \
    curl \
    --no-install-recommends

RUN apt-get clean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/logs/ && touch /var/logs/filesync.log && set -ex && ln -sfT /dev/stderr "/var/logs/filesync.log"

#RUN adduser sugar --disabled-password --disabled-login --gecos ""
#USER sugar
#RUN mkdir -p /home/sugar/.unison
#COPY config/app.prf /home/sugar/.unison/app.prf
RUN mkdir -p /root/.unison
COPY config/app.prf /root/.unison/app.prf

#USER root
RUN curl --insecure -L https://curl.haxx.se/ca/cacert.pem -o cacert.pem \
    && curl -L --cacert cacert.pem https://github.com/TentativeConvert/Syndicator/raw/master/unison-binaries/unison-fsmonitor \
    -o /usr/local/bin/unison-fsmonitor \
    && chmod +x /usr/local/bin/unison-fsmonitor

COPY apps/filesync /usr/local/bin/filesync
RUN chmod +x /usr/local/bin/filesync
#USER sugar
CMD ["/usr/local/bin/filesync"]

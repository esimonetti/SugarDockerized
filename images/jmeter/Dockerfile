FROM debian:9.6
MAINTAINER enrico.simonetti@gmail.com

RUN apt-get update \
    && apt-get install -y \
    libssl-dev \
    openjdk-8-jdk-headless \
    curl \
    unzip \
    vim \
    wget \
    ant \
    jq \
    git \
    --no-install-recommends \
    && apt-get clean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/jmeterinstall
RUN cd /opt/jmeterinstall \
    && wget -q https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.0.tgz \
    && mkdir jmeter \
    && tar -xzf apache-jmeter-5.0.tgz -C jmeter --strip 1 \ 
    && rm -f apache-jmeter-5.0.tgz \
    && wget -O jmeter/lib/cmdrunner-2.2.jar  http://search.maven.org/remotecontent?filepath=kg/apc/cmdrunner/2.2/cmdrunner-2.2.jar \
    && wget -O jmeter/lib/ext/jmeter-plugins-manager-1.3.jar https://jmeter-plugins.org/get/ \
    && java -cp jmeter/lib/ext/jmeter-plugins-manager-1.3.jar org.jmeterplugins.repository.PluginManagerCMDInstaller \
    && jmeter/bin/PluginsManagerCMD.sh install jpgc-json \
    && jmeter/bin/PluginsManagerCMD.sh install jpgc-xml

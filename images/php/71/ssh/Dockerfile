FROM esimonetti/sugarphp71image:1.4
MAINTAINER enrico.simonetti@gmail.com

RUN adduser sugar --uid 1500 --disabled-password --disabled-login --gecos ""
RUN apt-get update && apt-get install -y openssh-server zip unzip git
RUN apt-get clean && apt-get -y autoremove
RUN mkdir /var/run/sshd
CMD ["/usr/sbin/sshd", "-D"]
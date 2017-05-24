FROM debian:8.7
MAINTAINER enrico.simonetti@gmail.com

RUN apt-get update
RUN apt-get -y dist-upgrade

RUN apt-get install -y unzip vim apache2
RUN apt-get clean
RUN apt-get -y autoremove

RUN set -ex \
    && . "/etc/apache2/envvars" \
    && ln -sfT /dev/stderr "$APACHE_LOG_DIR/error.log" \
    && ln -sfT /dev/stdout "$APACHE_LOG_DIR/access.log" \
    && ln -sfT /dev/stdout "$APACHE_LOG_DIR/other_vhosts_access.log"

RUN a2enmod proxy proxy_http proxy_balancer lbmethod_byrequests status
COPY config/apache2/sites-available/sugar.conf /etc/apache2/sites-available/sugar.conf
RUN a2ensite sugar
RUN a2dissite 000-default

RUN sed -i "s#Timeout .*#Timeout 600#" /etc/apache2/apache2.conf

EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

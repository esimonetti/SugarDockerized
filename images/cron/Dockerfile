FROM debian:9
MAINTAINER enrico.simonetti@gmail.com

RUN apt-get update
RUN apt-get -y dist-upgrade

RUN apt-get install -y unzip vim curl php7.0-curl php7.0-gd php7.0-imap php7.0-zip php7.0-ldap php7.0 php7.0-dev apache2 php7.0-mcrypt build-essential php7.0-redis php7.0-mysql
RUN apt-get clean
RUN apt-get -y autoremove

RUN adduser sugar --disabled-password --disabled-login --gecos ""

RUN sed -i "s#.*date.timezone =.*#date.timezone = Australia/Sydney#" /etc/php/7.0/cli/php.ini
RUN sed -i "s#error_reporting = .*#error_reporting = E_ALL \& ~E_NOTICE \& ~E_STRICT \& ~E_DEPRECATED#" /etc/php/7.0/cli/php.ini
RUN sed -i "s#;error_log = syslog#error_log = /var/log/apache2/error.log#" /etc/php/7.0/cli/php.ini
RUN sed -i "s#;realpath_cache_size = .*#realpath_cache_size = 512k#" /etc/php/7.0/cli/php.ini
RUN sed -i "s#;realpath_cache_ttl = .*#realpath_cache_ttl = 600#" /etc/php/7.0/cli/php.ini

COPY config/php7/mods-available/opcache.ini /etc/php/7.0/mods-available/opcache.ini
COPY config/php7/opcache-blacklist /etc/php/7.0/opcache-blacklist
RUN phpenmod opcache

COPY apps/sugarcron /usr/local/bin/sugarcron
RUN chmod +x /usr/local/bin/sugarcron

USER sugar

CMD ["/usr/local/bin/sugarcron"]

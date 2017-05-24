FROM debian:8.7
MAINTAINER enrico.simonetti@gmail.com

RUN apt-get update
RUN apt-get -y dist-upgrade

RUN apt-get install -y unzip vim curl php5-curl php5-gd php5-imap libphp-pclzip php5-ldap php5 php5-dev php5-mcrypt build-essential php5-redis php5-mysql
RUN apt-get clean
RUN apt-get -y autoremove

RUN adduser sugar --disabled-password --disabled-login --gecos ""

RUN sed -i "s#.*date.timezone =.*#date.timezone = Australia/Sydney#" /etc/php5/cli/php.ini
RUN sed -i "s#error_reporting = .*#error_reporting = E_ALL \& ~E_NOTICE \& ~E_STRICT \& ~E_DEPRECATED#" /etc/php5/cli/php.ini
RUN sed -i "s#;error_log = syslog#error_log = /var/log/apache2/error.log#" /etc/php5/cli/php.ini
RUN sed -i "s#;realpath_cache_size = .*#realpath_cache_size = 512k#" /etc/php5/cli/php.ini
RUN sed -i "s#;realpath_cache_ttl = .*#realpath_cache_ttl = 600#" /etc/php5/cli/php.ini

COPY config/php5/mods-available/opcache.ini /etc/php5/mods-available/opcache.ini
COPY config/php5/opcache-blacklist /etc/php5/opcache-blacklist
RUN php5enmod opcache

COPY apps/sugarcron /usr/local/bin/sugarcron
RUN chmod +x /usr/local/bin/sugarcron

USER sugar

CMD ["/usr/local/bin/sugarcron"]

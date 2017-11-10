FROM debian:8.7
MAINTAINER enrico.simonetti@gmail.com

RUN apt-get update
RUN apt-get -y dist-upgrade

RUN apt-get install -y unzip vim curl php5-curl php5-gd php5-imap libphp-pclzip php5-ldap php5 php5-dev php5-mcrypt build-essential php5-redis php5-mysql php5-xdebug php5-xhprof

RUN apt-get install -y sudo
RUN adduser sugar --disabled-password --disabled-login --gecos ""
RUN echo "sugar ALL=NOPASSWD: ALL" > /etc/sudoers.d/sugar

RUN apt-get clean
RUN apt-get -y autoremove

RUN sed -i "s#.*date.timezone =.*#date.timezone = Australia/Sydney#" /etc/php5/cli/php.ini
RUN sed -i "s#error_reporting = .*#error_reporting = E_ALL \& ~E_NOTICE \& ~E_STRICT \& ~E_DEPRECATED#" /etc/php5/cli/php.ini
RUN sed -i "s#;error_log = syslog#error_log = /var/log/apache2/error.log#" /etc/php5/cli/php.ini
RUN sed -i "s#;realpath_cache_size = .*#realpath_cache_size = 512k#" /etc/php5/cli/php.ini
RUN sed -i "s#;realpath_cache_ttl = .*#realpath_cache_ttl = 600#" /etc/php5/cli/php.ini

COPY config/php/mods-available/xdebug.ini /etc/php5/mods-available/xdebug.ini
# to comment out if xdebug should be enabled - huge performance reduction especially during repair
RUN php5dismod xdebug

COPY config/php/mods-available/xhprof.ini /etc/php5/mods-available/xhprof.ini
RUN php5enmod xhprof

COPY config/php/mods-available/opcache.ini /etc/php5/mods-available/opcache.ini
COPY config/php/opcache-blacklist /etc/php5/opcache-blacklist
RUN php5enmod opcache

COPY apps/sugarcron /usr/local/bin/sugarcron
RUN chmod +x /usr/local/bin/sugarcron

WORKDIR "/var/www/html/sugar"
USER sugar

CMD ["/usr/local/bin/sugarcron"]

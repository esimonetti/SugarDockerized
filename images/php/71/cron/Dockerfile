FROM debian:8.8
MAINTAINER enrico.simonetti@gmail.com

RUN apt-get update
RUN apt-get install -y curl apt-transport-https
RUN curl -sS https://packages.sury.org/php/apt.gpg -o /etc/apt/trusted.gpg.d/php.gpg
RUN echo "deb https://packages.sury.org/php/ jessie main" > /etc/apt/sources.list.d/php.list

RUN apt-get update
RUN apt-get -y dist-upgrade

RUN apt-get install -y git unzip vim build-essential php7.1-curl php7.1-gd php7.1-bcmath php7.1-mbstring php7.1-imap php7.1-zip php7.1-ldap php7.1 php7.1-dev php7.1-mcrypt php7.1-redis php7.1-mysql php-xdebug php-tideways

RUN apt-get install -y sudo
RUN adduser sugar --disabled-password --disabled-login --gecos ""
RUN echo "sugar ALL=NOPASSWD: ALL" > /etc/sudoers.d/sugar

RUN apt-get clean
RUN apt-get -y autoremove

RUN sed -i "s#.*date.timezone =.*#date.timezone = Australia/Sydney#" /etc/php/7.1/cli/php.ini
RUN sed -i "s#error_reporting = .*#error_reporting = E_ALL \& ~E_NOTICE \& ~E_STRICT \& ~E_DEPRECATED#" /etc/php/7.1/cli/php.ini
RUN sed -i "s#;error_log = syslog#error_log = /var/log/apache2/error.log#" /etc/php/7.1/cli/php.ini
RUN sed -i "s#;realpath_cache_size = .*#realpath_cache_size = 512k#" /etc/php/7.1/cli/php.ini
RUN sed -i "s#;realpath_cache_ttl = .*#realpath_cache_ttl = 600#" /etc/php/7.1/cli/php.ini

COPY config/php/mods-available/xdebug.ini /etc/php/7.1/mods-available/xdebug.ini
# to comment out if xdebug should be enabled - huge performance reduction especially during repair
RUN php5dismod xdebug

COPY config/php/mods-available/opcache.ini /etc/php/7.1/mods-available/opcache.ini
COPY config/php/opcache-blacklist /etc/php/7.1/opcache-blacklist
RUN phpenmod opcache

RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

COPY apps/sugarcron /usr/local/bin/sugarcron
RUN chmod +x /usr/local/bin/sugarcron

WORKDIR "/var/www/html/sugar"
USER sugar

CMD ["/usr/local/bin/sugarcron"]

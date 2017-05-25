FROM debian:8.8
MAINTAINER enrico.simonetti@gmail.com

RUN apt-get update
RUN apt-get install -y curl apt-transport-https
RUN curl -sS https://packages.sury.org/php/apt.gpg -o /etc/apt/trusted.gpg.d/php.gpg
RUN echo "deb https://packages.sury.org/php/ jessie main" > /etc/apt/sources.list.d/php.list

RUN apt-get update
RUN apt-get -y dist-upgrade

RUN apt-get install -y unzip vim build-essential apache2 php7.1-curl php7.1-gd php7.1-bcmath php7.1-mbstring php7.1-imap php7.1-zip php7.1-ldap php7.1 php7.1-dev php7.1-mcrypt php7.1-redis php7.1-mysql

COPY config/apache2/mods-available/deflate.conf /etc/apache2/mods-available/deflate.conf
RUN a2enmod headers expires deflate rewrite

RUN adduser sugar --disabled-password --disabled-login --gecos ""
RUN sed -i "s#APACHE_RUN_USER=.*#APACHE_RUN_USER=sugar#" /etc/apache2/envvars
RUN sed -i "s#APACHE_RUN_GROUP=.*#APACHE_RUN_GROUP=sugar#" /etc/apache2/envvars

RUN set -ex \
    && . "/etc/apache2/envvars" \
    && ln -sfT /dev/stderr "$APACHE_LOG_DIR/error.log" \
    && ln -sfT /dev/stdout "$APACHE_LOG_DIR/access.log" \
    && ln -sfT /dev/stdout "$APACHE_LOG_DIR/other_vhosts_access.log"

RUN a2dissite 000-default
COPY config/apache2/sites-available/sugar.conf /etc/apache2/sites-available/sugar.conf
RUN a2ensite sugar

RUN sed -i "s#Timeout .*#Timeout 600#" /etc/apache2/apache2.conf

RUN sed -i "s#memory_limit = .*#memory_limit = 512M#" /etc/php/7.1/apache2/php.ini
RUN sed -i "s#.*date.timezone =.*#date.timezone = Australia/Sydney#" /etc/php/7.1/apache2/php.ini
RUN sed -i "s#post_max_size = .*#post_max_size = 100M#" /etc/php/7.1/apache2/php.ini
RUN sed -i "s#upload_max_filesize = .*#upload_max_filesize = 100M#" /etc/php/7.1/apache2/php.ini
RUN sed -i "s#max_execution_time = .*#max_execution_time = 600#" /etc/php/7.1/apache2/php.ini
RUN sed -i "s#max_input_time = .*#max_input_time = 600#" /etc/php/7.1/apache2/php.ini
RUN sed -i "s#error_reporting = .*#error_reporting = E_ALL \& ~E_NOTICE \& ~E_STRICT \& ~E_DEPRECATED#" /etc/php/7.1/apache2/php.ini
RUN sed -i "s#;error_log = syslog#error_log = /var/log/apache2/error.log#" /etc/php/7.1/apache2/php.ini
RUN sed -i "s#;realpath_cache_size = .*#realpath_cache_size = 512k#" /etc/php/7.1/apache2/php.ini
RUN sed -i "s#;realpath_cache_ttl = .*#realpath_cache_ttl = 600#" /etc/php/7.1/apache2/php.ini

RUN sed -i "s#session.save_handler = .*#session.save_handler = redis#" /etc/php/7.1/apache2/php.ini
RUN sed -i 's#;session.save_path = .*#session.save_path = "tcp://sugar78-redis:6379"#' /etc/php/7.1/apache2/php.ini

RUN sed -i "s#.*date.timezone =.*#date.timezone = Australia/Sydney#" /etc/php/7.1/cli/php.ini
RUN sed -i "s#error_reporting = .*#error_reporting = E_ALL \& ~E_NOTICE \& ~E_STRICT \& ~E_DEPRECATED#" /etc/php/7.1/cli/php.ini
RUN sed -i "s#;error_log = syslog#error_log = /var/log/syslog#" /etc/php/7.1/apache2/php.ini
RUN sed -i "s#;realpath_cache_size = .*#realpath_cache_size = 512k#" /etc/php/7.1/cli/php.ini
RUN sed -i "s#;realpath_cache_ttl = .*#realpath_cache_ttl = 600#" /etc/php/7.1/cli/php.ini

COPY config/php/mods-available/opcache.ini /etc/php/7.1/mods-available/opcache.ini
COPY config/php/opcache-blacklist /etc/php/7.1/opcache-blacklist
RUN phpenmod opcache

RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

RUN apt-get clean
RUN apt-get -y autoremove

WORKDIR "/var/www/html/sugar"

EXPOSE 80
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

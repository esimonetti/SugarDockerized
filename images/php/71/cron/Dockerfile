FROM esimonetti/sugarphp71image:1.3
MAINTAINER enrico.simonetti@gmail.com

RUN apt-get update && apt-get install -y sudo vim unzip --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN adduser sugar --disabled-password --disabled-login --gecos ""
RUN echo "sugar ALL=NOPASSWD: ALL" > /etc/sudoers.d/sugar

RUN apt-get clean && apt-get -y autoremove

RUN sed -i "s#.*date.timezone =.*#date.timezone = Australia/Sydney#" /etc/php/7.1/cli/php.ini \
    && sed -i "s#error_reporting = .*#error_reporting = E_ALL \& ~E_NOTICE \& ~E_STRICT \& ~E_DEPRECATED#" /etc/php/7.1/cli/php.ini \
    && sed -i "s#;error_log = syslog#error_log = /var/log/apache2/error.log#" /etc/php/7.1/cli/php.ini \
    && sed -i "s#;realpath_cache_size = .*#realpath_cache_size = 512k#" /etc/php/7.1/cli/php.ini \
    && sed -i "s#;realpath_cache_ttl = .*#realpath_cache_ttl = 600#" /etc/php/7.1/cli/php.ini

COPY config/php/mods-available/xdebug.ini /etc/php/7.1/mods-available/xdebug.ini
# to comment out if xdebug should be enabled - huge performance reduction especially during repair
RUN phpdismod xdebug

COPY config/php/mods-available/tideways.ini /etc/php/7.1/mods-available/tideways.ini
RUN phpenmod tideways
COPY config/php/mods-available/redis.ini /etc/php/7.1/mods-available/redis.ini
RUN phpenmod redis

COPY config/php/mods-available/opcache.ini /etc/php/7.1/mods-available/opcache.ini
COPY config/php/opcache-blacklist /etc/php/7.1/opcache-blacklist
RUN phpenmod opcache

RUN curl -sS http://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

COPY apps/sugarcron /usr/local/bin/sugarcron
RUN chmod +x /usr/local/bin/sugarcron

WORKDIR "/var/www/html/sugar"
USER sugar

CMD ["/usr/local/bin/sugarcron"]

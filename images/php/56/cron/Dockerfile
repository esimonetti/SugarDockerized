FROM debian:8.7
MAINTAINER enrico.simonetti@gmail.com

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    vim \
    curl \
    php5-curl \
    php5-gd \
    php5-imap \
    libphp-pclzip \
    php5-ldap \
    php5 \
    php5-dev \
    php5-mcrypt \
    build-essential \
    php5-redis \
    php5-mysql \
    php5-xdebug \
    php5-xhprof \
    sudo \
    --no-install-recommends && rm -rf /var/lib/apt/lists/* 

RUN adduser sugar --disabled-password --disabled-login --gecos ""
RUN echo "sugar ALL=NOPASSWD: ALL" > /etc/sudoers.d/sugar

RUN apt-get clean && apt-get -y autoremove

RUN sed -i "s#.*date.timezone =.*#date.timezone = Australia/Sydney#" /etc/php5/cli/php.ini \
    && sed -i "s#error_reporting = .*#error_reporting = E_ALL \& ~E_NOTICE \& ~E_STRICT \& ~E_DEPRECATED#" /etc/php5/cli/php.ini \
    && sed -i "s#;error_log = syslog#error_log = /proc/1/fd/1#" /etc/php5/cli/php.ini \
    && sed -i "s#display_errors = Off#display_errors = On#" /etc/php5/cli/php.ini \
    && sed -i "s#;realpath_cache_size = .*#realpath_cache_size = 512k#" /etc/php5/cli/php.ini \
    && sed -i "s#;realpath_cache_ttl = .*#realpath_cache_ttl = 600#" /etc/php5/cli/php.ini

COPY config/php/mods-available/xdebug.ini /etc/php5/mods-available/xdebug.ini
# to comment out if xdebug should be enabled - huge performance reduction especially during repair
RUN php5dismod xdebug

COPY config/php/mods-available/xhprof.ini /etc/php5/mods-available/xhprof.ini
RUN php5enmod xhprof

COPY config/php/mods-available/opcache.ini /etc/php5/mods-available/opcache.ini
COPY config/php/opcache-blacklist /etc/php5/opcache-blacklist
RUN php5enmod opcache

RUN curl -sS http://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

COPY apps/sugarcron /usr/local/bin/sugarcron
RUN chmod +x /usr/local/bin/sugarcron

WORKDIR "/var/www/html/sugar"
USER sugar

CMD ["/usr/local/bin/sugarcron"]

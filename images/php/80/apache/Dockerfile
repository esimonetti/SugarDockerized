FROM php:8.0-apache


RUN apt-get update \
    && apt-get install -y \
    graphviz \
    libpng-dev \
    libgmp-dev \
    libzip-dev \
    libc-client-dev \
    libkrb5-dev \
    libldap2-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libxml2-dev \
    git \
    --no-install-recommends

RUN apt-get clean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*

RUN adduser sugar --disabled-password --disabled-login --gecos ""

RUN echo "<?php \$_SERVER['SERVER_SOFTWARE'] = 'SugarDockerized';" > /usr/local/php/prepend.php

RUN echo 'date.timezone = GMT' >> /usr/local/etc/php/conf.d/docker.ini \
    && echo 'error_reporting = E_ALL \& ~E_NOTICE \& ~E_STRICT \& ~E_DEPRECATED' >> /usr/local/etc/php/conf.d/docker.ini \
    && echo 'error_log = /var/log/apache2/error.log' >> /usr/local/etc/php/conf.d/docker.ini \
    && echo 'log_errors = On' >> /usr/local/etc/php/conf.d/docker.ini \
    && echo 'display_errors = Off' >> /usr/local/etc/php/conf.d/docker.ini \
    && echo 'memory_limit = 512M' >> /usr/local/etc/php/conf.d/docker.ini \
    && echo 'post_max_size = 100M' >> /usr/local/etc/php/conf.d/docker.ini \
    && echo 'upload_max_filesize = 100M' >> /usr/local/etc/php/conf.d/docker.ini \
    && echo 'max_execution_time = 600' >> /usr/local/etc/php/conf.d/docker.ini \
    && echo 'max_input_time = 600' >> /usr/local/etc/php/conf.d/docker.ini \
    && echo 'realpath_cache_size = 512k' >> /usr/local/etc/php/conf.d/docker.ini \
    && echo 'realpath_cache_ttl = 600' >> /usr/local/etc/php/conf.d/docker.ini \
    && echo 'mbstring.func_overload = 0' >> /usr/local/etc/php/conf.d/docker.ini \
    && echo 'session.use_cookies = 1' >> /usr/local/etc/php/conf.d/docker.ini \
    && echo 'session.cookie_httponly = 1' >> /usr/local/etc/php/conf.d/docker.ini \
    && echo 'session.use_trans_sid = 0' >> /usr/local/etc/php/conf.d/docker.ini \
    && echo 'session.save_handler = redis' >> /usr/local/etc/php/conf.d/docker.ini \
    && echo 'session.save_path = "tcp://sugar-redis:6379"' >> /usr/local/etc/php/conf.d/docker.ini \
    && echo 'auto_prepend_file = "/usr/local/php/prepend.php"' >> /usr/local/etc/php/conf.d/docker.ini

COPY config/apache2/mods-available/deflate.conf /etc/apache2/mods-available/deflate.conf
COPY config/apache2/sites-available/sugar.conf /etc/apache2/sites-available/sugar.conf

RUN set -ex \
    && . "/etc/apache2/envvars" \
    && ln -sfT /dev/stderr "$APACHE_LOG_DIR/error.log" \
    && ln -sfT /dev/stdout "$APACHE_LOG_DIR/access.log" \
    && ln -sfT /dev/stdout "$APACHE_LOG_DIR/other_vhosts_access.log" \
    && a2enmod headers expires deflate rewrite \
    && sed -i "s#Timeout .*#Timeout 600#" /etc/apache2/apache2.conf \
    && a2dissite 000-default \
    && a2ensite sugar

RUN docker-php-ext-install mysqli \
    && docker-php-ext-install bcmath \
    && docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg \ 
    && docker-php-ext-install gd \
    && docker-php-ext-install gmp \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap \
    && docker-php-ext-install zip \
    && docker-php-ext-install ldap \
    && pecl install xdebug \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && docker-php-ext-install soap

RUN docker-php-ext-install -j$(nproc) gd

# enabled by default, it can be disabled locally
COPY config/php/mods-available/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
COPY config/php/mods-available/opcache.ini /usr/local/etc/php/conf.d/opcache.ini
COPY config/php/opcache-blacklist /usr/local/etc/php/opcache-blacklist

RUN git clone https://github.com/tideways/php-xhprof-extension.git tideways \
    && cd tideways \
    && /usr/local/bin/phpize \
    && ./configure --with-php-config=/usr/local/bin/php-config \
    && make \
    && make install

COPY config/php/mods-available/tideways.ini /usr/local/etc/php/conf.d/tideways.ini

RUN git clone https://github.com/longxinH/xhprof.git xhprof \
    && cd xhprof/extension/ \
    && /usr/local/bin/phpize \
    && ./configure --with-php-config=/usr/local/bin/php-config \
    && make \
    && make install

COPY config/php/mods-available/xhprof.ini /usr/local/etc/php/conf.d/xhprof.ini

WORKDIR "/var/www/html/sugar"

FROM php:7.3-rc-cli
MAINTAINER enrico.simonetti@gmail.com

RUN apt-get update \
    && apt-get install -y \
    sudo \
    vim \
    unzip \
    libmcrypt-dev \
    libpng-dev \
    libgmp-dev \
    libzip-dev \
    libc-client-dev \
    libkrb5-dev \
    gnupg \
    git \
    --no-install-recommends

# tideways does not seem to support php 7.3rc yet
#RUN echo 'deb http://s3-eu-west-1.amazonaws.com/tideways/packages debian main' > /etc/apt/sources.list.d/tideways.list \
#    && curl -sS https://s3-eu-west-1.amazonaws.com/tideways/packages/EEB5E8F4.gpg | apt-key add - \
#    && apt-get update \
#    && apt-get install -y \
#    tideways-php \
#    --no-install-recommends

RUN apt-get clean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/*

RUN adduser sugar --disabled-password --disabled-login --gecos "" \
    && echo "sugar ALL=NOPASSWD: ALL" > /etc/sudoers.d/sugar

RUN echo 'date.timezone = GMT' >> /usr/local/etc/php/conf.d/docker.ini \
    && echo 'error_reporting = E_ALL \& ~E_NOTICE \& ~E_STRICT \& ~E_DEPRECATED' >> /usr/local/etc/php/conf.d/docker.ini \
    && echo 'error_log = /proc/1/fd/1' >> /usr/local/etc/php/conf.d/docker.ini \
    && echo 'log_errors = On' >> /usr/local/etc/php/conf.d/docker.ini \
    && echo 'display_errors = Off' >> /usr/local/etc/php/conf.d/docker.ini \
    && echo 'memory_limit = -1' >> /usr/local/etc/php/conf.d/docker.ini \
    && echo 'max_execution_time = -1' >> /usr/local/etc/php/conf.d/docker.ini \
    && echo 'realpath_cache_size = 512k' >> /usr/local/etc/php/conf.d/docker.ini \
    && echo 'realpath_cache_ttl = 600' >> /usr/local/etc/php/conf.d/docker.ini \
    && echo 'mbstring.func_overload = 0' >> /usr/local/etc/php/conf.d/docker.ini

RUN docker-php-ext-install mysqli \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install gd \
    && docker-php-ext-install gmp \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap \
    && docker-php-ext-install zip \
    # pinning version 1.0.1 as 1.0.0 would not install
    && pecl install mcrypt-1.0.1 \
    && docker-php-ext-enable mcrypt \
    # problem for xdebug 2.6.1 with php 7.3rc (https://bugs.xdebug.org/view.php?id=1584)
    && pecl install xdebug-2.7.0beta1 \
    && pecl install redis \
    && docker-php-ext-enable redis

# disable by default, it can be enabled locally
#COPY config/php/mods-available/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
# tideways does not seem to support php 7.3rc yet
#COPY config/php/mods-available/tideways.ini /usr/local/etc/php/conf.d/tideways.ini
# php 7.3rc goes in seg fault at times with opcache, disabling for now
#COPY config/php/mods-available/opcache.ini /usr/local/etc/php/conf.d/opcache.ini
#COPY config/php/opcache-blacklist /usr/local/etc/php/opcache-blacklist

RUN git clone https://github.com/longxinH/xhprof.git xhprof \
    && cd xhprof/extension/ \
    && /usr/local/bin/phpize \
    && ./configure --with-php-config=/usr/local/bin/php-config \
    && make \
    && make install

COPY config/php/mods-available/xhprof.ini /usr/local/etc/php/conf.d/xhprof.ini

RUN curl -sS http://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

COPY apps/sugarcron /usr/local/bin/sugarcron
RUN chmod +x /usr/local/bin/sugarcron

WORKDIR "/var/www/html/sugar"
USER sugar

CMD ["/usr/local/bin/sugarcron"]

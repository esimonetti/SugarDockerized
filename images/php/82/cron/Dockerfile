FROM php:8.2.2-cli

RUN apt-get update \
    && apt-get install -y \
    sudo \
    vim \
    unzip \
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

RUN adduser sugar --disabled-password --disabled-login --gecos "" \
    && echo "sugar ALL=NOPASSWD: ALL" > /etc/sudoers.d/sugar

RUN echo "<?php \$_SERVER['SERVER_SOFTWARE'] = 'SugarDockerized';" > /usr/local/php/prepend.php

RUN docker-php-ext-install mysqli \
    && docker-php-ext-install bcmath \
    && docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg \ 
    && docker-php-ext-install gd \
    && docker-php-ext-install gmp \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap \
    && docker-php-ext-install zip \
    && docker-php-ext-install ldap \
    && docker-php-ext-install ldap \
    && pecl install xdebug-3.2.0 \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && docker-php-ext-install soap

RUN docker-php-ext-install -j$(nproc) gd

# disable by default, it can be enabled locally
#COPY config/php/mods-available/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
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

RUN curl -sS http://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

COPY apps/sugarcron /usr/local/bin/sugarcron
RUN chmod +x /usr/local/bin/sugarcron

WORKDIR "/var/www/html/sugar"
USER sugar

CMD ["/usr/local/bin/sugarcron"]

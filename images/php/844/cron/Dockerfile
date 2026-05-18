FROM php:8.4.4-cli

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
    && docker-php-ext-install gmp \
    && docker-php-ext-install zip \
    && docker-php-ext-install ldap \
    && pecl install xdebug \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && docker-php-ext-install soap

RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd
    
# disable by default, it can be enabled locally
COPY config/php/docker.ini /usr/local/etc/php/conf.d/docker.ini
COPY config/php/mods-available/opcache.ini /usr/local/etc/php/conf.d/opcache.ini
COPY config/php/opcache-blacklist /usr/local/etc/php/opcache-blacklist

RUN git clone https://github.com/longxinH/xhprof.git xhprof \
    && cd xhprof/extension/ \
    && /usr/local/bin/phpize \
    && ./configure --with-php-config=/usr/local/bin/php-config \
    && make \
    && make install

COPY config/php/mods-available/xhprof.ini /usr/local/etc/php/conf.d/xhprof.ini

# Important to enable providers
RUN sed -i 's/^# providers = provider_sect/providers = provider_sect/' /etc/ssl/openssl.cnf 

# Append the custom OpenSSL configuration to the existing openssl.cnf
RUN echo '[provider_sect]' >> /etc/ssl/openssl.cnf && \
    echo 'default = default_sect' >> /etc/ssl/openssl.cnf && \
    echo 'legacy = legacy_sect' >> /etc/ssl/openssl.cnf && \
    echo '[default_sect]' >> /etc/ssl/openssl.cnf && \
    echo 'activate = 1' >> /etc/ssl/openssl.cnf && \
    echo '[legacy_sect]' >> /etc/ssl/openssl.cnf && \
    echo 'activate = 1' >> /etc/ssl/openssl.cnf

RUN curl -sS http://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

COPY apps/sugarcron /usr/local/bin/sugarcron
RUN chmod +x /usr/local/bin/sugarcron

WORKDIR "/var/www/html/sugar"
USER sugar

CMD ["/usr/local/bin/sugarcron"]

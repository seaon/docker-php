FROM php:7.2.0-fpm-alpine3.7

RUN apk add --no-cache freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo_mysql sockets zip \
    && apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev

ENV PHPREDIS_VERSION 3.1.3
RUN curl -L -o /tmp/redis.tar.gz "https://github.com/phpredis/phpredis/archive/${PHPREDIS_VERSION}.tar.gz" \
        && tar xfz /tmp/redis.tar.gz \
        && rm -r /tmp/redis.tar.gz \
        &&  mkdir -p /usr/src/php/ext \
        && mv phpredis-$PHPREDIS_VERSION /usr/src/php/ext/redis \
        && docker-php-ext-install redis \
        && rm -rf /usr/src/php

EXPOSE 9000
CMD ["php-fpm"]

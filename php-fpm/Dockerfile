FROM alpine:3.8

RUN apk --update add \
        php7 \
        php7-bcmath \
        php7-dom \
        php7-ctype \
        php7-curl \
        php7-fpm \
        php7-gd \
        php7-iconv \
        php7-intl \
        php7-json \
        php7-mbstring \
        php7-mcrypt \
        php7-mysqlnd \
        php7-mysqli \
        php7-opcache \
        php7-openssl \
        php7-pdo \
        php7-pdo_mysql \
        php7-pdo_pgsql \
        php7-pdo_sqlite \
        php7-phar \
        php7-posix \
        php7-session \
        php7-soap \
        php7-xml \
        php7-zip \
    && rm -rf /var/cache/apk/* \
    && addgroup -g 82 -S www-data \
    && adduser -u 82 -D -S -G www-data www-data

COPY php.ini /etc/php7/conf.d/php.ini
COPY php-fpm.conf /etc/php7/php-fpm.conf
COPY config.inc.php /config.inc.php
COPY start.sh /start.sh

RUN mkdir /var/www && \
chmod -R 755 /var/www


EXPOSE 9000

CMD ["sh", "/start.sh"]


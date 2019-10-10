FROM php:7.2-apache-buster

RUN apt-get update && apt-get install -y \
    cron \
    libbz2-1.0 \
    libc6 \
    libcomerr2 \ 
    libcurl4 \
    libexpat1 \ 
    libffi6 \ 
    libfreetype6 \ 
    libfreetype6-dev \
    libgcc1 \ 
    libgcrypt20 \ 
    libgmp10 \ 
    libgnutls30 \ 
    libgpg-error0 \ 
    libgssapi-krb5-2 \ 
    libhogweed4 \ 
    libicu-dev \
    libidn11 \ 
    libidn2-0 \ 
    libjpeg62-turbo \ 
    libjpeg62-turbo-dev \
    libk5crypto3 \ 
    libkeyutils1 \ 
    libkrb5-3 \ 
    libkrb5support0 \ 
    libldap-2.4-2 \ 
    liblzma5 \ 
    libmemcached11 \ 
    libmemcachedutil2 \ 
    libncurses5 \ 
    libnettle6 \ 
    libnghttp2-14 \ 
    libp11-kit0 \ 
    libpcre3 \ 
    libpng-dev \
    libpng16-16 \ 
    libpq5 \ 
    libpsl5 \ 
    libreadline7 \ 
    librtmp1 \ 
    libsasl2-2 \ 
    libsqlite3-0 \ 
    libssh2-1 \ 
    libssl1.1 \ 
    libstdc++6 \ 
    libsybdb5 \ 
    libtasn1-6 \
    libtinfo5 \ 
    libxml2 \ 
    libxml2-dev \
    libxslt1.1 \ 
    libzip4 \ 
    zlib1g \
    && apt-get clean
RUN docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) zip \
    && docker-php-ext-install -j$(nproc) mysqli \
    && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-install -j$(nproc) xmlrpc \
    && docker-php-ext-install -j$(nproc) soap

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY php-custom.ini /
RUN cat /php-custom.ini >> "$PHP_INI_DIR/php.ini" && rm /php-custom.ini

RUN sed -i -e '/pam_loginuid.so/ s/^#*/#/' /etc/pam.d/cron

RUN mkdir /shifters

ADD https://github.com/moodle/moodle/archive/MOODLE_37_STABLE.tar.gz /shifters/moodle.tgz
RUN cd /shifters && tar zxf moodle.tgz && rm moodle.tgz
RUN rm -rf /var/www/html \
   && mv /shifters/moodle-MOODLE_37_STABLE /var/www/html \
   && chown -R www-data:www-data /var/www/html

RUN mkdir /var/www/moodledata && chown -R www-data:www-data /var/www/moodledata

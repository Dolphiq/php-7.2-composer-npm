FROM php:7.2-fpm

RUN apt-get update && apt-get install -y libmcrypt-dev libpng-dev libfreetype6-dev libjpeg62-turbo-dev gnupg git zip unzip \
    mysql-client libmagickwand-dev --no-install-recommends \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install bcmath pdo_mysql opcache zip \
    && docker-php-ext-enable opcache

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs build-essential
RUN apt-get install -y ssh rsync

RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer


# install prefered locales to use
RUN apt-get install -y locales && \
    sed -i 's/^# *\(en_US\)/\1/' /etc/locale.gen && \
    sed -i 's/^# *\(nl_NL\)/\1/' /etc/locale.gen && \
    locale-gen

WORKDIR /var/www

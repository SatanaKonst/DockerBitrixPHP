FROM php:7.4-apache
RUN apt-get update && apt-get install -y locales && \
    echo "Europe/Moscow" > /etc/timezone && \
    sed -i -e "s/# ru_RU.UTF-8.*/ru_RU.UTF-8 UTF-8/" /etc/locale.gen && \
    sed -i -e "s/# ru_RU.CP1251.*/ru_RU.CP1251 CP1251/" /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=ru_RU.UTF-8 && \
    rm -rf /etc/localtime && \
    ln -s /usr/share/zoneinfo/Europe/Moscow /etc/localtime
RUN apt-get install -y \
    libwebp-dev \
    libjpeg62-turbo-dev \
    libpng-dev libxpm-dev \
    libfreetype6-dev \
    zlib1g-dev \
    libzip-dev \
    libmagickwand-dev \
    jpegoptim \
    optipng \
    gifsicle \
    webp \
    && pecl install imagick \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd opcache mysqli pdo_mysql zip \
    && docker-php-ext-enable imagick \
    && a2enmod rewrite && a2enmod headers

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

ARG UID=1000
ARG GID=1000
ENV UID=${UID}
ENV GID=${GID}
ENV USER_NAME="bitrix"

COPY start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]

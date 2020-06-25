FROM php:7.2-apache

RUN apt-get update

# development packages
RUN apt-get install -y \
git \
zip \
curl \
sudo \
unzip \
libicu-dev \
libbz2-dev \
libpng-dev \
libjpeg-dev \
libmcrypt-dev \
libreadline-dev \
libfreetype6-dev \
g++ \
nano

# apache configs + document root
ENV APACHE_DOCUMENT_ROOT=/path/to/local/project
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# mod_rewrite for URL rewrite and mod_headers for .htaccess extra headers like Access-Control-Allow-Origin-
RUN a2enmod rewrite headers

# start with base php config, then add extensions
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# imagick
RUN apt-get install -y --no-install-recommends libmagickwand-dev
RUN pecl install imagick-3.4.3
RUN docker-php-ext-enable imagick

# xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

RUN docker-php-ext-install \
bz2 \
intl \
iconv \
bcmath \
opcache \
calendar \
mbstring \
pdo_mysql \
zip

# install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
COPY project_dir .

#RUN composer install
#RUN composer install --prefer-dist
#RUN composer install --ignore-platform-reqs


COPY provision/laravel /tmp

ENTRYPOINT ["/tmp/docker-apache2-entrypoint.sh"]

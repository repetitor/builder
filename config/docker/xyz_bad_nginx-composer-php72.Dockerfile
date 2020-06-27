#+++++++++++++++++++++++++++++++++++++++
# Dockerfile for webdevops/php-nginx:7.2
#    -- automatically generated  --
#+++++++++++++++++++++++++++++++++++++++

FROM webdevops/php:7.2

ENV WEB_DOCUMENT_ROOT=/path/to/local/project \
    WEB_DOCUMENT_INDEX=index.php \
    WEB_ALIAS_DOMAIN=*.vm \
    WEB_PHP_TIMEOUT=600 \
    WEB_PHP_SOCKET=""
ENV WEB_PHP_SOCKET=127.0.0.1:9000

COPY provision/laravel/nginx-php72/ /opt/docker/

RUN set -x \
    # Install nginx
    && apt-install \
        nginx \
    && docker-run-bootstrap \
    && docker-image-cleanup

# 5. composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
WORKDIR /var/www/html
COPY app_project .
RUN composer install --prefer-dist
#RUN composer install --ignore-platform-reqs

# 6. run container
COPY provision/laravel /tmp
ENTRYPOINT ["/tmp/docker-nginx-entrypoint.sh"]

#EXPOSE 80 443

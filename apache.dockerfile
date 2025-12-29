# Multi-stage build, see https://docs.docker.com/develop/develop-images/multistage-build/
FROM alpine AS builder

ENV VERSION 0.11.1

ADD https://github.com/sabre-io/Baikal/releases/download/$VERSION/baikal-$VERSION.zip .
RUN apk add unzip && unzip -q baikal-$VERSION.zip

# Final Docker image
FROM php:8.4-apache

# Install Baikal and required dependencies
COPY --from=builder --chown=www-data:www-data baikal /var/www/baikal
RUN apt-get update            &&\
  apt-get install -y          \
    libcurl4-openssl-dev      \
    msmtp msmtp-mta           \
    libpq-dev                 &&\
  rm -rf /var/lib/apt/lists/* &&\
  docker-php-ext-install curl pdo pdo_mysql pdo_pgsql pgsql

# Configure Apache + HTTPS
COPY files/apache.conf /etc/apache2/sites-enabled/000-default.conf
RUN a2enmod rewrite ssl && openssl req -x509 -newkey rsa:2048 -subj "/C=  " -keyout /etc/ssl/private/baikal.private.pem -out /etc/ssl/private/baikal.public.pem -days 3650 -nodes
RUN sed 's/expose_php = On/expose_php = Off/g' /usr/local/etc/php/php.ini-production > /usr/local/etc/php/php.ini

# Expose HTTPS & data directory
EXPOSE 443
VOLUME /var/www/baikal/config
VOLUME /var/www/baikal/Specific

COPY files/docker-entrypoint.sh /docker-entrypoint.sh
COPY files/favicon.ico /var/www/baikal/html
COPY files/docker-entrypoint.d/*.sh files/docker-entrypoint.d/*.php files/docker-entrypoint.d/httpd/ /docker-entrypoint.d/
ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD  [ "apache2-foreground" ]

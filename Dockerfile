# Multi-stage build, see https://docs.docker.com/develop/develop-images/multistage-build/
FROM debian:9-slim AS builder

ENV VERSION 0.4.6

ADD https://github.com/sabre-io/Baikal/releases/download/$VERSION/baikal-$VERSION.zip /tmp/baikal.zip
RUN apt-get update && apt-get install unzip && unzip -q /tmp/baikal.zip -d /tmp


# Final Docker image
FROM php:7.0-apache

LABEL maintainer="cyrill.kulka@gmail.com"
LABEL description="Baikal is a Cal and CardDAV server, based on sabre/dav, that includes an administrative interface for easy management."
LABEL version="0.4.6"
LABEL repository="https://github.com/ckulka/baikal-docker"
LABEL website="http://sabre.io/baikal/"

# Install Baikal
COPY --from=builder --chown=www-data:www-data /tmp/baikal /var/www/baikal

# Configure Apache + HTTPS
COPY files/apache.conf /etc/apache2/sites-enabled/000-default.conf
RUN a2enmod rewrite ssl && openssl req -x509 -newkey rsa:2048 -subj "/C=  " -keyout /etc/ssl/private/baikal.private.pem -out /etc/ssl/private/baikal.public.pem -days 3650 -nodes

# Expose HTTPS & data directory
EXPOSE 443
VOLUME /var/www/baikal/Specific

COPY files/start.sh /opt
CMD [ "sh", "/opt/start.sh" ]

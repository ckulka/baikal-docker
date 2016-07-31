# Set the base image
FROM php:5-apache

# File Author / Maintainer
MAINTAINER Cyrill Kulka

# Version of Baikal
ENV VERSION 0.2.7

# Download & extract Baikal
RUN curl --location --output /tmp/baikal.tgz https://github.com/fruux/Baikal/releases/download/$VERSION/baikal-regular-$VERSION.tgz &&\
	gzip -dc /tmp/baikal.tgz | tar -xz --directory /var/www &&\
	mv /var/www/baikal-regular /var/www/baikal &&\
	chown -R www-data:www-data /var/www &&\
	rm /tmp/baikal.tgz

# Configure Apache + HTTPS
COPY files/baikal.conf /etc/apache2/sites-enabled/000-default.conf
RUN a2enmod ssl && openssl req -x509 -newkey rsa:2048 -subj "/C=  " -keyout /etc/ssl/private/baikal.private.pem -out /etc/ssl/private/baikal.public.pem -days 3650 -nodes

# Expose HTTPS & data directory
EXPOSE 443
VOLUME /var/www/baikal/Specific

# Set the base image
FROM php:5-apache

# File Author / Maintainer
MAINTAINER Cyrill Kulka

# Version of Baikal
ENV VERSION 0.2.7

# Download & extract Baikal
RUN apt-get update && apt-get install unzip &&\
	curl --location --output /tmp/baikal.zip https://github.com/fruux/Baikal/releases/download/$VERSION/baikal-flat-$VERSION.zip &&\
	unzip -q /tmp/baikal.zip -d /var/www &&\
	mkdir -p /var/www/baikal && mv /var/www/baikal-flat /var/www/baikal/html &&\
	chown -R www-data:www-data /var/www &&\
	rm /tmp/baikal.zip && apt-get autoremove -y unzip

# Configure Apache + HTTPS
COPY files/baikal.conf /etc/apache2/sites-enabled/000-default.conf
RUN a2enmod ssl && openssl req -x509 -newkey rsa:2048 -subj "/C=  " -keyout /etc/ssl/private/baikal.private.pem -out /etc/ssl/private/baikal.public.pem -days 3650 -nodes

# Expose HTTPS & data directory
EXPOSE 443
VOLUME /var/www/baikal/html/Specific

# Set the base image
FROM php:5.6-apache

# File Author / Maintainer
MAINTAINER Cyrill Kulka


## PREPARE INSTALL

# Version of Baikal
ENV VERSION 0.2.7

WORKDIR /var/www

# Install unzip for extracting baikal-flat
RUN apt-get update && apt-get install -y unzip


## BEGIN INSTALLATION

# 1. Download & unzip baikal-flat
# 2. Replace /var/www/html
# 3. Prepare files & folders so Baikal is ready to go
RUN \
  curl -O http://baikal-server.com/get/baikal-flat-$VERSION.zip &&\
  unzip baikal-flat-$VERSION.zip &&\
  \
  rm -rf html && mv baikal-flat html &&\
  \
  touch html/Specific/ENABLE_INSTALL &&\
  chown -R www-data:www-data html


## IMAGE CLEANUP

RUN \
  rm baikal-flat-$VERSION.zip &&\
  apt-get -y autoremove unzip && apt-get -y clean


## IMAGE CONFIGURATION

# Expose data directory
VOLUME /var/www/html/Specific


# Set the base image
FROM ckulka/baikal:latest

# File Author / Maintainer
MAINTAINER Cyrill Kulka


## PREPARE INSTALL

WORKDIR /var/www


## BEGIN INSTALLATION

RUN openssl genrsa -out /etc/ssl/private/apache.key 2048
RUN openssl req -subj "/C=DE/ST=Bayern/L=Munich/O=meh/CN=localhost" -new -x509 -key /etc/ssl/private/apache.key -days 365 -sha256 -out /etc/ssl/certs/apache.crt


## IMAGE CLEANUP


## IMAGE CONFIGURATION

# Expose SSL Port
EXPOSE 443

# Set the base image
FROM ckulka/baikal:latest

# File Author / Maintainer
MAINTAINER Cyrill Kulka


## BEGIN INSTALLATION

RUN \
  openssl genrsa -out /etc/ssl/private/baikal.key 2048 &&\
  openssl req -subj "/C=DE/ST=Bayern/L=Munich/O=meh/CN=localhost" -new -x509 -key /etc/ssl/private/baikal.key -days 365 -sha256 -out /etc/ssl/certs/baikal.crt &&\
  a2enmod ssl &&\
  sed -i 's/ssl-cert-snakeoil/baikal/g' /etc/apache2/sites-available/default-ssl.conf &&\
  sed -i 's/baikal.pem/baikal.crt/g' /etc/apache2/sites-available/default-ssl.conf &&\
  a2ensite  default-ssl.conf


## IMAGE CONFIGURATION

# Set log directory
ENV APACHE_LOG_DIR /var/log/apache2

# Set SSLCertificateFile (/etc/ssl/certs/${BAIKAL_CERT}) & SSLCertificateKeyFile (/etc/ssl/private/${BAIKAL_PK}) filename
ENV BAIKAL_CERT baikal.crt
ENV BAIKAL_PK baikal.key

# Data volume for cert folders
VOLUME /etc/ssl/certs
VOLUME /etc/ssl/private

# Expose SSL Port
EXPOSE 443

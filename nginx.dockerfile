# Multi-stage build, see https://docs.docker.com/develop/develop-images/multistage-build/
FROM alpine AS builder

ENV VERSION 0.9.2

ADD https://github.com/sabre-io/Baikal/releases/download/$VERSION/baikal-$VERSION.zip .
RUN apk add unzip && unzip -q baikal-$VERSION.zip

# Final Docker image
FROM nginx:1

LABEL description="Baikal is a Cal and CardDAV server, based on sabre/dav, that includes an administrative interface for easy management."
LABEL version="0.9.2"
LABEL repository="https://github.com/ckulka/baikal-docker"
LABEL website="http://sabre.io/baikal/"

# Install dependencies: PHP (with libffi6 dependency) & SQLite3
RUN curl -o /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg &&\
  apt update                  &&\
  apt install -y lsb-release  &&\
  echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list &&\
  apt remove -y lsb-release   &&\
  apt update                  &&\
    apt install -y            \
    php8.0-curl               \
    php8.0-fpm                \
    php8.0-mbstring           \
    php8.0-mysql              \
    php8.0-sqlite3            \
    php8.0-xml                \
    sqlite3                   &&\
  rm -rf /var/lib/apt/lists/* &&\
  sed -i 's/www-data/nginx/' /etc/php/8.0/fpm/pool.d/www.conf &&\
  sed -i 's/^listen = .*/listen = \/var\/run\/php-fpm.sock/' /etc/php/8.0/fpm/pool.d/www.conf

# Add Baikal & nginx configuration
COPY --from=builder baikal /var/www/baikal
RUN apt update \
 && apt install -y \
    msmtp msmtp-mta \
 && rm -rf /var/lib/apt/lists/* \
 && chown -R nginx:nginx /var/www/baikal
COPY files/nginx.conf /etc/nginx/conf.d/default.conf
COPY files/start*.sh /opt/

VOLUME /var/www/baikal/config
VOLUME /var/www/baikal/Specific
CMD /opt/start-nginx.sh

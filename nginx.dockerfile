ARG FROM_ARCH=amd64

# Multi-stage build, see https://docs.docker.com/develop/develop-images/multistage-build/
FROM alpine AS builder

ENV VERSION 0.8.0

ADD https://github.com/sabre-io/Baikal/releases/download/$VERSION/baikal-$VERSION.zip .
RUN apk add unzip && unzip -q baikal-$VERSION.zip

# Download QEMU, see https://github.com/ckulka/docker-multi-arch-example
ADD https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-arm.tar.gz .
RUN tar zxvf qemu-3.0.0+resin-arm.tar.gz --strip-components 1
ADD https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-aarch64.tar.gz .
RUN tar zxvf qemu-3.0.0+resin-aarch64.tar.gz --strip-components 1


# Final Docker image
FROM $FROM_ARCH/nginx:mainline

LABEL description="Baikal is a Cal and CardDAV server, based on sabre/dav, that includes an administrative interface for easy management."
LABEL version="0.8.0"
LABEL repository="https://github.com/ckulka/baikal-docker"
LABEL website="http://sabre.io/baikal/"

# Add QEMU
COPY --from=builder qemu-arm-static /usr/bin
COPY --from=builder qemu-aarch64-static /usr/bin

# Install dependencies: PHP & SQLite3
RUN curl -o /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg &&\
  echo "deb https://packages.sury.org/php/ buster main" > /etc/apt/sources.list.d/php.list &&\
  apt update &&\
  apt install -y \
  php8.0-curl \
  php8.0-dom \
  php8.0-fpm \
  php8.0-mbstring \
  php8.0-mysql \
  php8.0-sqlite \
  php8.0-xmlwriter \
  sqlite3 \
  && rm -rf /var/lib/apt/lists/* \
  && sed -i 's/www-data/nginx/' /etc/php/8.0/fpm/pool.d/www.conf

# Add Baikal & nginx configuration
COPY --from=builder baikal /var/www/baikal
RUN chown -R nginx:nginx /var/www/baikal
COPY files/nginx.conf /etc/nginx/conf.d/default.conf

VOLUME /var/www/baikal/config
VOLUME /var/www/baikal/Specific
CMD /etc/init.d/php8.0-fpm start && chown -R nginx:nginx /var/www/baikal/Specific && nginx -g "daemon off;"

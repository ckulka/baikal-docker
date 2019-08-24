# Multi-stage build, see https://docs.docker.com/develop/develop-images/multistage-build/
FROM alpine AS builder

ENV VERSION 0.5.1

ADD https://github.com/sabre-io/Baikal/releases/download/$VERSION/baikal-$VERSION.zip .
RUN apk add unzip && unzip -q baikal-$VERSION.zip


# Final Docker image
FROM nginx:mainline

LABEL description="Baikal is a Cal and CardDAV server, based on sabre/dav, that includes an administrative interface for easy management."
LABEL version="0.5.1"
LABEL repository="https://github.com/ckulka/baikal-docker"
LABEL website="http://sabre.io/baikal/"

# Install dependencies: PHP & SQLite3
RUN apt-get update && apt-get install -y \
    php7.3-dom \
    php7.3-fpm \
    php7.3-mbstring \
    php7.3-mysql \
    php7.3-sqlite \
    php7.3-xmlwriter \
    sqlite3 \
  && rm -rf /var/lib/apt/lists/* \
  && sed -i 's/www-data/nginx/' /etc/php/7.3/fpm/pool.d/www.conf

# Add Baikal & nginx configuration
COPY --from=builder baikal /var/www/baikal
RUN chown -R nginx:nginx /var/www/baikal
COPY files/nginx.conf /etc/nginx/conf.d/default.conf

VOLUME /var/www/baikal/Specific
CMD /etc/init.d/php7.3-fpm start && chown -R nginx:nginx /var/www/baikal/Specific && nginx -g "daemon off;"

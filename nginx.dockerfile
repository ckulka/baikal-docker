# Multi-stage build, see https://docs.docker.com/develop/develop-images/multistage-build/
FROM alpine AS builder

ENV VERSION 0.11.1

ADD https://github.com/sabre-io/Baikal/releases/download/$VERSION/baikal-$VERSION.zip .
RUN apk add unzip && unzip -q baikal-$VERSION.zip

# Final Docker image
FROM nginx:1

# Install dependencies: PHP (with libffi6 dependency) & SQLite3
RUN apt update                  &&\
  apt install -y            \
  php8.4-curl               \
  php8.4-fpm                \
  php8.4-mbstring           \
  php8.4-mysql              \
  php8.4-pgsql              \
  php8.4-sqlite3            \
  php8.4-xml                \
  sqlite3                   \
  msmtp msmtp-mta           &&\
rm -rf /var/lib/apt/lists/* &&\
sed -i 's/www-data/nginx/' /etc/php/8.4/fpm/pool.d/www.conf &&\
sed -i 's/^listen = .*/listen = \/var\/run\/php-fpm.sock/' /etc/php/8.4/fpm/pool.d/www.conf

# Add Baikal & nginx configuration
COPY files/docker-entrypoint.d/*.sh files/docker-entrypoint.d/*.php files/docker-entrypoint.d/nginx/ /docker-entrypoint.d/
COPY --from=builder --chown=nginx:nginx baikal /var/www/baikal
COPY files/favicon.ico /var/www/baikal/html
COPY files/nginx.conf /etc/nginx/conf.d/default.conf

VOLUME /var/www/baikal/config
VOLUME /var/www/baikal/Specific

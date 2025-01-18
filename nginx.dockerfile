# Multi-stage build, see https://docs.docker.com/develop/develop-images/multistage-build/
FROM alpine AS builder

ENV VERSION 0.10.1

ADD https://github.com/sabre-io/Baikal/releases/download/$VERSION/baikal-$VERSION.zip .
RUN apk add unzip && unzip -q baikal-$VERSION.zip

# Final Docker image
FROM nginx:1

# Install dependencies: PHP (with libffi6 dependency) & SQLite3
RUN curl -o /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg &&\
  apt update                  &&\
  apt install -y lsb-release  &&\
  echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list &&\
  apt remove -y lsb-release   &&\
  apt update                  &&\
    apt install -y            \
    php8.1-curl               \
    php8.1-fpm                \
    php8.1-mbstring           \
    php8.1-mysql              \
    php8.1-pgsql              \
    php8.1-sqlite3            \
    php8.1-xml                \
    sqlite3                   \
    msmtp msmtp-mta           &&\
  rm -rf /var/lib/apt/lists/* &&\
  sed -i 's/www-data/nginx/' /etc/php/8.1/fpm/pool.d/www.conf &&\
  sed -i 's/^listen = .*/listen = \/var\/run\/php-fpm.sock/' /etc/php/8.1/fpm/pool.d/www.conf

# Add Baikal & nginx configuration
COPY files/docker-entrypoint.d/*.sh files/docker-entrypoint.d/*.php files/docker-entrypoint.d/nginx/ /docker-entrypoint.d/
COPY --from=builder --chown=nginx:nginx baikal /var/www/baikal
COPY files/nginx.conf /etc/nginx/conf.d/default.conf

VOLUME /var/www/baikal/config
VOLUME /var/www/baikal/Specific

# Multi-stage build with the Baikal release's bundled dependencies.
FROM alpine AS builder

ENV VERSION=0.13.0

ADD https://github.com/sabre-io/Baikal/releases/download/$VERSION/baikal-$VERSION.zip .
RUN apk add --no-cache unzip && unzip -q baikal-$VERSION.zip

FROM nginx:stable-bookworm

# Use a signed, scoped Sury repository for PHP 8.4 on Debian Bookworm.
RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends ca-certificates curl; \
  curl -fsSL https://packages.sury.org/debsuryorg-archive-keyring.deb -o /tmp/sury-keyring.deb; \
  dpkg -i /tmp/sury-keyring.deb; \
  echo 'deb [signed-by=/usr/share/keyrings/debsuryorg-archive-keyring.gpg] https://packages.sury.org/php/ bookworm main' > /etc/apt/sources.list.d/php.list; \
  apt-get update; \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    php8.4-cli php8.4-curl php8.4-fpm php8.4-mbstring \
    php8.4-mysql php8.4-pgsql php8.4-sqlite3 php8.4-xml \
    sqlite3 msmtp msmtp-mta; \
  rm -f /tmp/sury-keyring.deb; \
  rm -rf /var/lib/apt/lists/*; \
  sed -i \
    -e 's/^user = .*/user = nginx/' \
    -e 's/^group = .*/group = nginx/' \
    -e 's/^listen = .*/listen = \/var\/run\/php-fpm.sock/' \
    -e 's/^listen.owner = .*/listen.owner = nginx/' \
    -e 's/^listen.group = .*/listen.group = nginx/' \
    /etc/php/8.4/fpm/pool.d/www.conf

COPY files/docker-entrypoint.d/*.sh files/docker-entrypoint.d/*.php files/docker-entrypoint.d/nginx/ /docker-entrypoint.d/
COPY --from=builder --chown=nginx:nginx baikal /var/www/baikal
COPY files/nginx.conf /etc/nginx/conf.d/default.conf

VOLUME /var/www/baikal/config
VOLUME /var/www/baikal/Specific

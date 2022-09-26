#!/bin/sh

set -e
ME=$(basename $0)

# Start PHP FPM if it exists
if [ -f "/etc/init.d/php8.0-fpm" ]; then
  echo >&3 "$ME: info: Starting PHP 8.0"
  /etc/init.d/php8.0-fpm start
elif [ -f "/etc/init.d/php8.1-fpm" ]; then
  echo >&3 "$ME: info: Starting PHP 8.1"
  /etc/init.d/php8.1-fpm start
fi

#!/bin/sh

/opt/start-msmtp.sh

/etc/init.d/php8.0-fpm start
chown -R nginx:nginx /var/www/baikal/Specific
nginx -g "daemon off;"

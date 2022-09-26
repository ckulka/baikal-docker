#!/bin/sh

echo "version : $1"

cp -R /usr/src/baikal /var/www

if ! [ -d /var/www/baikal/Specific/db ]
then
    mkdir -p/var/www/baikal/Specific/db
fi

if [ "$1" = "apache" ]
then
   echo "Starting Apache"
   chown -R www-data:www-data /var/www/baikal

   # Inject ServerName and ServerAlias if specified
   APACHE_CONFIG="/etc/apache2/sites-available/000-default.conf"
   if [ ! -z ${BAIKAL_SERVERNAME+x} ]
   then
	sed -i "s/# InjectedServerName .*/ServerName $BAIKAL_SERVERNAME/g" $APACHE_CONFIG
   fi

   if [ ! -z ${BAIKAL_SERVERALIAS+x} ]
   then
	sed -i "s/# InjectedServerAlias .*/ServerAlias $BAIKAL_SERVERALIAS/g" $APACHE_CONFIG
   fi

   apache2-foreground
fi

if [ "$1" = "nginx" ]
then
    echo "Starting Nginx"
    chown -R nginx:nginx /var/www/baikal

    /etc/init.d/php8.1-fpm start && chown -R nginx:nginx /var/www/baikal/Specific && nginx -g "daemon off;"
fi

if [ "$1" = "nginx-php8.0" ]
then
    echo "Starting Nginx"
    chown -R nginx:nginx /var/www/baikal

    /etc/init.d/php8.0-fpm start && chown -R nginx:nginx /var/www/baikal/Specific && nginx -g "daemon off;"
fi

echo "done"

#!/bin/sh

set -e
ME=$(basename $0)

if ! [ -d /var/www/baikal/Specific/db ]
then
  echo "$ME: info: Creating new Baikal database folder"
  mkdir -p /var/www/baikal/Specific/db
fi

# Detect if we're running in the Apache httpd image
if [ ! -z ${APACHE_CONFDIR+x} ]
then
  echo "$ME: info: Adjusting Baikal file permissions for Apache httpd"
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
fi

# Detect if we're running in the nginx image
if [ ! -z ${NGINX_VERSION+x} ]
then
  echo "$ME: info: Adjusting Baikal file permissions for nginx"
  chown -R nginx:nginx /var/www/baikal
fi

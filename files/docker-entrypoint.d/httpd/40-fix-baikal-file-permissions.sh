#!/bin/sh

# Ensure correct file permissions if flag is set
if [ ! -z ${BAIKAL_ENABLE_CHOWN+x} ]
then
  chown -R www-data:www-data /var/www/baikal
fi

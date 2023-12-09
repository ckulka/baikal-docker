#!/bin/sh

# Ensure correct file permissions, unless behaviour is explicitly disabled
if [ -z ${BAIKAL_SKIP_CHOWN+x} ]
then
  chown -R nginx:nginx /var/www/baikal
fi

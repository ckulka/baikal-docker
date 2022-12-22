#!/bin/sh

set -e
ME=$(basename $0)

if ! [ -d /var/www/baikal/Specific/db ]
then
  echo "$ME: info: Creating new Baikal database folder"
  mkdir -p /var/www/baikal/Specific/db
fi

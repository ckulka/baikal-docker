#!/bin/sh

# Find the PHP FPM service script and start it
find /etc/init.d -type f -name "php*-fpm" -exec "{}" "start" \;

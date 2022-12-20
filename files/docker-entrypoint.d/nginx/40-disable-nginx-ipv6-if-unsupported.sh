#!/bin/sh

# Based on /etc/docker-entrypoint.d/10-listen-on-ipv6-by-default.sh, since the
# same one cannot be used because the checksum of the default.conf differs.

set -e
ME=$(basename $0)

# Disable IPv6 configuration if not supported or nginx is not installed
# Added to resolve https://github.com/ckulka/baikal-docker/issues/73
if nginx -t 2>&1 >/dev/null | grep -q '\[emerg\] socket() \[::\]:80 failed (97: Address family not supported by protocol)'; then
    echo "$ME: info: Disable IPv6 in configuration"
    sed -i 's/listen \[::\]:80;/# listen \[::\]:80/' /etc/nginx/conf.d/default.conf
fi

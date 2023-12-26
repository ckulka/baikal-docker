#!/bin/sh

# See https://github.com/ckulka/baikal-docker/discussions/61

# Insert sendmail mailer definitions
if [ ! -z ${MSMTPRC+x} ]
then
  echo "$MSMTPRC" > /etc/msmtprc
  chown root:msmtp /etc/msmtprc
  chmod 644 /etc/msmtprc
fi

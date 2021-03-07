#!/bin/sh

sed -i "s/SMTP_URL/${SMTP_URL}/g" /etc/msmtprc
sed -i "s/SMTP_FROM/${SMTP_FROM}/g" /etc/msmtprc
sed -i "s/SMTP_USER/${SMTP_USER}/g" /etc/msmtprc
sed -i "s/SMTP_PASSWORD/${SMTP_PASSWORD}/g" /etc/msmtprc

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

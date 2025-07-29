#!/bin/sh

set -e
ME=$(basename $0)

# Exit if Home Assistant fix not enabled
if [ -z ${APPLY_HOME_ASSISTANT_FIX+x} ] || [ "$APPLY_HOME_ASSISTANT_FIX" != "true" ]
then
  exit 0
fi

# Skip further processing if the current Plugin.php file already has the Home Assistant fix
CHECKSUM="7a7c9adc36dfc6cf780039d1ff7800df3e5f138a  /var/www/baikal/vendor/sabre/dav/lib/CalDAV/Plugin.php"
if echo $CHECKSUM | sha1sum --check --status - ;
then
  echo "$ME: info: Home Assistant fix already applied"
  exit 0
fi

# Abort if the Plugin.php file differs from the packaged version.
# This means the user customized the Plugin.php file already and applying the 
# Home Assistant fix would remove any modifications the user did. We inform the
# user about this, so that they can make the necessary adjustments to their
# custom Plugin.php file.
CHECKSUM="22e5ac3311fa112e702363920ce86d90256aacc6  /var/www/baikal/vendor/sabre/dav/lib/CalDAV/Plugin.php"
if ! echo $CHECKSUM | sha1sum --check --status - ;
then
  echo "$ME: info: Plugin.php differs from the packaged version. It looks like you customized it already, so we won't overwrite it and remove your modifications. Please either revert your own changes, or apply the Home Assistant fix manually to your custom Plugin.php file."
  exit 1
fi


# Replace the Plugin.php file with the one with the Home Assistant fix
echo "$ME: info: Applying Home Assistant fix"
cp /docker-entrypoint.d/Plugin-with-home-assistant-fix.php /var/www/baikal/vendor/sabre/dav/lib/CalDAV/Plugin.php
echo "$ME: info: Applied Home Assistant fix"

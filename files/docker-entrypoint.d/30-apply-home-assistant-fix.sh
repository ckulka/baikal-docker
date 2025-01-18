#!/bin/sh

set -e
ME=$(basename $0)

# Exit if Home Assistant fix not enabled
if [ -z ${APPLY_HOME_ASSISTANT_FIX+x} ] || [ "$APPLY_HOME_ASSISTANT_FIX" != "true" ]
then
  exit 0
fi

# Abort if the Plugin.php file differs from the packaged version.
# This means either the user customized the Plugin.php file already, or the
# packaged version changed and the fix needs to be updated.
CHECKSUM="22e5ac3311fa112e702363920ce86d90256aacc6  /var/www/baikal/vendor/sabre/dav/lib/CalDAV/Plugin.php"
if ! echo $CHECKSUM | sha1sum --check --status - ;
then
  echo "$ME: info: Plugin.php differs from the packaged version"
  exit 1
fi


# Replace the Plugin.php file with the one with the Home Assistant fix
echo "$ME: info: Applying Home Assistant fix"
cp /docker-entrypoint.d/Plugin-with-home-assistant-fix.php /var/www/baikal/vendor/sabre/dav/lib/CalDAV/Plugin.php

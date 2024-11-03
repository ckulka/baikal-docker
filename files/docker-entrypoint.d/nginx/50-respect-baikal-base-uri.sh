#!/bin/sh

set -e
ME=$(basename $0)

# Parses the base_uri value from the Baikal configuration file and updates the
# Nginx configuration to serve Baikal from the specified URL subpath.

# Abort rewriting the Nginx configuration if it is not enabled by the
# RESPECT_BAIKAL_BASE_URI environment variable
if [ -z "$RESPECT_BAIKAL_BASE_URI" ]; then
  exit 0
fi

# Path to the Baikal configuration file
CONFIG_FILE="/var/www/baikal/Config/baikal.yaml"

# Extract the base_uri value from the configuration file
BASE_URI=$(grep 'base_uri:' "$CONFIG_FILE" | awk '{print $2}')

# Exit if the base_uri was not set, i.e. no adjustments have to be made
if [ -z "$BASE_URI" ]; then
  exit 0
fi

echo "$ME: info: Found Baikal base URI '$BASE_URI', updating Nginx configuration."

# Remove surrounding quotes (single and double) and trailing slashes
BASE_URI=$(echo $BASE_URI | sed 's/"//g')
BASE_URI=$(echo $BASE_URI | sed "s/'//g")
BASE_URI=$(echo $BASE_URI | sed 's/\/$//g')

# Create the "location" nginx configuration snippet to rewrite the URL
cat <<EOF > /tmp/snippet.txt

  # Remove URL prefix from the URL when Baikal is served from a sub path
  location ^~ $BASE_URI {
    rewrite ^ / last;
  }
  location ^~ $BASE_URI/ {
    rewrite ^$BASE_URI(.*)$ /\$1 last;
    rewrite ^ / last;
  }
EOF

# Check if the file was created successfully
if [ $? -ne 0 ]; then
  echo "$ME: error: Failed to create snippet file to update Nginx configuration."
  exit 1
fi

# Insert the "location" snippet into the Nginx configuration
sed -i '/charset utf-8;/r /tmp/snippet.txt' /etc/nginx/conf.d/default.conf
rm /tmp/snippet.txt

sed -i 's/# internal;/internal;/' /etc/nginx/conf.d/default.conf

# Update the rewrite rules for the CalDAV and CardDAV well-known URLs
sed -i "s|rewrite ^/.well-known/caldav /dav.php redirect;|rewrite ^$BASE_URI/.well-known/caldav $BASE_URI/dav.php redirect;|" /etc/nginx/conf.d/default.conf
sed -i "s|rewrite ^/.well-known/carddav /dav.php redirect;|rewrite ^$BASE_URI/.well-known/carddav $BASE_URI/dav.php redirect;|" /etc/nginx/conf.d/default.conf

# Upgrade to Baikal 0.13.0 with Nginx and PHP 8.4

The `nginx-php8.4.dockerfile` provides a source-built Baikal 0.13.0 image.
It does not change the existing published image tags. The image retains the
existing configuration, startup scripts, and persistent data paths.

## Prepare the build

Clone this repository beside your existing `docker-compose.yml`, into a directory
named `baikal-image`. Use a revision containing `nginx-php8.4.dockerfile`.

Create `compose.upgrade.yml` beside your existing Compose file:

```yaml
services:
  baikal:
    image: local/baikal:0.13.0-nginx-php8.4
    pull_policy: never
    build:
      context: ./baikal-image
      dockerfile: nginx-php8.4.dockerfile
```

Replace `baikal` with your existing service name if necessary. Keep the existing
project name, mounts, ports, environment variables, networks, and proxy settings.
Run all commands from the existing Compose project directory.

Build while the old service is still running:

```bash
docker compose -f docker-compose.yml -f compose.upgrade.yml build --pull baikal
docker run --rm --entrypoint php local/baikal:0.13.0-nginx-php8.4 -v
```

Confirm PHP 8.4 is reported.

## Back up before migrating

```bash
docker compose -f docker-compose.yml stop baikal
```

Back up both existing mounts, including hidden files:

- `/var/www/baikal/config`
- `/var/www/baikal/Specific` (including the database when using SQLite)

Back up an external database separately if applicable. Keep the old image and
Compose configuration for rollback. Do not run `docker compose down -v`, which
removes named volumes.

The legacy `APPLY_HOME_ASSISTANT_FIX=true` option is not supported by this new
variant: its bundled patch targets an older sabre/dav release. Remove that option
before starting the new image and verify any Home Assistant integration separately.

## Start and verify

```bash
docker compose -f docker-compose.yml -f compose.upgrade.yml up -d --no-deps baikal
docker compose -f docker-compose.yml -f compose.upgrade.yml logs --tail=100 baikal
```

Open your usual admin page and complete the upgrade prompts. Test calendar and
contact syncing. If the installer offers to create a new instance instead of
upgrading the existing one, stop and check the persistent mounts.

Continue passing both Compose files for subsequent commands:

```bash
docker compose -f docker-compose.yml -f compose.upgrade.yml ps
docker compose -f docker-compose.yml -f compose.upgrade.yml logs -f baikal
docker compose -f docker-compose.yml -f compose.upgrade.yml restart baikal
```

## Rollback

Stop the upgraded service, restore the pre-upgrade configuration and database
backups, and start the previous image. After a database migration, changing only
the image back is not a complete rollback.

See the [upstream upgrade instructions](https://sabre.io/baikal/upgrade/) and
[Baikal 0.13.0 release notes](https://github.com/sabre-io/Baikal/releases/tag/0.13.0).

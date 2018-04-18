# Baikal

This dockerfile provides a ready-to-go Baikal server.

For more details, see <https://github.com/ckulka/baikal-docker>

## Supported Tags

I follow the same naming scheme for the images as [Baikal](http://baikal-server.com/) themselves:

- [latest](https://github.com/ckulka/baikal-docker/tree/master) (corresponds to 0.4.6)
- [0.4.6](https://github.com/ckulka/baikal-docker/tree/0.4.6)
- [0.4.5](https://github.com/ckulka/baikal-docker/tree/0.4.5)
- [0.3.5](https://github.com/ckulka/baikal-docker/tree/0.3.5)
- [0.2.7](https://github.com/ckulka/baikal-docker/tree/0.2.7)

## Run

The following command will run Baikal over HTTP & HTTPS:

```bash
docker run --rm -it -p 80:80 -p 443:443 ckulka/baikal
```

Alternatively, use the provided [examples/docker-compose.yaml](https://github.com/ckulka/baikal-docker/blob/master/examples/docker-compose.yaml) from the Git repository:

```bash
docker-compose up
```

## Environment Variables

This image uses environment variables to set Apache's `ServerName` and `ServerAlias` directives.

### `BAIKAL_SERVERNAME`

This environment variable is used to set the global `ServerName` directive, e.g. `dav.example.io`.

For more details, see [Apache Core Features: ServerName Directive](https://httpd.apache.org/docs/2.4/mod/core.html#servername).

### `BAIKAL_SERVERALIAS`

This environment variable is used to set the `ServerAlias` directive of the `VirtualHost`s, e.g. `dav.example.org dav.example.com`.

For more details, see [Apache Core Features: ServerAlias Directive](https://httpd.apache.org/docs/2.4/mod/core.html#serveralias).

## Systemd

I also included a [Systemd service file](https://github.com/ckulka/baikal-docker/blob/master/baikal.service).

```bash
sudo curl -o /etc/systemd/system/baikal.service https://github.com/ckulka/baikal-docker/blob/master/baikal.service
# Adjust the WorkingDirectory variable

sudo systemctl enable baikal.service
```

This automatically starts the service.

## Persistent Data

The image exposes the `/var/www/baikal/Specific` folder, which contains the persistent data. This folder should be part of a regular backup.

## SSL Certificates

### Let's Encrypt

[Traefik](https://traefik.io/) is a modern HTTP reverse proxy that supports Docker + [Let's Encrypt](https://letsencrypt.org) and manages its configuration automatically and dynamically.

An example for Docker Compose can be found under [examples/docker-compose.letsencrypt.yaml](https://github.com/ckulka/baikal-docker/blob/master/examples/docker-compose.letsencrypt.yaml).

### Static Certificates

If you want to use your own certificates, either hide this container behind your own HTTPS proxy (e.g. [nginx](https://hub.docker.com/_/nginx/)) or you mount your certificates into the container:

```bash
# The folder /etc/ssl/private/baikal contains the files baikal.public.pem and baikal.private.pem
docker run --rm -it -p 80:80 -p 443:443 -v /etc/ssl/private/baikal:/etc/ssl/private/:ro ckulka/baikal
```

Alternatively, you can also provide your own Apache configuration and specify different certificates (see [files/baikal.conf](https://github.com/ckulka/baikal-docker/blob/master/files/baikal.conf)).

## Backup to AWS S3

I backup my persistent data to AWS S3 (<https://aws.amazon.com/de/s3>).

Docker-compose file: [examples/docker-compose.awss3.yaml]<https://github.com/ckulka/baikal-docker/blob/master/examples/docker-compose.awss3.yaml>

```bash
# Important: only start the baikal container
docker-compose up baikal

# On a regular basis, perform the backup
docker-compose run --rm backup
```

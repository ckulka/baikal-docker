# Baikal

This dockerfile provides a ready-to-go [Baikal server](http://sabre.io/baikal/).

For more details, see <https://github.com/ckulka/baikal-docker>

## Supported tags and respective Dockerfile links

I follow the same version naming scheme as [Baikal](http://baikal-server.com/) themselves.

### Simple Tags

The following tags are only available for `amd64` platforms.

- `0.5.3` ([0.5.3/Dockerfile](https://github.com/ckulka/baikal-docker/tree/0.5.3))
- `0.4.5` ([0.4.5/Dockerfile](https://github.com/ckulka/baikal-docker/tree/0.4.5))
- `0.3.5` ([0.3.5/Dockerfile](https://github.com/ckulka/baikal-docker/tree/0.3.5))
- `0.2.7` ([0.2.7/Dockerfile](https://github.com/ckulka/baikal-docker/tree/0.2.7))

### Shared Tags

The following tags are available for both `amd64` and `arm32v7` platforms.

- `experimental`, `experimental-apache`
  - `experimental-apache-amd64` ([master/Dockerfile.apache-amd64](https://github.com/ckulka/baikal-docker/blob/master/Dockerfile.apache-amd64))
  - `experimental-apache-arm32v7` ([master/Dockerfile.apache-arm32v7](https://github.com/ckulka/baikal-docker/blob/master/Dockerfile.apache-arm32v7))
- `experimental-nginx`
  - `experimental-nginx-amd64` ([master/Dockerfile.nginx-amd64](https://github.com/ckulka/baikal-docker/blob/master/Dockerfile.nginx-amd64))
  - `experimental-nginx-arm32v7` ([master/Dockerfile.nginx-arm32v7](https://github.com/ckulka/baikal-docker/blob/master/Dockerfile.nginx-arm32v7))
- `0.5.3`, `0.5.3-apache`, `apache`, `latest`
  - `0.5.3-apache-amd64`, `apache-amd64` ([0.5.3/Dockerfile.apache-amd64](https://github.com/ckulka/baikal-docker/blob/0.5.3/Dockerfile.apache-amd64))
  - `0.5.3-apache-arm32v7`, `apache-arm32v7` ([0.5.3/Dockerfile.apache-arm32v7](https://github.com/ckulka/baikal-docker/blob/0.5.3/Dockerfile.apache-arm32v7))
- `0.5.3-nginx`, `nginx`
  - `0.5.3-nginx-amd64`, `nginx-amd64` ([0.5.3/Dockerfile.nginx](https://github.com/ckulka/baikal-docker/blob/0.5.3/Dockerfile.nginx-amd64))
  - `0.5.3-nginx-arm32v7`, `nginx-arm32v7` ([0.5.3/Dockerfile.nginx-arm32v7](https://github.com/ckulka/baikal-docker/blob/0.5.3/Dockerfile.nginx-arm32v7))

## Quick reference

- **Where to file issues**:
[https://github.com/ckulka/baikal-docker/issues](https://github.com/ckulka/baikal-docker/issues)
- **Supported architectures** ([more info](https://github.com/docker-library/official-images#architectures-other-than-amd64)):
[`amd64`](https://hub.docker.com/r/amd64/nginx/), [`arm32v7`](https://hub.docker.com/r/arm32v7/nginx/)
- **Image updates**:
[PRs for ckulka/baikal-docker](https://github.com/ckulka/baikal-docker/pulls)
- **Source of this description**:
[https://github.com/ckulka/baikal-docker](https://github.com/ckulka/baikal-docker)

## What is Baikal?

From <http://sabre.io/baikal/>:

>Baikal is a Cal and CardDAV server, based on sabre/dav, that includes an administrative interface for easy management.
>
>For more information, read the main website at baikal-server.com.
>
>Baikal is developed by Net Gusto and fruux.

## How to use this image

The following command will start Baikal:

```bash
docker run --rm -it -p 80:80 ckulka/baikal:nginx
```

Alternatively, use the provided [examples/docker-compose.yaml](https://github.com/ckulka/baikal-docker/blob/master/examples/docker-compose.yaml) from the Git repository:

```bash
docker-compose up
```

Then you can hit <http://localhost> or <http://host-ip> in your browser and use Baikal.

### Persistent Data

The image exposes the `/var/www/baikal/Specific` folder, which contains the persistent data. This folder should be part of a regular backup.

### Let's Encrypt + Traefik

[Traefik](https://traefik.io/) is a modern HTTP reverse proxy that supports Docker + [Let's Encrypt](https://letsencrypt.org) and manages its configuration automatically and dynamically.

An example for Docker Compose can be found at [examples/docker-compose.ssl.yaml](https://github.com/ckulka/baikal-docker/blob/master/examples/docker-compose.ssl.yaml).

This is my recommended approach, as your other containers can easily be added and you don't have to actively manage your certificates, Traefik creates new ones & replaces them when needed. Furthermore, since the image is an [official Docker image](https://hub.docker.com/_/traefik/), you won't have to worry as much about getting updates from a third party - aka me.

I included an example Docker Compose file [examples/docker-compose.ssl.yaml](https://github.com/ckulka/baikal-docker/blob/master/examples/docker-compose.ssl.yaml) as a template.

For more details on the Traefik configuration, see [Traefik's Docker](https://docs.traefik.io/configuration/backends/docker/) and [Traefik's Let's Encrypt](https://docs.traefik.io/configuration/acme/) docs.

### Static Certificates

If you want to use your own certificates, the recommended appraoch is to hide this container behind your own HTTPS proxy, e.g. with [Traefik's Static Certificates](https://docs.traefik.io/configuration/entrypoints/#static-certificates) or [nginx](https://hub.docker.com/_/nginx/).

This way your other containers can easily be added and since the images are either official Docker images, e.g. [Traefik](https://hub.docker.com/_/traefik/) and [nginx](https://hub.docker.com/_/nginx/), or  directly come the maintainers, you won't have to worry as much about getting updates from a third party - aka me.

Alternatively, if you're using the `apache` image variant, you can also mount your certificates into the container and expose the `443` port:

```bash
# The folder /etc/ssl/private/baikal contains the files baikal.public.pem and baikal.private.pem
docker run --rm -it -p 80:80 -p 443:443 -v /etc/ssl/private/baikal:/etc/ssl/private/:ro ckulka/baikal:apache
```

I also included a Docker Compose template [examples/docker-compose.apache.yaml](https://github.com/ckulka/baikal-docker/blob/master/examples/docker-compose.apache.yaml)

### Systemd

To ensure Baikal is up after reboots, I also included a [Systemd service template](https://github.com/ckulka/baikal-docker/blob/master/baikal.service) which relies on the Docker Compose file to start all containers. Before you use it, make sure that the working directory matches your server setup.

```bash
sudo curl -o /etc/systemd/system/baikal.service https://github.com/ckulka/baikal-docker/blob/master/baikal.service
# Adjust the WorkingDirectory variable

sudo systemctl enable baikal.service
```

This automatically starts the service whenever your server (re)boots.

### Backup to AWS S3

I backup my persistent data to [AWS S3](https://aws.amazon.com/de/s3).

Docker-compose file: [examples/docker-compose.awss3.yaml](https://github.com/ckulka/baikal-docker/blob/master/examples/docker-compose.awss3.yaml)

```bash
# Important: only start the baikal container
docker-compose up baikal

# On a regular basis, perform the backup
docker-compose run --rm backup
```


## Image Variants

The `ckulka/baikal` images come in several flavors, each designed for a specific use case.

### `ckulka/baikal:<version>`

This is the defacto image. If you are unsure about what your needs are, you probably want to use this one.

### `ckulka/baikal:apache`

This image relies on Apache httpd and uses the [official PHP image](https://hub.docker.com/_/php/) that's packaged with the Apache web server.

It also ships with HTTPS support and self-signed certificates, which can be replaced by user-provided certificates - for more details, see the *SSL Certificates: Static Certificates* section.

This image uses environment variables to set Apache's `ServerName` and `ServerAlias` directives to avoid Apache httpd's warnings in the logs.

The `BAIKAL_SERVERNAME` environment variable is used to set the global `ServerName` directive, e.g. `dav.example.io`. For more details, see [Apache Core Features: ServerName Directive](https://httpd.apache.org/docs/2.4/mod/core.html#servername).

The `BAIKAL_SERVERALIAS` environment variable is used to set the `ServerAlias` directive of the `VirtualHost`s, e.g. `dav.example.org dav.example.com`. For more details, see [Apache Core Features: ServerAlias Directive](https://httpd.apache.org/docs/2.4/mod/core.html#serveralias).

### `ckulka/baikal:experimental`

This image builds the `master` branch from the source repository [ckulka/baikal-docker](https://github.com/ckulka/baikal-docker). Use at your own risk.

### `ckulka/baikal:nginx`

This image relies on [nginx](https://www.nginx.com/) and uses the [official nginx image](https://hub.docker.com/_/nginx/).

Compared to the Apache variant, it is significantly smaller (less than half the size) and produces no warning messages out-of-the-box.

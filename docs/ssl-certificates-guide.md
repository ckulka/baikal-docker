# SSL Certificates Guide

## Let's Encrypt + Traefik

[Traefik](https://traefik.io/) is a modern HTTP reverse proxy that supports Docker + [Let's Encrypt](https://letsencrypt.org) and manages its configuration automatically and dynamically.

An example for Docker Compose can be found at [examples/docker-compose.ssl.yaml](https://github.com/ckulka/baikal-docker/blob/master/examples/docker-compose.ssl.yaml).

This is my recommended approach, as your other containers can easily be added and you don't have to actively manage your certificates, Traefik creates new ones & replaces them when needed. Furthermore, since the image is an [official Docker image](https://hub.docker.com/_/traefik/), you won't have to worry as much about getting updates from a third party - aka me.

I included an example Docker Compose file [examples/docker-compose.ssl.yaml](https://github.com/ckulka/baikal-docker/blob/master/examples/docker-compose.ssl.yaml) as a template.

For more details on the Traefik configuration, see [Traefik's Docker](https://doc.traefik.io/traefik/providers/docker/) and [Traefik's Let's Encrypt](https://doc.traefik.io/traefik/https/acme/) docs.

## Static Certificates

If you want to use your own certificates, the recommended appraoch is to hide this container behind your own HTTPS proxy, e.g. with [Traefik's Static Certificates](https://docs.traefik.io/configuration/entrypoints/#static-certificates) or [nginx](https://hub.docker.com/_/nginx/).

This way your other containers can easily be added and since the images are either official Docker images, e.g. [Traefik](https://hub.docker.com/_/traefik/) and [nginx](https://hub.docker.com/_/nginx/), or directly come from the maintainers, you won't have to worry as much about getting updates from a third party - aka me. Security is important for all our internet facing workloads and using the official images makes keeping us safer just that much easier.

Alternatively, if you're using the `apache` image variant, you can also mount your certificates into the container and expose the `443` port:

```bash
# The folder /etc/ssl/private/baikal contains the files baikal.public.pem and baikal.private.pem
docker run --rm -it -p 80:80 -p 443:443 -v /etc/ssl/private/baikal:/etc/ssl/private/:ro ckulka/baikal:apache
```

I also included the Docker Compose template [examples/docker-compose.apache.yaml](https://github.com/ckulka/baikal-docker/blob/master/examples/docker-compose.apache.yaml) for this scenario.

If you're using the `nginx` variant and would like to mount your certificates, you can do something like this:

```bash
# The folder /etc/nginx/ssl contains the files nginx.crt and nginx.key
docker run --rm -it -p 80:80 -p 443:443 -v /etc/ssl/private/baikal:/etc/nginx/ssl/:ro ckulka/baikal:nginx
```
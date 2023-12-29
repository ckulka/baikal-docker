# Unraid Docker Baikal Installation Guide

If you would like to roll your own Baikal installation within [Unraid](https://unraid.net/) straight from Docker Hub, this is the guide for you. Many thanks to [@Joshndroid](https://github.com/Joshndroid) for contributing this guide.

## Prerequisites

This Unraid Docker Installation guide assumes a few things:

1. Enabled Docker in Unraid (see [Docker Management](https://wiki.unraid.net/Manual/Docker_Management))
1. Enabled [Community Applications (CA)](https://forums.unraid.net/topic/38582-plug-in-community-applications/) in Unraid
1. Enabled ability to utilize Docker Hub for search results (see settings within the apps tab)
1. (Optional) A reverse proxy container and network to allow for certificate handling & SSL connections

**Installation Note** – You can change the Docker image tag in the repository in the later steps to one that is suitable for your setup. See [ckulka/baikal (Docker Hub)](https://hub.docker.com/r/ckulka/baikal/tags?page=1&ordering=last_updated) or [ckulka/baikal-docker (Github)](https://github.com/ckulka/baikal-docker) for a list of all available Docker image tags.

**Further Installation Note** – If you utilise an external database such as [MariaDB](https://hub.docker.com/_/mariadb), please ensure that Baikal and the database can connect correctly:

- the database and user are created
- the database and Baikal containers are on the same network

## Installation

With that in mind, the installation of Baikal is rather simple once you have the above setup.

1. Head over to apps and search for "Baikal".

1. Click on the _ckulka/baikal_ repository within the search results to begin the installation of Baikal.

1. On the right in the template, switch from _Basic View_ to _Advanced View_.

1. Ensure that the Docker image tag in your Docker repository line is the image variant you want.

   For more details, see _Image Variants_ and the _Tags_ tab in [ckulka/baikal (Docker Hub)](https://hub.docker.com/r/ckulka/baikal).

1. Set your _Icon URL_ to <https://raw.githubusercontent.com/sabre-io/sabre.io/master/source/img/baikal.png> (Baikal logo from the official maintainers).

1. Set your _WebUI_ to `http://[IP]:[PORT:80]/`

   Change this to whatever suits your local server port requirements - see below.

1. Set _Extra Parameters_ to `--restart=always`.

   This will restart the container automatically if it ever crashes.

1. (Optional) Set your network type as needed.

   For example, set it to the same one of your reverse proxy container that handles HTTPS termination and certificate renewal.

1. Add in your static IP address that you will utilize for Baikal.

   This will make it easier to get to your hosted instance.

1. Add a new _path_ with

   - _Name_ is `Config`
   - _Container Path_ is `/var/www/baikal/config`
   - _Host Path_ is `/mnt/user/appdata/baikal/config` (change to where you store it on local server)
   - _Default Value_ is `/mnt/user/appdata/baikal/config` (see above)
   - _Acccess Mode_ is `Read/Write`
   - _Description_ is `Container Path: /var/www/baikal/config`

1. Add a new _path_ with

   - _Name_ is `Specific`
   - _Container Path_ is `/var/www/baikal/Specific`
   - _Host Path_ is `/mnt/user/appdata/baikal/specific` (change to where you store it on local server)
   - _Default Value_ is `/mnt/user/appdata/baikal/specific` (see above)
   - _Acccess Mode_ is `Read/Write`
   - _Description_ is `Container Path: /var/www/baikal/Specific`

1. Now add in a _port_ with

   - _Name_ is `Port`
   - _Container Port_ is `80`
   - _Host Port_ is `80` (change to the port where you want to expose Baikal over HTTP on your local server)
   - _Default Value_ is `80` (see above)
   - _Connection Type_ is `TCP`
   - _Description_ is `Container Port: 80`

1. Click _Apply_ to download and install the container.

1. Start your Baikal docker container

1. (Optional) Set up SSL

   Head over to your SSL certificate provider container of choice and set-up as necessary to serve the certificates of your Baikal instance for your domain.

1. Head over to your Baikal web interface and start the Baikal initialisation process.

   You can access the web interface on the exposed port `http://[IP]:[PORT]`.

   During the Baikal initialisation process, you can choose between a SQLite database or an external database such as [MariaDB](https://hub.docker.com/_/mariadb). When using an separate container as external database, make sure the Baikal and database container are on the same network.

   If you are choosing to go with an external database container, you will need to set it up beforehand in order for Baikal to connect to it correctly, e.g. setting up the database user.

Your Baikal instance now up all set, congratulations 🎉 🙌

This dockerfile provides a ready-to-go Baikal server.


### Supported Tags

I follow the same naming scheme for the images as [Baikal](http://baikal-server.com/) themselves:
 - latest (corresponds to 0.2.7)
 - 0.2.7


###  Image Details

Baikal Server based on php:5.6-apache and Baikal 0.2.7
 - Exposes port 80
 - Data volume for ````/var/www/html/Specific```


### Usage

#### Build Docker Image

```
# Shell working directory is where this README.md is
docker build -t ckulka/baikal .
```

#### Run Baikal server

There are two ways to run the Baikal server: using the service scripts and the manual way.


#### Service Script

The service script's intended use is for /etc/init.d and provides the usual commands:

```
# Shell working directory is where this README.md is
baikal-server.sh {start | stop | restart | status}
```


##### The Manual Way

Note that the ```docker run``` command is running in the foreground, due to the conflicting ```-d``` and ```--rm``` flags.

```
# Create Baikal server volume container with the name “baikal-server-data”
docker create --name baikal-server-data ckulka/baikal /bin/true

# Run a Baikal server container
docker run -p 80:80 --rm --volumes-from baikal-server-data ckulka/baikal
```

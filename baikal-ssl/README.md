This dockerfile provides a ready-to-go Baikal server with HTTPS.


### Supported Tags

I follow the same naming scheme for the images as [Baikal](http://baikal-server.com/) themselves:
 - latest (corresponds to 0.2.7)
 - 0.2.7


###  Image Details

Baikal Server based on [ckulka/baikal](https://registry.hub.docker.com/u/ckulka/baikal/)
 - Exposes port 80 & 443
 - Data volume for ```/var/www/html/Specific```, ```/etc/ssl/certs``` & ```/etc/ssl/private```
 - Environment variables ```BAIKAL_CERT``` and ```BAIKAL_PK```

# Custom Certificates

You have to mount the two ```/etc/ssl/...``` volumes and either provide a ```baikal.crt``` and ```baikal.pem``` file, 
or override the filenames via the environment variables ```BAIKAL_CERT``` and ```BAIKAL_PK```.


### Usage

#### Build Docker Image

```
# Shell working directory is where this README.md is
docker build -t ckulka/baikal-ssl .
```

#### Run Baikal server

There are two ways to run the Baikal server: using the service scripts and the manual way.


#### Service Script

The service script's intended use is for /etc/init.d and provides the usual commands:

```
# Shell working directory is where this README.md is
baikal-ssl-server.sh {start | stop | restart | status}
```


##### The Manual Way

Note that the ```docker run``` command is running in the foreground, due to the conflicting ```-d``` and ```--rm``` flags.

```
# Create Baikal server volume container with the name “baikal-server-data”
docker create --name baikal-ssl-server-data ckulka/baikal-ssl /bin/true

# Run a Baikal server container
docker run -p 80:80 --rm --volumes-from baikal-ssl-server-data ckulka/baikal-ssl
```

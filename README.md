This dockerfile provides a ready-to-go Baikal server.

For more details, see https://github.com/ckulka/baikal-docker

### Supported Tags

I follow the same naming scheme for the images as [Baikal](http://baikal-server.com/) themselves:
 - latest (corresponds to 0.4.5)
 - 0.4.5


### Run

The following command will run Baikal, including HTTPS over self-signed certificates:
```
docker run --rm -it -p 443:443 -p 443:443 ckulka/baikal
```
Alternatively, use the provided [docker-compose.yml](https://github.com/ckulka/baikal-docker/blob/master/docker-compose.yml) from the Git repository:
```
docker-compose up baikal
```

#### Systemd

I also included a Systemd service file.
```
sudo curl -O https://github.com/ckulka/baikal-docker/blob/master/baikal.service
# Adjust the location of the docker-compose.yml

sudo systemctl enable baikal.service
```
This automatically starts the service.

### SSL Certificates

If you want to use your own certificates, either hide this container behind your own HTTPS proxy (e.g. nginx) or you mount your certificates into the container:
```
# The folder /etc/ssl/private/baikal contains the files baikal.public.pem and baikal.private.pem
docker run --rm -it -p 80:80 -p 443:443 -v /etc/my-certs/baikal:/etc/ssl/private/:ro ckulka/rpi-baikal
```
Alternatively, you can also provide your own Apache configuration  and specify different certificates (see [baikal-docker/files/baikal.conf](https://github.com/ckulka/baikal-docker/blob/master/files/baikal.conf)).

### Backup to AWS S3

I backup my persistent data to AWS S3 (https://aws.amazon.com/de/s3).

My docker-compose file: https://github.com/ckulka/baikal-docker/blob/master/docker-compose.yml
```
# On a regular basis, perform the backup
docker-compose run --rm backup
```

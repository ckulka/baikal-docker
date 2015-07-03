#!/bin/bash

### BEGIN INIT INFO
# Provides:           baikal-ssl-server
# Required-Start:     $network docker
# Required-Stop:      
# Should-Start:       
# Should-Stop:        
# Default-Start:      2 3 4 5
# Default-Stop:       0 1 6
# Short-Description:  Baikal server container
### END INIT INFO

# Docker image that is used
IMAGE="ckulka/baikal-ssl:0.2.7"

# Name of the runtime container & its data volume container
NAME="baikal-ssl-server"
DATA_NAME="$NAME-data"

# Add your exposed GoCD Server ports here
PORTS="-p 80:80 -p 443:443"

# Add your host mounts here if you want to - for whatever reason - mount directories from your host system instead of the data volume container.
VOLUMES=""
#VOLUMES="$VOLUMES -v /var/www/html/Specific:/var/baikal/Specific"
#VOLUMES="$VOLUMES -v /etc/ssl/certs:/etc/ssl/certs"
#VOLUMES="$VOLUMES -v /etc/ssl/private:/etc/ssl/private"

start() {

	docker inspect $DATA_NAME &> /dev/null
	if [ "$?" != "0" ]; then
		echo "docker create --name $DATA_NAME $VOLUMES $IMAGE /bin/true"
		echo -n "Creating new data volume container $DATA_NAME: "
		docker create --name $DATA_NAME $VOLUMES $IMAGE /bin/true
	else
		echo "Using existing data volume container: $DATA_NAME"
	fi

	echo "Starting new $IMAGE container: $NAME"
	docker run -d  $PORTS --volumes-from $DATA_NAME --name $NAME $IMAGE
}

stop() {
	echo "Stopping $IMAGE & removing old runtime container: $NAME"
	docker stop $NAME && docker rm $NAME
}

restart() {
	silentStatus && stop
	start
}

status() {
	docker inspect $NAME
}

silentStatus() {
	docker inspect $NAME &> /dev/null
}

case "$1" in
	start)
		silentStatus || $1
		;;
	stop)
		silentStatus || exit 0
		$1
		;;
	restart)
		$1
		;;
	status)
		$1
		;;
	*)
		echo "Usage: $0 {start | stop | status}"
		exit 2
		;;
esac

exit $?

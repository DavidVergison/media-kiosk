#!/bin/bash

source ./move.sh

docker stop nginx > /dev/null 2>&1
docker rm nginx > /dev/null 2>&1

docker run \
    --name nginx \
    -p 8080:80 \
    -v $PWD/site:/usr/share/nginx/html:ro \
    -d nginx

xset -dpms
xset s off

openbox-session &

while true; do
  firefox-kiosk "http://localhost:8080"
done
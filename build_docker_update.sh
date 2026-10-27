#!/bin/bash

containername=temporalcortex-fteqw
container=$(docker container ps -aqf "name=${containername}")

docker cp ./*.c ${container}:/temporalcortex/.
docker container start -i ${container}

#container=$(docker container run -it --name ${containername} --env DISPLAY=${DISPLAY} --user=fteqwtc:fteqwtc --mount type=bind,src=/tmp/.X11-unix,dst=/tmp/.X11-unix,readonly --mount type=bind,src=${PWD},dst=/temporalcortex --mount type=bind,src=${PWD}/../game_files/quake1,dst=/mnt/game --mount type=bind,src=${HOME},dst=/mnt/home-host,readonly ${imagename})

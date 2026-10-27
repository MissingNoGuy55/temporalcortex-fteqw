#!/bin/bash

repository=missingnoguy55/temporalcortex-fteqw
imagename=${repository}:latest
containername=temporalcortex-fteqw

if [[ $(docker image ls -aqf "reference=${repository}") != "" ]]; then
    docker image rm -f ${imagename}
fi

if [[ $(docker container ps --filter=name=${containername}) != "" ]]; then
    docker container rm -f ${containername}
fi

image=$(docker build --tag ${imagename} .)

container=$(docker container create -it --name ${containername} --env DISPLAY=${DISPLAY} --user=fteqwtc:fteqwtc --mount type=bind,src=/tmp/.X11-unix,dst=/tmp/.X11-unix,readonly --mount type=bind,src=${PWD}/../game_files/quake1,dst=/mnt/game,readonly --mount type=bind,src=${HOME},dst=/mnt/home-host,readonly --mount type=bind,src=${PWD},dst=/temporalcortex ${imagename})

# Copy final result to host system
docker cp ${container}:/usr/local/bin/fteqwtc ../game_files/quake1
docker cp ${container}:/usr/local/bin/fteqwtc.db ../game_files/quake1
docker cp ${container}:/usr/local/bin/fteqwtc-sv ../game_files/quake1
docker cp ${container}:/usr/local/bin/fteqwtc-sv.db ../game_files/quake1

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

mod_src_dir=$(pwd)
mod_src_dir_name=$(basename -- "$mod_src_dir")
mod_base_dir=$(dirname -- "$mod_src_dir")

container=$(docker container create -it \
--device /dev/snd \
--name ${containername} \
--env DISPLAY=${DISPLAY} \
--env ALSA_CARD=Generic \
--userns=host \
--mount type=bind,src=/var/run/dbus,dst=/var/run/dbus,readonly \
--mount type=bind,src=/tmp/.X11-unix,dst=/tmp/.X11-unix,readonly \
--mount type=bind,src=${PWD}/../game_files/quake1,dst=/mnt/game,readonly \
--mount type=bind,src=${HOME},dst=/mnt/home-host,readonly \
--mount type=bind,src=${PWD},dst=/"$mod_src_dir_name" \
${imagename})

# Copy final result to host system
#docker cp ${container}:/usr/local/bin/fteqwtc ../game_files/quake1
#docker cp ${container}:/usr/local/bin/fteqwtc.db ../game_files/quake1
#docker cp ${container}:/usr/local/bin/fteqwtc-sv ../game_files/quake1
#docker cp ${container}:/usr/local/bin/fteqwtc-sv.db ../game_files/quake1

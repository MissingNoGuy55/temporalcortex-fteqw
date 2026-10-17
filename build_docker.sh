#!/bin/bash

imagename=missingnoguy55/temporalcortex-fteqw:latest
image=$(docker build --tag ${imagename} .)
container=$(docker container create ${imagename})

docker cp ${container}:/temporalcortex/engine/release ../game_files/quake1/

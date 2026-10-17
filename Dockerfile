FROM debian:trixie AS build

WORKDIR /temporalcortex
RUN apt-get update
RUN apt-get install build-essential libx11-dev libgl-dev libxss-dev libxrandr-dev libxcursor-dev libasound2-dev libavcodec-dev libavformat-dev libswscale-dev libx11-6 libsdl2-2.0-0 libpng-dev zip wget -y
COPY . .

WORKDIR /temporalcortex/engine
RUN make makelibs
RUN make FTE_CONFIG=fteqwtc sv-rel m-rel plugins-rel

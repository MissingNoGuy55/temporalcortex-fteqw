#!/bin/bash

make $@ m-rel FTE_TARGET=win64 && make $@ m-rel && make $@ sv-rel && \
make $@ sv-rel FTE_TARGET=win64 && make $@ qcc-rel && make $@ qcc-rel FTE_TARGET=win64 && \
cp ./release/fteqw ../../game_files/quake1 && cp ./release/fteqw-sv ../../game_files/quake1 && cp ./release/fteqw64.exe ../../game_files/quake1 && cp ./release/fteqwsv64.exe ../../game_files/quake1 && \
cp ./release/fteqw-sv ../../game_files/quake1

make $@ plugins-rel && cp ./release/*.so ../../game_files/quake1 && make $@ plugins-rel FTE_TARGET=win64 && cp ./release/*.dll ../../game_files/quake1

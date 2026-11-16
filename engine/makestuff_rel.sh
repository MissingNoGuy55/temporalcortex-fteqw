#!/bin/bash

# Missi: Separated from the rest. Cannot run this with -j$(nproc) as it uses wget,
# which does not handle multithreading well.
make makelibs FTE_TARGET=win64 FTE_CONFIG=fteqwtc && make FTE_CONFIG=fteqwtc makelibs

make $@ m-rel FTE_TARGET=win64 FTE_CONFIG=fteqwtc && make $@ m-rel FTE_CONFIG=fteqwtc && \
make $@ sv-rel FTE_CONFIG=fteqwtc && make $@ sv-rel FTE_TARGET=win64 FTE_CONFIG=fteqwtc && \
make $@ qcc-rel FTE_CONFIG=fteqwtc && make $@ qcc-rel FTE_TARGET=win64 FTE_CONFIG=fteqwtc && \
make $@ iqm-rel FTE_CONFIG=fteqwtc && make $@ qcc-rel FTE_TARGET=win64 FTE_CONFIG=fteqwtc && \
make $@ iqm-rel FTE_TARGET=win64 FTE_CONFIG=fteqwtc && make $@ qcc-rel FTE_TARGET=win64 FTE_CONFIG=fteqwtc && \
cp ./release/fteqwtc ../../game_files/quake1 && \
cp ./release/fteqwtc64.exe ../../game_files/quake1 && \
cp ./release/fteqwtcsv64.exe ../../game_files/quake1 && \
cp ./release/fteqwtc-sv ../../game_files/quake1 && \
cp ./release/fteqcc ../../game_files/quake1 && \
cp ./release/fteqcc64.exe ../../game_files/quake1 && \
cp ./release/iqmtool ../../game_files/quake1 && \
cp ./release/iqmtool64.exe ../../game_files/quake1

make plugins-rel FTE_CONFIG=fteqwtc && cp ./release/*.so ../../game_files/quake1 && make plugins-rel FTE_TARGET=win64 FTE_CONFIG=fteqwtc && cp ./release/*.dll ../../game_files/quake1

#!/bin/bash

# Missi: Separated from the rest. Cannot run this with -j$(nproc) as it uses wget,
# which does not handle multithreading well.
make makelibs FTE_TARGET=win64 FTE_CONFIG=fteqwtc && make FTE_CONFIG=fteqwtc makelibs

make -j$(nproc) $@ m-dbg FTE_TARGET=win64 FTE_CONFIG=fteqwtc && make -j$(nproc) $@ m-dbg FTE_CONFIG=fteqwtc && \
make -j$(nproc) $@ sv-dbg FTE_CONFIG=fteqwtc && make -j$(nproc) $@ sv-dbg FTE_TARGET=win64 FTE_CONFIG=fteqwtc && \
make -j$(nproc) $@ qcc-dbg FTE_CONFIG=fteqwtc && make -j$(nproc) $@ qcc-dbg FTE_TARGET=win64 FTE_CONFIG=fteqwtc && \
cp ./debug/fteqwtc ../../game_files/quake1 && \
cp ./debug/fteqwtc-sv ../../game_files/quake1 && \
cp ./debug/fteqwtc64.exe ../../game_files/quake1 && \
cp ./debug/fteqwtcsv64.exe ../../game_files/quake1

make plugins-dbg FTE_CONFIG=fteqwtc && cp ./debug/*.so ../../game_files/quake1 && make plugins-dbg FTE_TARGET=win64 FTE_CONFIG=fteqwtc && cp ./debug/*.dll ../../game_files/quake1

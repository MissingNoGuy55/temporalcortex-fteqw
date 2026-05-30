#!/bin/bash

# Missi: Separated from the rest. Cannot run this with -j$(nproc) as it uses wget,
# which does not handle multithreading well.
make makelibs FTE_TARGET=win64 FTE_CONFIG=fteqwtc && make FTE_CONFIG=fteqwtc makelibs

make $@ m-dbg FTE_TARGET=win64 && make $@ m-dbg && make $@ sv-dbg && \
make $@ sv-dbg FTE_TARGET=win64 && make $@ qcc-dbg && make $@ qcc-dbg FTE_TARGET=win64 && \
cp ./debug/fteqw ../../game_files && cp ./debug/fteqw-sv ../../game_files && cp ./debug/fteqw64.exe ../../game_files && cp ./debug/fteqwsv64.exe ../../game_files && \
cp ./debug/fteqw-sv ../../game_files

make $@ plugins-dbg && cp ./debug/*.so ../../game_files && make $@ plugins-dbg FTE_TARGET=win64 && cp ./debug/*.dll ../../game_files

#!/bin/bash

make $@ m-dbg FTE_TARGET=win64 FTE_CONFIG=fteqwtc && make $@ m-dbg FTE_CONFIG=fteqwtc && \
make $@ mcl-dbg FTE_TARGET=win64 FTE_CONFIG=fteqwtc && make $@ mcl-dbg FTE_CONFIG=fteqwtc && \
make $@ sv-dbg FTE_CONFIG=fteqwtc && make $@ sv-dbg FTE_TARGET=win64 FTE_CONFIG=fteqwtc && \
make $@ qcc-dbg FTE_CONFIG=fteqwtc && make $@ qcc-dbg FTE_TARGET=win64 FTE_CONFIG=fteqwtc && \
cp ./debug/fteqwtc ../../game_files && \
cp ./debug/fteqwtc-sv ../../game_files && \
cp ./debug/fteqwtc64.exe ../../game_files && \
cp ./debug/fteqwtcsv64.exe ../../game_files && \
cp ./debug/fteqwtc-sv ../../game_files

make $@ plugins-dbg FTE_CONFIG=fteqwtc && cp ./debug/*.so ../../game_files && make $@ plugins-dbg FTE_TARGET=win64 FTE_CONFIG=fteqwtc && cp ./debug/*.dll ../../game_files

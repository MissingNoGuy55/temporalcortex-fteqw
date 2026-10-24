FROM debian:trixie AS build

WORKDIR /temporalcortex

RUN <<EOF
apt update
apt install build-essential libsdl2-2.0-0 libsdl2-dev libsdl3-0 libsdl3-dev alsa-utils libx11-6 x11-xserver-utils libx11-dev libgl-dev libxss-dev libxrandr-dev libxcursor-dev libasound2-dev libavcodec-dev libavformat-dev libswscale-dev libx11-6 libsdl3-0 libsdl3-dev libpng-dev mingw-w64 libz-mingw-w64-dev gdb zip wget git -y
EOF
COPY . .

# Add the user UID:1000, GID:1000, home at /yquake2
RUN groupadd -r fteqwtc -g 1000 && useradd -u 1000 -r -g fteqwtc -d /temporalcortex -s /sbin/nologin -c "fteqwtc user" fteqwtc && \
    chmod 775 /temporalcortex && chown fteqwtc /temporalcortex/engine

WORKDIR /temporalcortex/engine
RUN make -j${nproc} FTE_CONFIG=fteqwtc m-rel

WORKDIR /temporalcortex
RUN mkdir game

FROM build as finalize
COPY --from=build . .
RUN cp -r engine/release/fteqwtc /usr/local/bin

FROM finalize AS runtime
USER fteqwtc

ENTRYPOINT ["fteqwtc"]
CMD ["-basedir", "/mnt/game", "-manifest", "/mnt/game/temporalcortex.fmf"]

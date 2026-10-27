FROM debian:trixie AS build

WORKDIR /temporalcortex

RUN <<EOF
apt update
apt install build-essential libsdl2-2.0-0 libsdl2-dev libsdl3-0 libsdl3-dev alsa-utils libx11-6 x11-xserver-utils libx11-dev libgl-dev libxss-dev libxrandr-dev libxcursor-dev libasound2-dev libavcodec-dev libavformat-dev libswscale-dev libx11-6 libsdl3-0 libsdl3-dev libpng-dev mingw-w64 libz-mingw-w64-dev gdb zip wget git -y
apt install libvkd3d1 libvkd3d-dev dxvk -y
EOF
COPY . .

# Add the user UID:1000, GID:1000, home at /yquake2
RUN groupadd -r fteqwtc -g 1000 && useradd -u 1000 -r -g fteqwtc -d /temporalcortex -s /sbin/nologin -c "fteqwtc user" fteqwtc && \
    chmod 775 /temporalcortex && chown fteqwtc /temporalcortex/engine

WORKDIR /temporalcortex/engine
RUN make makelibs
RUN make -j${nproc} FTE_CONFIG=fteqwtc m-rel sv-rel

WORKDIR /temporalcortex

FROM build as finalize
COPY --from=build . .
RUN cp -r engine/release/fteqwtc /usr/local/bin
RUN cp -r engine/release/fteqwtc.db /usr/local/bin
RUN cp -r engine/release/fteqwtc-sv /usr/local/bin
RUN cp -r engine/release/fteqwtc-sv.db /usr/local/bin

FROM finalize AS runtime
USER fteqwtc

EXPOSE 27500/tcp
EXPOSE 27500/udp
EXPOSE 26000/tcp
EXPOSE 26000/udp

#ENTRYPOINT ["fteqwtc-sv"]
#CMD ["-basedir", "/mnt/game", "-manifest", "/mnt/game/temporalcortex.fmf", "+map", "mall"]

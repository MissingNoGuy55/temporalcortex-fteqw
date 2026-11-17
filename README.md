# [Temporal Cortex FTEQW](https://steamcommunity.com/id/missingnoguy55)

![Temporal Cortex FTEQW Logo](engine/client/fte_temporalcortex.ico)

# What is Temporal Cortex FTEQW?

Temporal Cortex FTEQW is a fork of the ![FTEQW](https://github.com/fte-team/fteqw) engine used for the game Temporal Cortex.

The game's main gimmick is time travel, achieved by having three BSPs loaded at runtime for each time period (past, present, future), with switching between the three as fast as the press of a button.

# Time travel compatibility list

| Game  | Status |
| ------------- | ------------- |
| NetQuake (vanilla) | Implemented, not tested |
| QuakeWorld (vanilla) | Implemented, not fully functional |
| NetQuake (FTE) | Implemented, not tested |
| QuakeWorld (FTE) | Implemented, fully functional |
| Quake II | Implemented, not functional and will crash |
| Quake III Arena | Implemented, not fully functional |
| Half-Life | Implemented, not tested |
| Half-Life 2 (FTE plugin modification) | Implemented, not tested |

# Building

The provided Dockerfile has all the necessary dependencies listed. If you do not feel like installing Docker, run this in a terminal from a clean installation:

```
apt install build-essential libsdl2-dev libsdl3-dev libx11-dev libgl-dev libxss-dev libxrandr-dev libxcursor-dev libasound2-dev libavcodec-dev libavformat-dev libswscale-dev libsdl3-dev libpng-dev mingw-w64 libz-mingw-w64-dev gdb zip wget git -y
```

to install all the dependencies.

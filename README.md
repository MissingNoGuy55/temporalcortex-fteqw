# [Temporal Cortex FTEQW](https://steamcommunity.com/id/missingnoguy55)

![Temporal Cortex FTEQW Logo](engine/client/fte_temporalcortex.ico)

# What is Temporal Cortex FTEQW?

Temporal Cortex FTEQW is a fork of the ![FTEQW](https://github.com/fte-team/fteqw) engine used for the game Temporal Cortex.

The game's main gimmick is time travel, achieved by having three BSPs loaded at runtime for each time period (past, present, future), with switching between the three as fast as the press of a button.

This project uses ***NO AI*** and will maintain that stance as such. Any PR's with vibecoding will be immediately rejected.

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

to install all the dependencies. Do *not* run this with `apt remove`, or you will most likely run into issues.

# How to time travel

In-game, bind any keys you want to `changetimeperiod [idx]`, which is a hardcoded console command with this engine. Valid values are `0` (present), `1` (past), and `2` (future). So, for example
```bind x "changetimeperiod 2"``` will bind the X key to changing time periods if `tc_sv_allow_host_time_travel` is set to `1`, which it is set to `1` by default.

To make individual time period BSPs, each BSP file needs to be suffixed with `_present`, `_past`, and `_future`, with the map name typed without any suffix at the console.

So, if you wanted to spawn inside `dev_present.bsp`, you would type 
```map dev``` at the console, and not  ```map dev_present```. The engine *does* autocomplete still with the suffixes present, so please be aware of that.

Absolute map names are supported for those who simply want to test specific time periods without loading all the BSPs at once.



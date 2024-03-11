## 7DRL engine for Apple IIe (enhanced)

This RogueLike engine was developed during 7DRL 2024 challenge. It features Depth-First search randomization of 5x5 room map, 4-directional character navigation and room mreveal mechanic.

Target: Apple II machine capable of rendering in 80 COL text mode and utilizing the Mouse Text character pallette.

![Mouse Text characters](https://www.foumartgames.com/dev/7drl/2024-untitled/mousetext.png)

Written mainly in plain BASIC, except where it wasn't possible to avoiding assembly routines. Such routine is the character screen reading mechanism (readchar.s). A lot of other implementations will have to be rewritten in ASM as well in order to work on a real Apple II machine decently enough. Righ now the text loading algorithm is being rewritten in ASM to greatly speed the loading and buffering processes..

Preview: https://www.foumartgames.com/dev/7drl/2024-untitled/#json/disks/7DRL2024.dsk

You should clock the emulator at 10Mhz or above, otherwise the program runs very slowly.

Current project is being built on top of https://github.com/foumart/AppleII.Project.template


## 7DRL 2024 game entry repo

Currently writting a simple RL engine to be used when the jam begins.

Target: Apple IIe, rendering in 80 COL text mode, utilizing the Mouse Text character pallette. For now using just plain BASIC, except where avoiding assembly routines becomes impossible. Such routine is the character screen reading mechanism (readchar.s). If I manage to tidy up a good engine and then succeed in creating a game, I will consider rewriting it all in ASM, so it could work on a real Apple II machine decently enough.

Preview: https://www.foumartgames.com/dev/7drl/2024-untitled/#json/disks/7DRL2024.dsk

The emulator is clocked at 10Mhz, otherwise the game runs very slowly.

Current project is being built on top of https://github.com/foumart/AppleII.Project.template


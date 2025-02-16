## 7DRL engine for Apple IIe (enhanced)

This Roguelike engine was primarily developed during the 7DRL 2024 challenge in March 2024, with additional efforts put recently in February 2025 to prepare for the next edition of 7DRL. The engine currently features depth-first search randomization of a 5x5 room map, four-directional character navigation, and a simple room-reveal mechanic.

Target: Apple II machine capable of rendering in 80 COL text mode and utilizing the Mouse Text character pallette.

An Apple //e (enhanced) will do the job.

![Mouse Text characters](https://www.foumartgames.com/dev/7drl/2024-untitled/mousetext.png)

The engine is written mainly in plain BASIC with some support ASSEMBLY routines. There is a character screen reading mechanism (readchar.s) and mouse text fast print routine (printmt.s). Other implementations will have to be rewritten in assembly as well in order to achieve decent speeds. For example the level generation currently is handled entirely in BASIC and it takes quite some time (around 40 seconds). If rewritten in Assembly it will take no more than a few seconds.

The project is organized in several BASIC files in attempt to better optimize the game for the limited Apple II memory. Initially a STARTUP.BAS file loads all the needed assembly routines and text data into memory. It then loads a MAIN.BAS file that is responsible with displaying all UI text and level generation. Finally the GAME.BAS is loaded at address $4000 instead in the default $800 so the memory available for the BASIC program and its variables could be expanded into a straight ~24kb range ($4000 - $9CFF), keeping the HGR page safe to display images, with the possibility to use the second text page ($800-$BFF) and make use of text page flipping in 80 Column mode if needed.

Preview: https://www.foumartgames.com/dev/7drl/2024-untitled/#json/disks/7drl-2024.dsk

Clocking the emulator at 4Mhz (like an accelerated CPU) or even better at 10Mhz, makes the game run responsively enough for the today's standards. But it works on a real Apple II hardware decently enough

The project is being built on top of https://github.com/foumart/AppleII.Project.template

Copyright (C) 2024-2025 by Noncho Savov

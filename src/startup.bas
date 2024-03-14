0 REM ROGUELIKE ENGINE FOR APPLE II BY NONCHO SAVOV
5 REM COPYRIGHT (C) 2024 BY FOUMARTGAMES, ALL RIGHTS RESERVED
10 REM DEVELOPED DURING 7DRL 2024 CHALLENGE

22 REM READCHAR ROUTINE SRC:
24 REM https://www.1000bit.it/support/manuali/apple/technotes/misc/tn.misc.10.html

26 REM BETTER ERROR HANDLING ROUTINE SRC:
28 REM https://www.applefritter.com/appleii-box/APPLE2/ErrormessagesFromONERR/Errormessages%20From%20ONERR.pdf

100 REM MEMORY LOCATIONS THAT ARE BEEN ACCESSED:
110 REM 0006 (6)               READCHAR CODE PLACEHOLDER
120 REM 0078,79 (120,121)      RANDOM SEED NUMBER 1 AND 2
130 REM 0068 (104)             THE HIGH BYTE OF THE BASIC PROGRAM CUSTOM LOADING ADDRESS

132 REM ASSEMBLY ROUTINES:
140 REM 0300 - 030F (768-783)  RANDOMIZE SEED ROUTINE WITH RND(NEGATIVE)
150 REM 0310 - 0338 (784-824)  READCHAR ROUTINE
160 REM 033A - 0344 (826-836)  ERROR HANDLING ROUTINE
162 REM 0350 - 0368 (848-872)  CLEAR DOUBLE HI-RES PAGE #1

170 REM VARIABLES AND ARRAY MEMORY LOCATIONS FOR DATA TRANSFER BETWEEN BAS FILES
175 REM 039B - 03B4 (923-948)  MAP
180 REM 03B5 - 03CE (949-974)  VISIBLES
190 REM 03CF - 03E8 (975-1000) INSIDES

195 REM TODO: USE GRAPHIC MEMORY SCREEN HOLES AND FREE UP 0345-03CF FOR ASSMEBLY SUBROUTINES
196 REM ALSO 03D0-03FF (976-1023) IS RESERVED FOR DOS, PRODOS AND INTERRUPT VECTORS

200 REM 03FF (1023)  DEBUG     (1-5:ON, 0:OFF)
210 REM 03FE (1022)  X         PLAYER X POSITION
220 REM 03FD (1021)  Y         PLAYER Y POSITION
230 REM 03FC (1020)  CLASS     PLAYER CLASS
240 REM 03FB (1019)  ??
250 REM 03FA (1018)  AK        ATTACK
260 REM 03F9 (1017)  AC        ARMOR CLASS
270 REM 03F8 (1016)  SR        STRENGTH
280 REM 03F7 (1015)  DX        DEXTERITY
290 REM 03F6 (1014)  IT        INTELLIGENCE
300 REM 03F5 (1013)  WI        WISDOM
310 REM 03F4 (1012)  HP        HEALTH
320 REM 03F3 (1011)  MP        MANA
330 REM 03F2 (1010)  AM        AMMO
340 REM 03F1 (1009)  GOLD      GOLD
350 REM 03F0 (1008)  EX        EXPERIENCE

375 REM STARTUP
380 REM 0800-0B8E (2048-2958)  DEFAULT LOADING ADDRESS. OTHER BASIC FILES WILL BE LOADED AT $4000 TO FREE UP TEXT PAGE 2
390 REM 1000-1764 (4096-5988)  INITIAL UI AND STORY (THIS WILL BE OVERWRITTEN BY OTHER UI DATA THAT WILL BE LOADED LATER)

395 REM MAIN & GAME
400 REM 0800-0BFF (2048-3071)  TEXT PAGE 2 (WILL BE KEPT FREE SO WE COULD USE TEXT PAGE FLIPPING IF NECESSARY)
410 REM 0C00-0FFF (3072-4095)  STARTSEED
420 REM 1000-11FF (4096-4607)  ENCOUNTER
430 REM 1200-13FF (4608-5119)  BATTLEWIN
440 REM 1400-15FF (5120-5631)  MORESTORY
450 REM 1600-17FF (5632-6143)  BEGINGAME
460 REM 1800-1FFF (6144-8191)  FREE SPACE
470 REM 2000-3FFF (8192-16383) GRAPHIC PAGE 1 SHOULD BE KEPT FREE SO WE COULD DISPLAY IMAGES
480 REM 4000-95FF(16384-38399) CUSTOM LOADING ADDRESS AND SPACE FOR OTHER BASIC FILES (WON'T BE USING GRAPHIC PAGE 2)

500 REM LOMEM: 24576 : REM PREVENT WRITING IN THE GRAPHIC PAGES (NOT NEEDED - STARTUP WAS OPTIMIZED ENOUGH TO NOT OCCUPY IT)

990 REM DEBUG 1: DISPLAYS INFORMATION IN THE BOTTOM - CURSOR POSITION, KEYCODE, FREE MEMORY LEFT, LEVEL DATA
991 REM DEBUG 2: SKIPS LOADING TEXT DATA FOR FASTER DEBUGGING, USING DEFAULT SEED - WILL PRODUCE THE SAME LEVEL EACH TIME
992 REM DEBUG 3: ANIMATED MAP GENERATION, ALSO USING RANDOMIZED SEED TO PRODUCE DIFFERENT LEVELS
993 REM DEBUG 4: WAIT FOR KEY PRESS ON EACH STEP DURING MAP GENERATION USING DEFAULT SEED
994 REM DEBUG 5: SAME AS ABOVE BUT USING RANDOMIZED SEED

1000 DEBUG = 0 : POKE 1023,DEBUG : REM WRITE DEBUG VALUE IN MEMORY

1060 D$ = CHR$(4) : REM DOS CONTROL
1070 MI$ = CHR$(15) : REM TURN INVERSE ON
1080 NI$ = CHR$(14) : REM TURN INVERSE OFF
1090 M$ = MI$ + CHR$(27) : REM TURN SPECIAL CHARACTERS ON (80COL MOUSE TEXT CARD CHARS)
1100 N$ = CHR$(24) + NI$ : REM TURN SPECIAL CHARACTERS OFF

1200 PRINT D$"PR#3" : PRINT CHR$(12) : REM TURN 80COL MODE ON, CLEAR WINDOW AND RESET CURSOR

1205 REM LOADS A SMALL ROUTINE AT $0300 THAT INCREMENTS THE RND LOCATIONS WHILE WAITING FOR KEYPRESS
1210 FOR O = 768 TO 782 : READ P
1215 POKE O,P : NEXT O : REM EXAMPLE: CALL 768 : X = RND(-1*(PEEK(78)+256*PEEK(79))) : PRINT X
1220 DATA 230,78,208,2,230,79,44,0,192,16,245,44,16,192,96

1225 PRINT D$"BLOAD READCHAR" : REM LOADS THE GET CHAR ROUTINE AT $0310 (784)
1226 PRINT D$"BLOAD CLEARDHR" : REM LOADS A ROUTINE TO CLEAR DHR AT $0350 (848)

1230 IF DEBUG > 1 THEN GOTO 10000

1235 POKE 49239,0 : REM TURN ON HIRES
1240 POKE 49237,0 : PRINT D$"BLOAD TITLE, A$2000, L$2000" : REM LOAD THE FG DHR TITLE PICTURE
1245 POKE 49236,0 : PRINT D$"BLOAD TITLE, A$2000, L$2000, B$2000" : REM LOAD THE REST OF THE DHR TITLE PICTURE IN AUX MEMORY
1250 POKE 49232,0 : REM TURN ON GRAPHICS
1255 POKE 49235,0 : REM TURN ON MIXED MODE
1260 POKE 49246,0 : REM TURN ON DHR

1310 VTAB(22) : REM DRAW LOADING BAR
1340 HTAB(20) : PRINT N$;"_            ___________________________"
1350 HTAB(20) : PRINT M$;"C";N$;" Buffering ";M$;"Z";N$;MI$;" ";NI$;M$;"W\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\";N$;
1430 PRINT MI$;" ";NI$;M$;"_";N$;
1435 VTAB(24) : HTAB(33) : PRINT M$;"LLLLLLLLLLLLLLLLLLLLLLLLLLL";N$;

1500 TADDR = 4096 : REM FREE MEMORY SPACE TO LOAD TEXT DATA INTO
1510 TL = 1869 : REM THE LENGTH OF THE TEXT DATA TO LOAD

1520 PRINT D$;"BLOAD UI,TTXT,A$1000"

1530 VTAB(23) : HTAB(35) : ? M$;"VW";N$; : VTAB(1) : ? : VTAB(1) : HTAB(1)

1540 FOR I = 0 TO INT(TL / 170)
1550   FOR J = TADDR + I * 171 TO TADDR + I * 171 + 170
1560     PRINT CHR$(PEEK(J));
1570   NEXT J
1580   POKE 49237,0 : POKE 1890 + I, 86 : REM DISPLAY BUFFERING PROGRESS
1590   POKE 49236,0 : POKE 1890 + I, 87
1610 NEXT I


9980 REM RUNNING A NEW BASIC FILE WIPES ALL MEMORY OCCUPIED BY THE CURRENT ONE AND ALL ITS VARIABLES
10000 POKE 104,64 : POKE 16384,0 : REM LOAD BASIC AT $4000 AND CLEAR THE FIRST BYTE IN ORDER TO MAKE IT WORK
10020 REM POKE 104,96 : POKE 24576,0 : REM LOAD THE GAME AT $6000 IF USING GRAPHIC PAGE 2 IS NECESSARY
10100 PRINT D$;"RUN MAIN"

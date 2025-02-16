0 REM ROGUELIKE ENGINE FOR APPLE II BY NONCHO SAVOV
5 REM COPYRIGHT (C) 2024 BY FOUMARTGAMES, ALL RIGHTS RESERVED
10 REM DEVELOPED DURING 7DRL 2024 CHALLENGE

22 REM READCHAR ROUTINE SRC:
24 REM https://www.1000bit.it/support/manuali/apple/technotes/misc/tn.misc.10.html

26 REM BETTER ERROR HANDLING ROUTINE SRC:
28 REM https://www.applefritter.com/appleii-box/APPLE2/ErrormessagesFromONERR/Errormessages%20From%20ONERR.pdf

100 REM MEMORY LOCATIONS THAT ARE BEEN ACCESSED:
110 REM 0006 (6)               READCHAR CODE PLACEHOLDER
120 REM 0078,79 (120,121)      RANDOM SEED NUMBER 1 AND 2 (LINE EXECUTED/STOPPED, ETC.)
122 REM 0068 (104)             THE HIGH BYTE OF THE BASIC PROGRAM CUSTOM LOADING ADDRESS
123 REM 0067 (103)             LOW BYTE OF THE BASIC PROGRAM ($0801 IS THE DEFAULT)

124 REM 00CE (206)             LOW BYTE OF MOUSE TEXT PRINT POINTER
126 REM 00CF (207)             HIGH BYTE OF MOUSE TEXT PRINT POINTER
128 REM 00F2 (242)             LOW BYTE OF MOUSE TEXT LENGTH
130 REM 00F3 (243)             HIGH BYTE OF MOUSE TEXT LENGTH

132 REM ASSEMBLY ROUTINES:
140 REM 0300 - 030F (768-783)  RANDOMIZE SEED ROUTINE WITH RND(NEGATIVE)
150 REM 0310 - 0338 (784-824)  READCHAR ROUTINE
160 REM 0339 - 0367 (825-871)  PRINT MOUSE TEXT ROUTINE
165 REM 0368 - 039A (872-922)  FREE SPACE

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

355 REM STARTUP - THIS SAME BASIC FILE OCCUPIED SPACE IS AROUND 1270 BYTES WITH SOME SPACE TO SPARE TILL $1000
360 REM 0800-0CF6 (2048-3318)  DEFAULT LOADING ADDRESS. OTHER BASIC FILES WILL BE LOADED AT $4000 TO FREE UP TEXT PAGE 2
365 REM 1000-1764 (4096-5988)  INITIAL UI AND STORY (THIS WILL BE OVERWRITTEN BY OTHER UI DATA THAT WILL BE LOADED LATER)

395 REM MAIN & GAME
400 REM 0800-0BFF (2048-3071)  TEXT PAGE 2 (WILL BE KEPT FREE SO WE COULD USE TEXT PAGE FLIPPING IF NECESSARY)
410 REM 0C00-0FE6 (3072-4070)  STARTSEED (LENGTH: 999 - BYTES; 0FE7-0FFF 4071-4095 IS FREE)
450 REM 1000-13F7 (4096-5111)  BEGINGAME (LENGTH: 1015 - BYTES; 13F8-13FF 5112-5119 IS FREE)
420 REM 1400-17EA (5120-6122)  ENCOUNTER (LENGTH: 1002 - BYTES; 17EB-17FF 6123-6143 IS FREE)
460 REM 1800-1DFF (6144-8191)  FREE SPACE

462 REM 1E00-1E0A (7680-7690)  ERROR HANDLING ROUTINE
464 REM 1E50-1E67 (7760-7783)  CLEAR DOUBLE HI-RES ROUTINE

470 REM 2000-3FFF (8192-16383) GRAPHIC PAGE 1 SHOULD BE KEPT FREE SO WE COULD DISPLAY IMAGES
480 REM 4000-95FF (16384-38399) CUSTOM LOADING ADDRESS AND SPACE FOR OTHER BASIC FILES (WON'T BE USING GRAPHIC PAGE 2)

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

1225 VTAB(22) : REM DRAW LOADING BAR
1240 HTAB(20) : PRINT N$;"_            ___________________________"
1250 HTAB(20) : PRINT M$;"C";N$;"  Loading  ";M$;"Z";N$;MI$;" ";NI$;M$;"\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\";N$;
1260 PRINT MI$;" ";NI$;M$;"_";N$;
1275 VTAB(24) : HTAB(33) : PRINT M$;"LLLLLLLLLLLLLLLLLLLLLLLLLLL";N$;
1280 VTAB(1) : ? : VTAB(1) : HTAB(1)

1285 REM LOADS A SMALL ROUTINE AT $0300 THAT INCREMENTS THE RND LOCATIONS WHILE WAITING FOR KEYPRESS
1290 FOR O = 768 TO 782 : READ P
1295 POKE O,P : NEXT O : REM EXAMPLE: CALL 768 : X = RND(-1*(PEEK(78)+256*PEEK(79))) : PRINT X
1300 DATA 230,78,208,2,230,79,44,0,192,16,245,44,16,192,96
1305 VTAB(23) : HTAB(34) : ? M$;"W";N$;

1335 POKE 49239,0 : REM TURN ON HIRES
1340 POKE 49237,0 : PRINT D$"BLOAD TITLE, A$2000, L$2000" : REM LOAD THE FG DHR TITLE PICTURE
1342 VTAB(23) : HTAB(35) : ? M$;"V";N$;M$;"W";N$; : VTAB(23) : HTAB(35) : ? M$;"V";N$;
1345 POKE 49236,0 : PRINT D$"BLOAD TITLE, A$2000, L$2000, B$2000" : REM LOAD THE REST OF THE DHR TITLE PICTURE IN AUX MEMORY
1350 POKE 49232,0 : REM TURN ON GRAPHICS
1355 POKE 49235,0 : REM TURN ON MIXED MODE
1360 POKE 49246,0 : REM TURN ON DHR
1380 VTAB(23) : HTAB(37) : ? M$;"V";N$;M$;"W";N$;

1400 PRINT D$"BLOAD READCHAR" : REM LOADS THE GET CHAR ROUTINE AT $0310 (784)
1405 VTAB(23) : HTAB(39) : ? M$;"V";N$;M$;"W";N$;
1410 PRINT D$"BLOAD CLEARDHR" : REM LOADS A ROUTINE TO CLEAR DHR AT $1E50 (7760)
1425 VTAB(23) : HTAB(41) : ? M$;"V";N$;M$;"W";N$;

1430 IF DEBUG > 1 THEN GOTO 10000

1500 PRINT D$"BLOAD UI, TTXT, A$1000"
1530 VTAB(23) : HTAB(43) : ? M$;"V";N$;M$;"W";N$;
1540 PRINT D$"BLOAD PRINTMT" : REM FAST PRINT TEXT ROUTINE AT $1D00 (7424)
1545 VTAB(23) : HTAB(45) : ? M$;"VW";N$;
1550 POKE 235, 0             : REM SET $EB - LOW BYTE OF TEXT START/POINTER (0 DECIMAL = $00)
1560 POKE 236, 16            : REM SET $EC - HIGH BYTE TEXT START/POINTER (16 DECIMAL = $10)
1570 POKE 237, 78           : REM SET $ED - LOW BYTE OF TEXT LENGTH
1580 POKE 238, 7             : REM SET $EE - HIGH BYTE OF TEXT LENGTH
1590 VTAB(23) : HTAB(47) : ? M$;"VW";N$; : VTAB(1) : ? : VTAB(1) : HTAB(1)
1600 CALL 825
1610 REM VTAB(23) : HTAB(47) : ? M$;"VW";N$; : VTAB(18) : ? : VTAB(16) : HTAB(1)
1620 REM PRINT : PRINT D$"BLOAD UI2, TTXT, A$1000"

1810 VTAB(23) : HTAB(49) : ? M$;"VW";N$;

9980 REM RUNNING A NEW BASIC FILE WIPES ALL MEMORY OCCUPIED BY THE CURRENT ONE AND ALL ITS VARIABLES
10000 POKE 104,64 : POKE 16384,0 : REM LOAD BASIC AT $4000 AND CLEAR THE FIRST BYTE IN ORDER TO MAKE IT WORK
10020 REM POKE 104,96 : POKE 24576,0 : REM LOAD THE GAME AT $6000 IF USING GRAPHIC PAGE 2 IS NECESSARY
10100 PRINT : PRINT D$"RUN MAIN"

0 REM 7DRL ROGUELIKE FOR APPLE II BY NONCHO SAVOV
5 REM COPYRIGHT (C) 2024-2025 BY FOUMARTGAMES

10 ONERR GOTO 60000 : REM BETTER ERROR HANDLING (NEEDS 14 BYTES AT THE BEGINNING IN A REM)
25 FOR I = 4102 TO 4115 : REM WRITE THE MACHINE CODE IN THE BEGINNING OF THIS SAME BASIC FILE
30   READ K
40   POKE I,K
50 NEXT
80 DATA 166,222,189,96,210,72,32,92,219,232,104,16,245,96

90 GOTO 2000


98 REM BELOW ARE ROUTINES THAT NEED TO BE FAST, THEREFORE THEY ARE AT THE BEGINNING OF THE PROGRAM

99 REM MAP CHARACTER READ ROUTINE
100 WW = X : GOSUB 200 : REM SET X POSITION
104 VTAB(Y) : REM SET Y POSITION
106 CALL 784: REM CALL THE GETCHAR ROUTINE LOADED AT $0310
108 A = PEEK(6)
110 IF A > 127 THEN A$ = N$ + CHR$(A)
112 IF A < 128 THEN A$ = M$ + CHR$(A) + N$
114 REM GOSUB 800 : REM FRE
116 REM TODO AT CHECK BYTES:
118 REM 0 (NOT MOVED YET) : -5 (MOVING IN) : -7 (MOVING IN MOUSE TETXT)
120 K = 0
122 RETURN


199 REM HTAB() BUG HANDLING - MAKE SURE WE HAVE THE CORRECT HORIZONTAL POSITION
200 POKE 1147,WW-1 : POKE 1403,WW-1 : POKE 36,WW-1
260 RETURN


299 REM SET SCROLL WINDOW
300 POKE 32,V1 : REM SCROLL X
310 POKE 33,V2 : REM SCROLL WIDTH
320 POKE 34,V3 : REM SCROLL Y
330 POKE 35,V4 : REM SCROLL HEIGHT
340 RETURN

349 REM RESET SCROLL WINDOW
350 POKE 32,0 : REM SCROLL X
360 POKE 33,80 : REM SCROLL WIDTH
370 POKE 34,0 : REM SCROLL Y
380 POKE 35,24 : REM SCROLL HEIGHT
390 RETURN

399 REM PRINTING THE LOADED MOUSE TEXT ON SCREEN
400 POKE 235, UX : REM 0 : REM LOW BYTE OF TEXT START ADDRESS
410 POKE 236, VX : REM FILES(W,1) : REM HIGH BYTE OF TEXT START ADDRESS
420 POKE 237, UY : REM FILES(W,2) AND 255 : REM LOW BYTE OF TEXT LENGTH
430 POKE 238, VY : REM INT(FILES(W,2) / 256) : REM HIGH BYTE OF TEXT LENGTH
480 CALL 825
490 RETURN


799 REM RUN FRE BASIC COMMAND TO FORCE GC, OR PRODOS FRE. DISPLAY FREE MEMORY LEFT IF IN DEBUG MODE
800 IF FF = 1 THEN AVAIL = FRE(0)
810 IF FF = 2 THEN ? D$;"FRE"
820 FF = 0
830 IF DEBUG = 0 THEN RETURN
840 IF DEBUG > 0 THEN HTAB(62) : VTAB (24) : PRINT MI$;" free:";INT(AVAIL/1000);"k ";AVAIL;
850 IF (AVAIL > 9999) THEN PRINT " ";NI$; : GOTO 880
860 IF (AVAIL > 999) THEN PRINT "   ";NI$; : GOTO 880
870 PRINT "    ";NI$;
880 RETURN



1995 REM VARIABLE DECLARATIONS
2000 DEBUG = PEEK(1023) : REM GET DEBUG SETTING SAVED BY STARTUP
2005 D$ = CHR$(4) : AVAIL = FRE(0)
2010 MI$ = CHR$(15) : REM TURN INVERSE ON
2015 NI$ = CHR$(14) : REM TURN INVERSE OFF
2020 M$ = MI$ + CHR$(27) : REM TURN SPECIAL CHARACTERS ON (80COL MOUSE TEXT CARD CHARS)
2025 N$ = CHR$(24) + NI$ : REM TURN SPECIAL CHARACTERS OFF
2030 KY = PEEK(49152) : REM VARIABLE TO KEEP LAST PRESSED KEY
2035 DL$ = CHR$(127) : REM DEL CHARACTER
2040 XX = 0 : REM VARIABLES TO BE USED IN SUBROUTINES LIKE THE ALTERNATIVE HTAB OR WHILE GENERATING A STAGE
2045 FF = 0 : REM SET TO 1 TO PERFORM FRE(0), SET TO 2 TO PERFORM THE PRODOS FRE() COMMAND
2050 MOVING = 0 : MDIR = 0
2055 FF$ = "SCREEN"
2060 SIZE = 5 : REM INITIALIZE MAZE DIMENSIONS
2065 DIM MAP(SIZE,SIZE) : REM DECLARE MAP CONNECTIONS ARRAY
2070 DIM VIS(SIZE,SIZE) : REM DECLARE MAP VISITED ROOMS ARRAY
2072 DIM INS(SIZE,SIZE) : REM DECLARE MAP CONTENTS ARRAY
2074 PRINT : HTAB(1) : VTAB(23) : PRINT "Buffering";
2080 GOSUB 20500 : REM GET MAP DATA FROM MEMORY
2090 RX = 0 : REM ROOM X COORDINATE
2100 RY = 0 : REM ROOM Y COORDINATE
2110 ZX = 0 : REM MOVING DIRECTION OFFSET X
2120 ZY = 0 : REM MOVING DIRECTION OFFSET Y


2999 REM DECLARE PLAYER VARIABLES
3000 DIM CLASSES$(3) : REM F : R : S
3010 CLASSES$(1) = "Fighter" : CLASSES$(2) = "Strider" : CLASSES$(3) = "Scholar"

3020 DIM F1$(3)
3030 F1$(1) = "Knight" : F1$(2) = "Warrior" : F1$(3) = "Monk"
3040 DIM F2$(4)
3050 F2$(1) = "Paladin" : F2$(2) = "Dragoon" : F2$(3) = "Barbarian" : F2$(4) = "Gladiator"
3060 DIM F3$(8)
3070 F3$(1) = "Templar" : F3$(2) = "Crusader" : F3$(3) = "Lancer" : F3$(4) = "Samurai" : F3$(5) = "Berserker" : F3$(6) = "Viking" : F3$(7) = "Slayer" : F3$(8) = "Zealot"

3075 DIM R1$(3)
3080 R1$(1) = "Ranger" : R1$(2) = "Rogue" : R1$(3) = "Bard"
3085 DIM R2$(4)
3090 R2$(1) = "Wanderer" : R2$(2) = "Archer" : R2$(3) = "Thief" : R2$(4) = "Brigand"
3092 DIM R3$(8)
3095 R3$(1) = "Hunter" : R3$(2) = "Pathfinder" : R3$(3) = "Marksman" : R3$(4) = "Sharpshooter" : R3$(5) = "Ninja" : R3$(6) = "Stalker" : R3$(7) = "Assassin" : R3$(8) = "Marauder"

3100 DIM S1$(3)
3105 S1$(1) = "Wizard" : S1$(2) = "Cleric" : S1$(3) = "Druid"
3110 DIM S2$(4)
3115 S2$(1) = "Magician" : S2$(2) = "Conjurer" : S2$(3) = "Priest" : S2$(4) = "Alchemist"
3120 DIM S3$(8)
3125 S3$(1) = "Warlock" : S3$(2) = "ArchMage" : S3$(3) = "Sorcerer" : S3$(4) = "Enchanter" : S3$(5) = "Seer" : S3$(6) = "Oracle" : S3$(7) = "Sage" : S3$(8) = "Shaman"

3129 REM THREE TYPES OF ENEMIES: FIGHTERS, ARCHERS AND SPELLCASTERS
3130 DIM E1$(9)
3135 E1$(1) = "Giant Rat" : E1$(2) = "Skeleton" : E1$(3) = "Orc" : E1$(4) = "Minotaur" : E1$(5) = "Dark Knight" : E1$(6) = "Troll" : E1$(7) = "Dark Raider" : E1$(8) = "Shadow Sentinel" : E1$(9) = "Starfall Champion"
3140 DIM E2$(9)
3145 E2$(1) = "Kobold" : E2$(2) = "Goblin" : E2$(3) = "Beholder" : E2$(4) = "Skeleton Lych" : E2$(5) = "Corrupted Marksman" : E2$(6) = "Cyclops" : E2$(7) = "Dark Sharpshooter" : E2$(8) = "Nightshade Rogue" : E2$(9) = "Arcane Avenger"
3150 DIM E3$(9)
3155 E3$(1) = "Imp" : E3$(2) = "Banshee" : E3$(3) = "Celestial Caster" : E3$(4) = "Mystic Warlock" : E3$(5) = "Spellweaver" : E3$(6) = "Spellbound Sorcerer" : E3$(7) = "Phantom" : E3$(8) = "Wind Whisperer" : E3$(9) = "Rune Binder"

3230 DIM L1$(9)
3235 L1$(1) = "r" : L1$(2) = "s" : L1$(3) = "o" : L1$(4) = "M" : L1$(5) = "K" : L1$(6) = "T" : L1$(7) = "D" : L1$(8) = "S" : L1$(9) = "C"
3240 DIM L2$(9)
3245 L2$(1) = "k" : L2$(2) = "g" : L2$(3) = "b" : L2$(4) = "L" : L2$(5) = "C" : L2$(6) = "Y" : L2$(7) = "R" : L2$(8) = "N" : L2$(9) = "H"
3250 DIM L3$(9)
3255 L3$(1) = "i" : L3$(2) = "e" : L3$(3) = "c" : L3$(4) = "W" : L3$(5) = "S" : L3$(6) = "B" : L3$(7) = "P" : L3$(8) = "W" : L3$(9) = "R"

3335 REM ENEMY ATTACK
3340 DIM A1(9)
3350 A1(1) = 1 : A1(2) = 2 : A1(3) = 1 : A1(4) = 4 : A1(5) = 3 : A1(6) = 6 : A1(7) = 5 : A1(8) = 8 : A1(9) = 10
3355 DIM A2(9)
3360 A2(1) = 1 : A2(2) = 2 : A2(3) = 1 : A2(4) = 3 : A2(5) = 4 : A2(6) = 3 : A2(7) = 5 : A2(8) = 6 : A2(9) = 8
3365 DIM A3(9)
3370 A3(1) = 1 : A3(2) = 1 : A3(3) = 2 : A3(4) = 1 : A3(5) = 3 : A3(6) = 2 : A3(7) = 4 : A3(8) = 5 : A3(9) = 6
3375 REM ENEMY HEALTH
3380 DIM H1(9)
3390 H1(1) = 10 : H1(2) = 16 : H1(3) = 25 : H1(4) = 20 : H1(5) = 32 : H1(6) = 28 : H1(3) = 50 : H1(8) = 60 : H1(9) = 90
3395 DIM H2(9)
3400 H2(1) = 8 : H2(2) = 10 : H2(3) = 20 : H2(4) = 16 : H2(5) = 24 : H2(6) = 30 : H2(3) = 28 : H2(8) = 32 : H2(9) = 60
3405 DIM H3(9)
3410 H3(1) = 6 : H3(2) = 16 : H3(3) = 12 : H3(4) = 18 : H3(5) = 15 : H3(6) = 36 : H3(3) = 20 : H3(8) = 25 : H3(9) = 50
3415 REM ENEMY DEFENSE
3420 DIM D1(9)
3430 D1(1) = 3 : D1(2) = 4 : D1(3) = 4 : D1(4) = 5 : D1(5) = 5 : D1(6) = 6 : D1(7) = 8 : D1(8) = 10 : D1(9) = 12
3435 DIM D2(9) 
3440 D2(1) = 2 : D2(2) = 1 : D2(3) = 3 : D2(4) = 3 : D2(5) = 4 : D2(6) = 4 : D2(7) = 5 : D2(8) = 6 : D2(9) = 8
3445 DIM D3(9)
3450 D3(1) = 1 : D3(2) = 1 : D3(3) = 2 : D3(4) = 2 : D3(5) = 3 : D3(6) = 3 : D3(7) = 4 : D3(8) = 5 : D3(9) = 6
3455 REM ENEMY AMMO
3460 DIM M1(9)
3465 M1(1) = 0 : M1(2) = 1 : M1(3) = 3 : M1(4) = 1 : M1(5) = 5 : M1(6) = 1 : M1(7) = 3 : M1(8) = 2 : M1(9) = 5
3470 DIM M2(9) 
3475 M2(1) = 6 : M2(2) = 3 : M2(3) = 12 : M2(4) = 3 : M2(5) = 2 : M2(6) = 16 : M2(7) = 8 : M2(8) = 6 : M2(9) = 12
3480 DIM M3(9)
3485 M3(1) = 1 : M3(2) = 3 : M3(3) = 1 : M3(4) = 3 : M3(5) = 4 : M3(6) = 8 : M3(7) = 2 : M3(8) = 3 : M3(9) = 6

3499 REM CURRENT ENEMIES; 1:TYPE; 2:LEVEL; 3:ATTACK; 4:HEALTH; 5:DEFENSE; 6:AMMO; 7:DISTANCE; 8:ADVANCED; 9:SLOT; 10:MAP
3500 DIM C1(10)
3505 rem C1(1) = 0 : C1(2) = 0 : C1(3) = 0 : C1(4) = 0 : C1(5) = 0 : C1(6) = 0 : C1(7) = 0 : C1(8) = 0 : C1(9) = 0 : C1(10) = 0
3510 DIM C2(10)
3515 rem C2(1) = 0 : C2(2) = 0 : C2(3) = 0 : C2(4) = 0 : C2(5) = 0 : C2(6) = 0 : C2(7) = 0 : C2(8) = 0 : C2(9) = 0 : C2(10) = 0
3520 DIM C3(10)
3525 rem C3(1) = 0 : C3(2) = 0 : C3(3) = 0 : C3(4) = 0 : C3(5) = 0 : C3(6) = 0 : C3(7) = 0 : C3(8) = 0 : C3(9) = 0 : C3(10) = 0
3530 DIM C4(10)
3535 rem C4(1) = 0 : C4(2) = 0 : C4(3) = 0 : C4(4) = 0 : C4(5) = 0 : C4(6) = 0 : C4(7) = 0 : C4(8) = 0 : C4(9) = 0 : C4(10) = 0
3540 DIM C5(10)
3545 rem C5(1) = 0 : C5(2) = 0 : C5(3) = 0 : C5(4) = 0 : C5(5) = 0 : C5(6) = 0 : C5(7) = 0 : C5(8) = 0 : C5(9) = 0 : C5(10) = 0
3550 DIM C6(10)
3555 rem C6(1) = 0 : C6(2) = 0 : C6(3) = 0 : C6(4) = 0 : C6(5) = 0 : C6(6) = 0 : C6(7) = 0 : C6(8) = 0 : C6(9) = 0 : C6(10) = 0
3560 DIM C7(10)
3565 rem C7(1) = 0 : C7(2) = 0 : C7(3) = 0 : C7(4) = 0 : C7(5) = 0 : C7(6) = 0 : C7(7) = 0 : C7(8) = 0 : C7(9) = 0 : C7(10) = 0
3570 DIM C8(10)
3575 rem C8(1) = 0 : C8(2) = 0 : C8(3) = 0 : C8(4) = 0 : C8(5) = 0 : C8(6) = 0 : C8(7) = 0 : C8(8) = 0 : C8(9) = 0 : C8(10) = 0
3578 DIM C9(10)
3580 rem C9(1) = 0 : C9(2) = 0 : C9(3) = 0 : C9(4) = 0 : C9(5) = 0 : C9(6) = 0 : C9(7) = 0 : C9(8) = 0 : C9(9) = 0 : C9(10) = 0
3582 rem DIM C0(10)
3585 rem C0(1) = 0 : C0(2) = 0 : C0(3) = 0 : C0(4) = 0 : C0(5) = 0 : C0(6) = 0 : C0(7) = 0 : C0(8) = 0 : C0(9) = 0 : C0(10) = 0
3590 GOSUB 800 : REM FRE
3592 C1$ = "" : C2$ = "" : C3$ = "" : C4$ = "" : C5$ = "" : C6$ = "" : C7$ = "" : C8$ = "" : C9$ = "" : rem C0$ = ""
3595 N1$ = "" : N2$ = "" : N3$ = "" : N4$ = "" : N5$ = "" : N6$ = "" : N7$ = "" : N8$ = "" : N9$ = "" : rem N0$ = ""


3600 DIM ITEMS$(5, 4) : REM 1:WEAPON, 2:SECONDARY ITEM, 3:ARMOR, 4:HEAD GEAR, 5:SPECIAL ITEM (RING, BRACER, AMULET, ETC.)
3605 PRINT ".";

3610 GOSUB 20000 : REM GET PLAYER DATA FROM MEMORY
3620 GOSUB 21000 : REM DISPLAY PLAYER STATS



7000 X = PEEK(1022) : Y = PEEK(1021) : REM INITIAL PLAYER POSITION (X VARIES, Y IS ALWAYS AT THE BOTTOM)
7010 RW = 9 : RH = 4 : REM ROOM SIZE
7020 RX = INT(X/RW) : RY = INT(Y/RH) : REM MAP ROOMS COORDINATES
7040 A = 160 : REM HOLDS THE MAP TILE PLAYER IS CURRENTLY ON READ BY THE READCHAR ROUTINE.
7050 DIM PLAYER(3) : REM HOLDS X, Y, AND THE MAP CHARACTER THAT'S BEHIND THE UNIT
7060 PLAYER(1) = X : PLAYER(2) = Y : PLAYER(3) = A
7070 A$ = CHR$(160) : REM THE CHARACTER CODE READ BY THE ROUTINE BUT AS STRING
7080 TURN = 0
7090 RZ = 0 : REM SHOULD DOORS BE DRAWN WHEN DRAWING ROOMS 16000
7100 BS = 0 : REM BATTLE STATE
7110 BT = 0 : REM BATTLE TYPE
7120 LB = 0 : REM BATTLE LIST ENEMIES
7130 LP = 0 : REM BATTLE LIST ENEMIES PAGE

7199 REM 
7200 DIM ROOMS$(4)

7219 REM EMPTY
7220 ROOMS$(1) = "  "

7229 REM ENTRANCE
7230 ROOMS$(2) = " "+M$+CHR$(93)+N$

7239 REM EXIT
7240 ROOMS$(3) = M$+CHR$(90)+CHR$(94)+N$

7249 REM ROMBUS
7250 ROOMS$(4) = " "+M$+CHR$(91)+N$

9000 GOSUB 30500 : REM DISPLAY DEBUG MAP

9100 V1 = 0 : V2 = 45 : V3 = 0 : V4 = 21 : GOSUB 300
9200 HOME : GOSUB 350 : REM CLEAR GAME SCREEN
9210 PRINT MI$;" ? ";NI$;M$;"_";N$ : PRINT M$;"LLL";N$
9300 VTAB(23) : HTAB(15) : PRINT ".";

9500 GOSUB 22000 : REM DRAW ALL ROOMS ROUTINE
9600 RX = INT(X/RW) : RY = INT(Y/RH) : REM CURRENT ROOM COORDINATES (0-4)
9700 IF RX < SIZE-1 THEN GOSUB 14700 : REM PLACE DOOR LEADING TO A ROOM ON THE RIGHT
9750 V1 = 0 : V2 = 45 : V3 = 22 : V4 = 24 : GOSUB 300
9800 HOME : PRINT "Ready" : REM VTAB(24) : DEBUG = 1 : GOSUB 800
9820 rem VTAB 24 : HTAB 1 : PRINT "There are exits leading to N/E.";
9840 GOSUB 350

9985 GOSUB 100 : REM GET CHAR ROUTINE
9990 REM K = 0 : REM VTAB(1) : END : BREAK JUST BEFORE MAIN GAME LOOP



10000 PLAYER(1) = X : PLAYER(2) = Y : PLAYER(3) = A
10020 IF DEBUG > 1 THEN HTAB(40) : VTAB(1) : ? V;" ";M;" ";RX;"x";RY;" ";ZX;"*";ZY;" "; : REM WW = X : GOSUB 200 : VTAB(Y)
10050 WW = X : GOSUB 200 : VTAB(Y) : PRINT "@" : REM DRAW PLAYER

10750 KY = PEEK(49152) : REM GOSUB 24000 : REM GET LAST PRESSED KEY AND DISPLAY DEBUG CURSOR INFO
11200 IF KY = 0 THEN GOTO 10000
11210 IF KY = K THEN GOTO 10000
11220 K = KY : POKE 49168,0 : REM CLEAR THE KEYBOARD STROBE - ALWAYS AFTER READING KEYBOARD

11300 REM VTAB(24) : PRINT X;" ";Y;" ";RX;" ";RY;
11400 REM DISPLAY THE MAP CHAR AT THE PLAYER'S PREVIOUS POSITION AND PERFORM MOVE
11500 HTAB(X) : VTAB(Y)
11700 PRINT A$
11720 REM AA$ = A$ : REM TODO : FIX BLINKING
11750 rem IF K = 197 OR K = 229 THEN GOTO 12300 : REM TOGGLE DEBUG WITH "E"

11780 REM -> (21)    D (68)     d (100)    L (76)     l (108)
11800 IF K = 149 OR K = 196 OR K = 228 OR K = 204 OR K = 236 THEN TURN = TURN + 1 : ZX = 1 : ZY = 0 : GOTO 12500 : REM RIGHT
11850 REM K = 21 OR K = 149 OR K = 68 OR K = 196 OR K = 100 OR K = 228 OR K = 76 OR K = 204 OR K = 108 OR K = 236 THEN GOTO 12500 : REM MOVING = 1 : MDIR = 1 : GOTO 12500 : REM RIGHT

11880 REM <- (8)     A (65)     a (87)     J (74)     j (106)
11900 IF K = 136 OR K = 193 OR K = 225 OR K = 202 OR K = 234 THEN TURN = TURN + 1 : ZX = -1 : ZY = 0 : GOTO 13000 : REM LEFT
11950 REM IF K = 8 OR K = 136 OR K = 65 OR K = 193 OR K = 97 OR K = 225 OR K = 74 OR K = 202 OR K = 106 OR K = 234 THEN GOTO 13000 : REM MOVING = 1 : MDIR = -1 : GOTO 13000 : REM LEFT

12020 REM ^ (11)     W (87)     w (119)    I (73)     i (105)
12050 IF K = 139 OR K = 215 OR K = 247 OR K = 201 OR K = 233 THEN TURN = TURN + 1 : ZX = 0 : ZY = -1 : GOTO 13500 : REM UP
12075 REM IF K = 8 OR K = 136 OR K = 65 OR K = 193 OR K = 97 OR K = 225 OR K = 74 OR K = 202 OR K = 106 OR K = 234 THEN GOTO 13500 : REM UP

12090 REM v (10)     S (83)     s (115)    K (75)     k (107)
12100 IF K = 138 OR K = 211 OR K = 243 OR K = 203 OR K = 235 THEN TURN = TURN + 1 : ZX = 0 : ZY = 1 : GOTO 14000 : REM DOWN
12150 REM IF K = 10 OR K = 138 OR K = 83 OR K = 211 OR K = 115 OR K = 243 OR K = 75 OR K = 203 OR K = 107 OR K = 235 THEN GOTO 14000 : REM DOWN

12200 IF K = 32 OR K = 160 THEN GOTO 14500 : REM SPACE, PASS
12220 IF K = 191 THEN VTAB(1) : HTAB(1) : V1 = 0 : V2 = 45 : V3 = 0 : V4 = 24 : GOSUB 300 : UX = 0 : VX = 12 : UY = 111 : VY = 3 : GOSUB 400 : GOSUB 350

12250 GOTO 10000



12299 REM TRIGGER DEBUG WITH "E" KEY
12300 IF DEBUG < 4 THEN DEBUG = DEBUG + 1 : HTAB(1) : VTAB(24) : CALL -958 : GOTO 10000
12310 IF DEBUG = 4 THEN DEBUG = 0 : HTAB(1) : VTAB(24) : CALL -958 : GOSUB 24000 : GOTO 10000

12498 REM TRIGGER MOVEMENT

12498 REM MOVE RIGHT
24996 REM 160:SPACE; 90:RIGHT WALL; 92:CORRIDOR; 93:ENTRANCE; 95:LEFT WALL;
12500 IF A = 160 OR A = 90 OR A = 92 OR A = 93 OR A = 95 OR (A > 192 AND A < 219) OR (A > 224 AND A < 251) THEN X = X + 1 : GOSUB 100
12505 REM REVEAL OPENED ROOM RIGHT 255:CLASSIC APPLE II CURSOR SYMBOL
12510 IF A = 255 THEN GOTO 12850
12599 REM OPEN DOOR RIGHT 94:DOOR
12600 IF A = 94 THEN GOSUB 12960
12649 REM ENEMIES 
12650 IF (A > 192 AND A < 219) OR (A > 224 AND A < 251) THEN 12800
12699 REM BLOCKED RIGHT
12700 IF A <> 160 AND A <> 93 AND A <> 90 AND (A <> 92 OR A = 92 AND Y<>19 AND Y<>15 AND Y<>11 AND Y<>7 AND Y<>3) THEN X = X - 1 : GOSUB 100
12800 RX = INT(X / RW) : RY = INT((Y-1) / RH)
12810 REM IF DEBUG > 0 THEN GOSUB 30500
12830 GOTO 10000
12849 REM REVEAL
12850 IF MAP(RX+1, RY+1) = 6 THEN MAP(RX+1, RY+1) = 3 : REM GOSUB 30500
12855 IF MAP(RX+1, RY+1) = 7 THEN MAP(RX+1, RY+1) = 8 : REM GOSUB 30500
12860 IF MAP(RX+1, RY+1) = 9 THEN MAP(RX+1, RY+1) = 4 : REM GOSUB 30500
12865 VIS(RX+1, RY+1) = 2 : A = 160 : A$ = " " : XX = RX * RW : YY = RY * RH : X1 = RX+1 : Y1 = RY+1
12870 GOSUB 16000
12875 IF RX < SIZE-1 THEN GOSUB 14700 : REM PLACE DOOR LEADING TO A ROOM ON THE RIGHT
12880 IF RY < SIZE-1 THEN GOSUB 14800 : REM PLACE DOOR LEADING TO A ROOM BELOW
12890 GOSUB 15000 : REM GO BATTLE
12900 REM X = X - 1 : GOSUB 100
12910 GOTO 12800
12959 REM OPEN
12960 VIS(RX+2,RY+1) = 1 : XX = (RX+1) * RW : YY = RY * RH : X1 = RX+2 : Y1 = RY+1
12970 RZ = 1 : GOSUB 16000 : VTAB(Y) : HTAB(X-1) : ? " ";M$;"\\\\";N$;DL$;
12980 RETURN

12999 REM MOVE LEFT
13000 IF A = 160 OR A = 93 OR A = 95 OR A = 90 OR A = 92 OR (A > 192 AND A < 219) OR (A > 224 AND A < 251) THEN X = X - 1 : GOSUB 100
13009 REM REVEAL OPENED ROOM LEFT
13010 IF A = 255 THEN GOTO 13350
13099 REM OPEN DOOR LEFT
13100 IF A = 94 THEN GOSUB 13460
12149 REM ENEMIES 
12150 IF (A > 192 AND A < 219) OR (A > 224 AND A < 251) THEN 13300
13199 REM BLOCKED LEFT
13200 IF A <> 160 AND A <> 93 AND A <> 95 AND (A <> 92 OR A = 92 AND Y<>19 AND Y<>15 AND Y<>11 AND Y<>7 AND Y<>3) THEN X = X + 1 : GOSUB 100
13300 RX = INT(X / RW) : RY = INT((Y-1) / RH)
13310 REM IF DEBUG > 0 THEN GOSUB 30500
13340 GOTO 10000
13349 REM REVEAL
13350 IF MAP(RX+1, RY+1) = 6 THEN MAP(RX+1, RY+1) = 3 : REM GOSUB 30500
13355 IF MAP(RX+1, RY+1) = 7 THEN MAP(RX+1, RY+1) = 8 : REM GOSUB 30500
13360 IF MAP(RX+1, RY+1) = 9 THEN MAP(RX+1, RY+1) = 4 : REM GOSUB 30500
13365 RX = RX - 1 : VIS(RX+1, RY+1) = 2 : A = 160 : A$ = " " : XX = RX * RW : YY = RY * RH : X1 = RX+1 : Y1 = RY+1
13370 GOSUB 16000
13380 IF RY < SIZE-1 THEN GOSUB 14800 : REM PLACE DOOR LEADING TO A ROOM BELOW
13390 GOSUB 15000 : REM GO BATTLE
13400 REM X = X + 1 : GOSUB 100
13410 GOTO 13300
13450 REM OPEN
13460 VIS(RX,RY+1) = 1 : XX = (RX-1) * RW : YY = RY * RH : X1 = RX : Y1 = RY+1
13470 RZ = 1 : GOSUB 16000 : VTAB(Y) : HTAB(X-2) : ? DL$;M$;"\\\\";N$;" ";
13480 REM IF RY < SIZE-1 THEN GOSUB 13375
13490 RETURN

13499 REM MOVE UP
13500 IF A = 92 THEN GOTO 10000
13510 IF A = 160 OR A = 93 OR A = 95 OR A = 90 OR (A > 192 AND A < 219) OR (A > 224 AND A < 251) THEN Y = Y - 1 : GOSUB 100
13559 REM REVEAL OPENED ROOM UP
13560 IF A = 255 THEN GOTO 13850
13599 REM OPEN DOOR UP
13600 IF A = 94 THEN GOSUB 13960
13649 REM ENEMIES 
13650 IF (A > 192 AND A < 219) OR (A > 224 AND A < 251) THEN 13800
13698 REM BLOCKED UP
13700 IF A <> 160 AND A <> 93 AND A <> 95 AND A <> 90 THEN Y = Y + 1 : GOSUB 100
13800 RX = INT(X / RW) : RY = INT((Y-1) / RH)
13810 REM IF DEBUG > 0 THEN GOSUB 30500
13840 GOTO 10000
13849 REM REVEAL
13850 IF MAP(RX+1, RY+1) = 5 THEN MAP(RX+1, RY+1) = 2 : REM GOSUB 30500
13855 IF MAP(RX+1, RY+1) = 7 THEN MAP(RX+1, RY+1) = 9 : REM GOSUB 30500
13860 IF MAP(RX+1, RY+1) = 8 THEN MAP(RX+1, RY+1) = 4 : REM GOSUB 30500
13865 RY = RY - 1 : VIS(RX+1, RY+1) = 2 : A = 160 : A$ = " " : XX = RX * RW : YY = RY * RH : X1 = RX+1 : Y1 = RY+1
13870 GOSUB 16000
13880 IF RX < SIZE-1 THEN GOSUB 14700 : REM PLACE DOOR LEADING TO A ROOM ON THE RIGHT
13890 GOSUB 15000 : REM GO BATTLE
13900 REM Y = Y + 1 : GOSUB 100
13910 GOTO 13800
13940 RETURN
13950 REM OPEN
13960 VIS(RX+1,RY) = 1 : XX = RX * RW : YY = (RY-1) * RH : X1 = RX+1 : Y1 = RY
13970 RZ = 1 : GOSUB 16000 : VTAB(Y) : HTAB(X-3) : ? M$;"\\\\_";N$;" ";M$;"Z\\\\";N$; : VTAB(Y-1) : HTAB(X-1) : ? DL$;DL$;DL$;
13980 RETURN

13999 REM MOVE DOWN
14000 IF A = 92 THEN GOTO 10000
14020 IF A = 160 OR A = 93 OR A = 95 OR A = 90 OR (A > 192 AND A < 219) OR (A > 224 AND A < 251) THEN Y = Y + 1 : GOSUB 100
14099 REM REVEAL OPENED ROOM DOWN
14100 IF A = 255 THEN GOTO 14350
14149 REM OPEN DOOR DOWN
14150 IF A = 94 THEN GOSUB 14460
14160 REM ENEMIES 
12180 IF (A > 192 AND A < 219) OR (A > 224 AND A < 251) THEN 14300
14199 REM BLOCKED DOWN
14200 IF A <> 160 AND A <> 93 AND A <> 95 AND A <> 90 THEN Y = Y - 1 : GOSUB 100
14300 RX = INT(X / RW) : RY = INT((Y-1) / RH)
14310 REM IF DEBUG > 0 THEN GOSUB 30500
14340 GOTO 10000
14349 REM REVEAL
14350 IF MAP(RX+1, RY+1) = 5 THEN MAP(RX+1, RY+1) = 2 : REM GOSUB 30500
14355 IF MAP(RX+1, RY+1) = 7 THEN MAP(RX+1, RY+1) = 9 : REM GOSUB 30500
14360 IF MAP(RX+1, RY+1) = 8 THEN MAP(RX+1, RY+1) = 4 : REM GOSUB 30500
14365 VIS(RX+1, RY+1) = 2 : A = 160 : A$ = " " : XX = RX * RW : YY = RY * RH : X1 = RX+1 : Y1 = RY+1
14370 GOSUB 16000
14375 IF RX < SIZE-1 THEN GOSUB 14700 : REM PLACE DOOR LEADING TO A ROOM ON THE RIGHT
14380 IF RY < SIZE-1 THEN GOSUB 14800 : REM PLACE DOOR LEADING TO A ROOM BELOW
14390 GOSUB 15000 : REM GO BATTLE
14400 REM Y = Y - 1 : GOSUB 100
14410 GOTO 14300
14459 REM OPEN
14460 VIS(RX+1, RY+2) = 1 : XX = RX * RW : YY = RY * RH + RH : X1 = RX+1 : Y1 = RY+2
14470 RZ = 1 : GOSUB 16000 : VTAB(Y) : HTAB(X-3) : ? M$;"\\\\_";N$;" ";M$;"Z\\\\";N$; : VTAB(Y+1) : HTAB(X-1) : ? DL$;DL$;DL$;
14480 RETURN

14500 GOSUB 100 : REM SPACE
14510 IF DEBUG > 0 THEN GOSUB 30500
14600 GOTO 10000

14699 REM PLACE DOOR LEADING TO A ROOM ON THE RIGHT
14700 IF MAP(RX+2, RY+1) = 3 OR MAP(RX+2, RY+1) = 4 OR MAP(RX+2, RY+1) = 8 THEN VTAB(RY*RH+3) : HTAB((RX+1)*RW-1) : ? " ";M$;"\\\\";N$;
14730 IF MAP(RX+2, RY+1) = 6 OR MAP(RX+2, RY+1) = 7 OR MAP(RX+2, RY+1) = 9 THEN VTAB(RY*RH+3) : HTAB((RX+1)*RW) : ? M$;"^";N$;MI$;" ";NI$;
14750 RETURN

14799 REM PLACE DOOR LEADING TO A ROOM BELOW
14800 IF MAP(RX+1, RY+2) = 2 OR MAP(RX+1, RY+2) = 4 OR MAP(RX+1, RY+2) = 9 THEN VTAB(RY*RH+5) : HTAB(RX*RW + 4) : ? M$;"_";N$;" ";M$;"Z";N$
14830 IF MAP(RX+1, RY+2) = 5 OR MAP(RX+1, RY+2) = 7 OR MAP(RX+1, RY+2) = 8 THEN VTAB(RY*RH+5) : HTAB(RX*RW + 4) : ? MI$;" ";NI$;M$;"^";N$;MI$;" ";NI$
14840 RETURN


14999 REM BATTLE
15000 TP = RND(1)*8
15010 IF TP = 1 THEN RETURN : REM ROUGHLY EVERY 8TH ROOM WILL BE EMPTY
15020 REM IF TP = 2 THEN GOSUB 15400 : RETURN : REM CHEST ROOM
15025 REM GOSUB 15400 : RETURN : REM CHEST ROOM
15030 REM IF TP = 3 THEN RETURN : REM ?
15040 REM GOSUB 15400
15050 REM RETURN

15099 REM TODO: FIX
15100 V1 = 47 : V2 = 33 : V3 = 15 : V4 = 24 : GOSUB 300 : REM LIMIT SCROLL AREA TO BOTTOM RIGHT
15102 UX = 77 : VX = 9 : UY = 60 : VY = 1 : HOME : VTAB(15) : GOSUB 400 : REM PRINT ENCOUNTER
15104 UX = 136 : VX = 10 : UY = 129 : VY = 0 : VTAB(22) : GOSUB 400 : REM PRINT CHOISES : TODO
15106 GOSUB 350
15110 REM UX = 197 : VX = 20 : UY =  50 : VY =  0 : GOSUB 400
15120 GOSUB 15550 : REM GENERATE ENEMIES FOR THIS ROOM
15140 GOSUB 15900 : REM EXPLAIN HOW MANY AND ASK ATTACK
15160 REM GOSUB 15700 : REM LIST ENEMIES
15180 REM PRINT ENEMIES IN THE CURRENT ROOM
15200 IF C1(1) > 0 THEN GOSUB 15300
15210 IF C2(1) > 0 THEN GOSUB 15310
15215 IF C3(1) > 0 THEN GOSUB 15320
15220 IF C4(1) > 0 THEN GOSUB 15330
15225 IF C5(1) > 0 THEN GOSUB 15340
15230 IF C6(1) > 0 THEN GOSUB 15350
15240 IF C7(1) > 0 THEN GOSUB 15360
15250 IF C8(1) > 0 THEN GOSUB 15370
15260 IF C9(1) > 0 THEN GOSUB 15380
15290 RETURN
15299 REM PRINT ENEMIES LETTERS
15300 IF BT = 1 OR BT = 3 THEN HTAB(RX * 9 + 5) : VTAB(RY*4 + 3) : PRINT C1$ : RETURN : REM K1
15302 IF BT = 2 THEN HTAB(RX * 9 + 8 - C1(7) - C1(8)) : VTAB(RY*4 + 3) : PRINT C1$ : RETURN : REM K1
15305 IF BT = 4 THEN HTAB(RX * 9 + 2 + C1(7) + C1(8)) : VTAB(RY*4 + 3) : PRINT C1$ : RETURN : REM K1
15310 IF BT = 1 OR BT = 3 THEN HTAB(RX * 9 + 5) : VTAB(RY*4 + 5 - BT) : PRINT C2$ : RETURN : REM A1
15312 IF BT = 2 THEN HTAB(RX * 9 + 8 - C2(7) - C2(8)) : VTAB(RY*4 + 3) : PRINT C2$ : RETURN : REM A1
15315 IF BT = 4 THEN HTAB(RX * 9 + 2 + C2(7) + C2(8)) : VTAB(RY*4 + 3) : PRINT C2$ : RETURN : REM A1
15320 IF BT = 1 OR BT = 3 THEN HTAB(RX * 9 + 4) : VTAB(RY*4 + 5 - BT) : PRINT C3$ : RETURN : REM W1
15312 IF BT = 2 THEN HTAB(RX * 9 + 8 - C3(7) - C3(8)) : VTAB(RY*4 + 3) : PRINT C3$ : RETURN : REM W1
15315 IF BT = 4 THEN HTAB(RX * 9 + 2 + C3(7) + C3(8)) : VTAB(RY*4 + 3) : PRINT C3$ : RETURN : REM W1
15330 IF BT = 1 OR BT = 3 THEN HTAB(RX * 9 + 4) : VTAB(RY*4 + 3) : PRINT C4$ : RETURN : REM K2
15332 IF BT = 2 THEN HTAB(RX * 9 + 8 - C4(7) - C4(8)) : VTAB(RY*4 + 2) : PRINT C4$ : RETURN : REM K2
15335 IF BT = 4 THEN HTAB(RX * 9 + 2 + C4(7) + C4(8)) : VTAB(RY*4 + 2) : PRINT C4$ : RETURN : REM K2
15340 IF BT = 1 OR BT = 3 THEN HTAB(RX * 9 + 3) : VTAB(RY*4 + 5 - BT) : PRINT C5$ : RETURN : REM A2
15342 IF BT = 2 THEN HTAB(RX * 9 + 8 - C5(7) - C5(8)) : VTAB(RY*4 + 2) : PRINT C5$ : RETURN : REM A2
15345 IF BT = 4 THEN HTAB(RX * 9 + 2 + C5(7) + C5(8)) : VTAB(RY*4 + 2) : PRINT C5$ : RETURN : REM A2
15350 IF BT = 1 OR BT = 3 THEN HTAB(RX * 9 + 6) : VTAB(RY*4 + 5 - BT) : PRINT C6$ : RETURN : REM W2
15312 IF BT = 2 THEN HTAB(RX * 9 + 8 - C6(7) - C6(8)) : VTAB(RY*4 + 2) : PRINT C6$ : RETURN : REM W2
15315 IF BT = 4 THEN HTAB(RX * 9 + 2 + C6(7) + C6(8)) : VTAB(RY*4 + 2) : PRINT C6$ : RETURN : REM W2
15360 IF BT = 1 OR BT = 3 THEN HTAB(RX * 9 + 6) : VTAB(RY*4 + 3) : PRINT C7$ : RETURN
15362 IF BT = 2 THEN HTAB(RX * 9 + 8 - C7(7) - C7(8)) : VTAB(RY*4 + 4) : PRINT C7$ : RETURN
15365 IF BT = 4 THEN HTAB(RX * 9 + 2 + C7(7) + C7(8)) : VTAB(RY*4 + 4) : PRINT C7$ : RETURN
15370 IF BT = 1 OR BT = 3 THEN HTAB(RX * 9 + 7) : VTAB(RY*4 + 5 - BT) : PRINT C8$ : RETURN : REM A3
15372 IF BT = 2 THEN HTAB(RX * 9 + 8 - C8(7) - C8(8)) : VTAB(RY*4 + 4) : PRINT C8$ : RETURN : REM A3
15375 IF BT = 4 THEN HTAB(RX * 9 + 2 + C8(7) + C8(8)) : VTAB(RY*4 + 4) : PRINT C8$ : RETURN : REM A3
15380 IF BT = 1 OR BT = 3 THEN HTAB(RX * 9 + BT*2+BT-1) : VTAB(RY*4 + 5 - BT) : PRINT C9$ : RETURN : REM W3
15312 IF BT = 2 THEN HTAB(RX * 9 + 8 - C9(7) - C9(8)) : VTAB(RY*4 + 4) : PRINT C9$ : RETURN : REM W3
15315 IF BT = 4 THEN HTAB(RX * 9 + 2 + C9(7) + C9(8)) : VTAB(RY*4 + 4) : PRINT C9$ : RETURN : REM W3
15400 V1 = 47 : V2 = 33 : V3 = 15 : V4 = 24 : GOSUB 300
15403 UX = 5 : VX = 21 : UY = 94 : VY = 1 : HOME : VTAB(15) : GOSUB 400 : REM HOME
15406 GOSUB 350
15410 REM UX = 197 : VX = 20 : UY =  50 : VY =  0 : GOSUB 400
15500 RETURN

15549 REM GENERATE ENEMIES 1:TYPE; 2:LEVEL; 3:ATTACK; 4:HEALTH; 5:DEFENSE; 6:AMMO; 7:DISTANCE; 8:ADVANCED; 9:SLOT; 0:MAP SYMBOL
15550 C1(1) = 0 : C2(1) = 0 : C3(1) = 0 : C4(1) = 0 : C5(1) = 0 : C6(1) = 0 : C7(1) = 0 : C8(1) = 0 : C9(1) = 0 : rem C0(1) = 0
15555 BS = 1
15560 IF X = 38 OR X = 29 OR X = 20 OR X = 11 THEN BT = 4
15565 IF Y = 20 OR Y = 16 OR Y = 12 OR Y = 8 THEN BT = 3
15570 IF X = 35 OR X = 26 OR X = 17 OR X = 8 THEN BT = 2
15575 IF Y = 18 OR Y = 14 OR Y = 10 OR Y = 6 THEN BT = 1
15580 REM TODO PLACE BOSS IN EXIT ROOM
15605 IF RND(1)*3 > 1 THEN N1$ = E1$(1) : C1$ = L1$(1) : C1(1) = 1 : C1(2) = 1 : C1(3) = A1(1) : C1(4) = H1(1) : C1(5) = D1(1) : C1(6) = M1(1) : C1(7) = 1 : C1(8) = 0 : C1(9) = 2 : C1(10) = 0
15610 IF RND(1)*3 > 1 THEN N2$ = E2$(1) : C2$ = L2$(1) : C2(1) = 2 : C2(2) = 1 : C2(3) = A2(1) : C2(4) = H2(1) : C2(5) = D2(1) : C2(6) = M2(1) : C2(7) = 3 : C2(8) = 0 : C2(9) = 2 : C2(10) = 0
15620 IF RND(1)*4 > 2 THEN N3$ = E3$(1) : C3$ = L3$(1) : C3(1) = 3 : C3(2) = 1 : C3(3) = A3(1) : C3(4) = H3(1) : C3(5) = D3(1) : C3(6) = M3(1) : C3(7) = 5 : C3(8) = 0 : C3(9) = 2 : C3(10) = 0
15630 IF RND(1)*6 > 3 THEN N4$ = E1$(2) : C4$ = L1$(2) : C4(1) = 1 : C4(2) = 2 : C4(3) = A1(2) : C4(4) = H1(2) : C4(5) = D1(2) : C4(6) = M1(2) : C4(7) = 2 : C4(8) = 0 : C4(9) = 1 : C4(10) = 0
15640 IF RND(1)*8 > 5 AND Y < 17 THEN N5$ = E2$(2) : C5$ = L2$(2) : C5(1) = 2 : C5(2) = 2 : C5(3) = A2(2) : C5(4) = H2(2) : C5(5) = D2(2) : C5(6) = M2(2) : C5(7) = 4 : C5(8) = 0 : C5(9) = 1 : C5(10) = 0
15650 IF RND(1)*9 > 6 AND Y < 17 THEN N6$ = E3$(2) : C6$ = L3$(2) : C6(1) = 3 : C6(2) = 2 : C6(3) = A3(2) : C6(4) = H3(2) : C6(5) = D3(2) : C6(6) = M3(2) : C6(7) = 5 : C6(8) = 0 : C6(9) = 1 : C6(10) = 0
15660 IF RND(1)*9 > 7 OR Y < 9 THEN N7$ = E1$(3) : C7$ = L1$(3) : C7(1) = 1 : C7(2) = 3 : C7(3) = A1(3) : C7(4) = H1(3) : C7(5) = D1(3) : C7(6) = M1(3) : C7(7) = 2 : C7(8) = 0 : C7(9) = 3 : C7(10) = 0
15660 IF RND(1)*9 > 7 AND Y < 9 THEN N8$ = E2$(3) : C8$ = L2$(3) : C8(1) = 2 : C8(2) = 3 : C8(3) = A2(3) : C8(4) = H2(3) : C8(5) = D2(3) : C8(6) = M2(3) : C8(7) = 4 : C8(8) = 0 : C8(9) = 3 : C8(10) = 0
15670 IF RND(1)*9 > 8 AND Y < 9 THEN N9$ = E3$(3) : C9$ = L3$(3) : C9(1) = 3 : C9(2) = 3 : C9(3) = A3(3) : C9(4) = H3(3) : C9(5) = D3(3) : C9(6) = M3(3) : C9(7) = 5 : C9(8) = 0 : C9(9) = 3 : C9(10) = 0
15680 RETURN
15690 REM LIST ENEMIES
15700 REM LB = 0
15702 REM IF C1(1) > 0 AND LP < 2 THEN LB = LB + 1 : VTAB(17 + LB) : GOSUB 15800
15705 REM IF C4(1) > 0 AND LP < 3 THEN LB = LB + 1 : VTAB(17 + LB) : GOSUB 15830
15710 REM IF C7(1) > 0 AND LP < 4 THEN LB = LB + 1 : VTAB(17 + LB) : GOSUB 15860
15715 REM IF C2(1) > 0 AND LP < 5 THEN LB = LB + 1 : VTAB(17 + LB) : GOSUB 15810
15720 REM IF C5(1) > 0 AND LP < 6 THEN LB = LB + 1 : VTAB(17 + LB) : GOSUB 15840
15725 REM IF C8(1) > 0 AND LP < 7 THEN LB = LB + 1 : VTAB(17 + LB) : GOSUB 15870
15730 REM IF C3(1) > 0 AND LP < 8 THEN LB = LB + 1 : VTAB(17 + LB) : GOSUB 15820
15735 REM IF C6(1) > 0 AND LP < 9 THEN LB = LB + 1 : VTAB(17 + LB) : GOSUB 15850
15740 REM IF C9(1) > 0 AND LP < 10 THEN LB = LB + 1 : VTAB(17 + LB) : GOSUB 15880
15790 REM RETURN
15800 REM HTAB(50) : PRINT LB;". ";"Knight";" HP:";C1(4);" A:";C1(3);" D:";C1(5);" '";(C1(7)-C1(8));"0" : RETURN
15810 REM HTAB(50) : PRINT LB;". ";"Archer";" HP:";C2(4);" A:";C2(3);" D:";C2(5);" '";(C2(7)-C2(8));"0" : RETURN
15820 REM HTAB(50) : PRINT LB;". ";"Wizard";" HP:";C3(4);" A:";C3(3);" D:";C3(5);" '";(C3(7)-C3(8));"0" : RETURN
15830 REM HTAB(50) : PRINT LB;". ";"Knight";" HP:";C4(4);" A:";C4(3);" D:";C4(5);" '";(C4(7)-C4(8));"0" : RETURN
15840 REM HTAB(50) : PRINT LB;". ";"Archer";" HP:";C5(4);" A:";C5(3);" D:";C5(5);" '";(C5(7)-C5(8));"0" : RETURN
15850 REM HTAB(50) : PRINT LB;". ";"Wizard";" HP:";C6(4);" A:";C6(3);" D:";C6(5);" '";(C6(7)-C6(8));"0" : RETURN
15860 REM HTAB(50) : PRINT LB;". ";"Knight";" HP:";C7(4);" A:";C7(3);" D:";C7(5);" '";(C7(7)-C7(8));"0" : RETURN
15870 REM HTAB(50) : PRINT LB;". ";"Archer";" HP:";C8(4);" A:";C8(3);" D:";C8(5);" '";(C8(7)-C8(8));"0" : RETURN
15880 REM HTAB(50) : PRINT LB;". ";"Wizard";" HP:";C9(4);" A:";C9(3);" D:";C9(5);" '";(C9(7)-C9(8));"0" : RETURN

15900 V1 = 0 : V2 = 0 : V3 = 0 : V4 = 18
15904 IF C1(1) > 0 THEN V1 = V1 + 1
15908 IF C4(1) > 0 THEN V1 = V1 + 1
15910 IF C7(1) > 0 THEN V1 = V1 + 1
15915 IF C2(1) > 0 THEN V2 = V2 + 1
15920 IF C5(1) > 0 THEN V2 = V2 + 1
15925 IF C8(1) > 0 THEN V2 = V2 + 1
15930 IF C3(1) > 0 THEN V3 = V3 + 1
15935 IF C6(1) > 0 THEN V3 = V3 + 1
15940 IF C9(1) > 0 THEN V3 = V3 + 1
15942 HTAB(51) : VTAB(18) : PRINT "You Face:"
15945 IF V1 > 0 THEN HTAB(61) : VTAB(18) : PRINT V1;" ";N1$; : V4 = V4 + 1 : IF V1 > 1 THEN PRINT "s";
15950 IF V2 > 0 THEN HTAB(61) : VTAB(V4) : PRINT V2;" ";N2$; : V4 = V4 + 1 : IF V2 > 1 THEN PRINT "s";
15955 IF V3 > 0 THEN HTAB(61) : VTAB(V4) : PRINT V3;" ";N3$; : IF V3 > 1 THEN PRINT "s";
15960 DEBUG = 1 : GOSUB 800
15980 RETURN

15999 REM UPDATE A ROOM
16000 M = MAP(X1, Y1)
16100 V = VIS(X1, Y1)
16150 if V = 0 THEN RETURN

16200 WW = XX+1 : GOSUB 200
16210 VTAB(YY+1)

16300 IF YY < 4 THEN GOTO 16500
16310 IF V > 1 AND Y1 > 1 AND VIS(X1, Y1-1) = 0 THEN PRINT " _______ "; : GOTO 16500
16350 IF V > 1 OR V = 1 AND VIS(X1, Y1-1) > 0 THEN ? " ";M$;"\\\\\\\\\\\\\\";N$;" "; : GOTO 17000 : REM DRAW IN BETWEEN ROOM VERTICAL SPACE
16500 IF V = 1 THEN ? " _";M$;"I";N$;"_";M$;"I";N$;"_";M$;"I";N$;"_ "

16799 REM DRAW VISIBLE EMPTY ROOM
17000 IF V > 1 THEN WW = XX+1 : GOSUB 200 : VTAB(YY+2) : ? M$;"Z_";N$;"     ";M$;"Z_";N$
17020 IF V > 1 AND TURN = 0 THEN HTAB(XX+1) : VTAB(YY+3) : ? M$;"Z_";N$;" ";ROOMS$(INS(X1, Y1)+1);"  ";M$;"Z_";N$ : GOTO 17100
17050 IF V > 1 THEN HTAB(XX+2) : VTAB(YY+3) : ? M$;"_";N$;" ";ROOMS$(INS(X1, Y1)+1);"  ";M$;"Z";N$
17100 IF V > 1 THEN HTAB(XX+1) : VTAB(YY+4) : ? M$;"Z_";N$;"     ";M$;"Z_";N$

17299 REM DRAW DISCOVERED ROOMS AS GREYED OUT IF THEY ARE NOT REVELAED OUT YET
17300 IF V = 1 THEN WW = XX+1 : GOSUB 200 : VTAB(YY+2) : ? M$;"ZVWVWVWV_";N$
17310 IF V = 1 THEN HTAB(XX+1) : VTAB(YY+3) : ? M$;"ZVWVWVWV_";N$
17320 IF V = 1 THEN HTAB(XX+1) : VTAB(YY+4) : ? M$;"ZVWVWVWV_";N$

17999 REM DRAW DOORS
18000 IF V = 0 GOTO 19600
18100 IF RZ = 1 THEN RZ = 0 : GOTO 19600

18299 REM HORIZONTAL OPEN DOORS
18300 IF M <> 3 AND M <> 4 AND M <> 8 THEN GOTO 18800
18400 IF V > 1 AND ZX = -1 THEN HTAB(XX-1) : VTAB(YY+3) : ? DL$;M$;"\\\\";N$;" "
18500 IF V > 1 AND ZX = 1 THEN HTAB(XX-1) : VTAB(YY+3) : ? " ";M$;"\\\\";N$;DL$

18799 REM HORIZONTAL CLOSED DOORS
18800 IF M <> 6 AND M <> 7 AND M <> 9 THEN GOTO 19300
19100 HTAB(XX) : VTAB(YY+3) : ? M$;" ^";N$


19299 REM VERTICAL OPEN DOOR
19300 IF M <> 2 AND M <> 4 AND M <> 9 THEN GOTO 19500
19305 IF V < 2 THEN GOTO 19320
19310 IF M = 2 OR M = 4 OR M = 9 THEN HTAB(XX+2) : VTAB(YY+1) : ? M$;"\\\\";CHR$(95);N$" ";M$;CHR$(90);"\\\\";N$ : GOTO 19500
19320 HTAB(XX+2) : VTAB(YY+1) : ? "_";M$;"I";N$;"_";M$;"I";N$;"_";M$;"I";N$;"_"


19499 REM VERTICAL CLOSED DOOR
19500 IF M <> 5 AND M <> 7 AND M <> 8 THEN GOTO 19600
19510 IF M = 5 OR M = 7 OR M = 8 THEN HTAB(XX+2) : VTAB(YY+1) : ? "__";M$;" ^ ";N$;"__"


19599 REM DRAW BOTTOM EDGE BORDER OF THE ROOM
19600 HTAB(XX+1) : VTAB(YY+5) : REM VTAB(1) : HTAB(1) : ? Y1, VIS(X1, Y1+1) : 
19700 IF Y1 < SIZE THEN GOTO 19850
19800 IF V > 0 THEN ? " ";M$;"LLLLLLL";N$;" " : RETURN
19825 RETURN
19850 IF VIS(X1, Y1+1) > 0 AND (MAP(X1, Y1+1) = 2 OR MAP(X1, Y1+1) = 4 OR MAP(X1, Y1+1) = 9) THEN ? " ";M$;"\\\\_";N$;" ";M$;"Z\\\\";N$;" " : RETURN
19860 IF VIS(X1, Y1+1) > 0 AND (MAP(X1, Y1+1) = 5 OR MAP(X1, Y1+1) = 7 OR MAP(X1, Y1+1) = 8) THEN ? " ";M$;"\\\\";N$;MI$;" ";NI$;M$;"^";N$;MI$;" ";NI$;M$;"\\\\";N$;" " : RETURN
19900 IF VIS(X1, Y1) > 0 AND VIS(X1, Y1 + 1) = 0 THEN ? " ";M$;"LLLLLLL";N$;" " : RETURN
19910 IF VIS(X1, Y1) > 0 THEN ? " ";M$;"\\\\\\\\\\\\\\";N$;" "
19920 RETURN


19999 REM GET PLAYER DATA FROM MEMORY
20000 CLASS = PEEK(1020) : REM PLAYER CLASS
20110 REM ? PEEK(1019) : REM ??
20120 AK = PEEK(1018) : REM ATTACK
20130 AC = PEEK(1017) : REM ARMOR CLASS
20140 SR = PEEK(1016) : REM STRENGTH
20150 DX = PEEK(1015) : REM DEXTERITY
20160 IT = PEEK(1014) : REM INTELLIGENCE
20170 WI = PEEK(1013) : REM WISDOM
20180 HP = PEEK(1012) : REM HEALTH
20190 MP = PEEK(1011) : REM MANA
20200 AM = PEEK(1010) : REM AMMO
20210 GOLD = PEEK(1009) : REM GOLD
20220 EX = PEEK(1008) : REM EXPERIENCE
20230 PRINT ".";

20400 IF CLASS = 1 THEN ITEMS$(1, 1) = "Bronze Sword" : ITEMS$(1, 2) = "Iron Sword" : ITEMS$(1, 3) = "Mithril Sword" : ITEMS$(1, 4) = "Unidentified"
20422 IF CLASS = 1 THEN ITEMS$(2, 1) = "Wooden Shield" : ITEMS$(2, 2) = "Iron Shield" : ITEMS$(2, 3) = "Mithril Shield" : ITEMS$(2, 4) = "Unidentified"
20424 IF CLASS = 1 THEN ITEMS$(3, 1) = "Leather Armor" : ITEMS$(3, 2) = "Chain Mail" : ITEMS$(3, 3) = "Plate Mail" : ITEMS$(3, 4) = "Unidentified"
20426 IF CLASS = 1 THEN ITEMS$(4, 1) = "Bronze Helm" : ITEMS$(4, 2) = "Iron Helm" : ITEMS$(4, 3) = "Mithril Helm" : ITEMS$(4, 4) = "Unidentified"
20428 IF CLASS = 1 THEN ITEMS$(5, 1) = "Bracer" : ITEMS$(5, 2) = "Unidentified" : ITEMS$(5, 3) = "Unidentified" : ITEMS$(5, 4) = "Unidentified"

20430 IF CLASS = 2 THEN ITEMS$(1, 1) = "Iron Dagger" : ITEMS$(1, 2) = "Obsidian Knife" : ITEMS$(1, 3) = "Mithril Dagger" : ITEMS$(1, 4) = "Unidentified"
20432 IF CLASS = 2 THEN ITEMS$(2, 1) = "Shortbow" : ITEMS$(2, 2) = "Longbow" : ITEMS$(2, 3) = "Crossbow" : ITEMS$(2, 4) = "Unidentified"
20434 IF CLASS = 2 THEN ITEMS$(3, 1) = "Leather Vest" : ITEMS$(3, 2) = "Unidentified" : ITEMS$(3, 3) = "Unidentified" : ITEMS$(3, 4) = "Unidentified"
20436 IF CLASS = 2 THEN ITEMS$(4, 1) = "Ranger Hood" : ITEMS$(4, 2) = "Unidentified" : ITEMS$(4, 3) = "Unidentified" : ITEMS$(4, 4) = "Unidentified"
20438 IF CLASS = 2 THEN ITEMS$(5, 1) = "Amulet" : ITEMS$(5, 2) = "Unidentified" : ITEMS$(5, 3) = "Unidentified" : ITEMS$(5, 4) = "Unidentified"

20440 IF CLASS = 3 THEN ITEMS$(1, 1) = "Quarterstaff" : ITEMS$(1, 2) = "Unidentified" : ITEMS$(1, 3) = "Unidentified" : ITEMS$(1, 4) = "Unidentified"
20442 IF CLASS = 3 THEN ITEMS$(2, 1) = "Spellbook" : ITEMS$(2, 2) = "Unidentified" : ITEMS$(2, 3) = "Unidentified" : ITEMS$(2, 4) = "Unidentified"
20444 IF CLASS = 3 THEN ITEMS$(3, 1) = "Cloth Robe" : ITEMS$(3, 2) = "Unidentified" : ITEMS$(3, 3) = "Plate Mail" : ITEMS$(3, 4) = "Unidentified"
20446 IF CLASS = 3 THEN ITEMS$(4, 1) = "Wizard Hat" : ITEMS$(4, 2) = "Unidentified" : ITEMS$(4, 3) = "Mithril Helm" : ITEMS$(4, 4) = "Unidentified"
20448 IF CLASS = 3 THEN ITEMS$(5, 1) = "Ring" : ITEMS$(5, 2) = "Unidentified" : ITEMS$(5, 3) = "Unidentified" : ITEMS$(5, 4) = "Unidentified"
20490 RETURN


20499 REM READ MAP DATA FROM MEMORY
20500 FOR I = SIZE TO 1 STEP -1
20520   FOR J = SIZE TO 1 STEP -1
20525     K = ((I - 1) * SIZE + J - 1)
20540     MAP(I, J) = PEEK(948 - K)
20550     VIS(I, J) = PEEK(974 - K)
20560     INS(I, J) = PEEK(1000 - K)
20650   NEXT J
20655   IF I = 2 OR I = 4 THEN PRINT ".";
20660 NEXT I
20670 RETURN



20999 REM DISPLAY PLAYER STATS
21000 VTAB(1) : HTAB(61) : PRINT MI$;CLASSES$(CLASS);NI$
21010 VTAB(3) : HTAB(51) : PRINT "HP: ";HP;"/";HP;"   Str: ";SR;"   Att: ";AK;" "
21030 VTAB(5) : HTAB(51) : PRINT "MP: ";MP;"/";MP;"     Dex: ";DX;"   AC: +";AC;" "
21040 VTAB(7) : HTAB(63) : PRINT "Int: ";IT;"   Wis: ";WI;" "; : HTAB(51)
21045 IF CLASS = 1 THEN PRINT "Block: ";AM;" "
21050 IF CLASS = 2 THEN PRINT "Arrows: ";AM;" "
21055 IF CLASS = 3 THEN PRINT "Spells: ";AM;" "
21056 VTAB(23) : HTAB(14) : PRINT ".";

21060 REM VTAB(7) : HTAB(57) : PRINT GOLD;"   "
21066 REM VTAB(7) : HTAB(68) : PRINT EX;"/100    "
21070 REM VTAB(12) : HTAB(50) : PRINT ITEMS$(1,1);M$;"_";N$; : VTAB(13) : HTAB(50) : PRINT ITEMS$(1,2);M$;"_";N$;
21080 REM VTAB(12) : HTAB(60) : PRINT ITEMS$(2,1);M$;"_";N$; : VTAB(13) : HTAB(60) : PRINT ITEMS$(2,2);M$;"_";N$;
21090 REM VTAB(12) : HTAB(70) : PRINT ITEMS$(3,1); : VTAB(13) : HTAB(70) : PRINT ITEMS$(3,2);
21190 RETURN


21999 REM DRAW ALL MAP ROOMS ROUTINE XX = RX * RW : YY = (RY+1) * RH : X1 = RX+1 : Y1 = RY+2
22000 FOR RY = 0 TO 4
22100   FOR RX = 0 TO 4
22200     REM CALCULATE THE X AND Y COORDINATES OF THE TOP LEFT CORNER OF THE ROOM
22300     XX = RX * RW
22400     YY = RY * RH
22420     X1 = RX+1
22440     Y1 = RY+1
22500     REM DRAW A ROOM AT THE CURRENT POSITION
22600     GOSUB 16000
22650     IF RY < 4 AND RX = 1 THEN PRINT ".";
22700   NEXT RX
22800 NEXT RY
22900 RETURN


23999 REM DEBUG LINE AT THE BOTTOM
24000 IF DEBUG = 0 OR X = 0 THEN RETURN
24005 REM HTAB(1) : VTAB(24) : ? MI$;XX;NI$;
24010 HTAB(4) : VTAB(24) : ? MI$;" cursor: ";X;"x";Y;NI$;M$;"N";N$;MI$;" PLR symbol: ";A;
24020 IF A < 10 THEN PRINT "   ";NI$; : GOTO 24050
24030 IF A < 100 THEN PRINT "  ";NI$; : GOTO 24050
24040 PRINT " ";NI$;
24050 HTAB(36) : VTAB(24) : PRINT M$;"V";N$;A$;M$;"V";N$;MI$;" ";NI$;
24060 HTAB(40) : VTAB(24) : PRINT M$;"N";N$;MI$"  key:";
24062 IF KY < 10 THEN PRINT " ";KY;"   ";NI$; : GOTO 24070
24064 IF KY < 100 THEN PRINT " ";KY;"  ";NI$; : GOTO 24070
24066 PRINT " ";KY;" ";NI$;
24070 HTAB(52) : VTAB(24) : PRINT M$"N";N$;MI$;" DEBUG";NI$;M$;"N";N$;MI$;"  ";NI$;
24080 GOSUB 800 : REM FRE
24100 RETURN


25999 REM LOAD DOUBLE HI-RES PICTURE
26000 REM POKE 49237,0: PRINT D$;"BLOAD ";FF$;", A$2000, L$2000"
26010 REM POKE 49236,0: PRINT D$;"BLOAD ";FF$;", A$2000, L$2000, B$2000"
26020 REM RETURN


30499 REM DEBUG PRINT MAZE
30500 IF DEBUG < 1 THEN RETURN
30535 FOR YY = 1 TO SIZE
30540    FOR XX = 1 TO SIZE
30545       HTAB(57 + XX) : VTAB(15 + YY) : O = 1 : IF XX = 1 THEN ? CHR$(8);MI$;" ";NI$;
30565       IF MAP(XX, YY) = 0 OR O > 0 THEN INVERSE : PRINT MAP(XX, YY) : NORMAL : GOTO 30575
30570       PRINT MAP(XX, YY)
30575    NEXT XX
30580 NEXT YY
30585 FOR YY = 1 TO SIZE
30590    FOR XX = 1 TO SIZE
30595       HTAB(64 + XX) : VTAB(15 + YY) : IF XX = 1 THEN PRINT CHR$(8);CHR$(8);M$;"N";N$;MI$;" ";NI$;
30600       IF X = XX AND Y = YY THEN PRINT MI$;VIS(XX, YY);NI$; : NORMAL : GOTO 30610
30605       PRINT VIS(XX, YY);M$;"N";N$;MI$;" ";NI$;
30610    NEXT XX
30615 NEXT YY
30670 RETURN


59999 REM ERROR HANDLING
60000 ER = PEEK(222)
60005 IF ER = 0 OR ER > 15 THEN PRINT : PRINT : CALL 4102
60020 IF ER <> 2 AND ER <> 3 AND ER <> 8 AND ER <> 11 THEN PRINT " ERROR!";
60030 PRINT CHR$(7);" in line ";PEEK(218) + PEEK(219) * 256
60050 REM TRACE VARIABLES
60060 REM PRINT AA$;" ";STACK;" ";XX;"*";YY;" ";X;"*";Y;" U:";INT(RU*10)/10;" R:";INT(RR*10)/10;" D:";INT(RD*10)/10;" L:";INT(RL*10)/10
60090 END

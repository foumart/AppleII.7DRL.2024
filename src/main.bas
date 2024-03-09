0 REM 7DRL2024 ENTRY BY NONCHO SAVOV
5 REM COPYRIGHT (C) 2024 BY FOUMARTGAMES

10 ONERR GOTO 60000 : REM BETTER ERROR HANDLING (NEEDS 14 BYTES AT THE BEGINNING IN A REM)
20 FOR I = 826 TO 839 : REM WRITE THE MACHINE CODE IN THE BEGINNING OF THIS SAME BASIC FILE
30   READ K
40   POKE I,K
50 NEXT
80 DATA 166,222,189,96,210,72,32,92,219,232,104,16,245,96

90 REM : RNG = RND(-1*(PEEK(78)+256*PEEK(79)))

100 GOTO 2000


195 REM BELOW ARE ROUTINES THAT NEED TO BE FAST,
196 REM THEREFORE THEY ARE AT THE BEGINNING OF THE PROGRAM

197 REM HTAB() BUG HANDLING - MAKE SURE WE HAVE THE CORRECT HORIZONTAL POSITION
198 REM PEEK(36) AND POS(0) ARE NOT WORKING IN 80 COL, SO WE WRITE TO DIFFERENT ADDRESSES
199 REM REM POKE 1531,Y : POKE 37,Y (Y IS OKAY)
200 POKE 1147,WW-1 : POKE 1403,WW-1 : POKE 36,WW-1
260 RETURN


279 REM RUN GC OR PRODOS FRE AND DISPLAY FREE MEMORY LEFT IF IN DEBUG MODE
280 IF FF = 1 THEN AVAIL = FRE(0)
284 IF FF = 2 THEN ? D$;"FRE"
286 FF = 0
288 IF DEBUG = 0 THEN RETURN
290 IF DEBUG > 0 THEN HTAB(62) : VTAB (24) : PRINT MI$;" free:";INT(AVAIL/1000);"k ";AVAIL;
291 IF (AVAIL > 9999) THEN PRINT " ";NI$; : GOTO 295
292 IF (AVAIL > 999) THEN PRINT "   ";NI$; : GOTO 295
293 PRINT "    ";NI$;
295 RETURN



674 REM ADD A CELL TO STACK
675 IF DEBUG > 3 THEN HTAB(36) : VTAB(1) : PRINT XX;"*";YY;
682 IF DEBUG > 3 THEN VV = 6 : GOSUB 23000 : PRINT : REM LIMIT SCROLL AREA
685 ZZ = 0
690 FOR II = 1 TO STACK
695   IF SX(II) = XX AND SY(II) = YY THEN ZZ = 1
700 NEXT II
702 IF ZZ = 1 AND DEBUG > 3 THEN VTAB(20) : HTAB(2) : PRINT AA$;" Skip ";STACK;":";XX;"x";YY;""
705 IF ZZ = 1 THEN GOTO 750
710 STACK = STACK + 1 : FF = FF + 1 : VTAB(20) : HTAB(2)
715 IF DEBUG > 3 AND AA$ = "C" THEN PRINT AA$;" Add> ";STACK;":";XX;"x";YY;""
718 IF DEBUG > 3 AND AA$ = "C" THEN GOTO 740
720 IF DEBUG > 3 AND RU > RR AND RU > RD AND RU > RL THEN PRINT AA$;" Add> ";STACK;":";XX;"x";YY;" U:";MI$;INT(RU*10)/10;NI$;" R:";INT(RR*10)/10;" D:";INT(RD*10)/10;" L:";INT(RL*10)/10
725 IF DEBUG > 3 AND RR > RU AND RR > RD AND RR > RL THEN PRINT AA$;" Add> ";STACK;":";XX;"x";YY;" U:";INT(RU*10)/10;" R:";MI$;INT(RR*10)/10;NI$;" D:";INT(RD*10)/10;" L:";INT(RL*10)/10
730 IF DEBUG > 3 AND RD > RU AND RD > RR AND RD > RL THEN PRINT AA$;" Add> ";STACK;":";XX;"x";YY;" U:";INT(RU*10)/10;" R:";INT(RR*10)/10;" D:";MI$;INT(RD*10)/10;NI$;" L:";INT(RL*10)/10
735 IF DEBUG > 3 AND RL > RU AND RL > RR AND RL > RD THEN PRINT AA$;" Add> ";STACK;":";XX;"x";YY;" U:";INT(RU*10)/10;" R:";INT(RR*10)/10;" D:";INT(RD*10)/10;" L:";MI$;INT(RL*10)/10;NI$
740 SX(STACK) = XX
745 SY(STACK) = YY
746 IF DEBUG > 3 THEN GOSUB 23100 : REM RESTORE SCROLL AREA
748 RETURN


749 REM DEPTH-FIRST SEARCH ALGORITHM FOR GENERATING A RANDOMIZED INTERCONNECTED ROOM MAP
750 X = INT(RND(1) * SIZE) + 1: Y = SIZE : REM INITIAL ROOM PICK (LEVEL ENTRANCE)

765 REM MARK THE LEVEL ENTRANCE CELL AS VISITED
770 INSIDES(X, Y) = 1 : VISIBLES(X,Y) = 2 : MAP(X,Y) = 1
780 POKE 1022,5 + 9*(X-1) : REM WRITE INITIAL PLAYER X POSITION
790 POKE 1021,19 : REM PLAYER Y POSITION IS ALWAYS AT THE BOTTOM

805 XX = X : YY = Y : AA$ = "C" : GOSUB 675
810 GOSUB 30500 : REM DEBUG DISPLAY THE STAGE DURING GENERATION
820 IF DEBUG > 4 THEN CALL 768 : REM WAIT FOR KEYPRESS

825 REM CHECK FOR UNVISITED NEIGHBOURS
830 NEIGHBRS = 0 : REM RESET
835 AVAILABLE(1) = 0 : REM UP
840 AVAILABLE(2) = 0 : REM RIGHT
845 AVAILABLE(3) = 0 : REM DOWN
850 AVAILABLE(4) = 0 : REM LEFT
855 FOR DIR = 1 TO 4
860   IF DIR = 1 AND Y > 1 THEN GOTO 890 : REM UP
865   IF DIR = 2 AND X < SIZE THEN GOTO 900 : REM RIGHT
870   IF DIR = 3 AND Y < SIZE THEN GOTO 910 : REM DOWN
875   IF DIR = 4 AND X > 1 THEN GOTO 920 : REM LEFT
880 NEXT DIR
885 GOTO 930

890 IF VISIBLES(X, Y - 1) = 0 THEN NEIGHBRS = NEIGHBRS + 1: AVAILABLE(1) = 1
895 GOTO 880
900 IF VISIBLES(X + 1, Y) = 0 THEN NEIGHBRS = NEIGHBRS + 1: AVAILABLE(2) = 1
905 GOTO 880
910 IF VISIBLES(X, Y + 1) = 0 THEN NEIGHBRS = NEIGHBRS + 1: AVAILABLE(3) = 1
915 GOTO 880
920 IF VISIBLES(X - 1, Y) = 0 THEN NEIGHBRS = NEIGHBRS + 1: AVAILABLE(4) = 1
925 GOTO 880

930 IF NEIGHBRS = 0 THEN GOTO 1200 : REMOVE THE CELL FROM STACK
940 I = 1
945 VTAB(24) : HTAB(1)
950 RU = RND(1)*4 : RR = RND(1)*4 : RD = RND(1)*4 : RL = RND(1)*4 : REM DEFINE PROBABILITIES
955 IF RU > RR AND RU > RD AND RU > RL AND AVAILABLE(1) > 0 THEN GOTO 1000
960 IF RR > RU AND RR > RD AND RR > RL AND AVAILABLE(2) > 0 THEN GOTO 1010
965 IF RD > RU AND RD > RR AND RD > RL AND AVAILABLE(3) > 0 THEN GOTO 1020
970 IF RL > RU AND RL > RR AND RL > RD AND AVAILABLE(4) > 0 THEN GOTO 1030
975 IF AVAILABLE(1) > 0 THEN GOTO 1000
980 IF AVAILABLE(2) > 0 THEN GOTO 1010
985 IF AVAILABLE(3) > 0 THEN GOTO 1020
990 IF AVAILABLE(4) > 0 THEN GOTO 1030
995 GOTO 1040

1000 Y = Y - 1 : GOTO 1050 : REM UP
1005 GOTO 1040
1010 X = X + 1 : GOTO 1090 : REM RIGHT
1015 GOTO 1040
1020 Y = Y + 1 : GOTO 1125 : REM DOWN
1025 GOTO 1040
1030 X = X - 1 : GOTO 1160 : REM LEFT
1035 GOTO 1040

1040 I = I + 1
1045 GOTO 945

1050 AA$ = "U" : REM UP
1055 IF MAP(X,Y) = 0 THEN MAP(X,Y) = 1
1060 VISIBLES(X,Y) = 1
1065 IF MAP(X,Y+1) < 2 THEN MAP(X,Y+1) = 2 : GOTO 1080
1070 IF MAP(X,Y+1) = 3 THEN MAP(X,Y+1) = 4
1075 REM TODO : CLOSED DOORS
1080 XX = X : YY = Y : GOSUB 675
1085 GOTO 1230

1090 AA$ = "R" : REM RIGHT
1095 IF MAP(X,Y) = 0 THEN MAP(X,Y) = 3 : GOTO 1105
1100 IF MAP(X,Y) = 2 THEN MAP(X,Y) = 4
1105 VISIBLES(X,Y) = 1
1110 REM IF MAP(X-1,Y) = 0 THEN MAP(X-1,Y) = 1
1115 XX = X : YY = Y : GOSUB 675
1120 GOTO 1230

1125 AA$ = "D" : REM DOWN
1130 IF MAP(X,Y) = 0 THEN MAP(X,Y) = 2 : GOTO 1140
1135 IF MAP(X,Y) = 3 THEN MAP(X,Y) = 4
1140 VISIBLES(X,Y) = 1
1145 REM IF MAP(X,Y-1) = 0 THEN MAP(X,Y-1) = 1
1150 XX = X : YY = Y : GOSUB 675
1155 GOTO 1230

1160 AA$ = "L" : REM LEFT
1165 IF MAP(X,Y) = 0 THEN MAP(X,Y) = 1
1170 VISIBLES(X,Y) = 1
1175 IF MAP(X+1,Y) = 1 THEN MAP(X+1,Y) = 3 : GOTO 1185
1180 IF MAP(X+1,Y) = 2 THEN MAP(X+1,Y) = 4
1185 XX = X : YY = Y : GOSUB 675
1190 GOTO 1230

1199 REM IF NO UNVISITED NEIGHBOURS - BACKTRACK
1200 IF TYPE = 1 THEN GOTO 1220
1205 SX(STACK) = 0 : SY(STACK) = 0 : STACK = STACK - 1 : INDEX = STACK
1210 IF DEBUG > 3 THEN VV = 6 : GOSUB 23000 : VTAB(20) : HTAB(2) : PRINT "Removed ";STACK;" at ";X;"x";Y; ", get ";SX(STACK);"x";SY(STACK) : GOSUB 23100
1215 GOTO 1230

1220 SX(INDEX) = 0 : SY(INDEX) = 0 : STACK = STACK - 1
1225 IF DEBUG > 3 THEN VV = 6 : GOSUB 23000 : VTAB(20) : HTAB(2) : PRINT "Removed ";INDEX;" at ";X;"x";Y; ", get ";SX(INDEX);"x";SY(INDEX) : GOSUB 23100

1229 REM GET ANOTHER (NEXT IF TYPE = 1) STACKED CELL : TODO
1230 IF FF > 1 AND FF < 18 THEN GOTO 1240
1235 GOTO 1260
1240 VTAB(23) : HTAB(OFFSET + 12 + FF) : IF FF / 2 = INT(FF / 2) THEN PRINT M$;L1$;N$; : GOTO 1260
1250 PRINT M$;L2$;N$;
1260 IF FF > 16 THEN VTAB(23) : HTAB(OFFSET + 12 + (FF-15)*2 - 2) : PRINT MI$;"  ";NI$;
1270 IF SX(STACK) > 0 THEN X = SX(STACK) : Y = SY(STACK) : GOTO 810
1280 VTAB(23) : HTAB(OFFSET + 22) : PRINT MI$;"         ";NI$;
1350 RETURN

1499 REM CLEAR PROGRESS BAR IN THE BOTTOM
1500 IF RETRY > 0 THEN 1600
1505 HTAB(OFFSET) : VTAB(22) : PRINT "_";
1510 HTAB(OFFSET) : VTAB(23)
1512 IF XX = 1 THEN PRINT M$;"C";N$;" ";FILES$(J);
1514 IF XX > 1 THEN PRINT M$;"C";N$;" Generate: ";
1520 HTAB(OFFSET + 14)
1530 IF XX = 1 THEN FOR P = 1 TO Z * 2 + 3 : PRINT M$;"\\";N$; : NEXT P : GOTO 1560
1540 FOR P = 1 TO XX * 2 + 1 : PRINT M$;"\\";N$; : NEXT P
1560 RETURN

1599 REM CLEAR PROGRESS BAR IN THE BOTTOM
1600 WW = 1 : GOSUB 200 : VTAB(22) : CALL -958
1660 HTAB(OFFSET) : VTAB(23) : PRINT M$;"C";N$;" Generate: ";
1690 REM HTAB(OFFSET + 14)
1720 REM FOR P = 1 TO XX * 2 + 1 : PRINT M$;"\\";N$; : NEXT P
1740 HTAB(OFFSET + 13) : VTAB(22) : PRINT "___________________"; : HTAB(OFFSET + 13) : VTAB(24) : PRINT M$;"LLLLLLLLLLLLLLLLLLL";N$;
1760 HTAB(OFFSET + 12) : VTAB(23) : PRINT M$;"Z";N$;MI$;" ";NI$; : HTAB(OFFSET + 31) : VTAB(23) : PRINT MI$;" ";NI$;M$;"_";N$;" Re-Seeding..."
1790 RETURN

1990 REM END FAST SUBROUTINES PORTION ^^





1995 REM VARIABLE DECLARATIONS
2000 DEBUG = PEEK(1023) : REM GET DEBUG SETTING SAVED BY STARTUP
2005 D$ = CHR$(4) : AVAIL = FRE(0)
2010 MI$ = CHR$(15) : REM TURN INVERSE ON
2015 NI$ = CHR$(14) : REM TURN INVERSE OFF
2020 M$ = MI$ + CHR$(27) : REM TURN SPECIAL CHARACTERS ON (80COL MOUSE TEXT CARD CHARS)
2025 N$ = CHR$(24) + NI$ : REM TURN SPECIAL CHARACTERS OFF
2030 KY = PEEK(49152) : REM VARIABLE TO KEEP LAST PRESSED KEY
2035 KK = KY : REM USED TO TRACK KEY PRESSES DURING LOAD TO SWITCH TO TEXT MODE UNTIMELY

2040 UU = 0 : VV = 0 : WW = 0 : REM VARIABLES TO BE USED IN SUBROUTINES
2045 XX = 0 : YY = 0 : ZZ = 0 : REM VARIABLES TO BE USED IN SUBROUTINES (DURING STAGE GENERATION)
2050 FF = 0 : REM SET TO 1 TO PERFORM FRE(0), SET TO 2 TO PERFORM THE PRODOS FRE() COMMAND, THEN GOSUB 280
2060 DIM N1%(10) : REM RANDOM SEED ARRAY OF 10 SHUFFLED NUMBERS (TO VISUALLY DISTINGUISH THE SEED, NOTHING ELSE)

2070 DIM CLASSES$(3) : REM STARTING PLAYER CLASSES
2080 CLASSES$(1) = "Fighter" : CLASSES$(2) = "Strider" : CLASSES$(3) = "Scholar"
2090 DIM ITEMS$(3, 2) : REM INITIAL ITEMS: 1:WEAPON, 2:SECONDARY ITEM, 3:ARMOR
2100 RETRY = 0

2120 W = 5 : REM NUMBER OF TEXT FILES TO LOAD
2130 Z = 11 : REM THE NUMBER OF TEXT LINES EACH FILE HAS
2140 I = 1 : J = 1 : L1$ = M$+"WV"+N$ : L2$ = M$+"VW"+N$ : OFFSET = 20
2150 DIM FILES$(W)
2160 FILES$(1) = "Encounter"
2170 FILES$(2) = "BattleWin"
2180 FILES$(3) = "StartSeed"
2190 FILES$(4) = "BeginGame"
2200 FILES$(5) = "MoreStory"
2210 REM FILES$(6) = "EndScreen"

2220 DIM COODS(W, 3) : REM WILL HOLD ALL UI PARAMETTERS: L, H, V
2230 DIM LINES$(W, Z) : REM WILL HOLD ALL UI DISPLAYS

2235 IF DEBUG > 0 THEN GOSUB 280 : REM FRE()
2250 KY = PEEK(49152) : IF KY <> KK THEN TEXT : REM SWITCHING TEXT DURING LOAD
2255 I = 1 : REM CLEAR PROGRESS BAR FOR NEW READING/BUFFERING DISPLAY
2260 HTAB(71) : VTAB(18) : PRINT 1 + INT(J*1.5); : PRINT "0"; : REM PSEUDO LOADING PERCENTAGE DISPLAY
2270 FF = 1 : GOSUB 280 : REM FRE()
2280 XX = 1 : GOSUB 1500 : REM CLEAR PROGRESS BAR

2798 REM TODO: CONVERT TEXT READ WITH DATA READ
2799 REM IF DEBUG = 0 THEN TEXT
2800 HTAB(72) : VTAB(18) : PRINT 1 : REM PSEUDO LOADING PERCENTAGE DISPLAY
2850 VTAB(23) : HTAB(62) : PRINT D$;"OPEN ";FILES$(J)
2900 HTAB(62) : PRINT D$;"READ ";FILES$(J)
3000 HTAB(62) : INPUT L : IF DEBUG > 1 THEN L = 0 : Z = 0 : REM GET THE TOTAL LINES OF THE TEXT FILE (FIRST PARAMETER FROM TEXT FILE)
3050 COODS(J, 1) = L : HTAB(72) : VTAB(18) : PRINT 2 : REM PSEUDO LOADING PERCENTAGE DISPLAY
3100 VTAB(23) : HTAB(OFFSET + 14) : PRINT M$;L2$;N$;
3125 HTAB(62) : INPUT H : REM GET LEFT OFFSET WHEN INSERTING THE TEXT (SECOND PARAMETER FROM TEXT FILE)
3150 COODS(J, 2) = H : HTAB(72) : VTAB(18) : PRINT 3 : REM PSEUDO LOADING PERCENTAGE DISPLAY
3175 VTAB(23) : HTAB(OFFSET + 15) : PRINT M$;L1$;N$;
3200 HTAB(62) : INPUT V : REM GET TOP OFFSET WHEN INSERTING THE TEXT (THIRD PARAMETER FROM TEXT FILE)
3250 COODS(J, 3) = V : HTAB(72) : VTAB(18) : PRINT 4 : REM PSEUDO LOADING PERCENTAGE DISPLAY

3300 VTAB(23) : HTAB(OFFSET + 15 + I * 2) : PRINT M$;L1$;N$;
3310 IF L = 0 THEN GOTO 3700
3350 HTAB(62) : INPUT A$ : REM GET THE NEXT DATA ROW
3400 LINES$(J, I) = A$ : I = I + 1 : REM SAVE IT AS NEW LINE
3500 IF I > COODS(J, 1) THEN GOTO 3700
3600 GOTO 3300 : REM READING LINES LOOP
3700 HTAB(62) : PRINT D$;"CLOSE"

3710 IF J = 3 THEN FF$ = "SCREEN" : GOSUB 26000 : REM LOAD TITLE PICTURE
3720 FF = 2 : GOSUB 280

3750 REM CONVERTING THE DATA
3800 REM UPDATING THE DATA IN PLACE
3850 HTAB(72) : VTAB(18) : PRINT 5; : REM PSEUDO LOADING PERCENTAGE DISPLAY
3900 HTAB(OFFSET) : VTAB(22)
3950 PRINT M$;"I";N$ : HTAB(OFFSET) : PRINT M$;"C";N$;" ";FILES$(J);
4400 HTAB(OFFSET + 14)
4500 PRINT M$;" ";N$;
4550 IF L = 0 THEN GOTO 5960 : REM DURING DEBUG WE MAY SKIP PRINTING UI TEXTS

4600 FOR I = 1 TO COODS(J, 1)
4700   NE$ = ""
4800   A$ = LINES$(J, I) : M = LEN(A$) : D = 1
4900   FOR XI = 1 TO M
5000     B$ = MID$(A$, XI, 1)
5100     C = ASC(B$)
5150     IF XI = 20 THEN PRINT M$;" ";N$; : REM PROGRESS DISPLAY
5180     KY = PEEK(49152) : IF KY <> KK THEN TEXT : REM SWITCHING TEXT DURING LOAD
5200     IF C = 123 THEN NE$ = NE$ + M$ : GOTO 5900 : REM TURN MOUSE TEXT ON WITH TRIGGER: "{"
5300     IF C = 125 THEN NE$ = NE$ + N$ : GOTO 5900 : REM TURN MOUSE TEXT OFF WITH TRIGGER: "}"
5400     IF C = 91 THEN NE$ = NE$ + MI$ : GOTO 5900 : REM TURN INVERSE ON WITH TRIGGER: "["
5500     IF C = 93 THEN NE$ = NE$ + NI$ : GOTO 5900 : REM TURN INVERSE OFF WITH TRIGGER: "]"
5650     IF C = 59 THEN NE$ = NE$ + ":" : GOTO 5900 : REM TYPE TWO DOTS PUNCTUATION ":" WITH TRIGGER: ";"
5700     IF C = 96 THEN NE$ = NE$ + "." : GOTO 5900 : REM TYPE A PERIOD "." WITH TRIGGER: "`"
5800     IF C < 125 THEN NE$ = NE$ + B$ : REM WILL PRINT THE REQUESTED LETTER
5850     IF C = 126 THEN NE$ = NE$ + "," : REM TYPE A COMMA "," WITH TRIGGER: "~"
5900   NEXT XI
5920   LINES$(J, I) = NE$
5930   PRINT M$;" ";N$; : REM PROGRESS DISPLAY
5940 NEXT I
5950 PRINT M$;"  ";N$;
5960 J = J + 1 : IF J < W + 1 THEN GOTO 2250


6000 TEXT : REM SWITCH TO TEXT MODE NOW
6035 KY = PEEK(49152) : REM GET LAST PRESSED KEY
6040 GOSUB 280 : REM FRE

6050 HTAB(70) : VTAB(18) : PRINT 100; : HTAB(76) : PRINT M$;"D";N$ : REM PSEUDO LOADING PERCENTAGE DISPLAY COMPLETE
6060 HTAB(52) : VTAB (22) : CALL -868 : REM CLEAR TEXT FROM CURSOR TO END OF LINE
6065 HTAB(22) : VTAB (23) : ? "Randomize:";M$;"Z";N$;MI$;" > Press Any Key < ";NI$;M$;"_";N$;"- Requirement";
6075 HTAB(52) : VTAB (24) : CALL -868 : GOSUB 280 : REM CLEAR AND FRE

6300 VV = 2 : GOSUB 23000 : REM LIMIT SCROLL AREA

6310 CALL 768 : IF DEBUG > 4 OR DEBUG = 2 THEN RNG = RND(-1*(PEEK(78)+256*PEEK(79))) : REM RANDOMIZE SEED

6320 HOME : REM PRINT SECOND SCREEN OF THE STORY
6350 FOR I = 1 TO 5 : PRINT LINES$(5, I) : NEXT I
6360 PRINT : FOR I = 6 TO 11 : PRINT LINES$(5, I) : NEXT I
6380 GOSUB 23100 : REM RESET SCROLL AREA

6400 W = 3 : X1 = 8 : GOSUB 25000 : REM DRAW RANDOM SEED WINDOW AND SECOND SCREEN OF STORY ENDING (WITHOUT BOTTOM BUTTONS)
6410 GOSUB 280 : REM DISPLAY FREE MEMORY
6415 W = PEEK(78) : IF W < 10 THEN HTAB(61) : REM DISPLAY SEED VARS
6420 IF W > 9 THEN HTAB(60)
6425 IF W > 99 THEN HTAB(59)
6435 VTAB (18) : PRINT MI$;W;NI$;

6440 W = PEEK(79) : IF W < 10 THEN HTAB(69)
6445 IF W > 9 THEN HTAB(68)
6450 IF W > 99 THEN HTAB(67)
6455 VTAB (18) : PRINT MI$;W;NI$;

6560 FOR I = 1 TO 10 : N1%(I) = I - 1 : NEXT I
6570 REM SHUFFLE THE NUMERIC ARRAY USING RANDOM SWAPS
6580 FOR I = 1 TO 10
6600   N = INT(RND(1) * 10) + 1
6620   T = N1%(I) : REM SWAP THE ELEMENT AT THE CURRENT INDEX WITH THE ELEMENT AT THE RANDOM INDEX
6630   N1%(I) = N1%(N)
6640   N1%(N) = T
6650 NEXT I
6660 VTAB(20) : HTAB(59) : REM PRINT THE NUMERIC SEED
6670 FOR I = 1 TO 10
6680  PRINT N1%(I);
6690 NEXT I

6699 REM PICK A RANDOM LETTER
6700 N2% = INT(RND(1) * 32) + 1
6710 PRINT CHR$(63 + N2%); : REM PRINT 1 CHARACTER AFTER THE SHUFFLED NUMBERS

6750 GOSUB 21200 : REM RANDOMIZE PLAYER STATS
6760 GOSUB 21000 : REM DISPLAY PLAYER STATS

6770 XX = 8 : GOSUB 1500 : REM CLEAR PROGRESS BAR

6775 REM GENERATE STAGE
6780 GOSUB 22000

6790 W = 3 : X1 = -8 : GOSUB 25000 : REM DRAW BEGIN JOURNEY WINDOW AGAIN WITH THE BOTTOM MENU UI
6795 POKE 2039, 64 : REM PRINT AN APPLE ICON AT BOTTOM RIGHT CORNER OF SCREEN (POKING TO PREVENT SCROLL)

6800 CALL 768 : REM WAIT FOR KEYPRESS
6810 KY = PEEK(49152) : REM GET LAST PRESSED KEY AND DISPLAY DEBUG CURSOR INFO
6815 IF KY = 32 THEN RNG = RND(-1*(PEEK(78)+256*PEEK(79))) : REM RE-SEED THE RND FUNCTION
6820 IF KY = 32 THEN RETRY = RETRY + 1 : GOTO 6400
6825 IF KY = 82 THEN RETRY = RETRY + 1 : GOTO 6400 : REM DON'T RESEED BUT USE THE CURRENT SEED NEXT RANDOM NUMBER
6830 IF KY = 13 THEN GOTO 6850
6840 GOTO 6810

6849 REM INITIALIZE THE GAME WITH THE RANDOM SEED
6850 HTAB(1) : VTAB(21) : CALL -958 : REM CLEAR TEXT FROM CURSOR TO BOTTOM OF WINDOW
6860 KY = PEEK(49152) : REM GET LAST PRESSED KEY AND DISPLAY DEBUG CURSOR INFO
6880 GOSUB 280 : REM FRE



7000 MX = 0 : MY = 0 : REM MAP ROOMS COORDINATES
7020 RW = 9 : RH = 4 : REM ROOM SIZE

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


8999 REM RENDERING GAME MAP AND SCREENS
9000 GOSUB 20000 : REM RENDER GAME MAP
9970 W = 4 : X1 = Z : GOSUB 25000 : REM RENDER GAME WELCOME SCREEN
9975 REM IF DEBUG = 1 THEN DEBUG = 3 : GOSUB 30500 : DEBUG = 1 : REM RENDER DEBUG STAGE DISPLAY : TEMP
9978 REM IF DEBUG = 2 THEN DEBUG = 3 : GOSUB 30500 : DEBUG = 2
9980 REM IF DEBUG > 2 THEN GOSUB 30500

9999 REM WRITE ALL GENERATED DATA IN MEMORY TO BE SENT TO THE GAME
10000 POKE 1020,CLASS : REM PLAYER CLASS
10010 POKE 1019,0 : REM ??
10020 POKE 1018,AK : REM ATTACK
10030 POKE 1017,AC : REM ARMOR CLASS
10040 POKE 1016,SR : REM STRENGTH
10050 POKE 1015,DX : REM DEXTERITY
10060 POKE 1014,IT : REM INTELLIGENCE
10070 POKE 1013,WI : REM WISDOM
10080 POKE 1012,HP : REM HEALTH
10090 POKE 1011,MP : REM MANA
10100 POKE 1010,AM : REM AMMO
10110 POKE 1009,GOLD : REM GOLD
10120 POKE 1008,EX : REM EXPERIENCE

10130 REM DIM MAP, VISIBLES, INSIDES
10140 REM DIM SS(5) : SS(1) = 871 : SS(2) = 897 : SS(3) = 923 : SS(4) = 949 : SS(5) = 975
10150 REM DIM SA(5) : SA(1) = 896 : SA(2) = 922 : SA(3) = 948 : SA(4) = 974 : SA(5) = 1000
10160 GOSUB 13000



11998 REM POKE 104,96 : POKE 24576,0 : REM LOAD THE GAME AT $6000
11999 REM LOAD THE GAME AT $4000
12000 POKE 104,64 : POKE 16384,0
12005 PRINT D$;"RUN GAME" : END


12999 REM SUBROUTINE TO STORE ARRAYS
13000 FOR I = SIZE TO 1 STEP -1
13020   FOR J = SIZE TO 1 STEP -1
13022     K = ((I - 1) * SIZE + J - 1)
13025     POKE 948 - K, MAP(I, J)
13040     POKE 974 - K, VISIBLES(I, J)
13060     POKE 1000 - K, INSIDES(I, J)
13250   NEXT J
13260 NEXT I
13270 RETURN


15999 REM DRAW A ROOM
16000 WW = MX+1 : GOSUB 200
16200 VTAB(MY+1)

16300 IF MY < 4 THEN GOTO 16600
16400 IF V > 1 THEN ? " ";M$;"\\\\\\\\\\\\\\";N$;" "; : REM DRAW IN BETWEEN ROOM VERTICAL SPACE
16500 GOTO 16800
16600 IF V > 1 THEN ? " _______ "; : REM DRAW TOP EDGE BORDER OF THE FIRST ROW ROOMS

16799 REM DRAW VISIBLE EMPTY ROOM
16800 M = MAP(ROW+1, COL+1)
16850 V = VISIBLES(ROW+1, COL+1)
16900 IF V > 1 THEN WW = MX+1 : GOSUB 200 : VTAB(MY+2) : ? M$;"Z_";N$;"     ";M$;"Z_";N$
17000 IF V > 1 OR M <> 0 THEN HTAB(MX+1) : VTAB(MY+3) : ? M$;"Z_";N$;" ";ROOMS$(INSIDES(ROW+1, COL+1)+1);"  ";M$;"Z_";N$
17100 IF V > 1 THEN HTAB(MX+1) : VTAB(MY+4) : ? M$;"Z_";N$;"     ";M$;"Z_";N$

17299 REM DRAW DISCOVERED ROOMS BUT WHICH ARE NOT REVELAED OUT YET AS GREYED OUT ROOMS
17300 IF V = 1 THEN WW = MX+1 : GOSUB 200 : VTAB(MY+2) : ? M$;"ZVWVWVWV_";N$
17310 IF V = 1 THEN HTAB(MX+1) : VTAB(MY+3) : ? M$;"ZVWVWVWV_";N$
17320 IF V = 1 THEN HTAB(MX+1) : VTAB(MY+4) : ? M$;"ZVWVWVWV_";N$

17399 REM CLEAR ROOMS THAT HAVEN'T BEEN DISCOVERED
17400 IF V = 0 THEN XX = MX+1 : GOSUB 200 : VTAB(MY+1) : ? "         "
17410 IF V = 0 THEN HTAB(MX+1) : VTAB(MY+2) : ? "         "
17430 IF V = 0 THEN HTAB(MX+1) : VTAB(MY+3) : ? "         "
17450 IF V = 0 THEN HTAB(MX+1) : VTAB(MY+4) : ? "         "
17460 IF V = 0 THEN HTAB(MX+1) : VTAB(MY+5) : ? "         "

17999 REM DRAW DOORS
18000 IF V = 0 GOTO 19600

18299 REM HORIZONTAL OPEN DOORS
18300 IF M <> 3 AND M <> 4 AND M <> 8 THEN GOTO 18800
18350 IF ROW < SIZE OR COL < SIZE THEN GOTO 18800
18400 IF VISIBLES(ROW+1, COL+1) > 0 THEN HTAB(MX-1) : VTAB(MY+3) : ? " "
18500 HTAB(MX+2) : VTAB(MY+3) : ? " "
18600 HTAB(MX) : VTAB(MY+3) : ? M$;"\\\\";N$

18799 REM HORIZONTAL CLOSED DOORS
18800 IF M <> 6 AND M <> 7 AND M <> 9 THEN GOTO 19300
18850 IF ROW < SIZE OR COL < SIZE THEN GOTO 19300
18900 IF VISIBLES(ROW+1, COL+1) > 0 THEN HTAB(MX-1) : VTAB(MY+3) : ? M$;"Z";N$
19000 IF VISIBLES(ROW+1, COL+2) > 0 THEN HTAB(MX+2) : VTAB(MY+3) : ? M$;"_";N$
19100 HTAB(MX) : VTAB(MY+3) : ? M$;" ^";N$

19299 REM VERTICAL OPEN DOOR
19300 IF M = 2 OR M = 4 OR M = 9 THEN HTAB(MX+4) : VTAB(MY+1) : ? M$;CHR$(95);N$" ";M$;CHR$(90);N$

19499 REM VERTICAL CLOSED DOOR
19500 IF M = 5 OR M = 7 OR M = 8 THEN HTAB(MX+2) : VTAB(MY+1) : ? "__";M$;" ^ ";N$;"__"

19599 REM
19600 IF MY < 15 THEN RETURN
19800 IF V > 1 THEN HTAB(MX+1) : VTAB(MY+5) : ? " ";M$;"LLLLLLL";N$;" " : REM DRAW BOTTOM EDGE BORDER OF THE BOTTOM ROW ROOMS

19900 RETURN





19999 REM DRAW ALL MAP ROOMS ROUTINE
20000 FOR ROW = 0 TO 4
20100   FOR COL = 0 TO 4
20200     REM CALCULATE THE X AND Y COORDINATES OF THE TOP LEFT CORNER OF THE ROOM
20300     MX = (ROW) * (RW)
20400     MY = (COL) * (RH)
20500     REM DRAW A ROOM AT THE CURRENT POSITION
20600     GOSUB 16000
20700   NEXT COL
20800 NEXT ROW
20900 RETURN


20999 REM DISPLAY PLAYER STATS
21000 VTAB(1) : HTAB(61) : PRINT MI$;CLASSES$(CLASS);NI$
21010 VTAB(3) : HTAB(51) : PRINT "HP: ";HP;"/";HP;"   Str: ";SR;"   Att: ";AK;" "
21030 VTAB(5) : HTAB(51) : PRINT "MP: ";MP;"/";MP;"     Dex: ";DX;"   AC: +";AC;" "
21040 VTAB(7) : HTAB(63) : PRINT "Int: ";IT;"   Wis: ";WI;" "; : HTAB(51)
21045 IF CLASS = 1 THEN PRINT "Block: ";AM;" "
21050 IF CLASS = 2 THEN PRINT "Arrows: ";AM;" "
21055 IF CLASS = 3 THEN PRINT "Spells: ";AM;" "

21060 REM VTAB(7) : HTAB(57) : PRINT GOLD;"   "
21066 REM VTAB(7) : HTAB(68) : PRINT EX;"/100    "
21070 VTAB(12) : HTAB(50) : PRINT ITEMS$(1,1);M$;"_";N$; : VTAB(13) : HTAB(50) : PRINT ITEMS$(1,2);M$;"_";N$;
21080 VTAB(12) : HTAB(60) : PRINT ITEMS$(2,1);M$;"_";N$; : VTAB(13) : HTAB(60) : PRINT ITEMS$(2,2);M$;"_";N$;
21090 VTAB(12) : HTAB(70) : PRINT ITEMS$(3,1); : VTAB(13) : HTAB(70) : PRINT ITEMS$(3,2);
21190 RETURN


21199 REM RANDOMIZE PLAYER STATS
21200 CLASS = CLASS + 1 : REM INT(RND(1) * 3) + 1 : REM FIGHTER, STRIDER OR SCHOLAR
21202 IF CLASS > 3 THEN CLASS = 1
21205 EX = 0 : REM EXPERIENCE
21210 HP = 21 - INT(RND(1) * 5) - INT(RND(1) * 3 + 1) * CLASS: IF HP < 10 THEN HP = 10
21220 AK = 4 - CLASS : REM MELEE DAMAGE - FIGHTER:3, STRIDER:2, SCHOLAR:1
21230 AC = 3 + CLASS*2 : REM ARMOR CLASS - FIGHTER:5, STRIDER:7, SCHOLAR:9
21240 GOLD = INT(RND(1) * 10)
21250 SR = 1 + INT(RND(1) * (4 - CLASS))
21260 DX = CLASS + INT(RND(1) * 3) : IF (CLASS = 3) THEN DX = DX - 2
21270 IF DX > 2 THEN AC = AC - 1
21280 IT = 1 + INT(RND(1) * CLASS * 1.5)
21285 MP = 0 : IF CLASS = 3 THEN MP = 12 - INT(RND(1) * (6 - IT)) : IF MP > 9 THEN MP = 9
21290 WI = 1 + INT(RND(1) * 3)
21300 AM = 1 : IF CLASS = 2 THEN AM = AM * 8 + INT(RND(1) * 8 - DX*1.5)
21310 IF CLASS = 3 THEN AM = AM + INT(RND(1) * 2 + IT)


21320 IF CLASS = 1 THEN ITEMS$(1,1) = " Bronze  " : ITEMS$(1,2) = "  Sword  "
21322 IF CLASS = 1 THEN ITEMS$(2,1) = " Wooden  " : ITEMS$(2,2) = " Shield  "
21324 IF CLASS = 1 THEN ITEMS$(3,1) = " Leather " : ITEMS$(3,2) = "  Armor  "

21330 IF CLASS = 2 THEN ITEMS$(1,1) = "  Iron   " : ITEMS$(1,2) = " Dagger  "
21332 IF CLASS = 2 THEN ITEMS$(2,1) = "  Short  " : ITEMS$(2,2) = "   Bow   "
21334 IF CLASS = 2 THEN ITEMS$(3,1) = " Leather " : ITEMS$(3,2) = "  Vest   "

21340 IF CLASS = 3 THEN ITEMS$(1,1) = " Quarter " : ITEMS$(1,2) = "  Staff  "
21342 IF CLASS = 3 THEN ITEMS$(2,1) = "  Spell  " : ITEMS$(2,2) = "  Book   "
21344 IF CLASS = 3 THEN ITEMS$(3,1) = "  Cloth  " : ITEMS$(3,2) = "  Robe   "

21420 RETURN



21999 REM GENERATE MAP ROUTINE
22000 IF DEBUG > 4 OR DEBUG = 2 THEN VTAB(19) : HTAB(50) : PRINT "Hit Any Key..." : CALL 768 : RNG = RND(-1*(PEEK(78)+256*PEEK(79)))
22005 IF SIZE = 5 THEN GOTO 22100
22008 DIM AVAILABLE(4)
22010 SIZE = 5 : REM INITIALIZE MAZE DIMENSIONS
22015 DIM MAP(SIZE,SIZE) : REM GENERATE MAP CONNECTIONS ARRAY
22020 DIM VISIBLES(SIZE,SIZE) : REM GENERATE MAP VISITED ROOMS ARRAY
22022 DIM INSIDES(SIZE,SIZE) : REM GENERATE MAP CONTENTS ARRAY
22025 DIM SX(SIZE*SIZE)
22030 DIM SY(SIZE*SIZE)


22100 TYPE = 0 : REM 0: LEAD CELL GENERATION (ZIG-ZAG LONGER); 1: RANDOM CELL (MORE CHAOTIC) : TODO TO IMPLEMENT
22110 AVAILABLE(1) = 0 : AVAILABLE(2) = 0 : AVAILABLE(3) = 0 : AVAILABLE(4) = 0 : REM 4 DIRECTIONS
22140 STACK = 0 : INDEX = 0

22150 IF DEBUG = 1 THEN DEBUG = 3 : GOSUB 30500 : DEBUG = 1 : REM DEBUG DISPLAY THE STAGE INITIALLY
22160 IF DEBUG = 2 THEN DEBUG = 3 : GOSUB 30500 : DEBUG = 2
22170 FF = 0 : GOSUB 750 : REM GENERATE STAGE
22180 IF DEBUG = 1 THEN DEBUG = 3 : GOSUB 30500 : DEBUG = 1 : REM DEBUG DISPLAY AFTER THE STAGE GENERATION
22190 IF DEBUG = 2 THEN DEBUG = 3 : GOSUB 30500 : DEBUG = 2

22200 FOR Y = 1 TO SIZE
22250   FOR X = 1 TO SIZE
22280     REM UU = 0
22300     REM IF X > 1 
22400     REM IF VISIBLES(X, Y) = 1 AND VISIBLES(X-1, Y) < 2 AND VISIBLES(X+1, Y) < 2 AND VISIBLES(X, Y-1) < 2 AND VISIBLES(X, Y+1) < 2 THEN VISIBLES(X, Y) = 0
22500     IF VISIBLES(X, Y) = 1 THEN VISIBLES(X, Y) = 0
22760     IF MAP(X, Y) > 0 THEN MAP(X, Y) = MAP(X, Y) + 3
22765   NEXT X
22770 NEXT Y

22890 IF DEBUG > 3 THEN VV = 2 : GOSUB 23000 : VTAB(20) : HTAB(2) : PRINT "Generation complete!" : GOSUB 23100
22898 RETURN : REM FINAL RETURN TO CALLER


22999 REM SET SCROLL WINDOW
23000 POKE 32,2 : REM SCROLL X
23010 POKE 33,42 : REM SCROLL WIDTH
23020 POKE 34,VV : REM SCROLL Y
23030 POKE 35,20 : REM SCROLL HEIGHT
23040 RETURN

23099 REM RESET SCROLL WINDOW
23100 POKE 32,0 : REM SCROLL X
23110 POKE 33,80 : REM SCROLL WIDTH
23120 POKE 34,0 : REM SCROLL Y
23130 POKE 35,24 : REM SCROLL HEIGHT
23140 RETURN


24998 REM PRINTING THE DATA ON SCREEN
24999 REM PRINT "xy:";COODS(W, 2);" x ";(COODS(W, 3) + 1) : HTAB(COODS(W, 2)) : VTAB (COODS(W, 3) + 1)
25000 Y1 = 1 : IF X1 < 0 THEN Y1 = X1 * -1 : X1 = Z
25100 FOR I = Y1 TO X1
25550    REM HTAB(42) : VTAB(24) : PRINT "xy:";COODS(W, 2);" x ";(COODS(W, 3) + I);
25600    WW = COODS(W, 2) : GOSUB 200 : VTAB (COODS(W, 3) + I)
25700    IF I < X1 THEN PRINT LINES$(W, I)
25750    IF I = X1 THEN PRINT LINES$(W, I);
25800 NEXT I
25900 RETURN


25999 REM LOAD DOUBLE HI-RES PICTURE
26000 POKE 49237,0: PRINT D$;"BLOAD ";FF$;", A$2000, L$2000"
26010 POKE 49236,0: PRINT D$;"BLOAD ";FF$;", A$2000, L$2000, B$2000"
26020 RETURN

30499 REM DEBUG PRINT MAZE
30500 IF DEBUG < 3 THEN GOTO 30670
30535 FOR YY = 1 TO SIZE
30540    FOR XX = 1 TO SIZE
30545       HTAB(57 + XX) : VTAB(15 + YY) : O = 1 : IF XX = 1 THEN ? CHR$(8);MI$;" ";NI$;
30550       FOR ZZ = 1 TO STACK
30555         IF XX = SX(ZZ) AND YY = SY(ZZ) THEN O = 0
30560       NEXT ZZ
30565       IF MAP(XX, YY) = 0 OR O > 0 THEN INVERSE : PRINT MAP(XX, YY) : NORMAL : GOTO 30575
30570       PRINT MAP(XX, YY)
30575    NEXT XX
30580 NEXT YY
30585 FOR YY = 1 TO SIZE
30590    FOR XX = 1 TO SIZE
30595       HTAB(64 + XX) : VTAB(15 + YY) : IF XX = 1 THEN PRINT CHR$(8);CHR$(8);M$;"N";N$;MI$;" ";NI$;
30600       IF X = XX AND Y = YY THEN PRINT MI$;VISIBLES(XX, YY);NI$; : NORMAL : GOTO 30610
30605       PRINT VISIBLES(XX, YY);M$;"N";N$;MI$;" ";NI$;
30610    NEXT XX
30615 NEXT YY
30620 IF DEBUG < 4 THEN GOTO 30670
30622 IF DEBUG > 4 THEN GOTO 30668
30625 WW = 1 : GOSUB 200 : VTAB(1)
30630 IF STACK < 10 THEN PRINT "#:";STACK;"                 " : GOTO 30640
30635 PRINT "#";STACK;"                 "
30640 FOR YY = 2 TO 5
30645   HTAB(1) : VTAB(YY) : CALL -868
30650 NEXT YY
30655 FOR YY = 1 TO STACK
30660   HTAB(1+INT(YY/SIZE)*4) : VTAB(YY - INT(YY/SIZE)*SIZE + 1) : PRINT SX(YY);"x";SY(YY);"  "
30665 NEXT YY
30668 CALL 768
30670 RETURN


60000 ER = PEEK(222)
60005 IF ER = 0 OR ER > 15 THEN PRINT : PRINT : CALL 826
60020 IF ER <> 2 AND ER <> 3 AND ER <> 8 AND ER <> 11 THEN PRINT " ERROR!";
60030 PRINT CHR$(7);" in line ";PEEK(218) + PEEK(219) * 256
60050 ? : REM TRACE VARIABLES
60060 REM PRINT AA$;" ";STACK;" ";XX;"*";YY;" ";X;"*";Y;" U:";INT(RU*10)/10;" R:";INT(RR*10)/10;" D:";INT(RD*10)/10;" L:";INT(RL*10)/10
60090 END

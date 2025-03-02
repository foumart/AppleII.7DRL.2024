0 REM 7DRL2024 ROGUELIKE ENGINE FOR APPLE II BY NONCHO SAVOV
5 REM COPYRIGHT (C) 2024 BY FOUMARTGAMES

10 ONERR GOTO 60000 : REM BETTER ERROR HANDLING (NEEDS 14 BYTES AT THE BEGINNING IN A REM)
20 FOR I = 16390 TO 16403 : REM WRITE THE MACHINE CODE IN THE BEGINNING OF THIS SAME BASIC FILE ($4000)
30   READ K
40   POKE I,K
50 NEXT
80 DATA 166,222,189,96,210,72,32,92,219,232,104,16,245,96

90 GOTO 2000


99 REM BELOW ARE ROUTINES THAT NEED TO BE FAST, THEREFORE THEY ARE AT THE BEGINNING OF THE PROGRAM

197 REM HTAB() BUG HANDLING - MAKE SURE WE HAVE THE CORRECT HORIZONTAL POSITION
198 REM PEEK(36) AND POS(0) ARE NOT WORKING IN 80 COL, SO WE WRITE TO DIFFERENT ADDRESSES
199 REM REM POKE 1531,Y : POKE 37,Y (Y IS OKAY)
200 POKE 1147,WW-1 : POKE 1403,WW-1 : POKE 36,WW-1
260 RETURN


299 REM SET SCROLL WINDOW
300 POKE 32,V1 : REM SCROLL X
310 POKE 33,V2 : REM SCROLL WIDTH
315 POKE 34,V3 : REM SCROLL Y
320 POKE 35,V4 : REM SCROLL HEIGHT
325 RETURN

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


599 REM RUN FRE BASIC COMMAND TO FORCE GC, OR PRODOS FRE. DISPLAY FREE MEMORY LEFT IF IN DEBUG MODE
600 IF FF = 1 THEN AVAIL = FRE(0)
605 IF FF = 2 THEN ? D$;"FRE"
610 FF = 0
615 IF DEBUG = 0 THEN RETURN
620 IF DEBUG > 0 THEN HTAB(62) : VTAB (24) : PRINT MI$;" free:";INT(AVAIL/1000);"k ";AVAIL;
625 IF (AVAIL > 9999) THEN PRINT " ";NI$; : GOTO 640
630 IF (AVAIL > 999) THEN PRINT "   ";NI$; : GOTO 640
635 PRINT "    ";NI$;
640 RETURN


674 REM ADD A CELL TO STACK
675 IF DEBUG > 3 THEN HTAB(36) : VTAB(1) : PRINT XX;"*";YY;
682 IF DEBUG > 3 THEN V1 = 2 : V2 = 42 : V3 = 6 : V4 = 20 : GOSUB 300 : PRINT : REM LIMIT SCROLL AREA
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
746 IF DEBUG > 3 THEN GOSUB 350 : REM RESTORE SCROLL AREA
748 RETURN


749 REM DEPTH-FIRST SEARCH ALGORITHM FOR GENERATING A RANDOMIZED INTERCONNECTED ROOM MAP
750 X = INT(RND(1) * SIZE) + 1: Y = SIZE : REM INITIAL ROOM PICK (LEVEL ENTRANCE)

765 REM MARK THE LEVEL ENTRANCE CELL AS VISITED
770 INS(X, Y) = 1 : VIS(X,Y) = 2 : MAP(X,Y) = 1
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

890 IF VIS(X, Y - 1) = 0 THEN NEIGHBRS = NEIGHBRS + 1: AVAILABLE(1) = 1
895 GOTO 880
900 IF VIS(X + 1, Y) = 0 THEN NEIGHBRS = NEIGHBRS + 1: AVAILABLE(2) = 1
905 GOTO 880
910 IF VIS(X, Y + 1) = 0 THEN NEIGHBRS = NEIGHBRS + 1: AVAILABLE(3) = 1
915 GOTO 880
920 IF VIS(X - 1, Y) = 0 THEN NEIGHBRS = NEIGHBRS + 1: AVAILABLE(4) = 1
925 GOTO 880

930 IF NEIGHBRS = 0 THEN GOTO 1200 : REMOVE THE CELL FROM STACK
940 I = 1
945 VTAB(24) : HTAB(1)
950 RU = RND(1)*4 : RR = RND(1)*6 : RD = RND(1)*7 : RL = RND(1)*6 : REM DEFINE PROBABILITIES
955 IF RU > RR AND RU > RD AND RU > RL THEN GOTO 1000
960 IF RR > RU AND RR > RD AND RR > RL THEN GOTO 1010
965 IF RD > RU AND RD > RR AND RD > RL THEN GOTO 1020
970 IF RL > RU AND RL > RR AND RL > RD THEN GOTO 1030
975 IF AVAILABLE(1) > 0 THEN GOTO 1000
980 IF AVAILABLE(2) > 0 THEN GOTO 1010
985 IF AVAILABLE(3) > 0 THEN GOTO 1020
990 IF AVAILABLE(4) > 0 THEN GOTO 1030
995 GOTO 950

1000 IF AVAILABLE(1) > 0 THEN Y = Y - 1 : GOTO 1050 : REM UP
1005 RU = 0 : GOTO 1040
1010 IF AVAILABLE(2) > 0 THEN X = X + 1 : GOTO 1090 : REM RIGHT
1015 RR = 0 : GOTO 1040
1020 IF AVAILABLE(3) > 0 THEN Y = Y + 1 : GOTO 1125 : REM DOWN
1025 RD = 0 : GOTO 1040
1030 IF AVAILABLE(4) > 0 THEN X = X - 1 : GOTO 1160 : REM LEFT
1035 RL = 0 : GOTO 1040

1040 I = I + 1
1045 GOTO 955

1050 AA$ = "U" : REM UP
1055 IF MAP(X,Y) = 0 THEN MAP(X,Y) = 1
1060 VIS(X,Y) = 1
1065 IF MAP(X,Y+1) < 2 THEN MAP(X,Y+1) = 2 : GOTO 1080
1070 IF MAP(X,Y+1) = 3 THEN MAP(X,Y+1) = 4
1075 REM TODO : CLOSED DOORS
1080 XX = X : YY = Y : GOSUB 675
1085 GOTO 1230

1090 AA$ = "R" : REM RIGHT
1095 IF MAP(X,Y) = 0 THEN MAP(X,Y) = 3 : GOTO 1105
1100 IF MAP(X,Y) = 2 THEN MAP(X,Y) = 4
1105 VIS(X,Y) = 1
1110 REM IF MAP(X-1,Y) = 0 THEN MAP(X-1,Y) = 1
1115 XX = X : YY = Y : GOSUB 675
1120 GOTO 1230

1125 AA$ = "D" : REM DOWN
1130 IF MAP(X,Y) = 0 THEN MAP(X,Y) = 2 : GOTO 1140
1135 IF MAP(X,Y) = 3 THEN MAP(X,Y) = 4
1140 VIS(X,Y) = 1
1145 REM IF MAP(X,Y-1) = 0 THEN MAP(X,Y-1) = 1
1150 XX = X : YY = Y : GOSUB 675
1155 GOTO 1230

1160 AA$ = "L" : REM LEFT
1165 IF MAP(X,Y) = 0 THEN MAP(X,Y) = 1
1170 VIS(X,Y) = 1
1175 IF MAP(X+1,Y) = 1 THEN MAP(X+1,Y) = 3 : GOTO 1185
1180 IF MAP(X+1,Y) = 2 THEN MAP(X+1,Y) = 4
1185 XX = X : YY = Y : GOSUB 675
1190 GOTO 1230

1198 REM IF NO UNVISITED NEIGHBOURS - BACKTRACK
1199 REM TODO: ADD MAP DESTINATION TARGET (STAIRS TO NEXT LEVEL)
1200 IF TYPE = 1 THEN GOTO 1220 : REM TYPE TO BE IMPLEMENTED
1205 SX(STACK) = 0 : SY(STACK) = 0 : STACK = STACK - 1 : INDEX = STACK
1210 IF DEBUG > 3 THEN V1 = 2 : V2 = 42 : V3 = 6 : V4 = 20 : GOSUB 300 : VTAB(20) : HTAB(2) : PRINT "Removed ";STACK;" at ";X;"x";Y; ", get ";SX(STACK);"x";SY(STACK) : GOSUB 350
1215 GOTO 1230

1220 SX(INDEX) = 0 : SY(INDEX) = 0 : STACK = STACK - 1
1225 IF DEBUG > 3 THEN V1 = 2 : V2 = 42 : V3 = 6 : V4 = 20 : GOSUB 300 : VTAB(20) : HTAB(2) : PRINT "Removed ";INDEX;" at ";X;"x";Y; ", get ";SX(INDEX);"x";SY(INDEX) : GOSUB 350

1230 IF FF > 1 AND FF < 18 THEN GOTO 1240
1235 GOTO 1260
1240 VTAB(23) : HTAB(OFFSET + 12 + FF) : IF FF / 2 = INT(FF / 2) THEN PRINT M$;L1$;N$; : GOTO 1260
1250 PRINT M$;L2$;N$;
1260 IF FF > 16 THEN VTAB(23) : HTAB(OFFSET + 12 + (FF-15)*2 - 2) : PRINT MI$;"  ";NI$;
1270 IF SX(STACK) > 0 THEN X = SX(STACK) : Y = SY(STACK) : GOTO 810
1280 VTAB(23) : HTAB(OFFSET + 22) : PRINT MI$;"         ";NI$;
1350 RETURN

1400 REM END FAST SUBROUTINES PORTION ^^


1499 REM CLEAR PROGRESS BAR IN THE BOTTOM
1500 IF RETRY > 0 THEN 1600
1505 HTAB(OFFSET) : VTAB(22) : PRINT "_";
1510 HTAB(OFFSET) : VTAB(23)
1520 IF XX = 0 THEN PRINT M$;"C";N$;" GameTitle ";
1525 IF XX = 1 THEN PRINT M$;"C";N$;" ";FILES$(J);" ";
1530 IF XX > 1 THEN PRINT M$;"C";N$;" Generate: ";
1540 IF XX = 0 OR XX = 1 THEN ? M$;"Z";N$;MI$;" ";NI$;M$;"W\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\";N$; : GOTO 1560 
1550 ? M$;"Z";N$;MI$;" ";NI$;M$;"\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\";N$;MI$;" ";NI$;M$;"_";N$;"  Please wait...";
1560 RETURN

1599 REM CLEAR PROGRESS BAR IN THE BOTTOM
1600 WW = 1 : GOSUB 200 : VTAB(22) : CALL -958
1660 HTAB(OFFSET) : VTAB(23) : PRINT M$;"C";N$;" Generate: ";
1740 HTAB(OFFSET + 13) : VTAB(22) : PRINT "___________________"; : HTAB(OFFSET + 13) : VTAB(24) : PRINT M$;"LLLLLLLLLLLLLLLLLLL";N$;
1760 HTAB(OFFSET + 12) : VTAB(23) : PRINT M$;"Z";N$;MI$;" ";NI$; : HTAB(OFFSET + 31) : VTAB(23) : PRINT MI$;" ";NI$;M$;"_";N$;" Re-Seeding..."
1790 RETURN






1995 REM VARIABLE DECLARATIONS
2000 DEBUG = PEEK(1023) : REM GET DEBUG SETTING SAVED BY STARTUP ($3FF)
2005 D$ = CHR$(4) : AVAIL = FRE(0)
2010 MI$ = CHR$(15) : REM TURN INVERSE ON
2015 NI$ = CHR$(14) : REM TURN INVERSE OFF
2020 M$ = MI$ + CHR$(27) : REM TURN SPECIAL CHARACTERS ON (80COL MOUSE TEXT CARD CHARS)
2025 N$ = CHR$(24) + NI$ : REM TURN SPECIAL CHARACTERS OFF
2030 KY = PEEK(49152) : REM VARIABLE TO KEEP LAST PRESSED KEY
2035 KK = KY : REM USED TO TRACK KEY PRESSES DURING LOAD TO SWITCH TO TEXT MODE UNTIMELY
2036 NL$ = CHR$(13) : REM NEW LINE
2037 CR$ = CHR$(10) : REM CARRIEGE RETURN

2038 UX = 0 : VX = 0 : UY = 0 : VY = 0 : REM SUPPORT VARS FOR BUFFERED TEXT PRINTING
2040 WW = 0 : REM SUPPORT VARIABLE FOR THE 80COL HTAB ROUTINE
2045 XX = 0 : YY = 0 : ZZ = 0 : REM VARIABLES TO BE USED IN SUBROUTINES (DURING STAGE GENERATION)
2050 FF = 0 : REM SET TO 1 TO PERFORM FRE(0), SET TO 2 TO PERFORM THE PRODOS FRE() COMMAND, THEN GOSUB 280
2060 DIM N1%(10) : REM RANDOM SEED ARRAY OF 10 SHUFFLED NUMBERS (TO VISUALLY DISTINGUISH THE SEED, NOTHING ELSE)

2070 DIM CLASSES$(3) : REM STARTING PLAYER CLASSES - CHECK GAME FOR FULL CLASS TREE
2080 CLASSES$(1) = "Fighter" : CLASSES$(2) = "Strider" : CLASSES$(3) = "Scholar"
2090 DIM ITEMS$(3, 2) : REM INITIAL ITEMS: 1:WEAPON, 2:SECONDARY ITEM, 3:ARMOR
2100 RETRY = 0 : REM RESEEDING COUNTER

2110 RW = 9 : RH = 4 : REM MAP ROOM SIZE (NUMBER OF SYMBOLS WIDTH AND HEIGHT)

2120 I = 1 : J = 1 : L1$ = M$+"WV"+N$ : L2$ = M$+"VW"+N$ : OFFSET = 20
2130 REM DIM LINES$(3, 4)
2150 DIM FILES$(3) : DIM FADDR$(3)
2160 DIM FILES(3, 5) : REM     0.START ADDRESS      1.START ADDRESS     2.DATA LENGTH      3.HTAB            4.VTAB            5.BUFFER
2170 FILES$(1) = "StartSeed" : FADDR$(1) = "0800" : FILES(1,1) = 8 : FILES(1,2) = 952 : FILES(1,3) = 1  : FILES(1,4) = 14 : FILES(1,5) = 1
2180 FILES$(2) = "BeginGame" : FADDR$(2) = "1000" : FILES(2,1) = 16 : FILES(2,2) = 1015 : FILES(2,3) = 48 : FILES(2,4) = 13 : FILES(2,5) = 4
2185 FILES$(3) = "Encounter" : FADDR$(3) = "0C00" : FILES(3,1) = 12 : FILES(3,2) = 874 : FILES(3,3) = 47 : FILES(3,4) = 13 : FILES(3,5) = 0

2500 IF DEBUG > 0 THEN GOSUB 600 : REM FRE()
2600 IF DEBUG > 0 THEN TEXT
2700 XX = 0 : REM GOSUB 1500 : REM CLEAR PROGRESS BAR
2750 K = 0

2800 POKE 49237,0 : CALL 872 : POKE 49236,0 : CALL 872 : REM CALL $0368 CLEAR DHGR SCREENS
2820 VTAB(23) : HTAB(OFFSET + 29 + J * 2) : PRINT M$;L2$;N$;
2840 FF$ = "SCREEN" : FF = 2 : GOSUB 26000 : REM LOAD TITLE PICTURE
2850 FF = 2 : GOSUB 600 : REM PRODOS FRE

2999 REM ITERATE TEXT FILES LOADING AND BUFFERING (J: CURRENT FILE)
3000 KY = PEEK(49152) : IF KY <> KK THEN TEXT : REM SWITCHING TEXT DURING LOAD ON KEYPRESS
3020 HTAB(71) : VTAB(17) : PRINT 1 + INT(J*1.5); : PRINT "0"; : REM PSEUDO LOADING PERCENTAGE DISPLAY
3030 FF = 1 : GOSUB 600 : REM FRE()

3060 PRINT D$;"BLOAD ";FILES$(J);",TTXT,A$";FADDR$(J)
3070 VTAB(23) : HTAB(OFFSET + 31 + J * 2) : PRINT M$;L2$;N$;
3080 POKE 49237,0 : POKE 1024 + 866 + J + K, 86 : REM DISPLAY BUFFERING PROGRESS
3090 POKE 49236,0 : POKE 1024 + 866 + J + K, 87

3140 HTAB(OFFSET) : VTAB(22)
3150 PRINT M$;"I";N$ : HTAB(OFFSET) : PRINT M$;"C";N$;" ";FILES$(J);

4250 J = J + 1 : IF J < 4 THEN GOTO 3000 : REM CONTINUE LOADING TEXT FILES



5000 TEXT : REM SWITCH TO TEXT MODE NOW
5540 VTAB(21) : HTAB(1) : ? : VTAB(21) : HTAB(1) : REM DRAW BOTTOM OVERLINE OF UI FRAME
5550 UX = 197 : VX = 19 : UY =  50 : VY =  0 : GOSUB 400 : REM THIS BORDER WAS HIDDEN DURING HGR DISPLAY

6035 KY = PEEK(49152) : REM GET LAST PRESSED KEY
6040 GOSUB 600 : REM FRE

6050 HTAB(70) : VTAB(17) : PRINT 100; : HTAB(76) : PRINT M$;"D";N$ : REM PSEUDO LOADING PERCENTAGE DISPLAY COMPLETE
6060 HTAB(52) : VTAB (22) : CALL -868 : REM CLEAR TEXT FROM CURSOR TO END OF LINE
6065 HTAB(22) : VTAB (23) : ? "Generate: ";M$;"Z";N$;MI$;" > Press Any Key < ";NI$;M$;"_";N$;"- Requirement";
6075 HTAB(52) : VTAB (24) : CALL -868 : GOSUB 600 : REM CLEAR AND FRE

6100 V1 = 2 : V2 = 42 : V3 = 2 : V4 = 19 : GOSUB 300 : REM LIMIT SCROLL AREA

6200 CALL 768 : REM CALL RANDOMIZE SEED ROUTINE
6210 KY = PEEK(49152) : REM GET LAST PRESSED KEY AND DISPLAY DEBUG CURSOR INFO
6220 IF DEBUG > 4 OR DEBUG = 3 OR KY <> 32 THEN RNG = RND(-1*(PEEK(78)+256*PEEK(79))) : REM RANDOMIZE SEED WHEN DEBUGGING

6320 HOME : REM FILES(2) PRINT SECOND SCREEN OF THE STORY
6360 UX = 255 : VX = 17 : UY = 140 : VY = 1 : GOSUB 400
6380 GOSUB 350 : REM RESET SCROLL AREA

6399 REM DISPLAY SEED NUMBERS AND GENERATE NEW LEVEL
6400 WW = FILES(1, 3) : GOSUB 200 : VTAB(FILES(1, 4))
6405 UX = 0 : VX = 8 : UY = 200 : VY = 2 : GOSUB 400 : REM FILES(1) DRAW RANDOM SEED WINDOW AND SECOND SCREEN OF STORY ENDING (WITHOUT BOTTOM BUTTONS)
6410 GOSUB 600 : REM DISPLAY FREE MEMORY
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
6720 REM END

6750 GOSUB 21200 : REM RANDOMIZE PLAYER STATS
6755 VTAB(4) : HTAB(52) : PRINT "                         " : VTAB(7) : HTAB(52) : PRINT "               "
6760 GOSUB 21000 : REM DISPLAY PLAYER STATS

6770 XX = 2 : GOSUB 1500 : REM CLEAR PROGRESS BAR

6775 REM GENERATE STAGE
6780 GOSUB 22000 : REM GENERATE MAP ROUTINE

6785 REM FILES(1) DRAW RANDOM SEED WINDOW AGAIN WITH THE BOTTOM MENU UI INCLUDED
6790 WW = FILES(1, 3) + 1 : GOSUB 200 : VTAB(FILES(1, 4) + 7)
6795 UX = 181 : VX = 10 : UY = 254 : VY = 0 : GOSUB 400
6798 POKE 2039, 64 : REM PRINT AN APPLE ICON AT BOTTOM RIGHT CORNER OF SCREEN (POKING TO PREVENT SCROLL)

6800 CALL 768 : REM WAIT FOR KEYPRESS
6810 KY = PEEK(49152) : REM TODO: GET JOYSTICK BUTTON DATA AS WELL
6812 REM K1 = PEEK(49249) : REM JOYSTICK BUTTON 1
6813 REM K2 = PEEK(49250) : REM JOYSTICK BUTTON 2
6814 REM K3 = PEEK(49251) : REM JOYSTICK BUTTON 3 ?
6815 REM ? K1, K2, K3 : GOTO 6810
6818 IF KY = 32 THEN RNG = RND(-1*(PEEK(78)+256*PEEK(79))) : REM RE-SEED THE RND FUNCTION
6820 IF KY = 32 THEN RETRY = RETRY + 1 : GOTO 6400
6825 REM IF KY = 82 THEN RETRY = RETRY + 1 : GOTO 6400 : REM DON'T RESEED BUT USE THE CURRENT SEED NEXT RANDOM NUMBER
6830 IF KY = 13 THEN GOTO 6850
6840 GOTO 6810

6849 REM INITIALIZE THE GAME WITH THE RANDOM SEED
6850 HTAB(1) : VTAB(21) : CALL -958 : REM CLEAR TEXT FROM CURSOR TO BOTTOM OF WINDOW
6860 KY = PEEK(49152) : REM GET LAST PRESSED KEY AND DISPLAY DEBUG CURSOR INFO
6880 GOSUB 600 : REM FRE



7000 MX = 0 : MY = 0 : REM MAP ROOMS COORDINATES

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

8000 rem VTAB(9) : HTAB(49) : PRINT M$;"LLLLLLLLLLLLLLLLLLLLLLL";N$;
8010 V1 = 47 : V2 = 33 : V3 = 9 : V4 = 24 : GOSUB 300 : REM LIMIT SCROLL AREA

8960 REM V1 = 47 : V2 = 33 : V3 = 14 : V4 = 24 : GOSUB 300 : REM LIMIT SCROLL AREA
8965 HOME
8970 UX = 0 : VX = 12 : UY = 44 : VY = 1 : VTAB(9) : GOSUB 400 : REM RENDER EQUIPMENT UI
8972 GOSUB 21050 : REM PRINT EQUIPMENT 
8975 UX = 0 : VX = 16 : UY = 228 : VY = 1 : VTAB(14) : GOSUB 400 : REM RENDER GAME WELCOME SCREEN
8980 POKE 2039, 76 : REM PRINT AN UPPER BORDER TO FINALIZE UI AT BOTTOM RIGHT CORNER OF SCREEN (POKING TO PREVENT SCROLL)
8990 GOSUB 350 : REM RESET SCROLL AREA
9000 UX = 178 : VX = 11 : UY = 65 : VY = 0 : VTAB(20) : GOSUB 400 : REM RENDER LOADING FOOTER
9010 REM VTAB(22) : HTAB(1) : PRINT
9020 V1 = 0 : V2 = 45 : V3 = 0 : V4 = 21 : GOSUB 300
9030 HOME : GOSUB 350 : REM CLEAR GAME SCREEN

9130 PRINT D$;"BLOAD LEGEND,TTXT,A$0800"
9140 V1 = 0 : V2 = 45 : V3 = 0 : V4 = 24 : GOSUB 300
9150 UX = 0 : VX = 8 : UY = 112 : VY = 3 : GOSUB 400
9180 GOSUB 350 : REM RESET SCROLL AREA
9190 REM VTAB(22) : HTAB(13)

9200 CALL 7936 : REM CALL 1F00 AND STORE TEXT SCREEN AT 1000-13FF (COPIED FROM MAIN MEMORY) AND 1400-17FF (COPIED FROM AUX)


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

10130 REM DIM MAP, VIS, INS
10140 REM DIM SS(5) : SS(1) = 871 : SS(2) = 897 : SS(3) = 923 : SS(4) = 949 : SS(5) = 975
10150 REM DIM SA(5) : SA(1) = 896 : SA(2) = 922 : SA(3) = 948 : SA(4) = 974 : SA(5) = 1000
10160 GOSUB 13000 : REM STORE ARRAY DATA



11995 REM POKE 104,96 : POKE 24576,0 : REM LOAD THE GAME AT $6000 IF HGR2 IS NEEDED
11996 REM POKE 104,64 : POKE 16384,0 : REM LOAD THE GAME AT $4000
11997 REM POKE 104,32 : POKE 8192,0 : REM LOAD THE GAME AT $2000 ONWARDS THROUGH THE GRAPHIC PAGES UP TO DOS AREA 95FF
11998 REM POKE 104,16 : POKE 4096,0 : REM LOAD THE GAME AT $1000 ONWARDS THROUGH THE GRAPHIC PAGES UP TO DOS AREA 95FF
11999 REM POKE 103,0 : POKE 104,8 : POKE 2048,0 : REM LOAD FROM DEFAULT $800 (WRITE TO {$67}{$68} THE BEGINNING OF THE BASIC FILE)
12000 POKE 104,32 : POKE 8192,0 : REM LOAD AT $2000

12500 PRINT D$;"RUN GAME" : END


12999 REM SUBROUTINE TO STORE ARRAYS
13000 FOR I = SIZE TO 1 STEP -1
13020   FOR J = SIZE TO 1 STEP -1
13022     K = ((I - 1) * SIZE + J - 1)
13025     POKE 948 - K, MAP(I, J)
13040     POKE 974 - K, VIS(I, J)
13060     POKE 1000 - K, INS(I, J)
13250   NEXT J
13260 NEXT I
13270 RETURN


20999 REM DISPLAY PLAYER STATS
21000 VTAB(1) : HTAB(61) : PRINT MI$;CLASSES$(CLASS);NI$
21010 VTAB(3) : HTAB(51) : PRINT "HP: ";HP;"/";HP;"   Str: ";SR;"   Att: ";AK;" "
21020 VTAB(5) : HTAB(51) : PRINT "MP: ";MP;"/";MP;"     Dex: ";DX;"   AC: +";AC;" "
21025 VTAB(7) : HTAB(63) : PRINT "Int: ";IT;"   Wis: ";WI;" "; : HTAB(51)
21030 IF CLASS = 1 THEN PRINT "Block: ";AM;" "
21035 IF CLASS = 2 THEN PRINT "Arrows: ";AM;" "
21040 IF CLASS = 3 THEN PRINT "Spells: ";AM;" "
21045 RETURN

21060 REM VTAB(7) : HTAB(57) : PRINT GOLD;"   "
21066 REM VTAB(7) : HTAB(68) : PRINT EX;"/100    "
21050 VTAB(12) : HTAB(3) : PRINT ITEMS$(1,1);M$;"_";N$; : VTAB(13) : HTAB(3) : PRINT ITEMS$(1,2);M$;"_";N$;
21060 VTAB(12) : HTAB(13) : PRINT ITEMS$(2,1);M$;"_";N$; : VTAB(13) : HTAB(13) : PRINT ITEMS$(2,2);M$;"_";N$;
21070 VTAB(12) : HTAB(23) : PRINT ITEMS$(3,1); : VTAB(13) : HTAB(22) : PRINT ITEMS$(3,2);
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
22000 IF DEBUG > 4 OR DEBUG = 3 THEN VTAB(19) : HTAB(50) : PRINT "Hit Any Key..." : CALL 768 : RNG = RND(-1*(PEEK(78)+256*PEEK(79)))
22005 IF SIZE = 5 THEN GOTO 22050 : REM REGENERATING
22008 DIM AVAILABLE(4)
22010 SIZE = 5 : REM INITIALIZE MAZE DIMENSIONS
22015 DIM MAP(SIZE,SIZE) : REM GENERATE MAP CONNECTIONS ARRAY
22020 DIM VIS(SIZE,SIZE) : REM GENERATE MAP VISITED ROOMS ARRAY
22022 DIM INS(SIZE,SIZE) : REM GENERATE MAP CONTENTS ARRAY TODO: TO BE IMPLEMENTED
22025 DIM SX(SIZE*SIZE)
22030 DIM SY(SIZE*SIZE)

22049 REM RESET WHEN RE-SEEDING : VIS(INT(PEEK(1022)/RW),INT(PEEK(1021)/RH)) = 0
22050 FOR Y = 1 TO SIZE
22055   FOR X = 1 TO SIZE
22060     VIS(X, Y) = 0
22070     MAP(X, Y) = 0
22090   NEXT X
22100 NEXT Y
22110 TYPE = 0 : REM 0: LEAD CELL GENERATION (ZIG-ZAG LONGER); 1: RANDOM CELL (MORE CHAOTIC) : TODO: TO BE IMPLEMENTED
22120 AVAILABLE(1) = 0 : AVAILABLE(2) = 0 : AVAILABLE(3) = 0 : AVAILABLE(4) = 0 : REM 4 DIRECTIONS
22140 STACK = 0 : INDEX = 0

22150 IF DEBUG = 1 THEN DEBUG = 3 : GOSUB 30500 : DEBUG = 1 : REM DEBUG DISPLAY THE STAGE INITIALLY
22160 IF DEBUG = 2 THEN DEBUG = 3 : GOSUB 30500 : DEBUG = 2
22170 FF = 0 : GOSUB 750 : REM GENERATE STAGE
22180 IF DEBUG = 1 THEN DEBUG = 3 : GOSUB 30500 : DEBUG = 1 : REM DEBUG DISPLAY AFTER THE STAGE GENERATION
22190 IF DEBUG = 2 THEN DEBUG = 3 : GOSUB 30500 : DEBUG = 2

22199 REM RESET VISIBILITY (VIS WAS USED DURING GENERATION LOOP, BUT NOW WE NEED IT FOR THE GAME)
22200 FOR Y = 1 TO SIZE
22250   FOR X = 1 TO SIZE
22280     IF VIS(X, Y) = 1 THEN VIS(X, Y) = 0
22300     IF MAP(X, Y) > 1 THEN MAP(X, Y) = MAP(X, Y) + 3
22310     IF VIS(X, Y) = 2 THEN X1 = X : Y1 = Y : REM MAP(X, Y) = MAP(X, Y) - 3 : REM MARK THE ENTRANCE
22765   NEXT X
22770 NEXT Y

22890 IF DEBUG > 3 THEN V1 = 2 : V2 = 42 : V3 = 2 : V4 = 20 : GOSUB 300 : VTAB(20) : HTAB(2) : PRINT "Generation complete!" : GOSUB 350
22898 RETURN : REM FINAL RETURN TO CALLER




25999 REM LOAD DOUBLE HI-RES PICTURE, FF=0 LOAD HIRES IMAGE; FF=1 LOAD DOUBLE HIRES IMAGES; FF=2 DISPLAY LOADING AS WELL
26000 IF FF > 0 THEN POKE 49237,0
26005 PRINT D$;"BLOAD ";FF$;", A$2000, L$2000"
26010 IF FF > 1 THEN POKE 1898, 86 : REM DISPLAY BUFFERING PROGRESS, WRITE CHARACTERS DIRECTLY IN MAIN/AUX MEMORY
26020 POKE 49236,0
26030 IF FF > 1 THEN POKE 1898, 87
26040 IF FF > 0 THEN PRINT D$;"BLOAD ";FF$;", A$2000, L$2000, B$2000"
26050 IF FF > 1 THEN POKE 49237,0 : POKE 1899, 86 : POKE 49236,0
26060 RETURN

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
30600       IF X = XX AND Y = YY THEN PRINT MI$;VIS(XX, YY);NI$; : NORMAL : GOTO 30610
30605       PRINT VIS(XX, YY);M$;"N";N$;MI$;" ";NI$;
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
60005 IF ER = 0 OR ER > 15 THEN PRINT : PRINT : CALL 16390
60020 IF ER <> 2 AND ER <> 3 AND ER <> 8 AND ER <> 11 THEN PRINT " ERROR!";
60030 PRINT CHR$(7);" in line ";PEEK(218) + PEEK(219) * 256
60050 ? : REM TRACE VARIABLES
60060 REM PRINT AA$;" ";STACK;" ";XX;"*";YY;" ";X;"*";Y;" U:";INT(RU*10)/10;" R:";INT(RR*10)/10;" D:";INT(RD*10)/10;" L:";INT(RL*10)/10
60090 END

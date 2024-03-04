10 REM RL ENGINE FOR APPLE II BY FOUMARTGAMES
20 REM ======================================
30 REM READCHAR ROUTINE SRC:
40 REM https://www.1000bit.it/support/manuali/apple/technotes/misc/tn.misc.10.html
50 REM ==============
60 REM LOMEM: 24576
70 REM HIMEM: 8192
80 REM 38399 : 24576 : 16384 : 8192
90 REM ONERR GOTO 30000
100 GOTO 1000

200 REM REM MAKE SURE WE HAVE THE CORRECT HORIZONTAL POSITION
210 REM PEEK(36) AND POS(0) ARE NOT WORKING IN 80 COL,
220 REM SO BELOW WE ACCESS DIFFERENT ADDRESSES TO BE SURE
230 REM REM POKE 1531,Y : POKE 37,Y (Y IS OKAY)
240 POKE 1147,XX-1 : POKE 1403,XX-1 : POKE 36,XX-1
260 RETURN

300 REM MAP CHARACTER READ ROUTINE
310 XX = X : GOSUB 200
320 VTAB(Y) : REM SET POSITION
350 CALL 784: REM CALL THE GETCHAR ROUTINE LOADED AT $0310
355 A = PEEK(6)
360 IF A > 127 THEN A$ = N$ + CHR$(A)
365 IF A < 128 THEN A$ = M$ + CHR$(A) + N$
370 REM GOSUB 24000 : REM GET LAST PRESSED KEY AND DISPLAY DEBUG CURSOR INFO
375 GOSUB 31000 : REM DISPLAY FREE MEMORY
380 REM TODO AT CHECK BYTES:
385 REM 0 (NOT MOVED YET) : -5 (MOVING IN) : -7 (MOVING IN MOUSE TETXT)
390 K = 0
395 RETURN

1000 DEBUG = PEEK(1023) : REM GET DEBUG SETTING SAVED BY STARTUP
1300 D$ = CHR$(4) : AVAIL = FRE(0) : REM ~26886
1400 MI$ = CHR$(15) : REM TURN INVERSE ON
1500 NI$ = CHR$(14) : REM TURN INVERSE OFF
1600 M$ = MI$ + CHR$(27) : REM TURN SPECIAL CHARACTERS ON (80COL MOUSE TEXT CARD CHARS)
1700 N$ = CHR$(24) + NI$ : REM TURN SPECIAL CHARACTERS OFF
1800 KY = PEEK(49152) : REM VARIABLE TO KEEP LAST PRESSED KEY
1810 XX = 1 : REM VARIABLE TO BE USED FOR ALTERNATIVE HTAB
1820 FF = 0 : REM SET TO 1 TO PERFORM FRE(0), SET TO 2 TO PERFORM THE PRODOS FRE() COMMAND
1830 MOVING = 0 : MDIR = 0
1900 ST$ = "" : REM GENERIC STRING, USED WHEN CENTERING TEXT
1950 DIM N1%(10) : DIM N2%(15) : REM SEEDS
 
2000 W = 5 : REM NUMBER OF TEXT FILES TO LOAD
2020 Z = 11 : REM THE NUMBER OF TEXT LINES EACH FILE HAS
2030 I = 1 : J = 1 : L1$ = M$+"WV"+N$ : L2$ = M$+"VW"+N$ : OFFSET = 20
2050 DIM FILES$(W)
2052 FILES$(1) = "Encounter"
2054 FILES$(2) = "BattleWin"
2056 FILES$(3) = "StartSeed"
2058 FILES$(4) = "BeginGame"
2060 FILES$(5) = "MoreStory"
2062 REM FILES$(6) = "EndScreen"


2070 DIM COODS(W, 3) : REM WILL HOLD ALL UI PARAMETTERS: L, H, V
2080 DIM LINES$(W, Z) : REM WILL HOLD ALL UI DISPLAYS

2100 IF DEBUG = 1 THEN PRINT D$"BLOAD READCHAR"

2200 I = 1 : REM CLEAR PROGRESS BAR FOR NEW READING/BUFFERING DISPLAY
2210 HTAB(71) : VTAB(17) : PRINT 1 + INT(J*1.5); : PRINT "0"; : REM PSEUDO LOADING PERCENTAGE DISPLAY
2220 FF = 1 : GOSUB 31000
2250 HTAB(OFFSET) : VTAB(22) : PRINT "_";
2300 HTAB(OFFSET) : VTAB(23) : PRINT M$;"C";N$;" ";FILES$(J);
2350 HTAB(OFFSET + 14)
2400 FOR P = 1 TO Z * 2 + 3
2420 PRINT M$;"\\";N$;
2440 NEXT P

2700 REM TODO: CONVERT TEXT READ WITH DATA READ
2750 IF DEBUG = 0 THEN TEXT
2800 HTAB(72) : VTAB(17) : PRINT 1 : REM PSEUDO LOADING PERCENTAGE DISPLAY
2850 VTAB(23) : HTAB(62) : PRINT D$;"OPEN ";FILES$(J)
2900 HTAB(62) : PRINT D$;"READ ";FILES$(J)
3000 HTAB(62) : INPUT L : IF DEBUG > 0 THEN L = 0 : Z = 0 : REM GET THE TOTAL LINES OF THE TEXT FILE (FIRST PARAMETER FROM TEXT FILE)
3050 COODS(J, 1) = L : HTAB(72) : VTAB(17) : PRINT 2 : REM PSEUDO LOADING PERCENTAGE DISPLAY
3100 VTAB(23) : HTAB(OFFSET + 14) : PRINT M$;L2$;N$;
3125 HTAB(62) : INPUT H : REM GET LEFT OFFSET WHEN INSERTING THE TEXT (SECOND PARAMETER FROM TEXT FILE)
3150 COODS(J, 2) = H : HTAB(72) : VTAB(17) : PRINT 3 : REM PSEUDO LOADING PERCENTAGE DISPLAY
3175 VTAB(23) : HTAB(OFFSET + 15) : PRINT M$;L1$;N$;
3200 HTAB(62) : INPUT V : REM GET TOP OFFSET WHEN INSERTING THE TEXT (THIRD PARAMETER FROM TEXT FILE)
3250 COODS(J, 3) = V : HTAB(72) : VTAB(17) : PRINT 4 : REM PSEUDO LOADING PERCENTAGE DISPLAY

3300 VTAB(23) : HTAB(OFFSET + 15 + I * 2) : PRINT M$;L1$;N$;
3350 HTAB(62) : INPUT A$ : REM GET THE NEXT DATA ROW
3400 LINES$(J, I) = A$ : I = I + 1 : REM SAVE IT AS NEW LINE
3500 IF I > COODS(J, 1) THEN GOTO 3700
3600 GOTO 3300 : REM READING LINES LOOP
3700 HTAB(62) : PRINT D$;"CLOSE"

3720 FF = 2 : GOSUB 31000

3750 REM CONVERTING THE DATA
3800 REM UPDATING THE DATA IN PLACE
3850 HTAB(72) : VTAB(17) : PRINT 5; : REM PSEUDO LOADING PERCENTAGE DISPLAY
3900 HTAB(OFFSET) : VTAB(22)
3950 PRINT M$;"I";N$ : HTAB(OFFSET) : PRINT M$;"C";N$;" ";FILES$(J);
4400 HTAB(OFFSET + 14)
4500 PRINT M$;" ";N$;

4600 FOR I = 1 TO COODS(J, 1)
4700   NE$ = ""
4800   A$ = LINES$(J, I) : M = LEN(A$) : D = 1
4900   FOR XI = 1 TO M
5000     B$ = MID$(A$, XI, 1)
5100     C = ASC(B$)
5150     IF XI = 20 THEN PRINT M$;" ";N$; : REM PROGRESS DISPLAY
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
5960 J = J + 1 : IF J < W + 1 THEN GOTO 2200

6000 IF DEBUG = 1 THEN TEXT
6030 REM HTAB(OFFSET) : VTAB(22) : CALL -958 : REM CLEAR TEXT FROM CURSOR TO BOTTOM OF WINDOW
6035 GOSUB 24000 : REM GET LAST PRESSED KEY AND DISPLAY DEBUG CURSOR INFO
6040 GOSUB 31000 : REM DISPLAY FREE MEMORY

6050 HTAB(70) : VTAB(17) : PRINT 100; : HTAB(76) : PRINT M$;"D";N$ : REM PSEUDO LOADING PERCENTAGE DISPLAY COMPLETE
6055 HTAB(50) : VTAB(19) : PRINT "Ready or not, here we go!";
6060 HTAB(52) : VTAB (22) : CALL -868 : REM CLEAR TEXT FROM CURSOR TO END OF LINE
6065 HTAB(22) : VTAB (23) : ? "Randomize:";M$;"Z";N$;MI$;" > Press Any Key < ";NI$;M$;"_";N$;"- Requirement";
6075 HTAB(52) : VTAB (24) : CALL -868
6080 POKE 2039, 64 : REM PRINT AN APPLE ICON AT BOTTOM RIGHT CORNER OF SCREEN (PREVENT SCROLL)

6300 GOSUB 23000

6310 CALL 768 : RNG = RND(-1*(PEEK(78)+256*PEEK(79)))
6320 VTAB(19) : PRINT CHR$(23)

6355 FOR I = 1 TO 11
6360 PRINT LINES$(5, I) : REM PRINT THE LINES DIRECTLY
6370 NEXT I
6375 PRINT CHR$(23);CHR$(23);CHR$(23);CHR$(23);CHR$(23); : REM SCROLL TEXT STORY UP
6380 GOSUB 23100

6400 W = 3 : GOSUB 25000 : REM DRAW BEGIN JOURNEY WINDOW WITH RANDOM SEED PLACEHOLDER
6410 GOSUB 31000 : REM DISPLAY FREE MEMORY
6420 HTAB(67) : VTAB (18) : PRINT MI$;PEEK(78);NI$ : HTAB(74) : VTAB (18) : ? MI$;PEEK(79);NI$

6540 FOR I = 1 TO 10 : N1%(I) = I - 1 : NEXT I
6550 FOR I = 1 TO 15 : N2%(I) = I - 1 : NEXT I
6570 REM SHUFFLE THE ARRAY USING RANDOM SWAPS
6580 FOR I = 1 TO 10
6600   N = INT(RND(1) * 10) + 1
6620   T = N1%(I) : REM SWAP THE ELEMENT AT THE CURRENT INDEX WITH THE ELEMENT AT THE RANDOM INDEX
6630   N1%(I) = N1%(N)
6640   N1%(N) = T
6650 NEXT I
6660 VTAB(20) : HTAB(59) : REM PRINT THE SEED
6670 FOR I = 1 TO 10
6680  PRINT N1%(I);
6690 NEXT I

6700 FOR I = 1 TO 15
6710   R = INT(RND(1) * 32) + 1
6715   FOR J = 1 TO I - 1
6720     IF R = N2%(J) THEN GOTO 6710
6725   NEXT J
6730   N2%(I) = R
6735 NEXT I
6738 REM REM PRINT THE ARRAY ELEMENTS
6740 REM FOR I = 1 TO 15
6742   REM IF I > 1 THEN PRINT MI$;
6745   REM PRINT CHR$(63 + N2%(I));
6748   REM IF I > 1 THEN PRINT NI$;
6750 REM NEXT I
6760 PRINT CHR$(63 + N2%(1));

6800 CALL 768 : RNG = RND(-1*(PEEK(78)+256*PEEK(79))) : REM RESEED THE RND FUNCTION
6850 GOSUB 24000 : REM GET LAST PRESSED KEY AND DISPLAY DEBUG CURSOR INFO
6870 IF KY = 32 THEN GOTO 6400
6880 IF KY = 13 THEN GOTO 6900
6890 GOTO 6850

6900 REM INITIALIZE THE GAME WITH THE RANDOM SEED
6910 HTAB(1) : VTAB(21) : CALL -958 : REM CLEAR TEXT FROM CURSOR TO BOTTOM OF WINDOW
6920 GOSUB 24000 : REM GET LAST PRESSED KEY AND DISPLAY DEBUG CURSOR INFO
6950 REM W = 1 : GOSUB 25000 : REM DRAW PLACEHOLDER
6955 GOSUB 31000 : REM DISPLAY FREE MEMORY

6960 REM POKE 49168,0 : REM CLEAR KEYBOARD
6970 REM IF PEEK (49152) = 0 THEN GOTO 6970
6980 REM IF PEEK (49152) = 141 THEN GOTO 7000
6990 REM GOTO 6970 : REM WAIT UNTIL ENTER IS PRESSED

7000 REM FIX MOUSE TEXT AND INVERSE ISSUES
7010 MX = 0 : MY = 0 : REM MAP ROOMS COORDINATES
7020 RW = 9 : RH = 4 : REM ROOM SIZE
7030 X = 23 : Y = 19 : REM INITIAL PLAYER POSITION
7040 A = 160 : REM HOLDS THE MAP TILE PLAYER IS CURRENTLY ON READ BY THE READCHAR ROUTINE.
7050 DIM PLAYER(3) : REM HOLDS X, Y, AND THE MAP CHARACTER THAT'S BEHIND THE UNIT
7060 PLAYER(1) = X : PLAYER(2) = Y : PLAYER(3) = A
7070 A$ = CHR$(160) : REM THE CHARACTER CODE READ BY THE ROUTINE BUT AS STRING

7200 REM 
7210 DIM ROOMS$(4)
7220 ROOMS$(1) = "  "
7230 ROOMS$(2) = " "+M$+CHR$(93)+N$
7240 ROOMS$(3) = M$+CHR$(90)+CHR$(94)+N$
7250 ROOMS$(4) = " "+M$+CHR$(91)+N$

7260 REM GENERATE MAP CONNECTIONS ARRAY
7270 DIM MAP(5, 5)
7280 DATA 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
7290 FOR I = 0 TO 4
7300   FOR J = 0 TO 4
7310     READ MAP(I,J)
7320   NEXT J
7330 NEXT I

7340 REM GENERATE MAP CONTENTS ARRAY
7350 DIM INSIDES(5, 5)
7360 DATA 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
7370 FOR I = 0 TO 4
7380   FOR J = 0 TO 4
7390     READ INSIDES(I,J)
7400   NEXT J
7410 NEXT I

7420 REM GENERATE MAP VISITED ROOMS ARRAY
7430 DIM VISIBLES(5, 5)
7440 REM DATA 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
7450 DATA 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
7460 FOR I = 0 TO 4
7470   FOR J = 0 TO 4
7480     READ VISIBLES(I,J)
7490   NEXT J
7500 NEXT I

7600 I = INT(RND(1) * 3 + 1)
7610 VISIBLES(0, I) = 1
7620 REM ...

9950 REM RENDERING GAME MAP AND SCREENS
9960 GOSUB 20000 : REM RENDER GAME MAP
9970 W = 4 : GOSUB 25000 : REM RENDER GAME WELCOME SCREEN
9980 GOSUB 300 : REM GET CHAR ROUTINE


9990 K = 0 : REM VTAB(1) : END : BREAK JUST BEFORE MAIN GAME LOOP


10000 REM MAIN LOOP
10010 REM FOR II=1 TO 200: NEXT II : REM WAIT 49200,3
10020 REM IF PLAYER(1) = X AND PLAYER(2) = Y THEN GOTO 550 : REM SKIP IF PLAYER HAS NOT MOVED
10030 PLAYER(1) = X : PLAYER(2) = Y : PLAYER(3) = A
10050 HTAB(X) : VTAB(Y) : ? "@" : REM DRAW PLAYER
10060 IF MOVING > 0 AND MDIR > 0 THEN HTAB(X) : VTAB(Y) : PRINT A$ : GOTO 12500
10080 IF MOVING > 0 AND MDIR < 0 THEN HTAB(X) : VTAB(Y) : PRINT A$ : GOTO 13000

10700 REM IF MOVING > 0 THEN PRINT A$ : GOTO 12500
10750 KY = PEEK(49152) : REM GOSUB 24000 : REM GET LAST PRESSED KEY AND DISPLAY DEBUG CURSOR INFO
10800 REM IF MOVING > 0 THEN END : TODO : IMPLEMENT HORIZONTAL MOVING
11200 IF KY = 0 THEN GOTO 10000
11210 IF KY = K THEN 10000
11220 K = KY : POKE 49168,0 : REM CLEAR THE KEYBOARD STROBE - ALWAYS AFTER READING KEYBOARD

11400 REM DISPLAY THE MAP CHAR AT THE PLAYER'S PREVIOUS POSITION AND PERFORM MOVE
11500 HTAB(X) : VTAB(Y)
11700 PRINT A$
11720 REM AA$ = A$ : REM TODO : FIX BLINKING
11750 IF K = 100 THEN GOTO 12300
11800 IF K = 149 OR K = 225 OR K = 196 THEN MOVING = 3 : MDIR = 1 : GOTO 12500 : REM RIGHT
11900 IF K = 136 OR K = 234 OR K = 202 THEN MOVING = 3 : MDIR = -1 : GOTO 13000 : REM LEFT
12000 IF K = 139 OR K = 247 OR K = 215 THEN GOTO 13500 : REM UP
12100 IF K = 138 OR K = 243 OR K = 211 THEN GOTO 14000 : REM DOWN
12200 IF K = 160 THEN GOTO 14500

12250 GOTO 10000

12299 REM TRIGGER DEBUG WITH "D" KEY
12300 IF DEBUG > 0 THEN DEBUG = 0 : HTAB(1) : VTAB(24) : CALL -958 : GOTO 10000
12310 IF DEBUG = 0 THEN DEBUG = 1 : GOSUB 24000 : GOTO 10000

12400 REM LIMIT MOVEMENT
12500 IF A = 160 OR A = 93 OR A = 95 OR A = 90 OR A = 92 THEN X = X + 1 : MOVING = MOVING -1 : GOSUB 300
12550 REM TODO: FIX BLINKING
12600 IF A = 94 THEN VTAB(Y) : HTAB(X+1) : ? M$;"\\\\";N$; : MX = 1 : MY = 4 : GOSUB 16000 : REM TODO: FIX HARDCODED STUFF
12700 IF A <> 160 AND A <> 93 AND A <> 90 AND (A <> 92 OR A = 92 AND Y<>19 AND Y<>15 AND Y<>11 AND Y<>7 AND Y<>3) THEN X = X - 1 : MOVING = 0 : GOSUB 300
12800 GOTO 10000

13000 IF A = 160 OR A = 93 OR A = 95 OR A = 90 OR A = 92 THEN X = X - 1 : MOVING = MOVING -1 : GOSUB 300
13050 REM TODO: FIX HARDCODED STUFF AROUND DOORS OPENING AND ROOM REVEALING
13100 IF A = 94 THEN ROW = 4 : COL = 1 : VISIBLES(4,1) = 2 : VTAB(Y) : HTAB(X-1) : MX = X-10 : MY = Y-3 : GOSUB 16000 : VTAB(Y) : HTAB(X-2) : ? " ";M$;"\\\\";N$;" ";
13200 IF A <> 160 AND A <> 93 AND A <> 95 AND (A <> 92 OR A = 92 AND Y<>19 AND Y<>15 AND Y<>11 AND Y<>7 AND Y<>3) THEN X = X + 1 : MOVING = 0 : GOSUB 300
13300 GOTO 10000

13500 IF A = 92 THEN GOTO 10000
13550 IF A = 160 OR A = 93 OR A = 95 OR A = 90 THEN Y = Y - 1 : GOSUB 300
13600 IF A = 94 THEN ROW = 2 : COL = 2 : VISIBLES(2,2) = 2 : VTAB(Y-1) : HTAB(X) : MX = X-5 : MY = Y-5 : GOSUB 16000 : VTAB(Y) : HTAB(X-1) : ? M$;"_";N$;" ";M$;"Z";N$;
13700 REM IF A = 94 THEN VTAB(Y) : HTAB(X-1) : ? M$;"Z";N$;" ";M$;"_"; : MX = 1 : MY = 4 : GOSUB 1000 : REM TODO: FIX HARDCODED STUFF
13800 IF A <> 160 AND A <> 93 AND A <> 95 AND A <> 90 OR (A = 92 AND Y<>19 AND Y<>15 AND Y<>11 AND Y<>7 AND Y<>3) THEN Y = Y + 1 : GOSUB 300
13900 GOTO 10000

14000 IF A = 92 THEN GOTO 10000
14100 IF A = 160 OR A = 93 OR A = 95 OR A = 90 THEN Y = Y + 1 : GOSUB 300
14200 IF A <> 160 AND A <> 93 AND A <> 95 AND A <> 90 OR (A = 92 AND Y<>19 AND Y<>15 AND Y<>11 AND Y<>7 AND Y<>3) THEN Y = Y - 1 : GOSUB 300
14300 GOTO 10000

14500 GOSUB 320
14600 GOTO 10000

15900 ? NI$;N$;"Exit" : END

16000 REM DRAW A ROOM
16010 XX = MX+1 : GOSUB 200
16200 VTAB(MY+1)

16300 IF MY < 4 THEN GOTO 16600
16400 ? " ";M$;"\\\\\\\\\\\\\\";N$;" "; : REM DRAW IN BETWEEN ROOM VERTICAL SPACE
16500 GOTO 16800
16600 ? " _______ "; : REM DRAW TOP EDGE BORDER OF THE FIRST ROW ROOMS

16700 REM DRAW EMPTY ROOM
16800 M = MAP(ROW, COL): V = VISIBLES(ROW, COL)
16900 IF V > 0 THEN XX = MX+1 : GOSUB 200 : VTAB(MY+2) : ? M$;"Z_";N$;"     ";M$;"Z_";N$
17000 IF V > 0 OR M <> 0 THEN HTAB(MX+1) : VTAB(MY+3) : ? M$;"Z_";N$;" ";ROOMS$(INSIDES(ROW, COL)+1);"  ";M$;"Z_";N$
17100 IF V > 0 THEN HTAB(MX+1) : VTAB(MY+4) : ? M$;"Z_";N$;"     ";M$;"Z_";N$

17200 REM GREYED OUT ROOMS
17300 IF V = 0 THEN XX = MX+1 : GOSUB 200 : VTAB(MY+2) : ? M$;"ZVWVWVWV_";N$
17400 IF V = 0 THEN HTAB(MX+1) : VTAB(MY+3) : ? M$;"ZVWVWVWV_";N$
17500 IF V = 0 THEN HTAB(MX+1) : VTAB(MY+4) : ? M$;"ZVWVWVWV_";N$

17600 REM TODO: EXPERIMENT WITH PARTIAL ROOM REVEAL (WHEN THERE ARE ENEMIES FOR EXAMPLE)
17700 REM IF V = 2 THEN HTAB(MX+1) : VTAB(MY+2) : ? M$;"ZWVWVW";N$;"  ";M$;"_";N$
17800 REM IF V = 2 THEN HTAB(MX+1) : VTAB(MY+3) : ? M$;"ZWVWV";N$;"   ";M$;"_";N$
17900 REM IF V = 2 THEN HTAB(MX+1) : VTAB(MY+4) : ? M$;"ZWVWVW";N$;"  ";M$;"_";N$

18000 REM DRAW DOORS
18100 IF V = 0 GOTO 19600

18200 REM HORIZONTAL OPEN DOORS
18300 IF M <> 3 AND M <> 4 AND M <> 8 THEN GOTO 18800
18400 IF VISIBLES(ROW, COL-1) = 1 THEN HTAB(MX-1) : VTAB(MY+3) : ? " "
18500 HTAB(MX+2) : VTAB(MY+3) : ? " "
18600 HTAB(MX) : VTAB(MY+3) : ? M$;"\\\\";N$

18700 REM HORIZONTAL CLOSED DOORS
18800 IF M <> 6 AND M <> 7 AND M <> 9 THEN GOTO 19300
18900 IF VISIBLES(ROW, COL-1) = 1 THEN HTAB(MX-1) : VTAB(MY+3) : ? M$;"Z";N$
19000 IF VISIBLES(ROW, COL+1) = 1 THEN HTAB(MX+2) : VTAB(MY+3) : ? M$;"_";N$
19100 HTAB(MX) : VTAB(MY+3) : ? M$;" ^";N$

19200 REM VERTICAL OPEN DOOR
19300 IF M = 2 OR M = 4 OR M = 9 THEN HTAB(MX+4) : VTAB(MY+1) : ? M$;CHR$(95);N$" ";M$;CHR$(90);N$

19400 REM VERTICAL CLOSED DOOR
19500 IF M = 5 OR M = 7 OR M = 8 THEN HTAB(MX+4) : VTAB(MY+1) : ? M$;" ^ ";N$

19600 REM
19700 IF MY < 15 THEN RETURN
19800 HTAB(MX+1) : VTAB(MY+5) : ? " ";M$;"LLLLLLL";N$;" " : REM DRAW BOTTOM EDGE BORDER OF THE BOTTOM ROW ROOMS

19900 RETURN


20000 REM DRAW ALL MAP ROOMS ROUTINE
20100 FOR ROW = 0 TO 4
20200   FOR COL = 0 TO 4
20300     REM CALCULATE THE X AND Y COORDINATES OF THE TOP LEFT CORNER OF THE ROOM
20400     MX = (COL) * (RW)
20500     MY = (ROW) * (RH)
20600     REM DRAW A ROOM AT THE CURRENT POSITION
20700     GOSUB 16000
20800   NEXT COL
20900 NEXT ROW
21000 RETURN

21500 REM **************
21600 REM CENTER TEXT
21700 REM *************
21800 HTAB (80 - LEN( ST$ ))/2 : REM CENTERING ALGORITHM
21900 REM VTAB B
22000 PRINT ST$
22100 RETURN

23000 REM SET SCROLL WINDOW
23005 POKE 32,2 : REM SCROLL X
23010 POKE 33,41 : REM SCROLL WIDTH
23020 POKE 34,2 : REM SCROLL Y
23030 POKE 35,20 : REM SCROLL HEIGHT
23040 RETURN

23100 REM RESET SCROLL WINDOW
23105 POKE 32,0 : REM SCROLL X
23110 POKE 33,80 : REM SCROLL WIDTH
23120 POKE 34,0 : REM SCROLL Y
23130 POKE 35,24 : REM SCROLL HEIGHT
23140 RETURN

24000 KY = PEEK(49152)
24010 IF DEBUG = 0 OR X = 0 THEN RETURN
24020 REM XX = 1 : GOSUB 200 : VTAB(24) : ? NI$;"     ";M$;
24050 XX = 3 : GOSUB 200 : VTAB(24) : ? MI$;"cursor: ";X;"x";Y;NI$;" ";MI$;"PLAYER symbol: ";A;NI$;" (";A$;")";NI$;"  ";
24060 HTAB(40) : VTAB(24) : PRINT "|"; : HTAB(42) : VTAB(24) : PRINT "key: ";KY;"  ";
24070 HTAB(52) : VTAB(24) : PRINT MI$;": DEBUG :";NI$;
24100 RETURN

25000 REM PRINTING THE DATA ON SCREEN
25010 REM PRINT "xy:";COODS(W, 2);" x ";(COODS(W, 3) + 1) : HTAB(COODS(W, 2)) : VTAB (COODS(W, 3) + 1)
25500 FOR I = 1 TO Z
25550    REM HTAB(42) : VTAB(24) : PRINT "xy:";COODS(W, 2);" x ";(COODS(W, 3) + I);
25600    HTAB(COODS(W, 2)) : VTAB (COODS(W, 3) + I)
25700    IF I < Z THEN PRINT LINES$(W, I)
25750    IF I = Z THEN PRINT LINES$(W, I);
25800 NEXT I
25900 RETURN

30000 PRINT N$;"error!";

31000 REM DISPLAY FREE MEMORY LEFT
31010 IF FF = 1 THEN AVAIL = FRE(0)
31020 IF FF = 2 THEN ? D$;"FRE"
31025 FF = 0
31030 IF DEBUG = 0 THEN RETURN
31040 IF DEBUG = 1 THEN HTAB(64) : VTAB (24) : PRINT MI$;"free:";INT(AVAIL/1000);"k ";AVAIL;NI$;" ";
31050 RETURN





60000 REM DATA 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

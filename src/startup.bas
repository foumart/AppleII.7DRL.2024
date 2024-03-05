10 REM LOADER - PRINTS A TEXT FILE TO PREPARE THE SCREEN BEFORE THE GAME STARTS
15 REM WORKS PRETTY MUCH LIKE LOADING A BITMAP IMAGE FOR GAME UI, BUT WITH TEXT
20 REM SUPPORTS UPPERCASE, LOWERCASE, INVERSE AND MOUSE TEXT,=.
25 REM TRIGGERS FROM TEXT FILE: NORMAL [INVERSE] {MOUSETEXT}
30 REM "`" = PERIOD (.), "~" = COMMA (,), ";" = TWO DOTS PUNCTUATION (:)
35 REM NOTE: PERIOD, COMMA AND TWO DOTS CAN'T BE READ BY BASIC. TODO: IMPLEMENT BINARY READ

40 REM READCHAR ROUTINE SRC:
45 REM https://www.1000bit.it/support/manuali/apple/technotes/misc/tn.misc.10.html

50 REM BETTER ERROR HANDLING ROUTINE SRC:
60 REM https://www.applefritter.com/appleii-box/APPLE2/ErrormessagesFromONERR/Errormessages%20From%20ONERR.pdf

70 REM MEMORY LOCATIONS:
71 REM 0006 (6)          READCHAR CODE PLACEHOLDER
72 REM 0300 - 030F (768) RANDOMIZE SEED ROUTINE WITH RND(NEGATIVE)
73 REM 0310 - 0338 (784) READCHAR ROUTINE
74 REM 033A - 0344 (826) ERROR HANDLING ROUTINE
80 REM 03FF (1023)       DEBUG (1-3:ON, 0:OFF)


90 REM PRINT CHR$(4);"RUN GENERATOR" : END
100 LOMEM: 24576 : REM PREVENT WRITING IN THE GRAPHIC PAGES


1000 DEBUG = 0 : POKE 1023,DEBUG
1010 REM SPEED = 1 : POKE 1023,1 : REM DEBUG

1020 BL = 1 : REM DATA IS LOADED FROM A TEXT FILE WITH READ OR BLOAD
1030 I = 1 : B$ = "" : Z = 24 : OFFSET = 20
1040 LO$ = N$+M$+"V"+N$ : LQ$ = N$+M$+"W"+N$
1050 DIM LINES$(Z)

1060 D$ = CHR$(4)
1070 MI$ = CHR$(15) : REM TURN INVERSE ON
1080 NI$ = CHR$(14) : REM TURN INVERSE OFF
1090 M$ = MI$ + CHR$(27) : REM TURN SPECIAL CHARACTERS ON (80COL MOUSE TEXT CARD CHARS)
1100 N$ = CHR$(24) + NI$ : REM TURN SPECIAL CHARACTERS OFF

1200 PRINT D$;"PR#3" : PRINT CHR$(12); : REM TURN 80COL MODE ON

1205 REM LOADS A SMALL ROUTINE AT $0300 THAT INCREMENTS THE RND LOCATIONS WHILE WAITING FOR KEYPRESS
1210 FOR O = 768 TO 782 : READ P
1215 POKE O,P : NEXT O : REM EXAMPLE: CALL 768 : X = RND(-1*(PEEK(78)+256*PEEK(79))) : PRINT X
1220 DATA 230,78,208,2,230,79,44,0,192,16,245,44,16,192,96

1225 PRINT D$"BLOAD READCHAR" : REM LOADS THE GET CHAR ROUTINE AT $0310

1230 IF DEBUG > 0 THEN PRINT CHR$(4);"RUN MAIN" : END

1235 POKE 49239,0 : REM TURN ON HIRES
1240 POKE 49237,0: PRINT D$;"BLOAD TITLE, A$2000, L$2000"
1245 POKE 49236,0: PRINT D$;"BLOAD TITLE, A$2000, L$2000, B$2000"
1250 POKE 49232,0: REM TURN ON GRAPHICS
1255 POKE 49235,0: REM TURN ON MIXED MODE
1260 POKE 49246,0: REM TURN ON DHR

1310 FOR O = 1 TO 21
1320 PRINT
1330 NEXT O
1340 HTAB(OFFSET) : PRINT N$;"_            ___________________________"
1350 HTAB(OFFSET) : PRINT M$;"C";N$;" Preparing ";M$;"Z";N$;MI$;" ";NI$;M$;
1400 FOR P = 1 TO Z + 1
1410 PRINT "\\";
1420 NEXT P
1430 PRINT N$;MI$;" ";NI$;M$;"_";N$;
1435 VTAB(24) : HTAB(OFFSET + 13) : FOR P = 1 TO Z + 3 : PRINT M$;"L";N$; : NEXT P
1440 IF BL = 1 THEN GOTO 1500
1450 TADDR = 24576 : TADDR$ = "6000" : REM FREE MEMORY SPACE TO LOAD TEXT DATA INTO
1460 PRINT D$;"BLOAD UI,TTXT,A$";TADDR$
1480 GOTO 2700

1500 REM OPEN AND READ A TEXT FILE, SAVING THE DATA IN AN ARRAY (LINES$)
1600 VTAB(20) : HTAB(1) : PRINT D$;"OPEN UI"
1800 VTAB(20) : HTAB(1) : PRINT D$;"READ UI" : REM HTAB(OFFSET + 39) : PRINT N$;MI$;" ";NI$;M$;"_";N$;
1900 VTAB(20) : HTAB(1) : INPUT L : IF DEBUG > 0 THEN L = 0 : REM GET THE TOTAL LINES OF THE TEXT FILE (FIRST PARAMETER FROM TEXT FILE)
2000 VTAB(23) : HTAB(OFFSET + 14) : PRINT N$;M$;LQ$;N$;
2050 VTAB(20) : HTAB(1) : INPUT H : REM REM GET LEFT OFFSET WHEN INSERTING THE TEXT (SECOND PARAMETER FROM TEXT FILE)
2100 VTAB(20) : HTAB(1) : INPUT V : REM VTAB(V) : REM GET TOP OFFSET WHEN INSERTING THE TEXT (THIRD PARAMETER FROM TEXT FILE)
2300 VTAB(23) : HTAB(OFFSET + 14 + I)
2310 IF I/2 = INT(I/2) THEN PRINT N$;M$;LQ$;N$; : GOTO 2350
2320 PRINT N$;M$;LO$;N$;
2350 VTAB(20) : HTAB(1) : INPUT A$ : REM GET THE NEXT DATA ROW

2380 VTAB(23)
2400 LINES$(I) = A$ : I = I + 1
2450 IF I > L THEN GOTO 2600
2500 GOTO 2300 : REM ITERATE LINES
2600 PRINT D$;"CLOSE":REM HTAB(OFFSET + 39) : PRINT N$;MI$;" ";NI$;M$;"_";N$; : 
2620 REM VTAB(23) : HTAB(14) : PRINT M$;"I";N$;
2650 GOTO 7200

2700 REM TODO : ASM PRLINES
2750 REM GETS THE THREE VARIABLES AT THE BEGINNING OF THE TEXT FILE (L:LINE LENGTH, H:INDENT, V:TOP)
2800 REM ALSO WILL SAVE THE STARTING ADDRESS OF THE ACTUAL TEXT DATA BECAUSE IT CAN VARY
2850 VTAB(23) : HTAB(OFFSET + 13) : PRINT M$;LO$;N$;
2900 I = 0 : REM CURRENT ADDRESS POSITION FROM THE LOADED TEXT DATA
3000 E = 0 : REM CURRENT TEXT VAR
3100 DIM TXTDTA(4) : TXTDTA(1) = 0 : TXTDTA(2) = 0 : TXTDTA(3) = 0 : TXTDTA(4) = 0 : REM TEXT VARS HOLDER
3200 DIM CHARS(3)

3300 K = 0 : REM CURRENT X POSITION OF TEXT VARIABLE READING
3400 CHARS(1) = 0 : CHARS(2) = 0 : CHARS(3) = 0 : REM PARTS OF THE NUMBER

3500 REM ITERATE THROUGH BYTES
3600 J = PEEK(TADDR + I) : REM READ THE NEXT ADDRESS
3700 IF J = 141 THEN GOTO 4200 : REM LINE BREAK MARKS THE END OF A TEXT VARIABLE DATA
3800 K = K + 1
3900 CHARS(K) = J - 128
4000 I = I + 1
4100 GOTO 3500

4200 REM DATA FOR THE TEXT VARS WILL BE READ AS STRINGS AND THEN COMBINED INTO NUMBERS
4300 I$ = "" : I = I + 1
4400 FOR F = 0 TO K
4500 I$ = I$ + CHR$(CHARS(F + 1))
4600 NEXT F
4700 E = E + 1
4800 TXTDTA(E) = VAL(I$)
4900 IF E < 3 THEN GOTO 3300
5000 TXTDTA(4) = TADDR + I : REM PRINT TXTDTA(1), TXTDTA(2), TXTDTA(3) , TXTDTA(4) : REM DEBUG THE TEXT DATA
5100 L = TXTDTA(1) : H = TXTDTA(2) : V = TXTDTA(3) : A = TXTDTA(4)
5300 REM HB = INT(A / 256) : TODO : PRLINES
5400 REM LB = A - (HB * 256)
5500 REM POKE 31994,HB
5600 REM POKE 31995,LB
5700 REM POKE 31996,L
5800 REM POKE 31997,H
5900 REM POKE 31998,V
6000 REM CALL 31744 : END : REM CALL PRLINES ASM
6050 PRINT M$;LO$;N$;

6100 JJ = 0 : KK = 0
6200 II = 1
6300 LINES$(II) = ""
6400 KK = PEEK(A + JJ)
6500 IF KK = 141 GOTO 6900
6600 LINES$(II) = LINES$(II) + CHR$(KK)
6700 JJ = JJ + 1
6800 GOTO 6400
6900 JJ = JJ + 1 : II = II + 1
6950 PRINT M$;LO$;N$;
7000 IF II < L+1 THEN GOTO 6300
7050 PRINT M$;LO$;LO$;N$;

7200 REM UPDATING THE DATA IN PLACE
7210 VTAB(22) : HTAB(OFFSET) : PRINT N$;M$;"I";N$ : HTAB(OFFSET) : PRINT M$;"C";N$;" Buffering ";M$;"Z ";
7220 VTAB(23) : HTAB(OFFSET + 14)
7225 PRINT M$;" ";N$;
7300 FOR I = 1 TO L
7375   NE$ = ""
7400   A$ = LINES$(I) : M = LEN(A$) : D = 1
7600   FOR X = 1 TO M
7700     B$ = MID$(A$, X, 1)
7800     C = ASC(B$)
7900     IF C = 123 THEN NE$ = NE$ + M$ : GOTO 8600 : REM TURN MOUSE TEXT ON WITH TRIGGER: "{"
8000     IF C = 125 THEN NE$ = NE$ + N$ : GOTO 8600 : REM TURN MOUSE TEXT OFF WITH TRIGGER: "}"
8100     IF C = 91 THEN NE$ = NE$ + MI$ : GOTO 8600 : REM TURN INVERSE ON WITH TRIGGER: "["
8200     IF C = 93 THEN NE$ = NE$ + NI$: GOTO 8600 : REM TURN INVERSE OFF WITH TRIGGER: "]"
8300     IF C = 59 THEN NE$ = NE$ + ":" : GOTO 8600 : REM TYPE TWO DOTS PUNCTUATION ":" WITH TRIGGER: ";"
8400     IF C = 96 THEN NE$ = NE$ + "." : GOTO 8600 : REM TYPE A PERIOD "." WITH TRIGGER: "`"
8500     IF C < 125 THEN NE$ = NE$ + B$ : REM WILL PRINT THE REQUESTED LETTER
8550     IF C = 126 THEN NE$ = NE$ + "," : REM TYPE A COMMA "," WITH TRIGGER: "~"
8600   NEXT X
8650   LINES$(I) = NE$ : PRINT M$;" ";N$;
8700   IF I = 12 THEN POKE 49237,0: PRINT D$;"BLOAD SCREEN, A$2000, L$2000"
8720   IF I = 12 THEN POKE 49236,0: PRINT D$;"BLOAD SCREEN, A$2000, L$2000, B$2000"
8750 NEXT I
8800 PRINT M$;" ";N$

9100 HOME
9200 REM PRINTING THE DATA ON SCREEN
9300 FOR I = 1 TO Z
9350    HTAB(H) : VTAB (V + I - 1)
9400    IF I = Z THEN ? LINES$(I); : GOTO 9500
9450    ? LINES$(I)
9500 NEXT I

9980 REM RUNNING A NEW BASIC FILE SHOULD WIPE ALL THE ABOVE
9990 REM USED ONLY AT THE BEGINNING TO DRAW THE TEXT SCREEN UI
10000 VTAB(1)
10500 IF DEBUG = 0 THEN TEXT
11000 PRINT D$;"RUN MAIN"


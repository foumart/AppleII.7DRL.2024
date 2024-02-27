1 REM RL ENGINE FOR APPLE II BY FOUMARTGAMES
2 REM ======================================
3 REM READCHAR ROUTINE SRC:
4 REM https://www.1000bit.it/support/manuali/apple/technotes/misc/tn.misc.10.html
5 REM ==============
9 REM INITIALIZATION
10 D$ = CHR$(4)
12 MX = 0 : MY = 0 : REM MAP ROOMS COORDINATES
14 RW = 9 : RH = 4 : REM ROOM SIZE
15 X = 23 : Y = 19 : REM INITIAL PLAYER POSITION
18 A = 160 : REM HOLDS THE MAP TILE PLAYER IS CURRENTLY ON READ BY THE READCHAR ROUTINE.
20 DIM PLAYER(3) : REM HOLDS X, Y, AND THE MAP CHARACTER THAT'S BEHIND THE UNIT
24 PLAYER(1) = X : PLAYER(2) = Y : PLAYER(3) = A
26 A$ = CHR$(160) : REM THE CHARACTER CODE READ BY THE ROUTINE BUT AS STRING
30 M$ = CHR$(27) + CHR$(15) : REM TURN SPECIAL CHARACTERS ON (80COL CARD CHARS)
32 N$ = CHR$(24) + CHR$(14) : REM TURN SPECIAL CHARACTERS OFF
34 ST$ = ""

40 REM ? D$;"PR#3"
50 ? D$"BLOAD READCHAR"

59 REM 
60 DIM ROOMS$(4)
70 ROOMS$(1) = "  "
75 ROOMS$(2) = " "+M$+CHR$(93)+N$
80 ROOMS$(3) = M$+CHR$(90)+CHR$(94)+N$
90 ROOMS$(4) = " "+M$+CHR$(91)+N$

99 REM GENERATE MAP CONNECTIONS ARRAY
100 DIM MAP(5, 5)
110 DATA 0,0,5,0,0,0,0,5,0,0,0,0,7,0,0,0,0,5,3,0,0,0,9,0,0
130 FOR I = 0 TO 4
140   FOR J = 0 TO 4
150     READ MAP(I,J)
160   NEXT J
170 NEXT I

199 REM GENERATE MAP CONTENTS ARRAY
200 DIM INSIDES(5, 5)
210 DATA 0,0,2,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,1,0,0
220 FOR I = 0 TO 4
230   FOR J = 0 TO 4
240     READ INSIDES(I,J)
250   NEXT J
260 NEXT I

299 REM GENERATE MAP VISITED ROOMS ARRAY
300 DIM VISIBLES(5, 5)
310 REM DATA 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
315 DATA 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,1,0,0
320 FOR I = 0 TO 4
330   FOR J = 0 TO 4
340     READ VISIBLES(I,J)
350   NEXT J
355 NEXT I

360 GOSUB 2000 : GOSUB 900

499 REM MAIN LOOP
500 REM FOR II=1 TO 200: NEXT II : REM WAIT 49200,3
510 REM IF PLAYER(1) = X AND PLAYER(2) = Y THEN GOTO 550 : REM SKIP IF PLAYER HAS NOT MOVED
530 PLAYER(1) = X : PLAYER(2) = Y : PLAYER(3) = A
540 HTAB(X) : VTAB(Y) : ? N$;"@" : REM DRAW PLAYER
550 IF K > 0 AND PEEK(-16384) > 0 THEN 500
560 K = 0
570 IF PEEK(-16384) = 0 THEN 500
580 K = PEEK(-16384)
590 REM POKE-16336,0 : REM CLEARS KEYBOARD STROBE - ALWAYS AFTER READING KEYBOARD
600 VTAB(22) : ? N$;"keycode: ";K;"  "; : REM DEBUG DISPLAY OF CHAR CODE KEY PRESSED

610 REM DISPLAY THE MAP CHAR AT THE PLAYER'S PREVIOUS POSITION AND PERFORM MOVE
620 HTAB(X) : VTAB(Y)
630 GOSUB 3000
700 PRINT AA$
710 IF K = 149 OR K = 225 OR K = 196 THEN GOTO 750 : REM RIGHT
720 IF K = 136 OR K = 234 OR K = 202 THEN GOTO 780 : REM LEFT
730 IF K = 139 OR K = 247 OR K = 215 THEN GOTO 820 : REM UP
740 IF K = 138 OR K = 243 OR K = 211 THEN GOTO 850 : REM DOWN
745 IF K = 160 THEN GOTO 880

748 GOTO 510

749 REM LIMIT MOVEMENT
750 IF A = 160 OR A = 93 OR A = 95 OR A = 90 OR A = 92 THEN X = X + 1 : GOSUB 900
755 IF A = 94 THEN VTAB(Y) : HTAB(X+1) : ? M$;"\\\\"; : MX = 1 : MY = 4 : GOSUB 1000 : REM TODO: FIX HARDCODED STUFF
760 IF A <> 160 AND A <> 93 AND A <> 90 AND (A <> 92 OR A = 92 AND Y<>19 AND Y<>15 AND Y<>11 AND Y<>7 AND Y<>3) THEN X = X - 1 : GOSUB 900
775 GOTO 500

780 IF A = 160 OR A = 93 OR A = 95 OR A = 90 OR A = 92 THEN X = X - 1 : GOSUB 900
782 REM TODO: FIX HARDCODED STUFF AROUND DOORS OPENING 7AND ROOM REVEALING
785 IF A = 94 THEN ROW = 4 : COL = 1 : VISIBLES(4,1) = 2 : VTAB(Y) : HTAB(X-1) : MX = X-10 : MY = Y-3 : GOSUB 1000 : VTAB(Y) : HTAB(X-2) : ? N$;" ";M$;"\\\\";N$;" ";M$;
790 IF A <> 160 AND A <> 93 AND A <> 95 AND (A <> 92 OR A = 92 AND Y<>19 AND Y<>15 AND Y<>11 AND Y<>7 AND Y<>3) THEN X = X + 1 : GOSUB 900
815 GOTO 500

820 IF A = 92 THEN GOTO 500
825 IF A = 160 OR A = 93 OR A = 95 OR A = 90 THEN Y = Y - 1 : GOSUB 900
830 IF A = 94 THEN ROW = 2 : COL = 2 : VISIBLES(2,2) = 2 : VTAB(Y-1) : HTAB(X) : MX = X-5 : MY = Y-5 : GOSUB 1000 : VTAB(Y) : HTAB(X-1) : ? M$;"_";N$;" ";M$;"Z";M$;
831 REM IF A = 94 THEN VTAB(Y) : HTAB(X-1) : ? M$;"Z";N$;" ";M$;"_"; : MX = 1 : MY = 4 : GOSUB 1000 : REM TODO: FIX HARDCODED STUFF
835 IF A <> 160 AND A <> 93 AND A <> 95 AND A <> 90 OR (A = 92 AND Y<>19 AND Y<>15 AND Y<>11 AND Y<>7 AND Y<>3) THEN Y = Y + 1 : GOSUB 900
845 GOTO 500

850 IF A = 92 THEN GOTO 500
855 IF A = 160 OR A = 93 OR A = 95 OR A = 90 THEN Y = Y + 1 : GOSUB 900
860 IF A <> 160 AND A <> 93 AND A <> 95 AND A <> 90 OR (A = 92 AND Y<>19 AND Y<>15 AND Y<>11 AND Y<>7 AND Y<>3) THEN Y = Y - 1 : GOSUB 900
875 GOTO 500

880 GOSUB 950
890 GOTO 500

899 REM MAP CHARACTER READ ROUTINE
900 REM PEEK(36) AND POS(0) ARE NOT WORKING IN 80 COL, SO BELOW WE ACCESS DIFFERENT ADDRESSES TO BE SURE
905 POKE 1147,X : POKE 1403,X : POKE 36,X : REM POKE 1531,Y : POKE 37,Y
910 P1 = PEEK (36)
920 IF P1 = 0 THEN P1 = PEEK (1403)
930 IF P1 = 0 THEN P1 = PEEK (1147)
940 POKE 1403,P1-1 : POKE 1147,P1-1 : POKE 36,P1-1 : REM MAKE SURE WE HAVE THE CORRECT HORIZONTAL POSITION
950 VTAB(Y)
960 CALL 32256: REM CALL THE GETCHAR ROUTINE
970 A = PEEK(6) : A$ = CHR$(A) : GOSUB 3000
980 HTAB(2) : VTAB(23) : ? N$;"cursor: ";P1;"x";Y;"     PLAYER symbol: ";A;" (";AA$;")   "
981 REM FOR II=1 TO 300: NEXT II
985 RETURN

990 ? CHR$(14) : END

1000 REM DRAW A ROOM
1005 ? CHR$(15)
1010 HTAB(MX+1) : VTAB(MY+1)

1012 IF MY < 4 THEN GOTO 1016
1014 ? N$;" ";M$;"\\\\\\\\\\\\\\";N$;" ";M$ : REM DRAW IN BETWEEN ROOM VERTICAL SPACE
1015 GOTO 1020
1016 ? N$;" _______ ";M$ : REM DRAW TOP EDGE BORDER OF THE FIRST ROW ROOMS

1019 REM DRAW EMPTY ROOM
1020 M = MAP(ROW, COL): V = VISIBLES(ROW, COL)
1025 IF V > 0 THEN HTAB(MX+1) : VTAB(MY+2) : ? "Z_";N$;"     ";M$;"Z_"
1030 IF V > 0 OR M <> 0 THEN HTAB(MX+1) : VTAB(MY+3) : ? "Z_";N$;" ";ROOMS$(INSIDES(ROW, COL)+1);"  ";M$;"Z_"
1040 IF V > 0 THEN HTAB(MX+1) : VTAB(MY+4) : ? "Z_";N$;"     ";M$;"Z_"

1049 REM GREYED OUT ROOMS
1050 IF V = 0 THEN HTAB(MX+1) : VTAB(MY+2) : ? "ZVWVWVWV_"
1060 IF V = 0 THEN HTAB(MX+1) : VTAB(MY+3) : ? "ZVWVWVWV_"
1070 IF V = 0 THEN HTAB(MX+1) : VTAB(MY+4) : ? "ZVWVWVWV_"

1071 REM TODO: EXPERIMENT WITH PARTIAL ROOM REVEAL (WHEN THERE ARE ENEMIES FOR EXAMPLE)
1072 REM IF V = 2 THEN HTAB(MX+1) : VTAB(MY+2) : ? "ZWVWVW";N$;"  ";M$;"_"
1074 REM IF V = 2 THEN HTAB(MX+1) : VTAB(MY+3) : ? "ZWVWV";N$;"   ";M$;"_"
1076 REM IF V = 2 THEN HTAB(MX+1) : VTAB(MY+4) : ? "ZWVWVW";N$;"  ";M$;"_"

1099 REM DRAW DOORS
1100 IF V = 0 GOTO 1970

1140 REM HORIZONTAL OPEN DOORS
1150 IF M <> 3 AND M <> 4 AND M <> 8 THEN GOTO 1250
1160 IF VISIBLES(ROW, COL-1) = 1 THEN HTAB(MX-1) : VTAB(MY+3) : ? N$;" ";M$
1170 HTAB(MX+2) : VTAB(MY+3) : ? N$;" ";M$
1180 HTAB(MX) : VTAB(MY+3) : ? "\\\\"

1249 REM HORIZONTAL CLOSED DOORS
1250 IF M <> 6 AND M <> 7 AND M <> 9 THEN GOTO 1350
1260 IF VISIBLES(ROW, COL-1) = 1 THEN HTAB(MX-1) : VTAB(MY+3) : ? "Z"
1270 IF VISIBLES(ROW, COL+1) = 1 THEN HTAB(MX+2) : VTAB(MY+3) : ? "_"
1280 HTAB(MX) : VTAB(MY+3) : ? " ^"

1349 REM VERTICAL OPEN DOOR
1350 IF M = 2 OR M = 4 OR M = 9 THEN HTAB(MX+4) : VTAB(MY+1) : ? CHR$(95);N$" ";M$;CHR$(90)

1949 REM VERTICAL CLOSED DOOR
1950 IF M = 5 OR M = 7 OR M = 8 THEN HTAB(MX+4) : VTAB(MY+1) : ? " ^ "

1970 REM
1975 IF MY < 15 THEN RETURN
1980 HTAB(MX+1) : VTAB(MY+5) : ? N$;" ";M$;"LLLLLLL";N$;" ";M$ : REM DRAW BOTTOM EDGE BORDER OF THE BOTTOM ROW ROOMS

1990 RETURN


2000 REM DRAW ALL MAP ROOMS ROUTINE
2010 FOR ROW = 0 TO 4
2020   FOR COL = 0 TO 4
2030     REM CALCULATE THE X AND Y COORDINATES OF THE TOP LEFT CORNER OF THE ROOM
2040     MX = (COL) * (RW)
2050     MY = (ROW) * (RH)
2060     REM DRAW A ROOM AT THE CURRENT POSITION
2070     GOSUB 1000
2080   NEXT COL
2090 NEXT ROW
2100 RETURN

2999 REM MAKE SURE WE DISPLAY THE PROPER CHARACTER
3000 IF A >= 160 THEN AA$ = N$ + A$ : RETURN
3010 AA$ = M$ + A$ + N$
3020 RETURN


20000 REM **************
20010 REM CENTER TEXT
20020 REM *************
20030 HTAB (80 - LEN( ST$ ))/2 : REM CENTERING ALGORITHM
20040 REM VTAB B
20050 PRINT ST$
20060 RETURN
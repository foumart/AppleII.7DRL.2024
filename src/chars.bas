1 LET B = 0
2 LET K = 0 : C = 0
3 PRINT CHR$(21)
5 IF B = 0 THEN POKE 49167,0 : REM Show ALTCHRSET
6 IF B = 1 THEN POKE 49166,0 : REM Don't show ALTCHRSET

10 LET H$ = "0123456789ABCDEF"
20 HOME : VTAB 3 : HTAB 13
30 PRINT H$
40 FOR V = 1 TO 16 : PRINT
50     HTAB 11 : A = PEEK (41) * 256
60     LET A = A + PEEK(40)
70     PRINT MID$(H$, V, 1);
80     FOR H = 1 TO 16
90         POKE A + H + 11, C : C = C + 1
95 NEXT H, V

100 REM
110 IF K > 0 AND PEEK(-16384) > 0 THEN 100
120 K = 0
130 IF PEEK(-16384) = 0 THEN 100
140 K = PEEK(-16384)
150 IF B = 1 THEN B = 0 : GOTO 2
160 IF B = 0 THEN B = 1
170 GOTO 2
		ORG $0310		;GET CHARACTERS FROM SCREEN IN 80 COL

PAGE1	EQU $C054		;TURN OFF PAGE 2 (READ)
PAGE2	EQU $C055		;TURN ON PAGE 2 (READ)
CLR80	EQU $C000		;TURN OFF 80 STORE (WRITE)
SET80	EQU $C001		;TURN ON 80 STORE (WRITE)
BASL	EQU $28			;BASE ADDRESS OF SCREEN LOCATION (PAGE 1)
OURCH	EQU $57B		;80 COLUMNS HORIZ. POSITION
CHAR	EQU 6			;PLACE TO HAND CHARACTER BACK TO BASIC

GETCHR	EQU *			;GET THE CHAR AT THE CURRENT CURSOR LOC.
		LDA	#$01		;MASK FOR HORIZ TEST
		BIT	OURCH		;ARE WE IN MAIN OR AUX MEM?
		BNE	MAIN		;IF BIT 0 OF OURCH IS SET, THEN MAIN MEM

AUX		EQU	*
		LDA	OURCH		;GET HORIZ POS.
		CLC				;CLEAR THE CARRY FOR DIVIDE
		LSR				;DIVIDE BY TWO
		TAY				;PUT THE RESULT IN Y
		STA	SET80		;TURN ON 80 STORE
		LDA	PAGE2		;FLIP TO AUX TEXT PAGE
		LDA	(BASL),Y	;GET THE CHARACTER
		STA	CHAR
		LDX	PAGE1		;TURN OFF AUX TEXT PAGE
		STA	CLR80		;TURN OFF 80 STORE
		RTS

MAIN	EQU	*
		LDA	OURCH		;GET HORIZ POS.
		CLC				;CLEAR THE CARRY FOR DIVIDE
		LSR				;DIVIDE BY TWO
		TAY				;PUT THE RESULT IN Y
		LDA	(BASL),Y	;GET THE CHARACTER
		STA	CHAR
		RTS

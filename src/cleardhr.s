	ORG $0368

HGR_CLEAR
	LDA	#$00
	STA	OUTL
	LDA	#$1F
	STA	OUTH

HGR_C_LOOP
	LDA	#$0
	STA	(OUTL),Y
	INY
	BNE	HGR_C_LOOP

	INC	OUTH
	LDA	OUTH
	CMP	#$40
	BNE	HGR_C_LOOP

	RTS

OUTL	EQU $FE
OUTH	EQU $FF

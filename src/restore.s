        ORG $1F70       ; Program load address (e.g. CALL 8040 from BASIC)

		                ; Zero-page pointer definitions
SRCPL	EQU $EB			; low byte of source pointer
SRCPH	EQU $EC			; high byte of source pointer
DSTPL	EQU $ED			; low byte of destination pointer
DSTPH	EQU $EE			; high byte of destination pointer
BLOCKS	EQU $EF			; counter for number of 256-byte blocks (should be 4)

		                ; Bank switching addresses
PAGE1	EQU $C054		; TURN OFF PAGE 2 (READ)
PAGE2	EQU $C055		; TURN ON PAGE 2 (READ)
CLR80	EQU $C000		; TURN OFF 80 STORE (WRITE)
SET80	EQU $C001		; TURN ON 80 STORE (WRITE)

RESTORE EQU *
		JSR RSTRL       ; Restore left half from backup buffer ($1000) to $0800
		;JSR	RSTRR   ; Restore right half from backup buffer ($1400) to aux bank
		RTS

RSTRL
		LDA #$00
		STA SRCPL
		LDA #$10        ; Source = $1000
		STA SRCPH

		LDA #$00
		STA DSTPL
		LDA #$04        ; Destination = $0400 (normal bank text)
		STA DSTPH

		LDA #$04
		STA BLOCKS

RSTRLO	EQU *
		JSR CPY256
		JSR ADD256S
		JSR ADD256D
		DEC BLOCKS
		BNE RSTRLO
		RTS

RSTRR   EQU *
		STA SET80       ; TURN ON 80 STORE
		LDA PAGE2       ; FLIP TO AUX TEXT PAGE
		LDA #$00
		STA SRCPL
		LDA #$14        ; Source = $1400
		STA SRCPH

		LDA #$00
		STA DSTPL
		LDA #$04        ; Destination = $0400 (normal bank text)
		STA DSTPH

		LDA #$04
		STA BLOCKS

RSTRRO	EQU *
		JSR CPY256
		JSR ADD256S
		JSR ADD256D
		DEC BLOCKS
		BNE RSTRRO

		LDX PAGE1       ; TURN OFF AUX TEXT PAGE
		STA CLR80       ; TURN OFF 80 STORE
		RTS


CPY256	EQU *
		LDY #$00
CPY256L	EQU *
		LDA (SRCPL),Y   ; Load byte from source pointer + Y
		STA (DSTPL),Y   ; Store byte into destination pointer + Y
		INY
		CPY #$00        ; After 256 iterations, Y will wrap to 0.
		BNE CPY256L
		RTS

ADD256S	EQU *           ; Increment the high byte of the 16-bit source pointer by 1.
		INC SRCPH       ; Since we’re copying 256-byte blocks and the low byte remains 0, this adds 256.
		RTS

ADD256D	EQU *           ; Increment the high byte of the 16-bit destination pointer by 1.
		INC DSTPH
		RTS

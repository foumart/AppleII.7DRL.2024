		ORG $1F00       ; Program load address (e.g. CALL 7936 from BASIC)

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

BACKUP	EQU *           ; Copies both halves of the 80-col text screen into backup buffers.
		JSR BCKPL       ; Backup left half from normal bank (text screen at $0400)
		;JSR	BCKPR       ; Backup right half from auxiliary bank (via bank switching)
		RTS

BCKPL	EQU *           ; Copy 1024 bytes from MAIN memory at $0400
		LDA #$00        ; Set source pointer low byte ${PH}00
		STA SRCPL
		LDA #$04        ; Set source pointer high byte $04{PL}
		STA SRCPH

		LDA #$00        ; Set destination pointer low byte ${PH}00
		STA DSTPL
		LDA #$10        ; Set destination pointer low byte $10{PL}
		STA DSTPH

		LDA #$04        ; Set counter for 4 blocks (256 bytes each)
		STA BLOCKS

BCKPLO	EQU *
		JSR CPY256      ; Copy one 256-byte block
		JSR ADD256S     ; Increment source pointer by 256
		JSR ADD256D     ; Increment destination pointer by 256
		DEC BLOCKS
		BNE BCKPLO
		RTS

BCKPR	EQU *           ; Copy 1024 bytes from AUX memory at $0400
		STA SET80       ; TURN ON 80 STORE
		LDA PAGE2       ; FLIP TO AUX TEXT PAGE

		LDA #$00        ; Set source pointer low byte ${PH}00
		STA SRCPL
		LDA #$04        ; Set source pointer high byte $04{PL}
		STA SRCPH

		LDA #$00        ; Set destination pointer low byte ${PH}00
		STA DSTPL
		LDA #$14        ; Set destination pointer low byte $14{PL}
		STA DSTPH

		LDA #$04        ; Set counter for 4 blocks (256 bytes each)
		STA BLOCKS

BCKPRO	EQU *
		JSR CPY256      ; Copy one 256-byte block
		JSR ADD256S     ; Increment source pointer by 256
		JSR ADD256D     ; Increment destination pointer by 256
		DEC BLOCKS
		BNE BCKPRO

		LDX PAGE1       ; TURN OFF AUX TEXT PAGE
		STA CLR80       ; TURN OFF 80 STORE
		RTS

		                ; Copy 256 bytes from address ${SRCPH}{SRCPL} to address ${DSTPH}{DSTPL}.
		                ; Uses the Y register as an 8-bit offset and the standard trick
		                ; where Y is initialized to 0 and allowed to wrap after 256 iterations.
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

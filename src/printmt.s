        ORG $4000

; PRTXT Print text with proper handling of mousetext reset.
; ZP F0 = pointer low, F1 = pointer high, F2 = count low, F3 = count high.
; Uses OSWRCH at $FDED for character output.

F0	EQU $F0
F1	EQU $F1
F2	EQU $F2
F3	EQU $F3

PRINTBLK
        LDY #$00           ; Set Y = 0 for indirect addressing

        ; Check block counter (at $E1); if >= 40 (0x28), return to BASIC
        ;LDA $E1
        ;CMP #$28
        ;BCS DONEBLK

LOOP
        ; Check if any bytes remain (F2F3)
        LDA F2
        ORA F3
        BEQ DONEFIL

        LDA (F0),Y        ; Get next byte from file
        SEC           ; Set the carry flag (required before SBC)
        SBC #$80     ; Subtract $80 (128) from the value in A

        ; Check if the byte equals any of the mouse-text close codes.
        ;CMP #$18         ; CAN
        ;BEQ NORMAL
        ;CMP #$11
        ;BEQ NORMAL
        ;CMP #$0F         ; Sometimes SI is used
        ;BEQ NORMAL

        ; Otherwise, if the byte is below SPACE (32), skip it.
        ;CMP #$20
        ;BMI SKIPBYTE

        ; If the byte is 127 or above, skip it.
        ;CMP #$7F
        ;BCS SKIPBYTE

        ; Otherwise, print the character.
        JSR $FDED       ; OSWRCH prints the character

        ; Increment block counter.
        ;INC $E1

SKIPBYTE
        JSR INCPT       ; Increment pointer and decrement count.
        JMP LOOP

;-----------------------------------------------------------
; NORMAL When a mouse-text closing control code is found,
; output a normal-mode command and skip the control code.
;-----------------------------------------------------------
;NORMAL
        ;LDA #$0E       ; CHR$(14) forces normal text mode.
        ;JSR $FDED      ; Output it.
        ;LDA #$18       ; CHR$(14) forces normal text mode.
        ;JSR $FDED      ; Output it.
        ;JSR INCPT      ; Skip the control code in the file.
        ;JMP LOOP

;-----------------------------------------------------------
; DONEBLK End of a printing block; return to BASIC.
;-----------------------------------------------------------
DONEBLK
        RTS

;-----------------------------------------------------------
; DONEFIL Finished printing the entire text file.
;         Reset block counter to 0 and return.
;-----------------------------------------------------------
DONEFIL
        LDA #$00
        ;STA $E1       ; Reset block counter.
        RTS

;-----------------------------------------------------------
; INCPT Increment pointer (F0,F1) and decrement the 16-bit count (F2F3) by one.
;-----------------------------------------------------------
INCPT
        INC F0       ; Increment low byte of pointer.
        BNE INC2
        INC F1       ; If F0 wrapped, increment high byte.
INC2
        JSR DECN     ; Decrement the 16-bit count.
        RTS

;-----------------------------------------------------------
; DECN Decrement the 16-bit count (F2F3) by one.
;-----------------------------------------------------------
DECN
        LDA F2
        SEC
        SBC #1
        STA F2
        BCS DECOK
        DEC F3
DECOK
        RTS

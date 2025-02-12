        ORG $036A

F0      EQU $F0         ; 240 LOW BYTE OF TEXT START (0 DECIMAL = $00)
F1      EQU $F1         ; 241 HIGH BYTE TEXT START (16 DECIMAL = $10)
F2      EQU $F2         ; 242 LOW BYTE OF TEXT LENGTH
F3      EQU $F3         ; 243 HIGH BYTE OF TEXT LENGTH

PRINTBLK
        LDY #$00        ; Set Y = 0 for indirect addressing

LOOP                    ; Check if any bytes remain at ${F3}{F2}
        LDA F2
        ORA F3
        BEQ DONEFIL

        LDA (F0),Y      ; Get next byte from file
        SEC             ; Set the carry flag (required before SBC)
        SBC #$80        ; Subtract $80 (128) from the value in A

        JSR $FDED       ; OSWRCH prints the character

        JSR INCPT       ; Increment pointer and decrement count.
        JMP LOOP

DONEFIL                 ; Finished printing the entire text file.
        LDA #$00
        RTS

INCPT                   ; Increment pointer ${F1}{F0} and decrement the 16-bit count ${F3}{F2} by one.
        INC F0          ; Increment low byte of pointer.
        BNE INC2
        INC F1          ; If F0 wrapped, increment high byte.
INC2
        JSR DECN        ; Decrement the 16-bit count.
        RTS

DECN                    ; DECN Decrement the 16-bit count ${F3}{F2} by one.
        LDA F2
        SEC
        SBC #1
        STA F2
        BCS DECOK
        DEC F3
DECOK
        RTS

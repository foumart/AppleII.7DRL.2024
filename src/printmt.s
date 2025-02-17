        ORG $0339

ZEB     EQU $EB         ; 235 LOW BYTE OF TEXT START/POINTER (0 DECIMAL = $00)
ZEC     EQU $EC         ; 236 HIGH BYTE TEXT START/POINER (16 DECIMAL = $10)
ZED     EQU $ED         ; 237 LOW BYTE OF TEXT LENGTH
ZEE     EQU $EE         ; 238 HIGH BYTE OF TEXT LENGTH

START
        LDY #$00        ; Set Y = 0 for indirect addressing

LOOP

        LDA ZED         ; Check if any bytes remain at ${ZEE}{ZED}
        ORA ZEE         ; and if both are zero, then complete.
        BEQ DONEFIL

PRTCHAR

        LDA (ZEB),Y     ; Get next byte from file
        SEC             ; Set the carry flag (required before SBC)
        SBC #$80        ; Subtract $80 (128) from the value in A

        JSR $FDED       ; OSWRCH prints the character

SKIP
        JSR INCPT       ; Increment pointer and decrement count.
        JMP LOOP

DONEFIL                 ; Finished printing the entire text file.
        LDA #$00
        RTS

INCPT                   ; Increment pointer ${ZEC}{ZEB} and decrement the 16-bit count ${ZEE}{ZED} by one.
        INC ZEB         ; Increment low byte of pointer.
        BNE INC2
        INC ZEC         ; If ZEB wrapped, increment high byte.
INC2
        JSR DECN        ; Decrement the 16-bit count.
        RTS

DECN                    ; DECN Decrement the 16-bit count ${ZEE}{ZED} by one.
        LDA ZED
        SEC
        SBC #1
        STA ZED
        BCS DECOK
        DEC ZEE
DECOK
        RTS

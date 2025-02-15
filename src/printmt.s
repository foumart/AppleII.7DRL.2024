        ORG $1D00

ZEB     EQU $EB         ; 235 LOW BYTE OF TEXT START/POINTER (0 DECIMAL = $00)
ZEC     EQU $EC         ; 236 HIGH BYTE TEXT START/POINER (16 DECIMAL = $10)
ZED     EQU $ED         ; 237 LOW BYTE OF TEXT LENGTH
ZEE     EQU $EE         ; 238 HIGH BYTE OF TEXT LENGTH
ZFA     EQU $FE         ; 250 SKIP FROM BEGINNING LOW BYTE
ZFB     EQU $FB         ; 251 SKIP FROM BEGINNING HIGH BYTE
ZFC     EQU $FC         ; 252 SKIP BEFORE END LOW BYTE
ZFD     EQU $FD         ; 253 SKIP BEFORE END HIGH BYTE

START
        LDY #$00        ; Set Y = 0 for indirect addressing

LOOP
        ;LDA ZFA
        ;CMP #$00        ; If ZFA low byte is not 0, decrement ZFA
        ;BEQ ;

        ;LDA ZFB
        ;CMP #$00        ; If ZFB high byte is not 0, decrement ZFB
        ;BEQ DECSTH

        LDA ZED         ; Check if any bytes remain at ${ZEE}{ZED}
        ORA ZEE         ; and if both are ero, then complete.
        BEQ DONEFIL

PRTCHAR

        LDA (ZEB),Y     ; Get next byte from file
        SEC             ; Set the carry flag (required before SBC)
        SBC #$80        ; Subtract $80 (128) from the value in A

        JSR $FDED       ; OSWRCH prints the character

SKIP
        JSR INCPT       ; Increment pointer and decrement count.
        JMP LOOP

;DECSTL
        ;DEC ZFA         ; after ZFA low byte decrement,
        ;CMP #$00        ; If ZFA low byte IS NOT 0,
        ;BEQ SKIP        ; then we are skipping the current character

        ;LDA ZFB         ; but when ZFA becomes 0, we check if ZFB has to be reduZEBd as well
        ;CMP #$00        ; If ZFB high byte IS NOT 0 then skip
        ;BEQ SKIP

        ;JMP PRTCHAR     ; otherwise we are not skipping any more and we print the character

;DECSTH
        ;DEC ZFB
        ;CMP #$00        ; If ZFB high byte IS NOT 0,
        ;BEQ SETZFA      ; then set ZFA to 255 and skip

        ;JMP PRTCHAR     ; otherwise print the character

;SETZFA
        ;LDA #$FF        ; Set ZFA to 255
        ;STA ZFA
        ;JMP SKIP

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

        ORG $4000            ; Load at $4000

        LDY #$00            ; Ensure Y = 0 for indirect addressing

LOOP    LDA $F2             ; Check if count (16-bit) is zero
        ORA $F3
        BEQ DONE

        LDA ($F0),Y         ; Load byte from text pointer

        JSR $FDED           ; Print using Apple II CHROUT

        INC $F0             ; Increment pointer (low byte)
        LDA $F0
        CMP #$00
        BNE SKIP
        INC $F1             ; If low byte wrapped, increment high byte

SKIP    LDA $F2             ; Decrement count (16-bit)
        SEC
        SBC #1
        STA $F2
        BCS NOHIGH
        DEC $F3

NOHIGH  JMP LOOP

DONE    RTS                 ; Return to BASIC

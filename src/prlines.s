    ORG $7C00 ; ENTRY POINT OF THE PROGRAM (31744)

MAIN
    LDA $7CFA       ; Load the current line
    STA $7CF0       ; Store it in the column index variable
    JSR READLOOP    ; Jump to the read loop subroutine
    JMP ENDTXT      ; Jump to the end of text subroutine

READLOOP
    LDA $7CFB       ; Load the temporary character
    BEQ ENDTXT      ; If it's 0, we've reached the end of text
    CMP #$8D        ; Check if the character is line break (141)
    BEQ ENDLINE     ; If it is, jump to end of line subroutine
    JSR TRANSLATE   ; Translate the character if necessary
    JSR PRCHAR      ; Print the character
    INC $7CF0       ; Increment the column index
    JMP READLOOP    ; Continue reading the next character

ENDTXT
    INC $7CFC       ; Increment current line count
    LDA #$00        ; Reset column index
    STA $7CF0       ; Store it in the column index variable
    JMP READLOOP    ; Start reading the next string
    RTS             ; Return from subroutine

ENDLINE
    LDA #$00        ; Load 0 for next line
    STA $7CF0       ; Reset column index
    JSR $FDDA       ; Set the cursor Y position
    JMP READLOOP    ; Continue reading the next character

TRANSLATE
    CMP #$7B        ; Check if the character is '{'
    BEQ TURN_ON_MT
    CMP #$7D        ; Check if the character is '}'
    BEQ TURN_OFF_MT
    CMP #$5B        ; Check if the character is '['
    BEQ TURN_ON_INV
    CMP #$5D        ; Check if the character is ']'
    BEQ TURN_OFF_INV
    CMP #$3B        ; Check if the character is ';'
    BEQ TYPE_BVS
    CMP #$60        ; Check if the character is '`'
    BEQ TYPE_TWO_DOTS
    JMP PRINT_NCH   ; Jump to printing normal character

TURN_ON_MT
    INX             ; D = D + 1
    LDA $7CF0       ; Load current column index
    CLC
    ADC #$30        ; H + X
    TAX             ; Store result in X
    LDA $7CF1       ; Load M$
    JSR $FDF0       ; Set cursor X position
    LDA #$3A        ; Load ":"
    JSR $FDED       ; Print ":"
    JMP READLOOP    ; Continue reading the next character

TURN_OFF_MT
    INX             ; D = D + 1
    LDA $7CF0       ; Load current column index
    CLC
    ADC #$30        ; H + X
    TAX             ; Store result in X
    LDA $7CF1       ; Load N$
    JSR $FDF0       ; Set cursor X position
    LDA #$3A        ; Load ":"
    JSR $FDED       ; Print ":"
    JMP READLOOP    ; Continue reading the next character

TURN_ON_INV
    INX             ; D = D + 1
    LDA $7CF0       ; Load current column index
    CLC
    ADC #$30        ; H + X
    TAX             ; Store result in X
    LDA #$0F        ; Load INVERSE on character
    JSR $FDED       ; Print INVERSE on
    JMP READLOOP    ; Continue reading the next character

TURN_OFF_INV
    INX             ; D = D + 1
    LDA $7CF0       ; Load current column index
    CLC
    ADC #$30        ; H + X
    TAX             ; Store result in X
    LDA #$0E        ; Load INVERSE off character
    JSR $FDED       ; Print INVERSE off
    JMP READLOOP    ; Continue reading the next character

TYPE_BVS
    LDA $7CF0       ; Load current column index
    CLC
    ADC #$30        ; H + X
    TAX             ; Store result in X
    LDA #$5C        ; Load "\" character
    JSR $FDED       ; Print "\"
    JMP READLOOP    ; Continue reading the next character

TYPE_TWO_DOTS
    LDA $7CF0       ; Load current column index
    CLC
    ADC #$30        ; H + X
    TAX             ; Store result in X
    LDA #$3A        ; Load ":" character
    JSR $FDED       ; Print ":"
    JMP READLOOP    ; Continue reading the next character

PRINT_NCH
    LDA $7CF0       ; Load current column index
    CLC
    ADC #$30        ; H + X
    TAX             ; Store result in X
    LDA $7CF1       ; Load B$
    JSR $FDED       ; Print the character
    JMP READLOOP    ; Continue reading the next character

PRCHAR
    LDA $7CF0       ; Load current column index
    CLC
    ADC #$30        ; H + X
    TAX             ; Store result in X
    LDA $7CF1       ; Load the character to print
    JSR $FDED       ; Print the character
    RTS             ; Return from subroutine

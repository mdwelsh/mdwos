.import __STARTUP_LOAD__, __BSS_LOAD__ ; Linker generated

.segment "EXEHDR"
.addr __STARTUP_LOAD__ ; Start address
.word __BSS_LOAD__ - __STARTUP_LOAD__ ; Size

.segment "RODATA"
MSG1: .ASCIIZ "MDW OS v0.1.1"
MSG2: .ASCIIZ "(c) 1979 by Matt Welsh"

.segment "STARTUP"

STRP2 = $CE  ; Free space

JSR $FC58 ; home

LDA #14
STA $24
JSR print
.ASCIIZ "MDW OS v0.1.1"

LDA #$8D ; newline
JSR $FDED
LDA #10
STA $24
JSR print
.ASCIIZ "(c) 1985 by Matt Welsh"

LDA #$8D ; newline
JSR $FDED
JSR $FDED
LDA #12
STA $24
JSR print
.ASCIIZ "Please select one:"

LDA #$8D ; newline
JSR $FDED
JSR $FDED
LDA #6
STA $24
JSR print
.ASCIIZ "1. About Matt"

LDA #$8D ; newline
JSR $FDED
JSR $FDED
LDA #6
STA $24
JSR print
.ASCIIZ "2. Research papers"

LDA #$8D ; newline
JSR $FDED
JSR $FDED
LDA #6
STA $24
JSR print
.ASCIIZ "3. Talks"

LDA #$8D ; newline
JSR $FDED
JSR $FDED
LDA #6
STA $24
JSR print
.ASCIIZ "4. Resume and CV"

LDA #$8D ; newline
JSR $FDED
JSR $FDED
LDA #1
STA $24
JSR print
.ASCIIZ "Your selection: "


JMP spin

print:

  PLA
  STA STRP2
  PLA
  STA STRP2+1

  LDY #0
@printloop:
  INC STRP2
  BNE @noc2  ; If no carry
  INC STRP2+1
@noc2:
  LDA (STRP2),Y
  BEQ @printend
  ORA #$80
  JSR $FDED ; cout

  LDA #$50 ; wait amount
  JSR $FCA8 ; wait


  JMP @printloop
@printend:
  LDA STRP2+1
  PHA
  LDA STRP2
  PHA
  RTS


spin:
  @SPIN: NOP
  JMP @SPIN


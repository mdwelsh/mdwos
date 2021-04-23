.import __STARTUP_LOAD__, __BSS_LOAD__ ; Linker generated

.segment "EXEHDR"
.addr __STARTUP_LOAD__ ; Start address
.word __BSS_LOAD__ - __STARTUP_LOAD__ ; Size

.segment "RODATA"
MSG1: .ASCIIZ "MDW OS v0.1.1"
MSG2: .ASCIIZ "(c) 1979 by Matt Welsh"

.segment "STARTUP"

STRP2 = $CE  ; Address used by print function
; Apple II constants
HOME = $FC58
XCURSOR = $24
NEWLINE = $8D
COUT = $FDED
KEYIN = $FD0C
HGRPAGE = $E6
PAGE0 = $C054
PAGE1 = $C055
HGR = $F3E2
HGR2 = $F3D8
HCLR = $F3F2
TEXT = $FB36
HPOSN = $F411
WAIT = $FCA8
HGRPAGE1 = $2000


; Main program
JSR main_menu
JMP spin

main_menu:
  JSR HOME

  LDA #14
  STA XCURSOR
  JSR print
  .ASCIIZ "MDW OS v0.1.1"

  LDA #NEWLINE
  JSR COUT
  LDA #10
  STA XCURSOR
  JSR print
  .ASCIIZ "(c) 1985 by Matt Welsh"

  LDA #NEWLINE
  JSR COUT
  JSR COUT
  LDA #12
  STA XCURSOR
  JSR print
  .ASCIIZ "Please select one:"

  LDA #NEWLINE
  JSR COUT
  JSR COUT
  LDA #6
  STA XCURSOR
  JSR print
  .ASCIIZ "1. About Matt"

  LDA #NEWLINE
  JSR COUT
  JSR COUT
  LDA #6
  STA XCURSOR
  JSR print
  .ASCIIZ "2. Research papers"

  LDA #NEWLINE
  JSR COUT
  JSR COUT
  LDA #6
  STA XCURSOR
  JSR print
  .ASCIIZ "3. Talks"

  LDA #NEWLINE
  JSR COUT
  JSR COUT
  LDA #6
  STA XCURSOR
  JSR print
  .ASCIIZ "4. Resume and CV"

  LDA #NEWLINE
  JSR COUT
  JSR COUT
  LDA #6
  STA XCURSOR
  JSR print
  .ASCIIZ "5. About this website"

  LDA #NEWLINE ; newline
  JSR COUT
  JSR COUT
  LDA #1
  STA XCURSOR
  JSR print
  .ASCIIZ "Your selection: "

@menu_input:
  JSR KEYIN
  JSR COUT ; echo out

@menu_1:
  CMP #'1'|$80
  BNE @menu_2
  JSR about_matt
  JMP main_menu

@menu_2:
  CMP #'2'|$80
  BNE @menu_3
  JSR papers
  JMP main_menu

@menu_3:
  CMP #'3'|$80
  BNE @menu_4
  JSR talks
  JMP main_menu

@menu_4:
  CMP #'4'|$80
  BNE @menu_5
  JSR resume
  JMP main_menu

@menu_5:
  CMP #'5'|$80
  BNE @menu_bad
  JSR about_website
  JMP main_menu

@menu_bad:
  LDA #NEWLINE ; newline
  JSR COUT
  LDA #1
  STA XCURSOR
  JSR print
  .ASCIIZ "Bad input!"
  JMP @menu_input


about_matt:
  JSR HGR2
  LDA #NEWLINE
  JSR COUT
  ; Start DOS command
  LDA #$84
  JSR COUT
  JSR print
  .ASCIIZ "BLOAD MDWIMG,A$4000"
  LDA #NEWLINE
  JSR COUT

  JSR $FD0C ; keyin
  JSR TEXT
  RTS

papers:
  JSR HOME

  LDA #4
  STA XCURSOR
  JSR print
  .ASCIIZ "Matt Welsh - Papers"

  LDA #NEWLINE
  JSR COUT
  LDA #4
  STA XCURSOR
  JSR print
  .ASCIIZ "-------------------"

  LDA #NEWLINE
  JSR COUT
  JSR COUT
  LDA #4
  STA XCURSOR
  JSR print
  .ASCIIZ "-- Press any key to go back --"
  JSR $FD0C ; keyin
  RTS

talks:
  JSR HOME

  LDA #4
  STA XCURSOR
  JSR print
  .ASCIIZ "Matt Welsh - Talks"

  LDA #NEWLINE
  JSR COUT
  LDA #4
  STA XCURSOR
  JSR print
  .ASCIIZ "------------------"

  LDA #NEWLINE
  JSR COUT
  JSR COUT
  LDA #4
  STA XCURSOR
  JSR print
  .ASCIIZ "-- Press any key to go back --"
  JSR $FD0C ; keyin
  RTS

resume:
  JSR HOME

  LDA #4
  STA XCURSOR
  JSR print
  .ASCIIZ "Matt Welsh - Resume and CV"

  LDA #NEWLINE
  JSR COUT
  LDA #4
  STA XCURSOR
  JSR print
  .ASCIIZ "--------------------------"

  LDA #NEWLINE
  JSR COUT
  JSR COUT
  LDA #4
  STA XCURSOR
  JSR print
  .ASCIIZ "-- Press any key to go back --"
  JSR $FD0C ; keyin
  RTS

about_website:
  JSR HOME
  LDA #4
  STA XCURSOR
  JSR print
  .ASCIIZ "About this website"

  LDA #NEWLINE
  JSR COUT
  LDA #4
  STA XCURSOR
  JSR print
  .ASCIIZ "------------------"

  LDA #NEWLINE
  JSR COUT
  JSR COUT
  JSR print
  .ASCIIZ "This site is written by hand in 6502"

  LDA #NEWLINE
  JSR COUT
  JSR print
  .ASCIIZ "assembly code, running on AppleIIjs, a"

  LDA #NEWLINE
  JSR COUT
  JSR print
  .ASCIIZ "JavaScript-based Apple ][ emulator."

  LDA #NEWLINE
  JSR COUT
  JSR COUT
  JSR print
  .ASCIIZ "For more details and code, check out:"

  LDA #NEWLINE
  JSR COUT
  JSR COUT
  JSR print
  .ASCIIZ "https://github.com/mdwelsh/6502/mdwos"

  LDA #NEWLINE
  JSR COUT
  JSR print
  .ASCIIZ "https://www.scullinsteel.com/apple2/"

  LDA #NEWLINE
  JSR COUT
  JSR COUT
  LDA #4
  STA XCURSOR
  JSR print
  .ASCIIZ "-- Press any key to go back --"
  JSR $FD0C ; keyin
  RTS


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
  JSR COUT ; cout

  LDA #$50 ; wait amount
  JSR WAIT

  JMP @printloop
@printend:
  LDA STRP2+1
  PHA
  LDA STRP2
  PHA
  RTS

keyin:
@keyloop:
  LDA $C000
  BPL @keyloop
  STA $C010
  RTS

spin:
  @SPIN: NOP
  JMP @SPIN


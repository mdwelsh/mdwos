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
OPENLINKURL = $C06A
OPENLINKURL2 = $C06B
OPENLINK = $C06C

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
  .ASCIIZ "2. Research papers and talks"

  LDA #NEWLINE
  JSR COUT
  JSR COUT
  LDA #6
  STA XCURSOR
  JSR print
  .ASCIIZ "3. Resume and CV"

  LDA #NEWLINE
  JSR COUT
  JSR COUT
  LDA #6
  STA XCURSOR
  JSR print
  .ASCIIZ "4. About this website"

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
  JSR pubs
  JMP main_menu

@menu_3:
  CMP #'3'|$80
  BNE @menu_4
  JSR resume
  JMP main_menu

@menu_4:
  CMP #'4'|$80
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

pubs:
  JSR HOME

  LDA #4
  STA XCURSOR
  JSR print
  .ASCIIZ "Matt Welsh - Publications and talks"

  LDA #NEWLINE
  JSR COUT
  LDA #4
  STA XCURSOR
  JSR print
  .ASCIIZ "-----------------------------------"

  LDA #NEWLINE
  JSR COUT
  JSR COUT

  JSR print
  .ASCIIZ "Would you like me to open a link to"
  LDA #NEWLINE
  JSR COUT

  JSR print
  .ASCIIZ "my research papers page (Y/N)?"

@pubs_input:
  JSR KEYIN
  JSR COUT ; echo out

@pubs_y:
  CMP #'Y'|$80
  BNE @pubs_n
  JSR doopenlink
  .ASCIIZ "https://www.mdw.la/pubs/"
  RTS

@pubs_n:
  CMP #'N'|$80
  BNE @pubs_bad
  LDA #NEWLINE
  JSR COUT
  JSR COUT
  LDA #4
  STA XCURSOR
  JSR print
  .ASCIIZ "-- Press any key to go back --"
  JSR $FD0C ; keyin
  RTS

@pubs_bad:
  LDA #NEWLINE ; newline
  JSR COUT
  LDA #1
  STA XCURSOR
  JSR print
  .ASCIIZ "Bad input! Please type Y or N."
  JMP @pubs_input

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

  JSR print
  .ASCIIZ "Would you like me to open a link to"
  LDA #NEWLINE
  JSR COUT

  JSR print
  .ASCIIZ "my resume (Y/N)?"

@resume_input:
  JSR KEYIN
  JSR COUT ; echo out

@resume_y:
  CMP #'Y'|$80
  BNE @resume_n
  JSR doopenlink
  .ASCIIZ "https://www.mdw.la/mattwelsh-resume.pdf"
  JMP @ask_cv

@resume_n:
  CMP #'N'|$80
  BNE @resume_bad
  JMP @ask_cv

@resume_bad:
  LDA #NEWLINE ; newline
  JSR COUT
  LDA #1
  STA XCURSOR
  JSR print
  .ASCIIZ "Bad input! Please type Y or N."
  JMP @resume_input

@ask_cv:
  LDA #NEWLINE
  JSR COUT
  JSR COUT
  JSR print
  .ASCIIZ "Would you like me to open a link to"
  LDA #NEWLINE
  JSR COUT

  JSR print
  .ASCIIZ "my full CV (Y/N)?"

@cv_input:
  JSR KEYIN
  JSR COUT ; echo out

@cv_y:
  CMP #'Y'|$80
  BNE @cv_n
  JSR doopenlink
  .ASCIIZ "https://www.mdw.la/mattwelsh-cv.pdf"
  RTS

@cv_n:
  CMP #'N'|$80
  BNE @cv_bad
  LDA #NEWLINE
  JSR COUT
  JSR COUT
  LDA #4
  STA XCURSOR
  JSR print
  .ASCIIZ "-- Press any key to go back --"
  JSR $FD0C ; keyin
  RTS

@cv_bad:
  LDA #NEWLINE ; newline
  JSR COUT
  LDA #1
  STA XCURSOR
  JSR print
  .ASCIIZ "Bad input! Please type Y or N."
  JMP @cv_input


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
  ; On entry, the return address-1 is on the stack.
  ; This will be the first byte of the string we want to print.
  ; So, we read that 16-bit address off the stack and store
  ; it in STPR2 / STRP2+1.
  PLA
  STA STRP2
  PLA
  STA STRP2+1

  LDY #0
@printloop:
  ; We inc here because the address we pulled off the stack was
  ; the return address-1.
  INC STRP2
  BNE @noc2  ; If no carry
  INC STRP2+1
@noc2:
  ; Load the next character
  LDA (STRP2),Y
  ; If null, stop printing.
  BEQ @printend
  ; Print it out.
  ORA #$80
  JSR COUT ; cout

  LDA #$50 ; wait amount
  JSR WAIT

  JMP @printloop
@printend:
  ; Now, we take the current pointer into the string we were printing
  ; and push it back on the stack as the return address.
  ; This will resume execution after the string.
  LDA STRP2+1
  PHA
  LDA STRP2
  PHA
  RTS

; Open a link by writing a pointer to the memory location
; OPENLINKURL/OPENLINKURL+1.
doopenlink:
  ; On entry, the return address-1 is on the stack.
  ; This will be the first byte of the URL we want to open.
  ; So, we read that 16-bit address off the stack and store
  ; it in OPENLINKURL / OPENLINKURL+1.
  PLA
  STA OPENLINKURL
  STA STRP2
  PLA
  STA OPENLINKURL2
  STA STRP2+1

  ; Before we open the link, we need to advance the return address
  ; to the end of the URL string.
  LDY #0
@skipurlloop:
  ; We inc here because the address we pulled off the stack was
  ; the return address-1.
  INC STRP2
  BNE @noc3  ; If no carry
  INC STRP2+1
@noc3:
  ; Load the next character
  LDA (STRP2),Y
  ; If null, stop skipping.
  BEQ @skipurlend
  JMP @skipurlloop
@skipurlend:
  ; Now, we take the current pointer into the string we were skipping
  ; and push it back on the stack as the return address.
  ; This will resume execution after the string.
  LDA STRP2+1
  PHA
  LDA STRP2
  PHA

  ; Finally, jump to the link.
  LDA OPENLINK

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


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
TEXTMODE = $32
NORMAL = $FF
INVERSE = $3F
HOME = $FC58
XCURSOR = $24
YCURSOR = $25
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
PRBYTE = $FDDA        ; Print accum as hex byte
PREAD = $FB1E         ; Game controller, X=0-3, Y=value
PBTN0 = $C061

OPENLINKURL = $C06A   ; MDWOS special
OPENLINKURL2 = $C06B  ; MDWOS special
OPENLINK = $C06C      ; MDWOS special

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
  JSR COUT
  LDA #1
  STA XCURSOR
  LDA #NEWLINE ; newline
  JSR COUT
  JSR print
  .ASCIIZ " < Click on selection or type 1-4 >"

@main_menu_loop:
  ; Read paddle 0 button
  BIT PBTN0
  BPL @main_menu_key
  ; Otherwise, button was clicked.

  LDA #4
  STA XCURSOR
  STA YCURSOR

  ; Read paddle 1 (y-position)
  LDX #1
  JSR PREAD
  TYA
  JSR PRBYTE

  CPY #$32  ; Lowest y-position of link
  BCC @check_link2
  CPY #$3B  ; Highest y-position of link
  BCS @check_link2
  JSR about_matt
  JMP main_menu

@check_link2:
  CPY #$47  ; Lowest y-position of link
  BCC @check_link3
  CPY #$50  ; Highest y-position of link
  BCS @check_link3
  JSR pubs
  JMP main_menu

@check_link3:
  CPY #$5A  ; Lowest y-position of link
  BCC @check_link4
  CPY #$64  ; Highest y-position of link
  BCS @check_link4
  JSR resume
  JMP main_menu

@check_link4:
  CPY #$70  ; Lowest y-position of link
  BCC @main_menu_key
  CPY #$79  ; Highest y-position of link
  BCS @main_menu_key
  JSR about_website
  JMP main_menu

@main_menu_key:
  ; Check for keypress
  LDA $C000
  BPL @main_menu_loop
  STA $C010
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
  JMP @main_menu_loop


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

@about_matt_loop:
  BIT PBTN0
  BPL @about_matt_key
  ; Otherwise, button was clicked.
  JSR TEXT
  RTS
@about_matt_key:
  ; Check for keypress
  LDA $C000
  BPL @about_matt_loop
  STA $C010
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
  JSR print
  .ASCIIZ "   (these links are clickable!)"

  LDA #NEWLINE
  JSR COUT
  JSR COUT
  LDA #INVERSE
  STA TEXTMODE
  JSR print
  .ASCIIZ "GITHUB.COM/MDWELSH/MDWOS-6502"

  LDA #NEWLINE
  JSR COUT
  JSR COUT
  JSR print
  .ASCIIZ "WWW.SCULLINSTEEL.COM/APPLE2/"

  LDA #NORMAL
  STA TEXTMODE
  LDA #NEWLINE
  JSR COUT
  JSR COUT
  LDA #4
  STA XCURSOR
  JSR print
  .ASCIIZ "-- Press any key to go back --"

@about_loop:
  ; Read paddle 0 button
  BIT PBTN0
  BPL @about_key
  ; Otherwise, button was clicked.

  ; Read paddle 1 (y-position)
  LDX #1
  JSR PREAD

  CPY #$65  ; Lowest y-position of first link
  BCC @check_link2
  CPY #$6F  ; Highest y-position of first link
  BCS @check_link2
  ; Now we know we are on the link.
  JSR doopenlink
  .ASCIIZ "https://github.com/mdwelsh/mdwos-6502"
  RTS

@check_link2:
  CPY #$7A  ; Lowest y-position of second link
  BCC @about_key
  CPY #$84  ; Highest y-position of second link
  BCS @about_key
  ; Now we know we are on the link.
  JSR doopenlink
  .ASCIIZ "https://www.scullinsteel.com/apple2/"
  RTS

@about_key:
  ; Check for keypress
  LDA $C000
  BPL @about_loop
  STA $C010
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

;  LDA #$10 ; wait amount
;  JSR WAIT

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


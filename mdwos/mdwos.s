.import __STARTUP_LOAD__, __BSS_LOAD__ ; Linker generated

.segment "EXEHDR"
.addr __STARTUP_LOAD__ ; Start address
.word __BSS_LOAD__ - __STARTUP_LOAD__ ; Size

.segment "RODATA"
.byte 0 ; XXX MDW - Use this elsewhere.

.segment "STARTUP"

PRINTPTR = $CE  ; Address used by print function
LINKPTR = $CE   ; Address used by showlink function
LINKJUMP = $ED  ; Address used by dolinks

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Main program

; Main program
JSR main_menu

main_menu:
  JSR HOME

  LDA #14
  STA XCURSOR
  JSR print
  .ASCIIZ "MDW OS v0.1.1"
  .byte 0

  LDA #NEWLINE
  JSR COUT
  LDA #10
  STA XCURSOR
  JSR print
  .ASCIIZ "(c) 1985 by Matt Welsh"
  .byte 0

  LDA #NEWLINE
  JSR COUT
  JSR COUT
  LDA #12
  STA XCURSOR
  JSR print
  .ASCIIZ "Please select one:"
  .ASCIIZ " "
  .byte 0

  ; Store address of our links in LINKPTR
  LDA #<main_menu_links
  STA LINKPTR
  LDA #>main_menu_links
  STA LINKPTR+1
  JSR showlinks

  LDA #NEWLINE ; newline
  JSR COUT
  JSR print
  .ASCIIZ " < Click on selection or type 1-5 >"
  .byte 0

  ; Check for input
  LDA #<main_menu_links
  STA LINKPTR
  LDA #>main_menu_links
  STA LINKPTR+1
  JMP dolinks

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; About Matt page

about_matt:
  JSR HGR2
  LDA #NEWLINE
  JSR COUT
  ; Start DOS command
  LDA #$84
  JSR COUT
  JSR print
  .ASCIIZ "BLOAD MDWIMG,A$4000"
  .byte 0
  LDA #NEWLINE
  JSR COUT

@about_matt_loop:
  BIT PBTN0
  BPL @about_matt_key
  ; Otherwise, button was clicked.
  JSR TEXT
  JMP main_menu
@about_matt_key:
  ; Check for keypress
  LDA $C000
  BPL @about_matt_loop
  STA $C010
  JMP main_menu

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Publications and talks page

pubs:
  JSR HOME

  LDA #4
  STA XCURSOR
  JSR print
  .ASCIIZ "Matt Welsh - Publications and talks"
  .byte 0

  LDA #NEWLINE
  JSR COUT
  LDA #4
  STA XCURSOR
  JSR print
  .ASCIIZ "-----------------------------------"
  .byte 0

  LDA #NEWLINE
  JSR COUT
  JSR COUT

  JSR print
  .ASCIIZ "Would you like me to open a link to"
  .byte 0
  LDA #NEWLINE
  JSR COUT

  JSR print
  .ASCIIZ "my research papers page (Y/N)?"
  .byte 0

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
  .byte 0
  JSR KEYIN
  RTS

@pubs_bad:
  LDA #NEWLINE ; newline
  JSR COUT
  LDA #1
  STA XCURSOR
  JSR print
  .ASCIIZ "Bad input! Please type Y or N."
  .byte 0
  JMP @pubs_input

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Resume and CV page

resume:
  JSR HOME

  LDA #4
  STA XCURSOR
  JSR print
  .ASCIIZ "Matt Welsh - Resume and CV"
  .byte 0

  LDA #NEWLINE
  JSR COUT
  LDA #4
  STA XCURSOR
  JSR print
  .ASCIIZ "--------------------------"
  .byte 0

  LDA #NEWLINE
  JSR COUT
  JSR COUT

  JSR print
  .ASCIIZ "Would you like me to open a link to"
  .byte 0
  LDA #NEWLINE
  JSR COUT

  JSR print
  .ASCIIZ "my resume (Y/N)?"
  .byte 0

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
  .byte 0
  JMP @resume_input

@ask_cv:
  LDA #NEWLINE
  JSR COUT
  JSR COUT
  JSR print
  .ASCIIZ "Would you like me to open a link to"
  .byte 0
  LDA #NEWLINE
  JSR COUT

  JSR print
  .ASCIIZ "my full CV (Y/N)?"
  .byte 0

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
  .byte 0
  JSR KEYIN
  RTS

@cv_bad:
  LDA #NEWLINE ; newline
  JSR COUT
  LDA #1
  STA XCURSOR
  JSR print
  .ASCIIZ "Bad input! Please type Y or N."
  .byte 0
  JMP @cv_input

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; About this website page

about_website:
  JSR HOME
  JSR print
  .ASCIIZ "About this website"
  .ASCIIZ "------------------"
  .ASCIIZ " "
  .ASCIIZ " "
  .byte 0

  JSR print
  .ASCIIZ "This site was built in hand-coded 6502"
  .ASCIIZ "assembly language, based on AppleIIjs,"
  .ASCIIZ "a JavaScript-based Apple ][ emulator."
  .ASCIIZ "For more info, check out these links!"
  .ASCIIZ " "
  .byte 0

  ; Store address of our links in LINKPTR
  LDA #<about_links
  STA LINKPTR
  LDA #>about_links
  STA LINKPTR+1
  JSR showlinks

  ; Check for input
  LDA #<about_links
  STA LINKPTR
  LDA #>about_links
  STA LINKPTR+1
  JMP dolinks

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Utilities
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; print
;;
;; Prints ASCIIZ strings following the `jsr print` instruction to the screen,
;; with a newline in between each line. If the string starts with a zero byte
;; it is the last string in the sequence.

print:
  ; On entry, the return address-1 is on the stack.
  ; This will be the first byte of the string we want to print.
  ; So, we read that 16-bit address off the stack and store
  ; it in PRINTPTR / PRINTPTR+1.
  PLA
  STA PRINTPTR
  PLA
  STA PRINTPTR+1

  ; The address we pulled off the stack was the return
  ; address-1.
  INC PRINTPTR
  BNE @print_line
  INC PRINTPTR+1

@print_line:
  ; Load the next character
  LDY #0
  LDA (PRINTPTR),Y
  ; If null, stop printing.
  BEQ @print_line_end
  ; Print char
  ORA #$80
  JSR COUT
  ; Increment the pointer
  INC PRINTPTR
  BNE @print_noc
  INC PRINTPTR+1
@print_noc:
  JMP @print_line

@print_line_end:
  ; Newline
  LDA #NEWLINE
  JSR COUT
  ; Check to see if there is another line to print.
  INC PRINTPTR
  BNE @print_end_noc
  INC PRINTPTR+1
@print_end_noc:
  LDY #0
  LDA (PRINTPTR),Y
  ; If non-null, print next line.
  BNE @print_line
  ; Now, we take the current pointer into the string we were printing
  ; and push it back on the stack as the return address.
  ; This will resume execution after the string.
  LDA PRINTPTR+1
  PHA
  LDA PRINTPTR
  PHA
  RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; doopenlink
;;
;; Open a web page link. This is done by triggering a hack in the appleiijs 
;; emulator that I added, which pulls the URL out of the memory address pointed
;; to by OPENLINKURL,OPENLINKURL2.
doopenlink:
  ; On entry, the return address-1 is on the stack.
  ; This will be the first byte of the URL we want to open.
  ; So, we read that 16-bit address off the stack and store
  ; it in OPENLINKURL / OPENLINKURL+1.
  PLA
  STA OPENLINKURL
  STA PRINTPTR
  PLA
  STA OPENLINKURL2
  STA PRINTPTR+1

  ; Before we open the link, we need to advance the return address
  ; to the end of the URL string.
  LDY #0
@skipurlloop:
  ; We inc here because the address we pulled off the stack was
  ; the return address-1.
  INC PRINTPTR
  BNE @noc3  ; If no carry
  INC PRINTPTR+1
@noc3:
  ; Load the next character
  LDA (PRINTPTR),Y
  ; If null, stop skipping.
  BEQ @skipurlend
  JMP @skipurlloop
@skipurlend:
  ; Now, we take the current pointer into the string we were skipping
  ; and push it back on the stack as the return address.
  ; This will resume execution after the string.
  LDA PRINTPTR+1
  PHA
  LDA PRINTPTR
  PHA

  ; Finally, jump to the link.
  ; Obviously this won't work on a non-MDWOS enabled machine.
  LDA OPENLINK
  RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; showlinks
;; Show a list of links, each with a corresponding key shortcut.
;; 
;; LINKPTR contains first link of a page, with format as described below.
showlinks:
@shownextlink:
  LDY #0
  LDA (LINKPTR),Y  ; Index of link
  BEQ @lastlink

  ; Advance LINKPTR by 65bytes so we get the first byte of the link text.
  INC LINKPTR
  BNE @showlinks_inc2
  INC LINKPTR+1
@showlinks_inc2:
  INC LINKPTR
  BNE @showlinks_inc3
  INC LINKPTR+1
@showlinks_inc3:
  INC LINKPTR
  BNE @showlinks_inc4
  INC LINKPTR+1
@showlinks_inc4:
  INC LINKPTR
  BNE @showlinks_inc5
  INC LINKPTR+1
  ; We only move 4 bytes here since we increment again in the loop below.

@showlinks_inc5:
  LDY #0
@showlinks_printloop:
  INC LINKPTR    ; Increment linkindex to get first byte of character.
  BNE @showlinks_noc
  INC LINKPTR+1
@showlinks_noc:
  ; Load the next character. Note that Y does not change in this loop.
  LDA (LINKPTR),Y
  ; If null, stop printing.
  BEQ @showlinks_printend
  ; Print it out.
  ORA #$80
  JSR COUT
  JMP @showlinks_printloop
@showlinks_printend:
  LDA #NEWLINE
  JSR COUT
  JSR COUT
  INC LINKPTR    ; Go to the beginning of the next link.
  BNE @shownextlink
  INC LINKPTR+1
  JMP @shownextlink
@lastlink:
  RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; dolinks
;; Process input for a list of links, watching for keyboard and mouse input.
;; Loops until link is pressed.
;; 
;; LINKPTR contains first link of a page, with format as described below.
dolinks:

@dolinks_loop:
  BIT PBTN0 ; Read paddle 0 button.
  BPL @dolinks_key ; Button not pressed, jump to keyboard processing.
  LDX #1    ; Read paddle 1 (y-position)
  JSR PREAD ; Read paddle position into y.
  TYA ; Transfer paddle position to A.
  TAX ; Transfer paddle position to X.

  LDY #0
@dolinks_check:
  LDA (LINKPTR),Y
  BEQ @dolinks_loop ; Done with all links, start over.

  INY ; Index of link lower y-position
  TXA ; Paddle position into A
  CMP (LINKPTR),Y
  BCC @no_hit

  INY ; Index of link upper y-position
  TXA ; Paddle position into A
  CMP (LINKPTR),Y
  BCS @no_hit

  ; Now we know we are on the link.
  ; Store jump address in LINKJUMP.
  INY
  LDA (LINKPTR),Y
  STA LINKJUMP
  INY
  LDA (LINKPTR),Y
  STA LINKJUMP+1
  JMP (LINKJUMP)

@no_hit:
  ; Skip over link text.
  INY
  LDA (LINKPTR),Y
  BNE @no_hit
  ; Now we are at the next link.
  JMP @dolinks_check

@dolinks_key:
  ; Check for keypress
  LDA $C000
  BPL @dolinks_loop ; If nothing pressed.
  STA $C010 ; Clear keyboard strobe

  JSR PRBYTE ; Debugging
  TAX ; Stash key in X
  
  LDY #0
@dolinks_key_check:
  LDA #'<'|$80
  JSR COUT
  TYA ; Debugging - Print Y index
  JSR PRBYTE
  LDA #'>'|$80
  JSR COUT
  TXA ; Debugging - print X val (key)
  JSR PRBYTE
  LDA (LINKPTR),Y
  JSR PRBYTE ; Debugging - print index

  LDA (LINKPTR),Y ; Get index
  BEQ @dolinks_loop ; Done with all links, start over.

  LDA (LINKPTR),Y ; Get index
  JSR PRBYTE ; Debugging, print index again

  TXA ; Get keypress into A
  CMP (LINKPTR),Y   ; Does key match index?
  BNE @no_key_hit

  ; Key matched link.
  LDA #'*'|$80 ; Debug
  JSR COUT ; Debug

  INY ; Skip paddle position indices
  INY
  ; Store jump address in LINKJUMP
  INY
  LDA (LINKPTR),Y
  STA LINKJUMP
  JSR PRBYTE
  INY
  LDA (LINKPTR),Y
  STA LINKJUMP+1
  JSR PRBYTE

  LDA #'*'|$80 ; Debug
  JSR COUT ; Debug
  JMP (LINKJUMP)

@no_key_hit:
  LDA #$33   ; Debugging
  JSR PRBYTE ; Debugging
  INY ; Skip paddle position indices
  INY
  INY ; Skip jump word
  INY
@no_key_hit_loop:
  ; Skip over link text.
  INY

  TYA ; Debug
  JSR PRBYTE ; Debug
  LDA (LINKPTR),Y ; Debug
  JSR PRBYTE ; Debug

  LDA (LINKPTR),Y
  BNE @no_key_hit_loop

  ; Now we are at the next link.
  INY
  LDA #'['|$80
  JSR COUT
  TYA
  JSR PRBYTE
  LDA #']'|$80
  JSR COUT
  LDA (LINKPTR),Y
  JSR PRBYTE
  JMP @dolinks_key_check

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Page data.

;; Individual link format:
;;   - byte: index of link (if 0, this is the last link on ths page)
;;   - byte: paddle Y min
;;   - byte: paddle Y max
;;   - work: Address to jsr when link clicked
;;   - asciiz: Link text

main_menu_links:
  .byte '1'|$80,$65,$6F
  .word about_matt
  .asciiz "  1. About Matt"
  .byte '2'|$80,$7a,$84
  .word pubs
  .asciiz "  2. Research papers and talks"
  .byte '3'|$80,$7a,$84
  .word resume
  .asciiz "  3. My resume and CV"
  .byte '4'|$80,$7a,$84
  .word about_website
  .asciiz "  4. Enter the dungeon"
  .byte '5'|$80,$7a,$84
  .word about_website
  .asciiz "  5. About this website"
  .byte 0

about_links:
  .byte '1'|$80,$65,$6F
  .word about_link_1_jump
  .asciiz "[1] github.com/mdwelsh/mdwos-6502"
  .byte '2'|$80,$7a,$84
  .word about_link_2_jump
  .asciiz "[2] www.scullinsteel.com/apple2"
  .byte '3'|$80,$7a,$84
  .word main_menu
  .asciiz "[3] Go back"
  .byte 0

about_link_1_jump:
  jsr doopenlink
  .asciiz "https://github.com/mdwelsh/mdwos-6502"
  jmp about_website

about_link_2_jump:
  jsr doopenlink
  .asciiz "https://www.scullinsteel.com/apple2/"
  jmp about_website

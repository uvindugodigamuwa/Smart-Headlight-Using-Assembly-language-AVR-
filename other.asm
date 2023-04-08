;
; other.asm
;
; Created: 11/29/2022 12:26:01 AM
; Author : uvind
;

.include "m328pdef.inc"
ldi r16 , 0xFF
out DDRB,r16
ldi r16 , 0x00
out DDRD,r16

loop:

in R17,PIND
out PORTB,R17

rjmp loop


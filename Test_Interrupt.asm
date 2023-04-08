; Lab02_task2
; E/18/114
; Godigamuwa W.M
; Group EE13
;https://eleccelerator.com/avr-timer-calculator/
;https://www.youtube.com/watch?v=cAui6116XKc&list=RDCMUCL1w3L33s0phNYGuvMLS-Eg&start_radio=1&rv=cAui6116XKc&t=17
.include "m328pdef.inc"
.org 0x0000 ; reset vector 
rjmp main ; restart the main program 
.org 0x0016; interrupt vector
rjmp aa;e “INT0_HANDLE”
main:
ldi r21,0xFF
out ddrb,r21
cli  ;global interrup dissable
ldi r21,1<<WGM12
sts TCCR1B,r21
ldi r21,LOW(20000)
sts OCR1AL,r21
ldi r21,HIGH(20000)
sts OCR1AH,r21
ldi r21,1<<OCIE1A
sts TIMSK1,r21 
sei ;global interrupt enable
ldi r21,1<<cs12|1<<cs10
ori TCCR1B,r21



main1:
ldi r21,LOW(RAMEND)
out SPL,r21 ;stack pointer low set to ramend low bits
ldi r21,HIGH(RAMEND)
out SPH,r21;stack pointer low set to ramend low bits
rjmp main1

aa:
ldi r17,0xFF
out PORTB, r17
reti  ;return from interrupt

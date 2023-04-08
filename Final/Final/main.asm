; Lab02_task2
; E/18/114
; Godigamuwa W.M
; Group EE13
.include "m328pdef.inc"
.cseg
.org 0x0000 ; reset vector 
rjmp main ; restart the main program 
.org 0x0002 ; interrupt vector
rjmp INT0HANDLE ; jump to the interrupt subroutine “INT0_HANDLE”
;.org 0x0016; interrupt vector
;rjmp aa;e “INT0_HANDLE”


main:

cli;dissable global interrupt

;configure registers for pwm
ldi R18,1<<COM0A1|1<<WGM01|1<<WGM00
out TCCR0A,R18
ldi R19,1<<CS00
out TCCR0B,R19

;configure registers for timer

;configure registers for interrupts by hall effect sensor
ldi r17, 0b00000010
sts EICRA, r17  ;interrupt happens in both rising and falling edges
ldi r17, 0b00000001
out EImsk, r17  ;enable external interrupt

;set registers for inputs and outputs
ldi r21,0xFF
out ddrb,r21
cbi DDRD,2
sbi DDRD,6 ;set as output 
sbi DDRD,3
cbi DDRD,0
cbi DDRC,0
cbi DDRC,1
;give initial conditions
ldi R20,0x96; env
ldi R21,0x00
ldi R22,0x40;ldr2
ldi R24,0x00
ldi R27,0x06
ldi R26,0x00
ldi R25,0x00
ldi R23,0x00
sei
;check for environment light conditions
envi:
ldi r30,LOW(RAMEND)
out SPL,r30 ;stack pointer low set to ramend low bits
ldi r30,HIGH(RAMEND)
out SPH,r30;stack pointer low set to ramend low bits
ldi R30,25
ldi R29,25
ldi R28,250
SBIS PIND,0;check if engine is started.
rjmp clk;if not, delay loop is started
;configure registers for ADC for LDR 1
ldi R16,0<<REFS0|0<<REFS1  ;Dissable internal vref and select analog input channel
sts ADMUX,R16   
ldi R16,1<<ADEN|1<<ADPS2|1<<ADPS1|1<<ADPS0  ;enable ADC and set pre scaler to 128
sts ADCSRA,R16
	ori R16,1<<ADSC|0<<MUX0   ;start conversion
	sts ADCSRA,R16
wait1:
	lds R16,ADCSRA   ;waiting until conersion ends
	sbrc R16,ADSC   
	rjmp wait1  ;if ADSC bit is cleared,loop ends

lds R17,ADCL ;read ADCL
lds R18,ADCH ;read ADCH
;compare environment intensity level with a pre defined value
cp R20,R17
BRMI frwd;if intensity is low, check for other LDR intensity level
out OCR0A,R21; if high,off the light
rjmp envi;again check for environment light level

frwd:
cp R26,R27
BRMI envi ;if it is high, headlight level to max

;configure registers for ADC for LDR 2
ldi R16,0<<REFS0|0<<REFS1|1<<MUX0  ;Dissable internal vref and select analog input channel
sts ADMUX,R16   
ldi R16,1<<ADEN|1<<ADPS2|1<<ADPS1|1<<ADPS0  ;enable ADC and set pre scaler to 128
sts ADCSRA,R16

	ori R16,1<<ADSC   ;start conversion
	sts ADCSRA,R16
wait2:
	lds R16,ADCSRA   ;waiting until conersion ends
	sbrc R16,ADSC   
	rjmp wait2  ;if ADSC bit is cleared,loop ends

lds R23,ADCL ;read ADCL
lds R18,ADCH ;read ADCH 
;compare Hall effect sensor number of state changes with a pre defined value

;compare LDR2 intensity level with pre defined value

cp R23,R22
BRMI decrs;if it is high,headlight level decreases.

out OCR0A,R17;if above conditions not atchived,headlight level adjust according to environment light level
rjmp envi

maxi: ;function for increase headlight level to maximum
;ldi R30,0x03
;out portb,r30
out OCR0A,R30
rjmp continue

decrs:;function for decrease headlight level to to a pre defined value
ldi r30,0X41
out OCR0A,R30
rjmp envi

clk:
ldi r25,0
sbic PIND,0 ;1
rjmp continue ;2
dec R30 ; 1
brne clk; 1
dec R29; 1
brne clk; 1
dec R28; 1
brne clk; 1
out OCR0A,R21; 1
mov r25,r21
mov r26,r21
rjmp continue; 2
out OCR0A,R21; 1
rjmp envi; 2


INT0HANDLE:;interrupt handling routing for hall effect sensor interrupts
inc r25
mov r26,r25
sbrc r26,7
rjmp loop11
rjmp continue  ;return from interrupt

loop11:
dec r25
rjmp continue

continue:
sei
rjmp envi
;
; test1 ldr.asm
;
; Created: 11/27/2022 1:52:07 AM
; Author : uvind
;

sbi DDRD,0  ;set as output 
cbi DDRC,0  ;set as input
ldi R16,0<<REFS0|0<<REFS1  ;Dissable internal vref and select analog input channel
sts ADMUX,R16   
ldi R16,1<<ADEN|1<<ADPS2|1<<ADPS1|1<<ADPS0  ;enable ADC and set pre scaler to 128
sts ADCSRA,R16
loop:
	ori R16,1<<ADSC   ;start conversion
	sts ADCSRA,R16
wait:
	lds R16,ADCSRA   ;waiting until conersion ends
	sbrc R16,ADSC   
	rjmp wait  ;if ADSC bit is cleared,loop ends

lds R17,ADCL ;read ADCL
lds R18,ADCH ;read ADCH

RCALL PAUSE
RCALL SOUND 

RJMP loop

SOUND: LDI R17,1
	   IN  R18,PORTD
	   EOR R18,R17
       OUT PORTD,R18
       RET

PAUSE: DEC R17
	   BRNE PAUSE
	   RET
;
; test2 pwm.asm
;
; Created: 11/27/2022 1:42:02 PM
; Author : uvind
;
sbi DDRD,6 ;set as output 
cbi DDRC,0

ori R18,1<<COM0A1|1<<WGM01|1<<WGM00
out TCCR0A,R18
ori R19,1<<CS00
out TCCR0B,R19

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
out OCR0A,R17

rjmp loop
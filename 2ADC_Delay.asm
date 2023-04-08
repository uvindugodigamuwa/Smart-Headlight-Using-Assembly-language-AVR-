; Created: 11/27/2022 1:42:02 PM
; Author : G19
;
;we cant get a good idea about environment light intencity by ldr connected on infront of the car
;when environment light intencity is below normal value, it ON the light according to the environment 
;light intencity.then it look for forward ldr and if light intencity on that ldr is above some value, 
;it reduce headlight value by half of present value.////////////test


;ADC
envi:
ldi R30,25
ldi R29,25
ldi R28,5

SBIS PIND,0
rjmp clk
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

cp R20,R17
BRMI frwd
out OCR0A,R21
rjmp envi

frwd:

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
cp R23,R22
BRMI decrs
out OCR0A,R17
rjmp envi

decrs:
out OCR0A,R20
rjmp envi


clk:
sbic PIND,0 ;1
rjmp envi ;2
dec R30 ; 1
brne clk; 1
dec R29; 1
brne clk; 1
dec R28; 1
brne clk; 1
out OCR0A,R21; 1
rjmp envi; 2
 
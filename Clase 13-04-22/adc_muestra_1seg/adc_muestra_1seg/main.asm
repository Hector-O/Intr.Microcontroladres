;
; adc_muestra_1seg.asm
;
; Created: 13/04/2022 04:55:32 p. m.
; Author : hecth
;


; Replace with your application code
.def temp=r16
.cseg 
.org 0

.org $018
reti

.org $02A
jmp adc_fin

reset: ldi temp, $ff
	out ddrb, temp
	sts admux, temp
	ldi temp,$01
	sts didr0, temp

	ldi temp,$05 
	sts adcsra, temp ; selecciona el modo de disparo
	ldi temp, $ef
	sts adcsra, temp ; selecciona autodisparo
	ldi temp, $1d
	sts tccr1b, temp ; selecciona modo CTC Click Timer Counter y N=1024
	ldi temp, $f4
	sts icr1h, temp	;carga parte alta de registro de captura de evento
	ldi temp, $24	
	sts icr1l, temp	;carga parte baja de registro de captura de evento
	
	ldi temp, $f4
	sts ocr1bh, temp	;carga parte alta de registro de comparación b
	ldi temp, $24	
	sts ocr1bl, temp	;carga parte baja de registro de comparación b
	
	ldi temp, $04
	sts timsk1, temp

main:	jmp main

adc_fin: lds temp, ach
out portb, temp
reti


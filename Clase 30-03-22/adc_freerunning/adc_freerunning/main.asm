;
; adc_freerunning.asm
;
; Created: 30/03/2022 04:42:36 p. m.
; Author : hecth
;


; Replace with your application code
	.def temp=r16
	.cseg 
	.org 0

	ldi temp, $ff
	out ddrd, temp ;configura puerto d salida

	ldi temp, $60 
	sts admux, temp ; Selecciona Vcc como voltaje de referencia y pone el resultado cargado a la izquierda, o porque selecciona adc0

	;adcsrb como es reset ya está en 0 y configurado para freerunning

	ldi temp, $01 
	sts didr0,temp ; deshabilita buffer digital

	ldi temp,$e7
	sts adcsra, temp; ;inicia la conversión en modo freerunning(unica vez)

espera:	lds temp, adcsra ;lee el registro
	andi temp, $10  ; se queda con registro 4
	breq espera
	ldi temp, $f7
	sts adcsra, temp ;establece la bandera 4 en 1, limpia la bandera poniendo el inicio de conversión

	lds temp, adch ; lee el datos de la convesión
	out portd, temp ;saca al puerto d la convesión
	jmp espera




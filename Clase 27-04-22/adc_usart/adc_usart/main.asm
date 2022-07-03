;
; adc_usart.asm
;
; Created: 27/04/2022 04:46:26 p. m.
; Author : hecth
;


; Replace with your application code
.def temp=r16
.cseg
.org 0

reset:	ldi temp, $60
	sts admux, temp ; configura el voltaje de referencia y resultado se carga a la izquierda y adc0 como entrada
	ldi temp, $01
	sts didr0, temp ; quitamos buffer digital en adc0
	ldi temp, $fe
	out ddrd, temp ; configura Tx como salida y Rx como entrada
	ldi temp, $18
	sts ucsr0b, temp ; habilita el receptor y el transmisor
	ldi temp, 103
	sts ubrr0l, temp ; configura a 9600 bits por segundo

main:	lds temp, ucsr0a ; lee la el registro para la bandera
	andi temp, $80
	breq main
	lds temp, udr0
	cpi temp, $30 //0x30 codigo hexadecimal del cero
	brne main
	ldi temp, $c7
	sts adcsra, temp ; habilita el adc e inicia la conversion
espera:	lds temp, adcsra ; lee registro de bandera para saber cuando termina la conversion
	andi temp, $10
	breq espera
	ldi temp, $97
	sts adcsra, temp ; limpia bandera de inicio de conversion
	lds temp, adch ; lee el valor del convertidor
	sts udr0, temp ; transmite la muestra
espera2:	sts ucsr0a, temp ; lee registro para la bandera
	andi temp, $40 ;0100 0000
	brne espera2 ; espera a que termine la transmision
	ldi temp, $40
	sts ucsr0a, temp ; limpia bandera
	jmp main
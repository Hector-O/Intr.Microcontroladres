;
; eco.asm
;
; Created: 25/04/2022 05:24:20 p. m.
; Author : hecth
;


; Replace with your application code
	.def temp=r16
	.cseg
	.org 0
	jmp reset

	.org $024
	jmp recibe

reset:	ldi temp, $fe
	out ddrd, temp ; pone a salida excepto d1 (rx entrada, tx salida)
	;ucsr0a, registro ya confugurado por reset
	ldi temp, $98
	sts ucsr0b, temp ; habilita rx interrupcion, habilita receptor y transmisor
	;ucsr0c, registro ta configurado por reset (8 bits)
	ldi temp, 103
	sts ubrr0l, temp; confugura a 9600 Bits Por Segundo
	sei

main:nop
	jmp main

recibe:	lds temp, udr0; lee registro de datos
	sts udr0, temp; escribe en el registro
	reti
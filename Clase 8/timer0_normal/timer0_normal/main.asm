;
; timer0_normal.asm
;
; Created: 12/03/2022 08:46:26 p. m.
; Author : hecth
;


; Replace with your application code
	.def temp=r16
	.cseg 
	.org 0
	rjmp reset ; salta a la direcci�n 0x000 (por tablita de vectores de interrupci�n)

	.org $020 ; direcci�n de donde es la interrupci�n TIMER0_OVF (sobreflujo, cuando llega registro de comparaci�n)
	rjmp timer0_ovf

reset: ldi temp, $20
	out ddrb, temp; b5 configurado como salida
	; por ser reset timer est� en modo normal
	ldi temp, $05
	out TCCR0B, temp; configura el preescalador a 1024 (primeros 4 bits para preescalador), p�g 141 atmega328.pdf
	ldi temp, $01
	sts timsk0, temp ;configura para interrupci�n por sobreflujo (sts porque timsk0 est� en 0x6e > $5f)
	sei ;habilita las interrupciones globales
	ldi temp, $20
	out portb, temp; prende el led

main:	nop
	nop
	rjmp main

;interrupci�n
timer0_ovf: com temp
	out portb, temp
	reti ; regreso de la interrupci�n


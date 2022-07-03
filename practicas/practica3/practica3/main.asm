;
; practica3.asm
;
; Created: 17/03/2022 02:54:36 a. m.
; Author : hecth
;


; Replace with your application code
	.def temp=r16
	.def cte=r17
	.def cont1=r18
	.def cont2=r19
	.def cont3=r20
	.cseg
	.org 0

	ldi temp, $40
	out ddrd, temp ; habilita d6 como salida
	ldi temp, $03
	out portd, temp ; habilita resistencia de pull ip de d0 y d1

	;timer 0 en modo fast pwm atmega.pdf	
	ldi temp, $83
	out tccr0a, temp ; 0x03 modo fast pwm y 0x8 para poner en 0 cuando llegue a ser igual que registro de comparación,
	ldi temp, $03 ; configura preescalador a 64
	out tccr0b, temp
	ldi temp, 10
	out ocr0a, temp ; configura registro de comparación a 10
	ldi cte, $0A

main:	in temp, pind
	cpi temp, $02
	breq aumenta
	cpi temp, $01
	breq disminuye
	jmp main

aumenta:	call delay_100ms ; un delay xd
	in temp, ocr0a ; lee el valor del comparación
	cpi temp, 250
	breq main
	add temp, cte ; suma 10 al valor de comparación
	out ocr0a, temp ; regresa el nuevo valor a comparación
	jmp main ; pregunta si el botón siguie presionándose


disminuye:	call delay_100ms ; un delay xd
	in temp, ocr0a ; lee el valor del comparación
	cpi temp, 0
	breq main
	sub temp, cte ; suma 10 al valor de comparación
	out ocr0a, temp ; regresa el nuevo valor a comparación
	jmp main ; pregunta si el botón siguie presionándose

delay_100ms: ldi cont1, 4
lazo3:ldi cont2, 200
lazo2:ldi cont3, 200
lazo1:nop
	nop
	nop
	nop
	nop
	nop
	nop
	dec cont3
	brne lazo1
	dec cont2
	brne lazo2
	dec cont1
	brne lazo3
	ret
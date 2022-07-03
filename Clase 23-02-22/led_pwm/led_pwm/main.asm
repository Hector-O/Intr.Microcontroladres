;
; led_pwm.asm
;
; Created: 09/04/2022 04:55:22 a. m.
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
	out ddrd, temp ; opcion para ponder d6 como  salida y d5 como entrada 0100 0000 
	
	ldi temp, $20
	out portd, temp ; resistencia de pullup a d5

	ldi temp, $83
	out tccr0a, temp	; 8 porque cuando sea comparacion se pone a 0 y la salida b no se usa.  y 3  para modo fast pwm

	ldi temp, $03 
	out tccr0b, temp ; pone preescalador a 64 

	ldi temp, 125
	out ocr0a, temp ; pone registro comparador a 125

	ldi cte, $05

main: sbic pind, 5 ; salta si el bit5 está a 0, si esta a 1 continua
	jmp main  

	call delay_100ms
	in temp, ocr0a
	add temp, cte
	out ocr0a, temp
	jmp main

delay_100ms:  ldi cont1, 4
lazo3: 	ldi cont2, 200
lazo2:	ldi cont3, 200
lazo1:	nop
	nop
	nop
	nop
	nop
	nop
	nop
	dec cont3
	breq lazo1
	dec cont2
	breq lazo2
	dec cont3
	breq lazo3
	ret
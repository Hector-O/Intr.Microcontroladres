;
; teclado-lcd.asm
;
; Created: 26/05/2022 05:18:26 p. m.
; Author : hecth
;


; Replace with your application code
	.def temp=r16
	
	.def cont1=r17
	.def cont2=r18
	.def cont3=r19
	.def cuenta=r20
	.def alta=r21
	.def baja=r22

	.cseg
	.org 0
	jmp reset

	.org $024
	jmp recibe

reset:	ldi temp, $fe ; 1111 1110
	out ddrd, temp ; pone a salida excepto d1 (rx entrada, tx salida)

	ldi cuenta, $00

	/////////cofigura LCD
		call delay_100ms


	;funcion set de cuatro bits
	ldi temp, $28 ; 0010 1000
	out portd, temp ;Enable 1 y RS en 0
	ldi temp, $20 ; 0010 0000
	out portd, temp ; Enable 0 y RS en 0
	call delay_10ms
	

	;funcion set de 8 bits
	ldi temp, $28 ; 0010 1000
	out portd, temp ;Enable 1 y RS en 0
	ldi temp, $20 ; 0010 0000
	out portd, temp ; Enable 0 y RS en 0

	ldi temp, $88 ; 0010 1000
	out portd, temp ;Enable 1 y RS en 0
	ldi temp, $80 ; 0010 0000
	out portd, temp ; Enable 0 y RS en 0
	call delay_10ms


	;display on/off
	ldi temp, $08 ; 0010 1000
	out portd, temp ;Enable 1 y RS en 0
	ldi temp, $00 ; 0010 0000
	out portd, temp ; Enable 0 y RS en 0

	ldi temp, $e8 ; 0010 1000
	out portd, temp ;Enable 1 y RS en 0
	ldi temp, $e0 ; 0010 0000
	out portd, temp ; Enable 0 y RS en 0
	call delay_10ms

	; modo de entrada
	ldi temp, $08 ; 0010 1000
	out portd, temp ;Enable 1 y RS en 0
	ldi temp, $00 ; 0010 0000
	out portd, temp ; Enable 0 y RS en 0

	ldi temp, $68 ; 0010 1000
	out portd, temp ;Enable 1 y RS en 0
	ldi temp, $60 ; 0010 0000
	out portd, temp ; Enable 0 y RS en 0
	call delay_10ms

	ldi temp, $08 ; 0010 1000
	out portd, temp ;Enable 1 y RS en 0
	ldi temp, $00 ; 0010 0000
	out portd, temp ; Enable 0 y RS en 0

	ldi temp, $18 ; 0010 1000
	out portd, temp ;Enable 1 y RS en 0
	ldi temp, $10 ; 0010 0000
	out portd, temp ; Enable 0 y RS en 0
	ldi cuenta, $00
	call delay_10ms

	///////configura USART
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
	cpi cuenta, 16
	breq salta_linea
	cpi cuenta, 32
	breq limpia_lcd
	inc cuenta
l_3:
	;escribe en el lcd
	mov alta, temp
	andi alta, $f0

	mov baja, temp
	andi baja, $0f
	lsl baja
	lsl baja
	lsl baja
	lsl baja
	
	mov temp, alta
	ori temp, $0c
	out portd, temp ;Enable 1 y RS en 1
	mov temp, alta
	ori temp, $04
	out portd, temp ; Enable 0 y RS en 1

	mov temp, baja
	ori temp, $0c
	out portd, temp ;Enable 1 y RS en 1
	mov temp, baja
	ori temp, $04
	out portd, temp ; Enable 0 y RS en 0
	call delay_10ms
	reti

salta_linea: ldi temp, $c8 ; 1100 1000
	out portd, temp ;Enable 1 y RS en 0
	ldi temp, $c0 ; 0010 0000
	out portd, temp ; Enable 0 y RS en 0

	ldi temp, $08 ; 0010 1000
	out portd, temp ;Enable 1 y RS en 0
	ldi temp, $00 ; 0010 0000
	out portd, temp ; Enable 0 y RS en 0
	call delay_10ms
	rjmp l_3

	; limpia el display
limpia_lcd:	ldi temp, $08 ; 0000 1000
	out portd, temp ;Enable 1 y RS en 0
	ldi temp, $00 ; 0000 0000
	out portd, temp ; Enable 0 y RS en 0

	ldi temp, $18 ; 0001 1000
	out portd, temp ;Enable 1 y RS en 0
	ldi temp, $10 ; 0001 0000
	out portd, temp ; Enable 0 y RS en 0
	ldi cuenta, $00
	call delay_10ms
	rjmp l_3




delay_100ms:ldi cont1, 4 
lazo3:	ldi cont2, 200
lazo2:	ldi cont3, 200
lazo1:	nop
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
	reti

delay_10ms: ldi cont1, 80
lazo5:	ldi cont2, 200
lazo4:	nop
	nop
	nop
	nop
	nop
	nop
	nop
	dec cont2
	brne lazo4
	dec cont1
	brne lazo5
	reti
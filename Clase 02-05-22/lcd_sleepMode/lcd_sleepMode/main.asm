;
; lcd.asm
;
; Created: 02/05/2022 04:59:52 p. m.
; Author : hecth
;


; Replace with your application code
	.def temp=r16
	.def cont1=r17
	.def cont2=r18
	.def cont3=r19
	.cseg
	.org 0
	jmp reset


	.org $006
	jmp pcint_0


reset:	ldi temp, $01
	sts pcicr, temp ; habilita vector de interrupcion pcint0
	sts pcmsk0, temp ; habilita individualmente int0
	out portb, temp ; habilita resistencia de pull-up en b0
	out ddrc, temp ; habilita c0 como salida

	ldi temp, $fe
	out ddrd, temp ; configura puerto d como entrada-salida

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

	; limpia el display
	ldi temp, $08 ; 0010 1000
	out portd, temp ;Enable 1 y RS en 0
	ldi temp, $00 ; 0010 0000
	out portd, temp ; Enable 0 y RS en 0

	ldi temp, $18 ; 0010 1000
	out portd, temp ;Enable 1 y RS en 0
	ldi temp, $10 ; 0010 0000
	out portd, temp ; Enable 0 y RS en 0
	call delay_10ms

	; letra H
	ldi temp, $4c ; 0010 1000
	out portd, temp ;Enable 1 y RS en 1
	ldi temp, $44 ; 0010 0000
	out portd, temp ; Enable 0 y RS en 1

	ldi temp, $8c ; 0010 1000
	out portd, temp ;Enable 1 y RS en 1
	ldi temp, $84 ; 0010 0000
	out portd, temp ; Enable 0 y RS en 0
	call delay_10ms

	; letra O
	ldi temp, $4c ; 0010 1000
	out portd, temp ;Enable 1 y RS en 1
	ldi temp, $44 ; 0010 0000
	out portd, temp ; Enable 0 y RS en 1

	ldi temp, $fc ; 0010 1000
	out portd, temp ;Enable 1 y RS en 1
	ldi temp, $f4 ; 0010 0000
	out portd, temp ; Enable 0 y RS en 0
	call delay_10ms

	; letra L
	ldi temp, $4c ; 0010 1000
	out portd, temp ;Enable 1 y RS en 1
	ldi temp, $44 ; 0010 0000
	out portd, temp ; Enable 0 y RS en 1

	ldi temp, $cc ; 0010 1000
	out portd, temp ;Enable 1 y RS en 1
	ldi temp, $c4 ; 0010 0000
	out portd, temp ; Enable 0 y RS en 0
	call delay_10ms

	; letra A
	ldi temp, $4c ; 0010 1000
	out portd, temp ;Enable 1 y RS en 1
	ldi temp, $44 ; 0010 0000
	out portd, temp ; Enable 0 y RS en 1

	ldi temp, $1c ; 0010 1000
	out portd, temp ;Enable 1 y RS en 1
	ldi temp, $14 ; 0010 0000
	out portd, temp ; Enable 0 y RS en 0
	call delay_10ms
	sei

aqui:	jmp	aqui


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
	dec cont3
	reti


;;;;;;;;;;;;;;;;;;;interrupciones;;;;;;;;;;;;;;;;;;;;;;;;;;;
pcint_0:	com temp
	andi temp, $01
	out portc, temp
	call delay_100ms
	call delay_100ms
	sbi pcifr, 0
	reti
	;;;;aqui escribio algo como a las 5:20



;;;;;;;;;;;;;;;;;;;;subrutinas;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
	dec cont2
	brne lazo5
	reti


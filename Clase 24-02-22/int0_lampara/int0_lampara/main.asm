	.def temp=r16
	.def cont1=r17
	.def cont2=r18
	.def cont3=r19
	.def cont4=r20
	.def cont5=r21
	.cseg
	.org 0

	jmp reset ;posición 0


	; no secesita .org porque jmp hace salto de 2 localidades
	; e int0 está en la posición 2
	jmp int_0 ;posición 2
	
reset: ldi temp, $20
	out ddrb, temp ; configura b5 como salida

	ldi temp, $00
	out ddrd, temp ; configura d como entrada

	ldi temp, $04
	out ddrd, temp ; habilia resistencia de pull-up de d2

	ldi temp, $01
	sts eicra, temp ; configura cualquier cambio para activar interrupcion

	out eimsk, temp ; configura interrupcion int0

	sei ; habilita interrupciones globales

	ldi temp, $20
	out portb, temp ; enciende la lampara, un  led jaja

main:call delay_5s
	cbi portb, 5;Clear Bit Register, pone b5 como 0
	jmp main

int_0: sbi portb, 5 ; prende el b5
	;reinicia delay
	ldi cont3, 200
	ldi cont4, 200
	ldi cont5, 200
	call delay_30ms ; para quitar los rebotes de la señal
	ldi temp, $01
	out eifr, temp ; se limpia por software la bandera
	reti

delay_30ms:	ldi cont1, 200
lazo2:	ldi cont2, 240
lazo1:	nop
	nop
	nop
	nop
	nop
	nop
	nop
	dec cont2
	brne lazo1
	dec cont1
	brne lazo2
	ret

delay_5s: ldi cont3, 200
lazo5:	ldi cont4, 200
lazo4:	ldi cont5, 200
lazo3:	nop
	nop
	nop
	nop
	nop
	nop
	nop
	dec cont5
	brne lazo3
	dec cont4 
	brne lazo4
	dec cont3
	brne lazo4
	ret
	
			
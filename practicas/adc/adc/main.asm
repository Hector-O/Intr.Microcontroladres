;
; adc.asm
;
; Created: 15/05/2022 01:49:33 a. m.
; Author : hecth
;
; Replace with your application code
.def temp=r16
.def unidades=r17
.def decenas=r18
.def centenas=r19
.def mux=r20
.def escalon=r21
.def conversion=r22

;***** Subroutine Register Variables
.equ	AtBCD0	=13		;address of tBCD0
.equ	AtBCD2	=15		;address of tBCD1
.def	tBCD0	=r13		;BCD value digits 1 and 0
.def	tBCD1	=r14		;BCD value digits 3 and 2
.def	tBCD2	=r15		;BCD value digit 4
.def	fbinL	=r0		;binary value Low byte
.def	fbinH	=r1		;binary value High byte
.def	cnt16a	=r23		;loop counter
.def	tmp16a	=r24		;temporary value
.cseg
.org 0
jmp reset
.org $020
jmp tmr0_ovf
.org $02a
jmp adc_conv

reset:	ldi temp, $ff
	out ddrd, temp ; configura d como salida
	ldi temp, $ff
	out ddrb, temp ; configura b0 a b2 como salida 
	ldi temp, $00
	out portd, temp ; envia ceros
	out portb, temp ; envia ceros
	call constantes_display ; llama a funcion que carga constantes

  ; configuracion adc en freeruning
	ldi temp, $60
	sts admux, temp ; Voltaje de referencia Vcc y conversion cargada a la izquierda
	;adcsrb como es reset ya esta en 0 y configurado para freerunning
	ldi temp, $01
	sts didr0, temp ; deshabilita el buffer digital
	ldi temp, $ef
	sts adcsra, temp ; inicia la conversion en modo freerunning(unica vez)

  ;configuracion timer0 como overflow
	;TCCR0A en ceros por reset y configurado para modo normal
	ldi temp, $03 
	out tccr0b, temp ; preescalador en 64
	ldi temp, $01
	sts timsk0, temp ; habilita interrupcion por overflow

  ;Inicializa constantes
	ldi unidades, $00
	ldi decenas, $00
	ldi centenas, $00
	ldi escalon, 196 ; 19.6mv
	sei; Interrupcion global habilitada
	jmp main

constantes_display:
	;guarda numeros bcd desde 0 al 9 en direccion $100
	ldi xh, $01
	ldi xl, $00  //carga $100 en x
				 ;          0abc defg
	ldi temp, $7e ;Display: 0111 1110 -> 0
	st X+, temp
	ldi temp, $30 ;Display: 0011 0000 -> 1
	st X+, temp
	ldi temp, $6d;Display: 0110 1101 -> 2
	st X+, temp
	ldi temp, $79;Display: 0111 1001 -> 3
	st X+, temp
	ldi temp, $33;Display: 0011 0011 -> 4
	st X+, temp
	ldi temp, $5b;Display: 0101 1011 -> 5
	st X+, temp
	ldi temp, $5f;Display: 0101 1111 -> 6
	st X+, temp
	ldi temp, $70;Display: 0111 0000 -> 7
	st X+, temp
	ldi temp, $7f;Display: 0111 1111 -> 8
	st X+, temp
	ldi temp, $73;Display: 0111 0011 -> 9
	st X, temp
	ldi xh, $01
	ldi xl, $00; vuelve a cargar $100 en x
	ret

main:
	nop
	rjmp main

adc_conv:
	lds conversion, adch;lee la parte alta de la conversion
	mul conversion, escalon; multuplica conversion por escalon
	call bin2BCD16 ; convierte de binario a BCD
	mov centenas,tBCD2 ;mueve de tBCD2 a centenas
	andi centenas,$0f ; se queda con la parte que nos interesa
	mov decenas,tBCD1 ;mueve de tBCD1 a decenas
	lsr decenas
	lsr decenas
	lsr decenas 
	lsr decenas ; tres shifts a la derecha para dejar solo centenas
	mov unidades,tBCD1 ;mueve de tBCD1 a unidades
	andi unidades,$0f ; se queda con la perte derecha
	reti

tmr0_ovf:
	ldi temp, $00
	out portd, temp; ; apaga displays
	cpi mux, $06 ; multiplexacion de unidades
	breq muestra_unidades
	cpi mux, $05; multiplexacion de decenas
	breq muestra_decenas
	rjmp muestra_centenas; multiplexacion de centenas
muestra_unidades:
	mov Xl,unidades
	ld temp,X
	out portd,temp
	out portb,mux
	ldi mux,$05
	reti
muestra_decenas:
	mov Xl,decenas
	ld temp,X
	out portd,temp
	out portb,mux
	ldi mux,$03
	reti
muestra_centenas:
	mov Xl,centenas
	ld temp,X
	ori temp,$80;Muestra el punto
	out portd,temp
	out portb,mux
	ldi mux,$06
	reti

;***** Code
bin2BCD16:
	ldi	cnt16a,16	;Init loop counter	
	clr	tBCD2		;clear result (3 bytes)
	clr	tBCD1		
	clr	tBCD0		
	clr	ZH		;clear ZH (not needed for AT90Sxx0x)
bBCDx_1:
	lsl	fbinL		;shift input value
	rol	fbinH		;through all bytes
	rol	tBCD0		;
	rol	tBCD1
	rol	tBCD2
	dec	cnt16a		;decrement loop counter
	brne bBCDx_2		;if counter not zero
	ret			;   return
bBCDx_2:
	ldi	r30,AtBCD2+1	;Z points to result MSB + 1
bBCDx_3:
	ld tmp16a,-Z	;get (Z) with pre-decrement
	subi tmp16a,-$03	;add 0x03
	sbrc tmp16a,3	;if bit 3 not clear
	st Z,tmp16a	;	store back
	ld tmp16a,Z	;get (Z)
	subi tmp16a,-$30	;add 0x30
	sbrc tmp16a,7	;if bit 7 not clear
	st Z,tmp16a	;	store back
	cpi ZL,AtBCD0	;done all three?
	brne bBCDx_3		;loop again if not
	rjmp bBCDx_1
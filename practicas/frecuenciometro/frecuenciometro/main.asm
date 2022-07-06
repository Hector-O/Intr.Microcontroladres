;
; frecuenciometro.asm
;
; Created: 16/05/2022 04:55:23 p. m.
; Author : hecth
;


; Replace with your application code
	.def temp=r16
	.def unidades=r17
	.def decenas=r18
	.def centenas=r19
	.def mux=r20
	.def uni_aux=r21
	.def dec_aux=r22
	.def cen_aux=r23
	.cseg

	.org 0
	jmp reset
	.org 2
	jmp int_0
	.org $016
	jmp tmr1_compA
	.org $020
	jmp tmr0_ovf

reset:
	;CONFIGURAR PUERTOS DE ENTRADA Y SALIDA
	ldi temp,$fb; 1111 1011
	out ddrd,temp;Puerto D como salida, excepto D2 a,b,c,d,e,f,g
	ldi temp,$04; 0000 0100
	out portd,temp; Pull up en D2
	ldi temp,$07; 0000 0111
	out ddrb,temp;Pines B2 a B0 como salida: centenas, decenas, unidades
	rcall constantes_display
	;CONFIGURAR INT0 EN FLANCO DE SUBIDA
	ldi temp,$03
	sts eicra,temp; Interrupcion en Int0 (D2) por flanco de subida
	ldi temp,$01
	out eimsk,temp; Habilita interrupcion en Int0
	;CONFIGURAR TIMER0 COMO INTERRUPCION EN OVERFLOW
	;TCCR0A en 0's, ya listo, modo normal
	ldi temp,$03 ; 03=64, 04=256
	out tccr0b,temp;Preescalador en 64 para 1ms
	ldi temp,$01
	sts timsk0,temp;Habilita interrupcion por overflow
	;CONFIGURAR TIMER1 COMO CTC a 1seg en COMPA
	ldi temp,$f4;f4
	sts ocr1ah,temp
	ldi temp,$24;24
	sts ocr1al,temp;Cargar en ocr1a 62500 para igualdad en 1s
	ldi temp,$00
	sts tccr1a,temp;Sin usar OC1A/OC1B, para modo CTC
	ldi temp,$0c;0c=256 , 0d=1024, 0b=64
	sts tccr1b,temp;Modo CTC y Preescalador en 256
	ldi temp,$02
	sts timsk1,temp;Interrupcion por comparacion con ocra1
	;CARGAR CONTADORES Y MUX
	ldi unidades,0
	ldi decenas,0
	ldi centenas,0
	ldi mux,$06;0000 0110, $06 unidades,$05 decenas, $03 centenas
	ldi uni_aux,0
	ldi dec_aux,0
	ldi cen_aux,0
	sei;Interrupcion global habilitada
	rjmp main

constantes_display:
	;Numeros del 0 al 9 y error con 'E'
	ldi xh,$01
	ldi xl,$00  ;Display: abcd e1fg
	ldi temp,$fe;Display: 1111 1110 0
	st X+,temp
	ldi temp,$64;Display: 0110 0100 1
	st X+,temp
	ldi temp,$dd;Display: 1101 1101 2
	st X+,temp
	ldi temp,$f5;Display: 1111 0101 3
	st X+,temp
	ldi temp,$67;Display: 0110 0111 4
	st X+,temp
	ldi temp,$b7;Display: 1011 0111 5
	st X+,temp
	ldi temp,$bf;Display: 1011 1111 6
	st X+,temp
	ldi temp,$e4;Display: 1110 0100 7
	st X+,temp
	ldi temp,$ff;Display: 1111 1111 8
	st X+,temp
	ldi temp,$e7;Display: 1110 0111 9
	st X+,temp
	ldi temp,$9f;Display: 1001 1111 E
	st X,temp
	ldi xh,$01
	ldi xl,$00
	ret

main:
	nop
	rjmp main

;CONTEO DE LA FRECUENCIA DE LA SEÑAL
int_0:
	cpi centenas,10;El error
	breq error
	inc unidades
	cpi unidades,10;Maximo de unidades
	breq inc_decenas
	reti
inc_decenas:ldi unidades,0
	inc decenas
	cpi decenas,10;Maximo de decenas
	breq inc_centenas
	reti
inc_centenas:ldi decenas,0
	inc centenas
	cpi centenas,10;Maximo de centenas
	breq error
	reti
error:
	ldi unidades,10
	ldi decenas,10
	reti;Para el error 'E'

;CARGA LA FRECUENCIA CADA SEGUNDO
tmr1_compA:
	mov uni_aux,unidades
	mov dec_aux,decenas
	mov cen_aux,centenas
	ldi unidades,0
	ldi decenas,0
	ldi centenas,0
	reti

;MULTIPLEXAR LOS DISPLAYS
tmr0_ovf:
	ldi temp,$04;0000 0100
	out portd,temp;Displays apagados
	cpi mux,$06
	breq muestra_unidades
	cpi mux,$05
	breq muestra_decenas
	rjmp muestra_centenas
muestra_unidades:
	mov Xl,uni_aux
	ld temp,X
	out portd,temp
	out portb,mux
	ldi mux,$05
	reti
muestra_decenas:
	mov Xl,dec_aux
	ld temp,X
	out portd,temp
	out portb,mux
	ldi mux,$03
	reti
muestra_centenas:
	mov Xl,cen_aux
	ld temp,X
	out portd,temp
	out portb,mux
	ldi mux,$06
	reti
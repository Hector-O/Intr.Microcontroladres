;
; teclado-pc-(usart)-LCD.asm
;
; Created: 15/06/2022 03:59:56 a. m.
; Author : hecth
;


; Replace with your application code
.def temp=r16
.def tecla=r17
.def cont1=r18
.def cont2=r19
.def cuenta=r20
.def alta=r21
.def baja=r22
.def sel=r23

.cseg
.org 0
jmp reset

.org $024
jmp recibe

reset:	ldi temp, $fe ; 1111 1110
	out ddrd, temp ; pone a salida excepto d1 (rx entrada, tx salida)

	ldi cuenta, $00
	ldi sel, $00

	;configura LCD
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

inicio:ldi temp, $00
out ddrc, temp ; configura puerto c (bajo) como entrada
ldi temp, $0f
out portc, temp ; configura resistencias de pull-up de parte baja

ldi temp, $ff
out ddrb, temp ; configura como salida
ldi temp, $00
out portb, temp ; saca 0 en el puerto b

nop
nop ; tiempo para buffers
nop
filas:	in temp, pinc
andi temp, $0f
cpi temp, $0E
breq fila0
cpi temp, $0D
breq fila4
cpi temp, $0B
breq fila8
cpi temp, $07
breq filaC
jmp filas

fila0: ldi tecla, $00
jmp columnas
fila4: ldi tecla, $04
jmp columnas
fila8: ldi tecla, $08
jmp columnas
filaC: ldi tecla, $0C
jmp columnas

columnas:	ldi temp, $00
out ddrb, temp ; configura puerto b (bajo) como entrada
ldi temp, $0f
out portb, temp ; configura resistencias de pull-up de parte baja

ldi temp, $ff
out ddrc, temp ; configura como salida
ldi temp, $00
out portc, temp ; saca 0 en el puerto c
nop
nop ; tiempo para buffers
nop

ldi temp, $18
out portd, temp

salto:	in temp, pinb
andi temp, $0f
cpi temp, $0E
breq columna0
cpi temp, $0D
breq columna1
cpi temp, $0B
breq columna2
cpi temp, $07
breq columna3
jmp salto

columna0:ldi temp, $00
add tecla, temp
jmp in_teclado
columna1:ldi temp, $01
add tecla, temp
jmp in_teclado
columna2:ldi temp, $02
add tecla, temp
jmp in_teclado
columna3:ldi temp, $03
add tecla, temp
jmp in_teclado


;modificar apartir de aca para la ultima practica

in_teclado: cpi tecla, $0f
	breq cambia_modo
	cpi sel, 2
	breq modo_2
	cpi sel, 1
	breq modo_1
	rjmp modo_0

modo_0: ldi temp, $30
	add temp, tecla
	sts udr0, temp
	call lcd
	call delay_200ms
	rjmp inicio

modo_1: ldi temp, $61
	add temp, tecla
	sts udr0, temp
	call lcd
	call delay_200ms
	rjmp inicio

modo_2: ldi temp, $70
	add temp, tecla
	sts udr0, temp
	call lcd
	call delay_200ms
	rjmp inicio

cambia_modo: inc sel
	cpi sel, $03
	breq reinicia_modo
	rjmp inicio

reinicia_modo: ldi sel, $00	
	ldi temp, $00 ; limpia el registro
	rjmp inicio

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
recibe:	lds temp, udr0; lee registro de datos
		call lcd
	reti
	
lcd:inc cuenta
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

	ldi temp, $00 ; limpia el registro
	call delay_10ms

	cpi cuenta, 17
	breq salta_linea
	cpi cuenta, 33
	breq limpia_lcd
l_3:ret

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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


delay_200ms:	call delay_100ms
		call delay_100ms
jmp inicio


delay_100ms:call delay_10ms
	call delay_10ms
	call delay_10ms
	call delay_10ms
	call delay_10ms
	call delay_10ms
	call delay_10ms
	call delay_10ms
	call delay_10ms
	call delay_10ms
	reti

delay_10ms: ldi cont1, 80
lazo2:	ldi cont2, 200
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
	reti
;
; Teclado.asm
;
; Created: 20/04/2022 09:35:21 p. m.
; Author : hecth
;


; Replace with your application code
.def temp=r16
.def tecla=r17
.def cont1=r18
.def cont2=r19
.def cont3=r20
.cseg
.org 0

ldi temp, $ff
out ddrd, temp ;configura d salida
out portd, temp

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
jmp offset
columna1:ldi temp, $01
add tecla, temp
jmp offset
columna2:ldi temp, $02
add tecla, temp
jmp offset
columna3:ldi temp, $03
add tecla, temp
jmp offset


;modoicar apartir de aca para la ultima practica
offset:	cpi tecla, $0f
breq offset_f
cpi tecla, $0e
breq offset_e
cpi tecla, $0d
breq offset_d
cpi tecla, $0c
breq offset_c
cpi tecla, $0b
breq offset_b
cpi tecla, $0a
breq offset_a
cpi tecla, $09
breq offset_9
cpi tecla, $08
breq offset_8
cpi tecla, $07
breq offset_7
cpi tecla, $06
breq offset_6
cpi tecla, $05
breq offset_5
cpi tecla, $04
breq offset_4
cpi tecla, $03
breq offset_3
cpi tecla, $02
breq offset_2
cpi tecla, $01
breq offset_1
jmp offset_0

offset_f: nop
jmp mostrar
offset_e: ldi temp, $0e
sub tecla, temp
jmp mostrar
offset_d: inc tecla
jmp mostrar
offset_c: inc tecla
jmp mostrar
offset_b: ldi temp, $04
sub tecla, temp
jmp mostrar
offset_a: ldi temp, $02
sub tecla, temp
jmp mostrar
offset_9: nop
jmp mostrar
offset_8: ldi temp, $04
add	tecla, temp
jmp mostrar
offset_7: ldi temp, $03
sub tecla, temp
jmp mostrar
offset_6: dec tecla
jmp mostrar
offset_5: inc tecla
jmp mostrar
offset_4: ldi temp, $07
add tecla, temp
jmp mostrar
offset_3: ldi temp, $02
sub tecla, temp
jmp mostrar
offset_2: nop
jmp mostrar
offset_1: ldi temp, $02
add tecla, temp
jmp mostrar
offset_0: ldi temp, $0A
add tecla, temp
jmp mostrar

mostrar:	cpi tecla, $0f
breq quince
cpi tecla, $0e
breq catorce
cpi tecla, $0d
breq trece
cpi tecla, $0c
breq doce
cpi tecla, $0b
breq once
cpi tecla, $0a
breq diez
cpi tecla, $09
breq nueve
cpi tecla, $08
breq ocho
cpi tecla, $07
breq siete
cpi tecla, $06
breq seis
cpi tecla, $05
breq cinco
cpi tecla, $04
breq cuatro
cpi tecla, $03
breq tres
cpi tecla, $02
breq dos
cpi tecla, $01
breq uno
jmp cero

quince: ldi temp, $71 ; 0111 0001
out portd, temp
jmp delay

catorce: ldi temp, $f9; 0111 1001
out portd, temp
jmp delay

trece: ldi temp, $5E; 0101 1110
out portd, temp
jmp delay

doce: ldi temp, $39
out portd, temp
jmp delay

once: ldi temp, $7c
out portd, temp
jmp delay

diez: ldi temp, $77
out portd, temp
jmp delay

nueve: ldi temp, $6f
out portd, temp
jmp delay

ocho: ldi temp, $7f
out portd, temp
jmp delay

siete: ldi temp, $07
out portd, temp
jmp delay

seis: ldi temp, $7d
out portd, temp
jmp delay

cinco: ldi temp, $6d
out portd, temp
jmp delay

cuatro: ldi temp, $66	
out portd, temp
jmp delay

tres: ldi temp, $4f
out portd, temp
jmp delay

dos: ldi temp, $5b
out portd, temp
jmp delay

uno: ldi temp, $06
out portd, temp
jmp delay

cero: ldi temp, $3f
out portd, temp
jmp delay

delay:	call delay_200ms
jmp inicio

delay_200ms:ldi cont1, 100
lazo3:	ldi cont2, 80
lazo2:	ldi cont3, 40
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
jmp inicio
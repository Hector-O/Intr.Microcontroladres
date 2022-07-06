;
; hola-7-seg.asm
;
; Created: 16/03/2022 05:21:25 p. m.
; Author : hecth
;


; Replace with your application code
.def temp=r16
.def cont1=r17
.def cont2=r18
.def cont3=r19
.cseg
.org 0

		   ;abcdefg
ldi temp, $6E;0110 1110 la H en cátodo
sts $0100,temp
ldi temp, $FC;1111 1100 la O en cátodo
sts $0101,temp
ldi temp, $1C;0001 1100 la L en cátodo
sts $0102,temp
ldi temp, $EE;1110 1110 la A en cátodo
sts $0103,temp

ldi temp, $ff
out ddrd, temp ; habilita salida

main: lds temp, $0100
	out portd, temp; pinta la H
	call delay_medio_seg
	lds temp, $0101
	out portd, temp; pinta la O
	call delay_medio_seg
	lds temp, $0102
	out portd, temp;pinta la L
	call delay_medio_seg
	lds temp, $0103
	out portd, temp;pinta la A
	call delay_medio_seg
	jmp main

delay_medio_seg: ldi cont1, 20
lazo3:ldi cont2, 200
lazo2:ldi cont3, 200
lazo1:nop ;un cilclo de reloj
	nop;un cilclo de reloj
	nop;un cilclo de reloj
	nop;un cilclo de reloj
	nop;un cilclo de reloj
	nop;un cilclo de reloj
	nop;un cilclo de reloj
	dec cont3 ;un cilclo de reloj, 
	brne lazo1 ;10 en total
	dec cont2
	brne lazo2
	dec cont1
	brne lazo3
	ret

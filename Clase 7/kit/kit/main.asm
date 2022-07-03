;
; kit.asm
;
; Created: 11/03/2022 08:25:44 p. m.
; Author : hecth
;


; Replace with your application code
.def temp=r16
.def cont1=r17
.def cont2=r18
.def cont3=r19
.cseg
.org 0

ldi temp, $ff
out ddrd, temp ;se configura como salida
ldi temp, $ef
out portd, temp
rcall delay_125ms
ldi temp, $01
out portd, temp
rcall delay_125ms

izq: lsl temp
out portd, temp
rcall delay_125ms
cpi temp, $80
brne izq
der: lsr temp
out portd, temp
rcall delay_125ms
cpi temp, $01
brne der
rjmp izq

;;;;;subrutinas

delay_125ms: ldi cont1, 5
lazo3: ldi cont2, 200
lazo2: ldi cont3, 200
lazo1:nop
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
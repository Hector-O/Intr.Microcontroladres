;
; kit_led.asm
;
; Created: 03/03/2022 04:52:31 p. m.
; Author : hecth
;


; Replace with your application code
start:
.def temp=r16
.def cont1=r17
.def cont2=r18
.def cont3=r19
.cseg
.org 0

;establece configuraciones
ldi temp, $ff
out ddrd, temp; o era b en vez de d
out portd, temp


ldi temp, $01
out portd, temp
call delay_125ms

delay_125ms:	ldi cont1, 4
lazo_3:	ldi cont2, 250
lazo_2:	ldi cont3, 200
lazo_1:	nop
nop
nop
nop
nop
nop
nop
nop
nop
dec cont3
brne lazo_1
dec cont2
brne lazo_2
dec cont1
brne lazo_3
ret
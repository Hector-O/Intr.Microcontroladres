;
; delay_v2.asm
;
; Created: 11/03/2022 08:12:05 p. m.
; Author : hecth
;


; Replace with your application code
.def temp=r16
.def cont1=r17
.def cont2=r18
.def cont3=r19
.cseg
.org 0

ldi temp, $00  ;Se carga 0x00 en temp
out ddrd, temp ;se habilita puerto d5 como entrada
ldi temp, $20 ; se carga 0x20 en temp  0010 0000
out portd, temp ;se habilita resistencia de pull up (d5)
out ddrb, temp; se configura pin b5 como salida

main: sbis pind,5 ;si es 1 (Set) se brinca la siguiente instrucción, si no continúa con ella
	rjmp un_seg ; salta a la subrutina un_seg

dos_seg:ldi temp, $20 
	out portb, temp ; carga el 0x20 en portb (el led se prende)
	rcall medio_seg ;aplica delay de medio seg
	rcall medio_seg ;aplica delay de medio seg
	ldi temp, $00 
	out portb, temp ;carga 0x0 en portb (el led se apaga)
	rcall medio_seg
	rcall medio_seg
	rjmp main ; pregunta si sigue presionando el bot?n


un_seg:ldi temp, $20 
	out portb, temp ; carga el 0x20 en portb (el led se prende)
	rcall medio_seg ;aplica delay de medio seg
	ldi temp, $00 
	out portb, temp ;carga 0x0 en portb (el led se apaga)
	rcall medio_seg
	rjmp main ; pregunta si sigue presionando el bot?n


;;;;;;;;;;;;;;;;;;;subrutinas
medio_seg: ldi cont1, 20 ;0.5seg=10x200x200x200x20x(62.5ns)
lazo3:	ldi cont2, 200
lazo2:	ldi cont3, 200	
lazo1:	nop ;un cilclo de reloj
	nop;un cilclo de reloj
	nop;un cilclo de reloj
	nop;un cilclo de reloj
	nop;un cilclo de reloj
	nop;un cilclo de reloj
	nop;un cilclo de reloj
	dec cont3 ;un cilclo de reloj, 
	brne lazo1 ;uno o 2 cilclo de reloj-----10 en total
	dec cont2
	brne lazo2
	dec cont1
	brne lazo3
	ret


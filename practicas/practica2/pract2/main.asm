;
; pract2.asm
;
; Created: 12/03/2022 10:34:20 p. m.
; Author : hecth
;


; Replace with your application code
.def temp=r16
.def band=r17
.cseg
.org 0
rjmp reset

.org $020
rjmp timer0_ovf


reset:	ldi temp, $ff
	out ddrd, temp ; habilita puerto d como salida

	ldi temp, $0f
	out ddrb, temp ; habilita mitad b como salida y b5 como entrada
	ldi temp, $20
	out portd, temp ; habilita resistencia de pull-up

	ldi temp, $0f
	out ddrc, temp ;habilita mitad c como salida

	ldi band, $01 ; establece bandera de prendido-apagado de matriz

	; por ser reset timer está en modo normal

	ldi temp, $03
	out TCCR0B, temp; configura el preescalador a 64 (primeros 4 bits para preescalador), p?g 141 atmega328.pdf
	ldi temp, $01
	sts timsk0, temp ;configura para interrupci?n por sobreflujo (sts porque timsk0 est? en 0x6e > $5f)
	sei ;habilita las interrupciones globales

	;guarda valores de b y c
	ldi temp, $07
	sts $0120, temp
	ldi temp, $0b
	sts $0121, temp
	ldi temp, $0d
	sts $0122, temp
	ldi temp, $0e
	sts $0123, temp
	ldi temp, $0f
	sts $0124, temp
	ldi temp, $0f
	sts $0125, temp
	ldi temp, $0f
	sts $0126, temp
	ldi temp, $0f
	sts $0127, temp

	;guarda valores de la primera figura
	ldi temp, $00
	sts $0100, temp
	ldi temp, $0f
	sts $0101, temp
	ldi temp, $0f
	sts $0102, temp
	ldi temp, $18
	sts $0103, temp
	ldi temp, $18
	sts $0104, temp
	ldi temp, $0f
	sts $0105, temp
	ldi temp, $0f
	sts $0106, temp
	ldi temp, $00
	sts $0107, temp
	;valores segunda figura
	ldi temp, $ff
	sts $0100, temp
	ldi temp, $ff
	sts $0101, temp
	ldi temp, $ff
	sts $0102, temp
	ldi temp, $ff
	sts $0103, temp
	ldi temp, $ff
	sts $0104, temp
	ldi temp, $ff
	sts $0105, temp
	ldi temp, $ff
	sts $0106, temp
	ldi temp, $ff
	sts $0107, temp

main:	nop
	nop
	rjmp main



timer0_ovf:cpi band, $01 ; si es 1 prende, si es 0 apaga
	breq apaga
	rjmp prende
	reti

apaga:	lds temp, $0100
	out portd, temp
	lds temp, $0120
	out portb, temp
	lds temp, $0124
	out portc, temp

	lds temp, $0100
	out portd, temp
	lds temp, $0121
	out portb, temp
	lds temp, $0125
	out portc, temp

	lds temp, $0100
	out portd, temp
	lds temp, $0122
	out portb, temp
	lds temp, $0126
	out portc, temp

	lds temp, $0100
	out portd, temp
	lds temp, $0123
	out portb, temp
	lds temp, $0127
	out portc, temp

	lds temp, $0100
	out portd, temp
	lds temp, $0124
	out portb, temp
	lds temp, $0120
	out portc, temp

	lds temp, $0100
	out portd, temp
	lds temp, $0125
	out portb, temp
	lds temp, $0121
	out portc, temp

	lds temp, $0100
	out portd, temp
	lds temp, $0126
	out portb, temp
	lds temp, $0122
	out portc, temp

	lds temp, $0100
	out portd, temp
	lds temp, $0127
	out portb, temp
	lds temp, $0123
	out portc, temp
reti

prende:	lds temp, $0100
	out portd, temp
	lds temp, $0120
	out portb, temp
	lds temp, $0124
	out portc, temp

	lds temp, $0101
	out portd, temp
	lds temp, $0121
	out portb, temp
	lds temp, $0125
	out portc, temp

	lds temp, $0102
	out portd, temp
	lds temp, $0122
	out portb, temp
	lds temp, $0126
	out portc, temp

	lds temp, $0103
	out portd, temp
	lds temp, $0123
	out portb, temp
	lds temp, $0127
	out portc, temp

	lds temp, $0104
	out portd, temp
	lds temp, $0124
	out portb, temp
	lds temp, $0120
	out portc, temp

	lds temp, $0105
	out portd, temp
	lds temp, $0125
	out portb, temp
	lds temp, $0121
	out portc, temp

	lds temp, $0106
	out portd, temp
	lds temp, $0126
	out portb, temp
	lds temp, $0122
	out portc, temp

	lds temp, $0107
	out portd, temp
	lds temp, $0127
	out portb, temp
	lds temp, $0123
	out portc, temp
reti

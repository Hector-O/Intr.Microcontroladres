;
; Matriz.asm
;
; Created: 13/03/2022 01:18:26 p. m.
; Author : Daniel
;

; Replace with your application code
    .def xd=r16
    .def xd2=r17
    .cseg
    .org 0
    ldi xd, $ff
    out portd, xd
    ldi xd, $ff
    out ddrd, xd
    
    ldi xd, $20
	out ddrc, xd
    out portc, xd
    ldi xd, $ff
    out ddrc, xd

    
    ldi xd, $00
    out portb, xd
    ldi xd, $ff
    out ddrb, xd

main:    in xd, pinc
		andi xd, $20
		cpi xd, $20
		breq U
		cpi xd, $00
		breq E
    
E:        ldi xd, $00        ////////////////////////////////////////
        out portc, xd
        ldi xd, $0e
        out portb, xd
        ldi xd, $00
        out portd, xd
/*Separador    */    ldi xd, $FF
/*            */    out portd, xd
        ldi xd, $01
        out portb,xd
        ldi xd,$24
        out portd,xd
/*Separador    */    ldi xd, $FF
/*            */    out portd, xd
        ldi xd,$0c
        out portc,xd
        ldi xd,$24
        out portd,xd
        
        rjmp main
    
U:        ldi xd, $0C     //prende los primeros 4 bits horizontal
        out portb, xd
        ldi xd, $00     //prende los primeros 4 bits horizontal
        out portc, xd
        ldi xd, $00     //Prende los bits de vertical 1 apaga 0 prende
        out portd, xd
    

/*Separador    */    ldi xd, $FF
/*            */    out portd, xd

        ldi xd, $00     //prende los primeros 4 bits horizontal
        out portc, xd
        ldi xd, $03     //prende los primeros 4 bits horizontal
        out portb, xd
        ldi xd, $3f     //Prende los bits de vertical 1 apaga 0 prende
        out portd, xd
/*Separador    */    ldi xd, $FF
/*            */    out portd, xd

        ldi xd, $00     //prende los primeros 4 bits horizontal
        out portb, xd
        ldi xd, $0f     //prende los primeros 4 bits horizontal
        out portc, xd
        ldi xd, $3f     //Prende los bits de vertical 1 apaga 0 prende
        out portd, xd
/*Separador    */    ldi xd, $FF
/*            */    out portd, xd
        ldi xd, $00     //prende los primeros 4 bits horizontal
        out portb, xd
        ldi xd, $03     //prende los primeros 4 bits horizontal
        out portc, xd
        ldi xd, $00     //Prende los bits de vertical 1 apaga 0 prende
        out portd, xd

        rjmp main
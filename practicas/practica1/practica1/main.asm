.def cont1=r17
	.def cont2=r18
	.def cont3=r19
	.def xd=r16
	.def xd2=r20
	.cseg
	.org 0

	ldi xd, $ff
	out ddrd, xd
	ldi xd, $01
	out portd, xd
	ldi xd, $03
	out portc, xd



main:	in xd, pinc
		andi xd, $03
		breq kitnormal 
		cpi xd, $03
		breq kitx2 
		cpi xd, $01
		breq outtin
		cpi xd, $02
		breq inoutt



kitnormal:  in xd, pind
			cpi xd, $01
			breq izq
		der:lsr xd
			out portd, xd
			call delay_125m
			cpi xd, $01
			brne der
			rjmp main
		izq:lsl xd
			out portd, xd
			call delay_125m
			cpi xd, $80
			breq der
			rjmp izq

			

kitx2: in xd, pind
		cpi xd, $01
		breq izq2
	der2:lsr xd
		out portd, xd
		call delay_62m
		cpi xd, $01
		brne der2
		rjmp main
	izq2:lsl xd
		out portd, xd
		call delay_62m
		cpi xd, $80
		breq der2
		rjmp izq2

outtin: ldi xd, $81
		out portd, xd
		call delay_125m
		call delay_125m
		ldi xd, $42
		out portd, xd
		call delay_125m
		call delay_125m
		ldi xd, $24
		out portd, xd
		call delay_125m
		call delay_125m
		ldi xd, $18
		out portd, xd
		call delay_125m
		call delay_125m
		rjmp main
				
		

inoutt: ldi xd, $18
		out portd, xd
		call delay_125m
		call delay_125m
		ldi xd, $24
		out portd, xd
		call delay_125m
		call delay_125m
		ldi xd, $42
		out portd, xd
		call delay_125m
		call delay_125m
		ldi xd, $81
		out portd, xd
		call delay_125m
		call delay_125m
		rjmp main



delay_125m:
			ldi cont1, 4
	lazo6:	ldi	cont2, 250
	lazo5:	ldi cont3, 200
	lazo4:	nop
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
			ret

delay_62m:
			ldi cont1, 2
	lazo3:	ldi	cont2, 250
	lazo2:	ldi cont3, 200
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
			ret
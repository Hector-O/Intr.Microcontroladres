;
; Entradas y Salidas.asm
;
; Created: 24/02/2022 02:11:28 a. m.
; Author : hecth
;


; Replace with your application code


.def temp=r16 ;pone nombre a un registro
.cseg ;esto va en el segmento de codigo
.org 0;partir de la memoria del programa en 0

;************* Programa básico para entrada o salida
;ldi temp, $20  ;0010 0000 número de pin de der a izq: 7654 3210
;out ddrb, temp ;habilita la lectura del pin5 del puerto b cargándole un 1
;;ldi temp, $00 ; se pone en 0 todo (no prende led)
;;ya se configuró ya no necesita ciclarse
;main:	out portb, temp ;pone un 0 en el pin5 del puerto b desde el registro temp
;rjmp main ;salto incondicional
;*************

;;************* Programa para mostrar resistencia de pull-up
ldi temp, $00 ;carga un 0x00 en temp (instrucción redundante, a está precargado así[reset])
out ddrd, temp ;habilita como entrada los puerto d (instrucción redundante, a está precargado así[reset])
ldi temp,$20 ;carga un 0010 0000 en temp
out portd, temp ;habilitamos la resistencia de pull-up de d5 [0 1 /ddrd port]
out ddrb, temp; configuramos b5 como salida 0x20-0010 0000

main:	in temp, pind ; leemos lo que el pin d según lo indicado en temp=0010 0000
com temp
out portb, temp ;sacamos al puerto b5 según lo dado en temp=0010 0000
rjmp main

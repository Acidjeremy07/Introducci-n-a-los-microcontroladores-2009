;
; Contador 0 a 99.asm
;
; Created: 20/12/2023 11:24:44 a. m.
; Author : Diego
;

; Replace with your application code

	.def xd=r16
	.def xd2=r17
	.def xd3=r18

	.def unidades=r19
	.def decenas=r20
	.def mux=r21
	.cseg
	.org 0
	
	rjmp reset

	.org $16
	rjmp compa
	.org $20
	rjmp timer0

reset:	ldi xd, $ff
		out ddrd, xd
		ldi xd, $01
		out portc, xd
		
		ldi xd, $ff
		out portb, xd
		ldi xd, $ff
		out ddrb, xd
		
		ldi xd, $0d
		sts tccr1b, xd
		ldi xd, $3d
		sts ocr1ah, xd
		ldi xd, $09
		sts ocr1al, xd
		ldi xd, $02
		sts timsk1, xd

		ldi xd, $0c
		out tccr0b, xd
		ldi xd, $01
		sts timsk0, xd
		
		

		ldi xd, $0a
		ldi ZL, low(display*2)
		ldi ZH, high(display*2)
		ldi XL, $00
		ldi XH, $01
lazo:	lpm r1, Z+
		st x+, r1
		dec xd
		brne lazo
		
		ldi mux, $01
		ldi unidades, $00
		ldi decenas , $00

		sei

main:	nop
		;mov XL, xd
		;ld xd2, x
		;out portd, xd2
		rjmp main

compa:	sbis pinc, 0
		rjmp decendente

;		ldi xd3, $01
;		out portb, xd3
;		lsl xd3
;		out portb, xd3
		
		inc unidades
		cpi unidades, $0a
		breq cero
		reti

decendente:	dec unidades
			cpi unidades, $ff
			breq nueve
			reti

nueve:	ldi unidades, $09
		dec decenas
		cpi decenas, $ff
		breq decrei
		reti

decrei:	ldi decenas, $09
		reti		

cero:	ldi unidades, $00
		inc decenas
		cpi decenas, $0a
		breq increi
		reti

increi: ldi decenas, $00	
		reti

timer0: ldi xd3, $03
		out portb, xd3
		

		cpi mux, $01
		breq unidadess
		
		mov XL, decenas
		ld xd2, x
		out portd, xd2
		out portb, mux
		ldi mux, $01
		reti

		reti

unidadess:	mov XL, unidades
			ld xd2, x
			out portd, xd2
			out portb, mux
			ldi mux, $02
;			cpi mux, $02
;			breq fallo
;			rjmp fallo
			reti



		.cseg
display:	.db $3F, $6, $5B, $4F, $66, $6D, $7D, $47, $7F, $67
;
; Matriz.asm
;
; Created: 16/01/2024 01:26:52 p. m.
; Author : Diego
;


; Replace with your application code
.DEF temp = r16
.def inicio =r17	
.def fin = r18
.def cont1 = r19
.def cont2= r20

.cseg
.org 0x0000
setup:	
		
		ldi temp, $FF
		out ddrd,temp
		out ddrb,temp
		out ddrc,temp

lazo20:		ldi temp, $ff
		out portd, temp
		ldi temp, $00
		out portb, temp
		out portc, temp

		jmp lazo20

		ldi XH, $01
		ldi XL, $00
		ldi ZH, high(figura*2)
		ldi ZL, low(figura*2)

		ldi temp,$10
lazo:	lpm R1,Z+
		st X+, R1
		dec temp
		brne lazo
		
		

ini_cad2:	ldi inicio,$28
			ldi fin, $28
			mov XL,inicio
fig3:	ldi cont1,$FF
fig2:	ldi cont2,$FF
fig1:	ldi temp,$FF
		out portc,temp
		out portd,temp

		ld temp,X+
		out portd,temp
		ldi temp,$07
		out portb, temp
		ldi temp,$FF
		out portb,temp

		ld temp,X+
		out portd,temp
		ldi temp,$0B
		out portb, temp
		ldi temp, $FF
		out portb,temp

		ld temp,X+
		out portd,temp
		ldi temp,$0D
		out portb, temp
		ldi temp, $FF
		out portb,temp

		ld temp,X+
		out portd,temp
		ldi temp,$0E
		out portb, temp
		ldi temp, $FF
		out portb,temp

		ld temp,X+
		out portd,temp
		ldi temp,$07
		out portc, temp
		ldi temp, $FF
		out portc,temp
		
		ld temp,X+
		out portd,temp
		ldi temp,$0B
		out portc, temp
		ldi temp, $FF
		out portc,temp

		ld temp,X+
		out portd,temp
		ldi temp,$0D
		out portc, temp
		ldi temp, $FF
		out portc,temp

		ld temp,X+
		out portd,temp
		ldi temp,$0E
		out portc, temp
		ldi temp, $FF
		out portc,temp

		mov XL,inicio
		dec cont2
		brne fig1
		dec cont1
		brne fig2

		inc inicio
		inc fin
		mov XL, inicio
		cpi fin,$61
		breq ini_cad
		jmp fig3
		
		
	ini_cad: jmp ini_Cad2
	

 
		.cseg
	 figura: .db $00,$00,$00,$00,$00,$7e,$18,$18,$18,$18,$7e,$00,$00,$00,$00,$00,$00,$00,$00,$00,$18,$24,$42,$81,$81,$42,$24,$18,$00,$00,$00,$00,$00,$00,$00,$00,$00,$7e,$02,$02,$02,$02,$02,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1e,$28,$48,$48,$28,$1e,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
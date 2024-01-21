;
; Practica8.asm
;
; Created: 09/01/2023 05:12:48 p. m.
; Author : Diego
;

	.def temp=r16
	.def cont1=r17
	.def cont2=r18
	.def contador=r19
	.def codigo_a=r20
	.def codigo_b=r21
	.cseg
	.org 0
	jmp reset

	.org $024
	jmp recibe

reset: 
	ldi contador, $00
	ldi temp, $fe ;1111 1100 d2 a d7 salida, d1 salida de lectura, d0 entrada de transmisión
	out ddrd, temp
	call delay_100ms

	ldi temp, $98 ;1001 1000
	sts ucsr0b, temp ;habilitar transmisor y receptor y la interrupción de recepción
	ldi temp, 103
	sts ubrr0l, temp

	;** Funcion set de 4 bits del lcd
	ldi temp,$28
	out portd,temp
	ldi temp,$20
	out portd,temp
	call delay_10ms

	;** Funcion set de 8 bits del lcd
	ldi temp,$28
	out portd,temp
	ldi temp,$20
	out portd,temp

	ldi temp,$88
	out portd,temp
	ldi temp,$80
	out portd,temp
	call delay_10ms

	;** Display on/off
	ldi temp,$08
	out portd,temp
	ldi temp,$00
	out portd,temp

	ldi temp,$e8
	out portd,temp
	ldi temp,$e0
	out portd,temp
	call delay_10ms

	;** mode set
	ldi temp,$08
	out portd,temp
	ldi temp,$00
	out portd,temp

	ldi temp,$68
	out portd,temp
	ldi temp,$60
	out portd,temp
	call delay_10ms

	;** clear display
	call clear
	sei

main: jmp main

recibe:
	inc contador
	cpi contador,17
	brne aux
	call bajar
aux: cpi contador,33
	brne aux2
	call clear
aux2:	lds temp, udr0
	mov codigo_a,temp
	mov codigo_b,temp
	andi codigo_a, $f0
	andi codigo_b, $0f
	lsl codigo_b
	lsl codigo_b
	lsl codigo_b
	lsl codigo_b
	call letra
	reti
	
clear: ldi temp,$08
	out portd,temp
	ldi temp,$00
	out portd,temp

	ldi temp,$18
	out portd,temp
	ldi temp,$10
	out portd,temp
	ldi contador,$00
	call delay_10ms
	ret

bajar: ldi temp,$a8
	out portd,temp
	ldi temp,$a0
	out portd,temp

	ldi temp,$88
	out portd,temp
	ldi temp,$80
	out portd,temp
	call delay_10ms
	ret

letra:
	ldi temp,$0c
	add temp,codigo_a
	out portd,temp
	ldi temp,$04
	add temp,codigo_a
	out portd,temp

	ldi temp,$0c
	add temp,codigo_b
	out portd,temp
	ldi temp,$c1
	add temp,codigo_b
	out portd,temp
	call delay_10ms

	ldi temp,$0c
	add temp,codigo_b
	out portd,temp
	ldi temp,$08
	add temp,codigo_b
	out portd,temp
	call delay_10ms
	ret

delay_10ms: ldi cont1, 80
lazo2:	ldi cont2, 200
lazo1:	nop
	nop
	nop
	nop
	nop
	nop
	nop
	dec cont2
	brne lazo1
	dec cont1
	brne lazo2
	ret

delay_100ms: call delay_10ms
	call delay_10ms
	call delay_10ms
	call delay_10ms
	call delay_10ms
	call delay_10ms
	call delay_10ms
	call delay_10ms
	call delay_10ms
	call delay_10ms
	ret
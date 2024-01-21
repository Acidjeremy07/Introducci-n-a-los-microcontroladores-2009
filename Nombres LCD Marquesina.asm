;;================================================ p3.asm ===================================================================
;============================ constantes ==========================================================
.equ	tam		=	47

.equ	portlcd	=	portd
.equ	rs		=	pd2
.equ	e		=	pd3
.equ	d4		=	pd4
.equ	d5		=	pd5
.equ	d6		=	pd6
.equ	d7		=	pd7

.equ	vo		=	pb1
;============================ variables ===========================================================
.def	temp	=	r16
.def	cont1	=	r17
.def	cont2	=	r18
.def	ms		=	r19
.def	cmdlcd	=	r20
.def	bandrs	=	r21
.def	contador =	r22
.def	contraste = r23
.def	suma5 = r24
;============================ cabecera ============================================================
		.cseg
		.org	0x0000
		jmp		reset
;============================ void setup ==========================================================
reset:		ldi		temp, $fd;						Puerto D -> Salidas
			out		ddrd, temp
			ldi		temp, $02;						Pin B1 -> PWM
			out		ddrb, temp
			ldi		temp, $0c;						Pin B2 y B3 -> Botones
			out		portb, temp;					Resistencias pull-up
;================== configura pwm ========================================
			ldi		temp, $81
			sts		tccr1a, temp
			ldi		temp, $0b;						Preescalador -> 64
			sts		tccr1b, temp;

			ldi		temp, $00
			sts		ocr1al, temp
;================== configuracion inicial ================================
			ldi		ms, 100
			call	delay_ms
			call	inilcd
			call	cargaram
			clr		bandrs

			ldi		contraste, 0
			ldi		suma5, 5
;============================ void main ===========================================================
main:		ldi		bandrs, $00
			ldi		cmdlcd, $01
			call	setcmd
			ldi		bandrs, $04

			ldi		xh, $01
			ldi		xl, $00

			ldi		contador, tam
sacasig:	ld		cmdlcd, x+
			call	setcmd
			ldi		ms, 250
			call	delay_ms
			call	pruebaboton
			ldi		ms, 250
			call	delay_ms
			call	pruebaboton
			cpi		contador, tam-14
			brsh	norec

			ldi		bandrs, $00
			ldi		cmdlcd, $18
			call	setcmd
			ldi		bandrs, $04

norec:		dec		contador
			brne	sacasig

			ldi		ms, 250
			call	delay_ms
			ldi		ms, 250
			call	delay_ms
			ldi		ms, 250
			call	delay_ms
			ldi		ms, 250
			call	delay_ms

			jmp		main
;============================ subrutinas ==========================================================
pruebaboton:cpi		contraste, $ff
			breq	baja
			sbis	pinb, 2
			add		contraste, suma5

baja:		cpi		contraste, $00
			breq	carga
			sbis	pinb, 3
			sub		contraste, suma5

carga:	sts ocr1al, contraste
		ret;
;============================ mensaje ====================================
cargaram:	ldi		zh, high(nombres*2)
			ldi		zl, low(nombres*2)
			ldi		xh, $01
			ldi		xl, $00

forsaca:	lpm		temp, z+
			st		x+, temp
			cpi		temp, $00
			brne	forsaca
			ret
;============================ lcd ========================================
inilcd:		clr		bandrs
			out		portlcd, bandrs

			ldi		cmdlcd, $20
			call	sendnible
			ldi		cmdlcd, $28
			call	setcmd
			ldi		cmdlcd, $0c
			call	setcmd
			ldi		cmdlcd, $06
			call	setcmd
			ldi		cmdlcd, $01
			call	setcmd
			ldi		cmdlcd, $02
			call	setcmd
			ret
;================== set caracter ================
setcmd:		call	sendnible
			swap	cmdlcd
			call	sendnible
			swap	cmdlcd
			ret
;================== send nible ==================
sendnible:	mov		temp, cmdlcd
			andi	temp, $f0
			or		temp, bandrs
			out		portlcd, temp

			sbi		portlcd, e
			ldi		ms, 20
			call	delay_ms
			cbi		portlcd, e
			ret
;================== delay ms ==================
delay_ms:	ldi		cont1, 16
lazo1_ms:	ldi		cont2, 200
lazo2_ms:	nop
			nop
			dec		cont2
			brne	lazo2_ms
			dec		cont1
			brne	lazo1_ms
			dec		ms
			brne	delay_ms
			ret
;============================ constantes =================================
nombres:	.db		$47, $75, $74, $69, $65, $72, $72, $65, $7a, $20, $4d, $6f, $72, $61, $6c, $65, $73, $20, $4f, $73, $63, $61, $72, $2c, $20, $47, $72, $61, $6e, $61, $64, $6f, $73, $20, $4f, $6c, $6d, $6f, $73, $20, $45, $64, $75, $61, $72, $64, $6f, $00;
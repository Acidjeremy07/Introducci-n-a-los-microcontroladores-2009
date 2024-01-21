;
; Frecuenciometro.asm
;
; Created: 20/12/2023 11:12:35 a. m.
; Author : Diego Hernandez
;

;;================================================ P3.asm ===================================================================
;============================ VARIABLES ===========================================================
.DEF temp = R16
.DEF temp2 = R17
.DEF contD1 = R18
.DEF cat = R19
.DEF uni = R20
.DEF dc = R21
.DEF cen = R22
.DEF uni2 = R23
.DEF dc2 = R24
.DEF cen2 = R25
;============================ INTERRUPCIONES ======================================================
.CSEG;
.ORG 0x0000
JMP reset
JMP INT_0
.ORG 0x001A
JMP Tmr1_ovf
.ORG 0x0020
JMP Tmr0_ovf
;============================ VOID SETUP ==========================================================
reset:
	LDI temp, $FB
	OUT DDRD, temp
	LDI temp, $0F
	OUT DDRC, temp
;================== Configuración de TMR0 ================================
	LDI temp, $03
	OUT TCCR0B, temp
	LDI temp, $01
	STS TIMSK0, temp
	LDI temp, 6
	OUT TCNT0, temp
;================== Configuración de TMR1 ================================
	LDI temp, $05
	STS TCCR1B, temp
	LDI temp, $01
	STS TIMSK1, temp
	LDI temp, $C2
	STS TCNT1H, temp
	LDI temp, $F7
	STS TCNT1L, temp
;================== Configuración de INT0 ================================
	LDI temp, $03
	STS EICRA, temp
	LDI temp, $01
	OUT EIMSK, temp
;================= Configuración adicional ===============================
	CLR dc
	CLR uni
	CLR cen

	CALL inicializar

	LDI temp, $FE
	MOV cat, temp

	LDI temp, $0F
	OUT PORTC, temp

	SEI
;============================ VOID MAIN ===========================================================
main:
	JMP		main
;============================ SUBRUTINAS ==========================================================
;================== Saca digitos =========================================
inicializar:
	LDI ZH, high(Digitos*2)
	LDI ZL, low(Digitos*2)
	LDI XH, $01
	LDI XL, $00

	LDI temp, 10
repite:
	LPM temp2, Z+
	ST X+, temp2
	DEC temp
	BRNE repite

	RET
;================== Interrupcion por TMR0 ================================
Tmr0_ovf:
	LDI temp2, $04
	OUT PORTD, temp2

	ROL cat
	SBRS cat, 4
	SWAP cat

	SBRS cat, 3
	MOV temp2, uni
	SBRS cat, 2
	MOV temp2, dc
	SBRS cat, 1
	MOV temp2, cen

DispUni:
	OUT PORTC, cat
	MOV XL, temp2
	LD temp2, X
	OUT PORTD, temp2

incTMR0:
	LDI temp2, 6
	OUT TCNT0, temp2
	RETI
;================== TMR1_OVF ====================
Tmr1_ovf:
	MOV uni, uni2
	MOV dc, dc2
	MOV cen, cen2

	CLR uni2
	CLR dc2
	CLR cen2

	LDI temp2, $C2
	STS TCNT1H, temp2
	LDI temp2, $C7
	STS TCNT1L, temp2
	RETI
;================== Int0 ========================
INT_0:
	INC uni2
	CPI uni2, $0A
	BRNE fin
	CLR uni2

	INC dc2
	CPI dc2, $0A
	BRNE fin
	CLR dc2

	INC cen2
	CPI cen2, $0A
	BRNE fin
	CLR cen2

fin:
	LDI temp2, $01
	OUT EIFR, temp2
	RETI
;============================ CONSTANTES ===========================================================
Digitos:
	.DB		$7F, $0E, $B7, $9F, $CE, $DD, $FD, $0F, $FF, $DF


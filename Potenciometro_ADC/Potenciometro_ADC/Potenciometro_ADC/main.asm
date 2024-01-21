;
; Potenciometro_ADC.asm
;
; Created: 23/10/2023 05:27:28 p. m.
; Author : jmzer
;


; Replace with your application code

	.def temp = r16
	.cseg
	.org 0

	ldi temp, $FF			//Pone el puerto D como salida
	out ddrd, temp
	
	ldi temp, $60			//Se ajusta el resultado hacia la izquieda
	sts ADMUX, temp;

	ldi temp, $01			//Se deshabilita el buffer para A0
	sts DIDR0, temp

	ldi temp, $02			//Habilita resistencia pull up en bit 1, para el boton
	out portc, temp

loop:	in temp, pinc		//Lee el puerto C
	andi temp, $02			//And con 02 para checar el estado del boton
	brne loop;				//Si no se presiona, sigue revisando el boton

	ldi temp, $C7			//Habilita ADC y establece el preescalador a 128 e inicia conversión 
	sts ADCSRA, temp


espera:	lds temp, ADCSRA	//Checar bit 4
	sbrs temp, 4
	jmp espera				//Si aun no termina espera hasta que termine

	lds temp, ADCH			//Lee los 8 bits mas significativos
	out portd, temp

	call delay30ms			//Espera 30ms para evitar rebotes del boton
	
	ldi temp, $97			//Se limpian las banderas 
	sts ADCSRA, temp

	jmp loop

delay30ms: ldi r17, 200
lazo2:	ldi r18, 240
lazo1:	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	dec r18
	brne lazo1
	dec r17
	brne lazo2



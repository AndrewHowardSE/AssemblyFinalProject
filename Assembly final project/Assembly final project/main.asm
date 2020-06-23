;
; Assembly final project.asm
;
; Created: 12/10/2018 10:58:23 AM
; Author : Andrew Howard
;



 				.include	<atxmega256a3budef.inc>
				.CSEG
				.ORG		0x00
				JMP			start

				.ORG		PORTE_INT0_VECT
				JMP			PE_INT0_ISR

				.ORG		0xF6


start:			LDI			zl, low(array << 1)	;
				LDI			zh, high(array << 1);
				LPM			R18,Z+				;
				LPM			R19,Z+				;


light:			LDI			R16,0b00110000		; D4 & D5 output
				STS			PORTD_DIR,R16		;				*
				LDI			R16,0x00			; turn off both red & green LED
				STS			PORTD_OUT,R16		;				*

				LDI			R16,0b00010011		; mode = single slope PWM
				STS			TCD1_CTRLB,R16		;				*

				LDI			R16,0				; desable event actions on CCA
				STS			TCD1_CTRLD,R16		;				*

				LDI			R16,low(20000)		; PER = 20,000
				STS			TCD1_PER,R16		;				*
				LDI			R16,high(20000)		;				*
				STS			TCD1_PER+1,R16		;				*

				STS			TCD1_CCA,R18		;				*
				STS			TCD1_CCA+1,R19		;				*

				LDI			R16,0x01			; count up
				STS			TCD1_CTRLFCLR,R16	;				*

				LDI			R16,0b00000001		; CONNECT Fper TO TCD1
				STS			TCD1_CTRLA,R16		;				*

				JMP			done				;

PE_INT0_ISR:	LDI			R16,0b00000001		; Clear the request
				STS			PORTE_INTFLAGS,R16	;				*

				LPM			R18,Z+				;
				LPM			R19,Z+				;

				LDS			R16,PORTA_IN		;   turn off A-4 LED
				ORI			R16,0b00010000		;				*
				STS			PORTA_OUT,R16		;				*


				JMP			light				;

done:			JMP			done

array:		.DB			0x00, 0x17, 0x00, 0x10, 0x00, 0x05, 0x00, 0x00

			



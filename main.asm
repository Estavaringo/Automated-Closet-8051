;Esse programa mostra uma mensagem no LCD para você escolher um compartimento (1 a 6) do CLOSET Automatizado, após isso, liga um motor DC que é desativado ao ativar uma sequência certa de sensores;
;Versão 1.0;



C1 EQU P0.0			;PINOS TECLADO
C2 EQU P0.1
C3 EQU P0.2
L1 EQU P0.3
L2 EQU P0.4
L3 EQU P0.5
L4 EQU P0.6			;
LCD EQU P2			;DADOS LCD
RS EQU P3.6			;MODO CONFIG/ESCREVER
E EQU P3.7			;PULSO GRAVAR NO LCD
S1 EQU P3.2			;SENSOR 1
S2 EQU P3.3			;SENSOR 2
S3 EQU P3.4			;SENSOR 3
SPR EQU P1.3			;SENSOR DE SEGURANÇA
RELE EQU P1.5			;LIGA RELE MOTOR


INICIO:  CLR E		;CONDIÇÃO PARA CONFIG. DISPLAY
	CLR RS		; 	''	''
	LCALL CONFIG	;IR PARA CONFIG. (DISPLAY);
	LCALL MENSAGEM1	;IR PARA MENSAGEM DE INICIALIZAÇÃO;
	LJMP LCDS ;VAI PARA MENSAGEM DE MENU;

LCDS:	CLR E
	LCALL CONFIG	;IR PARA CONFIG. PADRAO DO DISPLAY;
	LCALL MENSAGEM5	;IR PARA MENSAGEM DO MENU;
	CLR RS		;MODO CONFIGURAÇÃO;
	LJMP TECLADO	;VAI PARA ROTINA DE LEITURA DO TECLADO;


;ROTINA DE LEITURA DO TECLADO;
TECLADO:	
RASTREAR:	CLR C1
		JNB L1, UM1
		JNB L2, QUATRO1
		JNB L4, ESTRELA
		SETB C1

		CLR C2
		JNB L1, DOIS1
		JNB L2, CINCO1
		SETB C2

		CLR C3
		JNB L1, TRES1
		JNB L2, SEIS1
		SETB C3
		LJMP RASTREAR

UM1:		LJMP UM
QUATRO1:		LJMP QUATRO
DOIS1:		LJMP DOIS
CINCO1:		LJMP CINCO
TRES1:		LJMP TRES
SEIS1: 		LJMP SEIS
;FIM DA ROTINA DE LEITURA DO TECLADO;

;ROTINA PARA SELEÇÃO DE MENSAGEM DO MENU;
ESTRELA:		JNB L4, ESTRELA		;ESPERAR SOLTAR BOTAO
		CJNE R0, #1, MSG1	;SE R0 FOR 1, CONTINUA, SE NÃO, VAI P/ MSG SELEC. 1
		LCALL CONFIG		;RODA CONFIG PADRAO LCD
		LCALL MENSAGEM10		;MENSAGEM DE SELEÇÃO 2
		LJMP TECLADO		;VOLTA PARA ROTINA DO TECLADO

MSG1:		LCALL CONFIG		;CONFIG. PADRÃO DO LCD
		LCALL MENSAGEM5		;MENSAGEM DE SELEÇÃO 1 (MENU)
		LJMP TECLADO		;VOLTA PARA ROTINA DO TECLADO

;ROTINA PARA AÇÃO DOS BOTÕES;
UM:		MOV R7, #01		;SALVA O PRÓMIXO COMPARTIMENTO
SOLTAR1:		JNB L1, SOLTAR1
		CJNE R6, #01, CONT1
		LJMP MENSAGEM21
CONT1:		LCALL CONFIG		;CONFIG. PADRÃO DO LCD
		LCALL MENSAGEM14		;MENSAGEM APÓS SELECIONAR COMPARTIMENTO
		LCALL CONFIG2		;CONFIG 2 DO LCD
		LCALL MENSAGEM15		;MENSAGEM DE COMPARTIMENTO 1
		LCALL LMOTOR		;LIGA MOTOR
SENSOR1:		LCALL LEITURA1		;VAI PARA SENSOR DE PARADA
OK1:		JNB S1, OK1
		MOV R6, #01		;SALVA O COMPARTIMENTO ATUAL
		LJMP DMOTOR		;VAI PARA ROTINA DE DESLIGAR O MOTOR

DOIS:		MOV R7, #02		;SALVA O PRÓXIMO COMPARTIMENTO
SOLTAR2:		JNB L1, SOLTAR2
		CJNE R6, #02, CONT2
		LJMP MENSAGEM21
CONT2:		LCALL CONFIG		;CONFIG PADRÃO DO LCD
		LCALL MENSAGEM14		;MENSAGEM APÓS SELECIONAR COMPARTIMENTO
		LCALL CONFIG2		;CONFIG 2 DO LCD
		LCALL MENSAGEM16		;MENSAGEM DO COMPARTIMENTO 2
		LCALL LMOTOR		;LIGA MOTOR
SENSOR2:		LCALL LEITURA2 		;VAI PARA SENSOR DE PARADA
		MOV R6, #02		;SALVA O COMPARTIMENTO ATUAL
		LJMP DMOTOR		;VAI PARA ROTINA DE DESLIGAR MOTOR
		
TRES:		MOV R7, #03		;SALVA O PRÓXMO COMPARTIMENTO
SOLTAR3:		JNB L1, SOLTAR3
		CJNE R6, #03, CONT3
		LJMP MENSAGEM21
CONT3:		LCALL CONFIG		;CONFIG PADRAO DO LCD
		LCALL MENSAGEM14		;MENSAGEM APÓS SELECIONAR O COMPARTIMENTO
		LCALL CONFIG2		;CONFIG 2 DO LCD
		LCALL MENSAGEM17		;MENSAGEM DO COMPARTIMENTO 3
		LCALL LMOTOR		;LIGA MOTOR
SENSOR3:		LCALL LEITURA3		;VAI PARA O SENSOR DE PARADA
		MOV R6, #03		;SALVA O COMPARTIMENTO ATUAL
		LJMP DMOTOR		;VAI PARA ROTINA DE DESLIGAR O MOTOR
		
QUATRO:		MOV R7, #04
SOLTAR4:		JNB L2, SOLTAR4
		CJNE R6, #04, CONT4
		LJMP MENSAGEM21
CONT4:		LCALL CONFIG		;
		LCALL MENSAGEM14
		LCALL CONFIG2
		LCALL MENSAGEM18
		LCALL LMOTOR		;LIGA MOTOR
SENSOR4:		LCALL LEITURA4		;SENSOR DE PARADA
		MOV R6, #04
		LJMP DMOTOR
		
CINCO:		MOV R7, #05
SOLTAR5:		JNB L2, SOLTAR5
		CJNE R6, #05, CONT5
		LJMP MENSAGEM21
CONT5:		LCALL CONFIG
		LCALL MENSAGEM14
		LCALL CONFIG2
		LCALL MENSAGEM19
		LCALL LMOTOR		;LIGA MOTOR
SENSOR5:		LCALL LEITURA5		;SENSOR DE PARADA
		MOV R6, #05
		LJMP DMOTOR
		
SEIS:		MOV R7, #06
SOLTAR6:		JNB L2, SOLTAR6
		CJNE R6, #06, CONT6
		LJMP MENSAGEM21
CONT6:		LCALL CONFIG
		LCALL MENSAGEM14
		LCALL CONFIG2
		LCALL MENSAGEM20
		LCALL LMOTOR		;LIGA MOTOR
SENSOR6:		LCALL LEITURA6		;SENSOR DE PARADA
		MOV R6, #06
		LJMP DMOTOR

;ROTINA DOS SENSORES DE PARADA DO MOTOR;

SOLTA1:		JNB S1, SOLTA1
		JNB S2, SOLTA1
		JNB S3, SOLTA1
LEITURA1:	LCALL SENSORP
		CJNE R5, #42, CONTL1
		LCALL CONFIG		;CONFIG. PADRÃO DO LCD
		LCALL MENSAGEM14		;MENSAGEM APÓS SELECIONAR COMPARTIMENTO
		LCALL CONFIG2		;CONFIG 2 DO LCD
		LCALL MENSAGEM15		;MENSAGEM DE COMPARTIMENTO 1
		MOV R5, #00
CONTL1:		JNB S2, SOLTA1
		JB S1, LEITURA1
		JNB S3, SOLTA1
SOLTA11:		JNB S3, SOLTA1
		JNB S2, SOLTA1
		JNB S1, SOLTA11
		RET


SOLTA2:		JNB S2, SOLTA2
		JNB S1, SOLTA2
		JNB S3, SOLTA2
LEITURA2:	LCALL SENSORP
		CJNE R5, #42, CONTL2
		LCALL CONFIG		;CONFIG. PADRÃO DO LCD
		LCALL MENSAGEM14		;MENSAGEM APÓS SELECIONAR COMPARTIMENTO
		LCALL CONFIG2		;CONFIG 2 DO LCD
		LCALL MENSAGEM16		;MENSAGEM DE COMPARTIMENTO 1
		MOV R5, #00
CONTL2:		JB S2, LEITURA2
		JNB S1, SOLTA2
		JNB S3, SOLTA2
		JB S2, LEITURA2
		JNB S1, SOLTA2
SOLTA21:		JNB S1, SOLTA2
		JNB S3, SOLTA2
		JNB S2, SOLTA21
		RET
		
SOLTA3:		JNB S1, SOLTA3
		JNB S2, SOLTA3
		JNB S3, SOLTA3
LEITURA3:	LCALL SENSORP
		CJNE R5, #42, CONTL3
		LCALL CONFIG		;CONFIG. PADRÃO DO LCD
		LCALL MENSAGEM14		;MENSAGEM APÓS SELECIONAR COMPARTIMENTO
		LCALL CONFIG2		;CONFIG 2 DO LCD
		LCALL MENSAGEM17		;MENSAGEM DE COMPARTIMENTO 1
		MOV R5, #00
CONTL3:		JB  S1, LEITURA3
		JB  S2, LEITURA3
		JNB S3, SOLTA3
SOLTA31:		JNB S3, SOLTA3
		JNB S1, SOLTA31
		JNB S2, SOLTA31
		RET

		
SOLTA4:		JNB S3, SOLTA4
		JNB S2, SOLTA4
		JNB S1, SOLTA4
LEITURA4:	LCALL SENSORP
		CJNE R5, #42, CONTL4
		LCALL CONFIG		;CONFIG. PADRÃO DO LCD
		LCALL MENSAGEM14		;MENSAGEM APÓS SELECIONAR COMPARTIMENTO
		LCALL CONFIG2		;CONFIG 2 DO LCD
		LCALL MENSAGEM18		;MENSAGEM DE COMPARTIMENTO 1
		MOV R5, #00
CONTL4:		JB S3, LEITURA4
		JNB S1, SOLTA4
		JNB S2, SOLTA4
SOLTA41:		JNB S1, SOLTA4
		JNB S2, SOLTA4
		JNB S3, SOLTA41
		RET
		
SOLTA5:		JNB S1, SOLTA5
		JNB S3, SOLTA5
		JNB S2, SOLTA5
LEITURA5:	LCALL SENSORP
		CJNE R5, #42, CONTL5
		LCALL CONFIG		;CONFIG. PADRÃO DO LCD
		LCALL MENSAGEM14		;MENSAGEM APÓS SELECIONAR COMPARTIMENTO
		LCALL CONFIG2		;CONFIG 2 DO LCD
		LCALL MENSAGEM19		;MENSAGEM DE COMPARTIMENTO 1
		MOV R5, #00
CONTL5:		JB  S1, LEITURA5
		JB  S3, LEITURA5
		JNB  S2, SOLTA5
SOLTA51:		JNB S2, SOLTA5
		JNB S1, SOLTA51
		JNB S3, SOLTA51
		RET

SOLTA6:		JNB S2, SOLTA6
		JNB S3, SOLTA6
		JNB S1, SOLTA6
LEITURA6:	LCALL SENSORP
		CJNE R5, #42, CONTL6
		LCALL CONFIG		;CONFIG. PADRÃO DO LCD
		LCALL MENSAGEM14		;MENSAGEM APÓS SELECIONAR COMPARTIMENTO
		LCALL CONFIG2		;CONFIG 2 DO LCD
		LCALL MENSAGEM20		;MENSAGEM DE COMPARTIMENTO 1
		MOV R5, #00
CONTL6:		JB S3, LEITURA6
		JB  S2, LEITURA6
		JNB  S1, SOLTA6
SOLTA61:		JNB S1, SOLTA6
		JNB S2, SOLTA61
		JNB S3, SOLTA61
		RET
;FIM DA ROTINA DE SENSORES DE PARADA DO MOTOR;


;ROTINA PARA LIGAR MOTOR;
LMOTOR:	CLR RELE
	LCALL SENSORP
	RET



;ROTINA PARA DESLIGAR MOTOR;
DMOTOR:	SETB RELE
	LJMP LCDS


;CONFIG. PADRÃO DO LCD;
CONFIG:	CLR RS		;MODO CONFIGURAÇÃO
	MOV LCD, #38H	;CÓDIGO DISPLAY 2X16
	LCALL PULSARE	;PULSO PARA LER OS DADOS DE CONFIG
	MOV LCD, #38H	;CÓDIGO DISPLAY 2X16 8BITS
	LCALL PULSARE
	MOV LCD, #01H	;LIMPAR LCD
	LCALL PULSARE
	MOV LCD, #0DH	;CURSOR PISCANTE;
	LCALL PULSARE
	SETB RS
	RET

;DELAY DO ENABLE DO LCD;
DELAY:	MOV R1, #255
DL1:	MOV R2, #20
DL2:	DJNZ R2, DL2
	DJNZ R1, DL1
	RET

;ROTINA PARA DAR ENABLE NO LCD;
PULSARE:	SETB E
	LCALL DELAY
	CLR E
	RET

;DELAY DA MENSAGEM DE INICIALIZAÇÃO;
DELAY2:	MOV R1, #255
DL12:	MOV R2, #255
DL22:	MOV R3, #20
DL32:	DJNZ R3, DL32
	DJNZ R2, DL22
	DJNZ R1, DL12
	RET

DELAY3:	MOV R1, #255
DL13:	MOV R2, #200
DL23:	MOV R3, #1
DL33:	DJNZ R3, DL33
	DJNZ R2, DL23
	DJNZ R1, DL13
	RET

;ROTINA DO SENSOR DA PORTA;
SENSORP:	MOV R5, #00
	JNB SPR, PARADA
	RET
RETORNO: RET
PARADA:	JB SPR, RETORNO
	LCALL PARADA1
	CLR RELE
	MOV R5, #42
	RET
	
PARADA1:	SETB RELE
	LCALL MENSAGEMP
PARADA2:	JNB SPR, PARADA2
	LCALL DELAY3
	JNB SPR, PARADA2
	LCALL DELAY3
	JNB SPR, PARADA2
	LCALL DELAY3
	JNB SPR, PARADA2
	RET
;FIM DA ROTINA DO SENSOR DA PORTA;

;ROTINA PARA ESCREVER NO LCD;
TEXTO:	CLR A
	MOVC A, @A+DPTR
	JZ CONT
	LCALL ESC_LCD
	INC DPTR
	LJMP TEXTO
CONT:	RET

ESC_LCD:	SETB RS
	MOV LCD, A
	LCALL PULSARE
	RET
;FIM DA ROTINA PARA ESCREVER NO LCD

;MENSAGENS DO LCD;
MENSAGEM1:MOV DPTR, #DB1
	LCALL TEXTO
	LCALL DELAY3
	LCALL DELAY3
	LCALL DELAY3
	CLR RELE
SOLTA12:		JNB S1, SOLTA12
		JNB S2, SOLTA12
		JNB S3, SOLTA12
LEITURA12:	JNB S2, SOLTA12
		JB S1, LEITURA12
		JNB S3, SOLTA12
SOLTA112:	JNB S3, SOLTA12
		JNB S2, SOLTA12
		JNB S1, SOLTA112
		MOV R6, #01
;DESLIGAR MOTOR;
PULA:	SETB RELE

	CLR RS		;MODO CONFIGURAÇÃO
	MOV LCD, #01H	;LIMPAR LCD
	LCALL PULSARE

MENSAGEM2:MOV DPTR, #DB2
	LCALL TEXTO

	CLR RS		;MODO CONFIGURAÇÃO;
	MOV LCD, #94H	;POSI CIONAR CURSOR;
	LCALL PULSARE
	
MENSAGEM3:MOV DPTR, #DB3
	LCALL TEXTO
	LCALL DELAY2

	CLR RS		;MODO CONFIGURAÇÃO;
	MOV LCD, #01H	;LIMPAR LCD;
	LCALL PULSARE
	MOV LCD, #0C5H	;POSICIONAR CURSOR;
	LCALL PULSARE


MENSAGEM4:MOV DPTR, #DB4
	LCALL TEXTO
	LCALL DELAY2
	RET

MENSAGEM5:MOV R0, #1
	MOV DPTR, #DB5
	LCALL TEXTO

	CLR RS		;MODO CONFIGURAÇÃO;
	MOV LCD, #0C0H	;POSICIONAR CURSOR;
	LCALL PULSARE
	LCALL DELAY
	
MENSAGEM6:MOV DPTR, #DB6
	LCALL TEXTO

	CLR RS		;MODO CONFIGURAÇÃO;
	MOV LCD, #94H	;POSICIONAR CURSOR;
	LCALL PULSARE
	LCALL DELAY

MENSAGEM7:MOV DPTR, #DB7
	LCALL TEXTO

	CLR RS		;MODO CONFIGURAÇÃO;
	MOV LCD, #0D4H	;POSICIONAR CURSOR;
	LCALL PULSARE
	LCALL DELAY

MENSAGEM8:MOV DPTR, #DB8
	LCALL TEXTO

	CLR RS		;MODO CONFIGURAÇÃO;
	MOV LCD, #0E2H	;POSICIONAR CURSOR;
	LCALL PULSARE
	LCALL DELAY

MENSAGEM9:MOV DPTR, #DB9
	LCALL TEXTO
	CLR RS
	MOV LCD, #0E7H
	LCALL PULSARE
	RET

MENSAGEM10:MOV R0, #0
	MOV DPTR, #DB10
	LCALL TEXTO


	CLR RS		;MODO CONFIGURAÇÃO;
	MOV LCD, #0C0H	;POSICIONAR CURSOR;
	LCALL PULSARE
	LCALL DELAY

MENSAGEM11:MOV DPTR, #DB11
	LCALL TEXTO


	CLR RS		;MODO CONFIGURAÇÃO;
	MOV LCD, #94H	;POSICIONAR CURSOR;
	LCALL PULSARE
	LCALL DELAY

MENSAGEM12:MOV DPTR, #DB12
	LCALL TEXTO

	CLR RS		;MODO CONFIGURAÇÃO;
	MOV LCD, #0E0H	;POSICIONAR CURSOR;
	LCALL PULSARE
	LCALL DELAY

MENSAGEM13:MOV DPTR, #DB13
	LCALL TEXTO
	CLR RS
	MOV LCD, #0E7H
	LCALL PULSARE
	RET 


MENSAGEM14:MOV DPTR, #DB14
	LCALL TEXTO
	RET

CONFIG2:CLR RS		;MODO CONFIGURAÇÃO;
	MOV LCD, #0C0H	;POSICIONAR CURSOR;
	LCALL PULSARE
	LCALL DELAY
	RET
	
MENSAGEM15:MOV A, #01
	MOV DPTR, #DB15
	LCALL TEXTO
	RET

MENSAGEM16:MOV A, #02
	MOV DPTR, #DB16
	LCALL TEXTO
	RET

MENSAGEM17:MOV A, #03
	MOV DPTR, #DB17
	LCALL TEXTO
	RET

MENSAGEM18:MOV A, #04
	MOV DPTR, #DB18
	LCALL TEXTO
	RET
	
MENSAGEM19:MOV A, #05
	MOV DPTR, #DB19
	LCALL TEXTO
	RET

MENSAGEM20:MOV A, #06
	MOV DPTR, #DB20
	LCALL TEXTO
	RET

MENSAGEM21:MOV DPTR, #DB21
	LCALL CONFIG
	LCALL TEXTO

MENSAGEM22:CLR RS		;MODO CONFIGURAÇÃO;
	MOV LCD, #0C0H	;POSICIONAR CURSOR;
	LCALL PULSARE
	LCALL DELAY
	MOV DPTR, #DB22
	LCALL TEXTO
	LCALL DELAY2
	LJMP LCDS

MENSAGEMP:MOV DPTR, #DB23
	LCALL CONFIG
	LCALL TEXTO

MENSAGEMP2:CLR RS		;MODO CONFIGURAÇÃO;
	MOV LCD, #0C0H	;POSICIONAR CURSOR;
	LCALL PULSARE
	LCALL DELAY
	MOV DPTR, #DB24
	LCALL TEXTO
	RET

DB1:	DB	'INICIANDO...', 0
DB2:	DB	'CLOSET AUTOMATIZADO', 0
DB3:	DB	'VERSAO 1.0', 0
DB4:	DB	'BEM VINDO!', 0
DB5:	DB	'SELECIONE', 0
DB6:	DB	'1 - CALCAS', 0
DB7:	DB	'2 - SOCIAL', 0
DB8:	DB	'3 - BLUSAS', 0
DB9:	DB	'*-MAIS', 0
DB10:	DB	'4 - SAPATOS', 0
DB11:	DB	'5 - CAMISAS', 0
DB12:	DB	'6 - VESTIDOS', 0
DB13:	DB	'*-VOLTAR', 0
DB14:	DB	'COMPARTIMENTO:', 0
DB15:	DB	'1 - CALCAS', 0
DB16:	DB	'2 - SOCIAL', 0
DB17:	DB	'3 - BLUSAS/BOLSAS', 0
DB18:	DB	'4 - SAPATOS', 0
DB19:	DB	'5 - CAMISAS', 0
DB20:	DB	'6 - VESTIDOS', 0
DB21:	DB	'COMPARTIMENTO JA', 0
DB22:	DB	'SELECIONADO', 0
DB23:	DB	'SENSOR DE SEGURANCA', 0
DB24:	DB	'ATIVADO', 0

END
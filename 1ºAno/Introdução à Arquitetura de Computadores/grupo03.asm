; ***************************************************
; * IST-UL                                          *
; * Modulo:     main.asm                            *
; * Grupo: 3                                        *
; * Autores:    Ana Caldeira (ist1103258)           *
; *             Bernardo Sousa (ist1103191)         *
; *             Francisco Gouveia (ist1102571)      *
; ***************************************************





; **************
; * Constantes *
; **************
TEC_LIN				    EQU 0C000H	; endereço das linhas do teclado (periférico POUT-2)
TEC_COL				    EQU 0E000H	; endereço das colunas do teclado (periférico PIN)
LINHA_TECLADO		    EQU 8		; linha a testar (4ª linha, 1000b)
MASCARA				    EQU 0FH		; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
TECLA_ESQUERDA		    EQU 0		; tecla 0 no teclado
TECLA_DIREITA		    EQU 2		; tecla 2 no teclado
TECLA_E 	           	EQU 14      ; tecla C no teclado
TECLA_D                 EQU 13      ; tecla D no teclado
TECLA_C                 EQU 12      ; tecla C no teclado
TECLA_MISSIL            EQU 1       ; tecla 1 no teclado


; ********** MEDIA_CENTER **********
DEFINE_LINHA    	    EQU 600AH   ; endereço do comando para definir a linha
DEFINE_COLUNA   		EQU 600CH   ; endereço do comando para definir a coluna
DEFINE_PIXEL    		EQU 6012H   ; endereço do comando para escrever um pixel
APAGA_AVISO     		EQU 6040H   ; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRA	 	 	    EQU 6002H  	; endereço do comando para apagar todos os pixels já desenhados
SELECT_CEN_FUNDO	 	EQU 6042H   ; endereço do comando para selecionar o cenário de fundo a visualizar
TOCA_SOM_VID			EQU 605AH   ; endereço do comando para tocar um som/vídeo
SELECT_CEN_FRONTAL 		EQU 6046H   ; endereço do comando para selecionar um cenário frontal
APAGA_CEN_FRONTAL		EQU 6044H   ; endereço do comando para apagar o cenário frontal atual
TOCA_SOM_VID_ETERNO		    EQU 605CH   ; endereço do comando para tocar um som/video de forma cíclica
PAUSA_SOM_VID			EQU 605EH   ; endereço do comando para pausar um som/vídeo
; **********************************


; ********** MOVIMENTO_ROVER **********
MIN_COLUNA		        EQU 0		; número da coluna mais à esquerda que o objeto pode ocupar 
MAX_COLUNA		        EQU 63      ; número da coluna mais à direita que o objeto pode ocupar
MAX_LINHA               EQU 31      ; número da linha mais a baixo que o objeto pode ocupar
MAX_ATRASO			    EQU 50		; atraso para limitar a velocidade de movimento do rover
MAIS_UM_END             EQU 2       ; valor para incrementar endereços em uma unidade
; *************************************


; ********** NAVE **********
ALTURA_NAVE             EQU  4      ; altura do rover
LARGURA_NAVE	        EQU	5		; largura do rover
LINHA_NAVE        	    EQU 28      ; linha inicial do rover
COLUNA_NAVE			    EQU 30     	; coluna inicial do rover
COR_NAVE                EQU 0A0DFH  ; cor do pixel azul do rover
; **************************


; ********** METEORO **********
ALTURA_MET_1            EQU 1       ; altura do metoro de tamanho 1
LARGURA_MET_1           EQU 1       ; largura do metoro de tamanho 1
ALTURA_MET_2            EQU 2       ; altura do metoro de tamanho 2
LARGURA_MET_2           EQU 2       ; largura do metoro de tamanho 2
ALTURA_MET_3            EQU 3       ; altura do metoro de tamanho 3
LARGURA_MET_3           EQU 3       ; largura do metoro de tamanho 3
ALTURA_MET_4            EQU 4       ; altura do metoro de tamanho 4
LARGURA_MET_4           EQU 4       ; largura do metoro de tamanho 4
ALTURA_MET_5            EQU 5       ; altura do metoro de tamanho 5
LARGURA_MET_5           EQU 5       ; largura do meteoro de tamanho 5
LINHA_MET          	    EQU 0       ; linha inicial do meteoro
COLUNA_MET              EQU 20      ; coluna inicial do meteoro
COR_MET_CINZE           EQU 0F666H  ; cor do pixel cinzento do meteoro
COR_MET_BRAN            EQU 0FDDDH  ; cor do pixel branco do meteoro
COR_MET_CINZA           EQU 0F777H  ; cor do pixel cinza do meteoro
COR_MET_AMA             EQU 0FFC0H  ; cor do pixel amarelo do meteoro
COR_MET_LAR             EQU 0FF80H  ; cor do pixel laranja do meteoro
COR_MET_VERM            EQU 0FF00H  ; cor do pixel vermelho do meteoro
COR_MET_VERD            EQU 0F0F0H  ; cor do pixel verde do meteoro bom
MAX_ALT_TABLE           EQU 14      ; ultima linha para a qual se muda a table met
MOV_ALT_TBL             EQU 3       ; valor para o qual o meteoro vai alterando de desenho (3 em 3)
NUM_MET 			    EQU 4	    ; quantidade de meteoros a spawnar
MET_BOM			        EQU 1	    ; flag para saber que é um meteoro bom
MET_MAU    		        EQU -1	    ; flag para saber que é um meteoro mau
; *****************************


; ********** DISPLAY **********
DISPLAYS                EQU 0A000H  ; endereço dos displays de 7 segmentos (periférico POUT-1)
PONTUACAO_INICIAL       EQU 0064H   ; valor inicial do display
HEXTODEC_HELPER         EQU 000AH   ; variavel auxiliar na conversão de hexadecimal para decimal
MAX_DISPLAY_D           EQU 0100H   ; valor máximo do display para mostrar em decimal
MAX_DISPLAY_H           EQU 0064H   ; valor maximo do display em hexadecimal
MIN_DISPLAY             EQU 0H      ; valor minimo do display
DEC_DISPLAY				EQU -5		; valor para decrementar a energia do display
INC_DESTROI_MET			EQU 10		; valor para incrementar a energia quando se destroi um meteoro mau
INC_MET_BOM				EQU 15 		; valor para incrementar a energia quando se colide com um meteoro bom
; *****************************


; ********** MISSIL ***********
MAX_LINHA_MISSIL        EQU 16      ; coluna até qual o míssil dispara (meio do ecrã)
ALTURA_MISSIL           EQU 1       ; altura do míssil (em píxels)
LARGURA_MISSIL    	    EQU 1       ; largura do míssil (em píxels)
COR_MISSIL              EQU 0FA0FH	; cor do pixel do missil do rover
; *****************************


; ********** FLAGS **********
ATIVO                   EQU 1       ; valor para verificar se uma flag está ativa
INATIVO                 EQU 0       ; valor para verificar se uma flag está inativa
MOVE_ESQUERDA           EQU -1      ; valor para movimento para a esquerda (menos uma coluna)
MOVE_DIREITA            EQU 1       ; valor para movimento para a direita (mais uma coluna)
; ***************************


; ********** ESTADOS **********
STOP                    EQU -1      ; estado em que o programa não corre e apenas pode ser reiniciado
START                   EQU 1		; estado em que o programa tem que reiniciar todos os processos
PAUSED                  EQU 0	    ; estado em que o programa está pausado e pode continuar a qualquer momento
RUNNING                 EQU 2		; estado em que o programa esta a correr e pode ser pausado em qualquer momento
; *****************************


; **********
; * STACKS *
; **********
PLACE 2000H       

STACK 100H			    ; stack do processo inicial (main)						            
SP_process_inicial:	

STACK 100H              ; stack do processo do teclado
SP_teclado:

STACK 100H              ; stack do processo do rover
SP_nave:

STACK 100H              ; stack do processo do meteoro nº1
SP_meteoro_0:

STACK 100H              ; stack do processo do meteoro nº2
SP_meteoro_1:

STACK 100H              ; stack do processo do meteoro nº3
SP_meteoro_2:

STACK 100H              ; stack do processo do meteoro nº4
SP_meteoro_3:

STACK 100H              ; stack do processo do display
SP_display:

STACK 100H              ; stack do processo do míssil
SP_move_missil:


; ********** TABELA_EXCEPÇÕES **********
tabela_excep:
     WORD interrupt_0   ; rotina de atendimento da interrupção meteoros
     WORD interrupt_1   ; rotina de atendimento da interrupção missíl
     WORD interrupt_2   ; rotina de atendimento da interrupção energia
; **************************************


; ********** TABELA_NAVE **********
DEF_NAVE:
    WORD    ALTURA_NAVE, LARGURA_NAVE
    WORD    COR_NAVE, 0, COR_NAVE, 0, COR_NAVE                     
	WORD	COR_NAVE, 0, 0, 0, COR_NAVE		            		
	WORD	COR_NAVE, COR_NAVE, 0, COR_NAVE, COR_NAVE      
	WORD    0, COR_NAVE, 0, COR_NAVE, 0 
; *********************************


; ********** TABELA_METEORO **********
DEF_METEORO_1:
    WORD    ALTURA_MET_1, LARGURA_MET_1
    WORD    COR_MET_CINZE

DEF_METEORO_2:
    WORD    ALTURA_MET_2, LARGURA_MET_2
    WORD    COR_MET_CINZE, COR_MET_CINZE
    WORD    COR_MET_CINZE, COR_MET_CINZE

DEF_MET_BOM_3:
    WORD    ALTURA_MET_3, LARGURA_MET_3
    WORD    0, COR_MET_VERD, 0
    WORD    COR_MET_VERD, COR_MET_VERD, COR_MET_VERD
    WORD    0, COR_MET_VERD, 0

DEF_MET_BOM_4:
    WORD    ALTURA_MET_4, LARGURA_MET_4
    WORD    0, COR_MET_VERD, COR_MET_VERD, 0
    WORD    COR_MET_VERD, COR_MET_VERD, COR_MET_VERD, COR_MET_VERD
    WORD    COR_MET_VERD, COR_MET_VERD, COR_MET_VERD, COR_MET_VERD
    WORD    0, COR_MET_VERD, COR_MET_VERD, 0

DEF_MET_BOM_5:
    WORD    ALTURA_MET_5, LARGURA_MET_5
    WORD    0, COR_MET_VERD, COR_MET_VERD, COR_MET_VERD, 0
    WORD    COR_MET_VERD, COR_MET_VERD, COR_MET_VERD, COR_MET_VERD, COR_MET_VERD
    WORD    COR_MET_VERD, COR_MET_VERD, COR_MET_VERD, COR_MET_VERD, COR_MET_VERD
    WORD    COR_MET_VERD, COR_MET_VERD, COR_MET_VERD, COR_MET_VERD, COR_MET_VERD
    WORD    0, COR_MET_VERD, COR_MET_VERD, COR_MET_VERD, 0

DEF_MET_MAU_3:
    WORD    ALTURA_MET_3, LARGURA_MET_3
    WORD    0, COR_MET_CINZA, 0
    WORD    COR_MET_CINZA, COR_MET_CINZA, COR_MET_CINZA
    WORD    0, COR_MET_CINZA, 0

DEF_MET_MAU_4:
    WORD    ALTURA_MET_4, LARGURA_MET_4
    WORD    0, COR_MET_CINZA, COR_MET_CINZA, 0
    WORD    COR_MET_CINZA, COR_MET_AMA, 0, COR_MET_CINZA
    WORD    COR_MET_AMA, COR_MET_LAR, COR_MET_LAR, COR_MET_LAR
    WORD    0, COR_MET_VERM, COR_MET_VERM, 0

DEF_MET_MAU_5:
    WORD   ALTURA_MET_5, LARGURA_MET_5
    WORD   0, COR_MET_CINZA, COR_MET_CINZA, COR_MET_CINZA, 0                        
    WORD   COR_MET_AMA, COR_MET_CINZA, COR_MET_BRAN, COR_MET_AMA, COR_MET_CINZA    
    WORD   COR_MET_LAR, COR_MET_AMA, COR_MET_AMA, COR_MET_LAR, COR_MET_AMA        
    WORD   COR_MET_VERM, COR_MET_LAR, COR_MET_LAR, COR_MET_VERM, COR_MET_LAR     
    WORD   0, COR_MET_VERM, COR_MET_VERM, COR_MET_VERM, 0                       

MET_EXPLODIDO:
    	WORD   ALTURA_MET_5
    	WORD   LARGURA_MET_5
    	WORD   COR_MET_VERM, 0, COR_MET_VERM,0 , COR_MET_VERM           	
    	WORD   0, COR_MET_VERM,0, COR_MET_VERM, 0          				
    	WORD   COR_MET_VERM, 0, COR_MET_VERM,0 , COR_MET_VERM          
    	WORD   0, COR_MET_VERM,0, COR_MET_VERM, 0          			
    	WORD   COR_MET_VERM, 0, COR_MET_VERM,0 , COR_MET_VERM      

T_METS_MAUS:
	WORD DEF_METEORO_1
	WORD DEF_METEORO_2
	WORD DEF_MET_MAU_3
	WORD DEF_MET_MAU_4
	WORD DEF_MET_MAU_5
	
T_METS_BONS:
    WORD DEF_METEORO_1
	WORD DEF_METEORO_2
	WORD DEF_MET_BOM_3
	WORD DEF_MET_BOM_4
	WORD DEF_MET_BOM_5

T_SP_METEOROS:
	WORD SP_meteoro_0
	WORD SP_meteoro_1
	WORD SP_meteoro_2
	WORD SP_meteoro_3

T_POS_METEOROS:
	WORD 0, 0							; par (linha, coluna) do met_0
	WORD 0, 0							; par (linha, coluna) do met_1
	WORD 0, 0							; par (linha, coluna) do met_2
	WORD 0, 0							; par (linha, coluna) do met_3

T_ESTADO_MET:
	WORD 0,0,0,0						; estado de cada meteoro (MET_MAU ou MET_BOM)
; ************************************


; ********** MÍSSIL **********
TABLE_MISSIL:							; tabela para desenhar o missil
	WORD ALTURA_MISSIL
	WORD LARGURA_MISSIL
	WORD COR_MISSIL
ACABA_MISSIL:							; variavel estado para acabar o missil
	WORD 0								; no caso de ele colidir com um meteoro
; *****************************


; ********** DISPLAY **********
VALOR_DISPLAY:
    WORD PONTUACAO_INICIAL				; variavel que guarda o valor da energia
; *****************************


; ********** POSIÇÕES **********
POS_NAVE: 
    WORD LINHA_NAVE, COLUNA_NAVE        ; tabela com a posicao da nave (linha, coluna)

POS_MISSIL:								; tabela com a posicao do missil (linha ,coluna)
	WORD 0, 0                      
; ******************************


; ********** LOCKS_PROCESSOS **********
TECLA_CARREGADA:
	LOCK 0
TECLA_CONTINUA:
	LOCK 0
MOVE_MET:
	LOCK 0
LOCK_DISPLAY:
	LOCK 0
MOVE_MISSIL:
	LOCK 0	
START_DESENHOS:
	LOCK 0
; *************************************

ESTADO_PROG:
	WORD 0  							; variavel de estado do programa (STOP, START, RUNNING E PAUSED)

; **********
; * Código *
; **********
PLACE   0                    

; ********** Inicializações gerais **********
inicio:
	MOV  SP, SP_process_inicial			; inicializa SP para a palavra a seguir à última da pilha
    MOV BTE, tabela_excep   			; inicializa o registo da tabela de exceções
    EI0                             	; permite interrupção 0
    EI1                             	; permite interrupção 1
    EI2                             	; permite interrupção 2
    EI                              	; permite interrupções gerais
	CALL teclado						; evoca o processo teclado
	CALL nave							; evoca o processo nave
	MOV R9, NUM_MET						; numero de meteoros a criar
	CALL cria_varios_mets	
	CALL display						; evoca o processo display
	CALL missil							; evoca o processo missil
	MOV R1, STOP
	MOV [ESTADO_PROG], R1               ; inicializa o estado do programa a STOP
    MOV  [APAGA_AVISO], R1				; apaga o aviso de nenhum cenário selecionado 
    MOV  [APAGA_ECRA], R1				; apaga todos os pixels já desenhados
	MOV R0, 0
	MOV [TOCA_SOM_VID], R0				; inicia o video inicial do jogo
	MOV R0, 2								
	MOV [TOCA_SOM_VID_ETERNO], R0		; inicia a musica de fundo (fica em ciclo infinito)
	JMP ciclo_main

ciclo_start:
	MOV R0, 0
	MOV [PAUSA_SOM_VID], R0				; pausa o video inicial 
    MOV  [APAGA_AVISO], R1				; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRA], R1				; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	MOV	R1, 1							; cenário de fundo número 0
    MOV [SELECT_CEN_FRONTAL], R1		; seleciona o cenário de fundo	
	MOV R2, PAUSED						; valor para trocar o programa de running para paused

ciclo_main:
	MOV R11, [TECLA_CARREGADA]         	; lock do processo, espera pela tecla
	MOV R1, [ESTADO_PROG]				; carrega valor do estado do programa
	CALL ver_tecla_D					; verifica tecla_D
	CMP R10, ATIVO						; se for a tecla D vai para o ciclo_main
	JZ ciclo_main
	CALL ver_tecla_E					; verifica tecla_E
	CMP R10, ATIVO						; se for a tecla E vai para o ciclo_main
	JZ ciclo_main
	CALL ver_tecla_C					; verifica tecla_C
	CMP R10, ATIVO						; se for a tecla C vai para o ciclo_start
	JZ ciclo_start
	JMP ciclo_main                      ; loop infinito 



; ******************************************************************************************
; *	CRIA_VARIOS_METS: Invoca processos para criar meteoros
; *
; * 	Argumentos: R9 - numero de meteoros a criar
; *
; ******************************************************************************************
cria_varios_mets:
	DEC R9								; R9 é o indice do meteoro
	CALL meteoro						; chama um meteoro com R9 diferente de todos
	CMP R9, 0							; já chegamos ao fim do numero de meteoros?
	JNZ cria_varios_mets				; se sim continua o programa, se nao cria mais
	RET


; ******************************************************************************************
; *	VER_TECLA_D - Pausa ou recomeça o jogo, se a tecla D for premida
; *
; *	Argumentos: R1 - Estado do programa
; *			    R11 - Tecla
; *			    R2 - proximo valor do estado (2 ou 0 dependendo do valor do estado
; * 
; * Retorna:    R10 - Flag para saltar na main do programa
; *			    R2 - valor que troca de running para pause ( 0 ou 2)
; ******************************************************************************************
ver_tecla_D:
	PUSH R0
	PUSH R3
	MOV R10, INATIVO					; flag pra saltar desativada
	MOV R3, TECLA_D
	CMP R11, R3                    		; tecla D?
	JNZ fim_ver_tecla_D					; se nao for sai
	MOV R3, 1							; 0 e 2 tem o ultimo bit a 1 ( estado só pode ser -1, 0, 1 ou 2)
	AND R3, R1							; verifica se o valor do estado é 0 ou 2
	JNZ fim_ver_tecla_D					; se nao for sai
	MOV R10, ATIVO						; flag para saltar ativada
	CALL troca_valores_main				; troca o valor do estado para 0 ou 2, dependendo do anterior
	MOV [ESTADO_PROG], R1				; carrega na variavel do estado
	CMP R1, RUNNING						
	JNZ pause_prog						; se estiver em pausa salta
	MOV R0, 1
	MOV [SELECT_CEN_FRONTAL], R0		; seleciona o cenario para Running
	JMP fim_ver_tecla_D

pause_prog:
	MOV R0, 2
	MOV [SELECT_CEN_FRONTAL], R0		; seleciona o cenario frontal para pause

fim_ver_tecla_D:
	POP R3
	POP R0
	RET


; ******************************************************************************************
; *	VER_TECLA_E - Para o jogo , se a tecla E for premida
; *
; *	Argumentos: R11 - tecla
; *
; *	Retorna: R10 - flag para saltar na main do programa
; ******************************************************************************************
ver_tecla_E:
	PUSH R3	
	MOV R10, INATIVO
	MOV R3, TECLA_E						; tecla E?
	CMP R11, R3
	JNZ sai_ver_tecla_E					; se sim continua
	MOV R10, ATIVO
	MOV R1, START
	MOV [ESTADO_PROG], R1				; coloca o estado do programa em START
	CALL desbloq_proc					; desbloqueia os processos para que possam reiniciar
	YIELD								; espera para que reiniciem
    MOV  [APAGA_AVISO], R1				; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRA], R1				; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	MOV R1, STOP
	MOV [ESTADO_PROG], R1               ; coloca o estado do programa em STOP
	MOV R0, 0
	MOV [SELECT_CEN_FRONTAL], R0		; seleciona o cenário frontal principal

sai_ver_tecla_E:
	POP R3
	RET 


; ***************************************************************
; *  VER_TECLA_C - Recomeça o jogo, se a tecla C for premida    *
; *	 Argumentos:    R11 - Tecla                                 *
; *	 Retorna:       R10 - Flag para saltar na main do programa  *
; ***************************************************************
ver_tecla_C:
	PUSH R1
	PUSH R3
	MOV R10, INATIVO
	MOV R3, TECLA_C                     ; tecla C?
	CMP R11, R3
	JNZ fim_ver_tecla_C               	; se for continua, se nao volta ao ciclo do lock
	MOV R10, ATIVO
	MOV R1, START
	MOV [ESTADO_PROG], R1               ; coloca o estado do programa em START
	CALL desbloq_proc                   ; rotina para desbloquear todos os processos que precisem ser reiniciados
	YIELD								; deixa os outro processos dar restart
	MOV [START_DESENHOS], R0			; deixa os processos desenhar no ecra
	MOV R3, RUNNING
	MOV [ESTADO_PROG], R3               ; volta a colocar o estado do programa em RUNNING
	MOV [APAGA_CEN_FRONTAL], R0			; restart no ecra e volta a correr tudo
fim_ver_tecla_C:	
	POP R3
	POP R1
	RET





; *************************************************************************************
; * DESBLOQ_PROC: Desbloqueia todas as rotinas do programa com a finalidade de estas  *
; *				poderem dar restart													  *
; * Não usa argumentos nem retorna nada											      *
; *************************************************************************************
desbloq_proc:           
	MOV [MOVE_MET], R0              	; desbloqueia o meteoro
	MOV [LOCK_DISPLAY], R0              ; desbloqueia o display
	MOV [MOVE_MISSIL], R0				; desbloqueia o missil
	RET

; ******************************************************************************************
; * TROCA_VALORES_MAIN: troca os valores de 2 registos de estado (Running e Pause)         *
; *																	  	 				   *
; * Argumentos:	R1 - valor original                                                    	   *
; *				R2 - valor para troca                                                  	   *
; *																		 				   *
; * Retornar: 		R2 - valor original de R3									 		   *
; *           		R3 - valor original de R2	     							 		   *
; *                                                                                        *
; ******************************************************************************************
troca_valores_main:
	PUSH R3
	MOV R3, R1
	MOV R1, R2
	MOV R2, R3
	POP R3
	RET


; *******************************   INTERRUPÇÔES  ******************************************
interrupt_0:
	PUSH R3
	MOV R3, 0
	MOV [MOVE_MET],R3					; desbloqueia o meteoro para se mover
	POP R3
	RFE

interrupt_1:
	PUSH R3
	MOV R3, -1
	MOV [MOVE_MISSIL], R3				; desbloqueia o missil e move-o
	POP R3
	RFE	

interrupt_2:
	PUSH R3
	MOV R3, DEC_DISPLAY
	MOV [LOCK_DISPLAY], R3				; desbloqueia o display e decrementa-o em 5
	POP R3
	RFE	

; ***************************************************************************************




; +--------------------------------------------------------------------+
; |  PROCESSO - TECLADO												   |
; |	 Objetivo: Detetar quando uma tecla é premida e escrever num LOCK  |
; +--------------------------------------------------------------------+
PROCESS SP_teclado
teclado:
	MOV  R2, TEC_LIN			        ; endereço do periférico das linhas
	MOV  R3, TEC_COL		        	; endereço do periférico das colunas
	MOV  R5, MASCARA			        ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado	
espera_tecla:					        ; neste ciclo espera-se até uma tecla ser premida
	YIELD					            ; deixa outros processos correr
	MOV  R6, LINHA_TECLADO		        ; testar a linha 4 
	CALL varre_teclado
	CMP R0, 0                	        ; há tecla?
	JZ espera_tecla
	CALL calcula_tecla
	MOV	[TECLA_CARREGADA], R0	        ; informa quem estiver bloqueado neste LOCK que uma tecla foi carregada
ha_tecla:						        ; neste ciclo espera-se até NENHUMA tecla estar premida
	YIELD					            ; deixa os outros processos correr
	MOV	[TECLA_CONTINUA], R0	        ; informa quem estiver bloqueado neste LOCK que uma tecla está a ser carregada
	MOV  R6, LINHA_TECLADO		        ; testar a linha 4 
	CALL varre_teclado
    CMP  R0, 0				            ; há tecla premida?
    JNZ  salto_cond				        ; se ainda houver uma tecla premida, espera até não haver
    JMP	espera_tecla		        	; volta a esperar tecla e permite outros processos correrem
salto_cond:
	CALL calcula_tecla
	JMP ha_tecla





; **************************************************************************
; *  VARRE_TECLADO - percorre o teclado todo, para se encontrar uma tecla  *
; *  Argumentos:	R2 - endereço do periférico das linhas				   *
; *				    R3 - endereço do periférico das colunas				   *
; *				    R5 - mascara para isolar os 4 bits de menor peso	   *
; *				    R6 - linha em que a tecla está						   *
; *  Retorna: 		R0 - valor das colunas da tecla (1,2,4,8)			   *
; *           		R6 - valor das linhas da tecla (1,2,4,8)			   *
; **************************************************************************
varre_teclado:
	CMP R6, 0                	        ; verifica se já percorreu as linhas todas
	JZ fim_varre_teclado                ; se já percorreu termina o varrimento e retorna
	MOVB [R2], R6				        ; escrever no periférico de saída (linhas)
	MOVB R0, [R3]				        ; ler do periférico de entrada (colunas)
	AND  R0, R5			            	; elimina bits para além dos bits 0-3
	CMP  R0, 0				            ; há tecla premida?
	JZ troca_linha_teclado		        ; se nao ha tecla, continua pra prox linha
fim_varre_teclado:
	RET
troca_linha_teclado:
    SHR R6, 1                   	    ; passa a percorrer a linha seguinte
	JMP varre_teclado            	    ; volta a percorrer o teclado





; ******************************************************************************************
; *  CALCULA_TECLA - Calcula a tecla premida de acordo com a linha e a coluna dessa tecla  *
; *  Argumentos:    R2 - registo temporário                                                *
; *                 R3 - registo temporario                                                *
; *                 R6 - valor das linhas da tecla                                         *
; *                 R0 - valor das colunas da tecla                                        *
; *  Retorna: 	    R0 - valor correspondente à tecla premida (linha e coluna)             *
; ******************************************************************************************
calcula_tecla:
    PUSH R2
    PUSH R3                             ; coloca os registos em stack de modo a salvaguarda-los
    PUSH R6
    MOV R3, R6                	        ; contador para as linhas
    CALL conta_col_lin        	        ; conta a linha
    MOV R6, R3                  	    ; coloca o valor da linha em R6
    MOV R3, R0                	        ; contador para as colunas
    CALL conta_col_lin        	        ; conta a coluna
    MOV R0, R3                	        ; coloca o valor da coluna em R0
    SHL  R6, 2                	        ; multiplica por 4 o contador das linhas
    ADD R0, R6                	        ; adiciona o contador das colunas                
    POP R6
    POP R3                    	        ; faz a limpeza do stack e retorna
    POP R2
	RET





; ************************************************************************
; *  CONTA_COL_LIN - Indica, num numero, a posição do bit de maior peso  *
; *  Argumentos:    R3 - Numero para contar os bits						 *
; *  Retorna:       R3 - Posição do bit de maior peso                    *
; ************************************************************************
conta_col_lin:
    PUSH R2                             ; coloca o registo em stack de modo a salvaguarda-lo
    MOV R2, 0                 	        ; contador auxiliar
ciclo_conta_col_lin:
    SHR R3, 1                 	        ; verifica se há um zero à direita do 1
    JZ fim_conta_col_lin
    INC R2                         	    ; aumenta o contador
    JMP ciclo_conta_col_lin
fim_conta_col_lin:
    MOV R3, R2                	        ; coloca o valor calculado da linha/coluna
    POP R2                    	        ; limpa o stack, salvaguardando o cálculo em R3
    RET      





; +-----------------------------------------------------+
; |  PROCESSO - NAVE									|
; |	 Objetivo: Desenha a nave e move-a horizontalmente  |
; +-----------------------------------------------------+
PROCESS SP_nave
nave:	
    MOV R0, [START_DESENHOS]			; lê o lock						
    MOV R1, LINHA_NAVE				    ; inicializa a linha da nave
	MOV R2, COLUNA_NAVE				    ; inicializa a coluna da nave
	MOV [POS_NAVE + 2], R2              ; escreve a coluna da nave em memória
	MOV R4, DEF_NAVE				    ; inicializa a tabela da nave
	MOV R9, MAX_ATRASO                  ; valor maximo do contador
ciclo_nave:
	MOV R10, ATIVO                      ; ativa a flag para desenhar o boneco
	CALL	altura_boneco				; desenha o boneco a partir da tabela
	MOV R8, 0						    ; inicializa o contador de atraso
espera_movimento:
	MOV	R3, [TECLA_CONTINUA]		    ; lê o LOCK e bloqueia até o teclado ate escrever nele novamente
	MOV R0, [ESTADO_PROG]               ; ler o estado do programa
	CMP R0, 1                           ; restart a nave?
	JZ nave		                        ; se sim, salta para restart_nave
	CMP R0, RUNNING                     ; o programa esta a correr?
	JNZ ciclo_nave					    ; se nao volta para o ciclo_nave
	CMP R9, R8
	JNZ atraso                         
	CALL tecla_nave
ha_movimento:
	MOV R6, [R4+2]                      ; carregar o valor da largura da nave
	CALL testa_limites_nave
	CMP R7, 0                           ; movimenta-se ?
	JZ espera_movimento                 ; se não volta a bloquear (voltando ao ciclo)
	MOV R10, INATIVO                    ; ativa flag para apagar boneco
	CALL	altura_boneco				; apaga o boneco na sua posição corrente
	ADD R2, R7                          ; acrescenta movimento a nave
	MOV [POS_NAVE + 2], R2              ; atualiza a posicao da nave
	JMP	ciclo_nave				        ; ciclo infinito
atraso:
	INC R8
	JMP espera_movimento





; **********************************************************************************************************
; *  TECLA_NAVE - Determina o movimento da nave dependendo da tecla que está a ser pressionada (-1, 0 ,1)  *				 *
; *  Argumentos:    R3 - tecla em questão							                                       *
; *  Retorna:       R7 - valor do movimento                                                                *
; **********************************************************************************************************
tecla_nave:
	CMP R3, TECLA_ESQUERDA              ; verifica se a tecla carregada foi a esquerda (tecla 0)
	JZ ativa_esquerda                   ; se sim, avança para o tratamento correspondente
	CMP R3, TECLA_DIREITA               ; verifica se a tecla carregada foi a direita (tecla 2)
	JZ ativa_direita                    ; se sim, avança para o tratamento correspondente
	MOV R7, 0                           ; caso não tenha sido nenhuma, o valor do movimento é 0
	RET                                 ; retorna para onde foi chamada
ativa_esquerda:
    MOV R7, MOVE_ESQUERDA               ; ativa a flag para o movimento à esquerda e retorna
	RET                         
ativa_direita:
    MOV R7, MOVE_DIREITA                ; ativa a flag para o movimento à direita e retorna
	RET





; *******************************************************************
; *  ALTURA_BONECO - Ciclo para desenhar/apagar o boneco em altura  *
; *                                                                 *
; *  Argumentos:    R0 - Registo temporario 1                       *
; *                 R1 - linha                                      *
; *                 R2 - coluna                                     *
; *                 R4 - tabela que define o boneco                 *
; *                 R5 - registo temporário para a largura          *
; *                 R6 - Registo temporario para a altura           *
; *                 R10 - decide se apaga ou desenha o boneco       *
; *******************************************************************
altura_boneco:
    PUSH R0
    PUSH R1                    
    PUSH R2                             ; coloca os registos em stack de modo a salvaguarda-los
    PUSH R4                     
	PUSH R5
    PUSH R6
    MOV R6, [R4]                        ; carrega em R6 a altura do boneco
    ADD R4, 2                           ; obtem a altura do boneco (+2 porque é uma word)
    MOV R5, [R4]                        ; carrega em R5 a largura do boneco
    MOV R0, 2                           ; carrega R0 com 2 para depois contar o numero de pixeis que a largura tem
    MUL R0, R5                          ; 2 porque estamos a tratar de palavras de 2 bytes, código ARGB
altura_boneco_ciclo:
    CALL desenha_apaga_boneco
    INC R1                              ; aumenta a linha do boneco
    DEC R6                              ; contador altura
    JZ fim_altura_boneco                ; se já tiver passado por todas as linhas, termina o desenho
    ADD R4, R0                          ; avança para a próxima linha da tabela que define o boneco
    JMP altura_boneco_ciclo             ; continua com o ciclo
fim_altura_boneco:
    POP R6
	POP R5
    POP R4
    POP R2                              ; faz a limpeza do stack e retorna
    POP R1
    POP R0
    RET





; ***********************************************************************************
; *  DESENHA_APAGA_BONECO - Desenha ou apaga um boneco na linha e coluna indicadas  *
; *			                com a forma e cor definidas na tabela indicada.         *
; *  Argumentos:    R1 - linha                                                      *
; *                 R2 - coluna                                                     *
; *                 R3 - registo temporario                                         *
; *                 R4 - endereço anterior à linha que define o boneco              *
; *                 R5 - largura do boneco                                          *
; *                 R10 - valor que decide se desenha ou apaga                      *
; ***********************************************************************************
desenha_apaga_boneco:
	PUSH R0
    PUSH R2
	PUSH R3                             ; coloca os registos em stack de modo a salvaguarda-los
    PUSH R4                 
	PUSH R5
	ADD	R4, 2                           ; vai procurar o endereço seguinte da tabela DEF_NAVE ou DEF_METEORO
desenha_ou_apaga:
	MOV R0, MAX_LINHA		            ; carrega R0 com o valor máximo da linha
	CMP R1, R0	                        ; compara a linha do boneco com a última linha
	JGT fim_desenha_apaga_pixeis	    ; se chegou a ultima linha do ecrã não desenha
    CMP R10, 0                          ; verifica o argumento passado para saber se apaga ou desenha o boneco
    JZ prepara_apaga                    ; caso seja 0 avança para apagar o respetivo boneco
    JNZ prepara_desenho                 ; caso seja 1 avança para desenhar o respetivo boneco     
prepara_desenho:
    MOV R3, [R4]                        ; carrega o A de ARGB, para desenhar o pixel
    JMP desenha_apaga_pixels            ; avança para desenhar
prepara_apaga:
    MOV R3, 0                           ; carrega o A de ARGB a 0, ou seja, apaga o pixel
    JMP desenha_apaga_pixels            ; avança para a apagar
desenha_apaga_pixels:
    CALL escreve_pixel	                ; escreve cada pixel do boneco
	ADD	R4, 2			                ; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
    ADD R2, 1                           ; próxima coluna
    SUB R5, 1			                ; menos uma coluna para desenhar
    JNZ desenha_ou_apaga                ; continua até percorrer toda a largura do objeto
fim_desenha_apaga_pixeis:
	POP	R5
	POP	R4              
	POP	R3                              ; faz a limpeza do stack e retorna
	POP	R2
	POP  R0
	RET





; *******************************************************************
; *  ESCREVE_PIXEL - Escreve um pixel na linha e coluna indicadas  *
; *  Argumentos:    R1 - linha                                      *
; *                 R2 - coluna                                     *
; *                 R3 - cor do pixel (em formato ARGB de 16 bits)  *
; *******************************************************************
escreve_pixel:
	MOV  [DEFINE_LINHA], R1		        ; seleciona a linha
	MOV  [DEFINE_COLUNA], R2	        ; seleciona a coluna
	MOV  [DEFINE_PIXEL], R3		        ; altera a cor do pixel na linha e coluna já selecionadas
	RET                                 ; termina a rotina e retorna para onde foi chamada





; ******************************************************************************************
; *  TESTA_LIMITES_NAVE - Testa se a nave chegou aos limites do ecrã e impede o movimento  *
; *  Argumentos:	R2 - coluna em que o objeto está                                       *
; *                 R5 - registo temporario                                                *
; *			        R6 - largura da nave                                                   *
; *			        R7 - sentido de movimento da nave (valor a somar à coluna              *
; *				        em cada movimento: +1 para a direita, -1 para a esquerda)          *
; *  Retorna: 	    R7 - 0 se já tiver chegado ao limite, inalterado caso contrário	       *
; ******************************************************************************************
testa_limites_nave:
	PUSH	R5                          ; coloca os registos em stack de modo a salvaguarda-los
	PUSH	R6
testa_limite_esquerdo:		    
	MOV	R5, MIN_COLUNA                  ; carrega R5 com o valor mínimo da coluna
	CMP	R2, R5				            ; verifica se está no limite esquerdo
	JGT	testa_limite_direito	        ; se não estiver no limite esquerdo avança para testar o direito
	CMP	R7, 0			                ; se estiver no limite verifica sentido do movimento
	JGE	sai_testa_limites		        ; se for para a direita não vai contra o limite
	JMP	impede_movimento	            ; caso seja para a esquerda, impede o movimento
testa_limite_direito:
	ADD	R6, R2			                ; posição a seguir ao extremo direito do boneco
	MOV	R5, MAX_COLUNA                  ; carrega R5 com o valor máximo da coluna
	CMP	R6, R5                          ; verifica se está no limite direito
	JLE	sai_testa_limites	    	    ; se não estiver no limite direito avança para o fim da rotina
	CMP	R7, 0			        	    ; se estiver no limite verifica o sentido do movimento
	JGT	impede_movimento                ; caso seja para a direita, impede o movimento
	JMP	sai_testa_limites               ; se for para a esquerda não vai contra o limite
impede_movimento:
	MOV	R7, 0			        	    ; impede o movimento, forçando R7 a 0
sai_testa_limites:	
	POP	R6
	POP	R5                              ; faz a limpeza do stack e retorna
	RET





; +----------------------------------------+
; |  PROCESSO - METEORO                    |
; |  Objetivo: Desenhar e mover o meteoro  |
; +----------------------------------------+
PROCESS SP_meteoro_0			
meteoro:
	MOV R8, R9                      
	SHL R8, 1						    ; multiplica por 2 para incrementar endereços
	MOV R0, T_SP_METEOROS			    ; carrega R0 com a tabela de stack pointers dos meteoros
	MOV SP, [R0 + R8]				    ; inicializa o SP do respetivo meteoro
	SHL R8, 1						    ; multiplica por 2 para incrementar endereços 
restart_met:
	MOV R0, [START_DESENHOS]			; ja comecei o programa?
start_met:
	CALL define_pos_met                 ; vai buscar informação relativa ao meteoro
ciclo_met:
	MOV R10, ATIVO     			        ; ativa a flag para desenhar o meteoro
	CALL altura_boneco                  ; desenha o meteoro
	MOV R0, [MOVE_MET]                  ; bloqueia, espera para mover met
	MOV R0, [ESTADO_PROG]               ; carrega R0 com o estado do programa
	CMP R0, START                       ; verifica se está em START
	JZ restart_met                      ; reinicia o meteoro se o programa estiver no estado START
	CMP R0, RUNNING                     ; verifica se ainda se está a jogar (modo RUNNNING)
	JNZ ciclo_met                       ; se não se tiver a jogar bloqueia no ciclo	
	MOV R10, INATIVO                    ; ativa a flag para apagar o meteoro
	CALL altura_boneco                  ; apaga o meteoro
	INC R1					            ; move o meteoro (uma linha a mais, ou seja, para baixo)
	CALL testa_colisoes			        ; verifica se colidiu com alguma coisa
	CMP R6, 1					        ; flag para colisao com meteoro
	JZ colisao_met				        ; colidiu com meteoro?
	CMP R6, 2					        ; flag para colisao com missil
	JZ explode_met				        ; explode o meteoro
	MOV R0, MAX_LINHA			        ; carrega R0 com o valor máximo da linha do ecrã
	CMP R1, R0				            ; já chegou à ultima linha
	JZ start_met                        ; reinicia o meteoro caso tenha chegado à ultima linha
	MOV [R5 + R8], R1        	        ; atualiza a posicao do meteoro
	CALL alt_table_met                  ; verifica se é necessário alterar a tabela de desenho do meteoro 
	JMP ciclo_met                       ; continua no ciclo de movimento do meteoro
explode_met:
	CALL def_explode_met                ; explode o meteoro
	JMP start_met				        ; reinicia o meteoro (nova posição no topo do ecrã)
colisao_met:
	CALL def_colisao_met                ; o meteoro colide
	JMP start_met                       ; reinicia o meteoro (nova posição no topo do ecrã)





; *******************************************************************
; *	 DEF_EXPLODE_MET -  Explode o meteoro, incrementa 5 no display  *
; *	 Argumentos:    R1 - linha do meteoro                           *
; * 			    R2 - coluna do meteoro                          *
; *			        R9 - índice do meteoro                          *
; *******************************************************************
def_explode_met:
	PUSH R3
	PUSH R4                             ; coloca os registos em stack de modo a salvaguarda-los
	PUSH R6
	PUSH R10
	MOV R4, MET_EXPLODIDO		        ; carrega R4 com a tabela do meteoro explodido
	MOV R10, ATIVO                      ; carrega R10 com a flag de ativação
	MOV [ACABA_MISSIL], R10		        ; informa ao missil para acabar
	CALL altura_boneco			        ; desenha o meteoro (uma vez que R10 está ativo)
	MOV R0, [MOVE_MET]			        ; espera que o meteoro se mova de novo
	MOV R10, INATIVO                    ; carrega R10 com a flag de apagar
	CALL altura_boneco			        ; apaga o meteoro (uma vez que R10 está inativo)
	MOV R6, T_ESTADO_MET                ; carrega R6 com a tabela de estados dos meteoros
	MOV R10, R9                         ; carrega R10 com o indíce dos meteoro
	SHL R10, 1				            ; multiplica por 2 para mover endereço
	ADD R10, R6                         ; adiciona a R10 o endereço da tabela de estados dos meteoros
	MOV R4, MET_BOM                     ; carrega R4 com a flag de meteoro_bom
	MOV R6, [R10]                       ; carrega R6 com o estado do meteoro de índice R9
	CMP R6, R4	                        ; compara R6 a ver se é um meteoro bom
	JZ fim_def_explode_met              ; avança para o fim da rotina
	MOV R3,	INC_DESTROI_MET             ; carrega R3 com o valor de aumento do display
	CALL troca_valor_display            ; faz a alteração da energia do rover (display)
fim_def_explode_met:
	MOV R10, 1                          ; carrega R10 com o som da explosão do meteoro
	MOV [TOCA_SOM_VID], R10             ; utiliza o comando para tocar o som da explosão
	POP R10
	POP R6                  
	POP R4                              ; faz a limpeza do stack e retorna
	POP R3
	RET





; **********************************************************************************
; *  DEF_COLISAO_MET - Incrementa 10 de energia se colidir com um meteoro bom,     *
; *					troca o cenario de fundo e acaba o jogo se for um meteoro mau  *
; *	 Argumentos:    R9 - indice do meteoro                                         *
; **********************************************************************************
def_colisao_met:
	PUSH R0
	PUSH R3                             ; coloca os registos em stack de modo a salvaguarda-los
	PUSH R11
	MOV R11, R9                         ; carrega R11 com o índice do meteoro
	SHL R11, 1                          ; multiplica o índice do meteoro por 2 (para saltar de word em word e não bytes)
	MOV R0, T_ESTADO_MET                ; carrega R0 com a tabela de estado dos meteoros
	ADD R11, R0                         ; adiciona a R11 o endereço da tabela de estados do meteoros
	MOV R0, [R11]                       ; carrega R0 com o estado do meteoro (bom ou mau)
	CMP R0, MET_MAU                     ; verifica se o meteoro da colisão era bom ou mau
	JNZ colisao_met_bom                 ; avança para tratar da colisão com um meteoro bom
colisao_met_mau:
	MOV R0, STOP                        ; carrega R0 com o novo estado do jogo
	MOV [ESTADO_PROG], R0               ; escreve em memória o novo estado do jogo
	MOV R0, 4                           ; carrega R0 com o cenário de fim de jogo devido a colisão com o rover
	MOV [SELECT_CEN_FRONTAL], R0        ; utiliza o comando peara trocar o cenário frontal
	MOV R3, 5                           ; carrega R3 com o som da colisão com um meteoro mau
	MOV [TOCA_SOM_VID], R3              ; utiliza o comando para tocar o som da colisão
	JMP fim_def_colisao_met             ; avança para o fim da rotina
colisao_met_bom:
	MOV R3, INC_MET_BOM                 ; carrega R3 com o valor do aumento do display
	CALL troca_valor_display            ; faz a alteração da energia do rover (display)
	MOV R3, 6                           ; carrega R3 com o som da colisão com um meteoro bom
	MOV [TOCA_SOM_VID], R3              ; utiliza o comando para tocar o som da colisão
fim_def_colisao_met:
	POP R11
	POP R3                              ; faz a limpeza do stack e retorna
	POP R0
	RET





; ***************************************************************************
; *	 DEFINE_POS_MET - Vai buscar registos necessários para mover o meteoro  *
; *	 Argumentos:    R9 - indice do meteoro                                  *
; * 			    R8 - incremento das posições dos meteoros               *
; *	 Retorna:       R1 - Linha do meteoro                                   *
; * 		        R2 - Coluna do meteoro                                  *
; *		            R4 - tabela do meteoro (desenho)                        *
; * 	            R5 - tabela de posições dos meteoros                    *
; *		            R6 - flag de estado para verificar colisoes             *
; *                 R7 - tabela das progressoes dos meteoros                *
; ***************************************************************************
define_pos_met:
	PUSH R0
	PUSH R3                             ; coloca os registos em stack de modo a salvaguarda-lo
	PUSH R10
	PUSH R11
	MOV R0, TEC_COL                     ; carrega R0 com o endereço das colunas do teclado
	MOV R1, 0						    ; coloca a linha no registo R1
	MOV R4, DEF_METEORO_1       		; valor da tabela do meteoro
	MOV R5, T_POS_METEOROS			    ; carrega a tabela das posicoes dos meteoros
	MOV R10, T_ESTADO_MET			    ; carrega a tabela dos estados dos meteoros
	MOVB R11, [R0]				    	; carrega o registo com um valor random
	SHR R11, 5					        ; retira os bits desnecessários (para ficar valor 0 a 7)
	SHL R11, 3					        ; multiplica por 8 para obter a coluna
	MOV [R5 + R8], R1				    ; carrega a linha do meteoro na posicao do meteoro
	MOV R3, R8				    	    ; copia valor de R8
	ADD R3, MAIS_UM_END					; acrescenta dois para ir buscar a coluna do meteoro 
	MOV [R3 + R5], R11				    ; coloca o valor da coluna na posicao do meteoro
	MOV R2, R11				    	    ; coloca a coluna no registo
	MOV R3, R9					        ; copia o indice do meteoro
	SHL R3, 1						    ; multiplica por 2 para incrementar endereços 
	ADD R3, R10					        ; endereço do estado do meteoro
   	MOVB R11, [R0]               		; carrega o registo com um valor random
    SHR R11, 5                   		; retira os bits desnecessários
    CMP R11, 1                   		; para garantir os 25% de meteoros bons
    JLE def_table_bons                  ; salta para definir a tabela dos meteoros bons
    MOV R7, T_METS_MAUS				    ; carrega o registo com a tabela de desenho dos meteoros maus
	MOV R11, MET_MAU				    ; carrega R11 com a flag de meteoro mau
	MOV [R3], R11					    ; carrega esse valor para o estado do meteoro
    JMP fim_define_pos_met              ; avança para o fim da rotina
def_table_bons:
    MOV R7, T_METS_BONS                 ; carrega o registo com a tabela de desenho dos meteoros bons
	MOV R11, MET_BOM                    ; carrega R11 com a flag de meteoro bom
	MOV [R3], R11                       ; carrega esse valor para o estado do meteoro
fim_define_pos_met:
	POP R11
	POP R10                             
	POP R3                              ; faz a limpeza do stack e retorna
	POP R0	
	RET





; *******************************************************************************************
; *	 VER_COLISOES - Verifica se o meteoro em questão colidiu com um missil                  *
; *	 Argumentos:    R1 - Linha do meteoro                                                   *
; * 			    R2 - Coluna do meteoro                                                  *
; *			        R3 - Tabela do objeto que queremos testar colisões (nave ou missil)     *
; *			        R4 - Tabela do meteoro (desenho)                                        *
; *			        R9 - Indice do meteoro                                                  *
; * 			    R11 - Tabela da posição do objeto que queremos testar (nave ou missil)  *
; * Retorna:        R10 - Flag com valores ATIVO/INATIVO para informar se colidiu ou não    *
; *******************************************************************************************
ver_colisoes:
	PUSH R0                             ; coloca os registos em stack de modo a salvaguarda-los
	PUSH R5
	MOV R10, INATIVO		            ; começa o valor a INATIVO
	MOV R0, [R11 + MAIS_UM_END]		    ; carrega R0 com a coluna do objeto
	MOV R5, [R3 + MAIS_UM_END]		    ; carrega R0 com a largura do objeto
	DEC R5				                ; para não contar com o píxel da posição
	ADD R5, R0			                ; compara cantos opostos dos bonecos (meteoro esquerdo, boneco direito)
	CMP R2, R5
	JGT fim_ver_colisoes                ; avança para o fim da rotina não se tendo verificado colisão
	MOV R5, [R4 + MAIS_UM_END]		    ; carrega R5 com a largura do meteoro em memória
	DEC R5				                ; nao contar com o pixel da posição
	ADD R5, R2                       
	CMP R5, R0			                ; compara os cantos opostos dos bonecos (meteoro direito, boneco esquerdo)
	JLT fim_ver_colisoes                ; caso não tenha havido colisão salta para o fim da rotina
	MOV R5, [R4]			            ; carregar altura do meteoro
	DEC R5				                ; nao contar com o pixel da posicao
	ADD R5, R1			                ; primeira linha do meteoro
	MOV R0, [R11]			            ; carrega R0 com a linha do objeto (rover ou míssil)
	CMP R0, R5			                ; verifica se houve colisao entre as linhas dos bonecos
	JGT fim_ver_colisoes                ; caso não tenha havido colisão salta para o fim da rotina
	MOV R10, ATIVO			            ; ativa a flag porque houve colisão
fim_ver_colisoes:
	POP R5
	POP R0                              ; faz a limpeza do stack e retorna
	RET		
	




; *****************************************************************************************
; *  ALT_TABLE_MET - Altera a tabela (de desenho) do meteoro de acordo com a sua posição  *
; *  Argumentos:    R1 - Valor da linha do meteoro                                        *
; *                 R4 - Valor corrente da table do meteoro                               *
; *                 R7 - Tabela representante da progressão dos meteoros                  *
; *  Retorna:       R4 - Novo valor da table do meteoro                                   *
; *****************************************************************************************
alt_table_met:
	PUSH R3
	PUSH R5                             ; coloca os registos em stack de modo a salvaguarda-los
	PUSH R6
	PUSH R7
	MOV R6, 0                           ; carrega R6 com o valor que vamos adicionar ao endereço da table_met
	MOV R3, MAX_ALT_TABLE               ; carrega R3 com a última linha que se muda a tabela dos meteoros                  
	CMP R1, R3                          ; verifica se ainda falta alterar a tabela de desenho do meteoro
	JP termina_alt                      ; caso já tenha ultrapassado R3, não executa nenhuma alteração
	MOV R5, 0                           ; carrega R5 com 0
ciclo_alt_table:
	CMP R1, R5                          ; verifica se R1 já chegou a zero
	JZ troca_tabela_met                 ; termina, trocando valor de R4 (tabela de desenho do meteoro)
	CMP R5, R3		                    ; ultimo valor para alterar a table
	JGE termina_alt                     ; ja ultrapassou, nao troca nada 
	ADD R6, MAIS_UM_END                 ; proxima table (+2 porque é um endereço)
	ADD R5, MOV_ALT_TBL                 ; proxima posição para mudar de tabela 
	JMP ciclo_alt_table                 ; (movimentos de 3 em 3 alteram a table)
troca_tabela_met:
	ADD R7, R6                          ; proxima table (+2 porque é um endereço)
	MOV R4, [R7]                        ; tabela de acordo com a linha
termina_alt:
	POP R7	
	POP R6	                            
	POP R5                              ; faz a limpeza do stack e retorna
	POP R3	
	RET





; *****************************************************************************
; *  LIMITES_MET - Verifica os limites do meteoro e registra o seu movimento  *
; *  Argumentos:    R1 - Linha do meteoro                                     *
; *			        R3 - Altura do meteoro                                    *
; *                 R4 - Tabela do meteoro (desenho)                          *
; *  Retorna:       R1 - Nova linha do meteoro                                *
; *****************************************************************************
limites_met:
	PUSH R0
	PUSH R2                             ; coloca os registos em stack de modo a salvaguarda-los  
	PUSH R3
	DEC R3                              ; para nao contar com o pixel em que o meteoro se encontra
	MOV R0, MAX_LINHA                   ; carrega R0 com o valor máximo da linha do ecrã
	CMP R1,R0					        ; verifica se já chegou ao fim do ecrã
	JZ fim_limites_met                  ; se sim, avança para o fim da rotina
	INC R1                              ; se ainda não chegou ao fim do ecrã, aumenta uma linha (fazendo-o descer)
fim_limites_met:
	POP R3
	POP R2
	POP R0
	RET




 
; ******************************************************************************************
; *	 TESTA_COLISOES - Chama as rotinas para testar colisoes
; *	 Argumentos:    R1 - Linha do meteoro
; * 			    R2 - Coluna do meteoro
; *			        R3 - Tabela do objeto que queremos testar colisões (nave ou missil)
; *			        R4 - Tabela do meteoro (desenho)
; *			        R9 - Indice do meteoro
; * 			    R11 - Tabela da posição do objeto que queremos testar (nave ou missil)
; *  Retorna -      R6 - Flag para saltar no processo meteoro (0, 1, 2)
; ******************************************************************************************
testa_colisoes:
	PUSH R3
	PUSH R10                            ; coloco os registos em stack de modo a salvaguarda-los
	PUSH R11
	MOV R3, DEF_NAVE                    ; carrega R3 com a tabela que define o rover
	MOV R11, POS_NAVE			        ; carrega R11 com a tabela da posição do rover
	CALL ver_colisoes			        ; testa se o meteoro colidiu com a nave
	CMP R10, ATIVO                      ; verifica se houve colisão
	JZ testa_colisao_nave               ; se sim, avança para ativar a flag de colisão com nave
	MOV R3, TABLE_MISSIL                ; carrega R3 com a tabela que define o míssil
	MOV R11, POS_MISSIL			        ; carrega R11 com a tabela da posição do míssil
	CALL ver_colisoes			        ; testa se o meteoro colidiu com o missil
	CMP R10, ATIVO 	                    ; verifica se houve colisão
	JZ testa_colisao_missil             ; se sim, avança para ativar a flag de colisão com míssil
	MOV R6, 0					        ; se nao colidiu da set a flag a 0 e termina a rotina
	JMP fim_testa_colisoes              ; avança para o fim da rotina
testa_colisao_nave:
	MOV R6, 1					        ; flag para colisao com rover
	JMP fim_testa_colisoes              ; avança para o fim da rotina
testa_colisao_missil:
	MOV R6, 2					        ; flag para colisao com missil
	JMP fim_testa_colisoes              ; avança para o fim da rotina
fim_testa_colisoes:	
	POP R11
	POP R10                             ; faz a limpeza do stack e retorna
	POP R3
	RET





; +----------------------------------------------------
; |  PROCESSO - DISPLAY                               |
; |  Objetivo: Altera o display consoante necessário  |
; +----------------------------------------------------
PROCESS SP_display
display:
	MOV R1, PONTUACAO_INICIAL		    ; carrega R1 com a pontuação inicial
	MOV [VALOR_DISPLAY], R1             ; escreve em memória a pontuação inicial (hexa)
	CALL atualiza_display               ; escreve na memória do periférico a energia
ciclo_display:
	MOV R3, [LOCK_DISPLAY]			    ; bloqueia o processo display
	MOV R2, [ESTADO_PROG]               ; carrega R2 com o estado do programa
	CMP R2, START                   	; jogo está START?
	JZ display                          ; caso o jogo esteja parado volta ao ínicio, não mexendo no display
	CMP R2, RUNNING				        ; verifica se o jogo está em RUNNING
	JNZ ciclo_display               	; se nao fica no ciclo				
	CALL escolhe_display                ; vai buscar o novo valor do display (hexa)
	CALL atualiza_display               ; atualiza o periférico escrevendo a nova energia (decimal)
	CMP R1, MIN_DISPLAY             	; verifica-se se a energia do rover já chegou ao fim
	JZ sem_energia                      ; se a energia for 0, salta para a rotina de tratamento de fim de jogo
	JMP ciclo_display                   ; se ainda houver energia mantém-se dentro do ciclo
	
	
sem_energia:    
	MOV R3, STOP                        ; carrega R3 com a flag de jogo parado
	MOV [ESTADO_PROG], R3			    ; coloca o estado do programa em STOP
	MOV R3, 3                           ; carrega R3 com o cenário frontal que se pretende
	MOV [SELECT_CEN_FRONTAL], R3        ; evoca-se o comando para colocar um novo cenário frontal
	MOV R3, 4                           ; carrega R3 com o som/vídeo que se pretende
	MOV [TOCA_SOM_VID], R3				; evoca-se o comando para tocar o som de ficar sem energia
	JMP ciclo_display                   ; volta-se ao ciclo inicial





; ****************************************************************************
; *  TROCA_VALOR_DISPLAY - Altera em uma unidade (+/- 1) o valor do display  *
; *  Argumentos:    R3 - indicador para se definir aumento ou diminuição     *
; ****************************************************************************
troca_valor_display:
    PUSH R1                             ; coloca o registo em stack de modo a salvaguarda-lo
    MOV R1, [VALOR_DISPLAY]             ; carrega R1 com o valor hexadecimal que está de momento no display
    CALL escolhe_display                ; atualiza o valor hexadecimal de R1, seja aumentou ou diminuição
    MOV [VALOR_DISPLAY], R1             ; atualiza na memória o novo valor hexadecimal do display
    CALL atualiza_display               ; coloca no display o novo valor de R1, mas em decimal
    POP R1                              ; faz a limpeza do stack e retorna
    RET





; **********************************************************************
; *	 ESCOLHE_DISPLAY - Escolhe o valor a colocar no valor do display   *
; *  Argumentos:    R1 - valor do display                              *
; * 				R3 - flag para indicar o incremente ou decremento  *
; *  Retorna:       [VALOR_DISPLAY] - novo valor do display            *
; **********************************************************************
escolhe_display:
	PUSH R4
	MOV R1, [VALOR_DISPLAY]             ; carrega R1 com o valor em memória do display 
	MOV R4, R1                          ; carrega R4 com o valor de R1
	ADD R4, R3                          ; incrementa-se ou decrementa-se o valor do display
    CMP R3, 0		                    ; verifica se se pretende aumentar ou diminuir o display    
    JGT aumenta_display                 ; avança-se para aumentar o display
diminui_display:
    PUSH R2                             ; coloca o registo em stack de modo a salvaguarda-lo
    MOV R2, MIN_DISPLAY                 ; carrega R2 com o valor mínimo do display
    CMP R4, R2                          ; verifica se chegou ao limite mínimo do display (0000H == 0)
    JLE escolhe_min_display             ; caso esteja no limite, não altera o valor do display   **** CASO ULTRAPASSE ?? @FRANCISCO
    MOV R1, R4                          ; decrementa o valor de R1 (hexa)
    JMP fim_escolhe_display             ; avança para a escrita em memória do valor do display
aumenta_display:
    PUSH R2                             ; coloca o registo em stack de modo a salvaguarda-lo
    MOV R2, MAX_DISPLAY_H               ; carrega R2 com o valor máximo do display (hexa)
    CMP R4, R2                          ; verifica se chegou ao limite máixmo do display (0064H == 100)
    JGE escolhe_max_display             ; caso esteja no limite, não altera o valor do display
    MOV R1, R4                          ; incrementa o valor de R1 (hexa)
	JMP fim_escolhe_display             ; avança para a escrita em memória do valor do display
escolhe_min_display:
	MOV R1, R2                          ; carrega R1 com o valor mínimo do display
	JMP fim_escolhe_display             ; avança para a escrita em memória do valor do display
escolhe_max_display:
	MOV R1, R2                          ; carrega R1 com o valor máximo do display
fim_escolhe_display:
	MOV [VALOR_DISPLAY], R1             ; atualiza o valor do display
    POP R2                      
    POP R4                              ; faz a limpeza do stack e retorna
    RET





; **********************************************************************
; *  ATUALIZA_DISPLAY: Atualiza o display com o novo valor em decimal  *
; *  Retorna:       R1 - novo valor do display em decimal                    *
; **********************************************************************
atualiza_display:
    CALL hex_to_dec                     ; converte R1 de hexadecimal para decimal
    MOV [DISPLAYS], R1                  ; escreve o novo valor do display (decimal) no endereço respetivo
	RET                                 ; retorna para onde foi chamada





; ***************************************************
; *  HEX_TO_DEC - Converte hexadecimais em decimal  *
; *  Argumentos:    R1 - número hexadecimal         *
; *  Retorna:       R1 - número decimal             *
; ***************************************************
hex_to_dec: 				
	PUSH R0                             ; coloca os registos em stack de modo a salvaguarda-los 					
	PUSH R2
	MOV R2, MAX_DISPLAY_H               ; coloca em R2 o valor máximo do display em hexadecimal
	CMP R1, R2                          ; compara o número hexadecimal passada com o máximo em hexadecimal
	JGE coloca_valor_maximo             ; caso o valor seja maior ou igual, coloca-se o valor máximo decimal no display
	MOV R0, HEXTODEC_HELPER             ; carrega R0 com um valor auxiliar à conversão
	MOV R2, R1                          ; carrega-se R2 com o valor hexadecimal passado como argumento
	DIV R1, R0 			                ; coloca o algarismo das dezenas em decimal em R1
	MOD R2, R0 			                ; coloca o algarismo das unidades em decimal em R2
	SHL R1, 4                           ; divide por 16
	OR  R1, R2					        ; coloca o numero em decimal em R1
    JMP fim_hex_to_dec                  ; avança para o fim da rotina
coloca_valor_maximo:
    MOV R1, MAX_DISPLAY_D               ; carrega R1 com o valor decimal máximo (100d)
fim_hex_to_dec:
	POP R2    
	POP R0                              ; faz a limpeza do stack e retorna                 
	RET





; +-------------------------------------------------------
; |  PROCESSO - MÍSSIL                                   |
; |  Objetivo: Cria e move o missil disparado pela nave  |
; +-------------------------------------------------------
PROCESS SP_move_missil
missil:
	MOV R0, MAX_LINHA                   ; carrega R0 com o valor máximo da linha do ecrã
	MOV [POS_MISSIL], R0                ; escreve em memória a linha do míssil (depois vai ser substituida)
	MOV R0, MAX_COLUNA                  ; carrega R0 com o valor máximo da coluna do ecrã
	MOV [POS_MISSIL + 2], R0            ; escreve em memória a coluna do míssil (depois vai ser substituida)
	MOV R0, [TECLA_CARREGADA]           ; carrega R0 com a tecla que foi carregada
	MOV R11, [ESTADO_PROG]              ; carrega R11 com o estado atual do programa
	CMP R11, RUNNING                    ; verifica se estamos em RUNNING
	JNZ missil                          ; caso não se esteja não se avança com o movimento do míssil
	CMP R0, TECLA_MISSIL                ; verifica se a tecla de míssil foi carregada
	JNZ missil                          ; caso não tenha sido, não se avança com o movimento do míssil
	CALL start_missil                   ; vai buscar os registos necessários para a movimentação do míssil
ciclo_missil:
	MOV R10, ATIVO                      ; ativa a flag para escrita do míssil
	CALL altura_boneco                  ; desenha o míssil
	MOV R3, [MOVE_MISSIL]			    ; bloqueia o míssil de mover
	MOV R11, [ESTADO_PROG]              ; carrega em R11 com a flag de indicação do programa que está em memória
	CMP R11, START					    ; verifica se é necessário dar RESTART
	JZ missil						    ; se sim para o missil
	CMP R11, RUNNING				    ; verifica se estamos em RUNNING
	JNZ ciclo_missil				    ; se não, bloqueia o movimento do míssil
	MOV R10, INATIVO                    ; ativa a flag para apagar o míssil
	CALL altura_boneco                  ; apaga o míssil
	MOV R9, [ACABA_MISSIL]              ; carrega R9 com a flag em memória a saber se há ou não míssil ativo
	CMP R9, ATIVO                       ; verifica se há míssil ativo ou nõa
	JZ termina_missil                   ; se não houver vai saltar para a label para atualizar a flag
	ADD R1, R3                          ; move o missil
	MOV [POS_MISSIL], R1			    ; atualiza a posição do missil em memória
	CMP R1, R7                     	    ; verifica se já alcançou o seu limite de movimento
	JN missil                   	    ; se sim espera que disparem de novo
	JMP ciclo_missil			   	    ; se não, volta a movimentar o míssil uma linha
termina_missil:
	MOV R9, INATIVO                     ; ativa a flag que informa que já não há míssil no ecrã
	MOV [ACABA_MISSIL], R9              ; escreve em memória a nova flag
	JMP missil                          ; volta ao início do processo





; ************************************************************************************************************
; *	 START_MISSIL: Devolve registos necessários para mover o míssil e coloca a posição do míssil em memória  *
; *  Retorna:       R7 - Linha máxima do missil                                                              *
; * 		        R1 - Linha do missil                                                                     *
; *		            R2 - Coluna do missil                                                                    *
; *                 R4 - tabela missil                                                                       *
; ************************************************************************************************************
start_missil:
	PUSH R9                             ; coloca o registo em stack de modo a salvaguarda-lo
	MOV R7, MAX_LINHA_MISSIL            ; carrega R7 com a linha (meio do ecrã) até que o míssil pode ir
	MOV R1, [POS_NAVE]				    ; carrega em R1 a linha do rover
	MOV R2, [POS_NAVE + MAIS_UM_END]	; carrega em R2 a coluna do rover
	DEC R1                              ; coloca o míssil a começar uma linha acima do rover
	MOV [POS_MISSIL], R1			    ; guarda a linha do míssil em memória
	ADD R2, 2						    ; coloca o míssil a começar na coluna do meio do rover
	MOV [POS_MISSIL + MAIS_UM_END], R2	; guarda a coluna do míssil em memória
	MOV R3, DEC_DISPLAY                 ; carrega em R3 a mudança de valor no display da energia
	CALL troca_valor_display            ; decrementa o valor da energia (display) em 5
	MOV R4, TABLE_MISSIL                ; carrega em R4 a tabela que desenha o míssil
	MOV R9, 3                           ; seleciona o som a ser tocado
	MOV [TOCA_SOM_VID], R9              ; toca o som selecionado anteriormente
	POP R9                              ; faz a limpeza do stack e retorna
	RET

.DATA

MSGINTERFACE0 DB '                            |------------------| $'  
MSGINTERFACE1 DB '                            |-----WELCOME!-----| $'
MSGINTERFACE2 DB '                            |------------------| $'
MSGCHOICE DB 'ESCOLHA QUE ALGORITMO PRETENDE EXECUTAR[1- DIVISAO, 2- RAIZ QUADRADA]:  $'
CHOICE DW 0


DIVIDENDO DW 10 DUP(10)
HIGHORDER DW 0 
DIVISOR DW 0 
IMULT DW 0 
RESTO DW 0 
QUOCIENTE DW 0  
ARRAYPOS DW -2 
ARRAYPOSINPUT DW -2  
CALCQUOCIENTERESTO DW 0  
MSGDIVIDENDO DB 'QUANTOS DIGITOS PRETENDE USAR NO DIVIDENDO: $'
MSGDIVISOR DB 'QUANTOS DIGITOS PRETENDE USAR NO DIVISOR: $' 
MSGNEGATIVO DB 'PRETENDE QUE O NUMERO SEJA NEGATIVO? SE SIM, PRESSIONE - : $'
MSGDIGITO DB 'INSIRA UM DIGITO: $' 
MSGRESULTADO DB 'QUOCIENTE: $'  
MSGRESTO DB 'RESTO: $'
NDIGITOSDIVID DW 0
NDIGITOSDIVISOR DW 0
INPUTDIGITDIVISOR DW 0 
ARRAYRESULTDIVISAO DW 6 DUP(0) 
QCOUNT DW -2 
NEGATIVO DW 0


MESSAGERADICANDO DB 'INSIRA O NUMERO DE DIGITOS QUE PRETENDE USAR PRA O RADICANDO: $' 
MSGRESULTADORAIZ DB 'RESULTADO: $'   
HIGHORDER1 DW 0  
HIGHORDER2 DW 0
I  DW -1
J  DW -1
NALGARISMO DW 0
NDIGITSHIGHORDER DW -1   
RADICANDO DW 10 DUP(10) 
ARRAYPOSATUAL DW -2
RESULTFINAL DW 0 
AUX DW 0  
NDIGITOSRADICANDO DW 0  
ARRAYRESULTRAIZ DW 6 DUP(0)

.CODE

WELCOMEPROC PROC
    MOV DX, OFFSET MSGINTERFACE0
    MOV AH, 09H
    INT 21H     
    CALL CH_NEXTLINE 
    
    MOV DX, OFFSET MSGINTERFACE1
    MOV AH, 09H
    INT 21H     
    CALL CH_NEXTLINE
    
    MOV DX, OFFSET MSGINTERFACE2
    MOV AH, 09H
    INT 21H     
    CALL CH_NEXTLINE
    
    RET
ENDP
  
CH_NEXTLINE PROC
   
    MOV DL, 0AH
    MOV AH, 02H
    INT 21H 
    MOV DL, 0DH
    MOV AH, 02H
    INT 21H 
    RET
ENDP


CHECK_NDIGITOSDIVID PROC
    CMP AX, 0
    JLE GET_DIGITOSDIVIDENDO
    
    CMP AX,9
    JG GET_DIGITOSDIVIDENDO
    
    RET
ENDP


N_NEGATIVO PROC
    CALL CH_NEXTLINE
    MOV DX, OFFSET MSGNEGATIVO
    MOV AH, 09H
    INT 21H
    
    MOV AH, 01H
    INT 21H
    
    CMP AL, 2DH
    JNE NEGATIVOCONTINUE
    
    ADD NEGATIVO, 1 
    
    NEGATIVOCONTINUE:      
    RET
ENDP



GET_DIGITOSDIVIDENDO PROC
    CALL CH_NEXTLINE
    
    MOV DX, OFFSET MSGDIVIDENDO
    MOV AH, 09H
    INT 21H
    
    MOV AH,01H
    INT 21H
    
    SUB AX, 130H
    

    CALL CHECK_NDIGITOSDIVID
    
    MOV NDIGITOSDIVID, AX    
    RET
ENDP


GET_DIVIDENDO PROC
    DEC NDIGITOSDIVID
    CALL CH_NEXTLINE
    
    NOTVALIDJUMPDIVIDENDO:    
    MOV DX, OFFSET MSGDIGITO
    MOV AH, 09H
    INT 21H
    
    MOV AH,01H
    INT 21H
    SUB AX, 130H
    
  
    CMP AX, 0
    JL NOTVALIDJUMPDIVIDENDO
    
    CMP AX,9
    JG NOTVALIDJUMPDIVIDENDO 
    
    ADD ARRAYPOSINPUT,2
    MOV BX, ARRAYPOSINPUT
    MOV DIVIDENDO[BX], AX
 
    
    CMP NDIGITOSDIVID, 0
    JNE GET_DIVIDENDO
         
    RET
ENDP


CHECK_NDIGITOSDIVISOR PROC
    CMP AX, 0
    JLE GET_NDIGITOSDIVISOR
    
    CMP AX,9
    JG GET_NDIGITOSDIVISOR
    
    RET
ENDP  


GET_NDIGITOSDIVISOR PROC
    MOV DIVISOR, 0
    CALL CH_NEXTLINE
    
    MOV DX, OFFSET MSGDIVISOR
    MOV AH, 09H
    INT 21H
    
    MOV AH,01H
    INT 21H
    
    SUB AX, 130H
    
 
    CALL CHECK_NDIGITOSDIVISOR
    
    MOV NDIGITOSDIVISOR, AX    
    RET
ENDP


GET_DIVISOR PROC
    DEC NDIGITOSDIVISOR 
    
    CALL CH_NEXTLINE
    
    NOTVALIDJUMPDIVISOR:
    CALL CH_NEXTLINE    
    MOV DX, OFFSET MSGDIGITO
    MOV AH, 09H
    INT 21H
    
    MOV AH,01H
    INT 21H
    SUB AX, 130H
    
 
    CMP AX, 0
    JL NOTVALIDJUMPDIVISOR
    
    CMP AX,9
    JG NOTVALIDJUMPDIVISOR
    
    MOV INPUTDIGITDIVISOR,AX
    
    MOV AX, DIVISOR
    MOV BX, 10
    MUL BX
    ADD AX, INPUTDIGITDIVISOR  
    
    MOV DIVISOR, AX 

    CMP NDIGITOSDIVISOR, 0
    JNE GET_DIVISOR
        
    RET
ENDP


DIVISAO PROC 
    INICIO:     

    GETHIGHORDER:
        ADD ARRAYPOS, 2 
        MOV BX, ARRAYPOS 
        MOV AX, DIVIDENDO[BX] 
        CMP AX, 10
        JB COMPARAHIGHORDER
        JAE OVERFLOW
    
 
    COMPARAHIGHORDER:
        MOV HIGHORDER, AX
        MOV RESTO, AX
        CMP AX, DIVISOR
        JB CONCATHIGHORDER 
        JAE FLAG          
    

    CONCATHIGHORDER:
        
      
        ADD ARRAYPOS, 2
        MOV BX, ARRAYPOS
        MOV CX, DIVIDENDO[BX]
        CMP CX, 10     
   
        JNE NEXT
        JE FLAG
        
        NEXT:    
        MOV CX, 10
        MOV DX, 0 
        MUL CX
        MOV CX, DIVIDENDO[BX]
        ADD AX, CX         
        MOV HIGHORDER, AX
        MOV RESTO, AX 
    
    FLAG:

    MOV IMULT, -1 
    
  
    QUOCIENTECAL:
        INC IMULT
        MOV CX, IMULT
        MOV AX, DIVISOR
        MOV DX, 0
        MUL CX 
        CMP AX, RESTO
        JB QUOCIENTECAL
        JE CALCOPERRESTO 
    
   
    ITERANTERIOR:
        DEC IMULT 
    
  
    CALCOPERRESTO:
        MOV AX, IMULT
        MUL DIVISOR
        MOV BX, RESTO
        MOV CALCQUOCIENTERESTO, AX
    

    OPERACAORESTO:
        MOV AX, RESTO
        SUB AX, CALCQUOCIENTERESTO
        MOV RESTO, AX
    
  
    CALCQUOCIENTE2:
    
        MOV BX, ARRAYPOS
        ADD BX,2
        CMP DIVIDENDO[BX], 10
     
        JNE FLAG2
        JE  CONCATQUOCIENTE
            
        FLAG2:
        MOV DX, 0 
        MOV AX, RESTO
        MOV BX, 10
        MUL BX
        MOV RESTO, AX
        
     
        MOV BX, ARRAYPOS
        ADD BX,2
        CMP DIVIDENDO[BX], 10
     
        JNE CONCATRESTO
    
 
    CONCATRESTO:
        MOV AX, RESTO 
        ADD AX, DIVIDENDO[BX] 
        MOV RESTO, AX
    
 
    CONCATQUOCIENTE:
        MOV AX, 10
        MUL QUOCIENTE
        ADD AX, IMULT
        MOV QUOCIENTE, AX
    
 
    CONDICAOJUMP:
        MOV IMULT, -1
        MOV BX, ARRAYPOS
        ADD BX,2
        ADD ARRAYPOS,2
        CMP DIVIDENDO[BX], 10
        JNE QUOCIENTECAL
        JE  OVERFLOW                        
    OVERFLOW:
        RET
ENDP


MOSTRARESULTDIVISAO PROC
    CALL CH_NEXTLINE
    MOV DX, OFFSET MSGRESULTADO
    MOV AH, 09H
    INT 21H
    
   
    SEPARADIGITOS: 
        MOV DX,0
        MOV AX, QUOCIENTE
        MOV BX, 10
        DIV BX
        MOV QUOCIENTE,AX
        ADD QCOUNT, 2
        MOV BX, QCOUNT
        MOV ARRAYRESULTDIVISAO[BX], DX
        CMP QUOCIENTE, 0
        JG SEPARADIGITOS
        
       
        CMP NEGATIVO,1
        JNE MOSTRAQUOCIENTE0
        
        MOV DL,0F0H
        MOV AH, 06H
        INT 21H 
        
      
        MOSTRAQUOCIENTE0:
        ADD QCOUNT, 2
        MOSTRAQUOCIENTE:
        SUB QCOUNT, 2
        MOV BX, QCOUNT
        MOV AX, ARRAYRESULTDIVISAO[BX]
        MOV DX, AX
        ADD DX, 130H
        MOV AH, 06H
        INT 21H
        CMP QCOUNT, 0
        JNE MOSTRAQUOCIENTE
        
     
        CALL CH_NEXTLINE
        MOV QCOUNT, -2
        SEPARARESTO:
        MOV DX,0
        MOV AX, RESTO
        MOV BX, 10
        DIV BX
        MOV RESTO,AX
        ADD QCOUNT, 2
        MOV BX, QCOUNT
        MOV ARRAYRESULTDIVISAO[BX], DX
        CMP RESTO, 0
        JG SEPARARESTO
        
        MOV DX, OFFSET MSGRESTO
        MOV AH,09H
        INT 21H
        
      
        MOSTRARESTO0:
        ADD QCOUNT, 2
        MOSTRARESTO:
        SUB QCOUNT, 2
        MOV BX, QCOUNT
        MOV AX, ARRAYRESULTDIVISAO[BX]
        MOV DX, AX
        ADD DX, 130H
        MOV AH, 06H
        INT 21H
        CMP QCOUNT, 0
        JNE MOSTRARESTO
                
        RET    
ENDP


GET_NDIGITOSRADICANDO PROC
    CALL CH_NEXTLINE
    MOV DX, OFFSET MESSAGERADICANDO
    MOV AH, 09H
    INT 21H
    
    MOV AH, 01H
    INT 21H
    SUB AX, 130H 
        
    CMP AX, 0
    JLE GET_NDIGITOSRADICANDO
    
    CMP AX, 9
    JG GET_NDIGITOSRADICANDO
    
    MOV NDIGITOSRADICANDO, AX
        
    RET
ENDP


GET_RADICANDO PROC 
    CALL CH_NEXTLINE
    DEC NDIGITOSRADICANDO
    CALL CH_NEXTLINE
    
    NOTVALIDJUMPRADICANDO:    
    MOV DX, OFFSET MSGDIGITO
    MOV AH, 09H
    INT 21H
    
    MOV AH,01H
    INT 21H
    SUB AX, 130H
    
 
    CMP AX, 0
    JL NOTVALIDJUMPRADICANDO
    
    CMP AX,9
    JG NOTVALIDJUMPRADICANDO
    
    ADD ARRAYPOSINPUT,2
    MOV BX, ARRAYPOSINPUT
    MOV RADICANDO[BX], AX
    
    CMP NDIGITOSRADICANDO, 0
    JNE GET_RADICANDO
         
    RET
ENDP


SQRTALGORITMO PROC
    NDIGITOS:
       ADD ARRAYPOS, 2 
       INC NALGARISMO 
       MOV BX, ARRAYPOS
       MOV AX, RADICANDO[BX] 
       MOV CX, ARRAYPOS
       ADD CX, 2
       MOV BX, CX
       MOV CX, RADICANDO[BX]
       CMP CX, 10
       JE ISEVEN
       JNE NDIGITOS
    
    ISEVEN:
        MOV DX,0  
        MOV BX, 2 
        MOV AX, NALGARISMO
        DIV BX  
        CMP DX, 0
        JNE GETHIGHORDERPAIRIFNOTEVEN
        JE  GETHIGHORDERPAIRIFEVEN
        
    GETHIGHORDERPAIRIFNOTEVEN: 
        ADD ARRAYPOSATUAL, 2
        MOV BX, ARRAYPOSATUAL
        MOV AX, RADICANDO[BX] 
        MOV HIGHORDER1, AX
        DEC NALGARISMO
        JMP ITERACAO1    
     
    GETHIGHORDERPAIRIFEVEN:  
        ADD ARRAYPOSATUAL, 2
        MOV BX, ARRAYPOSATUAL
        MOV AX, RADICANDO[BX] 
        MOV CX, 10
        MUL CX
        MOV BX, ARRAYPOSATUAL
        ADD BX, 2
        MOV ARRAYPOSATUAL, BX
        MOV CX, RADICANDO[BX]
        ADD AX, CX        
        MOV HIGHORDER1, AX       
      
    ITERACAO1:
        INC I
        MOV AX,I
        MUL AX
        CMP AX, HIGHORDER1
        JA DECREMENT 
        JBE ITERACAO1
    
    DECREMENT: 
        DEC I 
    
    SUBTRACAO:  
        MOV AX, ARRAYPOSATUAL
        ADD AX, 2      
        MOV BX,AX
        CMP RADICANDO[BX], 10
        JE FINALRESULT1
        
        MOV AX, I
        MUL AX
        SUB HIGHORDER1, AX 
    
    GETNEXTHIGHORDERPAIR:   
        ADD ARRAYPOSATUAL, 2
        MOV BX, ARRAYPOSATUAL
        MOV AX, RADICANDO[BX] 
        MOV CX, 10
        MUL CX
        MOV BX, ARRAYPOSATUAL
        ADD BX, 2
        MOV ARRAYPOSATUAL, BX
        MOV CX, RADICANDO[BX]
        ADD AX, CX        
        MOV HIGHORDER2, AX
        
            
    MOV AX, HIGHORDER2
    GETHIGHORDERNDIGITS: 
        MOV DX, 0
        INC NDIGITSHIGHORDER
        MOV BX, 10
        DIV BX
        CMP AX, 0       
        JNE GETHIGHORDERNDIGITS
    
    ELEVADO: 
        MOV AX, 10
        MUL AX
        MOV CX, NDIGITSHIGHORDER
        DEC NDIGITSHIGHORDER
        CMP CX, 0
        JNE ELEVADO

    
    CONCATHIGHORDERRAIZ:   
        MOV BX, HIGHORDER1
        MUL BX
        ADD AX, HIGHORDER2 
        MOV HIGHORDER1, AX 
        
    OPER1: 
        MOV AX,I
        MOV BX, 2
        MUL BX
        MOV BX, 10
        MUL BX
        MOV AUX, AX
    
    DESCOBREJ: 
        INC J
        MOV BX, J
        MOV AX, AUX
        ADD AX, BX
        MUL BX
        MOV BX, HIGHORDER1
        CMP AX, BX
        JG DECREMENTAJ
        JLE DESCOBREJ
    
    DECREMENTAJ: 
        DEC J
    
    OPER2:
        MOV AX,AUX
        MOV BX, J
        ADD AX, J
        MUL J
        MOV AUX,AX
        
    SUBTRACAO2:
        MOV AX, HIGHORDER1
        MOV BX, AUX
        SUB AX, BX
        MOV HIGHORDER1, AX
    
    CONCATI:
        MOV AX, I
        MOV BX, 10
        MUL BX     
        ADD AX, J
        MOV I, AX
        
        MOV BX, ARRAYPOSATUAL
        ADD BX, 2
        CMP RADICANDO[BX],10        
        JNE GETNEXTHIGHORDERPAIR
        JE FINALRESULT1
    
    FINALRESULT1: 
        MOV RESULTFINAL,0
        MOV AX,I
        MOV RESULTFINAL, AX 
    
    MOV ARRAYPOS,0
    MOV BX, ARRAYPOS
    CMP RADICANDO[BX],0
    JE FINAL   
             
    FINAL:
    RET
ENDP

MOSTRARESULTSQRT PROC
    CALL CH_NEXTLINE
    MOV DX, OFFSET MSGRESULTADORAIZ
    MOV AH, 09H
    INT 21H
    
    SEPARADIGITOSRAIZ: 
        MOV DX,0
        MOV AX, RESULTFINAL
        MOV BX, 10
        DIV BX
        MOV RESULTFINAL,AX
        ADD QCOUNT, 2
        MOV BX, QCOUNT
        MOV ARRAYRESULTRAIZ[BX], DX
        CMP RESULTFINAL, 0
        JG SEPARADIGITOSRAIZ
        
        MOSTRARAIZ0:
        ADD QCOUNT, 2
        MOSTRARAIZ:
        SUB QCOUNT, 2
        MOV BX, QCOUNT
        MOV AX, ARRAYRESULTRAIZ[BX]
        MOV DX, AX
        ADD DX, 130H
        MOV AH, 06H
        INT 21H
        CMP QCOUNT, 0
        JNE MOSTRARAIZ
    RET
ENDP


MAIN PROC FAR
    MOV DX, @DATA
    MOV DS, DX
    
    CALL WELCOMEPROC
    CALL CH_NEXTLINE
    
    ESCOLHAALGORITMO:
    MOV DX, OFFSET MSGCHOICE
    MOV AH, 09H
    INT 21H
    
    MOV AH, 01H
    INT 21H
    SUB AX, 130H
    MOV CHOICE, AX
    
    CALL CH_NEXTLINE
    
    CMP CHOICE, 1
    JE DIVCHOICE
    
    CMP CHOICE, 2
    JE SQRTCHOICE
    JNE ESCOLHAALGORITMO 
    
    
    DIVCHOICE:
    CALL GET_DIGITOSDIVIDENDO
    
    CALL N_NEGATIVO
    
    CALL GET_DIVIDENDO
    
    CALL CH_NEXTLINE
    
    CALL GET_NDIGITOSDIVISOR
    
    CALL N_NEGATIVO 
    
    CALL GET_DIVISOR
    
    CALL DIVISAO
    
    CALL CH_NEXTLINE
    
    CALL MOSTRARESULTDIVISAO
    
    JMP FIM
    SQRTCHOICE:
    CALL GET_NDIGITOSRADICANDO
    
    CALL GET_RADICANDO
    
    CALL SQRTALGORITMO
    
    CALL MOSTRARESULTSQRT
    
    FIM:
    HLT   
ENDP
END MAIN
.DATA

msgInterface0 db '                            |------------------| $'  
msgInterface1 db '                            |-----Welcome!-----| $'
msgInterface2 db '                            |------------------| $'
msgChoice db 'Escolha que algoritmo pretende executar[1- Divisao, 2- Raiz Quadrada]:  $'
choice dw 0


dividendo DW 10 DUP(10)
highOrder DW 0 
divisor DW 0 
iMult DW 0 
resto DW 0 
quociente DW 0  
arrayPos DW -2 
arrayPosInput DW -2  
calcQuocienteResto DW 0  
msgDividendo DB 'Quantos digitos pretende usar no dividendo: $'
msgDivisor DB 'Quantos digitos pretende usar no divisor: $' 
msgNegativo DB 'Pretende que o numero seja negativo? Se sim, pressione - : $'
msgDigito DB 'Insira um digito: $' 
msgResultado DB 'Quociente: $'  
msgResto DB 'Resto: $'
nDigitosDivid DW 0
nDigitosDivisor DW 0
inputDigitDivisor DW 0 
arrayResultDivisao DW 6 DUP(0) 
qCount DW -2 
negativo DW 0


MESSAGERADICANDO DB 'INSIRA O NUMERO DE DIGITOS QUE PRETENDE USAR PRA O RADICANDO: $' 
msgResultadoRaiz DB 'Resultado: $'   
highOrder1 DW 0  
highOrder2 DW 0
i  DW -1
j  DW -1
nAlgarismo DW 0
nDigitsHighOrder DW -1   
RADICANDO DW 10 DUP(10) 
arrayPosAtual DW -2
resultFinal DW 0 
aux DW 0  
nDigitosRadicando DW 0  
arrayResultRaiz DW 6 DUP(0)

.CODE

welcomeProc proc
    mov dx, offset msgInterface0
    mov ah, 09h
    int 21h     
    call ch_nextline 
    
    mov dx, offset msgInterface1
    mov ah, 09h
    int 21h     
    call ch_nextline
    
    mov dx, offset msgInterface2
    mov ah, 09h
    int 21h     
    call ch_nextline
    
    ret
endp
  
ch_nextline proc
   
    MOV dl, 0ah
    MOV ah, 02h
    INT 21h 
    MOV dl, 0dh
    MOV ah, 02h
    INT 21h 
    ret
endp


check_NDigitosDivid proc
    cmp ax, 0
    jle get_digitosDividendo
    
    cmp ax,9
    jg get_digitosDividendo
    
    ret
endp


n_negativo proc
    call ch_nextline
    mov dx, offset msgNegativo
    mov ah, 09h
    int 21h
    
    mov ah, 01h
    int 21h
    
    CMP al, 2Dh
    JNE negativoContinue
    
    ADD negativo, 1 
    
    negativoContinue:      
    ret
endp



get_digitosDividendo proc
    call ch_nextline
    
    mov dx, offset msgDividendo
    mov ah, 09h
    int 21h
    
    mov ah,01h
    int 21h
    
    sub ax, 130h
    

    call check_NDigitosDivid
    
    mov nDigitosDivid, ax    
    ret
endp


get_Dividendo proc
    dec nDigitosDivid
    call ch_nextline
    
    notValidJumpDividendo:    
    mov dx, offset msgDigito
    mov ah, 09h
    int 21h
    
    mov ah,01h
    int 21h
    sub ax, 130h
    
  
    cmp ax, 0
    jl notValidJumpDividendo
    
    cmp ax,9
    jg notValidJumpDividendo 
    
    add arrayPosInput,2
    mov bx, arrayPosInput
    mov dividendo[bx], ax
 
    
    cmp nDigitosDivid, 0
    JNE get_Dividendo
         
    ret
endp


check_NDigitosDivisor proc
    cmp ax, 0
    jle get_nDigitosDivisor
    
    cmp ax,9
    jg get_nDigitosDivisor
    
    ret
endp  


get_nDigitosDivisor proc
    mov divisor, 0
    call ch_nextline
    
    mov dx, offset msgDivisor
    mov ah, 09h
    int 21h
    
    mov ah,01h
    int 21h
    
    sub ax, 130h
    
 
    call check_NDigitosDivisor
    
    mov nDigitosDivisor, ax    
    ret
endp


get_Divisor proc
    dec nDigitosDivisor 
    
    call ch_nextline
    
    notValidJumpDivisor:
    call ch_nextline    
    mov dx, offset msgDigito
    mov ah, 09h
    int 21h
    
    mov ah,01h
    int 21h
    sub ax, 130h
    
 
    cmp ax, 0
    jl notValidJumpDivisor
    
    cmp ax,9
    jg notValidJumpDivisor
    
    mov inputDigitDivisor,ax
    
    mov ax, divisor
    mov bx, 10
    mul bx
    add ax, inputDigitDivisor  
    
    mov divisor, ax 

    cmp nDigitosDivisor, 0
    JNE get_Divisor
        
    ret
endp


divisao proc 
    inicio:     

    getHighOrder:
        ADD arrayPos, 2 
        MOV BX, arrayPos 
        MOV AX, dividendo[BX] 
        CMP AX, 10
        JB comparaHighOrder
        JAE overflow
    
 
    comparaHighOrder:
        MOV HighOrder, AX
        MOV Resto, AX
        CMP AX, divisor
        JB concatHighOrder 
        JAE flag          
    

    concatHighOrder:
        
      
        ADD arrayPos, 2
        MOV BX, arrayPos
        MOV CX, dividendo[BX]
        CMP CX, 10     
   
        JNE next
        JE flag
        
        next:    
        MOV CX, 10
        MOV DX, 0 
        MUL CX
        MOV CX, dividendo[BX]
        ADD AX, CX         
        MOV HighOrder, AX
        MOV Resto, AX 
    
    flag:

    MOV iMult, -1 
    
  
    quocienteCal:
        INC iMult
        MOV CX, iMult
        MOV AX, divisor
        MOV DX, 0
        MUL CX 
        CMP AX, Resto
        JB quocienteCal
        JE calcOperResto 
    
   
    iterAnterior:
        DEC iMult 
    
  
    calcOperResto:
        MOV AX, iMult
        MUL divisor
        MOV BX, resto
        MOV calcQuocienteResto, AX
    

    OperacaoResto:
        MOV AX, Resto
        SUB AX, calcQuocienteResto
        MOV Resto, AX
    
  
    calcQuociente2:
    
        MOV BX, arrayPos
        ADD BX,2
        CMP dividendo[BX], 10
     
        JNE flag2
        JE  concatQuociente
            
        flag2:
        MOV DX, 0 
        MOV AX, Resto
        MOV BX, 10
        MUL BX
        MOV resto, AX
        
     
        MOV BX, arrayPos
        ADD BX,2
        CMP dividendo[BX], 10
     
        JNE concatResto
    
 
    concatResto:
        MOV AX, resto 
        ADD AX, dividendo[BX] 
        MOV resto, AX
    
 
    concatQuociente:
        MOV AX, 10
        MUL quociente
        ADD AX, iMult
        MOV quociente, AX
    
 
    condicaoJump:
        MOV iMult, -1
        MOV BX, arrayPos
        ADD BX,2
        ADD arrayPos,2
        CMP dividendo[BX], 10
        JNE quocienteCal
        JE  overflow                        
    overflow:
        ret
endp


mostraResultDivisao proc
    call ch_nextline
    mov dx, offset msgResultado
    mov ah, 09h
    int 21h
    
   
    separaDigitos: 
        mov dx,0
        MOV ax, quociente
        mov bx, 10
        div bx
        mov quociente,ax
        add qCount, 2
        mov bx, qCount
        mov arrayResultDivisao[bx], dx
        cmp quociente, 0
        JG separaDigitos
        
       
        CMP negativo,1
        JNE mostraQuociente0
        
        mov dl,0f0h
        mov ah, 06h
        int 21h 
        
      
        mostraQuociente0:
        add qCount, 2
        mostraQuociente:
        sub qCount, 2
        mov bx, qCount
        mov ax, arrayResultDivisao[bx]
        mov dx, ax
        add dx, 130h
        mov ah, 06h
        int 21h
        cmp qCount, 0
        JNE mostraQuociente
        
     
        call ch_nextline
        mov qCount, -2
        separaResto:
        mov dx,0
        MOV ax, resto
        mov bx, 10
        div bx
        mov resto,ax
        add qCount, 2
        mov bx, qCount
        mov arrayResultDivisao[bx], dx
        cmp resto, 0
        JG separaResto
        
        mov dx, offset msgResto
        mov ah,09h
        int 21h
        
      
        mostraResto0:
        add qCount, 2
        mostraResto:
        sub qCount, 2
        mov bx, qCount
        mov ax, arrayResultDivisao[bx]
        mov dx, ax
        add dx, 130h
        mov ah, 06h
        int 21h
        cmp qCount, 0
        JNE mostraResto
                
        ret    
endp


get_nDigitosRadicando proc
    call ch_nextline
    mov dx, offset MESSAGERADICANDO
    mov ah, 09h
    int 21h
    
    mov ah, 01h
    int 21h
    sub ax, 130h 
        
    cmp ax, 0
    jle get_nDigitosRadicando
    
    cmp ax, 9
    jg get_nDigitosRadicando
    
    mov nDigitosRadicando, ax
        
    ret
endp


get_Radicando proc 
    call ch_nextline
    dec nDigitosRadicando
    call ch_nextline
    
    notValidJumpRadicando:    
    mov dx, offset msgDigito
    mov ah, 09h
    int 21h
    
    mov ah,01h
    int 21h
    sub ax, 130h
    
 
    cmp ax, 0
    jl notValidJumpRadicando
    
    cmp ax,9
    jg notValidJumpRadicando
    
    add arrayPosInput,2
    mov bx, arrayPosInput
    mov RADICANDO[bx], ax
    
    cmp nDigitosRadicando, 0
    JNE get_Radicando
         
    ret
endp


sqrtAlgoritmo proc
    nDigitos:
       ADD arrayPos, 2 
       INC nAlgarismo 
       MOV BX, arrayPos
       MOV AX, radicando[BX] 
       MOV CX, arrayPos
       ADD CX, 2
       MOV BX, CX
       MOV CX, radicando[BX]
       CMP CX, 10
       JE isEven
       JNE nDigitos
    
    isEven:
        MOV DX,0  
        MOV BX, 2 
        MOV AX, nAlgarismo
        DIV BX  
        CMP DX, 0
        JNE getHighOrderPairIfNotEven
        JE  getHighOrderPairIfEven
        
    getHighOrderPairIfNotEven: 
        ADD arrayPosAtual, 2
        MOV BX, arrayPosAtual
        MOV AX, radicando[BX] 
        MOV highOrder1, AX
        DEC nAlgarismo
        JMP iteracao1    
     
    getHighOrderPairIfEven:  
        ADD arrayPosAtual, 2
        MOV BX, arrayPosAtual
        MOV AX, radicando[BX] 
        MOV CX, 10
        MUL CX
        MOV BX, arrayPosAtual
        ADD BX, 2
        MOV arrayPosAtual, BX
        MOV CX, radicando[BX]
        ADD AX, CX        
        MOV highOrder1, AX       
      
    iteracao1:
        INC I
        MOV AX,i
        MUL AX
        CMP AX, highOrder1
        JA decrement 
        JBE iteracao1
    
    decrement: 
        DEC I 
    
    subtracao:  
        MOV AX, arrayPosAtual
        ADD AX, 2      
        MOV BX,AX
        CMP radicando[BX], 10
        JE finalResult1
        
        MOV AX, I
        MUL AX
        SUB highOrder1, AX 
    
    getNextHighOrderPair:   
        ADD arrayPosAtual, 2
        MOV BX, arrayPosAtual
        MOV AX, radicando[BX] 
        MOV CX, 10
        MUL CX
        MOV BX, arrayPosAtual
        ADD BX, 2
        MOV arrayPosAtual, BX
        MOV CX, radicando[BX]
        ADD AX, CX        
        MOV highOrder2, AX
        
            
    MOV AX, highOrder2
    getHighOrderNDigits: 
        MOV DX, 0
        INC nDigitsHighOrder
        MOV BX, 10
        DIV BX
        CMP AX, 0       
        JNE getHighOrderNDigits
    
    elevado: 
        MOV AX, 10
        MUL AX
        MOV CX, nDigitsHighOrder
        DEC nDigitsHighOrder
        CMP CX, 0
        JNE elevado

    
    concatHighOrderRaiz:   
        MOV BX, highOrder1
        MUL BX
        ADD AX, highOrder2 
        MOV highOrder1, AX 
        
    oper1: 
        MOV AX,i
        MOV BX, 2
        MUL BX
        MOV BX, 10
        MUL BX
        MOV aux, AX
    
    descobreJ: 
        INC j
        MOV BX, j
        MOV AX, aux
        ADD AX, BX
        MUL BX
        MOV BX, highOrder1
        CMP AX, BX
        JG decrementaJ
        JLE descobreJ
    
    decrementaJ: 
        DEC j
    
    oper2:
        MOV AX,aux
        MOV BX, j
        ADD AX, j
        MUL j
        MOV aux,AX
        
    subtracao2:
        MOV AX, highOrder1
        MOV BX, aux
        SUB AX, BX
        MOV highOrder1, AX
    
    concatI:
        MOV AX, I
        MOV BX, 10
        MUL BX     
        ADD AX, j
        MOV i, AX
        
        MOV BX, arrayPosAtual
        ADD BX, 2
        CMP radicando[BX],10        
        JNE getNextHighOrderPair
        JE finalResult1
    
    finalResult1: 
        MOV resultFinal,0
        MOV AX,i
        MOV resultFinal, AX 
    
    MOV arrayPos,0
    MOV BX, arrayPos
    CMP radicando[BX],0
    JE final   
             
    final:
    ret
endp

mostraResultSqrt proc
    call ch_nextline
    mov dx, offset msgResultadoRaiz
    mov ah, 09h
    int 21h
    
    separaDigitosRaiz: 
        mov dx,0
        MOV ax, resultFinal
        mov bx, 10
        div bx
        mov resultFinal,ax
        add qCount, 2
        mov bx, qCount
        mov arrayResultRaiz[bx], dx
        cmp resultFinal, 0
        JG separaDigitosRaiz
        
        mostraRaiz0:
        add qCount, 2
        mostraRaiz:
        sub qCount, 2
        mov bx, qCount
        mov ax, arrayResultRaiz[bx]
        mov dx, ax
        add dx, 130h
        mov ah, 06h
        int 21h
        cmp qCount, 0
        JNE mostraRaiz
    ret
endp


MAIN PROC FAR
    MOV DX, @DATA
    MOV DS, DX
    
    call welcomeProc
    call ch_nextline
    
    escolhaAlgoritmo:
    mov dx, offset msgChoice
    mov ah, 09h
    int 21h
    
    mov ah, 01h
    int 21h
    sub ax, 130h
    mov choice, ax
    
    call ch_nextline
    
    cmp choice, 1
    je divChoice
    
    cmp choice, 2
    je sqrtChoice
    jne escolhaAlgoritmo 
    
    
    divChoice:
    call get_digitosDividendo
    
    call n_negativo
    
    call get_Dividendo
    
    call ch_nextline
    
    call get_nDigitosDivisor
    
    call n_negativo 
    
    call get_Divisor
    
    call divisao
    
    call ch_nextline
    
    call mostraResultDivisao
    
    jmp fim
    sqrtChoice:
    call get_nDigitosRadicando
    
    call get_Radicando
    
    call sqrtAlgoritmo
    
    call mostraResultSqrt
    
    fim:
    HLT   
ENDP
END MAIN
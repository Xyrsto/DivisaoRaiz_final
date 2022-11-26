.DATA
;----------VARIAVEIS DA INTERFACE----------
msgInterface0 db '                            |------------------| $'  
msgInterface1 db '                            |-----Welcome!-----| $'
msgInterface2 db '                            |------------------| $'
msgChoice db 'Escolha que algoritmo pretende executar[1- Divisao, 2- Raiz Quadrada]:  $'
choice dw 0

;----------VARIAVEIS DA DIVISAO----------
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

;----------VARIAVEIS DA RAIZ QUADRADA----------
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
;mensagem de boas vindas
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
    ;escreve na linha a seguir 
    MOV dl, 0ah
    MOV ah, 02h
    INT 21h 
    MOV dl, 0dh
    MOV ah, 02h
    INT 21h 
    ret
endp

;verifica se o input é válido
check_NDigitosDivid proc
    cmp ax, 0
    jle get_digitosDividendo
    
    cmp ax,9
    jg get_digitosDividendo
    
    ret
endp

;recebe - se o numero em questao for negativo
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


;recebe o numero de digitos do dividendo
get_digitosDividendo proc
    call ch_nextline
    
    mov dx, offset msgDividendo
    mov ah, 09h
    int 21h
    
    mov ah,01h
    int 21h
    
    sub ax, 130h
    
    ;verifica se o input é válido
    call check_NDigitosDivid
    
    mov nDigitosDivid, ax    
    ret
endp

;recebe digito a digito e guarda no array dividendo
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
    
    ;verifica se o input é válido
    cmp ax, 0
    jl notValidJumpDividendo
    
    cmp ax,9
    jg notValidJumpDividendo 
    
    add arrayPosInput,2
    mov bx, arrayPosInput
    mov dividendo[bx], ax
    ;mov lastInserted, ax
    
    cmp nDigitosDivid, 0
    JNE get_Dividendo
         
    ret
endp

;verifica se o input é válido
check_NDigitosDivisor proc
    cmp ax, 0
    jle get_nDigitosDivisor
    
    cmp ax,9
    jg get_nDigitosDivisor
    
    ret
endp  

;recebe o numero de digitos do divisor
get_nDigitosDivisor proc
    mov divisor, 0
    call ch_nextline
    
    mov dx, offset msgDivisor
    mov ah, 09h
    int 21h
    
    mov ah,01h
    int 21h
    
    sub ax, 130h
    
    ;verifica se o input é válido
    call check_NDigitosDivisor
    
    mov nDigitosDivisor, ax    
    ret
endp

;recebe o divisor digito a digito
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
    
    ;verifica se o input é válido
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

;algoritmo da divisao
divisao proc 
    inicio:     
    ;Obtém o primeiro high order do dividendo   
    getHighOrder:
        ADD arrayPos, 2 
        MOV BX, arrayPos 
        MOV AX, dividendo[BX] 
        CMP AX, 10
        JB comparaHighOrder
        JAE overflow
    
    ;Compara o high order com o divisor. Se o high order for menor do que divisor, passa para a label "concatHighOrder". Se for maior ou igual passa para a label "flag"    
    comparaHighOrder:
        MOV HighOrder, AX
        MOV Resto, AX
        CMP AX, divisor
        JB concatHighOrder 
        JAE flag          
    
    ;concatena o high order seguinte, caso o divisor seja maior do que o high order inicial    
    concatHighOrder:
        
        ;certifica-se de que a posição no array a seguir à atual não é 10, sendo que 10 determina o fim do array
        ADD arrayPos, 2
        MOV BX, arrayPos
        MOV CX, dividendo[BX]
        CMP CX, 10     
        ;se a posicao a seguir for 10, passa para a label "flag", senão passa para a label "next" 
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
    ;inicializa iMult a -1 para não ser feita 1 iteração a mais dentro de "quocienteCalc"                        
    MOV iMult, -1 
    
    ;itera até encontrar um valor para iMult maior do que o Resto. Se iMult for igual ao resto, passa para a label "calcOperResto". Quando iMult for maior do que o resto, salta para a label "iterAnterior"
    quocienteCal:
        INC iMult
        MOV CX, iMult
        MOV AX, divisor
        MOV DX, 0
        MUL CX 
        CMP AX, Resto
        JB quocienteCal
        JE calcOperResto 
    
    ;itera o valor de iMult anterior que respeite a condição iMult * Divisor < Resto     
    iterAnterior:
        DEC iMult 
    
    ;calcula o valor que vai ser subtraido pelo resto 
    calcOperResto:
        MOV AX, iMult
        MUL divisor
        MOV BX, resto
        MOV calcQuocienteResto, AX
    
    ;efetua a operação resto - calcQuocienteResto    
    OperacaoResto:
        MOV AX, Resto
        SUB AX, calcQuocienteResto
        MOV Resto, AX
    
    ;estrutura de controlo do quociente   
    calcQuociente2:
        ;certifica-se de que a posição no array a seguir à atual não é 10, sendo que 10 determina o fim do array
        MOV BX, arrayPos
        ADD BX,2
        CMP dividendo[BX], 10
        ;se a posicao a seguir for 10, passa para a label "concatQuociente", senão passa para a label "flag2" 
        JNE flag2
        JE  concatQuociente
            
        flag2:
        MOV DX, 0 
        MOV AX, Resto
        MOV BX, 10
        MUL BX
        MOV resto, AX
        
        ;certifica-se de que a posição no array a seguir à atual não é 10, sendo que 10 determina o fim do array 
        MOV BX, arrayPos
        ADD BX,2
        CMP dividendo[BX], 10
        ;se a posicao a seguir não for 10, passa para a label "concatResto"
        JNE concatResto
    
    ;concatena o valor calculado anteriormente ao resto
    concatResto:
        MOV AX, resto 
        ADD AX, dividendo[BX] 
        MOV resto, AX
    
    ;concatena o valor calculado anteriormente ao quociente
    concatQuociente:
        MOV AX, 10
        MUL quociente
        ADD AX, iMult
        MOV quociente, AX
    
    ;verifica se a posicao atual é a ultima posicao do array          
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

;mostra o resultado da divisao
mostraResultDivisao proc
    call ch_nextline
    mov dx, offset msgResultado
    mov ah, 09h
    int 21h
    
    ;separa os digitos do quociente e guarda num array arrayResultDivisao
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
        
        ;se for negativo adiciona - ao quociente
        CMP negativo,1
        JNE mostraQuociente0
        
        mov dl,0f0h
        mov ah, 06h
        int 21h 
        
        ;mostra o quociente 
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
        
        ;mostra o resto
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
        
        ;mostra o resto
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

;recebe o numero de digitos do radicando
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

;recebe radicando digito a digito e guarda no array radicando
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
    
    ;verifica se o input é válido
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

;algoritmo da raiz quadrada
sqrtAlgoritmo proc
    nDigitos: ;devolve o número de algarismo do radicando
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
    
    isEven: ;verifica se o numero de digitos é par
        MOV DX,0  
        MOV BX, 2 
        MOV AX, nAlgarismo
        DIV BX  
        CMP DX, 0
        JNE getHighOrderPairIfNotEven
        JE  getHighOrderPairIfEven
        
    getHighOrderPairIfNotEven:  ;obtem o high order se nAlgarismo for impar   
        ADD arrayPosAtual, 2
        MOV BX, arrayPosAtual
        MOV AX, radicando[BX] 
        MOV highOrder1, AX
        DEC nAlgarismo
        JMP iteracao1    
     
    getHighOrderPairIfEven:   ;obtem o high order se nAlgarismo for par
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
      
    iteracao1: ;descobre qual o valor de i que é maior do que o valor do highOrder1
        INC I
        MOV AX,i
        MUL AX
        CMP AX, highOrder1
        JA decrement 
        JBE iteracao1
    
    decrement: ;decrementa i para utilizarmos o valor correto
        DEC I 
    
    subtracao:  ;subtrai o highOrder ao valor guardado em AX multiplicado por I
        MOV AX, arrayPosAtual
        ADD AX, 2      
        MOV BX,AX
        CMP radicando[BX], 10
        JE finalResult1
        
        MOV AX, I
        MUL AX
        SUB highOrder1, AX 
    
    getNextHighOrderPair:   ;obtem o high order se nAlgarismo for par
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
    getHighOrderNDigits: ;obtem o numero de digitos do highOrder
        MOV DX, 0
        INC nDigitsHighOrder
        MOV BX, 10
        DIV BX
        CMP AX, 0       
        JNE getHighOrderNDigits
    
    elevado: ;verifica qual é a potencia de 10 mais adequada para o passo seguinte
        MOV AX, 10
        MUL AX
        MOV CX, nDigitsHighOrder
        DEC nDigitsHighOrder
        CMP CX, 0
        JNE elevado

    
    concatHighOrderRaiz:   ;concatena o proximo highOrder ao HighOrder atual
        MOV BX, highOrder1
        MUL BX
        ADD AX, highOrder2 
        MOV highOrder1, AX 
        
    oper1: ;operacao (2*i*10)
        MOV AX,i
        MOV BX, 2
        MUL BX
        MOV BX, 10
        MUL BX
        MOV aux, AX
    
    descobreJ:  ;descobre o j maior do que o necessario para a proxima operacao
        INC j
        MOV BX, j
        MOV AX, aux
        ADD AX, BX
        MUL BX
        MOV BX, highOrder1
        CMP AX, BX
        JG decrementaJ
        JLE descobreJ
    
    decrementaJ: ;decrementa J para o valor necessario
        DEC j
    
    oper2: ; adiciona j à variavel "aux" e multiplica por j o resultado em AX.
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
    
    concatI: ;concatena o i ao i anterior
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
    
    finalResult1: ;mostra o resultado final
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

;mostra resultado da raiz quadrada
mostraResultSqrt proc
    call ch_nextline
    mov dx, offset msgResultadoRaiz
    mov ah, 09h
    int 21h
    
    ;separa os digitos do quociente e guarda num array arrayResultDivisao
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
        
        ;mostra o quociente 
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
    
    ;proc inicial
    call welcomeProc
    call ch_nextline
    
    ;escolha do algoritmo a executar
    escolhaAlgoritmo:
    mov dx, offset msgChoice
    mov ah, 09h
    int 21h
    
    mov ah, 01h
    int 21h
    sub ax, 130h
    mov choice, ax
    
    call ch_nextline
    
    ;se 1: executa a divisao, se 2 executa a raiz quadrada
    cmp choice, 1
    je divChoice
    
    cmp choice, 2
    je sqrtChoice
    jne escolhaAlgoritmo 
    
    
    divChoice:
    ;recebe o numero de digitos do dividendo
    call get_digitosDividendo
    
    ;recebe o caracter - caso o dividendo seja negativo
    call n_negativo
    
    ;recebe o dividendo digito a digito e guarda no array dividendo
    call get_Dividendo
    
    call ch_nextline
    
    ;recebe o numero de digitos do divisor
    call get_nDigitosDivisor
    
    ;recebe o caracter - caso o divisor seja negativo
    call n_negativo 
    
    ;recebe o divisor digito a digito e guarda na variavel divisor
    call get_Divisor
    
    ;executa o algoritmo da divisao
    call divisao
    
    call ch_nextline
    
    ;mostra o quociente e o resto no ecra
    call mostraResultDivisao
    
    jmp fim
    sqrtChoice:
    ;;recebe o numero de digitos do radicando
    call get_nDigitosRadicando
    
    ;recebe o radicando digito a digito e guarda no array radicando
    call get_Radicando
    
    ;executa o algoritmo da raiz quadrada
    call sqrtAlgoritmo
    
    ;mostra resultado da raiz quadrada
    call mostraResultSqrt
    
    fim:
    HLT   
ENDP
END MAIN
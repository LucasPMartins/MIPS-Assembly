.data
	espaco: .asciiz " "
	msg: .asciiz "-- QUICKSORT --\n--- Array antes ---\n"
	msg2: .asciiz "\n\n--- Array DEPOIS ---\n"
	INF: .word 999
	quebra: .asciiz "\n-------------------\n"
	meuArray:
	.align 2
	.word 6, 5, 4, 1, 2, 11, 12, 22, 17, 18
	.space 40 # defino o tamanho para 10 INTEIROS
	pilhaH: .word 0:1000
	pilhaI: .word 0:1000
	
	# $t0 = indice  || $t1 = low || $t2 = temporario || $t3 = high||$t4 = middle||
	# $t5 = pivot||$t6 = i || $t7 = j
	# $t8
	# $t9 qtd de recursões já feitas.
.text
	li $v0, 4
	la $a0, msg
	syscall
	# inicializando: $t0 = indice, $t2 = tamanho do array
	move $t0, $zero #indice do array
	li $t2, 40 # tamanho do array
	
	move $t0, $zero
	# Imprimo o meu array antes:
	imprime:
		beq $t0, $t2, fimImprime
		li $v0, 1
		lw $a0, meuArray($t0)
		syscall
			
		li $v0, 4
		la $a0, espaco
		syscall
			
		addi $t0, $t0,4
		j imprime
	fimImprime:
	li $v0, 4
	la $a0, quebra
	syscall
	
	# Inicializando primeiro antes de começar o processo recursivo:
	#move $t0, $zero #indice do array
	move $t8,$zero # size da pilha de recursao
	move $t1, $zero # low = 0   (SALVAR NA PILHA
	move $t3, $t2 # high = tam (SALVAR NA PILHA) 
	move $t9, $zero # Pilha começa em 0.
	
	
	jal quickSort
	j finalizar
	
	
	quickSort:
	
	# Salva o registrador de retorno $ra na pilha antes da chamada recursiva
    	subi $sp, $sp, 4
    	sw $ra, ($sp)
		
	#INICIALIÇÂO
	#bgt $t1,$t3,fimWhile1 # if i < j pare
	
	#subi $t0, $t3,1
	div $s1, $t1,4 # HIGH/4
	div $s2, $t3,4 # LOW/4
	
	add $t4, $s2,$s1 # mid = (high+low)
	div $t4, $t4, 2 # mid = (high+low)/2
	mflo $t4 # mid = quociente
	mul $t4,$t4,4
	
	lw $t5, meuArray($t4) # $t5 = PIVOT = array[mid]
	move $t6, $t1 # i = low
	move $t7, $t3 # j = high
	
	#bgt $t6,$t7,fimWhile1 # if i < j pare
	while1:
	     bgt $t6,$t7,fimWhile1 # if i < j pare
	     lw $t2, meuArray($t6)    # array[i]
	     bge $t2, $t5,fimWhile2      # array[i] >= pivot
	     while2:
	     	lw $t2, meuArray($t6)    # array[i]
	     	bge $t2, $t5,fimWhile2      # array[i] >= pivot
	         addi $t6,$t6,4 	       # i+=4	        
	     	j while2
	     fimWhile2:	
	     
	     while3:
	     lw $t2, meuArray($t7) # array[j]
	     ble $t2, $t5,fimWhile3 # array[j] <= pivot
	     	addi $t7,$t7,-4 # j-=4
	     	j while3
	     fimWhile3:
	     
	     bgt $t6,$t7,else # if i > j pule para ELSE
		    #{
              #jal TROCA # troca (array[i],array[j]) i = $t6, j=$t7
              
              	    lw $t2, meuArray($t6) # temp = array[i]
		    lw $a0, meuArray($t7) # temp2 = $array[j]
		    sw $a0,meuArray($t6)  # array[i]=array[j]
		    sw $t2,meuArray($t7) # Troca finalizada
	     	    # incremento i++, j++
	     	    addi $t6,$t6,4 # i+=4
	     	    addi $t7,$t7,-4 # j-=4
		  #}
		 j while1 
	     else:
	     j while1
	     
	fimWhile1:
	
	
    # chamo quicksort de esquerda e direita:    	
    	bge $t1, $t7, else2 # Se low < j, faça quicksort para a parte esquerda
    
    	mul $t8,$t9,4 # Multiplica por 4
    	la $a0,pilhaI
    	add $a0, $t8,$a0 
    	sw $t6, ($a0)   # armazeno o i
    
    	la $a0,pilhaH
    	add $a0, $t8,$a0
    	sw $t3, ($a0)   # armazeno high
    
    	addi $t9,$t9,1 #Incrementa a qtdPilha
    
    	move $t3, $t7 # high = j
        
    
    	jal quickSort
    	bgt $t9,$zero,else2
    
    # -- Recuperando valores --
    
    addi $t9,$t9,-1   #  $t9--
    mul $t8,$t9,4 # Multiplica por 4
    la $a0,pilhaI
    add $a0, $t8,$a0 
    lw $t6, ($a0)   # armazeno o i
    
    la $a0,pilhaH
    add $a0, $t8,$a0
    lw $t3, ($a0)   # armazeno high
    
    
    else2:
    
    bge $t6, $t3, else3 # Se i < high, faça quicksort para a parte direita
    move $t1, $t6 # low = i
    
    jal quickSort
    else3:
    
     # Restaura o registrador de retorno $ra após a chamada recursiva
    lw $ra, ($sp)
    addi $sp, $sp, 4
    jr $ra  # Retorna para o endereço de retorno corretamente
	
	
      fimQuick:
      	beq $t9,$zero,finalizar
	jr $ra
	
	finalizar:
		li $v0, 4
		la $a0, msg2
		syscall
		
		li $t2, 40 # tamanho
		li $t0, 0
		jal imprime2 # imprimo o vetor final
		#Encerro o programa
		li $v0, 10
		syscall
	
	imprime2:
		beq $t0, $t2, fimImprime2
		li $v0, 1
		lw $a0, meuArray($t0)
		syscall
			
		li $v0, 4
		la $a0, espaco
		syscall
			
		addi $t0, $t0,4
		j imprime2
	fimImprime2:	
		jr $ra	# retorna
.data
    base: .word
    expoente: .word
    pergunta_base: .asciiz "Digite a base: "
    pergunta_expoente: .asciiz "Digite o expoente: "
    resultado: .asciiz "Resultado eh: "
.text
    # Imprime String pergunta da base
    li $v0, 4
    la $a0, pergunta_base
    syscall
    
    # Lê inteiro para a base                                        
    li $v0, 5
    syscall
    move $t0, $v0   # Salva o valor da base em $t0
    
    # Imprime String pergunta do expoente
    li $v0, 4
    la $a0, pergunta_expoente
    syscall
    
    # Lê inteiro para o expoente
    li $v0, 5
    syscall
    move $t1, $v0   # Salva o valor do expoente em $t1
    
    # Inicializa o resultado como 1
    li $t3, 1
    
while:
    beq $t1, $zero, saida   # Se o expoente for zero, saia do loop
    
    # Verifica se n é ímpar
    andi $t6, $t1, 1
    beq $t6, $zero, skip_multiply
    
    # Se n for ímpar, multiplica o resultado por x
    mul $t3, $t3, $t0
    
skip_multiply:
    # Divide n por 2
    srl $t1, $t1, 1
    
    # Eleva x ao quadrado
    mul $t0, $t0, $t0
    
    j while   # Continue o loop
    
saida:
    # Imprime a String de saída
    li $v0, 4
    la $a0, resultado
    syscall
    
    # Imprime o resultado
    li $v0, 1
    move $a0, $t3
    syscall

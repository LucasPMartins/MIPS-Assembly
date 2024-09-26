.data
	base: .double
	expoente: .double
	pergunta_base: .asciiz "Digite a base: "
	pergunta_expoente: .asciiz "Digite o expoente: "
	resultado: .asciiz "Resultado eh: "
.text
	#imprime String pergunta da base
	li $v0, 4
	la $a0, pergunta_base
	syscall
	
	#lê inteiro para a base										
	li $v0, 5
	la $a0, base
	syscall
	
	#Salva o valor da base em $t0
	move $t0, $v0
	
	#imprime String pergunta do expoente
	li $v0, 4
	la $a0, pergunta_expoente
	syscall
	
	#lê inteiro para a base
	li $v0, 5
	la $a0, expoente
	syscall
	
	#Salva o valor do expoente em $t1
	move $t1, $v0
	
	#result = 1
	li $t3, 1
	
	#while
while:
	ble $t1, 0, saida
	mul $t3, $t3, $t0
	addi $t1 ,$t1, -1
	j while
saida:
	#imprime a String de saída
	li $v0, 4
	la $a0, resultado
	syscall
	li $v0, 1
	move $a0, $t3
	syscall
	
	
	
	

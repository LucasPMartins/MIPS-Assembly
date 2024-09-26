# string_length - calcula o comprimento de uma string
# $a0 - endereço da string na memória

    .text
    .globl string_length

string_length:
    # Inicialização dos registradores
    addi $t0, $zero, 0        # $t0 = 0 (comprimento da string)
    addi $t1, $a0, 0          # $t1 = endereço inicial da string
    addi $t2, $zero, 1        # $t2 = 1 (incremento para acessar cada caractere)

    loop:
    lb $t3, 0($t1)            # Carrega o caractere atual
    beqz $t3, end_loop        # Verifica se é o caractere nulo (fim da string)
    addi $t1, $t1, 1          # Avança para o próximo caractere
    addi $t0, $t0, 1          # Incrementa o comprimento da string
    j loop                    # Volta para o início do loop

    end_loop:
    addi $v0, $t0, -1         # Armazena o comprimento da string em $v0
    jr $ra                    # Retorna ao chamador

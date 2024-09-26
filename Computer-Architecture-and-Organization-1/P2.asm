.data
    prompt: .asciiz "Entre com a string a ser convertida: "
    buffer: .space 256              # espa�o para a string digitada pelo usu�rio
    diff: .byte 32                  # diferen�a entre 'a' e 'A'

.text
.globl main
main:
    # Imprimir prompt para o usu�rio
    la    $a0, prompt              # endere�o da mensagem de prompt
    li    $v0, 4                   # syscall para imprimir string
    syscall

    # Ler string do usu�rio
    la    $a0, buffer              # endere�o do buffer
    li    $a1, 256                 # tamanho m�ximo do buffer
    li    $v0, 8                   # syscall para ler string
    syscall

    # Chamar fun��o para converter a string para min�sculo
    la    $a0, buffer              # passar o endere�o do buffer para $a0
    jal   string_to_lowercase      # chama a fun��o para converter a string

    # Imprimir string convertida
    la    $a0, buffer              # endere�o do buffer
    li    $v0, 4                   # syscall para imprimir string
    syscall

    # Sair do programa
    li    $v0, 10                  # syscall para sair
    syscall

# Fun��o para converter a string para min�sculo
string_to_lowercase:
    lb    $t1, diff                # carrega a diferen�a ('a' - 'A') em $t1

loop:
    lb    $t0, 0($a0)              # carrega o caractere atual da string em $t0
    beq   $t0, $zero, end          # se o caractere for '\0', termina o loop

    li    $t2, 'A'                 # carrega 'A' em $t2
    li    $t3, 'Z'                 # carrega 'Z' em $t3
    blt   $t0, $t2, next_char      # se $t0 < 'A', v� para o pr�ximo caractere
    bgt   $t0, $t3, next_char      # se $t0 > 'Z', v� para o pr�ximo caractere

    add   $t0, $t0, $t1            # converte para min�sculo adicionando a diferen�a
    sb    $t0, 0($a0)              # armazena o caractere convertido de volta na string

next_char:
    addi  $a0, $a0, 1              # incrementa o ponteiro da string
    j     loop                     # salta para o in�cio do loop

end:
    jr    $ra                      # retorna do procedimento

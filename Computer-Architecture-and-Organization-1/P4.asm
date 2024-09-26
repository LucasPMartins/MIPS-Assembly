.data
angulo:     .float
radianos:   .float
termo:      .float
resultado:  .float
precisao:   .float 0.00001

mensagem_angulo: .asciiz "Digite o angulo em graus: "

zero: .float 0.0
num180: .float 180.0
PI: .float 3.141592
num2: .float 2.0
num1negative: .float -1.0
num1: .float 1.0

.text
.globl main

main:
    # Exibe uma mensagem para digitar o ângulo em graus
    li $v0, 4
    la $a0, mensagem_angulo
    syscall

    # Lê o ângulo em graus
    li $v0, 6
    syscall
    lwc1 $f4, zero      # Carregar o valor zero em $f4
    add.s $f12,$f0,$f4  # $f12 = 'angulo'


    # Converte o ângulo de graus para radianos
    lwc1 $f3, num180
    div.s $f12, $f12, $f3
    lwc1 $f3, PI
    mul.s $f12, $f12, $f3 # $f2 armazena o grau em RAD. *PI


    # INICIALIZA termo e resultado com o primeiro termo da série (x)
    
    lwc1 $f2, num1 # $f2 é meu termo
    lwc1 $f3, num1  # $f3 é meu resultado
    
    mul.s $f1, $f12, $f12   # Calcular o QUADRADO de radianos
    lwc1 $f10, num1negative # -1.0 para alternar entre (+,-)
    
    mul.s $f1, $f1, $f10   # Calcula: -1 * RAD²
    
    lwc1 $f5, num2  # K = 2
    lwc1 $f11, num2 # num2 = $f11
    lwc1 $f13, num1 # num1 
    
loop:

    # calculo para meu DENONIMADOR, denom = $f4
    mov.s $f7, $f5
    sub.s $f7, $f7, $f13 # k - 1
    mul.s $f4, $f5, $f7 # (k * (k - 1))
    
    div.s $f4, $f1, $f4 # (-1) * x * x / (k * (k - 1));
    mul.s $f2, $f2, $f4 # termo = (-1)*termo * x * x / (k * (k - 1));
    
    # Adiciona o próximo termo ao resultado
    add.s $f3, $f3, $f2 # resultado += termo
    add.s $f5, $f5,$f11  # k+=2;
    
    #condiçao de parada
    
    abs.s $f7, $f2  # $f7 = abs($f2)
    
    lwc1 $f8, precisao
    c.lt.s $f7, $f8
    bc1t fim_loop
    
    # Repete o loop
    j loop
 
   
fim_loop:
    # Exibe o resultado (cosseno do ângulo)
    li $v0, 2
    mov.s $f12, $f3
    syscall

    # Encerra o programa
    li $v0, 10
    syscall

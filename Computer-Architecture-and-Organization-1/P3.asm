.data
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
    mov.s $f2, $f12 # $f2 é meu termo
    mov.s $f3, $f12  # $f3 é meu resultado
    
    mul.s $f1, $f12, $f12   # Calcular o QUADRADO de radianos
    lwc1 $f10, num1negative # -1.0 para alternar entre (+,-)
    mul.s $f1, $f1, $f10   # Calcula: -1 * RAD²
    
    lwc1 $f5, num1  # K = 1
    lwc1 $f11, num1
    
loop:

    # calculo para meu DENONIMADOR, denom = $f4
    lwc1 $f4, num2 # Meu DENOMINADOR
    mul.s $f4,$f4,$f5 # (2 * k)
    lwc1 $f7, num2 # Constante 2
    
    lwc1 $f7,num1 #Constante 1
    add.s $f7, $f5, $f7 # k + 1
    
    lwc1 $f8, num2 # Constante 2
    mul.s $f7, $f7, $f8    
    
    mul.s $f4, $f4, $f7 # (2*K) * (2*(K+1))
     
    # Adiciona o próximo termo ao resultado
    div.s $f6, $f1, $f4 # -1.0 * radianos * radianos / ((2 * k) * (2 * k + 1));
    mul.s $f2, $f2, $f6 # termo *= $f6
    
    add.s $f3, $f3, $f2 # resultado += termo
    add.s $f5, $f5,$f11  # k++;
    
    #condiçao de parada
    
    abs.s $f7, $f2  # $f7 = abs($f2)
    
    lwc1 $f8, precisao
    c.lt.s $f7, $f8
    bc1t fim_loop
    
    # Repete o loop
    j loop
 
   
fim_loop:
    # Exibe o resultado (seno do ângulo)
    li $v0, 2
    mov.s $f12, $f3
    syscall

    # Encerra o programa
    li $v0, 10
    syscall

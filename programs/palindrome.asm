; esse programa lê a entrada do teclado e imprime se é palíndrome ou não

imprimir_caractere macro caractere              ; macro para imprimir um caractere
                         mov dl, caractere      ; carrega o caractere no registrador dl
                         mov ah, 02h            ; define o modo de saída de dados como "write character"
                         int 21h                ; executa a interrupção para imprimir o caractere
endm

imprimir_mensagem macro mensagem              ; macro para imprimir uma mensagem
                        lea dx, mensagem      ; carrega o endereço da mensagem no registrador dx
                        mov ah, 09h           ; define o modo de saída de dados como "write string"
                        int 21h               ; executa a interrupção para imprimir a mensagem
endm

.model small
.stack 100h
.data                                                                          ; segmento de dados
      mensagem_digite_palavra_frase db "Digite uma palavra ou frase: $"
      mensagem_nao_palindrome       db "Nao eh palindrome", 0dh, 0ah, "$"
      mensagem_palindrome           db "Eh palindrome", 0dh, 0ah, "$"
      entrada                       db 30, ?, 30 dup (?)                       ; buffer de 30 bytes para a entrada
.code
      inicio:              
      ; define o segmento de dados
                           mov                ax, @data
                           mov                ds, ax

      ; imprime a mensagem na tela usando o macro "imprimir_mensagem"
                           imprimir_mensagem  mensagem_digite_palavra_frase

      ; lê a entrada do teclado
                           lea                dx, entrada                        ; carrega o endereço do buffer no registrador dx
                           mov                ah, 0ah                            ; define o modo de entrada de dados como "read string"
                           int                21h                                ; executa a interrupção para ler a entrada

      ; imprime uma nova linha (\r\n)
                           imprimir_caractere 0dh                                ; imprime o caractere de retorno de carro (CR - carriage return - \r)
                           imprimir_caractere 0ah                                ; imprime o caractere de nova linha (LF - line feed - \n)

                           lea                bx, entrada                        ; carrega o endereço do buffer no registrador bx
                           inc                bx                                 ; bx aponta para o tamanho da string
                           mov                cl, [bx]                           ; carrega o tamanho da string no registrador dl
      ; di aponta para o último caractere da string
                           mov                di, bx
                           add                di, cx

                           inc                bx                                 ; bx aponta para o primeiro caractere da string

      ; verifica se a string é um palíndrome
      verificar_palindrome:
                           mov                al, [bx]                           ; carrega o caractere bx no registrador al
                           cmp                al, [di]                           ; compara com o caractere de posição oposta em di
                           jne                nao_palindrome                     ; se forem diferentes, não é um palíndrome
                           inc                bx                                 ; incrementa bx para apontar para o próximo caractere
                           dec                di                                 ; decrementa di para apontar para o caractere de posição oposta
                           sub                cl, 2                              ; decrementa o tamanho da string em 2, uma vez que dois caracteres foram comparados
                           cmp                cl, 0                              ; compara o tamanho da string com 0
                           jg                 verificar_palindrome               ; se for maior que 0, continua a verificação
                           imprimir_mensagem  mensagem_palindrome                ; se for igual ou menor que 0 e o jump para nao_palindrome não foi feito, é um palíndrome
                           jmp                fim                                ; termina o programa

      ; imprime a mensagem de não palíndrome e termina o programa
      nao_palindrome:      
                           imprimir_mensagem  mensagem_nao_palindrome

      ; termina o programa com código de saída 0 (sucesso)
      fim:                 
                           mov                ax, 4c00h                          ; carrega o código de saída 0 (sucesso) no registrador ax
                           int                21h                                ; executa a interrupção para terminar o programa
end inicio

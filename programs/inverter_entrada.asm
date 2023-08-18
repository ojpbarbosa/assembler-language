; este programa lê uma string de 20 caracteres do teclado e a imprime invertida

imprimir_caractere macro caractere              ; macro para imprimir um caractere
                         mov ah, 02h            ; define o modo de saída de dados como "write character"
                         mov dl, caractere      ; define o caractere a ser impresso
                         int 21h                ; executa a função de saída de dados
endm

imprimir_mensagem macro mensagem                     ; macro para imprimir uma mensagem
                        mov ah, 09h                  ; define o modo de saída de dados como "write string"
                        mov dx, offset mensagem      ; define o endereço de memória onde a string está armazenada
                        int 21h                      ; executa a função de saída de dados
endm

nova_linha macro                  ; macro para imprimir uma nova linha
                 mov ah, 02h      ; define o modo de saída de dados como "write character"
                 mov dl, 0dh      ; define o caractere como "carriage return" (CR - \r)
                 int 21h          ; executa a função de saída de dados
                 mov ah, 02h      ; define o modo de saída de dados como "write character"
                 mov dl, 0ah      ; define o caractere como "line feed" (LF - \n)
                 int 21h          ; executa a função de saída de dados
endm

.model small
.stack 100h
.data                                                                      ; segmento de dados
      digite_mensagem    db "Digite uma mensagem de 20 caracteres: $"
      mensagem_digitada  db "Mensagem digitada: $"
      mensagem_invertida db "Mensagem invertida: $"
      entrada            db 21 dup("$")                                    ; 20 caracteres + 1 byte para o tamanho da string
.code
      start:             
                         mov                ax, @data               ; define o segmento de dados
                         mov                ds, ax                  ; define o segmento de dados como o segmento de dados padrão

                         imprimir_mensagem  digite_mensagem         ; imprime a mensagem usando o macro "imprimir_mensagem"

      ; lê a entrada do teclado
                         mov                ah, 0ah                 ; define o modo de entrada de dados como "read string"
                         mov                dx, offset entrada      ; define o endereço de memória onde a string será armazenada
                         int                21h                     ; executa a função de entrada de dados

                         nova_linha                                 ; imprime uma nova linha usando o macro "nova_linha"

      ; imprime a entrada do teclado
                         mov                bx, offset entrada      ; define o endereço de memória onde a string está armazenada
                         inc                bx                      ; incrementa o endereço de memória para apontar para o primeiro caractere da string
                         mov                cl, [bx]                ; define o tamanho da string
                         inc                bx                      ; incrementa o endereço de memória para apontar para o primeiro caractere da string

                         imprimir_mensagem  mensagem_digitada       ; imprime a mensagem usando o macro "imprimir_mensagem"
      imprimir_entrada:  
                         imprimir_caractere [bx]                    ; imprime o caractere usando o macro "imprimir_caractere"
                         inc                bx                      ; incrementa bx para apontar para o próximo caractere da string
                         dec                cl                      ; decrementa cl para indicar que um caractere foi impresso
                         jne                imprimir_entrada        ; se cl for diferente de zero, imprime o próximo caractere

                         nova_linha                                 ; imprime uma nova linha usando o macro "nova_linha"

                         imprimir_mensagem  mensagem_invertida      ; imprime a mensagem usando o macro "imprimir_mensagem"

                         mov                bx, offset entrada      ; define o endereço de memória onde a string está armazenada
                         inc                bx                      ; incrementa o endereço de memória para apontar para o primeiro caractere da string
                         mov                cl, [bx]                ; define o tamanho da string
                         add                bx, cx                  ; define o endereço de memória para apontar para o último caractere da string
      imprimir_invertida:
                         imprimir_caractere [bx]                    ; imprime o caractere usando o macro "imprimir_caractere"
                         dec                bx                      ; decrementa bx para apontar para o caractere anterior da string
                         dec                cl                      ; decrementa cl para indicar que um caractere foi impresso
                         jne                imprimir_invertida      ; se cl for diferente de zero, imprime o próximo caractere
      terminar:          
                         mov                ah, 4ch                 ; define o modo como "terminate program"
                         int                21h                     ; termina o programa

end start

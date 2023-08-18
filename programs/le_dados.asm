; esse programa lê dados do teclado e os imprime na tela

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
.data                                                       ; segmento de dados
      mensagem_digite_dados    db "Digite dados: $"
      mensagem_dados_digitados db "Dados digitados: $"
      dados                    db 30, ?, 30 dup (?)         ; buffer de 30 bytes para os dados
.code
      inicio:          
      ; define o segmento de dados
                       mov                ax, @data
                       mov                ds, ax

      ; imprime a mensagem na tela usando o macro "imprimir_mensagem"
                       imprimir_mensagem  mensagem_digite_dados

      ; lê os dados do teclado
                       lea                dx, dados                     ; carrega o endereço do buffer no registrador dx
                       mov                ah, 0ah                       ; define o modo de entrada de dados como "read string"
                       int                21h                           ; executa a interrupção para ler os dados

      ; imprime uma nova linha (\r\n)
                       imprimir_caractere 0dh                           ; imprime o caractere de retorno de carro (CR - carriage return - \r)
                       imprimir_caractere 0ah                           ; imprime o caractere de nova linha (LF - line feed - \n)

      ; imprime a mensagem na tela usando o macro "imprimir_mensagem"
                       imprimir_mensagem  mensagem_dados_digitados

      ; imprime a entrada do teclado
                       lea                bx, dados                     ; carrega o endereço da string no registrador bx
                       inc                bx                            ; incrementa o endereço de memória para apontar para o primeiro caractere da string
                       mov                cl, [bx]                      ; carrega o tamanho da string no registrador cl
                       inc                bx                            ; incrementa o endereço de memória para apontar para o primeiro caractere da string

      ; imprime os dados digitados na tela
      imprimir_entrada:
                       imprimir_caractere [bx]                          ; imprime o caractere apontado por bx usando o macro "imprimir_caractere"
                       inc                bx                            ; incrementa bx para apontar para o próximo caractere da string
                       dec                cl                            ; decrementa cl para indicar que um caractere foi impresso
                       jne                imprimir_entrada              ; se cl for diferente de zero, imprime o próximo caractere

      ; termina o programa com código de saída 0 (sucesso)
      fim:             
                       mov                ax, 4c00h                     ; carrega o código de saída 0 (sucesso) no registrador ax
                       int                21h                           ; executa a interrupção para terminar o programa
end inicio

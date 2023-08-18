; esse programa lê a entrada de um nome e imprime o número de vogais e consoantes do mesmo

imprimir_mensagem macro mensagem              ; macro para imprimir uma mensagem
                        lea dx, mensagem      ; carrega o endereço da mensagem no registrador dx
                        mov ah, 09h           ; define o modo de saída de dados como "write string"
                        int 21h               ; executa a interrupção para imprimir a mensagem
endm

.model small
.stack 100h
.data                                                                                                                                     ; segmento de dados
      mensagem_digite_nome db "Digite seu nome: $"
      mensagem_vogais      db 'Vogais: ', '$'
      mensagem_consoantes  db 'Consoantes: ', '$'
      moldura              db '********************', 7 dup(0dh, 0ah, '*                  *'), 0dh, 0ah, '********************', '$'      ; moldura para a saída
      entrada              db 60, ?, 60 dup (?)                                                                                           ; buffer de 60 bytes para a entrada
      numero_em_decimal    db 8 dup('$')                                                                                                  ; buffer de 8 bytes para o número
      nova_linha           db 0dh, 0ah, '$'                                                                                               ; string para pular uma linha
.code
para_maiuscula proc                                                                    ; procedimento para converter uma string para maiúscula
                                   push              bp                                ; salva o valor do registrador bp na pilha
                                   mov               bp, sp                            ; carrega o valor do registrador sp no registrador bp

                                   mov               si, [bp+4]                        ; carrega o endereço da string no registrador si
                                   lea               di, entrada                       ; carrega o endereço do buffer no registrador di
                                   mov               cx, 0                             ; contador de caracteres

      loop_maiuscula:              
                                   mov               al, [si]                          ; carrega o caractere atual no registrador al
                                   cmp               al, 0                             ; compara o caractere atual com 0
                                   je                fim_loop                          ; se o caractere atual for igual a 0 (terminador de string), pula para o label "fim_loop"

                                   cmp               al, 'a'                           ; compara o caractere atual com 'a'
                                   jb                pular_maiuscula                   ; se o caractere atual for menor que 'a', pula para o label "pular_maiuscula"
                                   cmp               al, 'z'                           ; compara o caractere atual com 'z'
                                   ja                pular_maiuscula                   ; se o caractere atual for maior que 'z', pula para o label "pular_maiuscula"
                                   sub               al, 32                            ; subtrai 32 do caractere atual para convertê-lo para maiúscula

      pular_maiuscula:             
                                   mov               [di], al                          ; carrega o caractere atual no endereço apontado por di
                                   inc               si                                ; incrementa o endereço de memória para apontar para o próximo caractere da string
                                   inc               di                                ; incrementa o endereço de memória para apontar para o próximo caractere da string
                                   inc               cx                                ; incrementa o contador de caracteres
                                   jmp               loop_maiuscula                    ; pula para o label "loop_maiuscula"

      fim_loop:                    
                                   mov               di, 0                             ; carrega 0 no registrador di
                                   mov               ax, cx                            ; carrega o valor do contador de caracteres no registrador ax
                                   pop               bp
                                   ret
para_maiuscula endp

hexadecimal_para_string proc                                                           ; procedimento para converter um número hexadecimal para string
                                   push              si                                ; salva o valor do registrador si na pilha

                                   mov               bx, 10                            ; carrega 10 como divisor no registrador bx
                                   mov               cx, 0                             ; zera o contador de dígitos

      loop_hexadecimal_para_string:
                                   mov               dx, 0                             ; zera o registrador dx como parte alta do dividendo
                                   div               bx                                ; divide o valor no registrador ax pelo valor no registrador bx

                                   push              dx                                ; empilha o resto da divisão

                                   inc               cx                                ; incrementa o contador de dígitos
                                   cmp               ax, 0                             ; compara o valor no registrador ax com 0

                                   jne               loop_hexadecimal_para_string      ; se o valor no registrador ax for diferente de 0, pula para o label "loop_hexadecimal_para_string"

                                   lea               si, numero_em_decimal             ; carrega o endereço do buffer no registrador di

      loop_string:                                                                     ; loop para converter os dígitos empilhados para string
                                   pop               dx                                ; desempilha o dígito
                                   add               dl, '0'                           ; adiciona '0' ao dígito para convertê-lo para caractere
                                   mov               [si], dl                          ; carrega o caractere no endereço apontado por si
                                   inc               si                                ; incrementa o endereço de memória para apontar para o próximo caractere da string
                                   loop              loop_string                       ; decrementa o contador de dígitos e pula para o label "loop_string" se o contador for diferente de 0

                                   pop               si                                ; desempilha o valor do registrador si
                                   ret                                                 ; retorna para a rotina que chamou o procedimento
hexadecimal_para_string endp

      inicio:                      
      ; define o segmento de dados
                                   mov               ax, @data
                                   mov               ds, ax

      ; imprime a mensagem na tela usando o macro "imprimir_mensagem"
                                   imprimir_mensagem mensagem_digite_nome

      ; lê a entrada do teclado
                                   lea               dx, entrada                       ; carrega o endereço do buffer no registrador dx
                                   mov               ah, 0ah                           ; define o modo de entrada de dados como "read string"
                                   int               21h                               ; executa a interrupção para ler a entrada

                                   lea               dx, entrada                       ; carrega o endereço da string no registrador dx
                                   push              dx                                ; empilha o endereço da string
                                   call              para_maiuscula                    ; chama a função para converter a string para maiúscula

                                   lea               bx, entrada                       ; carrega o endereço do buffer no registrador bx
                                   inc               bx                                ; incrementa o registrador bx para apontar para o tamanho da string
                                   mov               cl, [bx]                          ; carrega o tamanho da string no registrador cl

                                   mov               si, 0                             ; zera o contador de mensagem_vogais
                                   mov               di, 0                             ; zera o contador de mensagem_consoantes

      contar_letras:               
                                   cmp               cx, 0                             ; compara o tamanho da string com 0
                                   je                imprimir_moldura                  ; se o tamanho da string for igual a 0, pula para o label "fim"

                                   inc               bx                                ; incrementa o registrador bx para apontar para o próximo caractere da string
                                   mov               al, [bx]                          ; carrega o caractere atual no registrador al

                                   cmp               al, 'A'                           ; compara o caractere atual com 'A'
                                   je                contar_vogal                      ; se o caractere atual for igual ao 'A', pula para o label "contar_vogal"

                                   cmp               al, 'E'                           ; compara o caractere atual com 'E'
                                   je                contar_vogal                      ; se o caractere atual for igual ao 'E', pula para o label "contar_vogal"

                                   cmp               al, 'I'                           ; compara o caractere atual com 'I'
                                   je                contar_vogal                      ; se o caractere atual for igual ao 'I', pula para o label "contar_vogal"

                                   cmp               al, 'O'                           ; compara o caractere atual com 'O'
                                   je                contar_vogal                      ; se o caractere atual for igual ao 'O', pula para o label "contar_vogal"

                                   cmp               al, 'U'                           ; compara o caractere atual com 'U'
                                   je                contar_vogal                      ; se o caractere atual for igual ao 'U', pula para o label "contar_vogal"

                                   inc               di                                ; incrementa o contador de mensagem_consoantes

                                   dec               cx                                ; decrementa o tamanho do loop
                                   jmp               contar_letras                     ; repete o loop

      contar_vogal:                
                                   inc               si                                ; incrementa o contador de mensagem_vogais
                                   dec               cx                                ; decrementa o contador do loop
                                   jmp               contar_letras                     ; repete o loop

      imprimir_moldura:            
      ; imprime duas novas linhas (\r\n)
                                   imprimir_mensagem nova_linha
                                   imprimir_mensagem nova_linha

                                   push              di                                ; empilha o contador de mensagem_consoantes
                                   push              si                                ; empilha o contador de mensagem_vogais

                                   mov               di, 0                             ; define a posição inicial da moldura
                                   imprimir_mensagem moldura                           ; imprime a moldura

                                   mov               ah, 03h                           ; define o modo para obter a posição do cursor
                                   int               10h                               ; executa a interrupção para obter a posição do cursor

                                   mov               ah, 02h                           ; define o modo para posicionar o cursor
                                   mov               bh, 0                             ; define a página de vídeo como 0
                                   sub               dl, 14                            ; retrocede 14 colunas da posição atual do cursor
                                   sub               dh, 5                             ; retrocede 5 linhas da posição atual do cursor
                                   int               10h                               ; executa a interrupção para posicionar o cursor

                                   imprimir_mensagem mensagem_vogais                   ; imprime a mensagem "Vogais: "

                                   pop               ax                                ; desempilha o contador de vogais
                                   call              hexadecimal_para_string           ; chama o procedimento para converter o valor no registrador ax para string
                                   imprimir_mensagem numero_em_decimal                 ; imprime o valor no registrador ax como string

                                   mov               ah, 03h                           ; define o modo para obter a posição do cursor
                                   int               10h                               ; executa a interrupção para obter a posição do cursor

                                   mov               ah, 02h                           ; define o modo para posicionar o cursor
                                   mov               bh, 0                             ; define a página de vídeo como 0
                                   sub               dl, 11                            ; retrocede 11 colunas da posição atual do cursor
                                   add               dh, 2                             ; avança 2 linha da posição atual do cursor
                                   int               10h                               ; executa a interrupção para posicionar o cursor

                                   imprimir_mensagem mensagem_consoantes               ; imprime a mensagem "Consoantes: "

                                   pop               ax                                ; desempilha o contador de consoantes
                                   call              hexadecimal_para_string           ; chama o procedimento para converter o valor no registrador ax para string
                                   imprimir_mensagem numero_em_decimal                 ; imprime o valor no registrador ax como string

                                   mov               ah, 03h                           ; define o modo para obter a posição do cursor
                                   int               10h                               ; executa a interrupção para obter a posição do cursor

                                   mov               ah, 02h                           ; define o modo para posicionar o cursor
                                   mov               bh, 0                             ; define a página de vídeo como 0
                                   mov               dl, 0                             ; define a coluna como 0
                                   add               dh, 4                             ; avança 4 linhas da posição atual do cursor
                                   int               10h                               ; executa a interrupção para posicionar o cursor


      ; * crasha o programa
      ; bipar:
      ;                              mov               ah, 02h                       ; define o modo para imprimir um caractere
      ;                              mov               dl, 07h                       ; define o caractere como 07h (bel - bell - campainha)
      ;                              int               21h                           ; executa a interrupção para imprimir um caractere

      ; termina o programa com código de saída 0 (sucesso)
      fim:                         
                                   mov               ax, 4c00h                         ; carrega o código de saída 0 (sucesso) no registrador ax
                                   int               21h                               ; executa a interrupção para terminar o programa
end inicio

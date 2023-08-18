; esse programa ordena (bubble sort) um vetor de bytes

.model small
.stack 100h
.data
      vetor                   db  'l', 'k', 'j', 'i', 'h', 'g', 'f', 'e', 'd', 'c', 'b', 'a'      ; vetor a ser ordenado
      tamanho                 equ $-vetor                                                         ; tamanho do vetor
      mensagem_vetor_original db  'Vetor original: $'                                             ; mensagem de vetor original
      mensagem_vetor_ordenado db  0dh, 0ah, 'Vetor ordenado: $'                                   ; mensagem de vetor ordenado
.code
      ; procedimento para printar o vetor de bytes na tela
printar_vetor proc
      ; printa o vetor ordenado
                         mov  cx, tamanho                      ; carrega o tamanho do vetor em cx

      ; loop para printar o vetor
      printar_vetor_loop:
                         mov  dl, [bx]                         ; carrega o elemento atual do vetor em dl
                         mov  ah, 02h                          ; define a função de printar caractere
                         int  21h                              ; executa a função

                         mov  dl, ' '                          ; carrega um espaço em dl
                         mov  ah, 02h                          ; define a função de printar caractere
                         int  21h                              ; executa a função

                         inc  bx                               ; incrementa o endereço do vetor para apontar para o próximo elemento
                         loop printar_vetor_loop               ; repete até que cx seja igual a zero, ou seja, até que todos os elementos do vetor tenham sido printados

                         ret
printar_vetor endp

      ; procedimento de ordenação do vetor de bytes com algoritmo de ordenação bubble sort
      ; recebe o endereço do vetor em bx e o tamanho do vetor em dx
ordernar proc
      ; loop externo (devagar) para ordenar o vetor, redefine o vetor em si e seu tamanho em cx a cada iteração
      loop_externo:      
                         lea  si, [bx]                         ; carrega o endereço do vetor em si
                         mov  cx, dx                           ; carrega o tamanho do vetor em cx

      ; loop interno para ordenar o vetor
      rapido:            
                         mov  al, [si]                         ; carrega o elemento atual do vetor em al
                         cmp  al, [si + 1]                     ; compara o elemento atual com o próximo elemento
                         jc   proximo_elemento                 ; se o elemento atual for menor que o próximo elemento, pula para o próximo elemento
      ; troca o elemento atual com o próximo elemento
                         xchg al, [si + 1]
                         xchg al, [si]

      proximo_elemento:  
                         inc  si                               ; incrementa o endereço do vetor para apontar para o próximo elemento
                         loop rapido                           ; repete até que cx seja igual a zero, ou seja, até que todos os elementos do vetor tenham sido comparados
                         dec  dx                               ; decrementa o tamanho do vetor
                         jnz  loop_externo                     ; se o tamanho do vetor for diferente de zero, pula para o loop externo

                         mov  ah, 09h                          ; define a função de printar string
                         lea  dx, mensagem_vetor_ordenado      ; carrega o endereço da mensagem de vetor ordenado
                         int  21h                              ; executa a função

                         lea  bx, [si]                         ; carrega o endereço do vetor em bx
                         call printar_vetor                    ; chama o procedimento de printar o vetor

                         ret
ordernar endp

      start:             
                         mov  ax, @data                        ; inicializa e define o segmento de dados
                         mov  ds, ax

                         mov  ah, 09h                          ; define a função de printar string
                         lea  dx, mensagem_vetor_original      ; carrega o endereço da mensagem de vetor original
                         int  21h                              ; executa a função

                         lea  bx, vetor                        ; carrega o endereço do vetor em bx
                         call printar_vetor                    ; chama o procedimento de printar o vetor

                         lea  bx, vetor                        ; carrega o endereço do vetor
                         mov  dx, tamanho                      ; carrega o tamanho do vetor
                         call ordernar                         ; chama a função de ordenação

                         mov  ax, 4c00h                        ; termina o programa com código de erro 0
                         int  21h                              ; executa a função
end start

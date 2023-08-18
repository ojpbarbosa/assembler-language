; this program makes use of label to jump to a specific point in the code

.model small                                        ; set model to small
.stack 100h                                         ; set stack size to 100h
.data                                            ; set data segment
      message     db "Message", 13, 10, '$'
      message_two dw "T", "W", "O", "!"
.code
      start:     
                 mov ax, @data
                 mov ds, ax
                 mov ah, 9
                 mov dx, offset message
                 int 21h

                 mov ah, 02h                     ; set ah to 02h (read character)
                 mov dl, 'R'                     ; set dl to 'R'
                 int 21h                         ; call DOS interrupt

                 mov bx, offset message          ; load effective address of message into bx

                 mov cl, 4                       ; set cl to 4 (length of message)

      print_byte:
                 mov dl, [bx]                    ; set dl to message
                 mov ah, 02h                     ; set ah to 02h (read character)
                 int 21h                         ; call DOS interrupt
                 inc bx                          ; increment bx
                 dec cl                          ; decrement cl
                 jnz print_byte                  ; jump to print_byte if cl is not zero

                 mov cl, 4
                 mov bx, offset message_two

      print_word:
                 mov dx, word ptr [bx]           ; set dx to word pointer of message_two
                 mov ah, 02h                     ; set ah to 02h (read character)
                 int 21h                         ; call DOS interrupt]
                 add bx, 2                       ; increment bx by 2, since message_two is a word (2 bytes)
                 dec cl                          ; decrement cl
                 jnz print_word                  ; jump to print_byte if cl is not zero


end start

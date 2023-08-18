; this program reads the input, stores it in memory and then prints it
.model small                                        ; set model to small
.stack 100h                                         ; set stack size to 100h
.data                               ; set data segment
      message  db "Type in: $"
      key_data db 21 dup("$")       ; reserve 21 bytes for key_data
.code
      start:      
                  mov ax, @data
                  mov ds, ax
                  mov ah, 9
                  mov dx, offset message
                  int 21h

                  mov ah, 0ah                  ; set ah to 0ah (read keyboard)
                  mov dx, offset key_data      ; set dx to offset of key_data
                  int 21h                      ; call DOS interrupt

      ; print two new lines
                  mov dl, 0dh
                  mov ah, 02h
                  int 21h
                  mov dl, 0Ah
                  mov ah, 02h
                  int 21h
                  mov dl, 0Ah
                  mov ah, 02h
                  int 21h

                  mov bx, offset key_data      ; set bx to offset of key_data
                  inc bx
                  mov cl, [bx]                 ; set cl to length of key_data
                  inc bx

      print_input:
                  mov dl, [bx]                 ; set dl to character in key_data
                  mov ah, 02h                  ; set ah to 2 (write character)
                  int 21h                      ; call DOS interrupt
                  inc bx                       ; increment bx
                  dec cl                       ; decrement cl
                  jne print_input              ; loop until cl is 0
                  mov ax, 4c01h                ; set ax to 4ch (exit)
                  int 21h                      ; call DOS interrupt

end start

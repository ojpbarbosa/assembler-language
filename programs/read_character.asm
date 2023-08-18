; this program reads a character from the keyboard and prints it

.model small
.stack 100h
.data                                                   ; data segment
      type_in_message  db "Type in a character: $"
      typed_in_message db "Typed in character: $"
      character        db 30, ?, 30 dup (?)
.code
main proc
      ; set the data segment
           mov ax, @data
           mov ds, ax

      ; print the message on the screen
           lea dx, type_in_message       ; load the address of the message to print
           mov ah, 09h                   ; set the function code to "print string"
           int 21h                       ; execute the function

      ; read the input character from the keyboard
           mov ah, 01h                   ; set the function code to "read character from keyboard"
           int 21h                       ; read the input from the keyboard
           mov character, al             ; store the input character in the variable

      ; print a new line
           mov dl, 0dh                   ; load the address of the new line character
           mov ah, 02h                   ; set the function code to "write character on screen"
           int 21h                       ; execute the function
           mov dl, 0ah                   ; load the address of the new line character
           mov ah, 02h                   ; set the function code to "write character on screen"
           int 21h                       ; execute the function

      ; print the message on the screen
           lea dx, typed_in_message      ; load the address of the message to print
           mov ah, 09h                   ; set the function code to "print string"
           int 21h                       ; execute the function

      ; write the input character on the screen
           mov dl, character             ; load the address of the input character
           mov ah, 02h                   ; set the function code to "write character on screen"
           int 21h                       ; execute the function
      _end:
           mov ax, 4c01h                 ; set the function code to "terminate program" with return code 1
           int 21h                       ; execute the function
main endp
end main

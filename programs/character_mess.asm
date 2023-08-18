; this program reads a character from the keyboard and prints if it is greater or lower than 'm'

.model small
.stack 100h
.data                                                                ; data segment
      type_in_message        db "Type in a character: $"
      greater_than_m_message db "Character is greater than 'm'"
      lower_than_m_message   db "Character is lower than 'm'"
      character              db 0
.code
main proc
      ; set the data segment
                     mov ax, @data
                     mov ds, ax

      ; print the message on the screen
                     lea dx, type_in_message             ; load the address of the message to print
                     mov ah, 09h                         ; set the function code to "print string"
                     int 21h                             ; execute the function

      ; read the input character from the keyboard
                     mov ah, 01h                         ; set the function code to "read character from keyboard"
                     int 21h                             ; read the input from the keyboard
                     mov character, al                   ; store the input character in the variable

      ; print a new line
                     mov dl, 0dh                         ; load the address of the new line character
                     mov ah, 02h                         ; set the function code to "write character on screen"
                     int 21h                             ; execute the function
                     mov dl, 0ah                         ; load the address of the new line character
                     mov ah, 02h                         ; set the function code to "write character on screen"
                     int 21h                             ; execute the function

                     cmp character, 'm'                  ; compare the input character with the letter 'm'
                     ja  greater_than_m                  ; if the input character is greater than 'm' jump to the label greater_than_m
                     lea dx, lower_than_m_message        ; load the address of the message to print
                     jmp write_message                   ; jump to the label write_message

      greater_than_m:
                     lea dx, greater_than_m_message      ; load the address of the message to print

      write_message: 
                     mov ah, 09h                         ; set the function code to "print string"
                     int 21h                             ; execute the function
      _end:          
                     mov ax, 4c01h                       ; set the function code to "terminate program" with return code 1
                     int 21h                             ; execute the function
main endp
end main

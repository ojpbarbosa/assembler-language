; this program makes use of the conditional jump instruction (je)
; to print a "Inside if" if al register is equal to 10
; the program will print "Simple if" and "End of program"
.model small                                        ; set model to small
.stack 100h                                         ; set stack size to 100h
.data                                                         ; set data segment
      simple_if_message db "Simple if", 13, 10, '$'
      inside_if_message db "Inside if", 13, 10, '$'
      end_message       db "End of program", 13, 10, '$'
.code
      start:
            mov ax, @data
            mov ds, ax
            mov ah, 9
            mov dx, offset simple_if_message
            int 21h

            mov al, 10                            ; set al to 10
            cmp al, 10                            ; compare al to 10
            je  _end                              ; if equal, jump to _end
            mov ah, 9                             ; if not equal, print "Inside if"
            mov dx, offset inside_if_message      ; set dx to offset of inside_if_message
            int 21h                               ; call DOS interrupt

      _end:                                       ; label: end program in if (je - conditional jump)
            mov ah, 9                             ; print "End of program"
            mov dx, offset end_message            ; set dx to offset of end_message
            int 21h                               ; call DOS interrupt

            mov ax, 4c00h                         ; set ax to 4c00h (exit)
            int 21h                               ; call DOS interrupt

end start

; 8086 16-bit masm hello world
.model small
.stack 100h
.data                                              ; set data segment
      message db "Hello, world!", 13, 10, '$'
.code
      start:
            mov ax, @data
            mov ds, ax

            mov ah, 9
            mov dx, offset message
            int 21h

            mov ax, 4c00h               ; set ax to 4c00h (exit)
            int 21h                     ; call dos interruption

end start

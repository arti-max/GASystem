global _memcpy

; Memory Copy
; stack - arg
_memcpy:
   push bp
   mov bp, sp
   push ax
   push bx
   mov ax, [bp+2]
   mov bx, [bp+4]
   mov [bx], [ax]
   pop bx
   pop ax
   pop bp
   mov sp, bp
   ret

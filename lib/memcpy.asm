global _memcpy

; Memory Copy
; stack - arg
; (dest, src, count)
_memcpy:
   push bp
   mov bp, sp
   push si
   push di
   push cx
   mov di, [bp+4] ; dest
   mov si, [bp+6] ; src
   mov cx, [bp+8] ; count

   cmp cx, 0
   je .done

   cld

   rep movsb

.done:
   pop si
   pop di
   pop cx
   pop bp
   ret

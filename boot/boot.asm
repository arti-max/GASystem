[org 0x7c00]
[bits 16]

start:
    cli
    xor ax, ax
    mov es, ax
    mov ds, ax
    mov ss, ax
    mov sp, 0x7c00
    sti

    ; mov si, test_msg
    ; call print
    call get_info

    ; boot [load kernel]
    mov [boot_disk], dl
    ; read 2 sector to 0x0000:0x1000
    mov ah, 2
    mov al, 1
    mov ch, 0
    mov cl, 2
    mov dh, 1
    mov dl, 0x80
    mov bx, 0x1000

    int 0x13
    jc disk_error

    jmp 0x0000:0x1000
    jmp $
    hlt

print:
    lodsb

    test al, al
    jz .done

    cmp al, 0x0a
    je .new_line
    
    mov ah, 0x0e
    int 0x10
    jmp print

.new_line:
    mov ah, 0x0e
    mov al, 0x0d    ; CR
    int 0x10

    mov al, 0x0a    ; LF
    int 0x10

    jmp print

.done:
    ret

disk_error:
    mov al, ah  ; код ошибки
    call itoa_8
    mov si, buffer
    mov di, err_msg + 18
.cpy_loop:
    lodsb               ; load byte from DS:SI to AL and INC SI
    stosb               ; store byte to ES:DI from AL and INC SI
    test al, al         ; and al, al without al = result
    jnz .cpy_loop       ; jump if not zero
    mov si, err_msg
    call print
    jmp $


get_info:
    pusha
    int 0x12
    call itoa_16
    mov si, buffer
    mov di, memory_msg+14
.cpy_loop:
    lodsb
    stosb
    test al, al
    jnz .cpy_loop

    mov si, memory_msg
    call print
    popa
    ret


; ЧИСЛО В СТРОКУ (8 бит)
; AL - число
; buffer - строка с числом
itoa_8:
    pusha
    mov di, buffer
    movzx ax, al
    mov cx, 0
    mov bl, 10
.next_digit:
    xor dx, dx
    div bx
    add dl, '0'
    push dx
    inc cx
    test ax, ax
    jnz .next_digit
.pop_digits:
    pop dx
    mov [di], dl
    inc di
    loop .pop_digits
    mov byte [di], 0
    popa
    ret

; ЧИСЛО В СТРОКУ (16 бит)
; AX - число
; buffer - строка с числом
itoa_16:
    pusha
    mov di, buffer
    mov cx, 0
    mov bx, 10
.next_digit:
    xor dx, dx
    div bx
    add dl, '0'
    push dx
    inc cx
    test ax, ax
    jnz .next_digit
.pop_digits:
    pop dx
    mov [di], dl
    inc di
    loop .pop_digits
    mov byte [di], 0
    popa
    ret

; Data:

    boot_disk: db 0
    ; test_msg: db "Hello!", 0
    memory_msg: db "Memory [KB]: ", 0x0a, 0
    err_msg: db "Disk read error: ", 0x0a, 0
    buffer: times 6 db 0

times 510 - ($-$$) db 0
dw 0xAA55

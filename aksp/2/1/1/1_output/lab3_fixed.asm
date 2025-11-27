format ELF64 executable

segment readable writeable
    arr dw 14, 26, 35, 8, 20, 6, 102, 5, 10, 45
    count = 10
    result dw 0
    output db 'Result:   ', 10  ; 2 пробела под число
    output_len = $ - output

segment readable executable
entry _start

_start:
    ; Вычисление суммы остатков
    xor r8, r8
    mov rcx, count
    mov rbx, arr
.loop:
    mov ax, [rbx]
    xor dx, dx
    mov si, 3
    div si
    movzx rdx, dx
    add r8, rdx
    add rbx, 2
    loop .loop

    mov [result], r8w

    ; Простое преобразование (для чисел 0-99)
    mov rax, r8
    mov rbx, 10
    xor rdx, rdx
    div rbx
    
    ; Всегда выводим обе цифры
    add al, '0'
    mov [output + 7], al  ; десятки
    add dl, '0'
    mov [output + 8], dl  ; единицы

    ; Вывод
    mov rax, 1
    mov rdi, 1
    mov rsi, output
    mov rdx, output_len
    syscall

    mov rax, 60
    mov rdi, r8
    syscall

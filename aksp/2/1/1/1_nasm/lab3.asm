global _start

section .data
    arr dw 1000, 65534, 3733, 8754, 7585, 2, 1022, 45, 223, 100
    count equ 10
    result dw 0

section .text

_start:
    xor r8, r8          ; r8 = сумма остатков = 0
    mov rcx, count      ; 10 элементов
    mov rbx, arr        ; указатель на массив

loop_start:
    mov ax, [rbx]       ; AX = arr[i]
    xor dx, dx          ; DX = 0 для div
    mov si, 3
    div si              ; AX/3, остаток в DX

    movzx rdx, dx       ; расширили остаток
    add r8, rdx         ; сумма += остаток   (ВНИМАНИЕ: суммируем в R8!)

    add rbx, 2
    loop loop_start

before_exit:
    mov [result], r8w   ; записать младшие 16 бит суммы

after_store:
    mov rax, 60
    xor rdi, rdi
    syscall

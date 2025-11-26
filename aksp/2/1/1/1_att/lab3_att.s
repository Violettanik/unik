# lab3_att.s - AT&T синтаксис
.globl _start

.section .data
arr:
    .word 12, 25, 33, 7, 19, 5, 100, 3, 8, 44
count = 10
result:
    .word 0

.section .text
_start:
    # r8 = сумма остатков = 0
    xorq %r8, %r8
    
    # rcx = 10 элементов
    movq $count, %rcx
    
    # rbx = указатель на массив
    movq $arr, %rbx

loop_start:
    # AX = arr[i]
    movw (%rbx), %ax
    
    # DX = 0 для div
    xorw %dx, %dx
    
    # SI = 3
    movw $3, %si
    
    # AX/3, остаток в DX
    divw %si
    
    # расширили остаток
    movzwq %dx, %rdx
    
    # сумма += остаток
    addq %rdx, %r8
    
    # следующий элемент (2 байта)
    addq $2, %rbx
    
    # цикл
    loop loop_start

    # записать младшие 16 бит суммы
    movw %r8w, result
    
    # системный вызов exit
    movq $60, %rax
    movq %r8, %rdi
    syscall

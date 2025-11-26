# cyclic_shift_att.s - AT&T синтаксис
.text
.globl cyclic_shift

cyclic_shift:
    # если n <= 1 → ничего делать не нужно
    cmpq $1, %rsi
    jbe .done

    # если k == 0 → тоже ничего не делаем
    testq %rdx, %rdx
    je .done

    # r8 = счётчик внешнего цикла
    movq %rdx, %r8

.outer_loop:
    # Одношаговый сдвиг вправо:
    # tmp = arr[n-1]
    movq %rsi, %rcx      # rcx = n
    decq %rcx            # rcx = n-1
    movq %rcx, %r9       # r9 = n-1

    # загрузить arr[n-1] в eax
    shlq $2, %rcx        # умножаем индекс на 4
    movl (%rdi,%rcx), %eax  # eax = arr[n-1], tmp

    # внутренний цикл: i = n-1 .. 1
    movq %r9, %rcx       # rcx = i = n-1

.inner_loop:
    cmpq $0, %rcx
    je .place_first      # когда дошли до i == 0, выходим

    # arr[i] = arr[i-1]
    movq %rcx, %r10
    decq %r10            # r10 = i-1

    movl (%rdi,%r10,4), %edx  # edx = arr[i-1]
    movl %edx, (%rdi,%rcx,4)  # arr[i] = arr[i-1]

    decq %rcx
    jmp .inner_loop

.place_first:
    # arr[0] = tmp (eax)
    movl %eax, (%rdi)

    # один одношаговый сдвиг сделан
    decq %r8
    jnz .outer_loop      # пока не сделано k шагов, повторяем

.done:
    ret

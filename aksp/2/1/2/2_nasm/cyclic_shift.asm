; cyclic_shift.asm
; Реализация функции:
; void cyclic_shift(int32_t *arr, uint64_t n, uint64_t k);
;
; System V AMD64 ABI (Linux x86-64):
;   rdi = arr (int32_t *)
;   rsi = n   (uint64_t)
;   rdx = k   (uint64_t, уже нормализовано в C: 0..n-1)

global cyclic_shift

section .text

cyclic_shift:
    ; если n <= 1 → ничего делать не нужно
    cmp rsi, 1
    jbe .done

    ; если k == 0 → тоже ничего не делаем
    test rdx, rdx
    jz .done

    ; r8 = счётчик внешнего цикла (кол-во одношаговых сдвигов)
    mov r8, rdx

.outer_loop:
    ; Одношаговый сдвиг вправо:
    ; tmp = arr[n-1]

    mov rcx, rsi      ; rcx = n
    dec rcx           ; rcx = n-1
    mov r9, rcx       ; r9 = n-1 (индекс для внутреннего цикла)

    ; загрузить arr[n-1] в eax
    shl rcx, 2        ; умножаем индекс на 4 (размер int32_t)
    mov eax, [rdi + rcx]   ; eax = arr[n-1], tmp

    ; внутренний цикл: i = n-1 .. 1
    mov rcx, r9       ; rcx = i = n-1

.inner_loop:
    cmp rcx, 0
    je .place_first   ; когда дошли до i == 0, выходим

    ; arr[i] = arr[i-1]
    mov r10, rcx
    dec r10           ; r10 = i-1

    mov edx, [rdi + r10*4] ; edx = arr[i-1]
    mov [rdi + rcx*4], edx ; arr[i] = arr[i-1]

    dec rcx
    jmp .inner_loop

.place_first:
    ; arr[0] = tmp (eax)
    mov [rdi], eax

    ; один одношаговый сдвиг сделан
    dec r8
    jnz .outer_loop   ; пока не сделано k шагов, повторяем

.done:
    ret

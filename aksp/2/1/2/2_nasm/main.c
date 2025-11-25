// main.c
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <inttypes.h>
#include <time.h>

// объявление ассемблерной функции
extern void cyclic_shift(int32_t *arr, uint64_t n, uint64_t k);

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Использование: %s <size>\n", argv[0]);
        fprintf(stderr, "size — размер одномерного массива (число элементов)\n");
        return 1;
    }

    char *endptr = NULL;
    long long n_ll = strtoll(argv[1], &endptr, 10);
    if (*endptr != '\0' || n_ll <= 0) {
        fprintf(stderr, "Ошибка: размер массива должен быть положительным целым числом.\n");
        return 1;
    }

    uint64_t n = (uint64_t)n_ll;

    // Ввод диапазона случайных чисел
    int32_t min_val, max_val;
    printf("Введите минимум диапазона случайных чисел (int32): ");
    if (scanf("%" SCNd32, &min_val) != 1) {
        fprintf(stderr, "Ошибка ввода минимума.\n");
        return 1;
    }

    printf("Введите максимум диапазона случайных чисел (int32): ");
    if (scanf("%" SCNd32, &max_val) != 1) {
        fprintf(stderr, "Ошибка ввода максимума.\n");
        return 1;
    }

    if (min_val > max_val) {
        fprintf(stderr, "Ошибка: минимум не может быть больше максимума.\n");
        return 1;
    }

    // Ввод величины сдвига k (может быть отрицательной)
    long long k_input;
    printf("Введите величину циклического сдвига (k, может быть отрицательной): ");
    if (scanf("%lld", &k_input) != 1) {
        fprintf(stderr, "Ошибка ввода k.\n");
        return 1;
    }

    // Выделение памяти под массив
    int32_t *arr = malloc(n * sizeof(int32_t));
    if (!arr) {
        fprintf(stderr, "Не удалось выделить память для массива.\n");
        return 1;
    }

    // Инициализация ГПСЧ и генерация массива
    srand((unsigned)time(NULL));

    uint64_t i;
    uint64_t range = (uint64_t)((uint64_t)max_val - (uint64_t)min_val + 1);
    for (i = 0; i < n; ++i) {
        // rand() -> [0, RAND_MAX], приведём к нашему диапазону
        uint64_t r = (uint64_t)rand();
        int32_t value = min_val + (int32_t)(r % range);
        arr[i] = value;
    }

    // Вывод исходного массива
    printf("\nИсходный массив:\n");
    for (i = 0; i < n; ++i) {
        printf("%" PRId32 " ", arr[i]);
    }
    printf("\n");

    // Нормализация k по модулю n
    // Сдвиг вправо на k позиций
    uint64_t k_norm;
    if (n == 0) {
        k_norm = 0;
    } else {
        long long k_mod = k_input % (long long)n;
        if (k_mod < 0) {
            k_mod += (long long)n;   // делаем положительным
        }
        k_norm = (uint64_t)k_mod;
    }

    // Вызов ассемблерной подпрограммы
    cyclic_shift(arr, n, k_norm);

    // Вывод массива после сдвига
    printf("\nМассив после циклического сдвига вправо на %" PRIu64 " позиций:\n", k_norm);
    for (i = 0; i < n; ++i) {
        printf("%" PRId32 " ", arr[i]);
    }
    printf("\n");

    free(arr);
    return 0;
}

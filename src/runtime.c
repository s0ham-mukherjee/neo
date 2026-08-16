#include <stdio.h>
#include <time.h>

#ifdef _WIN32
#include <windows.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

void println_int(int val) {
    printf("%d\n", val);
    fflush(stdout);
}

void print_int(int val) {
    printf("%d", val);
    fflush(stdout);
}

void println_str(const char* s) {
    if (s) {
        printf("%s\n", s);
    } else {
        printf("(null)\n");
    }
    fflush(stdout);
}

void print_str(const char* s) {
    if (s) {
        printf("%s", s);
    } else {
        printf("(null)");
    }
    fflush(stdout);
}

long long clock_ms() {
#ifdef _WIN32
    return GetTickCount64();
#else
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (long long)(ts.tv_sec * 1000 + ts.tv_nsec / 1000000);
#endif
}

#ifdef __cplusplus
}
#endif

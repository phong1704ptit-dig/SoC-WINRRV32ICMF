#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <stdint.h>
#include "edge-impulse-sdk/porting/ei_classifier_porting.h"
#include <regs_UART.h>

/* ================= UART LOW LEVEL ================= */

void uart_send_char(uint8_t my_char) {
    __asm volatile ("nop");
    __asm volatile ("nop");
    __asm volatile ("nop");
    __asm volatile ("nop");
    __asm volatile ("nop");
    __asm volatile ("nop");
    __asm volatile ("nop");
    UART->U_TXDATA = my_char;
    __asm volatile ("nop");
    __asm volatile ("nop");
    __asm volatile ("nop");
    __asm volatile ("nop");
    __asm volatile ("nop");
    __asm volatile ("nop");
    __asm volatile ("nop");
    UART->U_CTRL_bf.STRTX = 1;
    __asm volatile ("nop");
    __asm volatile ("nop");
    __asm volatile ("nop");
    __asm volatile ("nop");
    __asm volatile ("nop");
    __asm volatile ("nop");
    __asm volatile ("nop");
    while (UART->U_STAT_bf.TBUSY == 1) {};
    __asm volatile ("nop");
    __asm volatile ("nop");
    __asm volatile ("nop");
    __asm volatile ("nop");
    __asm volatile ("nop");
    __asm volatile ("nop");
    __asm volatile ("nop");
    UART->U_CTRL_bf.STRTX = 0;
    __asm volatile ("nop");
    __asm volatile ("nop");
    __asm volatile ("nop");
    __asm volatile ("nop");
    __asm volatile ("nop");
    __asm volatile ("nop");
    __asm volatile ("nop");
}

void uart_send_str(const char *my_str) {
    for (uint32_t i = 0; my_str[i] != '\0'; i++) {
        __asm volatile ("nop");
        __asm volatile ("nop");
        __asm volatile ("nop");
        __asm volatile ("nop");
        __asm volatile ("nop");
        __asm volatile ("nop");
        __asm volatile ("nop");
        uart_send_char((uint8_t)my_str[i]);
        __asm volatile ("nop");
        __asm volatile ("nop");
        __asm volatile ("nop");
        __asm volatile ("nop");
        __asm volatile ("nop");
        __asm volatile ("nop");
        __asm volatile ("nop");
    }
}

// các hàm giả lập
EI_IMPULSE_ERROR ei_run_impulse_check_canceled() { return EI_IMPULSE_OK; }
EI_IMPULSE_ERROR ei_sleep(int32_t time_ms) {
    volatile uint32_t count = 0;
    for (uint32_t i = 0; i < (uint32_t)time_ms * 5000; i++) {
        count++;
    }

    return EI_IMPULSE_OK;
}

// thời gian
uint64_t ei_read_timer_ms(void) {
    uint32_t lo, hi;
    __asm__ volatile ("csrr %0, time" : "=r"(lo));
    __asm__ volatile ("csrr %0, timeh" : "=r"(hi));
    return ((uint64_t)hi << 32 | lo) / 1000;
}
uint64_t ei_read_timer_us(void) {
    uint32_t lo, hi;
    __asm__ volatile ("csrr %0, time" : "=r"(lo));
    __asm__ volatile ("csrr %0, timeh" : "=r"(hi));
    return ((uint64_t)hi << 32 | lo);
}

void ei_putchar(char c) { uart_send_char((uint8_t)c); }
char ei_getchar(void) { return 0; }
// In float với 4 chữ số thập phân
void ei_printf_float(float f) {
    if (f < 0) { uart_send_char('-'); f = -f; }
    int whole = (int)f;
    int frac = (int)((f - whole) * 10000); // 4 chữ số sau dấu thập phân
    // in phần nguyên
    char buf[12];
    int i = 0;
    int val = whole;
    if (val == 0) buf[i++] = '0';
    else {
        while (val) { buf[i++] = '0' + val % 10; val /= 10; }
    }
    while (i--) uart_send_char(buf[i]);
    uart_send_char('.');
    // in phần thập phân
    val = frac;
    int j = 4;
    char fbuf[4];
    while (j--) {
        fbuf[j] = '0' + val % 10;
        val /= 10;
    }
    for (int k=0; k<4; k++) uart_send_char(fbuf[k]);
}

// printf qua UART
void ei_printf(const char *fmt, ...) {
    va_list args;
    va_start(args, fmt);
    while (*fmt) {
        if (*fmt == '%') {
            fmt++;
            switch (*fmt) {
                case 'd': {
                    int val = va_arg(args, int);
                    char buf[12];
                    int i = 0, neg = 0;
                    if (val < 0) { neg = 1; val = -val; }
                    do { buf[i++] = '0' + val % 10; val /= 10; } while(val);
                    if (neg) buf[i++] = '-';
                    while (i--) uart_send_char(buf[i]);
                    break;
                }
                case 'u': {
                    unsigned int val = va_arg(args, unsigned int);
                    char buf[11];
                    int i = 0;
                    if (val == 0) buf[i++] = '0';
                    else { while (val) { buf[i++] = '0' + val % 10; val /= 10; } }
                    while (i--) uart_send_char(buf[i]);
                    break;
                }
                case 'x': {
                    unsigned int val = va_arg(args, unsigned int);
                    char buf[8];
                    int i = 0;
                    if (val == 0) buf[i++] = '0';
                    else { while (val) { int nib = val & 0xF; buf[i++] = nib < 10 ? '0'+nib : 'a'+(nib-10); val >>= 4; } }
                    while (i--) uart_send_char(buf[i]);
                    break;
                }
                case 'f': {
                    double val = va_arg(args, double); // float được promote lên double
                    ei_printf_float((float)val);
                    break;
                }
                case 's': {
                    char *s = va_arg(args, char*);
                    while (*s) uart_send_char(*s++);
                    break;
                }
                case '%': uart_send_char('%'); break;
                default: uart_send_char('?'); break;
            }
        } else {
            uart_send_char(*fmt);
        }
        fmt++;
    }
    va_end(args);
}

// bộ nhớ động
void *ei_malloc(size_t size) { return malloc(size); }
void *ei_calloc(size_t nitems, size_t size) { return calloc(nitems, size); }
void ei_free(void *ptr) { free(ptr); }

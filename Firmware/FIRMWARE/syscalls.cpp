#include <errno.h>
#include <unistd.h>
#include "edge-impulse-sdk/porting/ei_classifier_porting.h"
#include <sys/types.h>

#ifdef __cplusplus
extern "C" {
#endif

// Khai báo biến toàn cục (được định nghĩa trong Linker Script)
extern char __heap_start; // Kết thúc vùng BSS (thường là bắt đầu Heap)
extern char __heap_end; // Giới hạn cuối của Heap (Tùy chọn)

static char *__current_heap_end = 0;

void *_sbrk(ptrdiff_t incr) {
    char *prev_heap_end;
    char *new_heap_end;
    
    // Khởi tạo đỉnh Heap lần đầu tiên
    if (__current_heap_end == 0) {
        __current_heap_end = &__heap_start;
    }
    
    prev_heap_end = __current_heap_end;
    new_heap_end = prev_heap_end + incr;

    // Kiểm tra tràn Heap (nếu có định nghĩa __heap_end)
    if (new_heap_end < prev_heap_end || new_heap_end > &__heap_end) {
        // Trả về lỗi nếu vượt quá giới hạn
        errno = ENOMEM;
        return (void *)-1;
    }

    // Cập nhật con trỏ đỉnh Heap
    __current_heap_end = new_heap_end;
    
    // Trả về địa chỉ Heap cũ
    return (void *)prev_heap_end;
}

// Khai báo hàm HAL (giả định bạn đã viết)
// Hàm này thực hiện việc gửi một ký tự (byte) ra UART

ssize_t _write(int file, const void *ptr, size_t len) {
    const char *buf = (const char *)ptr;

    // Chỉ hỗ trợ stdout (1) và stderr (2)
    if (file != STDOUT_FILENO && file != STDERR_FILENO) {
        errno = EBADF; // File descriptor không hợp lệ
        return -1;
    }

    // Gửi từng ký tự ra UART
    for (size_t i = 0; i < len; ++i) {
        ei_putchar(buf[i]);
    }

    return len; // Trả về số byte đã ghi
}

void _exit(int status) {
    // Tùy chọn: Thêm mã để báo lỗi ra UART nếu status != 0
    // Lệnh này dừng chương trình (vòng lặp vô hạn)
    while (1) {
        // Lệnh No Operation (NOP)
        __asm volatile ("nop");
    }
}

}





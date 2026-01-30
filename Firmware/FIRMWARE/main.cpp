//     #include <stdint.h>
//     #include <string.h>
//     #include <stdio.h>
//     #include <string.h>
//     #include <stdlib.h>
//     #include <regs_UART.h>
//     #include <regs_GPIO.h>
//     #include <regs_PLIC.h>
//     #include <regs_UFLASH.h>


//     #define BUF_SIZE 5000


//     __attribute__((optimize("O0")))
//     void delay_ms(int ms) {
//         //int i, j
//         for (int i = 0; i < ms; i++) {
//             for (int j = 0; j < 27000/24; j++) {
//             }
//         }
//     }

    
// void uart_send_char(uint8_t my_char){
//         UART->U_TXDATA = my_char;
//         UART->U_CTRL_bf.STRTX = 1;
//         while(UART->U_STAT_bf.TBUSY == 1){};
//         UART->U_CTRL_bf.STRTX = 0;
//     //  delay_ms(1);
// }

// void uart_send_str(const char *my_str) {
//     for (uint32_t i = 0; my_str[i] != '\0'; i++) {
//         uart_send_char((uint8_t)my_str[i]); // ép char sang uint8_t khi gửi
//     }
// }

// char buffer[BUF_SIZE];   // buffer toàn cục
// int index = 0;


// void handle_rxuart(void){
//     char rxdata = UART->U_RXDATA;
//     GPIO->GPIO_IO_bf.GPIO_14 = 1;
//     if (rxdata != 'Z') {  // giả sử ký tự kết thúc là '\n'
//         if (index < BUF_SIZE - 1) {
//             buffer[index++] = rxdata;
//         } else {
//             index = 0; // reset nếu tràn
//         }
//     } else {
//         buffer[index] = '\0';     // kết thúc chuỗi
//         uart_send_str(buffer);  // gửi lại toàn bộ chuỗi
//         index = 0;                // reset để nhận chuỗi mới
//     }
//     GPIO->GPIO_IO_bf.GPIO_14 = 0;
// }
// int cou = 0;
// void handle_pgpio15(void){
//     if(cou) cou = 0;
//     else cou = 1;
//     GPIO->GPIO_IO_bf.GPIO_14 = cou;
//     delay_ms(50);
// }

// void blink_led(){//GPIO0->GPIO5
//     GPIO->GPIO_IO = 0x00000001;
//     delay_ms(1000);
//     GPIO->GPIO_IO = 0x00000002;
//     delay_ms(1000);
//     GPIO->GPIO_IO = 0x00000004;
//     delay_ms(1000);
//     GPIO->GPIO_IO = 0x00000008;
//     delay_ms(1000);
//     GPIO->GPIO_IO = 0x00000010;
//     delay_ms(1000);
//     GPIO->GPIO_IO = 0x00000020;
//     delay_ms(1000);


//     GPIO->GPIO_IO = 0x00000010;
//     delay_ms(1000);
//     GPIO->GPIO_IO = 0x00000008;
//     delay_ms(1000);
//     GPIO->GPIO_IO = 0x00000004;
//     delay_ms(1000);
//     GPIO->GPIO_IO = 0x00000002;
//     delay_ms(1000);
//     GPIO->GPIO_IO = 0x00000001;
//     delay_ms(1000);
    
//     for(int i = 0; i < 5; i++){
//         GPIO->GPIO_IO = 0x0000002a;
//         delay_ms(1000);
//         GPIO->GPIO_IO = 0x00000015;
//         delay_ms(1000);
//     }
//     return;
// }

// // void __attribute__((interrupt)) trap_entry(void) {
// //     uint32_t cause;
// //     __asm__ volatile ("csrr %0, mcause" : "=r"(cause));

// //     if ((cause & 0x80000000) && ((cause & 0xFF) == 11)) {
// //         // External interrupt từ UART qua PLIC
// //         uint16_t ID = PLIC->P_CLAIMCOMPLETE;
// //         uint32_t pending = 1;   // đọc pending register từ UART
        
// //         if (ID == 1) handle_rxuart();
// //         if (ID == 33)handle_pgpio15();

// //         PLIC->P_CLAIMCOMPLETE = ID; //Complete
// //     }
// // }
// void uart_sendint_unsigned(unsigned num){
//     char buffer[12] = {};
//     int i = 0;
//     if(num == 0) {
//         buffer[0] = '0';
//         buffer[1] = '\0';
//     } 
//     else{
//         while(num > 0){
//             buffer[i++] = num%10 + '0';
//             num = num/10;
//         }

//         for(int j = 0; j < i/2; j++){
//             char temp;
//             temp = buffer[j];
//             buffer[j] = buffer[i-j-1];
//             buffer[i-j-1] = temp;
//         }
//         buffer[i] = '\0';

//     }
//     uart_send_str(buffer);
//     return;
// }
// void uart_sendint_signed(signed num){
//     char buffer[12] = {};
//     int i = 0;
//     if(num == 0) {
//         buffer[0] = '0';
//         buffer[1] = '\0';
//     } 
//     else{
//         if(num<0){
//             if (num == -2147483648){
//                 uart_send_str("-2147483648");
//                 return;
//             }
//             num = -num;
//             uart_send_char('-');
//         }
//         while(num > 0){
//             buffer[i++] = num%10 + '0';
//             num = num/10;
//         }

//         for(int j = 0; j < i/2; j++){
//             char temp;
//             temp = buffer[j];
//             buffer[j] = buffer[i-j-1];
//             buffer[i-j-1] = temp;
//         }
//         buffer[i] = '\0';

//     }
//     uart_send_str(buffer);
//     return;
// }

//     void INIT_UART(){
//         UART->U_CTRL &= 0xfffffffe;//EN
//         UART->U_CTRL |= 1<<0;

//         UART->U_CTRL &= 0xffffff0f;
//         UART->U_CTRL |= 15<<4;

//         UART->U_CTRL &= 0xffff00ff;//CLK
//         UART->U_CTRL |= 27<<8;
//     }

//     static inline uint32_t read_cyclelo(void) {
//         uint32_t lo;
//         __asm__ volatile ("csrr %0, cycle"  : "=r"(lo));
//         return lo;
//     }
//     static inline uint32_t read_cyclehi(void) {
//         uint32_t hi;
//         __asm__ volatile ("csrr %0, cycleh" : "=r"(hi));
//         return hi;
//     }

//     static inline uint32_t read_instretlo(void) {
//         uint32_t lo;
//         __asm__ volatile ("csrr %0, instret" : "=r"(lo));
//         return lo;
//     }
//     static inline uint32_t read_instrethi(void) {
//         uint32_t hi;
//         __asm__ volatile ("csrr %0, instreth" : "=r"(hi));
//         return hi;
//     }

//     static inline uint32_t read_timelo(void) {
//         uint32_t lo;
//         __asm__ volatile ("csrr %0, time" : "=r"(lo));
//         return lo;
//     }
//     static inline uint32_t read_timehi(void) {
//         uint32_t hi;
//         __asm__ volatile ("csrr %0, timeh" : "=r"(hi));
//         return hi;
//     }

//     void INIT_IRQ(){
//         __asm__ volatile ("csrw mstatus, %0" :: "r"(8));//MIE

//         __asm__ volatile ("csrw mie, %0" :: "r"(0x800));//MEIE

//         // __asm__ volatile ("csrw mtvec, %0" :: "r"(&trap_entry));//Địa chỉ xử lý ngắt
//     }

//     void INIT_PLIC(){
//         //Bật ngắt tất cả ngoại vi
//         PLIC->P_ENABLE0 |= 0xffffffff;
//         PLIC->P_ENABLE1 |= 0xffffffff;

//         //Mức ưu tiên uart là 3
//         PLIC->P_PRIORITY1 &= 0x00000000;
//         PLIC->P_PRIORITY1 |= 3;

//         //Mức ưu tiên gpio15 posedge là 1
//         PLIC->P_PRIORITY33 &= 0x00000000;
//         PLIC->P_PRIORITY33 |= 1;

//         //Mức ưu tiên gpio15 negedge là 0
//         PLIC->P_PRIORITY34 &= 0x00000000;
//         PLIC->P_PRIORITY34 |= 0;

//         //Ngưỡng ngắt là 0
//         PLIC->P_THRESHOLD &= 0x00000000;
//     }

//     void INIT_GPIO(void){
//         GPIO->GPIO_CONFIG_bf.GPIO_15CONFIG = 1;//input
//     }

//     void INIT_UFLASH(){
//         UFLASH->UFLASH_CR = 0xffffffff;
//         UFLASH->UFLASH_CR_bf.MODE = 3;//IDLE
//         UFLASH->UFLASH_KEY1 = 0x57494E44;
//         UFLASH->UFLASH_KEY2 = 0x48674432;
//         UFLASH->UFLASH_KEY3 = 0xab4f9029;
//     }

//     void prog_flash(uint32_t data_prog, uint16_t xaddr, uint16_t yaddr){
//         UFLASH->UFLASH_XADR = xaddr;
//         UFLASH->UFLASH_YADR = yaddr;

//         UFLASH->UFLASH_DIR = data_prog;
//         UFLASH->UFLASH_CR_bf.MODE = 1;//PROGRAM
//         while(!UFLASH->UFLASH_SR_bf.PROG_DONE);
//         UFLASH->UFLASH_CR_bf.MODE = 3;//IDLE
//     }

//     uint32_t read_flash(uint16_t xaddr, uint16_t yaddr){
//         UFLASH->UFLASH_XADR = xaddr;
//         UFLASH->UFLASH_YADR = yaddr;

//         UFLASH->UFLASH_CR_bf.MODE = 0;//READ
//         while(!UFLASH->UFLASH_SR_bf.RD_DONE);
//         UFLASH->UFLASH_CR_bf.MODE = 3;//IDLE
//         return UFLASH->UFLASH_DOR;
//     }

//     void erase_flash(uint16_t xaddr){
//         UFLASH->UFLASH_XADR = xaddr;

//         UFLASH->UFLASH_CR_bf.MODE = 2;//PROGRAM
//         while(!UFLASH->UFLASH_SR_bf.ERASE_DONE);
//         UFLASH->UFLASH_CR_bf.MODE = 3;//IDLE
//     }

//     int mul_asm(int a, int b) {
//         int res;
//         __asm__ volatile ("mul %0, %1, %2" : "=r"(res) : "r"(a), "r"(b));
//         return res;
//     }
//     int mulh_asm(int a, int b) {
//         int resh;
//         __asm__ volatile ("mulh %0, %1, %2" : "=r"(resh) : "r"(a), "r"(b));
//         return resh;
//     }
//     int mulhu_asm(int a, int b) {
//         int reshu;
//         __asm__ volatile ("mulhu %0, %1, %2" : "=r"(reshu) : "r"(a), "r"(b));
//         return reshu;
//     }
//     int mulhsu_asm(int a, int b) {
//         int reshsu;
//         __asm__ volatile ("mulhsu %0, %1, %2" : "=r"(reshsu) : "r"(a), "r"(b));
//         return reshsu;
//     }
//     int div_asm(int a, int b) {
//         int res;
//         __asm__ volatile ("div %0, %1, %2" : "=r"(res) : "r"(a), "r"(b));
//         return res;
//     }
//     int divu_asm(int a, int b) {
//         int resu;
//         __asm__ volatile ("divu %0, %1, %2" : "=r"(resu) : "r"(a), "r"(b));
//         return resu;
//     }
//     int rem_asm(int a, int b) {
//         int rem;
//         __asm__ volatile ("rem %0, %1, %2" : "=r"(rem) : "r"(a), "r"(b));
//         return rem;
//     }
//     int remu_asm(int a, int b) {
//         int remu;
//         __asm__ volatile ("remu %0, %1, %2" : "=r"(remu) : "r"(a), "r"(b));
//         return remu;
//     }

// void uart_sendfloat(float f) {
//     char buf[48];

//     double fd = (double)f; // promote
//     if (fd < 0.0) { uart_send_char('-'); fd = -fd; }

//     // nếu quá lớn để cast an toàn vào int64, in bằng snprintf fallback
//     if (1) { // > 2^63 approx
//         // fallback
//         snprintf(buf, sizeof(buf), "%.6f", fd);
//         uart_send_str(buf);
//         return;
//     }

//     int64_t int_part = (int64_t)fd;
//     double frac = fd - (double)int_part;
//     if (frac < 0) frac = 0.0; // guard

//     // lấy 6 chữ số thập phân (làm tròn)
//     int32_t frac_part = (int32_t) (frac * 1000000.0 + 0.5);

//     // xử lý khi round up làm tràn phần nguyên
//     if (frac_part >= 1000000) {
//         frac_part -= 1000000;
//         int_part += 1;
//     }

//     // gửi phần nguyên (hàm của bạn hỗ trợ unsigned/signed 32bit; dùng 64bit cần mở rộng)
//     // convert int_part -> string (64-bit)
//     char intbuf[24];
//     int idx = 0;
//     int64_t tmp = int_part;
//     if (tmp == 0) { intbuf[idx++]='0'; }
//     else {
//         char rev[24]; int ri=0;
//         while(tmp>0) { rev[ri++]= '0' + (tmp%10); tmp/=10; }
//         while(ri--) intbuf[idx++]=rev[ri];
//     }
//     intbuf[idx]=0;
//     uart_send_str(intbuf);
//     uart_send_char('.');

//     char fracbuf[7];
//     for (int i = 5; i>=0; --i) {
//         fracbuf[i] = (frac_part % 10) + '0';
//         frac_part /= 10;
//     }
//     fracbuf[6]=0;
//     uart_send_str(fracbuf);
// }



// void uart_sendfloat_prec(float f, int precision) {
//     if (precision < 0) precision = 0;
//     if (precision > 8) precision = 8; // giới hạn 8 digits

//     if (f < 0) {
//         uart_send_char('-');
//         f = -f;
//     }

//     int32_t int_part = (int32_t)f;
//     uart_sendint_unsigned(int_part);

//     uart_send_char('.');

//     float frac = f - (float)int_part;

//     for (int i = 0; i < precision; i++) {
//         frac *= 10.0f;
//         int digit = (int)frac;
//         uart_send_char('0' + digit);
//         frac -= digit;
//     }
// }






//     unsigned cyclo;
//     uint64_t cychi;
//     uint64_t inslo;
//     uint64_t inshi;
//     uint64_t timelo;
//     uint64_t timehi;
//     uint32_t numb = 10;
//     uint32_t numa = 0;

//     float x = 0.11, y = 1.45, z = 5.76;
//     int main()
//     {
//         INIT_UART();
//         // INIT_IRQ();
//         // INIT_PLIC();
//         INIT_GPIO();
//         // INIT_UFLASH();

//         while (1){
//             cyclo = read_cyclelo();
//             cychi = read_cyclehi();

//             inslo = read_instretlo();
//             inshi = read_instrethi();

//             timelo = read_timelo();
//             timehi = read_timehi();
    

//             // uart_send_str("CYCLE: ");
//             // //uart_sendint(cychi);            
//             // uart_sendint(cyclo);
//             // uart_send_str("\n");

//             // uart_send_str("INSTRET: ");
//             // //uart_sendint(inshi);            
//             // uart_sendint(inslo);
//             // uart_send_str("\n");

//             // uart_send_str("TIME: ");
//             // //uart_sendint(timehi);            
//             // uart_sendint(timelo);
//             // uart_send_str("\n\n");

//             numb = numb + numa;
//             numa = numa+2;

//             x = z+y;
//             y = y+z;
//             z = x+y;

//             uart_send_str("x = ");
//             uart_sendfloat(x);
//             uart_send_char('\n');

//             uart_send_str("y = ");
//             uart_sendfloat(y);
//             uart_send_char('\n');

//             uart_send_str("z = ");
//             uart_sendfloat(z);
//             uart_send_char('\n');

//             uart_send_str("x*y = ");
//             uart_sendfloat(x*y);
//             uart_send_char('\n');

//             uart_send_str("z/y = ");
//             uart_sendfloat(z/y);
//             uart_send_char('\n');

//             uart_send_str("z*x+y = ");
//             uart_sendfloat(z*x + y);
//             uart_send_char('\n');



//             int32_t a = (int32_t)(numb);
//             int32_t b = (int32_t)numa;

//             uart_send_str("mul: "); uart_sendint_signed(a); uart_send_char('*'); uart_sendint_signed(-b); uart_send_str(" = "); uart_sendint_signed(mul_asm(a, -b)); uart_send_char('\n');//mul ở 158454083    
//             uart_send_str("mulh: "); uart_sendint_signed(a); uart_send_char('*'); uart_sendint_signed(-b); uart_send_str(" = "); uart_sendint_signed(mulh_asm(a, -b)); uart_send_char('\n');
//             uart_send_str("mulhu: "); uart_sendint_signed(a); uart_send_char('*'); uart_sendint_signed(-b); uart_send_str(" = "); uart_sendint_signed(mulhu_asm(a, -b)); uart_send_char('\n');
//             uart_send_str("mulhsu: "); uart_sendint_signed(-a); uart_send_char('*'); uart_sendint_signed(-b); uart_send_str(" = "); uart_sendint_signed(mulhsu_asm(-a, -b)); uart_send_char('\n');

//             uart_send_str("div: "); uart_sendint_signed(a); uart_send_char('/'); uart_sendint_signed(-b); uart_send_str(" = "); uart_sendint_signed(div_asm(a, -b)); uart_send_char('\n');//mul ở 158454083    
//             uart_send_str("divu: "); uart_sendint_signed(-a); uart_send_char('/'); uart_sendint_signed(b); uart_send_str(" = "); uart_sendint_signed(divu_asm(-a, b)); uart_send_char('\n');
//             uart_send_str("rem: "); uart_sendint_signed(a); uart_send_char('%'); uart_sendint_signed(-b); uart_send_str(" = "); uart_sendint_signed(rem_asm(a, -b)); uart_send_char('\n');
//             uart_send_str("remu: "); uart_sendint_signed(-a); uart_send_char('%'); uart_sendint_signed(b); uart_send_str(" = "); uart_sendint_signed(remu_asm(-a, b)); uart_send_char('\n');
            
//             uart_send_str("THDB b/0: div = "); uart_sendint_signed(div_asm(b, 0)); uart_send_str(" divu = "); uart_sendint_signed(divu_asm(b, 0)); uart_send_str(" rem = "); uart_sendint_signed(rem_asm(b, 0)); uart_send_str(" remu = "); uart_sendint_signed(remu_asm(b, 0)); uart_send_char('\n');
//             uart_send_str("THDB overflow -2^31/-1: div = "); uart_sendint_signed(div_asm(0x80000000, 0xffffffff)); uart_send_str(" rem = "); uart_sendint_signed(rem_asm(0x80000000, 0xffffffff)); uart_send_char('\n');

//             uart_send_char('\n');uart_send_char('\n');
//             delay_ms(4000);

//             // blink_led();
//         }
//         return 0;
//     }

























#include <stdio.h>
#include <regs_UART.h>
#include <regs_I2C.h>
#include <regs_PLIC.h>
#include <regs_GPIO.h>
#include <regs_TIMER.h>

#include "edge-impulse-sdk/classifier/ei_run_classifier.h"

#define EI_CAMERA_RAW_FRAME_BUFFER_COLS           32
#define EI_CAMERA_RAW_FRAME_BUFFER_ROWS           32
#define EI_CAMERA_FRAME_BYTE_SIZE                 3

void delay_us(int tim){
    uint64_t readtim_old = ei_read_timer_us();
    while((ei_read_timer_us() - readtim_old) < tim);
    return;
}
void delay_ms(int tim){
    delay_us(tim*1000);
}

void INIT_PLIC(){
    //Bật ngắt tất cả ngoại vi
    PLIC->P_ENABLE0 |= 0xffffffff;
    PLIC->P_ENABLE1 |= 0xffffffff;

    //Mức ưu tiên uart là 3
    PLIC->P_PRIORITY1 &= 0x00000000;
    PLIC->P_PRIORITY1 |= 3;

    //Ngưỡng ngắt là 0
    PLIC->P_THRESHOLD &= 0x00000000;
}
void INIT_GPIO(){
    GPIO->GPIO_CONFIG_bf.GPIO_0CONFIG = 0;//Tín hiệu báo sẵn sàng nhận ảnh
    GPIO->GPIO_IO_bf.GPIO_0 = 0;

    GPIO->GPIO_CONFIG_bf.GPIO_1CONFIG = 0;//Tín hiệu báo ngắt uart
    GPIO->GPIO_IO_bf.GPIO_1 = 0;

    GPIO->GPIO_CONFIG_bf.GPIO_2CONFIG = 1;//Tín hiệu nhận từ esp báo đang truyền ảnh

    GPIO->GPIO_CONFIG_bf.GPIO_3CONFIG = 0;//Output cho chân Trig
    GPIO->GPIO_IO_bf.GPIO_3 = 0;

    GPIO->GPIO_CONFIG_bf.GPIO_4CONFIG = 1;//Input cho chân Echo

    GPIO->GPIO_CONFIG_bf.GPIO_5CONFIG = 0;//Output cho chân điều khiển băng truyền
    GPIO->GPIO_IO_bf.GPIO_5 = 0;

    GPIO->GPIO_CONFIG_bf.GPIO_6CONFIG = 0;//Output điều khiển led
    GPIO->GPIO_IO_bf.GPIO_6 = 0;
}


    static inline uint32_t read_cyclelo(void) {
        uint32_t lo;
        __asm__ volatile ("csrr %0, cycle"  : "=r"(lo));
        return lo;
    }
    static inline uint32_t read_cyclehi(void) {
        uint32_t hi;
        __asm__ volatile ("csrr %0, cycleh" : "=r"(hi));
        return hi;
    }

    static inline uint32_t read_instretlo(void) {
        uint32_t lo;
        __asm__ volatile ("csrr %0, instret" : "=r"(lo));
        return lo;
    }
    static inline uint32_t read_instrethi(void) {
        uint32_t hi;
        __asm__ volatile ("csrr %0, instreth" : "=r"(hi));
        return hi;
    }

    // Đọc thanh ghi Cntbra (Tổng số lệnh nhảy) tại địa chỉ 0x999
    static inline uint32_t read_cntbra(void) {
        uint32_t val;
        __asm__ volatile ("csrr %0, 0x999" : "=r"(val));
        return val;
    }

    // Đọc thanh ghi Cntwrobra (Tổng số lệnh nhảy sai) tại địa chỉ 0x998
    static inline uint32_t read_cntwrobra(void) {
        uint32_t val;
        __asm__ volatile ("csrr %0, 0x998" : "=r"(val));
        return val;
    }

uint32_t raw_image[1024] = {
    0x716066, 0x746369, 0x72666f, 0x887d86, 0x897e83, 0x7b7274, 0x85757a, 0x8c767d, 0x8d7780, 0x8e7885, 0x8e7883, 0x8f7880, 0x8f7880, 0x8f7880, 0x907980, 0x8f7880, 0x8c757d, 0x8e7783, 0x8e7784, 0x887887, 0x988b99, 0x978a9c, 0x938699, 0x938599, 0x94879b, 0x807385, 0x7c6f7d, 0x7b6e7e, 0x796c7f, 0x75687a, 0x726674, 0x6d6270, 0x78676d, 0x79686e, 0x826873, 0x8b6f7a, 0x8a717a, 0x8a727a, 0x8e767e, 0x907780, 0x907780, 0x927983, 0x9a808a, 0x967882, 0x977a84, 0x997c85, 0x977a84, 0x937780, 0x947780, 0x9e8391, 0x9f8595, 0xa08699, 0xa2899c, 0xa3899d, 0xa1869b, 0x9e879a, 0x9d899a, 0x8a7386, 0x886e81, 0x876d80, 0x876b80, 0x81677b, 0x7f6579, 0x7c6276, 0x77606e, 0x7b6471, 0x7d656e, 0x816971, 0x866f77, 0x89727a, 0x8a737b, 0x8b747c, 0x8f777f, 0x917780, 0x937981, 0x927881, 0x957a83, 0x977c85, 0x967c84, 0x937981, 0xa28891, 0xa48b9c, 0x9e8598, 0xa0889b, 0x9f869a, 0x9e859b, 0x9d839b, 0x998093, 0x8e7785, 0x866e7d, 0x836b79, 0x836b7c, 0x82697c, 0x7f6679, 0x7b6275, 0x775e71, 0x7e666f, 0x7c666f, 0x816770, 0x866b74, 0x8a727a, 0x8a737b, 0x8a737b, 0x8a737b, 0x8f777f, 0x907780, 0x8f767f, 0x947982, 0x977c85, 0x977c85, 0x977c85, 0x947981, 0x9f848e, 0xa88fa0, 0xa58ca0, 0xa3899c, 0x9c8296, 0x9e849a, 0x9f849e, 0x997f94, 0x8a7284, 0x887080, 0x866e7c, 0x846c7a, 0x806877, 0x7e6675, 0x775f6e, 0x745c6b, 0x827074, 0x7c6a6e, 0x806971, 0x856c75, 0x887079, 0x8b737c, 0x8a737b, 0x8b747c, 0x8e777f, 0x8e787f, 0x907981, 0x917781, 0x947a84, 0x957d85, 0x927981, 0x947981, 0x9e848d, 0xaa95a7, 0xa08ca1, 0x9c889c, 0x9a879a, 0x98849b, 0x9a84a0, 0x9a8397, 0x8c7382, 0x886e7e, 0x846c7a, 0x826a78, 0x7d6476, 0x796173, 0x6f5c6c, 0x6e5b6b, 0x85747f, 0x7c6c77, 0x806c74, 0x856e76, 0x877179, 0x856f76, 0x8a747b, 0x917982, 0x917c85, 0x8e7b85, 0x8a767f, 0x99948a, 0x978a8b, 0x8c7480, 0x8d7680, 0x8e747f, 0x947b88, 0x948499, 0x7c6c88, 0x6a6184, 0x60597e, 0x6b5d7f, 0x8c7c97, 0xa292a1, 0x93808a, 0x8b7682, 0x83707b, 0x826d7a, 0x7e6576, 0x785e72, 0x725a71, 0x6d556c, 0x846e7b, 0x7c6673, 0x7e6770, 0x806a71, 0x856c77, 0x8a707d, 0x977f8a, 0x725b63, 0x816f68, 0x958373, 0x96a288, 0xc1f7c3, 0xbad0ad, 0x9d8279, 0xa0897e, 0x9f897c, 0x9e8a7c, 0x837579, 0x9e8ca7, 0xc0aec4, 0x87758b, 0x685671, 0x716075, 0x8b7b8b, 0x958598, 0x928093, 0x897689, 0x8b788c, 0x8d7b92, 0x78657b, 0x655061, 0x665162, 0x765f6a, 0x846d77, 0x947c88, 0x9b8490, 0x9d8996, 0xa3909e, 0x8c7789, 0x4d3943, 0x8e776b, 0xcfd1a8, 0xc4f7be, 0xc9ffca, 0xc3dbb4, 0xbea898, 0xc0ab99, 0xc5a99b, 0xc9ac9c, 0xa69390, 0x938493, 0xab9ba9, 0x8c7a89, 0x837083, 0x7f6e79, 0x675f64, 0x807e85, 0x8c8890, 0x857986, 0x6d5c72, 0x54445f, 0x44334b, 0x3f303f, 0x493a49, 0x937a85, 0x927884, 0x876c76, 0x7c6069, 0x736274, 0x6d607b, 0x8b7c94, 0x7f6f8b, 0x919e8f, 0xbef5c1, 0xc3ffc7, 0xaee4b1, 0x7f8e8d, 0x87968b, 0xa0c09a, 0xa6b99d, 0x826e66, 0x6a5b58, 0x8e8f8b, 0x9baa9b, 0x90a08f, 0x8fa792, 0x8ba98e, 0x9ec59e, 0xa9d8a9, 0xa3d3a9, 0x90968c, 0x71475a, 0x4f3344, 0x574158, 0x4d4159, 0x43374f, 0x7d5967, 0x7b5766, 0x79575e, 0x805e62, 0x685369, 0x8b7c9e, 0xa898ad, 0xa4acac, 0xbcf0be, 0xbeffc4, 0xbcf5bc, 0x8a9f7e, 0x798174, 0xabd6a6, 0xcfffcc, 0xc5ffc7, 0xb0e8b1, 0x9fcd9e, 0xb2e4b4, 0xbbf5bf, 0xbbf8bf, 0xb3ecb6, 0xb4ebb6, 0xb1e6b4, 0xb2e4b5, 0x96c89f, 0x707972, 0x523043, 0x32232d, 0x2a1f30, 0x41344e, 0x5f526c, 0x7f5c62, 0x88666b, 0x87686a, 0x89686a, 0x816e7a, 0x706677, 0x484d4e, 0xa6d0a3, 0xb9efb7, 0xb3ecb8, 0x94c395, 0x767d5b, 0x859469, 0xa4d2a0, 0xe5ffe5, 0xc7fec7, 0xb0efb1, 0xa4dea5, 0xb5f4ba, 0xbbfabf, 0xc4fbc8, 0xb8efbf, 0xabe6b2, 0xa1d2a7, 0x9fcaa3, 0x80a488, 0x48504d, 0x382d33, 0x453b43, 0x281c2c, 0x403648, 0x483e50, 0x846065, 0x876368, 0x8b6b67, 0x8d6e67, 0x927c7c, 0x4d3d43, 0x696e5a, 0xbbe3b4, 0x96b696, 0x97bf9a, 0x6d906d, 0x677551, 0xe2e0b9, 0xd4f5c6, 0xabd4af, 0x82aa80, 0x80ad80, 0xa2d8a3, 0xb6f4bb, 0xb4f1bb, 0xb0e0b7, 0x9bc59d, 0x86b185, 0x80a27f, 0x789379, 0x505f53, 0x343438, 0x4f4948, 0x6c5f5e, 0x2d2031, 0x353342, 0x343241, 0x8c6c6c, 0x8f6e6e, 0x92726f, 0x94736f, 0xac9089, 0xcabfb8, 0xe9e4d4, 0xb8ba99, 0x789272, 0x6e8b71, 0x648868, 0x779c71, 0xabb88b, 0xd1d9b1, 0x678060, 0x5e7a57, 0x84aa83, 0x8ec093, 0x83b286, 0x7ea583, 0x7ea485, 0x7c9b7c, 0x749074, 0x657868, 0x38393e, 0x332935, 0x5d585e, 0x4a4e53, 0x43444b, 0x34353c, 0x32313b, 0x25242e, 0x96736f, 0x977470, 0x9d7a77, 0x9c7774, 0xbfaa96, 0xffffec, 0xffffec, 0xe0cfac, 0x747864, 0x506d5e, 0x496050, 0x668467, 0x71936d, 0x889d7f, 0x87a584, 0x90ba91, 0x88b38b, 0x80a285, 0x98ac98, 0xadb9af, 0x87918b, 0x677864, 0x5a6b55, 0x2a3130, 0x33323c, 0x44323b, 0x4c3b3e, 0x4b4f51, 0x3f424d, 0x383d47, 0x373d44, 0x30363d, 0x987571, 0x9b7874, 0xa17f79, 0xa6847f, 0x897e7e, 0x988d7b, 0xd6c49c, 0xd6c19d, 0x9e8b74, 0x748069, 0x637464, 0x708a70, 0x89b58f, 0x638e70, 0x6b886e, 0x97c29a, 0xb9e3be, 0xd3dcd3, 0xabb5b6, 0x798584, 0x576260, 0x45534a, 0x6f6f68, 0xb4a9ab, 0xb4b5b5, 0x5f575a, 0x35292e, 0x554851, 0x5f5e6d, 0x454f5c, 0x404855, 0x353b49, 0x9a7772, 0x9d7a75, 0xa48677, 0x9f897e, 0x898686, 0x474146, 0x493a37, 0x7e7060, 0x988d73, 0x797565, 0x4c5753, 0x6b8079, 0x72897c, 0x678c70, 0x63876d, 0x83b38d, 0x96c5a2, 0x778c85, 0x566d66, 0x48645a, 0x475b53, 0x979998, 0xc5c6c6, 0x9c9fa3, 0x5f5c66, 0x393a44, 0x332832, 0x562f3a, 0x6e5961, 0x454b56, 0x373a4b, 0x2d243a, 0x8e6a6c, 0x987476, 0xad8b86, 0x8d847e, 0x6b7a79, 0x55575c, 0x332d31, 0x656056, 0x858271, 0x48433f, 0x2a262f, 0x474f54, 0x677b72, 0x63806b, 0x54745f, 0x497259, 0x4e6e5a, 0x425549, 0x3b4b40, 0x4c6452, 0x697c6a, 0x6d8076, 0x545d5c, 0x39363b, 0x39323a, 0x302830, 0x361d27, 0x4b1f2c, 0x5c2936, 0x564052, 0x2d2752, 0x584d8c, 0x79535a, 0x926b72, 0x9c7b80, 0x777c7c, 0x697d7d, 0x72797d, 0x2e2930, 0x413939, 0x4b4745, 0x28242a, 0x3d393f, 0x48454d, 0x464649, 0x565e54, 0x66786c, 0x566963, 0x5f706a, 0x3c4841, 0x394440, 0x434f4b, 0x35413b, 0x242d2c, 0x2d2a30, 0x3b3338, 0x40393c, 0x393738, 0x3e3235, 0x4c2333, 0x6e4657, 0x5e4056, 0x3c2f76, 0x564998, 0x714851, 0x7c5059, 0x80646c, 0x6b7975, 0x637876, 0x6b7e7e, 0x526264, 0x3d4c4e, 0x3d4a4b, 0x434d50, 0x465051, 0x45514d, 0x373f3e, 0x393d3a, 0x3d4340, 0x3e4648, 0x3c4547, 0x39423f, 0x3f4946, 0x3d484a, 0x434f52, 0x4b5359, 0x4f5356, 0x525557, 0x3d3f44, 0x3a3d43, 0x525860, 0x5b4857, 0x513443, 0x462e41, 0x2e2654, 0x392e70, 0x775153, 0x966e72, 0x837e7a, 0x677d79, 0x7f8b8a, 0x84908d, 0x7f9390, 0x819b99, 0x849c9b, 0x859d97, 0x889e95, 0x859b98, 0x7c9897, 0x789294, 0x748f85, 0x768f84, 0x728a88, 0x678583, 0x6c8b84, 0x6e8a82, 0x6d8980, 0x68877f, 0x5f8178, 0x576f6b, 0x424047, 0x393a41, 0x4c5157, 0x62666c, 0x39333e, 0x2c2030, 0x1c1731, 0x1e1838, 0xa58682, 0xaf938f, 0x86918e, 0x889899, 0x7a8b87, 0x738981, 0x6e8881, 0x6b8982, 0x6b8b82, 0x688c7f, 0x69897f, 0x6a8982, 0x668c7f, 0x608c7e, 0x5f8a7b, 0x618879, 0x5f857a, 0x598476, 0x548072, 0x537f70, 0x4d7b6b, 0x4d7466, 0x4b6c61, 0x4e6a64, 0x6d787b, 0x707479, 0x727579, 0x62686c, 0x344046, 0x252b32, 0x292f38, 0x1c232a, 0xb69695, 0xa08d87, 0x97a39d, 0x798b86, 0x618076, 0x66877c, 0x65867b, 0x65887c, 0x66897d, 0x688a7f, 0x648a7e, 0x608d7d, 0x628d7e, 0x608d7d, 0x5f8c7c, 0x60897b, 0x5e8779, 0x598577, 0x588475, 0x598173, 0x5a8174, 0x597e71, 0x53776b, 0x4c6e64, 0x546e67, 0x727c7d, 0x697778, 0x33393f, 0x262131, 0x252332, 0x2a2b39, 0x333744, 0xb49596, 0x898683, 0x94a4a3, 0x6a7d7e, 0x6c8880, 0x6c8a80, 0x6a897f, 0x69897f, 0x6a8c80, 0x698d81, 0x688d81, 0x648e80, 0x648d7f, 0x638c7e, 0x638c7e, 0x5d8b7c, 0x5a8879, 0x578675, 0x568373, 0x547c6e, 0x537a6c, 0x53796d, 0x52776b, 0x4f7367, 0x4d6a5f, 0x506960, 0x47645b, 0x374949, 0x2b2936, 0x251f2e, 0x201e2c, 0x231e2d, 0xa18c87, 0x89908e, 0x859999, 0x5c7272, 0x6c837d, 0x6b847a, 0x738a82, 0x748981, 0x69877c, 0x62897c, 0x65887c, 0x66877b, 0x67897d, 0x658a7e, 0x668b7e, 0x6c8f82, 0x6b8e82, 0x6c8d82, 0x6a8b81, 0x6d8a80, 0x6e8980, 0x6f887f, 0x718880, 0x748884, 0x738484, 0x728282, 0x6d7a7b, 0x677475, 0x62686c, 0x3a3a42, 0x1e1c24, 0x211e26, 0x5d5f5c, 0x778d88, 0x97a2a8, 0x7d8a91, 0x819190, 0x869895, 0x91a2a1, 0x93a4a3, 0x8b9f9e, 0x89a19f, 0x8aa19f, 0x8ca19f, 0x8ca29f, 0x8da69d, 0x8da59d, 0x8da59f, 0x8aa29d, 0x859e9a, 0x7d9692, 0x78938b, 0x749087, 0x708980, 0x6b827a, 0x647c78, 0x5b7575, 0x546c6d, 0x516769, 0x465d5e, 0x405956, 0x3b514f, 0x303a3c, 0x212a2c, 0x495859, 0x607673, 0x6c7d7f, 0x849699, 0x819594, 0x819592, 0x7f9493, 0x7c9292, 0x799190, 0x758f8e, 0x708e89, 0x6d8f85, 0x6b8c83, 0x6c8c81, 0x68897d, 0x608878, 0x5e8677, 0x5e8476, 0x5c8274, 0x587f72, 0x557e70, 0x547a6b, 0x537668, 0x517269, 0x4c6b66, 0x486661, 0x48635d, 0x425e58, 0x3b5753, 0x38514f, 0x384c4d, 0x354849, 0x547063, 0x5e7971, 0x54766c, 0x597e73, 0x5e7f74, 0x618074, 0x628379, 0x62857c, 0x65877c, 0x67897c, 0x65897d, 0x638a7f, 0x658b80, 0x688a7f, 0x67887d, 0x64887b, 0x64877b, 0x628579, 0x608277, 0x5d8177, 0x597f75, 0x597c74, 0x567770, 0x53726d, 0x587070, 0x536a67, 0x435f56, 0x425d56, 0x3c5451, 0x384f4e, 0x3b4b4f, 0x38494c, 0x547568, 0x567570, 0x5a7874, 0x617e7a, 0x618178, 0x628478, 0x63837b, 0x64847d, 0x65867d, 0x67887d, 0x698a80, 0x658980, 0x63887e, 0x66897d, 0x64867b, 0x63857a, 0x608278, 0x5a8074, 0x567c6f, 0x527870, 0x4f756e, 0x4e706a, 0x4f6f68, 0x4e6666, 0x818a93, 0xa8afb7, 0x7d858e, 0x566167, 0x425757, 0x3b4f4f, 0x394c4b, 0x374a49, 0x57726f, 0x57726e, 0x5d786f, 0x617e74, 0x5f7f76, 0x5f8077, 0x5f8077, 0x618278, 0x628379, 0x638378, 0x65867c, 0x66877d, 0x618076, 0x648176, 0x67847a, 0x6e8785, 0x748c8c, 0x7e8f94, 0x819297, 0x8a98a1, 0x919ea8, 0x9ca0ae, 0xa4a4b4, 0xaba7ba, 0xb3aac0, 0xc3bdd4, 0xc9c3e1, 0xa3a4ba, 0x4a5e62, 0x3b4d51, 0x384949, 0x384949, 0x537469, 0x53746a, 0x56796e, 0x5c7f74, 0x5b7d75, 0x5a7c75, 0x5c7d77, 0x5f7f7a, 0x608078, 0x608074, 0x607f77, 0x6e8483, 0xbbc2c9, 0xd7cfe3, 0xd7d0e4, 0xd7d3e8, 0xd5d1e8, 0xcecae3, 0xc9c5de, 0xbfbdd5, 0xb6b4cc, 0xacacc0, 0x9e9fb1, 0x9195a4, 0x7e8791, 0x898c9d, 0xc6c0dc, 0x9093a6, 0x3f5558, 0x3b4f52, 0x364a49, 0x334746, 0x4e6f6a, 0x50716c, 0x567a72, 0x567b73, 0x587c72, 0x597e73, 0x5b7d72, 0x5d7e73, 0x5e8075, 0x5e8176, 0x608177, 0x6a837f, 0x94a4a6, 0x92a0a8, 0x86959c, 0x7a8a8d, 0x6f7f82, 0x63777a, 0x5a6f72, 0x556d6b, 0x526c68, 0x486862, 0x42655e, 0x42625c, 0x405f58, 0x556b6c, 0x7d8794, 0x4d5d65, 0x354f4f, 0x354f4e, 0x354a48, 0x314544, 0x4c706a, 0x4e726c, 0x54766d, 0x55776d, 0x567670, 0x567671, 0x56776e, 0x547669, 0x54716c, 0x526c6f, 0x516869, 0x566465, 0x49565a, 0x4a545a, 0x525b61, 0x5e5e67, 0x484851, 0x33333a, 0x303037, 0x2f3b3d, 0x48605e, 0x486a64, 0x436962, 0x42665f, 0x42635e, 0x3e5b58, 0x37524f, 0x3b5653, 0x385250, 0x324b49, 0x334847, 0x314544

};
uint32_t pixel = 0;
int flag = 1;
int index = 0;
int cnt = 0;
int done_capture = 0;
void handle_rxuart(void){
    GPIO->GPIO_IO_bf.GPIO_1 = 1;
    if(flag){
        __asm volatile ("nop");
        __asm volatile ("nop");
        __asm volatile ("nop");
        __asm volatile ("nop");
        __asm volatile ("nop");
        __asm volatile ("nop");
        __asm volatile ("nop");
        uint8_t rxdata = UART->U_RXDATA;
        if(cnt == 0){//b
            pixel = (uint32_t)rxdata;
            cnt++;
        } 
        else if(cnt == 1){//g
            pixel |= ((uint32_t)rxdata << 8);
            cnt++;
        }
        else if(cnt == 2){//r
            pixel |= ((uint32_t)rxdata << 16);
            cnt = 0;
            raw_image[index] = pixel;
            index++;
            if(index >= 1023){
                ei_printf("Capture done\r\n");
                index = 0; 
                done_capture = 1;
                GPIO->GPIO_IO_bf.GPIO_0 = 0;
            } 
        }
    }
    GPIO->GPIO_IO_bf.GPIO_1 = 0;
}

void __attribute__((interrupt)) trap_entry(void) {
    uint32_t cause;
    __asm__ volatile ("csrr %0, mcause" : "=r"(cause));

    if ((cause & 0x80000000) && ((cause & 0xFF) == 11)) {
        // External interrupt từ UART qua PLIC
        uint16_t ID = PLIC->P_CLAIMCOMPLETE;
        uint32_t pending = 1;   // đọc pending register từ UART
        
        if (ID == 1) handle_rxuart();

        PLIC->P_CLAIMCOMPLETE = ID; //Complete
    }
}
void INIT_IRQ(){
    __asm__ volatile ("csrw mstatus, %0" :: "r"(8));//MIE

    __asm__ volatile ("csrw mie, %0" :: "r"(0x800));//MEIE

    __asm__ volatile ("csrw mtvec, %0" :: "r"(&trap_entry));//Địa chỉ xử lý ngắt
}
void INIT_UART(){
    UART->U_CTRL_bf.EN = 1;

    UART->U_CTRL_bf.BR = 0xf;
}
void INIT_PWM(){
    TIM->TPWM_CONFIG_bf.EN = 1;
    TIM->TPWM_CONFIG_bf.NUM = 1;
    TIM->TPWM_CONFIG_bf.POL = 1;
    TIM->TPWM_CONFIG_bf.SEL1 = 0;
    TIM->TPWM_CONFIG_bf.MODE = 0;

    TIM->TPWM_PRESCALER = 80;//1M
    TIM->TPWM_PERIOD1_bf.PER1 = 20000;//50HZ
    TIM->TPWM_COMPARE1_bf.CP1 = 0;
}
void Control_servo(int angle) {
    // Giới hạn góc từ 0 đến 180 để an toàn
    if (angle < 0) angle = 0;
    if (angle > 180) angle = 180;

    // Chuyển đổi từ góc (0-180) sang độ rộng xung (500us - 2400us)
    // Công thức: PulseWidth = 500 + (angle * (2400 - 500) / 180)
    uint32_t pulse_width = 500 + (angle * 1900 / 180);

    // Gán giá trị vào thanh ghi so sánh
    TIM->TPWM_COMPARE1_bf.CP1 = pulse_width;
}


void init_i2c(){
    I2C->I2C_CONTROL_bf.CLKMODE = 3;    //100KHz
    I2C->I2C_CONTROL_bf.SEML = 5;
    I2C->I2C_CONTROL_bf.EN = 1;
}

void send_i2c(uint8_t saddr, uint8_t sraddr, uint64_t datas, int numb){
    I2C->I2C_SLAVE_ADDR = saddr;
    I2C->I2C_CONTROL_bf.MODE = 0;
    I2C->I2C_TX_DATA_LOW = datas;
    if(sraddr != 0) I2C->I2C_REG_ADDR = sraddr;
    if(numb > 2) I2C->I2C_TX_DATA_HIGH = datas>>32;

    I2C->I2C_CONTROL_bf.NUMBTX = numb;
    I2C->I2C_CONTROL_bf.RSE = (sraddr != 0)?1:0;
    I2C->I2C_CONTROL_bf.STRX = 1;
    int tim1 = ei_read_timer_ms();
    int tim2 = 0;
    while(I2C->I2C_STATUS_bf.TS != 1){
        tim2 = ei_read_timer_ms();
        if(tim2 - tim1 > 1000){
            ei_printf("Gui i2c that bai!!!\n\r");
            if(I2C->I2C_CONTROL_bf.STRX == 0) ei_printf("STRX = 0\r\n");
            if(I2C->I2C_CONTROL_bf.EN == 0) ei_printf("EN = 0\r\n");
            if(I2C->I2C_CONTROL_bf.MODE == 1) ei_printf("MODE = 1\r\n");
            if(I2C->I2C_CONTROL_bf.NUMBTX == 0) ei_printf("NUMBTX = 0\r\n");
            break;
        }
    }
    I2C->I2C_CONTROL_bf.STRX = 0;
}
void LCD_sendcmd(uint8_t cmd)
{
    uint8_t data;

    // ----- gửi nibble cao -----
    data = (cmd & 0xF0) | 0x0C;     // EN=1, RS=0
    send_i2c(0x27, 0, data, 1);

    data = (cmd & 0xF0) | 0x08;     // EN=0, RS=0
    send_i2c(0x27, 0, data, 1);

    // ----- gửi nibble thấp -----
    data = ((cmd << 4) & 0xF0) | 0x0C;  // EN=1, RS=0
    send_i2c(0x27, 0, data, 1);

    data = ((cmd << 4) & 0xF0) | 0x08;  // EN=0, RS=0
    send_i2c(0x27, 0, data, 1);
}
void LCD_sendchar(uint8_t ch)
{
    uint8_t data;

    // ----- gửi nibble cao -----
    data = (ch & 0xF0) | 0x0D;      // EN=1, RS=1
    send_i2c(0x27, 0, data, 1);

    data = (ch & 0xF0) | 0x09;      // EN=0, RS=1
    send_i2c(0x27, 0, data, 1);

    // ----- gửi nibble thấp -----
    data = ((ch << 4) & 0xF0) | 0x0D;   // EN=1, RS=1
    send_i2c(0x27, 0, data, 1);

    data = ((ch << 4) & 0xF0) | 0x09;   // EN=0, RS=1
    send_i2c(0x27, 0, data, 1);
}


void init_LCD20X4(){
    delay_ms(50);
    LCD_sendcmd(0x30);
    delay_ms(5);
    LCD_sendcmd(0x03);
    delay_us(1000);
    LCD_sendcmd(0x00);
    delay_us(1000);
    LCD_sendcmd(0x02);
    delay_us(1000);
    LCD_sendcmd(0x28);
    delay_us(1000);
    LCD_sendcmd(0x08);
    delay_us(1000);
    LCD_sendcmd(0x01);
    delay_ms(2);
    LCD_sendcmd(0x06);
    delay_ms(2);
    LCD_sendcmd(0x0C);
}
void LCD_resetcurser(){
    LCD_sendcmd(0x02);
    delay_ms(10);
}
void LCD_gotoCursor(uint8_t row, uint8_t col)
{
    uint8_t address;

    if (col > 19) col = 19;

    switch (row)
    {
        case 0: address = 0x00 + col; break; // Line 1
        case 1: address = 0x40 + col; break; // Line 2
        case 2: address = 0x14 + col; break; // Line 3
        case 3: address = 0x54 + col; break; // Line 4
        default: return;
    }

    LCD_sendcmd(0x80 | address);
}
void LCD_sendstr(const char *str)
{
    while (*str)
    {
        LCD_sendchar((uint8_t)(*str));
        str++;
    }
}
void LCD_print_percent(float val) {
    // 1. Chuyển đổi từ 0.0-1.0 sang 0.0-100.0
    float percent = val * 100.0f;

    // 2. Ép kiểu lấy phần nguyên và phần thập phân (1 chữ số)
    // Thêm 0.05 để làm tròn (ví dụ 95.56 -> 95.6)
    int int_part = (int)percent;
    int dec_part = (int)((percent - int_part) * 10);

    // 3. Hiển thị phần nguyên
    if (int_part >= 100) {
        LCD_sendchar('1');
        LCD_sendchar('0');
        LCD_sendchar('0');
    } else {
        // Hàng chục
        if (int_part >= 10) {
            LCD_sendchar((int_part / 10) + '0');
        } else {
            LCD_sendchar(' '); // Khoảng trắng cho số < 10%
        }
        // Hàng đơn vị
        LCD_sendchar((int_part % 10) + '0');
    }

    // 4. Hiển thị dấu chấm và phần thập phân
    LCD_sendchar('.');
    LCD_sendchar(dec_part + '0');
    LCD_sendchar('%');
}
void uart_send_char2(uint8_t my_char) {
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
void uart_print_hex32(uint32_t val) {
    uart_send_char('0');
    uart_send_char('x');
    for (int i = 7; i >= 0; i--) {
        uint8_t nib = (val >> (i * 4)) & 0xF;
        uart_send_char(nib < 10 ? '0' + nib : 'A' + nib - 10);
    }
}

float Read_distance(){
    GPIO->GPIO_IO_bf.GPIO_3 = 1;
    delay_us(10);
    GPIO->GPIO_IO_bf.GPIO_3 = 0;

    uint32_t timeout = 1000000;
    while(GPIO->GPIO_IO_bf.GPIO_4 == 0){
        timeout--;
        if(timeout == 0) {
            ei_printf("HCSR04 Timeout\r\n");
            return -1;
        } 
    } 
    uint64_t timea = ei_read_timer_us();

    timeout = 1000000;
    while(GPIO->GPIO_IO_bf.GPIO_4 == 1){
        timeout--;
        if(timeout == 0) {
            ei_printf("HCSR04 Timeout\r\n");
            return -1;
        } 
    }
    uint64_t timeb = ei_read_timer_us();

    return (float)((timeb-timea)*34)/2000;
}


/* Private variables ------------------------------------------------------- */
static bool debug_nn = false; // Set this to true to see e.g. features generated from the raw signal
static bool is_initialised = false;
float p_toi = 0;
float p_chanh = 0;
bool flag_led = false;
uint8_t *snapshot_buf; //points to the output of the capture
int chanh = 0;
int toi = 0;

static int ei_camera_get_data(size_t offset, size_t length, float *out_ptr);

int main() {
    ei::signal_t signal;         // Wrapper for raw input buffer
    ei_impulse_result_t result = { 0 };// Used to store inference output
    EI_IMPULSE_ERROR res;       // Return code from inference

    INIT_GPIO();
    INIT_UART();
    init_i2c();
    INIT_PLIC();
    INIT_IRQ();
    INIT_PWM();
    init_LCD20X4();
    LCD_resetcurser();
    LCD_sendstr("HELLO");
    LCD_gotoCursor(1, 0);
    LCD_sendstr("DO THANH PHONG");

    done_capture = 0;
    cnt = 0;
    pixel = 0;
    index = 0;
    flag = 1;
    Control_servo(90);

    snapshot_buf = (uint8_t*)malloc(EI_CAMERA_RAW_FRAME_BUFFER_COLS * EI_CAMERA_RAW_FRAME_BUFFER_ROWS * EI_CAMERA_FRAME_BYTE_SIZE);


    while(1){
        p_toi = 0; p_chanh = 0;
        float dis = Read_distance();
        ei_printf("KHOANG CACH: %f\r\n", dis);
        Control_servo(90);
        
        if(dis > 10 || dis < 4.5){
            LCD_gotoCursor(0, 0);
            LCD_sendstr("  Saft energy   ");
            LCD_gotoCursor(1, 0);
            LCD_sendstr("Distance: ");
            LCD_sendchar((int)dis/10 + '0');
            LCD_sendchar((int)dis%10 + '0');
            LCD_sendchar('.');
            LCD_sendchar((int)(dis*10)%10 + '0');
            LCD_sendstr("cm");
            delay_ms(300);
            GPIO->GPIO_IO_bf.GPIO_6 = 0;//bat led
            flag_led = false;
            continue;
        }
        GPIO->GPIO_IO_bf.GPIO_6 = 1;//bat led
        if(flag_led == false) delay_ms(500);
        flag_led = true;

        //snapshot_buf = (uint8_t*)malloc(EI_CAMERA_RAW_FRAME_BUFFER_COLS * EI_CAMERA_RAW_FRAME_BUFFER_ROWS * EI_CAMERA_FRAME_BYTE_SIZE);

        done_capture = 0;
        cnt = 0;
        pixel = 0;
        index = 0;
        flag = 1;
        GPIO->GPIO_IO_bf.GPIO_0 = 1;//sẵn sàng nhận dữ liệu từ ESP32 CAM

        if (!snapshot_buf) {
            ei_printf("ERR: Failed to allocate snapshot buffer!\n");
            return 0;
        }   

        while(done_capture == 0){
            __asm volatile ("nop");
        };
        flag = 0;
        ei_printf("ok\r\n");
        for (int i = 0; i < EI_CAMERA_RAW_FRAME_BUFFER_COLS * EI_CAMERA_RAW_FRAME_BUFFER_ROWS; i++) {
            uint32_t px = raw_image[i];

            uint8_t r = (px >> 16) & 0xFF;
            uint8_t g = (px >> 8) & 0xFF;
            uint8_t b = px & 0xFF;

            snapshot_buf[i*3 + 0] = b;
            snapshot_buf[i*3 + 1] = g;
            snapshot_buf[i*3 + 2] = r;
        }
        done_capture = 0;
        ei_printf("ok2\r\n");
        ei_printf("Image 1024 pixel: (0x00RRGGBB)\r\n");
        for(int i = 0; i < 1024; i++){
            uart_print_hex32(raw_image[i]);
            uart_send_char(' ');
        }
        ei_printf("\r\n");

        signal.total_length = EI_CLASSIFIER_INPUT_WIDTH * EI_CLASSIFIER_INPUT_HEIGHT;
        signal.get_data = &ei_camera_get_data;

        memset(&result, 0, sizeof(result));
        EI_IMPULSE_ERROR err = run_classifier(&signal, &result, false);
        ei_printf("ok3\r\n");
        flag = 1;
        if (err != EI_IMPULSE_OK) {
            ei_printf("ERR: Failed to run classifier (%d)\n", err);
            free(snapshot_buf);
            return 0;
        }

        // Print return code and how long it took to perform inference
        ei_printf("run_classifier returned: \r\n");
        ei_printf("Predictions (DSP: %d ms., Classification: %d ms., Anomaly: %d ms.): \n",
                result.timing.dsp, result.timing.classification, result.timing.anomaly);

        // Print the prediction results (object detection)
        for (uint32_t i = 0; i < result.bounding_boxes_count; i++) {
            ei_impulse_result_bounding_box_t bb = result.bounding_boxes[i];

            if (bb.label[0] == 't')
                p_toi = bb.value;

            if (bb.label[0] == 'c')
                p_chanh = bb.value;

            if (bb.value > EI_CLASSIFIER_OBJECT_DETECTION_THRESHOLD)
            ei_printf("  %s (%f) [ x: %u, y: %u, width: %u, height: %u ]\r\n",
                    bb.label, bb.value, bb.x, bb.y, bb.width, bb.height);
        }

        LCD_gotoCursor(0,0);
        LCD_sendstr("Toi: ");
        LCD_print_percent(p_toi);
        LCD_sendstr("   "); 
        LCD_sendchar(toi/100 + '0');
        LCD_sendchar((toi%100)/10 + '0');
        LCD_sendchar((toi%10) + '0');

        // Dòng 2: Chanh
        LCD_gotoCursor(1,0);
        LCD_sendstr("Chanh: ");
        LCD_print_percent(p_chanh);
        LCD_sendstr(" "); // Xóa ký tự thừa
        LCD_sendchar(chanh/100 + '0');
        LCD_sendchar((chanh%100)/10 + '0');
        LCD_sendchar((chanh%10) + '0');

        // In chu kỳ máy (Cycles)
        ei_printf("cyclo: %u\n", read_cyclelo());
        ei_printf("cychi: %u\n", read_cyclehi());

        // In số lệnh đã thực thi (Instructions Retired)
        ei_printf("instrlo: %u\n", read_instretlo());
        ei_printf("instrhi: %u\n", read_instrethi());

        uint32_t total_branches = read_cntbra();
        uint32_t wrong_branches = read_cntwrobra();

        ei_printf("branch total: %u\n", total_branches);
        ei_printf("branch wrong total: %u\n", wrong_branches);

        if(p_toi <= 0.55){//Là chanh
            if(p_chanh >= 0.65){
                GPIO->GPIO_IO_bf.GPIO_5 = 1;//Bật băng truyền
                Control_servo(0);
                chanh++;
                for(int i = 0; i < 20; i++) delay_ms(250);
            }
        }
        else{//là tỏi
            if(p_chanh <= 0.7){
                GPIO->GPIO_IO_bf.GPIO_5 = 1;//Bật băng truyền
                Control_servo(90);
                toi++;
                for(int i = 0; i < 10; i++) delay_ms(500);
            }
        }

        Control_servo(90);
        delay_ms(300);
        memset(&result, 0, sizeof(result));
        // memset(&snapshot_buf, 0, sizeof(snapshot_buf));
        memset(&raw_image, 0, sizeof(raw_image));
    }
}

// Edge Impulse sẽ gọi hàm này để đọc dữ liệu
static int ei_camera_get_data(size_t offset, size_t length, float *out_ptr)
{
    // we already have a RGB888 buffer, so recalculate offset into pixel index
    size_t pixel_ix = offset * 3;
    size_t pixels_left = length;
    size_t out_ptr_ix = 0;

    while (pixels_left != 0) {
        // Swap BGR to RGB here
        // due to https://github.com/espressif/esp32-camera/issues/379
        out_ptr[out_ptr_ix] = (snapshot_buf[pixel_ix + 2] << 16) + (snapshot_buf[pixel_ix + 1] << 8) + snapshot_buf[pixel_ix];

        // go to the next pixel
        out_ptr_ix++;
        pixel_ix+=3;
        pixels_left--;
    }
    // and done!
    return 0;
}
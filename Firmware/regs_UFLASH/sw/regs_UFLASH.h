// Created with Corsair v1.0.4
#ifndef __REGS_UFLASH_H
#define __REGS_UFLASH_H

#define __I  volatile const // 'read only' permissions
#define __O  volatile       // 'write only' permissions
#define __IO volatile       // 'read / write' permissions


#ifdef __cplusplus
#include <cstdint>
extern "C" {
#else
#include <stdint.h>
#endif

#define UFLASH_BASE_ADDR 0x0

// UFLASH_KEY1 - Unlock key for User Flash region
#define UFLASH_UFLASH_KEY1_ADDR 0x0
#define UFLASH_UFLASH_KEY1_RESET 0x0
typedef struct {
    uint32_t KEY : 32; // 32-bit unlock key value(0x57494E44 - WIND)
} uflash_uflash_key1_t;

// UFLASH_KEY1.KEY - 32-bit unlock key value(0x57494E44 - WIND)
#define UFLASH_UFLASH_KEY1_KEY_WIDTH 32
#define UFLASH_UFLASH_KEY1_KEY_LSB 0
#define UFLASH_UFLASH_KEY1_KEY_MASK 0xffffffff
#define UFLASH_UFLASH_KEY1_KEY_RESET 0x0

// UFLASH_KEY2 - Unlock key for Text Flash region
#define UFLASH_UFLASH_KEY2_ADDR 0x4
#define UFLASH_UFLASH_KEY2_RESET 0x0
typedef struct {
    uint32_t KEY : 32; // 32-bit unlock key value
} uflash_uflash_key2_t;

// UFLASH_KEY2.KEY - 32-bit unlock key value
#define UFLASH_UFLASH_KEY2_KEY_WIDTH 32
#define UFLASH_UFLASH_KEY2_KEY_LSB 0
#define UFLASH_UFLASH_KEY2_KEY_MASK 0xffffffff
#define UFLASH_UFLASH_KEY2_KEY_RESET 0x0

// UFLASH_KEY3 - Unlock key for Boot Flash region
#define UFLASH_UFLASH_KEY3_ADDR 0x8
#define UFLASH_UFLASH_KEY3_RESET 0x0
typedef struct {
    uint32_t KEY : 32; // 32-bit unlock key value
} uflash_uflash_key3_t;

// UFLASH_KEY3.KEY - 32-bit unlock key value
#define UFLASH_UFLASH_KEY3_KEY_WIDTH 32
#define UFLASH_UFLASH_KEY3_KEY_LSB 0
#define UFLASH_UFLASH_KEY3_KEY_MASK 0xffffffff
#define UFLASH_UFLASH_KEY3_KEY_RESET 0x0

// UFLASH_CR - Flash Control Register
#define UFLASH_UFLASH_CR_ADDR 0xc
#define UFLASH_UFLASH_CR_RESET 0x0
typedef struct {
    uint32_t USER_EN : 1; // Enable access to User region
    uint32_t TEXT_EN : 1; // Enable access to Text region
    uint32_t BOOT_EN : 1; // Enable access to Boot region
    uint32_t PROG_EN : 1; // Program enable
    uint32_t READ_EN : 1; // Read enable
    uint32_t ERASE_EN : 1; // Erase enable
    uint32_t MODE : 2; // Flash operation mode
    uint32_t : 24; // reserved
} uflash_uflash_cr_t;

// UFLASH_CR.USER_EN - Enable access to User region
#define UFLASH_UFLASH_CR_USER_EN_WIDTH 1
#define UFLASH_UFLASH_CR_USER_EN_LSB 0
#define UFLASH_UFLASH_CR_USER_EN_MASK 0x1
#define UFLASH_UFLASH_CR_USER_EN_RESET 0x0

// UFLASH_CR.TEXT_EN - Enable access to Text region
#define UFLASH_UFLASH_CR_TEXT_EN_WIDTH 1
#define UFLASH_UFLASH_CR_TEXT_EN_LSB 1
#define UFLASH_UFLASH_CR_TEXT_EN_MASK 0x2
#define UFLASH_UFLASH_CR_TEXT_EN_RESET 0x0

// UFLASH_CR.BOOT_EN - Enable access to Boot region
#define UFLASH_UFLASH_CR_BOOT_EN_WIDTH 1
#define UFLASH_UFLASH_CR_BOOT_EN_LSB 2
#define UFLASH_UFLASH_CR_BOOT_EN_MASK 0x4
#define UFLASH_UFLASH_CR_BOOT_EN_RESET 0x0

// UFLASH_CR.PROG_EN - Program enable
#define UFLASH_UFLASH_CR_PROG_EN_WIDTH 1
#define UFLASH_UFLASH_CR_PROG_EN_LSB 3
#define UFLASH_UFLASH_CR_PROG_EN_MASK 0x8
#define UFLASH_UFLASH_CR_PROG_EN_RESET 0x0

// UFLASH_CR.READ_EN - Read enable
#define UFLASH_UFLASH_CR_READ_EN_WIDTH 1
#define UFLASH_UFLASH_CR_READ_EN_LSB 4
#define UFLASH_UFLASH_CR_READ_EN_MASK 0x10
#define UFLASH_UFLASH_CR_READ_EN_RESET 0x0

// UFLASH_CR.ERASE_EN - Erase enable
#define UFLASH_UFLASH_CR_ERASE_EN_WIDTH 1
#define UFLASH_UFLASH_CR_ERASE_EN_LSB 5
#define UFLASH_UFLASH_CR_ERASE_EN_MASK 0x20
#define UFLASH_UFLASH_CR_ERASE_EN_RESET 0x0

// UFLASH_CR.MODE - Flash operation mode
#define UFLASH_UFLASH_CR_MODE_WIDTH 2
#define UFLASH_UFLASH_CR_MODE_LSB 6
#define UFLASH_UFLASH_CR_MODE_MASK 0xc0
#define UFLASH_UFLASH_CR_MODE_RESET 0x0
typedef enum {
    UFLASH_UFLASH_CR_MODE_READ = 0x0, //Read mode
    UFLASH_UFLASH_CR_MODE_PROGRAM = 0x1, //Program mode
    UFLASH_UFLASH_CR_MODE_ERASE = 0x2, //Erase mode
    UFLASH_UFLASH_CR_MODE_IDLE = 0x3, //Idle mode
} uflash_uflash_cr_mode_t;

// UFLASH_SR - Flash Status Register
#define UFLASH_UFLASH_SR_ADDR 0x10
#define UFLASH_UFLASH_SR_RESET 0x0
typedef struct {
    uint32_t ERRA_USER : 1; // Error unauthorized access to User region
    uint32_t ERRA_TEXT : 1; // Error unauthorized access to Text region
    uint32_t ERRA_BOOT : 1; // Error unauthorized access to Boot region
    uint32_t ERRA_OVF : 1; // Error address overflow
    uint32_t RD_DONE : 1; // Read operation finished
    uint32_t PROG_DONE : 1; // Program operation finished
    uint32_t ERASE_DONE : 1; // Erase operation finished
    uint32_t : 25; // reserved
} uflash_uflash_sr_t;

// UFLASH_SR.ERRA_USER - Error unauthorized access to User region
#define UFLASH_UFLASH_SR_ERRA_USER_WIDTH 1
#define UFLASH_UFLASH_SR_ERRA_USER_LSB 0
#define UFLASH_UFLASH_SR_ERRA_USER_MASK 0x1
#define UFLASH_UFLASH_SR_ERRA_USER_RESET 0x0

// UFLASH_SR.ERRA_TEXT - Error unauthorized access to Text region
#define UFLASH_UFLASH_SR_ERRA_TEXT_WIDTH 1
#define UFLASH_UFLASH_SR_ERRA_TEXT_LSB 1
#define UFLASH_UFLASH_SR_ERRA_TEXT_MASK 0x2
#define UFLASH_UFLASH_SR_ERRA_TEXT_RESET 0x0

// UFLASH_SR.ERRA_BOOT - Error unauthorized access to Boot region
#define UFLASH_UFLASH_SR_ERRA_BOOT_WIDTH 1
#define UFLASH_UFLASH_SR_ERRA_BOOT_LSB 2
#define UFLASH_UFLASH_SR_ERRA_BOOT_MASK 0x4
#define UFLASH_UFLASH_SR_ERRA_BOOT_RESET 0x0

// UFLASH_SR.ERRA_OVF - Error address overflow
#define UFLASH_UFLASH_SR_ERRA_OVF_WIDTH 1
#define UFLASH_UFLASH_SR_ERRA_OVF_LSB 3
#define UFLASH_UFLASH_SR_ERRA_OVF_MASK 0x8
#define UFLASH_UFLASH_SR_ERRA_OVF_RESET 0x0

// UFLASH_SR.RD_DONE - Read operation finished
#define UFLASH_UFLASH_SR_RD_DONE_WIDTH 1
#define UFLASH_UFLASH_SR_RD_DONE_LSB 4
#define UFLASH_UFLASH_SR_RD_DONE_MASK 0x10
#define UFLASH_UFLASH_SR_RD_DONE_RESET 0x0

// UFLASH_SR.PROG_DONE - Program operation finished
#define UFLASH_UFLASH_SR_PROG_DONE_WIDTH 1
#define UFLASH_UFLASH_SR_PROG_DONE_LSB 5
#define UFLASH_UFLASH_SR_PROG_DONE_MASK 0x20
#define UFLASH_UFLASH_SR_PROG_DONE_RESET 0x0

// UFLASH_SR.ERASE_DONE - Erase operation finished
#define UFLASH_UFLASH_SR_ERASE_DONE_WIDTH 1
#define UFLASH_UFLASH_SR_ERASE_DONE_LSB 6
#define UFLASH_UFLASH_SR_ERASE_DONE_MASK 0x40
#define UFLASH_UFLASH_SR_ERASE_DONE_RESET 0x0

// UFLASH_XADR - Flash X Address Register
#define UFLASH_UFLASH_XADR_ADDR 0x14
#define UFLASH_UFLASH_XADR_RESET 0x0
typedef struct {
    uint32_t XADR : 16; // Flash X address (row / page select)
    uint32_t : 16; // reserved
} uflash_uflash_xadr_t;

// UFLASH_XADR.XADR - Flash X address (row / page select)
#define UFLASH_UFLASH_XADR_XADR_WIDTH 16
#define UFLASH_UFLASH_XADR_XADR_LSB 0
#define UFLASH_UFLASH_XADR_XADR_MASK 0xffff
#define UFLASH_UFLASH_XADR_XADR_RESET 0x0

// UFLASH_YADR - Flash Y Address Register
#define UFLASH_UFLASH_YADR_ADDR 0x18
#define UFLASH_UFLASH_YADR_RESET 0x0
typedef struct {
    uint32_t YADR : 8; // Flash Y address (column / word select)
    uint32_t : 24; // reserved
} uflash_uflash_yadr_t;

// UFLASH_YADR.YADR - Flash Y address (column / word select)
#define UFLASH_UFLASH_YADR_YADR_WIDTH 8
#define UFLASH_UFLASH_YADR_YADR_LSB 0
#define UFLASH_UFLASH_YADR_YADR_MASK 0xff
#define UFLASH_UFLASH_YADR_YADR_RESET 0x0

// UFLASH_DOR - Flash data out Register
#define UFLASH_UFLASH_DOR_ADDR 0x1c
#define UFLASH_UFLASH_DOR_RESET 0x0
typedef struct {
    uint32_t DO : 32; // 32BIT READ DATA
} uflash_uflash_dor_t;

// UFLASH_DOR.DO - 32BIT READ DATA
#define UFLASH_UFLASH_DOR_DO_WIDTH 32
#define UFLASH_UFLASH_DOR_DO_LSB 0
#define UFLASH_UFLASH_DOR_DO_MASK 0xffffffff
#define UFLASH_UFLASH_DOR_DO_RESET 0x0

// UFLASH_DIR - Flash data in Register
#define UFLASH_UFLASH_DIR_ADDR 0x20
#define UFLASH_UFLASH_DIR_RESET 0x0
typedef struct {
    uint32_t DI : 32; // 32BIT PROGRAM DATA
} uflash_uflash_dir_t;

// UFLASH_DIR.DI - 32BIT PROGRAM DATA
#define UFLASH_UFLASH_DIR_DI_WIDTH 32
#define UFLASH_UFLASH_DIR_DI_LSB 0
#define UFLASH_UFLASH_DIR_DI_MASK 0xffffffff
#define UFLASH_UFLASH_DIR_DI_RESET 0x0


// Register map structure
typedef struct {
    union {
        __O uint32_t UFLASH_KEY1; // Unlock key for User Flash region
        __O uflash_uflash_key1_t UFLASH_KEY1_bf; // Bit access for UFLASH_KEY1 register
    };
    union {
        __O uint32_t UFLASH_KEY2; // Unlock key for Text Flash region
        __O uflash_uflash_key2_t UFLASH_KEY2_bf; // Bit access for UFLASH_KEY2 register
    };
    union {
        __O uint32_t UFLASH_KEY3; // Unlock key for Boot Flash region
        __O uflash_uflash_key3_t UFLASH_KEY3_bf; // Bit access for UFLASH_KEY3 register
    };
    union {
        __IO uint32_t UFLASH_CR; // Flash Control Register
        __IO uflash_uflash_cr_t UFLASH_CR_bf; // Bit access for UFLASH_CR register
    };
    union {
        __I uint32_t UFLASH_SR; // Flash Status Register
        __I uflash_uflash_sr_t UFLASH_SR_bf; // Bit access for UFLASH_SR register
    };
    union {
        __IO uint32_t UFLASH_XADR; // Flash X Address Register
        __IO uflash_uflash_xadr_t UFLASH_XADR_bf; // Bit access for UFLASH_XADR register
    };
    union {
        __IO uint32_t UFLASH_YADR; // Flash Y Address Register
        __IO uflash_uflash_yadr_t UFLASH_YADR_bf; // Bit access for UFLASH_YADR register
    };
    union {
        __I uint32_t UFLASH_DOR; // Flash data out Register
        __I uflash_uflash_dor_t UFLASH_DOR_bf; // Bit access for UFLASH_DOR register
    };
    union {
        __O uint32_t UFLASH_DIR; // Flash data in Register
        __O uflash_uflash_dir_t UFLASH_DIR_bf; // Bit access for UFLASH_DIR register
    };
} uflash_t;

#define UFLASH ((uflash_t*)(UFLASH_BASE_ADDR))

#ifdef __cplusplus
}
#endif

#endif /* __REGS_UFLASH_H */
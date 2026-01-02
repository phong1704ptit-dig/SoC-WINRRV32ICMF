// Created with Corsair v1.0.4
#ifndef __REGS_TIMER_H
#define __REGS_TIMER_H

#define __I  volatile const // 'read only' permissions
#define __O  volatile       // 'write only' permissions
#define __IO volatile       // 'read / write' permissions


#ifdef __cplusplus
#include <cstdint>
extern "C" {
#else
#include <stdint.h>
#endif

#define TIM_BASE_ADDR 0x80000000

// Tim_config - Timer configuration register
#define TIM_TIM_CONFIG_ADDR 0x0
#define TIM_TIM_CONFIG_RESET 0x2
typedef struct {
    uint32_t EN : 1; // Enable timer
    uint32_t AR : 1; // Auto reload when reaching period
    uint32_t : 2; // reserved
    uint32_t DIR : 1; // Count direction (0 = up, 1 = down)
    uint32_t UD : 1; // Update counter with load value
    uint32_t : 26; // reserved
} tim_tim_config_t;

// Tim_config.EN - Enable timer
#define TIM_TIM_CONFIG_EN_WIDTH 1
#define TIM_TIM_CONFIG_EN_LSB 0
#define TIM_TIM_CONFIG_EN_MASK 0x1
#define TIM_TIM_CONFIG_EN_RESET 0x0

// Tim_config.AR - Auto reload when reaching period
#define TIM_TIM_CONFIG_AR_WIDTH 1
#define TIM_TIM_CONFIG_AR_LSB 1
#define TIM_TIM_CONFIG_AR_MASK 0x2
#define TIM_TIM_CONFIG_AR_RESET 0x1

// Tim_config.DIR - Count direction (0 = up, 1 = down)
#define TIM_TIM_CONFIG_DIR_WIDTH 1
#define TIM_TIM_CONFIG_DIR_LSB 4
#define TIM_TIM_CONFIG_DIR_MASK 0x10
#define TIM_TIM_CONFIG_DIR_RESET 0x0

// Tim_config.UD - Update counter with load value
#define TIM_TIM_CONFIG_UD_WIDTH 1
#define TIM_TIM_CONFIG_UD_LSB 5
#define TIM_TIM_CONFIG_UD_MASK 0x20
#define TIM_TIM_CONFIG_UD_RESET 0x0

// Tim_prescaler - Prescaler register (divides input clock)
#define TIM_TIM_PRESCALER_ADDR 0x4
#define TIM_TIM_PRESCALER_RESET 0x1b
typedef struct {
    uint32_t DIV : 32; // Clock divider value
} tim_tim_prescaler_t;

// Tim_prescaler.DIV - Clock divider value
#define TIM_TIM_PRESCALER_DIV_WIDTH 32
#define TIM_TIM_PRESCALER_DIV_LSB 0
#define TIM_TIM_PRESCALER_DIV_MASK 0xffffffff
#define TIM_TIM_PRESCALER_DIV_RESET 0x1b

// Tim_period - Timer period register
#define TIM_TIM_PERIOD_ADDR 0x8
#define TIM_TIM_PERIOD_RESET 0xffff
typedef struct {
    uint32_t PER : 32; // Counter max value
} tim_tim_period_t;

// Tim_period.PER - Counter max value
#define TIM_TIM_PERIOD_PER_WIDTH 32
#define TIM_TIM_PERIOD_PER_LSB 0
#define TIM_TIM_PERIOD_PER_MASK 0xffffffff
#define TIM_TIM_PERIOD_PER_RESET 0xffff

// Tim_counter - Current counter value
#define TIM_TIM_COUNTER_ADDR 0xc
#define TIM_TIM_COUNTER_RESET 0x0
typedef struct {
    uint32_t CNT : 32; // Counter current count
} tim_tim_counter_t;

// Tim_counter.CNT - Counter current count
#define TIM_TIM_COUNTER_CNT_WIDTH 32
#define TIM_TIM_COUNTER_CNT_LSB 0
#define TIM_TIM_COUNTER_CNT_MASK 0xffffffff
#define TIM_TIM_COUNTER_CNT_RESET 0x0

// Tim_status - Timer status register
#define TIM_TIM_STATUS_ADDR 0x10
#define TIM_TIM_STATUS_RESET 0x0
typedef struct {
    uint32_t OF : 1; // Overflow flag
    uint32_t OP : 1; // Over period flag
    uint32_t ERR : 1; // Error flag
    uint32_t LD : 1; // Load done flag
    uint32_t : 28; // reserved
} tim_tim_status_t;

// Tim_status.OF - Overflow flag
#define TIM_TIM_STATUS_OF_WIDTH 1
#define TIM_TIM_STATUS_OF_LSB 0
#define TIM_TIM_STATUS_OF_MASK 0x1
#define TIM_TIM_STATUS_OF_RESET 0x0

// Tim_status.OP - Over period flag
#define TIM_TIM_STATUS_OP_WIDTH 1
#define TIM_TIM_STATUS_OP_LSB 1
#define TIM_TIM_STATUS_OP_MASK 0x2
#define TIM_TIM_STATUS_OP_RESET 0x0

// Tim_status.ERR - Error flag
#define TIM_TIM_STATUS_ERR_WIDTH 1
#define TIM_TIM_STATUS_ERR_LSB 2
#define TIM_TIM_STATUS_ERR_MASK 0x4
#define TIM_TIM_STATUS_ERR_RESET 0x0

// Tim_status.LD - Load done flag
#define TIM_TIM_STATUS_LD_WIDTH 1
#define TIM_TIM_STATUS_LD_LSB 3
#define TIM_TIM_STATUS_LD_MASK 0x8
#define TIM_TIM_STATUS_LD_RESET 0x0

// Tim_load - Value to load into counter
#define TIM_TIM_LOAD_ADDR 0x14
#define TIM_TIM_LOAD_RESET 0x0
typedef struct {
    uint32_t LOAD : 32; // Counter load value
} tim_tim_load_t;

// Tim_load.LOAD - Counter load value
#define TIM_TIM_LOAD_LOAD_WIDTH 32
#define TIM_TIM_LOAD_LOAD_LSB 0
#define TIM_TIM_LOAD_LOAD_MASK 0xffffffff
#define TIM_TIM_LOAD_LOAD_RESET 0x0

// TPWM_config - PWM configuration register
#define TIM_TPWM_CONFIG_ADDR 0x18
#define TIM_TPWM_CONFIG_RESET 0x0
typedef struct {
    uint32_t EN : 1; // Enable PWM/CAPTURE operation
    uint32_t SEL1 : 2; // Output selection for PWM1
    uint32_t SEL2 : 2; // Output selection for PWM2
    uint32_t MODE : 1; // mode CAPTURE or PWM
    uint32_t : 1; // reserved
    uint32_t SEL3 : 2; // Output selection for PWM3
    uint32_t SEL4 : 2; // Output selection for PWM4
    uint32_t NUM : 3; // Number of PWM signals selected
    uint32_t POL : 1; // Polarity of the PWM signal
    uint32_t : 17; // reserved
} tim_tpwm_config_t;

// TPWM_config.EN - Enable PWM/CAPTURE operation
#define TIM_TPWM_CONFIG_EN_WIDTH 1
#define TIM_TPWM_CONFIG_EN_LSB 0
#define TIM_TPWM_CONFIG_EN_MASK 0x1
#define TIM_TPWM_CONFIG_EN_RESET 0x0

// TPWM_config.SEL1 - Output selection for PWM1
#define TIM_TPWM_CONFIG_SEL1_WIDTH 2
#define TIM_TPWM_CONFIG_SEL1_LSB 1
#define TIM_TPWM_CONFIG_SEL1_MASK 0x6
#define TIM_TPWM_CONFIG_SEL1_RESET 0x0

// TPWM_config.SEL2 - Output selection for PWM2
#define TIM_TPWM_CONFIG_SEL2_WIDTH 2
#define TIM_TPWM_CONFIG_SEL2_LSB 3
#define TIM_TPWM_CONFIG_SEL2_MASK 0x18
#define TIM_TPWM_CONFIG_SEL2_RESET 0x0

// TPWM_config.MODE - mode CAPTURE or PWM
#define TIM_TPWM_CONFIG_MODE_WIDTH 1
#define TIM_TPWM_CONFIG_MODE_LSB 5
#define TIM_TPWM_CONFIG_MODE_MASK 0x20
#define TIM_TPWM_CONFIG_MODE_RESET 0x0

// TPWM_config.SEL3 - Output selection for PWM3
#define TIM_TPWM_CONFIG_SEL3_WIDTH 2
#define TIM_TPWM_CONFIG_SEL3_LSB 7
#define TIM_TPWM_CONFIG_SEL3_MASK 0x180
#define TIM_TPWM_CONFIG_SEL3_RESET 0x0

// TPWM_config.SEL4 - Output selection for PWM4
#define TIM_TPWM_CONFIG_SEL4_WIDTH 2
#define TIM_TPWM_CONFIG_SEL4_LSB 9
#define TIM_TPWM_CONFIG_SEL4_MASK 0x600
#define TIM_TPWM_CONFIG_SEL4_RESET 0x0

// TPWM_config.NUM - Number of PWM signals selected
#define TIM_TPWM_CONFIG_NUM_WIDTH 3
#define TIM_TPWM_CONFIG_NUM_LSB 11
#define TIM_TPWM_CONFIG_NUM_MASK 0x3800
#define TIM_TPWM_CONFIG_NUM_RESET 0x0

// TPWM_config.POL - Polarity of the PWM signal
#define TIM_TPWM_CONFIG_POL_WIDTH 1
#define TIM_TPWM_CONFIG_POL_LSB 14
#define TIM_TPWM_CONFIG_POL_MASK 0x4000
#define TIM_TPWM_CONFIG_POL_RESET 0x0

// TPWM_prescaler - PWM clock divider
#define TIM_TPWM_PRESCALER_ADDR 0x1c
#define TIM_TPWM_PRESCALER_RESET 0x1b
typedef struct {
    uint32_t DIV : 32; // Clock divider value for PWM
} tim_tpwm_prescaler_t;

// TPWM_prescaler.DIV - Clock divider value for PWM
#define TIM_TPWM_PRESCALER_DIV_WIDTH 32
#define TIM_TPWM_PRESCALER_DIV_LSB 0
#define TIM_TPWM_PRESCALER_DIV_MASK 0xffffffff
#define TIM_TPWM_PRESCALER_DIV_RESET 0x1b

// TPWM_period1 - PWM1 and PWM2 period register
#define TIM_TPWM_PERIOD1_ADDR 0x20
#define TIM_TPWM_PERIOD1_RESET 0xffffffff
typedef struct {
    uint32_t PER1 : 16; // Period value for PWM1
    uint32_t PER2 : 16; // Period value for PWM2
} tim_tpwm_period1_t;

// TPWM_period1.PER1 - Period value for PWM1
#define TIM_TPWM_PERIOD1_PER1_WIDTH 16
#define TIM_TPWM_PERIOD1_PER1_LSB 0
#define TIM_TPWM_PERIOD1_PER1_MASK 0xffff
#define TIM_TPWM_PERIOD1_PER1_RESET 0xffff

// TPWM_period1.PER2 - Period value for PWM2
#define TIM_TPWM_PERIOD1_PER2_WIDTH 16
#define TIM_TPWM_PERIOD1_PER2_LSB 16
#define TIM_TPWM_PERIOD1_PER2_MASK 0xffff0000
#define TIM_TPWM_PERIOD1_PER2_RESET 0xffff

// TPWM_period2 - PWM3 and PWM4 period register
#define TIM_TPWM_PERIOD2_ADDR 0x24
#define TIM_TPWM_PERIOD2_RESET 0xffffffff
typedef struct {
    uint32_t PER3 : 16; // Period value for PWM3
    uint32_t PER4 : 16; // Period value for PWM4
} tim_tpwm_period2_t;

// TPWM_period2.PER3 - Period value for PWM3
#define TIM_TPWM_PERIOD2_PER3_WIDTH 16
#define TIM_TPWM_PERIOD2_PER3_LSB 0
#define TIM_TPWM_PERIOD2_PER3_MASK 0xffff
#define TIM_TPWM_PERIOD2_PER3_RESET 0xffff

// TPWM_period2.PER4 - Period value for PWM4
#define TIM_TPWM_PERIOD2_PER4_WIDTH 16
#define TIM_TPWM_PERIOD2_PER4_LSB 16
#define TIM_TPWM_PERIOD2_PER4_MASK 0xffff0000
#define TIM_TPWM_PERIOD2_PER4_RESET 0xffff

// TPWM_compare1 - Compare values for PWM1 and PWM2
#define TIM_TPWM_COMPARE1_ADDR 0x28
#define TIM_TPWM_COMPARE1_RESET 0xffffffff
typedef struct {
    uint32_t CP1 : 16; // Compare value for PWM1
    uint32_t CP2 : 16; // Compare value for PWM2
} tim_tpwm_compare1_t;

// TPWM_compare1.CP1 - Compare value for PWM1
#define TIM_TPWM_COMPARE1_CP1_WIDTH 16
#define TIM_TPWM_COMPARE1_CP1_LSB 0
#define TIM_TPWM_COMPARE1_CP1_MASK 0xffff
#define TIM_TPWM_COMPARE1_CP1_RESET 0xffff

// TPWM_compare1.CP2 - Compare value for PWM2
#define TIM_TPWM_COMPARE1_CP2_WIDTH 16
#define TIM_TPWM_COMPARE1_CP2_LSB 16
#define TIM_TPWM_COMPARE1_CP2_MASK 0xffff0000
#define TIM_TPWM_COMPARE1_CP2_RESET 0xffff

// TPWM_compare2 - Compare values for PWM3 and PWM4
#define TIM_TPWM_COMPARE2_ADDR 0x2c
#define TIM_TPWM_COMPARE2_RESET 0xffffffff
typedef struct {
    uint32_t CP3 : 16; // Compare value for PWM3
    uint32_t CP4 : 16; // Compare value for PWM4
} tim_tpwm_compare2_t;

// TPWM_compare2.CP3 - Compare value for PWM3
#define TIM_TPWM_COMPARE2_CP3_WIDTH 16
#define TIM_TPWM_COMPARE2_CP3_LSB 0
#define TIM_TPWM_COMPARE2_CP3_MASK 0xffff
#define TIM_TPWM_COMPARE2_CP3_RESET 0xffff

// TPWM_compare2.CP4 - Compare value for PWM4
#define TIM_TPWM_COMPARE2_CP4_WIDTH 16
#define TIM_TPWM_COMPARE2_CP4_LSB 16
#define TIM_TPWM_COMPARE2_CP4_MASK 0xffff0000
#define TIM_TPWM_COMPARE2_CP4_RESET 0xffff

// TPWM_counter1 - PWM counters for PWM1 and PWM2
#define TIM_TPWM_COUNTER1_ADDR 0x30
#define TIM_TPWM_COUNTER1_RESET 0x0
typedef struct {
    uint32_t CNT1 : 16; // Current counter value for PWM1
    uint32_t CNT2 : 16; // Current counter value for PWM2
} tim_tpwm_counter1_t;

// TPWM_counter1.CNT1 - Current counter value for PWM1
#define TIM_TPWM_COUNTER1_CNT1_WIDTH 16
#define TIM_TPWM_COUNTER1_CNT1_LSB 0
#define TIM_TPWM_COUNTER1_CNT1_MASK 0xffff
#define TIM_TPWM_COUNTER1_CNT1_RESET 0x0

// TPWM_counter1.CNT2 - Current counter value for PWM2
#define TIM_TPWM_COUNTER1_CNT2_WIDTH 16
#define TIM_TPWM_COUNTER1_CNT2_LSB 16
#define TIM_TPWM_COUNTER1_CNT2_MASK 0xffff0000
#define TIM_TPWM_COUNTER1_CNT2_RESET 0x0

// TPWM_counter2 - PWM counters for PWM3 and PWM4
#define TIM_TPWM_COUNTER2_ADDR 0x34
#define TIM_TPWM_COUNTER2_RESET 0x0
typedef struct {
    uint32_t CNT3 : 16; // Current counter value for PWM3
    uint32_t CNT4 : 16; // Current counter value for PWM4
} tim_tpwm_counter2_t;

// TPWM_counter2.CNT3 - Current counter value for PWM3
#define TIM_TPWM_COUNTER2_CNT3_WIDTH 16
#define TIM_TPWM_COUNTER2_CNT3_LSB 0
#define TIM_TPWM_COUNTER2_CNT3_MASK 0xffff
#define TIM_TPWM_COUNTER2_CNT3_RESET 0x0

// TPWM_counter2.CNT4 - Current counter value for PWM4
#define TIM_TPWM_COUNTER2_CNT4_WIDTH 16
#define TIM_TPWM_COUNTER2_CNT4_LSB 16
#define TIM_TPWM_COUNTER2_CNT4_MASK 0xffff0000
#define TIM_TPWM_COUNTER2_CNT4_RESET 0x0


// Register map structure
typedef struct {
    union {
        __O uint32_t TIM_CONFIG; // Timer configuration register
        __O tim_tim_config_t TIM_CONFIG_bf; // Bit access for TIM_CONFIG register
    };
    union {
        __O uint32_t TIM_PRESCALER; // Prescaler register (divides input clock)
        __O tim_tim_prescaler_t TIM_PRESCALER_bf; // Bit access for TIM_PRESCALER register
    };
    union {
        __O uint32_t TIM_PERIOD; // Timer period register
        __O tim_tim_period_t TIM_PERIOD_bf; // Bit access for TIM_PERIOD register
    };
    union {
        __I uint32_t TIM_COUNTER; // Current counter value
        __I tim_tim_counter_t TIM_COUNTER_bf; // Bit access for TIM_COUNTER register
    };
    union {
        __I uint32_t TIM_STATUS; // Timer status register
        __I tim_tim_status_t TIM_STATUS_bf; // Bit access for TIM_STATUS register
    };
    union {
        __O uint32_t TIM_LOAD; // Value to load into counter
        __O tim_tim_load_t TIM_LOAD_bf; // Bit access for TIM_LOAD register
    };
    union {
        __IO uint32_t TPWM_CONFIG; // PWM configuration register
        __IO tim_tpwm_config_t TPWM_CONFIG_bf; // Bit access for TPWM_CONFIG register
    };
    union {
        __IO uint32_t TPWM_PRESCALER; // PWM clock divider
        __IO tim_tpwm_prescaler_t TPWM_PRESCALER_bf; // Bit access for TPWM_PRESCALER register
    };
    union {
        __IO uint32_t TPWM_PERIOD1; // PWM1 and PWM2 period register
        __IO tim_tpwm_period1_t TPWM_PERIOD1_bf; // Bit access for TPWM_PERIOD1 register
    };
    union {
        __IO uint32_t TPWM_PERIOD2; // PWM3 and PWM4 period register
        __IO tim_tpwm_period2_t TPWM_PERIOD2_bf; // Bit access for TPWM_PERIOD2 register
    };
    union {
        __IO uint32_t TPWM_COMPARE1; // Compare values for PWM1 and PWM2
        __IO tim_tpwm_compare1_t TPWM_COMPARE1_bf; // Bit access for TPWM_COMPARE1 register
    };
    union {
        __IO uint32_t TPWM_COMPARE2; // Compare values for PWM3 and PWM4
        __IO tim_tpwm_compare2_t TPWM_COMPARE2_bf; // Bit access for TPWM_COMPARE2 register
    };
    union {
        __I uint32_t TPWM_COUNTER1; // PWM counters for PWM1 and PWM2
        __I tim_tpwm_counter1_t TPWM_COUNTER1_bf; // Bit access for TPWM_COUNTER1 register
    };
    union {
        __I uint32_t TPWM_COUNTER2; // PWM counters for PWM3 and PWM4
        __I tim_tpwm_counter2_t TPWM_COUNTER2_bf; // Bit access for TPWM_COUNTER2 register
    };
} tim_t;

#define TIM ((tim_t*)(TIM_BASE_ADDR))

#ifdef __cplusplus
}
#endif

#endif /* __REGS_TIMER_H */
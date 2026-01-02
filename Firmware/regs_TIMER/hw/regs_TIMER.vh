// Created with Corsair v1.0.4

`ifndef __REGS_TIMER_VH
`define __REGS_TIMER_VH

`define TIM_BASE_ADDR 2147483648
`define TIM_DATA_WIDTH 32
`define TIM_ADDR_WIDTH 32

// Tim_config - Timer configuration register
`define TIM_TIM_CONFIG_ADDR 32'h0
`define TIM_TIM_CONFIG_RESET 32'h2

// Tim_config.EN - Enable timer
`define TIM_TIM_CONFIG_EN_WIDTH 1
`define TIM_TIM_CONFIG_EN_LSB 0
`define TIM_TIM_CONFIG_EN_MASK 32'h0
`define TIM_TIM_CONFIG_EN_RESET 1'h0

// Tim_config.AR - Auto reload when reaching period
`define TIM_TIM_CONFIG_AR_WIDTH 1
`define TIM_TIM_CONFIG_AR_LSB 1
`define TIM_TIM_CONFIG_AR_MASK 32'h0
`define TIM_TIM_CONFIG_AR_RESET 1'h1

// Tim_config.DIR - Count direction (0 = up, 1 = down)
`define TIM_TIM_CONFIG_DIR_WIDTH 1
`define TIM_TIM_CONFIG_DIR_LSB 4
`define TIM_TIM_CONFIG_DIR_MASK 32'h0
`define TIM_TIM_CONFIG_DIR_RESET 1'h0

// Tim_config.UD - Update counter with load value
`define TIM_TIM_CONFIG_UD_WIDTH 1
`define TIM_TIM_CONFIG_UD_LSB 5
`define TIM_TIM_CONFIG_UD_MASK 32'h0
`define TIM_TIM_CONFIG_UD_RESET 1'h0


// Tim_prescaler - Prescaler register (divides input clock)
`define TIM_TIM_PRESCALER_ADDR 32'h4
`define TIM_TIM_PRESCALER_RESET 32'h1b

// Tim_prescaler.DIV - Clock divider value
`define TIM_TIM_PRESCALER_DIV_WIDTH 32
`define TIM_TIM_PRESCALER_DIV_LSB 0
`define TIM_TIM_PRESCALER_DIV_MASK 32'h4
`define TIM_TIM_PRESCALER_DIV_RESET 32'h1b


// Tim_period - Timer period register
`define TIM_TIM_PERIOD_ADDR 32'h8
`define TIM_TIM_PERIOD_RESET 32'hffff

// Tim_period.PER - Counter max value
`define TIM_TIM_PERIOD_PER_WIDTH 32
`define TIM_TIM_PERIOD_PER_LSB 0
`define TIM_TIM_PERIOD_PER_MASK 32'h8
`define TIM_TIM_PERIOD_PER_RESET 32'hffff


// Tim_counter - Current counter value
`define TIM_TIM_COUNTER_ADDR 32'hc
`define TIM_TIM_COUNTER_RESET 32'h0

// Tim_counter.CNT - Counter current count
`define TIM_TIM_COUNTER_CNT_WIDTH 32
`define TIM_TIM_COUNTER_CNT_LSB 0
`define TIM_TIM_COUNTER_CNT_MASK 32'hc
`define TIM_TIM_COUNTER_CNT_RESET 32'h0


// Tim_status - Timer status register
`define TIM_TIM_STATUS_ADDR 32'h10
`define TIM_TIM_STATUS_RESET 32'h0

// Tim_status.OF - Overflow flag
`define TIM_TIM_STATUS_OF_WIDTH 1
`define TIM_TIM_STATUS_OF_LSB 0
`define TIM_TIM_STATUS_OF_MASK 32'h10
`define TIM_TIM_STATUS_OF_RESET 1'h0

// Tim_status.OP - Over period flag
`define TIM_TIM_STATUS_OP_WIDTH 1
`define TIM_TIM_STATUS_OP_LSB 1
`define TIM_TIM_STATUS_OP_MASK 32'h10
`define TIM_TIM_STATUS_OP_RESET 1'h0

// Tim_status.ERR - Error flag
`define TIM_TIM_STATUS_ERR_WIDTH 1
`define TIM_TIM_STATUS_ERR_LSB 2
`define TIM_TIM_STATUS_ERR_MASK 32'h10
`define TIM_TIM_STATUS_ERR_RESET 1'h0

// Tim_status.LD - Load done flag
`define TIM_TIM_STATUS_LD_WIDTH 1
`define TIM_TIM_STATUS_LD_LSB 3
`define TIM_TIM_STATUS_LD_MASK 32'h10
`define TIM_TIM_STATUS_LD_RESET 1'h0


// Tim_load - Value to load into counter
`define TIM_TIM_LOAD_ADDR 32'h14
`define TIM_TIM_LOAD_RESET 32'h0

// Tim_load.LOAD - Counter load value
`define TIM_TIM_LOAD_LOAD_WIDTH 32
`define TIM_TIM_LOAD_LOAD_LSB 0
`define TIM_TIM_LOAD_LOAD_MASK 32'h14
`define TIM_TIM_LOAD_LOAD_RESET 32'h0


// TPWM_config - PWM configuration register
`define TIM_TPWM_CONFIG_ADDR 32'h18
`define TIM_TPWM_CONFIG_RESET 32'h0

// TPWM_config.EN - Enable PWM/CAPTURE operation
`define TIM_TPWM_CONFIG_EN_WIDTH 1
`define TIM_TPWM_CONFIG_EN_LSB 0
`define TIM_TPWM_CONFIG_EN_MASK 32'h18
`define TIM_TPWM_CONFIG_EN_RESET 1'h0

// TPWM_config.SEL1 - Output selection for PWM1
`define TIM_TPWM_CONFIG_SEL1_WIDTH 2
`define TIM_TPWM_CONFIG_SEL1_LSB 1
`define TIM_TPWM_CONFIG_SEL1_MASK 32'h18
`define TIM_TPWM_CONFIG_SEL1_RESET 2'h0

// TPWM_config.SEL2 - Output selection for PWM2
`define TIM_TPWM_CONFIG_SEL2_WIDTH 2
`define TIM_TPWM_CONFIG_SEL2_LSB 3
`define TIM_TPWM_CONFIG_SEL2_MASK 32'h18
`define TIM_TPWM_CONFIG_SEL2_RESET 2'h0

// TPWM_config.MODE - mode CAPTURE or PWM
`define TIM_TPWM_CONFIG_MODE_WIDTH 1
`define TIM_TPWM_CONFIG_MODE_LSB 5
`define TIM_TPWM_CONFIG_MODE_MASK 32'h18
`define TIM_TPWM_CONFIG_MODE_RESET 1'h0

// TPWM_config.SEL3 - Output selection for PWM3
`define TIM_TPWM_CONFIG_SEL3_WIDTH 2
`define TIM_TPWM_CONFIG_SEL3_LSB 7
`define TIM_TPWM_CONFIG_SEL3_MASK 32'h18
`define TIM_TPWM_CONFIG_SEL3_RESET 2'h0

// TPWM_config.SEL4 - Output selection for PWM4
`define TIM_TPWM_CONFIG_SEL4_WIDTH 2
`define TIM_TPWM_CONFIG_SEL4_LSB 9
`define TIM_TPWM_CONFIG_SEL4_MASK 32'h18
`define TIM_TPWM_CONFIG_SEL4_RESET 2'h0

// TPWM_config.NUM - Number of PWM signals selected
`define TIM_TPWM_CONFIG_NUM_WIDTH 3
`define TIM_TPWM_CONFIG_NUM_LSB 11
`define TIM_TPWM_CONFIG_NUM_MASK 32'h18
`define TIM_TPWM_CONFIG_NUM_RESET 3'h0

// TPWM_config.POL - Polarity of the PWM signal
`define TIM_TPWM_CONFIG_POL_WIDTH 1
`define TIM_TPWM_CONFIG_POL_LSB 14
`define TIM_TPWM_CONFIG_POL_MASK 32'h18
`define TIM_TPWM_CONFIG_POL_RESET 1'h0


// TPWM_prescaler - PWM clock divider
`define TIM_TPWM_PRESCALER_ADDR 32'h1c
`define TIM_TPWM_PRESCALER_RESET 32'h1b

// TPWM_prescaler.DIV - Clock divider value for PWM
`define TIM_TPWM_PRESCALER_DIV_WIDTH 32
`define TIM_TPWM_PRESCALER_DIV_LSB 0
`define TIM_TPWM_PRESCALER_DIV_MASK 32'h1c
`define TIM_TPWM_PRESCALER_DIV_RESET 32'h1b


// TPWM_period1 - PWM1 and PWM2 period register
`define TIM_TPWM_PERIOD1_ADDR 32'h20
`define TIM_TPWM_PERIOD1_RESET 32'hffffffff

// TPWM_period1.PER1 - Period value for PWM1
`define TIM_TPWM_PERIOD1_PER1_WIDTH 16
`define TIM_TPWM_PERIOD1_PER1_LSB 0
`define TIM_TPWM_PERIOD1_PER1_MASK 32'h20
`define TIM_TPWM_PERIOD1_PER1_RESET 16'hffff

// TPWM_period1.PER2 - Period value for PWM2
`define TIM_TPWM_PERIOD1_PER2_WIDTH 16
`define TIM_TPWM_PERIOD1_PER2_LSB 16
`define TIM_TPWM_PERIOD1_PER2_MASK 32'h20
`define TIM_TPWM_PERIOD1_PER2_RESET 16'hffff


// TPWM_period2 - PWM3 and PWM4 period register
`define TIM_TPWM_PERIOD2_ADDR 32'h24
`define TIM_TPWM_PERIOD2_RESET 32'hffffffff

// TPWM_period2.PER3 - Period value for PWM3
`define TIM_TPWM_PERIOD2_PER3_WIDTH 16
`define TIM_TPWM_PERIOD2_PER3_LSB 0
`define TIM_TPWM_PERIOD2_PER3_MASK 32'h24
`define TIM_TPWM_PERIOD2_PER3_RESET 16'hffff

// TPWM_period2.PER4 - Period value for PWM4
`define TIM_TPWM_PERIOD2_PER4_WIDTH 16
`define TIM_TPWM_PERIOD2_PER4_LSB 16
`define TIM_TPWM_PERIOD2_PER4_MASK 32'h24
`define TIM_TPWM_PERIOD2_PER4_RESET 16'hffff


// TPWM_compare1 - Compare values for PWM1 and PWM2
`define TIM_TPWM_COMPARE1_ADDR 32'h28
`define TIM_TPWM_COMPARE1_RESET 32'hffffffff

// TPWM_compare1.CP1 - Compare value for PWM1
`define TIM_TPWM_COMPARE1_CP1_WIDTH 16
`define TIM_TPWM_COMPARE1_CP1_LSB 0
`define TIM_TPWM_COMPARE1_CP1_MASK 32'h28
`define TIM_TPWM_COMPARE1_CP1_RESET 16'hffff

// TPWM_compare1.CP2 - Compare value for PWM2
`define TIM_TPWM_COMPARE1_CP2_WIDTH 16
`define TIM_TPWM_COMPARE1_CP2_LSB 16
`define TIM_TPWM_COMPARE1_CP2_MASK 32'h28
`define TIM_TPWM_COMPARE1_CP2_RESET 16'hffff


// TPWM_compare2 - Compare values for PWM3 and PWM4
`define TIM_TPWM_COMPARE2_ADDR 32'h2c
`define TIM_TPWM_COMPARE2_RESET 32'hffffffff

// TPWM_compare2.CP3 - Compare value for PWM3
`define TIM_TPWM_COMPARE2_CP3_WIDTH 16
`define TIM_TPWM_COMPARE2_CP3_LSB 0
`define TIM_TPWM_COMPARE2_CP3_MASK 32'h2c
`define TIM_TPWM_COMPARE2_CP3_RESET 16'hffff

// TPWM_compare2.CP4 - Compare value for PWM4
`define TIM_TPWM_COMPARE2_CP4_WIDTH 16
`define TIM_TPWM_COMPARE2_CP4_LSB 16
`define TIM_TPWM_COMPARE2_CP4_MASK 32'h2c
`define TIM_TPWM_COMPARE2_CP4_RESET 16'hffff


// TPWM_counter1 - PWM counters for PWM1 and PWM2
`define TIM_TPWM_COUNTER1_ADDR 32'h30
`define TIM_TPWM_COUNTER1_RESET 32'h0

// TPWM_counter1.CNT1 - Current counter value for PWM1
`define TIM_TPWM_COUNTER1_CNT1_WIDTH 16
`define TIM_TPWM_COUNTER1_CNT1_LSB 0
`define TIM_TPWM_COUNTER1_CNT1_MASK 32'h30
`define TIM_TPWM_COUNTER1_CNT1_RESET 16'h0

// TPWM_counter1.CNT2 - Current counter value for PWM2
`define TIM_TPWM_COUNTER1_CNT2_WIDTH 16
`define TIM_TPWM_COUNTER1_CNT2_LSB 16
`define TIM_TPWM_COUNTER1_CNT2_MASK 32'h30
`define TIM_TPWM_COUNTER1_CNT2_RESET 16'h0


// TPWM_counter2 - PWM counters for PWM3 and PWM4
`define TIM_TPWM_COUNTER2_ADDR 32'h34
`define TIM_TPWM_COUNTER2_RESET 32'h0

// TPWM_counter2.CNT3 - Current counter value for PWM3
`define TIM_TPWM_COUNTER2_CNT3_WIDTH 16
`define TIM_TPWM_COUNTER2_CNT3_LSB 0
`define TIM_TPWM_COUNTER2_CNT3_MASK 32'h34
`define TIM_TPWM_COUNTER2_CNT3_RESET 16'h0

// TPWM_counter2.CNT4 - Current counter value for PWM4
`define TIM_TPWM_COUNTER2_CNT4_WIDTH 16
`define TIM_TPWM_COUNTER2_CNT4_LSB 16
`define TIM_TPWM_COUNTER2_CNT4_MASK 32'h34
`define TIM_TPWM_COUNTER2_CNT4_RESET 16'h0


`endif // __REGS_TIMER_VH
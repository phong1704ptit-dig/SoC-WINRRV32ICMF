// Created with Corsair v1.0.4

`ifndef __REGS_UART_VH
`define __REGS_UART_VH

`define UCSR_BASE_ADDR 0
`define UCSR_DATA_WIDTH 32
`define UCSR_ADDR_WIDTH 32

// U_DATA - UART Data register
`define UCSR_U_DATA_ADDR 32'h0
`define UCSR_U_DATA_RESET 32'h0

// U_DATA.DATA - Data To Send Via UART TX
`define UCSR_U_DATA_DATA_WIDTH 8
`define UCSR_U_DATA_DATA_LSB 0
`define UCSR_U_DATA_DATA_MASK 32'h0
`define UCSR_U_DATA_DATA_RESET 8'h0


// U_STAT - UART Status register
`define UCSR_U_STAT_ADDR 32'h4
`define UCSR_U_STAT_RESET 32'h20

// U_STAT.READY - UART is Ready
`define UCSR_U_STAT_READY_WIDTH 1
`define UCSR_U_STAT_READY_LSB 5
`define UCSR_U_STAT_READY_MASK 32'h4
`define UCSR_U_STAT_READY_RESET 1'h1

// U_STAT.TX_DONE - Done Transmitting The Last Char (8-bit)
`define UCSR_U_STAT_TX_DONE_WIDTH 1
`define UCSR_U_STAT_TX_DONE_LSB 13
`define UCSR_U_STAT_TX_DONE_MASK 32'h4
`define UCSR_U_STAT_TX_DONE_RESET 1'h0


// U_CTRL - UART Control register
`define UCSR_U_CTRL_ADDR 32'h8
`define UCSR_U_CTRL_RESET 32'h0

// U_CTRL.START - TX Begin Signal, Valid For Only One Cycle
`define UCSR_U_CTRL_START_WIDTH 1
`define UCSR_U_CTRL_START_LSB 9
`define UCSR_U_CTRL_START_MASK 32'h8
`define UCSR_U_CTRL_START_RESET 1'h0


`endif // __REGS_UART_VH
/*   
    DTP D21DT166
    module uart ip
    kết nối các module 
    với thanh ghi uart
*/

module uart_ip #(
    parameter ADDR_W = 32,
    parameter DATA_W = 32,
    parameter STRB_W = DATA_W / 8
)(
    // System
    input           PCLK,
    input           PRESETn,

    // APB
    input   [31:0]  PADDR,
    input           PWRITE,
    input   [31:0]  PWDATA,
    input   [ 3:0]  PSTRB,
    input           PSEL,
    input           PENABLE,
    output  [31:0]  PRDATA,
    output          PREADY,
    output          PSLVERR,

    output          irqs1_rxuart,
    output          irqs2_txuart,

    // UART TX RX
    output          o_uart_tx,
    input           i_uart_rx
);

    // --------------------------------------------------
    // Wires between regs_UART and UART
    // --------------------------------------------------
    wire        csr_en;
    wire        csr_strtx;
    wire [3:0]  csr_br;
    reg  [3:0]  csr_br_ff = 4'b1111;
    wire [7:0]  csr_tx_data;

    wire        uart_busy;
    wire        uart_rxne;    
    wire [7:0]  uart_rx_data; 
    wire        tick;
    wire        tx_done_tick;
    wire        rx_done_tick;

    assign      irqs1_rxuart = rx_done_tick;
    assign      irqs2_txuart = 0;

    // --------------------------------------------------
    // Instantiation: register interface
    // --------------------------------------------------
    regs_UART #(
        .ADDR_W (ADDR_W),
        .DATA_W (DATA_W),
        .STRB_W (STRB_W)
    ) regs_uart (
        .clk                    (PCLK),
        .rst                    (!PRESETn),

        // CTRL outputs
        .csr_u_ctrl_en_out      (csr_en),
        .csr_u_ctrl_strtx_out   (csr_strtx),
        .csr_u_ctrl_br_out      (csr_br),

        // STAT inputs
        .csr_u_stat_tbusy_in    (uart_busy),
        .csr_u_stat_rxne_in     (uart_rxne),

        // TXDATA
        .csr_u_txdata_data_out  (csr_tx_data),

        // RXDATA 
        .csr_u_rxdata_data_in   (uart_rx_data),

        // APB
        .psel           (PSEL),
        .paddr          (PADDR),
        .penable        (PENABLE),
        .pwrite         (PWRITE),
        .pwdata         (PWDATA),
        .pstrb          (PSTRB),
        .prdata         (PRDATA),
        .pready         (PREADY),
        .pslverr        (PSLVERR)
    );

    // --------------------------------------------------
    // Instantiation: UART transmitter
    // --------------------------------------------------
always @(posedge PCLK) csr_br_ff <= csr_br;


    // Baud generator
    baud_gen #(
        .CLK_FREQ(80_000_000)
    ) baud_gen_unit (
        .clk(PCLK),
        .baud_rate(csr_br_ff),
        .rst_n(PRESETn),
        .tick(tick)
    );

    // UART RX
    uart_rx #(
        .DBIT(8),
        .SB_TICK(16)
    ) uart_rx_unit (
        .clk(PCLK),
        .rst_n(PRESETn),
        .rx(i_uart_rx),
        .s_tick(tick),
        .rx_ne(uart_rxne),
        .rx_done_tick(rx_done_tick),
        .dout(uart_rx_data)
    );

    // UART TX
    uart_tx #(
        .DBIT(8),
        .SB_TICK(16)
    ) uart_tx_unit (
        .clk(PCLK),
        .rst_n(PRESETn),
        .tx_start(csr_strtx),
        .s_tick(tick),
        .din(csr_tx_data),
        .tx_done_tick(tx_done_tick),
        .tx_busy(uart_busy),
        .tx(o_uart_tx)
    );

endmodule

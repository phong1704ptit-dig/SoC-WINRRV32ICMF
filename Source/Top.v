`include "Define.vh"


module Top_module(
    input           clk,
    input           rst,

    inout   [15:0 ] GPIO_x,

    input           BOOT0,
    input           BOOT1,

    input           uart_rx,
    output          uart_tx,

    input           MISO,           //Ngo?i vi SPI
    output          MOSI,
    inout           SCLK,
    output          SSS,
    output          SS,

    output  [ 3:0 ] PWM,            //Ngo?i vi TPWM

    inout           scl,
    inout           sda
);
    wire [15:0] sss; assign SS = sss[0];

wire    clksys;// = clk;
reg     rstsys_ff1 = 0;
reg     rstsys_ff2 = 0;
reg     rstsys_ff3 = 0;
reg     rstsys_ff4 = 0;
always @(posedge clksys) begin
    rstsys_ff1 <= rst;
    rstsys_ff2 <= rstsys_ff1;
    rstsys_ff3 <= rstsys_ff2;
    rstsys_ff4 <= rstsys_ff3 && rstsys_ff2 && rstsys_ff1 && rst;
end

wire    uart_txip;
reg     uart_tx_ff1 = 0;
reg     uart_tx_ff2 = 0;
reg     uart_tx_ff3 = 0;
reg     uart_tx_ff4 = 0;
assign  uart_tx = uart_tx_ff4;
always @(posedge clksys) begin
    uart_tx_ff1 <= uart_txip;
    uart_tx_ff2 <= uart_tx_ff1;
    uart_tx_ff3 <= uart_tx_ff2;
    uart_tx_ff4 <= uart_tx_ff3;
end

reg     uart_rx_ff1 = 1;
reg     uart_rx_ff2 = 1;
reg     uart_rx_ff3 = 1;
reg     uart_rx_ff4 = 1;
always @(posedge clksys) begin
    uart_rx_ff1 <= uart_rx;
    uart_rx_ff2 <= uart_rx_ff1;
    uart_rx_ff3 <= uart_rx_ff2;
    uart_rx_ff4 <= uart_rx_ff3;
end


//    Gowin_CLKDIV your_instance_name(
//        .clkout(clksys), //output clkout
//        .hclkin(clk), //input hclkin
//        .resetn(rst) //input resetn
//    );

//    Genclk_10M clk10M(
//        .clkin(clk),
//        .clkout(clksys)
//    );

//    Genclk_100M clk100M(
//        .clk_in(clk),
//        .clk_out(clksys)
//    );

    Genclk_80M clk80M(
        .clk_in(clk),
        .clk_out(clksys)
    );

//    Genclk_150M clk150M(
//        .clkin(clk),
//        .clkout(clksys)
//    );

//    Genclk_25M clk25M(
//        .clk_in(clk),
//        .clk_out(clksys)
//    );

//    Genclk_10M clk10M(
//        .clk_in(clk),
//        .clk_out(clksys)
//    );
wire    [31:0 ] peri_addr;
wire    [31:0 ] peri_wdata;
wire    [ 3:0 ] peri_wmask;
wire    [31:0 ] peri_rdata;
wire            peri_wen;
wire            peri_ren;

reg     [31:0 ] peri_rdatafn;

wire            s9_sel_spi;
wire            s8_sel_timer;
wire            s6_sel_uart;
wire            s5_sel_i2c;
wire            s4_sel_gpio;
wire            s3_sel_plic;

wire    [31:0 ] rdata_spi;
wire            pready_spi;
wire            pslverr_spi;

wire    [31:0 ] rdata_uart;
wire            pready_uart;
wire            pslverr_uart;

wire    [31:0 ] rdata_timer;
wire            pready_timer;
wire            pslverr_timer;

wire    [31:0 ] rdata_i2c;
wire            pready_i2c;
wire            pslverr_i2c;

wire    [ 2:0 ] peri_burst;
wire    [ 1:0 ] peri_htrans;
wire            peri_err;
wire            peri_rvalid;
wire            peri_wdone;

reg             peri_rvalidfn;
reg             peri_wdonefn;

wire    [ 3:0 ] HWSTRB;
wire            HCLK = clksys;
wire    [31:0 ] HADDR;
wire    [ 1:0 ] HTRANS;
wire            HWRITE;
wire    [ 2:0 ] HSIZE;
wire    [ 2:0 ] HBURST;
wire    [ 3:0 ] HPROT;
wire            HMASTLOCK;
wire    [31:0 ] HWDATA;
wire    [31:0 ] HRDATA;
wire            HREADY;
wire            HRESP;

wire            PCLK;
wire            PSEL;
wire    [31:0 ] PADDR;
wire            PWRITE;
wire    [31:0 ] PWDATA;
wire    [31:0 ] PWDATAT;
wire    [ 3:0 ] PSTRB;
wire            PENABLE;
reg     [31:0 ] PRDATA; 
reg             PREADY;
reg             PSLVERR;

wire            irq_out;
wire    [ 5:0 ] claim_id;
wire            irq_external_pending;
wire            trap_en;

wire    [31:0 ] rdata_plic;
wire            pready_plic;
wire            pslverr_plic; 

wire    [31:0 ] rdata_gpio;
wire            pready_gpio;
wire            pslverr_gpio;

wire            irqs1_rxuart;  
wire            irqs2_txuart;  
wire    [15:0 ] irqsx_gpio_pedge;
wire    [15:0 ] irqsx_gpio_nedge;   
wire            irqs1_rxi2c;
wire            irqs2_txi2c;
wire            irqs3_erri2c;
wire            irqs4_ndi2c;
wire            irqs1_rxspi;
wire            irqs2_txspi;

    always @(*) begin
        case({s9_sel_spi, s8_sel_timer, s6_sel_uart, s5_sel_i2c, s4_sel_gpio, s3_sel_plic})
            6'b000001: PRDATA = rdata_plic;
            6'b000010: PRDATA = rdata_gpio;
            6'b000100: PRDATA = rdata_i2c;
            6'b001000: PRDATA = rdata_uart;
            6'b010000: PRDATA = rdata_timer;
            6'b100000: PRDATA = rdata_spi;
            default:   PRDATA = 32'h0;
        endcase
    end

    always @(*) begin
        case({s9_sel_spi, s8_sel_timer, s6_sel_uart, s5_sel_i2c, s4_sel_gpio, s3_sel_plic})
            6'b000001: PREADY = pready_plic;
            6'b000010: PREADY = pready_gpio;
            6'b000100: PREADY = pready_i2c;
            6'b001000: PREADY = pready_uart;
            6'b010000: PREADY = pready_timer;
            6'b100000: PREADY = pready_spi;
            default:   PREADY = 1'h0;
        endcase
    end

    always @(*) begin
        case({s9_sel_spi, s8_sel_timer, s6_sel_uart, s5_sel_i2c, s4_sel_gpio, s3_sel_plic})
            6'b000001: PSLVERR = pslverr_plic;
            6'b000010: PSLVERR = pslverr_gpio;
            6'b000100: PSLVERR = pslverr_i2c;
            6'b001000: PSLVERR = pslverr_uart;
            6'b010000: PSLVERR = pslverr_timer;
            6'b100000: PSLVERR = pslverr_spi;
            default:   PSLVERR = 1'h0;
        endcase
    end

    always @(*) begin
            peri_rvalidfn   = peri_rvalid;
            peri_wdonefn    = peri_wdone;
            peri_rdatafn    = peri_rdata;
    end


    


//////////////////////////////////////////////////////////////////////////////////////////////////
Device_select DS(
        .addr           (peri_addr),
        .s3_sel_plic    (s3_sel_plic),
        .s4_sel_gpio    (s4_sel_gpio),
        .s5_sel_i2c     (s5_sel_i2c),
        .s6_sel_uart    (s6_sel_uart),
        .s8_sel_timer   (s8_sel_timer),
        .s9_sel_spi     (s9_sel_spi)
);


/////////////////////////////////////////////////////////////////////////////////////////////////
RV32I_core Core_CPU(
        .clk            (clksys),    
        .rst            (rstsys_ff4),
        .peri_addr      (peri_addr),
        .peri_wdata     (peri_wdata),
        .peri_wmask     (peri_wmask),
        .peri_rdata     (peri_rdatafn),
        .peri_wen       (peri_wen),
        .peri_ren       (peri_ren),
        .peri_burst     (peri_burst),
        .peri_htrans    (peri_htrans),

        .peri_rvalid    (peri_rvalidfn),
        .peri_wdone     (peri_wdonefn),
        .peri_err       (peri_err),
    
        .irq_flag       (irq_out),
        .irq_external_pending(irq_external_pending),
        .trap_en        (trap_en)
//        .irq_claim_id   (claim_id)
);


///////////////////////////////////////////////////////////////////////////////////////////////////////////
ahb3lite_master_adapter CPU_to_AHB(
        .HCLK           (HCLK),
        .HRESETn        (rstsys_ff4),

        // Simple CPU/DMAC request interface
        .peri_addr      (peri_addr),
        .peri_wdata     (peri_wdata),
        .peri_wmask     (peri_wmask),     // 0000=read; otherwise write strobes
        .peri_wen       (peri_wen),
        .peri_ren       (peri_ren),
        .peri_burst     (peri_burst),
        .peri_htrans    (peri_htrans),

        // Read return (per beat)
        .peri_rvalid    (peri_rvalid),
        .peri_wdone     (peri_wdone),
        .peri_rdata     (peri_rdata),
        .peri_err       (peri_err),

        .PWDATAT        (PWDATAT),
        // AHB-Lite master bus
        .HWSTRB         (HWSTRB),
        .HADDR          (HADDR),
        .HTRANS         (HTRANS),
        .HWRITE         (HWRITE),
        .HSIZE          (HSIZE),
        .HBURST         (HBURST),
//        .HPROT          (HPROT),           //Ch?a dùng
//        .HMASTLOCK      (HMASTLOCK),       //Ch?a dùng
        .HWDATA         (HWDATA),
        .HRDATA         (HRDATA),
        .HREADY         (HREADY),
        .HRESP          (HRESP)
);



////////////////////////////////////////////////////////////////////////////////////////////
ahb3lite_to_apb_bridge AHB_to_APB (
        .HCLK           (HCLK),
        .HRESETn        (rstsys_ff4),

        .PWDATAT        (PWDATAT),
        // AHB-Lite slave interface
        .HWSTRB         (HWSTRB),
        .HADDR          (HADDR),
        .HTRANS         (HTRANS),
        .HWRITE         (HWRITE),
        .HBURST         (HBURST),
        .HSIZE          (HSIZE),
        .HWDATA         (HWDATA),
        .HRDATA         (HRDATA),
        .HREADY         (HREADY),
        .HRESP          (HRESP),

        // APB master interface
        .PCLK           (PCLK),
        .PADDR          (PADDR),
        .PWRITE         (PWRITE),
        .PWDATA         (PWDATA),
        .PSTRB          (PSTRB),
        .PSEL           (PSEL),
        .PENABLE        (PENABLE),
        .PRDATA         (PRDATA),
        .PREADY         (PREADY),
        .PSLVERR        (PSLVERR)
);



/////////////////////////////////////////////////////////////////////////////////////////////
uart_ip uart_unit(
        .PCLK           (PCLK),
        .PRESETn        (rstsys_ff4),

        // APB
        .PSEL           (s6_sel_uart && PSEL),
        .PADDR          ({4'h0, PADDR[27:0]}),
        .PENABLE        (PENABLE),
        .PWRITE         (PWRITE),
        .PWDATA         (PWDATA),
        .PSTRB          (PSTRB),
        .PRDATA         (rdata_uart),
        .PREADY         (pready_uart),
        .PSLVERR        (pslverr_uart),

        .irqs1_rxuart   (irqs1_rxuart),
        .irqs2_txuart   (irqs2_txuart),

        .o_uart_tx  (uart_txip),
        .i_uart_rx  (uart_rx_ff1)
);


///////////////////////////////////////////////////////////////////////////////////////////
I2C_ip i2c_unit(
        .PCLK           (PCLK),
        .PRESETn        (rstsys_ff4),

//         
        .PSEL           (s5_sel_i2c && PSEL),
        .PADDR          ({4'h0, PADDR[27:0]}),
        .PENABLE        (PENABLE),
        .PWRITE         (PWRITE),
        .PWDATA         (PWDATA),
        .PSTRB          (PSTRB),
        .PRDATA         (rdata_i2c),
        .PREADY         (pready_i2c),
        .PSLVERR        (pslverr_i2c),

        .irqs1_rxi2c    (irqs1_rxi2c),
        .irqs2_txi2c    (irqs2_txi2c),
        .irqs3_erri2c   (irqs3_erri2c),
        .irqs4_ndi2c    (irqs4_ndi2c),

        .sda            (sda),
        .scl            (scl)
);




/////////////////////////////////////////////////////////////////////////////////////////////
PLIC_ip PLIC_unit(
        .PCLK           (PCLK),
        .PRESETn        (rstsys_ff4),

        .irqs1_rxuart   (irqs1_rxuart),             //Ng?t c?a UART
        .irqs2_txuart   (irqs2_txuart),

        .irqs3_pgpio0   (irqsx_gpio_pedge[0]),      //Ng?t c?a GPIO
        .irqs4_ngpio0   (irqsx_gpio_nedge[0]),

        .irqs5_pgpio1   (irqsx_gpio_pedge[1]),
        .irqs6_ngpio1   (irqsx_gpio_nedge[1]),

        .irqs7_pgpio2   (irqsx_gpio_pedge[2]),
        .irqs8_ngpio2   (irqsx_gpio_nedge[2]),

        .irqs9_pgpio3   (irqsx_gpio_pedge[3]),
        .irqs10_ngpio3  (irqsx_gpio_nedge[3]),

        .irqs11_pgpio4  (irqsx_gpio_pedge[4]),
        .irqs12_ngpio4  (irqsx_gpio_nedge[4]),

        .irqs13_pgpio5  (irqsx_gpio_pedge[5]),
        .irqs14_ngpio5  (irqsx_gpio_nedge[5]),

        .irqs15_pgpio6  (irqsx_gpio_pedge[6]),
        .irqs16_ngpio6  (irqsx_gpio_nedge[6]),

        .irqs17_pgpio7  (irqsx_gpio_pedge[7]),
        .irqs18_ngpio7  (irqsx_gpio_nedge[7]),

        .irqs19_pgpio8  (irqsx_gpio_pedge[8]),
        .irqs20_ngpio8  (irqsx_gpio_nedge[8]),

        .irqs21_pgpio9  (irqsx_gpio_pedge[9]),
        .irqs22_ngpio9  (irqsx_gpio_nedge[9]),

        .irqs23_pgpio10 (irqsx_gpio_pedge[10]),
        .irqs24_ngpio10 (irqsx_gpio_nedge[10]),

        .irqs25_pgpio11 (irqsx_gpio_pedge[11]),
        .irqs26_ngpio11 (irqsx_gpio_nedge[11]),

        .irqs27_pgpio12 (irqsx_gpio_pedge[12]),
        .irqs28_ngpio12 (irqsx_gpio_nedge[12]),

        .irqs29_pgpio13 (irqsx_gpio_pedge[13]),
        .irqs30_ngpio13 (irqsx_gpio_nedge[13]),

        .irqs31_pgpio14 (irqsx_gpio_pedge[14]),
        .irqs32_ngpio14 (irqsx_gpio_nedge[14]),

        .irqs33_pgpio15 (irqsx_gpio_pedge[15]),
        .irqs34_ngpio15 (irqsx_gpio_nedge[15]),

        .irqs35_rxi2c   (irqs1_rxi2c),
        .irqs36_txi2c   (irqs2_txi2c),
        .irqs37_erri2c  (irqs3_erri2c),
        .irqs38_ndi2c   (irqs4_ndi2c),

        .irqs39_rxspi   (irqs1_rxspi),
        .irqs40_txspi   (irqs2_txspi),     

        .irq_out        (irq_out),
        .irq_external_pending(irq_external_pending),
        .trap_en        (trap_en),

        .PSEL           (s3_sel_plic && PSEL),
        .PADDR          ({4'h0, PADDR[27:0]}),
        .PENABLE        (PENABLE),
        .PWRITE         (PWRITE),
        .PWDATA         (PWDATA),
        .PSTRB          (PSTRB),
        .PRDATA         (rdata_plic),
        .PREADY         (pready_plic),
        .PSLVERR        (pslverr_plic)
);


//////////////////////////////////////////////////////////////////////////////////////////////
gpio_ip gpio_unit(
        .PCLK           (PCLK),
        .PRESETn        (rstsys_ff4),

        // APB
        .PSEL           (s4_sel_gpio && PSEL),
        .PADDR          ({4'h0, PADDR[27:0]}),
        .PENABLE        (PENABLE),
        .PWRITE         (PWRITE),
        .PWDATA         (PWDATA),
        .PSTRB          (PSTRB),
        .PRDATA         (rdata_gpio),
        .PREADY         (pready_gpio),
        .PSLVERR        (pslverr_gpio),

        .irqsx_gpio_pedge(irqsx_gpio_pedge),
        .irqsx_gpio_nedge(irqsx_gpio_nedge),

        .GPIO_x         (GPIO_x)
);


////////////////////////////////////////////////////////////////////////////////////////////
//spi_ip #(
//        .ADDR_W(32),
//        .DATA_W(32),
//        .STRB_W(4)
//)SPI_unit (
//        .PCLK           (PCLK),
//        .PRESETn        (rstsys_ff4),

         
//        .PSEL           (s9_sel_spi && PSEL),
//        .PADDR          ({4'h0, PADDR[27:0]}),
//        .PENABLE        (PENABLE),
//        .PWRITE         (PWRITE),
//        .PWDATA         (PWDATA),
//        .PSTRB          (PSTRB),
//        .PRDATA         (rdata_spi),
//        .PREADY         (pready_spi),
//        .PSLVERR        (pslverr_spi),

//        .irqs1_rxspi    (irqs1_rxspi),
//        .irqs2_txspi    (irqs2_txspi),

//        .MISO_SPI       (MISO),
//        .MOSI_SPI       (MOSI),
//        .SCLK_SPI       (SCLK),
//        .SSS            (SSS),
//        .SS_SPI         (sss)
//    );

////////////////////////////////////////////////////////////////////////////////////////////
timer_ip #(
        .ADDR_W(32),
        .DATA_W(32),
        .STRB_W(4)
) timer_unit (
        .PCLK           (PCLK),
        .PRESETn        (rstsys_ff4),

         
        .PSEL           (s8_sel_timer && PSEL),
        .PADDR          ({4'h0, PADDR[27:0]}),
        .PENABLE        (PENABLE),
        .PWRITE         (PWRITE),
        .PWDATA         (PWDATA),
        .PSTRB          (PSTRB),
        .PRDATA         (rdata_timer),
        .PREADY         (pready_timer),
        .PSLVERR        (pslverr_timer),


        .signal_PWM1(PWM[0]),
        .signal_PWM2(PWM[1]),
        .signal_PWM3(PWM[2]),
        .signal_PWM4(PWM[3])
    );

endmodule

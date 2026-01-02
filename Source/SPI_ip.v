module spi_ip #(
    parameter ADDR_W = 32,
    parameter DATA_W = 32,
    parameter STRB_W = DATA_W / 8
)(
    input        PCLK,
    input        PRESETn,

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

    output          irqs2_txspi,
    output          irqs1_rxspi,

    // SPI Interface
    input  MISO_SPI,
    output MOSI_SPI,
    inout SCLK_SPI,
    output [15:0] SS_SPI,
    
    input SSS
);
//    assign MOSI_SPI = 1;
//    assign SCLK_SPI = 1;
//    assign SS_SPI = 0;

    // --- WIRE giữa regs và SPI_Master ---
    wire [5:0]  bpt;
    wire        cpol;
    wire        cpha;
    wire        enspi;
    wire        css;
    wire [3:0]  numss;
    wire        msb;
    wire        strx;
    wire [2:0]  clkselect;
    wire        mode; 
    
    wire        MOSI_MAS;
    wire        MISO_MAS;
    wire        SCLK_MAS;
    wire        MOSI_SLA;
    wire        MISO_SLA;

    wire [31:0] txdatal;
    wire [31:0] txdatah;
    wire [31:0] rxdatal;
    wire [31:0] rxdatah;

    wire        rxne;
    wire        txe;
    wire        err;
    wire        busy;

    wire        rxnes;
    wire        txes;
    wire        errs;
    wire        busys;

    regs_SPI regs_inst (
        .clk(PCLK),
        .rst(!PRESETn),

        .csr_spi_tx_low_data_low_out(txdatal),
        .csr_spi_tx_high_data_high_out(txdatah),

        .csr_spi_rx_low_data_in(rxdatal),
        .csr_spi_rx_high_data_in(rxdatah),

        .csr_control_reg_bpt_out(bpt),
        .csr_control_reg_cpol_out(cpol),
        .csr_control_reg_cpha_out(cpha),
        .csr_control_reg_enspi_out(enspi),
        .csr_control_reg_css_out(css),
        .csr_control_reg_numss_out(numss),
        .csr_control_reg_msb_out(msb),
        .csr_control_reg_strx_out(strx),
        .csr_control_reg_clks_out(clkselect),
        .csr_control_reg_mode_out(mode), // nếu cần dùng

        .csr_status_reg_rxne_in(rxne ),
        .csr_status_reg_txe_in(txe ),
        .csr_status_reg_err_in(err),
        .csr_status_reg_busy_in(busy ),


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

    SPI_Master spi_master_inst (
        .i_clk(PCLK),
        .i_rst(!PRESETn),

        .i_BPT_SPI(bpt),
        .i_CPOL_SPI(cpol),
        .i_CPHA_SPI(cpha),
        .i_EN_SPI(enspi && !mode),
        .i_CSS_SPI(css),
        .i_NUMSS_SPI(numss),
        .i_MSB_SPI(msb),
        .i_STRX_SPI(strx),
        .i_CLKS_SPI(clkselect),

        .i_TXDATAL_SPI(txdatal),
        .i_TXDATAH_SPI(txdatah),

        .o_TXE_SPI(txe),
        .o_RXNE_SPI(rxne),
        .o_ERR_SPI(err),
        .o_BUSY_SPI(busy),

        .o_RXDATAL_SPI(rxdatal),
        .o_RXDATAH_SPI(rxdatah),

        .MISO_SPI(MISO_MAS),
        .MOSI_SPI(MOSI_MAS),
        .SCLK_SPI(SCLK_SPI),
        .SS_SPI(SS_SPI)
    );

    SPI_Slave spi_slave_inst(
        .i_clk(PCLK),
        .i_rst(!PRESETn),
        .i_BPT_SPI(bpt),                    
        .i_CPOL_SPI(cpol),                   
        .i_CPHA_SPI(cpha),                   
        .i_EN_SPI(enspi & mode),                     
        .i_MSB_SPI(msb),                
  
        .i_TXDATAL_SPI(txdatal),             
        .i_TXDATAH_SPI(txdatah),            
    
        .o_TXE_SPI(txes),                   
        .o_RXNE_SPI(rxnes),               
        .o_ERR_SPI(errs),                    
        .o_BUSY_SPI(busys),                 

        .o_RXDATAL_SPI(),              
        .o_RXDATAH_SPI(),            


        .MISO_SPI(MISO_SLA),
        .MOSI_SPI(MOSI_SLA),
        .SCLK(SCLK_SPI),
        .SS_SPI(SSS)
);


    assign MISO_MAS = (!mode)?MISO_SPI:1'bz;
    assign MISO_SLA = (mode)?MISO_SPI:1'bz;
    assign MOSI_SPI = (!mode)?MOSI_MAS:MOSI_SLA;


endmodule

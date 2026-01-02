//DTB166 
//Module kết nối thanh ghi I2C với code chức năng


module I2C_ip #(
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

    output          irqs1_rxi2c,
    output          irqs2_txi2c,
    output          irqs3_erri2c,
    output          irqs4_ndi2c,
    
    // I2C Interface
    inout wire sda,
    inout wire scl
);
wire    MODE; 
wire    TS;
wire    sclrx, sdarx;
wire    scltx, sdatx;
assign  sda = (MODE)?sdarx:sdatx;
assign  scl = (MODE)?sclrx:scltx;

    ///////////////////////////////////////////////////////// I2C_CONTROL///////////////////////////////////////////////////////////////////
    wire [2:0] csr_i2c_control_clkmode;
    wire [2:0] csr_i2c_control_numbrx;
    wire [3:0] csr_i2c_control_dutyscl;
    wire csr_i2c_control_rse;
    wire [1:0] csr_i2c_control_lenadd;
    wire csr_i2c_control_en;
    wire csr_i2c_control_strx;
    wire csr_i2c_control_mode;
    wire [2:0] csr_i2c_control_numbtx;
    wire csr_i2c_control_rst;
    wire [4:0] csr_i2c_control_seml;
    
    ////////////////////////////////////////////////////////////// I2C_STATUS/////////////////////////////////////////////////////////////
    wire csr_i2c_status_slave_found;
    wire csr_i2c_status_txe;
    wire csr_i2c_status_txne;
    wire csr_i2c_status_rxe;
    wire csr_i2c_status_rxne;
    wire csr_i2c_status_err;
    wire csr_i2c_status_busy;
    wire csr_i2c_status_ts;
    wire csr_i2c_status_rs;
    
    ///////////////////////////////////////////////////////// I2C_SLAVE_ADDR//////////////////////////////////////////////////////////////////
    wire [9:0] csr_i2c_slave_addr_address;
    
    /////////////////////////////////////////////////////////// I2C_REG_ADDR////////////////////////////////////////////////////////////////////
    wire [7:0] csr_i2c_reg_addr_adds;
    
    ////////////////////////////////////////////////////////////// I2C_TX_DATA////////////////////////////////////////////////////////////////////
    wire [31:0] csr_i2c_tx_data_low_tx_data_low;
    wire [31:0] csr_i2c_tx_data_high_tx_data_high;
    
    ////////////////////////////////////////////////////////////// I2C_RX_DATA///////////////////////////////////////////////////////////////////////
    wire [31:0] csr_i2c_rx_data_low_rx_data_low;
    wire [31:0] csr_i2c_rx_data_high_rx_data_high;

    
    regs_I2C #(
        .ADDR_W(ADDR_W),
        .DATA_W(DATA_W),
        .STRB_W(STRB_W)
    ) u_regs (
        .clk(PCLK),
        .rst(PRESETn),
        
        // I2C_CONTROL
        .csr_i2c_control_clkmode_out    (csr_i2c_control_clkmode),
        .csr_i2c_control_numbrx_out     (csr_i2c_control_numbrx),
        .csr_i2c_control_dutyscl_out    (csr_i2c_control_dutyscl),
        .csr_i2c_control_rse_out        (csr_i2c_control_rse),
        .csr_i2c_control_lenadd_out     (csr_i2c_control_lenadd),
        .csr_i2c_control_en_out         (csr_i2c_control_en),
        .csr_i2c_control_strx_out       (csr_i2c_control_strx),
        .csr_i2c_control_mode_out       (csr_i2c_control_mode),
        .csr_i2c_control_numbtx_out     (csr_i2c_control_numbtx),
        .csr_i2c_control_rst_out        (csr_i2c_control_rst),
        .csr_i2c_control_seml_out       (csr_i2c_control_seml),
        
        // I2C_STATUS
        .csr_i2c_status_slave_found_in  (csr_i2c_status_slave_found),
        .csr_i2c_status_txe_in          (csr_i2c_status_txe),
        .csr_i2c_status_txne_in         (csr_i2c_status_txne),
        .csr_i2c_status_rxe_in          (csr_i2c_status_rxe),
        .csr_i2c_status_rxne_in         (csr_i2c_status_rxne),
        .csr_i2c_status_err_in          (csr_i2c_status_err),
        .csr_i2c_status_busy_in         (csr_i2c_status_busy),
        .csr_i2c_status_ts_in           (TS),
        .csr_i2c_status_rs_in           (csr_i2c_status_rs),
        
        // I2C_SLAVE_ADDR
        .csr_i2c_slave_addr_address_out (csr_i2c_slave_addr_address),
        
        // I2C_REG_ADDR
        .csr_i2c_reg_addr_adds_out      (csr_i2c_reg_addr_adds),
        
        // I2C_TX_DATA
        .csr_i2c_tx_data_low_tx_data_low_out(csr_i2c_tx_data_low_tx_data_low),
        .csr_i2c_tx_data_high_tx_data_high_out(csr_i2c_tx_data_high_tx_data_high),
        
        // I2C_RX_DATA
        .csr_i2c_rx_data_low_rx_data_low_in(csr_i2c_rx_data_low_rx_data_low),
        .csr_i2c_rx_data_high_rx_data_high_in(csr_i2c_rx_data_high_rx_data_high),
        
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



    localparam NONE = 0;
    localparam WRITE = 1'b0;
    localparam READ  = 1'b1;

    wire        clk_i2ctick;

/////////////////////////////////////CONTROL REGISTER////////////////////////////////////
    wire [2:0]  CLKMODE;            assign CLKMODE  =   csr_i2c_control_clkmode;
    wire [2:0]  NUMBRX;             assign NUMBRX   =   csr_i2c_control_numbrx;
    wire [3:0]  DUTYSCL;            assign DUTYSCL  =   csr_i2c_control_dutyscl;
    wire        RSE;                assign RSE      =   csr_i2c_control_rse;
    wire [1:0]  LENADD;             assign LENADD   =   csr_i2c_control_lenadd;
    wire        EN;                 assign EN       =   csr_i2c_control_en;
    wire        STRX;               assign STRX     =   csr_i2c_control_strx;
                                    assign MODE     =   csr_i2c_control_mode;
    wire [2:0]  NUMBTX;             assign NUMBTX   =   csr_i2c_control_numbtx;
    wire        RST;                assign RST       =  csr_i2c_control_rst;
    wire [4:0]  SEML;               assign SEML     =   csr_i2c_control_seml;
                                    


/////////////////////////////////////STATUS REGISTER/////////////////////////////////////
    wire        B2;
    wire        B1;                 assign csr_i2c_status_slave_found       =   B1;
    wire        TXE;                assign csr_i2c_status_txe               =   TXE;
    wire        TXNE;               assign csr_i2c_status_txne              =   TXNE;
    wire        RXE;                assign csr_i2c_status_rxe               =   1;
    wire        RXNE;               assign csr_i2c_status_rxne              =   0;
    wire        ERR1;
    wire        ERR2;               assign csr_i2c_status_err               =   0;//ERR1|ERR2;
    wire        BUSY1;
    wire        BUSY2;              assign csr_i2c_status_busy              =   BUSY1;
                                    assign csr_i2c_status_ts                =   TS;
    wire        RS;                 assign csr_i2c_status_rs                =   0;


//////////////////////////////////////ADDRESS SLAVE//////////////////////////////////////
    wire [31:0] ADDRES;             assign ADDRES           =   csr_i2c_slave_addr_address;    


//////////////////////////////////ADDRESS REGISTER SLAVE/////////////////////////////////
    wire [31:0] ADDS;               assign ADDS             =   csr_i2c_reg_addr_adds;

    
////////////////////////////////////TX DATA REGISTER/////////////////////////////////////
    wire [63:0] TX_DATA;            assign TX_DATA[31:0]    =       csr_i2c_tx_data_low_tx_data_low;
                                    assign TX_DATA[63:32]   =       csr_i2c_tx_data_high_tx_data_high;


////////////////////////////////////RX DATA REGISTER/////////////////////////////////////   
    wire [63:0] RX_DATA;            assign csr_i2c_rx_data_low_rx_data_low      =   0;
                                    assign csr_i2c_rx_data_high_rx_data_high    =   0;
    
    //assign RX_DATA = 1234;


    genclk_i2c #(        
        .CLK_FREQ(80_000_000)
    ) gentick_i2c(
                    .mode       (csr_i2c_control_clkmode),   //000-10KHz, 001-20KHz, 010-50KHz, 011-100KHz, 100-150KHz, 101-200KHz, 110-250KHz, 111-400KHz
                    .clkin      (PCLK), 
                    .rst        (PRESETn), 
                    .clk_i2ctick(clk_i2ctick)
    );

    I2C_Master_Tx uut (
                    .i_clk        (PCLK),
                    .i_clk_i2ctick(clk_i2ctick),
                    .i_rst_n      (PRESETn),
                    .i_res_en     (csr_i2c_control_rse),
                    .i_len_add    (csr_i2c_control_lenadd),
                    .i_i2c_en     (csr_i2c_control_en && ~csr_i2c_control_mode),
                    .i_i2c_start  (csr_i2c_control_strx),
                    .i_num_by     (csr_i2c_control_numbtx),
                    .i_re_start   (csr_i2c_control_rst),
                    .i_sem_lo     (csr_i2c_control_seml),
                    .i_add_sla    ({csr_i2c_slave_addr_address[9:0] , WRITE}),
                    .i_add_res    (csr_i2c_reg_addr_adds),
                    .i_data_tx    (TX_DATA),
                    .scl_i2c      (scltx),
                    .sda_i2c      (sdatx),
                    .o_detect     (B1),
                    .o_txe        (TXE),
                    .o_txne       (TXNE),
                    .o_busy       (BUSY1),
                    .o_ts         (TS),
                    .o_err        (ERR1)
    );

//    I2C_Master_Rx u_i2c_rx (
//                    .i_clk        (PCLK),
//                    .i_clk_i2ctick(clk_i2ctick),
//                    .i_rst_n      (PRESETn),
//                    .i_len_add    (LENADD),
//                    .i_i2c_en     (EN && MODE),
//                    .i_i2c_start  (STRX),
//                    .i_num_by     (NUMBRX),
//                    .i_sem_lo     (SEML),
//                    .i_add_sla    ({csr_i2c_slave_addr_address[9:0], READ}),
//                    .i_data_rx    (RX_DATA),
//                    .scl_i2c      (sclrx),
//                    .sda_i2c      (sdarx),
//                    .o_detect     (B2),
//                    .o_rxe        (RXE),
//                    .o_rxne       (RXNE),
//                    .o_busy       (BUSY2),
//                    .o_rs         (RS),
//                    .o_err        (ERR2)
//    );
endmodule
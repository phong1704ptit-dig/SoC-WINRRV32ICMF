module I2C_mapping(
    input clk,
    input rst,
    input [31:0] wo_i2c_control_reg,
    input [31:0] wo_i2c_saddr_reg,
    input [31:0] wo_i2c_raddr_reg,
    input [31:0] wo_i2c_TXDATA_l_reg,
    input [31:0] wo_i2c_TXDATA_h_reg,
    
    output [31:0] ro_i2c_RXDATA_l_reg,
    output [31:0] ro_i2c_RXDATA_h_reg,
    output [31:0] ro_i2c_status_reg,                 //note////////////////
    
    inout sda,//nối với thanh ghi ngoại vi GPIO
    inout scl //nối với thanh ghi ngoại vi GPIO
);
    localparam NONE = 0;
    localparam WRITE = 1'b0;
    localparam READ  = 1'b1;

    wire        clk_i2c;

/////////////////////////////////////CONTROL REGISTER////////////////////////////////////
    wire [9:0]  CLKDIV;             assign CLKDIV   =   wo_i2c_control_reg[9:0];
    wire [2:0]  NUMBRX;             assign NUMBRX   =   wo_i2c_control_reg[12:10];
    wire [3:0]  DUTYSCL;            assign DUTYSCL  =   wo_i2c_control_reg[16:13];
    wire        RSE;                assign RSE      =   wo_i2c_control_reg[17];
    wire [1:0]  LENADD;             assign LENADD   =   wo_i2c_control_reg[19:18];
    wire        EN;                 assign EN       =   wo_i2c_control_reg[20];
    wire        STRX;               assign STRX     =   wo_i2c_control_reg[21];
    wire        MODE;               assign MODE     =   wo_i2c_control_reg[22];
    wire [2:0]  NUMBTX;             assign NUMBTX   =   wo_i2c_control_reg[25:23];
    wire        RST;                assign RST       =   wo_i2c_control_reg[26];
    wire [4:0]  SEML;               assign SEML     =   wo_i2c_control_reg[31:27];
                                    


/////////////////////////////////////STATUS REGISTER/////////////////////////////////////
    wire        B;                  assign ro_i2c_status_reg[0]     =   B;
    wire        TXE;                assign ro_i2c_status_reg[1]     =   TXE;
    wire        TXNE;               assign ro_i2c_status_reg[2]     =   TXNE;
    wire        RXE;                assign ro_i2c_status_reg[6]     =   RXE;
    wire        RXNE;               assign ro_i2c_status_reg[7]     =   RXNE;
    wire        ERR;                assign ro_i2c_status_reg[11]    =   ERR;
    wire        BUSY;               assign ro_i2c_status_reg[12]    =   BUSY;
    wire        TS;                 assign ro_i2c_status_reg[13]    =   TS;
    wire        RS;                 assign ro_i2c_status_reg[14]    =   RS;
                                    
                                    assign ro_i2c_status_reg[5:3]   =   NONE;
                                    assign ro_i2c_status_reg[10:8]  =   NONE;
                                    assign ro_i2c_status_reg[31:15] =   NONE;


//////////////////////////////////////ADDRESS SLAVE//////////////////////////////////////
    wire [31:0] ADDRES;             assign ADDRES   =   wo_i2c_raddr_reg;    


//////////////////////////////////ADDRESS REGISTER SLAVE/////////////////////////////////
    wire [31:0] ADDS;               assign ADDS     =   wo_i2c_saddr_reg;

    
////////////////////////////////////TX DATA REGISTER/////////////////////////////////////
    wire [63:0] TX_DATA;            assign TX_DATA[31:0]    =       wo_i2c_TXDATA_l_reg;
                                    assign TX_DATA[63:32]   =       wo_i2c_TXDATA_h_reg;


////////////////////////////////////RX DATA REGISTER/////////////////////////////////////   
    wire [63:0] RX_DATA;            assign ro_i2c_RXDATA_l_reg      =   RX_DATA[31:0];
                                    assign ro_i2c_RXDATA_h_reg      =   RX_DATA[63:32];



    clk_i2c clk_i2cc(
                    .div(CLKDIV),
                    .clk27m(clk), 
                    .rst(rst), 
                    .clk_i2c(clk_i2c)
    );

    I2C_Master_Tx uut (
                    .i_clk        (clk_i2c),
                    .i_rst_n      (~rst),
                    .i_res_en     (RSE),
                    .i_len_add    (LENADD),
                    .i_i2c_en     (EN && ~MODE),
                    .i_i2c_start  (STRX),
                    .i_num_by     (NUMBTX),
                    .i_re_start   (RST),
                    .i_sem_lo     (SEML),
                    .i_add_sla    ({ADDS[14:0], WRITE}),
                    .i_add_res    (ADDRES[15:0]),
                    .i_data_tx    (TX_DATA),
                    .scl_i2c      (scl),
                    .sda_i2c      (sda),
                    .o_detect     (B),
                    .o_txe        (TXE),
                    .o_txne       (TXNE),
                    .o_busy       (BUSY),
                    .o_ts         (TS),
                    .o_err        (ERR)
    );

    I2C_Master_Rx u_i2c_rx (
                    .i_clk        (clk_i2c),
                    .i_rst_n      (~rst),
                    .i_len_add    (LENADD),
                    .i_i2c_en     (EN && MODE),
                    .i_i2c_start  (STRX),
                    .i_num_by     (NUMBRX),
                    .i_sem_lo     (SEML),
                    .i_add_sla    ({ADDS[14:0], READ}),
                    .i_data_rx    (RX_DATA),
                    .scl_i2c      (scl),
                    .sda_i2c      (sda),
            //    .o_detect     (B),
                    .o_rxe        (RXE),
                    .o_rxne       (RXNE),
            //    .o_busy       (BUSY),
                    .o_rs         (RS)
            //      .o_err        (ERR)
    );
endmodule
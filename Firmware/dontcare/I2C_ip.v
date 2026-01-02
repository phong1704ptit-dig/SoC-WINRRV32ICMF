module I2C_ip #(
    parameter ADDR_W = 32,
    parameter DATA_W = 32,
    parameter STRB_W = DATA_W / 8
)(
    // System signals
    input wire clk,
    input wire rst,
    
    // Local Bus Interface
    input wire [ADDR_W-1:0] waddr,
    input wire [DATA_W-1:0] wdata,
    input wire wen,
    input wire [STRB_W-1:0] wstrb,
    output wire wready,
    input wire [ADDR_W-1:0] raddr,
    input wire ren,
    output wire [DATA_W-1:0] rdata,
    output wire rvalid,
    
    // I2C Interface
    inout wire sda,
    inout wire scl
);

    ///////////////////////////////////////////////////////// I2C_CONTROL///////////////////////////////////////////////////////////////////
    wire [9:0] csr_i2c_control_clkdiv;
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
        .clk(clk),
        .rst(~rst),
        
        // I2C_CONTROL
        .csr_i2c_control_clkdiv_out(csr_i2c_control_clkdiv),
        .csr_i2c_control_numbrx_out(csr_i2c_control_numbrx),
        .csr_i2c_control_dutyscl_out(csr_i2c_control_dutyscl),
        .csr_i2c_control_rse_out(csr_i2c_control_rse),
        .csr_i2c_control_lenadd_out(csr_i2c_control_lenadd),
        .csr_i2c_control_en_out(csr_i2c_control_en),
        .csr_i2c_control_strx_out(csr_i2c_control_strx),
        .csr_i2c_control_mode_out(csr_i2c_control_mode),
        .csr_i2c_control_numbtx_out(csr_i2c_control_numbtx),
        .csr_i2c_control_rst_out(csr_i2c_control_rst),
        .csr_i2c_control_seml_out(csr_i2c_control_seml),
        
        // I2C_STATUS
        .csr_i2c_status_slave_found_in(csr_i2c_status_slave_found),
        .csr_i2c_status_txe_in(csr_i2c_status_txe),
        .csr_i2c_status_txne_in(csr_i2c_status_txne),
        .csr_i2c_status_rxe_in(csr_i2c_status_rxe),
        .csr_i2c_status_rxne_in(csr_i2c_status_rxne),
        .csr_i2c_status_err_in(csr_i2c_status_err),
        .csr_i2c_status_busy_in(csr_i2c_status_busy),
        .csr_i2c_status_ts_in(csr_i2c_status_ts),
        .csr_i2c_status_rs_in(csr_i2c_status_rs),
        
        // I2C_SLAVE_ADDR
        .csr_i2c_slave_addr_address_out(csr_i2c_slave_addr_address),
        
        // I2C_REG_ADDR
        .csr_i2c_reg_addr_adds_out(csr_i2c_reg_addr_adds),
        
        // I2C_TX_DATA
        .csr_i2c_tx_data_low_tx_data_low_out(csr_i2c_tx_data_low_tx_data_low),
        .csr_i2c_tx_data_high_tx_data_high_out(csr_i2c_tx_data_high_tx_data_high),
        
        // I2C_RX_DATA
        .csr_i2c_rx_data_low_rx_data_low_in(csr_i2c_rx_data_low_rx_data_low),
        .csr_i2c_rx_data_high_rx_data_high_in(csr_i2c_rx_data_high_rx_data_high),
        
        // Local Bus
        .waddr(waddr),
        .wdata(wdata),
        .wen(wen),
        .wstrb(wstrb),
        .wready(wready),
        .raddr(raddr),
        .ren(ren),
        .rdata(rdata),
        .rvalid(rvalid)
    );

    wire [31:0] zero; assign zero = 32'b0;

    // Instantiate the I2C mapping module
    I2C_mapping u_i2c_mapping (
        .clk(clk),
        .rst(rst),
        
        // Control Register
        .wo_i2c_control_reg({
            csr_i2c_control_seml,       // [31:27]
            csr_i2c_control_rst,        // [26]
            csr_i2c_control_numbtx,     // [25:23]
            csr_i2c_control_mode,       // [22]
            csr_i2c_control_strx,       // [21]
            csr_i2c_control_en,         // [20]
            csr_i2c_control_lenadd,    // [19:18]
            csr_i2c_control_rse,        // [17]
            csr_i2c_control_dutyscl,    // [16:13]
            csr_i2c_control_numbrx,     // [12:10]
            csr_i2c_control_clkdiv      // [9:0]
        }),
        
        // Status Register (output from mapping to registers)
        .ro_i2c_status_reg({
            zero[31:15],                      // [31:15]
            csr_i2c_status_rs,          // [14]
            csr_i2c_status_ts,          // [13]
            csr_i2c_status_busy,       // [12]
            csr_i2c_status_err,        // [11]
            zero[10:8],                      // [10:8]
            csr_i2c_status_rxne,        // [7]
            csr_i2c_status_rxe,         // [6]
            zero[5:3],                      // [5:3]
            csr_i2c_status_txne,        // [2]
            csr_i2c_status_txe,         // [1]
            csr_i2c_status_slave_found  // [0]
        }),
        
        // Slave Address Register
        .wo_i2c_saddr_reg({22'h0, csr_i2c_slave_addr_address}),
        
        // Register Address
        .wo_i2c_raddr_reg({24'h0, csr_i2c_reg_addr_adds}),
        
        // TX Data Registers
        .wo_i2c_TXDATA_l_reg(csr_i2c_tx_data_low_tx_data_low),
        .wo_i2c_TXDATA_h_reg(csr_i2c_tx_data_high_tx_data_high),
        
        // RX Data Registers
        .ro_i2c_RXDATA_l_reg(csr_i2c_rx_data_low_rx_data_low),
        .ro_i2c_RXDATA_h_reg(csr_i2c_rx_data_high_rx_data_high),
        
        // I2C Interface
        .sda(sda),
        .scl(scl)
    );

endmodule
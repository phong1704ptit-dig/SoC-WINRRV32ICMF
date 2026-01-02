// Created with Corsair v1.0.4

module regs_UFLASH #(
    parameter ADDR_W = 32,
    parameter DATA_W = 32,
    parameter STRB_W = DATA_W / 8
)(
    // System
    input clk,
    input rst,
    // UFLASH_KEY1.KEY
    output [31:0] csr_uflash_key1_key_out,

    // UFLASH_KEY2.KEY
    output [31:0] csr_uflash_key2_key_out,

    // UFLASH_KEY3.KEY
    output [31:0] csr_uflash_key3_key_out,

    // UFLASH_CR.USER_EN
    output  csr_uflash_cr_user_en_out,
    // UFLASH_CR.TEXT_EN
    output  csr_uflash_cr_text_en_out,
    // UFLASH_CR.BOOT_EN
    output  csr_uflash_cr_boot_en_out,
    // UFLASH_CR.PROG_EN
    output  csr_uflash_cr_prog_en_out,
    // UFLASH_CR.READ_EN
    output  csr_uflash_cr_read_en_out,
    // UFLASH_CR.ERASE_EN
    output  csr_uflash_cr_erase_en_out,
    // UFLASH_CR.MODE
    output [1:0] csr_uflash_cr_mode_out,

    // UFLASH_SR.ERRA_USER
    input  csr_uflash_sr_erra_user_in,
    // UFLASH_SR.ERRA_TEXT
    input  csr_uflash_sr_erra_text_in,
    // UFLASH_SR.ERRA_BOOT
    input  csr_uflash_sr_erra_boot_in,
    // UFLASH_SR.ERRA_OVF
    input  csr_uflash_sr_erra_ovf_in,
    // UFLASH_SR.RD_DONE
    input  csr_uflash_sr_rd_done_in,
    // UFLASH_SR.PROG_DONE
    input  csr_uflash_sr_prog_done_in,
    // UFLASH_SR.ERASE_DONE
    input  csr_uflash_sr_erase_done_in,

    // UFLASH_XADR.XADR
    output [15:0] csr_uflash_xadr_xadr_out,

    // UFLASH_YADR.YADR
    output [7:0] csr_uflash_yadr_yadr_out,

    // UFLASH_DOR.DO
    input [31:0] csr_uflash_dor_do_in,

    // UFLASH_DIR.DI
    output [31:0] csr_uflash_dir_di_out,

    // Local Bus
    input  [ADDR_W-1:0] waddr,
    input  [DATA_W-1:0] wdata,
    input               wen,
    input  [STRB_W-1:0] wstrb,
    output              wready,
    input  [ADDR_W-1:0] raddr,
    input               ren,
    output [DATA_W-1:0] rdata,
    output              rvalid
);
//------------------------------------------------------------------------------
// CSR:
// [0x0] - UFLASH_KEY1 - Unlock key for User Flash region
//------------------------------------------------------------------------------
wire [31:0] csr_uflash_key1_rdata;

wire csr_uflash_key1_wen;
assign csr_uflash_key1_wen = wen && (waddr == 32'h0);

//---------------------
// Bit field:
// UFLASH_KEY1[31:0] - KEY - 32-bit unlock key value(0x57494E44 - WIND)
// access: wo, hardware: o
//---------------------
reg [31:0] csr_uflash_key1_key_ff;

assign csr_uflash_key1_rdata[31:0] = 32'h0;

assign csr_uflash_key1_key_out = csr_uflash_key1_key_ff;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        csr_uflash_key1_key_ff <= 32'h0;
    end else  begin
     if (csr_uflash_key1_wen) begin
            if (wstrb[0]) begin
                csr_uflash_key1_key_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_uflash_key1_key_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_uflash_key1_key_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_uflash_key1_key_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_uflash_key1_key_ff <= csr_uflash_key1_key_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x4] - UFLASH_KEY2 - Unlock key for Text Flash region
//------------------------------------------------------------------------------
wire [31:0] csr_uflash_key2_rdata;

wire csr_uflash_key2_wen;
assign csr_uflash_key2_wen = wen && (waddr == 32'h4);

//---------------------
// Bit field:
// UFLASH_KEY2[31:0] - KEY - 32-bit unlock key value
// access: wo, hardware: o
//---------------------
reg [31:0] csr_uflash_key2_key_ff;

assign csr_uflash_key2_rdata[31:0] = 32'h0;

assign csr_uflash_key2_key_out = csr_uflash_key2_key_ff;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        csr_uflash_key2_key_ff <= 32'h0;
    end else  begin
     if (csr_uflash_key2_wen) begin
            if (wstrb[0]) begin
                csr_uflash_key2_key_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_uflash_key2_key_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_uflash_key2_key_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_uflash_key2_key_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_uflash_key2_key_ff <= csr_uflash_key2_key_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x8] - UFLASH_KEY3 - Unlock key for Boot Flash region
//------------------------------------------------------------------------------
wire [31:0] csr_uflash_key3_rdata;

wire csr_uflash_key3_wen;
assign csr_uflash_key3_wen = wen && (waddr == 32'h8);

//---------------------
// Bit field:
// UFLASH_KEY3[31:0] - KEY - 32-bit unlock key value
// access: wo, hardware: o
//---------------------
reg [31:0] csr_uflash_key3_key_ff;

assign csr_uflash_key3_rdata[31:0] = 32'h0;

assign csr_uflash_key3_key_out = csr_uflash_key3_key_ff;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        csr_uflash_key3_key_ff <= 32'h0;
    end else  begin
     if (csr_uflash_key3_wen) begin
            if (wstrb[0]) begin
                csr_uflash_key3_key_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_uflash_key3_key_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_uflash_key3_key_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_uflash_key3_key_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_uflash_key3_key_ff <= csr_uflash_key3_key_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xc] - UFLASH_CR - Flash Control Register
//------------------------------------------------------------------------------
wire [31:0] csr_uflash_cr_rdata;
assign csr_uflash_cr_rdata[31:8] = 24'h0;

wire csr_uflash_cr_wen;
assign csr_uflash_cr_wen = wen && (waddr == 32'hc);

wire csr_uflash_cr_ren;
assign csr_uflash_cr_ren = ren && (raddr == 32'hc);
reg csr_uflash_cr_ren_ff;
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        csr_uflash_cr_ren_ff <= 1'b0;
    end else begin
        csr_uflash_cr_ren_ff <= csr_uflash_cr_ren;
    end
end
//---------------------
// Bit field:
// UFLASH_CR[0] - USER_EN - Enable access to User region
// access: rw, hardware: o
//---------------------
reg  csr_uflash_cr_user_en_ff;

assign csr_uflash_cr_rdata[0] = csr_uflash_cr_user_en_ff;

assign csr_uflash_cr_user_en_out = csr_uflash_cr_user_en_ff;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        csr_uflash_cr_user_en_ff <= 1'b0;
    end else  begin
     if (csr_uflash_cr_wen) begin
            if (wstrb[0]) begin
                csr_uflash_cr_user_en_ff <= wdata[0];
            end
        end else begin
            csr_uflash_cr_user_en_ff <= csr_uflash_cr_user_en_ff;
        end
    end
end


//---------------------
// Bit field:
// UFLASH_CR[1] - TEXT_EN - Enable access to Text region
// access: rw, hardware: o
//---------------------
reg  csr_uflash_cr_text_en_ff;

assign csr_uflash_cr_rdata[1] = csr_uflash_cr_text_en_ff;

assign csr_uflash_cr_text_en_out = csr_uflash_cr_text_en_ff;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        csr_uflash_cr_text_en_ff <= 1'b0;
    end else  begin
     if (csr_uflash_cr_wen) begin
            if (wstrb[0]) begin
                csr_uflash_cr_text_en_ff <= wdata[1];
            end
        end else begin
            csr_uflash_cr_text_en_ff <= csr_uflash_cr_text_en_ff;
        end
    end
end


//---------------------
// Bit field:
// UFLASH_CR[2] - BOOT_EN - Enable access to Boot region
// access: rw, hardware: o
//---------------------
reg  csr_uflash_cr_boot_en_ff;

assign csr_uflash_cr_rdata[2] = csr_uflash_cr_boot_en_ff;

assign csr_uflash_cr_boot_en_out = csr_uflash_cr_boot_en_ff;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        csr_uflash_cr_boot_en_ff <= 1'b0;
    end else  begin
     if (csr_uflash_cr_wen) begin
            if (wstrb[0]) begin
                csr_uflash_cr_boot_en_ff <= wdata[2];
            end
        end else begin
            csr_uflash_cr_boot_en_ff <= csr_uflash_cr_boot_en_ff;
        end
    end
end


//---------------------
// Bit field:
// UFLASH_CR[3] - PROG_EN - Program enable
// access: rw, hardware: o
//---------------------
reg  csr_uflash_cr_prog_en_ff;

assign csr_uflash_cr_rdata[3] = csr_uflash_cr_prog_en_ff;

assign csr_uflash_cr_prog_en_out = csr_uflash_cr_prog_en_ff;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        csr_uflash_cr_prog_en_ff <= 1'b0;
    end else  begin
     if (csr_uflash_cr_wen) begin
            if (wstrb[0]) begin
                csr_uflash_cr_prog_en_ff <= wdata[3];
            end
        end else begin
            csr_uflash_cr_prog_en_ff <= csr_uflash_cr_prog_en_ff;
        end
    end
end


//---------------------
// Bit field:
// UFLASH_CR[4] - READ_EN - Read enable
// access: rw, hardware: o
//---------------------
reg  csr_uflash_cr_read_en_ff;

assign csr_uflash_cr_rdata[4] = csr_uflash_cr_read_en_ff;

assign csr_uflash_cr_read_en_out = csr_uflash_cr_read_en_ff;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        csr_uflash_cr_read_en_ff <= 1'b0;
    end else  begin
     if (csr_uflash_cr_wen) begin
            if (wstrb[0]) begin
                csr_uflash_cr_read_en_ff <= wdata[4];
            end
        end else begin
            csr_uflash_cr_read_en_ff <= csr_uflash_cr_read_en_ff;
        end
    end
end


//---------------------
// Bit field:
// UFLASH_CR[5] - ERASE_EN - Erase enable
// access: rw, hardware: o
//---------------------
reg  csr_uflash_cr_erase_en_ff;

assign csr_uflash_cr_rdata[5] = csr_uflash_cr_erase_en_ff;

assign csr_uflash_cr_erase_en_out = csr_uflash_cr_erase_en_ff;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        csr_uflash_cr_erase_en_ff <= 1'b0;
    end else  begin
     if (csr_uflash_cr_wen) begin
            if (wstrb[0]) begin
                csr_uflash_cr_erase_en_ff <= wdata[5];
            end
        end else begin
            csr_uflash_cr_erase_en_ff <= csr_uflash_cr_erase_en_ff;
        end
    end
end


//---------------------
// Bit field:
// UFLASH_CR[7:6] - MODE - Flash operation mode
// access: rw, hardware: o
//---------------------
reg [1:0] csr_uflash_cr_mode_ff;

assign csr_uflash_cr_rdata[7:6] = csr_uflash_cr_mode_ff;

assign csr_uflash_cr_mode_out = csr_uflash_cr_mode_ff;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        csr_uflash_cr_mode_ff <= 2'h0;
    end else  begin
     if (csr_uflash_cr_wen) begin
            if (wstrb[0]) begin
                csr_uflash_cr_mode_ff[1:0] <= wdata[7:6];
            end
        end else begin
            csr_uflash_cr_mode_ff <= csr_uflash_cr_mode_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x10] - UFLASH_SR - Flash Status Register
//------------------------------------------------------------------------------
wire [31:0] csr_uflash_sr_rdata;
assign csr_uflash_sr_rdata[31:7] = 25'h0;


wire csr_uflash_sr_ren;
assign csr_uflash_sr_ren = ren && (raddr == 32'h10);
reg csr_uflash_sr_ren_ff;
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        csr_uflash_sr_ren_ff <= 1'b0;
    end else begin
        csr_uflash_sr_ren_ff <= csr_uflash_sr_ren;
    end
end
//---------------------
// Bit field:
// UFLASH_SR[0] - ERRA_USER - Error unauthorized access to User region
// access: ro, hardware: i
//---------------------
reg  csr_uflash_sr_erra_user_ff;

assign csr_uflash_sr_rdata[0] = csr_uflash_sr_erra_user_ff;


always @(posedge clk or negedge rst) begin
    if (!rst) begin
        csr_uflash_sr_erra_user_ff <= 1'b0;
    end else  begin
              begin            csr_uflash_sr_erra_user_ff <= csr_uflash_sr_erra_user_in;
        end
    end
end


//---------------------
// Bit field:
// UFLASH_SR[1] - ERRA_TEXT - Error unauthorized access to Text region
// access: ro, hardware: i
//---------------------
reg  csr_uflash_sr_erra_text_ff;

assign csr_uflash_sr_rdata[1] = csr_uflash_sr_erra_text_ff;


always @(posedge clk or negedge rst) begin
    if (!rst) begin
        csr_uflash_sr_erra_text_ff <= 1'b0;
    end else  begin
              begin            csr_uflash_sr_erra_text_ff <= csr_uflash_sr_erra_text_in;
        end
    end
end


//---------------------
// Bit field:
// UFLASH_SR[2] - ERRA_BOOT - Error unauthorized access to Boot region
// access: ro, hardware: i
//---------------------
reg  csr_uflash_sr_erra_boot_ff;

assign csr_uflash_sr_rdata[2] = csr_uflash_sr_erra_boot_ff;


always @(posedge clk or negedge rst) begin
    if (!rst) begin
        csr_uflash_sr_erra_boot_ff <= 1'b0;
    end else  begin
              begin            csr_uflash_sr_erra_boot_ff <= csr_uflash_sr_erra_boot_in;
        end
    end
end


//---------------------
// Bit field:
// UFLASH_SR[3] - ERRA_OVF - Error address overflow
// access: ro, hardware: i
//---------------------
reg  csr_uflash_sr_erra_ovf_ff;

assign csr_uflash_sr_rdata[3] = csr_uflash_sr_erra_ovf_ff;


always @(posedge clk or negedge rst) begin
    if (!rst) begin
        csr_uflash_sr_erra_ovf_ff <= 1'b0;
    end else  begin
              begin            csr_uflash_sr_erra_ovf_ff <= csr_uflash_sr_erra_ovf_in;
        end
    end
end


//---------------------
// Bit field:
// UFLASH_SR[4] - RD_DONE - Read operation finished
// access: ro, hardware: i
//---------------------
reg  csr_uflash_sr_rd_done_ff;

assign csr_uflash_sr_rdata[4] = csr_uflash_sr_rd_done_ff;


always @(posedge clk or negedge rst) begin
    if (!rst) begin
        csr_uflash_sr_rd_done_ff <= 1'b0;
    end else  begin
              begin            csr_uflash_sr_rd_done_ff <= csr_uflash_sr_rd_done_in;
        end
    end
end


//---------------------
// Bit field:
// UFLASH_SR[5] - PROG_DONE - Program operation finished
// access: ro, hardware: i
//---------------------
reg  csr_uflash_sr_prog_done_ff;

assign csr_uflash_sr_rdata[5] = csr_uflash_sr_prog_done_ff;


always @(posedge clk or negedge rst) begin
    if (!rst) begin
        csr_uflash_sr_prog_done_ff <= 1'b0;
    end else  begin
              begin            csr_uflash_sr_prog_done_ff <= csr_uflash_sr_prog_done_in;
        end
    end
end


//---------------------
// Bit field:
// UFLASH_SR[6] - ERASE_DONE - Erase operation finished
// access: ro, hardware: i
//---------------------
reg  csr_uflash_sr_erase_done_ff;

assign csr_uflash_sr_rdata[6] = csr_uflash_sr_erase_done_ff;


always @(posedge clk or negedge rst) begin
    if (!rst) begin
        csr_uflash_sr_erase_done_ff <= 1'b0;
    end else  begin
              begin            csr_uflash_sr_erase_done_ff <= csr_uflash_sr_erase_done_in;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x14] - UFLASH_XADR - Flash X Address Register
//------------------------------------------------------------------------------
wire [31:0] csr_uflash_xadr_rdata;
assign csr_uflash_xadr_rdata[31:16] = 16'h0;

wire csr_uflash_xadr_wen;
assign csr_uflash_xadr_wen = wen && (waddr == 32'h14);

wire csr_uflash_xadr_ren;
assign csr_uflash_xadr_ren = ren && (raddr == 32'h14);
reg csr_uflash_xadr_ren_ff;
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        csr_uflash_xadr_ren_ff <= 1'b0;
    end else begin
        csr_uflash_xadr_ren_ff <= csr_uflash_xadr_ren;
    end
end
//---------------------
// Bit field:
// UFLASH_XADR[15:0] - XADR - Flash X address (row / page select)
// access: rw, hardware: o
//---------------------
reg [15:0] csr_uflash_xadr_xadr_ff;

assign csr_uflash_xadr_rdata[15:0] = csr_uflash_xadr_xadr_ff;

assign csr_uflash_xadr_xadr_out = csr_uflash_xadr_xadr_ff;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        csr_uflash_xadr_xadr_ff <= 16'h0;
    end else  begin
     if (csr_uflash_xadr_wen) begin
            if (wstrb[0]) begin
                csr_uflash_xadr_xadr_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_uflash_xadr_xadr_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_uflash_xadr_xadr_ff <= csr_uflash_xadr_xadr_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x18] - UFLASH_YADR - Flash Y Address Register
//------------------------------------------------------------------------------
wire [31:0] csr_uflash_yadr_rdata;
assign csr_uflash_yadr_rdata[31:8] = 24'h0;

wire csr_uflash_yadr_wen;
assign csr_uflash_yadr_wen = wen && (waddr == 32'h18);

wire csr_uflash_yadr_ren;
assign csr_uflash_yadr_ren = ren && (raddr == 32'h18);
reg csr_uflash_yadr_ren_ff;
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        csr_uflash_yadr_ren_ff <= 1'b0;
    end else begin
        csr_uflash_yadr_ren_ff <= csr_uflash_yadr_ren;
    end
end
//---------------------
// Bit field:
// UFLASH_YADR[7:0] - YADR - Flash Y address (column / word select)
// access: rw, hardware: o
//---------------------
reg [7:0] csr_uflash_yadr_yadr_ff;

assign csr_uflash_yadr_rdata[7:0] = csr_uflash_yadr_yadr_ff;

assign csr_uflash_yadr_yadr_out = csr_uflash_yadr_yadr_ff;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        csr_uflash_yadr_yadr_ff <= 8'h0;
    end else  begin
     if (csr_uflash_yadr_wen) begin
            if (wstrb[0]) begin
                csr_uflash_yadr_yadr_ff[7:0] <= wdata[7:0];
            end
        end else begin
            csr_uflash_yadr_yadr_ff <= csr_uflash_yadr_yadr_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x1c] - UFLASH_DOR - Flash data out Register
//------------------------------------------------------------------------------
wire [31:0] csr_uflash_dor_rdata;


wire csr_uflash_dor_ren;
assign csr_uflash_dor_ren = ren && (raddr == 32'h1c);
reg csr_uflash_dor_ren_ff;
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        csr_uflash_dor_ren_ff <= 1'b0;
    end else begin
        csr_uflash_dor_ren_ff <= csr_uflash_dor_ren;
    end
end
//---------------------
// Bit field:
// UFLASH_DOR[31:0] - DO - 32BIT READ DATA
// access: ro, hardware: i
//---------------------
reg [31:0] csr_uflash_dor_do_ff;

assign csr_uflash_dor_rdata[31:0] = csr_uflash_dor_do_ff;


always @(posedge clk or negedge rst) begin
    if (!rst) begin
        csr_uflash_dor_do_ff <= 32'h0;
    end else  begin
              begin            csr_uflash_dor_do_ff <= csr_uflash_dor_do_in;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x20] - UFLASH_DIR - Flash data in Register
//------------------------------------------------------------------------------
wire [31:0] csr_uflash_dir_rdata;

wire csr_uflash_dir_wen;
assign csr_uflash_dir_wen = wen && (waddr == 32'h20);

//---------------------
// Bit field:
// UFLASH_DIR[31:0] - DI - 32BIT PROGRAM DATA
// access: wo, hardware: o
//---------------------
reg [31:0] csr_uflash_dir_di_ff;

assign csr_uflash_dir_rdata[31:0] = 32'h0;

assign csr_uflash_dir_di_out = csr_uflash_dir_di_ff;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        csr_uflash_dir_di_ff <= 32'h0;
    end else  begin
     if (csr_uflash_dir_wen) begin
            if (wstrb[0]) begin
                csr_uflash_dir_di_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_uflash_dir_di_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_uflash_dir_di_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_uflash_dir_di_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_uflash_dir_di_ff <= csr_uflash_dir_di_ff;
        end
    end
end


//------------------------------------------------------------------------------
// Write ready
//------------------------------------------------------------------------------
assign wready = 1'b1;

//------------------------------------------------------------------------------
// Read address decoder
//------------------------------------------------------------------------------
reg [31:0] rdata_ff;
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        rdata_ff <= 32'h0;
    end else if (ren) begin
        case (raddr)
            32'h0: rdata_ff <= csr_uflash_key1_rdata;
            32'h4: rdata_ff <= csr_uflash_key2_rdata;
            32'h8: rdata_ff <= csr_uflash_key3_rdata;
            32'hc: rdata_ff <= csr_uflash_cr_rdata;
            32'h10: rdata_ff <= csr_uflash_sr_rdata;
            32'h14: rdata_ff <= csr_uflash_xadr_rdata;
            32'h18: rdata_ff <= csr_uflash_yadr_rdata;
            32'h1c: rdata_ff <= csr_uflash_dor_rdata;
            32'h20: rdata_ff <= csr_uflash_dir_rdata;
            default: rdata_ff <= 32'h0;
        endcase
    end else begin
        rdata_ff <= 32'h0;
    end
end
assign rdata = rdata_ff;

//------------------------------------------------------------------------------
// Read data valid
//------------------------------------------------------------------------------
reg rvalid_ff;
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        rvalid_ff <= 1'b0;
    end else if (ren && rvalid) begin
        rvalid_ff <= 1'b0;
    end else if (ren) begin
        rvalid_ff <= 1'b1;
    end
end

assign rvalid = rvalid_ff;

endmodule
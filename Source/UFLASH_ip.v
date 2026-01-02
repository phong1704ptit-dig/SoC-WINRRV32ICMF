module UFLASH_ip #(
    parameter ADDR_W = 32,
    parameter DATA_W = 32,
    parameter STRB_W = DATA_W / 8
)(
    input  wire               clk,
    input  wire               rst,

    // Local Bus Interface
    input  wire [ADDR_W-1:0]  waddr,
    input  wire [DATA_W-1:0]  wdata,
    input  wire               wen,
    input  wire [STRB_W-1:0]  wstrb,
    output wire               wready,
    input  wire [ADDR_W-1:0]  raddr,
    input  wire               ren,
    output wire [DATA_W-1:0]  rdata,
    output wire               rvalid
);

    // Wires between CSR and core
    wire [31:0] key1, key2, key3;
    wire        user_en, text_en, boot_en;
    wire        prog_en, read_en, erase_en;
    wire [1:0]  mode;
    wire [15:0]  xaddr;
    wire [7:0]  yaddr;

    wire        prog_done, rd_done, erase_done;
    wire        err_user, err_text, err_boot, err_ovf;

    wire [31:0] program_data;
    wire  [31:0] read_data;
    // Register Map
    regs_UFLASH regs_inst (
        .clk(clk),
        .rst(rst),

        // Keys
        .csr_uflash_key1_key_out(key1),
        .csr_uflash_key2_key_out(key2),
        .csr_uflash_key3_key_out(key3),

        // Control
        .csr_uflash_cr_user_en_out(user_en),
        .csr_uflash_cr_text_en_out(text_en),
        .csr_uflash_cr_boot_en_out(boot_en),
        .csr_uflash_cr_prog_en_out(prog_en),
        .csr_uflash_cr_read_en_out(read_en),
        .csr_uflash_cr_erase_en_out(erase_en),
        .csr_uflash_cr_mode_out(mode),

        // Status
        .csr_uflash_sr_erra_user_in(err_user),
        .csr_uflash_sr_erra_text_in(err_text),
        .csr_uflash_sr_erra_boot_in(err_boot),
        .csr_uflash_sr_erra_ovf_in(err_ovf),
        .csr_uflash_sr_rd_done_in(1),
        .csr_uflash_sr_prog_done_in(1),
        .csr_uflash_sr_erase_done_in(1),

        // Address
        .csr_uflash_xadr_xadr_out(xaddr),
        .csr_uflash_yadr_yadr_out(yaddr),
        
        //Data
        .csr_uflash_dir_di_out(program_data),
        .csr_uflash_dor_do_in(read_data),

        // Bus interface
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

    // Core xử lý flash (logic thực sự)
    UFLASH_core core_inst (
        .clk(clk),
        .rst(rst),
        .i_key1(key1),
        .i_key2(key2),
        .i_key3(key3),
        .i_user_en(user_en),
        .i_text_en(text_en),
        .i_boot_en(boot_en),
        .i_prog_en(prog_en),
        .i_read_en(read_en),
        .i_erase_en(erase_en),
        .i_mode(mode),
        .i_xaddr(xaddr),
        .i_yaddr(yaddr),

        .o_prog_done(prog_done),
        .o_rd_done(rd_done),
        .o_erase_done(erase_done),
        .o_err_user(err_user),
        .o_err_text(err_text),
        .o_err_boot(err_boot),
        .o_err_ovf(err_ovf),

        .i_program_data(program_data),
        .o_read_data(read_data)
    );

endmodule

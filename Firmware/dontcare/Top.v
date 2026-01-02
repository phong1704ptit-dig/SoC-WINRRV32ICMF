module Top (
    input clk,
    input reset_n,

    
    inout [15:0] leds,
    inout sda,
    inout scl
);

    parameter MEM_FILE = "C:\Users\PHONG\OneDrive - ptit.edu.vn\Documents\HOCTAP\KI8\Thuctapchuyensau\184\Project_I2C\firmware\firmware.hex";

    wire mem_rstrb;
    wire mem_instr;
    wire mem_ready;
    wire [31:0] mem_addr;
    wire [31:0] mem_wdata;
    wire [3:0] mem_wstrb;
    wire [31:0] mem_rdata, rdata_gpio, rdata_i2c;

    wire s0_sel_mem;
    wire s1_sel_gpio;
    wire s2_sel_i2c;

    reg [31:0] processor_rdata;
    always @(*) begin
        processor_rdata = 32'h0;
        case ({s2_sel_i2c, s1_sel_gpio, s0_sel_mem})
            3'b001: processor_rdata = mem_rdata;
            3'b010: processor_rdata = rdata_gpio;
            3'b100: processor_rdata = rdata_i2c;
        endcase
    end

    Memory #(
        .MEM_FILE(MEM_FILE),
        .SIZE(1024)
    ) D_mem_unit (
        .clk(clk),
        .mem_addr(mem_addr),
        .mem_rdata(mem_rdata),
        .mem_rstrb(s0_sel_mem & mem_rstrb),
        .mem_wdata(mem_wdata),
        .mem_wmask({4{s0_sel_mem}} & mem_wstrb)
    );

    FemtoRV32 processor (
        .clk      (clk),
        .reset    (reset_n),
        .mem_rstrb(mem_rstrb),
        .mem_rbusy(1'b0),
        .mem_wbusy(1'b0),
        .mem_addr (mem_addr),
        .mem_wdata(mem_wdata),
        .mem_wmask(mem_wstrb),
        .mem_rdata(processor_rdata)
    );

    regs_GPIO gpio_unit(
        .clk(clk),
        .rst(~reset_n),
        
        .csr_gpio_io_gpio_0_in (leds[0]),
        .csr_gpio_io_gpio_0_out(leds[0]),

        .csr_gpio_io_gpio_1_in (leds[1]),
        .csr_gpio_io_gpio_1_out(leds[1]),

        .csr_gpio_io_gpio_2_in (leds[2]),
        .csr_gpio_io_gpio_2_out(leds[2]),

        .csr_gpio_io_gpio_3_in (leds[3]),
        .csr_gpio_io_gpio_3_out(leds[3]),

        .csr_gpio_io_gpio_4_in (leds[4]),
        .csr_gpio_io_gpio_4_out(leds[4]),

        .csr_gpio_io_gpio_5_in (leds[5]),
        .csr_gpio_io_gpio_5_out(leds[5]),

        .csr_gpio_io_gpio_6_in (leds[6]),
        .csr_gpio_io_gpio_6_out(leds[6]),

        .csr_gpio_io_gpio_7_in (leds[7]),
        .csr_gpio_io_gpio_7_out(leds[7]),

        .csr_gpio_io_gpio_8_in (leds[8]),
        .csr_gpio_io_gpio_8_out(leds[8]),

        .csr_gpio_io_gpio_9_in (leds[9]),
        .csr_gpio_io_gpio_9_out(leds[9]),

        .csr_gpio_io_gpio_10_in (leds[10]),
        .csr_gpio_io_gpio_10_out(leds[10]),

        .csr_gpio_io_gpio_11_in (leds[11]),
        .csr_gpio_io_gpio_11_out(leds[11]),

        .csr_gpio_io_gpio_12_in (leds[12]),
        .csr_gpio_io_gpio_12_out(leds[12]),

        .csr_gpio_io_gpio_13_in (leds[13]),
        .csr_gpio_io_gpio_13_out(leds[13]),

        .csr_gpio_io_gpio_14_in (leds[14]),
        .csr_gpio_io_gpio_14_out(leds[14]),

        .csr_gpio_io_gpio_15_in (leds[15]),
        .csr_gpio_io_gpio_15_out(leds[15]),

        .waddr({4'h0, mem_addr[27:0]}),
        .wdata(mem_wdata),
        .wen(s1_sel_gpio & (|mem_wstrb)),
        .wstrb(mem_wstrb),
        .wready(),
        .raddr({4'h0, mem_addr[27:0]}),
        .ren(s1_sel_gpio & mem_rstrb),
        .rdata(rdata_gpio),
        .rvalid()
    );

    I2C_ip #(
        .ADDR_W(32),
        .DATA_W(32),
        .STRB_W(4)
    ) i2c_unit (
        .clk(clk),
        .rst(reset_n),

        .waddr({4'h0, mem_addr[27:0]}),
        .wdata(mem_wdata),
        .wen(s2_sel_i2c & (|mem_wstrb)),
        .wstrb(mem_wstrb),
        .wready(),
        .raddr({4'h0, mem_addr[27:0]}),
        .ren(s2_sel_i2c & mem_rstrb),
        .rdata(rdata_i2c),
        .rvalid(),

        .sda(sda),
        .scl(scl)
    );

    device_select dv_sel(
        .addr(mem_addr),
        .s0_sel_mem(s0_sel_mem),
        .s1_sel_gpio(s1_sel_gpio),
        .s2_sel_i2c(s2_sel_i2c)  
    );

endmodule

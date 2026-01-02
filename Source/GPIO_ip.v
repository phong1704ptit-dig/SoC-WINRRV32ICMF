module gpio_ip #(
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

    output  [15:0 ] irqsx_gpio_pedge,
    output  [15:0 ] irqsx_gpio_nedge,

    inout   [15:0]  GPIO_x       
);

    wire    [15:0]  gpio_dir;
    wire    [15:0]  gpio_out;

    reg     [15:0]  irq_pedge = 16'd0;  assign irqsx_gpio_pedge = irq_pedge;
    reg     [15:0]  irq_nedge = 16'd0;  assign irqsx_gpio_nedge = irq_nedge;

    reg     [15:0]  gpio_out_pre = 16'd0;

//Đồng bộ hóa (Thường qua 2 FF nhưng do ko đồng bộ đc với khối thanh ghi của corsair nên thôi)
//Cần đồng bộ với khối thanh ghi của corsair vì tín hiệu ra và vào đều chung 1 chân. Ra lệch với vào sẽ khiến GPIO nhảy lung tung
    wire     [15:0]  GPIO_x_inff1 = GPIO_x;
//    always @(posedge PCLK) begin
//        if (!PRESETn) begin
//            GPIO_x_inff1 <= 16'd0;
//        end
//        else begin
//            GPIO_x_inff1 <= GPIO_x;
//        end
//    end
//Đồng bộ hóa tín hiệu ra với tín hiệu vào
    wire     [15:0 ]  gpio_out_ff1 = gpio_out;
//    always @(posedge PCLK) begin
//        if (!PRESETn) begin
//            gpio_out_ff1 <= 16'd0;
//        end
//        else begin
//            gpio_out_ff1 <= gpio_out;
//        end
//    end


//Báo ngắt GPIO cạnh lên và cạnh xuống
    integer j;
    always @(posedge PCLK) begin
        if(!PRESETn) begin
            gpio_out_pre <= 16'd0;
            irq_pedge    <= 16'd0;
            irq_nedge    <= 16'd0;
        end
        else begin
            gpio_out_pre <= GPIO_x_inff1;
            irq_pedge <= 16'd0; irq_nedge <= 16'd0;
            for(j = 0; j < 16; j = j + 1) begin
                if (gpio_out_pre[j] == 0 && GPIO_x_inff1[j]) irq_pedge[j] <= 1'b1 & gpio_dir[j];
                if (gpio_out_pre[j] && !GPIO_x_inff1[j])irq_nedge[j] <= 1'b1 & gpio_dir[j];
            end
        end
    end


    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_GPIO_x_inff1_tristate
            assign GPIO_x[i] = (gpio_dir[i])? 1'bz : gpio_out_ff1[i];
        end
    endgenerate


    regs_GPIO #(
        .ADDR_W (ADDR_W),
        .DATA_W (DATA_W),
        .STRB_W (STRB_W)
    ) regs_gpio (
        .clk                    (PCLK),
        .rst                    (PRESETn),

        // GPIO IO
        .csr_gpio_io_gpio_0_in (GPIO_x_inff1[0]),
        .csr_gpio_io_gpio_0_out(gpio_out[0]),
        .csr_gpio_io_gpio_1_in (GPIO_x_inff1[1]),
        .csr_gpio_io_gpio_1_out(gpio_out[1]),
        .csr_gpio_io_gpio_2_in (GPIO_x_inff1[2]),
        .csr_gpio_io_gpio_2_out(gpio_out[2]),
        .csr_gpio_io_gpio_3_in (GPIO_x_inff1[3]),
        .csr_gpio_io_gpio_3_out(gpio_out[3]),
        .csr_gpio_io_gpio_4_in (GPIO_x_inff1[4]),
        .csr_gpio_io_gpio_4_out(gpio_out[4]),
        .csr_gpio_io_gpio_5_in (GPIO_x_inff1[5]),
        .csr_gpio_io_gpio_5_out(gpio_out[5]),
        .csr_gpio_io_gpio_6_in (GPIO_x_inff1[6]),
        .csr_gpio_io_gpio_6_out(gpio_out[6]),
        .csr_gpio_io_gpio_7_in (GPIO_x_inff1[7]),
        .csr_gpio_io_gpio_7_out(gpio_out[7]),
        .csr_gpio_io_gpio_8_in (GPIO_x_inff1[8]),
        .csr_gpio_io_gpio_8_out(gpio_out[8]),
        .csr_gpio_io_gpio_9_in (GPIO_x_inff1[9]),
        .csr_gpio_io_gpio_9_out(gpio_out[9]),
        .csr_gpio_io_gpio_10_in (GPIO_x_inff1[10]),
        .csr_gpio_io_gpio_10_out(gpio_out[10]),
        .csr_gpio_io_gpio_11_in (GPIO_x_inff1[11]),
        .csr_gpio_io_gpio_11_out(gpio_out[11]),
        .csr_gpio_io_gpio_12_in (GPIO_x_inff1[12]),
        .csr_gpio_io_gpio_12_out(gpio_out[12]),
        .csr_gpio_io_gpio_13_in (GPIO_x_inff1[13]),
        .csr_gpio_io_gpio_13_out(gpio_out[13]),
        .csr_gpio_io_gpio_14_in (GPIO_x_inff1[14]),
        .csr_gpio_io_gpio_14_out(gpio_out[14]),
        .csr_gpio_io_gpio_15_in (GPIO_x_inff1[15]),
        .csr_gpio_io_gpio_15_out(gpio_out[15]),

        // GPIO Config (Direction)
        .csr_gpio_config_gpio_0config_out (gpio_dir[0]),
        .csr_gpio_config_gpio_1config_out (gpio_dir[1]),
        .csr_gpio_config_gpio_2config_out (gpio_dir[2]),
        .csr_gpio_config_gpio_3config_out (gpio_dir[3]),
        .csr_gpio_config_gpio_4config_out (gpio_dir[4]),
        .csr_gpio_config_gpio_5config_out (gpio_dir[5]),
        .csr_gpio_config_gpio_6config_out (gpio_dir[6]),
        .csr_gpio_config_gpio_7config_out (gpio_dir[7]),
        .csr_gpio_config_gpio_8config_out (gpio_dir[8]),
        .csr_gpio_config_gpio_9config_out (gpio_dir[9]),
        .csr_gpio_config_gpio_10config_out(gpio_dir[10]),
        .csr_gpio_config_gpio_11config_out(gpio_dir[11]),
        .csr_gpio_config_gpio_12config_out(gpio_dir[12]),
        .csr_gpio_config_gpio_13config_out(gpio_dir[13]),
        .csr_gpio_config_gpio_14config_out(gpio_dir[14]),
        .csr_gpio_config_gpio_15config_out(gpio_dir[15]),

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
endmodule
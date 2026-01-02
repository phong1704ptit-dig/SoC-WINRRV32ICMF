`timescale 1ns / 1ps

module tb_Top();

    // Tín hiệu test
    reg clk;
    reg reset_n;
    reg reset_boot;

    // Các chân I/O khác để trống hoặc nối mặc định
    wire uart_tx;
    reg uart_rx = 1'b1;

    wire [3:0] PWM;
    wire [15:0] leds;

    wire sda, scl;
    reg MISO = 1'b0;
    wire MOSI;
    wire SCLK;
    wire SSS;
    wire SS;

    // Clock 50 MHz = 20 ns period
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Reset khởi động ban đầu
    initial begin
        reset_n = 0;
        #100;
        reset_n = 1;     // Bỏ reset sau 100 ns
    end

    // Gọi module thiết kế
    Top uut (
        .clk(clk),
        .reset_n(reset_n),
        .reset_boot(reset_boot),
        .uart_tx(uart_tx),
        .uart_rx(uart_rx),
        .PWM(PWM),
        .leds(leds),
        .sda(sda),
        .scl(scl),
        .MISO(MISO),
        .MOSI(MOSI),
        .SCLK(SCLK),
        .SSS(SSS),
        .SS(SS)
    );

endmodule


module Device_select (
    input   [31:0]  addr,
    output          s3_sel_plic,
    output          s4_sel_gpio,
    output          s5_sel_i2c,
    output          s6_sel_uart,      
    output          s8_sel_timer,
    output          s9_sel_spi

);
   
    wire plic_space     = (addr[31:28] == 4'h3);
    wire gpio_space     = (addr[31:28] == 4'h4);
    wire i2c_space      = (addr[31:28] == 4'h5);
    wire uart_space     = (addr[31:28] == 4'h6);
    wire timer_space    = (addr[31:28] == 4'h8);
    wire spi_space      = (addr[31:28] == 4'h9);

    assign s3_sel_plic  = plic_space;
    assign s4_sel_gpio  = gpio_space;
    assign s5_sel_i2c   = i2c_space;
    assign s6_sel_uart  = uart_space;
    assign s8_sel_timer = timer_space;
    assign s9_sel_spi   = 0;

endmodule

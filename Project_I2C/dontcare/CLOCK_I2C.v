module clk_i2c(
    input clk27m,
    input [9:0] div,
    input rst,
    output clk_i2c
);
    wire [31:0] Devision;
    assign Devision = div/20;

    reg clk_i2ctemp = 0;
    integer countclk = 0;
    always @(posedge clk27m) begin
            if (countclk  < (Devision/2) - 1) countclk <= countclk + 1;  
            else begin
                countclk <= 0;
                clk_i2ctemp <= ~clk_i2ctemp;
            end
    end
    assign clk_i2c = clk_i2ctemp;
endmodule

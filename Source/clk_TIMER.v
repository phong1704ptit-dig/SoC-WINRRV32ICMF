module clk_timbase(
    input clk,
    input [31:0] prescaler,
    input rst,
    output reg clk_tim
);
    wire [31:0] Devision;
    assign Devision = prescaler;

    reg clk_timtemp = 0;
    integer countclk = 0;
    always @(posedge clk) begin
            if (countclk  < (Devision/2) - 1 + (Devision%2 == 1 && clk_timtemp == 1)) begin
                countclk <= countclk + 1;  
            end
            else begin
                countclk <= 0;
                clk_timtemp <= ~clk_timtemp;
            end
    end
    always @(posedge clk) clk_tim <= clk_timtemp;
endmodule

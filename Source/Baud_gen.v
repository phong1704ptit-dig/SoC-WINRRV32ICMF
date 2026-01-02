module baud_gen #(
    parameter integer CLK_FREQ  = 27_000_000  // clock input (Hz)
)(
    input  wire clk,
    input  wire rst_n,
    input  [16:0] baud_rate,
    output reg  tick            // 16x oversampling tick
);

    // tính toán hệ số chia (divisor)

    reg [10:0] r_reg;
    always @(posedge clk) r_reg <= CLK_FREQ / (16*baud_rate);

    always @(posedge clk) begin
        if (!rst_n) begin
            r_reg <= 0;
            tick  <= 1'b0;
        end 
        else if (r_reg == DVSR-1) begin
            r_reg <= 0;
            tick  <= 1'b1;   // tạo 1 xung tick mỗi khi đủ chu kỳ
        end 
        else begin
            r_reg <= r_reg + 1;
            tick  <= 1'b0;
        end
    end

endmodule
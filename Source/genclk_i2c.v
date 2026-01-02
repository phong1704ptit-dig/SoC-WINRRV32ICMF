module genclk_i2c #(
    parameter integer CLK_FREQ  = 25_000_000  // clock input (Hz)
)(
    input wire  [2:0]   mode,
    input               clkin,
    input               rst,
    output reg          clk_i2ctick
);
    //20 sample
    localparam  CNT10K  =   (((CLK_FREQ/1000)/10)/20);    //10KHz  - max 250
    localparam  CNT20K  =   (((CLK_FREQ/1000)/20)/20);    //20KHz
    localparam  CNT50K  =   (((CLK_FREQ/1000)/50)/20);   //50KHz
    localparam  CNT100K =   (((CLK_FREQ/1000)/100)/20);   //100KHz
    localparam  CNT150K =   (((CLK_FREQ/1000)/150)/20);   //150KHz
    localparam  CNT200K =   (((CLK_FREQ/1000)/200)/20);   //200KHz
    localparam  CNT250K =   (((CLK_FREQ/1000)/250)/20);   //250KHz
    localparam  CNT400K =   (((CLK_FREQ/1000)/400)/20);   //400KHz

    reg [ 8:0 ] CNT =   0;
    always @(posedge clkin) begin
        case(mode)
            3'b000: CNT <= CNT10K;
            3'b001: CNT <= CNT20K;
            3'b010: CNT <= CNT50K;
            3'b011: CNT <= CNT100K;
            3'b100: CNT <= CNT150K;
            3'b101: CNT <= CNT200K;
            3'b110: CNT <= CNT250K;
            3'b111: CNT <= CNT400K;
            default:CNT <= 1; 
        endcase
    end

    reg [ 9:0 ] r_reg =   1;
    always @(posedge clkin) begin
        if (!rst) begin
            r_reg <= 1;
            clk_i2ctick  <= 1'b0;
        end 
        else if (r_reg >= CNT) begin
            r_reg <= 1;
            clk_i2ctick  <= 1'b1;   // tạo 1 xung tick mỗi khi đủ chu kỳ
        end 
        else begin
            r_reg <= r_reg + 1;
            clk_i2ctick  <= 1'b0;
        end
    end

endmodule
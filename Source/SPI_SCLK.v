/*           DTP D21DT166
Module cung cap tan so cho ngoai vi SPI
Lưu ý nó chỉ cung cấp 8 chu kì và hoạt
động tùy thuộc vào CPOL và DIV. Để sử 
dụng truyền liên tục cần liên tục cấp
xung start cho module.
*/

module SCLK_base#(
    parameter integer CLK_FREQ  = 50_000_000  // clock input (Hz)
)(
    input clk,
    input rst,
    input [6:0] i_BPT_SPI,
    input CPOL,
    input en,
    input start,
    input [2:0] clks,
    output reg done,
    output SCLK
);

    localparam IDLE_STATE = 0;
    localparam GEN_SCLK_STATE = 1;
    localparam DONE_STATE = 2;

    localparam CNT100K  =   (CLK_FREQ/100_000)/2;
    localparam CNT200K  =   (CLK_FREQ/200_000)/2;
    localparam CNT500K  =   (CLK_FREQ/500_000)/2;
    localparam CNT800K  =   (CLK_FREQ/800_000)/2;
    localparam CNT1M    =   (CLK_FREQ/1_000_000)/2;
    localparam CNT2M    =   (CLK_FREQ/2_000_000)/2;
    localparam CNT4M    =   (CLK_FREQ/4_000_000)/2;
    localparam CNT5M    =   (CLK_FREQ/5_000_000)/2;

    reg [ 7:0 ] CNT = 0;
    always @(posedge clk) begin
        case (clks) 
            3'b000: CNT <= CNT100K;
            3'b001: CNT <= CNT200K;
            3'b010: CNT <= CNT500K;
            3'b011: CNT <= CNT800K;
            3'b100: CNT <= CNT1M;
            3'b101: CNT <= CNT2M;
            3'b110: CNT <= CNT4M;
            3'b111: CNT <= CNT5M;
            default:CNT <= CNT500K; 
        endcase
    end

    reg SCLKtemp = 0;    assign SCLK = SCLKtemp;

    integer countclk = 0;
    integer cnt_edge = 0;
    integer state = 0;

    always @(posedge clk) begin
        if (~en || rst) begin
            cnt_edge <= 0;
            countclk <= 0;
            SCLKtemp <= CPOL;
            done <= 0;
            state <= 0;
            if (!en) SCLKtemp <= 1'bz;
        end
        else begin
            done <= 0;
            case (state) 
                IDLE_STATE: begin
                  	SCLKtemp <= CPOL;
                    if (start) begin
                        state <= GEN_SCLK_STATE;
                    end
                end
                GEN_SCLK_STATE: begin
                    if (cnt_edge < ((CPOL)?i_BPT_SPI*2:i_BPT_SPI*2)) begin
                        if (countclk  < CNT) begin
                            countclk <= countclk + 1;  
                        end
                        else begin
                            countclk <= 0;
                            cnt_edge <= cnt_edge + 1;
                            SCLKtemp <= ~SCLKtemp;
                        end
                    end
                    else begin
                        state <= DONE_STATE;
                      	cnt_edge <= 0;
                    end
                end
                DONE_STATE: begin
                    done <= 1;
                  	SCLKtemp <= CPOL;
                    if (~start) state <= IDLE_STATE;
                end
            endcase
        end
    end

endmodule

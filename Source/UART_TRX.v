/*                  DTP B21DT166
Module chức năng UART hỗ trợ truyền song công
Để gửi dữ liệu cần set bit yêu cầu truyền và reset sau đó
Để nhận dữ liệu cần kiểm tra bit RXNE và đọc dữ liệu từ
thanh ghi data_rx
Không có ngắt nên cần lưu ý khi kiểm tra bit RXNE chỉ được
set trong 1 chu kỳ.
*/

/*
Thanh ghi cấu hình
    B[0]: EN
    B[1]: STRTX
    B[7:4]: BR: bandrate 
        0000: 600
        0001: 1200
        0010: 2400
        0011: 4800
        0100: 9600
        0101: 14400
        0110: 19200
        0111: 38400
        1000: 56000
        1001: 57600
        1111: 115200
    B[15:8]: CLK: chứa tốc hệ thống khai báo. Không hỗ trợ chia tần
Thanh ghi trạng thái
    B[0]: TBUSY
    B[1]: RXNE

Thanh ghi dữ liệu TX
Thanh ghi dữ liệu RX
*/
//module UART
//	#(parameter	CLOCK = 2_700_000,
//			BAUD_RATE = 115_200) (
//	input       i_clk,                      //CLOCK hệ thống
//    input       i_rst,                      //Reset đồng bộ tích cực thấp
//    input       i_en,                       //Cờ bật trạng thái hoạt động của ngoại vi UART 
//    input       i_str_tx,                   //Cờ bật yêu cầu truyền cho ngoại vi UART
//    input [7:0] i_data_tx,                  //Bit_f chứa dữ liệu 8 bit muốn truyền đi  
//    input [3:0] i_br,                       //Bit_f chứa tốc độ band của ngoại vi UART
//    input [7:0] i_clk_dec,                  //Bit_f khai báo tần số hệ thống. Chỉ sử dụng tần số hệ thống không hỗ trợ chia tần
//    
//	input       i_RX,
//	output      o_TX,

//    output reg  irqs1_rxuart,               //Ngắt khi nhận đc kí tự
//    output reg  irqs2_txuart,               //Ngắt khi gửi xong kí tự

//    output      o_busy_tx,                  //Cờ báo hiệu ngoại vi UART đang bận truyền
//    output      o_RXNE,                     //Cờ báo hiệu ngoại vi UART nhận được đủ 8bit từ bên truyền
//    output [7:0]o_data_rx                   //Bit_f chứa dữ liệu 8 bit nhận được từ bên truyền

	//output      o_blink_led               //Thiết kế để TEST
//);




///////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////UART_TX////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////
module uart_tx # ( 
    parameter   DBIT = 8, // # data bits 
                SB_TICK = 16 // # ticks for stop bits 
)(
    input   wire            clk, rst_n, 
    input   wire            tx_start , s_tick, 
    input   wire    [7:0]   din, 
    output  reg             tx_busy,
    output  reg             tx_done_tick , 
    output  wire            tx 
);

// synlbolic state declaration 
localparam [1:0]
                    idle = 2'b00, 
                    start = 2'b01, 
                    data = 2'b10, 
                    stop = 2'b11; 

// signal declaration 
reg     [1:0]       state_reg , state_next ; 
reg     [3:0]       s_reg , s_next; 
reg     [2:0]       n_reg, n_next; 
reg     [7:0]       b_reg , b_next; 
reg                 tx_reg , tx_next ; 


// body 
// FSMD state & data registers 
    always @(posedge clk) begin 
        if (!rst_n) begin 
            state_reg <= idle; 
            s_reg <= 0; 
            n_reg <= 0; 
            b_reg <= 0; 
            tx_reg <= 1'b1 ; 
        end     
        else begin 
            state_reg <= state_next; 
            s_reg <= s_next; 
            n_reg <= n_next; 
            b_reg <= b_next; 
            tx_reg <= tx_next; 
        end
    end

// FSMD next_state logic & functional units 
    always @(*) begin 
        state_next = state_reg; 
        tx_done_tick = 1'b0;
        tx_busy = 1'b0;
        s_next = s_reg; 
        n_next = n_reg; 
        b_next = b_reg; 
        tx_next = tx_reg; 
        case (state_reg) 
            idle: begin 
                tx_next = 1'b1; 
                if (tx_start) begin 
                    state_next = start ; 
                    s_next = 0; 
                    b_next = din; 
                end 
            end 
            start: begin 
                tx_busy = 1'b1;
                tx_next = 1'b0; 
                if (s_tick) 
                    if (s_reg==15) begin 
                        state_next = data; 
                        s_next = 0; 
                        n_next = 0; 
                    end 
                    else s_next = s_reg + 1; 
                end 
            data: begin 
                tx_busy = 1'b1;
                tx_next = b_reg[0] ; 
                if (s_tick) 
                    if (s_reg==15) begin 
                        s_next = 0; 
                        b_next = b_reg >> 1; 
                        if (n_reg==(DBIT - 1)) state_next = stop ; 
                        else n_next = n_reg + 1; 
                    end 
                    else s_next = s_reg + 1; 
            end 
            stop: begin 
                tx_busy = 1'b1;
                tx_next = 1'b1; 
                if (s_tick) 
                    if (s_reg==(SB_TICK - 1)) begin 
                        state_next = idle; 
                        tx_done_tick = 1'b1 ; 
                    end 
                    else s_next = s_reg + 1; 
            end 
        endcase 
    end 


//////////////////////////////////////////ASS//////////////////////////////////////////
assign tx = tx_reg; 


endmodule 


///////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////UART_RX////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////
module uart_rx # ( 
    parameter   DBIT = 8, // # data bits 
                SB_TICK = 16 // # ticks for stop bits 
)(
    input   wire            clk, rst_n, 
    input   wire            rx, s_tick,
    output  reg             rx_ne,
    output  reg             rx_done_tick, 
    output  wire    [7:0]   dout 
); 

// symbolic state declaration 
localparam [1:0]    idle = 2'b00, 
                    start = 2'b01, 
                    data = 2'b10, 
                    stop = 2'b11; 

// signal declaration 
reg     [1:0]   state_reg , state_next ; 
reg     [3:0]   s_reg , s_next ; 
reg     [2:0]   n_reg , n_next ; 
reg     [7:0]   b_reg , b_next ; 


// body
// FSMD state & data registers 
    always @(posedge clk) 
        if (!rst_n) begin 
            state_reg <= idle; 
            s_reg <= 0; 
            n_reg <= 0; 
            b_reg <= 0; 
        end 
        else begin 
            state_reg <= state_next ; 
            s_reg <= s_next; 
            n_reg <= n_next; 
            b_reg <= b_next; 
        end 

// FSMD next_state logic 
    reg rx_done_tickcom = 0;
    always @(*) begin 
        rx_ne = 1'b0;
        state_next = state_reg ; 
        rx_done_tickcom = 1'b0; 
        s_next = s_reg;
        n_next = n_reg; 
        b_next = b_reg; 
        case (state_reg) 
            idle: 
                if (~rx) begin 
                    state_next = start ; 
                    s_next = 0; 
                end 
            start: 
                if (s_tick) begin
                    if (s_reg==7) begin 
                        state_next = data; 
                        s_next = 0; 
                        n_next = 0; 
                    end 
                    else s_next = s_reg + 1; 
                end
            data: 
                if (s_tick) begin
                    if (s_reg==15) begin 
                        s_next = 0; 
                        b_next = {rx , b_reg[7:1]}; 
                        if (n_reg==(DBIT - 1)) state_next = stop ; 
                        else n_next = n_reg + 1; 
                    end 
                    else s_next = s_reg + 1; 
                end
            stop: 
                if (s_tick) begin
                    if (s_reg==(SB_TICK - 1)) begin 
                        state_next = idle; 
                        rx_ne = 1'b1;           //is tick. có thể phải sửa
                        rx_done_tickcom =1'b1; 
                    end 
                    else s_next = s_reg + 1; 
                end
        endcase 
    end 
    always @(posedge clk) rx_done_tick <= rx_done_tickcom;


//////////////////////////////////////////ASS//////////////////////////////////////////
	assign dout = b_reg; 



///////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////FOR TEST//////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
/*
	always@(posedge i_clk, negedge i_rst) begin
		if (!i_rst)
			r_blink_led <= 0;
		else if (r_RX_ready) begin
			if (ascii_data == 8'h31)
				r_blink_led <= 1;
			else if (ascii_data == 8'h30)
				r_blink_led <= 0;
		end
	end

	assign o_blink_led = r_blink_led;
*/
endmodule












module baud_gen #(
    parameter integer CLK_FREQ  = 3_375_000  // clock input (Hz)
)(
    input  wire clk,
    input  wire rst_n,
    input  [3:0] baud_rate,
    output reg  tick            // 16x oversampling tick
);

    localparam CNTBR600     =   CLK_FREQ / (16*600);
    localparam CNTBR1200    =   CLK_FREQ / (16*1200);
    localparam CNTBR2400    =   CLK_FREQ / (16*2400);
    localparam CNTBR4800    =   CLK_FREQ / (16*4800);
    localparam CNTBR9600    =   CLK_FREQ / (16*9600);
    localparam CNTBR14400   =   CLK_FREQ / (16*14400);
    localparam CNTBR19200   =   CLK_FREQ / (16*19200);
    localparam CNTBR38400   =   CLK_FREQ / (16*38400);
    localparam CNTBR56000   =   CLK_FREQ / (16*56000);
    localparam CNTBR57600   =   CLK_FREQ / (16*57600);
    localparam CNTBR115200  =   CLK_FREQ / (16*115200);
    

    // tính toán hệ số chia (divisor)
    reg [10:0] r_reg;
    reg [12:0] CNT;
    always @(posedge clk) begin
        case (baud_rate)
            4'b0000: CNT <= CNTBR600;
            4'b0001: CNT <= CNTBR1200;
            4'b0010: CNT <= CNTBR2400;
            4'b0011: CNT <= CNTBR4800;
            4'b0100: CNT <= CNTBR9600;
            4'b0101: CNT <= CNTBR14400;
            4'b0110: CNT <= CNTBR19200;
            4'b0111: CNT <= CNTBR38400;
            4'b1000: CNT <= CNTBR56000;
            4'b1001: CNT <= CNTBR57600;
            default: CNT <= CNTBR115200;
        endcase
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            r_reg <= 0;
            tick  <= 1'b0;
        end 
        else if (r_reg >= CNT-1) begin
            r_reg <= 0;
            tick  <= 1'b1;   // tạo 1 xung tick mỗi khi đủ chu kỳ
        end 
        else begin
            r_reg <= r_reg + 1;
            tick  <= 1'b0;
        end
    end

endmodule



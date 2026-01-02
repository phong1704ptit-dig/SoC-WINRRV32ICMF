//module flag_buf #(
//    parameter W = 8 // # buffer bits 
//)( 
//    input   wire                clk, rst_n, 
//    input   wire                clr_flag, set_flag, 
//    input   wire    [W-1:0]     din, 
//    output  wire                flag, 
//    output  wire    [W-1:0]     dout 
//); 


 //signal declaration 
//reg     [W-1:0]     buf_reg, buf_next; 
//reg                 flag_reg, flag_next;

// 
// body 
// FF & register 
//    always @ (posedge clk) 
//        if (!rst_n) begin 
//            buf_reg <= 0; 
//            flag_reg <= 1'b0; 
//        end 
//        else begin 
//            buf_reg <= buf_next ; 
//            flag_reg <= flag_next; 
//        end 


// next-state logic 
//    always @(*) begin 
//        buf_next = buf_reg; 
//        flag_next = flag_reg; 
//        if (set_flag) begin 
//            buf_next = din; 
//            flag_next = 1'b1; 
//        end 
//        else if (clr_flag) flag_next = l'bO; 
//    end 


// output logic 

//assign dout = buf-reg; 
//assign flag = flag-reg; 


//endmodule


module baudb_gen #(
    parameter integer CLK_FREQ  = 27_000_000,  // clock input (Hz)
    parameter integer BAUD_RATE = 9600     // desired baud rate
)(
    input  wire clk,
    input  wire rst_n,
    output reg  tick            // 16x oversampling tick
);

    // tính toán hệ số chia (divisor)
    localparam integer DVSR = CLK_FREQ / (16 * BAUD_RATE);
    localparam integer DVSR_BIT = $clog2(DVSR);

    reg [DVSR_BIT-1:0] r_reg;

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







module uartb_rx # ( 
    parameter   DBIT = 8, // # data bits 
                SB_TICK = 16 // # ticks for stop bits 
)(
    input   wire            clk, rst_n, 
    input   wire            rx, s_tick, 
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
    always @(*) begin 
        state_next = state_reg ; 
        rx_done_tick = 1'b0; 
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
                if (s_tick) 
                    if (s_reg==7) begin 
                        state_next = data; 
                        s_next = 0; 
                        n_next = 0; 
                    end 
                else s_next = s_reg + 1; 
            data: 
                if (s_tick) 
                    if (s_reg==15) begin 
                        s_next = 0; 
                        b_next = {rx , b_reg[7:1]}; 
                        if (n_reg==(DBIT - 1)) state_next = stop ; 
                        else n_next = n_reg + 1; 
                    end 
                else s_next = s_reg + 1; 
            stop: 
                if (s_tick) 
                    if (s_reg==(SB_TICK - 1)) begin 
                        state_next = idle; 
                        rx_done_tick =1'b1; 
                    end 
                else s_next = s_reg + 1; 
        endcase 
    end 


// output 
assign dout = b_reg; 


endmodule




module uartb_tx # ( 
    parameter   DBIT = 8, // # data bits 
                SB_TICK = 16 // # ticks for stop bits 
)(
    input   wire            clk, rst_n, 
    input   wire            tx_start , s_tick, 
    input   wire    [7:0]   din, 
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
        s_next = s_reg; 
        n_next = n_reg; 
        b_next = b_reg; 
        tx_next = tx_reg; 
        case (state_reg) 
            idle: begin 
                tx_next = 1'b1 ; 
                if (tx_start) begin 
                    state_next = start ; 
                    s_next = 0; 
                    b_next = din; 
                end 
            end 
            start: begin 
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


// output 
assign tx = tx_reg; 


endmodule 
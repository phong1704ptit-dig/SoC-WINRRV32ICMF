
`include "Define.vh"
`ifdef RADIX_8

module ALU_div(
    input                   clk,
    input   wire    [31:0 ] dividend,
    input   wire    [31:0 ] divisor,
    input   wire            invalid,
    input   wire            Signed,

    output          [31:0 ] quotient,
    output          [31:0 ] result_REM,
    output                  ovalid
);
    reg [ 4:0 ] state = 0;
    reg [ 4:0 ] state_next = 0;
    reg [31:0 ] r_quotient, r_quotient_next;
    reg [63:0 ] r_ram = 64'd0;
    reg [63:0 ] r_ram_next = 64'd0;
    reg [31:0 ] r_divisor, r_divisor_next;
    reg [31:0 ] r_dividend, r_dividend_next;
    reg         r_signed, r_signed_next;

//    reg [31:0 ] Tiny_inA, Tiny_inA_next;
//    reg [31:0 ] Tiny_inB, Tiny_inB_next;
    wire[ 2:0 ] Tiny_qua;
    reg         r_ovalid, r_ovalid_next;
    reg         r_dividend_sign, r_dividend_sign_next;
    reg         r_divisor_sign, r_divisor_sign_next;


    assign ovalid = r_ovalid;
    assign quotient = r_quotient;
    assign result_REM = r_ram[63:32];

    TinyDIV tinydiv(
        .clk(clk),
        .inA(r_ram[63:32]),
        .inB(r_divisor),
        .Tiny_qua(Tiny_qua)
    );
    
    always @(posedge clk) begin
        state <= state_next;
        r_quotient <= r_quotient_next;
        r_ram <= r_ram_next;
//        Tiny_inA <= Tiny_inA_next;
//        Tiny_inB <= Tiny_inB_next;
        r_ovalid <= r_ovalid_next;
        r_dividend_sign <= r_dividend_sign_next;
        r_divisor_sign <= r_divisor_sign_next;
        r_divisor <= r_divisor_next;
        r_dividend <= r_dividend_next;
        r_signed <= r_signed_next;
    end

    always @(*) begin
        r_ram_next = r_ram;
        r_quotient_next = r_quotient;
        state_next = state;
//        Tiny_inA_next = Tiny_inA;
//        Tiny_inB_next = Tiny_inB;
        r_ovalid_next = 0;
        r_dividend_sign_next = r_dividend_sign;
        r_divisor_sign_next = r_divisor_sign;
        r_signed_next = r_signed;
        r_divisor_next = r_divisor;
        r_dividend_next = r_dividend;

//        (*parallel_case*)
        case (state) 
            0: begin
                r_dividend_sign_next = dividend[31];
                r_divisor_sign_next = divisor[31];
                r_divisor_next = divisor;
                r_dividend_next = dividend;
                r_signed_next = Signed;
                if(invalid) begin
                    state_next = 1;
                end
            end
            1: begin
                r_ram_next[33:0] = ((r_signed & r_dividend[31])?(~r_dividend)+1:r_dividend) << 2;
                r_divisor_next = (r_signed & r_divisor[31])?(~r_divisor)+1:r_divisor;
                r_ram_next[63:34] = 0;
                r_quotient_next = 32'b0;
                state_next = 3;
            end
            3: begin
                r_quotient_next = (r_quotient<<3) + Tiny_qua;
                r_ram_next = { (r_ram[63:32] - Tiny_qua*r_divisor), r_ram[31:0] } << 3;
//                r_ram_next = r_ram << 3;
                state_next = 4;
            end
            4: begin
                r_quotient_next = (r_quotient<<3) + Tiny_qua;
                r_ram_next = { (r_ram[63:32] - Tiny_qua*r_divisor), r_ram[31:0] } << 3;
//                r_ram_next = r_ram << 3;
                state_next = 5;
            end
            5: begin
                r_quotient_next = (r_quotient<<3) + Tiny_qua;
                r_ram_next = { (r_ram[63:32] - Tiny_qua*r_divisor), r_ram[31:0] } << 3;
//                r_ram_next = r_ram << 3;
                state_next = 6;
            end
            6: begin
                r_quotient_next = (r_quotient<<3) + Tiny_qua;
                r_ram_next = { (r_ram[63:32] - Tiny_qua*r_divisor), r_ram[31:0] } << 3;
//                r_ram_next = r_ram << 3;
                state_next = 7;
            end
            7: begin
                r_quotient_next = (r_quotient<<3) + Tiny_qua;
               r_ram_next = { (r_ram[63:32] - Tiny_qua*r_divisor), r_ram[31:0] } << 3;
//                r_ram_next = r_ram << 3;
                state_next = 8;
            end
            8: begin
                r_quotient_next = (r_quotient<<3) + Tiny_qua;
                r_ram_next = { (r_ram[63:32] - Tiny_qua*r_divisor), r_ram[31:0] } << 3;
//                r_ram_next = r_ram << 3;
                state_next = 9;
            end
            9: begin
                r_quotient_next = (r_quotient<<3) + Tiny_qua;
                r_ram_next = { (r_ram[63:32] - Tiny_qua*r_divisor), r_ram[31:0] } << 3;
//                r_ram_next = r_ram << 3;
                state_next = 10;
            end
            10: begin
                r_quotient_next = (r_quotient<<3) + Tiny_qua;
                r_ram_next = { (r_ram[63:32] - Tiny_qua*r_divisor), r_ram[31:0] } << 3;
//                r_ram_next = r_ram << 3;
                state_next = 11;
            end
            11: begin
                r_quotient_next = (r_quotient<<3) + Tiny_qua;
                r_ram_next = { (r_ram[63:32] - Tiny_qua*r_divisor), r_ram[31:0] } << 3;
//                r_ram_next = r_ram << 3;
                state_next = 12;
            end
            12: begin
                r_quotient_next = (r_quotient<<3) + Tiny_qua;
                r_ram_next = { (r_ram[63:32] - Tiny_qua*r_divisor), r_ram[31:0] } << 3;
//                r_ram_next = r_ram << 3;
                state_next = 13;
            end
            13: begin
                r_quotient_next = (r_quotient<<3) + Tiny_qua;
                r_ram_next[63:32] = (r_ram[63:32] - Tiny_qua*r_divisor);
                state_next = 14;
            end
            14: begin
                if(r_signed) begin  
                    if(r_dividend_sign) r_ram_next[63:32] = (~r_ram[63:32]) + 1;
                    if(r_dividend_sign ^ r_divisor_sign) r_quotient_next = (~r_quotient) + 1;
                end
                state_next = 15;
            end
            15: begin
                r_ovalid_next = 1;
                state_next = 0;
            end
        endcase
    end
endmodule

module TinyDIV(
    input   wire            clk,
    input   wire    [31:0 ] inA,
    input   wire    [31:0 ] inB,
    output  reg     [ 2:0 ] Tiny_qua
);
    always @(*) begin
        if(inA < inB) Tiny_qua = 0;
        else if(inA < inB<<1) Tiny_qua = 1;
        else if(inA < (inB<<1) + inB) Tiny_qua = 2;
        else if(inA < inB<<2) Tiny_qua = 3;
        else if(inA < (inB<<2) + inB) Tiny_qua = 4;
        else if(inA < (inB<<2) + (inB<<1)) Tiny_qua = 5;
        else if(inA < (inB<<2) + (inB<<1) + inB) Tiny_qua = 6;
        else Tiny_qua = 7;
    end
endmodule
`endif





`ifdef RADIX_4
module ALU_div(
    input                   clk,
    input   wire    [31:0 ] dividend,
    input   wire    [31:0 ] divisor,
    input   wire            invalid,
    input   wire            Signed,

    output          [31:0 ] quotient,
    output          [31:0 ] result_REM,
    output                  ovalid
);
    reg [ 4:0 ] state = 0;
    reg [ 4:0 ] state_next = 0;
    reg [31:0 ] r_quotient, r_quotient_next;
    reg [63:0 ] r_ram = 64'd0;
    reg [63:0 ] r_ram_next = 64'd0;
    reg [31:0 ] r_divisor, r_divisor_next;
    reg [31:0 ] r_dividend, r_dividend_next;
    reg         r_signed, r_signed_next;

//    reg [31:0 ] Tiny_inA, Tiny_inA_next;
//    reg [31:0 ] Tiny_inB, Tiny_inB_next;
    wire[ 1:0 ] Tiny_qua;
    reg         r_ovalid, r_ovalid_next;
    reg         r_dividend_sign, r_dividend_sign_next;
    reg         r_divisor_sign, r_divisor_sign_next;


    assign ovalid = r_ovalid;
    assign quotient = r_quotient;
    assign result_REM = r_ram[63:32];

    TinyDIV tinydiv(
        .clk(clk),
        .inA(r_ram[63:32]),
        .inB(r_divisor),
        .Tiny_qua(Tiny_qua)
    );
    
    always @(posedge clk) begin
        state <= state_next;
        r_quotient <= r_quotient_next;
        r_ram <= r_ram_next;
//        Tiny_inA <= Tiny_inA_next;
//        Tiny_inB <= Tiny_inB_next;
        r_ovalid <= r_ovalid_next;
        r_dividend_sign <= r_dividend_sign_next;
        r_divisor_sign <= r_divisor_sign_next;
        r_divisor <= r_divisor_next;
        r_dividend <= r_dividend_next;
        r_signed <= r_signed_next;
    end

    always @(*) begin
        r_ram_next = r_ram;
        r_quotient_next = r_quotient;
        state_next = state;
//        Tiny_inA_next = Tiny_inA;
//        Tiny_inB_next = Tiny_inB;
        r_ovalid_next = 0;
        r_dividend_sign_next = r_dividend_sign;
        r_divisor_sign_next = r_divisor_sign;
        r_signed_next = r_signed;
        r_divisor_next = r_divisor;
        r_dividend_next = r_dividend;

//        (*parallel_case*)
        case (state) 
            0: begin
                r_dividend_sign_next = dividend[31];
                r_divisor_sign_next = divisor[31];
                r_divisor_next = divisor;
                r_dividend_next = dividend;
                r_signed_next = Signed;
                if(invalid) begin
                    state_next = 1;
                end
            end
            1: begin
                r_ram_next[33:0] = ((r_signed & r_dividend[31])?(~r_dividend)+1:r_dividend) << 2;
                r_divisor_next = (r_signed & r_divisor[31])?(~r_divisor)+1:r_divisor;
                r_ram_next[63:34] = 0;
                r_quotient_next = 32'b0;
                state_next = 3;
            end
            3: begin
                r_quotient_next = (r_quotient<<2) + Tiny_qua;
                r_ram_next = { (r_ram[63:32] - Tiny_qua*r_divisor), r_ram[31:0] } << 2;
//                r_ram_next = r_ram << 3;
                state_next = 4;
            end
            4: begin
                r_quotient_next = (r_quotient<<2) + Tiny_qua;
                r_ram_next = { (r_ram[63:32] - Tiny_qua*r_divisor), r_ram[31:0] } << 2;
//                r_ram_next = r_ram << 3;
                state_next = 5;
            end
            5: begin
                r_quotient_next = (r_quotient<<2) + Tiny_qua;
                r_ram_next = { (r_ram[63:32] - Tiny_qua*r_divisor), r_ram[31:0] } << 2;
//                r_ram_next = r_ram << 3;
                state_next = 6;
            end
            6: begin
                r_quotient_next = (r_quotient<<2) + Tiny_qua;
                r_ram_next = { (r_ram[63:32] - Tiny_qua*r_divisor), r_ram[31:0] } << 2;
//                r_ram_next = r_ram << 3;
                state_next = 7;
            end
            7: begin
                r_quotient_next = (r_quotient<<2) + Tiny_qua;
               r_ram_next = { (r_ram[63:32] - Tiny_qua*r_divisor), r_ram[31:0] } << 2;
//                r_ram_next = r_ram << 3;
                state_next = 8;
            end
            8: begin
                r_quotient_next = (r_quotient<<2) + Tiny_qua;
                r_ram_next = { (r_ram[63:32] - Tiny_qua*r_divisor), r_ram[31:0] } << 2;
//                r_ram_next = r_ram << 3;
                state_next = 9;
            end
            9: begin
                r_quotient_next = (r_quotient<<2) + Tiny_qua;
                r_ram_next = { (r_ram[63:32] - Tiny_qua*r_divisor), r_ram[31:0] } << 2;
//                r_ram_next = r_ram << 3;
                state_next = 10;
            end
            10: begin
                r_quotient_next = (r_quotient<<2) + Tiny_qua;
                r_ram_next = { (r_ram[63:32] - Tiny_qua*r_divisor), r_ram[31:0] } << 2;
//                r_ram_next = r_ram << 3;
                state_next = 11;
            end
            11: begin
                r_quotient_next = (r_quotient<<2) + Tiny_qua;
                r_ram_next = { (r_ram[63:32] - Tiny_qua*r_divisor), r_ram[31:0] } << 2;
//                r_ram_next = r_ram << 3;
                state_next = 12;
            end
            12: begin
                r_quotient_next = (r_quotient<<2) + Tiny_qua;
                r_ram_next = { (r_ram[63:32] - Tiny_qua*r_divisor), r_ram[31:0] } << 2;
//                r_ram_next = r_ram << 3;
                state_next = 13;
            end
            13: begin
                r_quotient_next = (r_quotient<<2) + Tiny_qua;
                r_ram_next = { (r_ram[63:32] - Tiny_qua*r_divisor), r_ram[31:0] } << 2;
//                r_ram_next = r_ram << 3;
                state_next = 14;
            end
            14: begin
                r_quotient_next = (r_quotient<<2) + Tiny_qua;
                r_ram_next = { (r_ram[63:32] - Tiny_qua*r_divisor), r_ram[31:0] } << 2;
//                r_ram_next = r_ram << 3;
                state_next = 15;
            end
            15: begin
                r_quotient_next = (r_quotient<<2) + Tiny_qua;
                r_ram_next = { (r_ram[63:32] - Tiny_qua*r_divisor), r_ram[31:0] } << 2;
//                r_ram_next = r_ram << 3;
                state_next = 16;
            end
            16: begin
                r_quotient_next = (r_quotient<<2) + Tiny_qua;
                r_ram_next = { (r_ram[63:32] - Tiny_qua*r_divisor), r_ram[31:0] } << 2;
//                r_ram_next = r_ram << 3;
                state_next = 17;
            end
            17: begin
                r_quotient_next = (r_quotient<<2) + Tiny_qua;
                r_ram_next = { (r_ram[63:32] - Tiny_qua*r_divisor), r_ram[31:0] } << 2;
//                r_ram_next = r_ram << 3;
                state_next = 18;
            end
            18: begin
                r_quotient_next = (r_quotient<<2) + Tiny_qua;
                r_ram_next[63:32] = (r_ram[63:32] - Tiny_qua*r_divisor);
                state_next = 19;
            end
            19: begin
                if(r_signed) begin  
                    if(r_dividend_sign) r_ram_next[63:32] = (~r_ram[63:32]) + 1;
                    if(r_dividend_sign ^ r_divisor_sign) r_quotient_next = (~r_quotient) + 1;
                end
                state_next = 20;
            end
            20: begin
                r_ovalid_next = 1;
                state_next = 0;
            end
            default: state_next= 0;
        endcase
    end
endmodule

module TinyDIV(
    input   wire            clk,
    input   wire    [31:0 ] inA,
    input   wire    [31:0 ] inB,
    output  reg     [ 1:0 ] Tiny_qua
);
    always @(*) begin
        if(inA < inB) Tiny_qua = 0;
        else if(inA < inB<<1) Tiny_qua = 1;
        else if(inA < (inB<<1) + inB) Tiny_qua = 2;
        else Tiny_qua = 3;
    end
endmodule
`endif

`ifdef USE_DSP
module ALU_div(
    input                   clk,
    input   wire    [31:0 ] dividend,
    input   wire    [31:0 ] divisor,
    input   wire            invalid,
    input   wire            Signed,

    output          [31:0 ] quotient,
    output          [31:0 ] result_REM,
    output                  ovalid
);
    reg [ 2:0 ] state = 0;
    reg [ 2:0 ] state_next = 0;

    reg [39:0 ] Divisor_data = 0;
    reg [39:0 ] Divisor_data_next = 0;  

    reg [39:0 ] Dividend_data = 0;
    reg [39:0 ] Dividend_data_next = 0;

    reg         Divisor_tvalid = 0;
    reg         Divisor_tvalid_next = 0;
 
    reg         Dividend_tvalid = 0;
    reg         Dividend_tvalid_next = 0;

    wire        Divisor_tready;
    wire        Dividend_tready;
    wire        Dout_tvalid;
    wire[79:0 ] Dout_data;

    reg [31:0 ] quotient_result = 0;
    reg [31:0 ] quotient_result_next = 0; 

    reg [31:0 ] remainder_result = 0;
    reg [31:0 ] remainder_result_next = 0;

    reg         div_done = 0;
    reg         div_done_next = 0;


    assign quotient = quotient_result;
    assign result_REM = remainder_result;
    assign ovalid = div_done;


    DIV_IP divip(
        .clkin              (clk),

        .Divisor_data       (Divisor_data),
        .Divisor_tvalid     (Divisor_tvalid),
        .Divisor_tready     (Divisor_tready),

        .Dividend_data      (Dividend_data),
        .Dividend_tvalid    (Dividend_tvalid),
        .Dividend_tready    (Dividend_tready),
        
        .Dout_data          (Dout_data),
        .Dout_tvalid        (Dout_tvalid)
    );


    always @(posedge clk) begin
        state <= state_next;
        Dividend_data <= Dividend_data_next;
        Divisor_data <= Divisor_data_next;
        Dividend_tvalid <= Dividend_tvalid_next;
        Divisor_tvalid <= Divisor_tvalid_next;
        quotient_result <= quotient_result_next;
        remainder_result <= remainder_result_next;
        div_done <= div_done_next;
    end

    always @(*) begin
        state_next = state;
        Dividend_data_next = Dividend_data;
        Divisor_data_next = Divisor_data;
        Dividend_tvalid_next = 0;
        Divisor_tvalid_next = 0;
        quotient_result_next = quotient_result;
        remainder_result_next = remainder_result;
        div_done_next = 0;
        case (state) 
            0: begin
                if(invalid) begin
                    if(Signed) begin
                        Divisor_data_next = {{8{divisor[31]}},divisor};
                        Dividend_data_next = {{8{dividend[31]}},dividend};
                    end
                    else begin
                        Divisor_data_next = {8'd0,divisor};
                        Dividend_data_next = {8'd0,dividend};
                    end
                    state_next = 1;
                end
            end
            1: begin
                if(Divisor_tready & Dividend_tready) begin
                    Dividend_tvalid_next = 1;
                    Divisor_tvalid_next = 1;
                    state_next = 2;
                end
            end
            2: begin
                if(Dout_tvalid) begin
                    quotient_result_next = Dout_data[71:40];//Do bản chất là chia 32bit. Mở rộng chia 33bit chỉ để thực thi có dấu và không dấu linh hoạt
                    remainder_result_next = Dout_data[31:0];
                    div_done_next = 1;
                    state_next = 0;
                end
            end
        endcase
    end
  

endmodule
`endif
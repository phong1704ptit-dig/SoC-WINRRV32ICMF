`include "Define.vh"

module ALU_mul(
    input           clk,
    input signed   [31:0 ] A,
    input signed   [31:0 ] B,
    input           invalid,
    input           Signed,
    input           Unsigned,
    input           SU,        

    output signed  [63:0 ] P,
    output          valid
);

`ifdef RADIX_4_9CYC
    localparam PREPARE0= 0;
    localparam PREPARE1= 1;
    localparam PREPARE2= 2;
    localparam MUL_ONE = 3;
    localparam MUL_TWO = 4;
    localparam SUM_ONE = 5;
    localparam SUM_TWO = 6;
    localparam SUM_THR = 7;
    localparam SUM_FOU = 8;

    
    wire signed    [33:0 ] tiny_resonn;
    wire signed    [33:0 ] tiny_restw;
    wire signed    [33:0 ] tiny_resth;
    wire signed    [33:0 ] tiny_resfoo;
    wire signed    [33:0 ] tiny_resfoi;
    wire signed    [33:0 ] tiny_ressi;
    wire signed    [33:0 ] tiny_resse;
    wire signed    [33:0 ] tiny_resei;
    wire signed    [33:0 ] tiny_resbend;    
    
    reg  signed    [63:0] part_result0 = 0;
    reg  signed    [63:0] part_result1 = 0;
    reg  signed    [63:0] part_result2 = 0;
    reg  signed    [63:0] part_result3 = 0;
    reg  signed    [63:0] part_result4 = 0;
    reg  signed    [63:0] part_result5 = 0;
    reg  signed    [63:0] part_result6 = 0;
    reg  signed    [63:0] part_result7 = 0;
    reg  signed    [63:0] part_result8 = 0;
    reg  signed    [63:0] part_result9 = 0;
    reg  signed    [63:0] part_result10= 0;
    reg  signed    [63:0] part_result11= 0;
    reg  signed    [63:0] part_result12= 0;
    reg  signed    [63:0] part_result13= 0;
    reg  signed    [63:0] part_result14= 0;
    reg  signed    [63:0] part_result15= 0;

    reg  signed    [63:0] part_result0_next = 0;
    reg  signed    [63:0] part_result1_next = 0;
    reg  signed    [63:0] part_result2_next = 0;
    reg  signed    [63:0] part_result3_next = 0;
    reg  signed    [63:0] part_result4_next = 0;
    reg  signed    [63:0] part_result5_next = 0;
    reg  signed    [63:0] part_result6_next = 0;
    reg  signed    [63:0] part_result7_next = 0;
    reg  signed    [63:0] part_result8_next = 0;
    reg  signed    [63:0] part_result9_next = 0;
    reg  signed    [63:0] part_result10_next= 0;
    reg  signed    [63:0] part_result11_next= 0;
    reg  signed    [63:0] part_result12_next= 0;
    reg  signed    [63:0] part_result13_next= 0;
    reg  signed    [63:0] part_result14_next= 0;
    reg  signed    [63:0] part_result15_next= 0;
    
    reg  signed    [63:0] part_resultBend_next = 0;
    reg  signed    [63:0] part_resultBend      = 0;

    reg     [ 3:0 ] state = 0;
    reg     [ 3:0 ] state_next = 0;
    reg  signed    [63:0 ] result = 0;
    reg  signed    [63:0 ] result_next = 0;
    reg             ivalid, ivalid_next;
    reg  signed    [32:0 ] inA = 0;
    reg  signed    [32:0 ] inA_next = 0;
    reg  signed    [32:0 ] inB = 0;
    reg  signed    [32:0 ] inB_next = 0;
    reg            [ 2:0 ] tiny_inB = 0;
    reg            [ 2:0 ] tiny_inB_next = 0;
    reg            [ 2:0 ] tiny_inC = 0;
    reg            [ 2:0 ] tiny_inC_next = 0;
    reg            [ 2:0 ] tiny_inD = 0;
    reg            [ 2:0 ] tiny_inD_next = 0;
    reg            [ 2:0 ] tiny_inE = 0;
    reg            [ 2:0 ] tiny_inE_next = 0;
    reg            [ 2:0 ] tiny_inF = 0;
    reg            [ 2:0 ] tiny_inF_next = 0;
    reg            [ 2:0 ] tiny_inG = 0;
    reg            [ 2:0 ] tiny_inG_next = 0;
    reg            [ 2:0 ] tiny_inH = 0;
    reg            [ 2:0 ] tiny_inH_next = 0;
    reg            [ 2:0 ] tiny_inI = 0;
    reg            [ 2:0 ] tiny_inI_next = 0;
    reg            [ 1:0 ] tiny_inBend = 0;
    reg            [ 1:0 ] tiny_inBend_next = 0;

    MUL_Radix4 tinymul(
        .clk(clk),
        .A(inA),
        .B(tiny_inB),
        .C(tiny_inC),
        .D(tiny_inD),
        .E(tiny_inE),
        .F(tiny_inF),
        .G(tiny_inG),
        .H(tiny_inH),
        .I(tiny_inI),

        .Bend(tiny_inBend),
        .res_bend(tiny_resbend),

        .res_on(tiny_resonn),
        .res_tw(tiny_restw),
        .res_th(tiny_resth),
        .res_fo(tiny_resfoo),
        .res_fi(tiny_resfoi),
        .res_si(tiny_ressi),
        .res_se(tiny_resse),
        .res_ei(tiny_resei)
    );

    assign valid = ivalid;
    assign P = result;

    always @(posedge clk) begin
        state <= state_next;
        part_result0 <= part_result0_next;
        part_result1 <= part_result1_next;
        part_result2 <= part_result2_next;
        part_result3 <= part_result3_next;
        part_result4 <= part_result4_next;
        part_result5 <= part_result5_next;
        part_result6 <= part_result6_next;
        part_result7 <= part_result7_next;
        part_result8 <= part_result8_next;
        part_result9 <= part_result9_next;
        part_result10 <= part_result10_next;
        part_result11 <= part_result11_next;
        part_result12 <= part_result12_next;
        part_result13 <= part_result13_next;
        part_result14 <= part_result14_next;
        part_result15 <= part_result15_next;
        part_resultBend <= part_resultBend_next;
        result <= result_next;
        ivalid <= ivalid_next;
        inB <= inB_next;
        inA <= inA_next;
        tiny_inB <= tiny_inB_next;
        tiny_inC <= tiny_inC_next;
        tiny_inD <= tiny_inD_next;
        tiny_inE <= tiny_inE_next;
        tiny_inF <= tiny_inF_next;
        tiny_inG <= tiny_inG_next;
        tiny_inH <= tiny_inH_next;
        tiny_inI <= tiny_inI_next;
        tiny_inBend <= tiny_inBend_next;
    end

    always @(*) begin
        state_next = state;
        part_result0_next  = part_result0;
        part_result1_next  = part_result1;
        part_result2_next  = part_result2;
        part_result3_next  = part_result3;
        part_result4_next  = part_result4;
        part_result5_next  = part_result5;
        part_result6_next  = part_result6;
        part_result7_next  = part_result7;
        part_result8_next  = part_result8;
        part_result9_next  = part_result9;
        part_result10_next = part_result10;
        part_result11_next = part_result11;
        part_result12_next = part_result12;
        part_result13_next = part_result13;
        part_result14_next = part_result14;
        part_result15_next = part_result15;
        part_resultBend_next = part_resultBend;
        inA_next = inA;
        inB_next = inB;
        result_next = result;
        tiny_inB_next = tiny_inB;
        tiny_inC_next = tiny_inC;
        tiny_inD_next = tiny_inD;
        tiny_inE_next = tiny_inE;
        tiny_inF_next = tiny_inF;
        tiny_inG_next = tiny_inG;
        tiny_inH_next = tiny_inH;
        tiny_inI_next = tiny_inI;
        tiny_inBend_next = tiny_inBend;
        ivalid_next = 0;
        case (state) 
            PREPARE0: begin
                (*parallel_case*)
                case (1'b1) 
                    Signed: begin
                        inA_next = {A[31], A};   inB_next = {B[31], B};
                    end
                    Unsigned: begin  
                        inA_next = {1'b0, A};
                        inB_next = {1'b0, B};
                    end
                    SU: begin
                        inA_next = {A[31], A};
                        inB_next = {1'b0, B};
                    end
                    default:;
                endcase
                if (invalid) begin
                    state_next = PREPARE1;                
                    result_next = 0;
                end
            end
            PREPARE1: begin
                tiny_inB_next = {inB[1:0], 1'b0};
                tiny_inC_next = inB[3:1];
                tiny_inD_next = inB[5:3];
                tiny_inE_next = inB[7:5];
                tiny_inF_next = inB[ 9:7 ];
                tiny_inG_next = inB[11:9 ];
                tiny_inH_next = inB[13:11];
                tiny_inI_next = inB[15:13];
                
                tiny_inBend_next = inB[32:31];
                state_next = PREPARE2;                
            end
            PREPARE2: begin
                tiny_inB_next = inB[17:15];
                tiny_inC_next = inB[19:17];
                tiny_inD_next = inB[21:19];
                tiny_inE_next = inB[23:21];
                tiny_inF_next = inB[25:23];
                tiny_inG_next = inB[27:25];
                tiny_inH_next = inB[29:27];
                tiny_inI_next = inB[31:29];
                state_next = MUL_ONE;
            end
            MUL_ONE: begin
                part_result0_next = tiny_resonn;
                part_result1_next = tiny_restw;
                part_result2_next = tiny_resth;
                part_result3_next = tiny_resfoo;
                part_result4_next = tiny_resfoi;
                part_result5_next = tiny_ressi;
                part_result6_next = tiny_resse;
                part_result7_next = tiny_resei;
            
                part_resultBend_next = tiny_resbend;
                state_next = MUL_TWO;
            end
            MUL_TWO: begin                
                part_result8_next  = tiny_resonn;
                part_result9_next  = tiny_restw;
                part_result10_next = tiny_resth;
                part_result11_next = tiny_resfoo;
                part_result12_next = tiny_resfoi;
                part_result13_next = tiny_ressi;
                part_result14_next = tiny_resse;
                part_result15_next = tiny_resei;

                result_next = result  + (part_resultBend<<32);
                state_next = SUM_ONE;
            end
            SUM_ONE: begin
                result_next = result + (part_result15<<30) + (part_result0) + (part_result8 <<16) + (part_result7<<14);
                state_next = SUM_TWO;
            end
            SUM_TWO: begin
                result_next = result + (part_result13<<26) + (part_result2<<4)  + (part_result10<<20) + (part_result5<<10);
                state_next = SUM_THR;
            end
            SUM_THR: begin
                result_next = result + (part_result11<<22) + (part_result4<<8) + (part_result12<<24) + (part_result3<<6);
                state_next = SUM_FOU;
            end
            SUM_FOU: begin
                result_next = result + (part_result9 <<18) + (part_result6<<12) + (part_result14<<28) + (part_result1<<2);
                ivalid_next = 1;
                state_next = PREPARE0;
            end
            default: state_next = PREPARE0;
        endcase
    end
`endif




`ifdef RADIX_4_15CYC
    localparam PREPARE0= 0;
    localparam PREPARE1= 1;
    localparam PREPARE2= 2;
    localparam MUL_ONE = 3;
    localparam MUL_TWO = 4;
    localparam MUL_THR = 5;
    localparam MUL_FOU = 6;
    localparam SUM_ONE = 7;
    localparam SUM_TWO = 8;
    localparam SUM_THR = 9;
    localparam SUM_FOU = 10;
    localparam SUM_FIV = 11;
    localparam SUM_SIX = 12;
    localparam SUM_SEV = 13;
    localparam SUM_EIG = 14;

    
    wire signed    [33:0 ] tiny_reson;
    wire signed    [33:0 ] tiny_restw;
    wire signed    [33:0 ] tiny_resth;
    wire signed    [33:0 ] tiny_resfo;
    wire signed    [33:0 ] tiny_resbend;    
    
    reg  signed    [63:0] part_result0, part_result1, part_result2, part_result3;
    reg  signed    [63:0] part_result4, part_result5, part_result6, part_result7;
    reg  signed    [63:0] part_result8, part_result9, part_result10, part_result11;
    reg  signed    [63:0] part_result12, part_result13, part_result14, part_result15;

    reg  signed    [63:0] part_result0_next, part_result1_next, part_result2_next, part_result3_next;
    reg  signed    [63:0] part_result4_next, part_result5_next, part_result6_next, part_result7_next;
    reg  signed    [63:0] part_result8_next, part_result9_next, part_result10_next, part_result11_next;
    reg  signed    [63:0] part_result12_next, part_result13_next, part_result14_next, part_result15_next;
    
    reg  signed    [63:0] part_resultBend_next, part_resultBend;

    reg     [ 3:0 ] state = 0;
    reg     [ 3:0 ] state_next = 0;
    reg     [63:0 ] result = 0;
    reg  signed    [63:0 ] result_next = 0;
    reg             ivalid, ivalid_next;
    reg  signed    [32:0 ] inA, inA_next;
    reg  signed    [32:0 ] inB, inB_next;
    reg  signed    [ 2:0 ] tiny_inB, tiny_inB_next;
    reg  signed    [ 2:0 ] tiny_inC, tiny_inC_next;
    reg  signed    [ 2:0 ] tiny_inD, tiny_inD_next;
    reg  signed    [ 2:0 ] tiny_inE, tiny_inE_next;
    reg  signed    [ 1:0 ] tiny_inBend, tiny_inBend_next;


    MUL_Radix4 tinymul(
        .clk(clk),
        .A(inA),
        .B(tiny_inB),
        .C(tiny_inC),
        .D(tiny_inD),
        .E(tiny_inE),
        .Bend(tiny_inBend),


        .res_on(tiny_reson),
        .res_tw(tiny_restw),
        .res_th(tiny_resth),
        .res_fo(tiny_resfo),
        .res_bend(tiny_resbend)
    );

    assign valid = ivalid;
    assign P = result;

    always @(posedge clk) begin
        state <= state_next;
        part_result0 <= part_result0_next;
        part_result1 <= part_result1_next;
        part_result2 <= part_result2_next;
        part_result3 <= part_result3_next;
        part_result4 <= part_result4_next;
        part_result5 <= part_result5_next;
        part_result6 <= part_result6_next;
        part_result7 <= part_result7_next;
        part_result8 <= part_result8_next;
        part_result9 <= part_result9_next;
        part_result10 <= part_result10_next;
        part_result11 <= part_result11_next;
        part_result12 <= part_result12_next;
        part_result13 <= part_result13_next;
        part_result14 <= part_result14_next;
        part_result15 <= part_result15_next;
        part_resultBend <= part_resultBend_next;
        result <= result_next;
        ivalid <= ivalid_next;
        inB <= inB_next;
        inA <= inA_next;
        tiny_inB <= tiny_inB_next;
        tiny_inC <= tiny_inC_next;
        tiny_inD <= tiny_inD_next;
        tiny_inE <= tiny_inE_next;
        tiny_inBend <= tiny_inBend_next;
    end

    always @(*) begin
        state_next = state;
        part_result0_next  = part_result0;
        part_result1_next  = part_result1;
        part_result2_next  = part_result2;
        part_result3_next  = part_result3;
        part_result4_next  = part_result4;
        part_result5_next  = part_result5;
        part_result6_next  = part_result6;
        part_result7_next  = part_result7;
        part_result8_next  = part_result8;
        part_result9_next  = part_result9;
        part_result10_next = part_result10;
        part_result11_next = part_result11;
        part_result12_next = part_result12;
        part_result13_next = part_result13;
        part_result14_next = part_result14;
        part_result15_next = part_result15;
        part_resultBend_next = part_resultBend;
        inA_next = inA;
        inB_next = inB;
        result_next = result;
        tiny_inB_next = tiny_inB;
        tiny_inC_next = tiny_inC;
        tiny_inD_next = tiny_inD;
        tiny_inE_next = tiny_inE;
        tiny_inBend_next = tiny_inBend;
        ivalid_next = 0;
        result_next = result;
        case (state) 
            PREPARE0: begin
                (*parallel_case*)
                case (1'b1) 
                    Signed: begin
                        inA_next = {A[31], A};   inB_next = {B[31], B};
                    end
                    Unsigned: begin  
                        inA_next = {1'b0, A};
                        inB_next = {1'b0, B};
                    end
                    SU: begin
                        inA_next = {A[31], A};
                        inB_next = {1'b0, B};
                    end
                endcase
                if (invalid) begin
                    state_next = PREPARE1;                
                    result_next = 0;
                end
            end
            PREPARE1: begin
                tiny_inB_next = {B[1:0], 1'b0};
                tiny_inC_next = B[3:1];
                tiny_inD_next = B[5:3];
                tiny_inE_next = B[7:5];

                if (invalid) begin
                    state_next = PREPARE2;                
                    result_next = 0;
                end
            end
            PREPARE2: begin
                tiny_inB_next = B[ 9:7 ];
                tiny_inC_next = B[11:9 ];
                tiny_inD_next = B[13:11];
                tiny_inE_next = B[15:13];
                state_next = MUL_ONE;
            end
            MUL_ONE: begin
                part_result0_next = tiny_reson;
                part_result1_next = tiny_restw;
                part_result2_next = tiny_resth;
                part_result3_next = tiny_resfo;
                tiny_inB_next = B[17:15];
                tiny_inC_next = B[19:17];
                tiny_inD_next = B[21:19];
                tiny_inE_next = B[23:21];
                tiny_inBend_next = inB[32:31];
                state_next = MUL_TWO;
            end
            MUL_TWO: begin
                part_result4_next = tiny_reson;
                part_result5_next = tiny_restw;
                part_result6_next = tiny_resth;
                part_result7_next = tiny_resfo;
                tiny_inB_next = B[25:23];
                tiny_inC_next = B[27:25];
                tiny_inD_next = B[29:27];
                tiny_inE_next = B[31:29];
                state_next = MUL_THR;
            end
            MUL_THR: begin
                part_result8_next  = tiny_reson;
                part_result9_next  = tiny_restw;
                part_result10_next = tiny_resth;
                part_result11_next = tiny_resfo;
                part_resultBend_next = tiny_resbend;
                state_next = MUL_FOU;
            end
            MUL_FOU: begin
                part_result12_next = tiny_reson;
                part_result13_next = tiny_restw;
                part_result14_next = tiny_resth;
                part_result15_next = tiny_resfo;
                result_next = result  + (part_resultBend<<32);
                state_next = SUM_ONE;
            end
            SUM_ONE: begin
                result_next = result + (part_result15<<30) + (part_result0);
                state_next = SUM_TWO;
            end
            SUM_TWO: begin
                result_next = result + (part_result13<<26) + (part_result2<<4);
                state_next = SUM_THR;
            end
            SUM_THR: begin
                result_next = result + (part_result11<<22) + (part_result4<<8);
                state_next = SUM_FOU;
            end
            SUM_FOU: begin
                result_next = result + (part_result9 <<18) + (part_result6<<12);
                state_next = SUM_FIV;
            end
            SUM_FIV: begin
                result_next = result + (part_result14<<28) + (part_result1<<2);
                state_next = SUM_SIX;
            end
            SUM_SIX: begin
                result_next = result + (part_result12<<24) + (part_result3<<6);
                state_next = SUM_SEV;
            end
            SUM_SEV: begin
                result_next = result + (part_result10<<20) + (part_result5<<10);
                state_next = SUM_EIG;
            end
            SUM_EIG: begin
                result_next = result + (part_result8 <<16) + (part_result7<<14);
                ivalid_next = 1;
                state_next = PREPARE1;
            end
            default:;
        endcase
    end
    
`endif

`ifdef MUL_USE_DSP

    localparam PREPARE= 0;
    localparam WAIT1 = 1;
    localparam WAIT2 = 2;
    localparam WAIT3 = 3;
    localparam WAIT4 = 4;
    localparam WAIT5 = 5;
    localparam ISIP   = 6;

    reg     [ 3:0 ] state = 0;
    reg     [ 3:0 ] state_next = 0;
    reg     [63:0 ] result = 0;
    reg  signed    [63:0 ] result_next = 0;
    reg             ivalid, ivalid_next;
    reg  signed    [32:0 ] inA, inA_next;
    reg  signed    [32:0 ] inB, inB_next;
    reg             CE = 0;
    reg             CE_next = 0;

    wire    [65:0 ] result_ip;
    MUL_IP mulip(
        .clk(clk),
        .inA(inA),
        .inB(inB),
        .P(result_ip),
        .CE(CE)
    );

    assign valid = ivalid;
    assign P = result;

    always @(posedge clk) begin
        state <= state_next;
        result <= result_next;
        ivalid <= ivalid_next;
        inB <= inB_next;
        inA <= inA_next;
        CE <= CE_next;
    end

    always @(*) begin
        state_next = state;
        inA_next = inA;
        inB_next = inB;
        result_next = result;
        ivalid_next = 0;
        result_next = result;
        CE_next = CE;
        case (state) 
            PREPARE: begin
                CE_next = 0;
                (*parallel_case*)
                case (1'b1)
                    Signed: begin
                        inA_next = {A[31], A};   inB_next = {B[31], B};
                    end
                    Unsigned: begin  
                        inA_next = {1'b0, A};
                        inB_next = {1'b0, B};
                    end
                    SU: begin
                        inA_next = {A[31], A};
                        inB_next = {1'b0, B};
                    end
                endcase
                if (invalid) begin
                    state_next = WAIT1;                
                    result_next = 0;
                    CE_next = 1;
                end
            end
            WAIT1: begin
                state_next = WAIT2;
            end
            WAIT2: begin
                state_next = WAIT3;
            end
            WAIT3: begin
                state_next = WAIT4;
            end
            WAIT4: begin
                state_next = WAIT5;
            end
            WAIT5: begin
                state_next = ISIP;
            end
            ISIP: begin
                ivalid_next = 1;
                result_next = result_ip;
                state_next = PREPARE;
            end
            default:;
        endcase
    end

    
`endif

endmodule

`ifdef RADIX_4_9CYC
module MUL_Radix4(
    input                   clk,
    input signed    [32:0]  A,
    input           [ 2:0]  B,
    input           [ 2:0]  C,
    input           [ 2:0]  D,
    input           [ 2:0]  E,

    input           [ 2:0]  F,
    input           [ 2:0]  G,
    input           [ 2:0]  H,
    input           [ 2:0]  I,

    input           [ 1:0]  Bend,
    output wire signed  [33:0] res_bend,


    output wire signed  [33:0] res_on,
    output wire signed  [33:0] res_tw,
    output wire signed  [33:0] res_th,
    output wire signed  [33:0] res_fo,
    output wire signed  [33:0] res_fi,
    output wire signed  [33:0] res_si,
    output wire signed  [33:0] res_se,
    output wire signed  [33:0] res_ei
);
    reg signed  [33:0 ] r_res_on = 0;
    reg signed  [33:0 ] r_res_tw = 0;
    reg signed  [33:0 ] r_res_th = 0;
    reg signed  [33:0 ] r_res_fo = 0;
    reg signed  [33:0 ] r_res_fi = 0;
    reg signed  [33:0 ] r_res_si = 0;
    reg signed  [33:0 ] r_res_se = 0;
    reg signed  [33:0 ] r_res_ei = 0;
    reg signed  [33:0 ] r_res_bend = 0;

    function signed [33:0] booth_encode;
        input [2:0] bits;
        input signed [32:0] A;
        case(bits)
            3'b000, 3'b111: booth_encode = 0;
            3'b001, 3'b010: booth_encode =  A;
            3'b011:         booth_encode = A<<1;
            3'b100:         booth_encode = -(A<<1);
            3'b101, 3'b110: booth_encode = -A;
            default:        booth_encode = 0;
        endcase
    endfunction
    function signed [33:0] booth_Bend;
        input [1:0] bits;
        input signed [32:0] A;
        case(bits)
            2'b00, 2'b11:   booth_Bend = 0;
            2'b01:          booth_Bend = A;
            2'b10:          booth_Bend = -A;
            default:        booth_Bend = 0;
        endcase
    endfunction

    assign res_on = r_res_on;
    assign res_tw = r_res_tw;
    assign res_th = r_res_th;
    assign res_fo = r_res_fo;
    assign res_fi = r_res_fi;
    assign res_si = r_res_si;
    assign res_se = r_res_se;
    assign res_ei = r_res_ei;
    assign res_bend = r_res_bend;
    always @(posedge clk) begin
        r_res_on <= booth_encode(B, A);
        r_res_tw <= booth_encode(C, A);
        r_res_th <= booth_encode(D, A);
        r_res_fo <= booth_encode(E, A);
        r_res_fi <= booth_encode(F, A);
        r_res_si <= booth_encode(G, A);
        r_res_se <= booth_encode(H, A);
        r_res_ei <= booth_encode(I, A);
        r_res_bend <= booth_Bend(Bend, A);
    end
endmodule
`endif

`ifdef RADIX_4_15CYC
module MUL_Radix4(
    input          clk,
    input  signed [32:0] A,
    input   [ 2:0] B,
    input   [ 2:0] C,
    input   [ 2:0] D,
    input   [ 2:0] E,

    input   [ 1:0] Bend,
    output wire signed  [33:0] res_bend,


    output wire signed  [33:0] res_on,
    output wire signed  [33:0] res_tw,
    output wire signed  [33:0] res_th,
    output wire signed  [33:0] res_fo
);
    reg [33:0 ] r_res_on;
    reg [33:0 ] r_res_tw;
    reg [33:0 ] r_res_th;
    reg [33:0 ] r_res_fo;
    reg [33:0 ] r_res_bend;

    function signed [33:0] booth_encode;
        input [2:0] bits;
        input signed [32:0] A;
        case(bits)
            3'b000, 3'b111: booth_encode = 0;
            3'b001, 3'b010: booth_encode =  A;
            3'b011:         booth_encode = A*2;
            3'b100:         booth_encode = -A*2;
            3'b101, 3'b110: booth_encode = -A;
            default:        booth_encode = 0;
        endcase
    endfunction
    function signed [33:0] booth_Bend;
        input [1:0] bits;
        input signed [32:0] A;
        case(bits)
            2'b00, 2'b11:   booth_Bend = 0;
            2'b01:          booth_Bend = A;
            2'b10:          booth_Bend = -A;
            default:        booth_Bend = 0;
        endcase
    endfunction

    assign res_on = r_res_on;
    assign res_tw = r_res_tw;
    assign res_th = r_res_th;
    assign res_fo = r_res_fo;
    assign res_bend = r_res_bend;
    always @(posedge clk) begin
        r_res_on <= booth_encode(B, A);
        r_res_tw <= booth_encode(C, A);
        r_res_th <= booth_encode(D, A);
        r_res_fo <= booth_encode(E, A);
        r_res_bend <= booth_Bend(Bend, A);
    end
endmodule
`endif



`ifdef MUL_USE_DSP
`endif
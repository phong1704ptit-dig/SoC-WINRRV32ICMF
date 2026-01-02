
`include "Define.vh"
module ALU_unit(
    input           clk,
    input           isALUimm,
    input           isALUreg,
    input           isBranch,//chú ý
    input           isSYS,
    input           isMEXT,
    input   [ 7:0 ] funct3oh,
    input   [ 2:0 ] funct3,
    input   [ 6:0 ] funct7,
    input   [31:0 ] rs1,
    input   [31:0 ] rs2,            //Imm 
    input   [31:0 ] csr_rdata,
    input           DecodeNotValid,
    
    output          result_ready,
    output  [31:0]  result,
    
    output          correct
);

//ALU 
wire    isALU   =   isALUimm|   isALUreg;

wire    SUB     =   isALUreg&   funct3oh[0] &   funct7[5];  //SUB
wire    ADD     =   isALU   &   funct3oh[0] &   !SUB;       //ADDI or ADD
wire    AND     =   isALU   &   funct3oh[7];                //ANDI or AND
wire    OR      =   isALU   &   funct3oh[6];                //ORI or OR
wire    XOR     =   isALU   &   funct3oh[4];                //XORI or XOR
wire    SLL     =   isALU   &   funct3oh[1];                //SLLI or SLL
wire    SRL     =   isALU   &   funct3oh[5] &   !funct7[5]; //SRLI or SRL
wire    SRA     =   isALU   &   funct3oh[5] &   funct7[5];  //SRAI or SRA
wire    SLT     =   isALU   &   funct3oh[2];                //SLTI or SLT
wire    SLTIU   =   isALU   &   funct3oh[3];                //SLTIU or SLTU

//CSR
wire    CSRRW   =   isSYS   &  !funct3[1]   &   funct3[0];  //CSRRW or CSRRWI
wire    CSRRS   =   isSYS   &   funct3[1]   &  !funct3[0];  //CSRRS or CSRRSI
wire    CSRRC   =   isSYS   &   funct3[1]   &   funct3[0];  //CSRRC or CSRRCI

//M extension
wire    MUL     =   isMEXT  &   funct3oh[0];
wire    MULH    =   isMEXT  &   funct3oh[1];
wire    MULHU   =   isMEXT  &   funct3oh[3];
wire    MULHSU  =   isMEXT  &   funct3oh[2];
wire    DIV     =   isMEXT  &   funct3oh[4];
wire    DIVU    =   isMEXT  &   funct3oh[5];
wire    REM     =   isMEXT  &   funct3oh[6];
wire    REMU    =   isMEXT  &   funct3oh[7];

wire [63:0 ] mul_res;
wire [31:0 ] resdiv_quo;
wire [31:0 ] resdiv_rem;

//Sign for compare
wire   isUnSigned    =   (funct3oh[7] | funct3oh[6]);

//Compare
wire    CP  =  ($unsigned({1'b0, rs1}) < $unsigned({1'b0, rs2}));//Compare unsigned
wire    CS  =  (rs1[31] ^ rs2[31])?rs1[31]:CP;  //Compare signed; 1 = LT;
wire    EQ  =   rs1[31:0] == rs2[31:0];                     //Equal
wire    LT  =   isUnSigned?CP:CS;                 //Less than
wire    GE  =   !LT;                            //Greater than

//correct branch
assign  correct =     
            funct3oh[0]             &   EQ  |   //is BEQ
            funct3oh[1]             &  !EQ  |   //is BNE
           (funct3oh[4]|funct3oh[6])&   LT  |   //is BLT or BLTU
           (funct3oh[5]|funct3oh[7])&   GE;     //is BGE or BGEU

//result of ALU
assign  result  =   ADD     ?   rs1 +   rs2     :
                    SUB     ?   rs1 -   rs2     :
                    AND     ?   rs1 &   rs2     :
                    OR      ?   rs1 |   rs2     :
                    XOR     ?   rs1 ^   rs2     :
                    SLL     ?   rs1 <<  rs2[4:0]:        //note shami (SLLI)
                    SRL     ?   rs1 >>  rs2[4:0]:        //note shami (SRLI)
                    SRA     ?  (rs1 >> rs2[4:0])|((~(32'hffffffff>>rs2[4:0]))&{32{rs1[31]}}):
                    SLT     ?  (CS?32'd1:32'd0) :
                    SLTIU   ?  (CP?32'd1:32'd0) :
                    CSRRW   ?   rs1             :
                    CSRRS   ?   rs1 | csr_rdata :
                    CSRRC   ?  ~rs1 & csr_rdata :
                    
`ifdef MULTIPLY_DIVIDE_EXTENSIONS
                    MUL     ?   mul_res[31:0 ]  :
                    MULH    ?   mul_res[63:32]  :
                    MULHU   ?   mul_res[63:32]  :
                    MULHSU  ?   mul_res[63:32]  :
                    DIV     ?   resdiv_quo      :
                    DIVU    ?   resdiv_quo      :
                    REM     ?   resdiv_rem      :
                    REMU    ?   resdiv_rem      :
`endif
                    32'd0;

`ifdef MULTIPLY_DIVIDE_EXTENSIONS
/////////////////////////////////MUL//////////////////////////////////
wire mul_valid;
reg  en_mul;
reg  [31:0 ] inA_mul, inB_mul;
reg           Signed_mul, Unsigned_mul, SU_mul;
ALU_mul ALUmul(
    .clk            (clk),
    .A              (inA_mul),
    .B              (inB_mul),
    .invalid        (en_mul),
    .Signed         (Signed_mul),
    .Unsigned       (Unsigned_mul),
    .SU             (SU_mul),

    .P              (mul_res),
    .valid          (mul_valid)
);

reg flag_mul = 1;
always @(posedge clk) begin
    if((MUL|MULH|MULHU|MULHSU) & flag_mul & !DecodeNotValid) begin
        en_mul <= 1'b1;
        flag_mul <= 0;
    end
    if(mul_valid) flag_mul <= 1;
    if(en_mul) en_mul <= 1'b0;

    Signed_mul <= MUL|MULH;
    Unsigned_mul <= MULHU;
    SU_mul <= MULHSU;

    inA_mul <= rs1;
    inB_mul <= rs2;
    
end



////////////////////////////////DIV//////////////////////////////////
wire div_valid;
reg  en_div;
reg  [31:0 ] inA_div, inB_div;
reg          Signed_div;
ALU_div ALUdiv(
    .clk                (clk),
    .dividend           (inA_div),
    .divisor            (inB_div),
    .invalid            (en_div),
    .Signed             (Signed_div),

    .quotient           (resdiv_quo),
    .result_REM         (resdiv_rem),
    .ovalid             (div_valid)
);

reg flag_div = 1;
always @(posedge clk) begin
    if((DIV|DIVU|REM|REMU) & flag_div & !DecodeNotValid) begin
        en_div <= 1'b1;
        flag_div <= 0;
    end
    if(div_valid) flag_div <= 1;
    if(en_div) en_div <= 1'b0;

    Signed_div <= DIV|REM;
    inA_div <= rs1;
    inB_div <= rs2;
end

reg flag_sta = 0;
always @(posedge clk) flag_sta <= 1;

assign result_ready = (isMEXT & flag_sta & !DecodeNotValid)? ((DIV|DIVU|REM|REMU)?div_valid:mul_valid):
                                1'b1;
`endif

`ifndef MULTIPLY_DIVIDE_EXTENSIONS
assign result_ready = 1'b1;
`endif
endmodule
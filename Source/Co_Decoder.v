/*

-----------------------------------------Base Integer Instruction Set----------------------------------------
The RISC-V Instruction Set Manual
Volume I: User-Level ISA
Document Version 2.2


Integer Computational Instructions
    Integer Register-Immediate Instructions:
        ADDI        Add immediate                               (rd = rs1 + sign_extend(imm))
        SLTI        set less than immediate                     (rd = 1 if rs1 < imm, signed)
        SLTIU       set Less Than Immediate (Unsigned)          (rd = 1 if rs1 < imm, unsigned) SLTU = SNEZ(Set if Not Equal to Zero) when rs1 is x0
        ANDI        logical operation - AND                     (rd = rs1 & sign_extend(imm))
        ORI, XORI   //        //          //      
        SLLI        Shift Left Logical Immediate                (rd = rs1 << shamt)
        SRLI        Shift Right Logical Immediate               (rd = rs1 >> shamt)
        SRAI        Shift Right Arithmetic                      (rd = rs1 >>> shamt (arithmetic, signed))
        LUI         Load upper immediate                        (rd = Uimm)
        AUIPC       Add Upper Immediate to PC                   (rd = PC + Uimm)
    Integer Register-Register Operations:
        ADD/SLT/SLTU/AND/OR/XOR/SLL/SRL/SRA
Control Transfer Instructions
    Unconditional Jumps:
        JAL         Jump and link                               (PC = PC + Jimm, rd = PC+4) x1 - return address register, x5 - alternate link register
        JALR        Jump and link register                      (PC = rs1 + Iimm, rd = PC+4) x0 = rd if not required    (J no L) (ret)
    Conditional Branches:
        BEQ         Branch if Equal                             (branch if rs1 == rs2)                               
        BNE         Branch if Not Equal
        BLT/BLTU    //              //
        BGE/BGEU    //              //
Load and Store Instructions
    Load Instructions:
        LW          Load Word                                   (rd = MEM[rs1 + imm])
        LH          Load Halfword                               (rd = sign_extend_32(MEM[rs1 + imm][15:0])
        LHU         Load Halfword Unsigned                      (rd = zero_extend_32(MEM[rs1 + imm][15:0]))
        LB          Load Byte                                   (rd = sign_extend_32(MEM[rs1 + imm][7:0]))
        LBU         Load Byte Unsigned                          (rd = zero_extend_32(MEM[rs1 + imm][7:0]))
    Store Instructions:
        SW          Store Word                                  (MEM[rs1 + imm] = rs2)
        SH          Store Halfword                              (MEM[rs1 + imm] = rs2[15:0])
        SB          Store Byte                                  (MEM[rs1 + imm] = rs2[7:0])
Memory Model
        FENCE
        FENCE.I
Control and Status Register Instructions
    CSR Instructions:
        CSRRW       Atomic Read/Write CSR                       (rd = CSR, CSR = rs1) if rd = xo, not read CSR
        CSRRS       Atomic Read and Set Bits in CSR             (rd = CSR, Setbit CSR, rs1 - bitmask) if rs1 = x0, not write CSR
        CSRRC       Atomic Read and Clear Bits in CSR           (//     // Clearbit  //      //      //  )
        CSRRWI      Atomic Read/Write CSR Immediate             (rd = CSR, CSR = imm(unsigned)) if rd = xo, not read CSR
        CSRRSI      //              //          //                  //          //
        CSRRCI      //              //          //                  //          //
    Timers and Counters: CSRRS - RDCYCLE[H](count of the number of clock cycles executed by the processor core) cycle CSR
                                 RDTIME[H](wall-clock real time that has passed from an arbitrary start time in the past.) time CSR
                                 RDINSTRET[H](instructions retired by this hart from some arbitrary start point in the past) instret CSR
Environment Call and Breakpoints
        ECALL       Environment Call
        EBREAK      Environment Break


----------------------------------------Compressed Instructions(Extension)----------------------------------
The RISC-V Instruction Set Manual
Volume II: Privileged Architecture
Document Version 20211203
Page 159
Cần chú ý trường hợp rs1 = x0 nếu có các lệnh HINT hoặc trùng opcode

Stack-Pointer-Based Loads and Stores: Load - CI format, Store - CSS format
        C.LWSP      Load Word Stack Pointer                     (rd = MEM[rs1 + imm]) với rs1 mặc định là sp(x2), Chú ý imm này phải được nhân 4            
        C.FLWSP     Load Word Stack Pointer(floating-point reg) //         //          //          //          //      //      //      //      
        C.SWSP      Store Word Stack Pointer                    (MEM[rs1 + imm] = rs2) với rs1 mặc định là sp(x2), Chú ý imm này phải được nhân 4
        C.FSWSP     Store Word Stack Pointer(floating-point reg) //         //          //          //          //      //      //      //      
Register-Based Loads and Stores: Load - CL format, Store - CS format
        C.LW        Load Word                                   (rd' = MEM[rs1' + imm]), Chú ý imm này phải được nhân 4         
        C.FLW       Load Word(floating-point reg)               //             //          //                      //
        C.SW        Store Word                                  (MEM[rs1' + imm] = rs2'),   //                      //
        C.FSW       Store Word(floating-point reg)              //              //          //          //          //
Control Transfer Instructions:
        C.J         unconditional Jump(CJ format)               (PC = PC + imm, rd(x0) = PC + 2), Chú ý imm phải được nhân 2
        C.JAL       Jump And Link(CJ format)                    (PC = PC + imm, rd(x1) = PC + 2), Chú ý imm phải được nhân 2
        C.JR        Jump register(CR format)                    (PC = rs1, rd(x0) = PC + 2), Chú ý imm = 0
        C.JALR      Jump And Link Register(CR format)           (PC = rs1, rd(x1) = PC + 2), Chú ý imm = 0, rs1 = x0 opcode bị máp thành C.BREAK                 
        C.BEQZ      Branch if Equal Zero(CB format)             (PC = PC + imm if rs1' = 0), Chú ý imm phải được nhân 2 
        C.BNEZ      Branch if Not Equal Zero(CB format)         (PC = PC + imm if rs1' != 0), Chú ý imm phải được nhân 2
Integer Computational Instructions:
    Integer Constant-Generation Instructions: CI format
        C.LI        Load Immediate                              (rd = imm)
        C.LUI       Load Upper Immediate                        (rd = imm << 12), chú ý rd != x0, x2
    Integer Register-Immediate Operations
        C.ADDI      Add Immediate(CI format)                    (rd = rd + imm)
        C.ADDI16SP  Add Immediate to Stack Pointer(CI format)   (x2 = x2 + imm), chú ý imm phải được nhân 16
        C.ADDI4SPN  Add Imm to Stack Pointer, Non-zero(CIW)     (rd' = x2 + imm), chú ý imm phải được nhân 4
        C.SLLI      Shift Left Logical(CI format)               (rd = rd << shamt), chú ý shamt[5] = 0, shamt = 0 is HINT
        C.SRLI      Shift Right Logical(CB format)              (rd' = rd' >> shamt), chú ý shamt[5] = 0, shamt = 0 is HINT
        C.SRAI      Shift Right Arithmetic(CB format)           (rd' = rd' >>> shamt), chú ý shamt[5] = 0, shamt = 0 is HINT
        C.ANDI      And Immediate(CB format)                    (rd' = rd' && imm)
    Integer Register-Register Operations
        C.MV        Move(CR format)                             (rd = rs2), chú ý rs2 != x0, rs2 = x0 là C.JR, rs2 != x0 và rd = x0 là HINT
        C.ADD       Add(CR format)                              (rd = rd + rs2), chú ý rs2 != x0, rs2 = x0 là C.JALR hoặc C.EBREAK, rs2 != 0 và rd = x0 là HINT
        C.AND, C.OR, C.XOR, C.SUB(CA format)                    (rd' = rd' . rs2')
    NOP Instruction
        NOP         (CI format)
    Breakpoint Instruction
        C.BREAK     (CR format)
        
---------------------------------Integer Multiplication and Division(Extension)-----------------------------
The RISC-V Instruction Set Manual
Volume II: Privileged Architecture
Document Version 20211203


Multiplication Operations
        MUL         rd <- rs1 * rs2 (signed 32-bit × signed 32-bit).        Chỉ lấy 32bit thấp
        MULH        rd <- rs1 * rs2 (signed 32-bit × signed 32-bit).        Chỉ lấy 32bit cao
        MULHU       rd <- rs1 * rs2 (unsigned 32-bit × unsigned 32-bit).    Chỉ lấy 32bit cao
        MULHSU      rd <- rs1 * rs2 (signed 32-bit × unsigned 32-bit).      Chỉ lấy 32bit cao
Division Operations 
        DIV         rd <- rs1 ÷ rs2 (signed 32-bit ÷ signed 32-bit).        Quotient, round toward zero
        DIVU        rd <- rs1 ÷ rs2 (unsigned 32-bit ÷ unsigned 32-bit).    Quotient, round toward zero
        REM         rd <- rs1 % rs2 (signed 32-bit ÷ signed 32-bit).        Kết quả mang cùng dấu với rs1
        REMU        rd <- rs1 % rs2 (unsigned 32-bit ÷ unsigned 32-bit).
        
        *division by zero and division overflow(do số có dấu chỉ biểu diễn từ -2^31 -> 2^31-1)
            Condition           Dividend     Divisor    DIVU[W]     REMU[W]     DIV[W]      REM[W]
      --------------------------------------------------------------------------------------------
         Division by zero          x            0       2^L - 1      x           -1           x
      Overflow (signed only)    -2^(L-1)        -1                             -2^(L-1)       0
                                                    

*/


`include "Define.vh"
module RV32_CoDecoder(

//Instruction
    input   [31:0]  instr_data,
    input           rst,
    
//decode comm
    output  [31:0]  Immediate,
    output          insJAL,insJALR,insBRA,
    output          insFpause,              //Nop nếu lệnh FMVWX, FCVTSW, FCVTSWU và có xuất hiện hazard rs1
    output  [4:0]   regrs1, //Zimm


//Lệnh đặc biệt, sử dụng cho ngắt
    output          insMRET,   

//C extension
    output          insCEXT
);

/*
Rtype - Register:           add, sub, and, or, sll          (rd = rs1 op rs2)
Itype - Immediate:          addi, lw, jalr, ecall, csrrw    (rd = rs1 op imm)
Stype - Store:              sw, sh, sb                      (RAM[rs1 + offset] = rs2)
Btype - Branch:             beq, bne, blt, bge              (condition PC = PC + offset)
Utype - Upper immediate:    lui, auipc                      (rd = imm << 12)
Jtype - Jump:               jal                             (rd = PC+4, PC = PC + offset)
*/

`ifdef COMPRESSED_EXTENTIONS

    reg             r_insJAL    =   0;
    reg             r_insJALR   =   0;
    reg             r_insBRA    =   0;
    reg             r_insFpause =   0;
    reg             r_insFPUsim =   0;

    reg     [31:0 ] Iimm    =   32'h0;
    reg     [31:0 ] Bimm    =   32'h0;
    reg     [31:0 ] Jimm    =   32'h0;

    reg     [ 4:0 ] r_regrs1    =   5'd0; 
    reg             r_insMRET   =   1'b0;
    reg             r_insCEXT   =   1'b0; 


    wire    [3:0] Copcodeoh;
    wire    [7:0] Cfunct3oh_temp;

    reg             CinsJAL         = 1'b0;
    reg             CinsJALR        = 1'b0;
    reg             CinsBRA         = 1'b0;

    reg     [31:0]  CJimm           = 32'd0;
    reg     [31:0]  CBimm           = 32'd0;

    reg C_JAL = 0, C_J = 0;
    reg C_BEQZ = 0, C_BNEZ = 0;
    reg C_JALR = 0, C_JR = 0;
        
//-------------------Types of immediate. Sign extension always uses inst[31]-------------------
    //Immediate of RVI
    always @(*) begin
            Iimm    =   {{21{instr_data[31]}}, instr_data[30:20]};
            Bimm    =   {{20{instr_data[31]}}, instr_data[7], instr_data[30:25], instr_data[11:8], 1'b0};
            Jimm    =   {{12{instr_data[31]}}, instr_data[19:12], instr_data[20], instr_data[30:21], 1'b0};
    end


    //Immediate of RVC
    always @(*) begin
            // C extension immediate decoding (RVC)
            CJimm           = {{20{instr_data[12]}}, instr_data[12], instr_data[8], instr_data[10:9],
                                instr_data[6], instr_data[7], instr_data[2], instr_data[11],
                                instr_data[5:3], 1'b0};
            CBimm           = {{23{instr_data[12]}}, instr_data[12], instr_data[6:5], instr_data[2],
                                instr_data[11:10], instr_data[4:3], 1'b0};
    end

//---------------------Instruction - C extension----------------------
    //C extension decoded control signals
    always @(*) begin
            //-------------------------------
            // Quadrant 0
            //-------------------------------  

            //-------------------------------
            // Quadrant 1
            //-------------------------------
            C_JAL       = (Copcodeoh[1] & Cfunct3oh_temp[1]);
            C_J         = (Copcodeoh[1] & Cfunct3oh_temp[5]);
            C_BEQZ      = (Copcodeoh[1] & Cfunct3oh_temp[6]);
            C_BNEZ      = (Copcodeoh[1] & Cfunct3oh_temp[7]);

            //-------------------------------
            // Quadrant 2
            //-------------------------------
            C_JALR      = (Copcodeoh[2] & Cfunct3oh_temp[4]) &  instr_data[12] & (|instr_data[11:7]) & !(|instr_data[6:2]);
            C_JR        = (Copcodeoh[2] & Cfunct3oh_temp[4]) &(!instr_data[12])& (|instr_data[11:7]) & !(|instr_data[6:2]);
    end


    //final immediate
    wire    [31:0]  Cimm    =
                        (C_JAL | C_J)               ?   CJimm       :
                        (C_BEQZ | C_BNEZ)           ?   CBimm       :
                        (C_JR | C_JALR)             ?   32'd0       :
                        32'd0;

    wire    [31:0]  Imm     =     
                        (r_insJAL)                                              ?   Jimm    :
                        (r_insJALR)                                             ?   Iimm    :
                        (r_insBRA)                                              ?   Bimm    :
                        32'd0;


//----------------------funct3, funct7, rs2, rs1, rd-------------------------

    //funct3, funct7, rs2, rs1, rd in C extension
    assign  Cfunct3oh_temp   =   8'b0000_0001 << instr_data[15:13];
    assign  Copcodeoh   =   4'b0001 << instr_data[ 1:0 ];



    reg     [4:0]   Cregrs1;
    always @(*) begin   //rs1
        Cregrs1 = 5'd0;
        (*parallel_case*)
        case (1'b1) 
            C_JR | C_JALR: Cregrs1 = instr_data[11:7];
            default: Cregrs1 = 5'd0;
        endcase
    end
    always @(*) begin   //opcode
        CinsJAL     = 0;
        CinsJALR    = 0;
        CinsBRA     = 0;

        (*parallel_case*)
        case (1'b1)
            C_J | C_JAL                                 : CinsJAL = 1;  
            C_JR | C_JALR                               : CinsJALR = 1;
            C_BEQZ | C_BNEZ                             : CinsBRA = 1;
        endcase
    end



//---------------------------assign port-----------------------------


    //Instructions - opcode
    assign          insJAL      =   r_insJAL;
    assign          insJALR     =   r_insJALR;
    assign          insBRA      =   r_insBRA;
    assign          insFpause   =   r_insFpause;

    always @(*) begin
            r_insJAL    = (r_insCEXT)   ?   CinsJAL     :   (instr_data[6:2] == 5'b11011);// rd <- PC+4; PC<-PC+Jimm
            r_insJALR   = (r_insCEXT)   ?   CinsJALR    :   (instr_data[6:2] == 5'b11001);// rd <- PC+4; PC<-rs1+Iimm
            r_insBRA    = (r_insCEXT)   ?   CinsBRA     :   (instr_data[6:2] == 5'b11000);// if(rs1 OP rs2) PC<-PC+Bimm
            r_insFPUsim = (instr_data[6:2] == 5'b10100) && (!r_insCEXT);
            r_insFpause = (r_insFPUsim) && instr_data[31] && instr_data[30] && instr_data[28];
    end

    //MRET, MEXT, CEXT, enreg, funct, ...
    assign          regrs1      =   r_regrs1;
    assign          insMRET     =   r_insMRET;
    assign          insCEXT     =   r_insCEXT;
    

    always @(*) begin
            r_insCEXT   =   (!Copcodeoh[3]);    //C EXTENSION
            r_regrs1    =   (r_insCEXT)   ?   Cregrs1     :   instr_data[19:15];
            r_insMRET   =   (instr_data == 32'h30200073); //MRET: sử dụng cho ngắt. Muốn quay về PC sau khi đã ngắt xong
    end

    //Immediate
    assign Immediate    =   (r_insCEXT)?Cimm:Imm;

`endif

`ifndef COMPRESSED_EXTENTIONS
    reg             r_insJAL    =   0;
    reg             r_insJALR   =   0;
    reg             r_insBRA    =   0;

    reg     [31:0 ] Iimm    =   32'h0;
    reg     [31:0 ] Bimm    =   32'h0;
    reg     [31:0 ] Jimm    =   32'h0;
       
    reg     [ 4:0 ] r_regrs1    =   5'd0; 
    reg             r_insMRET   =   1'b0;
    reg             r_insCEXT   =   1'b0; 

    
//--------------Types of immediate. Sign extension always uses inst[31]-------------
    always @(*) begin
        if(!rst) begin
            Iimm = 0; Bimm = 0; Jimm = 0;
        end
        else begin
            Iimm    =   {{21{instr_data[31]}}, instr_data[30:20]};
            Bimm    =   {{20{instr_data[31]}}, instr_data[7], instr_data[30:25], instr_data[11:8], 1'b0};
            Jimm    =   {{12{instr_data[31]}}, instr_data[19:12], instr_data[20], instr_data[30:21], 1'b0};
        end
    end

    wire    [31:0]  Imm     =    
                        (r_insJAL)                                              ?   Jimm    :
                        (r_insJALR)                                             ?   Iimm    :
                        (r_insBRA)                                              ?   Bimm    :
                        32'd0;
    assign Immediate = Imm;



//---------------------------------Instructions - opcode--------------------------------
    assign          insJAL      =   r_insJAL;
    assign          insJALR     =   r_insJALR;
    assign          insBRA      =   r_insBRA;

    always @(*) begin
        if(!rst) begin
            r_insJAL    = 0;
            r_insJALR   = 0;
            r_insBRA    = 0;
        end
        else begin
            r_insJAL    = (instr_data[6:2] == 5'b11011);// rd <- PC+4; PC<-PC+Jimm
            r_insJALR   = (instr_data[6:2] == 5'b11001);// rd <- PC+4; PC<-rs1+Iimm
            r_insBRA    = (instr_data[6:2] == 5'b11000);// if(rs1 OP rs2) PC<-PC+Bimm
        end
    end
   


//-------------------funct3, funct7, rs2, rs1, rd, csr, shamt----------------------
    assign          regrs1      =   r_regrs1;
    assign          insMRET     =   r_insMRET;
    assign          insCEXT     =   r_insCEXT;
    

    always @(*) begin
        if(!rst) begin
            r_regrs1    =   5'd0;
            r_insMRET   =   1'b0;
            r_insCEXT   =   1'b0;
        end
        else begin
            r_regrs1    =   instr_data[19:15];
            r_insMRET   =   instr_data == 32'h30200073;//MRET: sử dụng cho ngắt. Muốn quay về PC sau khi đã ngắt xong 
            r_insCEXT   =   1'b0;
        end
    end

`endif

endmodule

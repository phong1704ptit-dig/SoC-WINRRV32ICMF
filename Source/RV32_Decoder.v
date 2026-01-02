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
Environment Call and Breakpoints
        ECALL       Environment Call
        EBREAK      Environment Break

-------------------------------------------------Zifence(Extension)----------------------------------------
Memory Model
        FENCE
        FENCE.I

--------------------------------------------------Zicsr(Extension)-----------------------------------------
Control and Status Register Instructions
    CSR Instructions:
        CSRRW       Atomic Read/Write CSR                       (rd = CSR, CSR = rs1) if rd = xo, not read CSR
        CSRRS       Atomic Read and Set Bits in CSR             (rd = CSR, Setbit CSR, rs1 - bitmask) if rs1 = x0, not write CSR
        CSRRC       Atomic Read and Clear Bits in CSR           (//     // Clearbit  //      //      //  )
        CSRRWI      Atomic Read/Write CSR Immediate             (rd = CSR, CSR = imm(unsigned)) if rd = xo, not read CSR
        CSRRSI      //              //          //                  //          //
        CSRRCI      //              //          //                  //          //

--------------------------------------------------Zicnt(Extension)-----------------------------------------
    Timers and Counters: CSRRS - RDCYCLE[H](count of the number of clock cycles executed by the processor core) cycle CSR
                                 RDTIME[H](wall-clock real time that has passed from an arbitrary start time in the past.) time CSR
                                 RDINSTRET[H](instructions retired by this hart from some arbitrary start point in the past) instret CSR



----------------------------------------Compressed Instructions(Extension)----------------------------------
The RISC-V Instruction Set
Manual Volume I
Unprivileged Architecture
Version 20240411

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
        C.JR        Jump register(CR format)                    (PC = rs1, rd(x0) = PC + 2), Chú ý imm = 0  Trường rs2 luôn = 0
        C.JALR      Jump And Link Register(CR format)           (PC = rs1, rd(x1) = PC + 2), Chú ý imm = 0, rs1 = x0 opcode bị máp thành C.BREAK, trường rs2 luôn = 0              
        C.BEQZ      Branch if Equal Zero(CB format)             (PC = PC + imm if rs1' = 0), Chú ý imm phải được nhân 2 
        C.BNEZ      Branch if Not Equal Zero(CB format)         (PC = PC + imm if rs1' != 0), Chú ý imm phải được nhân 2
Integer Computational Instructions:
    Integer Constant-Generation Instructions: CI format
        C.LI        Load Immediate                              (rd = imm), rd != 0
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
The RISC-V Instruction Set
Manual Volume I
Unprivileged Architecture
Version 20240411


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
                                                    

---------------------------------Single-Precision Floating-Point(Extension)---------------------------------
The RISC-V Instruction Set
Manual Volume I
Unprivileged Architecture
Version 20240411
20.

Single-precision floating-point computational instructions compliant with the IEEE 754-2008 arithmetic standard
The F extension adds 32 floating-point registers, f0-f31, each 32 bits wide, and a floating-point
control and status register fcsr.

Floating-Point Control and Status Register (fcsr): 
    It is a 32-bit read/write register that selects the dynamic rounding mode for floating-point arithmetic
    operations and holds the accrued exception flags.
    fscr[0]     - NX            : Inexact - kết quả làm tròn không chính xác tuyệt đối      Trị làm tròn
    fcsr[1]     - UF            : Underflow - kết quả quá nhỏ để biểu diễn                  0.0
    fcsr[2]     - OF            : Overflow - kết quả quá lớn để biểu diễn                   +-vc sau làm tròn
    fcsr[3]     - DZ            : Divide by zero - chia cho 0                               +-vc
    fcsr[4]     - NV            : Invalid Operation - phép toán không hợp lệ                NaN
    fcsr[7:5]   - Rounding Mode : 
        000 : RNE - Round to Nearest, ties to Even (Làm tròn đến giá trị gần nhất, nếu nằm giữa chọn số có bít cuối là chẵn)
        001 : RTZ - Round towards Zero (Cắt bỏ phần thập phân)
        010 : RDN - Round Down (towards -vc) (Làm tròn xuống)
        011 : RUP - Round Up (towards +vc) (Làm tròn lên)
        100 : RMM - Round to Nearest, ties to Max Magnitude (Làm tròn đến giá trị gần nhất, nếu giữa 2 số chọn số có trị tuyệt đối lớn nhất)
        111 : DYN - In instruction’s rm field, selects dynamic rounding mode; In Rounding Mode register, reserved. 
            (Chỉ có hiệu quả trong trường rm. Nếu rm = 111 - Dynamic rounding mode thì sẽ sử dụng rounding mode trong fcsr-frm)

NaN Generation and Propagation:
    NaN: Not a Number. Kết quả không hợp lệ hoặc các trường hợp ngoại lệ đều được trả về giá trị NaN - 0x7fc00000.
    Không mang theo payload để giảm chi phí phần cứng

Subnormal Arithmetic:
    Subnormal: E = 0 || Normal: E != 0, E != 255
    Tininess detected after rounding. on UF flag

Single-Precision Load and Store Instructions:
    FLW         Float load word                     Same LW     (frd = MEM[rs1 + imm])
    FSW         Float store word                    Same SW     (MEM[rs1 + imm] = frs2)

Single-Precision Floating-Point Computational Instructions:
    FADD.S      Float add single                    Same ADD    (frd = frs1 + frs2)                 fmt = 00 - 32-bit single-precision
    FSUB.S      Float sub single                    Same SUB    (frd = frs1 - frs2)                 //
    FMUL.S      Float mul single                    Same MUL    (frd = frs1 * frs2)
    FDIV.S      Float div single                    Same DIV    (frd = frs1 / frs2)
    FSQRT.S     Float square root                               (frd = sqrt(frs1))
    FMIN.S      Float min single                                (frd = min(frs1, frs2))
    FMAX.S      Float max single                                (frd = max(frs1, frs2))
        Với FMIN.S và FMAX.S nếu 1 toán hạng là NaN thì kết quả là toán hạng không phải
                             nếu cả 2 là NaN kết quả là canonical NaN
                             nếu 1 trong 2 là signaling NaN thì cờ NV sẽ được bật kết quả ghi ra như 2 cái trên
        +0.0 được coi là lớn hơn -0.0

    FMADD.S     Fused Multiply-Add (single)                     (frd = (frs1 * frs2) + frs3)
    FNMADD.S    Negated Fused Multiply-Add (single)             (frd = -((frs1 * frs2) + frs3))
    FMSUB.S     Fused Multiply-Sub (single)                     (frd = (frs1 * frs2) - frs3)
    FNMSUB.S    Negated Fused Multiply-Sub (single)             (frd = -((frs1 * frs2) - frs3))
        vc*0 + normal -> set NV, cNaN
        vc*0 + qNaN   -> set NV, cNaN
        normal*normal + qNaN -> qNaN

Single-Precision Floating-Point Conversion and Move Instructions:
    FCVT.int.fmt, FCVT.fmt.int
        FCVT.W.S    Convert Float Single → Word (signed int)    x[rd] = int32(frs1)
        FCVT.WU.S   Convert Float Single → Word Unsigned        x[rd] = uint32(frs1)
        FCVT.S.W    Convert Signed Word → Single Float          frd = float32(Signed x[rs1])
        FCVT.S.WU   Convert UnSigned Word → Single Float        frd = float32(Unsigned x[rs1])
                                                    FCVT.W.S    FCVT.WU.S       NV
            Minimum valid input (after rounding)      -2^31         0
            Maximum valid input (after rounding)      2^31-1      2^32-1
            Output for out-of-range negative input    -2^31         0           1
            Output for -vc                            -2^31         0           1
            Output for out-of-range positive input    2^31-1      2^31-1        1
            Output for +vc or NaN                     2^31-1      2^32-1        1
        Tất cả chuyển đổi float ->int nếu gtri đầu ra khác giá trị thực sự của float thì cờ NX được bật.
        Nhưng chỉ khi không có lỗi (NV = 0).
    FSGNJ
        FSGNJ.S     Floating Sign Join                          (frd = frs1 with sign of frs2)    
        FSGNJN.S    Floating Sign Join Negate                   (frd = frs1 with sign of ~frs2)
        FSGNJX.S    Floating Sign Join XOR                      (frd = frs1 with sign of frs2^frs1)
        Không set bất cứ ngoại lệ nào, không quan tâm NaN
    FMV.X.W         Floating MoVe to integer (X) from Word (W)  (rd = frs1)
    FMV.W.X         Floating MoVe Word (W) from integer (X)     (frd = rs1)
        Không set bất cứ ngoại lệ nào, không quan tâm NaN
Single-Precision Floating-Point Compare Instructions:
    FCMP
        FEQ.S       Floating Equal (quiet)                      (rd = 1 if frs1 == frs2)  if NaN -> rd = 0, set NV if sNaN
        FLT.S       Floating Less Than (signaling)              (rd = 1 if frs1 <  frs2)  if NaN -> rd = 0, set NV
        FLE.S       Floating Less or Equal (signaling)          (rd = 1 if frs1 <= frs2)  if NaN -> rd = 0, set NV
            -0 được coi là bằng +0
Single-Precision Floating-Point Classify Instruction:
    FCLASS          Floating-point CLASSify                     (rd = x[bit] if frs1)         Không thiết lập các cờ ngoại lệ
       bit          meaning
        0           frs1 is -vc
        1           frs1 is a negative normal number
        2           frs1 is a negative subnormal number
        3           frs1 is -0
        4           frs1 is +0
        5           frs1 is a positive subnormal number
        6           frs1 is a positive normal number
        7           frs1 is +vc
        8           frs1 is a signaling NaN
        9           frs1 is a quiet NaN
*/


`include "Define.vh"
module RV32_Decoder(

//Instruction
    input   [31:0]  instr_data,
    input           rst,
    
//decode comm
    output  [31:0]  Immediate,
    output          insALUImm,insALUReg,insLUI,insAUIPC,insJAL,insJALR,insBRA,insLOAD,insSTORE,insSYS,insFENCE,
    output          insFLOAD,insFSTORE,insFMADD,insFMSUB,insFNMSUB,insFNMADD,

    output          insFADD,
    output          insFSUB,
    output          insFMUL,
    output          insFDIV,
    output          insFSQRT,
    output          insFSGNJ,
    output          insFSGNJN,
    output          insFSGNJX,
    output          insFMIN,
    output          insFMAX,
    output          insFCVTWS,
    output          insFCVTWUS,
    output          insFMVXW,
    output          insFEQ,
    output          insFLT,
    output          insFLE,
    output          insFCLASS,
    output          insFCVTSW,
    output          insFCVTSWU,
    output          insFMVWX,

    output  [2:0]   funct3,
    output  [7:0]   funct3oh,
    output  [6:0]   funct7,
    output  [4:0]   regrs3,
    output  [4:0]   regrs2, //Shamt
    output  [4:0]   regrs1, //Zimm
    output  [4:0]   regrd,

    output          en_rs1,
    output          en_rs2,
    output          en_rd,

    output          en_frs1,
    output          en_frs2,
    output          en_frs3,
    output          en_frd,

//decode CSR
    output  [11:0]  csr_addr,

//Lệnh đặc biệt, sử dụng cho ngắt
    output          insMRET,   

//M extension
    output          insMEXT,
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
wire    insFPUsim;

`ifdef COMPRESSED_EXTENTIONS
    reg             r_insFLOAD  =   0;
    reg             r_insFSTORE =   0;
    reg             r_insFPUsim =   0;
    reg             r_insFMADD  =   0;
    reg             r_insFMSUB  =   0;
    reg             r_insFNMSUB =   0;
    reg             r_insFNMADD =   0; 

    reg             r_insFADD   =   0;
    reg             r_insFSUB   =   0;
    reg             r_insFMUL   =   0;
    reg             r_insFDIV   =   0;
    reg             r_insFSQRT  =   0;
    reg             r_insFSGNJ  =   0;
    reg             r_insFSGNJN =   0;
    reg             r_insFSGNJX =   0;
    reg             r_insFMIN   =   0;
    reg             r_insFMAX   =   0;
    reg             r_insFCVTWS =   0;
    reg             r_insFCVTWUS=   0;
    reg             r_insFMVXW  =   0;
    reg             r_insFEQ    =   0;
    reg             r_insFLT    =   0;
    reg             r_insFLE    =   0;
    reg             r_insFCLASS =   0;
    reg             r_insFCVTSW =   0;
    reg             r_insFCVTSWU=   0;
    reg             r_insFMVWX  =   0;

    reg             r_insALUImm =   0;
    reg             r_insALUReg =   0;
    reg             r_insLUI    =   0;
    reg             r_insAUIPC  =   0;
    reg             r_insJAL    =   0;
    reg             r_insJALR   =   0;
    reg             r_insBRA    =   0;
    reg             r_insLOAD   =   0;
    reg             r_insSTORE  =   0;
    reg             r_insSYS    =   0;
    reg             r_insFENCE  =   0;

    reg     [31:0 ] Iimm    =   32'h0;
    reg     [31:0 ] Simm    =   32'h0;
    reg     [31:0 ] Bimm    =   32'h0;
    reg     [31:0 ] Uimm    =   32'h0;
    reg     [31:0 ] Jimm    =   32'h0;

    reg     [ 7:0 ] r_funct3oh  =   8'd0;        
    reg     [ 2:0 ] r_funct3    =   3'd0; 
    reg     [ 6:0 ] r_funct7    =   7'd0; 
    reg     [ 4:0 ] r_regrs1    =   5'd0; 
    reg     [ 4:0 ] r_regrs2    =   5'd0; 
    reg     [ 4:0 ] r_regrs3    =   5'd0; 
    reg     [ 4:0 ] r_regrd     =   5'd0; 
    reg     [11:0 ] r_csr_addr  =   12'd0; 
    reg             r_en_rs1    =   1'b0;
    reg             r_en_rs2    =   1'b0;
    reg             r_en_rd     =   1'b0; 
    reg             r_en_frs1   =   1'b0;
    reg             r_en_frs2   =   1'b0;
    reg             r_en_frs3   =   1'b0;
    reg             r_en_frd    =   1'b0;
    reg             r_insMRET   =   1'b0;
    reg             r_insMEXT   =   1'b0;
    reg             r_insCEXT   =   1'b0; 


    wire    [3:0] Copcodeoh;
    wire    [7:0] Cfunct3oh_temp;
    wire    [3:0] Cfunct21oh;
    wire    [3:0] Cfunct22oh;

    reg     [2:0]   Cfunct3         = 3'd0;
    reg     [6:0]   Cfunct7         = 7'd0;
    reg             CinsALUImm      = 1'b0;
    reg             CinsALUReg      = 1'b0;
    reg             CinsLUI         = 1'b0;
    reg             CinsJAL         = 1'b0;
    reg             CinsJALR        = 1'b0;
    reg             CinsBRA         = 1'b0;
    reg             CinsLOAD        = 1'b0;
    reg             CinsFLOAD       = 1'b0;
    reg             CinsSTORE       = 1'b0;
    reg             CinsFSTORE      = 1'b0;
    reg             CinsBREAK       = 1'b0;

    reg     [31:0]  CLoadSPimm      = 32'd0;
    reg     [31:0]  CStoreSPimm     = 32'd0; 
    reg     [31:0]  CLoadimm        = 32'd0;
    reg     [31:0]  CStortimm       = 32'd0;
    reg     [31:0]  CJimm           = 32'd0;
    reg     [31:0]  CBimm           = 32'd0;
    reg     [31:0]  CLIimm          = 32'd0; 
    reg     [31:0]  CLUIimm         = 32'd0;
    reg     [31:0]  CADDIimm        = 32'd0; 
    reg     [31:0]  CADDI16SPimm    = 32'd0;
    reg     [31:0]  CADDI4SPNimm    = 32'd0;
    reg     [31:0]  CANDIimm        = 32'd0; 
    reg     [31:0]  CSimm           = 32'd0;

    reg C_ADDI4SPN = 0, C_LW = 0, C_FLW = 0, C_SW = 0, C_FSW = 0;
    reg C_ADDI = 0, C_JAL = 0, C_LI = 0, C_LUI = 0, C_ADDI16SP = 0, C_MISCALU = 0;
    reg C_SRLI = 0, C_SRAI = 0, C_ANDI = 0, C_SUB = 0, C_XOR = 0, C_OR = 0, C_AND = 0;
    reg C_J = 0, C_BEQZ = 0, C_BNEZ = 0;
    reg C_SLLI = 0, C_LWSP = 0, C_FLWSP = 0, C_JALR = 0, C_JR = 0, C_MV = 0, C_ADD = 0, C_EBREAK = 0;
    reg C_SWSP = 0, C_FSWSP = 0;
        
//-------------------Types of immediate. Sign extension always uses inst[31]-------------------
    //Immediate of RVI
    always @(*) begin
            Iimm    =   {{21{instr_data[31]}}, instr_data[30:20]};
            Simm    =   {{21{instr_data[31]}}, instr_data[30:25], instr_data[11:8], instr_data[7]}; 
            Bimm    =   {{20{instr_data[31]}}, instr_data[7], instr_data[30:25], instr_data[11:8], 1'b0};
            Uimm    =   {instr_data[31], instr_data[30:12], 12'd0};
            Jimm    =   {{12{instr_data[31]}}, instr_data[19:12], instr_data[20], instr_data[30:21], 1'b0};
    end


    //Immediate of RVC
    always @(*) begin
            // C extension immediate decoding (RVC)
            CLoadSPimm      = {24'd0, instr_data[3:2], instr_data[12], instr_data[6:4], 2'b00}; 
            CStoreSPimm     = {24'd0, instr_data[8:7], instr_data[12:9], 2'b00};
            CLoadimm        = {25'd0, instr_data[5], instr_data[12:10], instr_data[6], 2'b00};
            CStortimm       = CLoadimm;
            CJimm           = {{20{instr_data[12]}}, instr_data[12], instr_data[8], instr_data[10:9],
                                instr_data[6], instr_data[7], instr_data[2], instr_data[11],
                                instr_data[5:3], 1'b0};
            CBimm           = {{23{instr_data[12]}}, instr_data[12], instr_data[6:5], instr_data[2],
                                instr_data[11:10], instr_data[4:3], 1'b0};
            CLIimm          = {{26{instr_data[12]}}, instr_data[12], instr_data[6:2]};
            CLUIimm         = {{14{instr_data[12]}}, instr_data[12], instr_data[6:2], 12'd0};
            CADDIimm        = CLIimm;
            CADDI16SPimm    = {{22{instr_data[12]}}, instr_data[12], instr_data[4:3],
                                instr_data[5], instr_data[2], instr_data[6], 4'd0};
            CADDI4SPNimm    = {22'd0, instr_data[10:7], instr_data[12:11], instr_data[5],
                                instr_data[6], 2'b00};
            CANDIimm        = CLIimm;
            CSimm           = {26'd0, instr_data[12], instr_data[6:2]};
    end

//---------------------Instruction - C extension----------------------
    //C extension decoded control signals
    always @(*) begin
            //-------------------------------
            // Quadrant 0
            //-------------------------------
            C_ADDI4SPN  =   (Copcodeoh[0] & Cfunct3oh_temp[0]) & |CADDI4SPNimm;      
            C_LW        =   (Copcodeoh[0] & Cfunct3oh_temp[2]);      
            C_FLW       =   (Copcodeoh[0] & Cfunct3oh_temp[3]);      
            C_SW        =   (Copcodeoh[0] & Cfunct3oh_temp[6]);      
            C_FSW       =   (Copcodeoh[0] & Cfunct3oh_temp[7]);      

            //-------------------------------
            // Quadrant 1
            //-------------------------------
            C_ADDI      = (Copcodeoh[1] & Cfunct3oh_temp[0]);// & (|instr_data[11:7]) & (|({instr_data[12], instr_data[6:2]})); --> bỏ để bao hàm cả C_NOP
            C_JAL       = (Copcodeoh[1] & Cfunct3oh_temp[1]);
            C_LI        = (Copcodeoh[1] & Cfunct3oh_temp[2]) & (|instr_data[11:7]);
            C_LUI       = (Copcodeoh[1] & Cfunct3oh_temp[3]) & (|instr_data[11:7]) & (instr_data[11:7] != 5'd2) & (|({instr_data[12], instr_data[6:2]}));//|CLUIimm;
            C_ADDI16SP  = (Copcodeoh[1] & Cfunct3oh_temp[3]) & (instr_data[11:7] == 5'd2) & |CADDI16SPimm;
            C_MISCALU   = (Copcodeoh[1] & Cfunct3oh_temp[4]);
            C_SRLI      = C_MISCALU & Cfunct21oh[0] &(!instr_data[12]) & (|instr_data[6:2]);
            C_SRAI      = C_MISCALU & Cfunct21oh[1] &(!instr_data[12]) & (|instr_data[6:2]);
            C_ANDI      = C_MISCALU & Cfunct21oh[2];
            C_SUB       = C_MISCALU & Cfunct21oh[3] & Cfunct22oh[0];//&(!instr_data[12]) - thử
            C_XOR       = C_MISCALU & Cfunct21oh[3] & Cfunct22oh[1];//&(!instr_data[12]) - thử 
            C_OR        = C_MISCALU & Cfunct21oh[3] & Cfunct22oh[2];//&(!instr_data[12]) - thử
            C_AND       = C_MISCALU & Cfunct21oh[3] & Cfunct22oh[3];//&(!instr_data[12]) - thử
            C_J         = (Copcodeoh[1] & Cfunct3oh_temp[5]);
            C_BEQZ      = (Copcodeoh[1] & Cfunct3oh_temp[6]);
            C_BNEZ      = (Copcodeoh[1] & Cfunct3oh_temp[7]);

            //-------------------------------
            // Quadrant 2
            //-------------------------------
            C_SLLI      = (Copcodeoh[2] & Cfunct3oh_temp[0]) &(!instr_data[12])& (|instr_data[11:7]);
            C_LWSP      = (Copcodeoh[2] & Cfunct3oh_temp[2]) &(|instr_data[11:7]);
            C_FLWSP     = (Copcodeoh[2] & Cfunct3oh_temp[3]);
            C_JALR      = (Copcodeoh[2] & Cfunct3oh_temp[4]) &  instr_data[12] & (|instr_data[11:7]) & !(|instr_data[6:2]);
            C_JR        = (Copcodeoh[2] & Cfunct3oh_temp[4]) &(!instr_data[12])& (|instr_data[11:7]) & !(|instr_data[6:2]);
            C_MV        = (Copcodeoh[2] & Cfunct3oh_temp[4]) &(!instr_data[12])& (|instr_data[11:7]) & (|instr_data[6:2]);
            C_ADD       = (Copcodeoh[2] & Cfunct3oh_temp[4]) &  instr_data[12] & (|instr_data[11:7]) & (|instr_data[6:2]);
            C_EBREAK    = (Copcodeoh[2] & Cfunct3oh_temp[4]) &  instr_data[12] & !(|instr_data[11:2]);
            C_SWSP      = (Copcodeoh[2] & Cfunct3oh_temp[6]);
            C_FSWSP     = (Copcodeoh[2] & Cfunct3oh_temp[7]);
    end


    //final immediate
    wire    [31:0]  Cimm    =
                        (C_ADDI4SPN)                ?   CADDI4SPNimm:
                        (C_LW | C_FLW)              ?   CLoadimm    :
                        (C_SW | C_FSW)              ?   CStortimm   :
                        (C_ADDI | C_LI | C_ANDI)    ?   CLIimm      :
                        (C_SRLI |C_SRAI | C_SLLI)   ?   CSimm       :
                        (C_ADDI16SP)                ?   CADDI16SPimm:
                        (C_JAL | C_J)               ?   CJimm       :
                        (C_LWSP | C_FLWSP)          ?   CLoadSPimm  :
                        (C_SWSP | C_FSWSP)          ?   CStoreSPimm :
                        (C_BEQZ | C_BNEZ)           ?   CBimm       :
                        (C_LUI)                     ?   CLUIimm     :
                        (C_JR | C_JALR)             ?   32'd0       :
                        32'd0;

    wire    [31:0]  Imm     =   
                        (r_insLUI | r_insAUIPC)                                                     ?   Uimm    :   
                        (r_insJAL)                                                                  ?   Jimm    :
                        (r_insJALR|r_insLOAD|r_insALUImm|r_insFENCE|r_insSYS|r_insFLOAD)            ?   Iimm    :
                        (r_insBRA)                                                                  ?   Bimm    :
                        (r_insALUReg)                                                               ?   32'd0   :   //Haven't imm
                        (r_insSTORE|r_insFSTORE)                                                    ?   Simm    :
                        32'd0;


//----------------------funct3, funct7, rs2, rs1, rd-------------------------

    //funct3, funct7, rs2, rs1, rd in C extension
    assign  Cfunct3oh_temp   =   8'b0000_0001 << instr_data[15:13];
    assign  Copcodeoh   =   4'b0001 << instr_data[ 1:0 ];
    assign  Cfunct21oh  =   4'b0001 << instr_data[11:10];
    assign  Cfunct22oh  =   4'b0001 << instr_data[ 6:5 ];



    reg     [4:0]   Cregrs1;
    reg     [4:0]   Cregrs2;
    reg     [4:0]   Cregrd;
    always @(*) begin   //rs1
        Cregrs1 = 5'd0;
        (*parallel_case*)
        case (1'b1) 
            C_LW | C_FLW | C_SW | C_FSW | C_BEQZ | C_BNEZ |
            C_SRLI | C_SRAI | C_ANDI | C_SUB |
            C_XOR | C_OR | C_AND: Cregrs1 = {2'b01, instr_data[9:7]};
            C_ADDI | C_SLLI | C_JR | C_JALR | C_ADD: Cregrs1 = instr_data[11:7];
            C_SWSP | C_LWSP | C_FSWSP | C_FLWSP: Cregrs1 = 5'd2;
            C_ADDI4SPN | C_ADDI16SP: Cregrs1 = 5'd2;
            C_LI | C_MV: Cregrs1 = 5'd0;
            default: Cregrs1 = 5'd0;
        endcase
    end
    always @(*) begin   //rs2
        Cregrs2 = 5'd0;
        (*parallel_case*)
        case (1'b1) 
            C_SW | C_FSW | C_SUB | C_XOR | C_OR | C_AND: Cregrs2 = {2'b01, instr_data[4:2]};
            C_ADD | C_MV | C_SWSP | C_FSWSP: Cregrs2 = instr_data[6:2];
            C_BEQZ | C_BNEZ: Cregrs2 = 5'd0;
            C_SLLI | C_SRAI | C_SRLI: Cregrs2 = {instr_data[12], instr_data[6:2]};//shamt
            default: Cregrs2 = 5'd0;
        endcase
    end
    always @(*) begin   //rd
        Cregrd = 5'd0;
        (*parallel_case*)
        case (1'b1) 
            C_ADDI4SPN | C_LW | C_FLW:  Cregrd = {2'b01, instr_data[4:2]};
            C_SRLI | C_SRAI | C_ANDI | C_SUB | C_XOR | C_OR | C_AND: Cregrd = {2'b01, instr_data[9:7]};
            C_ADDI | C_LI | C_LUI | C_SLLI | C_LWSP | C_FLWSP | C_MV | C_ADD: 
                                        Cregrd = instr_data[11:7];
            C_ADDI16SP:                 Cregrd = 5'd2;
            C_JAL | C_JALR:             Cregrd = 5'd1;
            C_J | C_JR:                 Cregrd = 5'd0;
            default:                    Cregrd = 5'd0;
        endcase
    end
    always @(*) begin   //funct3
        Cfunct3 = 3'b000;
        (*parallel_case*)
        case (1'b1)
            C_ADDI4SPN | C_ADDI | C_LI | C_ADDI16SP: Cfunct3 = 3'b000;
            C_SLLI: Cfunct3 = 3'b001;
            C_ANDI | C_AND: Cfunct3 = 3'b111;
            C_SRLI | C_SRAI: Cfunct3 = 3'b101;
            C_ADD | C_MV: Cfunct3 = 3'b000;
            C_SUB: Cfunct3 = 3'b000;
            C_XOR: Cfunct3 = 3'b100;
            C_OR: Cfunct3 = 3'b110;
    //        C_JR | C_JALR: Cfunct3 = 3'b000;
            C_BEQZ: Cfunct3 = 3'b000;
            C_BNEZ: Cfunct3 = 3'b001;
            C_LW | C_LWSP | C_FLW | C_FLWSP | C_SW | C_SWSP | C_FSW | C_FSWSP: Cfunct3 = 3'b010;
            default: Cfunct3 = 3'b000;
        endcase
    end
    always @(*) begin   //opcode
        CinsALUImm  = 0;
        CinsALUReg  = 0;
        CinsLUI     = 0;
        CinsJAL     = 0;
        CinsJALR    = 0;
        CinsBRA     = 0;
        CinsLOAD    = 0;
        CinsFLOAD   = 0;
        CinsSTORE   = 0;
        CinsFSTORE  = 0;
        CinsBREAK   = 0;

        (*parallel_case*)
        case (1'b1)
            C_ADDI4SPN | C_ADDI | C_LI | C_ADDI16SP |
            C_SLLI | C_SRLI | C_SRAI | C_ANDI           : CinsALUImm    = 1;
            C_ADD | C_MV | C_SUB | C_XOR | C_OR | C_AND : CinsALUReg    = 1;
            C_LUI                                       : CinsLUI       = 1;
            C_J | C_JAL                                 : CinsJAL       = 1;  
            C_JR | C_JALR                               : CinsJALR      = 1;
            C_BEQZ | C_BNEZ                             : CinsBRA       = 1;
            C_LW | C_LWSP                               : CinsLOAD      = 1;
            C_FLW | C_FLWSP                             : CinsFLOAD     = 1;
            C_SW | C_SWSP                               : CinsSTORE     = 1;
            C_FSW | C_FSWSP                             : CinsFSTORE    = 1;
            C_EBREAK                                    : CinsBREAK     = 0;///không kích hoạt
        endcase
    end

    //funct7
    always @(*) begin
        Cfunct7 = 7'd0;
        (*parallel_case*)
        case (1'b1)
            C_SLLI | C_SRLI | C_ADD | C_XOR | C_OR | C_AND: Cfunct7 = 7'd0;
            C_SRAI | C_SUB: Cfunct7 = 7'b0100000;
            default: Cfunct7 = 7'd0;
        endcase
    end



//---------------------------assign port-----------------------------


    //Instructions - opcode
    assign          insALUImm   =   r_insALUImm;
    assign          insALUReg   =   r_insALUReg;
    assign          insLUI      =   r_insLUI;
    assign          insAUIPC    =   r_insAUIPC;
    assign          insJAL      =   r_insJAL;
    assign          insJALR     =   r_insJALR;
    assign          insBRA      =   r_insBRA;
    assign          insLOAD     =   r_insLOAD;
    assign          insSTORE    =   r_insSTORE;
    assign          insSYS      =   r_insSYS;
    assign          insFENCE    =   r_insFENCE;

    always @(*) begin
        if(!rst) begin
            r_insALUImm = 0;
            r_insALUReg = 0;
            r_insLUI    = 0;
            r_insAUIPC  = 0;
            r_insJAL    = 0;
            r_insJALR   = 0;
            r_insBRA    = 0;
            r_insLOAD   = 0;
            r_insSTORE  = 0;
            r_insSYS    = 0;
            r_insFENCE  = 0;
        end
        else begin
            r_insALUImm = (r_insCEXT)   ?   CinsALUImm  :   (instr_data[6:2] == 5'b00100);// rd <- rs1 OP Iimm
            r_insALUReg = (r_insCEXT)   ?   CinsALUReg  :   (instr_data[6:2] == 5'b01100) & !instr_data[25];// rd <- rs1 OP rs2
            r_insLUI    = (r_insCEXT)   ?   CinsLUI     :   (instr_data[6:2] == 5'b01101);// rd <- Uimm
            r_insAUIPC  = (r_insCEXT)   ?   1'b0        :   (instr_data[6:2] == 5'b00101);// rd <- PC + Uimm
            r_insJAL    = (r_insCEXT)   ?   CinsJAL     :   (instr_data[6:2] == 5'b11011);// rd <- PC+4; PC<-PC+Jimm
            r_insJALR   = (r_insCEXT)   ?   CinsJALR    :   (instr_data[6:2] == 5'b11001);// rd <- PC+4; PC<-rs1+Iimm
            r_insBRA    = (r_insCEXT)   ?   CinsBRA     :   (instr_data[6:2] == 5'b11000);// if(rs1 OP rs2) PC<-PC+Bimm
            r_insLOAD   = (r_insCEXT)   ?   CinsLOAD    :   (instr_data[6:2] == 5'b00000);// rd <- mem[rs1+Iimm]
            r_insSTORE  = (r_insCEXT)   ?   CinsSTORE   :   (instr_data[6:2] == 5'b01000);// mem[rs1+Simm] <- rs2
            r_insSYS    = (r_insCEXT)   ?   CinsBREAK   :   (instr_data[6:2] == 5'b11100);
            r_insFENCE  = (r_insCEXT)   ?   1'b0        :   (instr_data[6:2] == 5'b00011);
        end
    end

    //MRET, MEXT, CEXT, enreg, funct, ...
    assign          funct3oh    =   r_funct3oh;
    assign          funct3      =   r_funct3;
    assign          funct7      =   r_funct7;
    assign          regrs1      =   r_regrs1;
    assign          regrs2      =   r_regrs2;
    assign          regrd       =   r_regrd;
    assign          csr_addr    =   r_csr_addr;
    assign          en_rs1      =   r_en_rs1;
    assign          en_rs2      =   r_en_rs2;
    assign          en_rd       =   r_en_rd;
    assign          en_frs1     =   r_en_frs1;
    assign          en_frs2     =   r_en_frs2;
    assign          en_frs3     =   r_en_frs3;
    assign          en_frd      =   r_en_frd;
    assign          insMRET     =   r_insMRET;
    assign          insMEXT     =   r_insMEXT;
    assign          insCEXT     =   r_insCEXT;
    

    always @(*) begin
            r_insCEXT   =   (!Copcodeoh[3]);    //C EXTENSION
            r_funct3oh  =   8'b0000_0001 << ((r_insCEXT)?Cfunct3:instr_data[14:12]);
            r_funct3    =   (r_insCEXT)   ?   Cfunct3     :   instr_data[14:12];
            r_funct7    =   (r_insCEXT)   ?   Cfunct7     :   instr_data[31:25];
            r_regrs1    =   (r_insCEXT)   ?   Cregrs1     :   instr_data[19:15];
            r_regrs2    =   (r_insCEXT)   ?   Cregrs2     :   instr_data[24:20];
            r_regrd     =   (r_insCEXT)   ?   Cregrd      :   instr_data[11:7];
            r_csr_addr  =                                     instr_data[31:20];
            r_en_rs1    =   insJALR|insBRA|insLOAD|insSTORE|insALUImm|insALUReg|(insSYS&(funct3oh[1]|funct3oh[2]|funct3oh[3]))|insMEXT|(insFMVWX)|(insFLOAD)|(insFSTORE)|insFCVTSWU|insFCVTSW;
            r_en_rs2    =   insALUReg|insSTORE|insBRA|insMEXT;
            r_en_rd     =   insLUI|insAUIPC|insJAL|insJALR|insLOAD|insALUImm|insALUReg|(insSYS&(|funct3))|insFMVXW|insMEXT|insFCVTWS|insFCVTWUS|insFEQ|insFLT|insFLE|insFCLASS;
            r_en_frs1   =   insFMADD|insFNMADD|insFMSUB|insFNMSUB|(insFPUsim && !insFMVWX && !insFCVTSW && !insFCVTSWU);
            r_en_frs2   =   insFSTORE|insFMADD|insFNMADD|insFMSUB|insFNMSUB|(insFPUsim && !insFSQRT && !insFCVTSW && !insFCVTSWU && !insFCVTWS && !insFCVTWUS && !insFMVWX && !insFMVXW && !insFCLASS);//Không cần thiết vì các lệnh này không xảy ra hazard hoặc không pipeline
            r_en_frs3   =   insFMADD|insFNMADD|insFMSUB|insFNMSUB;
            r_en_frd    =   insFLOAD|insFMADD|insFNMADD|insFMSUB|insFNMSUB|(insFPUsim && !insFCLASS && !insFEQ && !insFLT && !insFLE && !insFMVXW && !insFCVTWS && !insFCVTWUS);
            r_insMRET   =   (instr_data == 32'h30200073); //MRET: sử dụng cho ngắt. Muốn quay về PC sau khi đã ngắt xong
            r_insMEXT   =   (instr_data[6:2] == 5'b01100) & instr_data[25] & !r_insCEXT;    //M EXTENSION
    end

    //Immediate
    assign Immediate    =   (r_insCEXT)?Cimm:Imm;

`endif

`ifndef COMPRESSED_EXTENTIONS
    reg             r_insFLOAD  =   0;
    reg             r_insFSTORE =   0;
    reg             r_insFPUsim =   0;
    reg             r_insFMADD  =   0;
    reg             r_insFMSUB  =   0;
    reg             r_insFNMSUB =   0;
    reg             r_insFNMADD =   0; 

    reg             r_insFADD   =   0;
    reg             r_insFSUB   =   0;
    reg             r_insFMUL   =   0;
    reg             r_insFDIV   =   0;
    reg             r_insFSQRT  =   0;
    reg             r_insFSGNJ  =   0;
    reg             r_insFSGNJN =   0;
    reg             r_insFSGNJX =   0;
    reg             r_insFMIN   =   0;
    reg             r_insFMAX   =   0;
    reg             r_insFCVTWS =   0;
    reg             r_insFCVTWUS=   0;
    reg             r_insFMVXW  =   0;
    reg             r_insFEQ    =   0;
    reg             r_insFLT    =   0;
    reg             r_insFLE    =   0;
    reg             r_insFCLASS =   0;
    reg             r_insFCVTSW =   0;
    reg             r_insFCVTSWU=   0;
    reg             r_insFMVWX  =   0;
    reg             r_insFMSUB  =   0;
    reg             r_insFNMSUB =   0;
    reg             r_insFNMADD =   0;


    reg             r_insALUImm =   0;
    reg             r_insALUReg =   0;
    reg             r_insLUI    =   0;
    reg             r_insAUIPC  =   0;
    reg             r_insJAL    =   0;
    reg             r_insJALR   =   0;
    reg             r_insBRA    =   0;
    reg             r_insLOAD   =   0;
    reg             r_insSTORE  =   0;
    reg             r_insSYS    =   0;
    reg             r_insFENCE  =   0;

    reg     [31:0 ] Iimm    =   32'h0;
    reg     [31:0 ] Simm    =   32'h0;
    reg     [31:0 ] Bimm    =   32'h0;
    reg     [31:0 ] Uimm    =   32'h0;
    reg     [31:0 ] Jimm    =   32'h0;

    reg     [ 7:0 ] r_funct3oh  =   8'd0;        
    reg     [ 2:0 ] r_funct3    =   3'd0; 
    reg     [ 6:0 ] r_funct7    =   7'd0; 
    reg     [ 4:0 ] r_regrs1    =   5'd0; 
    reg     [ 4:0 ] r_regrs2    =   5'd0;
    reg     [ 4:0 ] r_regrs3    =   5'd0;  
    reg     [ 4:0 ] r_regrd     =   5'd0; 
    reg     [11:0 ] r_csr_addr  =   12'd0; 
    reg             r_en_rs1    =   1'b0;
    reg             r_en_rs2    =   1'b0;
    reg             r_en_rd     =   1'b0; 
    reg             r_insMRET   =   1'b0;
    reg             r_insMEXT   =   1'b0;
    reg             r_insCEXT   =   1'b0; 

    
//--------------Types of immediate. Sign extension always uses inst[31]-------------
    always @(*) begin
        if(!rst) begin
            Iimm = 0; Simm = 0; Bimm = 0; Uimm = 0; Jimm = 0;
        end
        else begin
            Iimm    =   {{21{instr_data[31]}}, instr_data[30:20]};
            Simm    =   {{21{instr_data[31]}}, instr_data[30:25], instr_data[11:8], instr_data[7]}; 
            Bimm    =   {{20{instr_data[31]}}, instr_data[7], instr_data[30:25], instr_data[11:8], 1'b0};
            Uimm    =   {instr_data[31], instr_data[30:12], 12'd0};
            Jimm    =   {{12{instr_data[31]}}, instr_data[19:12], instr_data[20], instr_data[30:21], 1'b0};
        end
    end

    wire    [31:0]  Imm     =   
                        (r_insLUI | r_insAUIPC)                                             ?   Uimm    :   
                        (r_insJAL)                                                          ?   Jimm    :
                        (r_insJALR|r_insLOAD|r_insALUImm|r_insFENCE|r_insSYS|r_insFLOAD)    ?   Iimm    :
                        (r_insBRA)                                                          ?   Bimm    :
                        (r_insALUReg)                                                       ?   32'd0   :   //Haven't imm
                        (r_insSTORE|r_insFSTORE)                                            ?   Simm    :
                        
                        32'd0;
    assign Immediate = Imm;



//---------------------------------Instructions - opcode--------------------------------
    assign          insALUImm   =   r_insALUImm;
    assign          insALUReg   =   r_insALUReg;
    assign          insLUI      =   r_insLUI;
    assign          insAUIPC    =   r_insAUIPC;
    assign          insJAL      =   r_insJAL;
    assign          insJALR     =   r_insJALR;
    assign          insBRA      =   r_insBRA;
    assign          insLOAD     =   r_insLOAD;
    assign          insSTORE    =   r_insSTORE;
    assign          insSYS      =   r_insSYS;
    assign          insFENCE    =   r_insFENCE;

    always @(*) begin
        if(!rst) begin
            r_insALUImm = 0;
            r_insALUReg = 0;
            r_insLUI    = 0;
            r_insAUIPC  = 0;
            r_insJAL    = 0;
            r_insJALR   = 0;
            r_insBRA    = 0;
            r_insLOAD   = 0;
            r_insSTORE  = 0;
            r_insSYS    = 0;
            r_insFENCE  = 0;
        end
        else begin
            r_insALUImm = (instr_data[6:2] == 5'b00100);// rd <- rs1 OP Iimm
            r_insALUReg = (instr_data[6:2] == 5'b01100) & !instr_data[25];// rd <- rs1 OP rs2
            r_insLUI    = (instr_data[6:2] == 5'b01101);// rd <- Uimm
            r_insAUIPC  = (instr_data[6:2] == 5'b00101);// rd <- PC + Uimm
            r_insJAL    = (instr_data[6:2] == 5'b11011);// rd <- PC+4; PC<-PC+Jimm
            r_insJALR   = (instr_data[6:2] == 5'b11001);// rd <- PC+4; PC<-rs1+Iimm
            r_insBRA    = (instr_data[6:2] == 5'b11000);// if(rs1 OP rs2) PC<-PC+Bimm
            r_insLOAD   = (instr_data[6:2] == 5'b00000);// rd <- mem[rs1+Iimm]
            r_insSTORE  = (instr_data[6:2] == 5'b01000);// mem[rs1+Simm] <- rs2
            r_insSYS    = (instr_data[6:2] == 5'b11100);
            r_insFENCE  = (instr_data[6:2] == 5'b00011);
        end
    end
   


//-------------------funct3, funct7, rs2, rs1, rd, csr, shamt----------------------
    assign          funct3oh    =   r_funct3oh;
    assign          funct3      =   r_funct3;
    assign          funct7      =   r_funct7;
    assign          regrs1      =   r_regrs1;
    assign          regrs2      =   r_regrs2;
    assign          regrd       =   r_regrd;
    assign          csr_addr    =   r_csr_addr;
    assign          en_rs1      =   r_en_rs1;
    assign          en_rs2      =   r_en_rs2;
    assign          en_frs1     =   r_en_frs1;
    assign          en_frs2     =   r_en_frs2;
    assign          en_frs3     =   r_en_frs3;
    assign          en_rd       =   r_en_rd;
    assign          insMRET     =   r_insMRET;
    assign          insMEXT     =   r_insMEXT;
    assign          insCEXT     =   r_insCEXT;
    

    always @(*) begin
        if(!rst) begin
            r_funct3oh  =   8'd0;
            r_funct3    =   3'd0;
            r_funct7    =   7'd0;
            r_regrs1    =   5'd0;
            r_regrs2    =   5'd0;
            r_regrd     =   5'd0;
            r_csr_addr  =   12'd0;
            r_en_rs1    =   1'b0;
            r_en_rs2    =   1'b0;
            r_en_rd     =   1'b0;
            r_en_frs1   =   1'b0;
            r_en_frs2   =   1'b0;
            r_en_frs3   =   1'b0;
            r_insMRET   =   1'b0;
            r_insMEXT   =   1'b0;
            r_insCEXT   =   1'b0;
        end
        else begin
            r_funct3oh  =   8'b0000_0001 << instr_data[14:12];
            r_funct3    =   instr_data[14:12];
            r_funct7    =   instr_data[31:25];
            r_regrs1    =   instr_data[19:15];
            r_regrs2    =   instr_data[24:20];
            r_regrd     =   instr_data[11:7];
            r_csr_addr  =   instr_data[31:20];
            r_en_rs1    =   (!((insAUIPC)|(insLUI)|(insJAL)|(insFENCE)))|(insSYS&(funct3oh[1]|funct3oh[2]|funct3oh[3]))|insMEXT;
            r_en_rs2    =   insALUReg|insSTORE|insBRA|insMEXT;
            r_en_rd     =   (!((insBRA)|(insSTORE)|(insFENCE)|((insSYS&funct3oh[0]))))|insMEXT;
            r_en_frs1   =   insFMADD|insFNMADD|insFMSUB|insFNMSUB|(insFPUsim && !insFMVWX && !insFCVTSW && !insFCVTSWU);
            r_en_frs2   =   insFSTORE|insFMADD|insFNMADD|insFMSUB|insFNMSUB|(insFPUsim);// && !insFSQRT && !insFCVTSW && !insFCVTSWU && !insFCVTWS && !insFCVTWUS && !insFMVWX && !insFMVXW && !insFCLASS);//Không cần thiết vì các lệnh này không xảy ra hazard hoặc không pipeline
            r_en_frs3   =   insFMADD|insFNMADD|insFMSUB|insFNMSUB;
            r_insMRET   =   instr_data == 32'h30200073;//MRET: sử dụng cho ngắt. Muốn quay về PC sau khi đã ngắt xong
            r_insMEXT   =   (instr_data[6:2] == 5'b01100) & instr_data[25];  
            r_insCEXT   =   1'b0;
        end
    end

`endif

`ifdef FLOATING_POINT_EXTENSIONS

    //Instructions - opcode
    assign          insFLOAD    =   r_insFLOAD;
    assign          insFSTORE   =   r_insFSTORE;
    assign          insFPUsim   =   r_insFPUsim;
    assign          insFMADD    =   r_insFMADD;
    assign          insFMSUB    =   r_insFMSUB;
    assign          insFNMSUB   =   r_insFNMSUB;
    assign          insFNMADD   =   r_insFNMADD;

    assign          insFADD     =   r_insFADD;
    assign          insFSUB     =   r_insFSUB;
    assign          insFMUL     =   r_insFMUL;
    assign          insFDIV     =   r_insFDIV;
    assign          insFSQRT    =   r_insFSQRT;
    assign          insFSGNJ    =   r_insFSGNJ;
    assign          insFSGNJN   =   r_insFSGNJN;
    assign          insFSGNJX   =   r_insFSGNJX;
    assign          insFMIN     =   r_insFMIN;
    assign          insFMAX     =   r_insFMAX;
    assign          insFCVTWS   =   r_insFCVTWS;
    assign          insFCVTWUS  =   r_insFCVTWUS;
    assign          insFMVXW    =   r_insFMVXW;
    assign          insFEQ      =   r_insFEQ;
    assign          insFLT      =   r_insFLT;
    assign          insFLE      =   r_insFLE;
    assign          insFCLASS   =   r_insFCLASS;
    assign          insFCVTSW   =   r_insFCVTSW;
    assign          insFCVTSWU  =   r_insFCVTSWU;
    assign          insFMVWX    =   r_insFMVWX;


    always @(*) begin
            r_insFLOAD  = (r_insCEXT)?CinsFLOAD :(instr_data[6:2] == 5'b00001);
            r_insFSTORE = (r_insCEXT)?CinsFSTORE:(instr_data[6:2] == 5'b01001);
            r_insFPUsim = (instr_data[6:2] == 5'b10100) && (!r_insCEXT);
            r_insFMADD  = (instr_data[6:2] == 5'b10000) && (!r_insCEXT);
            r_insFMSUB  = (instr_data[6:2] == 5'b10001) && (!r_insCEXT);
            r_insFNMSUB = (instr_data[6:2] == 5'b10010) && (!r_insCEXT);
            r_insFNMADD = (instr_data[6:2] == 5'b10011) && (!r_insCEXT);

            r_insFADD   = insFPUsim && (funct7 == 7'b0000000);
            r_insFSUB   = insFPUsim && (funct7 == 7'b0000100);
            r_insFMUL   = insFPUsim && (funct7 == 7'b0001000);
            r_insFDIV   = insFPUsim && (funct7 == 7'b0001100);
            r_insFSQRT  = insFPUsim && (funct7 == 7'b0101100);
            r_insFSGNJ  = insFPUsim && (funct7 == 7'b0010000) && funct3oh[0];
            r_insFSGNJN = insFPUsim && (funct7 == 7'b0010000) && funct3oh[1];
            r_insFSGNJX = insFPUsim && (funct7 == 7'b0010000) && funct3oh[2];
            r_insFMIN   = insFPUsim && (funct7 == 7'b0010100) && funct3oh[0];
            r_insFMAX   = insFPUsim && (funct7 == 7'b0010100) && funct3oh[1];
            r_insFCVTWS = insFPUsim && (funct7 == 7'b1100000) && !regrs2[0];
            r_insFCVTWUS= insFPUsim && (funct7 == 7'b1100000) && regrs2[0];
            r_insFMVXW  = insFPUsim && (funct7 == 7'b1110000) && funct3oh[0];
            r_insFEQ    = insFPUsim && (funct7 == 7'b1010000) && funct3oh[2];
            r_insFLT    = insFPUsim && (funct7 == 7'b1010000) && funct3oh[1];
            r_insFLE    = insFPUsim && (funct7 == 7'b1010000) && funct3oh[0];
            r_insFCLASS = insFPUsim && (funct7 == 7'b1110000) && funct3oh[1];
            r_insFCVTSW = insFPUsim && (funct7 == 7'b1101000) && !regrs2[0];
            r_insFCVTSWU= insFPUsim && (funct7 == 7'b1101000) && regrs2[0];
            r_insFMVWX  = insFPUsim && (funct7 == 7'b1111000) && funct3oh[0];
    end

    //rs3: chỉ các lệnh có 2 phép tính mới dùng rs3
    assign          regrs3     =   r_regrs3;

    always @(*) begin
            r_regrs3    =   instr_data[31:27];
    end
    

`endif
`ifndef FLOATING_POINT_EXTENSIONS
    //Instructions - opcode
    assign          insFLOAD    =   r_insFLOAD;
    assign          insFSTORE   =   r_insFSTORE;
    assign          insFPUsim   =   r_insFPUsim;
    assign          insFMADD    =   r_insFMADD;
    assign          insFMSUB    =   r_insFMSUB;
    assign          insFNMSUB   =   r_insFNMSUB;
    assign          insFNMADD   =   r_insFNMADD;

    always @(*) begin
            r_insFLOAD  = 0;
            r_insFSTORE = 0;
            r_insFPUsim = 0;
            r_insFMADD  = 0;
            r_insFMSUB  = 0;
            r_insFNMSUB = 0;
            r_insFNMADD = 0;
    end

    //rs3: chỉ các lệnh có 2 phép tính mới dùng rs3
    assign          regrs3     =   r_regrs3;

    always @(*) begin
            r_regrs3    =   5'd0;
    end
`endif

endmodule

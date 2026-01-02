`include "Define.vh"
module RV32I_core(
    input           clk,    
    input           rst,

    output  [31:0 ] peri_addr,
    output  [31:0 ] peri_wdata,
    output  [ 3:0 ] peri_wmask,
    input   [31:0 ] peri_rdata,
    output          peri_wen,
    output          peri_ren,

    output  [ 2:0 ] peri_burst,
     
    output  [ 1:0 ] peri_htrans,

    input           peri_rvalid,
    input           peri_wdone,
    input           peri_err,

    input           irq_flag,
    input           irq_external_pending,
    output          trap_en
//    input   [ 5:0 ] irq_claim_id
);
`define DEBUG_EN

localparam  INSTR_FIRST     =   32'h00000000;
localparam  INSTR_NOP       =   32'h00000013;
localparam  VALUE_RESET32   =   32'h00000000;
localparam  VALUE_RESET     =   0;


//for CPU 5 instruction cycles
localparam  IF              =   0;
localparam  ID              =   1;
localparam  EX              =   2;
localparam  MEM             =   3;
localparam  WB              =   4;


localparam  Fetchoh         =   5'b00001 <<  IF;        //Fetch
localparam  Decodeoh        =   5'b00001 <<  ID;        //Decode
localparam  Executeoh       =   5'b00001 <<  EX;        //Execute
localparam  MemoryAoh       =   5'b00001 <<  MEM;       //Memory access
localparam  WriteBoh        =   5'b00001 <<  WB;        //Write back


//for CPU 3 instruction cycles
localparam  FD              =   0;                      //Fetch and decodes
localparam  EM              =   1;                      //Execute and access memory
localparam  WM              =   2;                      //Write back reg or mem

localparam  FetADec         =   5'b00001 <<  FD;
localparam  ExeAMem         =   5'b00001 <<  EM;
localparam  WRegOMem        =   5'b00001 <<  WM;

localparam  CLOCKSYS        =   80;

wire            clksys = clk;
wire            ALU_done;
wire            FPU_pause;
wire            wait_peri;
wire    [31:0 ] memins_rdata_pred;
wire    [15:0 ] memins_rdata_pred1;
wire    [15:0 ] memins_rdata_pred2;

wire    [31:0 ] memd_ldata;
wire    [31:0 ] memf_ldata;
reg     [15:0 ] memins_rdatacom1, memins_rdatacom2;
//reg     [31:0 ] memins_rdata;
reg     [31:0 ] mem_addr = VALUE_RESET32;
wire    [31:0 ] memins_addr;
reg     [31:0 ] mem_ldmaskfn = 0;
reg     [31:0 ] mem_ldmaskhold = 0;
reg        Wrongpred_pause = 0;
reg        Wrongpred_pause_ff = 0;

reg     [31:0 ] processor_data;
wire            s0_sel_mem      = (mem_addr[31:28] == 4'h2);
wire            s1_sel_flash    = (mem_addr[31:28] == 4'h1);

wire            insJALRpred;
//B?t c? nop
reg     [ 2:0 ] nop_cnt = 7;
reg             nop_done = 0;
reg             nop_busy = 0;
reg             nop_busyf= 0;
wire            insFpausepred;
reg             insFpausepred_shift1    = 0; always @(posedge clksys) insFpausepred_shift1  <= insFpausepred;
reg             insJALRpred_shift1      = 0; always @(posedge clksys) insJALRpred_shift1    <= insJALRpred;

wire            nop_forJALR     =   insJALRpred && (|nop_cnt);
wire            nop_forFpause   =   insFpausepred && (|nop_cnt);
reg             flag_nop = 0;

    reg s0_sel_memshift1    = 0;
    reg s1_sel_flashshift1  = 0;

    always @(posedge clksys) begin
        if(!wait_peri && ALU_done && !FPU_pause)
            s0_sel_memshift1 <= s0_sel_mem;
            s1_sel_flashshift1 <= s1_sel_flash;
    end

    always @(*) begin
        case({s1_sel_flashshift1, s0_sel_memshift1})
            2'b01: processor_data = memd_ldata;
            2'b10: processor_data = memf_ldata;
            2'b00: processor_data = peri_rdata;
            default: processor_data = 32'h00000000;
        endcase
    end



/*-------------------------------------------------
This module decodes 32-bit RV32I instructions by extracting fields such as opcode, rd, rs1, rs2, funct3, funct7, and immediate values. 
It identifies the instruction format (R, I, S, B, U, J) and generates control signals for execution units.
-------------------------------------------------*/
reg     [31:0 ] instr_data = 32'h2001e117;
wire    [31:0 ] Immediate_com;
wire            insALUImm_com, insALUReg_com, insLUI_com,
                insAUIPC_com, insJAL_com, insJALR_com,
                insBRA_com, insLOAD_com, insSTORE_com,
                insSYS_com, insFENCE_com;
reg             DecodeNotValid_fn = 0;
wire            DecodeNotValids;
wire    [ 2:0 ] funct3_com;
wire    [ 7:0 ] funct3oh_com;
wire    [ 6:0 ] funct7_com;
wire    [ 4:0 ] regrs3_com;
wire    [ 4:0 ] regrs2_com;
wire    [ 4:0 ] regrs1_com;
wire    [ 4:0 ] regrd_com;
wire            en_rs1_com;
wire            en_rs2_com;
wire            en_rd_com;
wire            en_frs1_com;
wire            en_frs2_com;
wire            en_frs3_com;
wire            en_frd_com;
wire    [ 3:0 ] pred_com;
wire    [ 3:0 ] succ_com;
wire    [11:0 ] csr_addr_com;
wire            insMRET_com;
wire            insMEXT_com;
wire            insCEXT_com;

wire            FLW_com;
wire            FSW_com;
wire            FMADD_com;
wire            FMSUB_com;
wire            FNMSUB_com;
wire            FNMADD_com;
wire            FADD_com;
wire            FSUB_com;
wire            FMUL_com;
wire            FDIV_com;
wire            FSQRT_com;
wire            FSGNJ_com;
wire            FSGNJN_com;
wire            FSGNJX_com;
wire            FMIN_com;
wire            FMAX_com;
wire            FCVTWS_com;
wire            FCVTWUS_com;
wire            FMVXW_com;
wire            FEQ_com;
wire            FLT_com;
wire            FLE_com;
wire            FCLASS_com;
wire            FCVTSW_com;
wire            FCVTSWU_com;
wire            FMVWX_com;       

reg     [31:0 ] Immediate;
reg             insALUImm, insALUReg, insLUI,
                insAUIPC, insJAL, insJALR,
                insBRA, insLOAD, insSTORE,
                insSYS, insFENCE;
reg             FLW, FSW, FMADD, 
                FMSUB, FNMSUB, 
                FNMADD;
reg             FADD, FSUB, FMUL, FDIV, FSQRT;
reg             FSGNJ, FSGNJN, FSGNJX;
reg             FMIN, FMAX;
reg             FCVTWS, FCVTWUS, FMVXW;
reg             FEQ, FLT, FLE;
reg             FCLASS;
reg             FCVTSW, FCVTSWU, FMVWX;

reg     [ 2:0 ] funct3;
reg     [ 7:0 ] funct3oh;
reg     [ 6:0 ] funct7;
reg     [ 4:0 ] regrs3;
reg     [ 4:0 ] regrs2;
reg     [ 4:0 ] regrs1;
reg     [ 4:0 ] regrd;
reg             en_rs1;
reg             en_rs2;
reg             en_rd;
reg             en_frs1;
reg             en_frs2;
reg             en_frs3;
reg             en_frd;
reg     [ 3:0 ] pred;
reg     [ 3:0 ] succ;
reg     [11:0 ] csr_addr;
reg             insMRET;
reg             insMEXT;
reg             insCEXT;

reg             isInsertNop = 0;
reg             isInsertNop_ff1 = 0;
reg             isInsertNop_ff2 = 0;
reg             isInsertNop_ff3 = 0;

reg             pausebra_jalr_ff1= 0;
reg             pausebra_jalr_ff2= 0;
reg             pausebra_jalr_ff3= 0;
reg             pausebra_jalr_ff4= 0;

reg             CPUhazard_pause1= 0;
reg             CPUhazard_pause2= 0;
reg             CPUhazard_pause3= 0;

RV32_Decoder Maindecoder(
    .instr_data         (instr_data),
    .rst                (rst),
    .Immediate          (Immediate_com),
    .insALUImm          (insALUImm_com),
    .insALUReg          (insALUReg_com),
    .insLUI             (insLUI_com),
    .insAUIPC           (insAUIPC_com),
    .insJAL             (insJAL_com),
    .insJALR            (insJALR_com),
    .insBRA             (insBRA_com),
    .insLOAD            (insLOAD_com),
    .insSTORE           (insSTORE_com),
    .insSYS             (insSYS_com),
    .insFENCE           (insFENCE_com),
    .funct3             (funct3_com),
    .funct3oh           (funct3oh_com),
    .funct7             (funct7_com),
    .regrs3             (regrs3_com),
    .regrs2             (regrs2_com),
    .regrs1             (regrs1_com),
    .regrd              (regrd_com),
    .en_rs1             (en_rs1_com),
    .en_rs2             (en_rs2_com),
    .en_rd              (en_rd_com),
    .en_frs1            (en_frs1_com),
    .en_frs2            (en_frs2_com),
    .en_frs3            (en_frs3_com),
    .en_frd             (en_frd_com),

    .insFLOAD           (FLW_com),
    .insFSTORE          (FSW_com),
    .insFMADD           (FMADD_com),
    .insFMSUB           (FMSUB_com),
    .insFNMSUB          (FNMSUB_com),
    .insFNMADD          (FNMADD_com),

    .insFADD            (FADD_com),
    .insFSUB            (FSUB_com),
    .insFMUL            (FMUL_com),
    .insFDIV            (FDIV_com),
    .insFSQRT           (FSQRT_com),
    .insFSGNJ           (FSGNJ_com),
    .insFSGNJN          (FSGNJN_com),
    .insFSGNJX          (FSGNJX_com),
    .insFMIN            (FMIN_com),
    .insFMAX            (FMAX_com),
    .insFCVTWS          (FCVTWS_com),
    .insFCVTWUS         (FCVTWUS_com),
    .insFMVXW           (FMVXW_com),
    .insFEQ             (FEQ_com),
    .insFLT             (FLT_com),
    .insFLE             (FLE_com),
    .insFCLASS          (FCLASS_com),
    .insFCVTSW          (FCVTSW_com),
    .insFCVTSWU         (FCVTSWU_com),
    .insFMVWX           (FMVWX_com),

    .csr_addr           (csr_addr_com),
    .insMRET            (insMRET_com),
    .insMEXT            (insMEXT_com),
    .insCEXT            (insCEXT_com)
);

//Ch?t d? li?u
always @(posedge clksys) begin
    if (!rst) begin
        DecodeNotValid_fn <= 0;
        Immediate       <= 32'b0;
        insALUImm       <= 1'b0;
        insALUReg       <= 1'b0;
        insLUI          <= 1'b0;
        insAUIPC        <= 1'b0;
        insJAL          <= 1'b0;
        insJALR         <= 1'b0;
        insBRA          <= 1'b0;
        insLOAD         <= 1'b0;
        insSTORE        <= 1'b0;
        insSYS          <= 1'b0;
        insFENCE        <= 1'b0;
        funct3          <= 3'b0;
        funct3oh        <= 8'b0;
        funct7          <= 7'b0;
        regrs3          <= 5'b0;
        regrs2          <= 5'b0;
        regrs1          <= 5'b0;
        regrd           <= 5'b0;
        en_rs1          <= 1'b0;
        en_rs2          <= 1'b0;
        en_rd           <= 1'b0;
        en_frs1         <= 1'b0;
        en_frs2         <= 1'b0;
        en_frs3         <= 1'b0;
        en_frd          <= 1'b0;
        csr_addr        <= 12'b0;
        insMRET         <= 1'b0;
        insMEXT         <= 1'b0;
        insCEXT         <= 1'b0;
        nop_busyf       <= 1'b0;

        FLW             <= 1'b0;
        FSW             <= 1'b0;
        FMADD           <= 1'b0;
        FMSUB           <= 1'b0;
        FNMSUB          <= 1'b0;
        FNMADD          <= 1'b0;
        FADD            <= 1'b0;
        FSUB            <= 1'b0;
        FMUL            <= 1'b0;
        FDIV            <= 1'b0;
        FSQRT           <= 1'b0;
        FSGNJ           <= 1'b0;
        FSGNJN          <= 1'b0;
        FSGNJX          <= 1'b0;
        FMIN            <= 1'b0;
        FMAX            <= 1'b0;
        FCVTWS          <= 1'b0;
        FCVTWUS         <= 1'b0;
        FMVXW           <= 1'b0;
        FEQ             <= 1'b0;
        FLT             <= 1'b0;
        FLE             <= 1'b0;
        FCLASS          <= 1'b0;
        FCVTSW          <= 1'b0;
        FCVTSWU         <= 1'b0;
        FMVWX           <= 1'b0;

    end
    else if(!wait_peri && ALU_done && !FPU_pause) begin
        Immediate       <= Immediate_com;
        insALUImm       <= insALUImm_com;
        insALUReg       <= insALUReg_com;
        insLUI          <= insLUI_com;
        insAUIPC        <= insAUIPC_com;
        insJAL          <= insJAL_com;
        insJALR         <= insJALR_com;
        insBRA          <= insBRA_com;
        insLOAD         <= insLOAD_com;
        insSTORE        <= insSTORE_com;
        insSYS          <= insSYS_com;
        insFENCE        <= insFENCE_com;
        funct3          <= funct3_com;
        funct3oh        <= funct3oh_com;
        funct7          <= funct7_com;
        regrs3          <= regrs3_com;
        regrs2          <= regrs2_com;
        regrs1          <= regrs1_com;
        regrd           <= regrd_com;
        en_rs1          <= en_rs1_com;
        en_rs2          <= en_rs2_com;
        en_rd           <= en_rd_com;
        en_frs1         <= en_frs1_com;
        en_frs2         <= en_frs2_com;
        en_frs3         <= en_frs3_com;
        en_frd          <= en_frd_com;
        csr_addr        <= csr_addr_com;
        insMRET         <= insMRET_com;
        insMEXT         <= insMEXT_com;
        insCEXT         <= insCEXT_com;
        nop_busyf       <= nop_busy;
        DecodeNotValid_fn <= DecodeNotValids;

        FLW             <= FLW_com;
        FSW             <= FSW_com;
        FMADD           <= FMADD_com;
        FMSUB           <= FMSUB_com;
        FNMSUB          <= FNMSUB_com;
        FNMADD          <= FNMADD_com;
        FADD            <= FADD_com;
        FSUB            <= FSUB_com;
        FMUL            <= FMUL_com;
        FDIV            <= FDIV_com;
        FSQRT           <= FSQRT_com;
        FSGNJ           <= FSGNJ_com;
        FSGNJN          <= FSGNJN_com;
        FSGNJX          <= FSGNJX_com;
        FMIN            <= FMIN_com;
        FMAX            <= FMAX_com;
        FCVTWS          <= FCVTWS_com;
        FCVTWUS         <= FCVTWUS_com;
        FMVXW           <= FMVXW_com;
        FEQ             <= FEQ_com;
        FLT             <= FLT_com;
        FLE             <= FLE_com;
        FCLASS          <= FCLASS_com;
        FCVTSW          <= FCVTSW_com;
        FCVTSWU         <= FCVTSWU_com;
        FMVWX           <= FMVWX_com;
        isInsertNop     <= ((|nop_cnt) && !(&nop_cnt)) || flag_nop;
    end
end


/*---------------------------------------------------
Instruction Memory:
A read-only memory that stores machine instructions. 
The CPU provides an address and receives the corresponding 32-bit instruction. 
It is used during the instruction fetch stage and does not support write operations.

Data Memory:
A read-write memory used to store program data. 
The CPU can read from or write to a specified address. 
It is accessed during the load/store stage of instruction execution.
---------------------------------------------------*/
//reg     [31:0 ] mem_addr, memint_addr;
reg     [31:0 ] memd_sdata = VALUE_RESET32;
wire    [31:0 ] memd_sdatafn;       assign  memd_sdatafn    =   memd_sdata << (mem_addr[1:0]*8);    //Shift data for store byte or haftw
reg             memd_lready = VALUE_RESET; 
wire            memins_read;
wire    [ 3:0 ] memd_mask;
reg             memd_senable = 1'b0;

wire            flag_branch;
reg     [ 1:0 ] predict_taken2  =   VALUE_RESET;

reg     [31:0 ] PCnext          =   INSTR_FIRST;
reg     [31:0 ] PCnext_fast     =   INSTR_FIRST;
reg     [31:0 ] PCnext_actual   =   INSTR_FIRST;
reg             wrong_pred      =   VALUE_RESET;
reg             wrong_predshift1=   VALUE_RESET;
wire            wrong_predfast; 
assign          wrong_predfast  =   insBRA & (flag_branch != predict_taken2[1]) & !wrong_pred & !wrong_predshift1;//L?u ý ch? b?t khi tr??c ?ó 2 chu kì không có sai r? nhánh.


assign          memins_rdata_pred = {memins_rdata_pred2, memins_rdata_pred1};

wire            wait_peri_as;
wire            mem_renablepred;

wire            memins_ren_fn = !(wait_peri_as || !ALU_done || FPU_pause) && memins_read;

    always @(posedge clk) begin
        if(!rst) begin
            memins_rdatacom1 <= 16'he117;
            memins_rdatacom2 <= 16'h2001;
        end
        else if(!wait_peri && ALU_done && !FPU_pause) begin
            memins_rdatacom1 <= memins_rdata_pred1;
            memins_rdatacom2 <= memins_rdata_pred2;
        end
    end




wire meminspred_ren_fn = mem_renablepred && !nop_forJALR && !nop_forFpause;

Co_memory #(
//    .MEM_FILE   ("C:/Users/PHONG/OneDrive - ptit.edu.vn/Desktop/FW RV32I/firmware/firmware.hex"),
//    .MEM_FILE   ("C:/firmware_instr.hex"),
//    .MEM_FILE   ("D:/Gowin/firmware_instr.hex"),
    .MEM_FILE   ("C:/Users/PHONG/OneDrive - ptit.edu.vn/Desktop/Project_I2C/firmware/build/firmware_instr.hex"),
    .SIZE       (47875)  //187Kb
) co_mem(
    .clk            (clksys),
    .mem_addrpred1  (PCnext_fast),
    .mem_addrpred2  (PCnext_fast+2),
    .mem_rdata_pred1(memins_rdata_pred1),
    .mem_rdata_pred2(memins_rdata_pred2),
    .mem_renablepred(meminspred_ren_fn)
);

//Ch?t l?nh
reg [31:0 ] memins_rdata = 32'h2001e117;
always @(posedge clksys) begin
    if(!rst) begin
        memins_rdata <= 32'h2001e117;
    end
    else if(!wait_peri && ALU_done && !FPU_pause) begin
        memins_rdata <= {memins_rdatacom2, memins_rdatacom1};
    end
end


wire    [ 3:0 ] memd_maskfn_mem;
wire            memd_lenfn_mem;
reg             insSTOREshift1;
reg             insLOADshift1;
reg             insSTOREshift2;
reg             insLOADshift2;
reg             insLOADshift3;

reg             FLWshift1 = 0;
reg             FLWshift2 = 0;
reg             FLWshift3 = 0;

assign          memd_maskfn_mem =   memd_mask & {4{memd_senable}} & {4{s0_sel_mem}} & {4{insSTORE||FSW}};
assign          memd_lenfn_mem  =   memd_lready & (insLOAD || FLW) & s0_sel_mem;

Data_memory #(
    //.MEM_FILE   ("C:/Users/PHONG/OneDrive - ptit.edu.vn/Desktop/FW RV32I/firmware/firmware.hex"),
//    .MEM_FILE   ("C:/firmware_data.hex"),
//    .MEM_FILE   ("D:/Gowin/firmware_data.hex"),
    .MEM_FILE   ("C:/Users/PHONG/OneDrive - ptit.edu.vn/Desktop/Project_I2C/firmware/build/firmware_data.hex"),
    .SIZE       (30750)
) data_mem(
    .clk        (clksys),
    .rst        (rst),
    .mem_addr   ({4'h0, mem_addr[27:0]}),
    .mem_ldata  (memd_ldata),
    .mem_sdata  (memd_sdatafn),    
    .mem_lenable(memd_lenfn_mem),
    .mem_mask   (memd_maskfn_mem)
);

wire            memf_lenfn_mem;
assign          memf_lenfn_mem  =   memd_lready & (insLOAD) & s1_sel_flash;
Flash_memory #(
    //.MEM_FILE   ("C:/Users/PHONG/OneDrive - ptit.edu.vn/Desktop/FW RV32I/firmware/firmware.hex"),
//    .MEM_FILE   ("C:/firmware_data.hex"),
//    .MEM_FILE   ("D:/Gowin/firmware_data.hex"),
    .MEM_FILE   ("C:/Users/PHONG/OneDrive - ptit.edu.vn/Desktop/Project_I2C/firmware/build/firmware_flash.hex"),
    .SIZE       (2580)
) flash_mem(
    .clk        (clksys),
    .rst        (rst),
    .mem_addr   ({4'h0, mem_addr[27:0]}),
    .mem_ldata  (memf_ldata),  
    .mem_lenable(memf_lenfn_mem)
);

wire    [31:0 ] mem_addrforl;
//load, store 8bit, 16bit or 32bit
wire    lsByte ;// =   (funct3[1:0] == 2'b00);
wire    lsHaftW;// =   (funct3[0]);
wire    lsWord ;// =   (funct3[1]);
wire    lsSign ;// =   (!funct3[2]);

wire    lsBytefn;
wire    lsHaftWfn;
wire    lsWordfn ;
wire    lsSignfn ;

reg     [ 2:0 ] funct3shift1;
reg     [ 2:0 ] funct3shift2;
reg     [31:0 ] mem_addrshift1;

    assign lsByte           =   (funct3[1:0] == 2'b00);
    assign lsHaftW          =   (funct3[0]);
    assign lsWord           =   (funct3[1]);
    assign lsSign           =   (!funct3[2]);

    assign lsBytefn =   (funct3shift1[1:0] == 2'b00);
    assign lsHaftWfn=   (funct3shift1[0]);
    assign lsWordfn =   (funct3shift1[1]);
    assign lsSignfn =   (!funct3shift1[2]);

    assign mem_addrforl     =   mem_addrshift1;


//gen mem_mask and make load data 8bit, 16bit or 32bit
assign          memd_mask   = 
                    lsWord  ?   4'b1111                         :
                    lsHaftW ?   (mem_addr[1]?4'b1100:4'b0011)  :
                    lsByte  ?   (mem_addr[1]?(mem_addr[0]?4'b1000:4'b0100):
                                              (mem_addr[0]?4'b0010:4'b0001)):
                    4'b0;

wire    [31:0]  byte_data;
wire    [31:0]  halfw_data;

assign byte_data = (mem_addrforl[1:0] == 2'b00) ? processor_data[7:0]   :
                   (mem_addrforl[1:0] == 2'b01) ? processor_data[15:8]  :
                   (mem_addrforl[1:0] == 2'b10) ? processor_data[23:16] :
                                                  processor_data[31:24] ;
assign halfw_data = mem_addrforl[1] ? processor_data[31:16] : processor_data[15:0];


wire    [31:0]  mem_ldmask;     //Mem load data(mask)

assign mem_ldmask = lsWordfn  ? processor_data :
                    lsHaftWfn ? (lsSignfn ? {{16{halfw_data[15]}}, halfw_data[15:0]} :
                                        {16'b0, halfw_data[15:0]}) :
                    lsBytefn  ? (lsSignfn ? {{24{byte_data[7]}}, byte_data[7:0]} :
                                        {24'b0, byte_data[7:0]}) :
                    32'b0;

/*---------------------------------------------------------
The Arithmetic Logic Unit performs integer operations such as addition, subtraction, bitwise logic, and shifts. 
It also supports comparison operations used for branch instructions, including signed and unsigned comparisons. 
The ALU receives two operands and an operation code, and outputs the result along with a branch condition cr if needed.
---------------------------------------------------------*/
wire    [31:0 ] result_ALU;
//wire            flag_branch;
wire    [31:0 ] data_rs1;
wire    [31:0 ] data_rs1fn;
wire    [31:0 ] data_rs2;   
wire    [31:0 ] data_rs2fn;
wire    [31:0 ] temphz;

//Hazard RAW
reg     [ 4:0 ] regrd_shifthz1  =   5'h00;          //Du lai rd 1 chu ki truoc de so sanh. Ph?c v? phát hi?n hazard 1 chu kì
reg     [ 4:0 ] regrd_shifthz2  =   5'h00;          //Du lai rd 2 chu ki truoc de so sanh. Ph?c v? phát hi?n hazard 2 chu kì
reg     [ 4:0 ] regrd_shifthz3  =   5'h00;          //Du lai rd 3 chu ki truoc de so sanh. Ph?c v? phát hi?n hazard 2 chu kì

reg     [ 4:0 ] regrs1_shifthz1 =   5'h00;          //Du lai rs1 1 chu ki truoc de so sanh. Ph?c v? phát hi?n hazard 1 chu kì
reg     [ 4:0 ] regrs1_shifthz2 =   5'h00;          //Du lai rs1 2 chu ki truoc de so sanh. Ph?c v? phát hi?n hazard 2 chu kì
reg     [ 4:0 ] regrs1_shifthz3 =   5'h00;          //Du lai rs1 3 chu ki truoc de so sanh. Ph?c v? phát hi?n hazard 2 chu kì

reg     [11:0 ] csr_addr_shift1 =   5'h00;         //Du lai csr_addr 1 chu ki truoc de so sanh. Ph?c v? phát hi?n hazard 1 chu kì
reg     [11:0 ] csr_addr_shift2 =   5'h00;         //Du lai csr_addr 2 chu ki truoc de so sanh. Ph?c v? phát hi?n hazard 2 chu kì
reg     [11:0 ] csr_addr_shift3 =   5'h00;         //Du lai csr_addr 3 chu ki truoc de so sanh. Ph?c v? phát hi?n hazard 2 chu kì


wire            isRAW_Hazardrs1_1cyc_forWB;    //phat hien hazard 1 chu kì
wire            isRAW_Hazardrs2_1cyc_forWB;    //phat hien hazard 1 chu kì
wire            isRAW_Hazardrs1_2cyc_forWB;    //phat hien hazard 2 chu kì
wire            isRAW_Hazardrs2_2cyc_forWB;    //phat hien hazard 2 chu kì
wire            isRAW_Hazardrs1_3cyc_forWB;    //phat hien hazard 2 chu kì
wire            isRAW_Hazardrs2_3cyc_forWB;    //phat hien hazard 2 chu kì


reg             en_rdhz1        =   VALUE_RESET;
reg             en_rdhz2        =   VALUE_RESET;
reg             en_rdhz3        =   VALUE_RESET;

reg             en_rs1hz1        =   VALUE_RESET;
reg             en_rs1hz2        =   VALUE_RESET;

//Result of ins
reg     [31:0 ] result;
wire    [31:0 ] resulthz_1cyc;
wire    [31:0 ] resulthz_2cyc;
wire    [31:0 ] resulthz_3cyc;

wire    [31:0 ] data_rs1hz_1cyc;
wire    [31:0 ] data_rs2hz_1cyc;
wire    [31:0 ] temprs2_hz;
wire    [31:0 ] temprs1_hz;

wire    [31:0 ] data_rs1hz_2cyc;
wire    [31:0 ] data_rs2hz_2cyc;

wire    [31:0 ] data_rs1hz_3cyc;
wire    [31:0 ] data_rs2hz_3cyc;

reg     [31:0 ] mem_ldmaskshift1    =   VALUE_RESET32; 
reg     [31:0 ] mem_ldmaskshift2    =   VALUE_RESET32; 

    assign temprs2_hz       =   (insALUImm)?Immediate:data_rs2;
    assign temprs1_hz       =   (insSYS)?((funct3[2])?regrs1:data_rs1):data_rs1;
    assign data_rs2hz_1cyc  =   (isRAW_Hazardrs2_1cyc_forWB)?((insLOADshift1 || FLWshift1)?mem_ldmask:resulthz_1cyc):
                                                               temprs2_hz;
    assign data_rs1hz_1cyc  =   (isRAW_Hazardrs1_1cyc_forWB)?((insLOADshift1 || FLWshift1)?mem_ldmask:resulthz_1cyc):
                                                               temprs1_hz;
    assign data_rs2hz_2cyc  =   (isRAW_Hazardrs2_2cyc_forWB)?((insLOADshift2 || FLWshift2)?mem_ldmaskshift1:resulthz_2cyc):
                                                               temprs2_hz;
    assign data_rs1hz_2cyc  =   (isRAW_Hazardrs1_2cyc_forWB)?((insLOADshift2 || FLWshift2)?mem_ldmaskshift1:resulthz_2cyc):
                                                               temprs1_hz;
    assign data_rs2hz_3cyc  =   (isRAW_Hazardrs2_3cyc_forWB)?((insLOADshift3 || FLWshift3)?mem_ldmaskshift2:resulthz_3cyc):
                                                               temprs2_hz;
    assign data_rs1hz_3cyc  =   (isRAW_Hazardrs1_3cyc_forWB)?((insLOADshift3 || FLWshift3)?mem_ldmaskshift2:resulthz_3cyc):
                                                               temprs1_hz;

    assign data_rs2fn       =   (isRAW_Hazardrs2_1cyc_forWB)?data_rs2hz_1cyc:
                                (isRAW_Hazardrs2_2cyc_forWB)?data_rs2hz_2cyc:
                                                             data_rs2hz_3cyc;
    assign data_rs1fn       =   (isRAW_Hazardrs1_1cyc_forWB)?data_rs1hz_1cyc:
                                (isRAW_Hazardrs1_2cyc_forWB)?data_rs1hz_2cyc:
                                                             data_rs1hz_3cyc;


wire    [31:0 ] csr_rdata;
ALU_unit ALU(
    .clk            (clksys),
    .isALUimm       (insALUImm),
    .isALUreg       (insALUReg),
    .isBranch       (insBRA),
    .isSYS          (insSYS),
    .isMEXT         (insMEXT),
    .funct3oh       (funct3oh),
    .funct3         (funct3),
    .funct7         (funct7),
    .rs1            (data_rs1fn),
    .rs2            (data_rs2fn),
    .csr_rdata      (csr_rdata),
    .result         (result_ALU),
    .correct        (flag_branch),
    .DecodeNotValid (DecodeNotValid_fn),
    .result_ready(ALU_done)
);



/*---------------------------------------------------------
This block contains 32 general-purpose 32-bit registers (x0-x31).
Register x0 is hardwired to zero and cannot be modified. The register file supports
two read ports and one write port, allowing simultaneous access to rs1, rs2, and rd
operands. It is used for storing intermediate and final results during instruction execution.
---------------------------------------------------------*/
wire    [31:0 ] data_desfn;
wire    [ 4:0 ] regrdfn;
//reg     [31:0 ] result;
reg     [31:0 ] data_des;
reg     [ 4:0 ] regrd_shiftpl   =   5'h00;
`ifdef FIVES_PIPELINE_EN
    assign data_desfn = data_des;
    assign regrdfn = regrd_shiftpl;
`endif


//wire    [31:0 ] data_rs1;
//wire    [31:0 ] data_rs2;
wire    [31:0 ] data_rs1pred;
wire    [ 4:0 ] regrs1pred;
reg             data_valid;

//wire    [31:0 ] csr_rdata;
reg             csr_we;
reg     [31:0 ] csr_wdata = VALUE_RESET32;


Registers_unit Regunit(
    .clk            (clksys), 
    .rst            (rst),

    .rs1            (regrs1),
    .rs1pred        (regrs1pred),
    .rs2            (regrs2),
    .rd             (regrdfn),
    .data_des       (data_desfn),
    .data_valid     (data_valid),
    .data_rs1       (data_rs1),
    .data_rs2       (data_rs2),
    .data_rs1pred   (data_rs1pred)
);


wire    [31:0 ] FPU_fdatars2;
wire    [31:0 ] FPU_fdatars1;
wire    [31:0 ] FPU_outputCVT;

reg     [31:0 ] dataCPU_Load;
reg             dataCPU_Lvalid;

wire            f_isEQ;
wire            f_isLT;
wire            f_isLE;
wire    [ 9:0 ] f_class;
FPU_unit    FPU_coprocessor(
    .clk            (clksys),
    .rst            (rst),
    .data_rs1       (data_rs1),
    .fregrs1        (regrs1),
    .fregrs2        (regrs2),
    .fregrs3        (regrs3),
    .fregrd         (regrd),
    .frs1_en        (en_frs1),
    .frs2_en        (en_frs2),
    .frs3_en        (en_frs3),
    .frd_en         (en_frd),
    .funct3oh       (funct3oh),
    .funct7         (funct7),
    .immediate      (Immediate),
    .FPU_en         (!wait_peri && ALU_done && !nop_busyf),
    .FSW_enperi     (1'b0),//!wait_peri),
    .FLW            (FLW),
    .FSW            (FSW),
    .FMADD          (FMADD),
    .FMSUB          (FMSUB),
    .FNMSUB         (FNMSUB),
    .FNMADD         (FNMADD),
    .FADD           (FADD),
    .FSUB           (FSUB),
    .FMUL           (FMUL),
    .FDIV           (FDIV),
    .FSQRT          (FSQRT),
    .FSGNJ          (FSGNJ),
    .FSGNJN         (FSGNJN),
    .FSGNJX         (FSGNJX),
    .FMIN           (FMIN),
    .FMAX           (FMAX),
    .FCVTWS         (FCVTWS),
    .FCVTWUS        (FCVTWUS),
    .FMVXW          (FMVXW),
    .FEQ            (FEQ),
    .FLT            (FLT),
    .FLE            (FLE),
    .FCLASS         (FCLASS),
    .FCVTSW         (FCVTSW),
    .FCVTSWU        (FCVTSWU),
    .FMVWX          (FMVWX),
    .DecodeNotValid (DecodeNotValid_fn),

    .dataCPU_rs1    (data_rs1fn),
    .dataCPU_Load   (dataCPU_Load),
    .dataCPU_Lvalid (dataCPU_Lvalid),

    .FPU_fdatars1   (FPU_fdatars1),
    .FPU_fdatars2   (FPU_fdatars2),
    .FPU_outputCVT  (FPU_outputCVT),
    .f_isEQ         (f_isEQ),
    .f_isLT         (f_isLT),
    .f_isLE         (f_isLE),
    .f_class        (f_class),

    .FPU_ready      (FPU_pause)
);




/*--------------------------------------------------------------------
This module implements a simplified RISC-V CSR unit for machine mode. It contains 
key machine CSRs such as mstatus, mie, mtvec, mepc, mcause, mtval, and mip, and
also supports counters like cycle, instret, and mtime. The unit updates counters
every clock cycle, allows CSR read/write through addresses, and automatically upd-
-ates trap-related CSRs (mepc, mcause, mtval) when a trap occurs. It provides a s-
-tandard interface for CPU core access to control, status, and performance monito-
-ring registers.
--------------------------------------------------------------------*/
reg     [11:0 ] csr_addrpl;
reg     [63:0 ] csr_instret     =   64'b0;
reg     [63:0 ] csr_real_mtime  =   64'd0;
reg     [ 7:0 ] cnt             =   8'b1;

reg             csr_trap_taken  = 1'b0;
reg     [31:0 ] csr_trap_pc     = 32'd0;
wire    [31:0 ] csr_trap_rpc;
wire    [31:0 ] csr_trap_addr;
reg     [31:0 ] csr_trap_cause  = 32'd0;
reg             UpdateMEPC      = 1'b0;
reg     [31:0 ] branch_pred_total   =   32'd0;
reg     [31:0 ] branch_pred_wrong   =   32'd0;

CSR_unit CSRreg(
    .clk            (clksys), 
    .rst            (rst),
    .csr_addrr      (csr_addr),
    .csr_addrw      (csr_addrpl),
    .csr_wdata      (csr_wdata),
    .csr_we         (csr_we),
    .csr_rdata      (csr_rdata),
    .csr_instret    (csr_instret),
    .real_mtime     (csr_real_mtime),    //tick

    .cntbra         (branch_pred_total),
    .cntwbra        (branch_pred_wrong),

    .trap_taken     (csr_trap_taken),
    .trap_complete  (insMRET),
    .updateMEPC     (UpdateMEPC),
    .trap_pc        (csr_trap_pc),
    .trap_rpc       (csr_trap_rpc),
    .trap_addr      (csr_trap_addr),
    .trap_cause     (csr_trap_cause),
    
    .irq_software   (1'b0),
    .irq_timer      (1'b0),
    .irq_external   (irq_external_pending),
    .global_ie      (irq_en)
    
);
assign trap_en = irq_en;

//Count time (1tick = 1us)
always @(posedge clksys) begin
    if(!rst) begin
        cnt <= 1;
        csr_real_mtime <= 64'b0;
    end
    else if(1) begin
        cnt <= cnt + 1;
        if(cnt == CLOCKSYS) begin
            cnt <= 1;
            csr_real_mtime <= csr_real_mtime + 1;
        end
    end
end


assign      peri_burst      =   3'b000;
assign      peri_htrans     =  ((peri_ren || peri_wen) && !s0_sel_mem && !s1_sel_flash)?2'b10:2'b00;
assign      peri_addr       =   mem_addr;
assign      peri_wdata      =   memd_sdata;
assign      peri_wmask      =   memd_mask;
assign      peri_wen        =   memd_senable && (insSTORE || FSW);
assign      peri_ren        =   memd_lready & (insLOAD || FLW);
wire        peri_trans_done =   (peri_ren && peri_rvalid) || (peri_wen && peri_wdone);




reg     [31:0 ] PC          =   INSTR_FIRST;    //The program counter (PC) is a 32-bit register that holds the address of the current instruction being executed. 
                                            //After each instruction, the PC is typically incremented by 4 to point to the next instruction. 
//reg     [31:0 ] PCnext  =   INSTR_FIRST;
reg     [ 4:0 ] state       =   5'b00001;
reg     [31:0 ] load_data;
wire            insALU      =   insALUImm || insALUReg;


/*------------------------------------------------------------------------------------------
--------------------------------------------------------
 This processor is organized into five pipeline stages:
    1. IF  (Instruction Fetch) : Fetch the instruction from instruction memory.
    2. ID  (Instruction Decode): Decode the instruction and read operands from registers.
    3. EX  (Execute)          : Perform ALU operations or compute branch targets.
    4. MEM (Memory Access)    : Access data memory for load/store instructions.
    5. WB  (Write Back)       : Write results back to the register file.

 Pipelined architecture enables instruction-level parallelism.
 Each instruction passes through these stages in successive clock cycles.
 After the pipeline is filled, one instruction is completed per clock cycle.

 -------------------------------------------------------------------------------
 EXCEPTIONS / HAZARDS (summary):
   - In general, data hazards are resolved by forwarding (bypassing) where possible,
     so most RAW cases (ALU ? ALU, EX?EX forwarding, MEM?EX when available) do not
     require pipeline bubbles.

   - JALR / indirect-jump hazards are special:
       * A JALR computes its next-PC from a register (rs1 + imm). That means the
         PC_next depends on the **value in rs1** rather than a PC-relative immediate.
       * If rs1 is produced by a prior instruction that is not yet available (e.g. a load),
         the pipeline **cannot** always forward the value early enough to compute PC_next
         at the usual pipeline point. Consequently a stall is required.

   - Stall policy (as used in this design):
       * If the implementation computes JALR's PC_next in the **ID stage (1-cycle JALR path)**:
           - A prior load ? JALR pair will require **2 cycles of stall** to wait for the load data
             to become valid before computing the JALR target.
       * If the implementation computes JALR's PC_next in the **EX stage (2-cycle JALR path)**:
           - A prior load ? JALR pair will require **1 cycle of stall** (because the load result
             can be forwarded from MEM into EX in time).
       * In all other normal data-dependency cases (ALU results, registers written earlier) the
         forwarding network supplies data so no extra stall is needed.

   - Control hazards (branches, jal) that use PC-relative immediates are easier:
       * For PC-relative JAL and conditional branches the target can be computed from the
         current PC and the immediate (no rs1) - these do not incur the same rs1-dependent
         JALR penalty. They still may suffer from misprediction flushes, which are handled
         by the branch control unit.
------------------------------------------------------------
-------------------------------------------------------------------------------------------*/
reg     IDen                    =   VALUE_RESET;
reg     EXen                    =   VALUE_RESET;
reg     MEMen                   =   VALUE_RESET;
reg     WBen                    =   VALUE_RESET;
reg     Fetchena                =   VALUE_RESET;    
reg     [31:0 ] PCBraoJum       =   VALUE_RESET32;
reg     [31:0 ] temp            =   VALUE_RESET32;

reg     [ 2:0 ] CntfMem         =   3'd0;           //counter for memory access
reg     [31:0 ] Store_datapl1   =   VALUE_RESET32;
reg     [31:0 ] Store_datapl2   =   VALUE_RESET32;

reg     [31:0 ] mem_addrup      =   VALUE_RESET32;  //??a ch? t?i tr??c 1 chu kì cho memory access
reg     [31:0 ] result_shiftpl  =   VALUE_RESET32;
reg     [31:0 ] result_shiftpl1 =   VALUE_RESET32;

reg     [31:0 ] dwb_csr         =   VALUE_RESET32;
reg     [31:0 ] dwb_csr_shiftpl =   VALUE_RESET32;
reg     [31:0 ] dwb_csr_shiftpl1=   VALUE_RESET32;

reg     [31:0 ] choose1_1       =   VALUE_RESET32;
reg     [31:0 ] choose1_2       =   VALUE_RESET32;
reg     [31:0 ] choose1_3       =   VALUE_RESET32;
reg     [31:0 ] choose2_1       =   VALUE_RESET32;
reg     [31:0 ] choose2_2       =   VALUE_RESET32;
reg     [31:0 ] choose2_3       =   VALUE_RESET32;

//reg             wrong_pred      =   VALUE_RESET;
//reg             wrong_predshift1=   VALUE_RESET;

reg     [ 1:0 ] predict_taken1  =   2'b00;
//reg             predict_taken2  =   VALUE_RESET;
reg     [ 1:0 ] predict_taken3  =   2'b00;


reg     [ 4:0 ] regrd_shiftpl1  =   5'h00;
reg     [ 4:0 ] regrd_shiftpl2  =   5'h00;
reg     [ 4:0 ] regrd_shiftpl3  =   5'h00;
//reg     [ 4:0 ] regrd_shiftpl   =   5'h00;

reg             insALUImmshift1, insALURegshift1, insLUIshift1,
                insAUIPCshift1, insJALshift1, insJALRshift1,
                insBRAshift1, //insLOADshift1, insSTOREshift1,
                insSYSshift1, insFENCEshift1, insMEXTshift1,
                FCVTWS_shift1, FCVTWUS_shift1, FMVXW_shift1,
                FLW_shift1, FCLASS_shift1, FEQ_shift1,
                FLT_shift1, FLE_shift1;
reg             insALUImmshift2, insALURegshift2, insLUIshift2,
                insAUIPCshift2, insJALshift2, insJALRshift2,
                insBRAshift2, //insLOADshift2, insSTOREshift2,
                insSYSshift2, insFENCEshift2, insMEXTshift2,
                FCVTWS_shift2, FCVTWUS_shift2, FMVXW_shift2,
                FLW_shift2, FCLASS_shift2, FEQ_shift2,
                FLT_shift2, FLE_shift2;
reg             DecodeNotValid_fn_shift1 = 0;
reg             DecodeNotValid_fn_shift2 = 0;

reg             holdplus_forDE        =   VALUE_RESET;  
reg             holdplus_forEX        =   VALUE_RESET;  
reg             holdplus_forMEM       =   VALUE_RESET; 
reg             holdplus_forWB        =   VALUE_RESET; 


//reg             insLOADshift3;

reg     [31:0 ] PCshift1        =   VALUE_RESET;

wire            isRAW_Hazardrs1_1cyc_forSTORE;  //Phat hien hazard 1 chu kì cho store
wire            isRAW_Hazardrs2_1cyc_forSTORE;  //Phat hien hazard 1 chu kì cho store
wire            isRAW_Hazardrs1_2cyc_forSTORE;  //Phat hien hazard 2 chu kì cho store
wire            isRAW_Hazardrs2_2cyc_forSTORE;  //Phat hien hazard 2 chu kì cho store
wire            isRAW_Hazardrs1_3cyc_forSTORE;  //Phat hien hazard 2 chu kì cho store
wire            isRAW_Hazardrs2_3cyc_forSTORE;  //Phat hien hazard 2 chu kì cho store

reg     [31:0 ] resultfast          =   VALUE_RESET32;

assign          wait_peri           =   !s0_sel_mem && !s1_sel_flash && (!peri_trans_done) && (insLOAD || insSTORE || FLW || FSW) && PC != 32'h0 && !wrong_pred && !wrong_predshift1;
reg             IRQ_UpdatePC        =   VALUE_RESET;    //C? báo hi?u chu?n b? Update PC do trap x?y ra
                                                        //S? d?ng ?? tránh tr??ng h?p v?a ng?t xong thì phát hi?n r? nhánh sai l?i nh?y ra kh?i ng?t
reg             IRQ_UpdatePCshift1  =   VALUE_RESET;
reg             IRQ_UpdatePCshift2  =   VALUE_RESET;
reg     [31:0 ] PCnext_actual_shift1=   VALUE_RESET32;
reg     [31:0 ] PCnext_candidate    =   VALUE_RESET32;
reg             mem_renablepredff   =   VALUE_RESET;

reg enUpdate_next = 0;
reg [31:0 ] result_next;
reg [31:0 ] dwb_csr_next = 0;


assign          wait_peri_as        =   wait_peri;
assign          mem_renablepred =   mem_renablepredff;
always @(*) begin
    mem_renablepredff = !wait_peri && ALU_done && !FPU_pause;
end

//X? lý hazard n?u d? li?u ph? thu?c không ??n t? l?nh load
    always @(posedge clksys) if(!wait_peri && ALU_done && !FPU_pause) Wrongpred_pause_ff <= Wrongpred_pause;////////////////////////////////////////////////ch? này m?i thêm !wait_peri && ALU_done && !FPU_pause
    assign isRAW_Hazardrs1_1cyc_forWB   =   (en_rdhz1&&en_rs1&&!Wrongpred_pause&&!CPUhazard_pause1)? (regrs1 == regrd_shifthz1)  &&
                                                                (regrd_shifthz1 != 5'h00) 
                                                                :1'b0; 
    assign isRAW_Hazardrs2_1cyc_forWB   =   (en_rdhz1&&en_rs2&&!Wrongpred_pause&&!CPUhazard_pause1)? (regrs2 == regrd_shifthz1)  &&
                                                                (regrd_shifthz1 != 5'h00)   
                                                                :1'b0;
    assign isRAW_Hazardrs1_2cyc_forWB   =   (en_rdhz2&&en_rs1&&!Wrongpred_pause&&!CPUhazard_pause2)? (regrs1 == regrd_shifthz2)  &&
                                                                (regrd_shifthz2 != 5'h00)   
                                                                :1'b0;
    assign isRAW_Hazardrs2_2cyc_forWB   =   (en_rdhz2&&en_rs2&&!Wrongpred_pause&&!CPUhazard_pause2)? (regrs2 == regrd_shifthz2)  &&
                                                                (regrd_shifthz2 != 5'h00)   
                                                                :1'b0;
    assign isRAW_Hazardrs1_3cyc_forWB   =   (en_rdhz3&&en_rs1&&!Wrongpred_pause&&!Wrongpred_pause_ff&&!CPUhazard_pause3)? (regrs1 == regrd_shifthz3)  &&
                                                                (regrd_shifthz3 != 5'h00)  
                                                                :1'b0; 
    assign isRAW_Hazardrs2_3cyc_forWB   =   (en_rdhz3&&en_rs2&&!Wrongpred_pause&&!Wrongpred_pause_ff&&!CPUhazard_pause3)? (regrs2 == regrd_shifthz3)  &&
                                                                (regrd_shifthz3 != 5'h00)
                                                                :1'b0; 


    assign isRAW_Hazardrs1_1cyc_forSTORE=   isRAW_Hazardrs1_1cyc_forWB;
    assign isRAW_Hazardrs2_1cyc_forSTORE=   isRAW_Hazardrs2_1cyc_forWB;
    assign isRAW_Hazardrs1_2cyc_forSTORE=   isRAW_Hazardrs1_2cyc_forWB;
    assign isRAW_Hazardrs2_2cyc_forSTORE=   isRAW_Hazardrs2_2cyc_forWB;
    assign isRAW_Hazardrs1_3cyc_forSTORE=   isRAW_Hazardrs1_3cyc_forWB;
    assign isRAW_Hazardrs2_3cyc_forSTORE=   isRAW_Hazardrs2_3cyc_forWB;


    assign resulthz_1cyc                =   result;
    assign resulthz_2cyc                =   result_shiftpl;
    assign resulthz_3cyc                =   result_shiftpl1;






/*-------------------------------------------------------------------------
This module implements a 2-bit bimodal branch predictor using a 256-entry table of saturating counters.
It predicts branch direction based on the most significant bit (MSB) of each counter. On each clock cy-
-cle, the predictor updates its state according to the actual branch outcome if update_en is high.
-------------------------------------------------------------------------*/
reg             update_BHT      =   VALUE_RESET;
reg             actual_taken    =   VALUE_RESET;
wire    [ 1:0 ] predict_taken;  
wire            insBRApred; 
reg     [31:0 ] pc_pred_in      =   VALUE_RESET32;
reg             enUpdate        =   VALUE_RESET;
wire    [31:0 ] Instruc_bpre    =   PCnext_fast;
reg     [ 1:0 ] predict_old     =   VALUE_RESET;
branch_predictor BRA_PRED(
    .clk             (clksys),
    .insBRA          (insBRApred),
    .pc_pred_in      (pc_pred_in),           //D? ?oán l?nh k? ti?p 
    .Instruc_bpre    (Instruc_bpre),
    .update_en       (update_BHT),    
    .actual_taken    (actual_taken),
    .take_en         (!wait_peri && ALU_done && !FPU_pause),
    .predict_taken   (predict_taken),   //0: not take, 1: take
    .predict_old     (predict_old)
);

/*-------------
Decoder for predictor
-------------*/
wire            insJALpred;
wire            insMRETpred;
//wire            insJALRpred;
wire    [ 4:0 ] regrdpred;
wire    [31:0 ] Immediatepred;
//wire            insFpausepred;
wire            insCEXTpred;
reg             insCEXTpred_shift1 = 0;
RV32_CoDecoder Decoder_for_pred(
    .instr_data         (memins_rdata_pred),
    .rst                (rst),
    .Immediate          (Immediatepred),
    .insJAL             (insJALpred),
    .insJALR            (insJALRpred),
    .insBRA             (insBRApred),
    .insMRET            (insMRETpred),
    .insFpause          (insFpausepred),
    .regrs1             (regrs1pred),
    .insCEXT            (insCEXTpred)
    //.regrd              (regrdpred)
);

//X? lý jalr sau d? ?oán r? nhánh sai
wire   pausebra_jalr;
assign pausebra_jalr = isInsertNop && (wrong_pred || (holdplus_forDE&&!IRQ_UpdatePCshift2));
always @(posedge clksys) begin
    if(!rst)                pausebra_jalr_ff1 <= 0;
    else begin
        if(pausebra_jalr)   pausebra_jalr_ff1 <= 1;
        if(!isInsertNop)    pausebra_jalr_ff1 <= 0;
    end
end
//always @(posedge clksys) begin
//    CPUhazard_pause1 <= DecodeNotValid_fn;
//    CPUhazard_pause2 <= DecodeNotValid_fn_ff;
//    CPUhazard_pause3 <= DecodeNotValid_fn_ff2;
//end
 

/*----------------------------------------------------------
    1. IF (Instruction Fetch): Fetches the instruction from instruction memory.
    2. ID (Instruction Decode): Decodes the instruction and reads operands from registers.
    3. EX (Execute): Performs ALU operations or computes branch targets.
    4. MEM (Memory Access): Accesses data memory for load/store instructions.
    5. WB (Write Back): Writes results back to the register file.
----------------------------------------------------------*/
//----------------------------FETCH---------------------------//

//B?t c? ng?t
reg irq_flagh = 0;
reg irq_active = 0;
    always @(posedge clksys) begin
        if(!rst) begin
            irq_flagh <= 1'b0;
        end
        else begin
            if(irq_flag) irq_flagh <= 1'b1;
            if(irq_active) irq_flagh <= 1'b0;
        end
    end

    always @(*) begin
            PCnext_candidate = PCnext + ((insCEXTpred)?2:4);
            (*parallel_case*)
            case(1'b1) 
                insJALpred: begin
                    PCnext_candidate = PCnext + Immediatepred;

                end
                insJALRpred: begin
                    PCnext_candidate = (data_rs1pred + Immediatepred) & ~32'h1;
                end
                insBRApred: begin
                    PCnext_candidate = (predict_taken[1])?PCnext + Immediatepred:PCnext+((insCEXTpred)?2:4);
                end
                default:;
            endcase
    end
    
    reg Pause_PCnextfast = 0;
    reg [31:0] PC_value_pause = 0;
    reg insBRApreds1 = 0;
    always @(*) begin
            PCnext_fast = PCnext_candidate;
            if(wrong_predfast) begin
                if (!IRQ_UpdatePC) PCnext_fast = PCnext_actual;
            end
            if(Pause_PCnextfast) PCnext_fast = PC_value_pause;
            
            if(irq_flagh && !irq_active && !insBRApred && !insBRApreds1 && !nop_forFpause && !nop_forJALR && !nop_busyf) PCnext_fast = csr_trap_addr; 
            if(insMRETpred) PCnext_fast = csr_trap_rpc;
    end
    always @(posedge clksys) begin
        if(!rst) Pause_PCnextfast <= 0;
        else begin
            if((nop_forJALR || nop_forFpause) && wrong_predfast) begin
                Pause_PCnextfast <= 1;
                PC_value_pause <= PCnext_actual;
            end
            if(Pause_PCnextfast && !(nop_forJALR || nop_forFpause)) Pause_PCnextfast <= 0;
        end
    end
    
    assign memins_addr = PCnext;
    assign memins_read = 1'b1;          //Luôn ??c
    always @(posedge clksys) begin
        if(!rst) begin 
            PC <= INSTR_FIRST;
            PCnext <= INSTR_FIRST;
            PCshift1 <= INSTR_FIRST;
            PCnext_actual <= INSTR_FIRST;
            PCnext_actual_shift1 <= INSTR_FIRST;
            Fetchena <= VALUE_RESET;
            pc_pred_in <= VALUE_RESET32;
            IDen <= 1;                      ///ch?nh ngày 12/12
            update_BHT <= VALUE_RESET;
            actual_taken <= VALUE_RESET;
            predict_taken1 <= VALUE_RESET32;
            predict_taken2 <= VALUE_RESET32;
            predict_taken3 <= VALUE_RESET32;
            IRQ_UpdatePC <= VALUE_RESET;
            UpdateMEPC <= VALUE_RESET;
            insCEXTpred_shift1 <= 0;
            
            choose1_1 <= VALUE_RESET32; choose1_2 <= VALUE_RESET32;
            choose2_1 <= VALUE_RESET32; choose2_2 <= VALUE_RESET32;
        end
        else if(!wait_peri && ALU_done && !FPU_pause) begin
            insBRApreds1 <= insBRApred;
            PCshift1 <= PC;
            if(!nop_forJALR && !nop_forFpause) begin
                PC <= PCnext;   
                PCnext <= PCnext_fast;
            end

            Fetchena <= 1'b1;
            
            PCnext_actual <= (predict_taken1[1])?choose2_1+((insCEXTpred_shift1)?2:4):choose1_1;
            PCnext_actual_shift1 <= PCnext_actual;
            update_BHT <= 1'b0;

            UpdateMEPC <= 1'b0;
            if(IRQ_UpdatePC) begin        //Update l?i mepc chính xác do r? nhánh sai.
                if(wrong_predfast) begin
                    csr_trap_pc <= PCnext_actual;
                    UpdateMEPC  <= 1'b1;
                end
                if(wrong_pred) begin
                    UpdateMEPC  <= 1'b1;
                    csr_trap_pc <= PCnext_actual_shift1;
                end
            end

            //Trap handler
            csr_trap_taken <= 1'b0;
            IRQ_UpdatePC <= 1'b0;
            IRQ_UpdatePCshift1 <= IRQ_UpdatePC;
            IRQ_UpdatePCshift2 <= IRQ_UpdatePCshift1;
            if(irq_flagh && !irq_active && !insBRApred && !insBRApreds1 && !nop_forFpause && !nop_forJALR && !nop_busyf) begin //N?u l?nh PCnext tr??c ?ó là branch s? không ng?t
                irq_active <= 1'b1;
                csr_trap_taken <= 1'b1;
                csr_trap_pc <= PCnext_candidate;
                csr_trap_cause <= 32'h8000000B;

                IRQ_UpdatePC <= 1'b1;
            end
            if(insMRETpred) begin
                irq_active <= 1'b0;
            end

            if(enUpdate) begin
                //Update BHT
                update_BHT <= 1'b1;
                predict_old <= predict_taken3;
                actual_taken <= (wrong_pred)?!predict_taken3[1]:predict_taken3[1];
                pc_pred_in <= choose2_3;                          //??a ch? l?nh branch
            end

            choose1_1 <= PCnext + Immediatepred;    choose1_2 <= choose1_1; choose1_3 <= choose1_2;
            choose2_1 <= PCnext;                    choose2_2 <= choose2_1; choose2_3 <= choose2_2;
    
            insCEXTpred_shift1 <= insCEXTpred;

            IDen <= 1'b1;
            predict_taken1 <= predict_taken;    
            predict_taken2 <= predict_taken1;
            predict_taken3 <= predict_taken2;
        end
    end


//----------------------------DECODE---------------------------//
//    reg        flag_nop = 0;
    reg [ 1:0] DecodeNotValid_cnt = 0;
    reg        Insertnop = 0;
    assign     DecodeNotValids = wrong_predfast || wrong_pred || (|DecodeNotValid_cnt);
    
    always @(posedge clksys) begin
        flag_nop <= (|nop_cnt) && !(&nop_cnt);
    end
    always @(*) begin
        Insertnop = 0;
        if(((|nop_cnt) && !(&nop_cnt)) || flag_nop) begin
                instr_data = 32'h00000013;
                Insertnop = 1;
        end
        else    instr_data = {memins_rdatacom2, memins_rdatacom1};                      
    end
    always @(posedge clksys) begin
        if(!rst) DecodeNotValid_cnt <= 0;
        else begin
            if(wrong_predfast) 
                if(Insertnop) DecodeNotValid_cnt <= 1;
            if(wrong_pred)
                if(Insertnop) DecodeNotValid_cnt <= 1;
            if((|DecodeNotValid_cnt) && !Insertnop) DecodeNotValid_cnt <= DecodeNotValid_cnt - 1;
        end
    end


    reg     EXen_shift1 = 0;
    always @(posedge clksys) begin// or negedge IDen) begin
        if (!rst || !IDen) begin
            EXen <= 1'b0; EXen_shift1 <= 0;
            Wrongpred_pause <= 0;
            funct3shift1 <= 3'h0;

            insALUImmshift1 <= 1'b0;    insALURegshift1 <= 1'b0;    insLUIshift1    <= 1'b0;
            insAUIPCshift1  <= 1'b0;    insJALshift1    <= 1'b0;    insJALRshift1   <= 1'b0;
            insBRAshift1    <= 1'b0;    insLOADshift1   <= 1'b0;    insSTOREshift1  <= 1'b0;
            insSYSshift1    <= 1'b0;    insFENCEshift1  <= 1'b0;    insMEXTshift1   <= 1'b0;
            FLWshift1       <= 1'b0;    

            insALUImmshift2 <= 1'b0;    insALURegshift2 <= 1'b0;    insLUIshift2    <= 1'b0;
            insAUIPCshift2  <= 1'b0;    insJALshift2    <= 1'b0;    insJALRshift2   <= 1'b0;
            insBRAshift2    <= 1'b0;    insLOADshift2   <= 1'b0;    insSTOREshift2  <= 1'b0;
            insSYSshift2    <= 1'b0;    insFENCEshift2  <= 1'b0;    insMEXTshift2   <= 1'b0;
            FLWshift2       <= 1'b0;

            DecodeNotValid_fn_shift1 <= 0;
            DecodeNotValid_fn_shift2 <= 0;

            insLOADshift3   <= 1'b0;
            FLWshift3       <= 1'b0;

            regrd_shiftpl1  <= 1'b0;    regrd_shiftpl2  <= 1'b0;    regrd_shiftpl3  <= 1'b0;
            regrd_shifthz1  <= 1'b0;    regrd_shifthz2  <= 1'b0;    regrd_shifthz3  <= 1'b0;
            en_rdhz1        <= 1'b0;    en_rdhz2        <= 1'b0;    en_rdhz3        <= 1'b0;

            isInsertNop_ff1 <= 0;
            isInsertNop_ff2 <= 0;
            isInsertNop_ff3 <= 0;

            CPUhazard_pause1 <= 0;
            CPUhazard_pause2 <= 0;
            CPUhazard_pause3 <= 0;

            holdplus_forDE <= VALUE_RESET;
        end
        else if(!wait_peri && ALU_done && !FPU_pause) begin
            //instr_data <= memins_rdata;
            EXen <= 1'b1;
            EXen_shift1 <= EXen;

            funct3shift1 <= funct3; 
            mem_addrshift1 <= mem_addr; 
            if(wrong_pred || holdplus_forDE) begin
                funct3shift1 <= funct3shift1;
                mem_addrshift1 <= mem_addrshift1;//m?i thêm 9/12
            end
        
         
            regrd_shifthz1 <= regrd;
            regrd_shifthz2 <= regrd_shifthz1;
            regrd_shifthz3 <= regrd_shifthz2;

            regrs1_shifthz1 <= regrs1;
            regrs1_shifthz2 <= regrs1_shifthz1;
            regrs1_shifthz3 <= regrs1_shifthz2;

            csr_addr_shift1 <= csr_addr;
            csr_addr_shift2 <= csr_addr_shift1;
            csr_addr_shift3 <= csr_addr_shift2;

            regrd_shiftpl1 <= regrd;            //L?u tr? 1 chu kì
            regrd_shiftpl2 <= regrd_shiftpl1;   //L?u tr? 2 chu kì
            regrd_shiftpl3 <= regrd_shiftpl2;   //L?u tr? 3 chu kì 


            en_rdhz1 <= en_rd;
            en_rdhz2 <= en_rdhz1;
            en_rdhz3 <= en_rdhz2;

            en_rs1hz1 <= en_rs1;
            en_rs1hz2 <= en_rs1hz1;

            // L?u tr? 1 chu k? 
            insALUImmshift1  <= insALUImm;      insALURegshift1  <= insALUReg;
            insLUIshift1     <= insLUI;         insAUIPCshift1   <= insAUIPC;
            insJALshift1     <= insJAL;         insJALRshift1    <= insJALR;
            insBRAshift1     <= insBRA;         insLOADshift1    <= insLOAD;
            insSTOREshift1   <= insSTORE;       insSYSshift1     <= insSYS;
            insFENCEshift1   <= insFENCE;       insMEXTshift1    <= insMEXT;
            FLWshift1        <= FLW;    

            FMVXW_shift1     <= FMVXW;          FCVTWUS_shift1   <= FCVTWUS;
            FCVTWS_shift1    <= FCVTWS;         FLW_shift1       <= FLW;
            FCLASS_shift1     <= FCLASS;        FEQ_shift1       <= FEQ;
            FLT_shift1       <= FLT;            FLE_shift1       <= FLE;
     

            // L?u tr? 2 chu k? 
            insALUImmshift2  <= insALUImmshift1;insALURegshift2  <= insALURegshift1;
            insLUIshift2     <= insLUIshift1;   insAUIPCshift2   <= insAUIPCshift1;
            insJALshift2     <= insJALshift1;   insJALRshift2    <= insJALRshift1;
            insBRAshift2     <= insBRAshift1;   insLOADshift2    <= insLOADshift1;
            insSTOREshift2   <= insSTOREshift1; insSYSshift2     <= insSYSshift1;
            insFENCEshift2   <= insFENCEshift1; insMEXTshift2    <= insMEXTshift1;
            FLWshift2        <= FLWshift1;
    
            FMVXW_shift2     <= FMVXW_shift1;   FCVTWUS_shift2   <= FCVTWUS_shift1;
            FCVTWS_shift2    <= FCVTWS_shift1;  FLW_shift2       <= FLW_shift1;
            FCLASS_shift2    <= FCLASS_shift1;  FEQ_shift2       <= FEQ_shift1;
            FLT_shift2       <= FLT_shift1;     FLE_shift2       <= FLE_shift1;

            DecodeNotValid_fn_shift1 <= DecodeNotValid_fn;
            DecodeNotValid_fn_shift2 <= DecodeNotValid_fn_shift1;

            //L?u tr? 3 chu kì
            insLOADshift3    <= insLOADshift2;
            FLWshift3        <= FLWshift2;  


            //Fix l?i jalr sau d? ?oán r? nhánh sai
            isInsertNop_ff1 <= isInsertNop;
            isInsertNop_ff2 <= isInsertNop_ff1;
            isInsertNop_ff3 <= isInsertNop_ff2;

            pausebra_jalr_ff2 <= pausebra_jalr_ff1;
            pausebra_jalr_ff3 <= pausebra_jalr_ff2;
            pausebra_jalr_ff4 <= pausebra_jalr_ff3;

            CPUhazard_pause1 <= DecodeNotValid_fn;
            CPUhazard_pause2 <= CPUhazard_pause1;
            CPUhazard_pause3 <= CPUhazard_pause2;

            holdplus_forDE <= 1'b0;
            Wrongpred_pause <= 0;
            if(wrong_pred || (holdplus_forDE&&!IRQ_UpdatePCshift2)) begin  //N?u phát hi?n d? ?oán sai -> không l?u các thanh ghi 2 l?nh k? ti?p tính t? branch.
                regrd_shifthz1 <= regrd_shifthz1;
                regrd_shifthz2 <= regrd_shifthz2;
                regrd_shifthz3 <= regrd_shifthz3;

                regrd_shiftpl1 <= regrd_shiftpl1;          
                regrd_shiftpl2 <= regrd_shiftpl2;  
                regrd_shiftpl3 <= regrd_shiftpl3; 

                regrs1_shifthz1 <= regrs1_shifthz1;
                regrs1_shifthz2 <= regrs1_shifthz2;
                regrs1_shifthz3 <= regrs1_shifthz3;

                csr_addr_shift1 <= csr_addr_shift1;
                csr_addr_shift2 <= csr_addr_shift2;
                csr_addr_shift3 <= csr_addr_shift3;

                pausebra_jalr_ff2 <= pausebra_jalr_ff2;
                pausebra_jalr_ff3 <= pausebra_jalr_ff3;
                pausebra_jalr_ff4 <= pausebra_jalr_ff4;

                en_rdhz1 <= en_rdhz1;
                en_rdhz2 <= en_rdhz2;
                en_rdhz3 <= en_rdhz3;

//                CPUhazard_pause1 <= CPUhazard_pause1;
//                CPUhazard_pause2 <= CPUhazard_pause2;
//                CPUhazard_pause3 <= CPUhazard_pause3;

                en_rs1hz1 <= en_rs1hz1;
                en_rs1hz2 <= en_rs1hz2;

                // L?u tr? 1 chu k? (gi? nguyên chính nó)
                insALUImmshift1  <= insALUImmshift1;
                insALURegshift1  <= insALURegshift1;
                insLUIshift1     <= insLUIshift1;
                insAUIPCshift1   <= insAUIPCshift1;
                insJALshift1     <= insJALshift1;
                insJALRshift1    <= insJALRshift1;
                insBRAshift1     <= insBRAshift1;
                insLOADshift1    <= insLOADshift1;
                insSTOREshift1   <= insSTOREshift1;
                insSYSshift1     <= insSYSshift1;
                insFENCEshift1   <= insFENCEshift1;
                funct3shift1     <= funct3shift1;
                insMEXTshift1    <= insMEXTshift1;
                FLWshift1        <= FLWshift1;

                FCVTWS_shift1    <= FCVTWS_shift1;
                FCVTWUS_shift1   <= FCVTWUS_shift1;
                FMVXW_shift1     <= FMVXW_shift1;
                FLW_shift1       <= FLW_shift1;
                FCLASS_shift1    <= FCLASS_shift1;
                FEQ_shift1       <= FEQ_shift1;
                FLT_shift1       <= FLT_shift1;
                FLE_shift1       <= FLE_shift1;

                // L?u tr? 2 chu k? (gi? nguyên chính nó)
                insALUImmshift2  <= insALUImmshift2;
                insALURegshift2  <= insALURegshift2;
                insLUIshift2     <= insLUIshift2;
                insAUIPCshift2   <= insAUIPCshift2;
                insJALshift2     <= insJALshift2;
                insJALRshift2    <= insJALRshift2;
                insBRAshift2     <= insBRAshift2;
                insLOADshift2    <= insLOADshift2;
                insSTOREshift2   <= insSTOREshift2;
                insSYSshift2     <= insSYSshift2;
                insFENCEshift2   <= insFENCEshift2;
                insMEXTshift2    <= insMEXTshift2;
                FLWshift2        <= FLWshift2;

                DecodeNotValid_fn_shift1 <= DecodeNotValid_fn_shift1;
                DecodeNotValid_fn_shift2 <= DecodeNotValid_fn_shift2;

                FCVTWS_shift2    <= FCVTWS_shift2;
                FCVTWUS_shift2   <= FCVTWUS_shift2;
                FMVXW_shift2     <= FMVXW_shift2;
                FLW_shift2       <= FLW_shift2;
                FCLASS_shift2    <= FCLASS_shift2;
                FEQ_shift2       <= FEQ_shift2;
                FLT_shift2       <= FLT_shift2;
                FLE_shift2       <= FLE_shift2;
                
                Wrongpred_pause <= 1;               //C? báo hi?u 2 l?nh k? ti?p r? nhánh ko ki?m tra hazard

                // L?u tr? 3 chu k? (gi? nguyên chính nó)
                insLOADshift3    <= insLOADshift3;
                FLWshift3        <= FLWshift3;
                
                if(wrong_pred) holdplus_forDE <= 1'b1;
            end  

            if(wrong_predfast && !IRQ_UpdatePC) begin
                EXen <= 1'b0;                                       //L?p l?i pipeline, xóa k?t qu? c?
            end 
        end
        else if (!FPU_pause) begin

        end
    end


//----------------------------EXECUTE---------------------------//
    always @(*) begin//-> giúp load và store s?m h?n 1 chu kì
            mem_addr = VALUE_RESET32;
            memd_sdata = VALUE_RESET32;
            memd_lready = VALUE_RESET;
            memd_senable = VALUE_RESET;
            (*parallel_case*)
            case(1'b1)
                DecodeNotValid_fn: begin
                    memd_lready = 1'b0;
                    memd_senable = 1'b0;
                end
                insLOAD || FLW: begin
                    mem_addr =      (isRAW_Hazardrs1_1cyc_forSTORE)?((insLOADshift1 || FLWshift1)?mem_ldmask + Immediate:result + Immediate)                 :    //X? lý c? hazard c?a store n?u tr??c ?ó là l?nh load
                                    (isRAW_Hazardrs1_2cyc_forSTORE)?((insLOADshift2 || FLWshift2)?mem_ldmaskshift1 + Immediate:result_shiftpl + Immediate)   :
                                    (isRAW_Hazardrs1_3cyc_forSTORE)?((insLOADshift3 || FLWshift3)?mem_ldmaskshift2 + Immediate:result_shiftpl1 + Immediate)  :
                                                                      data_rs1 + Immediate;
                    memd_lready = 1'b1 && !wrong_pred && !wrong_predshift1;
                end
                insSTORE || FSW: begin
                    mem_addr =      (isRAW_Hazardrs1_1cyc_forSTORE)?((insLOADshift1 || FLWshift1)?mem_ldmask + Immediate:result + Immediate)                 :    //X? lý c? hazard c?a store n?u tr??c ?ó là l?nh load
                                    (isRAW_Hazardrs1_2cyc_forSTORE)?((insLOADshift2 || FLWshift2)?mem_ldmaskshift1 + Immediate:result_shiftpl + Immediate)   :
                                    (isRAW_Hazardrs1_3cyc_forSTORE)?((insLOADshift3 || FLWshift3)?mem_ldmaskshift2 + Immediate:result_shiftpl1 + Immediate)  :
                                                                     data_rs1 + Immediate;
                    memd_sdata =    (isRAW_Hazardrs2_1cyc_forSTORE)?((insLOADshift1 || FLWshift1)?mem_ldmask:result)                 :
                                    (isRAW_Hazardrs2_2cyc_forSTORE)?((insLOADshift2 || FLWshift2)?mem_ldmaskshift1:result_shiftpl)   :
                                    (isRAW_Hazardrs2_3cyc_forSTORE)?((insLOADshift3 || FLWshift3)?mem_ldmaskshift2:result_shiftpl1)  :
                                                                     (FSW)?FPU_fdatars2:data_rs2;
                    memd_senable = 1'b1 && !wrong_pred && !wrong_predshift1;
                end
                default: begin
                    memd_lready = 1'b0;
                    memd_senable = 1'b0;
                end
            endcase
    end

//    reg enUpdate_next = 0;
//    reg [31:0 ] result_next;
//    reg [31:0 ] dwb_csr_next = 0;
    always @(*) begin
        //Tính result_next b?ng logic t? h?p. Tính ??a ch? tr? v? khi g?p l?nh JALR 
        result_next = result;
        enUpdate_next = enUpdate;
        dwb_csr_next = dwb_csr;
        (*parallel_case*)
        case(1'b1)
            insBRA: begin
                enUpdate_next = 1'b1;
            end
            insALU | insMEXT: begin
                result_next = result_ALU;
            end
            insLUI: begin
                result_next = Immediate;
            end
            insAUIPC: begin 
                result_next = PCshift1 + Immediate;
            end
            insJAL: begin
                result_next = PCshift1 + ((insCEXT)?2:4);                 
                //PCnext <= PCshift1 + Immediate;         //was predicted
            end
            insJALR: begin
                result_next = PCshift1 + ((insCEXT)?2:4);               
                //PCnext <= data_rs1 + Immediate;   //was predicted
            end
            insSYS: begin
                result_next = csr_rdata;
                dwb_csr_next = result_ALU;
            end
            FMVXW: begin
                result_next = FPU_fdatars1;
            end
            FCVTWS || FCVTWUS: begin
                result_next = FPU_outputCVT;
            end
            FCLASS: begin
                result_next = {22'd0, f_class};
            end
            FEQ: begin
                result_next = {31'd0, f_isEQ};
            end
            FLT: begin
                result_next = {31'd0, f_isLT};
            end
            FLE: begin
                result_next = {31'd0, f_isLE};
            end
        endcase
    end

    always @(posedge clksys) begin
        if(!rst) begin
            wrong_predshift1 <= VALUE_RESET;
        end
        else if(!wait_peri && ALU_done && !FPU_pause) begin////////////////////////////////////////////m?i thêm !wait_peri && ALU_done && !FPU_pause
            wrong_predshift1 <= wrong_pred;
        end
    end

    always @(posedge clksys) begin// or negedge EXen) begin
        if(!rst || !EXen) begin
            MEMen <= 1'b0;
            wrong_pred <= VALUE_RESET;
            PCBraoJum <= VALUE_RESET;
            mem_addrup <= VALUE_RESET32;
            result <= VALUE_RESET32;
            holdplus_forEX <= VALUE_RESET;
        end
        else if(!wait_peri && ALU_done && !FPU_pause) begin
            wrong_pred <= wrong_predfast; enUpdate <= 1'b0;

            enUpdate <= enUpdate_next;
            result <= result_next;
            dwb_csr <= dwb_csr_next;

            result_shiftpl <= result;
            result_shiftpl1 <= result_shiftpl;

            dwb_csr_shiftpl <= dwb_csr;
            dwb_csr_shiftpl1 <= dwb_csr_shiftpl;

            holdplus_forEX <= 1'b0;
            if((wrong_pred || (holdplus_forEX&&!IRQ_UpdatePCshift2))) begin  //N?u phát hi?n d? ?oán sai -> d? l?i k?t qu? c? 2 chu kì n?a
                result_shiftpl <= result_shiftpl;
                result_shiftpl1 <= result_shiftpl1;

                dwb_csr_shiftpl <= dwb_csr_shiftpl;
                dwb_csr_shiftpl1 <= dwb_csr_shiftpl1;
                if(wrong_pred) holdplus_forEX <= 1'b1;
            end 

            MEMen <= 1'b1;
            if(wrong_predfast && !IRQ_UpdatePC) begin
                MEMen <= 1'b0;
            end
        end
    end


//----------------------------MEMORY ACCESS---------------------------//
    reg     [31:0 ] dataCPU_Load_com   = 0;
    always @(posedge clksys) begin
        if(!rst || !MEMen) begin
            WBen <= VALUE_RESET;
            holdplus_forMEM <= VALUE_RESET;

        end
        else if(!wait_peri && ALU_done && !FPU_pause) begin //FLW không bao gi? b? ph? thu?c d? li?u vào l?nh tr??c (ch? tính freg)                
            mem_ldmaskshift1 <= mem_ldmask;
            mem_ldmaskshift2 <= mem_ldmaskshift1;
            dataCPU_Load_com <= mem_ldmask;

            holdplus_forMEM <= 1'b0;
            if(wrong_pred || holdplus_forMEM) begin  //N?u phát hi?n d? ?oán sai -> d? l?i kêt qu? c? 2 chu kì n?a
                mem_ldmaskshift1 <= mem_ldmaskshift1;
                mem_ldmaskshift2 <= mem_ldmaskshift2;
                if(wrong_pred) holdplus_forMEM <= 1'b1;
            end 

            WBen <= 1'b1;
        end
        else dataCPU_Load_com <= mem_ldmask;
    end

    always @(posedge clksys) begin
        if(!rst) begin
            csr_instret <= 0;
        end
        else if(!wait_peri && ALU_done) begin
            csr_instret <= csr_instret + 1;
            if(wrong_pred || holdplus_forMEM) begin
                csr_instret <= csr_instret;
            end
        end
    end


//----------------------------WRITE BACK---------------------------//
    always @(posedge clksys) begin//s? d?ng giá tr? c? c?a WBen
        if(!rst)begin  //cho phep ghi n?t l?nh tr??c
            data_des <= VALUE_RESET32;
            regrd_shiftpl <= 5'h00;
            data_valid <= VALUE_RESET;
            nop_cnt <= 3'b111;
            nop_done <= 0;
            nop_busy <= 0;
        end
        else if(!WBen) begin
            data_des <= VALUE_RESET32;
            regrd_shiftpl <= 5'h00;
            data_valid <= VALUE_RESET;
            if(insJALRpred || insFpausepred) begin
                if(!nop_busy) begin
                    nop_cnt <= 4;//for JALR
                    if(insFpausepred) nop_cnt <= 2;
                    nop_busy <= 1;
                end
            end
        end
        else if((!wait_peri && ALU_done && !FPU_pause)) begin//MEMen||
            case(1'b1)
                DecodeNotValid_fn_shift2: begin
                    data_valid <= 1'b0;
                    dataCPU_Lvalid <= 0;
                end
                insLOADshift2: begin
                    data_des <= mem_ldmaskshift1;
                    regrd_shiftpl <= regrd_shiftpl2;
                    data_valid <= 1'b1;
//                    $display("LOAD WB: data=%h -> x%0d", mem_ldmaskshift1, regrd_shiftpl2);
                end
                FLW_shift2: begin
                    dataCPU_Load <= dataCPU_Load_com;
                    dataCPU_Lvalid <= 1;
//                    $display("FLOAD WB: data=%h -> x%0d", mem_ldmaskshift1, regrd_shiftpl2);
                end
                insALUImmshift2 | insALURegshift2 | insLUIshift2 | 
                insAUIPCshift2  | insJALshift2    | insJALRshift2|
                insMEXTshift2   | FMVXW_shift2    | FCVTWUS_shift2|
                FCVTWS_shift2   | FCLASS_shift2   | FEQ_shift2   |
                FLT_shift2      | FLE_shift2    : begin
                    data_des <= result_shiftpl;
                    regrd_shiftpl <= regrd_shiftpl2;
                    data_valid <= 1'b1;
//                    $display("ALU WB: result=%h -> x%0d", result_shiftpl, regrd_shiftpl2);
                end
                insSYSshift2: begin
                    data_des <= result_shiftpl;
                    regrd_shiftpl <= regrd_shiftpl2;
                    data_valid <= 1'b1;

                    csr_addrpl <= csr_addr_shift2;
                    csr_we <= !(regrs1_shifthz2 == 5'h00 && en_rs1hz2);
                    csr_wdata <= dwb_csr_shiftpl;
//                    $display("SYS WB: csr_wdata=%h -> csr%0d", csr_wdata, csr_addrpl);
                end
                default:begin
                    data_valid <= 1'b0;
                    dataCPU_Lvalid <= 0;
                    csr_we <= 1'b0;
                end
            endcase



            //??p s? chu kì nop
            if(insJALRpred || insFpausepred) begin
                if(!nop_busy) begin
                    nop_cnt <= 4;//for JALR
                    if(insFpausepred) nop_cnt <= 4;
                    nop_busy <= 1;
                end
                else begin
                    nop_cnt <= nop_cnt - 1;
                    if(nop_cnt == 0) begin
                        nop_cnt <= 3'b111;
                        nop_done <= 1;
                        nop_busy <= 0;
                    end
                end
            end
        end
        else begin
            dataCPU_Load <= dataCPU_Load_com;
            dataCPU_Lvalid <= 1;
        end
    end


`ifdef DEBUG_EN

reg             wrong_pred_pre      =   1'b0;

always @(posedge clksys) begin
    if(!rst) begin
        branch_pred_total <= 32'd0;
        branch_pred_wrong <= 32'd0;
        wrong_pred_pre    <= 1'b0;
    end
    else begin
        wrong_pred_pre <= wrong_pred;
        if(PCshift1 != PC && insBRA) branch_pred_total <= branch_pred_total + 1;
        if(!wrong_pred_pre && wrong_pred) branch_pred_wrong <= branch_pred_wrong + 1;
    end
end

`endif


endmodule
module FPU_unit(
    input   wire            clk,
    input   wire            rst,

    input   wire    [31:0 ] data_rs1,

    input   wire    [ 4:0 ] fregrs1,
    input   wire    [ 4:0 ] fregrs2,
    input   wire    [ 4:0 ] fregrs3,
    input   wire    [ 4:0 ] fregrd,
    
    input   wire            frs1_en,
    input   wire            frs2_en,
    input   wire            frs3_en,
    input   wire            frd_en,

    input   wire    [ 7:0 ] funct3oh,
    input   wire    [ 6:0 ] funct7,
    input   wire    [31:0 ] immediate,
    input   wire            FPU_en,
    input   wire            FSW_enperi,

    input   wire            FLW,
    input   wire            FSW,
    input   wire            FMADD,
    input   wire            FMSUB,
    input   wire            FNMSUB,
    input   wire            FNMADD,

    input   wire            FADD,
    input   wire            FSUB,
    input   wire            FMUL,
    input   wire            FDIV,
    input   wire            FSQRT,
    input   wire            FSGNJ,
    input   wire            FSGNJN,
    input   wire            FSGNJX,
    input   wire            FMIN,
    input   wire            FMAX,
    input   wire            FCVTWS,
    input   wire            FCVTWUS,
    input   wire            FMVXW,
    input   wire            FEQ,
    input   wire            FLT,
    input   wire            FLE,
    input   wire            FCLASS,
    input   wire            FCVTSW,
    input   wire            FCVTSWU,
    input   wire            FMVWX,
    input   wire            DecodeNotValid,

    input   wire            RNEfcsr, RNErm, //Round to Nearest, ties to Even (Làm tròn đến giá trị gần nhất, nếu nằm giữa chọn số có bít cuối là chẵn)
    input   wire            RTZfcsr, RTZrm, //Round towards Zero (Cắt bỏ phần thập phân)
    input   wire            RDNfcsr, RDNrm, //Round Down (towards -vc) (Làm tròn xuống)
    input   wire            RUPfcsr, RUPrm, //Round Up (towards +vc) (Làm tròn lên)
    input   wire            RMMfcsr, RMMrm, //RMM - Round to Nearest, ties to Max Magnitude (Làm tròn đến giá trị gần nhất, nếu giữa 2 số chọn số có trị tuyệt đối lớn nhất)
    input   wire            DYNrm,          //In instruction’s rm field, selects dynamic rounding mode; In Rounding Mode register, reserved. 

    output  wire            NXpulse,
    output  wire            UFpulse,
    output  wire            OFpulse,
    output  wire            DZpulse,
    output  wire            NVpulse,

    output  wire            FPU_ready,      //FPU yêu cầu dừng
     
    input   wire    [31:0 ] dataCPU_rs1,    //input for cvt, mv
    input   wire    [31:0 ] dataCPU_Load,   //input for load 
    input   wire            dataCPU_Lvalid,

    output  wire    [31:0 ] FPU_fdatars2,   //output for store
    output  wire    [31:0 ] FPU_fdatars1,   //output for mv
    output  wire    [31:0 ] FPU_outputCVT,  //output for result cvt
    output  wire            f_isEQ,         //output for FEQ
    output  wire            f_isLT,         //output for FLT
    output  wire            f_isLE,         //output for FLE
    output  wire    [ 9:0 ] f_class         //output for FCLASS
);
    localparam  ALI1    =   0;  //Align1
    localparam  ALI2    =   1;  //Align2
    localparam  OPE     =   2;  //Operation
    localparam  NOR1    =   3;  //Normalize1
    localparam  NOR2    =   4;  //Normalize2
    localparam  RAW     =   5;  //Round and write back

    localparam  SALI1   =   6'b000001   <<  ALI1;
    localparam  SALI2   =   6'b000001   <<  ALI2;
    localparam  SOPE    =   6'b000001   <<  OPE;
    localparam  SNOR1   =   6'b000001   <<  NOR1;
    localparam  SNOR2   =   6'b000001   <<  NOR2;
    localparam  SRAW    =   6'b000001   <<  RAW;

    reg     [ 5:0 ] state       =   0;
    reg     [ 5:0 ] state_next  =   0;


    wire    [31:0 ] fdata_rs1, fdata_rs2, fdata_rs3;
    reg     [31:0 ] fdata_des = 0;
    reg             fdata_valid = 0;

    wire            iseq, isless;
    wire            cmp_done;

    reg             ALI1en  =   0;
    reg             ALI2en  =   0;
    reg             OPE1en  =   0;
    reg             OPE2en  =   0;
    reg             NOR1en  =   0;
    reg             NOR2en  =   0;
    reg             RAW1en  =   0;



    reg     [31:0 ] fw_data     =   32'd0;
    reg             fw_valid    =   1'b0;
    reg     [ 4:0 ] fregrd_plwb = 0;

    wire    [31:0 ] fw_datafn;
    wire            fw_validfn;
    wire    [ 4:0 ] fregrd_fn;
    FRegisters_unit Freg_unit(
        .clk        (clk),
        .rst        (rst),
    
        .frs1       (fregrs1),
        .fdata_rs1  (fdata_rs1),

        .frs2       (fregrs2),
        .fdata_rs2  (fdata_rs2),

        .frs3       (fregrs3),
        .fdata_rs3  (fdata_rs3),

        .frd        (fregrd_fn),
        .fdata_des  (fw_datafn),
        .fdata_valid(fw_validfn)        
    );

    reg     [26:0 ] mulinA_ope1;
    reg     [ 2:0 ] mulinB_ope1;
    reg     [ 2:0 ] mulinC_ope1;
    reg     [ 2:0 ] mulinD_ope1;   
    reg     [ 2:0 ] mulinE_ope1;
    reg     [ 2:0 ] mulinF_ope1;
    reg     [ 2:0 ] mulinG_ope1;
    reg     [ 2:0 ] mulinH_ope1; 

    wire signed [55:0 ] res_on_ope1;
    wire signed [55:0 ] res_tw_ope1;
    wire signed [55:0 ] res_th_ope1;
    wire signed [55:0 ] res_fo_ope1;
    wire signed [55:0 ] res_fi_ope1;
    wire signed [55:0 ] res_si_ope1;
    wire signed [55:0 ] res_se_ope1;

    reg     [26:0 ] mulinA_ope2;
    reg     [ 2:0 ] mulinB_ope2;
    reg     [ 2:0 ] mulinC_ope2;
    reg     [ 2:0 ] mulinD_ope2;   
    reg     [ 2:0 ] mulinE_ope2;
    reg     [ 2:0 ] mulinF_ope2;
    reg     [ 2:0 ] mulinG_ope2;
    reg     [ 2:0 ] mulinH_ope2; 

    wire signed [55:0 ] res_on_ope2;
    wire signed [55:0 ] res_tw_ope2;
    wire signed [55:0 ] res_th_ope2;
    wire signed [55:0 ] res_fo_ope2;
    wire signed [55:0 ] res_fi_ope2;
    wire signed [55:0 ] res_si_ope2;
    wire signed [55:0 ] res_se_ope2;

    mul_tiny multiny(   
        .clk        (clk),

        .inA        ({1'b0, mulinA_ope1}),

        .inB        (mulinB_ope1),
        .inC        (mulinC_ope1),
        .inD        (mulinD_ope1),
        .inE        (mulinE_ope1),
        .inF        (mulinF_ope1),
        .inG        (mulinG_ope1),
        .inH        (mulinH_ope1),

        .res_on     (res_on_ope1),
        .res_tw     (res_tw_ope1),
        .res_th     (res_th_ope1),
        .res_fo     (res_fo_ope1),
        .res_fi     (res_fi_ope1),
        .res_si     (res_si_ope1),
        .res_se     (res_se_ope1)
    );

    mul_tiny multiny2(   
        .clk        (clk),

        .inA        ({1'b0, mulinA_ope2}),

        .inB        (mulinB_ope2),
        .inC        (mulinC_ope2),
        .inD        (mulinD_ope2),
        .inE        (mulinE_ope2),
        .inF        (mulinF_ope2),
        .inG        (mulinG_ope2),
        .inH        (mulinH_ope2),

        .res_on     (res_on_ope2),
        .res_tw     (res_tw_ope2),
        .res_th     (res_th_ope2),
        .res_fo     (res_fo_ope2),
        .res_fi     (res_fi_ope2),
        .res_si     (res_si_ope2),
        .res_se     (res_se_ope2)
    );

//---------------------------------------------------------------------------------------------------------//
//------------------------------------------FPU mode1 - Pipeline-------------------------------------------//
//---------------------------------------------------------------------------------------------------------//
/*
In FPU Mode 1, instructions are executed using a pipelined architecture. The pipeline processes each instruction
through seven stages:
Prepare – the instruction and operands are fetched and prepared for execution.

    Align – operands are aligned to ensure correct positioning for the arithmetic operation.
    Operation 1 – the first phase of the arithmetic computation is performed.
    Operation 2 – the second phase of computation, often handling intermediate results.
    Normalize 1 – the result is normalized to fit the standard floating-point format.
    Normalize 2 – further normalization to correct any remaining deviations.
    Round and Write-back (WB) – the result is rounded according to the selected rounding mode and written back to the destination register.

This 7-stage pipeline allows multiple instructions to be processed simultaneously, improving throughput while maintaining correct execution order.
*/

//--------------------------------------------HANDLE HAZARD------------------------------------------------//
    wire            hazard_1cyc;
    wire            hazard_2cyc;
    wire            hazard_3cyc;
    wire            hazard_4cyc;
    wire            hazard_5cyc;
    wire            hazard_6cyc;
    wire            hazard_7cyc;
//    wire            hazard_8cyc =   (fregrd_pre == fregrs1 && frs1_en) || (fregrd_pre == fregrs2 && frs2_en) || (fregrd_pre == fregrs3 && frs3_en);

    reg     [ 3:0 ] pause_cnt   =   0;


//------------------------------------------UNPACK AND PREPARE---------------------------------------------//
    wire        FPU_ready_pre_h;
    reg         FPU_ready_pre   = 1;

    reg         signfrs1     = 0;
    reg [ 7:0 ] exponentfrs1 = 0;
    reg [26:0 ] mantissafrs1 = 0;// 3 bit GRS (guard–round–sticky)
    reg         signfrs2     = 0;
    reg [ 7:0 ] exponentfrs2 = 0;
    reg [26:0 ] mantissafrs2 = 0;
    reg         signfrs3     = 0;
    reg [ 7:0 ] exponentfrs3 = 0;
    reg [26:0 ] mantissafrs3 = 0;
    reg [31:0 ] datafrs1_pre = 0;

    reg [ 4:0 ] fregrs1_pre  = 0;
    reg [ 4:0 ] fregrs2_pre  = 0;
    reg [ 4:0 ] fregrs3_pre  = 0;   
    reg [ 4:0 ] fregrd_pre   = 0;
    reg         frd_en_pre   = 0;

    reg         frs1isSNaN_pre  = 0;//Cờ báo not a number                       //QNaN: sign = 0, exp = ff, man[22] = 1//SNaN: sign = 0, exp = ff, man[22] = 0
    reg         frs2isSNaN_pre  = 0;
    reg         frs3isSNaN_pre  = 0;
    reg         frs1isQNaN_pre  = 0;
    reg         frs2isQNaN_pre  = 0;
    reg         frs3isQNaN_pre  = 0;
    reg         frs1isNaN_pre   = 0;
    reg         frs2isNaN_pre   = 0;
    reg         frs3isNaN_pre   = 0;
    reg         frs1isInf_pre   = 0;//Cờ báo vô cùng                            //Exp = ff, Man = 0, dấu tùy
    reg         frs2isInf_pre   = 0;
    reg         frs3isInf_pre   = 0;
    reg         frs1isSub_pre   = 0;//Cờ báo subnormal number - số vô cùng bé   //Exp = 0, dạng 0.F
    reg         frs2isSub_pre   = 0;
    reg         frs3isSub_pre   = 0;
    reg         frs1isZero_pre  = 0;//Cờ báo 0                                  //Tất cả 0, dấu tùy
    reg         frs2isZero_pre  = 0;
    reg         frs3isZero_pre  = 0;   
    
    reg [31:0 ] dataCPU_rs1_pre      = 0;
    reg         dataCPU_valid_pre   = 0;

    reg [ 4:0 ] expskew     = 0;
    reg         exprs1higher= 0;
    reg         expskewofr  = 0;//out of range(>=27)

    reg [ 4:0 ] expskewacc  = 0;
    reg         exprs3higher= 0;
    reg         expskewaccofr=0;//out of range(>=27)

    reg [31:0 ] data_rs1_pre= 0;
    reg [31:0 ] fdata_rs1_pre= 0;
    reg [31:0 ] fdata_rs2_pre= 0;
    reg         signrs1_cvt_pre = 0;

    reg         FADD_pre    = 0;
    reg         FSUB_pre    = 0;
    reg         FMUL_pre    = 0;
    reg         FDIV_pre    = 0;
    reg         FSQRT_pre   = 0;
    reg         FSGNJ_pre   = 0;
    reg         FSGNJN_pre  = 0;
    reg         FSGNJX_pre  = 0;
    reg         FMIN_pre    = 0;
    reg         FMAX_pre    = 0;
    reg         FCVTWS_pre  = 0;
    reg         FCVTWUS_pre = 0;
    reg         FMVXW_pre   = 0;
    reg         FEQ_pre     = 0;
    reg         FLT_pre     = 0;
    reg         FLE_pre     = 0;
    reg         FCLASS_pre  = 0;
    reg         FCVTSW_pre  = 0;
    reg         FCVTSWU_pre = 0;
    reg         FMVWX_pre   = 0;
    reg         FLW_pre     = 0;

    reg         FMADD_pre   = 0;
    reg         FNMADD_pre  = 0;
    reg         FMSUB_pre   = 0;
    reg         FNMSUB_pre  = 0;

    reg         FPU_ready_pre_com       = 0;
    reg         FPU_ready_pre_com_ff    = 0;
    always @(*) begin
        if(hazard_1cyc || hazard_2cyc || hazard_3cyc || hazard_4cyc || hazard_5cyc || hazard_6cyc || hazard_7cyc) FPU_ready_pre_com = 0;
        else FPU_ready_pre_com = 1;
    end
    always @(posedge clk) FPU_ready_pre_com_ff <= FPU_ready_pre_com;
    assign      FPU_ready_pre_h = !FPU_ready_pre_com && FPU_ready_pre_com_ff;//Lấy của FPU_ready_pre sớm 1 chu kỳ
    wire        FPU_ready_pre_fn=  FPU_ready_pre     && !FPU_ready_pre_h;

    always @(posedge clk) begin
        if(!rst || !(FPU_en || (!FSW_enperi && FSW)) || DecodeNotValid) begin
            FPU_ready_pre <= 1;
            fregrd_pre  <= 0;
            fregrs1_pre <= 0;
            fregrs2_pre <= 0;
            fregrs3_pre <= 0;
            frd_en_pre  <= 0;
            ALI2en <= 0;
        end
        else begin
            //UNPACK
            signfrs1 <= fdata_rs1[31];   exponentfrs1 <= fdata_rs1[30:23];    mantissafrs1 <= {1'b1, fdata_rs1[22:0], 3'b000};
            signfrs2 <= fdata_rs2[31];   exponentfrs2 <= fdata_rs2[30:23];    mantissafrs2 <= {1'b1, fdata_rs2[22:0], 3'b000};
            signfrs3 <= fdata_rs3[31];   exponentfrs3 <= fdata_rs3[30:23];    mantissafrs3 <= {1'b1, fdata_rs3[22:0], 3'b000};
            datafrs1_pre    <= dataCPU_rs1  ;
            fregrs1_pre     <= fregrs1      ;
            fregrs2_pre     <= fregrs2      ;
            fregrs3_pre     <= fregrs3      ;
            fregrd_pre      <= fregrd       ;
            frd_en_pre      <= frd_en       ;
            fdata_rs1_pre   <= fdata_rs1    ;
            fdata_rs2_pre   <= fdata_rs2    ;

            //For mul, so le để dịch đề ở 2 state ope1 và ope2
            mulinA_ope1 <= {1'b1, fdata_rs1[22:0], 3'b000};
            mulinB_ope1 <= 3'd0;
            mulinC_ope1 <=  fdata_rs2[ 2:0 ];
            mulinD_ope1 <=  fdata_rs2[ 6:4 ];
            mulinE_ope1 <=  fdata_rs2[10:8 ];
            mulinF_ope1 <=  fdata_rs2[14:12];
            mulinG_ope1 <=  fdata_rs2[18:16];
            mulinH_ope1 <=  fdata_rs2[22:20];
    
            if(FDIV || FSQRT) frd_en_pre <= 0;
            //FOR FCVTSW[U]
            data_rs1_pre    <= dataCPU_rs1;
            signrs1_cvt_pre <= 0; 
            if(FCVTSW) begin
                data_rs1_pre    <= (dataCPU_rs1[31])?~dataCPU_rs1+1:dataCPU_rs1;
                signrs1_cvt_pre <= dataCPU_rs1[31];    
            end

            //PREPARE
            expskewofr <= 0;
            if(fdata_rs1[30:23] < fdata_rs2[30:23]) begin
                if(fdata_rs2[30:23] - fdata_rs1[30:23] >= 27) expskewofr <= 1;
                expskew <= fdata_rs2[30:23] - fdata_rs1[30:23];
                exprs1higher <= 0;
            end
            else begin
                if(fdata_rs1[30:23] - fdata_rs2[30:23] >= 27) expskewofr <= 1;
                expskew <= fdata_rs1[30:23] - fdata_rs2[30:23];
                exprs1higher <= 1;                
            end

            //PREPARE FOR ACC
            expskewaccofr <= 0;
            if(fdata_rs3[30:23] <= fdata_rs2[30:23] + fdata_rs1[30:23]-127) begin
                if(fdata_rs1[30:23] + fdata_rs2[30:23] - 127 - fdata_rs3[30:23] >= 27) expskewaccofr <= 1;
                expskewacc <= fdata_rs1[30:23] + fdata_rs2[30:23] - 127 - fdata_rs3[30:23];
                exprs3higher <= 0;
            end
            else begin
                if(fdata_rs3[30:23] - fdata_rs2[30:23] - fdata_rs1[30:23] + 127 >= 27) expskewaccofr <= 1;
                expskewacc <= fdata_rs3[30:23] - fdata_rs2[30:23] - fdata_rs1[30:23] + 127;
                exprs3higher <= 1;                
            end

            //zero, NaN, subnormal, infinity
                //SNaN
            frs1isSNaN_pre <= (&fdata_rs1[30:23]) && (|fdata_rs1[21:0]) && !fdata_rs1[22];
            frs2isSNaN_pre <= (&fdata_rs2[30:23]) && (|fdata_rs2[21:0]) && !fdata_rs2[22];          
            frs3isSNaN_pre <= (&fdata_rs3[30:23]) && (|fdata_rs3[21:0]) && !fdata_rs3[22];   
                //QNaN
            frs1isQNaN_pre <= (&fdata_rs1[30:23]) && fdata_rs1[22];
            frs2isQNaN_pre <= (&fdata_rs2[30:23]) && fdata_rs2[22];          
            frs3isQNaN_pre <= (&fdata_rs3[30:23]) && fdata_rs3[22];  
                //NaN
            frs1isNaN_pre  <= (&fdata_rs1[30:23]) && (|fdata_rs1[22:0]);
            frs2isNaN_pre  <= (&fdata_rs2[30:23]) && (|fdata_rs2[22:0]);          
            frs3isNaN_pre  <= (&fdata_rs3[30:23]) && (|fdata_rs3[22:0]); 
                //infinity
            frs1isInf_pre  <= (&fdata_rs1[30:23]) &&!(|fdata_rs1[22:0]);
            frs2isInf_pre  <= (&fdata_rs2[30:23]) &&!(|fdata_rs2[22:0]);          
            frs3isInf_pre  <= (&fdata_rs3[30:23]) &&!(|fdata_rs3[22:0]);  
                //subnormal
            frs1isSub_pre <= 0;
            frs2isSub_pre <= 0;
            frs3isSub_pre <= 0;
            if(!(|fdata_rs1[30:23]) && (|fdata_rs1[22:0])) begin
                frs1isSub_pre <= 1;
                mantissafrs1[26] <= 0;
                mulinA_ope1[26] <= 0;  
            end
            if(!(|fdata_rs2[30:23]) && (|fdata_rs2[22:0])) begin
                frs2isSub_pre <= 1;
                mantissafrs2[26] <= 0;  
            end
            if(!(|fdata_rs3[30:23]) && (|fdata_rs3[22:0])) begin
                frs3isSub_pre <= 1;
                mantissafrs3[26] <= 0;
            end

            //zero
            frs1isZero_pre  <= 0;
            frs2isZero_pre  <= 0;          
            frs3isZero_pre  <= 0; 
            if(!(|fdata_rs1[30:23]) && !(|fdata_rs1[22:0])) begin
                frs1isZero_pre <= 1;
                mantissafrs1[26] <= 0;
                mulinA_ope1[26] <= 0;
            end
            if(!(|fdata_rs2[30:23]) && !(|fdata_rs2[22:0])) begin
                frs2isZero_pre <= 1;
                mantissafrs2[26] <= 0;
            end
            if(!(|fdata_rs3[30:23]) && !(|fdata_rs3[22:0])) begin
                frs3isZero_pre <= 1;
                mantissafrs3[26] <= 0;
            end


            //Instruction
            FADD_pre    <= FADD;
            FSUB_pre    <= FSUB;
            FMUL_pre    <= FMUL;
            FDIV_pre    <= FDIV;
            FSQRT_pre   <= FSQRT;
            FSGNJ_pre   <= FSGNJ;
            FSGNJN_pre  <= FSGNJN;
            FSGNJX_pre  <= FSGNJX;
            FMIN_pre    <= FMIN;
            FMAX_pre    <= FMAX;
            FCVTWS_pre  <= FCVTWS;
            FCVTWUS_pre <= FCVTWUS;
            FMVXW_pre   <= FMVXW;
            FEQ_pre     <= FEQ;
            FLT_pre     <= FLT;
            FLE_pre     <= FLE;
            FCLASS_pre  <= FCLASS;
            FCVTSW_pre  <= FCVTSW;
            FCVTSWU_pre <= FCVTSWU;
            FMVWX_pre   <= FMVWX;  
            FLW_pre     <= FLW;
    
            FMADD_pre   <= FMADD;
            FNMADD_pre  <= FNMADD;
            FMSUB_pre   <= FMSUB;
            FNMSUB_pre  <= FNMSUB;

            //Hazard handle, pipeline
            FPU_ready_pre <= 1;
            ALI2en <= 1'b1;
            if(ALI2en) begin
                casez({hazard_1cyc, hazard_2cyc, hazard_3cyc, hazard_4cyc, hazard_5cyc, hazard_6cyc, hazard_7cyc})
                    7'b1??????  :   begin
                        pause_cnt   <= 10;
                        ALI2en      <= 0;
                        FPU_ready_pre <= 0;
                    end
                    7'b01?????  :   begin
                        pause_cnt   <= 9;
                        ALI2en      <= 0;
                        FPU_ready_pre <= 0;
                    end
                    7'b001????  :   begin
                        pause_cnt   <= 8;
                        ALI2en      <= 0;
                        FPU_ready_pre <= 0;
                    end
                    7'b0001???  :   begin
                        pause_cnt   <= 7;
                        ALI2en      <= 0;
                        FPU_ready_pre <= 0;
                    end
                    7'b00001??  :   begin       
                        pause_cnt   <= 6;
                        ALI2en      <= 0;
                        FPU_ready_pre <= 0;
                    end
                    7'b000001?  :   begin
                        pause_cnt   <= 5;
                        ALI2en      <= 0;
                        FPU_ready_pre <= 0;
                    end
                    7'b0000001  :   begin
                        pause_cnt   <= 4;
                        ALI2en      <= 0;
                        FPU_ready_pre <= 0;
                    end
                    default     :   begin
                        pause_cnt <= 0;
                        FPU_ready_pre <= 1;
                    end
                endcase
            end
            else begin
                if((|pause_cnt)) pause_cnt <= pause_cnt - 1;
                if(pause_cnt == 1 || !(|pause_cnt)) begin
                    ALI2en <= 1;
                    FPU_ready_pre <= 1;
                end
                else begin
                    ALI2en <= 0;
                    FPU_ready_pre <= 0;
                    frd_en_pre    <= 0;
                end
            end
        end
    end


//--------------------------------------------------ALIGN2---------------------------------------------//
    reg         signfrs1_ali2        = 0;
    reg [ 7:0 ] exponentfrs1_ali2    = 0;
    reg [26:0 ] mantissafrs1_ali2    = 0;
    reg         signfrs2_ali2        = 0;
    reg [ 7:0 ] exponentfrs2_ali2    = 0;
    reg [26:0 ] mantissafrs2_ali2    = 0;
    reg         signfrs3_ali2        = 0;
    reg signed [ 9:0 ] exponentfrs3_ali2    = 0;   //extend for Fused Multiply-Add
    reg [52:0 ] mantissafrs3_ali2    = 0;
    reg [31:0 ] datafrs1_ali2        = 0;
    reg [31:0 ] fdata_rs1_ali2       = 0;
    reg [31:0 ] fdata_rs2_ali2       = 0;
    
    reg [ 4:0 ] fregrs1_ali2         = 0;
    reg [ 4:0 ] fregrs2_ali2         = 0;
    reg [ 4:0 ] fregrs3_ali2         = 0;
    reg [ 4:0 ] fregrd_ali2          = 0;
    reg         frd_en_ali2          = 0;

    reg         signfrs1x_ali2       = 0;
    reg [ 7:0 ] exponentfrs1x_ali2   = 0;
    reg [26:0 ] mantissafrs1x_ali2   = 0;
    reg         signfrs2x_ali2       = 0;
    reg [ 7:0 ] exponentfrs2x_ali2   = 0;
    reg [26:0 ] mantissafrs2x_ali2   = 0;
    reg         signfrs3x_ali2       = 0;

    reg         frs1isSNaN_ali2  = 0;
    reg         frs2isSNaN_ali2  = 0;
    reg         frs3isSNaN_ali2  = 0;
    reg         frs1isQNaN_ali2  = 0;
    reg         frs2isQNaN_ali2  = 0;
    reg         frs3isQNaN_ali2  = 0;
    reg         frs1isNaN_ali2   = 0;
    reg         frs2isNaN_ali2   = 0;
    reg         frs3isNaN_ali2   = 0;
    reg         frs1isInf_ali2   = 0;
    reg         frs2isInf_ali2   = 0;
    reg         frs3isInf_ali2   = 0;
    reg         frs1isZero_ali2  = 0;
    reg         frs2isZero_ali2  = 0;
    reg         frs3isZero_ali2  = 0;
    reg         frs1isSub_ali2   = 0;
    reg         frs2isSub_ali2   = 0;
    reg         frs3isSub_ali2   = 0;

    reg         mul_inacc_Inf    = 0;
    reg         mul_inacc_Zero   = 0;

    reg [31:0 ] dataCPU_rs1_ali2      = 0;
    reg         dataCPU_valid_ali2   = 0;
    
    reg [26:0 ] mantissafrd_cvt_ali2 = 0;

    reg         signfrd_cvt_ali2     = 0;
    reg [ 4:0 ] exponentfrd_cvt_ali2 = 0;
    reg         iszero_ali2          = 0;

    reg [ 3:0 ] expskewacc_ali2     = 0;

    reg         FADD_ali2           = 0;
    reg         FSUB_ali2           = 0;
    reg         FMUL_ali2           = 0;
    reg         FDIV_ali2           = 0;
    reg         FSQRT_ali2          = 0;
    reg         FSGNJ_ali2          = 0;
    reg         FSGNJN_ali2         = 0;
    reg         FSGNJX_ali2         = 0;
    reg         FMIN_ali2           = 0;
    reg         FMAX_ali2           = 0;
    reg         FCVTWS_ali2         = 0;
    reg         FCVTWUS_ali2        = 0;
    reg         FMVXW_ali2          = 0;
    reg         FEQ_ali2            = 0;
    reg         FLT_ali2            = 0;
    reg         FLE_ali2            = 0;
    reg         FCLASS_ali2         = 0;
    reg         FCVTSW_ali2         = 0;
    reg         FCVTSWU_ali2        = 0;
    reg         FMVWX_ali2          = 0;
    reg         FLW_ali2            = 0;
    
    reg         FMADD_ali2          = 0;
    reg         FNMADD_ali2         = 0;
    reg         FMSUB_ali2          = 0;
    reg         FNMSUB_ali2         = 0;

    always @(posedge clk) begin
        if(!rst||!ALI2en) begin
            OPE1en <= 0;
            fregrd_ali2  <= 0;
            fregrs1_ali2 <= 0;
            fregrs2_ali2 <= 0;
            fregrs3_ali2 <= 0;
            frd_en_ali2  <= 0;
        end
        else begin
            //UNPACK
            signfrs1_ali2      <= signfrs1;   exponentfrs1_ali2  <= exponentfrs1;   mantissafrs1_ali2  <= mantissafrs1;
            signfrs2_ali2      <= signfrs2;   exponentfrs2_ali2  <= exponentfrs2;   mantissafrs2_ali2  <= mantissafrs2;
            signfrs3_ali2      <= signfrs3;   exponentfrs3_ali2  <= exponentfrs3;   mantissafrs3_ali2  <= mantissafrs3;
            signfrs1x_ali2     <= signfrs1;   exponentfrs1x_ali2 <= exponentfrs1;   mantissafrs1x_ali2 <= mantissafrs1;
            signfrs2x_ali2     <= signfrs2;   exponentfrs2x_ali2 <= exponentfrs2;   mantissafrs2x_ali2 <= mantissafrs2;
            datafrs1_ali2      <= datafrs1_pre;
            dataCPU_valid_ali2 <= dataCPU_valid_pre;

            fregrs1_ali2       <= fregrs1_pre;
            fregrs2_ali2       <= fregrs2_pre;
            fregrs3_ali2       <= fregrs3_pre;
            fregrd_ali2        <= fregrd_pre;
            frd_en_ali2        <= frd_en_pre;
            fdata_rs1_ali2     <= fdata_rs1_pre;
            fdata_rs2_ali2     <= fdata_rs2_pre;

            //FOR FCVTSW[U]
            signfrd_cvt_ali2  <= signrs1_cvt_pre;
            iszero_ali2       <= 0;
            case(1'b1)
                data_rs1_pre[31]    :   begin
                    exponentfrd_cvt_ali2 <= 31;
                    mantissafrd_cvt_ali2 <= {data_rs1_pre[31:5]};
                end
                data_rs1_pre[30]    :   begin
                    exponentfrd_cvt_ali2 <= 30;
                    mantissafrd_cvt_ali2 <= {data_rs1_pre[30:4]};
                end
                data_rs1_pre[29]    :   begin
                    exponentfrd_cvt_ali2 <= 29;
                    mantissafrd_cvt_ali2 <= {data_rs1_pre[29:3]};
                end
                data_rs1_pre[28]    :   begin
                    exponentfrd_cvt_ali2 <= 28;
                    mantissafrd_cvt_ali2 <= {data_rs1_pre[28:2]};
                end
                data_rs1_pre[27]    :   begin
                    exponentfrd_cvt_ali2 <= 27;
                    mantissafrd_cvt_ali2 <= {data_rs1_pre[27:1]};
                end
                data_rs1_pre[26]    :   begin
                    exponentfrd_cvt_ali2 <= 26;
                    mantissafrd_cvt_ali2 <= {data_rs1_pre[26:0]};
                end
                data_rs1_pre[25]    :   begin
                    exponentfrd_cvt_ali2 <= 25;
                    mantissafrd_cvt_ali2 <= {data_rs1_pre[25:0], 1'd0};
                end
                data_rs1_pre[24]    :   begin
                    exponentfrd_cvt_ali2 <= 24;
                    mantissafrd_cvt_ali2 <= {data_rs1_pre[24:0], 2'd0};
                end
                data_rs1_pre[23]    :   begin
                    exponentfrd_cvt_ali2 <= 23;
                    mantissafrd_cvt_ali2 <= {data_rs1_pre[23:0], 3'd0};
                end
                data_rs1_pre[22]    :   begin
                    exponentfrd_cvt_ali2 <= 22;
                    mantissafrd_cvt_ali2 <= {data_rs1_pre[22:0], 4'd0};
                end
                data_rs1_pre[21]    :   begin
                    exponentfrd_cvt_ali2 <= 21;
                    mantissafrd_cvt_ali2 <= {data_rs1_pre[21:0], 5'd0};
                end
                data_rs1_pre[20]    :   begin
                    exponentfrd_cvt_ali2 <= 20;
                    mantissafrd_cvt_ali2 <= {data_rs1_pre[20:0], 6'd0};
                end
                data_rs1_pre[19]    :   begin
                    exponentfrd_cvt_ali2 <= 19;
                    mantissafrd_cvt_ali2 <= {data_rs1_pre[19:0], 7'd0};
                end
                data_rs1_pre[18]    :   begin
                    exponentfrd_cvt_ali2 <= 18;
                    mantissafrd_cvt_ali2 <= {data_rs1_pre[18:0], 8'd0};
                end
                data_rs1_pre[17]    :   begin
                    exponentfrd_cvt_ali2 <= 17;
                    mantissafrd_cvt_ali2 <= {data_rs1_pre[17:0], 9'd0};
                end
                data_rs1_pre[16]    :   begin
                    exponentfrd_cvt_ali2 <= 16;
                    mantissafrd_cvt_ali2 <= {data_rs1_pre[16:0], 10'd0};
                end
                data_rs1_pre[15]    :   begin
                    exponentfrd_cvt_ali2 <= 15;
                    mantissafrd_cvt_ali2 <= {data_rs1_pre[15:0], 11'd0};
                end
                data_rs1_pre[14]    :   begin
                    exponentfrd_cvt_ali2 <= 14;
                    mantissafrd_cvt_ali2 <= {data_rs1_pre[14:0], 12'd0};
                end
                data_rs1_pre[13]    :   begin
                    exponentfrd_cvt_ali2 <= 13;
                    mantissafrd_cvt_ali2 <= {data_rs1_pre[13:0], 13'd0};
                end
                data_rs1_pre[12]    :   begin
                    exponentfrd_cvt_ali2 <= 12;
                    mantissafrd_cvt_ali2 <= {data_rs1_pre[12:0], 14'd0};
                end
                data_rs1_pre[11]    :   begin
                    exponentfrd_cvt_ali2 <= 11;
                    mantissafrd_cvt_ali2 <= {data_rs1_pre[11:0], 15'd0};
                end
                data_rs1_pre[10]    :   begin
                    exponentfrd_cvt_ali2 <= 10;
                    mantissafrd_cvt_ali2 <= {data_rs1_pre[10:0], 16'd0};
                end
                data_rs1_pre[9 ]    :   begin
                    exponentfrd_cvt_ali2 <= 9;
                    mantissafrd_cvt_ali2 <= {data_rs1_pre[ 9:0], 17'd0};
                end
                data_rs1_pre[8 ]    :   begin
                    exponentfrd_cvt_ali2 <= 8;
                    mantissafrd_cvt_ali2 <= {data_rs1_pre[ 8:0], 18'd0};
                end
                data_rs1_pre[7 ]    :   begin
                    exponentfrd_cvt_ali2 <= 7;
                    mantissafrd_cvt_ali2 <= {data_rs1_pre[ 7:0], 19'd0};
                end
                data_rs1_pre[6 ]    :   begin
                    exponentfrd_cvt_ali2 <= 6;
                    mantissafrd_cvt_ali2 <= {data_rs1_pre[ 6:0], 20'd0};
                end
                data_rs1_pre[5 ]    :   begin
                    exponentfrd_cvt_ali2 <= 5;
                    mantissafrd_cvt_ali2 <= {data_rs1_pre[ 5:0], 21'd0};
                end
                data_rs1_pre[4 ]    :   begin
                    exponentfrd_cvt_ali2 <= 4;
                    mantissafrd_cvt_ali2 <= {data_rs1_pre[ 4:0], 22'd0};
                end
                data_rs1_pre[3 ]    :   begin
                    exponentfrd_cvt_ali2 <= 3;
                    mantissafrd_cvt_ali2 <= {data_rs1_pre[ 3:0], 23'd0};
                end
                data_rs1_pre[2 ]    :   begin
                    exponentfrd_cvt_ali2 <= 2;
                    mantissafrd_cvt_ali2 <= {data_rs1_pre[ 2:0], 24'd0};
                end
                data_rs1_pre[1 ]    :   begin
                    exponentfrd_cvt_ali2 <= 1;
                    mantissafrd_cvt_ali2 <= {data_rs1_pre[ 1:0], 25'd0};
                end
                data_rs1_pre[0 ]    :   begin
                    exponentfrd_cvt_ali2 <= 0;
                    mantissafrd_cvt_ali2 <= {data_rs1_pre[0], 26'd0};
                end
                default: begin
                    iszero_ali2 <= 1;
                end
            endcase            

            //Align for acc
            if(FMADD_pre || FNMADD_pre || FMSUB_pre || FNMSUB_pre) begin
                exponentfrs3_ali2 <= $unsigned(exponentfrs1) + $unsigned(exponentfrs2) - 127;
                if(exprs3higher) begin
                    mantissafrs3_ali2 <= mantissafrs3 << expskewacc;
                    expskewacc_ali2 <= expskewacc[3:0];
                    if(expskewaccofr) begin     //rs1*rs2 -> zero
                        exponentfrs3_ali2 <= exponentfrs3;
                        mantissafrs3_ali2 <= mantissafrs3;
                        mantissafrs2_ali2 <= 0;
                        expskewacc_ali2 <= 0;
                    end
                end
                else begin
                    mantissafrs3_ali2 <= mantissafrs3 >> expskewacc;
                    if(expskewaccofr) begin     //rs3 -> zero
                        mantissafrs3_ali2 <= 0;
                        exponentfrs3_ali2 <= 0;
                    end
                end
            end

            //Align
            if(FADD_pre || FSUB_pre) begin
                if(exprs1higher) begin
                    exponentfrs2_ali2 <= exponentfrs1;
                    mantissafrs2_ali2 <= mantissafrs2 >> expskew;
                    if(expskewofr) begin        //zero
                        exponentfrs2_ali2 <= 0;
                        mantissafrs2_ali2 <= 0;
                    end
                end
                else begin
                    exponentfrs1_ali2 <= exponentfrs2;
                    mantissafrs1_ali2 <= mantissafrs1 >> expskew;
                    if(expskewofr) begin        //zero
                        exponentfrs1_ali2 <= 0;
                        mantissafrs1_ali2 <= 0;
                    end
                end
            end
    
            //for mul
            mulinA_ope2 <= mulinA_ope1;
            mulinB_ope2 <=  mantissafrs2[ 3:1 ];
            mulinC_ope2 <=  mantissafrs2[ 7:5 ];
            mulinD_ope2 <=  mantissafrs2[11:9 ];
            mulinE_ope2 <=  mantissafrs2[15:13];
            mulinF_ope2 <=  mantissafrs2[19:17];
            mulinG_ope2 <=  mantissafrs2[23:21];
            mulinH_ope2 <= {1'b0, mantissafrs2[26:25]};

            //nan, zero, inf...
            frs1isSNaN_ali2 <= frs1isSNaN_pre;
            frs2isSNaN_ali2 <= frs2isSNaN_pre;
            frs3isSNaN_ali2 <= frs3isSNaN_pre;
            frs1isQNaN_ali2 <= frs1isQNaN_pre;
            frs2isQNaN_ali2 <= frs2isQNaN_pre;
            frs3isQNaN_ali2 <= frs3isQNaN_pre;
            frs1isNaN_ali2  <= frs1isNaN_pre;
            frs2isNaN_ali2  <= frs2isNaN_pre;
            frs3isNaN_ali2  <= frs3isNaN_pre;
            frs1isInf_ali2  <= frs1isInf_pre;
            frs2isInf_ali2  <= frs2isInf_pre;
            frs3isInf_ali2  <= frs3isInf_pre;
            frs1isZero_ali2 <= frs1isZero_pre;
            frs2isZero_ali2 <= frs2isZero_pre;
            frs3isZero_ali2 <= frs3isZero_pre;
            frs1isSub_ali2  <= frs1isSub_pre;
            frs2isSub_ali2  <= frs2isSub_pre;
            frs3isSub_ali2  <= frs3isSub_pre;
            
            //Instruction
            FADD_ali2       <= FADD_pre;
            FSUB_ali2       <= FSUB_pre;
            FMUL_ali2       <= FMUL_pre;
            FDIV_ali2       <= FDIV_pre;
            FSQRT_ali2      <= FSQRT_pre;
            FSGNJ_ali2      <= FSGNJ_pre;
            FSGNJN_ali2     <= FSGNJN_pre;
            FSGNJX_ali2     <= FSGNJX_pre;
            FMIN_ali2       <= FMIN_pre;
            FMAX_ali2       <= FMAX_pre;
            FCVTWS_ali2     <= FCVTWS_pre;
            FCVTWUS_ali2    <= FCVTWUS_pre;
            FMVXW_ali2      <= FMVXW_pre;
            FEQ_ali2        <= FEQ_pre;
            FLT_ali2        <= FLT_pre;
            FLE_ali2        <= FLE_pre;
            FCLASS_ali2     <= FCLASS_pre;
            FCVTSW_ali2     <= FCVTSW_pre;
            FCVTSWU_ali2    <= FCVTSWU_pre;
            FMVWX_ali2      <= FMVWX_pre;
            FLW_ali2        <= FLW_pre;

            FMSUB_ali2      <= FMSUB_pre;
            FNMSUB_ali2     <= FNMSUB_pre;
            FMADD_ali2      <= FMADD_pre;
            FNMADD_ali2     <= FNMADD_pre;

            OPE1en <= 1;
        end
    end



//--------------------------------------------------OPERATION1---------------------------------------------//
    reg         FADD_ope1        = 0;
    reg         FSUB_ope1        = 0;
    reg         FMUL_ope1        = 0;
    reg         FDIV_ope1        = 0;
    reg         FSQRT_ope1       = 0;
    reg         FSGNJ_ope1       = 0;
    reg         FSGNJN_ope1      = 0;
    reg         FSGNJX_ope1      = 0;
    reg         FMIN_ope1        = 0;
    reg         FMAX_ope1        = 0;
    reg         FCVTWS_ope1      = 0;
    reg         FCVTWUS_ope1     = 0;
    reg         FMVXW_ope1       = 0;
    reg         FEQ_ope1         = 0;
    reg         FLT_ope1         = 0;
    reg         FLE_ope1         = 0;
    reg         FCLASS_ope1      = 0;
    reg         FCVTSW_ope1      = 0;
    reg         FCVTSWU_ope1     = 0;
    reg         FMVWX_ope1       = 0;
    reg         FLW_ope1         = 0;

    reg         FMADD_ope1       = 0;
    reg         FNMADD_ope1      = 0;
    reg         FMSUB_ope1       = 0;
    reg         FNMSUB_ope1      = 0;


    reg         signfrs1_ope1        = 0;
    reg [ 7:0 ] exponentfrs1_ope1    = 0;
    reg [26:0 ] mantissafrs1_ope1    = 0;
    reg         signfrs2_ope1        = 0;
    reg [ 7:0 ] exponentfrs2_ope1    = 0;
    reg [26:0 ] mantissafrs2_ope1    = 0;
    reg         signfrs3_ope1        = 0;
    reg signed [ 9:0 ] exponentfrs3_ope1    = 0;
    reg [52:0 ] mantissafrs3_ope1    = 0;
    reg [31:0 ] datafrs1_ope1        = 0;
    reg [31:0 ] fdata_rs1_ope1       = 0;
    reg [31:0 ] fdata_rs2_ope1       = 0;

    reg [ 4:0 ] fregrs1_ope1         = 0;
    reg [ 4:0 ] fregrs2_ope1         = 0;
    reg [ 4:0 ] fregrs3_ope1         = 0;
    reg [ 4:0 ] fregrd_ope1          = 0;
    reg         frd_en_ope1          = 0;

    reg         signfrs1x_ope1       = 0;
    reg [ 7:0 ] exponentfrs1x_ope1   = 0;
    reg [26:0 ] mantissafrs1x_ope1   = 0;
    reg         signfrs2x_ope1       = 0;
    reg [ 7:0 ] exponentfrs2x_ope1   = 0;
    reg [26:0 ] mantissafrs2x_ope1   = 0;

    reg [ 3:0 ] expskewacc_ope1  = 0;

    reg         frs1isSNaN_ope1  = 0;
    reg         frs2isSNaN_ope1  = 0;
    reg         frs3isSNaN_ope1  = 0;
    reg         frs1isQNaN_ope1  = 0;
    reg         frs2isQNaN_ope1  = 0;
    reg         frs3isQNaN_ope1  = 0;
    reg         frs1isNaN_ope1   = 0;
    reg         frs2isNaN_ope1   = 0;
    reg         frs3isNaN_ope1   = 0;
    reg         frs1isInf_ope1   = 0;
    reg         frs2isInf_ope1   = 0;
    reg         frs3isInf_ope1   = 0;
    reg         frs1isZero_ope1  = 0;
    reg         frs2isZero_ope1  = 0;
    reg         frs3isZero_ope1  = 0;
    reg         frs1isSub_ope1   = 0;
    reg         frs2isSub_ope1   = 0;
    reg         frs3isSub_ope1   = 0;

    reg [31:0 ] dataCPU_rs1_ope1      = 0;
    reg         dataCPU_valid_ope1   = 0;

    reg         rs1lesst_ope1    = 0;

    reg [31:0 ] data_rs1_ope1       = 0;

    reg         signrd_ope1      = 0;
    reg signed  [ 9:0 ] exponentrd_ope1 = 0;
    reg signed  [53:0 ] mantissard_ope1  = 0;    
    reg         [53:0 ] mantissard_signed_ope1  = 0; 

    reg         ope_done            = 0;    //Chỉ xử lý trường hợp NaN, zero, Infinity ...

    always @(posedge clk) begin
        if(!rst||!OPE1en) begin
            OPE2en <= 0;
            fregrd_ope1  <= 0;
            fregrs1_ope1 <= 0;
            fregrs2_ope1 <= 0;
            fregrs3_ope1 <= 0;
            frd_en_ope1  <= 0;
        end
        else begin 
            signfrs1_ope1        <= signfrs1_ali2;    exponentfrs1_ope1    <= exponentfrs1_ali2;    mantissafrs1_ope1    <= mantissafrs1_ali2;
            signfrs2_ope1        <= signfrs2_ali2;    exponentfrs2_ope1    <= exponentfrs2_ali2;    mantissafrs2_ope1    <= mantissafrs2_ali2;
            signfrs3_ope1        <= signfrs3_ali2;    exponentfrs3_ope1    <= exponentfrs3_ali2;    mantissafrs3_ope1    <= mantissafrs3_ali2;
            signfrs1x_ope1       <= signfrs1x_ali2;   exponentfrs1x_ope1   <= exponentfrs1x_ali2;   mantissafrs1x_ope1   <= mantissafrs1x_ali2;
            signfrs2x_ope1       <= signfrs2x_ali2;   exponentfrs2x_ope1   <= exponentfrs2x_ali2;   mantissafrs2x_ope1   <= mantissafrs2x_ali2;

            fregrs1_ope1         <= fregrs1_ali2;
            fregrs2_ope1         <= fregrs2_ali2;
            fregrs3_ope1         <= fregrs3_ali2;        
            fregrd_ope1          <= fregrd_ali2;
            frd_en_ope1          <= frd_en_ali2;
            fdata_rs1_ope1       <= fdata_rs1_ali2;
            fdata_rs2_ope1       <= fdata_rs2_ali2;

            expskewacc_ope1      <= expskewacc_ali2;

            ope_done <= 0;
            case(1'b1)
                FADD_ali2   :   begin
                    if(signfrs1_ali2 == signfrs2_ali2) begin
                        mantissard_ope1 <= $unsigned(mantissafrs1_ali2) + $unsigned(mantissafrs2_ali2);
                        signrd_ope1 <= signfrs1_ali2;
                    end
                    exponentrd_ope1 <= {2'b00, exponentfrs1_ali2};
                    if(frs1isQNaN_ali2 || frs2isQNaN_ali2) begin
                        //invalid
                    end
                end
                FSUB_ali2   :   begin
                    if(signfrs1_ali2 != signfrs2_ali2) begin
                        mantissard_ope1 <= $unsigned(mantissafrs1_ali2) + $unsigned(mantissafrs2_ali2);
                        signrd_ope1 <= signfrs1_ali2;
                    end
                    exponentrd_ope1 <= {2'b00, exponentfrs1_ali2};
                    if(frs1isSNaN_ali2 || frs2isSNaN_ali2) begin
                        //invalid
                    end
                end
                FMIN_ali2|FMAX_ali2: begin
                    if(fdata_rs1_ali2[31] != fdata_rs2_ali2[31])    rs1lesst_ope1 <= (fdata_rs1_ali2[31] == 1'b1); // rs1 âm < rs2 dương
                    else if(fdata_rs1_ali2[31] == 1'b0)             rs1lesst_ope1 <= (fdata_rs1_ali2[30:0] < fdata_rs2_ali2[30:0]);
                    else                                            rs1lesst_ope1 <= (fdata_rs1_ali2[30:0] > fdata_rs2_ali2[30:0]);

                    if((frs1isNaN_ali2 && frs2isNaN_ali2) || frs1isSNaN_ali2 || frs2isSNaN_ali2) begin  //cNaN - 0x7fc00000
                        signrd_ope1 <= 1'b0;
                        exponentrd_ope1 <= 10'h0ff;
                        mantissard_ope1 <= {27'd0, 24'b110000000000000000000000, 3'b000};
                        ope_done <= 1;
                    end
                end
                FSGNJ_ali2  :   begin
                    exponentrd_ope1 <= {2'b00, exponentfrs1_ali2};
                    mantissard_ope1 <= $unsigned(mantissafrs1_ali2);
                    signrd_ope1 <= signfrs2_ali2;
                end
                FSGNJN_ali2 :   begin
                    exponentrd_ope1 <= {2'b00, exponentfrs1_ali2};
                    mantissard_ope1 <= $unsigned(mantissafrs1_ali2);
                    signrd_ope1 <= !signfrs2_ali2;
                end
                FMUL_ali2||FMADD_ali2||FNMADD_ali2||FMSUB_ali2||FNMSUB_ali2:   begin
                    exponentrd_ope1 <= exponentfrs1_ali2 - 127;
                    mantissard_ope1 <= (res_on_ope1) + (res_tw_ope1 << 4) + (res_th_ope1 << 8) + (res_fo_ope1 << 12) +
                                                  (res_fi_ope1 << 16)+ (res_si_ope1 << 20)+ (res_se_ope1 << 24);
                    if(frs1isNaN_ali2 || frs2isNaN_ali2 || (frs3isNaN_ali2 && !FMUL_ali2)) begin    //cNaN
                        signrd_ope1 <= 1'b0;
                        exponentrd_ope1 <= 10'h0ff;
                        mantissard_ope1 <= {27'd0, 24'b110000000000000000000000, 3'b000};
                        ope_done <= 1;
                    end
                    if((frs1isZero_ali2 && frs2isInf_ali2) || (frs1isInf_ali2 && frs2isZero_ali2)) begin    //cNaN                        signrd_ope1 <= 1'b0;
                        exponentrd_ope1 <= 10'h0ff;
                        mantissard_ope1 <= {27'd0, 24'b110000000000000000000000, 3'b000};
                        ope_done <= 1;
                    end
                    if(frs1isSNaN_ali2 || frs2isSNaN_ali2 || (frs3isSNaN_ali2 && !FMUL_ali2)) begin
                        //invalid
                    end
                end
                FCVTSW_ali2||FCVTSWU_ali2:   begin
                    exponentrd_ope1 <= exponentfrd_cvt_ali2 + 127;
                    signrd_ope1     <= signfrd_cvt_ali2;
                    mantissard_ope1 <= {27'd0, mantissafrd_cvt_ali2};
                    if(iszero_ali2) begin
                        exponentrd_ope1 <= 0;
                        mantissard_ope1 <= 0;
                    end
                end
            endcase

            datafrs1_ope1       <= datafrs1_ali2;
            dataCPU_rs1_ope1     <= dataCPU_rs1_ali2;
            dataCPU_valid_ope1   <= dataCPU_valid_ali2;

            //nan, zero, inf...
            frs1isSNaN_ope1 <= frs1isSNaN_ali2;
            frs2isSNaN_ope1 <= frs2isSNaN_ali2;
            frs3isSNaN_ope1 <= frs3isSNaN_ali2;
            frs1isQNaN_ope1 <= frs1isQNaN_ali2;
            frs2isQNaN_ope1 <= frs2isQNaN_ali2;
            frs3isQNaN_ope1 <= frs3isQNaN_ali2;
            frs1isNaN_ope1  <= frs1isNaN_ali2;
            frs2isNaN_ope1  <= frs2isNaN_ali2;
            frs3isNaN_ope1  <= frs3isNaN_ali2;
            frs1isInf_ope1  <= frs1isInf_ali2;
            frs2isInf_ope1  <= frs2isInf_ali2;
            frs3isInf_ope1  <= frs3isInf_ali2;
            frs1isZero_ope1 <= frs1isZero_ali2;
            frs2isZero_ope1 <= frs2isZero_ali2;
            frs3isZero_ope1 <= frs3isZero_ali2;
            frs1isSub_ope1  <= frs1isSub_ali2;
            frs2isSub_ope1  <= frs2isSub_ali2;
            frs3isSub_ope1  <= frs3isSub_ali2;

            //Instruction
            FADD_ope1    <= FADD_ali2;
            FSUB_ope1    <= FSUB_ali2;
            FMUL_ope1    <= FMUL_ali2;
            FDIV_ope1    <= FDIV_ali2;
            FSQRT_ope1   <= FSQRT_ali2;
            FSGNJ_ope1   <= FSGNJ_ali2;
            FSGNJN_ope1  <= FSGNJN_ali2;
            FSGNJX_ope1  <= FSGNJX_ali2;
            FMIN_ope1    <= FMIN_ali2;
            FMAX_ope1    <= FMAX_ali2;
            FCVTWS_ope1  <= FCVTWS_ali2;
            FCVTWUS_ope1 <= FCVTWUS_ali2;
            FMVXW_ope1   <= FMVXW_ali2;
            FEQ_ope1     <= FEQ_ali2;
            FLT_ope1     <= FLT_ali2;
            FLE_ope1     <= FLE_ali2;
            FCLASS_ope1  <= FCLASS_ali2;
            FCVTSW_ope1  <= FCVTSW_ali2;
            FCVTSWU_ope1 <= FCVTSWU_ali2;
            FMVWX_ope1   <= FMVWX_ali2;
            FLW_ope1     <= FLW_ali2;

            FMADD_ope1   <= FMADD_ali2;
            FNMADD_ope1  <= FNMADD_ali2;
            FMSUB_ope1   <= FMSUB_ali2;
            FNMSUB_ope1  <= FNMSUB_ali2;

            //pipeline
            OPE2en <= 1'b1;
        end
    end


//--------------------------------------------------OPERATION2---------------------------------------------//
    reg         FADD_ope2        = 0;
    reg         FSUB_ope2        = 0;
    reg         FMUL_ope2        = 0;
    reg         FDIV_ope2        = 0;
    reg         FSQRT_ope2       = 0;
    reg         FSGNJ_ope2       = 0;
    reg         FSGNJN_ope2      = 0;
    reg         FSGNJX_ope2      = 0;
    reg         FMIN_ope2        = 0;
    reg         FMAX_ope2        = 0;
    reg         FCVTWS_ope2      = 0;
    reg         FCVTWUS_ope2     = 0;
    reg         FMVXW_ope2       = 0;
    reg         FEQ_ope2         = 0;
    reg         FLT_ope2         = 0;
    reg         FLE_ope2         = 0;
    reg         FCLASS_ope2      = 0;
    reg         FCVTSW_ope2      = 0;
    reg         FCVTSWU_ope2     = 0;
    reg         FMVWX_ope2       = 0;
    reg         FLW_ope2         = 0;

    reg         FMADD_ope2       = 0;
    reg         FNMADD_ope2      = 0;
    reg         FMSUB_ope2       = 0;
    reg         FNMSUB_ope2      = 0;   

    reg         signrd_ope2      = 0;
    reg signed  [ 9:0 ] exponentrd_ope2  = 0;
    reg signed  [54:0 ] mantissard_ope2  = 0; 
    reg         [78:0 ] mantissafrs3_ope2= 0;
    reg                 signfrs3_ope2    = 0;      

    reg         [ 4:0 ] fregrs1_ope2    = 0;
    reg         [ 4:0 ] fregrs2_ope2    = 0;
    reg         [ 4:0 ] fregrs3_ope2    = 0;
    reg         [ 4:0 ] fregrd_ope2     = 0;
    reg                 frd_en_ope2     = 0;

    reg         [ 3:0 ] expskewacc_ope2 = 0;

    reg         [31:0 ] dataCPU_rs1_ope2      = 0;
    reg         dataCPU_valid_ope2   = 0;
    reg         NoNor_ope               = 0;
     

    always @(posedge clk) begin
        if(!rst||!OPE2en) begin
            NOR1en <= 0;
            fregrd_ope2  <= 0;
            fregrs1_ope2 <= 0;
            fregrs2_ope2 <= 0;
            fregrs3_ope2 <= 0;
            frd_en_ope2  <= 0;
        end
        else begin 
            exponentrd_ope2 <= exponentrd_ope1;
            signrd_ope2 <= signrd_ope1;
            mantissard_ope2 <= mantissard_ope1;
            mantissafrs3_ope2 <= mantissafrs3_ope1 << 26;
            signfrs3_ope2 <= signfrs3_ope1;
            NoNor_ope <= 0;

            fregrs1_ope2 <= fregrs1_ope1;
            fregrs2_ope2 <= fregrs2_ope1;
            fregrs3_ope2 <= fregrs3_ope1;           
            fregrd_ope2 <= fregrd_ope1;
            frd_en_ope2 <= frd_en_ope1;

            expskewacc_ope2 <= expskewacc_ope1;

            //pipeline
            NOR1en <= 1'b1;

            case(1'b1)
                FADD_ope1   :   begin
                    if(signfrs1_ope1 != signfrs2_ope1) begin
                        if($unsigned(mantissafrs1_ope1) > $unsigned(mantissafrs2_ope1)) begin
                            mantissard_ope2 <= $unsigned(mantissafrs1_ope1) - $unsigned(mantissafrs2_ope1);
                            signrd_ope2 <= signfrs1_ope1;
                        end
                        else begin
                            mantissard_ope2 <= $unsigned(mantissafrs2_ope1) - $unsigned(mantissafrs1_ope1);
                            signrd_ope2 <= signfrs2_ope1;
                        end
                    end
                    if(frs1isNaN_ope1 || frs2isNaN_ope1) begin  //cNaN
                        signrd_ope2 <= 1'b0;
                        exponentrd_ope2 <= 10'h0ff;
                        mantissard_ope2 <= {27'd0, 24'b110000000000000000000000, 3'b000};  
                        NoNor_ope <= 1;
                    end
                end
                FSUB_ope1   :   begin
                    if(signfrs1_ope1 == signfrs2_ope1) begin
                        if(mantissafrs1_ope1 > mantissafrs2_ope1) begin
                            mantissard_ope2 <= $unsigned(mantissafrs1_ope1) - $unsigned(mantissafrs2_ope1);
                            signrd_ope2 <= signfrs1_ope1;
                        end
                        else begin
                            mantissard_ope2 <= $unsigned(mantissafrs2_ope1) - $unsigned(mantissafrs1_ope1);
                            signrd_ope2 <= !signfrs2_ope1;
                        end
                    end
                    if(frs1isNaN_ope1 || frs2isNaN_ope1) begin  //cNaN
                        signrd_ope2 <= 1'b0;
                        exponentrd_ope2 <= 10'h0ff;
                        mantissard_ope2 <= {27'd0, 24'b110000000000000000000000, 3'b000};  
                        NoNor_ope <= 1;
                    end
                end
                FMIN_ope1||FMAX_ope1: begin
                    if(rs1lesst_ope1 && FMIN_ope1) begin
                        signrd_ope2 <= fdata_rs1_ope1[31];
                        exponentrd_ope2 <= {2'b00, fdata_rs1_ope1[30:23]};
                        mantissard_ope2 <= {27'd0, 1'b1, fdata_rs1_ope1[22:0], 3'b000};
                    end
                    else begin
                        signrd_ope2 <= fdata_rs2_ope1[31];
                        exponentrd_ope2 <= {2'b00, fdata_rs2_ope1[30:23]};
                        mantissard_ope2 <= {27'd0, 1'b1, fdata_rs2_ope1[22:0], 3'b000};
                    end

                    if(frs1isNaN_ope1) begin                            
                        signrd_ope2 <= signfrs2x_ope1;
                        exponentrd_ope2 <= {2'b00, exponentfrs2x_ope1};
                        mantissard_ope2 <= mantissafrs2x_ope1;
                    end
                    if(frs2isNaN_ope1) begin    
                        signrd_ope2 <= signfrs1x_ope1;
                        exponentrd_ope2 <= {2'b00, exponentfrs1x_ope1};
                        mantissard_ope2 <= mantissafrs1x_ope1;
                    end

                    if(ope_done) begin
                        exponentrd_ope2 <= {2'b00, exponentrd_ope1};
                        signrd_ope2 <= signrd_ope1;
                        mantissard_ope2 <= mantissard_ope1;
                    end
                    if(frs1isSNaN_ope1 || frs2isSNaN_ope1) begin
                        //invalid
                    end
                end
                FSGNJX_ope1 :   begin
                    exponentrd_ope2 <= {2'b00, exponentfrs1_ope1};
                    mantissard_ope2 <= mantissafrs1_ope1;
                    signrd_ope2 <= signfrs2_ope1^signfrs1_ope1;
                end
                FMUL_ope1||FMADD_ope1||FNMSUB_ope1||FNMADD_ope1||FMSUB_ope1:   begin
                    signrd_ope2 <= signfrs2_ope1^signfrs1_ope1;
                    exponentrd_ope2 <= $signed(exponentrd_ope1) + $signed({2'b00, exponentfrs2_ope1});
                    mantissard_ope2 <= mantissard_ope1 + (res_on_ope2 << 2) + (res_tw_ope2 << 6) + (res_th_ope2 << 10) + (res_fo_ope2 << 14) +
                                                         (res_fi_ope2 << 18)+ (res_si_ope2 << 22) + (res_se_ope2 << 26);

                    if((frs1isZero_ope1 && frs2isInf_ope1)||(frs2isZero_ope1 && frs1isInf_ope1)) begin  //cNaN
                        signrd_ope2 <= 1'b0;
                        exponentrd_ope2 <= 10'h0ff;
                        mantissard_ope2 <= {27'd0, 24'b110000000000000000000000, 3'b000};
                        NoNor_ope <= 1;
                    end

                    if(ope_done) begin
                        exponentrd_ope2 <= exponentrd_ope1;
                        signrd_ope2 <= signrd_ope1;
                        mantissard_ope2 <= mantissard_ope1;
                        NoNor_ope <= 1;
                    end
                end
                0:   begin
                    exponentrd_ope2 <= $signed(exponentrd_ope1) + $signed({2'b00, exponentfrs2_ope1});
                    if(signfrs2_ope1^signfrs1_ope1 != signfrs3_ope1) begin
                        if((mantissard_ope2 + (res_on_ope2 << 2) + (res_tw_ope2 << 6) + (res_th_ope2 << 10) + (res_fo_ope2 << 14) +
                                                         (res_fi_ope2 << 18)+ (res_si_ope2 << 22) + (res_se_ope2 << 26)) > ($signed({1'b0, mantissafrs3_ope1, 26'b0}))) begin
                            mantissard_ope2 <= mantissard_ope1 + (res_on_ope2 << 2) + (res_tw_ope2 << 6) + (res_th_ope2 << 10) + (res_fo_ope2 << 14) +
                                                                 (res_fi_ope2 << 18)+ (res_si_ope2 << 22)+ (res_se_ope2 << 26) - ($signed({1'b0, mantissafrs3_ope1, 26'b0}));
                            signrd_ope2 <= (FNMSUB_ope1)?signfrs2_ope1==signfrs1_ope1:signfrs2_ope1^signfrs1_ope1;
                        end
                        else begin
                            mantissard_ope2 <=-mantissard_ope1 - (res_on_ope2 << 2) - (res_tw_ope2 << 6) - (res_th_ope2 << 10) - (res_fo_ope2 << 14) -
                                                                 (res_fi_ope2 << 18)- (res_si_ope2 << 22)- (res_se_ope2 << 26) + ($signed({1'b0, mantissafrs3_ope1, 26'b0}));
                            signrd_ope2 <= (FNMSUB_ope1)?!signfrs3_ope1:signfrs3_ope1;
                        end
                    end
                    else begin
                        mantissard_ope2 <= mantissard_ope1 + (res_on_ope2 << 2) + (res_tw_ope2 << 6) + (res_th_ope2 << 10) + (res_fo_ope2 << 14) +
                                                             (res_fi_ope2 << 18)+ (res_si_ope2 << 22)+ (res_se_ope2 << 26) + ($signed({1'b0, mantissafrs3_ope1, 26'b0}));
                        signrd_ope2 <= (FNMSUB_ope1)?!signfrs3_ope1:signfrs3_ope1;
                    end

                    if((frs1isZero_ope1 && frs2isInf_ope1)||(frs2isZero_ope1 && frs1isInf_ope1)) begin  //cNaN
                        signrd_ope2 <= 1'b0;
                        exponentrd_ope2 <= 10'h0ff;
                        mantissard_ope2 <= {27'd0, 24'b110000000000000000000000, 3'b000};
                    end

                    if(ope_done) begin
                        exponentrd_ope2 <= exponentrd_ope1;
                        signrd_ope2 <= signfrs1_ope1;
                        mantissard_ope2 <= mantissard_ope1;
                    end
                end
                0:   begin
                    exponentrd_ope2 <= $signed(exponentrd_ope1) + $signed({2'b0, exponentfrs2_ope1});
                    if(signfrs2_ope1^signfrs1_ope1 == signfrs3_ope1) begin
                        if((mantissard_ope2 + (res_on_ope2 << 2) + (res_tw_ope2 << 6) + (res_th_ope2 << 10) + (res_fo_ope2 << 14) +
                                                         (res_fi_ope2 << 18)+ (res_si_ope2 << 22) + (res_se_ope2 << 26)) > ($signed({1'b0, mantissafrs3_ope1, 26'b0}))) begin
                            mantissard_ope2 <= mantissard_ope1 + (res_on_ope2 << 2) + (res_tw_ope2 << 6) + (res_th_ope2 << 10) + (res_fo_ope2 << 14) +
                                                                 (res_fi_ope2 << 18)+ (res_si_ope2 << 22)+ (res_se_ope2 << 26) - ($signed({1'b0, mantissafrs3_ope1, 26'b0}));
                            signrd_ope2 <= (FNMADD_ope1)?signfrs2_ope1==signfrs1_ope1:signfrs2_ope1^signfrs1_ope1;
                        end
                        else begin
                            mantissard_ope2 <=-mantissard_ope1 - (res_on_ope2 << 2) - (res_tw_ope2 << 6) - (res_th_ope2 << 10) - (res_fo_ope2 << 14) -
                                                                 (res_fi_ope2 << 18)- (res_si_ope2 << 22)- (res_se_ope2 << 26) + ($signed({1'b0, mantissafrs3_ope1, 26'b0}));
                            signrd_ope2 <= (FNMADD_ope1)?signfrs3_ope1:!signfrs3_ope1;
                        end
                    end
                    else begin
                        mantissard_ope2 <= mantissard_ope1 + (res_on_ope2 << 2) + (res_tw_ope2 << 6) + (res_th_ope2 << 10) + (res_fo_ope2 << 14) +
                                                             (res_fi_ope2 << 18)+ (res_si_ope2 << 22)+ (res_se_ope2 << 26) + ($signed({1'b0, mantissafrs3_ope1, 26'b0}));
                        signrd_ope2 <= (FNMADD_ope1)?signfrs3_ope1:!signfrs3_ope1;
                    end

                    if((frs1isZero_ope1 && frs2isInf_ope1)||(frs2isZero_ope1 && frs1isInf_ope1)) begin  //cNaN
                        signrd_ope2 <= 1'b0;
                        exponentrd_ope2 <= 10'h0ff;
                        mantissard_ope2 <= {27'd0, 24'b110000000000000000000000, 3'b000};
                    end

                    if(ope_done) begin
                        exponentrd_ope2 <= exponentrd_ope1;
                        signrd_ope2 <= signfrs1_ope1;
                        mantissard_ope2 <= mantissard_ope1;
                    end
                end
                FMVWX_ope1  :   begin
                    signrd_ope2 <= datafrs1_ope1[31];
                    exponentrd_ope2 <= {2'b0, datafrs1_ope1[30:23]};
                    mantissard_ope2 <= {28'd0, 1'b1, datafrs1_ope1[22:0 ], 3'b000};
                end
                FLW_ope1    :   begin
                    exponentrd_ope2 <= {2'b00, dataCPU_Load[30:23]};
                    signrd_ope2     <= dataCPU_Load[31];
                    mantissard_ope2 <= {27'd0, 1'b1, dataCPU_Load[22:0 ], 3'b000};   
                    if(!dataCPU_Lvalid) NOR1en <= 0;
                end
            endcase

            //Instruction
            FADD_ope2        <= FADD_ope1;
            FSUB_ope2        <= FSUB_ope1;
            FMUL_ope2        <= FMUL_ope1;
            FDIV_ope2        <= FDIV_ope1;
            FSQRT_ope2       <= FSQRT_ope1;
            FSGNJ_ope2       <= FSGNJ_ope1;
            FSGNJN_ope2      <= FSGNJN_ope1;
            FSGNJX_ope2      <= FSGNJX_ope1;
            FMIN_ope2        <= FMIN_ope1;
            FMAX_ope2        <= FMAX_ope1;
            FCVTWS_ope2      <= FCVTWS_ope1;
            FCVTWUS_ope2     <= FCVTWUS_ope1;
            FMVXW_ope2       <= FMVXW_ope1;
            FEQ_ope2         <= FEQ_ope1;
            FLT_ope2         <= FLT_ope1;
            FLE_ope2         <= FLE_ope1;
            FCLASS_ope2      <= FCLASS_ope1;
            FCVTSW_ope2      <= FCVTSW_ope1;
            FCVTSWU_ope2     <= FCVTSWU_ope1;
            FMVWX_ope2       <= FMVWX_ope1;
            FLW_ope2         <= FLW_ope1;

            FMADD_ope2       <= FMADD_ope1;
            FNMADD_ope2      <= FNMADD_ope1;
            FMSUB_ope2       <= FMSUB_ope1;
            FNMSUB_ope2      <= FNMSUB_ope1;
        end
    end


//--------------------------------------------------NORMALIZE1---------------------------------------------//
    reg         FADD_nor1        = 0;
    reg         FSUB_nor1        = 0;
    reg         FMUL_nor1        = 0;
    reg         FDIV_nor1        = 0;
    reg         FSQRT_nor1       = 0;
    reg         FSGNJ_nor1       = 0;
    reg         FSGNJN_nor1      = 0;
    reg         FSGNJX_nor1      = 0;
    reg         FMIN_nor1        = 0;
    reg         FMAX_nor1        = 0;
    reg         FCVTWS_nor1      = 0;
    reg         FCVTWUS_nor1     = 0;
    reg         FMVXW_nor1       = 0;
    reg         FEQ_nor1         = 0;
    reg         FLT_nor1         = 0;
    reg         FLE_nor1         = 0;
    reg         FCLASS_nor1      = 0;
    reg         FCVTSW_nor1      = 0;
    reg         FCVTSWU_nor1     = 0;
    reg         FMVWX_nor1       = 0;
    reg         FLW_nor1         = 0;

    reg         FMADD_nor1       = 0;
    reg         FNMADD_nor1      = 0;
    reg         FMSUB_nor1       = 0;
    reg         FNMSUB_nor1      = 0;

    reg         signrd_nor1      = 0;
    reg signed  [ 9:0 ] exponentrd_nor1  = 0;
    reg [80:0 ] mantissard_nor1  = 0; 

    reg [ 7:0 ] expskewaccplus_nor1 = 0; 
    reg [ 7:0 ] expskewacc_nor1  = 0;
    reg [ 3:0 ] expskewacc_nor1c = 0;   
    reg [ 7:0 ] expskewaccsub_nor1  = 0; 
    reg         expskewen_nor1   = 0;
    

    reg         frd_en_nor1      = 0;
    reg [ 4:0 ] fregrd_nor1      = 0; 
    reg [ 4:0 ] fregrs1_nor1     = 0; 
    reg [ 4:0 ] fregrs2_nor1     = 0; 
    reg [ 4:0 ] fregrs3_nor1     = 0; 
    reg [ 4:0 ] shift_total      = 0;
    reg         shift_left_flag  = 0;
    reg         NoNor_nor1       = 0;

    always @(posedge clk) begin
        if(!rst||!NOR1en) begin
            NOR2en <= 0;
            fregrd_nor1  <= 0;
            fregrs1_nor1 <= 0;
            fregrs2_nor1 <= 0;
            fregrs3_nor1 <= 0;
            frd_en_nor1  <= 0;
        end
        else begin
            signrd_nor1 <= signrd_ope2;
            exponentrd_nor1 <= exponentrd_ope2;
            mantissard_nor1 <= {26'b0, mantissard_ope2};
            frd_en_nor1 <= frd_en_ope2;
            fregrd_nor1 <= fregrd_ope2;
            fregrs1_nor1<= fregrs1_ope2;
            fregrs2_nor1<= fregrs2_ope2;
            fregrs3_nor1<= fregrs3_ope2;

            expskewaccplus_nor1 <= expskewacc_ope2 + 53;
            expskewacc_nor1 <= expskewacc_ope2 + 52;
            expskewacc_nor1c <= expskewacc_ope2;
            expskewaccsub_nor1  <= expskewacc_ope2 + 51;
            expskewen_nor1  <= |expskewacc_ope2;

            if(mantissafrs3_ope2 > mantissard_ope2) begin
                if(signfrs3_ope2 != signrd_ope2) begin
                    if(FMADD_ope2 || FNMADD_ope2) begin
                        mantissard_nor1 <= $unsigned(mantissafrs3_ope2) - $unsigned(mantissard_ope2);
                        signrd_nor1 <= (FMADD_ope2)?signfrs3_ope2:!signfrs3_ope2;
                    end
                    else if(FNMSUB_ope2 || FMSUB_ope2) begin
                        mantissard_nor1 <= $unsigned(mantissafrs3_ope2) + $unsigned(mantissard_ope2);
                        signrd_nor1 <= (FNMSUB_ope2)?signfrs3_ope2:!signfrs3_ope2;
                    end
                end
                else begin
                    if(FMADD_ope2 || FNMADD_ope2) begin
                        mantissard_nor1 <= $unsigned(mantissafrs3_ope2) + $unsigned(mantissard_ope2);
                        signrd_nor1 <= (FMADD_ope2)?signfrs3_ope2:!signfrs3_ope2;
                    end
                    else if(FNMSUB_ope2 || FMSUB_ope2) begin
                        mantissard_nor1 <= $unsigned(mantissafrs3_ope2) - $unsigned(mantissard_ope2);
                        signrd_nor1 <= (FNMSUB_ope2)?signfrs3_ope2:!signfrs3_ope2;
                    end
                end
            end
            else begin
                if(signfrs3_ope2 != signrd_ope2) begin
                    if(FMADD_ope2 || FNMADD_ope2) begin
                        mantissard_nor1 <=-$unsigned(mantissafrs3_ope2) + $unsigned(mantissard_ope2);
                        signrd_nor1 <= (FMADD_ope2)?!signfrs3_ope2:signfrs3_ope2;
                    end
                    else if(FNMSUB_ope2 || FMSUB_ope2) begin
                        mantissard_nor1 <= $unsigned(mantissafrs3_ope2) + $unsigned(mantissard_ope2);
                        signrd_nor1 <= (FNMSUB_ope2)?signfrs3_ope2:!signfrs3_ope2;
                    end
                end
                else begin
                    if(FMADD_ope2 || FNMADD_ope2) begin
                        mantissard_nor1 <= $unsigned(mantissafrs3_ope2) + $unsigned(mantissard_ope2);
                        signrd_nor1 <= (FMADD_ope2)?signfrs3_ope2:!signfrs3_ope2;
                    end
                    else if(FNMADD_ope2 || FMSUB_ope2) begin
                        mantissard_nor1 <=-$unsigned(mantissafrs3_ope2) + $unsigned(mantissard_ope2);
                        signrd_nor1 <= (FMSUB_ope2)?signrd_ope2:!signrd_ope2;
                    end
                end
            end

            shift_left_flag <= 1;
            case(1'b1)
                mantissard_ope2[27] :   begin
                    shift_total <= 1;
                    shift_left_flag <= 0;//shift right
                end
                mantissard_ope2[26]: shift_total <= 0;
                mantissard_ope2[25]: shift_total <= 1;
                mantissard_ope2[24]: shift_total <= 2;
                mantissard_ope2[23]: shift_total <= 3;
                mantissard_ope2[22]: shift_total <= 4;
                mantissard_ope2[21]: shift_total <= 5;
                mantissard_ope2[20]: shift_total <= 6;
                mantissard_ope2[19]: shift_total <= 7;
                mantissard_ope2[18]: shift_total <= 8;
                mantissard_ope2[17]: shift_total <= 9;
                mantissard_ope2[16]: shift_total <= 10;
                mantissard_ope2[15]: shift_total <= 11;
                mantissard_ope2[14]: shift_total <= 12;
                mantissard_ope2[13]: shift_total <= 13;
                mantissard_ope2[12]: shift_total <= 14;
                mantissard_ope2[11]: shift_total <= 15;
                mantissard_ope2[10]: shift_total <= 16;
                mantissard_ope2[9 ]: shift_total <= 17;
                mantissard_ope2[8 ]: shift_total <= 18;
                mantissard_ope2[7 ]: shift_total <= 19;
                mantissard_ope2[6 ]: shift_total <= 20;
                mantissard_ope2[5 ]: shift_total <= 21;
                mantissard_ope2[4 ]: shift_total <= 22;
                mantissard_ope2[3 ]: shift_total <= 23;
                mantissard_ope2[2 ]: shift_total <= 24;
                mantissard_ope2[1 ]: shift_total <= 25;
                mantissard_ope2[0 ]: shift_total <= 26;
                default            : shift_total <= 0;
            endcase

            //Nếu thuộc trường hợp ngoại lẹ
            NoNor_nor1 <= 0;
            if(NoNor_ope) begin
                signrd_nor1 <= signrd_ope2;
                exponentrd_nor1 <= exponentrd_ope2;
                mantissard_nor1 <= {26'b0, mantissard_ope2};
                NoNor_nor1 <= 1;
            end

            

            // instruction
            FADD_nor1        <= FADD_ope2;
            FSUB_nor1        <= FSUB_ope2;
            FMUL_nor1        <= FMUL_ope2;
            FDIV_nor1        <= FDIV_ope2;
            FSQRT_nor1       <= FSQRT_ope2;
            FSGNJ_nor1       <= FSGNJ_ope2;
            FSGNJN_nor1      <= FSGNJN_ope2;
            FSGNJX_nor1      <= FSGNJX_ope2;
            FMIN_nor1        <= FMIN_ope2;
            FMAX_nor1        <= FMAX_ope2;
            FCVTWS_nor1      <= FCVTWS_ope2;
            FCVTWUS_nor1     <= FCVTWUS_ope2;
            FMVXW_nor1       <= FMVXW_ope2;
            FEQ_nor1         <= FEQ_ope2;
            FLT_nor1         <= FLT_ope2;
            FLE_nor1         <= FLE_ope2;
            FCLASS_nor1      <= FCLASS_ope2;
            FCVTSW_nor1      <= FCVTSW_ope2;
            FCVTSWU_nor1     <= FCVTSWU_ope2;
            FMVWX_nor1       <= FMVWX_ope2;
            FLW_nor1         <= FLW_ope2;
            
            FMADD_nor1       <= FMADD_ope2;
            FNMADD_nor1      <= FNMADD_ope2;
            FMSUB_nor1       <= FMSUB_ope2;
            FNMSUB_nor1      <= FNMSUB_ope2;

            //pipeline
            NOR2en <= 1;
        end
    end


//--------------------------------------------------NORMALIZE2---------------------------------------------//
    reg         FADD_nor2        = 0;
    reg         FSUB_nor2        = 0;
    reg         FMUL_nor2        = 0;
    reg         FDIV_nor2        = 0;
    reg         FSQRT_nor2       = 0;
    reg         FSGNJ_nor2       = 0;
    reg         FSGNJN_nor2      = 0;
    reg         FSGNJX_nor2      = 0;
    reg         FMIN_nor2        = 0;
    reg         FMAX_nor2        = 0;
    reg         FCVTWS_nor2      = 0;
    reg         FCVTWUS_nor2     = 0;
    reg         FMVXW_nor2       = 0;
    reg         FEQ_nor2         = 0;
    reg         FLT_nor2         = 0;
    reg         FLE_nor2         = 0;
    reg         FCLASS_nor2      = 0;
    reg         FCVTSW_nor2      = 0;
    reg         FCVTSWU_nor2     = 0;
    reg         FMVWX_nor2       = 0;
    reg         FLW_nor2         = 0;

    reg         FMADD_nor2       = 0;
    reg         FNMADD_nor2      = 0;
    reg         FMSUB_nor2       = 0;
    reg         FNMSUB_nor2      = 0;
    
    reg         signrd_nor2      = 0;
    reg signed [ 9:0 ] exponentrd_nor2  = 0;
    reg [53:0 ] mantissard_nor2  = 0; 
    
    reg         frd_en_nor2      = 0;
    reg [ 4:0 ] fregrd_nor2      = 0; 
    reg [ 4:0 ] fregrs1_nor2     = 0; 
    reg [ 4:0 ] fregrs2_nor2     = 0; 
    reg [ 4:0 ] fregrs3_nor2     = 0; 
    
    reg         fdatardZero_nor2 = 0;
    reg         fdatardInf_nor2  = 0;
    

    wire[80:0 ] tmp_shiftplus    = mantissard_nor1 >> (expskewaccplus_nor1 - 26);    
    wire[80:0 ] tmp_shift        = mantissard_nor1 >> (expskewacc_nor1 - 26); 
    wire[80:0 ] tmp_shiftsub     = mantissard_nor1 >> (expskewaccsub_nor1 - 26); 

    always @(posedge clk) begin
        if(!rst||!NOR2en) begin
            RAW1en <= 0;
            fregrd_nor2  <= 0;
            fregrs1_nor2 <= 0;
            fregrs2_nor2 <= 0;
            fregrs3_nor2 <= 0;
            frd_en_nor2  <= 0;
        end
        else begin
            signrd_nor2 <= signrd_nor1;
            mantissard_nor2 <= mantissard_nor1;
            exponentrd_nor2 <= exponentrd_nor1;
            frd_en_nor2 <= frd_en_nor1;
            fregrd_nor2 <= fregrd_nor1;
            fregrs1_nor2<= fregrs1_nor1;
            fregrs2_nor2<= fregrs2_nor1;
            fregrs3_nor2<= fregrs3_nor1;

            case(1'b1)
                FMUL_nor1   :   begin
                    if(mantissard_nor1[53]) begin
                        mantissard_nor2 <= {27'd0, mantissard_nor1[53:27]};
                        exponentrd_nor2 <= exponentrd_nor1 + 1;

//                        if(exponentrd_nor1[7:0] == 8'hff) begin //-->infinity
//                            exponentrd_nor2 <= exponentrd_nor1;
//                            mantissard_nor2 <= 0;
//                        end
                    end
                    else begin
                        mantissard_nor2 <= {27'd0, mantissard_nor1[52:26]};
                        exponentrd_nor2 <= exponentrd_nor1;
                    end
                end
                FMADD_nor1||FNMADD_nor1||
                FMSUB_nor1||FNMSUB_nor1:    begin
                    case(1'b1)
                        mantissard_nor1[54] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[54:28]};
                            exponentrd_nor2 <= exponentrd_nor1 + 2;
                        end
                        mantissard_nor1[53] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[53:27]};
                            exponentrd_nor2 <= exponentrd_nor1 + 1;
                        end
                        mantissard_nor1[52] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[52:26]};
                            exponentrd_nor2 <= exponentrd_nor1;
                        end
                        mantissard_nor1[51] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[51:25]};
                            exponentrd_nor2 <= exponentrd_nor1 - 1;
                        end
                        mantissard_nor1[50] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[50:24]};
                            exponentrd_nor2 <= exponentrd_nor1 - 2;
                        end
                        mantissard_nor1[49] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[49:23]};
                            exponentrd_nor2 <= exponentrd_nor1 - 3;
                        end
                        mantissard_nor1[48] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[48:22]};
                            exponentrd_nor2 <= exponentrd_nor1 - 4;
                        end
                        mantissard_nor1[47] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[47:21]};
                            exponentrd_nor2 <= exponentrd_nor1 - 5;
                        end
                        mantissard_nor1[46] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[46:20]};
                            exponentrd_nor2 <= exponentrd_nor1 - 6;
                        end
                        mantissard_nor1[45] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[45:19]};
                            exponentrd_nor2 <= exponentrd_nor1 - 7;
                        end
                        mantissard_nor1[44] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[44:18]};
                            exponentrd_nor2 <= exponentrd_nor1 - 8;
                        end
                        mantissard_nor1[43] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[43:17]};
                            exponentrd_nor2 <= exponentrd_nor1 - 9;
                        end
                        mantissard_nor1[42] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[42:16]};
                            exponentrd_nor2 <= exponentrd_nor1 - 10;
                        end
                        mantissard_nor1[41] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[41:15]};
                            exponentrd_nor2 <= exponentrd_nor1 - 11;
                        end
                        mantissard_nor1[40] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[40:14]};
                            exponentrd_nor2 <= exponentrd_nor1 - 12;
                        end
                        mantissard_nor1[39] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[39:13]};
                            exponentrd_nor2 <= exponentrd_nor1 - 13;
                        end
                        mantissard_nor1[38] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[38:12]};
                            exponentrd_nor2 <= exponentrd_nor1 - 14;
                        end
                        mantissard_nor1[37] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[37:11]};
                            exponentrd_nor2 <= exponentrd_nor1 - 15;
                        end
                        mantissard_nor1[36] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[36:10]};
                            exponentrd_nor2 <= exponentrd_nor1 - 16;
                        end
                        mantissard_nor1[35] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[35:9]};
                            exponentrd_nor2 <= exponentrd_nor1 - 17;
                        end
                        mantissard_nor1[34] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[34:8]};
                            exponentrd_nor2 <= exponentrd_nor1 - 18;
                        end
                        mantissard_nor1[33] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[33:7]};
                            exponentrd_nor2 <= exponentrd_nor1 - 19;
                        end
                        mantissard_nor1[32] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[32:6]};
                            exponentrd_nor2 <= exponentrd_nor1 - 20;
                        end
                        mantissard_nor1[31] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[31:5]};
                            exponentrd_nor2 <= exponentrd_nor1 - 21;
                        end
                        mantissard_nor1[30] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[30:4]};
                            exponentrd_nor2 <= exponentrd_nor1 - 22;
                        end
                        mantissard_nor1[29] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[29:3]};
                            exponentrd_nor2 <= exponentrd_nor1 - 23;
                        end
                        mantissard_nor1[28] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[28:2]};
                            exponentrd_nor2 <= exponentrd_nor1 - 24;
                        end
                        mantissard_nor1[27] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[27:1]};
                            exponentrd_nor2 <= exponentrd_nor1 - 25;
                        end
                        mantissard_nor1[26] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[26:0]};
                            exponentrd_nor2 <= exponentrd_nor1 - 26;
                        end
                        mantissard_nor1[25] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[25:0], 1'b0};
                            exponentrd_nor2 <= exponentrd_nor1 - 27;
                        end
                        mantissard_nor1[24] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[24:0], 2'b0};
                            exponentrd_nor2 <= exponentrd_nor1 - 28;
                        end
                        mantissard_nor1[23] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[23:0], 3'b0};
                            exponentrd_nor2 <= exponentrd_nor1 - 29;
                        end
                        mantissard_nor1[22] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[22:0], 4'b0};
                            exponentrd_nor2 <= exponentrd_nor1 - 30;
                        end
                        mantissard_nor1[21] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[21:0], 5'b0};
                            exponentrd_nor2 <= exponentrd_nor1 - 31;
                        end
                        mantissard_nor1[20] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[20:0], 6'b0};
                            exponentrd_nor2 <= exponentrd_nor1 - 32;
                        end
                        mantissard_nor1[19] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[19:0], 7'b0};
                            exponentrd_nor2 <= exponentrd_nor1 - 33;
                        end
                        mantissard_nor1[18] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[18:0], 8'b0};
                            exponentrd_nor2 <= exponentrd_nor1 - 34;
                        end
                        mantissard_nor1[17] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[17:0], 9'b0};
                            exponentrd_nor2 <= exponentrd_nor1 - 35;
                        end
                        mantissard_nor1[16] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[16:0], 10'b0};
                            exponentrd_nor2 <= exponentrd_nor1 - 36;
                        end
                        mantissard_nor1[15] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[15:0], 11'b0};
                            exponentrd_nor2 <= exponentrd_nor1 - 37;
                        end
                        mantissard_nor1[14] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[14:0], 12'b0};
                            exponentrd_nor2 <= exponentrd_nor1 - 38;
                        end
                        mantissard_nor1[13] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[13:0], 13'b0};
                            exponentrd_nor2 <= exponentrd_nor1 - 39;
                        end
                        mantissard_nor1[12] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[12:0], 14'b0};
                            exponentrd_nor2 <= exponentrd_nor1 - 40;
                        end
                        mantissard_nor1[11] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[11:0], 15'b0};
                            exponentrd_nor2 <= exponentrd_nor1 - 41;
                        end
                        mantissard_nor1[10] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[10:0], 16'b0};
                            exponentrd_nor2 <= exponentrd_nor1 - 42;
                        end
                        mantissard_nor1[9] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[9:0], 17'b0};
                            exponentrd_nor2 <= exponentrd_nor1 - 43;
                        end
                        mantissard_nor1[8] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[8:0], 18'b0};
                            exponentrd_nor2 <= exponentrd_nor1 - 44;
                        end
                        mantissard_nor1[7] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[7:0], 19'b0};
                            exponentrd_nor2 <= exponentrd_nor1 - 45;
                        end
                        mantissard_nor1[6] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[6:0], 20'b0};
                            exponentrd_nor2 <= exponentrd_nor1 - 46;
                        end
                        mantissard_nor1[5] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[5:0], 21'b0};
                            exponentrd_nor2 <= exponentrd_nor1 - 47;
                        end
                        mantissard_nor1[4] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[4:0], 22'b0};
                            exponentrd_nor2 <= exponentrd_nor1 - 48;
                        end
                        mantissard_nor1[3] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[3:0], 23'b0};
                            exponentrd_nor2 <= exponentrd_nor1 - 49;
                        end
                        mantissard_nor1[2] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[2:0], 24'b0};
                            exponentrd_nor2 <= exponentrd_nor1 - 50;
                        end
                        mantissard_nor1[1] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[1:0], 25'b0};
                            exponentrd_nor2 <= exponentrd_nor1 - 51;
                        end
                        mantissard_nor1[0] : begin
                            mantissard_nor2 <= {27'd0, mantissard_nor1[0], 26'b0};
                            exponentrd_nor2 <= exponentrd_nor1 - 52;
                        end
                        default            : begin  //Mantissa = 0 -> zero
                            mantissard_nor2 <= 0;
                            exponentrd_nor2 <= 0;
                        end
                    endcase

                    if(expskewen_nor1) begin
                        if(mantissard_nor1[expskewaccplus_nor1]) begin
                            mantissard_nor2 <= {27'd0, tmp_shiftplus[26:0]};
                            exponentrd_nor2 <= exponentrd_nor1 + expskewacc_nor1c + 1;
                        end
                        else if(mantissard_nor1[expskewacc_nor1]) begin
                            mantissard_nor2 <= {27'd0, tmp_shift[26:0]};
                            exponentrd_nor2 <= exponentrd_nor1 + expskewacc_nor1c;
                        end
                        else if(mantissard_nor1[expskewaccsub_nor1]) begin
                            mantissard_nor2 <= {27'd0, tmp_shiftsub[26:0]};
                            exponentrd_nor2 <= exponentrd_nor1 + expskewacc_nor1c - 1;
                        end
                    end
                end
                FADD_nor1||FSUB_nor1||
                FSGNJN_nor1||FSGNJ_nor1||FSGNJX_nor1||
                FMAX_nor1||FMIN_nor1:   begin
                    if(shift_left_flag) begin
                        mantissard_nor2 <= mantissard_nor1 << shift_total;
                        exponentrd_nor2 <= exponentrd_nor1 - shift_total;
                    end
                    else begin
                        mantissard_nor2 <= mantissard_nor1 >> 1;
                        exponentrd_nor2 <= exponentrd_nor1 + 1;
                    end
                
//                    if(shift_left_flag && (exponentrd_nor1 < shift_total)) begin //--> subnormal number
//                        exponentrd_nor2 <= 0;
//                        mantissard_nor2 <= mantissard_nor1 << (shift_total - exponentrd_nor1[4:0]);
//                    end

//                    if(!shift_left_flag && (exponentrd_nor1[7:0] == 8'hff)) begin //--> infinity
//                        exponentrd_nor2 <= exponentrd_nor1;
//                        mantissard_nor2 <= 0;
//                    end
                end
            endcase

            //Nếu thuộc trường hợp ngoại lệ
            if(NoNor_nor1) begin
                signrd_nor2 <= signrd_nor1;
                mantissard_nor2 <= mantissard_nor1;
                exponentrd_nor2 <= exponentrd_nor1;
            end
            

            //Instruction
            FADD_nor2        <= FADD_nor1;
            FSUB_nor2        <= FSUB_nor1;
            FMUL_nor2        <= FMUL_nor1;
            FDIV_nor2        <= FDIV_nor1;
            FSQRT_nor2       <= FSQRT_nor1;
            FSGNJ_nor2       <= FSGNJ_nor1;
            FSGNJN_nor2      <= FSGNJN_nor1;
            FSGNJX_nor2      <= FSGNJX_nor1;
            FMIN_nor2        <= FMIN_nor1;
            FMAX_nor2        <= FMAX_nor1;
            FCVTWS_nor2      <= FCVTWS_nor1;
            FCVTWUS_nor2     <= FCVTWUS_nor1;
            FMVXW_nor2       <= FMVXW_nor1;
            FEQ_nor2         <= FEQ_nor1;
            FLT_nor2         <= FLT_nor1;
            FLE_nor2         <= FLE_nor1;
            FCLASS_nor2      <= FCLASS_nor1;
            FCVTSW_nor2      <= FCVTSW_nor1;
            FCVTSWU_nor2     <= FCVTSWU_nor1;
            FMVWX_nor2       <= FMVWX_nor1;
            FLW_nor2         <= FLW_nor1;

            FMADD_nor2       <= FMADD_nor1;
            FNMADD_nor2      <= FNMADD_nor1;
            FMSUB_nor2       <= FMSUB_nor1;
            FNMSUB_nor2      <= FNMSUB_nor1;

            RAW1en <= 1;
        end
    end


//--------------------------------------------------ROUND and WRITE BACK---------------------------------------------//
//    reg [31:0 ] fw_data     =   32'd0;
//    reg         fw_valid    =   1'b0;
//    reg [ 4:0 ] fregrd_plwb   = 0;
    reg [ 4:0 ] fregrs1_wb  = 0;
    reg [ 4:0 ] fregrs2_wb  = 0;
    reg [ 4:0 ] fregrs3_wb  = 0;
    
    reg         frd_en_wb   = 0;

    always @(posedge clk) begin
        if(!rst||!RAW1en) begin
            fw_data <= 32'd0;
            fregrd_plwb <= 0;
            fw_valid <= 1'b0;
            fregrs1_wb <= 0;
            fregrs2_wb <= 0;
            fregrs3_wb <= 0;
            frd_en_wb  <= 0;
        end
        else begin                
            fregrs1_wb  <= fregrs1_nor2;
            fregrs2_wb  <= fregrs2_nor2;
            fregrs3_wb  <= fregrs3_nor2;   
            if(frd_en_nor2 && !FDIV_nor2 && !FSQRT_nor2) begin
                fw_data     <= {signrd_nor2, exponentrd_nor2[7:0], mantissard_nor2[25:3]};
                if(exponentrd_nor2[9]) begin    //Out of range exp < 0 -> 0
                    fw_data <= {signrd_nor2, 8'd0, 23'd0};
                end
                else if(exponentrd_nor2[8]) begin   //Out of range exp > 255 -> Infinity
                    fw_data <= {signrd_nor2, 8'hff, 23'd0};
                end
                fregrd_plwb <= fregrd_nor2;
                fw_valid <= 1'b1;
                frd_en_wb <= 1;
            end
            else begin
                fw_data     <= 32'b0;
                fregrd_plwb   <= 5'b0;
                fw_valid    <= 1'b0;
                frd_en_wb <= 0;
            end
        end
    end

//    reg     hazard_1cyc_ff =   0;
//    always @(posedge clk) hazard_1cyc_ff <= hazard_1cyc;
    reg     [ 3:0 ] pause_cnt_ff = 0;
    always @(posedge clk) pause_cnt_ff <= pause_cnt;
    assign  hazard_1cyc =   ((fregrd_pre     == fregrs1 && frs1_en && frd_en_pre ) || (fregrd_pre   == fregrs2 && frs2_en && frd_en_pre ) || (fregrd_pre   == fregrs3 && frs3_en && frd_en_pre )) && (FPU_en || (!FSW_enperi && FSW)) && rst && !(|pause_cnt_ff) && !DecodeNotValid;
    assign  hazard_2cyc =   ((fregrd_ali2    == fregrs1 && frs1_en && frd_en_ali2) || (fregrd_ali2  == fregrs2 && frs2_en && frd_en_ali2) || (fregrd_ali2  == fregrs3 && frs3_en && frd_en_ali2)) && ALI2en && !DecodeNotValid;
    assign  hazard_3cyc =   ((fregrd_ope1    == fregrs1 && frs1_en && frd_en_ope1) || (fregrd_ope1  == fregrs2 && frs2_en && frd_en_ope1) || (fregrd_ope1  == fregrs3 && frs3_en && frd_en_ope1)) && OPE1en && !DecodeNotValid;
    assign  hazard_4cyc =   ((fregrd_ope2    == fregrs1 && frs1_en && frd_en_ope2) || (fregrd_ope2  == fregrs2 && frs2_en && frd_en_ope2) || (fregrd_ope2  == fregrs3 && frs3_en && frd_en_ope2)) && OPE2en && !DecodeNotValid;
    assign  hazard_5cyc =   ((fregrd_nor1    == fregrs1 && frs1_en && frd_en_nor1) || (fregrd_nor1  == fregrs2 && frs2_en && frd_en_nor1) || (fregrd_nor1  == fregrs3 && frs3_en && frd_en_nor1)) && NOR1en && !DecodeNotValid;
    assign  hazard_6cyc =   ((fregrd_nor2    == fregrs1 && frs1_en && frd_en_nor2) || (fregrd_nor2  == fregrs2 && frs2_en && frd_en_nor2) || (fregrd_nor2  == fregrs3 && frs3_en && frd_en_nor2)) && NOR2en && !DecodeNotValid;
    assign  hazard_7cyc =   ((fregrd_plwb    == fregrs1 && frs1_en && frd_en_wb  ) || (fregrd_plwb  == fregrs2 && frs2_en && frd_en_wb  ) || (fregrd_plwb  == fregrs3 && frs3_en && frd_en_wb  )) && RAW1en && !DecodeNotValid;


//---------------------------------------------------------------------------------------------------------//
//------------------------------------------FPU mode2 - Combination----------------------------------------//
//---------------------------------------------------------------------------------------------------------//
/*
In FPU Mode 2, instructions such as FMVXW, FCVTWS, and FCVTWUS are executed in a combinational manner rather
than through a pipeline. These operations directly interact with the CPU, producing results immediately within
a single cycle. This mode is suitable for instructions that require fast conversion or data transfer between
the CPU and floating-point registers without the latency introduced by a multi-stage pipeline.
*/
    reg [31:0 ]     CVT_data    = 0;
    reg             f_eq        = 0;
    reg             f_lt        = 0;
    reg             f_le        = 0;
    reg [ 9:0 ]     fclass      = 0;

    assign          FPU_fdatars1    = fdata_rs1;
    assign          FPU_outputCVT   = CVT_data;
    assign          f_isEQ          = f_eq;
    assign          f_isLT          = f_lt;
    assign          f_isLE          = f_le;
    assign          f_class         = fclass;

//--------------------------------------------------Convert------------------------------------------------//
    reg             sign        = 0;
    reg     [ 7:0 ] exp         = 0;
    reg     [54:0 ] mant        = 0;
    reg     [55:0 ] shifted     = 0;
    
always @(*) begin
    if (!rst) begin
        CVT_data = 32'b0;
        sign = 0;
        exp = 0;
        mant = 0;
        shifted = 0;
    end
    else begin
        sign  = fdata_rs1[31];
        exp   = fdata_rs1[30:23];
        mant = {31'd0, 1'b1, fdata_rs1[22:0]};
        shifted = 0;
        CVT_data = 0;
       

        // ================= UNDERFLOW: |x| < 1 =================
        if (exp < 127) begin
            if(exp == 126) begin
                if(FCVTWS)  CVT_data = 32'd0;//-1
                else begin
                    if(sign)CVT_data = 32'd0;
                    else    CVT_data = 32'd0;
                end
            end
        end

        // ================= OVERFLOW =================
        else if (exp >= 158 && !(exp == 158 && FCVTWUS && !sign)) begin
            if (FCVTWUS) begin                   // unsigned
                if (sign)   CVT_data = 32'd0;      // âm → saturate 0
                else        CVT_data = 32'hFFFF_FFFF;
            end
            else begin                           // signed
                if (sign)   CVT_data = 32'h8000_0000; // min int32
                else        CVT_data = 32'h7FFF_FFFF; // max int32
            end
                
            if((&exp) && (|fdata_rs1[22:0]))   //NaN
                if(FCVTWUS) CVT_data = 32'hFFFF_FFFF;
                else        CVT_data = 32'h7FFF_FFFF;
        end

        // ================= NORMAL CASE =================
        else begin
            // tính shift
            shifted = mant << (exp - 127);

            // unsigned convert
            if (FCVTWUS) begin
                if (sign) CVT_data = 32'd0;     // negative clamp 0
                else      CVT_data =    shifted[54:23];
            end

            // signed convert
            else begin
                if (sign) CVT_data =   -shifted[54:23];
                else      CVT_data =    shifted[54:23];
            end
        end
    end
end

//--------------------------------------------------Compare------------------------------------------------//
always @(*) begin
    if(!rst) begin
        f_eq = 0;
        f_lt = 0;
        f_le = 0;
    end
    else begin
        // kiểm tra NaN: nếu có NaN, tất cả cờ = 0
        if((fdata_rs1[30:23] == 8'hFF && (|fdata_rs1[22:0])) || 
           (fdata_rs2[30:23] == 8'hFF && (|fdata_rs2[22:0]))) begin
            f_eq = 0;
            f_lt = 0;
            f_le = 0;
        end
        else begin
            f_eq = ((fdata_rs1 == fdata_rs2) || (fdata_rs1[30:0] == fdata_rs2[30:0] && !(|fdata_rs1[30:0])));

            if(fdata_rs1[31] != fdata_rs2[31])  f_lt = (fdata_rs1[31] == 1'b1); // rs1 âm < rs2 dương
            else if(fdata_rs1[31] == 1'b0)      f_lt = (fdata_rs1[30:0] < fdata_rs2[30:0]);
            else                                f_lt = (fdata_rs1[30:0] > fdata_rs2[30:0]);

            f_le = f_eq | f_lt;
        end
    end
end
//---------------------------------------------------CLASS-----------------------------------------------//
always @(*) begin
    if(!rst) begin
        fclass = 10'b0;
    end
    else begin
        fclass = 10'b0;

        if((fdata_rs1[30:23] == 8'hFF) && |fdata_rs1[22:0])                //NaN
            if(fdata_rs1[22])   fclass[9] = 1'b1;
            else                fclass[8] = 1'b1;
        else begin
            if((fdata_rs1[30:23] == 8'hFF) && (fdata_rs1[22:0]==0)) begin  // +∞ / -∞
                if(fdata_rs1[31]==0) fclass[7] = 1'b1; // +∞
                else fclass[0] = 1'b1;                 // -∞
            end
            else if(fdata_rs1[30:23] != 0) begin                            // normalized
                if(fdata_rs1[31]==0) fclass[6] = 1'b1; // +normal
                else fclass[1] = 1'b1;                 // -normal
            end
            else if(fdata_rs1[30:23]==0 && fdata_rs1[22:0]!=0) begin        // subnormal
                if(fdata_rs1[31]==0) fclass[5] = 1'b1; // +subnormal
                else fclass[2] = 1'b1;                 // -subnormal
            end     
            else if(fdata_rs1[30:0]==0) begin                               // zero
                if(fdata_rs1[31]==0) fclass[4] = 1'b1; // +0
                else fclass[3] = 1'b1;                 // -0
            end
        end
    end
end
    

//---------------------------------------------------------------------------------------------------------//
//----------------------------------FPU mode3 - Long-Latency Non-Pipelined---------------------------------//
//---------------------------------------------------------------------------------------------------------//
/*
FPU Mode 3 handles instructions such as FDIV and FSQRT, which are executed over multiple cycles without using
a pipeline. These operations require iterative computation due to their complexity, and the FPU does not start 
a new instruction until the current operation is completed. This mode ensures correct results for long-latency 
operations like division and square root, where intermediate stages must be fully resolved before writing back 
to the destination register.
*/


//-------------------------------------------------DIV-----------------------------------------------------//
                                        //20 cyc per instruction//
    localparam  FINDX0_1    =   0;
    localparam  FINDX0_2    =   1;
    localparam  LOOPNR_1    =   2;
    localparam  LOOPNR_2    =   3;
    localparam  LOOPNR_3    =   4;
    localparam  LOOPNR_4    =   5;
    localparam  LOOPNR_5    =   6;
    localparam  LOOPNR_6    =   7;
    localparam  LOOPNR_7    =   8;
    localparam  LOOPNR_8    =   9;  
    localparam  MULFN1       =   10;
    localparam  MULFN2       =   11;
    localparam  MULFN3       =   12;
    localparam  MULFN4       =   13;
    localparam  WRITEBACK    =   14;

    reg [31:0 ]     DIV_result  = 0;
    reg [ 4:0 ]     DIV_state   = 0;

    reg             DIV_signrs1 = 0;
    reg             DIV_signrs2 = 0;
    reg [ 7:0 ]     DIV_exprs1  = 0;
    reg [ 7:0 ]     DIV_exprs2  = 0;
    reg [26:0 ]     DIV_matrs1  = 0;
    reg [26:0 ]     DIV_matrs2  = 0;
    reg         [26:0 ]     DIV_x       = 0;
    reg signed  [55:0 ]     DIV_x1      = 0;
    reg             DIV_foundx  = 0;
    wire[23:0 ]     DIV_matrd_next = DIV_x1[52:29] + DIV_x1[28];
    reg [23:0 ]     DIV_matrd   = 0;
    reg [ 7:0 ]     DIV_exprd   = 0;
    reg             DIV_signrd  = 0;
    
    reg             DIV_doneNR  = 0;    //Done Newton–Raphson (NR)
    reg             DIV_donediv = 0;    //Done DIV

    reg [31:0 ]     DIV_datawb  = 0;
    reg             DIV_datavalid= 0;
    reg [ 4:0 ]     DIV_fregrdwb= 0;

    reg             DIV_shift1  = 0;
    reg             DIV_pause   = 0;
    wire            DIV_rise    = FDIV && !DIV_shift1 && !DecodeNotValid;
    wire            DIV_pausefn = DIV_pause || DIV_rise;
    reg             DIV_wait    = 0;

    reg             DIV_zero    = 0;
    reg             DIV_nan     = 0;
    reg             DIV_inf     = 0;
    reg             DIV_frs1inf = 0;
    reg             DIV_frs2inf = 0;
    reg             DIV_frs1zero= 0;
    reg             DIV_frs2zero= 0;

    reg     [26:0 ] mulinA_DIV;
    reg     [ 2:0 ] mulinB_DIV;
    reg     [ 2:0 ] mulinC_DIV;
    reg     [ 2:0 ] mulinD_DIV;   
    reg     [ 2:0 ] mulinE_DIV;
    reg     [ 2:0 ] mulinF_DIV;
    reg     [ 2:0 ] mulinG_DIV;
    reg     [ 2:0 ] mulinH_DIV; 

    wire signed [55:0 ] res_on_DIV;
    wire signed [55:0 ] res_tw_DIV;
    wire signed [55:0 ] res_th_DIV;
    wire signed [55:0 ] res_fo_DIV;
    wire signed [55:0 ] res_fi_DIV;
    wire signed [55:0 ] res_si_DIV;
    wire signed [55:0 ] res_se_DIV;

    mul_tiny multiny3(   
        .clk        (clk),

        .inA        ({1'b0, mulinA_DIV}),

        .inB        (mulinB_DIV),
        .inC        (mulinC_DIV),
        .inD        (mulinD_DIV),
        .inE        (mulinE_DIV),
        .inF        (mulinF_DIV),
        .inG        (mulinG_DIV),
        .inH        (mulinH_DIV),

        .res_on     (res_on_DIV),
        .res_tw     (res_tw_DIV),
        .res_th     (res_th_DIV),
        .res_fo     (res_fo_DIV),
        .res_fi     (res_fi_DIV),
        .res_si     (res_si_DIV),
        .res_se     (res_se_DIV)
    );

    always @(posedge clk) begin
        if(!rst) begin
            DIV_state <= 0;
            DIV_shift1 <= 0;
            DIV_zero <= 0;
        end
        else begin
            DIV_wait <= 0;
            DIV_shift1 <= FDIV;
            case(DIV_state)
                FINDX0_1:  begin       //khởi động
                    DIV_pause       <= 0;
                    DIV_datavalid   <= 0;
                    DIV_signrs1     <= fdata_rs1[31];
                    DIV_signrs2     <= fdata_rs2[31];
                    DIV_exprs1      <= fdata_rs1[30:23];
                    DIV_exprs2      <= fdata_rs2[30:23];
                    DIV_matrs1      <= {1'b1, fdata_rs1[22:0], 3'b000};
                    DIV_matrs2      <= {1'b1, fdata_rs2[22:0], 3'b000};
                    DIV_foundx      <= 1;
            
                    DIV_zero <= 0;
                    DIV_nan <= 0;
                    DIV_inf <= 0;

                    case(fdata_rs2[22:17])  //6 bit
                        6'b000000:  DIV_x   <=  27'h3f78986;//27'h7EF130B >> 1(*2^-1)
                        6'b000001:  DIV_x   <=  27'h3e80a6b;//27'h7d014d6 >> 1
                        6'b000010:  DIV_x   <=  27'h3d90291;
                        6'b000011:  DIV_x   <=  27'h3ca6cab;
                        6'b000100:  DIV_x   <=  27'h3bc43bc;
                        6'b000101:  DIV_x   <=  27'h3ae8312;
                        6'b000110:  DIV_x   <=  27'h3a1263b;
                        6'b000111:  DIV_x   <=  27'h394290a; 
                        6'b001000:  DIV_x   <=  27'h3878788;
                        6'b001001:  DIV_x   <=  27'h37b3df9;
                        6'b001010:  DIV_x   <=  27'h36f48d1;
                        6'b001011:  DIV_x   <=  27'h363a4b7;
                        6'b001100:  DIV_x   <=  27'h3584e7f;
                        6'b001101:  DIV_x   <=  27'h34d4323;
                        6'b001110:  DIV_x   <=  27'h3427fc9;
                        6'b001111:  DIV_x   <=  27'h33801b8;
                        6'b010000:  DIV_x   <=  27'h32dc65c;
                        6'b010001:  DIV_x   <=  27'h323cb41;
                        6'b010010:  DIV_x   <=  27'h31a0e10;
                        6'b010011:  DIV_x   <=  27'h3108c91;
                        6'b010100:  DIV_x   <=  27'h30744a5;
                        6'b010101:  DIV_x   <=  27'h2fe3447;
                        6'b010110:  DIV_x   <=  27'h2f5598b;
                        6'b010111:  DIV_x   <=  27'h2ecb299;
                        6'b011000:  DIV_x   <=  27'h2e43db0;
                        6'b011001:  DIV_x   <=  27'h2dbf924;
                        6'b011010:  DIV_x   <=  27'h2d3e359;
                        6'b011011:  DIV_x   <=  27'h2cbfac8;
                        6'b011100:  DIV_x   <=  27'h2c43df9;
                        6'b011101:  DIV_x   <=  27'h2bcab85;
                        6'b011110:  DIV_x   <=  27'h2b54214;
                        6'b011111:  DIV_x   <=  27'h2ae005c;
                        default: DIV_foundx <= 0;
                    endcase

                    if(FDIV && !DecodeNotValid) begin
                        if(!DIV_wait && pause_cnt <= 1) DIV_state  <= FINDX0_2;
                        if(!DIV_wait) DIV_pause  <= 1;
                    end
                end
                FINDX0_2:  begin       //Newton-Raphson: x1 = x0 * (2 - B*x0)
                    DIV_doneNR <= 0;
                    case(DIV_matrs2[25:20])  //6 bit
                        6'b100000:   DIV_x   <=  27'h2A6E521;
                        6'b100001:   DIV_x   <=  27'h29FEF34;
                        6'b100010:   DIV_x   <=  27'h2991D72;
                        6'b100011:   DIV_x   <=  27'h2926EC5;
                        6'b100100:   DIV_x   <=  27'h28BE21F;
                        6'b100101:   DIV_x   <=  27'h2857681;
                        6'b100110:   DIV_x   <=  27'h27F2AF2;
                        6'b100111:   DIV_x   <=  27'h278FE84;
                        6'b101000:   DIV_x   <=  27'h272F054;
                        6'b101001:   DIV_x   <=  27'h26CFF84;
                        6'b101010:   DIV_x   <=  27'h2672B41;
                        6'b101011:   DIV_x   <=  27'h26172C0;
                        6'b101100:   DIV_x   <=  27'h25BD53B;
                        6'b101101:   DIV_x   <=  27'h25651F5;
                        6'b101110:   DIV_x   <=  27'h250E839;
                        6'b101111:   DIV_x   <=  27'h24B9756;
                        6'b110000:   DIV_x   <=  27'h2465EA3;
                        6'b110001:   DIV_x   <=  27'h2413D7C;
                        6'b110010:   DIV_x   <=  27'h23C3343;
                        6'b110011:   DIV_x   <=  27'h2373F5F;
                        6'b110100:   DIV_x   <=  27'h232613F;
                        6'b110101:   DIV_x   <=  27'h22D9853;
                        6'b110110:   DIV_x   <=  27'h228E411;
                        6'b110111:   DIV_x   <=  27'h22443F6;
                        6'b111000:   DIV_x   <=  27'h21FB781;
                        6'b111001:   DIV_x   <=  27'h21B3E36;
                        6'b111010:   DIV_x   <=  27'h216D79C;
                        6'b111011:   DIV_x   <=  27'h212833F;
                        6'b111100:   DIV_x   <=  27'h20E40B0;
                        6'b111101:   DIV_x   <=  27'h20A0F80;
                        6'b111110:   DIV_x   <=  27'h205EF47;
                        6'b111111:   DIV_x   <=  27'h201DF9E;
                        default:;
                    endcase
                    if(DIV_foundx) DIV_x <= DIV_x;
                    DIV_state <= LOOPNR_1;
                    if(pause_cnt >= 2) DIV_state <= FINDX0_1;

                    DIV_nan <= (&fdata_rs1[30:23]) && (|fdata_rs1[22:0]) || (&fdata_rs2[30:23]) && (|fdata_rs2[22:0]);
                    DIV_frs1inf <= (&fdata_rs1[30:23]) &&!(|fdata_rs1[22:0]);
                    DIV_frs2inf <= (&fdata_rs2[30:23]) &&!(|fdata_rs2[22:0]);
                    DIV_frs1zero<= fdata_rs1[30:0] == 0;
                    DIV_frs2zero<= fdata_rs2[30:0] == 0;
                end
                LOOPNR_1:  begin
                    mulinA_DIV <= DIV_matrs2;

                    mulinB_DIV <=  DIV_x[ 3:1 ];
                    mulinC_DIV <=  DIV_x[ 7:5 ];
                    mulinD_DIV <=  DIV_x[11:9 ];
                    mulinE_DIV <=  DIV_x[15:13];
                    mulinF_DIV <=  DIV_x[19:17];
                    mulinG_DIV <=  DIV_x[23:21];
                    mulinH_DIV <= {1'b0, DIV_x[26:25]};

                    DIV_exprd  <=  DIV_exprs1 - DIV_exprs2 + 127;
                    DIV_state <= LOOPNR_2;

                    if (DIV_frs1zero || DIV_frs2zero) begin
                        DIV_state <= WRITEBACK;
                        DIV_zero <= 1;
                    end
                    if (DIV_nan) DIV_state <= WRITEBACK;
                    if (DIV_frs1inf || DIV_frs2inf) begin
                        DIV_state <= WRITEBACK;
                        DIV_inf <= 1;
                    end
                end
                LOOPNR_2:  begin
                    mulinB_DIV <= {DIV_x[ 1:0 ], 1'b0};
                    mulinC_DIV <=  DIV_x[ 5:3 ];
                    mulinD_DIV <=  DIV_x[ 9:7 ];
                    mulinE_DIV <=  DIV_x[13:11];
                    mulinF_DIV <=  DIV_x[17:15];
                    mulinG_DIV <=  DIV_x[21:19];
                    mulinH_DIV <=  DIV_x[25:23];

                    DIV_signrd <=  DIV_signrs1^DIV_signrs2;
                    DIV_state <= LOOPNR_3;
                end
                LOOPNR_3:  begin   //(2-D*x0)
                    DIV_x1 <= ($signed({2'b0, 28'h8000000, 26'b0})) - (res_on_DIV << 2) - (res_tw_DIV << 6) - (res_th_DIV << 10) - (res_fo_DIV << 14) -
                                           (res_fi_DIV << 18)- (res_si_DIV << 22)- (res_se_DIV << 26);
                    DIV_state <= LOOPNR_4;
                end
                LOOPNR_4:  begin 
                    DIV_x1 <= DIV_x1       - (res_on_DIV)      - (res_tw_DIV << 4) - (res_th_DIV << 8) - (res_fo_DIV << 12) -
                                           (res_fi_DIV <<+ 16)- (res_si_DIV << 20)- (res_se_DIV << 24);
                    DIV_state <= LOOPNR_5;
                end
                LOOPNR_5:  begin
                    mulinA_DIV <= DIV_x;

                    mulinB_DIV <=  DIV_x1[29:27];
                    mulinC_DIV <=  DIV_x1[33:31];
                    mulinD_DIV <=  DIV_x1[37:35];
                    mulinE_DIV <=  DIV_x1[41:39];
                    mulinF_DIV <=  DIV_x1[45:43];
                    mulinG_DIV <=  DIV_x1[49:47];
                    mulinH_DIV <= {1'b0, DIV_x1[52:51]};   
                    DIV_state <= LOOPNR_6;
                end
                LOOPNR_6:  begin
                    mulinB_DIV <= {DIV_x1[27:26], 1'b0};
                    mulinC_DIV <=  DIV_x1[31:29];
                    mulinD_DIV <=  DIV_x1[35:33];
                    mulinE_DIV <=  DIV_x1[39:37];
                    mulinF_DIV <=  DIV_x1[43:41];
                    mulinG_DIV <=  DIV_x1[47:45];
                    mulinH_DIV <=  DIV_x1[51:49];
                    DIV_state <= LOOPNR_7;
                end
                LOOPNR_7:  begin
                    DIV_x1 <= (res_on_DIV << 2) + (res_tw_DIV << 6) + (res_th_DIV << 10) + (res_fo_DIV << 14) +
                                                  (res_fi_DIV << 18)+ (res_si_DIV << 22) + (res_se_DIV << 26);
                    DIV_state <= LOOPNR_8;
                end
                LOOPNR_8:  begin
                    DIV_x1 <= DIV_x1 + (res_on_DIV) + (res_tw_DIV << 4) + (res_th_DIV << 8) + (res_fo_DIV << 12) +
                                                      (res_fi_DIV << 16)+ (res_si_DIV << 20)+ (res_se_DIV << 24);
                    DIV_state <= MULFN1;
                end
                MULFN1: begin
                    if(DIV_doneNR) begin       
//                        DIV_pause <= 0;

                        mulinA_DIV <=  DIV_matrs1;

                        mulinB_DIV <=  DIV_x1[29:27];
                        mulinC_DIV <=  DIV_x1[33:31];
                        mulinD_DIV <=  DIV_x1[37:35];
                        mulinE_DIV <=  DIV_x1[41:39];
                        mulinF_DIV <=  DIV_x1[45:43];
                        mulinG_DIV <=  DIV_x1[49:47];
                        mulinH_DIV <= {1'b0, DIV_x1[52:51]};   

                        DIV_state <= MULFN2;
                    end
                    else begin
                        DIV_doneNR<= 1;
                        DIV_x <= DIV_x1[52:26];
                        DIV_state <= LOOPNR_1;
                    end
                end
                MULFN2: begin
                    mulinB_DIV <= {DIV_x1[27:26], 1'b0};
                    mulinC_DIV <=  DIV_x1[31:29];
                    mulinD_DIV <=  DIV_x1[35:33];
                    mulinE_DIV <=  DIV_x1[39:37];
                    mulinF_DIV <=  DIV_x1[43:41];
                    mulinG_DIV <=  DIV_x1[47:45];
                    mulinH_DIV <=  DIV_x1[51:49];
                    DIV_state <= MULFN3;
                end
                MULFN3: begin
                    DIV_x1 <= (res_on_DIV << 2) + (res_tw_DIV << 6) + (res_th_DIV << 10) + (res_fo_DIV << 14) +
                                                  (res_fi_DIV << 18)+ (res_si_DIV << 22) + (res_se_DIV << 26);
                    DIV_state <= MULFN4;
                end
                MULFN4: begin
                    DIV_x1 <= DIV_x1 + (res_on_DIV) + (res_tw_DIV << 4) + (res_th_DIV << 8) + (res_fo_DIV << 12) +
                                                      (res_fi_DIV << 16)+ (res_si_DIV << 20)+ (res_se_DIV << 24);
                    DIV_state <= WRITEBACK;
                end
                WRITEBACK: begin     
                    if(1) begin
                        DIV_x <= DIV_x1[52:26];
                        DIV_matrd <= DIV_matrd_next;  
                        if(DIV_matrd_next[23])      DIV_datawb <= ({DIV_signrd, DIV_exprd  , DIV_matrd_next[22:0]}) + DIV_x1[28];
                        else if(&DIV_exprd)         DIV_datawb <= ({DIV_signrd, 8'hff, 23'h000000});//-->inf
                        else                        DIV_datawb <= ({DIV_signrd, DIV_exprd, DIV_matrd_next[21:0], 1'b0}) + (DIV_x1[28]<<1) + 32'h00800000;
                        DIV_fregrdwb <= fregrd;
                        DIV_datavalid <= 1;
                        DIV_pause <= 0;
                        DIV_wait <= 1;

                        if(DIV_zero) begin
                            if(DIV_frs1zero)DIV_datawb <= {(fdata_rs1[31] ^ fdata_rs2[31]), 8'h00, 23'h000000};//-->zero
                            if(DIV_frs2zero)
                            if(DIV_frs1zero)DIV_datawb <= 32'h7fc00000;//-->cNaN 
                            else            DIV_datawb <= {(fdata_rs1[31] ^ fdata_rs2[31]), 8'hff, 23'h000000};//-->inf
                        end
                        if(DIV_nan) DIV_datawb <= 32'h7fc00000;//-->cNaN
                        if(DIV_inf) begin
                            if(DIV_frs1inf) DIV_datawb <= {(fdata_rs1[31] ^ fdata_rs2[31]), 8'hff, 23'h000000};//-->inf
                            if(DIV_frs2inf) 
                            if(DIV_frs1inf) DIV_datawb <= 32'h7fc00000;//-->cNaN 
                            else            DIV_datawb <= {(fdata_rs1[31] ^ fdata_rs2[31]), 8'h00, 23'h000000};//-->zero
                        end
                        DIV_state <= FINDX0_1;
                    end
                end
            endcase
        end
    end



//-------------------------------------------------SQRT-----------------------------------------------------//
    reg [ 3:0 ]     SQRT_state  =   0;
    reg             SQRT_signrs1=   0;
    reg [ 8:0 ]     SQRT_exprs1 =   0;
    reg [26:0 ]     SQRT_matrs1 =   0;

    reg             SQRT_signrd =   0;
    reg [ 7:0 ]     SQRT_exprd  =   0;
    reg [26:0 ]     SQRT_matrd  =   0;

    reg [27:0 ]     SQRT_rem    =   0;
    reg [27:0 ]     SQRT_trial  =   0;
    reg [13:0 ]     SQRT_root   =   0;
    
    reg [31:0 ]     SQRT_datawb = 0;
    reg             SQRT_datavalid= 0;
    reg [ 4:0 ]     SQRT_fregrdwb= 0;

    reg             SQRT_shift1 = 0;
    wire            SQRT_rise   = !SQRT_shift1 && FSQRT && !DecodeNotValid;
    reg             SQRT_pause  = 0;
    wire            SQRT_pausefn= SQRT_rise || SQRT_pause;
    reg             SQRT_wait   = 0;

    reg             SQRT_nan    = 0;
    reg             SQRT_zero   = 0;
    reg             SQRT_neg    = 0;
    reg             SQRT_inf    = 0;

    always @(posedge clk) begin
        if(!rst) begin
            SQRT_state <= 0;
            SQRT_shift1 <= 0;
        end
        else begin
            SQRT_wait <= 0;
            SQRT_shift1 <= FSQRT;
            case(SQRT_state)
                0:  begin       //khởi động chuẩn hóa
                    SQRT_pause <= 0;
                    SQRT_datavalid  <= 0;
                    SQRT_rem    <= 0;
                    SQRT_trial  <= 0;
                    SQRT_root   <= 0;
                    SQRT_signrs1    <= fdata_rs1[31];

                    SQRT_nan <= 0;
                    SQRT_zero <= 0;
                    SQRT_neg <= 0;
                    SQRT_inf <= 0;

                    if(fdata_rs1[23]) begin
                        SQRT_exprs1     <= fdata_rs1[30:23] - 127;
                        SQRT_matrs1     <= {1'b1, fdata_rs1[22:0], 3'b000};                        
                    end
                    else begin
                        SQRT_exprs1     <= fdata_rs1[30:23] + 1 - 127;
                        SQRT_matrs1     <= {2'b01, fdata_rs1[22:0], 2'b00};
                    end
                    if(FSQRT && !DecodeNotValid) begin
                        if(!SQRT_wait && pause_cnt <= 1) SQRT_state <= 1;
                        if(!SQRT_wait) SQRT_pause <= 1;
                    end
                end
                1:  begin
                    SQRT_signrd <=  0;
                    SQRT_exprd  <=  $signed(SQRT_exprs1>>>1) + $signed(127);
            
                    SQRT_rem    <= {SQRT_rem[25:0], 1'b0, SQRT_matrs1[26]};
                    SQRT_trial  <= {12'd0, SQRT_root[13:0], 2'b01};

                    if(({SQRT_rem[25:0], 1'b0, SQRT_matrs1[26]}) < ({12'd0, SQRT_root[13:0], 2'b01})) begin
                        SQRT_root <= SQRT_root << 1;
                    end
                    else begin
                        SQRT_rem  <= ({SQRT_rem[25:0], 1'b0, SQRT_matrs1[26]}) - ({12'd0, SQRT_root[13:0], 2'b01});
                        SQRT_root <= {SQRT_root[12:0], 1'b1};
                    end
                    SQRT_state <= 2;
                    if(pause_cnt >= 2) SQRT_state <= 0;
                    
                    SQRT_neg <= fdata_rs1[31];
                    SQRT_nan <= (&fdata_rs1[30:23]) && (|fdata_rs1[22:0]);
                    SQRT_inf <= (&fdata_rs1[30:23]) &&!(|fdata_rs1[22:0]);
                    SQRT_zero<=!(|fdata_rs1[30:0 ]);
                end
                2:  begin
            
                    SQRT_rem    <= {SQRT_rem[25:0], SQRT_matrs1[25:24]};
                    SQRT_trial  <= ({12'd0, SQRT_root[13:0], 2'b01});

                    if(({SQRT_rem[25:0], SQRT_matrs1[25:24]}) < ({12'd0, SQRT_root[13:0], 2'b01})) begin
                        SQRT_root <= SQRT_root << 1;
                    end
                    else begin
                        SQRT_rem  <= ({SQRT_rem[25:0], SQRT_matrs1[25:24]}) - ({12'd0, SQRT_root[13:0], 2'b01});
                        SQRT_root <= {SQRT_root[12:0], 1'b1};
                    end
                    SQRT_state <= 3;
                    
                    if(SQRT_neg || SQRT_nan || SQRT_inf || SQRT_zero) SQRT_state <= 15;
                end
                3:  begin
            
                    SQRT_rem    <= {SQRT_rem[25:0], SQRT_matrs1[23:22]};
                    SQRT_trial  <= {12'd0, SQRT_root[13:0], 2'b01};

                    if(({SQRT_rem[25:0], SQRT_matrs1[23:22]}) < ({12'd0, SQRT_root[13:0], 2'b01})) begin
                        SQRT_root <= SQRT_root << 1;
                    end
                    else begin
                        SQRT_rem  <= ({SQRT_rem[25:0], SQRT_matrs1[23:22]}) - ({12'd0, SQRT_root[13:0], 2'b01});
                        SQRT_root <= {SQRT_root[12:0], 1'b1};
                    end
                    SQRT_state <= 4;
                end
                4:  begin
            
                    SQRT_rem    <= {SQRT_rem[25:0], SQRT_matrs1[21:20]};
                    SQRT_trial  <= {12'd0, SQRT_root[13:0], 2'b01};

                    if(({SQRT_rem[25:0], SQRT_matrs1[21:20]}) < ({12'd0, SQRT_root[13:0], 2'b01})) begin
                        SQRT_root <= SQRT_root << 1;
                    end
                    else begin
                        SQRT_rem  <= ({SQRT_rem[25:0], SQRT_matrs1[21:20]}) - ({12'd0, SQRT_root[13:0], 2'b01});
                        SQRT_root <= {SQRT_root[12:0], 1'b1};
                    end
                    SQRT_state <= 5;
                end
                5:  begin
            
                    SQRT_rem    <= {SQRT_rem[25:0], SQRT_matrs1[19:18]};
                    SQRT_trial  <= {12'd0, SQRT_root[13:0], 2'b01};

                    if(({SQRT_rem[25:0], SQRT_matrs1[19:18]}) < ({12'd0, SQRT_root[13:0], 2'b01})) begin
                        SQRT_root <= SQRT_root << 1;
                    end
                    else begin
                        SQRT_rem  <= ({SQRT_rem[25:0], SQRT_matrs1[19:18]}) - ({12'd0, SQRT_root[13:0], 2'b01});
                        SQRT_root <= {SQRT_root[12:0], 1'b1};
                    end
                    SQRT_state <= 6;
                end
                6:  begin
            
                    SQRT_rem    <= {SQRT_rem[25:0], SQRT_matrs1[17:16]};
                    SQRT_trial  <= {12'd0, SQRT_root[13:0], 2'b01};

                    if(({SQRT_rem[25:0], SQRT_matrs1[17:16]}) < ({12'd0, SQRT_root[13:0], 2'b01})) begin
                        SQRT_root <= SQRT_root << 1;
                    end
                    else begin
                        SQRT_rem  <= ({SQRT_rem[25:0], SQRT_matrs1[17:16]}) - ({12'd0, SQRT_root[13:0], 2'b01});
                        SQRT_root <= {SQRT_root[12:0], 1'b1};
                    end
                    SQRT_state <= 7;
                end
                7:  begin
            
                    SQRT_rem    <= {SQRT_rem[25:0], SQRT_matrs1[15:14]};
                    SQRT_trial  <= {12'd0, SQRT_root[13:0], 2'b01};

                    if(({SQRT_rem[25:0], SQRT_matrs1[15:14]}) < ({12'd0, SQRT_root[13:0], 2'b01})) begin
                        SQRT_root <= SQRT_root << 1;
                    end
                    else begin
                        SQRT_rem  <= ({SQRT_rem[25:0], SQRT_matrs1[15:14]}) - ({12'd0, SQRT_root[13:0], 2'b01});
                        SQRT_root <= {SQRT_root[12:0], 1'b1};
                    end
                    SQRT_state <= 8;
                end
                8:  begin
            
                    SQRT_rem    <= {SQRT_rem[25:0], SQRT_matrs1[13:12]};
                    SQRT_trial  <= {12'd0, SQRT_root[13:0], 2'b01};

                    if(({SQRT_rem[25:0], SQRT_matrs1[13:12]}) < ({12'd0, SQRT_root[13:0], 2'b01})) begin
                        SQRT_root <= SQRT_root << 1;
                    end
                    else begin
                        SQRT_rem  <= ({SQRT_rem[25:0], SQRT_matrs1[13:12]}) - ({12'd0, SQRT_root[13:0], 2'b01});
                        SQRT_root <= {SQRT_root[12:0], 1'b1};
                    end
                    SQRT_state <= 9;
                end
                9:  begin
            
                    SQRT_rem    <= {SQRT_rem[25:0], SQRT_matrs1[11:10]};
                    SQRT_trial  <= {12'd0, SQRT_root[13:0], 2'b01};

                    if(({SQRT_rem[25:0], SQRT_matrs1[11:10]}) < ({12'd0, SQRT_root[13:0], 2'b01})) begin
                        SQRT_root <= SQRT_root << 1;
                    end
                    else begin
                        SQRT_rem  <= ({SQRT_rem[25:0], SQRT_matrs1[11:10]}) - ({12'd0, SQRT_root[13:0], 2'b01});
                        SQRT_root <= {SQRT_root[12:0], 1'b1};
                    end
                    SQRT_state <= 10;
                end
                10:  begin
            
                    SQRT_rem    <= {SQRT_rem[25:0], SQRT_matrs1[ 9:8 ]};
                    SQRT_trial  <= {12'd0, SQRT_root[13:0], 2'b01};

                    if(({SQRT_rem[25:0], SQRT_matrs1[ 9:8 ]}) < ({12'd0, SQRT_root[13:0], 2'b01})) begin
                        SQRT_root <= SQRT_root << 1;
                    end
                    else begin
                        SQRT_rem  <= ({SQRT_rem[25:0], SQRT_matrs1[ 9:8 ]}) - ({12'd0, SQRT_root[13:0], 2'b01});
                        SQRT_root <= {SQRT_root[12:0], 1'b1};
                    end
                    SQRT_state <= 11;
                end
                11:  begin
            
                    SQRT_rem    <= {SQRT_rem[25:0], SQRT_matrs1[ 7:6 ]};
                    SQRT_trial  <= {12'd0, SQRT_root[13:0], 2'b01};

                    if(({SQRT_rem[25:0], SQRT_matrs1[ 7:6 ]}) < ({12'd0, SQRT_root[13:0], 2'b01})) begin
                        SQRT_root <= SQRT_root << 1;
                    end
                    else begin
                        SQRT_rem  <= ({SQRT_rem[25:0], SQRT_matrs1[ 7:6 ]}) - ({12'd0, SQRT_root[13:0], 2'b01});
                        SQRT_root <= {SQRT_root[12:0], 1'b1};
                    end
                    SQRT_state <= 12;
                end
                12:  begin
            
                    SQRT_rem    <= {SQRT_rem[25:0], SQRT_matrs1[ 5:4 ]};
                    SQRT_trial  <= {12'd0, SQRT_root[13:0], 2'b01};

                    if(({SQRT_rem[25:0], SQRT_matrs1[ 5:4 ]}) < ({12'd0, SQRT_root[13:0], 2'b01})) begin
                        SQRT_root <= SQRT_root << 1;
                    end
                    else begin
                        SQRT_rem  <= ({SQRT_rem[25:0], SQRT_matrs1[ 5:4 ]}) - ({12'd0, SQRT_root[13:0], 2'b01});
                        SQRT_root <= {SQRT_root[12:0], 1'b1};
                    end
                    SQRT_state <= 13;
                end
                13:  begin
            
                    SQRT_rem    <= {SQRT_rem[25:0], SQRT_matrs1[ 3:2 ]};
                    SQRT_trial  <= {12'd0, SQRT_root[13:0], 2'b01};

                    if(({SQRT_rem[25:0], SQRT_matrs1[ 3:2 ]}) < ({12'd0, SQRT_root[13:0], 2'b01})) begin
                        SQRT_root <= SQRT_root << 1;
                    end
                    else begin
                        SQRT_rem  <= ({SQRT_rem[25:0], SQRT_matrs1[ 3:2 ]}) - ({12'd0, SQRT_root[13:0], 2'b01});
                        SQRT_root <= {SQRT_root[12:0], 1'b1};
                    end
                    SQRT_state <= 14;
                end
                14:  begin
                    SQRT_rem    <= {SQRT_rem[25:0], SQRT_matrs1[ 1:0 ]};
                    SQRT_trial  <= {12'd0, SQRT_root[13:0], 2'b01};

                    if(({SQRT_rem[25:0], SQRT_matrs1[ 1:0 ]}) < ({12'd0, SQRT_root[13:0], 2'b01})) begin
                        SQRT_root <= SQRT_root << 1;
                    end
                    else begin
                        SQRT_rem  <= ({SQRT_rem[25:0], SQRT_matrs1[ 1:0 ]}) - ({12'd0, SQRT_root[13:0], 2'b01});
                        SQRT_root <= {SQRT_root[12:0], 1'b1};
                    end
//                    SQRT_pause <= 0;
                    SQRT_state <= 15;
                end
                15: begin
                    if(1) begin
                        if(SQRT_root[13])   SQRT_datawb <= {SQRT_signrd, SQRT_exprd, SQRT_root[12:0], 10'b0};
                        else if(|SQRT_exprd)SQRT_datawb <= {SQRT_signrd, SQRT_exprd, SQRT_root[11:0], 11'b0} - 32'h00800000;
                        else                SQRT_datawb <= {SQRT_signrd, 31'h00000000};//-->zero
                        SQRT_fregrdwb <= fregrd;
                        SQRT_datavalid <= 1;
                        SQRT_state <= 0;
                        SQRT_pause <= 0;
                        SQRT_wait  <= 1;

                        if(SQRT_neg) SQRT_datawb <= 32'h7fc00000;//-->cNaN
                        if(SQRT_nan) SQRT_datawb <= 32'h7fc00000;//-->cNaN
                        if(SQRT_inf) SQRT_datawb <= {fdata_rs1[31], 8'hff, 23'h000000};
                        if(SQRT_zero)SQRT_datawb <= {fdata_rs1[31], 31'h00000000};//-->zero
                    end
                end
            endcase
        end
    end

    assign  FPU_ready   = SQRT_pausefn || DIV_pausefn || (!FPU_ready_pre_fn);
    assign  FPU_fdatars2= (fw_validfn && fregrd_fn == fregrs2)?fw_datafn:fdata_rs2;
    assign  fw_datafn   =   (DIV_datavalid  )?DIV_datawb    :
                            (SQRT_datavalid )?SQRT_datawb   :
                                              fw_data;
    assign  fw_validfn  =   (DIV_datavalid || SQRT_datavalid)?1'b1:fw_valid;
    assign  fregrd_fn   =   (DIV_datavalid  )?DIV_fregrdwb  :
                            (SQRT_datavalid )?SQRT_fregrdwb :
                                              fregrd_plwb;
endmodule












module mul_tiny(
    input                   clk,
    input   wire    [27:0]  inA,
    input   wire    [ 2:0]  inB,
    input   wire    [ 2:0]  inC,
    input   wire    [ 2:0]  inD,
    input   wire    [ 2:0]  inE,

    input   wire    [ 2:0]  inF,
    input   wire    [ 2:0]  inG,
    input   wire    [ 2:0]  inH,    


    output   wire   signed  [55:0] res_on,
    output   wire   signed  [55:0] res_tw,
    output   wire   signed  [55:0] res_th,
    output   wire   signed  [55:0] res_fo,
    output   wire   signed  [55:0] res_fi,
    output   wire   signed  [55:0] res_si,
    output   wire   signed  [55:0] res_se
);
    reg signed  [55:0 ] r_res_on = 0;
    reg signed  [55:0 ] r_res_tw = 0;
    reg signed  [55:0 ] r_res_th = 0;
    reg signed  [55:0 ] r_res_fo = 0;
    reg signed  [55:0 ] r_res_fi = 0;
    reg signed  [55:0 ] r_res_si = 0;
    reg signed  [55:0 ] r_res_se = 0;

    function signed [53:0] booth_encode;
        input [2:0] bits;
        input [27:0] A;
        case(bits)
            3'b000, 3'b111: booth_encode = 0;
            3'b001, 3'b010: booth_encode =  A;
            3'b011:         booth_encode = A<<1;
            3'b100:         booth_encode = -(A<<1);
            3'b101, 3'b110: booth_encode = -A;
            default:        booth_encode = 0;
        endcase
    endfunction

    assign res_on = r_res_on;
    assign res_tw = r_res_tw;
    assign res_th = r_res_th;
    assign res_fo = r_res_fo;
    assign res_fi = r_res_fi;
    assign res_si = r_res_si;
    assign res_se = r_res_se;
    always @(posedge clk) begin
        r_res_on <= booth_encode(inB, inA);
        r_res_tw <= booth_encode(inC, inA);
        r_res_th <= booth_encode(inD, inA);
        r_res_fo <= booth_encode(inE, inA);
        r_res_fi <= booth_encode(inF, inA);
        r_res_si <= booth_encode(inG, inA);
        r_res_se <= booth_encode(inH, inA);
    end
endmodule
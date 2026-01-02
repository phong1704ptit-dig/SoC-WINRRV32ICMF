//boot XADR: 0_0000_0000 -> 0_0011_1111 16KB
//text XADR: 0_0100_0000 -> 0_0111_1111 16KB
//user XADR: 0_1000_0000 -> 1_0010_1111 45KB


module UFLASH_core #(
    parameter integer CLK_FREQ  = 27_000_000,   // clock input (Hz)
    parameter integer BAUD_RATE = 9600          // baud rate
) (
    input  wire        clk,
    input  wire        rst,

    // Keys
    input  wire [31:0] i_key1,
    input  wire [31:0] i_key2,
    input  wire [31:0] i_key3,

    // Control
    input  wire        i_user_en,
    input  wire        i_text_en,
    input  wire        i_boot_en,
    input  wire        i_prog_en,
    input  wire        i_read_en,
    input  wire        i_erase_en,
    input  wire [1:0]  i_mode,

    // Address
    input  wire [15:0]  i_xaddr,
    input  wire [7:0]  i_yaddr,

    // Status outputs
    output reg         o_prog_done,
    output reg         o_rd_done,
    output reg         o_erase_done,
    output             o_err_user,
    output             o_err_text,
    output             o_err_boot,
    output             o_err_ovf,

    input      [31:0 ] i_program_data,
    output reg [31:0 ] o_read_data
);
    localparam READ_MODE    = 2'b00;
    localparam PROGRAM_MODE = 2'b01;
    localparam ERASE_MODE   = 2'b10;
    localparam IDLE_MODE    = 2'b11;
    

    // ===== KEY constants =====
    localparam KEY1_CONST = 32'h57494E44;   //WIND - phong
    localparam KEY2_CONST = 32'h48674432;   //Không tiết lộ
    localparam KEY3_CONST = 32'hab4f9029;   //Không tiết lộ

    // ===== External unlock flags =====
    assign o_err_user = (i_key1 != KEY1_CONST);// && i_xaddr < 9'b0_0100_0000 && i_mode != 2'b11;
    assign o_err_text = (i_key2 != KEY2_CONST);// && i_xaddr < 9'b0_0111_1111 && i_xaddr >= 9'b0_0100_0000 && i_mode != 2'b11;
    assign o_err_boot = (i_key3 != KEY3_CONST);// && i_xaddr < 9'b1_0010_1111 && i_xaddr >= 9'b0_1000_0000 && i_mode != 2'b11;

    // ===== Error address overflow =====
    assign o_err_ovf  = i_xaddr >= 9'b1_0010_1111;




/////////////////////////////////////////////////////////////////////////////////////////////
// =====================================Control main=========================================
/////////////////////////////////////////////////////////////////////////////////////////////

    // Flash signals
    wire [31:0] dout;
    reg  [31:0] din, din_next;
    reg  [15:0]  xadr, xadr_next;
    reg  [7:0]  yadr, yadr_next;
    reg         xe, ye, se, prog, erase, nvstr;
    reg         xe_next, ye_next, se_next, prog_next, erase_next, nvstr_next;
    
    // user
    reg  [31:0] time_cnt, time_next_cnt;
    wire        en_user = (i_key1 == KEY1_CONST) && i_xaddr < 9'b0_0100_0000;// && i_mode != 2'b11 && i_user_en;
    wire        en_text = (i_key2 == KEY2_CONST) && i_xaddr < 9'b0_0111_1111 && i_xaddr >= 9'b0_0100_0000;// && i_mode != 2'b11 && i_text_en;
    wire        en_boot = (i_key3 == KEY3_CONST) && i_xaddr < 9'b1_0010_1111 && i_xaddr >= 9'b0_1000_0000;// && i_mode != 2'b11 && i_boot_en;  

    reg         erase_done_next;
    reg         rd_done_next;
    reg         prog_done_next;
    reg [31:0 ] read_data_next;

    // State encoding
    localparam S_IDLE       = 3'b000;
    localparam S_PROGRAM    = 3'b001;
    localparam S_READ       = 3'b010;
    localparam S_ERASE      = 3'b011;
    localparam S_HOLD       = 3'b100;
    reg [3:0] state_reg, state_next, state_pre;
    

    //flash write
    localparam SW_BEGIN   = 4'b0000;     //SE, ERASE, YE, XE, PROG, NVSTR = 0
    localparam SW_SETXADR = 4'b0001;     //XE = 1, setup XADR
    localparam SW_PROG    = 4'b0010;     //PROG = 1
    localparam SW_NVSTR   = 4'b0011;     //NVSTR = 1
    localparam SW_SETYADR = 4'b0100;     //setup YADR, setup DIN
    localparam SW_ENYADR  = 4'b0101;     //YE = 1
    localparam SW_DISYYADR= 4'b0110;     //YE = 0
    localparam SW_HOLDADR = 4'b0111;     //hold 1 cyc adr and pass, dont care YADR
    localparam SW_DISPROG = 4'b1000;     //PROG = 0
    localparam SW_DISNVSTR= 4'b1001;     //NVSTR = 0
    localparam SW_HOLDXADR= 4'b1010;     //hold 1 cyc adr and pass, dont care YADR, XE = 0
    localparam SW_END     = 4'b1011;     //NVSTR, PROG, XE, ERASE, SE = 1
    reg [3:0] statew_reg, statew_next;


    //flash read
    localparam SR_SETUP   = 3'b000;     //setup XADDR, setup YADDR, XE, YE = 1, SE = 0
    localparam SR_ENSE    = 3'b001;     //SE = 1
    localparam SR_DISSE   = 3'b010;     //SE = 0
    localparam SR_DONE    = 3'b011;     //pass XADR, YADR, XE, YE = 0, Sample
    localparam SR_DELAY   = 3'b100;     //delay
    localparam SR_IDLE    = 3'b101;     //hold
    reg [3:0] stater_reg, stater_next;


    //flash clear
    localparam SC_BEGIN   = 3'b000;     //YE, SE, XE, ERASE, NVSTR = 0
    localparam SC_SETXADR = 3'b001;     //setup XADR, XE = 1
    localparam SC_ENERASE = 3'b010;     //ERASE = 1
    localparam SC_ENNVSTR = 3'b011;     //NVSTR = 1
    localparam SC_DISERASE= 3'b100;     //ERASE = 0
    localparam SC_DISNVSTH= 3'b101;     //NVSTR = 0, pass XADR
    localparam SC_CLPREDONE=3'b110;     //YE = 1, XE = 0;
    localparam SC_CLDONE  = 3'b111;     //YE, SE, XE, ERASE, NVSTR = 1
    reg [3:0] statec_reg, statec_next;
    


    // ========================= Flash (gowin IP) ===============================
//    Gowin_User_Flash flash_boot(
//        .dout(dout),
//        .xe(xe),
//        .ye(ye),
//        .se(se),
//        .prog(prog),
//        .erase(erase),
//        .nvstr(nvstr),
//        .xadr(xadr),
//        .yadr(yadr),
//        .din(din)
//    );

    // FSM registers
    always @(posedge clk) begin
        if (!rst) begin
            state_reg <= S_IDLE;
            state_pre <= S_IDLE;
            statew_reg <= SW_BEGIN;
            stater_reg <= SR_SETUP;
            statec_reg <= SC_BEGIN;

            xadr <= 0; yadr <= 0;
            din  <= 0;
            xe   <= 0; ye <= 0; se <= 0;
            prog <= 0; erase <= 0; nvstr <= 0;
            
            time_cnt <= 0;
        end else begin
            state_reg <= state_next;
            state_pre <= state_reg;
            statew_reg <= statew_next;
            stater_reg <= stater_next;
            statec_reg <= statec_next;

            xadr  <= xadr_next;
            yadr  <= yadr_next;
            din   <= din_next;
            xe    <= xe_next;
            ye    <= ye_next;
            se    <= se_next;
            prog  <= prog_next;
            erase <= erase_next;
            nvstr <= nvstr_next;

            o_prog_done <= prog_done_next;
            o_rd_done <= rd_done_next;
            o_erase_done <= erase_done_next;
            o_read_data <= read_data_next;

            time_cnt <= time_next_cnt;
        end
    end

    // FSM next state + control
reg ck = 0;
    always @(*) begin
        // giữ nguyên mặc định
        state_next    = state_reg;
        statew_next   = statew_reg;
        stater_next   = stater_reg;
        statec_next   = statec_reg;

        xadr_next  = xadr;
        yadr_next  = yadr;
        din_next   = din;
        xe_next    = xe;
        ye_next    = ye;
        se_next    = se;
        prog_next  = prog;
        erase_next = erase;
        nvstr_next = nvstr;

        prog_done_next = o_prog_done;
        erase_done_next = o_erase_done;
        rd_done_next = o_rd_done;
        read_data_next = o_read_data;


        time_next_cnt = time_cnt;

        case (state_reg)
            S_IDLE: begin
                if (en_user | en_boot | en_text) begin
                    if (i_prog_en && i_mode == PROGRAM_MODE) begin
                        state_next = S_PROGRAM;
                    end
                    if (i_erase_en && i_mode == ERASE_MODE) begin
                        state_next = S_ERASE;
                    end
                    if (i_read_en && i_mode == READ_MODE) begin
                        state_next = S_READ;
                    end
                end
                prog_done_next = 1'b0;
                erase_done_next = 1'b0;
                rd_done_next = 1'b0;
            end
            S_ERASE: begin
                case (statec_reg)
                    SC_BEGIN    : begin     //YE, SE, XE, ERASE, NVSTR = 0
                        ye_next = 1'b0; se_next = 1'b0; xe_next = 1'b0;
                        erase_next = 1'b0; nvstr_next = 0;

                        prog_next = 1'b0;
                        statec_next = SC_SETXADR;
                    end
                    SC_SETXADR  : begin     //setup XADR, XE = 1
                        xe_next = 1'b1;
                        xadr_next = i_xaddr;
                        time_next_cnt = 0;
                        statec_next = SC_ENERASE;
                    end
                    SC_ENERASE  : begin     //ERASE = 1
                        erase_next = 1'b1;
                        statec_next = SC_ENNVSTR;
                    end
                    SC_ENNVSTR  : begin     //delay > 5us, NVSTR = 1
                        time_next_cnt = time_cnt + 1;
                        if(time_cnt == 7*27) begin
                            nvstr_next = 1'b1;
                            time_next_cnt = 0;
                            statec_next = SC_DISERASE;
                        end
                    end
                    SC_DISERASE : begin     //delay > 100ms < 120ms, ERASE = 1'b0
                        time_next_cnt = time_cnt + 1;
                        if(time_cnt == 110000*27) begin
                            erase_next = 1'b0;
                            time_next_cnt = 0;
                            statec_next = SC_DISNVSTH;
                        end
                    end
                    SC_DISNVSTH : begin     //delay > 5us, NVSTR = 0
                        time_next_cnt = time_cnt + 1;
                        if(time_cnt == 7*27) begin
                            nvstr_next = 1'b0;
                            time_next_cnt = 0;
                            statec_next = SC_CLPREDONE;
                        end                      
                    end
                    SC_CLPREDONE: begin     //YE = 1, XE = 0;
                        ye_next = 1'b1;
                        xe_next = 1'b0;
                        statec_next = SC_CLDONE;
                    end
                    SC_CLDONE   : begin     //delay > 10us, SE, XE, ERASE, NVSTR = 1
                        time_next_cnt = time_cnt + 1;
                        if(time_cnt == 12*27) begin
                            se_next = 1'b1; xe_next = 1'b1;
                            erase_next = 1'b1; nvstr_next = 1'b1;
                            statec_next = SC_BEGIN;
                            state_next = S_HOLD;
                            time_next_cnt = 0;
                        end 
                    end
                endcase
            end

            S_PROGRAM: begin
                case (statew_reg)
                    SW_BEGIN    : begin     //SE, ERASE, YE, XE, PROG, NVSTR = 0
                        se_next = 1'b0; erase_next = 1'b0; xe_next = 1'b0;
                        ye_next = 1'b0; prog_next = 1'b0; nvstr_next = 1'b0;
                        statew_next = SW_SETXADR;
                    end
                    SW_SETXADR  : begin     //XE = 1, setup XADR
                        xe_next = 1'b1;
                        xadr_next = i_xaddr;
                        statew_next = SW_PROG;
                    end
                    SW_PROG     : begin     //PROG = 1
                        prog_next = 1'b1;
                        statew_next = SW_NVSTR;
                    end
                    SW_NVSTR    : begin     //delay > 5us, NVSTR = 1
                        time_next_cnt = time_cnt + 1;
                        if(time_cnt == 7*27) begin
                            nvstr_next = 1'b1;
                            time_next_cnt = 0;
                            statew_next = SW_SETYADR;
                        end
                    end
                    SW_SETYADR  : begin     //setup YADR, setup DIN
                        yadr_next = i_yaddr;
                        din_next = i_program_data;
                        statew_next = SW_ENYADR;
                    end
                    SW_ENYADR   : begin     //delay > 10us, //YE = 1
                        time_next_cnt = time_cnt + 1;
                        if(time_cnt == 12*27) begin
                            ye_next = 1'b1;
                            time_next_cnt = 0;
                            statew_next = SW_DISYYADR;
                        end
                    end
                    SW_DISYYADR : begin     //delay > 8us < 16us, YE = 0 
                        time_next_cnt = time_cnt + 1;
                        if(time_cnt == 12*27) begin
                            ye_next = 1'b0;
                            time_next_cnt = 0;
                            statew_next = SW_HOLDADR;
                        end
                    end
                    SW_HOLDADR  : begin     //hold 1 cyc adr and pass, dont care YADR
                        statew_next = SW_DISPROG;
                    end
                    SW_DISPROG  : begin     //PROG = 0
                        prog_next = 1'b0;
                        statew_next = SW_DISNVSTR;
                    end
                    SW_DISNVSTR : begin     //delay > 5us, NVSTR = 0
                        time_next_cnt = time_cnt + 1;
                        if(time_cnt == 7*27) begin
                            nvstr_next = 1'b0;
                            time_next_cnt = 0;
                            statew_next = SW_HOLDXADR;
                        end
                    end
                    SW_HOLDXADR : begin     //hold 1 cyc adr and pass, dont care YADR, XE = 0
                        xe_next = 1'b0;
                        statew_next = SW_END;
                    end
                    SW_END      : begin     //delay > 10us, NVSTR, PROG, XE, ERASE, SE = 1
                        time_next_cnt = time_cnt + 1;
                        if(time_cnt == 12*27) begin
                            nvstr_next = 1'b1; prog_next = 1'b1;
                            xe_next = 1'b1; erase_next = 1'b1; se_next = 1'b1;
                            time_next_cnt = 0;
                            statew_next = SW_BEGIN;
                            state_next = S_HOLD;
                        end
                    end
                endcase
            end

            S_READ: begin
                case (stater_reg) 
                    SR_SETUP    : begin     //setup XADDR, setup YADDR, XE, YE = 1, SE = 0
                        xadr_next = i_xaddr; yadr_next = i_yaddr;
                        xe_next = 1'b1; ye_next = 1'b1; se_next = 1'b0;
                            
                        prog_next = 1'b0; erase_next = 1'b0; nvstr_next = 1'b0;
                        stater_next = SR_ENSE;
                    end
                    SR_ENSE     : begin     //SE = 1
                        se_next = 1'b1;
                        stater_next = SR_DISSE;
                    end
                    SR_DISSE    : begin     //SE = 0
                        se_next = 1'b0;
                        stater_next = SR_DONE;
                    end
                    SR_DONE     : begin     //pass XADR, YADR, XE, YE = 0, Sample
                        ye_next = 1'b0; xe_next = 1'b0; 
                        read_data_next = dout;
                        stater_next = SR_DELAY;
                    end
                    SR_DELAY    : begin     //delay 1us
                        time_next_cnt = time_cnt + 1;
                        if(time_cnt == 1000*27) begin
                            time_next_cnt = 0;
                            stater_next = SR_SETUP;                
                            state_next = S_HOLD;
                        end                      
                    end
                endcase
            end
            S_HOLD: begin   
                case (i_mode)
                    IDLE_MODE: state_next = S_IDLE;
                    ERASE_MODE: erase_done_next = 1'b1;
                    READ_MODE: rd_done_next = 1'b1;
                    PROGRAM_MODE: prog_done_next = 1'b1;
                endcase
            end
        endcase
    end


endmodule

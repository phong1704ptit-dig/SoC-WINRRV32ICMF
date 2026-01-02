module uart_top #(
    parameter integer CLK_FREQ  = 27_000_000,   // clock input (Hz)
    parameter integer BAUD_RATE = 9600          // baud rate
)(
    input  wire clk,
    input  wire rst_n,
    input  wire rx,
    output wire tx
);

    // UART signals
    wire tick;
    wire rx_done_tick;
    wire tx_done_tick;
    wire [7:0] rx_data;
    reg  [7:0] tx_data, tx_data_next;
    reg        tx_start, tx_start_next;

    // Flash signals
    wire [31:0] dout;
    reg  [31:0] din, din_next;
    reg  [8:0]  xadr, xadr_next;
    reg  [5:0]  yadr, yadr_next;
    reg         xe, ye, se, prog, erase, nvstr;
    reg         xe_next, ye_next, se_next, prog_next, erase_next, nvstr_next;
    
    reg  [31:0] time_cnt, time_next_cnt;

    reg  [2:0]  send_cnt, send_cnt_next;

    // State encoding
    localparam S_IDLE  = 3'b000;
    localparam S_LOAD  = 3'b001;
    localparam S_WRITE = 3'b010;
    localparam S_READ  = 3'b011;
    localparam S_SEND  = 3'b100;
    localparam S_CFLAST= 3'b111;
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
    

    // Helper regs
    reg [1:0] byte_cnt, byte_cnt_next;
    reg [31:0] buffer, buffer_next;
    reg [31:0] addr_cnt, addr_cnt_next;

    // Baud generator
    baud_gen #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) baud_gen_unit (
        .clk(clk),
        .rst_n(rst_n),
        .tick(tick)
    );

    // UART RX
    // synthesis keep
    uart_rx uart_rx_unit (
        .clk(clk),
        .rst_n(rst_n),
        .rx(rx),
        .s_tick(tick),
        .rx_done_tick(rx_done_tick),
        .dout(rx_data)
    );

    // UART TX
    uart_tx uart_tx_unit (
        .clk(clk),
        .rst_n(rst_n),
        .tx_start(tx_start),
        .s_tick(tick),
        .din(tx_data),
        .tx_done_tick(tx_done_tick),
        .tx(tx)
    );

    // Flash (gowin IP)
    //synthesis keep
    Gowin_User_Flash flash_boot(
        .dout(dout),
        .xe(xe),
        .ye(ye),
        .se(se),
        .prog(prog),
        .erase(erase),
        .nvstr(nvstr),
        .xadr(xadr),
        .yadr(yadr),
        .din(din)
    );

    // FSM registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_reg <= S_CFLAST;
            state_pre <= S_CFLAST;
            statew_reg <= SW_BEGIN;
            stater_reg <= SR_SETUP;
            statec_reg <= SC_BEGIN;
            addr_cnt  <= 0;
            byte_cnt  <= 0;
            buffer    <= 0;
            tx_data   <= 0;
            tx_start  <= 0;

            xadr <= 0; yadr <= 0;
            din  <= 0;
            xe   <= 0; ye <= 0; se <= 0;
            prog <= 0; erase <= 0; nvstr <= 0;
            
            time_cnt <= 0;
            send_cnt <= 0;
        end else begin
            state_reg <= state_next;
            state_pre <= state_reg;
            statew_reg <= statew_next;
            stater_reg <= stater_next;
            statec_reg <= statec_next;
            addr_cnt  <= addr_cnt_next;
            byte_cnt  <= byte_cnt_next;
            buffer    <= buffer_next;
            tx_data   <= tx_data_next;
            tx_start  <= tx_start_next;

            xadr  <= xadr_next;
            yadr  <= yadr_next;
            din   <= din_next;
            xe    <= xe_next;
            ye    <= ye_next;
            se    <= se_next;
            prog  <= prog_next;
            erase <= erase_next;
            nvstr <= nvstr_next;

            time_cnt <= time_next_cnt;
            send_cnt <= send_cnt_next;
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
        addr_cnt_next = addr_cnt;
        byte_cnt_next = byte_cnt;
        buffer_next   = buffer;
        tx_data_next  = tx_data;
        tx_start_next = 1'b0;  // luôn reset, chỉ bật khi cần

        xadr_next  = xadr;
        yadr_next  = yadr;
        din_next   = buffer;
        xe_next    = xe;
        ye_next    = ye;
        se_next    = se;
        prog_next  = prog;
        erase_next = erase;
        nvstr_next = nvstr;


        time_next_cnt = time_cnt;
        send_cnt_next = send_cnt;

        case (state_reg)
            S_CFLAST: begin
                case (statec_reg)
                    SC_BEGIN    : begin     //YE, SE, XE, ERASE, NVSTR = 0
                        ye_next = 1'b0; se_next = 1'b0; xe_next = 1'b0;
                        erase_next = 1'b0; nvstr_next = 0;

                        prog_next <= 1'b0;
                        statec_next = SC_SETXADR;
                    end
                    SC_SETXADR  : begin     //setup XADR, XE = 1
                        xe_next = 1'b1;
                        xadr_next = 0;
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
                            state_next = S_IDLE;
                            time_next_cnt = 0;
                        end 
                    end
                endcase
            end
            S_IDLE: begin
                if (rx_done_tick) begin
                    buffer_next[7:0] = rx_data;
                    byte_cnt_next = 1;
                    state_next = S_LOAD;
                end
            end

            S_LOAD: begin
                if (rx_done_tick) begin
                    case (byte_cnt)
                        1: buffer_next[15:8]  = rx_data;
                        2: buffer_next[23:16] = rx_data;
                        3: buffer_next[31:24] = rx_data;
                    endcase
                    byte_cnt_next = byte_cnt + 1;
                    if (byte_cnt == 3)
                        state_next = S_WRITE;
                end
            end

            S_WRITE: begin
                case (statew_reg)
                    SW_BEGIN    : begin     //SE, ERASE, YE, XE, PROG, NVSTR = 0
                        se_next = 1'b0; erase_next = 1'b0; xe_next = 1'b0;
                        ye_next = 1'b0; prog_next = 1'b0; nvstr_next = 1'b0;
                        statew_next = SW_SETXADR;
                    end
                    SW_SETXADR  : begin     //XE = 1, setup XADR
                        xe_next = 1'b1;
                        xadr_next = addr_cnt[14:6];
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
                        yadr_next = addr_cnt[5:0];
                        din_next = buffer;
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
                            state_next = S_READ;
                        end
                    end
                endcase
            end
            S_READ: begin
                case (stater_reg) 
                    SR_SETUP    : begin     //setup XADDR, setup YADDR, XE, YE = 1, SE = 0
                        xadr_next = addr_cnt[14:6]; yadr_next = addr_cnt[5:0];
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
                        tx_data_next = dout[7:0];
                        stater_next = SR_DELAY;
                    end
                    SR_DELAY    : begin     //delay 1us
                        time_next_cnt = time_cnt + 1;
                        if(time_cnt == 1000*27) begin
                            time_next_cnt = 0;
                            stater_next = SR_SETUP;                
                            state_next = S_SEND;
                        end                      
                    end
                endcase

            end

            S_SEND: begin
                tx_start_next = 1'b0;
                if (!tx_start && state_pre == S_READ) begin
                    tx_start_next = 1'b1;
                    send_cnt_next = send_cnt + 1;
                    tx_data_next  = dout[7:0];
                end
                 
                if (tx_done_tick) begin
                    send_cnt_next = send_cnt + 1;
                    tx_start_next = 1'b1;
                    if(send_cnt == 4) begin
                        state_next    = S_IDLE;
                        send_cnt_next = 0;
                        tx_start_next = 1'b0;
                    end
                    case(send_cnt)
                        2'd0: tx_data_next = dout[7:0];
                        2'd1: tx_data_next = dout[15:8];
                        2'd2: tx_data_next = dout[23:16];
                        2'd3: tx_data_next = dout[31:24];
                    endcase
                    addr_cnt_next = addr_cnt + 1;
                end
            end
        endcase
    end


    // điều khiển loopback: khi rx_done_tick -> copy rx_data sang tx_data và start transmit
//    always @(posedge clk or negedge rst_n) begin
//        if (!rst_n) begin
//            tx_start <= 1'b0;
//            tx_data  <= 8'h00;
//        end else begin
//            if (rx_done_tick) begin
//                tx_data  <= dout;
//                tx_start <= 1'b1;
//            end else if (tx_done_tick) begin
//                tx_start <= 1'b0;
//            end
//        end
//    end


endmodule

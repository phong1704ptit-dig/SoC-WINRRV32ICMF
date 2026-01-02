module I2C_Master_Rx(
    input i_clk,
    input i_rst_n,
    input [1:0] i_len_add,          //Lựa chọn độ dài địa chỉ slave. 00: 7bit, 01: 8bit, 10: 9bit, 11: 10bit
    input i_i2c_en,                 //Bat tat khoi i2c
    input i_i2c_start,              //Bat dau truyen, nhan
    input [2:0] i_num_by,           //Lựa chọn số lượng byte muốn nhận. 0 được coi là 1
    input [4:0] i_sem_lo,           //Lựa chọn vị trí lấy mẫu và thay đổi dữ liệu truyền. Từ 1 tới 9. Tất cả các giá trị ngoài khoảng đều đc chuẩn hóa
    input [15:0] i_add_sla,         //Thanh ghi địa chỉ slave

    output reg [63:0] i_data_rx,         //Thanh ghi dữ liệu nhận được
    inout scl_i2c,
    inout sda_i2c,

    output reg o_detect,                //Cờ báo hiệu phát hiện slave trên đường truyền
    output reg o_rxe,                   //Cờ báo hiệu thanh ghi dữ liệu nhận trống
    output reg o_rxne,                  //Cờ báo hiệu thanh ghi dữ liệu nhận không trống
    output reg o_busy,                  //Cờ báo hiệu ngoại vi I2C có đang bận hay không
    output reg o_rs,                    //Cờ báo hiệu hoàn thành nhận 
    output reg o_err                    //Cờ báo hiệu có xuất hiện lỗi trong quá trình nhận
);

    localparam STATE_IDLE =0;
    localparam START_STATE = 1;
    localparam SEND_ADD_SLAVE_STATE = 2;
    localparam CHECK_ACK_STATE = 3;
    localparam RECEIVE_DATA_STATE = 4;
    localparam SEND_ACK_NACK_STATE = 5;
    localparam PRE_STOP_STATE = 6;
    localparam STOP_STATE = 7;
    localparam NBUSY_STATE = 8;


    integer inter_fsm = 0;
    integer inter_cnt_lo = 1;
    integer inter_cnt_index = 10;
    
    reg inter_check_ACK;
    reg inter_fixb = 0;
    reg inter_fixb2 = 0;
    reg [2:0] inter_cnt_numby;
    reg scl = 1'b1, sda = 1'b1;



//////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////Control SDA, SCL//////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
    always @(posedge i_clk) begin
        if (i_rst_n || ~i_i2c_en) begin
            o_detect <= 1'b0;
            o_rxe <= 1'b1;
            o_rxne <= 1'b0;
            o_busy <= 1'b0;
            o_rs <= 1'b0;
            inter_fixb <= 1'b0;
            inter_fixb2 <= 1'b0;
            inter_cnt_index <= 7 + i_len_add;
            inter_cnt_numby <= i_num_by;
            inter_fsm <= STATE_IDLE;
            scl <= 1'b1;
            sda <= 1'b1;
        end


        else if (i_i2c_en) begin
            o_busy <= 1;
            o_rs <= 1'b0;
            //scl <= 1'b1;
            if ((((inter_cnt_lo == ((i_sem_lo > 0)?((i_sem_lo < 10)?i_sem_lo:9):1) + 10)) && inter_fsm != RECEIVE_DATA_STATE) 
                || ((inter_cnt_lo == ((i_sem_lo > 0)?((i_sem_lo < 10)?i_sem_lo:9):1)) && inter_fsm == RECEIVE_DATA_STATE && inter_fixb)
                || inter_fsm == STATE_IDLE || inter_fsm == NBUSY_STATE
                || (inter_cnt_lo == 2 && inter_fsm == START_STATE)
                || inter_cnt_lo == 8 && inter_fsm == STOP_STATE) begin
                case (inter_fsm)
                    STATE_IDLE: begin
                        sda <= 1'b1;
                        inter_fixb <= 1'b0;
                        if (i_i2c_start) inter_fsm <= START_STATE;
                    end
                    START_STATE: begin
                        sda <= 1'b0;
                        o_rxe <= 1'b0; o_rxne <= 1'b1; o_rs <= 1'b0; o_busy <= 1'b1;
                        inter_cnt_index <= 7 + i_len_add;
                        inter_cnt_numby <= i_num_by;
                        inter_fsm <= SEND_ADD_SLAVE_STATE;
                    end
                    SEND_ADD_SLAVE_STATE: begin
                        sda <= i_add_sla[inter_cnt_index];
                        if (inter_cnt_index != 0) inter_cnt_index <= inter_cnt_index - 1;
                        else begin
                            inter_fsm <= CHECK_ACK_STATE;
                            inter_cnt_index <= 7;
                        end
                    end
                    CHECK_ACK_STATE: begin
                        sda <= 1'bz;
                        if (/*inter_check_ACK == 0*/1) begin
                            o_detect <= 1'b1;
                            inter_fixb <= 1'b1;
                            if (inter_fixb) inter_fsm <= RECEIVE_DATA_STATE;
                        end
                        else begin                      //khong phat hien
                            o_detect <= 1'b0;
                            inter_fsm <= PRE_STOP_STATE;
                        end
                    end
                    RECEIVE_DATA_STATE: begin
                        sda <= 1'bz;
                        i_data_rx[inter_cnt_index + (inter_cnt_numby-1)*8] <= sda_i2c;
                        if (inter_cnt_index != 0) inter_cnt_index <= inter_cnt_index - 1;
                        else begin      
                            inter_cnt_index <= 7;
                            inter_cnt_numby <= inter_cnt_numby - 1;
                            inter_fixb <= 1'b0;
                            inter_fixb2 <= 1'b1;
                            inter_fsm <= SEND_ACK_NACK_STATE;
                        end
                    end
                    SEND_ACK_NACK_STATE: begin
                        inter_fixb <= 1'b1;
                        if (inter_cnt_numby != 0) begin
                            if (inter_fixb) inter_fsm <= RECEIVE_DATA_STATE;
                            sda <= 1'b0;
                        end
                        else begin
                            sda <= 1'b1;
                            inter_fsm <= PRE_STOP_STATE;
                        end
                    end
                    PRE_STOP_STATE: begin
                        sda <= 1'b0;
                        inter_fsm <= STOP_STATE;
                    end
                    STOP_STATE: begin
                        sda <= 1'b1; scl <= 1'b1;
                        inter_cnt_numby <= i_num_by;
//                        o_busy <= 1'b0;
//                        o_rxe <= 1'b1;
//                        o_rxne <= 1'b0;
                        inter_fsm <= NBUSY_STATE;
                    end
                    NBUSY_STATE: begin
                        o_busy <= 1'b0;
                        o_rs <= 1'b1;
                        o_rxe <= 1'b1;
                        o_rxne <= 1'b0;
                        sda <= 1'b1;
                        if (i_i2c_start == 0) inter_fsm <= STATE_IDLE;
                    end
                endcase
            end
            
            
            if (inter_cnt_lo == 0 || inter_cnt_lo == 10) scl <= ~scl;
        end
    end



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////CHECK TIME/////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    always @(posedge i_clk) begin
        if (i_rst_n || ~i_i2c_en) begin
            inter_cnt_lo <= 1;
            inter_check_ACK <= 1'bz;
        end
        else if (i_i2c_en) begin
            if (inter_fsm != STATE_IDLE && i_i2c_start) inter_cnt_lo <= (inter_cnt_lo != 19)?(inter_cnt_lo + 1):0;
            else inter_cnt_lo <= 1;
            if ((inter_cnt_lo == ((i_sem_lo > 0)?((i_sem_lo < 10)?i_sem_lo:9):1)) && 
                                  (inter_fsm == CHECK_ACK_STATE)) begin 
                                  inter_check_ACK = sda_i2c;
            end

            if (/*inter_fsm == STOP_STATE || */inter_fsm == NBUSY_STATE) inter_cnt_lo <= 1;
        end
    end



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////CHECK ERROR//////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    reg inter_val;
    always @(posedge i_clk) begin
        inter_val <= sda_i2c;
        if (inter_fsm == START_STATE) o_err <= 1'b0;
        else if (inter_fsm == RECEIVE_DATA_STATE) begin
            if (inter_cnt_lo >= 0 && inter_cnt_lo <= 10) begin
                if (inter_val != sda_i2c) o_err <= 1'b1;//Phat hien hoi thay doi du lieu khi SCL muc cao
                else o_err <= 1'b0;
            end
        end
    end


////////////////////Gan 2 duong du lieu cua i2c////////////////////
    assign scl_i2c = (i_i2c_en)?scl:1'bz;
    assign sda_i2c = (i_i2c_en && inter_fsm != RECEIVE_DATA_STATE && inter_fsm != CHECK_ACK_STATE )?sda:1'bz;
   // assign i_data_tx = (inter_fsm == PRE_STOP_STATE || inter_fsm == STOP_STATE)?72'b0:72'bz;
endmodule

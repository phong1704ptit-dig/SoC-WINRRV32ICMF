/*          DTP D21DT166   
Module ngoại vi SPI ở chế độ slave
Xung SCLK được đọc mỗi. Tùy thuộc 
vào CPHA tin hiệu sẽ được lấy mẫu 
ở sườn phù hợp.
Ban co nhan ra dieu gi khong ^^
*/

module SPI_Slave(
    input       i_clk,
    input       i_rst,
    input [5:0] i_BPT_SPI,                    //Số bít mỗi lần nhận (Bits per recei) 1 -> 64 (63 được hiểu là 64, 0 được hiểu là 1 ngoài ra n đc hiểu là n)
    input       i_CPOL_SPI,                   //Lựa chọn cực tính đồng hồ trạng thái nhàn rồi (0 - logic thấp)
    input       i_CPHA_SPI,                   //Lựa chọn cực tính lấy mẫu(0 - cạnh tăng)
    input       i_EN_SPI,                     //Enable spi
    input       i_MSB_SPI,                    //Lựa chọn giao tiếp MSB trước hay LSB trước (1 - MSB)
  
    input [31:0] i_TXDATAL_SPI,               //Dữ liệu muốn truyền 32 bit thấp
    input [31:0] i_TXDATAH_SPI,               //Dữ liệu muốn truyền 32 bit cao
    
    output      o_TXE_SPI,                    //Đã truyền đủ 8bit
    output      o_RXNE_SPI,                   //Đã nhận đủ 8 bit
    output      o_ERR_SPI,                    //Cờ báo hiệu xuất hiện lỗi
    output      o_BUSY_SPI,                   //Cờ báo hiệu hệ thống đang bận

    output [31:0]o_RXDATAL_SPI,               //Dữ liệu nhận được 32 bit thấp
    output [31:0]o_RXDATAH_SPI,               //Dữ liệu nhận được 32 bit cao

    //signal
    input MISO_SPI,
    output MOSI_SPI,
    input SCLK,
    input SS_SPI
);

    reg             inter_STRX_SPI;
    wire    [6:0]   inter_BPT_SPI;          assign  inter_BPT_SPI       =       ((i_BPT_SPI == 0)?6'd1:((i_BPT_SPI == 63)?64:i_BPT_SPI));
    wire    [63:0]  inter_TXDATA_SPI;       assign  inter_TXDATA_SPI    =       {i_TXDATAH_SPI, i_TXDATAL_SPI};
    wire    [63:0]  inter_RXDATA_SPI;       assign  inter_RXDATA_SPI    =       {o_RXDATAH_SPI, o_RXDATAL_SPI};    


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////ACTIVE HIGH////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    integer     inter_state_pos = 0;
    integer     inter_cnt_pos = 0;
    reg [63:0]   inter_RX_pos = 0;
    reg         inter_TXdata_pos = 0;
    reg         inter_busy_pos = 0;
    reg         inter_TXE_pos = 0;
    reg         inter_RXNE_pos = 0;
    reg         SCLK_d_pos = 0;

    wire pos_edge1;  assign pos_edge1 = (SCLK&(inter_state_pos==2));
    wire pos_edge2;  assign pos_edge2 = (i_clk&(inter_state_pos != 2));

    always @(posedge i_clk) begin
        if (i_rst || !i_EN_SPI || SS_SPI) begin
            inter_state_pos <= 0;
            inter_cnt_pos <= 0;
            inter_RX_pos <= 0;
            inter_TXdata_pos <= inter_TXDATA_SPI[((i_MSB_SPI)?inter_BPT_SPI-1:0)];
            inter_busy_pos <= 0;
            inter_TXE_pos <= 0;
            inter_RXNE_pos <= 0;
        end
        else begin
            inter_busy_pos <= 1;
            inter_RXNE_pos <= 0;
            inter_TXE_pos <= 0;
            SCLK_d_pos <= SCLK;
            if (i_CPHA_SPI == i_CPOL_SPI) begin            //Lấy mẫu
                case (inter_state_pos) 
                    0: begin
                        if (i_EN_SPI) begin
                            inter_state_pos <= 1;
                        end
                    end
                    1: begin 
                        if ((SCLK == 1 && SCLK_d_pos == 0) || (inter_cnt_pos == inter_BPT_SPI)) begin
                            if (inter_cnt_pos < inter_BPT_SPI) begin
                                inter_cnt_pos <= inter_cnt_pos + 1;
                                inter_RX_pos[inter_cnt_pos] <= MISO_SPI;
                            end
                            else begin
                                inter_cnt_pos <= 0;
                                inter_state_pos <= 2;
                            end
                        end
                    end
                    2: begin
                        inter_busy_pos <= 0;
                        inter_RXNE_pos <= 1;
                        if (i_EN_SPI) begin
                            inter_state_pos <= 0;
                        end
                    end
                endcase
            end
            else begin                  //Dịch chuyển
                case (inter_state_pos)
                    0: begin
                        inter_TXdata_pos <= inter_TXDATA_SPI[((i_MSB_SPI)?inter_BPT_SPI-1:0)];
                        if (i_EN_SPI) begin
                            inter_state_pos <= 1;
                            if (!i_CPHA_SPI) inter_cnt_pos <= 1;             //Xem hình ở chế độ CPHA = CPOL
                            else inter_cnt_pos <= 0;
                        end
                    end
                    1: begin
                        if ((SCLK == 1 && SCLK_d_pos == 0) || (inter_cnt_pos == inter_BPT_SPI)) begin
                            if (inter_cnt_pos < inter_BPT_SPI) begin
                                inter_cnt_pos <= inter_cnt_pos + 1;
                                inter_TXdata_pos <= inter_TXDATA_SPI[((i_MSB_SPI)?(inter_BPT_SPI-1-inter_cnt_pos):inter_cnt_pos)];
                            end
                            else begin
                                inter_cnt_pos <= 0;
                                inter_state_pos <= 2;
                            end
                        end
                    end
                    2: begin
                        inter_busy_pos <= 0;
                        inter_TXE_pos <= 1;
                        if (i_EN_SPI) begin
                            inter_state_pos <= 0;
                        end
                    end
                endcase
            end
        end
    end



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////ACTIVE LOW/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    integer     inter_state_neg = 0;
    integer     inter_cnt_neg = 0;
    reg [63:0]  inter_RX_neg = 0;
    reg         inter_TXdata_neg = 0;
    reg         inter_busy_neg = 0;
    reg         inter_TXE_neg = 0;
    reg         inter_RXNE_neg = 0;
    reg         SCLK_d_neg = 0;
    reg         inter_check_B = (i_CPOL_SPI)?1:1;          //Sử dụng để bỏ đi xung sườn xuống đầu tiên của SCLK nếu ở chế độ CPOL = 1

    wire neg_edge1;  assign neg_edge1 = (SCLK&(inter_state_neg==2));
    wire neg_edge2;  assign neg_edge2 = (i_clk&(inter_state_neg != 2));

    always @(posedge i_clk) begin
        if (i_rst || !i_EN_SPI || SS_SPI) begin
            inter_state_neg <= 0;
            inter_cnt_neg <= 0;
            inter_RX_neg <= 0;
            inter_TXdata_neg <= inter_TXDATA_SPI[((i_MSB_SPI)?inter_BPT_SPI-1:0)];
            inter_busy_neg <= 0;
            inter_TXE_neg <= 0;
            inter_RXNE_neg <= 0;
            inter_check_B <= (i_CPOL_SPI)?1:1;
        end
        else begin
            inter_busy_neg <= 1;
            inter_RXNE_neg <= 0;
            inter_TXE_neg <= 0;
            SCLK_d_neg <= SCLK;
            if (i_CPHA_SPI != i_CPOL_SPI) begin            //Lấy mẫu
                case (inter_state_neg) 
                    0: begin
                        if (i_EN_SPI) begin
                            inter_state_neg <= 1;
                            inter_cnt_neg <= 0;
                        end
                    end
                    1: begin  
                        if ((SCLK == 0 && SCLK_d_neg == 1 && inter_check_B) || (inter_cnt_neg == inter_BPT_SPI)) begin
                            if (inter_cnt_neg < inter_BPT_SPI) begin
                                inter_cnt_neg <= inter_cnt_neg + 1;
                                inter_RX_neg[inter_cnt_neg] <= MISO_SPI;
                            end
                            else begin
                                inter_cnt_neg <= 0;
                                inter_state_neg <= 2;
                            end
                        end
                        if (SCLK == 0 && SCLK_d_neg == 1) inter_check_B <= 1;
                    end
                    2: begin
                        inter_busy_neg <= 0;
                        inter_RXNE_neg <= 1;
                        inter_check_B <= (i_CPOL_SPI)?1:1;
                        if (i_EN_SPI) begin
                            inter_state_neg <= 0;
                        end
                    end
                endcase
            end
            else begin                  //Dịch chuyển
                case (inter_state_neg)
                    0: begin
                        inter_TXdata_neg <= inter_TXDATA_SPI[((i_MSB_SPI)?inter_BPT_SPI-1:0)];
                        if (i_EN_SPI) begin
                            inter_state_neg <= 1;
                            if (!i_CPHA_SPI) inter_cnt_neg <= 1;             //Xem hình ở chế độ CPHA = CPOL
                            else inter_cnt_neg <= 0;
                        end
                    end
                    1: begin
                        if ((SCLK == 0 && SCLK_d_neg == 1 && inter_check_B) || (inter_cnt_neg == inter_BPT_SPI)) begin                        
                            if (inter_cnt_neg < inter_BPT_SPI) begin
                                inter_cnt_neg <= inter_cnt_neg + 1;
                                inter_TXdata_neg <= inter_TXDATA_SPI[((i_MSB_SPI)?(inter_BPT_SPI-1-inter_cnt_neg):inter_cnt_neg)];
                            end
                            else begin
                                inter_cnt_neg <= 0;
                                inter_state_neg <= 2;
                            end
                        end
                        if (SCLK == 0 && SCLK_d_neg == 1) inter_check_B <= 1;
                    end
                    2: begin
                        inter_busy_neg <= 0;
                        inter_TXE_neg <= 1;
                        inter_check_B <= (i_CPOL_SPI)?1:1;
                        if (i_EN_SPI) begin
                            inter_state_neg <= 0;
                        end
                    end
                endcase
            end
        end
    end


///////////////////////////////////////////////Gán////////////////////////////////////////
    wire    [63:0]   inter_RX_neg_d   =   {inter_RX_neg[0], inter_RX_neg[1], inter_RX_neg[2], inter_RX_neg[3], inter_RX_neg[4], inter_RX_neg[5], inter_RX_neg[6], inter_RX_neg[7], 
                                             inter_RX_neg[8], inter_RX_neg[9], inter_RX_neg[10], inter_RX_neg[11], inter_RX_neg[12], inter_RX_neg[13], inter_RX_neg[14], inter_RX_neg[15], 
                                             inter_RX_neg[16], inter_RX_neg[17], inter_RX_neg[18], inter_RX_neg[19], inter_RX_neg[20], inter_RX_neg[21], inter_RX_neg[22], inter_RX_neg[23], 
                                             inter_RX_neg[24], inter_RX_neg[25], inter_RX_neg[26], inter_RX_neg[27], inter_RX_neg[28], inter_RX_neg[29], inter_RX_neg[30], inter_RX_neg[31], 
                                             inter_RX_neg[32], inter_RX_neg[33], inter_RX_neg[34], inter_RX_neg[35], inter_RX_neg[36], inter_RX_neg[37], inter_RX_neg[38], inter_RX_neg[39], 
                                             inter_RX_neg[40], inter_RX_neg[41], inter_RX_neg[42], inter_RX_neg[43], inter_RX_neg[44], inter_RX_neg[45], inter_RX_neg[46], inter_RX_neg[47], 
                                             inter_RX_neg[48], inter_RX_neg[49], inter_RX_neg[50], inter_RX_neg[51], inter_RX_neg[52], inter_RX_neg[53], inter_RX_neg[54], inter_RX_neg[55], 
                                             inter_RX_neg[56], inter_RX_neg[57], inter_RX_neg[58], inter_RX_neg[59], inter_RX_neg[60], inter_RX_neg[61], inter_RX_neg[62], inter_RX_neg[63]};

    wire    [63:0]   inter_RX_pos_d   =   {inter_RX_pos[0], inter_RX_pos[1], inter_RX_pos[2], inter_RX_pos[3], inter_RX_pos[4], inter_RX_pos[5], inter_RX_pos[6], inter_RX_pos[7], 
                                             inter_RX_pos[8], inter_RX_pos[9], inter_RX_pos[10], inter_RX_pos[11], inter_RX_pos[12], inter_RX_pos[13], inter_RX_pos[14], inter_RX_pos[15], 
                                             inter_RX_pos[16], inter_RX_pos[17], inter_RX_pos[18], inter_RX_pos[19], inter_RX_pos[20], inter_RX_pos[21], inter_RX_pos[22], inter_RX_pos[23], 
                                             inter_RX_pos[24], inter_RX_pos[25], inter_RX_pos[26], inter_RX_pos[27], inter_RX_pos[28], inter_RX_pos[29], inter_RX_pos[30], inter_RX_pos[31], 
                                             inter_RX_pos[32], inter_RX_pos[33], inter_RX_pos[34], inter_RX_pos[35], inter_RX_pos[36], inter_RX_pos[37], inter_RX_pos[38], inter_RX_pos[39], 
                                             inter_RX_pos[40], inter_RX_pos[41], inter_RX_pos[42], inter_RX_pos[43], inter_RX_pos[44], inter_RX_pos[45], inter_RX_pos[46], inter_RX_pos[47], 
                                             inter_RX_pos[48], inter_RX_pos[49], inter_RX_pos[50], inter_RX_pos[51], inter_RX_pos[52], inter_RX_pos[53], inter_RX_pos[54], inter_RX_pos[55], 
                                             inter_RX_pos[56], inter_RX_pos[57], inter_RX_pos[58], inter_RX_pos[59], inter_RX_pos[60], inter_RX_pos[61], inter_RX_pos[62], inter_RX_pos[63]};


    assign o_RXDATAL_SPI     =       ((i_CPHA_SPI)?((i_MSB_SPI)?inter_RX_neg_d[31:0]:inter_RX_neg[31:0]):((i_MSB_SPI)?inter_RX_pos_d[31:0]:inter_RX_pos[31:0]));
    assign o_RXDATAH_SPI     =       ((i_CPHA_SPI)?((i_MSB_SPI)?inter_RX_neg_d[63:32]:inter_RX_neg[63:32]):((i_MSB_SPI)?inter_RX_pos_d[63:32]:inter_RX_pos[63:32]));
    assign MOSI_SPI         =       ((i_CPHA_SPI == i_CPOL_SPI)?inter_TXdata_neg:inter_TXdata_pos);
    assign o_ERR_SPI        =       1'b0;   //Chưa phát triển được để dành cho tương lai :))))
    assign o_BUSY_SPI       =       inter_busy_neg || inter_busy_pos;
    assign o_TXE_SPI        =       (inter_TXE_neg || inter_TXE_pos);
    assign o_RXNE_SPI       =       (inter_RXNE_neg || inter_RXNE_pos);
endmodule 
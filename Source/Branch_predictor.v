/*-------------------------------------------------------------------------
This module implements a 2-bit bimodal branch predictor using a 256-entry table of saturating counters.
It predicts branch direction based on the most significant bit (MSB) of each counter. On each clock cy-
-cle, the predictor updates its state according to the actual branch outcome if update_en is high.

      Strongly not taken(00) -- Weakly not taken(01) -- Weakly taken(10) -- Strongly taken(11)
-------------------------------------------------------------------------*/
module branch_predictor (
    input           clk,   
    input           insBRA,
    input  [31:0]   pc_pred_in,
    input  [31:0]   Instruc_bpre,
    input           update_en,    
    input           actual_taken,
    input           take_en,
    output [ 1:0]   predict_taken,   //0: not take, 1: take
    input  [ 1:0]   predict_old
);

    // Bảng 2-bit saturating counter: 256 dòng
    (* ram_style = "block" *) reg [1:0] BHT [16383:0];  // 2-bit per entry. (Branch history table)
           
    integer i;
    initial begin
        for (i = 0; i < 2000; i = i + 1) BHT[i] = 2'b01; 
        for (i = 2000; i < 4000; i = i + 1) BHT[i] = 2'b01; 
        for (i = 4000; i < 6000; i = i + 1) BHT[i] = 2'b01; 
        for (i = 6000; i < 8000; i = i + 1) BHT[i] = 2'b01; 
        for (i = 8000; i < 10000; i = i + 1) BHT[i] = 2'b01; 
        for (i = 10000; i < 12000; i = i + 1) BHT[i] = 2'b01; 
        for (i = 12000; i < 14000; i = i + 1) BHT[i] = 2'b01; 
        for (i = 14000; i < 16000; i = i + 1) BHT[i] = 2'b01; 
        for (i = 16000; i < 16384; i = i + 1) BHT[i] = 2'b01;
    end

    wire [11:0] index = pc_pred_in[12:1]; // Chọn index từ PC; 8 bit -> 255 trường hợp
    wire [11:0] r_index = Instruc_bpre[12:1];
    reg  [1:0] bht_data;
    reg  [1:0] wdata = 2'b00;
    // Đọc dự đoán
    assign predict_taken = bht_data;


    //Tính giá trị dự đoán sau thay đổi
    always @(*) begin
        wdata = 2'b01;
        if (update_en) begin
            case ({actual_taken, predict_old})
                3'b0_00: wdata = 2'b00; // Giữ SN
                3'b0_01: wdata = 2'b00; // WN -> SN
                3'b0_10: wdata = 2'b01; // WT -> WN
                3'b0_11: wdata = 2'b10; // ST -> WT
                3'b1_00: wdata = 2'b01; // SN -> WN
                3'b1_01: wdata = 2'b10; // WN -> WT
                3'b1_10: wdata = 2'b11; // WT -> ST
                3'b1_11: wdata = 2'b11; // Giữ ST
            endcase
        end
    end


    // Cập nhật theo kết quả thật
    always @(posedge clk) begin
        if (update_en) begin
            BHT[index] <= wdata;
        end

        if(take_en) bht_data <= BHT[r_index];
    end


endmodule

module Timer_base(
    input clk,
    input clk_tim,
    input useclk,                           //sử dụng nếu bộ chia tần có giá trị <= 1
    input rst,
    input i_enable,                         //bật tắt hoạt động của timer
    input i_auto_reload,                    //tự động đặt về ban đầu nếu đếm đến giá trị ngường đọc từ thanh ghi period
    input i_direction,                      //hướng đếm: 0 – đếm lên, 1 – đếm xuống
    input i_upload,                         //đặt lại giá trị thanh ghi count bằng giá trị thanh ghi load
    input [31:0] i_period,                  //chứa giá trị đếm tối đa của thanh ghi counter
    input [31:0] i_load,                    //chưa giá trị muốn nạp vào thanh ghi counter

    output [31:0] o_count,                  //chứa giá trị đếm của counter
    output reg o_overflow,                      //cờ báo tràn thanh ghi counter
    output reg o_overperiod,                    //cờ báo tràn giá trị chu kì
    output reg o_err,                           //cờ báo lỗi
    output reg o_load_done                      //load done
);
    reg [31:0] inter_cnt = 32'b0;
    reg        clk_tim_ff = 0;

    assign o_count = inter_cnt;
    always @(posedge clk) begin
        clk_tim_ff <= clk_tim;
        if (rst || ~i_enable) begin
            inter_cnt <= 32'b0;
            o_overflow <= 1'b0;
            o_overperiod <= 1'b0;
        end
        else begin
            if((!clk_tim_ff && clk_tim) || !useclk) begin
                inter_cnt <= (i_direction)?inter_cnt-1:inter_cnt+1;
                if (inter_cnt == i_period) begin
                    if (i_auto_reload == 1) inter_cnt <= (i_direction)?i_period-1:0;
                    else inter_cnt <= inter_cnt;
                    o_overperiod <= 1'b1;
                end
                else o_overperiod <= 1'b0;

                if (inter_cnt == 32'hffffffff) o_overflow <= 1'b1;
                else o_overflow <= 1'b0;

                if(i_upload)begin
                    inter_cnt <= i_load;
                    o_load_done <= 1'b1;
                end
                else o_load_done <= 1'b0;
            end
        end
    end

    always @(posedge clk) begin
        if (rst || ~i_enable) begin
            o_err <= 1'b0;
        end
        else begin
            o_err <= o_err;
        end
    end
endmodule



/*      DTP-D21DT166
Module timer pwm điều chế xung
Cung cấp 4 cổng PWM tùy chọn có thể cấu hình
Do chinh xac cao
*/


module Timer_PWM(
    input clk,
    input rst,
    input useclk,
    input i_enable,                         //bật tắt hoạt động của timer
    input [1:0] i_select1,                  //lựa chọn đầu ra PWM1
    input [1:0] i_select2,                  //lựa chọn đầu ra PWM2
    input [1:0] i_select3,                  //lựa chọn đầu ra PWM3
    input [1:0] i_select4,                  //lựa chọn đầu ra PWM4
    input [2:0] i_number,                   //lựa cọn số lượng tín hiệu PWM. Lấy từ PWM1 -> PWM4 
    input i_pol,                            //cực tính của tín hiệu khi nho hon gia tri so sanh

    input [31:0] i_prescaler,               //giá trị chia tần cung cấp cho PWM
//  input [7:0] i_prescaler2,               //giá trị chia tần cung cấp cho PWM2
//  input [7:0] i_prescaler3,               //giá trị chia tần cung cấp cho PWM3
//  input [7:0] i_prescaler4,               //giá trị chia tần cung cấp cho PWM4

    input [15:0]i_period1,                  //chứa giá trị đếm tối đa của thanh ghi counter PWM1
    input [15:0]i_period2,                  //chứa giá trị đếm tối đa của thanh ghi counter PWM2
    input [15:0]i_period3,                  //chứa giá trị đếm tối đa của thanh ghi counter PWM3
    input [15:0]i_period4,                  //chứa giá trị đếm tối đa của thanh ghi counter PWM4

    input [15:0]i_compare1,                 //chứa giá trị so sánh của thanh ghi counter PWM1
    input [15:0]i_compare2,                 //chứa giá trị so sánh của thanh ghi counter PWM2
    input [15:0]i_compare3,                 //chứa giá trị so sánh của thanh ghi counter PWM3
    input [15:0]i_compare4,                 //chứa giá trị so sánh của thanh ghi counter PWM4

    output reg [15:0] o_counter1,               //chứa giá trị đếm của PWM1
    output reg [15:0] o_counter2,               //chứa giá trị đếm của PWM2
    output reg [15:0] o_counter3,               //chứa giá trị đếm của PWM3
    output reg [15:0] o_counter4,               //chứa giá trị đếm của PWM4

    output signal_PWM1,
    output signal_PWM2,
    output signal_PWM3,
    output signal_PWM4
);


/////////////////////////////////////////////chia tan///////////////////////////////////////////
    wire clk_timpwm;
    clk_timbase clktimadv(
        .clk            (clk),
        .prescaler      (i_prescaler),
        .rst            (rst),
        .clk_tim        (clk_timpwm)
    );



//////////////////////////////////////////////main///////////////////////////////////////////////
    reg [3:0] signal = 4'b0;
    reg       clk_timpwm_ff = 0;
    always @(posedge clk) begin
        clk_timpwm_ff <= clk_timpwm;
        if (rst || ~i_enable) begin
            signal <= 4'b0;
            o_counter1 <= 16'b0;
            o_counter2 <= 16'b0;
            o_counter3 <= 16'b0;
            o_counter4 <= 16'b0;
        end
        else begin
            if((!clk_timpwm_ff && clk_timpwm) || !useclk) begin
                if (i_number > 0) o_counter1 <= (o_counter1>=i_period1-1)?0:o_counter1 + 1;
                if (i_number > 1) o_counter2 <= (o_counter2>=i_period2-1)?0:o_counter2 + 1;
                if (i_number > 2) o_counter3 <= (o_counter3>=i_period3-1)?0:o_counter3 + 1;
                if (i_number > 3) o_counter4 <= (o_counter4>=i_period4-1)?0:o_counter4 + 1;

                if (o_counter1 < i_compare1 && i_number > 0) signal[i_select1] <= i_pol;
                else if (i_number > 0) signal[i_select1] <= ~i_pol;

                if (o_counter2 < i_compare2 && i_number > 1) signal[i_select2] <= i_pol;
                else if (i_number > 1) signal[i_select2] <= ~i_pol;

                if (o_counter3 < i_compare3 && i_number > 2) signal[i_select3] <= i_pol;
                else if (i_number > 2) signal[i_select3] <= ~i_pol;

                if (o_counter4 < i_compare4 && i_number > 3) signal[i_select4] <= i_pol;
                else if (i_number > 3) signal[i_select4] <= ~i_pol;
            end
        end
    end

    
    assign signal_PWM1 = signal[0];
    assign signal_PWM2 = signal[1];
    assign signal_PWM3 = signal[2];
    assign signal_PWM4 = signal[3];

endmodule
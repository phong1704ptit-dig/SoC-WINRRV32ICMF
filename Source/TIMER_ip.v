module timer_ip#(
    parameter ADDR_W = 32,
    parameter DATA_W = 32,
    parameter STRB_W = DATA_W / 8
)(
    input           PCLK,
    input           PRESETn,

    // Output PWM, input CAPTURE
    output          signal_PWM1,
    output          signal_PWM2,
    output          signal_PWM3,
    output          signal_PWM4,

    // APB
    input   [31:0]  PADDR,
    input           PWRITE,
    input   [31:0]  PWDATA,
    input   [ 3:0]  PSTRB,
    input           PSEL,
    input           PENABLE,
    output  [31:0]  PRDATA,
    output          PREADY,
    output          PSLVERR
);
    wire [31:0] none; assign none = 0;

    // Wires for register outputs
    wire        enbase;
    wire        ar;
    wire        dir;
    wire        ud;
    wire [31:0] divbase;
    wire [31:0] perbase;
    wire [31:0] load;

    wire [31:0] cnt;
    wire        of;
    wire        op;
    wire        err;
    wire        ld;

    // Wire declarations for connecting register map to Timer_PWM
    wire        enadv;
    wire [1:0]  sel1, sel2, sel3, sel4;
    wire        mode;
    wire [2:0]  num;
    wire        pol;
    wire [31:0] divadv;
    wire [15:0] per1, per2, per3, per4;
    wire [15:0] cp1, cp2, cp3, cp4;
    wire [15:0] cnt1, cnt2, cnt3, cnt4;

    // Register map instance
    regs_TIMER regs_timer (
        .clk                        (PCLK),
        .rst                        (PRESETn),

        .csr_tim_config_en_out      (enbase),
        .csr_tim_config_ar_out      (ar),
        .csr_tim_config_dir_out     (dir),
        .csr_tim_config_ud_out      (ud),

        .csr_tim_prescaler_div_out  (divbase),
        .csr_tim_period_per_out     (perbase),
        .csr_tim_load_load_out      (load),

        .csr_tim_counter_cnt_in     (cnt),

        .csr_tim_status_of_in       (of),
        .csr_tim_status_op_in       (op),
        .csr_tim_status_err_in      (err),
        .csr_tim_status_ld_in       (ld),

        .csr_tpwm_config_en_out     (enadv),
        .csr_tpwm_config_sel1_out   (sel1),
        .csr_tpwm_config_sel2_out   (sel2),
        .csr_tpwm_config_sel3_out   (sel3),
        .csr_tpwm_config_sel4_out   (sel4),
        .csr_tpwm_config_mode_out   (mode),////////////////////////////////
        .csr_tpwm_config_num_out    (num),
        .csr_tpwm_config_pol_out    (pol),

        .csr_tpwm_prescaler_div_out (divadv),

        .csr_tpwm_period1_per1_out  (per1),
        .csr_tpwm_period1_per2_out  (per2),
        .csr_tpwm_period2_per3_out  (per3),
        .csr_tpwm_period2_per4_out  (per4),

        .csr_tpwm_compare1_cp1_out  (cp1),
        .csr_tpwm_compare1_cp2_out  (cp2),
        .csr_tpwm_compare2_cp3_out  (cp3),
        .csr_tpwm_compare2_cp4_out  (cp4),

        .csr_tpwm_counter1_cnt1_in  (cnt1),
        .csr_tpwm_counter1_cnt2_in  (cnt2),
        .csr_tpwm_counter2_cnt3_in  (cnt3),
        .csr_tpwm_counter2_cnt4_in  (cnt4),

        // APB
        .psel           (PSEL),
        .paddr          (PADDR),
        .penable        (PENABLE),
        .pwrite         (PWRITE),
        .pwdata         (PWDATA),
        .pstrb          (PSTRB),
        .prdata         (PRDATA),
        .pready         (PREADY),
        .pslverr        (PSLVERR)
    );


///////////////////////////////////////TIMBASE//////////////////////////////////
    wire clk_tim;
    clk_timbase clk_timbase(
        .clk            (PCLK),
        .prescaler      (divbase),
        .rst            (rst),
        .clk_tim        (clk_tim)
    );

    Timer_base timbase(
        .clk            (PCLK),
        .clk_tim        (clk_tim),
        .useclk         ((divbase > 1)),
        .rst            (~PRESETn),
        .i_enable       (enbase),                   
        .i_auto_reload  (ar),            
        .i_direction    (dir),                   
        .i_upload       (ud),            
        .i_period       (perbase),         
        .i_load         (load),            

        .o_count        (cnt),          
        .o_overflow     (of),
        .o_overperiod   (op),
        .o_err          (err),  
        .o_load_done    (ld)
    );


//////////////////////////////////////TIMADV////////////////////////////////////
    // Timer PWM module
    Timer_PWM pwm_inst (
        .clk            (PCLK),
        .rst            (~PRESETn),
        .useclk         ((divbase > 1)),
        .i_enable       (enadv),
        .i_select1      (sel1),
        .i_select2      (sel2),
        .i_select3      (sel3),
        .i_select4      (sel4),
        .i_number       (num),
        .i_pol          (pol),
        .i_prescaler    (divadv),
        .i_period1      (per1),
        .i_period2      (per2),
        .i_period3      (per3),
        .i_period4      (per4),
        .i_compare1     (cp1),
        .i_compare2     (cp2),
        .i_compare3     (cp3),
        .i_compare4     (cp4),
        .o_counter1     (cnt1),
        .o_counter2     (cnt2),
        .o_counter3     (cnt3),
        .o_counter4     (cnt4),
        .signal_PWM1    (signal_PWM1),
        .signal_PWM2    (signal_PWM2),
        .signal_PWM3    (signal_PWM3),
        .signal_PWM4    (signal_PWM4)
    ); 


endmodule
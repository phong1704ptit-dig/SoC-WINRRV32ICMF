module CoReg_unit(
    input           clk,

    //common port
    input   [ 4:0 ] rd,
    input   [31:0 ] data_des,
    input           data_valid,

    //port for predictor    
    input   [ 4:0 ] rs1pred,
    output  [31:0]  data_rs1pred

);
//31 general-purpose registers x1–x31, which hold integer values.
    (* ram_style = "block" *) reg     [31:0]  xreg[0:31];        
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            xreg[i] = 32'h00000000;
        end
    end

    assign  data_rs1pred=   xreg[rs1pred];

//Values destination
    always @(posedge clk) begin
        if(data_valid) 
            xreg[rd] <= data_des;
        //xreg[0] <= 32'h00000000;     //Register x0 is hardwired to the constant 0
    end
endmodule
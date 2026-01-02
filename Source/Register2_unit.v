module Registers2_unit(
    input           clk,

    //common port
    input   [ 4:0 ] rs2,
    input   [ 4:0 ] rd,
    input   [31:0 ] data_des,
    output  [31:0]  data_rs2,
    input           data_valid

);
//31 general-purpose registers x1–x31, which hold integer values.
    reg     [31:0]  xreg[0:31];        
    integer i;
//    initial begin
//        for (i = 0; i < 32; i = i + 1) begin
//            xreg[i] = 32'h00000000;
//        end
//    end

    assign  data_rs2    =   xreg[rs2];

//Values destination
    always @(posedge clk) begin
        if(data_valid) 
            xreg[rd] <= data_des;
        //xreg[0] <= 32'h00000000;     //Register x0 is hardwired to the constant 0

//        if(!rst) begin
//            for(i = 0; i < 32; i = i + 1) begin
//                xreg[i] <= 32'h00000000;
//            end
//        end
    end
endmodule
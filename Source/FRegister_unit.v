module FRegisters_unit(
    input           clk,
    input           rst,

    //common port
    input   [ 4:0 ] frs1,
    output  [31:0]  fdata_rs1,

    input   [ 4:0 ] frs2,
    output  [31:0]  fdata_rs2,

    input   [ 4:0 ] frs3,
    output  [31:0]  fdata_rs3, 

    input   [ 4:0 ] frd,
    input   [31:0 ] fdata_des,
    input           fdata_valid
);
//31 general-purpose registers f1–f31, which hold floating-point values.
    reg     [31:0]  freg[0:31];        
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            freg[i] = 32'h00000000;
        end
    end

    assign  fdata_rs1    =   freg[frs1];
    assign  fdata_rs2    =   freg[frs2];
    assign  fdata_rs3    =   freg[frs3];

//Values destination
    always @(posedge clk) begin
        if(!rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                freg[i] = 32'h00000000;
            end
        end
        else
            if(fdata_valid) freg[frd] <= fdata_des;
    end
endmodule
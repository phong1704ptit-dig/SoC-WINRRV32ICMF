module Co_memory #(parameter MEM_FILE = "",
                parameter SIZE = 1024)(
    input           clk,

//Bus
    input   [31:0]  mem_addrpred1,
    input   [31:0]  mem_addrpred2,
    output  [15:0]  mem_rdata_pred1,
    output  [15:0]  mem_rdata_pred2, 
    input           mem_renablepred

);
`define ENABLE_READ_INSTR_MEM;
//`define ENABLE_WRITE_INSTR_MEM;

    wire    [31:0]  addr_word1;   assign addr_word1 = mem_addrpred1[31:1];
    wire    [31:0]  addr_word2;   assign addr_word2 = mem_addrpred2[31:1]; 
//Boot
    (* ram_style = "block" *) reg [15:0] MEM_co [0:SIZE*2-1];            //1024 * 4 = 4096 = 4Kb 
    initial begin
        $readmemh(MEM_FILE,MEM_co);
    end

//read instr
`ifdef ENABLE_READ_INSTR_MEM
    reg     [15: 0] rdata1 = 16'h3117;  assign mem_rdata_pred1 = rdata1;
    reg     [15: 0] rdata2 = 16'h2001;  assign mem_rdata_pred2 = rdata2;


    always @(posedge clk) begin
        if(mem_renablepred) begin
            rdata1 <= MEM_co[addr_word1];
        end
    end

    always @(posedge clk) begin
        if(mem_renablepred) begin
            rdata2 <= MEM_co[addr_word2];
        end
    end

`endif

endmodule
module Instruction_memory #(parameter MEM_FILE = "",
                parameter SIZE = 1024)(
    input           clk,
//Bus
    input   [31:0]  mem_addr1,   //address for read or write
    input   [31:0]  mem_addr2,   //address for read or write
    output  [15:0]  mem_rdata1,  //read data  
    output  [15:0]  mem_rdata2,  //read data  
    input   	    mem_renable, //high when CPU wants to read data

    input           mem_wenable,
    input   [31:0]  mem_wdata

);
`define ENABLE_READ_INSTR_MEM;
//`define ENABLE_WRITE_INSTR_MEM;

    wire    [31:0]  addr_word1;   assign addr_word1 = mem_addr1[31:1];
    wire    [31:0]  addr_word2;   assign addr_word2 = mem_addr2[31:1]; 
//Boot
    (* ram_style = "block" *) reg [15:0] MEM [0:SIZE*2-1];            //, ram_write_mode= "read_first" 
    integer i;
    initial begin
        $readmemh(MEM_FILE,MEM);
    end

//read instr
    reg     [15: 0] rdata1 = 16'h2117;  assign mem_rdata1 = rdata1;
    reg     [15: 0] rdata2 = 16'h2000;  assign mem_rdata2 = rdata2;
`ifdef ENABLE_READ_INSTR_MEM
always @(posedge clk) begin
    if (mem_renable)
        rdata1 <= MEM[addr_word1];
end

always @(posedge clk) begin
    if (mem_renable)
        rdata2 <= MEM[addr_word2];
end

`endif

//write instr
`ifdef ENABLE_WRITE_INSTR_MEM
    always @(posedge clk) begin
        if(mem_wenable) MEM[addr_word] <= mem_wdata;
    end
`endif

endmodule
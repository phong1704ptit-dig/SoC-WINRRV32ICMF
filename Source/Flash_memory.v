module Flash_memory #(parameter MEM_FILE = "",
    parameter SIZE = 4096)(

    input           clk,
    input           rst,

//Bus
    input   [31:0]  mem_addr,   //address for load or store
    output  [31:0]  mem_ldata,  //load data  
    input   	    mem_lenable//high when CPU wants to load data
);

    (* ram_style = "block" *) reg [31:0] MEM_data [0:SIZE-1];            
    initial begin
        $readmemh(MEM_FILE,MEM_data);
    end
    wire    [31:0]  addr_word;   assign addr_word = mem_addr[31:2];     //because MEM 32bit

    //read instr
    reg     [31: 0] rdata = 32'b0;  assign mem_ldata = rdata;
    always @(posedge clk) begin
        if(mem_lenable)
            rdata <= MEM_data[addr_word];   
    end

endmodule
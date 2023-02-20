`timescale 1ns / 1ps
module b23_memory(
    input clk,
    input signed [15:0] b23_wrdata,
    input [3:0] wr_b23addr,
	input [3:0] rd_b23addr,
    input we,
    input rd,
    output signed [15:0] b23_rddata
    );
    
    reg signed [15:0] mem [0:9];
    
    //initial 
    //begin
    //$readmemb("b23_bin.txt", mem);
    //end
    
    
    
    always @(posedge clk)
    begin
        if (we)
           mem[wr_b23addr] <= b23_wrdata;
    end

    assign b23_rddata = (rd)?mem[rd_b23addr]:16'h0000;
endmodule

`timescale 1ns / 1ps
module b12_memory(
    input clk,
    input signed [15:0] b12_wrdata,
    input [4:0] wr_b12addr,
	input [4:0] rd_b12addr,
    input we,
    input rd,
    output signed [15:0] b12_rddata 
    );
    
    reg signed [15:0] mem [0:19];
    
    //initial begin
    //$readmemb("b12_bin.txt", mem);
    //end
    
    
    
    always @(posedge clk)
    begin
        if (we)
           mem[wr_b12addr] <= b12_wrdata;
    end

    assign b12_rddata = (rd)?mem[rd_b12addr]:16'h0000;
endmodule



`timescale 1ns / 1ps
module data_memory(
    input clk,
    input signed [1:0] wrdata,
    input [8:0] wraddr,
	input [8:0] rdaddr,
    input we,
    input rd,
    output signed [1:0] rddata
    );
    
    reg signed [1:0] mem [0:255];
    
    //initial 
    //begin
    //$readmemb("a1_bin.txt", mem);
    //end
    
    
    
    always @(posedge clk)
    begin
        if (we)
           mem[wraddr] <= wrdata;
    end
    assign rddata = (rd)?mem[rdaddr]:2'b00;

    
endmodule



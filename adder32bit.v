`timescale 1ns / 1ps
module adder32bit(
    input signed [31:0] a,
    input signed [15:0] b,
    output signed [31:0] out
    );
    wire signed [25:0] z;
    wire signed [31:0] k;
    assign z = {b,10'b0};
    assign k = {{6{z[25]}},z};
    assign out = a+k;
endmodule
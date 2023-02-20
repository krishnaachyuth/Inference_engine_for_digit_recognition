`timescale 1ns / 1ps
module adder(
    input signed[15:0] a,
    input signed[15:0] b,
    output signed[15:0] out
    );
    assign out = a+b;
endmodule
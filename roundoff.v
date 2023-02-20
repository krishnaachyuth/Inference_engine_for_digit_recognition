`timescale 1ns / 1ps
module roundoff(
    input signed [31:0] a,
    output signed [19:0] b
    );
    assign b  = a[25:6];
endmodule
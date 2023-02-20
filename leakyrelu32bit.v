`timescale 1ns / 1ps
module leakyrelu32bit(
    input signed [31:0] a,
    output reg signed [31:0] out
    );
    always @(a)
    begin
        if(a[31])
           out = a>>>3;
        else
           out = a;
    end
endmodule
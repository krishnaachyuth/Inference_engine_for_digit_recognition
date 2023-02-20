`timescale 1ns / 1ps
module leakyrelu(
    input signed [15:0] a,
    output reg signed [15:0] out
    );
    always @(a)
    begin
        if(a[15])
           out = a>>>3;
        else
           out = a;
    end
endmodule

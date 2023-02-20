`timescale 1ns / 1ps
module leakyrelu20bit(
    input signed [19:0] a,
    output reg signed [19:0] out
    );
    always @(a)
    begin
        if(a[19])
           out = a>>>3;
        else
           out = a;
    end
endmodule

`timescale 1ns / 1ps
// this module defines the top module to compile the RTL code for three stages namley stage1, inhiddenout(hidden layer calculations) and final stage (stage where one hot encoding of the final output is done)
// all the inputs here are suplied in q(6.10 - 10 bits as fraction,6 bits are considered as integer) and output as q(6.14 format- 6 integer bits,14 fractional bits)

module top(
input clk,
input reset,
input start,
input signed [15:0] w12_wrdata, 
input signed [1:0] wrdata,
input signed [15:0] b12_wrdata,
input signed [15:0] w23_wrdata,
input signed [15:0] b23_wrdata,
input [12:0] wr_w12addr, // write address bus for writing data to w12 memory
input [4:0] wr_b12addr, // write address bus for writing data to b12 memory
input [8:0] wraddr, // write address bus for writing data to data memory
input [3:0] wr_b23addr, // write address bus for writing data to b23 memory
input [7:0] wr_w23addr, // write address bus for writing data to w23 memory
input we,
input rd,
input we_data,
input rd_data,
input we_b12,
input rd_b12,
input w23_we,
input w23_rd,
input b23_we,
input b23_rd,
output reg done,
output reg [9:0] onehot_enc 
);

wire signed [15:0] stage2_in [0:19];
wire signed [31:0] finalout [0:9];
wire stage1_done,stage2_done;

stage1 c1 (clk,reset,start,w12_wrdata,wr_w12addr,wr_b12addr,wraddr,b12_wrdata,wrdata,we,rd,we_data,rd_data,we_b12,rd_b12,stage2_in,stage1_done);
inhiddenout c2 (clk,reset,stage2_in,stage1_done,wr_b23addr,wr_w23addr,w23_wrdata,b23_wrdata,w23_we,w23_rd,b23_we,b23_rd,finalout,stage2_done);
finalstage  c3 (clk,reset,finalout,stage2_done,done,onehot_enc);

endmodule

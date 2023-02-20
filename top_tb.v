`timescale 1ns / 1ps
module tb;

reg clk;
reg reset;
reg start;

reg signed [15:0] w12_wrdata; 
reg signed [1:0] wrdata;
reg signed [15:0] b12_wrdata;
reg signed [15:0] w23_wrdata;
reg signed [15:0] b23_wrdata;
reg we;
reg rd;
reg we_data;
reg rd_data;
reg we_b12;
reg rd_b12;
reg w23_we;
reg w23_rd;
reg b23_we;
reg b23_rd;
reg done;
reg [12:0] wr_w12addr; // write address bus for writing data to w12 memory
reg [4:0] wr_b12addr; // write address bus for writing data to b12 memory
reg [8:0] wraddr; // write address bus for writing data to data memory
reg [3:0] wr_b23addr; // write address bus for writing data to b23 memory
reg [7:0] wr_w23addr; // write address bus for writing data to w23 memory
wire  [9:0] onehot_enc;

reg signed [15:0] b12_mem [0:19];
reg signed [15:0] b23_mem [0:9];
reg signed [15:0] w23_mem [0:199];
reg signed [15:0] w12_mem [0:5119];
reg signed [1:0] data_mem [0:255];


top TEST (clk,reset,start,w12_wrdata,wrdata,b12_wrdata,w23_wrdata,b23_wrdata,wr_w12addr,wr_b12addr,wraddr,wr_b23addr,wr_w23addr,we,rd,we_data,rd_data,we_b12,rd_b12,w23_we,w23_rd,b23_we,b23_rd,done,onehot_enc);

initial begin
 $readmemb("b12_bin.txt", b12_mem);
 $readmemb("b23_bin.txt", b23_mem);
 $readmemb("w12_bin.txt", w12_mem);
 $readmemb("w23_bin.txt", w23_mem);
 $readmemb("a1_bin.txt", data_mem);
 
end

initial begin
clk=0;
forever #5  clk=!clk;
end

integer i,j,k,l,m;

initial 
begin 
we=1'b1;
for(i=0;i<5200;i=i+1)
begin
	#10 w12_wrdata=w12_mem[i];
	wr_w12addr = i;
end
#10 we=1'b0;
rd=1'b1;
end

initial 
begin 
we_b12=1'b1;
for(j=0;j<20;j=j+1)
begin
	#10 b12_wrdata=b12_mem[j];
	wr_b12addr = j;
end
#10 we_b12=1'b0;
rd_b12=1'b1;
end


initial 
begin 
w23_we=1'b1;
for(k=0;k<200;k=k+1)
begin
	#10 w23_wrdata=w23_mem[k];
	wr_w23addr = k;
end
#10 w23_we=1'b0;
w23_rd=1'b1;
end


initial 
begin 
b23_we=1'b1;
for(l=0;l<10;l=l+1)
begin
	#10 b23_wrdata=b23_mem[l];
	wr_b23addr = l;
end
#10 b23_we=1'b0;
b23_rd=1'b1;
end


initial 
begin 
we_data=1'b1;
for(m=0;m<256;m=m+1)
begin
	#10 wrdata=data_mem[m];
	wraddr = m;
end
#10 we_data=1'b0;
rd_data=1'b1;
end


initial 
begin
#52020;	
reset=1;
#20 reset=0; 
#50 start=1;
#55 start = 0;


$readmemb("a1_bin.txt", data_mem);

we_data=1'b1;
for(m=0;m<256;m=m+1)
begin
	#10 wrdata=data_mem[m];
	wraddr = m;
end
#10 we_data=1'b0;
rd_data=1'b1;
start=1'b1;
#50 start=1'b0;



#53770;
$readmemb("a5_bin.txt", data_mem);

we_data=1'b1;
for(m=0;m<256;m=m+1)
begin
	#10 wrdata=data_mem[m];
	wraddr = m;
end
#10 we_data=1'b0;
rd_data=1'b1;
start=1'b1;
#50 start=1'b0;
#10 $strobe(onehot_enc);



#53770;
$readmemb("a6_bin.txt", data_mem);

we_data=1'b1;
for(m=0;m<256;m=m+1)
begin
	#10 wrdata=data_mem[m];
	wraddr = m;
end
#10 we_data=1'b0;
rd_data=1'b1;
start=1'b1;
#50 start=1'b0;
#10 $strobe(onehot_enc);


#53770;
$readmemb("a7_bin.txt", data_mem);

we_data=1'b1;
for(m=0;m<256;m=m+1)
begin
	#10 wrdata=data_mem[m];
	wraddr = m;
end
#10 we_data=1'b0;
rd_data=1'b1;
start=1'b1;
#50 start=1'b0;
#10 $strobe(onehot_enc);

#53770;
$readmemb("a8_bin.txt", data_mem);

we_data=1'b1;
for(m=0;m<256;m=m+1)
begin
	#10 wrdata=data_mem[m];
	wraddr = m;
end
#10 we_data=1'b0;
rd_data=1'b1;
start=1'b1;
#50 start=1'b0;

#10 $strobe(onehot_enc);

#53770;
$readmemb("digitthree_bin.txt", data_mem);

we_data=1'b1;
for(m=0;m<256;m=m+1)
begin
	#10 wrdata=data_mem[m];
	wraddr = m;
end
#10 we_data=1'b0;
rd_data=1'b1;
start=1'b1;
#50 start=1'b0;

#10 $strobe(onehot_enc);

#53770;
$readmemb("digittwo_bin.txt", data_mem);

we_data=1'b1;
for(m=0;m<256;m=m+1)
begin
	#10 wrdata=data_mem[m];
	wraddr = m;
end
#10 we_data=1'b0;
rd_data=1'b1;
start=1'b1;
#50 start=1'b0;

#10 $strobe(onehot_enc);

#53770;
$readmemb("digitzero_bin.txt", data_mem);

we_data=1'b1;
for(m=0;m<256;m=m+1)
begin
	#10 wrdata=data_mem[m];
	wraddr = m;
end
#10 we_data=1'b0;
rd_data=1'b1;
start=1'b1;
#50 start=1'b0;

#10 $strobe(onehot_enc);

#53770;
$readmemb("digitfive_bin.txt", data_mem);

we_data=1'b1;
for(m=0;m<256;m=m+1)
begin
	#10 wrdata=data_mem[m];
	wraddr = m;
end
#10 we_data=1'b0;
rd_data=1'b1;
start=1'b1;
#50 start=1'b0;

#10 $strobe(onehot_enc);

#53770;
$readmemb("digit0_bin.txt", data_mem);

we_data=1'b1;
for(m=0;m<256;m=m+1)
begin
	#10 wrdata=data_mem[m];
	wraddr = m;
end
#10 we_data=1'b0;
rd_data=1'b1;
start=1'b1;
#50 start=1'b0;

#50 $strobe(onehot_enc);


end
endmodule
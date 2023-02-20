`timescale 1ns / 1ps
// inputs to this stage are w12,b12 and image. 
// input to this stage is the w12 data which is the weight computed over matlab and the b12 data which is bias applied between layer 1 and layer 2 
// the output of this stage is fed as input to the next stage 
// signed inputs are used to represent 2's compliment format. since some weights are negative we need to use 2's compliment to represent numbers.
// all the inputs here are suplied as q(6.10 - 6 integer bites,10 fractional bits) and output as q(6.14 format- 6 integer bits,14 fractional bits)


module stage1(
input clk, // clock,reset and start are the global signals. 
input reset,
input start,
input signed [15:0] w12_wrdata, // to write data to memory using test bench. w12 is data of size 20*256,considering each element as 16 bits to store the data into w12 memory it takes 20*256 clock cycles.
input [12:0] wr_w12addr, // write address bus for writing data to w12 memory
input [4:0] wr_b12addr, // write address bus for writing data to b12 memory
input [8:0] wraddr, // write address bus for writing data to data memory
input signed [15:0] b12_wrdata, //  to write data to memory using test bench. b12 is data of size 20*1,considering each element as 16 bits to store the data into b12 memory  it takes 20*1 clock cycles.
input signed [1:0] wrdata, // pushing 2 bits of image data of size 256 which takes 256 clock cycles to load, though the image is b/w we are considering 2 bits to represent in 2's complement form. 
input we, // write enable for the w12 memory
input rd, // read enable for w12 memory
input we_data, // write enable for input image memory
input rd_data, // read enable for input image memory
input we_b12, // write enable for b12 memory
input rd_b12, // read enable for b12 memory
output reg signed [15:0] stage2_in[0:19], // output of stage1 which is fed as input to the second stage.
output reg stage1_done // signal to start the second stage computation.

);

reg signed [15:0] z2 [0:19]; // output after the first stage MAC( multiplier and accumulator) operation.
reg signed [15:0] hidlayer_out; // output after adding first stage bias(b12) constants. 
reg signed [1:0]  data; // reg variable to read and store image data(pixel) from memory. 
reg signed [15:0] w12 [0:19]; // w12 is the weights between layer one and layer two of size 20X256 
reg signed [15:0] b12;


wire signed [15:0] stage1_out; // the output of stage1 of 16 bit wide which is fetched to the second stage 

//state variables for multiplier and adder.
parameter RESET = 1'b0;
parameter MULT  = 1'b1;
parameter ADD_RESET = 1'b0;
parameter ADD = 1'b1;

// state variable for multiplier and adder
reg state;  
reg add_state;

reg stage1_mac_done; // signals to represent the MAC operation as done which is used to start the calculation at next stage.
reg stage1_mac_delay; // stage1_mac_done signal delayed by one clock cycle(to detect the positive edge of mac_done signal)

// wires to connect from memory output to input 
wire signed [15:0] w12wire;
wire signed [15:0] b12wire;
wire signed [1:0] data_i;

// counters to update the state variables
reg [8:0] i; // 
reg [4:0] k; //
reg [4:0] l; //
wire [12:0] b12_addr;

integer j;
//assign b12_addr = 13'b0000100000000*k+i;
//w12_memory a1 (clk,w12_wrdata,b12_addr, we,rd,w12wire);
//data_memory a2 (clk,wrdata, i, we_data,rd_data,data_i);

always @(posedge clk)
begin
    if (reset)
    begin
        i <= 9'b0;  //initialising the variables to 0's 
        k <= 5'b0;  // used to wait for 20 clock cycles to load data from memory to w12 register 
		for (j = 0; j < 20; j = j + 1) begin
               z2[j] <= 16'b0;  // initialising the output of MAC to zero before the calculation starts. 
        end
        state <= RESET;
        stage1_mac_done <= 1'b0;
    end
    else begin
    case(state)      // using a state machine to loop through different stages at this stage, once the start signal is triggered it reaches to the next state which is the multiplication stage 
        RESET:begin
           if(start)
            begin
				i <= 9'b0;  //initialising the variables to 0's 
				k <= 5'b0;  // used to wait for 20 clock cycles to load data from memory to w12 register 
				for (j = 0; j < 20; j = j + 1) begin
					z2[j] <= 16'b0;  // initialising the output of MAC to zero before the calculation starts. 
				end
                state <= MULT;
				stage1_mac_done=1'b0;
            end 
        end
        MULT:begin
            if(i[8]==1'b1)  // checking if the 8th bit of i is equal to 1 and setting the wire stage1_mac_done i.e the multiplication of all values in stage one(i.e waiting for 20*256 cycles) is done and reseting the state machine to the initial stage 
            begin
                stage1_mac_done <= 1'b1;
                state <= RESET;
            end
            else if(k==5'b10100) // waiting for the data(from data memory ) and w12(from w12 memory) to load for the multiplication calculation to start 
            begin
                z2[0] <= data*w12[0]+z2[0];  // these represent the MAC operation for each node in hidden layer. (hidden layer is 20 nodes)
                z2[1] <= data*w12[1]+z2[1];
                z2[2] <= data*w12[2]+z2[2];
                z2[3] <= data*w12[3]+z2[3];
                z2[4] <= data*w12[4]+z2[4];
                z2[5] <= data*w12[5]+z2[5];
                z2[6] <= data*w12[6]+z2[6];
                z2[7] <= data*w12[7]+z2[7];
                z2[8] <= data*w12[8]+z2[8];
                z2[9] <= data*w12[9]+z2[9];
                z2[10] <= data*w12[10]+z2[10];
                z2[11] <= data*w12[11]+z2[11];
                z2[12] <= data*w12[12]+z2[12];
                z2[13] <= data*w12[13]+z2[13];
                z2[14] <= data*w12[14]+z2[14];
                z2[15] <= data*w12[15]+z2[15];
                z2[16] <= data*w12[16]+z2[16];
                z2[17] <= data*w12[17]+z2[17];
                z2[18] <= data*w12[18]+z2[18];
                z2[19] <= data*w12[19]+z2[19];
                i <= i+1'b1;
                k <= 5'b0;
            end
            else
            begin
                w12[k] <= w12wire; // loading values into w12 memory using wire
                data <= data_i; // loading the image data using data_i wire. 
                k <= k+1'b1; // incrementing the value of k at every clock cycle for 20 cycles to make sure the w12 data is loaded. 
            end
        end
    endcase
  end
 end

assign b12_addr = 13'b0000100000000*k+i; // taking address lines of size 256*k+i.
w12_memory a1 (clk,w12_wrdata,wr_w12addr,b12_addr, we,rd,w12wire); //loading w12 data from module w12_memory
data_memory a2 (clk,wrdata,wraddr, i,we_data,rd_data,data_i); // loading image data from data_memory


  // delay the done signal by one clk pulse to start the second stage on +ve edge of done signal of clk
  always @(posedge clk)
  begin
     if (reset)
        stage1_mac_delay <= 1'b0;
    else
        stage1_mac_delay <= stage1_mac_done;
 end

b12_memory a3 (clk,b12_wrdata,wr_b12addr,l,we_b12,rd_b12,b12wire); // loading b12(bias) from module b12_memory 

always @(posedge clk)  //on the positive edgee of the clock we are incrementing the value of l for further add and leaky relu operations and store it in stage2_in variable
begin
    if (reset)
    begin
        l <= 5'b0;
        add_state <= ADD_RESET;
        stage1_done <= 1'b0;
    end
    else begin
    case (add_state)
    ADD_RESET: begin
        if(!stage1_mac_delay && stage1_mac_done)
        begin
			l <= 5'b0;
            stage1_done <= 1'b0;
            add_state <= ADD;
        end
    end
    ADD: begin
        if (l==5'b10100)
            begin
                stage1_done <= 1'b1;
                add_state <= ADD_RESET;
            end
        else
            begin
                l <= l+1'b1;
            end
    end
    endcase
    end
end

// add the constant b12 to intermediate data
 adder u1 (z2[l], b12wire, stage1_out); // computing the addition of values obtained from Z2 with the bias and storing the output in stage1_out

 
 //apply leakyrelu function
leakyrelu u2 (stage1_out, hidlayer_out); // applying the activation function - this algorithm uses the activation function leaky relu 

// store the results in second stage input
always @(posedge clk)
 begin
    if (reset)
    begin
        for (j = 0; j < 20; j = j + 1) begin
             stage2_in[j] <= 16'b0;
        end
    end
    else
      stage2_in[l] <= hidlayer_out;  // pushing the values of the hidlayer_out to stage2_in which serves as input to the second stage
 end

endmodule

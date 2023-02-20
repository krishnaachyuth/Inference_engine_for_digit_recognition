`timescale 1ns / 1ps
// this module computes the maximum value of the final_out array and one hot encoding of the same which represents the image value between 0-9

module finalstage(
input clk, // clock,reset are the global signals. 
input reset,
input signed [31:0] stage3_in [0:9], // input the final stage which is of 10 nodes each of size 20 bits 
input stage2_done, // signal which represents stage2 calculations as done
output reg done, // final done signal which shows that all stage calculations are done
output reg [9:0] onehot_enc // signal which representa the classification value between 0-9
);


reg signed [31:0] final_out; // 

reg stage3_maxval_state;
reg stage2_done_delay;

parameter STAGE3_RESET = 1'b0;
parameter STAGE3_MAXVAL = 1'b1;

// counters to update the state variables
reg [3:0] z;
reg [3:0] max_out;

// delay the done signal by on:e clk pulse to start the second stage on +ve edge of done signal of clk
 always @(posedge clk)
 begin
    if (reset)
        stage2_done_delay <= 1'b0;
    else
        stage2_done_delay <= stage2_done;
 end
 
 
 // compute the max value
 always @(posedge clk) 
 begin
    // reset the registers
    if(reset)
    begin
        stage3_maxval_state <= STAGE3_RESET;
		z<=4'b0;		
        max_out <= 4'b0;
        onehot_enc <= 10'b0;
        done <= 1'b0;
    end
    else begin
    case (stage3_maxval_state)
    STAGE3_RESET:begin
        if(!stage2_done_delay && stage2_done)
        begin
			z<=4'b0;		
			max_out <= 4'b0;
            done <= 1'b0;
            stage3_maxval_state <= STAGE3_MAXVAL;
        end
    end
    STAGE3_MAXVAL:begin
       if(z==4'b1010)
        begin
            done <= 1'b1;
            onehot_enc <= 10'b0000000001<<max_out;
            stage3_maxval_state <= STAGE3_RESET;
        end
        else
        begin
		    if(stage3_in[z]>stage3_in[max_out])
		    begin
		      max_out <= z;
		    end
            z<= z+1'b1;
        end
    end
   endcase
   end
 end
endmodule

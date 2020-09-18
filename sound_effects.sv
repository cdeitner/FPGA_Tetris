// Description: This module controls the frequencies being used to assign
// data to the audio codec interface

module sound_effects #(parameter BIT_WIDTH = 21) (clk, reset, enable, sound, freq, write_en);
	input logic clk, reset, enable;
	input logic [1:0] sound;
	//input logic [9:0] SW;
	
	output logic write_en;
	output logic [19:0] freq;

	logic [BIT_WIDTH:0] counter;  //MSB changes every quarter second, 24

	//Sequential logic to hold write_en high for half a second
	//after enable goes high
	always_ff @(posedge clk) begin
		if(reset)
			write_en <= 0;
		else if(enable)
			write_en <= 1;
		else if (counter == 0)	
			write_en <= 0;  
	end

	//Incrementing counter when write_en is high
	always_ff @(posedge clk) begin
		if(~write_en)
			counter <= 1;  //initializing to zero so we can check later if its 0
		else begin
			counter <= counter + 1;
		end
	end
	
	always_comb begin
		case(sound)
			//key press
			2'b00:	freq = 523;
			
			//block landing
			2'b01:	freq = counter[BIT_WIDTH] ? 262 : 523;
			
			//row cleared
			2'b10:  freq = counter[BIT_WIDTH] ? 523 : 262;
			
			//game lost
			2'b11:  freq = counter[BIT_WIDTH] ? 65 : 262;
		endcase
	end

	//First play freq. 523 for 1/4 of a second, then freq. 262 for 1/4 of a second
//	always_ff @(posedge clk) begin
//		if(!counter[23])
//			freq <= 523;
//		else
//			freq <= 262;
//	end
//
//		always_ff @(posedge clk) begin
//		if(sound) begin
//			if(!counter[21])
//				freq <= 523;
//			else
//				freq <= 262;
//		end
//		else begin
//			freq <= 523;
//		end
		
	//end




endmodule 
/*
module sound_effects_testbench();
	logic clk, reset, key_press;
	logic write_en;
	logic [19:0] freq;
	
	sound_effects dut(.*);
	
	parameter PERIOD = 100;
	
	initial begin
		clk <= 0;
		forever #(PERIOD/2) clk = ~clk;
	end
	
	initial begin
		@(posedge clk);	reset <= 1; 
		@(posedge clk);	reset <= 0; key_press <= 1;
		@(posedge clk);				key_press <= 0;
		@(posedge clk);
		@(posedge clk); 
		@(posedge clk); 
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);	
		@(posedge clk);	
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);	
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk); key_press <= 1;
		@(posedge clk); key_press <= 0;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk); key_press <= 1;
		@(posedge clk); key_press <= 0;
		@(posedge clk);
		@(posedge clk);
		
		$stop();
	
	end


endmodule 
*/
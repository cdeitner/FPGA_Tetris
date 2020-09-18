//outputs the corresponding control signal for one clock cycle when the key
//		is pressed. Only one pulse is delivered for each key stroke.
//		Keys that are being looked for are the arrow keys.


module TetrisKeyboard (clk, reset, PS2_DAT, PS2_CLK, rotate, down, left, right);
	input logic clk, reset, PS2_DAT, PS2_CLK;
	output logic rotate, down, left, right;
	logic valid, makeBreak;
	logic [7:0] outCode;

	keyboard_press_driver getKeysPressed (.*);
	
	TetrisKey upKey (.clk, .reset, .valid, .makeBreak, 
							.codeCorrect(outCode == 8'h75), .pressed(rotate));
	TetrisKey rightKey (.clk, .reset, .valid, .makeBreak, 
							.codeCorrect(outCode == 8'h74), .pressed(right));
	TetrisKey downKey (.clk, .reset, .valid, .makeBreak, 
							.codeCorrect(outCode == 8'h72), .pressed(down));
	TetrisKey leftKey (.clk, .reset, .valid, .makeBreak, 
							.codeCorrect(outCode == 8'h6b), .pressed(left));

endmodule							
						
						
							
//*****************************************************************
//UNORTHADOX TESTBENCH
//*****************************************************************
	//because the PS2 inputs using serial communication and is relatively
	// complicated to simulate on a testbench I have replicated the exact
	// module above but with counters that count the number of clock cycles
	// the ouputs are held high. They should incriment by only one per key press
	
//To use this testbench:	
	//comment out the module above and uncomment the module below and that is it
	//the conters will be displayed on the DE1 hex display
	
/*	

module TetrisKeyboard (CLOCK_50, PS2_DAT, PS2_CLK, rotate, down, left, right, 
								HEX0, HEX1, HEX2, HEX3, KEY);
	input logic CLOCK_50, PS2_DAT, PS2_CLK;
	input logic [3:0] KEY;
	output logic rotate, down, left, right;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3;
	logic valid, makeBreak;
	logic [7:0] outCode;
	logic clk, reset;
		
	assign clk = CLOCK_50;
	assign reset = ~KEY[0];

	keyboard_press_driver getKeysPressed (.*);
	
	TetrisKey upKey (.clk, .reset, .valid, .makeBreak, 
							.codeCorrect(outCode == 8'h75), .pressed(rotate));
	TetrisKey rightKey (.clk, .reset, .valid, .makeBreak, 
							.codeCorrect(outCode == 8'h74), .pressed(right));
	TetrisKey downKey (.clk, .reset, .valid, .makeBreak, 
							.codeCorrect(outCode == 8'h72), .pressed(down));
	TetrisKey leftKey (.clk, .reset, .valid, .makeBreak, 
							.codeCorrect(outCode == 8'h6b), .pressed(left));	
	
	
	
	
	
	
//---------------------------------------------------
//Added testbench code
	
	
	logic [3:0] rot_cntr, d_cntr, l_cntr, right_cntr;
	
	//counts the number of clock cycles rotate is high
	always_ff @(posedge clk) begin
		if (reset) 
			rot_cntr <= 0;
		else if (rotate)
			rot_cntr <= rot_cntr + 1;
	end

	//counts the number of clock cycles down is high
	always_ff @(posedge clk) begin
		if (reset) 
			d_cntr <= 0;
		else if (down)
			d_cntr <= d_cntr + 1;
	end
	
	//counts the number of clock cycles left is high
	always_ff @(posedge clk) begin
		if (reset) 
			l_cntr <= 0;
		else if (left)
			l_cntr <= l_cntr + 1;
	end
	
	//counts the number of clock cycles right is high
	always_ff @(posedge clk) begin
		if (reset) 
			right_cntr <= 0;
		else if (right)
			right_cntr <= right_cntr + 1;
	end	
	
	//display counters
	HEX_Decoder upcntr (.clk, .reset, .num(rot_cntr), .HEX(HEX0));
	HEX_Decoder dcntr (.clk, .reset, .num(d_cntr), .HEX(HEX1));
	HEX_Decoder leftcntr (.clk, .reset, .num(l_cntr), .HEX(HEX2));
	HEX_Decoder rightcntr (.clk, .reset, .num(right_cntr), .HEX(HEX3));
	
						
							
endmodule
*/


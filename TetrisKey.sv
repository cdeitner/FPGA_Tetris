
//Outputs 'pressed' for one clock cycle when the 'codeCorrect' key has been pressed
//	Only outputs once for each press and takes into account that the current key code
//	will continue to be output intill it is released	

module TetrisKey (clk, reset, valid, makeBreak, codeCorrect, pressed);
	input logic clk, reset, valid, makeBreak, codeCorrect;
	output logic pressed;
	logic pressed_next;
	
	enum {unpressed, keyPressed, held} ps, ns;
	
	//output register
	always_ff @(posedge clk) begin
		if (reset)
			pressed <= 0;
		else 
			pressed <= pressed_next;
	end
	
	
	//FSM flip flop
	always_ff @(posedge clk) begin
		if (reset)
			ps <= unpressed;
		else 
			ps <= ns;
	end
	
	//FSM
	always_comb begin
		case(ps)
			unpressed: 	//key is not pressed
				begin
					pressed_next = 1'b0;							
					if (valid && makeBreak && codeCorrect)
						ns = keyPressed;
					else 
						ns = unpressed;
				end
				
			keyPressed: //key is initially pressed
				begin
					pressed_next = 1'b1;
					ns = held;
				end
				
			held:			//key is currently pressed
				begin
					pressed_next = 1'b0;
					if (valid && ~makeBreak && codeCorrect)
						ns = unpressed;
					else
						ns = held;
				end
				
			default: 
				begin
					ns = unpressed;
					pressed_next = 1'b0;
				end
		endcase
	end

endmodule
						
			
module TetrisKey_TestBench ();
	logic clk, reset, valid, makeBreak, codeCorrect;
	logic pressed;
	integer i;
		
	TetrisKey dut (.*);		
	
	parameter PERIOD = 100;
	
	initial begin
		clk <= 0;
		forever #(PERIOD/2) clk = ~clk;
	end
		
	initial begin
	
		@(posedge clk); 	valid <= 0; makeBreak <= 0; codeCorrect <= 0;
		@(posedge clk);	reset <= 1;
		@(posedge clk);	reset <= 0;
		
		//different key pressed
		@(posedge clk); 	valid <= 1; makeBreak <= 1; codeCorrect <= 0;
		@(posedge clk); 	valid <= 0; makeBreak <= 0; codeCorrect <= 0;		
		for (i=0;i<3; i=i+1) @(posedge clk); 
		
		//correct key pressed & pressed should only be one pulse
		@(posedge clk); 	valid <= 1; makeBreak <= 1; codeCorrect <= 1;		
		@(posedge clk); 	valid <= 0; makeBreak <= 0; codeCorrect <= 1;
		for (i=0;i<5; i=i+1) @(posedge clk);
		
		//check for glitches in control signals
		@(posedge clk); 	valid <= 0; makeBreak <= 0; codeCorrect <= 1;
		@(posedge clk); 	valid <= 1; makeBreak <= 1; codeCorrect <= 0;
		@(posedge clk); 	valid <= 1; makeBreak <= 0; codeCorrect <= 0;
		@(posedge clk); 	valid <= 0; makeBreak <= 0; codeCorrect <= 0;
		
		//correct key released no pulse should be in "unpressed" state
		@(posedge clk); 	valid <= 1; makeBreak <= 0; codeCorrect <= 1;
		@(posedge clk); 	valid <= 0; makeBreak <= 0; codeCorrect <= 1;
		for (i=0;i<5; i=i+1) @(posedge clk);
		
		//check for glitches in control signal in unpressed state
		@(posedge clk); 	valid <= 0; makeBreak <= 0; codeCorrect <= 1;
		@(posedge clk); 	valid <= 1; makeBreak <= 1; codeCorrect <= 0;
		@(posedge clk); 	valid <= 1; makeBreak <= 0; codeCorrect <= 0;
		@(posedge clk); 	valid <= 0; makeBreak <= 0; codeCorrect <= 0;
		
		//very quick press and release of key
		@(posedge clk); 	valid <= 1; makeBreak <= 1; codeCorrect <= 1;
		for (i=0;i<4; i=i+1) @(posedge clk); //driver takes 4 cycles to update
		@(posedge clk); 	valid <= 1; makeBreak <= 0; codeCorrect <= 1;
		@(posedge clk); 	valid <= 0; makeBreak <= 0; codeCorrect <= 0;
		@(posedge clk);

		
		$stop();
	end

endmodule		

			
			
			
			
			
			
			
			
			
			
					
module Move_Valid #(parameter PLAY_WIDTH = 10,
							 parameter PLAY_HEIGHT = 15, 
							 parameter PIX_PER_BLK = 32)		
						(clk, reset, background_height, next_location, not_valid);
						
	input logic clk, reset;
	input logic [(PLAY_WIDTH*PLAY_HEIGHT)-1:0] background_height;
	input logic [(PLAY_WIDTH*PLAY_HEIGHT)-1:0] next_location; 
	
	output logic not_valid;
	
	logic block_v, leftRight_v, topBottom_v;
	logic [(PLAY_HEIGHT-1):0] left_col, right_col; 	
	

	
	//check if next_location overlaps background height
	assign block_v = ((next_location & background_height) > 0);
		
		
	//check left and right columns
	integer i;
	always_comb begin
		for (i=0; i<PLAY_HEIGHT; i=i+1) begin
			left_col[i]   = next_location[0+PLAY_WIDTH*i];
			right_col[i]  = next_location[(PLAY_WIDTH-1)+(PLAY_WIDTH*i)];
		end
	end
		
	assign leftRight_v = left_col && right_col;
	
	
	//check top and bottom rows
	assign topBottom_v = next_location[PLAY_WIDTH-1:0] &&
						next_location[(PLAY_HEIGHT*PLAY_WIDTH)-1:(PLAY_WIDTH*(PLAY_HEIGHT-1))];
	

	//if interference raise not_valid output
	assign not_valid = block_v || leftRight_v || topBottom_v;
	
			
endmodule



module Move_Valid_testbench #(parameter PLAY_WIDTH = 10,
										  parameter PLAY_HEIGHT = 15, 
										  parameter PIX_PER_BLK = 32) ();
	logic clk, reset;
	logic [(PLAY_WIDTH*PLAY_HEIGHT)-1:0] background_height;
	logic [(PLAY_WIDTH*PLAY_HEIGHT)-1:0] next_location; 
	
	logic not_valid;
		
	Move_Valid dut (.*);
		
	parameter PERIOD = 100;
	
	initial begin
		clk <= 0;
		forever #(PERIOD/2) clk = ~clk;
	end
		
	initial begin
	
		@(posedge clk);
		@(posedge clk);	background_height <= 0;								
								next_location <= 0; 
								
		@(posedge clk);	reset <= 1;					
		@(posedge clk);	reset <= 0;		
		
		//check for normal situation
		@(posedge clk);	background_height[149:102] <= 48'hFFFFFFFFFFFF;								
								next_location[123:120] <= 4'hF;  			
		//reset
		@(posedge clk);	background_height <= 0;								
								next_location <= 0;
						
						
		//check block crossing bottom			
		@(posedge clk);	background_height <= 0;								
								next_location[144] <= 1'b1;
								next_location[4] <= 1'b1;																
		//reset						
		@(posedge clk);	background_height <= 0;								
								next_location <= 0; 

								
		//check block crossing sides					
		@(posedge clk);	background_height <= 0;								
								next_location[122:119] <= 4'hF; 
		//reset						
		@(posedge clk);	background_height <= 0;								
								next_location <= 0; 
						
		
		//check block overlapping another block					
		@(posedge clk);	background_height[149:134] <= 16'hFFFF;								
								next_location[134] <= 1;
		//reset						
		@(posedge clk);	background_height <= 0;								
								next_location <= 0; 							
	
		@(posedge clk);
		@(posedge clk);
	
		$stop();
	end

endmodule	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

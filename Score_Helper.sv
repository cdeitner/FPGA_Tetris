module Score_Helper #(parameter PLAY_WIDTH = 10,
							 parameter PLAY_HEIGHT = 15, 
							 parameter ROW = 1)		
						(clk, reset, background_height, prev_playfield_i, 
						 updated_prev_playfield_i_i, next_background_height_i, score_i);
						
	input logic clk, reset;
	input logic [(PLAY_WIDTH*PLAY_HEIGHT)-1:0] background_height;
	input logic [2:0] prev_playfield_i [0:(PLAY_WIDTH*PLAY_HEIGHT)-1];


	output logic [2:0] updated_prev_playfield_i_i [0:(PLAY_WIDTH*PLAY_HEIGHT)-1];
	output logic [(PLAY_WIDTH*PLAY_HEIGHT)-1:0] next_background_height_i; 	
	output logic score_i;
	
	logic [2:0] paddedzeros [9:0];	
	assign paddedzeros = '{default:0};
	
	//logic [2:0] prev_playfield_i_i [0:(PLAY_WIDTH*PLAY_HEIGHT)-1];
	//assign prev_playfield_i_i = prev_playfield_i;

	integer j;	
	always_comb begin
		updated_prev_playfield_i_i = prev_playfield_i;
		next_background_height_i = background_height;

		
		//if(score_i) begin
			next_background_height_i[(((ROW)*PLAY_WIDTH)+9):0] = {background_height[(((ROW)*PLAY_WIDTH)-1):0], 10'b0};
			for(j=PLAY_WIDTH; j<((ROW+1)*PLAY_WIDTH); j=j+1) begin			
				updated_prev_playfield_i_i[j] = prev_playfield_i[j-PLAY_WIDTH];
			end
			
			
			//updated_prev_playfield_i_i[(((ROW)*PLAY_WIDTH)+10):149] = {paddedzeros, prev_playfield_i[(((ROW)*PLAY_WIDTH)+9):149]};
			
		
		//end
		
	end
		
	
	always_comb begin
		if (background_height[((PLAY_WIDTH-1)+(ROW*PLAY_WIDTH))-:10] == 10'b1111111111)
			score_i = 1;
		else
			score_i = 0;				
	end
	
	
	
	
	
endmodule

module Score_Helper_testbench #(parameter PLAY_WIDTH = 10,
										  parameter PLAY_HEIGHT = 15, 
										  parameter PIX_PER_BLK = 32) ();
	logic clk, reset;
	logic [(PLAY_WIDTH*PLAY_HEIGHT)-1:0] background_height;
	logic [2:0] prev_playfield_i [0:(PLAY_WIDTH*PLAY_HEIGHT)-1];

	logic [2:0] updated_prev_playfield_i_i [0:(PLAY_WIDTH*PLAY_HEIGHT)-1];
	logic [(PLAY_WIDTH*PLAY_HEIGHT)-1:0] next_background_height_i; 	
	logic score_i;

		
	Score_Helper dut (.*);
		
	parameter PERIOD = 100;
	
	initial begin
		clk <= 0;
		forever #(PERIOD/2) clk = ~clk;
	end
		
	initial begin
	
		@(posedge clk);	
		@(posedge clk);	background_height <= 0;	
								prev_playfield_i <= '{default:0};
								
		@(posedge clk);	reset <= 1;					
		@(posedge clk);	reset <= 0;		
		
		//check for just bottom line filled
		@(posedge clk);	background_height[149:134] <= 16'hFFFF;								
		//reset
		@(posedge clk);	background_height <= 0;								
						
						
		//check block crossing bottom			
		@(posedge clk);	background_height <= 0;								
		//reset						
		@(posedge clk);	background_height <= 0;								

								
		//check block crossing sides					
		@(posedge clk);	background_height <= 0;								
		//reset						
		@(posedge clk);							
						
		
		//check block overlapping another block					
		@(posedge clk);	background_height[149:118] <= 32'hFFFFFFFF;								
		//reset						
		@(posedge clk);	background_height <= 0;								
	
		@(posedge clk);
		@(posedge clk);
	
		$stop();
	end

endmodule	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
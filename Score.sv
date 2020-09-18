module Score 	#(parameter PLAY_WIDTH = 10,
					  parameter PLAY_HEIGHT = 15, 
					  parameter PIX_PER_BLK = 32)		
				(clk, reset, background_height, prev_playfield_i, 
				 updated_prev_playfield_i, next_background_height, score);
						
	input logic clk, reset;
	input logic [(PLAY_WIDTH*PLAY_HEIGHT)-1:0] background_height;
	input logic [2:0] prev_playfield_i [0:(PLAY_WIDTH*PLAY_HEIGHT)-1];


	output logic [2:0] updated_prev_playfield_i [0:(PLAY_WIDTH*PLAY_HEIGHT)-1];
	output logic [(PLAY_WIDTH*PLAY_HEIGHT)-1:0] next_background_height; 	
	output logic score;
	

	logic [3:0] row;
	
	logic [2:0] updated_prev_playfield_i_i [1:PLAY_HEIGHT-1] [0:(PLAY_WIDTH*PLAY_HEIGHT)-1];
	logic [(PLAY_WIDTH*PLAY_HEIGHT)-1:0] next_background_height_i [1:PLAY_HEIGHT-1];
	logic score_i [1:PLAY_HEIGHT-1];
	
	
	Score_Helper #(.ROW(1))  rowCheck1  
					  (.clk, .reset, .background_height, .prev_playfield_i, 
						.updated_prev_playfield_i_i(updated_prev_playfield_i_i[1]),
						.next_background_height_i(next_background_height_i[1]), 
						.score_i(score_i[1]));
					
	Score_Helper #(.ROW(2))  rowCheck2 
					  (.clk, .reset, .background_height, .prev_playfield_i, 
						.updated_prev_playfield_i_i(updated_prev_playfield_i_i[2]),
						.next_background_height_i(next_background_height_i[2]), 
						.score_i(score_i[2]));
						
	Score_Helper #(.ROW(3))  rowCheck3  
					  (.clk, .reset, .background_height, .prev_playfield_i, 
						.updated_prev_playfield_i_i(updated_prev_playfield_i_i[3]),
						.next_background_height_i(next_background_height_i[3]), 
						.score_i(score_i[3]));
						
	Score_Helper #(.ROW(4))  rowCheck4 
					  (.clk, .reset, .background_height, .prev_playfield_i, 
						.updated_prev_playfield_i_i(updated_prev_playfield_i_i[4]),
						.next_background_height_i(next_background_height_i[4]), 
						.score_i(score_i[4]));
						
	Score_Helper #(.ROW(5))  rowCheck5 
					  (.clk, .reset, .background_height, .prev_playfield_i, 
						.updated_prev_playfield_i_i(updated_prev_playfield_i_i[5]),
						.next_background_height_i(next_background_height_i[5]), 
						.score_i(score_i[5]));
						
	Score_Helper #(.ROW(6))  rowCheck6  
					  (.clk, .reset, .background_height, .prev_playfield_i, 
						.updated_prev_playfield_i_i(updated_prev_playfield_i_i[6]),
						.next_background_height_i(next_background_height_i[6]), 
						.score_i(score_i[6]));
						
	Score_Helper #(.ROW(7))  rowCheck7 
					  (.clk, .reset, .background_height, .prev_playfield_i, 
						.updated_prev_playfield_i_i(updated_prev_playfield_i_i[7]),
						.next_background_height_i(next_background_height_i[7]), 
						.score_i(score_i[7]));
						
	Score_Helper #(.ROW(8))  rowCheck8 
					  (.clk, .reset, .background_height, .prev_playfield_i, 
						.updated_prev_playfield_i_i(updated_prev_playfield_i_i[8]),
						.next_background_height_i(next_background_height_i[8]), 
						.score_i(score_i[8]));
						
	Score_Helper #(.ROW(9))  rowCheck9
					  (.clk, .reset, .background_height, .prev_playfield_i, 
						.updated_prev_playfield_i_i(updated_prev_playfield_i_i[9]),
						.next_background_height_i(next_background_height_i[9]), 
						.score_i(score_i[9]));
						
	Score_Helper #(.ROW(10)) rowCheck10 
					  (.clk, .reset, .background_height, .prev_playfield_i, 
						.updated_prev_playfield_i_i(updated_prev_playfield_i_i[10]),
						.next_background_height_i(next_background_height_i[10]), 
						.score_i(score_i[10]));
						
	Score_Helper #(.ROW(11)) rowCheck11 
					  (.clk, .reset, .background_height, .prev_playfield_i, 
						.updated_prev_playfield_i_i(updated_prev_playfield_i_i[11]),
						.next_background_height_i(next_background_height_i[11]), 
						.score_i(score_i[11]));
						
	Score_Helper #(.ROW(12)) rowCheck12 
					  (.clk, .reset, .background_height, .prev_playfield_i, 
						.updated_prev_playfield_i_i(updated_prev_playfield_i_i[12]),
						.next_background_height_i(next_background_height_i[12]), 
						.score_i(score_i[12]));
						
	Score_Helper #(.ROW(13)) rowCheck13 
					  (.clk, .reset, .background_height, .prev_playfield_i, 
						.updated_prev_playfield_i_i(updated_prev_playfield_i_i[13]),
						.next_background_height_i(next_background_height_i[13]), 
						.score_i(score_i[13]));
						
	Score_Helper #(.ROW(14)) rowCheck14 
					  (.clk, .reset, .background_height, .prev_playfield_i, 
						.updated_prev_playfield_i_i(updated_prev_playfield_i_i[14]),
						.next_background_height_i(next_background_height_i[14]), 
						.score_i(score_i[14]));
						
	

	always_ff @(posedge clk) begin
		if (reset || (row == (PLAY_HEIGHT-1))) 
			row <= 1;
		else
			row <= row + 1;
	end

	
	always_ff @(posedge clk) begin
		if (reset) 
			score <= 0;
		else
			score <= score_i[row];
	end
	
	always_ff @(posedge clk) begin
		if (reset) begin
			next_background_height <= '{default:0};
			updated_prev_playfield_i <= '{default:0};			
		end else begin
			next_background_height <= next_background_height_i [row];
			updated_prev_playfield_i <= updated_prev_playfield_i_i [row];	
		end
	end
		
	
	
	
	
endmodule
				
				
				
				
module Score_testbench #(parameter PLAY_WIDTH = 10,
										  parameter PLAY_HEIGHT = 15, 
										  parameter PIX_PER_BLK = 32) ();
	logic clk, reset;
	logic [(PLAY_WIDTH*PLAY_HEIGHT)-1:0] background_height;
	logic [2:0] prev_playfield_i [0:(PLAY_WIDTH*PLAY_HEIGHT)-1];


	logic [2:0] updated_prev_playfield_i [0:(PLAY_WIDTH*PLAY_HEIGHT)-1];
	logic [(PLAY_WIDTH*PLAY_HEIGHT)-1:0] next_background_height; 	
	logic score;
		
	Score dut (.*);
		
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
		
		
		repeat(15) @(posedge clk);
		
		
		@(posedge clk);	background_height <= 0;								
						
						
		//check block crossing bottom			
		@(posedge clk);	background_height <= 0;								
								prev_playfield_i[144] <= 1'b1;
		//reset						
		@(posedge clk);	background_height <= 0;								

								
		//check block crossing sides					
		@(posedge clk);	background_height <= 0;								
		//reset						
		@(posedge clk);	background_height <= 0;								
						
		
		//check block overlapping another block					
		@(posedge clk);	background_height[149:133] <= 16'hFFFF;								
		//reset						
		@(posedge clk);	background_height <= 0;								
	
		@(posedge clk);
		@(posedge clk);
	
		$stop();
	end

endmodule	
	
	
				
				
				
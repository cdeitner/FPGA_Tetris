// Description: Controls the tetris gameplay. Controls and displays entire play area. 
// Note: each shape is a designated color

module Gameplay  #(parameter PLAY_WIDTH = 10,
						 parameter PLAY_HEIGHT = 15, 
						 parameter PIX_PER_BLK = 32)							 
					(clk, reset, shape_req, rotate, left, right, down, playfield, block_landed, score, lose); 
					
	input logic	[2:0] 	shape_req;
	input logic clk, reset, rotate, left, right, down;
	
	output logic [2:0] playfield [0: (PLAY_WIDTH*PLAY_HEIGHT)-1];
	output logic block_landed, score, lose;
	
	logic [2:0] playfield_i [0: (PLAY_WIDTH*PLAY_HEIGHT)-1];
	logic [2:0] prev_playfield_i [0: (PLAY_WIDTH*PLAY_HEIGHT)-1];	
	logic [2:0] next_playfield_i [0: (PLAY_WIDTH*PLAY_HEIGHT)-1];	
	logic [2:0] playfield_out [0: (PLAY_WIDTH*PLAY_HEIGHT)-1];	

	
	//-------------------------------------------------------------------------------------
	// Set up block position (displacement) values
	//-------------------------------------------------------------------------------------
	
	
	logic [7:0] displacement; 					//0-149 all possible blocks
	logic [3:0] xp, yp, prev_xp, prev_yp; 	//xp: x position (0-9)
														//yp: y position (0-14)
														//(0,0 = top left of shape 4x4 block)
	logic [25:0] clockcounter;
	assign displacement = (xp + (PLAY_WIDTH*yp));
	

	//-------------------------------------------------------------------------------------
	// Set up orientation values
	//-------------------------------------------------------------------------------------

	
	logic [1:0] orient, prev_orient;
	
	parameter UP 	= 2'b00;
	parameter RIGHT 	= 2'b01;
	parameter DOWN 	= 2'b10;
	parameter LEFT = 2'b11;
	
	
	
	
	
	//-------------------------------------------------------------------------------------
	// Set up block interference values
	//-------------------------------------------------------------------------------------	
	
	logic not_valid;
	
	logic [(PLAY_WIDTH*PLAY_HEIGHT)-1:0] location; //current blocks occupied by the block in playfield 
	logic [(PLAY_WIDTH*PLAY_HEIGHT)-1:0] next_location; //current blocks occupied by the block in playfield_i (combinational)	
	logic [(PLAY_WIDTH*PLAY_HEIGHT)-1:0] background_height; //current values in background occupied by blocks

	
	//update the
	integer block;
	always_comb begin
		for (block=0; block<(PLAY_WIDTH*PLAY_HEIGHT); block=block+1) begin
			next_location[block] = (playfield_i[block] != 0);  //checks location of current block
		end
	end
	
	
	
	//Need a module to indicate that the current block is touching another block or the bottom and then indicates 'block_landed'
	//		must keep track and update the column hight of each column and check if the current block location is touching the bottom
	//		ouputs:	'block_landed' - block_landed stops the game, loads playfield_i to prev_playfield_i one clock cycle
	//		inputs: 	'location'   
	
	Block_Landed nextBlock (.*);
	
	
	//need a module to determine if the next position is valid eg. if rotated or moved it would overlap with the wall or another block
	//		outputs: 'valid' - Determines if the playfield_i will update main playfield
	//		inputs:	'next location' - create some way of testing if the new positions will violate any boundries.
	
	Move_Valid checkMove (.*);
	
	
	//-------------------------------------------------------------------------------------
	// Set up row removal values
	//-------------------------------------------------------------------------------------	
	
	
	logic [2:0] updated_prev_playfield_i [0: (PLAY_WIDTH*PLAY_HEIGHT)-1];
	logic [(PLAY_WIDTH*PLAY_HEIGHT)-1:0] next_background_height; 
	//output logic score;
	
	//removes a row when it has been filled and moves every row above down one
	//use location array to check if row has been filled
	//must modify prev_playfield_i and background_height arrays (what happens if a new block happens at same time as row removal?)
	//ouput updated_prev_playfield_i, score
	
	
	Score checkFullRows (.*);
	
	//check if a block is in row 2 in background if it is then assert lose
	assign lose = ((background_height[2*PLAY_WIDTH+(PLAY_WIDTH-1):2*PLAY_WIDTH])>0);

	
	
	
	//-------------------------------------------------------------------------------------
	// Block Interference Control
	//-------------------------------------------------------------------------------------
	
	always_ff @(posedge clk) begin
		if (reset || block_landed) 
			location <= '{default:0};
		else if (~(not_valid)) 
			location <= next_location;
	end	
	
	integer j;
	//update the current height of landed blocks
	always_ff @(posedge clk) begin
		if (reset) 
			background_height <= '{default:0};
		else if (block_landed) 
			background_height <= background_height + location;
		else if (score)
			background_height <= next_background_height;
	end
	
	
	
	
	
	
	
	//-------------------------------------------------------------------------------------
	// Block Position Control
	//-------------------------------------------------------------------------------------
	
	
	
	always_ff @(posedge clk) begin
		if (reset || block_landed) 
			yp <= 4'h0;
		else if (not_valid)
			yp <= prev_yp;
		else if ((clockcounter == 0) || down)
			yp <= yp + 1'b1;
	end

	always_ff @(posedge clk) begin
		if (reset || block_landed)
			xp = 4'h3;
		else if (not_valid)
			xp <= prev_xp;
		else if (right && (xp < (PLAY_WIDTH-1)))
			xp <= xp + 1'b1;
		else if (left && (xp > 0))
			xp <= xp - 1'b1;
	end
	
	always_ff @(posedge clk) begin
		if (reset || block_landed) begin
			prev_xp <= 4'h0;
			prev_yp <= 4'h0;
		end else if (~not_valid) begin
			prev_xp <= xp;
			prev_yp <= yp;
		end
	end
	
	
	
	
	
	always_ff @(posedge clk) begin
		if (reset || block_landed || down)
			clockcounter <= 1;
		else
			clockcounter <= clockcounter + 1'b1;
	end
	

	
	
	//-------------------------------------------------------------------------------------
	// Block Rotation Control
	//-------------------------------------------------------------------------------------
	
	
	always_ff @(posedge clk) begin
		if (reset)
			orient <= 2'b00;
		else if (not_valid)
			orient <= prev_orient;
		else if (rotate)
			orient <= orient + 1'b1;
	end
	
	always_ff @(posedge clk) begin
		if (reset) 
			prev_orient <= 2'b00;
		else if (~not_valid)
			prev_orient <= orient;
	end
	
	
	
	

	//-------------------------------------------------------------------------------------
	// Background Control
	//-------------------------------------------------------------------------------------

	integer row, col;

	//sets backround to white or updates background to all blocks
	always_ff @(posedge clk) begin
		if (reset)
			prev_playfield_i <= '{default:0};		
		else if (block_landed) 
			prev_playfield_i <= playfield_out;
		else if (score)
			prev_playfield_i <= updated_prev_playfield_i;
		
	end
	
	
	//replecates the current playfield (output)
	always_ff @(posedge clk) begin
		if (reset)		
			playfield_out <= '{default:0};			
		else if (~not_valid && ~lose)		 		//TO DO: CHECK IF next_playfield_i is a valid playfield
			playfield_out <= next_playfield_i;		
	end
	
	
	assign playfield = playfield_out;



	
	
	
	
	
	integer block1;
	always_comb begin
		for (block1 = 0; block1 < PLAY_HEIGHT*PLAY_WIDTH; block1 = block1+1) begin
				next_playfield_i[block1] = playfield_i[block1] + prev_playfield_i[block1];
		end	
	end
	
	
	
	

	//Combinational block for 7 shapes with 4 orientations each
	//Note: coordinates are hard-coded, should be changed if the shape size is modified
	// (but this is unlikely in this application)
	always_comb begin
	

		playfield_i = '{default:0}; 	//setting everything black by default

		case(shape_req) 
			//-------------------------------------------------------------------------------------
			// Line -- green
			//-------------------------------------------------------------------------------------
			3'b000: begin
						case(orient)
							//Up
							2'b00: 	begin
										playfield_i[0 + 0*PLAY_WIDTH + displacement] = 3'b001;
										playfield_i[0 + 1*PLAY_WIDTH + displacement] = 3'b001;
										playfield_i[0 + 2*PLAY_WIDTH + displacement] = 3'b001;
										playfield_i[0 + 3*PLAY_WIDTH + displacement] = 3'b001;
										
									end
							//Right		
							2'b01: 	begin
										playfield_i[0 + 0*PLAY_WIDTH + displacement] = 3'b001;
										playfield_i[1 + 0*PLAY_WIDTH + displacement] = 3'b001;
										playfield_i[2 + 0*PLAY_WIDTH + displacement] = 3'b001;
										playfield_i[3 + 0*PLAY_WIDTH + displacement] = 3'b001;
									end
							//Down		
							2'b10: 	begin
										playfield_i[0 + 0*PLAY_WIDTH + displacement] = 3'b001;
										playfield_i[0 + 1*PLAY_WIDTH + displacement] = 3'b001;
										playfield_i[0 + 2*PLAY_WIDTH + displacement] = 3'b001;
										playfield_i[0 + 3*PLAY_WIDTH + displacement] = 3'b001;
									end
							//Left		
							2'b11: 	begin
										playfield_i[0 + 0*PLAY_WIDTH + displacement] = 3'b001;
										playfield_i[1 + 0*PLAY_WIDTH + displacement] = 3'b001;
										playfield_i[2 + 0*PLAY_WIDTH + displacement] = 3'b001;
										playfield_i[3 + 0*PLAY_WIDTH + displacement] = 3'b001;
									end
						endcase
			
					end  //line
			
			//-------------------------------------------------------------------------------------
			// Square -- brick red
			//-------------------------------------------------------------------------------------
			3'b001: begin
						case(orient)
							//Up
							2'b00: 	begin
										playfield_i[0 + 0*PLAY_WIDTH + displacement] = 3'b010;
										playfield_i[1 + 0*PLAY_WIDTH + displacement] = 3'b010;
										playfield_i[0 + 1*PLAY_WIDTH + displacement] = 3'b010;
										playfield_i[1 + 1*PLAY_WIDTH + displacement] = 3'b010;
									end
							//Right		
							2'b01: 	begin
										playfield_i[0 + 0*PLAY_WIDTH + displacement] = 3'b010;
										playfield_i[1 + 0*PLAY_WIDTH + displacement] = 3'b010;
										playfield_i[0 + 1*PLAY_WIDTH + displacement] = 3'b010;
										playfield_i[1 + 1*PLAY_WIDTH + displacement] = 3'b010;
									end
							//Down		
							2'b10: 	begin
										playfield_i[0 + 0*PLAY_WIDTH + displacement] = 3'b010;
										playfield_i[1 + 0*PLAY_WIDTH + displacement] = 3'b010;
										playfield_i[0 + 1*PLAY_WIDTH + displacement] = 3'b010;
										playfield_i[1 + 1*PLAY_WIDTH + displacement] = 3'b010;
									end
							//Left		
							2'b11: 	begin
										playfield_i[0 + 0*PLAY_WIDTH + displacement] = 3'b010;
										playfield_i[1 + 0*PLAY_WIDTH + displacement] = 3'b010;
										playfield_i[0 + 1*PLAY_WIDTH + displacement] = 3'b010;
										playfield_i[1 + 1*PLAY_WIDTH + displacement] = 3'b010;
									end
						endcase
			
					end  //square
			
			//-------------------------------------------------------------------------------------
			// T shape -- sky blue
			//-------------------------------------------------------------------------------------
			3'b010: begin
						case(orient)
							//Up
							2'b00: 	begin
										playfield_i[0 + 0*PLAY_WIDTH + displacement] = 3'b011;
										playfield_i[1 + 0*PLAY_WIDTH + displacement] = 3'b011;
										playfield_i[2 + 0*PLAY_WIDTH + displacement] = 3'b011;
										playfield_i[1 + 1*PLAY_WIDTH + displacement] = 3'b011;
									end
							//Right		
							2'b01: 	begin
										playfield_i[0 + 1*PLAY_WIDTH + displacement] = 3'b011;
										playfield_i[1 + 0*PLAY_WIDTH + displacement] = 3'b011;
										playfield_i[1 + 1*PLAY_WIDTH + displacement] = 3'b011;
										playfield_i[1 + 2*PLAY_WIDTH + displacement] = 3'b011;
									end
							//Down		
							2'b10: 	begin
										playfield_i[0 + 1*PLAY_WIDTH + displacement] = 3'b011;
										playfield_i[1 + 0*PLAY_WIDTH + displacement] = 3'b011;
										playfield_i[1 + 1*PLAY_WIDTH + displacement] = 3'b011;
										playfield_i[2 + 1*PLAY_WIDTH + displacement] = 3'b011;
									end
							//Left		
							2'b11: 	begin
										playfield_i[0 + 0*PLAY_WIDTH + displacement] = 3'b011;
										playfield_i[0 + 1*PLAY_WIDTH + displacement] = 3'b011;
										playfield_i[0 + 2*PLAY_WIDTH + displacement] = 3'b011;
										playfield_i[1 + 1*PLAY_WIDTH + displacement] = 3'b011;
									end
						endcase
			
					end  //T shape
			
			//-------------------------------------------------------------------------------------
			// L shape -- light purple
			//-------------------------------------------------------------------------------------
			3'b011:	begin
						case(orient)
							//Up
							2'b00: 	begin
										playfield_i[0 + 0*PLAY_WIDTH + displacement] = 3'b100;
										playfield_i[0 + 1*PLAY_WIDTH + displacement] = 3'b100;
										playfield_i[1 + 0*PLAY_WIDTH + displacement] = 3'b100;
										playfield_i[2 + 0*PLAY_WIDTH + displacement] = 3'b100;
									end
							//Right		
							2'b01: 	begin
										playfield_i[0 + 0*PLAY_WIDTH + displacement] = 3'b100;
										playfield_i[1 + 0*PLAY_WIDTH + displacement] = 3'b100;
										playfield_i[1 + 1*PLAY_WIDTH + displacement] = 3'b100;
										playfield_i[1 + 2*PLAY_WIDTH + displacement] = 3'b100;
									end
							//Down		
							2'b10: 	begin
										playfield_i[0 + 1*PLAY_WIDTH + displacement] = 3'b100;
										playfield_i[1 + 1*PLAY_WIDTH + displacement] = 3'b100;
										playfield_i[2 + 1*PLAY_WIDTH + displacement] = 3'b100;
										playfield_i[2 + 0*PLAY_WIDTH + displacement] = 3'b100;
									end
							//Left		
							2'b11: 	begin
										playfield_i[0 + 0*PLAY_WIDTH + displacement] = 3'b100;
										playfield_i[0 + 1*PLAY_WIDTH + displacement] = 3'b100;
										playfield_i[0 + 2*PLAY_WIDTH + displacement] = 3'b100;
										playfield_i[1 + 2*PLAY_WIDTH + displacement] = 3'b100;
									end
						endcase
					end  //L shape
			
			//-------------------------------------------------------------------------------------
			// J shape -- orange
			//-------------------------------------------------------------------------------------			
			3'b100: begin
						case(orient)
							//Up
							2'b00: 	begin
										playfield_i[0 + 0*PLAY_WIDTH + displacement] = 3'b101;
										playfield_i[1 + 0*PLAY_WIDTH + displacement] = 3'b101;
										playfield_i[2 + 0*PLAY_WIDTH + displacement] = 3'b101;
										playfield_i[2 + 1*PLAY_WIDTH + displacement] = 3'b101;
									end
							//Right		
							2'b01: 	begin
										playfield_i[0 + 2*PLAY_WIDTH + displacement] = 3'b101;
										playfield_i[1 + 0*PLAY_WIDTH + displacement] = 3'b101;
										playfield_i[1 + 1*PLAY_WIDTH + displacement] = 3'b101;
										playfield_i[1 + 2*PLAY_WIDTH + displacement] = 3'b101;
									end
							//Down		
							2'b10: 	begin
										playfield_i[0 + 0*PLAY_WIDTH + displacement] = 3'b101;
										playfield_i[0 + 1*PLAY_WIDTH + displacement] = 3'b101;
										playfield_i[1 + 1*PLAY_WIDTH + displacement] = 3'b101;
										playfield_i[2 + 1*PLAY_WIDTH + displacement] = 3'b101;
									end
							//Left		
							2'b11: 	begin
										playfield_i[0 + 0*PLAY_WIDTH + displacement] = 3'b101;
										playfield_i[0 + 1*PLAY_WIDTH + displacement] = 3'b101;
										playfield_i[0 + 2*PLAY_WIDTH + displacement] = 3'b101;
										playfield_i[1 + 0*PLAY_WIDTH + displacement] = 3'b101;
									end
						endcase
					end  //J shape
			//-------------------------------------------------------------------------------------
			// Z shape -- magenta
			//-------------------------------------------------------------------------------------
			3'b101: begin
						case(orient)
							//Up
							2'b00: 	begin
										playfield_i[0 + 0*PLAY_WIDTH + displacement] = 3'b110;
										playfield_i[1 + 0*PLAY_WIDTH + displacement] = 3'b110;
										playfield_i[1 + 1*PLAY_WIDTH + displacement] = 3'b110;
										playfield_i[2 + 1*PLAY_WIDTH + displacement] = 3'b110;
									end
							//Right		
							2'b01: 	begin
										playfield_i[1 + 0*PLAY_WIDTH + displacement] = 3'b110;
										playfield_i[1 + 1*PLAY_WIDTH + displacement] = 3'b110;
										playfield_i[0 + 1*PLAY_WIDTH + displacement] = 3'b110;
										playfield_i[0 + 2*PLAY_WIDTH + displacement] = 3'b110;
									end
							//Down		
							2'b10: 	begin
										playfield_i[0 + 0*PLAY_WIDTH + displacement] = 3'b110;
										playfield_i[1 + 0*PLAY_WIDTH + displacement] = 3'b110;
										playfield_i[1 + 1*PLAY_WIDTH + displacement] = 3'b110;
										playfield_i[2 + 1*PLAY_WIDTH + displacement] = 3'b110;
									end
							//Left		
							2'b11: 	begin
										playfield_i[1 + 0*PLAY_WIDTH + displacement] = 3'b110;
										playfield_i[1 + 1*PLAY_WIDTH + displacement] = 3'b110;
										playfield_i[0 + 1*PLAY_WIDTH + displacement] = 3'b110;
										playfield_i[0 + 2*PLAY_WIDTH + displacement] = 3'b110;
									end
						endcase
					end  //Z shape
					
			//-------------------------------------------------------------------------------------
			// S shape -- turquoise
			//-------------------------------------------------------------------------------------
			3'b110: begin
						case(orient)
							//Up
							2'b00: 	begin
										playfield_i[0 + 1*PLAY_WIDTH + displacement] = 3'b111;
										playfield_i[1 + 1*PLAY_WIDTH + displacement] = 3'b111;
										playfield_i[1 + 0*PLAY_WIDTH + displacement] = 3'b111;
										playfield_i[2 + 0*PLAY_WIDTH + displacement] = 3'b111;
									end
							//Right		
							2'b01: 	begin
										playfield_i[0 + 0*PLAY_WIDTH + displacement] = 3'b111;
										playfield_i[0 + 1*PLAY_WIDTH + displacement] = 3'b111;
										playfield_i[1 + 1*PLAY_WIDTH + displacement] = 3'b111;
										playfield_i[1 + 2*PLAY_WIDTH + displacement] = 3'b111;
									end
							//Down		
							2'b10: 	begin
										playfield_i[0 + 1*PLAY_WIDTH + displacement] = 3'b111;
										playfield_i[1 + 1*PLAY_WIDTH + displacement] = 3'b111;
										playfield_i[1 + 0*PLAY_WIDTH + displacement] = 3'b111;
										playfield_i[2 + 0*PLAY_WIDTH + displacement] = 3'b111;
									end
							//Left		
							2'b11: 	begin
										playfield_i[0 + 0*PLAY_WIDTH + displacement] = 3'b111;
										playfield_i[0 + 1*PLAY_WIDTH + displacement] = 3'b111;
										playfield_i[1 + 1*PLAY_WIDTH + displacement] = 3'b111;
										playfield_i[1 + 2*PLAY_WIDTH + displacement] = 3'b111;
									end
						endcase
					end  //S shape
			
			default: begin
			
					end
		endcase
	end
	

endmodule 



module Gameplay_testbench    #(parameter PLAY_WIDTH = 10,
										  parameter PLAY_HEIGHT = 15, 
										  parameter PIX_PER_BLK = 32)							 
																			(); 
	logic	[2:0] 	shape_req;
	logic clk, reset, rotate, left, right, down;	
	logic [2:0] playfield [0: (PLAY_WIDTH*PLAY_HEIGHT)-1];
	logic score;
	integer i;
	logic block_landed, lose;

	Gameplay dut (.*);
	
	parameter PERIOD = 100;
	
	initial begin
		clk <= 0;
		forever #(PERIOD/2) clk = ~clk;
	end
		
	initial begin
	
		@(posedge clk);	shape_req <= 3'b011; //L shape
		@(posedge clk);	rotate<=0; left<=0; right<=0; down<=0;								
		@(posedge clk);								
		@(posedge clk);	reset <= 1;					
		@(posedge clk);	reset <= 0;		
		
		//move square to bottom
		repeat(5) 
		begin
			@(posedge clk);	 shape_req <= 3'b000; //Line shape
			@(posedge clk);	rotate<=0; left<=0; right<=0; down<=1;
			@(posedge clk);	rotate<=0; left<=0; right<=0; down<=1;
			@(posedge clk);	rotate<=0; left<=0; right<=0; down<=1;
								for (i=0; i<8; i=i+1)
									@(posedge clk)
			@(posedge clk);	rotate<=0; left<=0; right<=0; down<=0;	
		end
		
		repeat(5) 
		begin
			@(posedge clk);	 shape_req <= 3'b001; //Square shape
			@(posedge clk);	rotate<=0; left<=0; right<=0; down<=1;
			@(posedge clk);	rotate<=0; left<=0; right<=0; down<=1;
			@(posedge clk);	rotate<=0; left<=0; right<=0; down<=1;
								for (i=0; i<8; i=i+1)
									@(posedge clk)
			@(posedge clk);	rotate<=0; left<=0; right<=0; down<=0;	
		end
		
		repeat(5) 
		begin
			@(posedge clk);	 shape_req <= 3'b010; //T shape
			@(posedge clk);	rotate<=0; left<=0; right<=0; down<=1;
			@(posedge clk);	rotate<=0; left<=0; right<=0; down<=1;
			@(posedge clk);	rotate<=0; left<=0; right<=0; down<=1;
								for (i=0; i<8; i=i+1)
									@(posedge clk)
			@(posedge clk);	rotate<=0; left<=0; right<=0; down<=0;	
		end
		
		repeat(5) 
		begin
			@(posedge clk);	 shape_req <= 3'b011; //L shape
			@(posedge clk);	rotate<=0; left<=0; right<=0; down<=1;
			@(posedge clk);	rotate<=0; left<=0; right<=0; down<=1;
			@(posedge clk);	rotate<=0; left<=0; right<=0; down<=1;
								for (i=0; i<8; i=i+1)
									@(posedge clk)
			@(posedge clk);	rotate<=0; left<=0; right<=0; down<=0;	
		end
		//game should end
		
		@(posedge clk);								
		@(posedge clk);	reset <= 1;					
		@(posedge clk);	reset <= 0;	
		
		repeat(5) 
		begin
			@(posedge clk);	 shape_req <= 3'b100; //J shape
			@(posedge clk);	rotate<=1; left<=0; right<=0; down<=1; //check roation
			@(posedge clk);	rotate<=0; left<=0; right<=0; down<=1;
			@(posedge clk);	rotate<=1; left<=0; right<=0; down<=1;
								for (i=0; i<8; i=i+1)
									@(posedge clk)
			@(posedge clk);	rotate<=0; left<=0; right<=0; down<=0;	
		end
		
		repeat(5) 
		begin
			@(posedge clk);	 shape_req <= 3'b101; //Z shape
			@(posedge clk);	rotate<=0; left<=0; right<=0; down<=1;
			@(posedge clk);	rotate<=0; left<=1; right<=0; down<=1; //move left
			@(posedge clk);	rotate<=0; left<=0; right<=0; down<=1;
								for (i=0; i<8; i=i+1)
									@(posedge clk)
			@(posedge clk);	rotate<=0; left<=0; right<=0; down<=0;	
		end
		
		repeat(5) 
		begin
			@(posedge clk);	 shape_req <= 3'b110; //S shape
			@(posedge clk);	rotate<=0; left<=0; right<=0; down<=1;
			@(posedge clk);	rotate<=0; left<=0; right<=1; down<=1; //move right
			@(posedge clk);	rotate<=0; left<=0; right<=0; down<=1;
								for (i=0; i<8; i=i+1)
									@(posedge clk)
			@(posedge clk);	rotate<=0; left<=0; right<=0; down<=0;	
		end
				

		@(posedge clk);
		@(posedge clk);
	
		$stop();
	end

endmodule	





	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	





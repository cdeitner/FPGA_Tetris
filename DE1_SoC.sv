 module DE1_SoC (HEX0, 
				HEX1, 
				HEX2, 
				HEX3, 
				HEX4, 
				HEX5, 
				KEY, 
				LEDR, 
				SW,
				CLOCK_50, 
				VGA_R, 
				VGA_G, 
				VGA_B, 
				VGA_BLANK_N, 
				VGA_CLK, 
				VGA_HS, 
				VGA_SYNC_N, 
				VGA_VS, 
				PS2_DAT, 
				PS2_CLK,
				CLOCK2_50,
				FPGA_I2C_SCLK, 
				FPGA_I2C_SDAT, 
				AUD_XCK, 
				AUD_DACLRCK, 
				AUD_ADCLRCK, 
				AUD_BCLK, 
				AUD_ADCDAT, 
				AUD_DACDAT
	);
					 
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	input logic PS2_DAT, PS2_CLK;
	
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;

	inout FPGA_I2C_SDAT;

	output FPGA_I2C_SCLK;
	output AUD_XCK;	
	output AUD_DACDAT;

	input CLOCK_50, CLOCK2_50;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;

	logic reset, rotate, left, right, down;
	logic block_landed, score, lose;
	logic [9:0] x, xp, xm, xt;  //xp is pixelized x
	logic [8:0] y, yp, ym, yt;	//yp is pixelized y
	logic [7:0] r, g, b;
	logic [2:0] playfield [0: (PLAY_WIDTH*PLAY_HEIGHT)-1];	//10x15 array of the playing area
	logic [2:0] menufield [0: (MENU_WIDTH*PLAY_HEIGHT)-1];	//10x15 array of the playing area
	logic [2:0] menu_shape [0: (BLK_PER_SHAPE**2) -1];
	logic [(TITLE_WIDTH*TITLE_HEIGHT-1):0] title;
	
	//Audio CODEC signals:
	wire read_ready, write_ready, read, write;
	wire [23:0] readdata_left, readdata_right;
	wire [23:0] writedata_left, writedata_right;
	logic write_en1, write_en2, write_en3, write_en4;	
		
	assign reset = ~KEY[0] || SW[9];	

	assign writedata_right = writedata_left;	
	assign read = read_ready;				 
	assign write = write_en1 | write_en2 | write_en3 | write_en4;
	

	//---------------------------------------------------------------------------------------------
	// PARAMETER DECLARATIONS
	//---------------------------------------------------------------------------------------------
	localparam integer BLK_PER_SHAPE = 4;   //blocks per shape
	localparam integer PIX_PER_BLK = 32;  //pixels per block
	localparam integer SHAPE_SIZE = BLK_PER_SHAPE * PIX_PER_BLK;  //size of shape in terms of pixels
	localparam integer TOTAL_WIDTH = 640 / PIX_PER_BLK;	
	localparam integer PLAY_WIDTH = 10;
	localparam integer PLAY_HEIGHT = 15;
	localparam integer MENU_WIDTH = TOTAL_WIDTH - PLAY_WIDTH;
	localparam integer TITLE_WIDTH = 28;
	localparam integer TITLE_HEIGHT = 6;
	localparam integer TITLE_PIX_PER_BLK = 8;	
	
	//---------------------------------------------------------------------------------------------
	// MODULE INSTANTIATIONS
	//---------------------------------------------------------------------------------------------
	
	
	//Reads PS2 keyboard keypad
	TetrisKeyboard gameControls (.clk(CLOCK_50), .reset, .PS2_DAT, .PS2_CLK, .rotate, .down, .left, .right);
	//KeyboardReplicator (.clk(CLOCK_50), .reset, .KEY, .rotate, .down, .left, .right);
	logic key_press;
	assign key_press = rotate | down | left | right;
	
	
	//Provided Code: 
	//Instantiating the video driver which outputs coordinates to be colored
	video_driver #(.WIDTH(640), .HEIGHT(480))
		v1 (.CLOCK_50, .reset, .x, .y, .r, .g, .b,
			 .VGA_R, .VGA_G, .VGA_B, .VGA_BLANK_N,
			 .VGA_CLK, .VGA_HS, .VGA_SYNC_N, .VGA_VS);
	

	//generates the gameplay video output and control
	Gameplay   //#(.PLAY_WIDTH, .PLAY_HEIGHT, .PIX_PER_BLK)
		playarea (
			.clk(CLOCK_50), 
			.reset, 
			.shape_req(curr_shape), 
			.rotate, 
			.left,
			.right, 
			.down, 
			.playfield, 
			.block_landed,
			.lose, 
			.score
	); 

	//Generates next shape randomly
	logic [2:0] curr_shape, next_shape;
	next_shape	u_next(
			.clk			(CLOCK_50), 
			.reset, 
			.new_block		(block_landed), 
			.curr_shape, 
			.next_shape
	);
			
	//Creates display array for next shape
	single_shape u_shape_n (
			.shape_req		(next_shape), 
			.orient			(2'b00), //always show shape up on menu
			.shape_out		(menu_shape)		
	);
	
	//Controls pixels displayed on right side of screen as a menu
	menu_gen   #(.MENU_WIDTH(10), .PLAY_HEIGHT(15)) u_menu(
			.menu_shape, 
			.menu			(menufield),
			.lose
	);	

	//Audio CODEC instantiations:
	clock_generator my_clock_gen(
		CLOCK2_50,
		reset,
		AUD_XCK
	);

	audio_and_video_config cfg(
		CLOCK_50,
		reset,
		FPGA_I2C_SDAT,
		FPGA_I2C_SCLK
	);

	audio_codec codec(
		CLOCK_50,
		reset,
		read,	
		write,
		writedata_left, 
		writedata_right,
		AUD_ADCDAT,
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,
		read_ready, write_ready,
		readdata_left, readdata_right,
		AUD_DACDAT
	);
	
	logic [19:0] freq, freq1, freq2, freq3, freq4;
	sound_effects key_sound(
		.clk		(CLOCK_50), 
		.enable     (key_press),
		.reset,
		.sound		(2'b00),
		.freq		(freq1),
		.write_en	(write_en1)
	);
	
	sound_effects #(22) land_sound(
		.clk		(CLOCK_50), 
		.enable     (block_landed),
		.reset,
		.sound		(2'b01),
		.freq		(freq2),
		.write_en	(write_en2)
	);
	
		sound_effects #(23) row_sound(
		.clk		(CLOCK_50), 
		.enable     (score),
		.reset,
		.sound		(2'b10),
		.freq		(freq3),
		.write_en	(write_en3)
	);
	
		sound_effects #(23) lose_sound(
		.clk		(CLOCK_50), 
		.enable     (lose),
		.reset,
		.sound		(2'b11),
		.freq		(freq4),
		.write_en	(write_en4)
	);
	
	//assign freq = write_en2? freq2 : freq1;	
	square_wave sound1(
		.clk		(CLOCK_50), 
		.reset, 
		.freq, 
		.wave_data	(writedata_left)
	);
	
	title_gen titleGenerator (
		.title
	);	
	
	score_display scoredisp  (
		.clk(CLOCK_50), 
		.reset, 
		.score, 
		.HEX0, 
		.HEX1, 
		.HEX2, 
		.HEX3, 
		.HEX4, 
		.HEX5
	);


	
	always_comb begin
		if(write_en4)
			freq = freq4;
		else if(write_en3)
			freq = freq3;
		else if(write_en2)
			freq = freq2;
		else
			freq = freq1;
	end
	
		 	 
	//---------------------------------------------------------------------------------------------
	// COORDINATE LOGIC 
	//---------------------------------------------------------------------------------------------
	assign xp = x / PIX_PER_BLK;
	assign yp = (PLAY_WIDTH*(y/PIX_PER_BLK));
	
	assign xm = ((x - PLAY_WIDTH*PIX_PER_BLK) / PIX_PER_BLK);
	assign ym = MENU_WIDTH*(y / PIX_PER_BLK);
	
	assign xt = ((x - (PLAY_WIDTH+2)*PIX_PER_BLK) / TITLE_PIX_PER_BLK);
	assign yt = TITLE_WIDTH*(y / TITLE_PIX_PER_BLK);
	
	//---------------------------------------------------------------------------------------------
	// Color Decoder 
	//---------------------------------------------------------------------------------------------	
	
	logic [23:0] green, red, blue, purple, orange, magenta, turtle, black;
	logic [23:0] play_color, menu_color, title_color;
	
	assign black 	= 	24'h000000;	//000
	assign green 	= 	24'h009900; //001
	assign red 		= 	24'hD25555;	//010
	assign blue 	= 	24'h3399FF;	//011
	assign purple 	= 	24'hCC99FF;	//100
	assign orange 	= 	24'hFF9933;	//101
	assign magenta = 	24'hCC0066;	//110
	assign turtle 	= 	24'h009999;	//111
	
	always_comb begin
		case (playfield[xp+yp])		
				3'b000:	play_color = black;				
				3'b001:	play_color = green;				
				3'b010:	play_color = red;					
				3'b011:	play_color = blue;
				3'b100:	play_color = purple;
				3'b101:	play_color = orange;				
				3'b110:	play_color = magenta;
				3'b111:	play_color = turtle;
		endcase
	end	

		always_comb begin
		case (menufield[xm+ym])		
				3'b000:	menu_color = black;				
				3'b001:	menu_color = green;				
				3'b010:	menu_color = red;					
				3'b011:	menu_color = blue;
				3'b100:	menu_color = purple;
				3'b101:	menu_color = orange;				
				3'b110:	menu_color = magenta;
				3'b111:	menu_color = turtle;
		endcase
	end		
	
	always_comb begin
		case (title[xt+yt])		
				1'b0:	title_color = black;				
				1'b1:	title_color = magenta;				
		endcase
	end	


	//Sequential block to assign color based on coordinate outputted from video_driver.sv
	always_ff @(posedge CLOCK_50) begin
		if (x < PLAY_WIDTH*PIX_PER_BLK) begin //in the playfield
			r <= play_color[23:16];
			g <= play_color[15:8];
			b <= play_color[7:0];
		end
		else if ((x >= (PLAY_WIDTH+2)*PIX_PER_BLK) && 
					(y < TITLE_HEIGHT*TITLE_PIX_PER_BLK) && 
					(x < (PLAY_WIDTH+2)*PIX_PER_BLK + (TITLE_WIDTH*TITLE_PIX_PER_BLK))) begin
			r <= title_color[23:16];
			g <= title_color[15:8];
			b <= title_color[7:0];
		end 
		else begin
			r <= menu_color[23:16];
			g <= menu_color[15:8];
			b <= menu_color[7:0];
		end
	end
	
	
	

	
	

	
	
	
endmodule

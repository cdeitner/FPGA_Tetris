// Description: 

module menu_gen #(parameter BLK_PER_SHAPE = 4, parameter MENU_WIDTH = 10, parameter PLAY_HEIGHT = 15) 
				(menu_shape, menu, lose);
	input  logic [2:0] menu_shape [0: (BLK_PER_SHAPE**2) -1];
	output logic [2:0] menu [0: (MENU_WIDTH*PLAY_HEIGHT) -1];  //default 10x15 array, on right side of screen
	input logic lose;
	
	integer row, col;
	always_comb begin		
		
		menu = '{default:0};
		
		if(lose) begin
			for (row = 0; row < PLAY_HEIGHT; row = row+1) begin
				for (col = 0; col < MENU_WIDTH; col = col+1) begin
					menu[col + row*MENU_WIDTH] <= 3'b010;  //menu shape in top left
				end
			end 
		end else begin
			for (row = 6; row < 6 + BLK_PER_SHAPE; row = row+1) begin
				for (col = 3; col < 3 + BLK_PER_SHAPE; col = col+1) begin
					menu[(col+1) + row*MENU_WIDTH] <= menu_shape[(col - 3) + (row - 6)*BLK_PER_SHAPE];  //menu shape in top left
				end
			end 
			
			for (row = 0; row < PLAY_HEIGHT; row = row+1) begin
				menu[row*MENU_WIDTH] <= 3'b111;  //turqouise line that divides menu and playfield
			end 
			
		end
	end


endmodule 
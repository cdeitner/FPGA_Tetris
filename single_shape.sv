// Description: The purpose of this module is to generate a tetris shape based on 
// a given encoding, shape_req
// Note: each shape is a designated color

module single_shape   #(parameter SHAPE_SIZE = 4)  //ratio of blocks per shape
					(shape_req, orient, shape_out);  
	input logic	[2:0] 	shape_req;
	input logic [1:0]	orient;
	
	output logic [2:0]	shape_out[0:(SHAPE_SIZE**2) -1];
	
	logic [2:0]	shape_i[0:(SHAPE_SIZE**2) -1];
	
	parameter UP 	= 2'b00;
	parameter DOWN 	= 2'b01;
	parameter LEFT 	= 2'b10;
	parameter RIGHT = 2'b11;
	

	integer row, col;

	//Combinational block for 7 shapes with 4 orientations each
	//Note: coordinates are hard-coded, should be changed if the shape size is modified
	// (but this is unlikely in this application)
	always_comb begin
	
		shape_i = '{default:0};
	
		case(shape_req) 
			//-------------------------------------------------------------------------------------
			// Line -- green
			//-------------------------------------------------------------------------------------
			3'b000: begin
						case(orient)
							//Up
							2'b00: 	begin
										shape_i[0 + 0*SHAPE_SIZE] = 3'b001;
										shape_i[0 + 1*SHAPE_SIZE] = 3'b001;
										shape_i[0 + 2*SHAPE_SIZE] = 3'b001;
										shape_i[0 + 3*SHAPE_SIZE] = 3'b001;
									end
							//Right		
							2'b01: 	begin
										shape_i[0 + 0*SHAPE_SIZE] = 3'b001;
										shape_i[1 + 0*SHAPE_SIZE] = 3'b001;
										shape_i[2 + 0*SHAPE_SIZE] = 3'b001;
										shape_i[3 + 0*SHAPE_SIZE] = 3'b001;
									end
							//Down		
							2'b10: 	begin
										shape_i[0 + 0*SHAPE_SIZE] = 3'b001;
										shape_i[0 + 1*SHAPE_SIZE] = 3'b001;
										shape_i[0 + 2*SHAPE_SIZE] = 3'b001;
										shape_i[0 + 3*SHAPE_SIZE] = 3'b001;
									end
							//Left		
							2'b11: 	begin
										shape_i[0 + 0*SHAPE_SIZE] = 3'b001;
										shape_i[1 + 0*SHAPE_SIZE] = 3'b001;
										shape_i[2 + 0*SHAPE_SIZE] = 3'b001;
										shape_i[3 + 0*SHAPE_SIZE] = 3'b001;
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
										shape_i[0 + 0*SHAPE_SIZE] = 3'b010;
										shape_i[1 + 0*SHAPE_SIZE] = 3'b010;
										shape_i[0 + 1*SHAPE_SIZE] = 3'b010;
										shape_i[1 + 1*SHAPE_SIZE] = 3'b010;
									end
							//Right		
							2'b01: 	begin
										shape_i[2 + 0*SHAPE_SIZE] = 3'b010;
										shape_i[2 + 1*SHAPE_SIZE] = 3'b010;
										shape_i[3 + 0*SHAPE_SIZE] = 3'b010;
										shape_i[3 + 1*SHAPE_SIZE] = 3'b010;
									end
							//Down		
							2'b10: 	begin
										shape_i[2 + 2*SHAPE_SIZE] = 3'b010;
										shape_i[2 + 3*SHAPE_SIZE] = 3'b010;
										shape_i[3 + 2*SHAPE_SIZE] = 3'b010;
										shape_i[3 + 3*SHAPE_SIZE] = 3'b010;
									end
							//Left		
							2'b11: 	begin
										shape_i[0 + 2*SHAPE_SIZE] = 3'b010;
										shape_i[0 + 3*SHAPE_SIZE] = 3'b010;
										shape_i[1 + 2*SHAPE_SIZE] = 3'b010;
										shape_i[1 + 3*SHAPE_SIZE] = 3'b010;
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
										shape_i[0 + 0*SHAPE_SIZE] = 3'b011;
										shape_i[1 + 0*SHAPE_SIZE] = 3'b011;
										shape_i[2 + 0*SHAPE_SIZE] = 3'b011;
										shape_i[1 + 1*SHAPE_SIZE] = 3'b011;
									end
							//Right		
							2'b01: 	begin
										shape_i[3 + 0*SHAPE_SIZE] = 3'b011;
										shape_i[3 + 1*SHAPE_SIZE] = 3'b011;
										shape_i[3 + 2*SHAPE_SIZE] = 3'b011;
										shape_i[2 + 1*SHAPE_SIZE] = 3'b011;
									end
							//Down		
							2'b10: 	begin
										shape_i[1 + 3*SHAPE_SIZE] = 3'b011;
										shape_i[2 + 3*SHAPE_SIZE] = 3'b011;
										shape_i[3 + 3*SHAPE_SIZE] = 3'b011;
										shape_i[2 + 2*SHAPE_SIZE] = 3'b011;
									end
							//Left		
							2'b11: 	begin
										shape_i[0 + 1*SHAPE_SIZE] = 3'b011;
										shape_i[0 + 2*SHAPE_SIZE] = 3'b011;
										shape_i[0 + 3*SHAPE_SIZE] = 3'b011;
										shape_i[1 + 2*SHAPE_SIZE] = 3'b011;
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
										shape_i[0 + 0*SHAPE_SIZE] = 3'b100;
										shape_i[0 + 1*SHAPE_SIZE] = 3'b100;
										shape_i[1 + 0*SHAPE_SIZE] = 3'b100;
										shape_i[2 + 0*SHAPE_SIZE] = 3'b100;
									end
							//Right		
							2'b01: 	begin
										shape_i[2 + 0*SHAPE_SIZE] = 3'b100;
										shape_i[3 + 0*SHAPE_SIZE] = 3'b100;
										shape_i[3 + 1*SHAPE_SIZE] = 3'b100;
										shape_i[3 + 2*SHAPE_SIZE] = 3'b100;
									end
							//Down		
							2'b10: 	begin
										shape_i[1 + 3*SHAPE_SIZE] = 3'b100;
										shape_i[2 + 3*SHAPE_SIZE] = 3'b100;
										shape_i[3 + 3*SHAPE_SIZE] = 3'b100;
										shape_i[3 + 2*SHAPE_SIZE] = 3'b100;
									end
							//Left		
							2'b11: 	begin
										shape_i[0 + 1*SHAPE_SIZE] = 3'b100;
										shape_i[0 + 2*SHAPE_SIZE] = 3'b100;
										shape_i[0 + 3*SHAPE_SIZE] = 3'b100;
										shape_i[1 + 3*SHAPE_SIZE] = 3'b100;
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
										shape_i[1 + 0*SHAPE_SIZE] = 3'b101;
										shape_i[2 + 0*SHAPE_SIZE] = 3'b101;
										shape_i[3 + 0*SHAPE_SIZE] = 3'b101;
										shape_i[3 + 1*SHAPE_SIZE] = 3'b101;
									end
							//Right		
							2'b01: 	begin
										shape_i[2 + 3*SHAPE_SIZE] = 3'b101;
										shape_i[3 + 1*SHAPE_SIZE] = 3'b101;
										shape_i[3 + 2*SHAPE_SIZE] = 3'b101;
										shape_i[3 + 3*SHAPE_SIZE] = 3'b101;
									end
							//Down		
							2'b10: 	begin
										shape_i[0 + 2*SHAPE_SIZE] = 3'b101;
										shape_i[0 + 3*SHAPE_SIZE] = 3'b101;
										shape_i[1 + 3*SHAPE_SIZE] = 3'b101;
										shape_i[2 + 3*SHAPE_SIZE] = 3'b101;
									end
							//Left		
							2'b11: 	begin
										shape_i[0 + 0*SHAPE_SIZE] = 3'b101;
										shape_i[0 + 1*SHAPE_SIZE] = 3'b101;
										shape_i[0 + 2*SHAPE_SIZE] = 3'b101;
										shape_i[1 + 0*SHAPE_SIZE] = 3'b101;
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
										shape_i[0 + 0*SHAPE_SIZE] = 3'b110;
										shape_i[1 + 0*SHAPE_SIZE] = 3'b110;
										shape_i[1 + 1*SHAPE_SIZE] = 3'b110;
										shape_i[2 + 1*SHAPE_SIZE] = 3'b110;
									end
							//Right		
							2'b01: 	begin
										shape_i[2 + 1*SHAPE_SIZE] = 3'b110;
										shape_i[2 + 2*SHAPE_SIZE] = 3'b110;
										shape_i[3 + 0*SHAPE_SIZE] = 3'b110;
										shape_i[3 + 1*SHAPE_SIZE] = 3'b110;
									end
							//Down		
							2'b10: 	begin
										shape_i[1 + 2*SHAPE_SIZE] = 3'b110;
										shape_i[2 + 2*SHAPE_SIZE] = 3'b110;
										shape_i[2 + 3*SHAPE_SIZE] = 3'b110;
										shape_i[3 + 3*SHAPE_SIZE] = 3'b110;
									end
							//Left		
							2'b11: 	begin
										shape_i[0 + 2*SHAPE_SIZE] = 3'b110;
										shape_i[0 + 3*SHAPE_SIZE] = 3'b110;
										shape_i[1 + 1*SHAPE_SIZE] = 3'b110;
										shape_i[1 + 2*SHAPE_SIZE] = 3'b110;
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
										shape_i[1 + 1*SHAPE_SIZE] = 3'b111;
										shape_i[2 + 1*SHAPE_SIZE] = 3'b111;
										shape_i[2 + 0*SHAPE_SIZE] = 3'b111;
										shape_i[3 + 0*SHAPE_SIZE] = 3'b111;
									end
							//Right		
							2'b01: 	begin
										shape_i[2 + 1*SHAPE_SIZE] = 3'b111;
										shape_i[2 + 2*SHAPE_SIZE] = 3'b111;
										shape_i[3 + 0*SHAPE_SIZE] = 3'b111;
										shape_i[3 + 1*SHAPE_SIZE] = 3'b111;
									end
							//Down		
							2'b10: 	begin
										shape_i[0 + 3*SHAPE_SIZE] = 3'b111;
										shape_i[1 + 3*SHAPE_SIZE] = 3'b111;
										shape_i[1 + 2*SHAPE_SIZE] = 3'b111;
										shape_i[2 + 2*SHAPE_SIZE] = 3'b111;
									end
							//Left		
							2'b11: 	begin
										shape_i[0 + 0*SHAPE_SIZE] = 3'b111;
										shape_i[0 + 1*SHAPE_SIZE] = 3'b111;
										shape_i[1 + 1*SHAPE_SIZE] = 3'b111;
										shape_i[1 + 2*SHAPE_SIZE] = 3'b111;
									end
						endcase
					end  //S shape
			
			default: begin
			
					end
		endcase
	end
	
	assign shape_out = shape_i;

endmodule 
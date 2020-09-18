//decodes an input 4-bit number to a 7-bit hex display

module HEX_Decoder (clk, reset, num, HEX);
	input logic clk, reset;
	input logic [3:0] num;
	output logic [6:0] HEX;
	
	always_comb begin
		case (num)
			4'b0000: HEX = 7'b1000000;//0
			4'b0001: HEX = 7'b1111001;//1
			4'b0010: HEX = 7'b0100100;//2
			4'b0011: HEX = 7'b0110000;//3
			4'b0100: HEX = 7'b0011001;//4
			4'b0101: HEX = 7'b0010010;//5
			4'b0110: HEX = 7'b0000010;//6
			4'b0111: HEX = 7'b1111000;//7
			4'b1000: HEX = 7'b0000000;//8
			4'b1001: HEX = 7'b0010000;//9
			4'b1010: HEX = 7'b0001000;//A
			4'b1011: HEX = 7'b0000011;//B
			4'b1100: HEX = 7'b1000110;//C
			4'b1101: HEX = 7'b0100001;//D
			4'b1110: HEX = 7'b0000110;//E
			4'b1111: HEX = 7'b0001110;//F
		endcase
	end
endmodule

module HEX_Decoder_testbench ();
	logic clk, reset;
	logic [3:0] num;
	logic [6:0] HEX;
	
	HEX_Decoder dut (.clk, .reset, .num, .HEX);
		
	parameter PERIOD = 100;
	
	initial begin
		clk <= 0;
		forever #(PERIOD/2) clk = ~clk;
	end
		
	initial begin
										@(posedge clk);
		num <= 0; 					@(posedge clk);
		reset <= 1;					@(posedge clk);
		reset <= 0;					@(posedge clk);
		num <= 0; 					@(posedge clk);
		num <= 1; 					@(posedge clk);
		num <= 2; 					@(posedge clk);
		num <= 3; 					@(posedge clk);
		num <= 4; 					@(posedge clk);
		num <= 5; 					@(posedge clk);
		num <= 6; 					@(posedge clk);
		num <= 7; 					@(posedge clk);
		num <= 8; 					@(posedge clk);
		num <= 9; 					@(posedge clk);
		num <= 10;					@(posedge clk);
		num <= 11;					@(posedge clk);
		num <= 12;					@(posedge clk);
		num <= 13;					@(posedge clk);
		num <= 14;					@(posedge clk);
		num <= 15; 					@(posedge clk);
		
		$stop();
	end

endmodule		



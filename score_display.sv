module score_display (clk, reset, score, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input logic clk, reset, score;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	logic [3:0] counter1, counter10, counter100, counter1k, counter10k;
	logic [16:0] counter;
	
	always_ff @(posedge clk) begin
		if (reset) begin
			counter <= 0;
		end else if (score) begin
			counter <= counter + 1;
		end
	end
	
	assign counter1 	= (counter % 10) 		/ 1;
	assign counter10 	= (counter % 100) 	/ 10;
	assign counter100 = (counter % 1000) 	/ 100;
	assign counter1k 	= (counter % 10000) 	/ 1000;
	assign counter10k = (counter % 100000) / 10000;
	
	HEX_Decoder ones (.clk(CLOCK_50), .reset, .num(counter1), .HEX(HEX0));
	HEX_Decoder tens (.clk(CLOCK_50), .reset, .num(counter10), .HEX(HEX1));
	HEX_Decoder hundreds (.clk(CLOCK_50), .reset, .num(counter100), .HEX(HEX2));
	HEX_Decoder thousands (.clk(CLOCK_50), .reset, .num(counter1k), .HEX(HEX3));
	HEX_Decoder tenthousands (.clk(CLOCK_50), .reset, .num(counter10k), .HEX(HEX4));

	assign HEX5 = 7'b1111111;	
	
endmodule
		
		
module score_display_testbench();
	logic clk, reset, score;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	score_display dut (.*);

	parameter PERIOD = 100;
	
	initial begin
		clk <= 0;
		forever #(PERIOD/2) clk = ~clk;
	end
	
	initial begin
		@(posedge clk);	reset <= 1; score <= 1;
		@(posedge clk);	reset <= 0;
		@(posedge clk);
		repeat (111) @(posedge clk);
			
		$stop();
	
	end

endmodule 
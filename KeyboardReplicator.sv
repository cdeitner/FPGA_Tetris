module KeyboardReplicator (clk, reset, KEY, rotate, down, left, right);
	input logic clk, reset;
	input logic [3:0] KEY;
	output logic rotate, down, left, right;
	
	logic [1:0] rotate_i, down_i, left_i, right_i;
	
	assign rotate = (rotate_i == 2'b01);
	assign down = (down_i == 2'b01);
	assign left = (left_i == 2'b01);
	assign right = (right_i == 2'b01);
	
	
	always_ff @(posedge clk) begin
		if (reset || KEY[0])
			rotate_i <= 2'b00;
		else if (~KEY[0] && (rotate_i == 2'b00))
			rotate_i <= 2'b01;
		else if (rotate_i == 1)
			rotate_i <= 2'b10;
	end
	
	always_ff @(posedge clk) begin
		if (reset || KEY[0])
			down_i <= 2'b00;
		else if (~KEY[0] && (down_i == 2'b00))
			down_i <= 2'b01;
		else if (down_i == 1)
			down_i <= 2'b10;
	end


	always_ff @(posedge clk) begin
		if (reset || KEY[0])
			left_i <= 2'b00;
		else if (~KEY[0] && (left_i == 2'b00))
			left_i <= 2'b01;
		else if (left_i == 1)
			left_i <= 2'b10;
	end		

	always_ff @(posedge clk) begin
		if (reset || KEY[0])
			right_i <= 2'b00;
		else if (~KEY[0] && (right_i == 2'b00))
			right_i <= 2'b01;
		else if (right_i == 1)
			right_i <= 2'b10;
	end	
						
endmodule





			
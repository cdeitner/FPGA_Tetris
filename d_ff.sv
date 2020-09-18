// D flip-flop w/synchronous reset

module d_ff (q, d, reset, clk); 
	input  logic d, reset, clk;
	output logic q;
	 
	always_ff @(posedge clk) begin // Hold val until clock edge
		if (reset)
			q <= 0; // On reset, set to 0
		else
			q <= d; // Otherwise out = d
	end
endmodule 
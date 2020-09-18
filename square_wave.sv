// Description: This module generates a square wave of the desired fequency and amplitude, 
// to be written to the Audio CODEC interface

module square_wave(clk, reset, freq, wave_data);
	input 			clk, reset;
	input [19:0] 	freq;
	
	output logic signed [23:0] wave_data;

	logic [19:0] counter;   //20 bit counter can go up to approx. 1M cycles	
	logic [19:0] wavelength;
	
	//Wavelength is inverse of frequency times frequency of clock
	assign wavelength = 50*(10**6) / freq;
	
	always_ff @(posedge clk) begin
		if(reset) begin
			wave_data <= 24'h0FFFFF;
			counter <= 20'd0;
		end
		else begin			
			
			if(counter < (wavelength / 2))
				wave_data <= 24'h0FFFFF;
			else 
				wave_data <= 24'h8FFFFF;
				
			if(counter == wavelength)
				counter <= 20'd0;
			else
				counter <= counter + 1;
		end
	
	end

endmodule 

module square_wave_testbench();
	logic clk, reset;
	logic [19:0] freq;
	logic signed [23:0] wave_data;
	
	square_wave sq_dut(.*);

	parameter PERIOD = 100;
	
	initial begin
		clk <= 0;
		forever #(PERIOD/2) clk = ~clk;
	end
	
	initial begin
		@(posedge clk);	reset <= 1; freq <= 20'd2794;
		@(posedge clk);	reset <= 0;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk); 
		@(posedge clk); 
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);	
		@(posedge clk);	
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);	
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		
		$stop();
	
	end

endmodule 
module title_gen  #(parameter BLK_PER_SHAPE = 4, parameter TITLE_WIDTH = 28, parameter TITLE_HEIGHT = 6) 
				(title);

	output logic [(TITLE_WIDTH*TITLE_HEIGHT)-1:0]  title;  //Hard coded title array
	
	always_comb begin
		title = '{default:0};
		
		//row1
		title[ 3+(TITLE_WIDTH* 1): 1+(TITLE_WIDTH* 1)] = 3'b111;
		title[ 6+(TITLE_WIDTH* 1): 5+(TITLE_WIDTH* 1)] = 2'b11;
		title[10+(TITLE_WIDTH* 1): 8+(TITLE_WIDTH* 1)] = 3'b111;
		title[15+(TITLE_WIDTH* 1)] = 1'b1;
		title[19+(TITLE_WIDTH* 1):18+(TITLE_WIDTH* 1)] = 2'b11;
		//title[21+(TITLE_WIDTH* 1)] = 1'b1;
		//title[23+(TITLE_WIDTH* 1)] = 1'b1;
		//title[27+(TITLE_WIDTH* 1):25+(TITLE_WIDTH* 1)] = 3'b111;
		
		//row2
		title[ 2+(TITLE_WIDTH* 2)] = 1'b1;
		title[ 5+(TITLE_WIDTH* 2)] = 1'b1;
		title[ 9+(TITLE_WIDTH* 2)] = 1'b1;
		title[12+(TITLE_WIDTH* 2)] = 1'b1;
		title[13+(TITLE_WIDTH* 2)] = 1'b1;
		title[17+(TITLE_WIDTH* 2)] = 1'b1;
		//title[23+(TITLE_WIDTH* 2):21+(TITLE_WIDTH* 2)] = 3'b111;
		//title[25+(TITLE_WIDTH* 2)] = 1'b1;	
		
		//row3
		title[ 2+(TITLE_WIDTH* 3)] = 1'b1;
		title[ 5+(TITLE_WIDTH* 3)] = 1'b1;
		title[ 6+(TITLE_WIDTH* 3)] = 1'b1;
		title[ 9+(TITLE_WIDTH* 3)] = 1'b1;
		title[12+(TITLE_WIDTH* 3)] = 1'b1;
		title[15+(TITLE_WIDTH* 3)] = 1'b1;
		title[18+(TITLE_WIDTH* 3)] = 1'b1;
		//title[23+(TITLE_WIDTH* 3)] = 1'b1;
		//title[27+(TITLE_WIDTH* 3):25+(TITLE_WIDTH* 3)] = 3'b111;
		
		//row4
		title[ 2+(TITLE_WIDTH* 4)] = 1'b1;
		title[ 5+(TITLE_WIDTH* 4)] = 1'b1;
		title[ 9+(TITLE_WIDTH* 4)] = 1'b1;
		title[12+(TITLE_WIDTH* 4)] = 1'b1;
		title[15+(TITLE_WIDTH* 4)] = 1'b1;
		title[19+(TITLE_WIDTH* 4)] = 1'b1;
		//title[23+(TITLE_WIDTH* 4)] = 1'b1;
		//title[27+(TITLE_WIDTH* 4)] = 1'b1;
		
		//row5
		title[ 2+(TITLE_WIDTH* 5)] = 1'b1;
		title[ 5+(TITLE_WIDTH* 5)] = 1'b1;
		title[ 6+(TITLE_WIDTH* 5)] = 1'b1;
		title[ 9+(TITLE_WIDTH* 5)] = 1'b1;
		title[12+(TITLE_WIDTH* 5)] = 1'b1;
		title[15+(TITLE_WIDTH* 5)] = 1'b1;
		
		title[18+(TITLE_WIDTH* 5):17+(TITLE_WIDTH* 5)] = 3'b111;
		//title[23+(TITLE_WIDTH* 5)] = 1'b1;		
		//title[27+(TITLE_WIDTH* 5):25+(TITLE_WIDTH* 5)] = 3'b111;
		
		
		end
	
	
endmodule





















module mux4to1(
	input i_sel0,
	input i_sel1,
  	input [1:0] i_0,
	input [1:0] i_1,
	input [1:0] i_2,
	input [1:0] i_3,
	output reg [1:0] o_y
);

	always @(i_sel0,i_sel1,i_0,i_1,i_2,i_3) begin
		case({i_sel1,i_sel0})
			2'b00 : begin
				o_y = i_0;
			end
			
			2'b01 : begin
				o_y = i_1;
			end
			
			2'b10 : begin
				o_y = i_2;
			end
				
			default : begin
				o_y = i_3;
			end
		endcase
		
	end
	
endmodule
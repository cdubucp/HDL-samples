module mux4to1_tb();

	reg i_sel0;
	reg i_sel1;
	reg [1:0] i_0;
	reg [1:0] i_1;
	reg [1:0] i_2;
	reg [1:0] i_3;
	wire [1:0] o_y;
	
	mux4to1 dut (
		.i_sel0(i_sel0),
		.i_sel1(i_sel1),
		.i_0(i_0),
		.i_1(i_1),
		.i_2(i_2),
		.i_3(i_3),
		.o_y(o_y)
		);
	
	initial begin
		
		i_0 = 2'b00;
		i_1 = 2'b01;
		i_2 = 2'b10;
		i_3 = 2'b11;
		
		i_sel1 = 1'b0; i_sel0 = 1'b0; #10
		if(o_y != 2'b00)begin
			$display("Result was not 0 at 00. o_y = %0h", o_y);
		end
		
		i_sel1 = 1'b0; i_sel0 = 1'b1; #10
		if(o_y != 2'b01)begin
			$display("Result was not 1 at 01. o_y = %0h", o_y);
		end
		
		i_sel1 = 1'b1; i_sel0 = 1'b0; #10
		if(o_y != 2'b10)begin
			$display("Result was not 2 at 10. o_y = %0h", o_y);
		end
		
		i_sel1 = 1'b1; i_sel0 = 1'b1; #10
		if(o_y != 2'b11)begin
			$display("Result was not 3 at 11. o_y = %0h", o_y);
		end else begin
			$display("Test successful");
		end
		
	
	end
	
endmodule
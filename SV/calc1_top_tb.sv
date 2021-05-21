// test bench for COEN413 project "calc1"
`default_nettype none
module calc1_top_tb;
  
  // inputs
  reg c_clk;
  
  // reset needs to be set to 11111111 and held for 7 consecutive cycles
  // all inputs except the c_clk should be set to zero while resetting the design
  bit [7:0] reset;
  
  bit [3:0] req1_cmd_in;
  bit [3:0] req2_cmd_in;
  bit [3:0] req3_cmd_in;
  bit [3:0] req4_cmd_in;
  
  bit [31:0] req1_data_in;
  bit [31:0] req2_data_in;
  bit [31:0] req3_data_in;
  bit [31:0] req4_data_in;
  
  // outputs
  
  // response values
  // 00 no response
  // 01 success
  // 10 overflow, underflow, or invalid command. overflow/underflow only valid for add or sub commands
  // overflow occurs on add op when high order bit has a carry out
  // underflow occurs on a subtract operation when a larger number is subtracted from a smaller number
  // 11 unused response value
  logic [1:0] out_resp1;
  logic [1:0] out_resp2;
  logic [1:0] out_resp3;
  logic [1:0] out_resp4; 
  
  logic [31:0] out_data1;
  logic [31:0] out_data2;
  logic [31:0] out_data3;
  logic [31:0] out_data4;
  
  // test bench counters
  int error_count = 0;
  int correct_count = 0;
  
     calc1_top calc1_top (
			.c_clk(c_clk),
			.reset(reset),
			.req1_cmd_in(req1_cmd_in),
			.req2_cmd_in(req2_cmd_in),
			.req3_cmd_in(req3_cmd_in),
			.req4_cmd_in(req4_cmd_in),
			.req1_data_in(req1_data_in),
			.req2_data_in(req2_data_in),
			.req3_data_in(req3_data_in),
			.req4_data_in(req4_data_in),
			.out_resp1(out_resp1),
			.out_resp2(out_resp2),
			.out_resp3(out_resp3),
			.out_resp4(out_resp4),
			.out_data1(out_data1),
			.out_data2(out_data2),
			.out_data3(out_data3),
			.out_data4(out_data4)
			);
  
  // command decode values
  // req1_cmd_in = ADD
  localparam NOOP = 4'b0000,
  ADD = 4'b0001,
  SUB = 4'b0010,
  SHLEFT = 4'b0101,
  SHRIGHT = 4'b0110,
  RESET = 8'hff,
  ZERO = 8'h00;
  
  
     initial 
     begin
	req1_cmd_in = 0;
	req1_data_in = 0;
	req2_cmd_in = 0;
	req2_data_in = 0;
	req3_cmd_in = 0;
	req3_data_in = 0;
	req4_cmd_in = 0;
	req4_data_in = 0;
	
     end
  
  
  
initial begin
c_clk = 0;
forever #100 c_clk = ~c_clk;
end

  // test cases
  initial begin
	reset = ZERO;
	#200

	reset = RESET;
	#1400
	
	reset = ZERO;
	#200
	//#1000
	//assert_reset;
    // port 1
	//@(posedge c_clk);
   
    	  // add test 1 

	req4_cmd_in = 1;
	req4_data_in = 'h0000FFFF;
	req3_cmd_in = 1;
	req3_data_in = 'h0000FFFF;
	req2_cmd_in = 1;
	req2_data_in = 'h0000FFFF;
	req1_cmd_in = 1;
	req1_data_in = 'h0000FFFF;
	
	#200
	
	req4_cmd_in = 0;
	req4_data_in = 'hFFFF0000;
	req3_cmd_in = 0;
	req3_data_in = 'hFFFF0000;
	req2_cmd_in = 0;
	req2_data_in = 'hFFFF0000;
	req1_cmd_in = 0;
	req1_data_in = 'hFFFF0000;
	
  	#1600
	
	    	  // add test 2
	  
	 req1_cmd_in = 1;
	req1_data_in = 'hFFFFFFF0;
	req2_cmd_in = 1;
	req2_data_in = 'hFFFFFFF0;
	req3_cmd_in = 1;
	req3_data_in = 'hFFFFFFF0;
	req4_cmd_in = 1;
	req4_data_in = 'hFFFFFFF0;
		
	#200
	req1_cmd_in = 0;
	req1_data_in = 'h00000001;
	req2_cmd_in = 0;
	req2_data_in = 'h00000001;
	req3_cmd_in = 0;
	req3_data_in = 'h00000001;
	req4_cmd_in = 0;
	req4_data_in = 'h00000001;
		
	#1600
	
	
	    	  // sub test 3
	  
	req1_cmd_in = 2;
	req1_data_in = 'hFFFFFFFF;
	req2_cmd_in = 2;
	req2_data_in = 'hFFFFFFFF;
	req3_cmd_in = 2;
	req3_data_in = 'hFFFFFFFF;
	req4_cmd_in = 2;
	req4_data_in = 'hFFFFFFFF;
	

		
	#200
	req1_cmd_in = 0;
	req1_data_in = 'hFFFFFFFE;
	req2_cmd_in = 0;
	req2_data_in = 'hFFFFFFFE;
	req3_cmd_in = 0;
	req3_data_in = 'hFFFFFFFE;
	req4_cmd_in = 0;
	req4_data_in = 'hFFFFFFFE;
	
	#1600
	
		
	    	  // sub test 4
	  
	req1_cmd_in = 2;
	req1_data_in = 'hFFFFFFFF;
	req2_cmd_in = 2;
	req2_data_in = 'hFFFFFFFF;
	req3_cmd_in = 2;
	req3_data_in = 'hFFFFFFFF;
	req4_cmd_in = 2;
	req4_data_in = 'hFFFFFFFF;


		
	#200
	req1_cmd_in = 0;
	req1_data_in = 'hFFFFFFFF;
	req2_cmd_in = 0;
	req2_data_in = 'hFFFFFFFF;
	req3_cmd_in = 0;
	req3_data_in = 'hFFFFFFFF;
	req4_cmd_in = 0;
	req4_data_in = 'hFFFFFFFF;
		
	#1600
	

  		    	  // shift left test 5
	  
	req1_cmd_in = 5;
	req1_data_in = 'h00000001;
	req2_cmd_in = 5;
	req2_data_in = 'h00000001;
	req3_cmd_in = 5;
	req3_data_in = 'h00000001;
	req4_cmd_in = 5;
	req4_data_in = 'h00000001;
		
	#200
	req1_cmd_in = 0;
	req1_data_in = 'h00000002;
	req2_cmd_in = 0;
	req2_data_in = 'h00000002;
	req3_cmd_in = 0;
	req3_data_in = 'h00000002;
	req4_cmd_in = 0;
	req4_data_in = 'h00000002;
		
	#1600


	    	  // shift left test 6
	  
	req1_cmd_in = 5;
	req1_data_in = 'h00000001;
	req2_cmd_in = 5;
	req2_data_in = 'h00000001;
	req3_cmd_in = 5;
	req3_data_in = 'h00000001;
	req4_cmd_in = 5;
	req4_data_in = 'h00000001;
		
	#200
	req1_cmd_in = 0;
	req1_data_in = 'h00000002;
	req2_cmd_in = 0;
	req2_data_in = 'h00000012;
	req3_cmd_in = 0;
	req3_data_in = 'h000FFFF2;
	req4_cmd_in = 0;
	req4_data_in = 'hFFFFFFF2;
		
	#1600

//SHGIFTING 0 BITS
	
	req1_cmd_in = 5;
	req1_data_in = 'h00000009;
	req2_cmd_in = 5;
	req2_data_in = 'h00000009;
	req3_cmd_in = 5;
	req3_data_in = 'h00000009;
	req4_cmd_in = 5;
	req4_data_in = 'h00000009;
		
	#200


	req1_cmd_in = 0;
	req1_data_in = 'h00000000;
	req2_cmd_in = 0;
	req2_data_in = 'h00000000;
	req3_cmd_in = 0;
	req3_data_in = 'h00000000;
	req4_cmd_in = 0;
	req4_data_in = 'h00000000;
		
	#1600

	//SHIFT BY 31 

	req1_cmd_in = 5;
	req1_data_in = 'h00000007;
	req2_cmd_in = 5;
	req2_data_in = 'h00000007;
	req3_cmd_in = 5;
	req3_data_in = 'h00000007;
	req4_cmd_in = 5;
	req4_data_in = 'h00000007;
		
	#200


	req1_cmd_in = 0;
	req1_data_in = 'h0000001f;
	req2_cmd_in = 0;
	req2_data_in = 'h0000001f;
	req3_cmd_in = 0;
	req3_data_in = 'h0000001f;
	req4_cmd_in = 0;
	req4_data_in = 'h0000001f;
		
	#1600
	
	  	
	    	  // shift right test 5
	  
	req1_cmd_in = 6;
	req1_data_in = 'h80000000;
	req2_cmd_in = 6;
	req2_data_in = 'h80000000;
	req3_cmd_in = 6;
	req3_data_in = 'h80000000;
	req4_cmd_in = 6;
	req4_data_in = 'h80000000;

		
	#200
	req1_cmd_in = 0;
	req1_data_in = 'h00000002;
	req2_cmd_in = 0;
	req2_data_in = 'h00000002;
	req3_cmd_in = 0;
	req3_data_in = 'h00000002;
	req4_cmd_in = 0;
	req4_data_in = 'h00000002;
		
	#1600
	
	  	
	    	  // shift right test 6
	  
	req1_cmd_in = 6;
	req1_data_in = 'h8642ECA0;
	req2_cmd_in = 6;
	req2_data_in = 'h8642ECA0;
	req3_cmd_in = 6;
	req3_data_in = 'h8642ECA0;
	req4_cmd_in = 6;
	req4_data_in = 'h8642ECA0;

		
	#200
	req1_cmd_in = 0;
	req1_data_in = 'h0000003F;
	req2_cmd_in = 0;
	req2_data_in = 'hFFFFFFF2;
	req3_cmd_in = 0;
	req3_data_in = 'hFFFFFFF2;
	req4_cmd_in = 0;
	req4_data_in = 'hFFFFFFF2;
		
	#1600

	//SHGIFTING 0 BITS
	
	req1_cmd_in = 6;
	req1_data_in = 'h00000009;
	req2_cmd_in = 6;
	req2_data_in = 'h00000009;
	req3_cmd_in = 6;
	req3_data_in = 'h00000009;
	req4_cmd_in = 6;
	req4_data_in = 'h00000009;
		
	#200


	req1_cmd_in = 0;
	req1_data_in = 'h00000000;
	req2_cmd_in = 0;
	req2_data_in = 'h00000000;
	req3_cmd_in = 0;
	req3_data_in = 'h00000000;
	req4_cmd_in = 0;
	req4_data_in = 'h00000000;
		
	#1600

	//SHIFT BY 31 

	req1_cmd_in = 6;
	req1_data_in = 'he0000000;
	req2_cmd_in = 6;
	req2_data_in = 'he0000000;
	req3_cmd_in = 6;
	req3_data_in = 'he0000000;
	req4_cmd_in = 6;
	req4_data_in = 'he0000000;
		
	#200


	req1_cmd_in = 0;
	req1_data_in = 'h0000001f;
	req2_cmd_in = 0;
	req2_data_in = 'h0000001f;
	req3_cmd_in = 0;
	req3_data_in = 'h0000001f;
	req4_cmd_in = 0;
	req4_data_in = 'h0000001f;
		
	#1600
	
	       	  // overflow test 6
	  
	req1_cmd_in = 1;
	req1_data_in = 'hFFFFFFFF;
	req2_cmd_in = 1;
	req2_data_in = 'hFFFFFFFF;
	req3_cmd_in = 1;
	req3_data_in = 'hFFFFFFFF;
	req4_cmd_in = 1;
	req4_data_in = 'hFFFFFFFF;
	
		
	#200
	req1_cmd_in = 0;
	req1_data_in = 'h00000002;
	req2_cmd_in = 0;
	req2_data_in = 'h00000002;
	req3_cmd_in = 0;
	req3_data_in = 'h00000002;
	req4_cmd_in = 0;
	req4_data_in = 'h00000002;
		
	#1600
		

	
   
    	    	  // underflow test 7
	  
	req1_cmd_in = 2;
	req1_data_in = 'h00000000;
	req2_cmd_in = 2;
	req2_data_in = 'h00000000;
	req3_cmd_in = 2;
	req3_data_in = 'h00000000;
	req4_cmd_in = 2;
	req4_data_in = 'h00000000;
		
  
    		
	#200
	req1_cmd_in = 0;
	req1_data_in = 'h00000001;
	req2_cmd_in = 0;
	req2_data_in = 'h00000001;
	req3_cmd_in = 0;
	req3_data_in = 'h00000001;
	req4_cmd_in = 0;
	req4_data_in = 'h00000001;
	
	#1600
	
	
	  // invalid test 8
	 
  	req1_cmd_in = 7;
	req1_data_in = 'h2309abef;
	req2_cmd_in = 7;
	req2_data_in = 'h2309abef;
	req3_cmd_in = 7;
	req3_data_in = 'h2309abef;
	req4_cmd_in = 7;
	req4_data_in = 'h2309abef;

	#200

	req1_cmd_in = 0;
	req1_data_in = 'h332200ff;
	req2_cmd_in = 0;
	req2_data_in = 'h332200ff;
	req3_cmd_in = 0;
	req3_data_in = 'h332200ff;
	req4_cmd_in = 0;
	req4_data_in = 'h332200ff;
  
  	#1600
  
  
   #50000 $stop;
  end
  
  
   task assert_reset;
      reset = ZERO;
      @(posedge c_clk);
        reset = RESET;
      repeat(7) @(posedge c_clk);     
      reset = ZERO;    
   endtask // assert_reset
 

  
endmodule  

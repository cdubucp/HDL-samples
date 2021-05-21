
// test bench for COEN413 project "calc2"
`default_nettype none

module calc2_top_tb;
  
  import pack::*;
  
  // inputs
  bit c_clk;
  
  // reset needs to be set to 11111111 and held for 3 consecutive cycles
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
  
  // tags are used for setting the order of commands (I think?)
  bit [1:0] req1_tag_in;
  bit [1:0] req2_tag_in;
  bit [1:0] req3_tag_in;
  bit [1:0] req4_tag_in;
  
  // outputs
  
  // response values
  // 00 no response
  // 01 successc
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
  
  logic [1:0] out_tag1;
  logic [1:0] out_tag2;
  logic [1:0] out_tag3;
  logic [1:0] out_tag4;
  
  // port mapping
     calc2_top calc2_top (
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
			.req1_tag_in(req1_tag_in),
			.req2_tag_in(req2_tag_in),
			.req3_tag_in(req3_tag_in),
			.req4_tag_in(req4_tag_in),
			.out_resp1(out_resp1),
			.out_resp2(out_resp2),
			.out_resp3(out_resp3),
			.out_resp4(out_resp4),
			.out_data1(out_data1),
			.out_data2(out_data2),
			.out_data3(out_data3),
			.out_data4(out_data4),
			.out_tag1(out_tag1),
			.out_tag2(out_tag2),
			.out_tag3(out_tag3),
			.out_tag4(out_tag4)
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
  
  // assign class object values to the DUT inputs
  task assignValues(input int cmdin, tag, Calculation c);
    
    req1_cmd_in = cmdin;
    req2_cmd_in = cmdin;
    req3_cmd_in = cmdin;
    req4_cmd_in = cmdin;
    
    req1_tag_in = tag;
    req2_tag_in = tag;
    req3_tag_in = tag;
    req4_tag_in = tag;
    
    req1_data_in = c.req1_data_in;
    req2_data_in = c.req2_data_in;
    req3_data_in = c.req3_data_in;
    req4_data_in = c.req4_data_in;
  
  endtask 
  
  task init();
    
   	reset = ZERO;
    	
 		req1_cmd_in = 0;
    req2_cmd_in = 0;
    req3_cmd_in = 0;
    req4_cmd_in = 0;
    
    req1_tag_in = 0;
    req2_tag_in = 0;
    req3_tag_in = 0;
    req4_tag_in = 0;
    
    req1_data_in = 0;
    req2_data_in = 0;
    req3_data_in = 0;
    req4_data_in = 0;
    	
    	
	  #200;

	  reset = RESET;
	  #600;
	
	  reset = ZERO;
	  #200;
	  
  endtask
  
  // main start
  
initial begin
  c_clk = 0;
  forever #100 c_clk = ~c_clk;
end

Calculation c1, c2;

// timeCount is used just for checking the timings during simulation
int tag = 0;

  // test cases
  initial begin
  
   init();
   
   $display("Start of ADD tests");
   
   $display("Tag = %d", tag);
   // ADD tests
  
    // generate random values then assign them to the DUT inputs
    c1 = new();
    c1.randomize();
    $display("C1:");
    c1.printAll();
    
    assignValues(ADD,0,c1);
    
    #200;
    
    c2 = new();
    c2.randomize();
    $display("C2:");
    c2.printAll();
    
    assignValues(NOOP,NOOP,c2);
    
    #200;
    
    c1 = new();
    c1.randomize();
    $display("C1:");
    c1.printAll();
    
    assignValues(ADD,1,c1);
    
    #200;
    
    c2 = new();
    c2.randomize();
    $display("C2:");
    c2.printAll();
    
    assignValues(NOOP,NOOP,c2);
    
    #200;
    
    c1 = new();
    c1.randomize();
    $display("C1:");
    c1.printAll();
    
    assignValues(ADD,2,c1);
    
    #200;
    
    c2 = new();
    c2.randomize();
    $display("C2:");
    c2.printAll();
    
    assignValues(NOOP,NOOP,c2);
    
    #200;
    
    c1 = new();
    c1.randomize();
    $display("C1:");
    c1.printAll();
    
    assignValues(ADD,3,c1);
    
    #200;
    
    c2 = new();
    c2.randomize();
    $display("C2:");
    c2.printAll();
    
    assignValues(NOOP,NOOP,c2);
    
    #200;
    
    $display("Start of SUB tests");
    c1 = new();
    c1.randomize();
    $display("C1:");
    c1.printAll();
    
    assignValues(SUB,0,c1);
    
    #200;
    
    c2 = new();
    c2.randomize();
    $display("C2:");
    c2.printAll();
    
    assignValues(NOOP,NOOP,c2);
    
    #200;
    
    c1 = new();
    c1.randomize();
    $display("C1:");
    c1.printAll();
    
    assignValues(SUB,1,c1);
    
    #200;
    
    c2 = new();
    c2.randomize();
    $display("C2:");
    c2.printAll();
    
    assignValues(NOOP,NOOP,c2);
    
    #200;
    
    c1 = new();
    c1.randomize();
    $display("C1:");
    c1.printAll();
    
    assignValues(SUB,2,c1);
    
    #200;
    
    c2 = new();
    c2.randomize();
    $display("C2:");
    c2.printAll();
    
    assignValues(NOOP,NOOP,c2);
    
    #200;
    
    c1 = new();
    c1.randomize();
    $display("C1:");
    c1.printAll();
    
    assignValues(SUB,3,c1);
    
    #200;
    
    c2 = new();
    c2.randomize();
    $display("C2:");
    c2.printAll();
    
    assignValues(NOOP,NOOP,c2);
    
    #200;
    
    $display("Start of SHLEFT tests");
    
    c1 = new();
    c1.randomize();
    $display("C1:");
    c1.printAll();
    
    assignValues(SHLEFT,0,c1);
    
    #200;
    
    c2 = new();
    c2.randomize();
    $display("C2:");
    c2.printAll();
    
    assignValues(NOOP,NOOP,c2);
    
    #200;
    
    c1 = new();
    c1.randomize();
    $display("C1:");
    c1.printAll();
    
    assignValues(SHLEFT,1,c1);
    
    #200;
    
    c2 = new();
    c2.randomize();
    $display("C2:");
    c2.printAll();
    
    assignValues(NOOP,NOOP,c2);
    
    #200;
    
    c1 = new();
    c1.randomize();
    $display("C1:");
    c1.printAll();
    
    assignValues(SHLEFT,2,c1);
    
    #200;
    
    c2 = new();
    c2.randomize();
    $display("C2:");
    c2.printAll();
    
    assignValues(NOOP,NOOP,c2);
    
    #200;
    
    c1 = new();
    c1.randomize();
    $display("C1:");
    c1.printAll();
    
    assignValues(SHLEFT,3,c1);
    
    #200;
    
    c2 = new();
    c2.randomize();
    $display("C2:");
    c2.printAll();
    
    assignValues(NOOP,NOOP,c2);
    
    #200;
    
    $display("Start of SHRIGHT tests");
    
    c1 = new();
    c1.randomize();
    $display("C1:");
    c1.printAll();
    
    assignValues(SHRIGHT,0,c1);
    
    #200;
    
    c2 = new();
    c2.randomize();
    $display("C2:");
    c2.printAll();
    
    assignValues(NOOP,NOOP,c2);
    
    #200;
    
    c1 = new();
    c1.randomize();
    $display("C1:");
    c1.printAll();
    
    assignValues(SHRIGHT,1,c1);
    
    #200;
    
    c2 = new();
    c2.randomize();
    $display("C2:");
    c2.printAll();
    
    assignValues(NOOP,NOOP,c2);
    
    #200;
    
    c1 = new();
    c1.randomize();
    $display("C1:");
    c1.printAll();
    
    assignValues(SHRIGHT,2,c1);
    
    #200;
    
    c2 = new();
    c2.randomize();
    $display("C2:");
    c2.printAll();
    
    assignValues(NOOP,NOOP,c2);
    
    #200;
    
    c1 = new();
    c1.randomize();
    $display("C1:");
    c1.printAll();
    
    assignValues(SHRIGHT,3,c1);
    
    #200;
    
    c2 = new();
    c2.randomize();
    $display("C2:");
    c2.printAll();
    
    assignValues(NOOP,NOOP,c2);
    
    
    #30000 $stop;
 end
 
endmodule


package pack;
  
  class Calculation;
    
  // test bench counters
  static int error_count = 0;
  static int correct_count = 0;
    
  bit [3:0] req1_cmd_in;
  bit [3:0] req2_cmd_in;
  bit [3:0] req3_cmd_in;
  bit [3:0] req4_cmd_in;
  
  rand bit [31:0] req1_data_in;
  rand bit [31:0] req2_data_in;
  rand bit [31:0] req3_data_in;
  rand bit [31:0] req4_data_in;
  
  constraint c { 
  req1_data_in inside {[0:31]};
  req2_data_in inside {[0:31]};
  req3_data_in inside {[0:31]};
  req4_data_in inside {[0:31]};
}

  bit [1:0] req1_tag_in;
  bit [1:0] req2_tag_in;
  bit [1:0] req3_tag_in;
  bit [1:0] req4_tag_in;
  
  // outputs
  
  // response values
  // 00 no response
  // 01 success
  // 10 overflow, underflow, or invalid command. overflow/underflow only valid for add or sub commands
  // overflow occurs on add op when high order bit has a carry out
  // underflow occurs on a subtract operation when a larger number is subtracted from a smaller number
  // 11 unused response value
  
  /*
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
    */
    
  function new();
  
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
   
  endfunction
  
  function void printAll();
    
    $display("Req1 data = %d",req1_data_in);
    $display("Req2 data = %d",req2_data_in);
    $display("Req3 data = %d",req3_data_in);
    $display("Req4 data = %d",req4_data_in);
    
  endfunction
    
  endclass
    
endpackage

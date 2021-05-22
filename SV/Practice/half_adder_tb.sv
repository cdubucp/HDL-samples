
module half_adder_tb();
  // reg = inputs
  // wire = outputs
  reg i_bit1;
  reg i_bit2;
  wire o_sum;
  wire o_carry;
  
  // port map
  half_adder dut(
    .i_bit1(i_bit1),
    .i_bit2(i_bit2),
    .o_sum(o_sum),
    .o_carry(o_carry)
  );
  
  // start self-checking test
  initial begin
    i_bit1 = 0; i_bit2 = 0; #10
    if({o_carry,o_sum} != 2'b00) begin
      $display("00 has failed");
    end
    
    i_bit1 = 0; i_bit2 = 1; #10
    if({o_carry,o_sum} != 2'b01) begin
      $display("01 has failed");
    end
    
    i_bit1 = 1; i_bit2 = 0; #10
    if({o_carry,o_sum} != 2'b01) begin
      $display("01 has failed");
    end
    
    i_bit1 = 1; i_bit2 = 1; #10
    if({o_carry,o_sum} != 2'b10) begin
      $display("10 has failed");
    end else begin 
      $display("Success");
    end
    
  end

endmodule
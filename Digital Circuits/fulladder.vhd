library IEEE;
use IEEE.std_logic_1164.all;

entity fulladder is
	port(
		A,B,Cin,clk : in std_logic;
		Sum, CarryOut : out std_logic
	);
end entity fulladder;

architecture rtl of fulladder is

begin
	Sum <= A xor B xor Cin;
	CarryOut <= (A and B) or (Cin and (A xor B));
			
end rtl;
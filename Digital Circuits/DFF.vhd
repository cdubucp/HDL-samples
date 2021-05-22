library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DFF is
	port(
		clk,reset,D : in std_logic;
		Q,Qnot : out std_logic);

end entity DFF;

architecture behav of DFF is

begin
	
		process(clk,reset)
			
		begin
			if(reset = '1') then
				Q <= '0';
				Qnot <= '1';
			elsif(rising_edge(clk)) then
				Q <= D;
				Qnot <= Q;
			end if;
	
		end process;
	
end behav;
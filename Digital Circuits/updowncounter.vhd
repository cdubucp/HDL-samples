library IEEE;
use IEEE.std_logic_1164.all;

entity updowncounter is
	generic(
		max_count : integer := 10
	);
	port(
		clk, rst, i_dir : in std_logic;
		o_full, o_empty : out std_logic
	);
end updowncounter;

-- counter resets to 0 when rst = '1'
-- counter increments while i_dir = '1'
-- max count = 10
-- while counter is at max, flag o_full = '1'
-- counter decrements while i_dir = '0'
-- min count = 0
-- while counter is empty, flag o_empty = '1'

architecture rtl of counter is
	signal count : integer := 0; 
	begin
	
	process(clk,rst)
	
	begin
		if(rst = '1')then
			count <= 0;
			elsif(rising_edge(clk))then
				if(i_dir = '1' and not(count = max_count))then
					count <= count + 1;
				elsif(i_dir = '0' and not(count = 0))then
					count <= count - 1;
				end if;
		end if;
	end process;

	o_full <= '1' when (count = max_count) else '0';
	o_empty <= '1' when (count = 0) else '0';

end rtl;
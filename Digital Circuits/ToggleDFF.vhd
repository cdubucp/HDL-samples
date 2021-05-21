library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity toggleDFF is
	port(
	clk,D in:std_logic;
	Q out:std_logic);
end toggleDFF;

architecture example of toggleDFF is
-- signals go here
begin

	D <= (not Q);

	process(clk)
	-- variables go here
	begin
		if (rising_edge(clk)) then
			Q <= D;
		end if;
	end process;
end example;
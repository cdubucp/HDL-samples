library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity enc8to3 is
	port(
	i: in std_logic_vector(7 downto 0);
	o: out std_logic_vector(2 downto 0));

end entity enc8to3;

architecture rtl of enc8to3 is
-- 8 to 3 encoder
begin
	
	o(0) <= i(1) or i(3) or i(5) or i(7);
	o(1) <= i(2) or i(3) or i(6) or i(7);
	o(2) <= i(4) or i(5) or i(6) or i(7);
	
end rtl;
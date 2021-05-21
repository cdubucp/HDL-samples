library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity enc8to3 is
	port(
	i: in std_logic_vector(7 downto 0);
	--i0,i1,i2,i3,i4,i5,i6,i7: in std_logic;
	o: out std_logic_vector(2 downto 0));
	--o2,o1,o0: out std_logic);	
	
end entity enc8to3;

architecture rtl of enc8to3 is

begin
	
	o(0) <= i(1) or i(3) or i(5) or i(7);
	o(1) <= i(2) or i(3) or i(6) or i(7);
	o(2) <= i(4) or i(5) or i(6) or i(7);
	--o0 <= i1 or i3 or i5 or i7;
	--o1 <= i2 or i3 or i6 or i7;
	--o2 <= i4 or i5 or i6 or i7;
	
end rtl;
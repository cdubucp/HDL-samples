library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity halfadder is
	port(
	A,B,reset in:std_logic;
	sum,cout out:std_logic);
end halfadder;

architecture halfadder_arch of halfadder is
signal x,y : std_logic;
begin

	process(A,B,reset)
	begin
		if (reset ='1') then
			x <= 0;
			y <= 0;
		else
			x <= A xor B;
			y <= A and B;
		end if;
	end process;

	sum <= x;
	cout <= y;

end halfadder_arch;
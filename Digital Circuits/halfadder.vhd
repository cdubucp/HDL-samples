library ieee;
use ieee.std_logic_1164.all;

entity halfadder is
	port(
		A,B in:std_logic;
		sum,cout out:std_logic);
end halfadder;

architecture rtl of halfadder is

begin

	sum <= A xor B;
	cout <= A and B;

end rtl;
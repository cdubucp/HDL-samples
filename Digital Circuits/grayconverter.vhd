library IEEE;
use IEEE.std_logic_1164.all;

entity graycon is
	generic(
		word_length : natural :=8
	);
	port(
		bin: in std_logic_vector(word_length-1 downto 0);
		gray: out std_logic_vector(word_length-1 downto 0)
	);
end graycon;

architecture rtl of graycon is
-- binary to gray code converter
begin

	process(bin)
	variable i: integer := 0;
	begin
			
		for i in word_length-2 downto 0 loop
			gray(i) <= bin(i+1) xor bin(i);
		end loop;
		
		gray(word_length-1) <= bin(word_length-1);
	
	end process;

end rtl;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

-- COEN316 lab 2
-- written by Chris Dubuc-Pesetti
-- Register File
entity regfile is
port( 		din 			: in std_logic_vector(31 downto 0);
		reset 			: in std_logic;
		clk 			: in std_logic;
		write 			: in std_logic;
		read_a 			: in std_logic_vector(4 downto 0);
		read_b 			: in std_logic_vector(4 downto 0);
		write_address 		: in std_logic_vector(4 downto 0);
		out_a 			: out std_logic_vector(31 downto 0);
		out_b 			: out std_logic_vector(31 downto 0));
end regfile ;

architecture behav of regfile is
	-- create 32 position array of 32-bit registers initialized to all 0's
	type registerFile is array (0 to 31) of std_logic_vector(31 downto 0);
	signal registers : registerFile := (others => (others => '0'));
begin

	out_a <= 	registers(0) when (read_a = "00000") else
			registers(1) when (read_a = "00001") else
			registers(2) when (read_a = "00010") else
			registers(3) when (read_a = "00011") else
			registers(4) when (read_a = "00100") else
			registers(5) when (read_a = "00101") else
			registers(6) when (read_a = "00110") else
			registers(7) when (read_a = "00111") else
			registers(8) when (read_a = "01000") else
			registers(9) when (read_a = "01001") else
			registers(10) when (read_a = "01010") else
			registers(11) when (read_a = "01011") else
			registers(12) when (read_a = "01100") else
			registers(13) when (read_a = "01101") else
			registers(14) when (read_a = "01110") else
			registers(15) when (read_a = "01111") else
			registers(16) when (read_a = "10000") else
			registers(17) when (read_a = "10001") else
			registers(18) when (read_a = "10010") else
			registers(19) when (read_a = "10011") else
			registers(20) when (read_a = "10100") else
			registers(21) when (read_a = "10101") else
			registers(22) when (read_a = "10110") else
			registers(23) when (read_a = "10111") else
			registers(24) when (read_a = "11000") else
			registers(25) when (read_a = "11001") else
			registers(26) when (read_a = "11010") else
			registers(27) when (read_a = "11011") else
			registers(28) when (read_a = "11100") else
			registers(29) when (read_a = "11101") else
			registers(30) when (read_a = "11110") else
			registers(31);

	out_b <= 	registers(0) when (read_b = "00000") else
			registers(1) when (read_b = "00001") else
			registers(2) when (read_b = "00010") else
			registers(3) when (read_b = "00011") else
			registers(4) when (read_b = "00100") else
			registers(5) when (read_b = "00101") else
			registers(6) when (read_b = "00110") else
			registers(7) when (read_b = "00111") else
			registers(8) when (read_b = "01000") else
			registers(9) when (read_b = "01001") else
			registers(10) when (read_b = "01010") else
			registers(11) when (read_b = "01011") else
			registers(12) when (read_b = "01100") else
			registers(13) when (read_b = "01101") else
			registers(14) when (read_b = "01110") else
			registers(15) when (read_b = "01111") else
			registers(16) when (read_b = "10000") else
			registers(17) when (read_b = "10001") else
			registers(18) when (read_b = "10010") else
			registers(19) when (read_b = "10011") else
			registers(20) when (read_b = "10100") else
			registers(21) when (read_b = "10101") else
			registers(22) when (read_b = "10110") else
			registers(23) when (read_b = "10111") else
			registers(24) when (read_b = "11000") else
			registers(25) when (read_b = "11001") else
			registers(26) when (read_b = "11010") else
			registers(27) when (read_b = "11011") else
			registers(28) when (read_b = "11100") else
			registers(29) when (read_b = "11101") else
			registers(30) when (read_b = "11110") else
			registers(31);

	process(clk,reset)
	begin
		if (reset = '1') then
			registers <= (others=>(others=>'0'));
		elsif (clk'event and clk = '1') then
			if (write = '1') then
				if (write_address = "00000") then
					registers(0) <= din;
				elsif (write_address = "00001") then
					registers(1) <= din;
				elsif (write_address = "00010") then
					registers(2) <= din;
				elsif (write_address = "00011") then
					registers(3) <= din;
				elsif (write_address = "00100") then
					registers(4) <= din;
				elsif (write_address = "00101") then
					registers(5) <= din;
				elsif (write_address = "00110") then
					registers(6) <= din;
				elsif (write_address = "00111") then
					registers(7) <= din;
				elsif (write_address = "01000") then
					registers(8) <= din;
				elsif (write_address = "01001") then
					registers(9) <= din;
				elsif (write_address = "01010") then
					registers(10) <= din;
				elsif (write_address = "01011") then
					registers(11) <= din;
				elsif (write_address = "01100") then
					registers(12) <= din;
				elsif (write_address = "01101") then
					registers(13) <= din;
				elsif (write_address = "01110") then
					registers(14) <= din;
				elsif (write_address = "01111") then
					registers(15) <= din;
				elsif (write_address = "10000") then
					registers(16) <= din;
				elsif (write_address = "10001") then
					registers(17) <= din;
				elsif (write_address = "10010") then
					registers(18) <= din;
				elsif (write_address = "10011") then
					registers(19) <= din;
				elsif (write_address = "10100") then
					registers(20) <= din;
				elsif (write_address = "10101") then
					registers(21) <= din;
				elsif (write_address = "10110") then
					registers(22) <= din;
				elsif (write_address = "10111") then
					registers(23) <= din;
				elsif (write_address = "11000") then
					registers(24) <= din;
				elsif (write_address = "11001") then
					registers(25) <= din;
				elsif (write_address = "11010") then
					registers(26) <= din;
				elsif (write_address = "11011") then
					registers(27) <= din;
				elsif (write_address = "11100") then
					registers(28) <= din;
				elsif (write_address = "11101") then
					registers(29) <= din;
				elsif (write_address = "11110") then
					registers(30) <= din;
				else
					registers(31) <= din;
				end if;
			-- registers(to_integer(unsigned(write_address))) <= din; --need numeric_std for to_integer
			end if;
		end if;
	end process;
	
end behav;

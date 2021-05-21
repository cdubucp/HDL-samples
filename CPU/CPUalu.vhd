library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

-- COEN316 lab 1
-- written by Chris Dubuc-Pesetti
-- Arithmetic Logic Unit
entity alu is
port(x, y : in std_logic_vector(31 downto 0);
	-- two input operands
	add_sub : in std_logic ;
	-- 0 = add , 1 = sub
	logic_func : in std_logic_vector(1 downto 0 ) ;
	-- 00 = AND, 01 = OR , 10 = XOR , 11 = NOR
	func		: in std_logic_vector(1 downto 0 ) ;
	-- 00 = lui, 01 = setless , 10 = arith , 11 = logic
	output		: out std_logic_vector(31 downto 0) ;
	overflow	: out std_logic ;
	zero		: out std_logic);
end alu ;

architecture behav of alu is

-- signals
signal adder_subtract		: std_logic_vector(31 downto 0);
signal logic_unit		: std_logic_vector(31 downto 0);
signal adder_subtract_sum	: signed(31 downto 0);
signal adder_subtract_dif	: signed(31 downto 0);
signal bool_sum			: std_logic;
signal bool_dif			: std_logic;

begin
	--sum comb logic
	adder_subtract_sum <= signed(x) + signed(y);
	
	--dif comb logic
	adder_subtract_dif <= signed(x) - signed(y);
	
	--adder_subtract block
	process(adder_subtract_sum,adder_subtract_dif,add_sub)
	begin
		if (add_sub = '0') then
			adder_subtract <= std_logic_vector(adder_subtract_sum);
		else
			adder_subtract <= std_logic_vector(adder_subtract_dif);
		end if;
	end process;

	--logic unit block
	process(x,y,logic_func,func)
	variable temp : std_logic_vector(31 downto 0);
	begin
		if (func == "11") then
			if (logic_func = "00") then --AND
				temp := x AND y;
			elsif (logic_func = "01") then --OR
				temp := x OR y;
			elsif (logic_func = "10") then --XOR
				temp := x XOR y;
			else				--NOR
				temp := (not (x OR y));
			end if;
			logic_unit <= temp;
		end if;
	end process;

	-- 4to1 output mux
	process(y,adder_subtract,logic_unit,func,adder_subtract_dif)
	variable temp : std_logic_vector(31 downto 0) := (others => '0');
	begin
		if (func = "00") then		-- lui
			temp := y; 
		elsif (func = "01") then	-- slt
			temp := "0000000000000000000000000000000" & std_logic_vector(adder_subtract_dif(31 downto 31)); 
		elsif (func = "10") then	-- output of adder_subtract
			temp := adder_subtract;
		else						-- output of logic_unit
			temp := logic_unit;
		end if;
		--output <= (not temp); -- negated onboard LED output
		output <= temp;
	end process;

	-- zero bit output
	process(adder_subtract)
	begin
		if (adder_subtract = "00000000000000000000000000000000") then		
			zero <= '1'; 
		else
			zero <= '0';
		end if;
	end process;

	-- overflow detection logic
	bool_sum <= ((NOT x(31)) AND (NOT y(31)) AND adder_subtract(31)) OR ( x(31) AND y(31) AND (NOT adder_subtract(31)));
	bool_dif <= ((x(31)) AND (NOT y(31)) AND (NOT adder_subtract(31))) OR ((NOT x(31)) AND (y(31)) AND (adder_subtract(31)));
	
	-- overflow bit output
	process(bool_sum,bool_dif,add_sub)
	begin
		if (add_sub = '0' AND bool_sum = '1') then		
			overflow <= '1'; 
		elsif (add_sub = '1' AND bool_dif = '1') then
			overflow <= '1';
		else
			overflow <= '0';
		end if;
	end process;
	-- ORing not the solution, check for (add_sub = 0 AND bool_sum) or (add_sub = 1 AND bool_dif) then set overflow = 1

end behav;



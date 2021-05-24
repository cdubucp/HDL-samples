library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

-- COEN316 lab 3
-- written by Chris Dubuc-Pesetti
-- Next Address Unit
entity next_address is
port(rt, rs 		: in std_logic_vector(31 downto 0);
		-- two register inputs
	pc 				: in std_logic_vector(31 downto 0);
	target_address 	: in std_logic_vector(25 downto 0);
	branch_type 	: in std_logic_vector(1 downto 0);
	pc_sel 			: in std_logic_vector(1 downto 0);
	next_pc 		: out std_logic_vector(31 downto 0));
end next_address ;

architecture behav of next_address is 

--signals
signal one					: std_logic_vector(31 downto 0);
signal pc_plus_one 			: std_logic_vector(31 downto 0);
signal jump_conc_32bit		: std_logic_vector(31 downto 0);
signal jump_ext_32bit		: std_logic_vector(31 downto 0);
signal branch_mux_out		: std_logic_vector(31 downto 0);
signal extend_sum			: std_logic_vector(31 downto 0);
signal beq_mux_out			: std_logic_vector(31 downto 0);
signal bne_mux_out			: std_logic_vector(31 downto 0);
signal bltz_mux_out			: std_logic_vector(31 downto 0);
signal zero					: std_logic_vector(0 downto 0);
signal ltz					: std_logic_vector(0 downto 0);
signal adder_subtract_diff	: unsigned(31 downto 0);

begin
	one <= "00000000000000000000000000000001";
	pc_plus_one <= std_logic_vector(unsigned(pc) + unsigned(one));
	
	jump_conc_32bit <= "000000" & target_address;
	
	-- jump 32bit sign extend
	process(target_address)
	begin
		if (target_address(15) = '0') then
			jump_ext_32bit <= "0000000000000000" & target_address(15 downto 0);
		else
			jump_ext_32bit <= "1111111111111111" & target_address(15 downto 0);
		end if;
	end process;
	extend_sum <= std_logic_vector(unsigned(pc_plus_one) + unsigned(jump_ext_32bit));
	
	--zero detect
	adder_subtract_diff <= unsigned(rs) - unsigned(rt);
	process(adder_subtract_diff)
	begin
		if (adder_subtract_diff = "00000000000000000000000000000000") then
			zero <= "1";
		else
			zero <= "0";
		end if;
	end process;
	
	--beq, bne muxes
	process(pc_plus_one, extend_sum, zero)
	begin
		if (zero = "1") then
			beq_mux_out <= extend_sum;
			bne_mux_out <= pc_plus_one;
		else
			beq_mux_out <= pc_plus_one;
			bne_mux_out <= extend_sum;
		end if;
	end process;
	
	-- less than zero detect
	process(rs)
	begin
		if (rs(31) = '1') then
			ltz <= "1";
		else
			ltz <= "0";
		end if;
	end process;
	
	--bltz mux
	process(pc_plus_one, extend_sum, ltz)
	begin
		if (ltz = "1") then
			bltz_mux_out <= extend_sum;
			
		else
			bltz_mux_out <= pc_plus_one;
		end if;
	end process;
	
	-- branch_type mux
	process(pc_plus_one, beq_mux_out, bne_mux_out, bltz_mux_out, branch_type)
	begin
		if (branch_type = "00") then
			branch_mux_out <= pc_plus_one;
		elsif (branch_type = "01") then
			branch_mux_out <= beq_mux_out;
		elsif (branch_type = "10") then
			branch_mux_out <= bne_mux_out;
		else
			branch_mux_out <= bltz_mux_out;
		end if;
	end process;
	
	--pc_sel mux
	process(branch_mux_out,jump_conc_32bit,rs,pc_sel)
	begin
		case pc_sel is
			when "00" =>	next_pc <= branch_mux_out;
			when "01" =>	next_pc <= jump_conc_32bit;
			when others =>	next_pc <= rs;
		end case;
	end process;

end behav;

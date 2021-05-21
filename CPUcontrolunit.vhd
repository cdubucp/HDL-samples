library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

-- COEN316 lab 5
-- written by Chris Dubuc-Pesetti
-- CPU Entity, datapath/control unit integration
entity cpu is 
port(		clk 			: in std_logic;
			reset 			: in std_logic;
			rs_out, rt_out	: out std_logic_vector(3 downto 0);
			-- output ports from register file
			
			pc_out			: out std_logic_vector(3 downto 0); -- pc reg 
			overflow, zero	: out std_logic
			
			--mux control signals
			reg_dst			: in std_logic;
			alu_src			: in std_logic;
			reg_in_src		: in std_logic;
			
			--dcache write control signal
			data_write		: in std_logic;

			func			: in std_logic_vector(1 downto 0);

			-- all below will need to be port mapped
			
			-- inputs
			-- next_pc output from NAU
			pc_in 			: in std_logic_vector(31 downto 0);

			-- output from main ALU, goes to dcache (4 downto 0) and reg_in_src mux (31 downto 0)
			ALU_result		: in std_logic_vector(31 downto 0);
			
			-- output from register file: out_b(rt), goes to d_in of data cache
			regfile_out_b			: in std_logic_vector(31 downto 0);

			-- outputs
			
			-- output of icache, goes to register file read address inputs
			read_a			: out std_logic_vector(4 downto 0);
			read_b			: out std_logic_vector(4 downto 0);
			
			-- output of reg_dst mux, goes to register file write address input
			reg_dst_out		: out std_logic_vector(4 downto 0);
			
			-- icache output, goes to NAU target_address input
			target_address	: out std_logic_vector(25 downto 0);
			
			-- alu_src mux output, goes to the ALU y input
			alu_src_out		: out std_logic_vector(31 downto 0);
			
			-- reg_in_src mux output, goes to d_in of register file
			reg_in_src_out	: out std_logic_vector(31 downto 0);

			-- to pc input of ALU
			pc_out32 		: out std_logic_vector(31 downto 0);
			
			--control signals
			
			--to regfile
			reg_write		: out std_logic;
			
			--to ALU
			add_sub			: out std_logic;
			logic_func		: out std_logic_vector(1 downto 0);
			func			: out std_logic_vector(1 downto 0);
			
			--to NAU
			branch_type		: out std_logic_vector(1 downto 0);
			pc_sel			: out std_logic_vector(1 downto 0));
			
end cpu;

architecture behav of cpu is
signal pc_out5 			: std_logic_vector(4 downto 0);
signal icache_out		: std_logic_vector(31 downto 0);
signal op				: std_logic_vector(5 downto 0);
signal rs				: std_logic_vector(4 downto 0);
signal rt				: std_logic_vector(4 downto 0);
signal rd				: std_logic_vector(4 downto 0);
signal funct			: std_logic_vector(5 downto 0);
signal immediate		: std_logic_vector(15 downto 0);
signal jump_address		: std_logic_vector(25 downto 0);
signal sign_ext_out		: std_logic_vector(31 downto 0);
--signal dcache_address		: std_logic_vector(4 downto 0);
--signal d_in				: std_logic_vector(31 downto 0);
signal d_out			: std_logic_vector(31 downto 0);
signal i_address_in		: std_logic_vector(4 downto 0);

-- not sure if needed
type dataCache is array (0 to 31) of std_logic_vector(31 downto 0);
signal dcache : dataCache := (others => (others => '0'));

begin
	-- control unit
	process(op,rs,rt,rd,funct)
	begin
		if(op = "001111") then --lui
			reg_write		<= '1';
			reg_dst			<= '0';
			reg_in_src		<= '1';
			alu_src			<= '1';
			add_sub			<= '0';
			data_write		<= '0';
			logic_func		<= "00";
			func			<= "00";
			branch_type		<= "00";
			pc_sel			<= "00";
			
		elsif (op = "001000"	) then -- addi
			reg_write		<= '1';
			reg_dst			<= '0';
			reg_in_src		<= '1';
			alu_src			<= '1';
			add_sub			<= '0';
			data_write		<= '0';
			logic_func		<= "00";
			func			<= "10";
			branch_type		<= "00";
			pc_sel			<= "00";
		
		elsif (op = "001010"	) then -- slti
			reg_write		<= '1';
			reg_dst			<= '0';
			reg_in_src		<= '1';
			alu_src			<= '1';
			add_sub			<= '1';
			data_write		<= '0';
			logic_func		<= "00";
			func			<= "01";
			branch_type		<= "00";
			pc_sel			<= "00";
			
		elsif (op = "001100"	) then -- andi
			reg_write		<= '1';
			reg_dst			<= '0';
			reg_in_src		<= '1';
			alu_src			<= '1';
			add_sub			<= '1';
			data_write		<= '0';
			logic_func		<= "00";
			func			<= "11";
			branch_type		<= "00";
			pc_sel			<= "00";

		elsif (op = "001101"	) then -- ori
			reg_write		<= '1';
			reg_dst			<= '0';
			reg_in_src		<= '1';
			alu_src			<= '1';
			add_sub			<= '1';
			data_write		<= '0';
			logic_func		<= "01";
			func			<= "11";
			branch_type		<= "00";
			pc_sel			<= "00";

		elsif (op = "001110"	) then -- xori
			reg_write		<= '1';
			reg_dst			<= '0';
			reg_in_src		<= '1';
			alu_src			<= '1';
			add_sub			<= '1';
			data_write		<= '0';
			logic_func		<= "10";
			func			<= "11";
			branch_type		<= "00";
			pc_sel			<= "00";			
			
		elsif (op = "100011"	) then -- lw
			reg_write		<= '1';
			reg_dst			<= '0';
			reg_in_src		<= '0';
			alu_src			<= '1';
			add_sub			<= '0';
			data_write		<= '0';
			logic_func		<= "10";
			func			<= "10";
			branch_type		<= "00";
			pc_sel			<= "00";	
			
		elsif (op = "101011"	) then -- sw
			reg_write		<= '0';
			reg_dst			<= '0';
			reg_in_src		<= '0';
			alu_src			<= '1';
			add_sub			<= '0';
			data_write		<= '1';
			logic_func		<= "10";
			func			<= "10";
			branch_type		<= "00";
			pc_sel			<= "00";	
			
		elsif (op = "000010"	) then -- j
			reg_write		<= '0';
			reg_dst			<= '1';
			reg_in_src		<= '1';
			alu_src			<= '1';
			add_sub			<= '0';
			data_write		<= '0';
			logic_func		<= "10";
			func			<= "10";
			branch_type		<= "00";
			pc_sel			<= "01";	

		elsif (op = "000001"	) then -- bltz
			reg_write		<= '0';
			reg_dst			<= '0';
			reg_in_src		<= '0';
			alu_src			<= '0';
			add_sub			<= '0';
			data_write		<= '0';
			logic_func		<= "00";
			func			<= "00";
			branch_type		<= "11";
			pc_sel			<= "00";	

		elsif (op = "000100"	) then -- beq
			reg_write		<= '0';
			reg_dst			<= '0';
			reg_in_src		<= '0';
			alu_src			<= '0';
			add_sub			<= '0';
			data_write		<= '0';
			logic_func		<= "00";
			func			<= "00";
			branch_type		<= "01";
			pc_sel			<= "00";	
			
		elsif (op = "000101"	) then -- bne
			reg_write		<= '0';
			reg_dst			<= '0';
			reg_in_src		<= '0';
			alu_src			<= '0';
			add_sub			<= '0';
			data_write		<= '0';
			logic_func		<= "00";
			func			<= "00";
			branch_type		<= "10";
			pc_sel			<= "00";	

		elsif (op = "000000") then -- R type
			if(funct = "100000") then -- add
				reg_write		<= '1';
				reg_dst			<= '1';
				reg_in_src		<= '1';
				alu_src			<= '0';
				add_sub			<= '0';
				data_write		<= '0';
				logic_func		<= "00";
				func			<= "10";
				branch_type		<= "00";
				pc_sel			<= "00";
			
			elsif(funct = "100010") then -- sub
				reg_write		<= '1';
				reg_dst			<= '1';
				reg_in_src		<= '1';
				alu_src			<= '0';
				add_sub			<= '1';
				data_write		<= '0';
				logic_func		<= "00";
				func			<= "10";
				branch_type		<= "00";
				pc_sel			<= "00";			
			
			elsif(funct = "101010") then -- slt
				reg_write		<= '1';
				reg_dst			<= '1';
				reg_in_src		<= '1';
				alu_src			<= '0';
				add_sub			<= '1';
				data_write		<= '0';
				logic_func		<= "00";
				func			<= "01";
				branch_type		<= "00";
				pc_sel			<= "00";

			elsif(funct = "100100") then -- and
				reg_write		<= '1';
				reg_dst			<= '1';
				reg_in_src		<= '1';
				alu_src			<= '0';
				add_sub			<= '1';
				data_write		<= '0';
				logic_func		<= "00";
				func			<= "11";
				branch_type		<= "00";
				pc_sel			<= "00";

			elsif(funct = "100101") then -- or
				reg_write		<= '1';
				reg_dst			<= '1';
				reg_in_src		<= '1';
				alu_src			<= '0';
				add_sub			<= '1';
				data_write		<= '0';
				logic_func		<= "01";
				func			<= "11";
				branch_type		<= "00";
				pc_sel			<= "00";

			elsif(funct = "100110") then -- xor
				reg_write		<= '1';
				reg_dst			<= '1';
				reg_in_src		<= '1';
				alu_src			<= '0';
				add_sub			<= '1';
				data_write		<= '0';
				logic_func		<= "10";
				func			<= "11";
				branch_type		<= "00";
				pc_sel			<= "00";

			elsif(funct = "100111") then -- nor
				reg_write		<= '1';
				reg_dst			<= '1';
				reg_in_src		<= '1';
				alu_src			<= '0';
				add_sub			<= '1';
				data_write		<= '0';
				logic_func		<= "11";
				func			<= "11";
				branch_type		<= "00";
				pc_sel			<= "00";

			elsif(funct = "001000") then -- jr
				reg_write		<= '0';
				reg_dst			<= '1';
				reg_in_src		<= '1';
				alu_src			<= '1';
				add_sub			<= '0';
				data_write		<= '0';
				logic_func		<= "10";
				func			<= "10";
				branch_type		<= "00";
				pc_sel			<= "10";
				
			else -- set all write control signals to 0 in case of unknown signal
				reg_write		<= '0';
				reg_dst			<= '1';
				reg_in_src		<= '1';
				alu_src			<= '0';
				add_sub			<= '0';
				data_write		<= '0';
				logic_func		<= "00";
				func			<= "00";
				branch_type		<= "00";
				pc_sel			<= "00";			
			
			end if;
		
		else -- set all write control signals to 0 in case of unknown signal
				reg_write		<= '0';
				reg_dst			<= '1';
				reg_in_src		<= '1';
				alu_src			<= '0';
				add_sub			<= '0';
				data_write		<= '0';
				logic_func		<= "00";
				func			<= "00";
				branch_type		<= "00";
				pc_sel			<= "00";
		
		end if;
	end process;
	
	-- pc register
	process(clk,reset)
	begin
		if (reset = '1') then
			pc_out32 <= "00000000000000000000000000000000";
			pc_out5	<= "00000";
			pc_out <= "0000";
		elsif (clk'event and clk = '1') then
			pc_out32 <= pc_in;
			pc_out5 <= pc_in(4 downto 0);
			pc_out <= pc_in(3 downto 0);
		end if;
	end process;	

	-- i-cache
	i_address_in <= pc_out5;
	process(i_address_in)
	begin
		case i_address_in is -- dummy values for testing
			when "00000" => icache_out <= "00100000000000010000000000000001";
			when "00001" => icache_out <= "00100000000000100000000000000010";
			when "00010" => icache_out <= "00000000010000010001000000100000";
			when "00011" => icache_out <= "00001000000000000000000000000010";
			when others  => icache_out <= "00000000000000001111111111111111";
		end case;
	end process;
	
	op		<= icache_out(31 downto 26);
	rs 		<= icache_out(25 downto 21);
	rt 		<= icache_out(20 downto 16);
	rd 		<= icache_out(15 downto 11);
	funct	<= icache_out(5 downto 0);
	immediate	<= icache_out(15 downto 0);
	jump_address <= icache_out(25 downto 0);
	
	-- signals to outputs
	target_address <= jump_address;
	read_a <= rs;
	read_b <= rt;
	
	-- icache to regfile mux
	process(reg_dst,rt,rd)
	begin
		if (reg_dst = '1') then
			reg_dst_out <= rd;
		else
			reg_dst_out <= rt;
		end if;
	end process;
	
	-- sign extend immediate offset
	process(immediate, func)
	begin
		if (func = "00") then -- load upper immediate
			sign_ext_out <= immediate & "0000000000000000";
		elsif (func = "11") then -- slti + arithmetic
			
			if (immediate(15) = '1') then
				sign_ext_out <= "1111111111111111" & immediate;
			else
				sign_ext_out <= "0000000000000000" & immediate;
			end if;
			
		else	-- logical
			sign_ext_out <= "0000000000000000" & immediate;
		end if;
	end process;
	
	-- sign extend / regfile to ALU mux
	process(alu_src,regfile_out_b,sign_ext_out)
	begin
		if (alu_src = '1') then
			alu_src_out <= sign_ext_out;
		else
			alu_src_out <= regfile_out_b;
		end if;
	end process;
	
	-- dcache
	--ALU_result(4 downto 0) <= ALU_result(4 downto 0);
	--d_in <= regfile_out_b;
	
	-- dcache read
		d_out <= 	dcache(0) when (ALU_result(4 downto 0) = "00000") else
			dcache(1) when (ALU_result(4 downto 0) = "00001") else
			dcache(2) when (ALU_result(4 downto 0) = "00010") else
			dcache(3) when (ALU_result(4 downto 0) = "00011") else
			dcache(4) when (ALU_result(4 downto 0) = "00100") else
			dcache(5) when (ALU_result(4 downto 0) = "00101") else
			dcache(6) when (ALU_result(4 downto 0) = "00110") else
			dcache(7) when (ALU_result(4 downto 0) = "00111") else
			dcache(8) when (ALU_result(4 downto 0) = "01000") else
			dcache(9) when (ALU_result(4 downto 0) = "01001") else
			dcache(10) when (ALU_result(4 downto 0) = "01010") else
			dcache(11) when (ALU_result(4 downto 0) = "01011") else
			dcache(12) when (ALU_result(4 downto 0) = "01100") else
			dcache(13) when (ALU_result(4 downto 0) = "01101") else
			dcache(14) when (ALU_result(4 downto 0) = "01110") else
			dcache(15) when (ALU_result(4 downto 0) = "01111") else
			dcache(16) when (ALU_result(4 downto 0) = "10000") else
			dcache(17) when (ALU_result(4 downto 0) = "10001") else
			dcache(18) when (ALU_result(4 downto 0) = "10010") else
			dcache(19) when (ALU_result(4 downto 0) = "10011") else
			dcache(20) when (ALU_result(4 downto 0) = "10100") else
			dcache(21) when (ALU_result(4 downto 0) = "10101") else
			dcache(22) when (ALU_result(4 downto 0) = "10110") else
			dcache(23) when (ALU_result(4 downto 0) = "10111") else
			dcache(24) when (ALU_result(4 downto 0) = "11000") else
			dcache(25) when (ALU_result(4 downto 0) = "11001") else
			dcache(26) when (ALU_result(4 downto 0) = "11010") else
			dcache(27) when (ALU_result(4 downto 0) = "11011") else
			dcache(28) when (ALU_result(4 downto 0) = "11100") else
			dcache(29) when (ALU_result(4 downto 0) = "11101") else
			dcache(30) when (ALU_result(4 downto 0) = "11110") else
			dcache(31);
	
	-- dcache write/reset
	process(clk,reset)
	begin
		if (reset = '1') then
			dcache <= (others=>(others=>'0'));
		elsif (clk'event and clk = '1') then
			if (data_write = '1') then
				if (ALU_result(4 downto 0) = "00000") then
					dcache(0) <= regfile_out_b;
				elsif (ALU_result(4 downto 0) = "00001") then
					dcache(1) <= regfile_out_b;
				elsif (ALU_result(4 downto 0) = "00010") then
					dcache(2) <= regfile_out_b;
				elsif (ALU_result(4 downto 0) = "00011") then
					dcache(3) <= regfile_out_b;
				elsif (ALU_result(4 downto 0) = "00100") then
					dcache(4) <= regfile_out_b;
				elsif (ALU_result(4 downto 0) = "00101") then
					dcache(5) <= regfile_out_b;
				elsif (ALU_result(4 downto 0) = "00110") then
					dcache(6) <= regfile_out_b;
				elsif (ALU_result(4 downto 0) = "00111") then
					dcache(7) <= regfile_out_b;
				elsif (ALU_result(4 downto 0) = "01000") then
					dcache(8) <= regfile_out_b;
				elsif (ALU_result(4 downto 0) = "01001") then
					dcache(9) <= regfile_out_b;
				elsif (ALU_result(4 downto 0) = "01010") then
					dcache(10) <= regfile_out_b;
				elsif (ALU_result(4 downto 0) = "01011") then
					dcache(11) <= regfile_out_b;
				elsif (ALU_result(4 downto 0) = "01100") then
					dcache(12) <= regfile_out_b;
				elsif (ALU_result(4 downto 0) = "01101") then
					dcache(13) <= regfile_out_b;
				elsif (ALU_result(4 downto 0) = "01110") then
					dcache(14) <= regfile_out_b;
				elsif (ALU_result(4 downto 0) = "01111") then
					dcache(15) <= regfile_out_b;
				elsif (ALU_result(4 downto 0) = "10000") then
					dcache(16) <= regfile_out_b;
				elsif (ALU_result(4 downto 0) = "10001") then
					dcache(17) <= regfile_out_b;
				elsif (ALU_result(4 downto 0) = "10010") then
					dcache(18) <= regfile_out_b;
				elsif (ALU_result(4 downto 0) = "10011") then
					dcache(19) <= regfile_out_b;
				elsif (ALU_result(4 downto 0) = "10100") then
					dcache(20) <= regfile_out_b;
				elsif (ALU_result(4 downto 0) = "10101") then
					dcache(21) <= regfile_out_b;
				elsif (ALU_result(4 downto 0) = "10110") then
					dcache(22) <= regfile_out_b;
				elsif (ALU_result(4 downto 0) = "10111") then
					dcache(23) <= regfile_out_b;
				elsif (ALU_result(4 downto 0) = "11000") then
					dcache(24) <= regfile_out_b;
				elsif (ALU_result(4 downto 0) = "11001") then
					dcache(25) <= regfile_out_b;
				elsif (ALU_result(4 downto 0) = "11010") then
					dcache(26) <= regfile_out_b;
				elsif (ALU_result(4 downto 0) = "11011") then
					dcache(27) <= regfile_out_b;
				elsif (ALU_result(4 downto 0) = "11100") then
					dcache(28) <= regfile_out_b;
				elsif (ALU_result(4 downto 0) = "11101") then
					dcache(29) <= regfile_out_b;
				elsif (ALU_result(4 downto 0) = "11110") then
					dcache(30) <= regfile_out_b;
				else
					dcache(31) <= regfile_out_b;
				end if;
			end if;
		end if;
	end process;
	
	-- reg_in_src mux output, goes to d_in of regfile
	process(reg_in_src,d_out,ALU_result)
	begin
		if (reg_in_src = '0') then
			reg_in_src_out <= d_out;
		else
			reg_in_src_out <= ALU_result;
		end if;
	end process;
	
end behav;

library IEEE;
use IEEE.std_logic_1164.all;

entity moore is 
	port(
		input, reset, clk: in std_logic;
		output: out std_logic
	);
end entity moore;

architecture fsm of moore is
	type state_type is (A,B,C);
	signal state: state_type;
	
-- rising edge detector
-- start/reset: state = A, output = 0
-- state = A, when input = 1, go to state = B, output = 1
-- state = B, if input = 1, go to state = C, output = 0
-- 	else if input = 0, go to state = A, output = 0
-- state = C, if input = 0, go to state = A, else stay

	begin
		
		process(reset,clk)
        begin
			if(reset = '1') then
				state <= A;
			elsif(rising_edge(clk)) then
			
			case state is
			
				when A =>
					if(input = '1') then state <= B; 
					end if;
				
				when B =>
					if(input = '1') then state <= C;
					else state <= A;					
					end if;

				when C =>
					if(input = '0') then state <= A;
					end if;			
			
			end case;
            end if;
		end process;

		output <= '1' when state = B else '0';

end fsm;
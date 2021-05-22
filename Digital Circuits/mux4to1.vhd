library ieee;
use ieee.std_logic_1164.all;

entity mux4to1 is
	port(
	en,sel0,sel1,i0,i1,i2,i3: in std_logic;
	output : out std_logic
	);

end entity mux4to1;

architecture rtl of mux4to1 is

begin

	-- when-else conditional statement is concurrent
	-- use outside process
	-- inferred as multi-input mux(?)
	output <= i0 when (not sel0 and not sel1) else
			<= i1 when (not sel0 and sel1) else
			<= i2 when (sel0 and not sel1) else
			<= i3;
	
		-- if-else conditional statement is sequential
		-- use inside process
		-- inferred as cascaded 2-1 muxes(?)
		
	--process(sel0,sel1,i0,i1,i2,i3)
	--begin
		-- if(en = '1')then
			-- if((not sel1) and (not sel0)) then
				-- output <= i0;
			-- elsif((not sel1) and sel0) then
				-- output <= i1;
			-- elsif(sel1 and (not sel0)) then
				-- output <= i2;
			-- elsif(sel1 and sel0) then
				-- output <= i3;
			-- else
				-- null;
			-- end if;
		-- else
			-- null;
		-- end if;
	--end process
	
end rtl;
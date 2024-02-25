library ieee;
use ieee.std_logic_1164.all;

entity diff is
	
	port (
		clk		: in std_logic;
		reset	: in std_logic;
		btn 	: in std_logic;
		edge 	: out std_logic
	);

end diff;

architecture behavioral of diff is

	type state_type is (st_1, st_2, st_3);
	
	signal state_reg, next_state : state_type;

begin

	STATE_TRANSITION : process (clk) is
	begin
		if rising_edge (clk) then
			if reset = '1' then
				state_reg <= st_1;
				
			else
				state_reg <= next_state;
			
			end if;
		end if;
	end process STATE_TRANSITION;
	
	NEXT_STATE_LOGIC : PROcess (state_reg, btn) is
	begin
		case state_reg is
			when st_1 =>
				if btn = '1' then
					next_state <= st_2;
					
				else
					next_state <= st_1;
				
				end if;
				
			when st_2 =>
				if btn = '1' then
					next_state <= st_2;
					
				else
					next_state <= st_3;
				
				end if;
			when st_3 =>
				next_state <= st_1;
				
		end case;
	end process NEXT_STATE_LOGIC;
	
	OUTPUT_LOGIC : process (state_reg) is
	begin
		case state_reg is
			when st_1 =>
				edge <= '0';
				
			when st_2 =>
				edge <= '0';
				
			when st_3 =>
				edge <= '1';
				
		end case;
	end process OUTPUT_LOGIC;

end architecture Behavioral;
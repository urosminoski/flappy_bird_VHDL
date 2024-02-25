library ieee;
use ieee.std_logic_1164.all;

entity pipes_moving is

	generic(
		--Nisam siguran da li sam dobro izracunao opseg
        constant C_PIPE_WIDTH: integer := 64;
		
		C_FIRST_POS : integer range 1023 to  2 * 1024 - (64 + 72):=1024 ; 	-- Initial position of a pipe.
		C_NEXT_POS 	: integer range 1023 to  2 * 1024 - (64 + 72):=1024 ;		-- Position on wich pipe goes after reaching left border of a display.
		
		C_PIPE_VELOCITY	: integer := 1
	);
	port(
		clk65M				: in std_logic;							-- clock 65Mhz
		reset				: in std_logic; 						-- reset
		started				: in std_logic;							-- if game is on or off
		ref_tick			: in std_logic;							-- output of vga_controller
		pipe_xpos			: out integer range - C_PIPE_WIDTH to ( 2 * 1024 - (64 + 72) + C_PIPE_WIDTH )
	);
end pipes_moving;

architecture Behavioral of pipes_moving is
	signal xpos	: integer range -C_PIPE_WIDTH to (2 * 1024 - (64 + 72) + C_PIPE_WIDTH);

begin
	
	-- Update position. If reset is active or game is
	-- not on then the position of the pipe has initial value. 
	-- Otherwise on rising clock edge on the end of the frame if pipe
	-- reached right edge of the display the position of the pipe is set
	-- to be on right edge of the display. If pipe did not reached left edge,
	-- position of the pipe is decremented by defined constant.
MOVING:	process(clk65M, reset, ref_tick, started) is
	begin
		if reset = '1' or started = '0' then
			xpos <= C_FIRST_POS;
		else
			if rising_edge(clk65M) then
				if ref_tick = '1' then
					if xpos < -C_PIPE_WIDTH then
						xpos <= C_NEXT_POS;
					else  
						xpos <= xpos - C_PIPE_VELOCITY;
					end if;
				end if;
			end if;
		end if;
	end process MOVING;
	
	pipe_xpos <= xpos;


end Behavioral;
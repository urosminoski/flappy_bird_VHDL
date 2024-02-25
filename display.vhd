library ieee;
use ieee.std_logic_1164.all;

entity display is
generic (
constant WINDOW_WIDTH: integer := 32;
constant C_PIPE_WIDTH: integer := 64;
constant FLAPPY_SIZE: integer := 32;
H_DISPLAY: integer := 1024;
V_DISPLAY: integer := 768
);

port (

	clk_65M : in std_logic;
	reset : in std_logic;
 
    win_ypos1 : in integer range 32 to 736;
    win_ypos2 : in integer range 32 to 736;
    win_ypos3 : in integer range 32 to 736;
    win_ypos4 : in integer range 32 to 736;
    win_ypos5 : in integer range 32 to 736;
    
    pipe_xpos1: in integer range - C_PIPE_WIDTH to ( 2 * 1024 - (64 + 72) + C_PIPE_WIDTH );
    pipe_xpos2: in integer range - C_PIPE_WIDTH to ( 2 * 1024 - (64 + 72) + C_PIPE_WIDTH );
    pipe_xpos3: in integer range - C_PIPE_WIDTH to ( 2 * 1024 - (64 + 72) + C_PIPE_WIDTH );
    pipe_xpos4: in integer range - C_PIPE_WIDTH to ( 2 * 1024 - (64 + 72) + C_PIPE_WIDTH );
    pipe_xpos5: in integer range - C_PIPE_WIDTH to ( 2 * 1024 - (64 + 72) + C_PIPE_WIDTH );
    
    flappy_ypos: in integer range -FLAPPY_SIZE to (V_DISPLAY + FLAPPY_SIZE);
    
    hpos : in integer range 0 to H_DISPLAY - 1;
    vpos : in integer range 0 to V_DISPLAY - 1;
    
	Rout, Gout, Bout : out std_logic_vector(7 downto 0)
);


end display;

architecture Behavioral of display is


signal color: std_logic_vector(23 downto 0);
signal on_pipe: std_logic_vector(4 downto 0);
signal on_bird: std_logic;
signal pipe_xpos: integer range - C_PIPE_WIDTH to ( 2 * 1024 - (64 + 72) + C_PIPE_WIDTH);

constant BCKG_COLOR : std_logic_vector(23 downto 0) := x"777777";
constant PIPE_COLOR : std_logic_vector(23 downto 0) := x"007700";
constant BIRD_COLOR: std_logic_vector(23 downto 0) := x"777700";

begin


on_pipe(0) <= '1' when ( hpos >= pipe_xpos1 and hpos< pipe_xpos1 + C_PIPE_WIDTH) and (vpos <= win_ypos1 and vpos > win_ypos1 + WINDOW_WIDTH) else '0';
on_pipe(1) <= '1' when ( hpos >= pipe_xpos2 and hpos< pipe_xpos2 + C_PIPE_WIDTH) and (vpos <= win_ypos2 and vpos > win_ypos2 + WINDOW_WIDTH) else '0';
on_pipe(2) <= '1' when ( hpos >= pipe_xpos3 and hpos< pipe_xpos3 + C_PIPE_WIDTH) and (vpos <= win_ypos3 and vpos > win_ypos3 + WINDOW_WIDTH) else '0';
on_pipe(3) <= '1' when ( hpos >= pipe_xpos4 and hpos< pipe_xpos4 + C_PIPE_WIDTH) and (vpos <= win_ypos4 and vpos > win_ypos4 + WINDOW_WIDTH) else '0';
on_pipe(4) <= '1' when ( hpos >= pipe_xpos5 and hpos< pipe_xpos5 + C_PIPE_WIDTH) and (vpos <= win_ypos5 and vpos > win_ypos5 + WINDOW_WIDTH) else '0';

on_bird <= '1' when (vpos >= flappy_ypos and vpos < flappy_ypos + FLAPPY_SIZE) else '0';

COL : process (reset, on_pipe) is

begin

if (reset = '1') then

color <= (others => '0');

else

case on_pipe is

    when "00001" =>
        color <= PIPE_COLOR;
    when "00010" =>
        color <= PIPE_COLOR;
    when "00100" =>
        color <= PIPE_COLOR;
    when "01000" =>
        color <= PIPE_COLOR;
    when "10000" =>
        color <= PIPE_COLOR;
    when others =>   
        if(on_bird = '1') then
            color <= BIRD_COLOR;
        else
            color <= BCKG_COLOR;
        end if;

end case;

end if;

end process COL;

Rout <= color(23 downto 16);
Gout <= color(15 downto 8);
Bout <= color (7 downto 0);

end Behavioral;
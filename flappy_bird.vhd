library ieee;
use ieee.std_logic_1164.all;

entity flappy_bird is

Port (
    
    CLK_50MHz : in  std_logic;
    reset : in std_logic;
    
    -- VGA 
	VGA_CLK : out std_logic;
	VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N : out std_logic;
	VGA_R, VGA_G, VGA_B : out std_logic_vector(7 downto 0)
  );

  
end flappy_bird;


architecture rtl of flappy_bird is

component pll is
	port (
		refclk   : in  std_logic := '0'; --  refclk.clk
		rst      : in  std_logic := '0'; --   reset.reset
		outclk_0 : out std_logic         -- outclk0.clk
	);
    
    
component vga_sync is
generic(
	H_SYNC    : integer := 136;
	H_BP      : integer := 160;
	H_FP      : integer := 24;
	H_DISPLAY : integer := 1024;
	
	V_SYNC    : integer := 6;
	V_BP      : integer := 29;
	V_FP      : integer := 3;
	V_DISPLAY : integer := 768
);
port(
	clk : in std_logic;
	reset : in std_logic;
	hsync, vsync : out std_logic;
	sync_n, blank_n : out std_logic;
	hpos : out integer range 0 to H_DISPLAY - 1;
	vpos : out integer range 0 to V_DISPLAY - 1;
	Rin, Gin, Bin : in std_logic_vector(7 downto 0);
	Rout, Gout, Bout : out std_logic_vector(7 downto 0);
	ref_tick : out std_logic
);
end component;

    



begin





end rtl;
  
  

  
  
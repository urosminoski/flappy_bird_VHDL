library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga_sync is
	generic (
		-- Default display mode is 1024x768@60Hz
		-- Horizontal line
		H_SYNC	: integer := 136;		-- sync pulse in pixels
		H_BP		: integer := 160;		-- back porch in pixels
		H_FP		: integer := 24;		-- front porch in pixels
		H_DISPLAY: integer := 1024;	-- visible pixels
		-- Vertical line
		V_SYNC	: integer := 6;		-- sync pulse in pixels
		V_BP		: integer := 29;		-- back porch in pixels
		V_FP		: integer := 3;		-- front porch in pixels
		V_DISPLAY: integer := 768		-- visible pixels
	);
	port (
		clk : in std_logic;
		reset : in std_logic;
		hsync, vsync : out std_logic;
		sync_n, blank_n : out std_logic;
		hpos : out integer range 0 to H_DISPLAY - 1;
		vpos : out integer range 0 to V_DISPLAY - 1;
		Rin, Gin, Bin : in std_logic_vector(7 downto 0);
		Rout, Gout, Bout : out std_logic_vector(7 downto 0)
	);
end vga_sync;

architecture behavioral of vga_sync is
	constant H_PERIOD : integer := H_SYNC + H_BP + H_DISPLAY + H_FP;
	constant V_PERIOD : integer := V_SYNC + V_BP + V_DISPLAY + V_FP;

	signal h_count : integer range 0 to H_PERIOD - 1;
	signal v_count : integer range 0 to V_PERIOD - 1;
	signal disp_ena : std_logic;

begin

	sync_n <= '0';		-- no sync on green
	blank_n <= '1';	-- no direct blanking
	
	process (clk, reset) is
	begin
		if (reset = '1') then
			h_count <= 0;
			v_count <= 0;
			hsync <= '1';
			vsync <= '1';
			disp_ena <= '0';
			hpos <= 0;
			vpos <= 0;
		elsif (rising_edge(clk)) then
			if (h_count < H_PERIOD - 1) then
				h_count <= h_count + 1;
			else
				h_count <= 0;
				if (v_count < V_PERIOD - 1) then
					v_count <= v_count + 1;
				else
					v_count <= 0;
				end if;
			end if;
			
			-- horizontal sync
			if (h_count < H_DISPLAY + H_FP or h_count > H_DISPLAY + H_FP + H_SYNC) then
				hsync <= '1';
			else
				hsync <= '0';
			end if;
			
			-- vertical sync
			if (v_count < V_DISPLAY + V_FP or v_count > V_DISPLAY + V_FP + V_SYNC) then
				vsync <= '1';
			else
				vsync <= '0';
			end if;
			
			-- set pixel coordinates
			if (h_count < H_DISPLAY) then
				hpos <= h_count;
			end if;
			if (v_count < V_DISPLAY) then
				vpos <= v_count;
			end if;
			
			-- set disp_ena
			if (h_count < H_DISPLAY and v_count < V_DISPLAY) then
				disp_ena <= '1';
			else
				disp_ena <= '0';
			end if;			
		end if;
	end process;
	
	Rout <= Rin when disp_ena = '1' else (others => '0');
	Gout <= Gin when disp_ena = '1' else (others => '0');
	Bout <= Bin when disp_ena = '1' else (others => '0');
	

end behavioral;
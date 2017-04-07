library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vgagenerator is
  port (
	fpga_clk : in std_logic;
	rst : in std_logic;
	HS : out std_logic;
	VS : out std_logic;
	red : out std_logic_vector(2 downto 0);
	green : out std_logic_vector(2 downto 0);
	blue : out std_logic_vector(1 downto 0)) ;
end entity ; -- vgagenerator

architecture behav of  vgagenerator is
	signal pixel_clk : std_logic;
	signal hcount : std_logic_vector(10 downto 0);
	signal vcount : std_logic_vector(10 downto 0);
	signal blank : std_logic;
	signal locked : std_logic;
	signal romAddress :  std_logic_vector(14 downto 0);
	signal romOut : STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	
component display is
  port ( 
    hcount : in  std_logic_vector(10 downto 0);  -- Pixel x coordinate
    vcount : in  std_logic_vector(10 downto 0);  -- Pixel y coordinate
    blank  : in  std_logic;             -- If 1, video output must be null
    red    : out std_logic_vector(2 downto 0);   -- Red color output
    green  : out std_logic_vector(2 downto 0);   -- Green color output
    blue   : out std_logic_vector(1 downto 0));  -- Blue color output
end component;

component dcm is
  port
    (                                   -- Clock in ports
      CLK_IN1  : in  std_logic;
      -- Clock out ports
      CLK_OUT1 : out std_logic;
      -- Status and control signals
      RESET    : in  std_logic;
      LOCKED   : out std_logic
      );
end component;

component vga is
  port (
    pixel_clk : in  std_logic;          -- 40MHz
    rst       : in  std_logic;          -- active low
    hs        : out std_logic;          -- Horizontale synchonization impulsion
    vs        : out std_logic;          -- Vertical synchonization impulsion
    blank     : out std_logic;         -- If 1,  video output must be null
    hcount    : out std_logic_vector(10 downto 0);  -- Pixel x coordinate
    vcount    : out std_logic_vector(10 downto 0));  -- Pixel y coordinate
end component;

COMPONENT rom_map2
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
);
END COMPONENT;


begin



romAddress <= std_logic_vector(to_unsigned(to_integer(unsigned(hcount))+200*to_integer(unsigned(vcount)),15));

rom_map2 : rom_map2
  PORT MAP (
    clka => fpga_clk,
    addra => romAddress,
    douta => romOut
  );

dcm_map : dcm
  port map
   (
    CLK_IN1 => fpga_clk,
    CLK_OUT1 => pixel_clk,
    RESET  => rst,
    LOCKED => LOCKED);

  vga_map: vga
  port map (
    pixel_clk => pixel_clk,
    rst       => rst,
    hs        => hs,
    vs        => vs,
    blank     => blank,
    hcount    => hcount,
    vcount    => vcount);

display_map : display
  port map(
    blank     => blank,
    hcount    => hcount,
    vcount    => vcount,
    red    => red,
    green  => green,
    blue   => blue);

end architecture ; -- arch
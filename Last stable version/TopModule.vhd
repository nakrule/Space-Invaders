library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TopModule is
  port (
    fpga_clk : in  std_logic;
    rst      : in  std_logic;
    HS       : out std_logic;
    VS       : out std_logic;
    red      : out std_logic_vector(2 downto 0);
    green    : out std_logic_vector(2 downto 0);
    blue     : out std_logic_vector(1 downto 0));
end entity;

architecture Behavioral of TopModule is

  signal pixel_clk  : std_logic;
  signal hcount     : std_logic_vector(10 downto 0);
  signal vcount     : std_logic_vector(10 downto 0);
  signal blank      : std_logic;
  signal locked     : std_logic;
  signal romAddress : std_logic_vector(14 downto 0);
  signal rom1Out     : std_logic_vector(7 downto 0);

  component display is
    port(
      blank      : in  std_logic;       -- If 1, video output must be null
      hcount     : in  std_logic_vector(10 downto 0);  -- Pixel x coordinate
      vcount     : in  std_logic_vector(10 downto 0);  -- Pixel y coordinate
      imageInput : in  std_logic_vector(7 downto 0);   -- data from rom
      red        : out std_logic_vector(2 downto 0);   -- Red color output
      green      : out std_logic_vector(2 downto 0);   -- Green color output
      blue       : out std_logic_vector(1 downto 0);   -- Blue color output
		clk        : in  std_logic;
	   reset      : in  std_logic
		);
  end component;

  component dcm is
    port(
        CLK_IN1  : in  std_logic;
        RESET    : in  std_logic;
        CLK_OUT1 : out std_logic;
        LOCKED   : out std_logic);
  end component;

  component vga_internal is
    port(
      pixel_clk : in  std_logic;        -- 40MHz
      rst       : in  std_logic;        -- active low
      hs        : out std_logic;        -- Horizontale synchonization impulsion
      vs        : out std_logic;        -- Vertical synchonization impulsion
      blank     : out std_logic;        -- If 1,  video output must be null
      hcount    : out std_logic_vector(10 downto 0);   -- Pixel x coordinate
      vcount    : out std_logic_vector(10 downto 0));  -- Pixel y coordinate
  end component;
  
  component StartScreenRom
    port(
      clka  : in  std_logic;
      addra : in  std_logic_vector(14 downto 0);
      douta : out std_logic_vector(7 downto 0)
      );
  end component;

begin

  -- Convert hcount and vcount in an address usable by a ROM block.
  romAddress <= std_logic_vector(to_unsigned((150*(to_integer(unsigned(hcount))/4)) + (to_integer(unsigned(vcount))/4), 15));

  StartScreenRom_map : StartScreenRom
    port map(
      clka  => pixel_clk,
      addra => romAddress,
      douta => rom1Out
      );

  

  DCM_map : DCM
    port map(
      CLK_IN1  => fpga_clk,
      CLK_OUT1 => pixel_clk,
      RESET    => rst,
      LOCKED   => LOCKED
      );

  VGA : VGA_Internal
    port map(
      pixel_clk => pixel_clk,
      rst       => rst,
      hs        => hs,
      vs        => vs,
      blank     => blank,
      hcount    => hcount,
      vcount    => vcount
      );

  Display_Map : Display
    port map(
      blank      => blank,
      hcount     => hcount,
      vcount     => vcount,
      red        => red,
      green      => green,
      imageInput => rom1Out,
      blue       => blue,
		clk        => pixel_clk,
	   reset      => rst
      );
		


end architecture;

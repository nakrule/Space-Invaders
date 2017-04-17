----------------------------------------------------------------------------------
-- Company:         HES-SO
-- Engineer:        Samuel Riedo & Pascal Roulin
-- Create Date:     1/03/2017
-- Design Name:     TopModule.vhd
-- Project Name:    Space Invaders - FPGA Edition
-- Target Devices:  Digilent NEXYS 3 (Xilinx Spartan 6 XC6LX16-CS324)
-- Description:     Project top module
-- Revision 0.01 -  File Created
--          1.00 -  VGA_internal, Display, DCM and StartScreenROM added
--          1.1  -  Ship and aliens movements implemented
--          1.2  -  Inputs added
----------------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TopModule is
  port(
    fpga_clk : in  std_logic;           -- 100MHz
    rst      : in  std_logic;           -- Active high
    startButton     : in  std_logic;    -- Start button
	 fire     : in  std_logic;           -- Fire button
    right    : in  std_logic;           -- Right arrow button
    left     : in  std_logic;           -- Left arrow button
    HS       : out std_logic;           -- VGA horizontal synchronization
    VS       : out std_logic;           -- VGA vertical synchronization
    red      : out std_logic_vector(2 downto 0);  -- VGA red bus
    green    : out std_logic_vector(2 downto 0);  -- VGA green bus
    blue     : out std_logic_vector(1 downto 0)   -- VGA blue bus
    );
end entity;

architecture Behavioral of TopModule is

  signal pixel_clk         : std_logic;  -- 40MHz clock
  signal blank             : std_logic;  -- When 1, VGA color outputs must be 0
  signal locked            : std_logic;  -- Unused
  signal gameStarted       : std_logic;  -- When 0, show start screen
  signal newMissile        : std_logic;  -- When 1, new missile launched
  signal rocketOnScreen    : std_logic;		-- If 1, display a rocket
  signal startScreenROMOut : std_logic_vector(7 downto 0);  -- Used as ImageInput in display
  signal alienY            : std_logic_vector(8 downto 0);  -- first alien position from top screen
  signal shipPosition      : std_logic_vector(9 downto 0);  -- From left screen
  signal alienX            : std_logic_vector(9 downto 0);  -- first alien position from left screen
  signal missileY          : std_logic_vector(9 downto 0);    -- Pixels between top screen and top missile position
  signal hcount            : std_logic_vector(10 downto 0);  -- VGA horizontal synchronization
  signal vcount            : std_logic_vector(10 downto 0);  -- VGA vertical synchronization
  signal romAddress        : std_logic_vector(14 downto 0);  -- Combination of hcount and vcount
  signal MissileX          : std_logic_vector(9 downto 0);   -- Missile x coordinate
  

  component display is
    port(
      blank        : in  std_logic;     -- If 1, video output must be null
      gameStarted  : in  std_logic;     -- When 0, show start screen
		rocketOnScreen : in std_logic;		-- If 1, display a rocket
		missileY : in std_logic_vector(9 downto 0); -- Pixels between top screen and top missile position
      shipPosition : in  std_logic_vector(9 downto 0);  -- Ship x coordinate
		MissileX     : in std_logic_vector(9 downto 0);   -- Missile x coordinate
      hcount       : in  std_logic_vector(10 downto 0);  -- Pixel x coordinate
      vcount       : in  std_logic_vector(10 downto 0);  -- Pixel y coordinate
      imageInput   : in  std_logic_vector(7 downto 0);  -- data from rom
      alienX       : in  std_logic_vector(9 downto 0);  -- first alien position from left screen
      alienY       : in  std_logic_vector(8 downto 0);  -- first alien position from top screen
      red          : out std_logic_vector(2 downto 0);  -- Red color output
      green        : out std_logic_vector(2 downto 0);  -- Green color output
      blue         : out std_logic_vector(1 downto 0)   -- Blue color output
      );
  end component;

  component dcm is
    port(
      CLK_IN1  : in  std_logic;         -- 100MHz
      RESET    : in  std_logic;         -- Active high
      CLK_OUT1 : out std_logic;         -- 40MHz
      LOCKED   : out std_logic          -- Unused
      );
  end component;

  component vga_internal is
    port(
      pixel_clk : in  std_logic;        -- 40MHz
      rst       : in  std_logic;        -- active low
      hs        : out std_logic;        -- Horizontale synchonization impulsion
      vs        : out std_logic;        -- Vertical synchonization impulsion
      blank     : out std_logic;        -- If 1,  video output must be null
      hcount    : out std_logic_vector(10 downto 0);  -- Pixel x coordinate
      vcount    : out std_logic_vector(10 downto 0)   -- Pixel y coordinate
      );
  end component;

  component StartScreenRom
    port(
      clka  : in  std_logic;            -- 40MHz
      addra : in  std_logic_vector(14 downto 0);  -- Combinaison of hcount and vcount
      douta : out std_logic_vector(7 downto 0)    -- ROM output
      );
  end component;

  component Input is
    port(
      startButton  : in  std_logic;       -- When 1, start game
		fire         : in  std_logic;       -- When 1, shoot a rocket
      clk          : in  std_logic;     -- 40MHz
      fastCLK      : in  std_logic;     -- 100MHz clock for random counter
      reset        : in  std_logic;     -- Active high
      left         : in  std_logic;     -- Left arrow button
      right        : in  std_logic;     -- Right arrow button
		newMissile   : out std_logic;     -- If 1, new missile launched
      gameStarted  : out std_logic;     -- When 0, show start screen
      alienX       : out std_logic_vector(9 downto 0);  -- first alien position from left screen
      alienY       : out std_logic_vector(8 downto 0);  -- first alien position from top screen
      shipPosition : out std_logic_vector(9 downto 0)   -- Ship x coordinate
      );
  end component;
  
  component rocketManager is
	port(
		newMissile : in std_logic;				-- If 1, new missile launched
		reset : in std_logic;					-- Active high
		clk : in std_logic;						-- 40MHz
		shipPosition : in  std_logic_vector(9 downto 0);  -- Ship x coordinate
		rocketOnScreen : out std_logic;		-- If 1, display a rocket
		missileY : out std_logic_vector(9 downto 0); -- Pixels between top screen and top missile position
		MissileX     : out std_logic_vector(9 downto 0)   -- Missile x coordinate
	);
end component;

begin

  -- Convert hcount and vcount in an address usable by a ROM block.
  romAddress <= std_logic_vector(to_unsigned((150*(to_integer(unsigned(hcount))/4)) + (to_integer(unsigned(vcount))/4), 15));

  StartScreenRom_map : StartScreenRom
    port map(
      clka  => pixel_clk,
      addra => romAddress,
      douta => startScreenROMOut
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
      blank        => blank,
      gameStarted  => gameStarted,
		rocketOnScreen => rocketOnScreen,
		missileY => missileY,
      hcount       => hcount,
      vcount       => vcount,
		MissileX => MissileX,
      shipPosition => shipPosition,
      alienX       => alienX,
      alienY       => alienY,
      red          => red,
      green        => green,
      imageInput   => startScreenROMOut,
      blue         => blue
      );

  Input_Map : Input
    port map(
      startButton         => startButton,
		fire => 		fire,
      clk          => pixel_clk,
      fastCLK      => pixel_clk,
      reset        => rst,
      right        => right,
      left         => left,
		newMissile   => newMissile,
      shipPosition => shipPosition,
      gameStarted  => gameStarted,
      alienX       => alienX,
      alienY       => alienY
      );
		
	rocketManager_Map : rocketManager
	port map(
		newMissile => newMissile,
		reset => rst,
		clk => pixel_clk,
		shipPosition => shipPosition,
		rocketOnScreen => rocketOnScreen,
		missileY => missileY,
		MissileX => missileX
	);

end architecture;

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
--          1.3  -  Display now have a clk
--          1.4  -  Add alienRocket
----------------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TopModule is
  port(
    fpga_clk    : in  std_logic;        -- 100MHz
    rst         : in  std_logic;        -- Active high
    startButton : in  std_logic;        -- Start button
    fire        : in  std_logic;        -- Fire button
    right       : in  std_logic;        -- Right arrow button
    left        : in  std_logic;        -- Left arrow button
    HS          : out std_logic;        -- VGA horizontal synchronization
    VS          : out std_logic;        -- VGA vertical synchronization
    red         : out std_logic_vector(2 downto 0);  -- VGA red bus
    green       : out std_logic_vector(2 downto 0);  -- VGA green bus
    blue        : out std_logic_vector(1 downto 0)   -- VGA blue bus
    );
end entity;

architecture Behavioral of TopModule is

  signal pixel_clk         : std_logic;  -- 40MHz clock
  signal blank             : std_logic;  -- When 1, VGA color outputs must be 0
  signal locked            : std_logic;  -- Unused
  signal gameStarted       : std_logic;  -- When 0, show start screen
  signal newMissile        : std_logic;  -- When 1, new missile launched
  signal rocketOnScreen    : std_logic;  -- If 1, display a rocket
  signal alienKilled       : std_logic;  -- If 1, the rocket killed an alien
  signal startScreenROMOut : std_logic_vector(7 downto 0);  -- Used as ImageInput in display
  signal alienY            : std_logic_vector(8 downto 0);  -- first alien position from top screen
  signal shipPosition      : std_logic_vector(9 downto 0);  -- From left screen
  signal alienX            : std_logic_vector(9 downto 0);  -- first alien position from left screen
  signal missileY          : std_logic_vector(9 downto 0);  -- Pixels between top screen and top missile position
  signal hcount            : std_logic_vector(10 downto 0);  -- VGA horizontal synchronization
  signal vcount            : std_logic_vector(10 downto 0);  -- VGA vertical synchronization
  signal romAddress        : std_logic_vector(14 downto 0);  -- Combination of hcount and vcount
  signal MissileX          : std_logic_vector(9 downto 0);  -- Missile x coordinate
  signal alienRocketx      : std_logic_vector(9 downto 0);  -- Alien rocket x position
  signal alienRockety      : std_logic_vector(9 downto 0);  -- Alien rocket y position
  signal alienL1           : std_logic_vector(0 to 9);  -- Same value as alienLine2
  signal alienL2           : std_logic_vector(0 to 9);  -- Same value as alienLine2
  signal alienL3           : std_logic_vector(0 to 9);  -- Same value as alienLine3
  signal alienL4           : std_logic_vector(0 to 9);  -- Same value as alienLine4
  signal alienL5           : std_logic_vector(0 to 9);  -- Same value as alienLine5

  component display is
    port(
      blank          : in  std_logic;   -- If 1, video output must be null
      gameStarted    : in  std_logic;   -- When 0, show start screen
      rocketOnScreen : in  std_logic;   -- If 1, display a rocket
      clk            : in  std_logic;   -- 40MHz
      alienRocketx   : in  std_logic_vector(9 downto 0);  -- Alien rocket x position
      alienRockety   : in  std_logic_vector(9 downto 0);  -- Alien rocket y position
      missileY       : in  std_logic_vector(9 downto 0);  -- Pixels between top screen and top missile position
      shipPosition   : in  std_logic_vector(9 downto 0);  -- Ship x coordinate
      MissileX       : in  std_logic_vector(9 downto 0);  -- Missile x coordinate
      hcount         : in  std_logic_vector(10 downto 0);  -- Pixel x coordinate
      vcount         : in  std_logic_vector(10 downto 0);  -- Pixel y coordinate
      imageInput     : in  std_logic_vector(7 downto 0);  -- data from rom
      alienX         : in  std_logic_vector(9 downto 0);  -- first alien position from left screen
      alienY         : in  std_logic_vector(8 downto 0);  -- first alien position from top screen
      alienKilled    : out std_logic;   -- 1 if alien killed
      red            : out std_logic_vector(2 downto 0);  -- Red color output
      green          : out std_logic_vector(2 downto 0);  -- Green color output
      blue           : out std_logic_vector(1 downto 0);  -- Blue color output
      alienL1        : out std_logic_vector(0 to 9);  -- Same value as alienLine1
      alienL2        : out std_logic_vector(0 to 9);  -- Same value as alienLine2
      alienL3        : out std_logic_vector(0 to 9);  -- Same value as alienLine3
      alienL4        : out std_logic_vector(0 to 9);  -- Same value as alienLine4
      alienL5        : out std_logic_vector(0 to 9)  -- Same value as alienLine5
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
      startButton  : in  std_logic;     -- When 1, start game
      fire         : in  std_logic;     -- When 1, shoot a rocket
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
      newMissile     : in  std_logic;   -- If 1, new missile launched
      reset          : in  std_logic;   -- Active high
      clk            : in  std_logic;   -- 40MHz
      alienKilled    : in  std_logic;   -- 1 if alien killed
      shipPosition   : in  std_logic_vector(9 downto 0);  -- Ship x coordinate
      rocketOnScreen : out std_logic;   -- If 1, display a rocket
      missileY       : out std_logic_vector(9 downto 0);  -- Pixels between top screen and top missile position
      MissileX       : out std_logic_vector(9 downto 0)  -- Missile x coordinate
      );
  end component;

  component alienRocket is
    port(
      reset        : in  std_logic;       -- Active high
      clk          : in  std_logic;       -- 40MHz
      alienLine1   : in  std_logic_vector(0 to 9);  -- Top screen alien line
      alienLine2   : in  std_logic_vector(0 to 9);
      alienLine3   : in  std_logic_vector(0 to 9);
      alienLine4   : in  std_logic_vector(0 to 9);
      alienLine5   : in  std_logic_vector(0 to 9);  -- Bottom screen alien line
      shipPosition : in  std_logic_vector(9 downto 0);  -- Ship x coordinate, only used to generate random
      alienX       : in  std_logic_vector(9 downto 0);  -- first alien position from left screen
      alienY       : in  std_logic_vector(8 downto 0);  -- first alien position from top screen
      alienRocketx : out std_logic_vector(9 downto 0);  -- Alien rocket x coordinate from left screen
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
      blank          => blank,
      gameStarted    => gameStarted,
      rocketOnScreen => rocketOnScreen,
      clk            => pixel_clk,
      missileY       => missileY,
      hcount         => hcount,
      vcount         => vcount,
      alienRocketx   => alienRocketx,
      alienRockety   => alienRockety,
      alienKilled    => alienKilled,
      MissileX       => MissileX,
      shipPosition   => shipPosition,
      alienX         => alienX,
      alienY         => alienY,
      red            => red,
      green          => green,
      imageInput     => startScreenROMOut,
      blue           => blue,
      alienL1        => alienL1,
      alienL2        => alienL2,
      alienL3        => alienL3,
      alienL4        => alienL4,
      alienL5        => alienL5
      );

  Input_Map : Input
    port map(
      startButton  => startButton,
      fire         => fire,
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
      newMissile     => newMissile,
      reset          => rst,
      clk            => pixel_clk,
      shipPosition   => shipPosition,
      rocketOnScreen => rocketOnScreen,
      alienKilled    => alienKilled,
      missileY       => missileY,
      MissileX       => missileX
      );

  alienRocketMap : alienRocket
    port map(
      reset        => rst,
      clk          => pixel_clk,
      alienLine1   => alienL1,
      alienLine2   => alienL2,
      alienLine3   => alienL3,
      alienLine4   => alienL4,
      alienLine5   => alienL5,
      shipPosition => shipPosition,
      alienX       => alienX,
      alienY       => alienY,
      alienRocketx => alienRocketx,
      alienRockety => alienRockety
      );

end architecture;

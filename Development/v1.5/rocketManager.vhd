----------------------------------------------------------------------------------
-- Company:         HES-SO
-- Engineer:        Samuel Riedo & Pascal Roulin
-- Create Date:     13/04/2017
-- Design Name:     rocketManager.vhd
-- Project Name:    Space Invaders - FPGA Edition
-- Target Devices:  Digilent NEXYS 3 (Xilinx Spartan 6 XC6LX16-CS324)
-- Description:     Manage rocket shoot by the ship
-- Revision 0.01 -  File Created
--          1.00 -  Fire, left and write implemented
--          1.1  -  Ship and aliens movements implemented
--          1.2  -  Ship rocket implemented
--          1.3  -  Rocket can be stopped by Display when an alien is killed
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.SpaceInvadersPackage.all;

entity rocketManager is
  port(
    newMissile     : in  std_logic;                     -- If 1, new missile launched
    reset          : in  std_logic;                     -- Active high
    clk            : in  std_logic;                     -- 40MHz
    alienKilled    : in  std_logic;                     -- 1 if alien killed
    shipPosition   : in  std_logic_vector(9 downto 0);  -- Ship x coordinate
    rocketOnScreen : out std_logic;                     -- If 1, display a rocket
    missileY       : out std_logic_vector(9 downto 0);  -- Pixels between top screen and top missile position
    MissileX       : out std_logic_vector(9 downto 0)   -- Missile x coordinate
    );
end rocketManager;

architecture Behavioral of rocketManager is

  signal rocketDisplayed : std_logic;                       -- Integer of rocketOnScreen
  signal rocketY         : integer range 0 to (VLINES-30);  -- Pixels between top screen and top missile
  signal missileTimer    : integer range 0 to missileSpeed; -- Slow down fire rate
  signal shootFinished   : integer range 0 to 1;            -- If 1, current missile is off screen
  signal MissileXX       : integer range shipMargin to (HLINES-shipMargin) := shipMargin;  -- Missile x value 
                                                                                           -- from left screen

begin

  rocketOnScreen <= rocketDisplayed;
  missileY       <= std_logic_vector(to_unsigned(rocketY, 10));
  MissileX       <= std_logic_vector(to_unsigned(MissileXX, 10));

  -- Update rocketY
  process(reset, clk, alienKilled)
  begin
    if reset = '1' or alienKilled = '1' then
      missileTimer <= 0;
      rocketY      <= 0;
      MissileXX    <= shipMargin;
    elsif rising_edge(clk) then
      if rocketDisplayed = '1' then
        if rocketY = 0 then
          rocketY   <= (VLINES-30);
          MissileXX <= (to_integer(unsigned(shipPosition))+31);
        end if;
        if missileTimer = missileSpeed then
          missileTimer <= 0;
          rocketY      <= rocketY - 1;
          MissileXX    <= MissileXX;
        else
          missileTimer <= missileTimer + 1;
        end if;
      else
        rocketY   <= 0;
        MissileXX <= shipMargin;
      end if;
    end if;
  end process;

  -- Update rocketDisplayed
  process(newMissile, shootFinished)
  begin
    rocketDisplayed <= '0';
    if newMissile = '1' then
      rocketDisplayed <= '1';
    elsif shootFinished = 0 then
      rocketDisplayed <= '1';
    end if;
  end process;

  -- Update shootFinished
  process(rocketY, shootFinished)
  begin
    if rocketY = 0 then
      shootFinished <= 1;
    else
      shootFinished <= 0;
    end if;
  end process;

end Behavioral;


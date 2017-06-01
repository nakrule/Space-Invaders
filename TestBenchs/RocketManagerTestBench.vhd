----------------------------------------------------------------------------------
-- Company:         HES-SO
-- Engineer:        Samuel Riedo & Pascal Roulin
-- Create Date:     18/05/2017
-- Design Name:     RocketManagerTestBench.vhd
-- Project Name:    Space Invaders - FPGA Edition
-- Target Devices:  Digilent NEXYS 3 (Xilinx Spartan 6 XC6LX16-CS324)
-- Description:     Test RocketManager.vhd fonctionnalities
-- Revision 0.01 -  File Created
--          1.00 -  All fonctionnalities tested.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity rocketManager_tb is
end;

architecture bench of rocketManager_tb is

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

  signal newMissile     : std_logic;
  signal reset          : std_logic;
  signal clk            : std_logic;
  signal alienKilled    : std_logic;
  signal shipPosition   : std_logic_vector(9 downto 0);
  signal rocketOnScreen : std_logic;
  signal missileY       : std_logic_vector(9 downto 0);
  signal MissileX       : std_logic_vector(9 downto 0);

  constant clock_period    : time    := 25 ns;
  constant stop_simulation : boolean := false;

begin

  uut : rocketManager port map (
    newMissile     => newMissile,
    reset          => reset,
    clk            => clk,
    alienKilled    => alienKilled,
    shipPosition   => shipPosition,
    rocketOnScreen => rocketOnScreen,
    missileY       => missileY,
    MissileX       => MissileX);

  clocking : process
  begin
    while not stop_simulation loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

  stimulis : process
  begin
    report "Simulation start.";
    reset        <= '1';
    newMissile   <= '0';
    alienKilled  <= '0';
    shipPosition <= "0100000000";
    wait for clock_period;

    assert (missileY = "0000000000") report "missileY uninitialized to 0 after reset." severity error;
    assert (MissileX = "0000110010") report "missileX uninitialized to 50 after reset." severity error;
    assert (rocketOnScreen = '0') report "rocketOnScreen uninitialized to 0 after reset." severity error;
    reset <= '0';
    newMissile   <= '1';
    shipPosition <= "0111000000";
    wait for clock_period;

    assert (rocketOnScreen = '1') report "rocketOnScreen didn't change to 1 when newMissile = 1." severity error;
    newMissile <= '0';
    wait for clock_period;

    assert (rocketOnScreen = '1') report "rocketOnScreen not = 1 after launch." severity error;
    assert (MissileY = "1000111010") report "missileY value incorrect, not = 570." severity error;
    alienKilled <= '1';
    wait for clock_period;

    assert (missileY = "0000000000") report "missileY uninitialized to 0 after alien killed." severity error;
    assert (MissileX = "0000110010") report "missileX uninitialized to 50 after alien killed." severity error;
    assert (rocketOnScreen = '0') report "rocketOnScreen uninitialized to 0 after alien killed." severity error;

  end process;

end;

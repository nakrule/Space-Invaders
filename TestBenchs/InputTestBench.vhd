----------------------------------------------------------------------------------
-- Company:         HES-SO
-- Engineer:        Samuel Riedo & Pascal Roulin
-- Create Date:     18/05/2017
-- Design Name:     InputTestBench.vhd
-- Project Name:    Space Invaders - FPGA Edition
-- Target Devices:  Digilent NEXYS 3 (Xilinx Spartan 6 XC6LX16-CS324)
-- Description:     Test Input.vhd fonctionnalities
-- Revision 0.01 -  File Created
--          1.00 -  All fonctionnalities tested.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity Input_tb is
end;

architecture bench of Input_tb is

  component Input
    port(
      startButton  : in  std_logic;
      fire         : in  std_logic;
      clk          : in  std_logic;
      reset        : in  std_logic;
      left         : in  std_logic;
      right        : in  std_logic;
      newMissile   : out std_logic;
      gameStarted  : out std_logic;
      alienX       : out std_logic_vector(9 downto 0);
      alienY       : out std_logic_vector(8 downto 0);
      shipPosition : out std_logic_vector(9 downto 0)
      );
  end component;

  signal startButton  : std_logic;
  signal fire         : std_logic;
  signal clk          : std_logic;
  signal reset        : std_logic;
  signal left         : std_logic;
  signal right        : std_logic;
  signal newMissile   : std_logic;
  signal gameStarted  : std_logic;
  signal alienX       : std_logic_vector(9 downto 0);
  signal alienY       : std_logic_vector(8 downto 0);
  signal shipPosition : std_logic_vector(9 downto 0);

  constant clock_period : time := 25 ns;
  constant stop_simulation: boolean := False;

begin

  uut : Input port map (startButton  => startButton,
                        fire         => fire,
                        clk          => clk,
                        reset        => reset,
                        left         => left,
                        right        => right,
                        newMissile   => newMissile,
                        gameStarted  => gameStarted,
                        alienX       => alienX,
                        alienY       => alienY,
                        shipPosition => shipPosition);

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
    reset <= '1';
    startButton <= '0';
    fire <= '0';
    left <= '0';
    right <= '0';
    wait for 5 ns;

    reset <= '0';
    assert (gameStarted = '0') report "gameStarted uninitialized to 0 after reset." severity ERROR;
    assert (newMissile = '0') report "newMissile uninitialized to 0 after reset." severity ERROR;
    assert (alienX = "11111010") report "alienX uninitialized to 250 after reset." severity ERROR;
    assert (alienY = "1100100") report "alienY uninitialized to 100 after reset." severity ERROR;
    assert (shipPosition = "0101110000") report "shipPosition uninitialized to 386 after reset." severity ERROR;
    wait for clock_period;

    startButton <= '1';
    wait for clock_period;
    assert (gameStarted = '1') report "Game didn't start after pressing startButton" severity ERROR;
    left <= '1';
    wait for clock_period;

    assert (shipPosition = "0101110001") report "Ship didn't moved to the left when pressing left arrow." severity ERROR;
    left <= '0';
    right <= '1';
    wait for clock_period;

    assert (shipPosition = "0101110000") report "Ship didn't moved to the right when pressing right arrow." severity ERROR;
    right <= '0';
    fire <= '1';
    wait for clock_period;

    assert (newMissile = '1') report "Ship didn't shoot to a new missile when pressing fire." severity ERROR;

  end process;

end;

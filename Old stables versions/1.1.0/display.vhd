----------------------------------------------------------------------------------
-- Company: HES-SO
-- Engineer: Samuel Riedo & Pascal Roulin
-- Create Date:    09:20:02 03/02/2017
-- Design Name:    display.vhd
-- Module Name:    display - Behavioral
-- Project Name: Super Mario World - FPGA Edition
-- Target Devices: Digilent NEXYS 3 (Xilinx Spartan 6 XC6LX16-CS324)
-- Description: Display pixel at vga coordinates
-- Revision 0.01 - File Created
--          1.00 - First functionnal version
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.marioPackage.all;

entity display is
  port (
    hcount : in  std_logic_vector(10 downto 0);  -- Pixel x coordinate
    vcount : in  std_logic_vector(10 downto 0);  -- Pixel y coordinate
    blank  : in  std_logic;             -- If 1, video output must be null
    red    : out std_logic_vector(2 downto 0);   -- Red color output
    green  : out std_logic_vector(2 downto 0);   -- Green color output
    blue   : out std_logic_vector(1 downto 0);  -- Blue color output
	 ImageInput : in std_logic_vector(7 downto 0));
end entity display;

architecture logic of display is

  signal color : std_logic_vector(7 downto 0);  -- Color output
  signal vcounter : integer range 0 to VMAX;
  signal hcounter : integer range 0 to HMAX;

begin

	vcounter <= to_integer(unsigned(vcount));
	hcounter <= to_integer(unsigned(hcount));
	
  red   <= color(7 downto 5) when blank = '0' else "000";
  green <= color(4 downto 2) when blank = '0' else "000";
  blue  <= color(1 downto 0) when blank = '0' else "00";



  process(hcounter, vcounter)

  begin
		--if (hcounter<299 and vcounter <299) then
			color <= ImageInput;
			-- color <= std_logic_vector(to_unsigned(16#e0#,8));
		--else
		 --color <= "00011000";
		--end if;
  end process;
end architecture;

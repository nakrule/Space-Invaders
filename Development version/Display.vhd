----------------------------------------------------------------------------------
-- Company:        HES-SO
-- Engineer:       Samuel Riedo & Pascal Roulin
-- Create Date:    09:20:02 03/02/2017
-- Design Name:    Display.vhd
-- Project Name:   Super Mario World - FPGA Edition
-- Target Devices: Digilent NEXYS 3 (Xilinx Spartan 6 XC6LX16-CS324)
-- Description:    Display pixel at vga coordinates using ROM data
-- Revision 0.01 - File Created
--          1.00 - First functionnal version
--          1.01 - Work with using ROM data input
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.SpaceInvadersPackage.all;

entity Display is
  port(
    blank      : in  std_logic;         -- If 1, video output must be null
    hcount     : in  std_logic_vector(10 downto 0);  -- Pixel x coordinate
    vcount     : in  std_logic_vector(10 downto 0);  -- Pixel y coordinate
    ImageInput : in  std_logic_vector(7 downto 0);   -- ROM data input
	 clk        : in  std_logic;                      -- 40MHz
	 reset      : in  std_logic;                      -- Active high
    red        : out std_logic_vector(2 downto 0);   -- Red color output
    green      : out std_logic_vector(2 downto 0);   -- Green color output
    blue       : out std_logic_vector(1 downto 0));  -- Blue color output

end entity Display;

architecture logic of Display is

  signal color : std_logic_vector(7 downto 0);  -- Color output
  signal hcounter : integer range 0 to 2047;
  signal vcounter : integer range 0 to 2047;

begin

	hcounter <= to_integer(unsigned(hcount));
	vcounter <= to_integer(unsigned(vcount));

  -- Outputs must be 0 is blank = 0, this happen
  -- when hcount and vcount are higher than 800x600.
  red   <= color(7 downto 5) when blank = '0' else "000";
  green <= color(4 downto 2) when blank = '0' else "000";
  blue  <= color(1 downto 0) when blank = '0' else "00";
  
  
	--process(hcounter, vcounter, ImageInput)
	--begin
	  --if hcounter <800 and vcounter < 600 then
	  --color <= "11100000";
			color <= ImageInput;                   -- Read background from ROM
		--else
			--color <= "00000000";
	  --end if;
  --end process;
  
  
  
end architecture;

----------------------------------------------------------------------------------
-- Company:         HES-SO
-- Engineer:        Samuel Riedo & Pascal Roulin
-- Create Date:     09:20:02 03/02/2017
-- Design Name:     Display.vhd
-- Project Name:    Space Invaders - FPGA Edition
-- Target Devices:  Digilent NEXYS 3 (Xilinx Spartan 6 XC6LX16-CS324)
-- Description:     Display pixel at vga coordinates using ROM data and package tables
-- Revision 0.01 -  File Created
--          1.00 -  First functionnal version, display a ship at the bottom of the screen
--          1.1  -  Ship can be moved using arrows buttons, display start screen 
--                  before playing
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.SpaceInvadersPackage.all;

entity Display is
  port(
      blank      : in  std_logic;       -- If 1, video output must be null
		gameStarted : in std_logic; -- When 0, show start screen
		shipPosition : in  std_logic_vector(9 downto 0);  -- Ship x coordinate
      hcount     : in  std_logic_vector(10 downto 0);  -- Pixel x coordinate
      vcount     : in  std_logic_vector(10 downto 0);  -- Pixel y coordinate
      imageInput : in  std_logic_vector(7 downto 0);   -- data from rom
      red        : out std_logic_vector(2 downto 0);   -- Red color output
      green      : out std_logic_vector(2 downto 0);   -- Green color output
      blue       : out std_logic_vector(1 downto 0)    -- Blue color output
      );
end entity Display;

architecture logic of Display is

  signal color        : std_logic_vector(7 downto 0);  -- Color output
  signal hcounter     : integer range 0 to 2047;  -- Integer value of hcount
  signal vcounter     : integer range 0 to 2047;  -- Integer value of vcount
  signal shipPos : integer range 0 to maxShipPosValue;   -- x position of the ship
  signal alienX : integer range 0 to 1000 := 250;   -- pixel between left screen and first alien
  signal alienY : integer range 0 to 1000 := 100;   -- pixel between up screen and first alien
  signal alienTableX : integer range 0 to 9; -- x index in alien array
  signal alienTableY : integer range 0 to 4; -- y index in alien array
  signal alienType : integer range 0 to 10; -- alien race in current table index
  signal alien_s: std_logic_vector(3 downto 0);
  
  type aliensArray is array(9 downto 0, 4 downto 0) of integer range 0 to 10;
  signal aliens : aliensArray := (others => (others => 1)); -- Initialized to 0

begin

  hcounter <= to_integer(unsigned(hcount));
  vcounter <= to_integer(unsigned(vcount));
  shipPos <= to_integer(unsigned(shipPosition));
  alienTableX <= ((hcounter-alienX)/30);
  alienTableY <= ((hcounter-alienY)/30);
  alienType <= aliens(alienTableX, alienTableY);

  -- Outputs must be 0 is blank = 0, this happen
  -- when hcount and vcount are higher than 800x600.
  red   <= color(7 downto 5) when blank = '0' else "000";
  green <= color(4 downto 2) when blank = '0' else "000";
  blue  <= color(1 downto 0) when blank = '0' else "00";

  alien_s <= "0000" when alienType = 0 else
				 "0001" when alienType = 1 else
				 "0010" when alienType = 2 else
				 "0011" when alienType = 3 else
				 "0100" when alienType = 4 else
				 "0101" when alienType = 5 else
				 "0110" when alienType = 6 else
				 "0111" when alienType = 7 else
				 "1000" when alienType = 8 else
				 "1001" when alienType = 9 else
				 "1010";
	
  process(hcounter, vcounter, shipPos, gameStarted, ImageInput, alienX, alienY, aliens, alien_s)
  begin
	 if gameStarted = '0' then
	   color <= ImageInput;
	 else
		 -- Display the ship
		 if hcounter >= shipPos and hcounter < (shipPos+62) and vcounter > 570 then
			color <= std_logic_vector(to_unsigned(ship((hcounter-shipPos), (vcounter-570)), 8));
		 else
			color <= "00000000";
		 end if;
		 
		 -- Display aliens
		 if hcounter >= alienX and hcounter < (alienX + 300) and vcounter >= alienY and vcounter < (alienY + 150) then
		 case alien_s is
			when "0000" =>
				color <= "00000000";
			when "0001" =>
					color <= std_logic_vector(to_unsigned(blueAlien(((hcounter-alienX) mod 30), ((vcounter-alienY)mod 30)),8));
			when "0011" =>
					color <= std_logic_vector(to_unsigned(DarkBlueAlien(((hcounter-alienX) mod 30), ((vcounter-alienY)mod 30)),8));
			when "0101" =>
					color <= std_logic_vector(to_unsigned(greenAlien(((hcounter-alienX) mod 30), ((vcounter-alienY)mod 30)),8));
			when "0111" =>
					color <= std_logic_vector(to_unsigned(purpleAlien(((hcounter-alienX) mod 30), ((vcounter-alienY)mod 30)),8));
			when "1001" =>
					color <= std_logic_vector(to_unsigned(yellowAlien(((hcounter-alienX) mod 30), ((vcounter-alienY)mod 30)),8));
			when others =>
				color <= "00000000";
		 end case;
		end if;
	 end if;
  end process;
  
end architecture;

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
--          1.2  -  Display mouving aliens
--          1.3  -  Display ship rockets.
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.SpaceInvadersPackage.all;

entity Display is
  port(
    blank          : in  std_logic;     -- If 1, video output must be null
    gameStarted    : in  std_logic;     -- When 0, show start screen
    rocketOnScreen : in  std_logic;     -- If 1, display a rocket
    missileY       : in  std_logic_vector(9 downto 0);  -- Pixels between top screen and top missile position
    shipPosition   : in  std_logic_vector(9 downto 0);  -- Ship x coordinate
    MissileX       : in  std_logic_vector(9 downto 0);  -- Missile x coordinate
    hcount         : in  std_logic_vector(10 downto 0);  -- Pixel x coordinate
    vcount         : in  std_logic_vector(10 downto 0);  -- Pixel y coordinate
    alienX         : in  std_logic_vector(9 downto 0);  -- first alien position from left screen
    alienY         : in  std_logic_vector(8 downto 0);  -- first alien position from top screen
    imageInput     : in  std_logic_vector(7 downto 0);  -- data from rom
    red            : out std_logic_vector(2 downto 0);  -- Red color output
    green          : out std_logic_vector(2 downto 0);  -- Green color output
    blue           : out std_logic_vector(1 downto 0)   -- Blue color output
    );
end entity Display;

architecture logic of Display is

  signal color     : std_logic_vector(7 downto 0);        -- Color output
  signal hcounter  : integer range 0 to 2047;  -- Integer value of hcount
  signal vcounter  : integer range 0 to 2047;  -- Integer value of vcount
  signal shipPos   : integer range 0 to maxShipPosValue;  -- x position of the ship
  signal alienXX   : integer range 0 to 1000;  -- Integer value of alienX
  signal alienYY   : integer range 0 to 1000;  -- Integer value of alienY
  signal missileYY : integer range 0 to 1023;  -- Integer value of missileY
  signal missileXX : integer range shipMargin to (HLINES-shipMargin) := shipMargin;  -- Current Missile x value from left screen
  signal alienLine : integer range 0 to 4 := 0;
  signal alienIndex : integer range 0 to 9 := 0;
  
  signal alienLine1 : std_logic_vector(0 to 9) := "1111111111"; -- 1 bit for every alien ; 1 alien alive, 0 dead alien
  signal alienLine2 : std_logic_vector(0 to 9) := "1111111111"; -- 1 bit for every alien ; 1 alien alive, 0 dead alien
  signal alienLine3 : std_logic_vector(0 to 9) := "1111111111"; -- 1 bit for every alien ; 1 alien alive, 0 dead alien
  signal alienLine4 : std_logic_vector(0 to 9) := "1111111111"; -- 1 bit for every alien ; 1 alien alive, 0 dead alien
  signal alienLine5 : std_logic_vector(0 to 9) := "1111111111"; -- 1 bit for every alien ; 1 alien alive, 0 dead alien
  
  -- Temp signals used for alienLine computation
  signal temp  : integer range 0 to 1023 := 0;
  signal temp2 : integer range 0 to 1023 := 0;
  signal temp3 : integer range 0 to 1023 := 0;


begin

  hcounter  <= to_integer(unsigned(hcount));
  vcounter  <= to_integer(unsigned(vcount));
  shipPos   <= to_integer(unsigned(shipPosition));
  alienXX   <= to_integer(unsigned(alienX));
  alienYY   <= to_integer(unsigned(alienY));
  missileYY <= to_integer(unsigned(missileY));
  missileXX <= to_integer(unsigned(missileX));
  
  alienIndex <= (((hcounter-alienXX) / 30) mod 10) when (hcounter-alienXX) >= 0 else 0;

  temp <= (vcounter-alienYY) when (vcounter-alienYY) >= 0 else 0;
  temp2 <= temp / 30;
  temp3 <= temp2 mod 5;
  alienLine <= temp3;


  -- Outputs must be 0 is blank = 0, this happen
  -- when hcount and vcount are higher than 800x600.
  red   <= color(7 downto 5) when blank = '0' else "000";
  green <= color(4 downto 2) when blank = '0' else "000";
  blue  <= color(1 downto 0) when blank = '0' else "00";

  process(hcounter, vcounter, shipPos, gameStarted, ImageInput, alienXX, alienYY, rocketOnScreen, missileYY, missileXX, alienLine1, 
  alienLine2, alienLine3, alienLine4, alienLine5, alienLine, alienIndex)
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
      if hcounter >= alienXX and hcounter < (alienXX + 300) and vcounter >= alienYY and vcounter < (alienYY + 150) then
			case alienLine is
				when 0 =>
					if alienLine1(alienIndex) = '1' then
						color <= std_logic_vector(to_unsigned(blueAlien(((hcounter-alienXX) mod 30), ((vcounter-alienYY)mod 30)), 8));
					else
						color <= "00000000";
					end if;
				when 1 =>
					if alienLine2(alienIndex) = '1' then
							color <= std_logic_vector(to_unsigned(DarkBlueAlien(((hcounter-alienXX) mod 30), ((vcounter-alienYY)mod 30)), 8));
						else
							color <= "00000000";
						end if;
				when 2 =>
					if alienLine3(alienIndex) = '1' then
						color <= std_logic_vector(to_unsigned(greenAlien(((hcounter-alienXX) mod 30), ((vcounter-alienYY)mod 30)), 8));
					else
						color <= "00000000";
					end if;
				when 3 =>
					if alienLine4(alienIndex) = '1' then
						color <= std_logic_vector(to_unsigned(yellowAlien(((hcounter-alienXX) mod 30), ((vcounter-alienYY)mod 30)), 8));
					else
						color <= "00000000";
					end if;
				when others =>
					if alienLine5(alienIndex) = '1' then
						color <= std_logic_vector(to_unsigned(purpleAlien(((hcounter-alienXX) mod 30), ((vcounter-alienYY)mod 30)), 8));
					else
						color <= "00000000";
					end if;
				end case;
      end if;

      -- Missile
      if rocketOnScreen = '1' then
        if hcounter = missileXX and vcounter > missileYY and vcounter < (missileYY+rocketLength) then
          color <= rocketColor;
        end if;
      end if;
    end if;
  end process;
  
--	alienLine1 <= "1111111111";
--	alienLine2 <= "1111111111";
--	alienLine3 <= "1111000011";
--	alienLine4 <= "1111111111";
--	alienLine5 <= "1111111111";
	
	-- Alien collision
  process(alienXX, gameStarted, alienYY, missileXX, missileYY,alienLine1, alienLine2, alienLine3, alienLine4, alienLine5)
  begin
	if gameStarted = '0' then
		alienLine1 <= "1111111111";
		alienLine2 <= "1111111111";
		alienLine3 <= "1111111111";
		alienLine4 <= "1111111111";
		alienLine5 <= "1111111111";
	-- If rocket position is in the alien table
	elsif missileYY >= alienYY and missileYY < (alienYY+150) and missileXX >= alienXX and missileXX < (alienXX+300) then
		case ((missileYY-alienYY)/30) is
			when 0 => -- top line
				alienLine1((missileXX-alienXX)/30) <= '0';
			when 1 =>
				alienLine2((missileXX-alienXX)/30) <= '0';
			when 2 =>
				alienLine3((missileXX-alienXX)/30) <= '0';
			when 3 =>
				alienLine4((missileXX-alienXX)/30) <= '0';
			when others=> -- bottom line
				alienLine5((missileXX-alienXX)/30) <= '0';
			end case;
	end if;
  
  end process;
  



end architecture;
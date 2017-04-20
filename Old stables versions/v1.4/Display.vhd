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
--          1.3  -  Display ship rockets
--          1.4  -  Aliens can be killed
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
    clk            : in  std_logic;     -- 40MHz
    missileY       : in  std_logic_vector(9 downto 0);  -- Pixels between top screen and top missile position
    shipPosition   : in  std_logic_vector(9 downto 0);  -- Ship x coordinate
    MissileX       : in  std_logic_vector(9 downto 0);  -- Missile x coordinate
    hcount         : in  std_logic_vector(10 downto 0);  -- Pixel x coordinate
    vcount         : in  std_logic_vector(10 downto 0);  -- Pixel y coordinate
    alienX         : in  std_logic_vector(9 downto 0);  -- first alien position from left screen
    alienY         : in  std_logic_vector(8 downto 0);  -- first alien position from top screen
    imageInput     : in  std_logic_vector(7 downto 0);  -- data from rom
    alienKilled    : out std_logic;     -- 1 if alien killed
    red            : out std_logic_vector(2 downto 0);  -- Red color output
    green          : out std_logic_vector(2 downto 0);  -- Green color output
    blue           : out std_logic_vector(1 downto 0)   -- Blue color output
    );
end entity Display;

architecture logic of Display is

  signal color      : std_logic_vector(7 downto 0);        -- Color output
  signal hcounter   : integer range 0 to 2047;  -- Integer value of hcount
  signal vcounter   : integer range 0 to 2047;  -- Integer value of vcount
  signal shipPos    : integer range 0 to maxShipPosValue;  -- x position of the ship
  signal alienXX    : integer range 0 to 1000;  -- Integer value of alienX
  signal alienYY    : integer range 0 to 1000;  -- Integer value of alienY
  signal missileYY  : integer range 0 to 1023;  -- Integer value of missileY
  signal missileXX  : integer range shipMargin to (HLINES-shipMargin) := shipMargin;  -- Current Missile x value from left screen
  signal alienLine  : integer range 0 to 4                            := 0;
  signal alienIndex : integer range 0 to 9                            := 0;

  signal alienLine1 : std_logic_vector(0 to 9) := "1111111111";  -- 1 bit for every alien ; 1 alien alive, 0 dead alien
  signal alienLine2 : std_logic_vector(0 to 9) := "1111111111";  -- 1 bit for every alien ; 1 alien alive, 0 dead alien
  signal alienLine3 : std_logic_vector(0 to 9) := "1111111111";  -- 1 bit for every alien ; 1 alien alive, 0 dead alien
  signal alienLine4 : std_logic_vector(0 to 9) := "1111111111";  -- 1 bit for every alien ; 1 alien alive, 0 dead alien
  signal alienLine5 : std_logic_vector(0 to 9);  -- 1 bit for every alien ; 1 alien alive, 0 dead alien

  signal touched : integer range 0 to 1 := 0;  -- if 1, an alien is killed

  signal ali1 : integer range 0 to 1023 := 1023;
  signal ali2 : integer range 0 to 1023 := 1023;
  signal ali3 : integer range 0 to 1023 := 1023;
  signal ali4 : integer range 0 to 1023 := 1023;
  signal ali5 : integer range 0 to 1023 := 1023;

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

  temp      <= (vcounter-alienYY) when (vcounter-alienYY) >= 0 else 0;
  temp2     <= temp / 30;
  temp3     <= temp2 mod 5;
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

  alienLine1 <= std_logic_vector(to_unsigned(ali1, 10));
  alienLine2 <= std_logic_vector(to_unsigned(ali2, 10));
  alienLine3 <= std_logic_vector(to_unsigned(ali3, 10));
  alienLine4 <= std_logic_vector(to_unsigned(ali4, 10));
  alienLine5 <= std_logic_vector(to_unsigned(ali5, 10));

  process(touched)
  begin
    if touched = 1 then
      alienKilled <= '1';
    else
      alienKilled <= '0';
    end if;
  end process;

  -- Alien collision
  process(gameStarted, clk)
  begin
    if gameStarted = '0' then
      ali1    <= 1023;
      ali2    <= 1023;
      ali3    <= 1023;
      ali4    <= 1023;
      ali5    <= 1023;
      touched <= 0;
    elsif rising_edge(clk) then
      if missileYY >= alienYY and missileYY < (alienYY+150) and missileXX >= alienXX and missileXX < (alienXX+300) then

        -- last line
        if ((missileYY-alienYY)/30) = 4 and touched = 0 then

          if alienLine5(0) = '1' and ((missileXX-alienXX)/30) = 0 then
            ali5    <= ali5 - 512;
            touched <= 1;
          elsif alienLine5(1) = '1' and ((missileXX-alienXX)/30) = 1 then
            ali5    <= ali5 - 256;
            touched <= 1;
          elsif alienLine5(2) = '1' and ((missileXX-alienXX)/30) = 2 then
            ali5    <= ali5 - 128;
            touched <= 1;
          elsif alienLine5(3) = '1' and ((missileXX-alienXX)/30) = 3 then
            ali5    <= ali5 - 64;
            touched <= 1;
          elsif alienLine5(4) = '1' and ((missileXX-alienXX)/30) = 4 then
            ali5    <= ali5 - 32;
            touched <= 1;
          elsif alienLine5(5) = '1' and ((missileXX-alienXX)/30) = 5 then
            ali5    <= ali5 - 16;
            touched <= 1;
          elsif alienLine5(6) = '1' and ((missileXX-alienXX)/30) = 6 then
            ali5    <= ali5 - 8;
            touched <= 1;
          elsif alienLine5(7) = '1' and ((missileXX-alienXX)/30) = 7 then
            ali5    <= ali5 - 4;
            touched <= 1;
          elsif alienLine5(8) = '1' and ((missileXX-alienXX)/30) = 8 then
            ali5    <= ali5 - 2;
            touched <= 1;
          elsif alienLine5(9) = '1' and ((missileXX-alienXX)/30) = 9 then
            ali5    <= ali5 - 1;
            touched <= 1;
          end if;

        -- line 4
        elsif ((missileYY-alienYY)/30) = 3 and touched = 0 then

          if alienLine4(0) = '1' and ((missileXX-alienXX)/30) = 0 then
            ali4    <= ali4 - 512;
            touched <= 1;
          elsif alienLine4(1) = '1' and ((missileXX-alienXX)/30) = 1 then
            ali4    <= ali4 - 256;
            touched <= 1;
          elsif alienLine4(2) = '1' and ((missileXX-alienXX)/30) = 2 then
            ali4    <= ali4 - 128;
            touched <= 1;
          elsif alienLine4(3) = '1' and ((missileXX-alienXX)/30) = 3 then
            ali4    <= ali4 - 64;
            touched <= 1;
          elsif alienLine4(4) = '1' and ((missileXX-alienXX)/30) = 4 then
            ali4    <= ali4 - 32;
            touched <= 1;
          elsif alienLine4(5) = '1' and ((missileXX-alienXX)/30) = 5 then
            ali4    <= ali4 - 16;
            touched <= 1;
          elsif alienLine4(6) = '1' and ((missileXX-alienXX)/30) = 6 then
            ali4    <= ali4 - 8;
            touched <= 1;
          elsif alienLine4(7) = '1' and ((missileXX-alienXX)/30) = 7 then
            ali4    <= ali4 - 4;
            touched <= 1;
          elsif alienLine4(8) = '1' and ((missileXX-alienXX)/30) = 8 then
            ali4    <= ali4 - 2;
            touched <= 1;
          elsif alienLine4(9) = '1' and ((missileXX-alienXX)/30) = 9 then
            ali4    <= ali4 - 1;
            touched <= 1;
          end if;

        -- line 3
        elsif ((missileYY-alienYY)/30) = 2 and touched = 0 then

          if alienLine3(0) = '1' and ((missileXX-alienXX)/30) = 0 then
            ali3    <= ali3 - 512;
            touched <= 1;
          elsif alienLine3(1) = '1' and ((missileXX-alienXX)/30) = 1 then
            ali3    <= ali3 - 256;
            touched <= 1;
          elsif alienLine3(2) = '1' and ((missileXX-alienXX)/30) = 2 then
            ali3    <= ali3 - 128;
            touched <= 1;
          elsif alienLine3(3) = '1' and ((missileXX-alienXX)/30) = 3 then
            ali3    <= ali3 - 64;
            touched <= 1;
          elsif alienLine3(4) = '1' and ((missileXX-alienXX)/30) = 4 then
            ali3    <= ali3 - 32;
            touched <= 1;
          elsif alienLine3(5) = '1' and ((missileXX-alienXX)/30) = 5 then
            ali3    <= ali3 - 16;
            touched <= 1;
          elsif alienLine3(6) = '1' and ((missileXX-alienXX)/30) = 6 then
            ali3    <= ali3 - 8;
            touched <= 1;
          elsif alienLine3(7) = '1' and ((missileXX-alienXX)/30) = 7 then
            ali3    <= ali3 - 4;
            touched <= 1;
          elsif alienLine3(8) = '1' and ((missileXX-alienXX)/30) = 8 then
            ali3    <= ali3 - 2;
            touched <= 1;
          elsif alienLine3(9) = '1' and ((missileXX-alienXX)/30) = 9 then
            ali3    <= ali3 - 1;
            touched <= 1;
          end if;

        -- line 2
        elsif ((missileYY-alienYY)/30) = 1 and touched = 0 then

          if alienLine2(0) = '1' and ((missileXX-alienXX)/30) = 0 then
            ali2    <= ali2 - 512;
            touched <= 1;
          elsif alienLine2(1) = '1' and ((missileXX-alienXX)/30) = 1 then
            ali2    <= ali2 - 256;
            touched <= 1;
          elsif alienLine2(2) = '1' and ((missileXX-alienXX)/30) = 2 then
            ali2    <= ali2 - 128;
            touched <= 1;
          elsif alienLine2(3) = '1' and ((missileXX-alienXX)/30) = 3 then
            ali2    <= ali2 - 64;
            touched <= 1;
          elsif alienLine2(4) = '1' and ((missileXX-alienXX)/30) = 4 then
            ali2    <= ali2 - 32;
            touched <= 1;
          elsif alienLine2(5) = '1' and ((missileXX-alienXX)/30) = 5 then
            ali2    <= ali2 - 16;
            touched <= 1;
          elsif alienLine2(6) = '1' and ((missileXX-alienXX)/30) = 6 then
            ali2    <= ali2 - 8;
            touched <= 1;
          elsif alienLine2(7) = '1' and ((missileXX-alienXX)/30) = 7 then
            ali2    <= ali2 - 4;
            touched <= 1;
          elsif alienLine2(8) = '1' and ((missileXX-alienXX)/30) = 8 then
            ali2    <= ali2 - 2;
            touched <= 1;
          elsif alienLine2(9) = '1' and ((missileXX-alienXX)/30) = 9 then
            ali2    <= ali2 - 1;
            touched <= 1;
          end if;

        -- line 1
        elsif ((missileYY-alienYY)/30) = 0 and touched = 0 then

          if alienLine1(0) = '1' and ((missileXX-alienXX)/30) = 0 then
            ali1    <= ali1 - 512;
            touched <= 1;
          elsif alienLine1(1) = '1' and ((missileXX-alienXX)/30) = 1 then
            ali1    <= ali1 - 256;
            touched <= 1;
          elsif alienLine1(2) = '1' and ((missileXX-alienXX)/30) = 2 then
            ali1    <= ali1 - 128;
            touched <= 1;
          elsif alienLine1(3) = '1' and ((missileXX-alienXX)/30) = 3 then
            ali1    <= ali1 - 64;
            touched <= 1;
          elsif alienLine1(4) = '1' and ((missileXX-alienXX)/30) = 4 then
            ali1    <= ali1 - 32;
            touched <= 1;
          elsif alienLine1(5) = '1' and ((missileXX-alienXX)/30) = 5 then
            ali1    <= ali1 - 16;
            touched <= 1;
          elsif alienLine1(6) = '1' and ((missileXX-alienXX)/30) = 6 then
            ali1    <= ali1 - 8;
            touched <= 1;
          elsif alienLine1(7) = '1' and ((missileXX-alienXX)/30) = 7 then
            ali1    <= ali1 - 4;
            touched <= 1;
          elsif alienLine1(8) = '1' and ((missileXX-alienXX)/30) = 8 then
            ali1    <= ali1 - 2;
            touched <= 1;
          elsif alienLine1(9) = '1' and ((missileXX-alienXX)/30) = 9 then
            ali1    <= ali1 - 1;
            touched <= 1;
          end if;

        end if;
      else
        touched <= 0;
      end if;
    end if;
  end process;

end architecture;

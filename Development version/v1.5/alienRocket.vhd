----------------------------------------------------------------------------------
-- Company:         HES-SO
-- Engineer:        Samuel Riedo & Pascal Roulin
-- Create Date:     20/04/2017
-- Design Name:     alienRocket.vhd
-- Project Name:    Space Invaders - FPGA Edition
-- Target Devices:  Digilent NEXYS 3 (Xilinx Spartan 6 XC6LX16-CS324)
-- Description:     Manage rockets shoot by aliens
-- Revision 0.1  -  File Created
--          1.0  -  First implementation
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.SpaceInvadersPackage.all;

entity alienRocket is
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
    alienRockety : out std_logic_vector(9 downto 0)   -- Alien rocket y coordinate from top screen
    );
end entity;

architecture logic of alienRocket is

  signal column1  : std_logic_vector(4 downto 0);  -- First column of alien
  signal column2  : std_logic_vector(4 downto 0);  -- MSB = bottom screen alien
  signal column3  : std_logic_vector(4 downto 0);  -- LSB = top screen alien
  signal column4  : std_logic_vector(4 downto 0);
  signal column5  : std_logic_vector(4 downto 0);
  signal column6  : std_logic_vector(4 downto 0);
  signal column7  : std_logic_vector(4 downto 0);
  signal column8  : std_logic_vector(4 downto 0);
  signal column9  : std_logic_vector(4 downto 0);
  signal column10 : std_logic_vector(4 downto 0);  -- Last column of alien

  signal shipPos        : integer range 0 to maxShipPosValue;  -- x position of the ship
  signal columnCounter  : integer range 0 to 9                                  := 0;  -- Determine the shooting column
  signal newShoot       : integer range 0 to 1                                  := 0;  -- Force a new shoot if 1
  signal shootTimer     : integer range 0 to rocketFrequency                    := 0;  -- Determine the shooting column
  signal rocketYY       : integer range 0 to VLINES                             := VLINES;  -- Alien rocket y position from top screen
  signal rocketLaunched : integer range 0 to 1                                  := 0;  -- If 1, a rocket is launched
  signal rocketXX       : integer range alienXMargin to (HLINES - alienXMargin) := alienXMargin;  -- Rocket x position when a new one is launched
  signal rocketXXX      : integer range alienXMargin to (HLINES - alienXMargin) := alienXMargin;  -- Copy of rocketXX before it is reset to 0
  signal newRocketYY    : integer range 0 to VLINES                             := 0;  -- Y position of a new rocket launched
  signal alienXX        : integer range 0 to 1000;  -- Integer value of alienX
  signal alienYY        : integer range 0 to 1000;  -- Integer value of alienY
  signal rocketSpeed    : integer range 0 to missileSpeed;     -- Missile speed
  signal rocketFinished : integer range 0 to 1                                  := 1;  -- If 1, a new rocket can be launched

begin

  alienRocketx <= std_logic_vector(to_unsigned(rocketXXX, 10));
  alienRockety <= std_logic_vector(to_unsigned(rocketYY, 10));

  shipPos <= to_integer(unsigned(shipPosition));

  column1  <= alienLine5(0) & alienLine4(0) & alienLine3(0) & alienLine2(0) & alienLine1(0);
  column2  <= alienLine5(1) & alienLine4(1) & alienLine3(1) & alienLine2(1) & alienLine1(1);
  column3  <= alienLine5(2) & alienLine4(2) & alienLine3(2) & alienLine2(2) & alienLine1(2);
  column4  <= alienLine5(3) & alienLine4(3) & alienLine3(3) & alienLine2(3) & alienLine1(3);
  column5  <= alienLine5(4) & alienLine4(4) & alienLine3(4) & alienLine2(4) & alienLine1(4);
  column6  <= alienLine5(5) & alienLine4(5) & alienLine3(5) & alienLine2(5) & alienLine1(5);
  column7  <= alienLine5(6) & alienLine4(6) & alienLine3(6) & alienLine2(6) & alienLine1(6);
  column8  <= alienLine5(7) & alienLine4(7) & alienLine3(7) & alienLine2(7) & alienLine1(7);
  column9  <= alienLine5(8) & alienLine4(8) & alienLine3(8) & alienLine2(8) & alienLine1(8);
  column10 <= alienLine5(9) & alienLine4(9) & alienLine3(9) & alienLine2(9) & alienLine1(9);

  alienXX <= to_integer(unsigned(alienX));
  alienYY <= to_integer(unsigned(alienY));

  -- columnCounter, rocketXXX and shootTimer
  process(reset, clk)
  begin
    if reset = '1' then
      columnCounter <= 0;
      shootTimer    <= 0;
      rocketXXX     <= alienXMargin;
    elsif rising_edge(clk) then
      -- rocketXX
      if rocketXX > alienXMargin then
        rocketXXX <= rocketXX;
      else
        rocketXXX <= rocketXXX;
      end if;
      -- columnCounter
      if columnCounter = 9 then
        columnCounter <= 0;
      else
        columnCounter <= columnCounter + 1;
      end if;
      -- shootTimer
      if newShoot = 1 then
        shootTimer <= rocketFrequency;
      elsif shootTimer = rocketFrequency then
        shootTimer <= 0;
      else
        shootTimer <= shootTimer + 1;
      end if;
    end if;
  end process;

  -- Launch new alien rocket
  process(shootTimer, columnCounter, column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, alienyy, alienxx, rocketFinished)
  begin
    if shootTimer = rocketFrequency and rocketFinished = 1 then
      rocketLaunched <= 1;
      newShoot       <= 0;
      case columnCounter is
        when 0 =>
          if column1 > "00000" then
            if column1 > "01111" then
              newRocketYY <= (alienYY + 150);
              rocketXX    <= (alienXX+15);
            elsif column1 > "00111" then
              newRocketYY <= (alienYY + 120);
              rocketXX    <= (alienXX+15);
            elsif column1 > "00011" then
              newRocketYY <= (alienYY + 90);
              rocketXX    <= (alienXX+15);
            elsif column1 > "00001" then
              newRocketYY <= (alienYY + 60);
              rocketXX    <= (alienXX+15);
            else
              newRocketYY <= (alienYY + 30);
              rocketXX    <= (alienXX+15);
            end if;
          else
            newRocketYY <= 0;
            rocketXX    <= alienXMargin;
            newShoot    <= 1;
          end if;
        when 1 =>
          if column2 > "00000" then
            if column2 > "01111" then
              newRocketYY <= (alienYY + 150);
              rocketXX    <= (alienXX+45);
            elsif column2 > "00111" then
              newRocketYY <= (alienYY + 120);
              rocketXX    <= (alienXX+45);
            elsif column2 > "00011" then
              newRocketYY <= (alienYY + 90);
              rocketXX    <= (alienXX+45);
            elsif column2 > "00001" then
              newRocketYY <= (alienYY + 60);
              rocketXX    <= (alienXX+45);
            else
              newRocketYY <= (alienYY + 30);
              rocketXX    <= (alienXX+45);
            end if;
          else
            newRocketYY <= 0;
            rocketXX    <= alienXMargin;
            newShoot    <= 1;
          end if;
        when 2 =>
          if column3 > "00000" then
            if column3 > "01111" then
              newRocketYY <= (alienYY + 150);
              rocketXX    <= (alienXX+75);
            elsif column3 > "00111" then
              newRocketYY <= (alienYY + 120);
              rocketXX    <= (alienXX+75);
            elsif column3 > "00011" then
              newRocketYY <= (alienYY + 90);
              rocketXX    <= (alienXX+75);
            elsif column3 > "00001" then
              newRocketYY <= (alienYY + 60);
              rocketXX    <= (alienXX+75);
            else
              newRocketYY <= (alienYY + 30);
              rocketXX    <= (alienXX+75);
            end if;
          else
            newRocketYY <= 0;
            rocketXX    <= alienXMargin;
            newShoot    <= 1;
          end if;
        when 3 =>
          if column4 > "00000" then
            if column4 > "01111" then
              newRocketYY <= (alienYY + 150);
              rocketXX    <= (alienXX+105);
            elsif column4 > "00111" then
              newRocketYY <= (alienYY + 120);
              rocketXX    <= (alienXX+105);
            elsif column4 > "00011" then
              newRocketYY <= (alienYY + 90);
              rocketXX    <= (alienXX+105);
            elsif column4 > "00001" then
              newRocketYY <= (alienYY + 60);
              rocketXX    <= (alienXX+105);
            else
              newRocketYY <= (alienYY + 30);
              rocketXX    <= (alienXX+105);
            end if;
          else
            newRocketYY <= 0;
            rocketXX    <= alienXMargin;
            newShoot    <= 1;
          end if;
        when 4 =>
          if column5 > "00000" then
            if column5 > "01111" then
              newRocketYY <= (alienYY + 150);
              rocketXX    <= (alienXX+135);
            elsif column5 > "00111" then
              newRocketYY <= (alienYY + 120);
              rocketXX    <= (alienXX+135);
            elsif column5 > "00011" then
              newRocketYY <= (alienYY + 90);
              rocketXX    <= (alienXX+135);
            elsif column5 > "00001" then
              newRocketYY <= (alienYY + 60);
              rocketXX    <= (alienXX+135);
            else
              newRocketYY <= (alienYY + 30);
              rocketXX    <= (alienXX+135);
            end if;
          else
            newRocketYY <= 0;
            rocketXX    <= alienXMargin;
            newShoot    <= 1;
          end if;
        when 5 =>
          if column6 > "00000" then
            if column6 > "01111" then
              newRocketYY <= (alienYY + 150);
              rocketXX    <= (alienXX+165);
            elsif column6 > "00111" then
              newRocketYY <= (alienYY + 120);
              rocketXX    <= (alienXX+165);
            elsif column6 > "00011" then
              newRocketYY <= (alienYY + 90);
              rocketXX    <= (alienXX+165);
            elsif column6 > "00001" then
              newRocketYY <= (alienYY + 60);
              rocketXX    <= (alienXX+165);
            else
              newRocketYY <= (alienYY + 30);
              rocketXX    <= (alienXX+165);
            end if;
          else
            newRocketYY <= 0;
            rocketXX    <= alienXMargin;
            newShoot    <= 1;
          end if;
        when 6 =>
          if column7 > "00000" then
            if column7 > "01111" then
              newRocketYY <= (alienYY + 150);
              rocketXX    <= (alienXX+195);
            elsif column7 > "00111" then
              newRocketYY <= (alienYY + 120);
              rocketXX    <= (alienXX+195);
            elsif column7 > "00011" then
              newRocketYY <= (alienYY + 90);
              rocketXX    <= (alienXX+195);
            elsif column7 > "00001" then
              newRocketYY <= (alienYY + 60);
              rocketXX    <= (alienXX+195);
            else
              newRocketYY <= (alienYY + 30);
              rocketXX    <= (alienXX+195);
            end if;
          else
            newRocketYY <= 0;
            rocketXX    <= alienXMargin;
            newShoot    <= 1;
          end if;
        when 7 =>
          if column8 > "00000" then
            if column8 > "01111" then
              newRocketYY <= (alienYY + 150);
              rocketXX    <= (alienXX+225);
            elsif column8 > "00111" then
              newRocketYY <= (alienYY + 120);
              rocketXX    <= (alienXX+225);
            elsif column8 > "00011" then
              newRocketYY <= (alienYY + 90);
              rocketXX    <= (alienXX+225);
            elsif column8 > "00001" then
              newRocketYY <= (alienYY + 60);
              rocketXX    <= (alienXX+225);
            else
              newRocketYY <= (alienYY + 30);
              rocketXX    <= (alienXX+225);
            end if;
          else
            newRocketYY <= 0;
            rocketXX    <= alienXMargin;
            newShoot    <= 1;
          end if;
        when 8 =>
          if column9 > "00000" then
            if column9 > "01111" then
              newRocketYY <= (alienYY + 150);
              rocketXX    <= (alienXX+255);
            elsif column9 > "00111" then
              newRocketYY <= (alienYY + 120);
              rocketXX    <= (alienXX+255);
            elsif column9 > "00011" then
              newRocketYY <= (alienYY + 90);
              rocketXX    <= (alienXX+255);
            elsif column9 > "00001" then
              newRocketYY <= (alienYY + 60);
              rocketXX    <= (alienXX+255);
            else
              newRocketYY <= (alienYY + 30);
              rocketXX    <= (alienXX+255);
            end if;
          else
            newRocketYY <= 0;
            rocketXX    <= alienXMargin;
            newShoot    <= 1;
          end if;
        when others =>
          if column10 > "00000" then
            if column10 > "01111" then
              newRocketYY <= (alienYY + 150);
              rocketXX    <= (alienXX+285);
            elsif column10 > "00111" then
              newRocketYY <= (alienYY + 120);
              rocketXX    <= (alienXX+285);
            elsif column10 > "00011" then
              newRocketYY <= (alienYY + 90);
              rocketXX    <= (alienXX+285);
            elsif column10 > "00001" then
              newRocketYY <= (alienYY + 60);
              rocketXX    <= (alienXX+285);
            else
              newRocketYY <= (alienYY + 30);
              rocketXX    <= (alienXX+285);
            end if;
          else
            newRocketYY <= 0;
            rocketXX    <= alienXMargin;
            newShoot    <= 1;
          end if;
      end case;
    else
      rocketLaunched <= 0;
      newRocketYY    <= 0;
      rocketXX       <= alienXMargin;
      newShoot       <= 0;
    end if;
  end process;

  -- Update rocketYY
  process(reset, clk, newShoot)
  begin
    if reset = '1' or newShoot = 1 then
      rocketYY       <= VLINES;
      rocketFinished <= 1;
    elsif rising_edge(clk) then
      if rocketlaunched = 1 then
        rocketYY       <= newRocketYY;
        rocketFinished <= 0;
      end if;

      if rocketSpeed = missileSpeed then
        rocketSpeed <= 0;
        if rocketYY = VLINES then
          rocketYY       <= VLINES;
          rocketFinished <= 1;
        else
          rocketYY       <= rocketYY + 1;
          rocketFinished <= 0;
        end if;
      else
        rocketSpeed <= rocketSpeed + 1;
      --rocketFinished <= 0;
      end if;
    end if;
  end process;

end architecture;

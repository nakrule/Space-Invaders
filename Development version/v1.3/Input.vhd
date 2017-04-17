----------------------------------------------------------------------------------
-- Company:         HES-SO
-- Engineer:        Samuel Riedo & Pascal Roulin
-- Create Date:     13/04/2017
-- Design Name:     Input.vhd
-- Project Name:    Space Invaders - FPGA Edition
-- Target Devices:  Digilent NEXYS 3 (Xilinx Spartan 6 XC6LX16-CS324)
-- Description:     Slow inputs
-- Revision 0.01 -  File Created
--          1.00 -  Fire, left and write implemented
--          1.1  -  Ship and aliens movements implemented
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.SpaceInvadersPackage.all;

entity Input is
  port(
    startButton  : in  std_logic;       -- When 1, start game
	 fire         : in  std_logic;       -- When 1, shoot a rocket
    clk          : in  std_logic;       -- 40MHz
    fastCLK      : in  std_logic;       -- 100MHz clock for random counter
    reset        : in  std_logic;       -- Active high
    left         : in  std_logic;       -- Left arrow button
    right        : in  std_logic;       -- Right arrow button
	 newMissile   : out std_logic;       -- If 1, new missile launched
    gameStarted  : out std_logic;       -- When 0, show start screen
    alienX       : out std_logic_vector(9 downto 0);  -- first alien position from left screen
    alienY       : out std_logic_vector(8 downto 0);  -- first alien position from top screen
    shipPosition : out std_logic_vector(9 downto 0)   -- Ship x coordinate
    );
end Input;

architecture Behavioral of Input is

  signal start          : integer range 0 to 1                             := 0;  -- Integer of gameStarted
  signal fireTimer      : integer range 0 to fireSpeed                     := 0;  -- Slow fire rate
  signal shipTimer      : integer range 0 to shipSpeed                     := 0;  -- Slow ship speed
  signal alienTimer     : integer range 0 to alienSpeed                    := 0;  -- Slow alien speed
  signal alienDirection : integer range 0 to 7                             := 0;  -- If 0, aliens move left, 1=up left, 2 = up, ...
  signal alienJump      : integer range 1 to maxAlienJump                  := 1;  -- Pixels number alien use as unit to move
  signal shipPos        : integer range 0 to 737                           := (maxShipPosValue/2);  -- X position of the ship
  signal alienXX        : integer range alienXMargin to (500-alienXMargin) := 250;  -- alienX in integer, 499=799-300
  signal alienYY        : integer range alienYUpMargin to alienYDownMargin := 100;  -- alienY in integer

begin

  -- Update outputs according to their integer equivalent
  gameStarted  <= '1' when start = 1 else '0';
  shipPosition <= std_logic_vector(to_unsigned(shipPos, 10));
  alienX       <= std_logic_vector(to_unsigned(alienXX, 10));
  alienY       <= std_logic_vector(to_unsigned(alienYY, 9));

  process(reset, clk)
  begin
    if reset = '1' then
      alienYY    <= 100;
      alienXX    <= 250;
      shipPos    <= (maxShipPosValue/2);
      alienTimer <= 0;
      shipTimer  <= 0;
      fireTimer  <= 0;
      start      <= 0;
		newMissile <= '0';
    elsif rising_edge(clk) then
      -- fire
      if fireTimer >= fireSpeed then
        fireTimer <= 0;
        if startButton = '1' then
			 start <= 1;
        end if;
		  if fire = '1' and start = 1 then
			newMissile <= '1';
			else
				newMissile <= '0';
			end if;
      else
        fireTimer <= fireTimer + 1;
		  newMissile <= '0';
      end if;

      -- left and right
		if start = 1 then
			if shipTimer >= shipSpeed then
			  shipTimer <= 0;
			  if left = '1' then
				 if shipPos > (0+shipMargin) then
					shipPos <= shipPos - 1;
				 end if;
			  elsif right = '1' then
				 if shipPos < (maxShipPosValue-shipMargin) then
					shipPos <= shipPos + 1;
				 end if;
			  end if;
			else
			  shipTimer <= shipTimer + 1;
			end if;
		else
			shipTimer <= 0;
		end if;

      -- aliens
      if alienTimer >= alienSpeed then
        alienTimer <= 0;
        case alienDirection is
          when 0 =>                     -- go left
            if alienXX > alienXMargin then
              alienXX    <= alienXX -alienJump;
              alienTimer <= alienXX + fireTimer;
            end if;
          when 1 =>                     -- go up left
            if alienXX > alienXMargin and alienYY > alienYUpMargin then
              alienXX    <= alienXX -alienJump;
              alienYY    <= alienYY -alienJump;
              alienTimer <= alienYY + shipTimer;
            end if;
          when 2 =>                     -- go up
            if alienYY > alienYUpMargin then
              alienYY    <= alienYY -alienJump;
              alienTimer <= alienYY + shipTimer;
            end if;
          when 3 =>                     -- go up right
            if alienXX < (500-alienXMargin) and alienYY > alienYUpMargin then
              alienXX    <= alienXX +alienJump;
              alienYY    <= alienYY -alienJump;
              alienTimer <= alienXX + fireTimer;
            end if;
          when 4 =>                     -- go right
            if alienXX < (500-alienXMargin) then
              alienXX    <= alienXX +alienJump;
              alienTimer <= alienXX + shipTimer;
            end if;
          when 5 =>                     -- go right down
            if alienXX < (500-alienXMargin) and alienYY < alienYDownMargin then
              alienXX    <= alienXX +alienJump;
              alienYY    <= alienYY +alienJump;
              alienTimer <= alienYY + fireTimer;
            end if;
          when 6 =>                     -- go down
            if alienYY < alienYDownMargin then
              alienYY    <= alienYY +alienJump;
              alienTimer <= alienXX + shipTimer;
            end if;
          when others =>                -- go down left
            if alienXX > alienXMargin and alienYY < alienYDownMargin then
              alienXX    <= alienXX -alienJump;
              alienYY    <= alienYY +alienJump;
              alienTimer <= alienYY + fireTimer;
            end if;
        end case;
      else
        alienTimer <= alienTimer + 1;
      end if;
    end if;
  end process;

  process(reset, fastCLK)
  begin
    if reset = '1' then
      alienDirection <= 0;
      alienJump      <= 1;
    elsif rising_edge(fastCLK) then
      -- alien direction
      if alienDirection >= 7 then
        alienDirection <= 0;
      else
        alienDirection <= alienDirection + 1;
      end if;
      -- alien jump
      if alienJump >= maxAlienJump then
        alienJump <= 1;
      else
        alienJump <= alienJump + 1;
      end if;
		
    end if;
  end process;

end Behavioral;


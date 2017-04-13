----------------------------------------------------------------------------------
-- Company:         HES-SO
-- Engineer:        Samuel Riedo & Pascal Roulin
-- Create Date:     13/04/2017
-- Design Name:     Display.vhd
-- Project Name:    Super Mario World - FPGA Edition
-- Target Devices:  Digilent NEXYS 3 (Xilinx Spartan 6 XC6LX16-CS324)
-- Description:     Slow inputs
-- Revision 0.01 -  File Created
--          1.00 -  Fire, left and write implemented.
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.SpaceInvadersPackage.all;

entity Input is
	port(
		fire : in std_logic; -- When 1, shoot or start game
		clk : in std_logic; -- 40MHz
		left : in std_logic; -- Left arrow button
		right : in std_logic; -- Right arrow button
		gameStarted : out std_logic; -- When 0, show start screen
		shipPosition : out  std_logic_vector(9 downto 0)  -- Ship x coordinate
	);
end Input;

architecture Behavioral of Input is

	signal start : integer range 0 to 1 := 0;
	signal fireTimer : integer range 0 to fireSpeed := 0;
	signal shipTimer : integer range 0 to shipSpeed := 0;
	signal shipPos : integer range 0 to 737;   -- x position of the ship

begin

	gameStarted <= '1' when start = 1 else '0';
	shipPosition <= std_logic_vector(to_unsigned(shipPos, 10));

	process(clk)
	begin
		if rising_edge(clk) then
			-- fire
			if fireTimer >= fireSpeed then
				fireTimer <= 0;
				if fire = '1' then
					start <= 1;
				end if;
			else
				fireTimer <= fireTimer + 1;
			end if;
			
			-- left and right
			if shipTimer >= shipSpeed then
				shipTimer <= 0;
				if left = '1' then
					if shipPos >0 then
						shipPos <= shipPos - 1;
					end if;
				elsif right = '1' then
					if shipPos < maxShipPosValue then
						shipPos <= shipPos + 1;
					end if;
				end if;
			else
				shipTimer <= shipTimer + 1;
			end if;
			
		end if;
	end process;

end Behavioral;


----------------------------------------------------------------------------------
-- Company:        HES-SO
-- Engineer:       Samuel Riedo & Pascal Roulin
-- Create Date:    11:24:52 03/02/2017
-- Design Name:    marioPackage.vhd
-- Project Name:   Super Mario World - FPGA Edition
-- Target Devices: Digilent NEXYS 3 (Xilinx Spartan 6 XC6LX16-CS324)
-- Description:    Contain all constant.
-- Revision 0.01 - File Created
--          1.00 - Add vga contants.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package SpaceInvadersPackage is
----------------------------------------------------------------------------------
  -- vga constants
  constant HMAX      : integer := 1056;
  constant VMAX      : integer := 628;
  constant HLINES    : integer := 800;
  constant VLINES    : integer := 600;
  constant HSP       : integer := 968;
  constant HFP       : integer := 840;
  constant VFP       : integer := 601;
  constant VSP       : integer := 605;
----------------------------------------------------------------------------------
  -- romsRouter
  constant firstMap  : integer := 1;   -- First used map to create world map.
  constant lastMap   : integer := 7;   -- Last used map to create world map.
----------------------------------------------------------------------------------
end SpaceInvadersPackage;

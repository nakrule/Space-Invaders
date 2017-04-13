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

library ieee;
use ieee.std_logic_1164.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package SpaceInvadersPackage is
----------------------------------------------------------------------------------
  -- VGA
  constant HMAX      : integer := 1056;
  constant VMAX      : integer := 628;
  constant HLINES    : integer := 800;
  constant VLINES    : integer := 600;
  constant HSP       : integer := 968;
  constant HFP       : integer := 840;
  constant VFP       : integer := 601;
  constant VSP       : integer := 605;
  ----------------------------------------------------------------------------------
  -- Inputs
  constant fireSpeed : integer := 60000;
  constant shipSpeed : integer := 60000;
  constant maxShipPosValue : integer := 737;
----------------------------------------------------------------------------------
  -- Tables of aliens and ship
  type shipPicture is array(0 to 61, 0 to 29) of integer;
constant ship : shipPicture:=(
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#ff#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#),
(16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#,16#0#));
----------------------------------------------------------------------------------
end SpaceInvadersPackage;

--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 


library IEEE;
use IEEE.STD_LOGIC_1164.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package marioPackage is
  -- vga constants
  constant HMAX   : integer := 1056;
  constant VMAX   : integer := 628;
  constant HLINES : integer := 800;
  constant VLINES : integer := 600;
  constant HSP    : integer := 968;
  constant HFP    : integer := 840;
  constant VFP    : integer := 601;
  constant VSP    : integer := 605;
  -- file constants
end marioPackage;

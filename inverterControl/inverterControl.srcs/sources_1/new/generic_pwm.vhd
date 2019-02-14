----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/14/2019 09:58:02 AM
-- Design Name: 
-- Module Name: generic_pwm - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity generic_pwm is
    Port ( freq : in STD_LOGIC;
           ocr : in STD_LOGIC;
           phase : in STD_LOGIC;
           pwm_high : out STD_LOGIC;
           pwm_low : out STD_LOGIC);
end generic_pwm;

architecture Behavioral of generic_pwm is

begin


end Behavioral;

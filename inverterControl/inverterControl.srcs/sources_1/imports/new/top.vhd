library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.NUMERIC_STD.all;


entity top is
    Port (  
            clk         : in  STD_LOGIC;
            sw          : in  std_logic_vector (3 downto 0);
            red         : out STD_LOGIC_VECTOR (7 downto 0);
            green       : out STD_LOGIC_VECTOR (7 downto 0);
            blue        : out STD_LOGIC_VECTOR (7 downto 0);
            row         : out STD_LOGIC_VECTOR (7 downto 0)
           );
end top;

architecture Behavioral of top is
    -- ************ Components ************

    
    -- ************ Signals ************
    -- Clock prescaler
    signal prescaler        : unsigned(31 downto 0) := x"00000000";

begin


prescaling_process:
process (clk)
begin
   if rising_edge(clk) then
        prescaler <= prescaler + 1;
   end if;
end process;





end Behavioral;
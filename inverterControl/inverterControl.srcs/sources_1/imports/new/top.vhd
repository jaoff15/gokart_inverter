 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.NUMERIC_STD.all;


entity top is
--    Port (  
----    clk_8ns     : in  STD_LOGIC;
----            red         : out STD_LOGIC_VECTOR (7 downto 0);
----            green       : out STD_LOGIC_VECTOR (7 downto 0);
----            blue        : out STD_LOGIC_VECTOR (7 downto 0);
----            row         : out STD_LOGIC_VECTOR (7 downto 0)
--           );
end top;

architecture Behavioral of top is

    
    
    
--    component m_row is
--    Port (  
--    counter     : in  unsigned(7 downto 0)  := "00000000";
--            red_out     : in  STD_LOGIC_VECTOR(63 downto 0);
--            green_out   : in  STD_LOGIC_VECTOR(63 downto 0);
--            blue_out    : in  STD_LOGIC_VECTOR(63 downto 0);
--            red_pwm     : out STD_LOGIC_VECTOR(7 downto 0);
--            green_pwm   : out STD_LOGIC_VECTOR(7 downto 0);
--            blue_pwm    : out STD_LOGIC_VECTOR(7 downto 0)
--           );
--end component;
    
--    signal prescaler       : unsigned(31 downto 0) := x"00000000";
--    signal counter         : unsigned(7 downto 0)  := "00000000";
--    signal column_counter  : unsigned(7 downto 0)  := "00000000";
    
--    signal color_r      : STD_LOGIC_VECTOR(63 downto 0);
--    signal color_g      : STD_LOGIC_VECTOR(63 downto 0);
--    signal color_b      : STD_LOGIC_VECTOR(63 downto 0);
    
    
--    signal column       : STD_LOGIC_VECTOR(7 downto 0);
begin


--prescaling_process:
--process (clk_8ns)
--begin
--   if rising_edge(clk_8ns) then
--        prescaler <= prescaler + 1;
--   end if;
--end process;


--counter_process:
--process (prescaler)
--begin
---- 7.5kHz
--   if rising_edge(prescaler(14)) then
--        counter <= counter + 1;
--   end if;
--end process;

--column_process:
--process (prescaler)
--begin
--   if rising_edge(prescaler(20)) then
--        column_counter <= column_counter + 1;
--   end if;
--end process;



--row0:m_row
--port map(
--    counter     => counter,
--    red_out     => x"00112233445566778899AABBCCDDEEFF",
--    green_out   => x"00112233445566778899AABBCCDDEEFF",
--    blue_out    => x"00112233445566778899AABBCCDDEEFF",
--    red_pwm     => red,
--    green_pwm   => green,
--    blue_pwm    => blue
--);





end Behavioral;

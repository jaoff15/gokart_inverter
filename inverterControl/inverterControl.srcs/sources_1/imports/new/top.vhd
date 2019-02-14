 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.NUMERIC_STD.all;


entity top is
    Port (  
            clk_8ns     : in  STD_LOGIC;
            red         : out STD_LOGIC_VECTOR (7 downto 0);
            green       : out STD_LOGIC_VECTOR (7 downto 0);
            blue        : out STD_LOGIC_VECTOR (7 downto 0);
            row         : out STD_LOGIC_VECTOR (7 downto 0)
           );
end top;

architecture Behavioral of top is

    
    
    
    component generic_pwm is
    Port ( clk            : in  STD_LOGIC;
           freq           : in  STD_LOGIC_VECTOR(3 downto 0);
           threshold_high : in  signed(31 downto 0);
           threshold_low  : in  signed(31 downto 0);
           pwm_high       : out STD_LOGIC;
           pwm_low        : out STD_LOGIC
           );
end component;
    
--    signal prescaler       : unsigned(31 downto 0) := x"00000000";
--    signal counter         : unsigned(7 downto 0)  := "00000000";
--    signal column_counter  : unsigned(7 downto 0)  := "00000000";
    
--    signal color_r      : STD_LOGIC_VECTOR(63 downto 0);
--    signal color_g      : STD_LOGIC_VECTOR(63 downto 0);
--    signal color_b      : STD_LOGIC_VECTOR(63 downto 0);
    
    
--    signal column       : STD_LOGIC_VECTOR(7 downto 0);
begin

row <= "11111110";
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



generic_pwm0:generic_pwm
port map(
           clk            => clk_8ns,
           freq           => "0000",
           threshold_high => x"047868C0", -- 75000000
           threshold_low  => x"03B9ACA0", -- 62500000
           pwm_high       => red(0),
           pwm_low        => red(1)
);

generic_pwm1:generic_pwm
port map(
           clk            => clk_8ns,
           freq           => "0001",
           threshold_high => x"047868C0", -- 75000000
           threshold_low  => x"03B9ACA0", -- 62500000
           pwm_high       => red(2),
           pwm_low        => red(3)
);

generic_pwm2:generic_pwm
port map(
           clk            => clk_8ns,
           freq           => "0010",
           threshold_high => x"047868C0", -- 75000000
           threshold_low  => x"03B9ACA0", -- 62500000
           pwm_high       => red(4),
           pwm_low        => red(5)
);

end Behavioral;

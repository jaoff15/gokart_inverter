 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.NUMERIC_STD.all;


entity top is
    Port (  
            clk_8ns     : in  STD_LOGIC;
            sw          : in  std_logic_vector (3 downto 0);
            red         : out STD_LOGIC_VECTOR (7 downto 0);
            green       : out STD_LOGIC_VECTOR (7 downto 0);
            blue        : out STD_LOGIC_VECTOR (7 downto 0);
            row         : out STD_LOGIC_VECTOR (7 downto 0)
           );
end top;

architecture Behavioral of top is
    -- ************ Components ************
    -- Dual PWM generator
    component pwm_dual is
    Port (  
            clk             : in  std_logic;
            duty_cycle      : in  signed(10 downto 0);
            phase           : in  std_logic_vector(1 downto 0);
            pwm_high        : out std_logic;
            pwm_low         : out std_logic;
            pwm_high_middle : out std_logic;
            pwm_low_middle  : out std_logic
           );
    end component;
    
    -- Single PWM generator
    component pwm_single is
        Port ( 
                clk          : in  std_logic;
                duty_cycle   : in  signed(10 downto 0);
                phase        : in  std_logic_vector (10 downto 0);
                pwm          : out std_logic
               );
    end component;
    
    
    -- ************ Signals ************
    -- Clock prescaler
    signal prescaler        : unsigned(31 downto 0) := x"00000000";
    
    -- PWM freq
    signal pwm_freq         : std_logic;
begin

-- Set row
row <= "11111110";

-- Select PWM frequency dependign 
with sw select
    pwm_freq <=  prescaler(16) when "0000",
                 prescaler(15) when "0001", 
                 prescaler(14) when "0010", 
                 prescaler(13) when "0011",
                 prescaler(12) when "0100",
                 prescaler(11) when "0101", 
                 prescaler(10) when "0110", 
                 prescaler(9) when "0111",
                 prescaler(8) when "1000",
                 prescaler(7) when "1001", 
                 prescaler(6) when "1010", 
                 prescaler(5) when "1011",
                 prescaler(4) when "1100",
                 prescaler(3) when "1101", 
                 prescaler(2) when "1110", 
                 prescaler(1) when "1111";

prescaling_process:
process (clk_8ns)
begin
   if rising_edge(clk_8ns) then
        prescaler <= prescaler + 1;
   end if;
end process;

-- Phase 1. 0 degrees phase shift
pwm_dual0:pwm_dual
port map(
           clk            => pwm_freq,
           duty_cycle     => "00111110100", -- 50%
           phase          => "00",
           pwm_high       => red(0),
           pwm_low        => red(1),
           pwm_high_middle=> blue(0),
           pwm_low_middle => blue(1)
);

-- Phase 2. 120 degrees phase shift
pwm_dual1:pwm_dual
port map(
           clk            => pwm_freq,
           duty_cycle     => "00111110100", -- 50%
           phase          => "01",
           pwm_high       => red(2),
           pwm_low        => red(3),
           pwm_high_middle=> blue(2),
           pwm_low_middle => blue(3)
);

-- Phase 3. 240 degrees phase shift
pwm_dual2:pwm_dual
port map(
           clk            => pwm_freq,
           duty_cycle     => "00111110100", -- 50%
           phase          => "10",
           pwm_high       => red(4),
           pwm_low        => red(5),
           pwm_high_middle=> blue(4),
           pwm_low_middle => blue(5)
);


---- Single pwm
--pwm_single0:pwm_single
--port map(
--    clk          => pwm_freq,
--    duty_cycle   => "00111110100",
--    phase        => "00000000000",
--    pwm          => red(7)
--);
--pwm_single1:pwm_single
--port map(
--    clk          => pwm_freq,
--    duty_cycle   => "00111110100",
--    phase        => "01000000000",
--    pwm          => red(6)
--);

end Behavioral;

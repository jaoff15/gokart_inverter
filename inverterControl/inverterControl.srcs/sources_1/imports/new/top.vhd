 

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
    signal pwm_freq             : std_logic;
    signal duty_cycle_signal    : signed(10 downto 0);
begin

-- Set row
row <= "11111110";

--pwm_freq <= prescaler(0);

-- Select PWM frequency dependign 
with sw select
    duty_cycle_signal <=    "00000000000" when "0000",  -- 000
                            "00000011001" when "0001",  -- 25
                            "00000110010" when "0011",  -- 50
                            "00001001011" when "0111",  -- 75
                            "00001011111" when "1100",  -- 95
                            "00001011110" when "1110",  -- 94
                            "00001100100" when "1111",  -- 100
                            "00000000000" when others;

--prescaling_process:
--process (clk)
--begin
--   if rising_edge(clk) then
--        prescaler <= prescaler + 1;
--   end if;
--end process;

-- Phase 1. 0 degrees phase shift
pwm_dual0:pwm_dual
port map(
           clk            => clk,
           duty_cycle     => duty_cycle_signal, --"00111110100", -- 50%
           phase          => "00",
           pwm_high       => red(6),
           pwm_low        => red(4),
           pwm_high_middle=> green(6),
           pwm_low_middle => green(4)
);

-- Phase 2. 120 degrees phase shift
pwm_dual1:pwm_dual
port map(
           clk            => clk,
           duty_cycle     => duty_cycle_signal, -- 50%
           phase          => "01",
           pwm_high       => red(2),
           pwm_low        => red(0),
           pwm_high_middle=> green(2),
           pwm_low_middle => green(0)
);

---- Phase 3. 240 degrees phase shift
--pwm_dual2:pwm_dual
--port map(
--           clk            => pwm_freq,
--           duty_cycle     => "00111110100", -- 50%
--           phase          => "10",
--           pwm_high       => blue(6),
--           pwm_low        => green(5),
--           pwm_high_middle=> green(6),
--           pwm_low_middle => green(7)
--);



end Behavioral;

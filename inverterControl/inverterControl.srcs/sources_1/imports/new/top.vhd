 

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
    -- ************ Components ************
    -- Dual PWM generator
    component pwm_dual is
    Port (  
            clk             : in  STD_LOGIC;
            duty_cycle      : in  signed(10 downto 0);
            phase           : in  STD_LOGIC_VECTOR(1 downto 0);
            pwm_high        : out STD_LOGIC;
            pwm_low         : out STD_LOGIC
           );
    end component;
    
    -- Single PWM generator
    component pwm_single is
        Port ( 
                clk          : in  std_logic;
                duty_cycle   : in  signed(10 downto 0);
                phase        : in  std_logic_vector (1 downto 0);
                pwm          : out std_logic
               );
    end component;
    
    
    -- ************ Signals ************
    -- Clock prescaler
    signal prescaler       : unsigned(31 downto 0) := x"00000000";
begin

-- Set row
row <= "11111110";

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
           clk            => prescaler(16),
           duty_cycle     => "00111110100", -- 50%
           phase          => "00",
           pwm_high       => red(0),
           pwm_low        => red(1)
);

-- Phase 2. 120 degrees phase shift
pwm_dual1:pwm_dual
port map(
           clk            => prescaler(16),
           duty_cycle     => "00111110100", -- 50%
           phase          => "01",
           pwm_high       => red(2),
           pwm_low        => red(3)
);

-- Phase 3. 240 degrees phase shift
pwm_dual2:pwm_dual
port map(
           clk            => prescaler(16),
           duty_cycle     => "00111110100", -- 50%
           phase          => "10",
           pwm_high       => red(4),
           pwm_low        => red(5)
);


-- Single pwm
pwm_single0:pwm_single
port map(
    clk          => prescaler(15),
    duty_cycle   => "00111110100",
    phase        => "00",
    pwm          => red(7)
);

end Behavioral;

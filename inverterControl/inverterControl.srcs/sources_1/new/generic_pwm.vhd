

-- Module that makes a PWM

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity generic_pwm is
    Port ( clk            : in  STD_LOGIC;
           freq           : in  STD_LOGIC_VECTOR(3 downto 0);
           threshold_high : in  signed(31 downto 0);
           threshold_low  : in  signed(31 downto 0);
          -- phase          : in  STD_LOGIC;
           pwm_high       : out STD_LOGIC;
           pwm_low        : out STD_LOGIC);
end generic_pwm;

architecture Behavioral of generic_pwm is
    -- Clock frequency
    constant CLOCK_FREQ : signed(31 downto 0) := x"07735940"; -- 125000000kHz

    -- Counting directions
    constant UP   : STD_LOGIC := '1';
    constant DOWN : STD_LOGIC := '0';
    
    -- Output levels
    constant HIGH : STD_LOGIC := '1';
    constant LOW  : STD_LOGIC := '0';
    
    -- Counter limits. When the count reaches the limit. The counting direction is changed.
    constant COUNT_MAX : signed(31 downto 0) := x"07735940";
    constant COUNT_MIN : signed(31 downto 0) := x"00000000";
    
    -- Counting direction (up or down)
    signal dir : STD_LOGIC := UP;
    
    -- Counter amount. The amount by which the counter should increase
    signal counter_amount : signed(31 downto 0) := x"00000000";
    
    -- Counter that counts on every clock pulse 
    signal counter : signed(31 downto 0) := x"00000000";
    
    
begin


with freq select
    counter_amount <=   x"00000010" when "0000",
                        x"00000002" when "0001",
                        x"00000001" when others;


-- Counts on every clock pulse
counter_process:
process (clk)
begin
   if rising_edge(clk) then
        if dir = UP then
            -- Count up
            counter <= counter + counter_amount;
            
            -- If max is reached. Change direction
            if counter >= COUNT_MAX then
                dir <= DOWN;
            end if;
        elsif dir = DOWN then
            -- Count down
            counter <= counter - counter_amount;
            
            -- If min is reached. Change direction
            if counter <= COUNT_MIN then
                dir <= UP ;
            end if;
        else
        -- If en error occurs .Reset counter and direction
            dir     <= UP;
            counter <= x"00000000";
        end if;
   end if;
end process;




pwm_high_process:
process(counter)
begin
    -- If counter is under threshold. 
    -- Output: 0
    -- If counter is over threshold.
    -- Output: 1
    if (counter > threshold_high) then
        pwm_high <= HIGH;
    else
        pwm_high <= LOW;
    end if;
end process;

-- Process that controls the low side PWM.
pwm_low_process:
process(counter)
begin
    -- If counter is under threshold. 
    -- Output: 1
    -- If counter is over threshold.
    -- Output: 0
    if (counter < threshold_low) then
        pwm_low <= HIGH;
    else
        pwm_low <= LOW;
    end if;
end process;


end Behavioral;

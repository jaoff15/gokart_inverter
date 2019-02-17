

-- Module that makes a PWM

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity generic_pwm is
    Port ( clk            : in  STD_LOGIC;
           clk_freq 	  : in  signed(31 downto 0);
		   duty_cycle 	  : in  signed(31 downto 0);
           phase          : in  signed(2 downto 0);	-- 0 = 0degrees, 1 = 120 degrees, 2 = 240 degrees
           pwm_high       : out STD_LOGIC;
           pwm_low        : out STD_LOGIC);
end generic_pwm;

architecture Behavioral of generic_pwm is
    -- Clock frequency
    --constant CLOCK_FREQ : signed(31 downto 0) := x"07735940"; -- 125000000kHz

    -- Counting directions
    constant DOWN : STD_LOGIC := '0';
	constant UP   : STD_LOGIC := '1';
    
    -- Output levels
    constant HIGH : STD_LOGIC := '1';
    constant LOW  : STD_LOGIC := '0';
	
	-- Deadtime
	constant DEADTIME  : signed(31 downto 0) := x"00000005"; 
    
    -- Counter limits. When the count reaches the limit. The counting direction is changed.
    signal COUNT_MAX : signed(31 downto 0) := x"07735940";
    constant COUNT_MIN : signed(31 downto 0) := x"00000000";
    
    -- Counting direction (up or down)
    signal dir : STD_LOGIC := NONE_INITIALIZED;
    
    -- Counter amount. The amount by which the counter should increase
    signal counter_amount : signed(31 downto 0) := x"00000000";
    
    -- Counter that counts on every clock pulse 
    signal counter : signed(31 downto 0);
    
    -- Threshold
	signal threshold : signed(31 downto 0);
	-- Phase contribution
	signal phase_contribution : signed(31 downto 0);
begin

-- Set the counting max to the clock frequency/2
COUNT_MAX(31 downto 1) <= clk_freq(30 downto 0);

-- Find thresholds
threshold_high <= clk_freq * duty_cycle;
threshold_low  <= threshold_high - DEADTIME;




-- Counts on every clock pulse
counter_process:
process (clk)
begin
   if rising_edge(clk) then
		if dir = UP then
            -- Count up
            counter <= counter + 1;
            
            -- If max is reached. Change direction
            if counter >= COUNT_MAX then
                dir <= DOWN;
            end if;
        elsif dir = DOWN then
            -- Count down
            counter <= counter - 1;
            
            -- If min is reached. Change direction
            if counter <= COUNT_MIN then
				-- Phase contribution
				phase_contribution <= ( phase * 120 ) * COUNT_MAX;
				
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

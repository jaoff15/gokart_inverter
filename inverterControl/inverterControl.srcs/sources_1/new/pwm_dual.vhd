
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Duty cycles
-- Percent   Decimal   Input to module
--  1%      = 0.010   =  1
--  10%     = 0.100   =  10
--  50%     = 0.500   =  50
--  100%    = 1.000   =  100

-- PWM frequency
-- 0Hz --> 125MHz/2000 = 62.5kHz

entity pwm_dual is
    Port ( clk            : in  std_logic;                              -- Input clock
		   duty_cycle 	  : in  signed(10 downto 0);                    -- duty_cycle*100. 501 => 0.501 = 50.1%
           phase          : in  std_logic_vector(1 downto 0) := "00";   -- 0 = 0degrees, 1 = 120 degrees, 2 = 240 degrees
           pwm_high       : out std_logic;                              -- Output PWM high signal
           pwm_low        : out std_logic;                              -- Output PWM low signal
           pwm_high_middle: out std_logic;                              -- Outputs a pulse on the middle of the high-side PWM
           pwm_low_middle : out std_logic                               -- Outputs a pulse on the middle of the low-side PWM
           );
end pwm_dual;

architecture Behavioral of pwm_dual is
    -- Counting directions
    constant DOWN 				: std_logic_vector 	     := "00";
	constant UP   				: std_logic_vector	     := "01";
	constant UNINITIALIZED		: std_logic_vector 		 := "10";
    
    -- Output levels
    constant HIGH 				: std_logic 			 := '1';
    constant LOW  				: std_logic 			 := '0';
   
	-- Deadtime
	constant DEADTIME  			: signed(10 downto 0)    := "00000000100";   -- 1/(Clk/2000)*deadtime = actual deadtime [s]
	signal   HALF_DEADTIME      : signed(10 downto 0)    := "00000000000";
    
    -- Counter limits. When the count reaches the limit. The counting direction is changed.
    constant COUNT_MAX 			: signed(10 downto 0)    := "00001100100";      -- 100
    constant COUNT_MIN 			: signed(10 downto 0)    := "00000000000";      -- 0
	
    -- Counter that counts on every clock pulse 
    signal counter 				: signed(10 downto 0)    := "00000000000";
    
    -- Thresholds for PWM outputs
	signal threshold_high 		: signed(10 downto 0)    := "00000000000";
	signal threshold_low  		: signed(10 downto 0)    := "00000000000";

    -- Counting direction (up or down)
    signal dir 					: std_logic_vector(1 downto 0) := UNINITIALIZED;
   
begin

HALF_DEADTIME(9 downto 0) <= DEADTIME(10 downto 1);

-- Find thresholds

threshold_high <= duty_cycle - HALF_DEADTIME when (duty_cycle - HALF_DEADTIME <= COUNT_MAX) else COUNT_MIN;

threshold_low  <= duty_cycle + HALF_DEADTIME when (duty_cycle + HALF_DEADTIME >= COUNT_MIN) else COUNT_MAX;




-- Counts on every clock pulse
counter_process:
process (clk, counter)
begin
    if rising_edge(clk) then
        -- Initialize the counter with a phase and a counting direction
        if dir = UNINITIALIZED then
            -- 00 => 0 degrees phase shift. Add 0 degrees
            if phase = "00" then
                counter <= "00000000000";
                dir <= UP;
            
            -- 01 => 120 degrees of phase shift. Add 120 degrees
            elsif phase = "01" then
--                counter <= x"0000029A";  -- COUNT_MAX*3/3 = 67
                counter <= "00001000011";  -- COUNT_MAX*3/3 = 67
                dir <= UP;
            
            -- 10 => 240 degrees of phase shift. Add 240 degrees of phase shift
            elsif phase = "10" then
--                counter <= x"0000014D"; -- (COUNT_MAX*2/(2/3))-COUNT_MAX = 33
                counter <= "00000100001"; -- (COUNT_MAX*2/(2/3))-COUNT_MAX = 33
                dir <= DOWN;
            end if;
        end if;
        
        -- Count up
        if dir = UP then
            counter <= counter + 1;
        end if;
        
        -- Count down
        if dir = DOWN then
            counter <= counter - 1;
        end if;
        
        -- Change the counting direction if a counting limit is reached
        -- The counter limits has a buffer of 1 so that the limit is reached in the same scan where the signal actually hits the 
        -- limit. Otherwise this is delayed one cycle due to the delay between assigning a value to a signal and the
        -- Value actually being written to the signal
        -- If minimum limit is reached. Change direction
        if counter <= COUNT_MIN + x"00000001" then
            dir <= UP;
        end if;
       
        -- If maximum limit is reached. Change direction
        if counter >= COUNT_MAX - x"00000001" then
            dir <= DOWN;
        end if;    
    end if;
end process;


-- Control of the high side PWM
-- If counter is over threshold.
-- Output: 0
-- If counter is under threshold. 
-- Output: 1
pwm_high <= LOW when (counter >= threshold_high) else HIGH;

-- Control of the low side PWM
-- If counter is under threshold. 
-- Output: 0
-- If counter is over threshold.
-- Output: 1
pwm_low  <= LOW when (counter <= threshold_low) else HIGH;


-- Output a pulse in the middle of the high PWM signal
pwm_high_middle <= HIGH when (counter >= COUNT_MAX) else LOW;

-- Output a pulse in the middle of the low PWM signal
pwm_low_middle <= HIGH when (counter <= COUNT_MIN) else LOW;


end Behavioral;

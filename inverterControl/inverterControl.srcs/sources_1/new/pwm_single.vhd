
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- This module can generate a single PWM output
-- The outputtet pwm will have the frequency of the input scaled with by 1000.
-- pwm_freq = clk / 1000;
-- 
--
entity pwm_single is
    Port ( 
            clk          : in  std_logic;                       -- Input clock
            duty_cycle   : in  signed(10 downto 0);             -- Duty cycle. 0.1% = 1, 50% = 500, 99.8% = 998
            phase        : in  signed (10 downto 0);            -- Phase shift [degrees/1000]
            pwm          : out std_logic                        -- PWM output
           );
end pwm_single;

architecture Behavioral of pwm_single is
    -- Counting states.
	constant UP   				: std_logic_vector	    := "01";
	constant UNINITIALIZED		: std_logic_vector 		:= "10";
    
    -- Output levels on the PWM
    constant HIGH 				: std_logic 			 := '1';
    constant LOW  				: std_logic 			 := '0';
    
    -- Counter limits. When the count reaches the limit reset back down
    constant COUNT_MAX 			: signed(31 downto 0)    := x"000003E8";      -- 1,000
    constant COUNT_MIN 			: signed(31 downto 0)    := x"00000000";      -- 0
    
    -- Counting state (up or uninitialized)
    signal state 				: std_logic_vector(1 downto 0) := UNINITIALIZED;
    
    -- Counter that counts on every clock pulse 
    signal counter 				: signed(31 downto 0) := x"00000000";
    
    -- Threshold  change between high and low in the pwm
	signal threshold 		    : signed(31 downto 0) := x"00000000";

begin

-- Set threshold for PWM to go high
threshold(10 downto 0) <= duty_cycle;


-- Counter process. Counts up to a max value and resets back down.
counter_process:
process (clk, counter)
begin
    if rising_edge(clk) then
        if state = UNINITIALIZED then
            -- Set conter start value
            counter(10 downto 0) <= phase;
            -- Set state to counting up
            state <= UP;
        end if;
           
        -- Count up
        if state = UP then
            counter <= counter + 1;
        end if;
        
        
        
        
       -- Change the counting direction if the counting limit is reached
       if counter >= COUNT_MAX then
            counter <= COUNT_MIN;
        end if;  
    end if;
end process;



-- Control of the PWM.
-- If counter is over threshold.
-- Output: 1
-- If counter is under threshold. 
-- Output: 0
pwm <= HIGH when (counter > threshold) else LOW; 


end Behavioral;

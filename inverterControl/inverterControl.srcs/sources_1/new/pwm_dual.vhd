

-- Module that makes a PWM

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Duty cycles
-- Percent   Decimal   Input to module
--  1%      = 0.010   =  10
--  10%     = 0.100   =  100
--  50%     = 0.500   =  500
--  100%    = 1.000   =  1000

-- PWM frequency
-- 0Hz --> 125MHz/1000 = 125kHz

entity pwm_dual is
    Port ( clk            : in  std_logic;                              -- Input clock
		   duty_cycle 	  : in  signed(10 downto 0);                    -- duty_cycle*1000 => 50.1% = 0.501 = 501
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
	constant DEADTIME  			: signed(10 downto 0)    := "00000000101";   -- 1/(Clk/1000)*deadtime = actual deadtime [s]
    
    -- Counter limits. When the count reaches the limit. The counting direction is changed.
    constant COUNT_MAX 			: signed(31 downto 0)    := x"000003E8";      -- 1,000
    constant COUNT_MIN 			: signed(31 downto 0)    := x"00000000";      -- 0
	
	-- 120 degrees phase shift
	constant PHASE_120DEGREES	: signed(15 downto 0) 	 := x"029A";          -- (COUNT_MAX*2)/3 = 666
 
    -- Counter that counts on every clock pulse 
    signal counter 				: signed(31 downto 0)    := x"00000000";
    
    -- Thresholds for PWM outputs
	signal threshold_high 		: signed(31 downto 0)    := x"00000000";
	signal threshold_low  		: signed(31 downto 0)    := x"00000000";

    -- Counting direction (up or down)
    signal dir 					: std_logic_vector(1 downto 0) := UNINITIALIZED;
begin

---- Find thresholds
threshold_high(10 downto 0) <= duty_cycle;
threshold_low(10 downto 0)  <= threshold_high(10 downto 0) - DEADTIME;


-- Counts on every clock pulse
counter_process:
process (clk, counter)
begin
    if rising_edge(clk) then
        -- If direction is uninitialized then initialize it by giving it the offset specified by the phase inputtet to the module.
        if dir = UNINITIALIZED then
            dir <= UP;
            if phase = "00" then
                -- 00 => 0 degrees phase shift. Add 0 degrees
                counter <= x"00000000";
            elsif phase = "01" then
                -- 01 => 120 degrees of phase shift. Add 120 degrees
                counter <= x"0000029A";  -- COUNT_MAX*3/3 = 666
            elsif phase = "10" then
                -- 10 => 240 degrees of phase shift. Add 240 degrees of phase shift
                counter <= x"0000014D"; -- (COUNT_MAX*2/(2/3))-COUNT_MAX = 333
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
        
        -- Check counter limits and control the PWM signal pulses 
        pwm_low_middle <= LOW;
        if counter <= COUNT_MIN then
            -- If min is reached. Change direction
            dir <= UP;
            pwm_low_middle <= HIGH;
        end if;
        
        pwm_high_middle <= LOW;
        if counter >= COUNT_MAX then
            -- If max is reached. Change direction
            dir <= DOWN;
            pwm_high_middle <= HIGH;
        end if;   
            
    end if;
end process;



-- Process that controls the PWMs.
pwm_high_process:
process(counter)
begin
        -- If counter is over threshold.
        -- Output: 1
        -- If counter is under threshold. 
        -- Output: 0
        if (counter > threshold_high) then
            pwm_high <= HIGH;
         else
            pwm_high <= LOW;
        end if;
        
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



-- Module that makes a PWM

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Duty cycles
-- Percent   Decimal   Input to module
--  1%      = 0.010   =  10
--  10%     = 0.100   =  100
--  100%    = 1.000   =  1000

entity pwm is
    Port ( clk            : in  STD_LOGIC;
		   duty_cycle 	  : in  signed(10 downto 0);                   -- duty_cycle*1000 => 50.1% = 0.501 = 501
           phase          : in  STD_LOGIC_VECTOR(1 downto 0) := "00";  -- 0 = 0degrees, 1 = 120 degrees, 2 = 240 degrees
           pwm_high       : out STD_LOGIC;
           pwm_low        : out STD_LOGIC
           );
end pwm;

architecture Behavioral of pwm is
    -- Counting directions
    constant DOWN 				: STD_LOGIC_VECTOR 	    := "00";
	constant UP   				: STD_LOGIC_VECTOR	    := "01";
	constant UNINITIALIZED		: STD_LOGIC_VECTOR 		:= "10";
    
    -- Output levels
    constant HIGH 				: STD_LOGIC 			 := '1';
    constant LOW  				: STD_LOGIC 			 := '0';
   
	-- Deadtime
	constant DEADTIME  			: signed(10 downto 0)   := "00000000101"; 
    
    -- Counter limits. When the count reaches the limit. The counting direction is changed.
    constant COUNT_MAX 			: signed(31 downto 0)    := x"000003E8";      -- 1,000
    constant COUNT_MIN 			: signed(31 downto 0)    := x"00000000";      -- 0
	
	-- 120 degrees phase shift
	constant PHASE_120DEGREES	: signed(15 downto 0) 	 := x"029A";       -- (COUNT_MAX*2)/3 = 666
	
    
    -- Counting direction (up or down)
    signal dir 					: STD_LOGIC_VECTOR(1 downto 0) := UNINITIALIZED;
--    signal dir 					: STD_LOGIC_VECTOR(1 downto 0) := UP;
    
    -- Counter that counts on every clock pulse 
    signal counter 				: signed(31 downto 0) := x"00000000";
    
    -- Thresholds
	signal threshold_high 		: signed(31 downto 0) := x"00000000";
	signal threshold_low  		: signed(31 downto 0) := x"00000000";

begin

---- Find thresholds
threshold_high(10 downto 0) <= duty_cycle;
threshold_low(10 downto 0)  <= threshold_high(10 downto 0) - DEADTIME;


-- Counts on every clock pulse
counter_process:
process (clk, counter)
begin
    if rising_edge(clk) then
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
        elsif dir = UP then
            -- Count up
            counter <= counter + 1;
        end if;
        if dir = DOWN then
            -- Count down
            counter <= counter - 1;    
        end if;
        
        -- Check counter limits
        if counter <= COUNT_MIN then
            -- If min is reached. Change direction
            dir <= UP;
        end if;
        if counter >= COUNT_MAX then
            -- If max is reached. Change direction
            dir <= DOWN;
        end if;   
            
    end if;
end process;



-- Process that controls the PWMs.
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity pwm_single is
    Port ( 
            clk          : in  std_logic;
            duty_cycle   : in  signed(10 downto 0);
            phase        : in  std_logic_vector (1 downto 0);
            pwm          : out std_logic
           );
end pwm_single;

architecture Behavioral of pwm_single is
    -- Counting directions
	constant UP   				: std_logic_vector	    := "01";
	constant UNINITIALIZED		: std_logic_vector 		:= "10";
    
    -- Output levels
    constant HIGH 				: std_logic 			 := '1';
    constant LOW  				: std_logic 			 := '0';
    
    -- Counter limits. When the count reaches the limit reset back down
    constant COUNT_MAX 			: signed(31 downto 0)    := x"000003E8";      -- 1,000
    constant COUNT_MIN 			: signed(31 downto 0)    := x"00000000";      -- 0
    
    -- Counting (up or uninitialized)
    signal dir 					: std_logic_vector(1 downto 0) := UNINITIALIZED;
    
    -- Counter that counts on every clock pulse 
    signal counter 				: signed(31 downto 0) := x"00000000";
    
    -- Threshold
	signal threshold 		    : signed(31 downto 0) := x"00000000";
begin

-- Threshold
threshold(10 downto 0) <= duty_cycle;

counter_process:
process (clk, counter)
begin
    if rising_edge(clk) then
        if dir = UNINITIALIZED then
            -- Set conter start value
            counter <= x"00000000";
            -- Begin counting up
            dir <= UP;
           
        elsif dir = UP then
            -- Count up
            counter <= counter + 1;
        end if;

        
        -- Check counter limits
        if counter >= COUNT_MAX then
            counter <= COUNT_MIN;
        end if;   
            
    end if;
end process;


-- Process that controls the PWM.
pwm_process:
process(counter)
begin
        -- If counter is over threshold.
        -- Output: 1
        -- If counter is under threshold. 
        -- Output: 0
        if (counter > threshold) then
            pwm <= HIGH;
         else
            pwm <= LOW;
        end if;
end process;

end Behavioral;

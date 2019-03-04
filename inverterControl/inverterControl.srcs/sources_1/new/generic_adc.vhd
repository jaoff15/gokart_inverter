library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
USE ieee.std_logic_unsigned.all;

Library UNISIM;
use UNISIM.vcomponents.all;

entity generic_adc is
    Port ( clk_8ns       : in  STD_LOGIC;
           led          : out STD_LOGIC_VECTOR (3 downto 0);
           xa_p         : in STD_LOGIC_VECTOR (3 downto 0); 
           xa_n         : in  STD_LOGIC_VECTOR (3 downto 0));
end generic_adc;

architecture Behavioral of generic_adc is
    signal reading : std_logic_vector(15 downto 0) := (others => '0');
    signal muxaddr : std_logic_vector( 4 downto 0) := (others => '0');
    signal channel : std_logic_vector( 4 downto 0) := (others => '0');
    signal vauxn   : std_logic_vector(15 downto 0) := (others => '0');
    signal vauxp   : std_logic_vector(15 downto 0) := (others => '0');  
begin

process(clk_8ns, reading)
begin
    if reading(2) = '1' then
        led(0) <= '1';
    end if;
    if reading(5) = '1' then
        led(1) <= '1';
    end if;
    if reading(8) = '1' then
        led(2) <= '1';
    end if;
    if reading(11) = '1' then
        led(3) <= '1';
    end if;
end process;
    

               
    -----------------------------------
    -- Pass through the analogue inputs
    -----------------------------------
    vauxp(14) <= xa_p(0);  vauxn(14) <= xa_n(0);
    vauxp(7)  <= xa_p(1);  vauxn(7)  <= xa_n(1);
    vauxp(15) <= xa_p(2);  vauxn(15) <= xa_n(2);
    vauxp(6)  <= xa_p(3);  vauxn(6)  <= xa_n(3);
     
XADC_inst : XADC generic map (
      -- INIT_40 - INIT_42: XADC configuration registers
      INIT_40 => X"9000", -- averaging of 16 selected for external channels
      INIT_41 => X"2ef0", -- Continuous Seq Mode, Disable unused ALMs, Enable calibration
      INIT_42 => X"0800", -- ACLK = DCLK/8 = 100MHz / 8 = 12.5 MHz 
      -- INIT_48 - INIT_4F: Sequence Registers
      INIT_48 => X"4701", -- CHSEL1 - enable Temp VCCINT, VCCAUX, VCCBRAM, and calibration
      INIT_49 => X"000CC", -- CHSEL2 - enable aux analog channels 6,7,14,15
      INIT_4A => X"0000", -- SEQAVG1 disabled all channels
      INIT_4B => X"0000", -- SEQAVG2 disabled all channels
      INIT_4C => X"0000", -- SEQINMODE0 - The lowest 16 channels are bipolar
      INIT_4D => X"00CC", -- SEQINMODE1 - Channels 6, 7, 14 & 15 are unipolar
      INIT_4E => X"0000", -- SEQACQ0 - No extra settling time all channels
      INIT_4F => X"0000", -- SEQACQ1 - No extra settling time all channels
      -- INIT_50 - INIT_58, INIT5C: Alarm Limit Registers
      INIT_50 => X"b5ed", -- Temp upper alarm trigger 85°C
      INIT_51 => X"5999", -- Vccint upper alarm limit 1.05V
      INIT_52 => X"A147", -- Vccaux upper alarm limit 1.89V
      INIT_53 => X"dddd", -- OT upper alarm limit 125°C - see Thermal Management
      INIT_54 => X"a93a", -- Temp lower alarm reset 60°C
      INIT_55 => X"5111", -- Vccint lower alarm limit 0.95V
      INIT_56 => X"91Eb", -- Vccaux lower alarm limit 1.71V
      INIT_57 => X"ae4e", -- OT lower alarm reset 70°C - see Thermal Management
      INIT_58 => X"5999", -- VCCBRAM upper alarm limit 1.05V
      INIT_5C => X"5111", -- VCCBRAM lower alarm limit 0.95V

      -- Simulation attributes: Set for proper simulation behavior
      SIM_DEVICE       => "7SERIES",    -- Select target device (values)
      SIM_MONITOR_FILE => "design.txt"  -- Analog simulation data file name
   ) port map (
      -- ALARMS: 8-bit (each) output: ALM, OT
      ALM          => open,             -- 8-bit output: Output alarm for temp, Vccint, Vccaux and Vccbram
      OT           => open,             -- 1-bit output: Over-Temperature alarm

      -- STATUS: 1-bit (each) output: XADC status ports
      BUSY         => open,             -- 1-bit output: ADC busy output
      CHANNEL      => channel,          -- 5-bit output: Channel selection outputs
      EOC          => open,             -- 1-bit output: End of Conversion
      EOS          => open,             -- 1-bit output: End of Sequence
      JTAGBUSY     => open,             -- 1-bit output: JTAG DRP transaction in progress output
      JTAGLOCKED   => open,             -- 1-bit output: JTAG requested DRP port lock
      JTAGMODIFIED => open,             -- 1-bit output: JTAG Write to the DRP has occurred
      MUXADDR      => muxaddr,          -- 5-bit output: External MUX channel decode
      
      -- Auxiliary Analog-Input Pairs: 16-bit (each) input: VAUXP[15:0], VAUXN[15:0]
      VAUXN        => vauxn,            -- 16-bit input: N-side auxiliary analog input
      VAUXP        => vauxp,            -- 16-bit input: P-side auxiliary analog input
      
      -- CONTROL and CLOCK: 1-bit (each) input: Reset, conversion start and clock inputs
      CONVST       => '0',              -- 1-bit input: Convert start input
      CONVSTCLK    => '0',              -- 1-bit input: Convert start input
      RESET        => '0',              -- 1-bit input: Active-high reset
      
      -- Dedicated Analog Input Pair: 1-bit (each) input: VP/VN
      VN           => '0', -- 1-bit input: N-side analog input
      VP           => '0', -- 1-bit input: P-side analog input
      
      -- Dynamic Reconfiguration Port (DRP) -- hard set to read channel 15 (XADC7/XADC3)
      DO           => reading,
      DRDY         => open,
      DADDR        => "0011111",  -- The address for reading AUX channel 15
      DCLK         => clk_8ns,
      DEN          => '1',
      DI           => (others => '0'),
      DWE          => '0'
   );

end Behavioral;

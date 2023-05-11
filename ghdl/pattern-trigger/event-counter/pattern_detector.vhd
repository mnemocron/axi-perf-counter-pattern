----------------------------------------------------------------------------------
-- Company:        
-- Engineer:       simon.burkhardt
-- 
-- Create Date:    2023-04-21
-- Design Name:    AXIS pattern_detector
-- Module Name:    tb_skid - bh
-- Project Name:   
-- Target Devices: 
-- Tool Versions:  GHDL 0.37
-- Description:    bidirectional AXIS pipeline register
-- 
-- Dependencies:   
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pattern_detector is
  generic (
    -- Users to add parameters here

    -- User parameters ends
    -- Do not modify the parameters beyond this line

    -- Width of S_AXIS address bus. The slave accepts the read and write addresses of width C_S_AXIS_TDATA_WIDTH.
    C_S_AXIS_TDATA_WIDTH  : integer := 512;
    C_COMPARE_DATA_WIDTH  : integer := 32
  );
  port (
    -- Users to add ports here

    -- User ports ends
    -- Global ports
    AXIS_ACLK       : in std_logic;
    AXIS_ARESETN    : in  std_logic;

    -- Slave Stream Ports. TVALID indicates that the master is driving a valid transfer, A transfer takes place when both TVALID and TREADY are asserted. 
    S_AXIS_TVALID   : in  std_logic;
    -- TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
    S_AXIS_TDATA    : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
    -- TREADY indicates that the slave can accept a transfer in the current cycle.
    S_AXIS_TREADY   : in  std_logic;
    
    compare_pattern : in std_logic_vector(C_COMPARE_DATA_WIDTH-1 downto 0);

    match_out       : out std_logic
  );
end pattern_detector;

architecture arch_imp of pattern_detector is

  constant C_NUM_DATA_BYTES : integer  := (C_S_AXIS_TDATA_WIDTH/8);
  constant C_NUM_COMP_BYTES : integer  := (C_COMPARE_DATA_WIDTH/8);
  constant C_NUM_COMPARISONS : integer := (C_NUM_DATA_BYTES - C_NUM_COMP_BYTES +1);

  -- signals
  signal aclk    : std_logic;
  signal aresetn : std_logic;

  signal i_s_axis_tvalid : std_logic := '0';
  signal i_s_axis_tdata  : std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
  signal i_s_axis_tready : std_logic;
  signal i_pattern       : std_logic_vector(C_COMPARE_DATA_WIDTH-1 downto 0);

  signal o_match_out     : std_logic;
  signal match_accumulator : std_logic_vector(C_NUM_COMPARISONS-1 downto 0);

begin
  -- I/O connections assignments
  aclk    <= AXIS_ACLK;
  aresetn <= AXIS_ARESETN;

  -- inputs
  i_s_axis_tready <= S_AXIS_TREADY;
  i_s_axis_tvalid <= S_AXIS_TVALID;
  i_s_axis_tdata  <= S_AXIS_TDATA;
  i_pattern <= compare_pattern;

  -- outputs
  match_out <= o_match_out;

  gen_alligned_pattern_detect : for ii in 0 to (C_NUM_COMPARISONS-1) generate
    p_compare : process(aclk)
    begin
      if rising_edge(aclk) then
        if aresetn = '0' then
          match_accumulator(ii) <= '0';
        else
          if i_s_axis_tvalid = '1' and i_s_axis_tready = '1' then
            if i_s_axis_tdata( (ii)*8-1 + C_COMPARE_DATA_WIDTH  downto ii*8 ) = i_pattern then 
              match_accumulator(ii) <= '1';
            else
              match_accumulator(ii) <= '0';
            end if;
          else
            match_accumulator(ii) <= '0';
          end if;
        end if;
      end if;
    end process;
  end generate gen_alligned_pattern_detect;

  p_final_decision : process(aclk)
  begin
    if rising_edge(aclk) then
      if aresetn = '0' then
        o_match_out <= '0';
      else
        if unsigned(match_accumulator) = 0 then
          o_match_out <= '0';
        else 
          o_match_out <= '1';
        end if;
      end if;
    end if;
  end process;

end arch_imp;

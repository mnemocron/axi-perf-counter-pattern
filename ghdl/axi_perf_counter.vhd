----------------------------------------------------------------------------------
-- Company:        
-- Engineer:       simon.burkhardt
-- 
-- Create Date:    2023-04-21
-- Design Name:    axi_perf_counter
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

entity axi_perf_counter is
  generic (
    -- Users to add parameters here

    -- User parameters ends
    -- Do not modify the parameters beyond this line

    C_S_AXI_ADDR_WIDTH   : integer := 32;
    C_S_AXI_DATA_WIDTH   : integer := 32;
    C_S_AXIS_TDATA_WIDTH : integer := 512;
    C_COMPARE_DATA_WIDTH : integer := 32

  );
  port (
    -- Users to add ports here

    -- User ports ends
    -- Global ports
    S_AXI_ACLK     : in std_logic;
    S_AXI_ARESETN  : in std_logic;

    S_AXI_ARADDR  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_ARVALID : in  std_logic;
    S_AXI_ARREADY : out std_logic;

    S_AXI_RDATA   : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_RVALID  : out std_logic;
    S_AXI_RREADY  : in  std_logic;
    S_AXI_RRESP   : out std_logic;

    S_AXI_AWADDR  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_AWVALID : in  std_logic;
    S_AXI_AWREADY : out std_logic;

    S_AXI_WDATA   : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_WVALID  : in  std_logic;
    S_AXI_WREADY  : out std_logic;

    S_AXI_BRESP   : out std_logic_vector(1 downto 0);
    S_AXI_BVALID  : out std_logic;
    S_AXI_BREADY  : in  std_logic;

    -- AXIS Start
    start_axis_tvalid : in  std_logic;
    start_axis_tdata  : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
    start_axis_tvalid : in  std_logic;

    -- AXIS Stop
    stop_axis_tvalid  : in  std_logic;
    stop_axis_tdata   : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
    stop_axis_tvalid  : in  std_logic;

    trg_start    : in std_logic;
    trg_stop_c0  : in std_logic;
    trg_stop_c1  : in std_logic;

  );
end axi_perf_counter;

architecture arch_imp of axi_perf_counter is

  component pattern_detector is
    generic (
      C_S_AXIS_TDATA_WIDTH  : integer := 512;
      C_COMPARE_DATA_WIDTH  : integer := 32
    );
    port (
      AXIS_ACLK       : in  std_logic;
      AXIS_ARESETN    : in  std_logic;
      S_AXIS_TVALID   : in  std_logic;
      S_AXIS_TDATA    : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
      M_AXIS_TREADY   : in  std_logic;
      compare_pattern : in  std_logic_vector(C_COMPARE_DATA_WIDTH-1 downto 0);
      match_out       : out std_logic
    );
  end component;

  -- signals
  signal aclk    : std_logic;
  signal aresetn : std_logic;

  signal axi_reg_pattern  : std_logic_vector(31 downto 0);
  signal axi_reg_counter  : std_logic_vector(31 downto 0);

  signal en_count      : std_logic;

  signal trg_start : std_logic;
  signal trg_stop  : std_logic;

  signal i_axi_aclk    : std_logic;
  signal i_axi_aresetn : std_logic;
  signal i_axi_araddr  : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
  signal i_axi_arvalid : std_logic;
  signal o_axi_arready : std_logic;
  signal o_axi_rdata   : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal o_axi_rvalid  : std_logic;
  signal i_axi_rready  : std_logic;
  signal o_axi_rresp   : std_logic;
  signal i_axi_awaddr  : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
  signal i_axi_awvalid : std_logic;
  signal o_axi_awready : std_logic;
  signal i_axi_wdata   : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal i_axi_wvalid  : std_logic;
  signal o_axi_wready  : std_logic;
  signal o_axi_bresp   : std_logic_vector(1 downto 0);
  signal o_axi_bvalid  : std_logic;
  signal i_axi_bready  : std_logic;

  signal i_start_axis_tvalid : std_logic;
  signal i_start_axis_tdata  : std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
  signal i_start_axis_tready : std_logic;
  signal i_stop_axis_tvalid  : std_logic;
  signal i_stop_axis_tdata   : std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
  signal i_stop_axis_tready  : std_logic;

begin
  -- I/O connections assignments
  aclk    <= AXI_ACLK;
  aresetn <= AXIS_ARESETN;

  -- inputs
  i_axi_araddr  <=  S_AXI_ARADDR;
  i_axi_arvalid <=  S_AXI_ARVALID;
  i_axi_rready  <=  S_AXI_RREADY;  
  i_axi_awaddr  <=  S_AXI_AWADDR;
  i_axi_awvalid <=  S_AXI_AWVALID;
  i_axi_wdata   <=  S_AXI_WDATA;
  i_axi_wvalid  <=  S_AXI_WVALID;
  i_axi_bready  <=  S_AXI_BREADY;

  i_start_axis_tvalid <= start_axis_tvalid;
  i_start_axis_tdata  <= start_axis_tdata;
  i_stop_axis_tvalid  <= stop_axis_tvalid;
  i_stop_axis_tdata   <= stop_axis_tdata;

  -- outputs
  S_AXI_ARREADY <= o_axi_arready;
  S_AXI_RDATA   <= o_axi_rdata;
  S_AXI_RVALID  <= o_axi_rvalid;
  S_AXI_RRESP   <= o_axi_rresp;
  S_AXI_AWREADY <= o_axi_awready;
  S_AXI_WREADY  <= o_axi_wready;
  S_AXI_BRESP   <= o_axi_bresp;
  S_AXI_BVALID  <= o_axi_bvalid;

-- TODO features
-- axi lite R/W access to both registers

  p_axi_read : process(aclk)
  begin
    if rising_edge(aclk) then
      if aresetn = '0' then
        o_axi_rdata  <= (others => '0');
        o_axi_rvalid <= '0';
      else

      end if;
    end if;
  end process;
  
  p_axi_write : process(aclk)
  begin
    if rising_edge(aclk) then
      if aresetn = '0' then
        o_s_axi_wready <= '0';
      else
      end if;
    end if;
  end process;

  p_counter : process(aclk)
  begin
    if rising_edge(aclk) then
      if aresetn = '0' then
      else
        if en_count_c0 = '1' then
          axi_reg_counter_c0 <= std_logic_vector( unsigned(axi_reg_counter_c0) + 1);
        else
          axi_reg_counter_c0 <= axi_reg_counter_c0;
        end if;

        if en_count_c1 = '1' then
          axi_reg_counter_c1 <= std_logic_vector( unsigned(axi_reg_counter_c1) + 1);
        else
          axi_reg_counter_c1 <= axi_reg_counter_c1;
        end if;
      end if;
    end if;
  end process;

  pattern_detector_start : pattern_detector
    generic map (
      C_S_AXIS_TDATA_WIDTH  => C_S_AXIS_TDATA_WIDTH,
      C_COMPARE_DATA_WIDTH  => C_COMPARE_DATA_WIDTH
    )
    port map (
      AXIS_ACLK      => aclk,
      AXIS_ARESETN   => aresetn,
      S_AXIS_TVALID   => i_start_axis_tvalid,
      S_AXIS_TDATA    => i_start_axis_tdata,
      M_AXIS_TREADY   => i_start_axis_tready,
      compare_pattern => axi_reg_pattern,
      match_out       => trg_start
    );

  pattern_detector_stop : pattern_detector
    generic map (
      C_S_AXIS_TDATA_WIDTH  => C_S_AXIS_TDATA_WIDTH,
      C_COMPARE_DATA_WIDTH  => C_COMPARE_DATA_WIDTH
    )
    port map (
      AXIS_ACLK      => aclk,
      AXIS_ARESETN   => aresetn,
      S_AXIS_TVALID   => i_stop_axis_tvalid,
      S_AXIS_TDATA    => i_stop_axis_tdata,
      M_AXIS_TREADY   => i_stop_axis_tready,
      compare_pattern => axi_reg_pattern,
      match_out       => trg_stop
    );

end arch_imp;

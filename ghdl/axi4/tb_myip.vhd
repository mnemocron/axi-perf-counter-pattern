----------------------------------------------------------------------------------
-- Company:        
-- Engineer:       simon.burkhardt
-- 
-- Create Date:    2023-05-11
-- Design Name:    AXI4 pattern trigger testbench
-- Module Name:    tb_myip - bh
-- Project Name:   
-- Target Devices: 
-- Tool Versions:  GHDL 0.37
-- Description:    
-- 
-- Dependencies:   
-- 
-- Revision:
-- Revision 0.1 - design created, verified with testbench
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- this testbench acts as a streaming master, sending bursts of data
-- counting from 1-4, also asserting tlast on the 4th data packet

-- the testbench also configures the match pattern via AXI Lite interface

-- simulate both with OPT_DATA_REG = True / False
entity tb_myip is
  generic
  (
    C_S_AXI_LITE_DATA_WIDTH   : integer := 32;
    C_S_AXI_LITE_ADDR_WIDTH   : integer := 4;

    C_S_AXI_ID_WIDTH          : integer := 1;
    C_S_AXI_DATA_WIDTH        : integer := 128;
    C_S_AXI_ADDR_WIDTH        : integer := 6;
    C_S_AXI_AWUSER_WIDTH      : integer := 0;
    C_S_AXI_ARUSER_WIDTH      : integer := 0;
    C_S_AXI_WUSER_WIDTH       : integer := 0;
    C_S_AXI_RUSER_WIDTH       : integer := 0;
    C_S_AXI_BUSER_WIDTH       : integer := 0
  );
end tb_myip;

architecture bh of tb_myip is
  -- DUT component declaration
  component axi4_w_pattern_trigger is
    generic (
      C_S_AXI_LITE_DATA_WIDTH   : integer;
      C_S_AXI_LITE_ADDR_WIDTH   : integer;
      C_S_AXI_ID_WIDTH          : integer;
      C_S_AXI_DATA_WIDTH        : integer;
      C_S_AXI_ADDR_WIDTH        : integer;
      C_S_AXI_AWUSER_WIDTH      : integer;
      C_S_AXI_ARUSER_WIDTH      : integer;
      C_S_AXI_WUSER_WIDTH       : integer;
      C_S_AXI_RUSER_WIDTH       : integer;
      C_S_AXI_BUSER_WIDTH       : integer
    );
    port (
      S_AXI_ACLK      : in  std_logic;
      S_AXI_ARESETN   : in  std_logic;
      S_AXI_AWADDR    : in  std_logic_vector(C_S_AXI_LITE_ADDR_WIDTH-1 downto 0);
      S_AXI_AWPROT    : in  std_logic_vector(2 downto 0);
      S_AXI_AWVALID   : in  std_logic;
      S_AXI_AWREADY   : out std_logic;
      S_AXI_WDATA     : in  std_logic_vector(C_S_AXI_LITE_DATA_WIDTH-1 downto 0);
      S_AXI_WSTRB     : in  std_logic_vector((C_S_AXI_LITE_DATA_WIDTH/8)-1 downto 0);
      S_AXI_WVALID    : in  std_logic;
      S_AXI_WREADY    : out std_logic;
      S_AXI_BRESP     : out std_logic_vector(1 downto 0);
      S_AXI_BVALID    : out std_logic;
      S_AXI_BREADY    : in  std_logic;
      S_AXI_ARADDR    : in  std_logic_vector(C_S_AXI_LITE_ADDR_WIDTH-1 downto 0);
      S_AXI_ARPROT    : in  std_logic_vector(2 downto 0);
      S_AXI_ARVALID   : in  std_logic;
      S_AXI_ARREADY   : out std_logic;
      S_AXI_RDATA     : out std_logic_vector(C_S_AXI_LITE_DATA_WIDTH-1 downto 0);
      S_AXI_RRESP     : out std_logic_vector(1 downto 0);
      S_AXI_RVALID    : out std_logic;
      S_AXI_RREADY    : in  std_logic;

      s00_axi_awid  : in std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
      s00_axi_awaddr  : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
      s00_axi_awlen : in std_logic_vector(7 downto 0);
      s00_axi_awsize  : in std_logic_vector(2 downto 0);
      s00_axi_awburst : in std_logic_vector(1 downto 0);
      s00_axi_awlock  : in std_logic;
      s00_axi_awcache : in std_logic_vector(3 downto 0);
      s00_axi_awprot  : in std_logic_vector(2 downto 0);
      s00_axi_awqos : in std_logic_vector(3 downto 0);
      s00_axi_awregion  : in std_logic_vector(3 downto 0);
      s00_axi_awuser  : in std_logic_vector(C_S_AXI_AWUSER_WIDTH-1 downto 0);
      s00_axi_awvalid : in std_logic;
      s00_axi_awready : out std_logic;
      s00_axi_wdata : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
      s00_axi_wstrb : in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
      s00_axi_wlast : in std_logic;
      s00_axi_wuser : in std_logic_vector(C_S_AXI_WUSER_WIDTH-1 downto 0);
      s00_axi_wvalid  : in std_logic;
      s00_axi_wready  : out std_logic;
      s00_axi_bid   : out std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
      s00_axi_bresp : out std_logic_vector(1 downto 0);
      s00_axi_buser : out std_logic_vector(C_S_AXI_BUSER_WIDTH-1 downto 0);
      s00_axi_bvalid  : out std_logic;
      s00_axi_bready  : in std_logic;
      s00_axi_arid  : in std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
      s00_axi_araddr  : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
      s00_axi_arlen : in std_logic_vector(7 downto 0);
      s00_axi_arsize  : in std_logic_vector(2 downto 0);
      s00_axi_arburst : in std_logic_vector(1 downto 0);
      s00_axi_arlock  : in std_logic;
      s00_axi_arcache : in std_logic_vector(3 downto 0);
      s00_axi_arprot  : in std_logic_vector(2 downto 0);
      s00_axi_arqos : in std_logic_vector(3 downto 0);
      s00_axi_arregion  : in std_logic_vector(3 downto 0);
      s00_axi_aruser  : in std_logic_vector(C_S_AXI_ARUSER_WIDTH-1 downto 0);
      s00_axi_arvalid : in std_logic;
      s00_axi_arready : out std_logic;
      s00_axi_rid   : out std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
      s00_axi_rdata : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
      s00_axi_rresp : out std_logic_vector(1 downto 0);
      s00_axi_rlast : out std_logic;
      s00_axi_ruser : out std_logic_vector(C_S_AXI_RUSER_WIDTH-1 downto 0);
      s00_axi_rvalid  : out std_logic;
      s00_axi_rready  : in std_logic;
      trg             : out std_logic
    );
  end component;

  constant CLK_PERIOD: TIME := 5 ns;
  -- +8 bits creates an offset, so that the pattern is not 32 bit alligned
  constant PATTERN_TOP : integer := 31+8;
  constant PATTERN_LOW : integer := 0+8;

  signal clk   : std_logic;
  signal rst_n : std_logic;

  signal axi_awaddr  : std_logic_vector(C_S_AXI_LITE_ADDR_WIDTH-1 downto 0);
  signal axi_awprot  : std_logic_vector(2 downto 0);
  signal axi_awvalid : std_logic;
  signal axi_awready : std_logic;
  signal axi_wdata   : std_logic_vector(C_S_AXI_LITE_DATA_WIDTH-1 downto 0);
  signal axi_wstrb   : std_logic_vector((C_S_AXI_LITE_DATA_WIDTH/8)-1 downto 0);
  signal axi_wvalid  : std_logic;
  signal axi_wready  : std_logic;
  signal axi_bresp   : std_logic_vector(1 downto 0);
  signal axi_bvalid  : std_logic;
  signal axi_bready  : std_logic;
  signal axi_araddr  : std_logic_vector(C_S_AXI_LITE_ADDR_WIDTH-1 downto 0);
  signal axi_arprot  : std_logic_vector(2 downto 0);
  signal axi_arvalid : std_logic;
  signal axi_arready : std_logic;
  signal axi_rdata   : std_logic_vector(C_S_AXI_LITE_DATA_WIDTH-1 downto 0);
  signal axi_rresp   : std_logic_vector(1 downto 0);
  signal axi_rvalid  : std_logic;
  signal axi_rready  : std_logic;

  signal start_axis_tvalid : std_logic;
  signal start_axis_tdata  : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal start_axis_tlast  : std_logic;
  signal start_axis_tready : std_logic;
  signal trigger : std_logic;

  signal clk_count : std_logic_vector(7 downto 0) := (others => '0');
begin

  -- generate clk signal
  p_clk_gen : process
  begin
   clk <= '1';
   wait for (CLK_PERIOD / 2);
   clk <= '0';
   wait for (CLK_PERIOD / 2);
   clk_count <= std_logic_vector(unsigned(clk_count) + 1);
  end process;

  -- generate initial reset
  p_reset_gen : process
  begin 
    rst_n <= '0';
    wait until rising_edge(clk);
    wait for (CLK_PERIOD / 4);
    rst_n <= '1';
    wait;
  end process;

  axi_bready <= '1';
  axi_rready <= '1';
  axi_wstrb <= (others => '1');

  --
  p_stream_traffic : process(clk)
  begin
    if rising_edge(clk) then
      if rst_n = '0' then
        start_axis_tvalid <= '0';
        start_axis_tdata <= (others => '0');
        start_axis_tready <= '1';
      else
      if unsigned(clk_count) = 19 then
          start_axis_tdata(C_S_AXI_DATA_WIDTH-1 downto PATTERN_TOP+1) <= (others => '0');
          start_axis_tdata(PATTERN_TOP downto PATTERN_LOW) <= x"deadbeef";
          start_axis_tvalid <= '1';
        end if;
        if unsigned(clk_count) = 20 then
          start_axis_tdata(C_S_AXI_DATA_WIDTH-1 downto PATTERN_TOP+1) <= (others => '0');
          start_axis_tdata(PATTERN_TOP downto PATTERN_LOW) <= x"aabbccdd";
          start_axis_tvalid <= '1';
        end if;
        if unsigned(clk_count) = 21 then
          start_axis_tdata(C_S_AXI_DATA_WIDTH-1 downto PATTERN_TOP+1) <= (others => '0');
          start_axis_tdata(PATTERN_TOP downto PATTERN_LOW) <= x"1F1F1F1F";
          start_axis_tvalid <= '1';
        end if;
        if unsigned(clk_count) = 22 then
          start_axis_tdata <= (others => '0');
          start_axis_tvalid <= '0';
        end if;

        if unsigned(clk_count) = 25 then
          start_axis_tdata(C_S_AXI_DATA_WIDTH-1 downto PATTERN_TOP+1) <= (others => '0');
          start_axis_tdata(PATTERN_TOP downto PATTERN_LOW) <= x"deadbeef";
          start_axis_tvalid <= '1';
        end if;
        if unsigned(clk_count) = 27 then
          start_axis_tdata <= (others => '0');
          start_axis_tvalid <= '0';
        end if;

        if unsigned(clk_count) = 30 then
          start_axis_tdata(C_S_AXI_DATA_WIDTH-1 downto PATTERN_TOP+1) <= (others => '0');
          start_axis_tdata(31 downto 0) <= x"deadbeef";
          start_axis_tvalid <= '1';
        end if;
        if unsigned(clk_count) = 31 then
          start_axis_tdata <= (others => '0');
          start_axis_tvalid <= '0';
        end if;
      end if;
    end if;
  end process;

  -- 
  p_axi_rw : process(clk)
  begin
    if rising_edge(clk) then
      if rst_n = '0' then
        axi_awaddr <= (others => '0');
        axi_awvalid <= '0';
        axi_araddr <= (others => '0');
        axi_arvalid <= '0';
        axi_wdata <= (others => '0');
        axi_wvalid <= '0';
      else
        -- AW channel
        if axi_awready = '1' then
          axi_awaddr <= (others => '0');
          axi_awvalid <= '0';
        else
          if unsigned(clk_count) = 8 then
            axi_awaddr <= "0000"; -- write compare pattern
            axi_awvalid <= '1';
            axi_wdata <= x"deadbeef";
            axi_wvalid <= '1';
          end if;
        end if;
      end if;
    end if;
  end process;

-- DUT instance and connections
  myip_inst : axi4_w_pattern_trigger
    generic map (
      C_S_AXI_LITE_DATA_WIDTH   => C_S_AXI_LITE_DATA_WIDTH,
      C_S_AXI_LITE_ADDR_WIDTH   => C_S_AXI_LITE_ADDR_WIDTH,
      C_S_AXI_ID_WIDTH          => C_S_AXI_ID_WIDTH,
      C_S_AXI_DATA_WIDTH        => C_S_AXI_DATA_WIDTH,
      C_S_AXI_ADDR_WIDTH        => C_S_AXI_ADDR_WIDTH,
      C_S_AXI_AWUSER_WIDTH      => C_S_AXI_AWUSER_WIDTH,
      C_S_AXI_ARUSER_WIDTH      => C_S_AXI_ARUSER_WIDTH,
      C_S_AXI_WUSER_WIDTH       => C_S_AXI_WUSER_WIDTH,
      C_S_AXI_RUSER_WIDTH       => C_S_AXI_RUSER_WIDTH,
      C_S_AXI_BUSER_WIDTH       => C_S_AXI_BUSER_WIDTH
    )
    port map (
      S_AXI_ACLK      => clk, 
      S_AXI_ARESETN   => rst_n, 
      S_AXI_AWADDR    => axi_awaddr, 
      S_AXI_AWPROT    => axi_awprot, 
      S_AXI_AWVALID   => axi_awvalid, 
      S_AXI_AWREADY   => axi_awready, 
      S_AXI_WDATA     => axi_wdata, 
      S_AXI_WSTRB     => axi_wstrb, 
      S_AXI_WVALID    => axi_wvalid, 
      S_AXI_WREADY    => axi_wready, 
      S_AXI_BRESP     => axi_bresp, 
      S_AXI_BVALID    => axi_bvalid, 
      S_AXI_BREADY    => axi_bready, 
      S_AXI_ARADDR    => axi_araddr, 
      S_AXI_ARPROT    => axi_arprot, 
      S_AXI_ARVALID   => axi_arvalid, 
      S_AXI_ARREADY   => axi_arready, 
      S_AXI_RDATA     => axi_rdata, 
      S_AXI_RRESP     => axi_rresp, 
      S_AXI_RVALID    => axi_rvalid, 
      S_AXI_RREADY    => axi_rready,
      s00_axi_awid     => (others => '0'), 
      s00_axi_awaddr   => (others => '0'), 
      s00_axi_awlen    => (others => '0'), 
      s00_axi_awsize   => (others => '0'), 
      s00_axi_awburst  => (others => '0'), 
      s00_axi_awlock   => '0',
      s00_axi_awcache  => (others => '0'), 
      s00_axi_awprot   => (others => '0'), 
      s00_axi_awqos    => (others => '0'), 
      s00_axi_awregion => (others => '0'), 
      s00_axi_awuser   => (others => '0'),
      s00_axi_awvalid  => '0',
      s00_axi_awready  => open, 
      s00_axi_wdata    => start_axis_tdata, 
      s00_axi_wstrb    => (others => '0'), 
      s00_axi_wlast    => '0', 
      s00_axi_wuser    => (others => '0'), 
      s00_axi_wvalid   => start_axis_tvalid, 
      s00_axi_wready   => open, 
      s00_axi_bid      => open, 
      s00_axi_bresp    => open, 
      s00_axi_buser    => open, 
      s00_axi_bvalid   => open, 
      s00_axi_bready   => '0',
      s00_axi_arid     => (others => '0'), 
      s00_axi_araddr   => (others => '0'), 
      s00_axi_arlen    => (others => '0'), 
      s00_axi_arsize   => (others => '0'), 
      s00_axi_arburst  => (others => '0'), 
      s00_axi_arlock   => '0',
      s00_axi_arcache  => (others => '0'), 
      s00_axi_arprot   => (others => '0'), 
      s00_axi_arqos    => (others => '0'), 
      s00_axi_arregion => (others => '0'), 
      s00_axi_aruser   => (others => '0'),
      s00_axi_arvalid  => '0',
      s00_axi_arready  => open, 
      s00_axi_rid      => open, 
      s00_axi_rdata    => open, 
      s00_axi_rresp    => open,
      s00_axi_rlast    => open, 
      s00_axi_ruser    => open, 
      s00_axi_rvalid   => open, 
      s00_axi_rready   => '0',
      trg              => trigger
    );

end bh;

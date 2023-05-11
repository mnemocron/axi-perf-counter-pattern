----------------------------------------------------------------------------------
-- Company:        
-- Engineer:       simon.burkhardt
-- 
-- Create Date:    2023-04-21
-- Design Name:    skid buffer testbench
-- Module Name:    tb_myip - bh
-- Project Name:   
-- Target Devices: 
-- Tool Versions:  GHDL 0.37
-- Description:    
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

-- simulate both with OPT_DATA_REG = True / False
entity tb_myip is
  generic
  (
    C_S_AXI_DATA_WIDTH   : integer := 32;
    C_S_AXI_ADDR_WIDTH   : integer := 5;
    C_S_AXIS_TDATA_WIDTH : integer := 512
  );
end tb_myip;

architecture bh of tb_myip is
  -- DUT component declaration
  component axis_latency_counter is
    generic (
      C_S_AXI_DATA_WIDTH   : integer;
      C_S_AXI_ADDR_WIDTH   : integer;
      C_S_AXIS_TDATA_WIDTH : integer
    );
    port (
      S_AXI_ACLK      : in  std_logic;
      S_AXI_ARESETN   : in  std_logic;
      S_AXI_AWADDR    : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
      S_AXI_AWPROT    : in  std_logic_vector(2 downto 0);
      S_AXI_AWVALID   : in  std_logic;
      S_AXI_AWREADY   : out std_logic;
      S_AXI_WDATA     : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
      S_AXI_WSTRB     : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
      S_AXI_WVALID    : in  std_logic;
      S_AXI_WREADY    : out std_logic;
      S_AXI_BRESP     : out std_logic_vector(1 downto 0);
      S_AXI_BVALID    : out std_logic;
      S_AXI_BREADY    : in  std_logic;
      S_AXI_ARADDR    : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
      S_AXI_ARPROT    : in  std_logic_vector(2 downto 0);
      S_AXI_ARVALID   : in  std_logic;
      S_AXI_ARREADY   : out std_logic;
      S_AXI_RDATA     : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
      S_AXI_RRESP     : out std_logic_vector(1 downto 0);
      S_AXI_RVALID    : out std_logic;
      S_AXI_RREADY    : in  std_logic;
      trg_a    : in std_logic;
      trg_y    : in std_logic
    );
  end component;

  constant CLK_PERIOD: TIME := 5 ns;
  -- +8 bits creates an offset, so that the pattern is not 32 bit alligned
  constant PATTERN_TOP : integer := 31+8;
  constant PATTERN_LOW : integer := 0+8;

  signal clk   : std_logic;
  signal rst_n : std_logic;

  signal axi_awaddr  : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
  signal axi_awprot  : std_logic_vector(2 downto 0);
  signal axi_awvalid : std_logic;
  signal axi_awready : std_logic;
  signal axi_wdata   : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal axi_wstrb   : std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
  signal axi_wvalid  : std_logic;
  signal axi_wready  : std_logic;
  signal axi_bresp   : std_logic_vector(1 downto 0);
  signal axi_bvalid  : std_logic;
  signal axi_bready  : std_logic;
  signal axi_araddr  : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
  signal axi_arprot  : std_logic_vector(2 downto 0);
  signal axi_arvalid : std_logic;
  signal axi_arready : std_logic;
  signal axi_rdata   : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal axi_rresp   : std_logic_vector(1 downto 0);
  signal axi_rvalid  : std_logic;
  signal axi_rready  : std_logic;

  signal trg_start   : std_logic;
  signal trg_stop    : std_logic;

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
        trg_start <= '0';
        trg_stop  <= '0';
      else
        -- trigger to START counting
        if unsigned(clk_count) = 19 then
          trg_start <= '1';
        end if;
        if unsigned(clk_count) = 20 then
          trg_start <= '0';
        end if;

        -- 10 cycles later
        -- trigger to STOP counting
        if unsigned(clk_count) = 29 then
          trg_stop <= '1';
        end if;
        if unsigned(clk_count) = 30 then
          trg_stop <= '0';
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
          if unsigned(clk_count) = 16 then
            axi_awaddr <= "00000"; -- reset counter
            axi_awvalid <= '1';
            axi_wdata <= x"00000000";
            axi_wvalid <= '1';
          end if;
        end if;

        -- AR channel
        if axi_arready = '1' then
          axi_araddr <= (others => '0');
          axi_arvalid <= '0';
        else
          -- read perf counter value
          if unsigned(clk_count) = 4 then
            axi_araddr <= "00000"; -- read clock count
            axi_arvalid <= '1';
          end if;

          -- after the trigger has been stopped, read the counter value
          if unsigned(clk_count) = 40 then
            axi_araddr <= "00000"; -- read clock count
            axi_arvalid <= '1';
          end if;
        end if;

        -- W channel
        if axi_wready = '1' then
          axi_wdata <= (others => '0');
          axi_wvalid <= '0';
        end if;
      end if;
    end if;
  end process;

-- DUT instance and connections
  myip_inst : axis_latency_counter
    generic map (
      C_S_AXI_DATA_WIDTH   => C_S_AXI_DATA_WIDTH,
      C_S_AXI_ADDR_WIDTH   => C_S_AXI_ADDR_WIDTH,
      C_S_AXIS_TDATA_WIDTH => C_S_AXIS_TDATA_WIDTH
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
      trg_a           => trg_start,
      trg_y           => trg_stop
    );

end bh;

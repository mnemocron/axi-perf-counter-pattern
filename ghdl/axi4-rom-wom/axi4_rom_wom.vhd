----------------------------------------------------------------------------------
-- Company:        
-- Engineer:       simon.burkhardt
-- 
-- Create Date:    2023-05-30
-- Design Name:    axi4_rom_wom
-- Module Name:    
-- Project Name:   
-- Target Devices: 
-- Tool Versions:  GHDL 0.37
-- Description:    high performance AXI4 Read Only Memory + Write Only Memory
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

entity axi4_rom_wom is
  generic (
    -- Users to add parameters here

    -- User parameters ends
    -- Do not modify the parameters beyond this line
    -- Width of ID for for write address, write data, read address and read data
    C_S_AXI_ID_WIDTH    : integer   := 1;
    -- Width of S_AXI data bus
    C_S_AXI_DATA_WIDTH  : integer   := 512;
    -- Width of S_AXI address bus
    C_S_AXI_ADDR_WIDTH  : integer   := 20;
    -- Width of optional user defined signal in write address channel
    C_S_AXI_AWUSER_WIDTH    : integer   := 0;
    -- Width of optional user defined signal in read address channel
    C_S_AXI_ARUSER_WIDTH    : integer   := 0;
    -- Width of optional user defined signal in write data channel
    C_S_AXI_WUSER_WIDTH : integer   := 0;
    -- Width of optional user defined signal in read data channel
    C_S_AXI_RUSER_WIDTH : integer   := 0;
    -- Width of optional user defined signal in write response channel
    C_S_AXI_BUSER_WIDTH : integer   := 0
    
  );
  port (
    -- Users to add ports here

    -- User ports ends
    -- Global ports
    S_AXI_ACLK     : in std_logic;
    S_AXI_ARESETN  : in std_logic;

    -- AXI4 (full) Slave
    -- Write Address ID
    S_AXI_AWID  : in std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
    -- Write address
    S_AXI_AWADDR    : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    -- Burst length. The burst length gives the exact number of transfers in a burst
    S_AXI_AWLEN : in std_logic_vector(7 downto 0);
    -- Burst size. This signal indicates the size of each transfer in the burst
    S_AXI_AWSIZE    : in std_logic_vector(2 downto 0);
    -- Burst type. The burst type and the size information, 
    -- determine how the address for each transfer within the burst is calculated.
    S_AXI_AWBURST   : in std_logic_vector(1 downto 0);
    -- Lock type. Provides additional information about the
    -- atomic characteristics of the transfer.
    S_AXI_AWLOCK    : in std_logic;
    -- Memory type. This signal indicates how transactions
    -- are required to progress through a system.
    S_AXI_AWCACHE   : in std_logic_vector(3 downto 0);
    -- Protection type. This signal indicates the privilege
    -- and security level of the transaction, and whether
    -- the transaction is a data access or an instruction access.
    S_AXI_AWPROT    : in std_logic_vector(2 downto 0);
    -- Quality of Service, QoS identifier sent for each
    -- write transaction.
    S_AXI_AWQOS : in std_logic_vector(3 downto 0);
    -- Region identifier. Permits a single physical interface
    -- on a slave to be used for multiple logical interfaces.
    S_AXI_AWREGION  : in std_logic_vector(3 downto 0);
    -- Optional User-defined signal in the write address channel.
    S_AXI_AWUSER    : in std_logic_vector(C_S_AXI_AWUSER_WIDTH-1 downto 0);
    -- Write address valid. This signal indicates that
    -- the channel is signaling valid write address and
    -- control information.
    S_AXI_AWVALID   : in std_logic;
    -- Write address ready. This signal indicates that
    -- the slave is ready to accept an address and associated
    -- control signals.
    S_AXI_AWREADY   : out std_logic;
    -- Write Data
    S_AXI_WDATA : in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    -- Write strobes. This signal indicates which byte
    -- lanes hold valid data. There is one write strobe
    -- bit for each eight bits of the write data bus.
    S_AXI_WSTRB : in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
    -- Write last. This signal indicates the last transfer
    -- in a write burst.
    S_AXI_WLAST : in std_logic;
    -- Optional User-defined signal in the write data channel.
    S_AXI_WUSER : in std_logic_vector(C_S_AXI_WUSER_WIDTH-1 downto 0);
    -- Write valid. This signal indicates that valid write
    -- data and strobes are available.
    S_AXI_WVALID    : in std_logic;
    -- Write ready. This signal indicates that the slave
    -- can accept the write data.
    S_AXI_WREADY    : out std_logic;
    -- Response ID tag. This signal is the ID tag of the
    -- write response.
    S_AXI_BID   : out std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
    -- Write response. This signal indicates the status
    -- of the write transaction.
    S_AXI_BRESP : out std_logic_vector(1 downto 0);
    -- Optional User-defined signal in the write response channel.
    S_AXI_BUSER : out std_logic_vector(C_S_AXI_BUSER_WIDTH-1 downto 0);
    -- Write response valid. This signal indicates that the
    -- channel is signaling a valid write response.
    S_AXI_BVALID    : out std_logic;
    -- Response ready. This signal indicates that the master
    -- can accept a write response.
    S_AXI_BREADY    : in std_logic;
    -- Read address ID. This signal is the identification
    -- tag for the read address group of signals.
    S_AXI_ARID  : in std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
    -- Read address. This signal indicates the initial
    -- address of a read burst transaction.
    S_AXI_ARADDR    : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    -- Burst length. The burst length gives the exact number of transfers in a burst
    S_AXI_ARLEN : in std_logic_vector(7 downto 0);
    -- Burst size. This signal indicates the size of each transfer in the burst
    S_AXI_ARSIZE    : in std_logic_vector(2 downto 0);
    -- Burst type. The burst type and the size information, 
    -- determine how the address for each transfer within the burst is calculated.
    S_AXI_ARBURST   : in std_logic_vector(1 downto 0);
    -- Lock type. Provides additional information about the
    -- atomic characteristics of the transfer.
    S_AXI_ARLOCK    : in std_logic;
    -- Memory type. This signal indicates how transactions
    -- are required to progress through a system.
    S_AXI_ARCACHE   : in std_logic_vector(3 downto 0);
    -- Protection type. This signal indicates the privilege
    -- and security level of the transaction, and whether
    -- the transaction is a data access or an instruction access.
    S_AXI_ARPROT    : in std_logic_vector(2 downto 0);
    -- Quality of Service, QoS identifier sent for each
    -- read transaction.
    S_AXI_ARQOS : in std_logic_vector(3 downto 0);
    -- Region identifier. Permits a single physical interface
    -- on a slave to be used for multiple logical interfaces.
    S_AXI_ARREGION  : in std_logic_vector(3 downto 0);
    -- Optional User-defined signal in the read address channel.
    S_AXI_ARUSER    : in std_logic_vector(C_S_AXI_ARUSER_WIDTH-1 downto 0);
    -- Write address valid. This signal indicates that
    -- the channel is signaling valid read address and
    -- control information.
    S_AXI_ARVALID   : in std_logic;
    -- Read address ready. This signal indicates that
    -- the slave is ready to accept an address and associated
    -- control signals.
    S_AXI_ARREADY   : out std_logic;
    -- Read ID tag. This signal is the identification tag
    -- for the read data group of signals generated by the slave.
    S_AXI_RID   : out std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
    -- Read Data
    S_AXI_RDATA : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    -- Read response. This signal indicates the status of
    -- the read transfer.
    S_AXI_RRESP : out std_logic_vector(1 downto 0);
    -- Read last. This signal indicates the last transfer
    -- in a read burst.
    S_AXI_RLAST : out std_logic;
    -- Optional User-defined signal in the read address channel.
    S_AXI_RUSER : out std_logic_vector(C_S_AXI_RUSER_WIDTH-1 downto 0);
    -- Read valid. This signal indicates that the channel
    -- is signaling the required read data.
    S_AXI_RVALID    : out std_logic;
    -- Read ready. This signal indicates that the master can
    -- accept the read data and response information.
    S_AXI_RREADY    : in std_logic

  );
end axi4_rom_wom;

architecture arch_imp of axi4_rom_wom is

  type axi_rx_state_t is (AXI_RX_STATE_IDLE, AXI_RX_STATE_SIMPLE, AXI_RX_STATE_MULTI);
  signal state_axi_rx : axi_rx_state_t;
  signal state_axi_tx : axi_rx_state_t;

  -- signals
  signal aclk    : std_logic;
  signal aresetn : std_logic;

  -- Write Response
  --signal o_axi_bresp  : std_logic_vector(1 downto 0);
  --signal o_axi_bvalid : std_logic;
  --signal o_axi_bid    : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
  --signal i_axi_bready : std_logic;

  signal temp_bid       : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
  signal temp_rid       : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
  signal bresp_pending  : std_logic;
  signal rresp_pending  : std_logic;

  signal o_axi_awready  : std_logic;
  signal o_axi_wready   : std_logic;
  signal o_axi_bid      : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
  signal o_axi_bresp    : std_logic_vector(1 downto 0);
  signal o_axi_buser    : std_logic_vector(C_S_AXI_BUSER_WIDTH-1 downto 0);
  signal o_axi_bvalid   : std_logic;
  signal o_axi_arready  : std_logic;

  signal o_axi_rid      : std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
  signal o_axi_rdata    : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal o_axi_rresp    : std_logic_vector(1 downto 0);
  signal o_axi_rlast    : std_logic;
  signal o_axi_ruser    : std_logic_vector(C_S_AXI_RUSER_WIDTH-1 downto 0);
  signal o_axi_rvalid   : std_logic;
  signal read_burst_count : std_logic_vector(7 downto 0);
  signal n_read_beats     : std_logic_vector(7 downto 0);

begin
  -- I/O connections assignments
  aclk    <= S_AXI_ACLK;
  aresetn <= S_AXI_ARESETN;

  S_AXI_AWREADY  <= o_axi_awready;
  S_AXI_ARREADY  <= o_axi_arready;
  S_AXI_RLAST    <= o_axi_rlast;
  S_AXI_RDATA    <= o_axi_rdata;
  S_AXI_RVALID   <= o_axi_rvalid;

  S_AXI_BRESP   <= o_axi_bresp;
  S_AXI_BVALID  <= o_axi_bvalid;
  S_AXI_BID     <= o_axi_bid;

  S_AXI_WREADY  <= '1';

  p_axi_tx_flow_state : process(aclk)
  begin
    if rising_edge(aclk) then
      if aresetn = '0' then
        state_axi_tx <= AXI_RX_STATE_IDLE;
        o_axi_rvalid <= '0';
        o_axi_rresp  <= (others => '0');
        o_axi_rid    <= (others => '0');
        o_axi_arready <= '1';  -- "always" ready to accept AR (because address gets discarded anyways)
        o_axi_rlast <= '0';
        o_axi_rdata <= (others => '0');
        rresp_pending <= '0';
        read_burst_count <= (others => '0');
      else
        -- state machine that can accept up to 2 requests over AR channel
        case state_axi_tx is
          -- IDLE: wait for AR request, remember ARID for RID, go to RX_SIMPLE
          when AXI_RX_STATE_IDLE =>
            if S_AXI_ARVALID = '1' and o_axi_arready = '1' then
              o_axi_rdata <= (others => '1');
              o_axi_rresp <= (others => '0');
              o_axi_rdata <= (others => '0');
              o_axi_rid <= S_AXI_ARID;
              o_axi_rvalid <= '0';
              n_read_beats <= S_AXI_ARLEN;
              o_axi_arready <= '0';
              o_axi_rlast <= '0';
              state_axi_tx <= AXI_RX_STATE_SIMPLE;
            else
              o_axi_rdata <= (others => '0');            
              o_axi_rvalid <= '0';
              o_axi_rlast <= '0';
            end if;

          -- RX_SIMPLE: only 1 incomming xfer, AXI Slave can still accept AR requests
          -- when another AR reqest is incomming go to RX_MULTI
          when AXI_RX_STATE_SIMPLE =>
            o_axi_rdata(7 downto 0) <= read_burst_count;
            if S_AXI_ARVALID = '1' and o_axi_arready = '1' then -- accept ANOTHER incomming AR request
              state_axi_tx <= AXI_RX_STATE_MULTI;
              -- signal the pending signal, if arvalid
              temp_rid <= S_AXI_ARID;
              o_axi_arready <= '0';
            else
              -- wait for transfer to be complete
              o_axi_arready <= '1';
              state_axi_tx <= AXI_RX_STATE_SIMPLE;
            end if;
            if S_AXI_RREADY = '1' then
              if unsigned(read_burst_count) = unsigned(n_read_beats) then
                read_burst_count <= (others => '0');
                state_axi_tx <= AXI_RX_STATE_IDLE;
                o_axi_rlast <= '1';
                o_axi_rvalid <= '1';
              else
                read_burst_count <= std_logic_vector(unsigned(read_burst_count) +1);
                o_axi_rlast <= '0';
                o_axi_rvalid <= '1';
              end if;
            end if;

          -- RX_MULTI: multiple xfers pending, AXI Slave AR is stalled
          when AXI_RX_STATE_MULTI =>
            o_axi_rdata(7 downto 0) <= read_burst_count;
            if S_AXI_RREADY = '1' then
              if unsigned(read_burst_count) = unsigned(n_read_beats) then
                read_burst_count <= (others => '0');
                state_axi_tx <= AXI_RX_STATE_SIMPLE;
                o_axi_rlast <= '1';
                o_axi_rvalid <= '1';
              else
                read_burst_count <= std_logic_vector(unsigned(read_burst_count) +1);
                o_axi_rlast <= '0';
                o_axi_rvalid <= '1';
              end if;
            end if;
       end case;
      end if;
    end if;
  end process;

  p_axi_rx_flow_state : process(aclk)
  begin
    if rising_edge(aclk) then
      if aresetn = '0' then
        state_axi_rx <= AXI_RX_STATE_IDLE;
        o_axi_bvalid <= '0';
        o_axi_bresp  <= (others => '0');
        o_axi_bid    <= (others => '0');
        o_axi_awready <= '1';  -- "always" ready to accept AW (because address gets discarded anyways)
        bresp_pending <= '0';
      else
        -- state machine that can accept up to 2 requests over AW channel
        case state_axi_rx is
          -- IDLE: wait for AW request, remember AWID for BID, go to RX_SIMPLE
          when AXI_RX_STATE_IDLE =>
            if S_AXI_AWVALID = '1' and o_axi_awready = '1' then -- accept incomming AW request
              state_axi_rx <= AXI_RX_STATE_SIMPLE;
              o_axi_bid <= S_AXI_AWID;
              o_axi_awready <= '0';
            end if;
            if S_AXI_WLAST = '1' then
              -- tlast signals that the transfer can be aknowledged via BRESP channel
              o_axi_bvalid <= '1';
            end if;
            if o_axi_bvalid = '1' and S_AXI_BREADY = '1' then
              -- deasert, if BRESP is aknowledged
              o_axi_bvalid <= '0';
            end if;

          -- RX_SIMPLE: only 1 incomming xfer, AXI Slave can still accept AW requests
          -- when another AW reqest is incomming go to RX_MULTI
          when AXI_RX_STATE_SIMPLE =>
            if S_AXI_AWVALID = '1' and o_axi_awready = '1' then -- accept ANOTHER incomming AW request
              state_axi_rx <= AXI_RX_STATE_MULTI;
              -- signal the pending signal, if awvalid, awready and tlast assert at the same time
              --bresp_pending <= o_m_axis_tlast; 
              temp_bid <= S_AXI_AWID;
              o_axi_bvalid <= '0';
              o_axi_awready <= '0';
            elsif S_AXI_WLAST = '1' then
              -- tlast signals that the transfer is complete and can be aknowledged via BRESP channel
              state_axi_rx <= AXI_RX_STATE_IDLE;
              o_axi_bvalid <= '1';
              o_axi_awready <= '1';
            else
              -- wait for transfer to be complete
              state_axi_rx <= AXI_RX_STATE_SIMPLE;
              o_axi_bvalid <= '0';
              o_axi_awready <= '1';
            end if;
            if o_axi_bvalid = '1' and S_AXI_BREADY = '1' then
              -- deasert, if BRESP is aknowledged
              o_axi_bvalid <= '0';
            end if;

          -- RX_MULTI: multiple xfers pending, AXI Slave AW is stalled
          when AXI_RX_STATE_MULTI =>
            if bresp_pending = '1' then
              bresp_pending <= '0';
              state_axi_rx <= AXI_RX_STATE_SIMPLE;
              o_axi_awready <= '1';
              o_axi_bvalid <= '1';
            elsif S_AXI_WLAST = '1' then
              state_axi_rx <= AXI_RX_STATE_SIMPLE;
              o_axi_awready <= '1';
              o_axi_bid <= temp_bid;
              o_axi_bvalid <= '1';
            else
              o_axi_awready <= '0';
            end if;
       end case;
      end if;
    end if;
  end process;

end arch_imp;

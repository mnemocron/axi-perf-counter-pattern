library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity axi4_s_monitor_breakout is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_ID_WIDTH	: integer	:= 1;
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 6;
		C_S00_AXI_AWUSER_WIDTH	: integer	:= 0;
		C_S00_AXI_ARUSER_WIDTH	: integer	:= 0;
		C_S00_AXI_WUSER_WIDTH	: integer	:= 0;
		C_S00_AXI_RUSER_WIDTH	: integer	:= 0;
		C_S00_AXI_BUSER_WIDTH	: integer	:= 0
	);
	port (
		-- Users to add ports here

		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awid	: in std_logic_vector(C_S00_AXI_ID_WIDTH-1 downto 0);
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awlen	: in std_logic_vector(7 downto 0);
		s00_axi_awsize	: in std_logic_vector(2 downto 0);
		s00_axi_awburst	: in std_logic_vector(1 downto 0);
		s00_axi_awlock	: in std_logic;
		s00_axi_awcache	: in std_logic_vector(3 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awqos	: in std_logic_vector(3 downto 0);
		s00_axi_awregion	: in std_logic_vector(3 downto 0);
		s00_axi_awuser	: in std_logic_vector(C_S00_AXI_AWUSER_WIDTH-1 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: in std_logic; -- out
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wlast	: in std_logic;
		s00_axi_wuser	: in std_logic_vector(C_S00_AXI_WUSER_WIDTH-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: in std_logic; -- out
		s00_axi_bid	: in std_logic_vector(C_S00_AXI_ID_WIDTH-1 downto 0); -- out
		s00_axi_bresp	: in std_logic_vector(1 downto 0); -- out
		s00_axi_buser	: in std_logic_vector(C_S00_AXI_BUSER_WIDTH-1 downto 0); -- out
		s00_axi_bvalid	: in std_logic; -- out
		s00_axi_bready	: in std_logic;
		s00_axi_arid	: in std_logic_vector(C_S00_AXI_ID_WIDTH-1 downto 0);
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arlen	: in std_logic_vector(7 downto 0);
		s00_axi_arsize	: in std_logic_vector(2 downto 0);
		s00_axi_arburst	: in std_logic_vector(1 downto 0);
		s00_axi_arlock	: in std_logic;
		s00_axi_arcache	: in std_logic_vector(3 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arqos	: in std_logic_vector(3 downto 0);
		s00_axi_arregion	: in std_logic_vector(3 downto 0);
		s00_axi_aruser	: in std_logic_vector(C_S00_AXI_ARUSER_WIDTH-1 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: in std_logic; -- out
		s00_axi_rid	: in std_logic_vector(C_S00_AXI_ID_WIDTH-1 downto 0); -- out
		s00_axi_rdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0); -- out
		s00_axi_rresp	: in std_logic_vector(1 downto 0); -- out
		s00_axi_rlast	: in std_logic; -- out
		s00_axi_ruser	: in std_logic_vector(C_S00_AXI_RUSER_WIDTH-1 downto 0); -- out
		s00_axi_rvalid	: in std_logic; -- out
		s00_axi_rready	: in std_logic;

		m00_axi_init_axi_txn	: out std_logic; -- in
		m00_axi_txn_done	: out std_logic;
		m00_axi_error	: out std_logic;
		m00_axi_aclk	: out std_logic; -- in
		m00_axi_aresetn	: out std_logic; -- in
		m00_axi_awid	: out std_logic_vector(C_S00_AXI_ID_WIDTH-1 downto 0);
		m00_axi_awaddr	: out std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		m00_axi_awlen	: out std_logic_vector(7 downto 0);
		m00_axi_awsize	: out std_logic_vector(2 downto 0);
		m00_axi_awburst	: out std_logic_vector(1 downto 0);
		m00_axi_awlock	: out std_logic;
		m00_axi_awcache	: out std_logic_vector(3 downto 0);
		m00_axi_awprot	: out std_logic_vector(2 downto 0);
		m00_axi_awqos	: out std_logic_vector(3 downto 0);
		m00_axi_awuser	: out std_logic_vector(C_S00_AXI_AWUSER_WIDTH-1 downto 0);
		m00_axi_awvalid	: out std_logic;
		m00_axi_awready	: out std_logic; -- in
		m00_axi_wdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		m00_axi_wstrb	: out std_logic_vector(C_S00_AXI_DATA_WIDTH/8-1 downto 0);
		m00_axi_wlast	: out std_logic;
		m00_axi_wuser	: out std_logic_vector(C_S00_AXI_WUSER_WIDTH-1 downto 0);
		m00_axi_wvalid	: out std_logic;
		m00_axi_wready	: out std_logic; -- in
		m00_axi_bid	: out std_logic_vector(C_S00_AXI_ID_WIDTH-1 downto 0); -- in
		m00_axi_bresp	: out std_logic_vector(1 downto 0); -- in
		m00_axi_buser	: out std_logic_vector(C_S00_AXI_BUSER_WIDTH-1 downto 0); -- in
		m00_axi_bvalid	: out std_logic; -- in
		m00_axi_bready	: out std_logic;
		m00_axi_arid	: out std_logic_vector(C_S00_AXI_ID_WIDTH-1 downto 0);
		m00_axi_araddr	: out std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		m00_axi_arlen	: out std_logic_vector(7 downto 0);
		m00_axi_arsize	: out std_logic_vector(2 downto 0);
		m00_axi_arburst	: out std_logic_vector(1 downto 0);
		m00_axi_arlock	: out std_logic;
		m00_axi_arcache	: out std_logic_vector(3 downto 0);
		m00_axi_arprot	: out std_logic_vector(2 downto 0);
		m00_axi_arqos	: out std_logic_vector(3 downto 0);
		m00_axi_aruser	: out std_logic_vector(C_S00_AXI_ARUSER_WIDTH-1 downto 0);
		m00_axi_arvalid	: out std_logic;
		m00_axi_arready	: out std_logic; -- in
		m00_axi_rid	: out std_logic_vector(C_S00_AXI_ID_WIDTH-1 downto 0); -- in
		m00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0); -- in
		m00_axi_rresp	: out std_logic_vector(1 downto 0); -- in
		m00_axi_rlast	: out std_logic; -- in
		m00_axi_ruser	: out std_logic_vector(C_S00_AXI_RUSER_WIDTH-1 downto 0); -- in
		m00_axi_rvalid	: out std_logic; -- in
		m00_axi_rready	: out std_logic
	);
end axi4_s_monitor_breakout;

architecture arch_imp of axi4_s_monitor_breakout is

begin

	-- Add user logic here

	m00_axi_init_axi_txn	<= s00_axi_init_axi_txn; -- in
	m00_axi_txn_done	<= s00_axi_txn_done; 
	m00_axi_error	<= s00_axi_error; 
	m00_axi_aclk	<= s00_axi_aclk; -- in
	m00_axi_aresetn	<= s00_axi_aresetn; -- in
	m00_axi_awid	<= s00_axi_awid; 
	m00_axi_awaddr	<= s00_axi_awaddr; 
	m00_axi_awlen	<= s00_axi_awlen; 
	m00_axi_awsize	<= s00_axi_awsize; 
	m00_axi_awburst	<= s00_axi_awburst; 
	m00_axi_awlock	<= s00_axi_awlock; 
	m00_axi_awcache	<= s00_axi_awcache; 
	m00_axi_awprot	<= s00_axi_awprot; 
	m00_axi_awqos	<= s00_axi_awqos; 
	m00_axi_awuser	<= s00_axi_awuser; 
	m00_axi_awvalid	<= s00_axi_awvalid; 
	m00_axi_awready	<= s00_axi_awready; -- in
	m00_axi_wdata	<= s00_axi_wdata; 
	m00_axi_wstrb	<= s00_axi_wstrb; 
	m00_axi_wlast	<= s00_axi_wlast; 
	m00_axi_wuser	<= s00_axi_wuser; 
	m00_axi_wvalid	<= s00_axi_wvalid; 
	m00_axi_wready	<= s00_axi_wready; -- in
	m00_axi_bid	<= s00_axi_bid; -- in
	m00_axi_bresp	<= s00_axi_bresp; -- in
	m00_axi_buser	<= s00_axi_buser; -- in
	m00_axi_bvalid	<= s00_axi_bvalid; -- in
	m00_axi_bready	<= s00_axi_bready; 
	m00_axi_arid	<= s00_axi_arid; 
	m00_axi_araddr	<= s00_axi_araddr; 
	m00_axi_arlen	<= s00_axi_arlen; 
	m00_axi_arsize	<= s00_axi_arsize; 
	m00_axi_arburst	<= s00_axi_arburst; 
	m00_axi_arlock	<= s00_axi_arlock; 
	m00_axi_arcache	<= s00_axi_arcache; 
	m00_axi_arprot	<= s00_axi_arprot; 
	m00_axi_arqos	<= s00_axi_arqos; 
	m00_axi_aruser	<= s00_axi_aruser; 
	m00_axi_arvalid	<= s00_axi_arvalid; 
	m00_axi_arready	<= s00_axi_arready; -- in
	m00_axi_rid	<= s00_axi_rid; -- in
	m00_axi_rdata	<= s00_axi_rdata; -- in
	m00_axi_rresp	<= s00_axi_rresp; -- in
	m00_axi_rlast	<= s00_axi_rlast; -- in
	m00_axi_ruser	<= s00_axi_ruser; -- in
	m00_axi_rvalid	<= s00_axi_rvalid; -- in
	m00_axi_rready	<= s00_axi_rready; 

	-- User logic ends

end arch_imp;

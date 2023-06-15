library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity axis_s_template_v1_0 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXIS
		C_S00_AXIS_TDATA_WIDTH	: integer	:= 32
	);
	port (
		-- Users to add ports here

		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXIS
		s00_axis_aclk	: in std_logic;
		s00_axis_aresetn	: in std_logic;

		s00_axis_tready	: in std_logic;
		s00_axis_tdata	: in std_logic_vector(C_S00_AXIS_TDATA_WIDTH-1 downto 0);
		s00_axis_tstrb	: in std_logic_vector((C_S00_AXIS_TDATA_WIDTH/8)-1 downto 0);
		s00_axis_tlast	: in std_logic;
		s00_axis_tvalid	: in std_logic; 

		m00_axis_tvalid	: out std_logic;
		m00_axis_tdata	: out std_logic_vector(C_S00_AXIS_TDATA_WIDTH-1 downto 0);
		m00_axis_tstrb	: out std_logic_vector((C_S00_AXIS_TDATA_WIDTH/8)-1 downto 0);
		m00_axis_tlast	: out std_logic;
		m00_axis_tready	: out std_logic
	);
end axis_s_template_v1_0;

architecture arch_imp of axis_s_template_v1_0 is

begin
	-- Add user logic here
	-- s00_axis_tready	<= m00_axis_tready;

	m00_axis_tvalid	<= s00_axis_tvalid; 
	m00_axis_tdata	<= s00_axis_tdata; 
	m00_axis_tstrb	<= s00_axis_tstrb; 
	m00_axis_tlast	<= s00_axis_tlast; 
	m00_axis_tready	<= s00_axis_tready; 

	-- User logic ends

end arch_imp;

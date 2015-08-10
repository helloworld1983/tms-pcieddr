
library IEEE;
use IEEE.STD_LOGIC_1164.all;

library work;
use work.abb64Package.all;
use work.bpm_pcie_a7_priv_pkg.all;

library UNISIM;
use UNISIM.VComponents.all;

entity top is
  generic (
    SIMULATION   : string := "FALSE";
    -- ****
    -- PCIe core parameters
    -- ****
    constant pcieLanes : integer := 4;
    PL_FAST_TRAIN      : string  := "FALSE";
    PIPE_SIM_MODE      : string  := "FALSE";
    --***************************************************************************
    -- Necessary parameters for DDR core support
    -- (dependent on memory chip connected to FPGA, not to be modified at will)
    --***************************************************************************
    constant DDR_DQ_WIDTH      : integer := 32;
    constant DDR_PAYLOAD_WIDTH : integer := 256;
    constant DDR_DQS_WIDTH     : integer := 4;
    constant DDR_DM_WIDTH      : integer := 4;
    constant DDR_ROW_WIDTH     : integer := 16;
    constant DDR_BANK_WIDTH    : integer := 3;
    constant DDR_CK_WIDTH      : integer := 1;
    constant DDR_CKE_WIDTH     : integer := 1;
    constant DDR_ODT_WIDTH     : integer := 1
    );
  port (
    --DDR3 memory pins
    ddr3_dq      : inout std_logic_vector(DDR_DQ_WIDTH-1 downto 0);
    ddr3_dqs_p   : inout std_logic_vector(DDR_DQS_WIDTH-1 downto 0);
    ddr3_dqs_n   : inout std_logic_vector(DDR_DQS_WIDTH-1 downto 0);
    ddr3_addr    : out   std_logic_vector(DDR_ROW_WIDTH-1 downto 0);
    ddr3_ba      : out   std_logic_vector(DDR_BANK_WIDTH-1 downto 0);
    ddr3_ras_n   : out   std_logic;
    ddr3_cas_n   : out   std_logic;
    ddr3_we_n    : out   std_logic;
    ddr3_reset_n : out   std_logic;
    ddr3_ck_p    : out   std_logic_vector(DDR_CK_WIDTH-1 downto 0);
    ddr3_ck_n    : out   std_logic_vector(DDR_CK_WIDTH-1 downto 0);
    ddr3_cke     : out   std_logic_vector(DDR_CKE_WIDTH-1 downto 0);
    ddr3_cs_n    : out   std_logic_vector(0 downto 0);
    ddr3_dm      : out   std_logic_vector(DDR_DM_WIDTH-1 downto 0);
    ddr3_odt     : out   std_logic_vector(DDR_ODT_WIDTH-1 downto 0);
    -- PCIe transceivers
    pci_exp_rxp : in  std_logic_vector(pcieLanes - 1 downto 0);
    pci_exp_rxn : in  std_logic_vector(pcieLanes - 1 downto 0);
    pci_exp_txp : out std_logic_vector(pcieLanes - 1 downto 0);
    pci_exp_txn : out std_logic_vector(pcieLanes - 1 downto 0);
    -- Necessity signals
    ddr_sys_clk_p : in std_logic;
    ddr_sys_clk_n : in std_logic;
    sys_clk_p     : in std_logic;
    sys_clk_n     : in std_logic;
    sys_rst_n     : in std_logic
    );
end entity top;

architecture arch of top is

  -- WISHBONE SLAVE interface:
  -- Single-Port RAM with Asynchronous Read
  --
  component WB_MEM is
    generic(
      AWIDTH : natural range 2 to 29 := 7;
      DWIDTH : natural range 8 to 128 := 64
    );
    port(
      CLK_I : in  std_logic;
      ACK_O : out std_logic;
      ADR_I : in  std_logic_vector(AWIDTH-1 downto 0);
      DAT_I : in  std_logic_vector(DWIDTH-1 downto 0);
      DAT_O : out std_logic_vector(DWIDTH-1 downto 0);
      STB_I : in  std_logic;
      WE_I  : in  std_logic
    );
  end component;

  signal ddr_sys_clk_i : std_logic;
  signal ddr_sys_rst_i : std_logic;

  signal pll_clkin : std_logic;
  signal pll_clkfbout : std_logic;
  signal pll_clkout0 : std_logic;
  signal pll_locked : std_logic;

  signal wbone_clk   : std_logic;
  signal wbone_addr  : std_logic_vector(31 downto 0);
  signal wbone_mdin  : std_logic_vector(C_DBUS_WIDTH-1 downto 0);
  signal wbone_mdout : std_logic_vector(C_DBUS_WIDTH-1 downto 0);
  signal wbone_we    : std_logic;
  signal wbone_sel   : std_logic_vector(0 downto 0);
  signal wbone_stb   : std_logic;
  signal wbone_ack   : std_logic;
  signal wbone_cyc   : std_logic;
  signal wbone_rst   : std_logic;

begin
    bpm_pcie : bpm_pcie_a7
    generic map(
      SIMULATION => SIMULATION,
      -- ****
      -- PCIe core parameters
      -- ****
      pcieLanes     => pcieLanes,
      PL_FAST_TRAIN => PL_FAST_TRAIN,
      PIPE_SIM_MODE => PIPE_SIM_MODE
      )
    port map(
      --DDR3 memory pins
      ddr3_dq      => ddr3_dq,
      ddr3_dqs_p   => ddr3_dqs_p,
      ddr3_dqs_n   => ddr3_dqs_n,
      ddr3_addr    => ddr3_addr,
      ddr3_ba      => ddr3_ba,
      ddr3_ras_n   => ddr3_ras_n,
      ddr3_cas_n   => ddr3_cas_n,
      ddr3_we_n    => ddr3_we_n,
      ddr3_reset_n => ddr3_reset_n,
      ddr3_ck_p    => ddr3_ck_p,
      ddr3_ck_n    => ddr3_ck_n,
      ddr3_cke     => ddr3_cke,
      ddr3_cs_n    => ddr3_cs_n,
      ddr3_dm      => ddr3_dm,
      ddr3_odt     => ddr3_odt,
      -- PCIe transceivers
      pci_exp_rxp => pci_exp_rxp,
      pci_exp_rxn => pci_exp_rxn,
      pci_exp_txp => pci_exp_txp,
      pci_exp_txn => pci_exp_txn,
      -- Necessity signals
      ddr_sys_clk_p => ddr_sys_clk_i,
      ddr_sys_clk_n => '0',
      sys_clk_p     => sys_clk_p,
      sys_clk_n     => sys_clk_n,
      sys_rst_n     => sys_rst_n,

      -- DDR memory controller interface --
      -- uncomment when instantiating in another project
      ddr_core_rst   => ddr_sys_rst_i,
      memc_ui_clk    => open,
      memc_ui_rst    => open,
      memc_cmd_rdy   => open,
      memc_cmd_en    => '0',
      memc_cmd_instr => (others => '0'),
      memc_cmd_addr  => (others => '0'),
      memc_wr_en     => '0',
      memc_wr_end    => '0',
      memc_wr_mask   => (others => '0'),
      memc_wr_data   => (others => '0'),
      memc_wr_rdy    => open,
      memc_rd_data   => open,
      memc_rd_valid  => open,
      ---- memory arbiter interface
      memarb_acc_req => '0',
      memarb_acc_gnt => open,
      --/ DDR memory controller interface

      -- Wishbone interface --
      -- uncomment when instantiating in another project
      CLK_I  => wbone_clk,
      RST_I  => wbone_rst,
      ACK_I  => wbone_ack,
      DAT_I  => wbone_mdin,
      ADDR_O => wbone_addr(28 downto 0),
      DAT_O  => wbone_mdout,
      WE_O   => wbone_we,
      STB_O  => wbone_stb,
      SEL_O  => wbone_sel(0),
      CYC_O  => wbone_cyc,
      --/ Wishbone interface
      -- Additional exported signals for instantiation
      ext_rst_o => wbone_rst
    );

  Wishbone_mem_large: if (SIMULATION = "TRUE") generate
    wb_mem_sim :
      wb_mem
        generic map(
          AWIDTH => 16,
          DWIDTH => 64
        )
        port map(
          CLK_I => wbone_clk, --in  std_logic;
          ACK_O => wbone_ack, --out std_logic;
          ADR_I => wbone_addr(16-1 downto 0), --in  std_logic_vector(AWIDTH-1 downto 0);
          DAT_I => wbone_mdout, --in  std_logic_vector(DWIDTH-1 downto 0);
          DAT_O => wbone_mdin, --out std_logic_vector(DWIDTH-1 downto 0);
          STB_I => wbone_stb, --in  std_logic;
          WE_I  => wbone_we --in  std_logic
        );

  end generate;

  Wishbone_mem_sample: if (SIMULATION = "FALSE") generate
    wb_mem_syn :
      wb_mem
        generic map(
          AWIDTH => 7,
          DWIDTH => 64
        )
        port map(
          CLK_I => wbone_clk, --in  std_logic;
          ACK_O => wbone_ack, --out std_logic;
          ADR_I => wbone_addr(7-1 downto 0), --in  std_logic_vector(AWIDTH-1 downto 0);
          DAT_I => wbone_mdout, --in  std_logic_vector(DWIDTH-1 downto 0);
          DAT_O => wbone_mdin, --out std_logic_vector(DWIDTH-1 downto 0);
          STB_I => wbone_stb, --in  std_logic;
          WE_I  => wbone_we --in  std_logic
        );

  end generate;

  --temporary clock assignment
  wbone_clk <= pll_clkin;

  ddr_inclk_buf : IBUFGDS
    port map
     (o  => pll_clkin,
      i  => ddr_sys_clk_p,
      ib => ddr_sys_clk_n
    );

  plle2_adv_inst : PLLE2_ADV
  generic map
   (bandwidth         => "high",
   compensation       => "zhold",
   divclk_divide      => 5,
   clkfbout_mult      => 64,
   clkfbout_phase     => 0.000,
   clkout0_divide     => 8,
   clkout0_phase      => 0.000,
   clkout0_duty_cycle => 0.500,
   clkin1_period      => 8.000,
   ref_jitter1        => 0.010)
  port map
    -- output clocks
   (clkfbout => pll_clkfbout,
   clkout0   => pll_clkout0,
   clkout1   => open,
   clkout2   => open,
   clkout3   => open,
   clkout4   => open,
   clkout5   => open,
    -- input clock control
    clkfbin => pll_clkfbout,
    clkin1  => pll_clkin,
    clkin2  => '0',
    -- tied to always select the primary input clock
    clkinsel => '1',
    -- ports for dynamic reconfiguration
    daddr => (others => '0'),
    DCLK  => '0',
    DEN   => '0',
    DI    => (others => '0'),
    DO    => open,
    DRDY  => open,
    DWE   => '0',
    -- Other control and status signals
    LOCKED => pll_locked,
    PWRDWN => '0',
    RST    => '0');

  -- Output buffering
  -------------------------------------
  clkout1_buf : BUFG
    port map
    (O => ddr_sys_clk_i,
    I  => pll_clkout0
    );

  ddr_sys_rst_i <= not(pll_locked);

end architecture;

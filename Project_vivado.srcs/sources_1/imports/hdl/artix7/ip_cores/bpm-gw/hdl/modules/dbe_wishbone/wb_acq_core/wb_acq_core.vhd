------------------------------------------------------------------------------
-- Title      : BPM Data Acquisition
------------------------------------------------------------------------------
-- Author     : Lucas Maziero Russo
-- Company    : CNPEM LNLS-DIG
-- Created    : 2013-22-10
-- Platform   : FPGA-generic
-------------------------------------------------------------------------------
-- Description: Top Module for the BPM Data Acquisition
--
--              It allows for the following types of acquisition:
--               1) Simple acquisition on request
--               2) Pre-trigger acquisition
--               3) Post-trigger acquisition
--               4) Pre+Post-trigger acquisition
--
--               TODO: fix FIXMEs
--                     do TODOs
--                     implement anti-overflow in main FIFO (acquire until
--                       the requested number of samples or until the FIFO is
--                       full and another valid samples comes in). Report this
--                       to the user through a wishbone register or some other
--                       method
-------------------------------------------------------------------------------
-- Copyright (c) 2013 CNPEM
-- Licensed under GNU Lesser General Public License (LGPL) v3.0
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2013-22-10  1.0      lucas.russo        Created
-------------------------------------------------------------------------------

-- Based on FMC-ADC-100M (http://www.ohwr.org/projects/fmc-adc-100m14b4cha/repository)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
-- Main Wishbone Definitions
use work.wishbone_pkg.all;
-- General common cores
use work.gencores_pkg.all;
-- Genrams cores
use work.genram_pkg.all;
-- BPM acq core cores
use work.acq_core_pkg.all;
-- BPM FSM Acq Regs
use work.acq_core_wbgen2_pkg.all;
-- DBE wishbone cores
use work.dbe_wishbone_pkg.all;
-- DBE Common cores
use work.dbe_common_pkg.all;

entity wb_acq_core is
generic
(
  g_interface_mode                          : t_wishbone_interface_mode      := CLASSIC;
  g_address_granularity                     : t_wishbone_address_granularity := WORD;
  g_acq_addr_width                          : natural := 32;
  g_acq_num_channels                        : natural := c_default_acq_num_channels;
  g_acq_channels                            : t_acq_chan_param_array := c_default_acq_chan_param_array;
  g_ddr_payload_width                       : natural := 256;     -- be careful changing these!
  g_ddr_dq_width                            : natural := 64;      -- be careful changing these!
  g_ddr_addr_width                          : natural := 32;      -- be careful changing these!
  g_multishot_ram_size                      : natural := 2048;
  g_fifo_fc_size                            : natural := 64;
  g_sim_readback                            : boolean := false
);
port
(
  fs_clk_i                                  : in std_logic;
  fs_ce_i                                   : in std_logic;
  fs_rst_n_i                                : in std_logic;

  sys_clk_i                                 : in std_logic;
  sys_rst_n_i                               : in std_logic;

  ext_clk_i                                 : in std_logic;
  ext_rst_n_i                               : in std_logic;

  -----------------------------
  -- Wishbone Control Interface signals
  -----------------------------

  wb_adr_i                                  : in  std_logic_vector(c_wishbone_address_width-1 downto 0) := (others => '0');
  wb_dat_i                                  : in  std_logic_vector(c_wishbone_data_width-1 downto 0) := (others => '0');
  wb_dat_o                                  : out std_logic_vector(c_wishbone_data_width-1 downto 0);
  wb_sel_i                                  : in  std_logic_vector(c_wishbone_data_width/8-1 downto 0) := (others => '0');
  wb_we_i                                   : in  std_logic := '0';
  wb_cyc_i                                  : in  std_logic := '0';
  wb_stb_i                                  : in  std_logic := '0';
  wb_ack_o                                  : out std_logic;
  wb_err_o                                  : out std_logic;
  wb_rty_o                                  : out std_logic;
  wb_stall_o                                : out std_logic;

  -----------------------------
  -- External Interface
  -----------------------------
  acq_val_low_i                             : in t_acq_val_half_array(g_acq_num_channels-1 downto 0);
  acq_val_high_i                            : in t_acq_val_half_array(g_acq_num_channels-1 downto 0);
  acq_dvalid_i                              : in std_logic_vector(g_acq_num_channels-1 downto 0);
  acq_trig_i                                : in std_logic_vector(g_acq_num_channels-1 downto 0);

  -----------------------------
  -- DRRAM Interface
  -----------------------------
  dpram_dout_o                              : out std_logic_vector(f_acq_chan_find_widest(g_acq_channels)-1 downto 0);
  dpram_valid_o                             : out std_logic;

  -----------------------------
  -- External Interface (w/ FLow Control)
  -----------------------------
  ext_dout_o                                : out std_logic_vector(g_ddr_payload_width-1 downto 0);
  ext_valid_o                               : out std_logic;
  ext_addr_o                                : out std_logic_vector(g_acq_addr_width-1 downto 0);
  ext_sof_o                                 : out std_logic;
  ext_eof_o                                 : out std_logic;
  ext_dreq_o                                : out std_logic; -- for debbuging purposes
  ext_stall_o                               : out std_logic; -- for debbuging purposes

  -----------------------------
  -- DDR3 SDRAM Interface
  -----------------------------
  ui_app_addr_o                             : out std_logic_vector(g_ddr_addr_width-1 downto 0);
  ui_app_cmd_o                              : out std_logic_vector(2 downto 0);
  ui_app_en_o                               : out std_logic;
  ui_app_rdy_i                              : in std_logic;

  ui_app_wdf_data_o                         : out std_logic_vector(g_ddr_payload_width-1 downto 0);
  ui_app_wdf_end_o                          : out std_logic;
  ui_app_wdf_mask_o                         : out std_logic_vector(g_ddr_payload_width/8-1 downto 0);
  ui_app_wdf_wren_o                         : out std_logic;
  ui_app_wdf_rdy_i                          : in std_logic;

  ui_app_rd_data_i                          : in std_logic_vector(g_ddr_payload_width-1 downto 0);
  ui_app_rd_data_end_i                      : in std_logic;
  ui_app_rd_data_valid_i                    : in std_logic;

  ui_app_req_o                              : out std_logic;
  ui_app_gnt_i                              : in std_logic;

  -----------------------------
  -- Debug Interface
  -----------------------------
  dbg_ddr_rb_start_p_i                      : in std_logic;
  dbg_ddr_rb_rdy_o                          : out std_logic;
  dbg_ddr_rb_data_o                         : out std_logic_vector(g_ddr_payload_width-1 downto 0);
  dbg_ddr_rb_addr_o                         : out std_logic_vector(g_acq_addr_width-1 downto 0);
  dbg_ddr_rb_valid_o                        : out std_logic
);
end wb_acq_core;

architecture rtl of wb_acq_core is

  alias c_acq_channels : t_acq_chan_param_array(g_acq_num_channels-1 downto 0) is g_acq_channels;

  -----------------------------
  -- General Constants
  -----------------------------
  constant c_acq_samples_size               : natural := 32;
  constant c_dpram_depth                    : integer := f_log2_size(g_multishot_ram_size);
  constant c_periph_addr_size               : natural := 3+3;

  constant c_acq_data_width                 : natural :=
                                  f_acq_chan_find_widest(c_acq_channels);

  constant c_fc_pipe_size                   : natural := 8;

  ------------------------------------------------------------------------------
  -- Types declaration
  ------------------------------------------------------------------------------

  -- Registers Signals
  signal regs_in                            : t_acq_core_in_registers;
  signal regs_out                           : t_acq_core_out_registers;

  -- Wishbone slave adapter signals/structures
  signal wb_slv_adp_out                     : t_wishbone_master_out;
  signal wb_slv_adp_in                      : t_wishbone_master_in;
  signal resized_addr                       : std_logic_vector(c_wishbone_address_width-1 downto 0);

  -- Trigger
  signal ext_trig_a                         : std_logic;
  signal ext_trig                           : std_logic;
  signal int_trig                           : std_logic;
  signal int_trig_over_thres                : std_logic;
  signal int_trig_over_thres_d              : std_logic;
  signal int_trig_sel                       : std_logic_vector(1 downto 0);
  signal int_trig_data                      : std_logic_vector(15 downto 0);
  signal int_trig_thres                     : std_logic_vector(15 downto 0);
  signal hw_trig_pol                        : std_logic;
  signal hw_trig                            : std_logic;
  signal hw_trig_t                          : std_logic;
  signal hw_trig_sel                        : std_logic;
  signal hw_trig_en                         : std_logic;
  signal sw_trig                            : std_logic;
  signal sw_trig_t                          : std_logic;
  signal sw_trig_en                         : std_logic;
  signal trig                               : std_logic;
  signal trig_delay                         : std_logic_vector(31 downto 0);
  signal trig_delay_cnt                     : unsigned(31 downto 0);
  signal trig_d                             : std_logic;
  signal trig_align                         : std_logic;

  ---- Acquisition FSM
  signal acq_fsm_state                      : std_logic_vector(2 downto 0);
  signal acq_start                          : std_logic;
  signal acq_start_sync_ext                 : std_logic;
  signal acq_start_sync_fs                  : std_logic;
  signal acq_now                            : std_logic;
  signal acq_stop                           : std_logic;
  signal acq_end                            : std_logic;
  signal acq_trig                           : std_logic;
  signal acq_in_pre_trig                    : std_logic;
  signal acq_in_wait_trig                   : std_logic;
  signal acq_in_post_trig                   : std_logic;
  signal acq_data_marsh                     : std_logic_vector(c_acq_chan_max_w-1 downto 0);
  signal acq_trig_in                        : std_logic;
  signal acq_dvalid_in                      : std_logic;
  signal samples_wr_en                      : std_logic;

  -- Pre/Post trigger and shots counters
  signal pre_trig_samples_c                 : unsigned(c_acq_samples_size-1 downto 0);
  signal post_trig_samples_c                : unsigned(c_acq_samples_size-1 downto 0);
  signal shots_nb_c                         : unsigned(15 downto 0);

  signal acq_single_shot                    : std_logic;
  signal acq_ddr3_start_addr_full           : std_logic_vector(31 downto 0); -- full 32-bit address
  signal acq_ddr3_start_addr                : std_logic_vector(g_ddr_addr_width-1 downto 0);

  signal acq_pre_trig_done                  : std_logic;
  signal acq_wait_trig_skip_done            : std_logic;
  signal acq_post_trig_done                 : std_logic;
  signal lmt_curr_chan_id                   : unsigned(c_chan_id_width-1 downto 0);
  signal samples_cnt                        : unsigned(c_acq_samples_size-1 downto 0);
  signal shots_cnt                          : unsigned(15 downto 0);
  signal shots_decr                         : std_logic;
  signal multishot_buffer_sel               : std_logic;

  -- Packet size for ext interface
  signal lmt_acq_pkt_size                   : unsigned(c_acq_samples_size-1 downto 0);
  signal lmt_shots_nb                       : unsigned(15 downto 0);
  signal lmt_valid                          : std_logic;

  -- Multi-shot mode
  signal dpram_addra_cnt                    : unsigned(c_dpram_depth-1 downto 0);
  signal dpram_addra_trig                   : unsigned(c_dpram_depth-1 downto 0);
  signal dpram_addra_post_done              : unsigned(c_dpram_depth-1 downto 0);
  signal dpram_addrb_cnt                    : unsigned(c_dpram_depth-1 downto 0);
  signal dpram_dout                         : std_logic_vector(c_acq_data_width-1 downto 0);
  signal dpram_valid                        : std_logic;

  -- FIFO Flow Control signals
  signal fifo_fc_req_rst_trans              : std_logic;

  signal fifo_fc_all_trans_done_p           : std_logic;
  signal fifo_fc_all_trans_done_l           : std_logic;
  signal fifo_fc_full                       : std_logic;
  signal fifo_fc_full_l                     : std_logic;

  -- External memory interface signals
  signal ext_dout                           : std_logic_vector(g_ddr_payload_width-1 downto 0);
  signal ext_valid                          : std_logic;
  signal ext_sof                            : std_logic;
  signal ext_eof                            : std_logic;
  signal ext_addr                           : std_logic_vector(g_ddr_addr_width-1 downto 0);
  signal ext_dreq                           : std_logic;
  signal ext_stall                          : std_logic;

  -- External memory interface debug signals
  signal dbg_fifo_we		                    : std_logic;
  signal dbg_fifo_wr_count	                : std_logic_vector(f_log2_size(g_fifo_fc_size)-1 downto 0);
  signal dbg_fifo_re		                    : std_logic;
  signal dbg_fifo_fc_rd_en	                : std_logic;
  signal dbg_fifo_rd_empty	                : std_logic;
  signal dbg_fifo_wr_full	                  : std_logic;
  signal dbg_fifo_fc_valid_fwft			        : std_logic;
  signal dbg_source_pl_dreq	                : std_logic;
  signal dbg_source_pl_stall	              : std_logic;

  signal dbg_pkt_ct_cnt                     : std_logic_vector(c_pkt_size_width-1 downto 0);
  signal dbg_shots_cnt                      : std_logic_vector(c_shots_size_width-1 downto 0);

  -- DDR3 signals
  signal ddr3_wr_all_trans_done_p           : std_logic;
  signal ddr3_wr_all_trans_done_l           : std_logic;
  signal sim_in_rb                          : std_logic;
  signal ddr3_rb_lmt_rb_rst                 : std_logic;
  signal acq_ddr3_rst_n                     : std_logic;

  signal dbg_ddr_rb_data                    : std_logic_vector(g_ddr_payload_width-1 downto 0);
  signal dbg_ddr_rb_addr                    : std_logic_vector(g_acq_addr_width-1 downto 0);
  signal dbg_ddr_rb_valid                   : std_logic;

  signal ddr3_rb_start                      : std_logic;
  signal ddr3_rb_all_trans_done_p           : std_logic;

  signal ddr3_all_trans_done_l              : std_logic;
  signal ddr3_all_trans_done_p              : std_logic;
  signal ddr3_all_trans_done_p_fs           : std_logic;

  -- UI multiplexed signals
  signal ui_app_rb_addr                     : std_logic_vector(g_ddr_addr_width-1 downto 0);
  signal ui_app_rb_cmd                      : std_logic_vector(2 downto 0);
  signal ui_app_rb_en                       : std_logic;
  signal ui_app_rb_req                      : std_logic;
  signal ui_app_rb_gnt                      : std_logic;

  signal ui_app_wdf_addr                    : std_logic_vector(g_ddr_addr_width-1 downto 0);
  signal ui_app_wdf_cmd                     : std_logic_vector(2 downto 0);
  signal ui_app_wdf_en                      : std_logic;
  signal ui_app_wdf_req                     : std_logic;
  signal ui_app_wdf_gnt                     : std_logic;

  -- RAM address counter
  signal test_data_en                       : std_logic;
  signal trig_addr                          : std_logic_vector(31 downto 0);

  ------------------------------------------------------------------------------
  -- Components
  ------------------------------------------------------------------------------

  component acq_core_regs
  port (
    rst_n_i                                  : in     std_logic;
    clk_sys_i                                : in     std_logic;
    wb_adr_i                                 : in     std_logic_vector(3 downto 0);
    wb_dat_i                                 : in     std_logic_vector(31 downto 0);
    wb_dat_o                                 : out    std_logic_vector(31 downto 0);
    wb_cyc_i                                 : in     std_logic;
    wb_sel_i                                 : in     std_logic_vector(3 downto 0);
    wb_stb_i                                 : in     std_logic;
    wb_we_i                                  : in     std_logic;
    wb_ack_o                                 : out    std_logic;
    wb_stall_o                               : out    std_logic;
    fs_clk_i                                 : in     std_logic;
    ext_clk_i                                : in     std_logic;
    regs_i                                   : in     t_acq_core_in_registers;
    regs_o                                   : out    t_acq_core_out_registers
  );
  end component;

begin

  -----------------------------
  -- Slave adapter for Wishbone Register Interface
  -----------------------------
  cmp_slave_adapter : wb_slave_adapter
  generic map (
    g_master_use_struct                     => true,
    g_master_mode                           => PIPELINED,
    g_master_granularity                    => WORD,
    g_slave_use_struct                      => false,
    g_slave_mode                            => g_interface_mode,
    g_slave_granularity                     => g_address_granularity
  )
  port map (
    clk_sys_i                               => sys_clk_i,
    rst_n_i                                 => sys_rst_n_i,
    master_i                                => wb_slv_adp_in,
    master_o                                => wb_slv_adp_out,
    sl_adr_i                                => resized_addr,
    sl_dat_i                                => wb_dat_i,
    sl_sel_i                                => wb_sel_i,
    sl_cyc_i                                => wb_cyc_i,
    sl_stb_i                                => wb_stb_i,
    sl_we_i                                 => wb_we_i,
    sl_dat_o                                => wb_dat_o,
    sl_ack_o                                => wb_ack_o,
    sl_rty_o                                => wb_rty_o,
    sl_err_o                                => wb_err_o,
    sl_int_o                                => open,
    sl_stall_o                              => wb_stall_o
  );

  resized_addr(c_periph_addr_size-1 downto 0)
                                            <= wb_adr_i(c_periph_addr_size-1 downto 0);
  resized_addr(c_wishbone_address_width-1 downto c_periph_addr_size)
                                            <= (others => '0');

  -----------------------------
  -- BPM Acq Register Wishbone Interface. Word addressed!
  -----------------------------
  --BPM Acq register interface, word addressed
  cmp_acq_core_regs : acq_core_regs
  port map(
    rst_n_i                                 => sys_rst_n_i,
    clk_sys_i                               => sys_clk_i,
    wb_adr_i                                => wb_slv_adp_out.adr(3 downto 0),
    wb_dat_i                                => wb_slv_adp_out.dat,
    wb_dat_o                                => wb_slv_adp_in.dat,
    wb_cyc_i                                => wb_slv_adp_out.cyc,
    wb_sel_i                                => wb_slv_adp_out.sel,
    wb_stb_i                                => wb_slv_adp_out.stb,
    wb_we_i                                 => wb_slv_adp_out.we,
    wb_ack_o                                => wb_slv_adp_in.ack,
    wb_stall_o                              => wb_slv_adp_in.stall,
    fs_clk_i                                => fs_clk_i,
    ext_clk_i                               => ext_clk_i,
    regs_i                                  => regs_in,
    regs_o                                  => regs_out
  );

  -- Unused wishbone signals
  wb_slv_adp_in.int                         <= '0';
  wb_slv_adp_in.err                         <= '0';
  wb_slv_adp_in.rty                         <= '0';

  -- Input register assignments
  --regs_in.sta_fsm_i                         <= acq_fsm_state;
  --regs_in.sta_reserved_i                    <= (others => '0');
  --regs_in.trig_pos_i                        <= (others => '0');
  --regs_in.samples_cnt_i                     <= std_logic_vector(samples_cnt);

  pre_trig_samples_c                        <= unsigned(regs_out.pre_samples_o);
  post_trig_samples_c                       <= unsigned(regs_out.post_samples_o);
  shots_nb_c                                <= unsigned(regs_out.shots_nb_o);

  lmt_curr_chan_id                          <= unsigned(regs_out.acq_chan_ctl_which_o); -- 5-bit

  -- Synchronous to ext_clk_i
  acq_ddr3_start_addr_full                  <= regs_out.ddr3_start_addr_o;

  -- Truncate address to the actually width of external memory
  -- Synchronous to ext_clk_i
  acq_ddr3_start_addr                       <= acq_ddr3_start_addr_full(acq_ddr3_start_addr'left downto 0);

  acq_start                                 <= regs_out.ctl_fsm_start_acq_o; -- 1 fs_clk cycle pulse
  acq_stop                                  <= regs_out.ctl_fsm_stop_acq_o; -- 1 fs_clk cycle pulse
  acq_now                                   <= regs_out.ctl_fsm_acq_now_o;

  regs_in.sta_fsm_state_i                   <= acq_fsm_state;
  regs_in.sta_fsm_acq_done_i                <= acq_end;
  regs_in.sta_reserved1_i                   <= dbg_fifo_rd_empty & dbg_fifo_fc_rd_en & dbg_fifo_re & dbg_fifo_we;
  regs_in.sta_fc_trans_done_i               <= fifo_fc_all_trans_done_l;
  regs_in.sta_fc_full_i                     <= fifo_fc_full_l;
  regs_in.sta_reserved2_i                   <= "00" & dbg_source_pl_stall & dbg_source_pl_dreq &
                                               dbg_fifo_fc_valid_fwft & dbg_fifo_wr_full;
  regs_in.sta_ddr3_trans_done_i             <= ddr3_all_trans_done_l;
  regs_in.sta_reserved3_i                   <= dbg_pkt_ct_cnt(14 downto 0);
  regs_in.trig_pos_i                        <= (others => '0');
  regs_in.samples_cnt_i                     <= std_logic_vector(samples_cnt);

  cmp_acq_sel_chan : acq_sel_chan
  generic map
  (
    g_acq_num_channels                      => g_acq_num_channels
  )
  port map
  (
    clk_i                                   => fs_clk_i,
    rst_n_i                                 => fs_rst_n_i,

    -----------------------------
    -- Acquisiton Interface
    -----------------------------
    acq_val_low_i                           => acq_val_low_i,
    acq_val_high_i                          => acq_val_high_i,
    acq_dvalid_i                            => acq_dvalid_i,
    acq_trig_i                              => acq_trig_i,
    acq_curr_chan_id_i                      => lmt_curr_chan_id,

    -----------------------------
    -- Output Interface.
    -----------------------------
    acq_data_o                              => acq_data_marsh,
    acq_dvalid_o                            => acq_dvalid_in,
    acq_trig_o                              => acq_trig_in
  );

  -- Wait acknowledge signal from ext clk domain to initiaite the acquisition
  cmp_sync_acq_start : gc_pulse_synchronizer
    port map(
      clk_in_i                                => ext_clk_i,
      clk_out_i                               => fs_clk_i,
      rst_n_i                                 => ext_rst_n_i,
      d_ready_o                               => open,
      d_p_i                                   => acq_start_sync_ext,
      q_p_o                                   => acq_start_sync_fs
    );

  cmp_acq_fsm : acq_fsm
  port map
  (
    fs_clk_i                                  => fs_clk_i,
    fs_ce_i                                   => fs_ce_i,
    fs_rst_n_i                                => fs_rst_n_i,

    -----------------------------
    -- FSM Commands (Inputs)
    -----------------------------
    acq_start_i                               => acq_start_sync_fs,
    acq_now_i                                 => acq_now,
    acq_stop_i                                => acq_stop,
    acq_trig_i                                => acq_trig_in,
    acq_dvalid_i                              => acq_dvalid_in,

    -----------------------------
    -- FSM Number of Samples
    -----------------------------
    pre_trig_samples_i                        => pre_trig_samples_c,
    post_trig_samples_i                       => post_trig_samples_c,
    shots_nb_i                                => shots_nb_c,
    samples_cnt_o                             => samples_cnt,

    -----------------------------
    -- FSM Monitoring
    -----------------------------
    acq_end_o                                 => acq_end,
    acq_single_shot_o                         => acq_single_shot,
    acq_in_pre_trig_o                         => acq_in_pre_trig,
    acq_in_wait_trig_o                        => acq_in_wait_trig,
    acq_in_post_trig_o                        => acq_in_post_trig,
    acq_pre_trig_done_o                       => acq_pre_trig_done,
    acq_wait_trig_skip_done_o                 => acq_wait_trig_skip_done,
    acq_post_trig_done_o                      => acq_post_trig_done,
    acq_fsm_state_o                           => acq_fsm_state,

    -----------------------------
    -- FSM Outputs
    -----------------------------
    shots_decr_o                              => shots_decr,
    acq_trig_o                                => acq_trig,
    multishot_buffer_sel_o                    => multishot_buffer_sel,
    samples_wr_en_o                           => samples_wr_en
  );

  ------------------------------------------------------------------------------
  -- Dual DPRAM buffers for multi-shots acquisition
  -----------------------------------------------------------------------------
  cmp_acq_multishot_dpram : acq_multishot_dpram
  generic map
  (
    g_data_width                            => c_acq_data_width,
    g_multishot_ram_size                    => g_multishot_ram_size
  )
  port map
  (
    fs_clk_i                                => fs_clk_i,
    fs_ce_i                                 => fs_ce_i,
    fs_rst_n_i                              => fs_rst_n_i,

    data_i                                  => acq_data_marsh(c_acq_data_width-1 downto 0),
    dvalid_i                                => acq_dvalid_in,
    wr_en_i                                 => samples_wr_en,
    addr_rst_i                              => shots_decr,

    buffer_sel_i                            => multishot_buffer_sel,
    acq_trig_i                              => acq_trig,

    pre_trig_samples_i                      => pre_trig_samples_c,
    post_trig_samples_i                     => post_trig_samples_c,

    acq_pre_trig_done_i                     => acq_pre_trig_done,
    acq_wait_trig_skip_done_i               => acq_wait_trig_skip_done,
    acq_post_trig_done_i                    => acq_post_trig_done,

    dpram_dout_o                            => dpram_dout,
    dpram_valid_o                           => dpram_valid
  );

  dpram_dout_o                              <=  dpram_dout;
  dpram_valid_o                             <=  dpram_valid;

  ------------------------------------------------------------------------------
  -- Flow control FIFO for data to DDR
  ------------------------------------------------------------------------------

  cmp_acq_fc_fifo : acq_fc_fifo
  generic map (
    g_data_out_width                        => g_ddr_payload_width,
    g_addr_width                            => g_ddr_addr_width,
    g_acq_num_channels                      => g_acq_num_channels,
    g_acq_channels                          => g_acq_channels,
    g_fifo_size                             => g_fifo_fc_size,
    g_fc_pipe_size                          => c_fc_pipe_size
  )
  port map
  (
    fs_clk_i                                => fs_clk_i,
    fs_ce_i                                 => fs_ce_i,
    fs_rst_n_i                              => fs_rst_n_i,

    -- DDR3 external clock
    ext_clk_i                               => ext_clk_i,
    ext_rst_n_i                             => ext_rst_n_i,

    dpram_data_i                            => dpram_dout,
    dpram_dvalid_i                          => dpram_valid,

    pt_data_i                               => acq_data_marsh(c_acq_data_width-1 downto 0),
    pt_dvalid_i                             => acq_dvalid_in,
    pt_wr_en_i                              => samples_wr_en,

    -- Request transaction reset as soon as possible (when all outstanding
    -- transactions have been commited)
    req_rst_trans_i                         => fifo_fc_req_rst_trans, -- FIXME: Could this be acq_start = '1'???
    -- Select between multi-buffer mode and pass-through mode (data directly
    -- through external module interface)
    passthrough_en_i                        => acq_single_shot,
    -- Which buffer (0 or 1) to store data in. Valid only when passthrough_en_i = '0'
    buffer_sel_i                            => multishot_buffer_sel,

    -- Current channel selection ID
    lmt_curr_chan_id_i                      => lmt_curr_chan_id,
    -- Size of the transaction in g_size bytes
    lmt_pkt_size_i                          => lmt_acq_pkt_size,
    -- Number of shots in this acquisition
    lmt_shots_nb_i                          => lmt_shots_nb,
    --lmt_valid_i                             => lmt_valid,
    lmt_valid_i                             => acq_start_sync_ext,

    fifo_fc_all_trans_done_p_o              => fifo_fc_all_trans_done_p,
    -- Asserted when the Acquisition FIFO is full. Data is lost when this signal is
    -- set and valid data keeps coming
    fifo_fc_full_o                          => fifo_fc_full,

    fifo_fc_dout_o                          => ext_dout,
    fifo_fc_valid_o                         => ext_valid,
    fifo_fc_addr_o                          => ext_addr,
    fifo_fc_sof_o                           => ext_sof,
    fifo_fc_eof_o                           => ext_eof,
    fifo_fc_dreq_i                          => ext_dreq,
    fifo_fc_stall_i                         => ext_stall,

    dbg_fifo_we_o		                	      => dbg_fifo_we,
    dbg_fifo_wr_count_o	                    => dbg_fifo_wr_count,
    dbg_fifo_re_o		                	      => dbg_fifo_re,
    dbg_fifo_fc_rd_en_o	                    => dbg_fifo_fc_rd_en,
    dbg_fifo_rd_empty_o	                    => dbg_fifo_rd_empty,
    dbg_fifo_wr_full_o	                    => dbg_fifo_wr_full,
    dbg_fifo_fc_valid_fwft_o			          => dbg_fifo_fc_valid_fwft,
    dbg_source_pl_dreq_o	                  => dbg_source_pl_dreq,
    dbg_source_pl_stall_o	                  => dbg_source_pl_stall,
    dbg_pkt_ct_cnt_o                        => dbg_pkt_ct_cnt,
    dbg_shots_cnt_o                         => dbg_shots_cnt
  );

  cmp_fifo_fc_all_trans : pulse2level
  port map
  (
    clk_i                                  => fs_clk_i,
    rst_n_i                                => fs_rst_n_i,

    pulse_i                                => fifo_fc_all_trans_done_p,
    clr_i                                  => acq_start_sync_fs,
    level_o                                => fifo_fc_all_trans_done_l
  );

  cmp_fifo_fc_full : pulse2level
  port map
  (
    clk_i                                  => fs_clk_i,
    rst_n_i                                => fs_rst_n_i,

    pulse_i                                => fifo_fc_full,
    clr_i                                  => acq_start_sync_fs,
    level_o                                => fifo_fc_full_l
  );

  -- When FSM in IDLE, request reset
  fifo_fc_req_rst_trans <= '1' when acq_fsm_state = "001" else '0';

  p_total_acq_sample : process (fs_clk_i)
  begin
    if rising_edge(fs_clk_i) then
      if fs_rst_n_i = '0' then
        lmt_acq_pkt_size <= to_unsigned(0, lmt_acq_pkt_size'length);
        lmt_shots_nb <= to_unsigned(0, lmt_shots_nb'length);
      else
        -- Be pessimist about overflow. Pick only the LSB of trig samples
        lmt_acq_pkt_size <= unsigned('0' & pre_trig_samples_c(c_acq_samples_size-2 downto 0)) +
                            unsigned('0' & post_trig_samples_c(c_acq_samples_size-2 downto 0));
        lmt_shots_nb <= shots_nb_c;
      end if;
    end if;
  end process;

  lmt_valid <= acq_start_sync_fs;

  ext_dout_o                                <= ext_dout;
  ext_valid_o                               <= ext_valid;
  ext_addr_o                                <= ext_addr;
  ext_sof_o                                 <= ext_sof;
  ext_eof_o                                 <= ext_eof;
  ext_dreq_o                                <= ext_dreq;   -- for debugging purposes
  ext_stall_o                               <= ext_stall;  -- for debugging purposes

  ------------------------------------------------------------------------------
  -- DDR3 Interface
  ------------------------------------------------------------------------------

  cmp_acq_ddr3_iface : acq_ddr3_iface
  generic map
  (
    g_acq_num_channels                        => g_acq_num_channels,
    g_acq_channels                            => g_acq_channels,
    g_fc_pipe_size                            => c_fc_pipe_size,
    -- Do not modify these! As they are dependent of the memory controller generated!
    g_ddr_payload_width                       => g_ddr_payload_width,
    g_ddr_dq_width                            => g_ddr_dq_width,
    g_ddr_addr_width                          => g_ddr_addr_width
  )
  port map
  (
    -- DDR3 external clock
    ext_clk_i                                 => ext_clk_i,
    ext_rst_n_i                               => ext_rst_n_i,

    -- Flow protocol to interface with external SDRAM. Evaluate the use of
    -- Wishbone Streaming protocol.
    fifo_fc_din_i                             => ext_dout,
    fifo_fc_valid_i                           => ext_valid,
    fifo_fc_addr_i                            => ext_addr,
    fifo_fc_sof_i                             => ext_sof,
    fifo_fc_eof_i                             => ext_eof,
    fifo_fc_dreq_o                            => ext_dreq,
    fifo_fc_stall_o                           => ext_stall,

    wr_start_i                                => acq_start_sync_ext,
    -- "acq_ddr3_start_addr" is synced with sys_clk, but we only read it after
    -- acq_start_sync_ext is set, which is sync to ext_clk. So, that does not
    -- impose any metastability problem in this module
    wr_init_addr_i                            => acq_ddr3_start_addr,

    lmt_all_trans_done_p_o                    => ddr3_wr_all_trans_done_p,
    lmt_rst_i                                 => '0', --remove this signal

    -- Current channel selection ID
    lmt_curr_chan_id_i                        => lmt_curr_chan_id,
    -- Size of the transaction in g_fifo_size bytes
    lmt_pkt_size_i                            => lmt_acq_pkt_size,
    -- Number of shots in this acquisition
    lmt_shots_nb_i                            => lmt_shots_nb,
    -- Acquisition limits valid signal. Qualifies lmt_fifo_pkt_size_i and lmt_shots_nb_i
    lmt_valid_i                               => acq_start_sync_ext,

    -- Xilinx DDR3 UI Interface
    ui_app_addr_o                             => ui_app_wdf_addr,
    ui_app_cmd_o                              => ui_app_wdf_cmd,
    ui_app_en_o                               => ui_app_wdf_en,
    ui_app_rdy_i                              => ui_app_rdy_i,

    ui_app_wdf_data_o                         => ui_app_wdf_data_o,
    ui_app_wdf_end_o                          => ui_app_wdf_end_o,
    ui_app_wdf_mask_o                         => ui_app_wdf_mask_o,
    ui_app_wdf_wren_o                         => ui_app_wdf_wren_o,
    ui_app_wdf_rdy_i                          => ui_app_wdf_rdy_i,

    ui_app_rd_data_i                          => ui_app_rd_data_i,
    ui_app_rd_data_end_i                      => ui_app_rd_data_end_i,
    ui_app_rd_data_valid_i                    => ui_app_rd_data_valid_i,

    ui_app_req_o                              => ui_app_wdf_req,
    ui_app_gnt_i                              => ui_app_wdf_gnt
  );

  cmp_sync_req_rst : gc_pulse_synchronizer
  port map (
    clk_in_i                                  => fs_clk_i,
    clk_out_i                                 => ext_clk_i,
    rst_n_i                                   => fs_rst_n_i,
    d_ready_o                                 => open,
    d_p_i                                     => acq_start, -- pulse input
    q_p_o                                     => acq_start_sync_ext -- pulse output
  );

  -- Only for simulation!
  gen_ddr3_readback : if (g_sim_readback) generate

    cmp_ddr3_wr_all_trans_done : pulse2level
    port map
    (
      clk_i                                => ext_clk_i,
      rst_n_i                              => ext_rst_n_i,

      pulse_i                              => ddr3_wr_all_trans_done_p,
      clr_i                                => acq_start_sync_ext,
      level_o                              => ddr3_wr_all_trans_done_l
    );

    sim_in_rb <= ddr3_wr_all_trans_done_l;
    ddr3_rb_lmt_rb_rst <= not ddr3_wr_all_trans_done_l;

    cmp_acq_ddr3_read : acq_ddr3_read
    generic map
    (
      g_acq_addr_width                      => g_acq_addr_width,
      g_acq_num_channels                    => g_acq_num_channels,
      g_acq_channels                        => g_acq_channels,
      -- Do not modify these! As they are dependent of the memory controller generated!
      g_ddr_payload_width                   => g_ddr_payload_width,
      g_ddr_dq_width                        => g_ddr_dq_width,
      g_ddr_addr_width                      => g_ddr_addr_width
    )
    port map
    (
      -- DDR3 external clock
      ext_clk_i                             => ext_clk_i,
      ext_rst_n_i                           => ext_rst_n_i,

      -- Flow protocol to interface with external SDRAM. Evaluate the use of
      -- Wishbone Streaming protocol.
      fifo_fc_din_o                         => dbg_ddr_rb_data,
      fifo_fc_valid_o                       => dbg_ddr_rb_valid,
      fifo_fc_addr_o                        => dbg_ddr_rb_addr,
      fifo_fc_sof_o                         => open,
      fifo_fc_eof_o                         => open,
      fifo_fc_dreq_i                        => '0',
      fifo_fc_stall_i                       => '0',

      -- Only start the readbak test when we have done writing and an external signal
      -- tells us to
      rb_start_i                            => ddr3_rb_start,
      -- "acq_ddr3_start_addr" is synced with sys_clk, but we only read it after
      -- ddr3_wr_all_trans_done_p is set, which is sync to ext_clk. So, that does not
      -- impose any metastability problem in this module
      rb_init_addr_i                        => acq_ddr3_start_addr,

      lmt_all_trans_done_p_o                => ddr3_rb_all_trans_done_p,
      lmt_rst_i                             => '0', -- remove this signal!

      -- Current channel selection ID
      lmt_curr_chan_id_i                    => lmt_curr_chan_id,
      -- Size of the transaction in g_fifo_size bytes
      -- FIXME FIXME
      lmt_pkt_size_i                        => lmt_acq_pkt_size,
      -- Number of shots in this acquisition
      lmt_shots_nb_i                        => lmt_shots_nb,
      -- Acquisition limits valid signal. Qualifies lmt_fifo_pkt_size_i and lmt_shots_nb_i
      lmt_valid_i                           => acq_start_sync_ext,

      -- Xilinx DDR3 UI Interface
      ui_app_addr_o                         => ui_app_rb_addr,
      ui_app_cmd_o                          => ui_app_rb_cmd,
      ui_app_en_o                           => ui_app_rb_en,
      ui_app_rdy_i                          => ui_app_rdy_i,

      ui_app_rd_data_i                      => ui_app_rd_data_i,
      ui_app_rd_data_end_i                  => ui_app_rd_data_end_i,
      ui_app_rd_data_valid_i                => ui_app_rd_data_valid_i,

      ui_app_req_o                          => ui_app_rb_req,
      ui_app_gnt_i                          => ui_app_rb_gnt
    );

    ddr3_rb_start                           <= ddr3_wr_all_trans_done_l and dbg_ddr_rb_start_p_i;
    acq_ddr3_rst_n                          <= ext_rst_n_i and ddr3_wr_all_trans_done_l;
    ddr3_all_trans_done_p                   <= ddr3_rb_all_trans_done_p;

    dbg_ddr_rb_data_o                       <= dbg_ddr_rb_data;
    dbg_ddr_rb_valid_o                      <= dbg_ddr_rb_valid;
    dbg_ddr_rb_addr_o                       <= dbg_ddr_rb_addr;

    -- Multiplex between write to DDR3 and readback from DDR3 (simulation only!)
    ui_app_addr_o <= ui_app_wdf_addr when sim_in_rb = '0' else ui_app_rb_addr;
    ui_app_cmd_o <= ui_app_wdf_cmd when sim_in_rb = '0' else ui_app_rb_cmd;
    ui_app_en_o <= ui_app_wdf_en when sim_in_rb = '0' else ui_app_rb_en;

    ui_app_req_o <= ui_app_wdf_req when sim_in_rb = '0' else ui_app_rb_req;

    ui_app_wdf_gnt <= ui_app_gnt_i when sim_in_rb = '0' else '0';
    ui_app_rb_gnt <= ui_app_gnt_i when sim_in_rb = '1' else '0';

    dbg_ddr_rb_rdy_o <= sim_in_rb;

  end generate;

  gen_ddr3_non_readback : if (not g_sim_readback) generate
    ddr3_all_trans_done_p <= ddr3_wr_all_trans_done_p;

    ui_app_addr_o <= ui_app_wdf_addr;
    ui_app_cmd_o <= ui_app_wdf_cmd;
    ui_app_en_o <= ui_app_wdf_en;

    ui_app_req_o <= ui_app_wdf_req;
    ui_app_wdf_gnt <= ui_app_gnt_i;

    dbg_ddr_rb_rdy_o <= '0';
  end generate;

  -- Generate level signal to indicate DDR3 tranfer is complete
  cmp_gc_pulse_synchronizer : gc_pulse_synchronizer
  port map (
    clk_in_i                              => ext_clk_i,
    clk_out_i                             => fs_clk_i,
    rst_n_i                               => ext_rst_n_i,
    d_ready_o                             => open,
    d_p_i                                 => ddr3_all_trans_done_p, -- pulse input
    q_p_o                                 => ddr3_all_trans_done_p_fs -- pulse output
  );

  cmp_ddr3_all_trans_done_l : pulse2level
  port map
  (
    clk_i                                  => fs_clk_i,
    rst_n_i                                => fs_rst_n_i,

    pulse_i                                => ddr3_all_trans_done_p_fs,
    clr_i                                  => acq_start_sync_fs,
    level_o                                => ddr3_all_trans_done_l
  );

end rtl;
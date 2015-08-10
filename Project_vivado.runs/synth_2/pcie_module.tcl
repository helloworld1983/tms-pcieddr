# 
# Synthesis run script generated by Vivado
# 

set_param gui.test TreeTableDev
debug::add_scope template.lib 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000

create_project -in_memory -part xc7a200tffg1156-2
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.cache/wt [current_project]
set_property parent.project_path D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.xpr [current_project]
set_property default_lib work [current_project]
set_property target_language VHDL [current_project]
add_files -quiet D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.runs/clock_unit_synth_1/clock_unit.dcp
set_property used_in_implementation false [get_files D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.runs/clock_unit_synth_1/clock_unit.dcp]
read_verilog D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/example_design/sim/ddr3_model_parameters.vh
read_verilog {
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_ddr_of_pre_fifo.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_ddr_if_post_fifo.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_ddr_byte_group_io.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/controller/mig_7series_v2_3_round_robin_arb.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_poc_tap_base.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_poc_meta.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_poc_edge_store.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_poc_cc.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_ddr_byte_lane.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_poc_top.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_ddr_phy_ocd_samp.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_ddr_phy_ocd_po_cntlr.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_ddr_phy_ocd_mux.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_ddr_phy_ocd_lim.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_ddr_phy_ocd_edge.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_ddr_phy_ocd_data.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_ddr_phy_ocd_cntlr.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_ddr_phy_4lanes.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/controller/mig_7series_v2_3_bank_state.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/controller/mig_7series_v2_3_bank_queue.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/controller/mig_7series_v2_3_bank_compare.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/controller/mig_7series_v2_3_arb_select.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/controller/mig_7series_v2_3_arb_row_col.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/controller/mig_7series_v2_3_rank_common.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/controller/mig_7series_v2_3_rank_cntrl.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_poc_pd.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_ddr_prbs_gen.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_ddr_phy_wrlvl_off_delay.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_ddr_phy_wrlvl.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_ddr_phy_wrcal.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_ddr_phy_tempmon.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_ddr_phy_rdlvl.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_ddr_phy_prbs_rdlvl.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_ddr_phy_oclkdelay_cal.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_ddr_phy_init.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_ddr_phy_dqs_found_cal_hr.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_ddr_phy_dqs_found_cal.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_ddr_phy_ck_addr_cmd_delay.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_ddr_mc_phy.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/controller/mig_7series_v2_3_bank_common.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/controller/mig_7series_v2_3_bank_cntrl.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/controller/mig_7series_v2_3_arb_mux.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/example_design/rtl/traffic_gen/mig_7series_v2_3_vio_init_pattern_bram.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/example_design/rtl/traffic_gen/mig_7series_v2_3_tg_prbs_gen.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/example_design/rtl/traffic_gen/mig_7series_v2_3_data_prbs_gen.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/controller/mig_7series_v2_3_rank_mach.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/ecc/mig_7series_v2_3_fi_xor.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/ecc/mig_7series_v2_3_ecc_merge_enc.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/ecc/mig_7series_v2_3_ecc_gen.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/ecc/mig_7series_v2_3_ecc_dec_fix.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/ecc/mig_7series_v2_3_ecc_buf.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_ddr_mc_phy_wrapper.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_ddr_calib_top.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/controller/mig_7series_v2_3_col_mach.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/controller/mig_7series_v2_3_bank_mach.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/example_design/rtl/traffic_gen/mig_7series_v2_3_s7ven_data_gen.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/example_design/rtl/traffic_gen/mig_7series_v2_3_afifo.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_pcie_bram_7x.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/ui/mig_7series_v2_3_ui_wr_data.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/ui/mig_7series_v2_3_ui_rd_data.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/ui/mig_7series_v2_3_ui_cmd.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/controller/mig_7series_v2_3_mc.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/example_design/rtl/traffic_gen/mig_7series_v2_3_wr_data_gen.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/example_design/rtl/traffic_gen/mig_7series_v2_3_read_posted_fifo.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/example_design/rtl/traffic_gen/mig_7series_v2_3_rd_data_gen.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/example_design/rtl/traffic_gen/mig_7series_v2_3_cmd_prbs_gen.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_rxeq_scan.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_pcie_brams_7x.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_axi_basic_tx_thrtl_ctl.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_axi_basic_tx_pipeline.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_axi_basic_rx_pipeline.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_axi_basic_rx_null_gen.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/ui/mig_7series_v2_3_ui_top.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/ip_top/mig_7series_v2_3_mem_intfc.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/example_design/rtl/traffic_gen/mig_7series_v2_3_write_data_path.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/example_design/rtl/traffic_gen/mig_7series_v2_3_tg_status.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/example_design/rtl/traffic_gen/mig_7series_v2_3_read_data_path.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/example_design/rtl/traffic_gen/mig_7series_v2_3_memc_flow_vcontrol.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/example_design/rtl/traffic_gen/mig_7series_v2_3_cmd_gen.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_qpll_wrapper.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_qpll_reset.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_qpll_drp.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_pipe_user.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_pipe_sync.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_pipe_reset.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_pipe_rate.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_pipe_eq.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_pipe_drp.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_pipe_clock.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_pcie_pipe_misc.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_pcie_pipe_lane.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_pcie_bram_top_7x.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_gt_wrapper.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_gtp_pipe_reset.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_gtp_pipe_rate.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_gtp_pipe_drp.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_axi_basic_tx.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_axi_basic_rx.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/clocking/mig_7series_v2_3_tempmon.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/ip_top/mig_7series_v2_3_memc_ui_top_std.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/clocking/mig_7series_v2_3_iodelay_ctrl.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/clocking/mig_7series_v2_3_infrastructure.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/clocking/mig_7series_v2_3_clk_ibuf.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/example_design/rtl/traffic_gen/mig_7series_v2_3_memc_traffic_gen.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/example_design/rtl/traffic_gen/mig_7series_v2_3_init_mem_pattern_ctr.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_pipe_wrapper.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_pcie_pipe_pipeline.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_pcie_7x.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_gt_rx_valid_filter_7x.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_axi_basic_top.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/example_design/rtl/traffic_gen/mig_7series_v2_3_traffic_gen_top.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_pcie_top.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_gt_top_pipe_mode.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core_gt_top.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/example_design/sim/wiredly.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/example_design/sim/ddr3_model.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/pcie_core/source/pcie_core.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/example_design/sim/sim_tb_top.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/backplane/rtl/addr_decoder_156.v
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/backplane/rtl/pcie_module.v
}
read_vhdl -library work {
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/modules/pcie/bpm_pcie_a7_const_pkg.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/general-cores/modules/genrams/genram_pkg.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/general-cores/modules/genrams/memory_loader_pkg.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/modules/pcie/common/v6abb64Package_efifo_elink.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/general-cores/modules/wishbone/wishbone_pkg.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/general-cores/modules/genrams/xilinx/generic_dpram_sameclock.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/general-cores/modules/genrams/xilinx/generic_dpram_dualclock.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/general-cores/modules/genrams/xilinx/series7/s7_fifo_pkg.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/general-cores/modules/genrams/xilinx/generic_dpram.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/phy/mig_7series_v2_3_ddr_phy_top.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/general-cores/modules/genrams/xilinx/series7/s7_hwfifo_wrapper.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/general-cores/modules/genrams/inferred_sync_fifo.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/general-cores/modules/genrams/xilinx/series7/generic_sync_fifo.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/modules/pcie/common/DMA_FSM.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/modules/pcie/common/DMA_Calculate.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/modules/pcie/common/Tx_Output_Arbitor.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/modules/pcie/common/tx_Mem_Reader.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/modules/pcie/common/rx_usDMA_Channel.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/modules/pcie/common/rx_MWr_Channel.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/modules/pcie/common/rx_MRd_Channel.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/modules/pcie/common/rx_dsDMA_Channel.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/modules/pcie/common/rx_CplD_Channel.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/modules/pcie/common/RxIn_Delays.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/modules/pcie/common/Interrupts.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/general-cores/modules/genrams/inferred_async_fifo.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/ddr_core_mig.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/rtl/ddr_core.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/modules/pcie/common/tx_Transact.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/modules/pcie/common/rx_Transact.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/modules/pcie/common/Registers.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/general-cores/modules/genrams/xilinx/series7/generic_async_fifo.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/modules/pcie/common/DDR_Blinker.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/modules/pcie/common/DDRs_Control.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/example_design/rtl/example_top.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/modules/pcie/common/wb_transact.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/modules/pcie/common/tlpControl.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/modules/pcie/common/ddr_Transact.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/modules/pcie/common/bram_DDRs_Control_Loopback.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/new/bpm_pcie_a7_patch.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/modules/pcie/bpm_pcie_a7_priv_pkg.vhd
  D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/backplane/rtl/wb_gen/wb_test.vhd
}
read_edif D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/sfifo_15x128.ngc
read_edif D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/prime_FIFO_plain.ngc
read_edif D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/imports/hdl/artix7/ip_cores/bpm-gw/hdl/ip_cores/pcie/7a200ffg1156/bram_x64.ngc
read_xdc D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/constrs_1/pcie_core.xdc
set_property used_in_implementation false [get_files D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/constrs_1/pcie_core.xdc]
set_property processing_order EARLY [get_files D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/constrs_1/pcie_core.xdc]

read_xdc D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/constrs_1/pcie_core_1.xdc
set_property used_in_implementation false [get_files D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/constrs_1/pcie_core_1.xdc]

read_xdc D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/constraints/ddr_core.xdc
set_property used_in_implementation false [get_files D:/Devel/projekty/TMS/project_vivado_20150716.tar/Project_vivado.srcs/sources_1/ip/ddr_core/ddr_core/user_design/constraints/ddr_core.xdc]

catch { write_hwdef -file pcie_module.hwdef }
synth_design -top pcie_module -part xc7a200tffg1156-2 -bufg 32 -directive AreaOptimizedHigh -keep_equivalent_registers
write_checkpoint -noxdef pcie_module.dcp
catch { report_utilization -file pcie_module_utilization_synth.rpt -pb pcie_module_utilization_synth.pb }
vcom  -93 -work xil_defaultlib \
"../../../../../sim/ddr4_sim_model/ddr4_0/bd_0/ip/ip_0/sim/bd_9054_microblaze_I_0.vhd" \
"../../../../../sim/ddr4_sim_model/ddr4_0/bd_0/ip/ip_1/sim/bd_9054_rst_0_0.vhd" \
"../../../../../sim/ddr4_sim_model/ddr4_0/bd_0/ip/ip_2/sim/bd_9054_ilmb_0.vhd" \
"../../../../../sim/ddr4_sim_model/ddr4_0/bd_0/ip/ip_3/sim/bd_9054_dlmb_0.vhd" \
"../../../../../sim/ddr4_sim_model/ddr4_0/bd_0/ip/ip_4/sim/bd_9054_dlmb_cntlr_0.vhd" \
"../../../../../sim/ddr4_sim_model/ddr4_0/bd_0/ip/ip_5/sim/bd_9054_ilmb_cntlr_0.vhd" \

vlog  -incr -mfcu -work xil_defaultlib  "+incdir+../../../../../sim/ddr4_sim_model/ddr4_0/ip_1/rtl/map" "+incdir+../../../../../sim/ddr4_sim_model/ddr4_0/rtl/ip_top" "+incdir+../../../../../sim/ddr4_sim_model/ddr4_0/rtl/cal" "+incdir+../../../../../sim/ddr4_sim_model/imports" \
"../../../../../sim/ddr4_sim_model/ddr4_0/bd_0/ip/ip_6/sim/bd_9054_lmb_bram_I_0.v" \

vlog  -incr -mfcu -work xil_defaultlib \
"../../../../../sim/ddr4_sim_model/ddr_axi_top.v" \

vcom  -93 -work xil_defaultlib \
"../../../../../sim/ddr4_sim_model/ddr4_0/bd_0/ip/ip_7/sim/bd_9054_second_dlmb_cntlr_0.vhd" \
"../../../../../sim/ddr4_sim_model/ddr4_0/bd_0/ip/ip_8/sim/bd_9054_second_ilmb_cntlr_0.vhd" \

vlog  -incr -mfcu -work xil_defaultlib  "+incdir+../../../../../sim/ddr4_sim_model/ddr4_0/ip_1/rtl/map" "+incdir+../../../../../sim/ddr4_sim_model/ddr4_0/rtl/ip_top" "+incdir+../../../../../sim/ddr4_sim_model/ddr4_0/rtl/cal" "+incdir+../../../../../sim/ddr4_sim_model/imports" \
"../../../../../sim/ddr4_sim_model/ddr4_0/bd_0/ip/ip_9/sim/bd_9054_second_lmb_bram_I_0.v" \

vcom  -93 -work xil_defaultlib \
"../../../../../sim/ddr4_sim_model/ddr4_0/bd_0/ip/ip_10/sim/bd_9054_iomodule_0_0.vhd" \

vlog  -incr -mfcu -work xil_defaultlib  "+incdir+../../../../../sim/ddr4_sim_model/ddr4_0/ip_1/rtl/map" "+incdir+../../../../../sim/ddr4_sim_model/ddr4_0/rtl/ip_top" "+incdir+../../../../../sim/ddr4_sim_model/ddr4_0/rtl/cal" "+incdir+../../../../../sim/ddr4_sim_model/imports" \
"../../../../../sim/ddr4_sim_model/ddr4_0/bd_0/sim/bd_9054.v" \
"../../../../../sim/ddr4_sim_model/ddr4_0/ip_0/sim/ddr4_0_microblaze_mcs.v" \

vlog  -incr -mfcu -sv -work xil_defaultlib  "+incdir+../../../../../sim/ddr4_sim_model/ddr4_0/ip_1/rtl/map" "+incdir+../../../../../sim/ddr4_sim_model/ddr4_0/rtl/ip_top" "+incdir+../../../../../sim/ddr4_sim_model/ddr4_0/rtl/cal" "+incdir+../../../../../sim/ddr4_sim_model/imports" \
"../../../../../sim/ddr4_sim_model/ddr4_0/ip_1/rtl/phy/ddr4_0_phy_ddr4.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/ip_1/rtl/phy/ddr4_phy_v2_2_xiphy_behav.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/ip_1/rtl/phy/ddr4_phy_v2_2_xiphy.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/ip_1/rtl/iob/ddr4_phy_v2_2_iob_byte.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/ip_1/rtl/iob/ddr4_phy_v2_2_iob.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/ip_1/rtl/clocking/ddr4_phy_v2_2_pll.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/ip_1/rtl/xiphy_files/ddr4_phy_v2_2_xiphy_tristate_wrapper.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/ip_1/rtl/xiphy_files/ddr4_phy_v2_2_xiphy_riuor_wrapper.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/ip_1/rtl/xiphy_files/ddr4_phy_v2_2_xiphy_control_wrapper.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/ip_1/rtl/xiphy_files/ddr4_phy_v2_2_xiphy_byte_wrapper.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/ip_1/rtl/xiphy_files/ddr4_phy_v2_2_xiphy_bitslice_wrapper.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/ip_1/rtl/ip_top/ddr4_0_phy.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/controller/ddr4_v2_2_mc_wtr.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/controller/ddr4_v2_2_mc_ref.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/controller/ddr4_v2_2_mc_rd_wr.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/controller/ddr4_v2_2_mc_periodic.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/controller/ddr4_v2_2_mc_group.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/controller/ddr4_v2_2_mc_ecc_merge_enc.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/controller/ddr4_v2_2_mc_ecc_gen.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/controller/ddr4_v2_2_mc_ecc_fi_xor.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/controller/ddr4_v2_2_mc_ecc_dec_fix.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/controller/ddr4_v2_2_mc_ecc_buf.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/controller/ddr4_v2_2_mc_ecc.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/controller/ddr4_v2_2_mc_ctl.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/controller/ddr4_v2_2_mc_cmd_mux_c.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/controller/ddr4_v2_2_mc_cmd_mux_ap.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/controller/ddr4_v2_2_mc_arb_p.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/controller/ddr4_v2_2_mc_arb_mux_p.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/controller/ddr4_v2_2_mc_arb_c.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/controller/ddr4_v2_2_mc_arb_a.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/controller/ddr4_v2_2_mc_act_timer.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/controller/ddr4_v2_2_mc_act_rank.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/controller/ddr4_v2_2_mc.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/ui/ddr4_v2_2_ui_wr_data.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/ui/ddr4_v2_2_ui_rd_data.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/ui/ddr4_v2_2_ui_cmd.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/ui/ddr4_v2_2_ui.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/axi/ddr4_v2_2_axi_ar_channel.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/axi/ddr4_v2_2_axi_aw_channel.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/axi/ddr4_v2_2_axi_b_channel.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/axi/ddr4_v2_2_axi_cmd_arbiter.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/axi/ddr4_v2_2_axi_cmd_fsm.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/axi/ddr4_v2_2_axi_cmd_translator.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/axi/ddr4_v2_2_axi_fifo.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/axi/ddr4_v2_2_axi_incr_cmd.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/axi/ddr4_v2_2_axi_r_channel.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/axi/ddr4_v2_2_axi_w_channel.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/axi/ddr4_v2_2_axi_wr_cmd_fsm.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/axi/ddr4_v2_2_axi_wrap_cmd.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/axi/ddr4_v2_2_a_upsizer.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/axi/ddr4_v2_2_axi.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/axi/ddr4_v2_2_axi_register_slice.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/axi/ddr4_v2_2_axi_upsizer.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/axi/ddr4_v2_2_axic_register_slice.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/axi/ddr4_v2_2_carry_and.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/axi/ddr4_v2_2_carry_latch_and.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/axi/ddr4_v2_2_carry_latch_or.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/axi/ddr4_v2_2_carry_or.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/axi/ddr4_v2_2_command_fifo.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/axi/ddr4_v2_2_comparator.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/axi/ddr4_v2_2_comparator_sel.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/axi/ddr4_v2_2_comparator_sel_static.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/axi/ddr4_v2_2_r_upsizer.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/axi/ddr4_v2_2_w_upsizer.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/axi_ctrl/ddr4_v2_2_axi_ctrl_addr_decode.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/axi_ctrl/ddr4_v2_2_axi_ctrl_read.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/axi_ctrl/ddr4_v2_2_axi_ctrl_reg_bank.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/axi_ctrl/ddr4_v2_2_axi_ctrl_reg.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/axi_ctrl/ddr4_v2_2_axi_ctrl_top.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/axi_ctrl/ddr4_v2_2_axi_ctrl_write.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/clocking/ddr4_v2_2_infrastructure.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/cal/ddr4_v2_2_cal_xsdb_bram.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/cal/ddr4_v2_2_cal_write.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/cal/ddr4_v2_2_cal_wr_byte.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/cal/ddr4_v2_2_cal_wr_bit.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/cal/ddr4_v2_2_cal_sync.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/cal/ddr4_v2_2_cal_read.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/cal/ddr4_v2_2_cal_rd_en.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/cal/ddr4_v2_2_cal_pi.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/cal/ddr4_v2_2_cal_mc_odt.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/cal/ddr4_v2_2_cal_debug_microblaze.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/cal/ddr4_v2_2_cal_cplx_data.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/cal/ddr4_v2_2_cal_cplx.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/cal/ddr4_v2_2_cal_config_rom.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/cal/ddr4_v2_2_cal_addr_decode.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/cal/ddr4_v2_2_cal_top.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/cal/ddr4_v2_2_cal_xsdb_arbiter.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/cal/ddr4_v2_2_cal.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/cal/ddr4_v2_2_chipscope_xsdb_slave.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/cal/ddr4_v2_2_dp_AB9.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/ip_top/ddr4_0_ddr4.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/ip_top/ddr4_0_ddr4_mem_intfc.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/cal/ddr4_0_ddr4_cal_riu.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/rtl/ip_top/ddr4_0.sv" \
"../../../../../sim/ddr4_sim_model/ddr4_0/tb/microblaze_mcs_0.sv" \
"../../../../../sim/ddr4_sim_model/imports/arch_package.sv" \
"../../../../../sim/ddr4_sim_model/imports/proj_package.sv" \
"../../../../../sim/ddr4_sim_model/imports/ddr4_model.sv" \
"../../../../../sim/ddr4_sim_model/imports/ddr4_v2_2_axi_opcode_gen.sv" \
"../../../../../sim/ddr4_sim_model/imports/ddr4_v2_2_axi_tg_top.sv" \
"../../../../../sim/ddr4_sim_model/imports/ddr4_v2_2_axi_wrapper.sv" \
"../../../../../sim/ddr4_sim_model/imports/ddr4_v2_2_boot_mode_gen.sv" \
"../../../../../sim/ddr4_sim_model/imports/ddr4_v2_2_custom_mode_gen.sv" \
"../../../../../sim/ddr4_sim_model/imports/ddr4_v2_2_data_chk.sv" \
"../../../../../sim/ddr4_sim_model/imports/ddr4_v2_2_data_gen.sv" \
"../../../../../sim/ddr4_sim_model/imports/ddr4_v2_2_prbs_mode_gen.sv" \
"../../../../../sim/ddr4_sim_model/imports/interface.sv" \
"../../../../../sim/ddr4_sim_model/imports/ddr4_sim_model.sv" \
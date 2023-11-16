// (c) Copyright 1995-2023 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.

// IP VLNV: xilinx.com:ip:ddr4_phy:2.2
// IP Revision: 0

// The following must be inserted into your Verilog file for this
// core to be instantiated. Change the instance name and port connections
// (in parentheses) to your own signal names.

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
ddr4_0_phy your_instance_name (
  .sys_clk_p(sys_clk_p),                                          // input wire sys_clk_p
  .sys_clk_n(sys_clk_n),                                          // input wire sys_clk_n
  .mmcm_lock(mmcm_lock),                                          // input wire mmcm_lock
  .pllGate(pllGate),                                              // input wire pllGate
  .div_clk(div_clk),                                              // input wire div_clk
  .div_clk_rst(div_clk_rst),                                      // input wire div_clk_rst
  .riu_clk(riu_clk),                                              // input wire riu_clk
  .riu_clk_rst(riu_clk_rst),                                      // input wire riu_clk_rst
  .pll_lock(pll_lock),                                            // output wire pll_lock
  .sys_clk_in(sys_clk_in),                                        // output wire sys_clk_in
  .mmcm_clk_in(mmcm_clk_in),                                      // output wire mmcm_clk_in
  .mcal_ACT_n(mcal_ACT_n),                                        // input wire [7 : 0] mcal_ACT_n
  .mcal_CAS_n(mcal_CAS_n),                                        // input wire [7 : 0] mcal_CAS_n
  .mcal_RAS_n(mcal_RAS_n),                                        // input wire [7 : 0] mcal_RAS_n
  .mcal_WE_n(mcal_WE_n),                                          // input wire [7 : 0] mcal_WE_n
  .mcal_ADR(mcal_ADR),                                            // input wire [135 : 0] mcal_ADR
  .mcal_BA(mcal_BA),                                              // input wire [15 : 0] mcal_BA
  .mcal_C(mcal_C),                                                // input wire [7 : 0] mcal_C
  .mcal_CKE(mcal_CKE),                                            // input wire [7 : 0] mcal_CKE
  .mcal_CS_n(mcal_CS_n),                                          // input wire [7 : 0] mcal_CS_n
  .mcal_ODT(mcal_ODT),                                            // input wire [7 : 0] mcal_ODT
  .mcal_PAR(mcal_PAR),                                            // input wire [7 : 0] mcal_PAR
  .ch0_mcal_DMOut_n(ch0_mcal_DMOut_n),                            // input wire [63 : 0] ch0_mcal_DMOut_n
  .ch0_mcal_DQOut(ch0_mcal_DQOut),                                // input wire [511 : 0] ch0_mcal_DQOut
  .ch0_mcal_DQSOut(ch0_mcal_DQSOut),                              // input wire [0 : 0] ch0_mcal_DQSOut
  .ch0_mcal_clb2phy_rden_upp(ch0_mcal_clb2phy_rden_upp),          // input wire [31 : 0] ch0_mcal_clb2phy_rden_upp
  .ch0_mcal_clb2phy_rden_low(ch0_mcal_clb2phy_rden_low),          // input wire [31 : 0] ch0_mcal_clb2phy_rden_low
  .ch0_mcal_clb2phy_wrcs0_upp(ch0_mcal_clb2phy_wrcs0_upp),        // input wire [31 : 0] ch0_mcal_clb2phy_wrcs0_upp
  .ch0_mcal_clb2phy_wrcs1_upp(ch0_mcal_clb2phy_wrcs1_upp),        // input wire [31 : 0] ch0_mcal_clb2phy_wrcs1_upp
  .ch0_mcal_clb2phy_wrcs0_low(ch0_mcal_clb2phy_wrcs0_low),        // input wire [31 : 0] ch0_mcal_clb2phy_wrcs0_low
  .ch0_mcal_clb2phy_wrcs1_low(ch0_mcal_clb2phy_wrcs1_low),        // input wire [31 : 0] ch0_mcal_clb2phy_wrcs1_low
  .ch0_mcal_clb2phy_rdcs0_upp(ch0_mcal_clb2phy_rdcs0_upp),        // input wire [31 : 0] ch0_mcal_clb2phy_rdcs0_upp
  .ch0_mcal_clb2phy_rdcs1_upp(ch0_mcal_clb2phy_rdcs1_upp),        // input wire [31 : 0] ch0_mcal_clb2phy_rdcs1_upp
  .ch0_mcal_clb2phy_rdcs0_low(ch0_mcal_clb2phy_rdcs0_low),        // input wire [31 : 0] ch0_mcal_clb2phy_rdcs0_low
  .ch0_mcal_clb2phy_rdcs1_low(ch0_mcal_clb2phy_rdcs1_low),        // input wire [31 : 0] ch0_mcal_clb2phy_rdcs1_low
  .ch0_mcal_clb2phy_odt_upp(ch0_mcal_clb2phy_odt_upp),            // input wire [55 : 0] ch0_mcal_clb2phy_odt_upp
  .ch0_mcal_clb2phy_odt_low(ch0_mcal_clb2phy_odt_low),            // input wire [55 : 0] ch0_mcal_clb2phy_odt_low
  .ch0_mcal_clb2phy_t_b_low(ch0_mcal_clb2phy_t_b_low),            // input wire [31 : 0] ch0_mcal_clb2phy_t_b_low
  .ch0_mcal_clb2phy_t_b_upp(ch0_mcal_clb2phy_t_b_upp),            // input wire [31 : 0] ch0_mcal_clb2phy_t_b_upp
  .mcal_rd_vref_value(mcal_rd_vref_value),                        // input wire [55 : 0] mcal_rd_vref_value
  .ch1_mcal_DMOut_n(ch1_mcal_DMOut_n),                            // input wire [63 : 0] ch1_mcal_DMOut_n
  .ch1_mcal_DQOut(ch1_mcal_DQOut),                                // input wire [511 : 0] ch1_mcal_DQOut
  .ch1_mcal_DQSOut(ch1_mcal_DQSOut),                              // input wire [0 : 0] ch1_mcal_DQSOut
  .ch1_mcal_clb2phy_rden_upp(ch1_mcal_clb2phy_rden_upp),          // input wire [31 : 0] ch1_mcal_clb2phy_rden_upp
  .ch1_mcal_clb2phy_rden_low(ch1_mcal_clb2phy_rden_low),          // input wire [31 : 0] ch1_mcal_clb2phy_rden_low
  .ch1_mcal_clb2phy_wrcs0_upp(ch1_mcal_clb2phy_wrcs0_upp),        // input wire [31 : 0] ch1_mcal_clb2phy_wrcs0_upp
  .ch1_mcal_clb2phy_wrcs1_upp(ch1_mcal_clb2phy_wrcs1_upp),        // input wire [31 : 0] ch1_mcal_clb2phy_wrcs1_upp
  .ch1_mcal_clb2phy_wrcs0_low(ch1_mcal_clb2phy_wrcs0_low),        // input wire [31 : 0] ch1_mcal_clb2phy_wrcs0_low
  .ch1_mcal_clb2phy_wrcs1_low(ch1_mcal_clb2phy_wrcs1_low),        // input wire [31 : 0] ch1_mcal_clb2phy_wrcs1_low
  .ch1_mcal_clb2phy_rdcs0_upp(ch1_mcal_clb2phy_rdcs0_upp),        // input wire [31 : 0] ch1_mcal_clb2phy_rdcs0_upp
  .ch1_mcal_clb2phy_rdcs1_upp(ch1_mcal_clb2phy_rdcs1_upp),        // input wire [31 : 0] ch1_mcal_clb2phy_rdcs1_upp
  .ch1_mcal_clb2phy_rdcs0_low(ch1_mcal_clb2phy_rdcs0_low),        // input wire [31 : 0] ch1_mcal_clb2phy_rdcs0_low
  .ch1_mcal_clb2phy_rdcs1_low(ch1_mcal_clb2phy_rdcs1_low),        // input wire [31 : 0] ch1_mcal_clb2phy_rdcs1_low
  .ch1_mcal_clb2phy_odt_upp(ch1_mcal_clb2phy_odt_upp),            // input wire [55 : 0] ch1_mcal_clb2phy_odt_upp
  .ch1_mcal_clb2phy_odt_low(ch1_mcal_clb2phy_odt_low),            // input wire [55 : 0] ch1_mcal_clb2phy_odt_low
  .ch1_mcal_clb2phy_t_b_low(ch1_mcal_clb2phy_t_b_low),            // input wire [31 : 0] ch1_mcal_clb2phy_t_b_low
  .ch1_mcal_clb2phy_t_b_upp(ch1_mcal_clb2phy_t_b_upp),            // input wire [31 : 0] ch1_mcal_clb2phy_t_b_upp
  .ch0_mcal_clb2phy_fifo_rden(ch0_mcal_clb2phy_fifo_rden),        // input wire [103 : 0] ch0_mcal_clb2phy_fifo_rden
  .ch1_mcal_clb2phy_fifo_rden(ch1_mcal_clb2phy_fifo_rden),        // input wire [103 : 0] ch1_mcal_clb2phy_fifo_rden
  .mcal_DMIn_n(mcal_DMIn_n),                                      // output wire [63 : 0] mcal_DMIn_n
  .mcal_DQIn(mcal_DQIn),                                          // output wire [511 : 0] mcal_DQIn
  .phy_ready_riuclk(phy_ready_riuclk),                            // output wire phy_ready_riuclk
  .bisc_complete_riuclk(bisc_complete_riuclk),                    // output wire bisc_complete_riuclk
  .phy2clb_rd_dq_bits(phy2clb_rd_dq_bits),                        // output wire [0 : 0] phy2clb_rd_dq_bits
  .bisc_byte(bisc_byte),                                          // input wire [0 : 0] bisc_byte
  .cal_RESET_n(cal_RESET_n),                                      // input wire [0 : 0] cal_RESET_n
  .en_vtc_riuclk(en_vtc_riuclk),                                  // input wire en_vtc_riuclk
  .ub_rst_out_riuclk(ub_rst_out_riuclk),                          // input wire ub_rst_out_riuclk
  .riu2clb_vld_read_data(riu2clb_vld_read_data),                  // output wire [0 : 0] riu2clb_vld_read_data
  .riu_nibble_8(riu_nibble_8),                                    // output wire [0 : 0] riu_nibble_8
  .riu_addr_cal(riu_addr_cal),                                    // output wire [0 : 0] riu_addr_cal
  .riu2clb_valid_riuclk(riu2clb_valid_riuclk),                    // output wire [0 : 0] riu2clb_valid_riuclk
  .io_addr_strobe_clb2riu_riuclk(io_addr_strobe_clb2riu_riuclk),  // input wire io_addr_strobe_clb2riu_riuclk
  .io_address_riuclk(io_address_riuclk),                          // input wire [0 : 0] io_address_riuclk
  .io_write_data_riuclk(io_write_data_riuclk),                    // input wire [0 : 0] io_write_data_riuclk
  .io_write_strobe_riuclk(io_write_strobe_riuclk),                // input wire io_write_strobe_riuclk
  .phy2clb_fixdly_rdy_low_riuclk(phy2clb_fixdly_rdy_low_riuclk),  // output wire [0 : 0] phy2clb_fixdly_rdy_low_riuclk
  .phy2clb_fixdly_rdy_upp_riuclk(phy2clb_fixdly_rdy_upp_riuclk),  // output wire [0 : 0] phy2clb_fixdly_rdy_upp_riuclk
  .phy2clb_phy_rdy_upp_riuclk(phy2clb_phy_rdy_upp_riuclk),        // input wire [0 : 0] phy2clb_phy_rdy_upp_riuclk
  .phy2clb_phy_rdy_low_riuclk(phy2clb_phy_rdy_low_riuclk),        // output wire [0 : 0] phy2clb_phy_rdy_low_riuclk
  .dbg_bus(dbg_bus),                                              // output wire [0 : 0] dbg_bus
  .ddr4_act_n(ddr4_act_n),                                        // output wire ddr4_act_n
  .ddr4_adr(ddr4_adr),                                            // output wire [16 : 0] ddr4_adr
  .ddr4_ba(ddr4_ba),                                              // output wire [1 : 0] ddr4_ba
  .ddr4_bg(ddr4_bg),                                              // output wire [1 : 0] ddr4_bg
  .ddr4_c(ddr4_c),                                                // output wire [0 : 0] ddr4_c
  .ddr4_cke(ddr4_cke),                                            // output wire [0 : 0] ddr4_cke
  .ddr4_odt(ddr4_odt),                                            // output wire [0 : 0] ddr4_odt
  .ddr4_cs_n(ddr4_cs_n),                                          // output wire [0 : 0] ddr4_cs_n
  .ddr4_ck_t(ddr4_ck_t),                                          // output wire [0 : 0] ddr4_ck_t
  .ddr4_ck_c(ddr4_ck_c),                                          // output wire [0 : 0] ddr4_ck_c
  .ddr4_reset_n(ddr4_reset_n),                                    // output wire ddr4_reset_n
  .ddr4_dm_dbi_n(ddr4_dm_dbi_n),                                  // inout wire [7 : 0] ddr4_dm_dbi_n
  .mcal_CK_c(mcal_CK_c),                                          // input wire [7 : 0] mcal_CK_c
  .mcal_CK_t(mcal_CK_t),                                          // input wire [7 : 0] mcal_CK_t
  .ddr4_dq(ddr4_dq),                                              // inout wire [63 : 0] ddr4_dq
  .ddr4_dqs_c(ddr4_dqs_c),                                        // inout wire [7 : 0] ddr4_dqs_c
  .ddr4_dqs_t(ddr4_dqs_t),                                        // inout wire [7 : 0] ddr4_dqs_t
  .mcal_BG(mcal_BG)                                              // input wire [15 : 0] mcal_BG
);
// INST_TAG_END ------ End INSTANTIATION Template ---------

// You must compile the wrapper file ddr4_0_phy.v when simulating
// the core, ddr4_0_phy. When compiling the wrapper file, be sure to
// reference the Verilog simulation library.


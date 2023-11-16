-- (c) Copyright 1995-2023 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.
-- IP VLNV: xilinx.com:ip:ddr4_phy:2.2
-- IP Revision: 0

-- The following code must appear in the VHDL architecture header.

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT ddr4_0_phy
  PORT (
    sys_clk_p : IN STD_LOGIC;
    sys_clk_n : IN STD_LOGIC;
    mmcm_lock : IN STD_LOGIC;
    pllGate : IN STD_LOGIC;
    div_clk : IN STD_LOGIC;
    div_clk_rst : IN STD_LOGIC;
    riu_clk : IN STD_LOGIC;
    riu_clk_rst : IN STD_LOGIC;
    pll_lock : OUT STD_LOGIC;
    sys_clk_in : OUT STD_LOGIC;
    mmcm_clk_in : OUT STD_LOGIC;
    mcal_ACT_n : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    mcal_CAS_n : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    mcal_RAS_n : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    mcal_WE_n : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    mcal_ADR : IN STD_LOGIC_VECTOR(135 DOWNTO 0);
    mcal_BA : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    mcal_C : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    mcal_CKE : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    mcal_CS_n : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    mcal_ODT : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    mcal_PAR : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    ch0_mcal_DMOut_n : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    ch0_mcal_DQOut : IN STD_LOGIC_VECTOR(511 DOWNTO 0);
    ch0_mcal_DQSOut : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    ch0_mcal_clb2phy_rden_upp : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    ch0_mcal_clb2phy_rden_low : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    ch0_mcal_clb2phy_wrcs0_upp : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    ch0_mcal_clb2phy_wrcs1_upp : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    ch0_mcal_clb2phy_wrcs0_low : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    ch0_mcal_clb2phy_wrcs1_low : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    ch0_mcal_clb2phy_rdcs0_upp : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    ch0_mcal_clb2phy_rdcs1_upp : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    ch0_mcal_clb2phy_rdcs0_low : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    ch0_mcal_clb2phy_rdcs1_low : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    ch0_mcal_clb2phy_odt_upp : IN STD_LOGIC_VECTOR(55 DOWNTO 0);
    ch0_mcal_clb2phy_odt_low : IN STD_LOGIC_VECTOR(55 DOWNTO 0);
    ch0_mcal_clb2phy_t_b_low : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    ch0_mcal_clb2phy_t_b_upp : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    mcal_rd_vref_value : IN STD_LOGIC_VECTOR(55 DOWNTO 0);
    ch1_mcal_DMOut_n : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    ch1_mcal_DQOut : IN STD_LOGIC_VECTOR(511 DOWNTO 0);
    ch1_mcal_DQSOut : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    ch1_mcal_clb2phy_rden_upp : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    ch1_mcal_clb2phy_rden_low : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    ch1_mcal_clb2phy_wrcs0_upp : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    ch1_mcal_clb2phy_wrcs1_upp : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    ch1_mcal_clb2phy_wrcs0_low : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    ch1_mcal_clb2phy_wrcs1_low : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    ch1_mcal_clb2phy_rdcs0_upp : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    ch1_mcal_clb2phy_rdcs1_upp : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    ch1_mcal_clb2phy_rdcs0_low : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    ch1_mcal_clb2phy_rdcs1_low : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    ch1_mcal_clb2phy_odt_upp : IN STD_LOGIC_VECTOR(55 DOWNTO 0);
    ch1_mcal_clb2phy_odt_low : IN STD_LOGIC_VECTOR(55 DOWNTO 0);
    ch1_mcal_clb2phy_t_b_low : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    ch1_mcal_clb2phy_t_b_upp : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    ch0_mcal_clb2phy_fifo_rden : IN STD_LOGIC_VECTOR(103 DOWNTO 0);
    ch1_mcal_clb2phy_fifo_rden : IN STD_LOGIC_VECTOR(103 DOWNTO 0);
    mcal_DMIn_n : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    mcal_DQIn : OUT STD_LOGIC_VECTOR(511 DOWNTO 0);
    phy_ready_riuclk : OUT STD_LOGIC;
    bisc_complete_riuclk : OUT STD_LOGIC;
    phy2clb_rd_dq_bits : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    bisc_byte : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    cal_RESET_n : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    en_vtc_riuclk : IN STD_LOGIC;
    ub_rst_out_riuclk : IN STD_LOGIC;
    riu2clb_vld_read_data : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    riu_nibble_8 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    riu_addr_cal : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    riu2clb_valid_riuclk : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    io_addr_strobe_clb2riu_riuclk : IN STD_LOGIC;
    io_address_riuclk : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    io_write_data_riuclk : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    io_write_strobe_riuclk : IN STD_LOGIC;
    phy2clb_fixdly_rdy_low_riuclk : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    phy2clb_fixdly_rdy_upp_riuclk : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    phy2clb_phy_rdy_upp_riuclk : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    phy2clb_phy_rdy_low_riuclk : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    dbg_bus : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    ddr4_act_n : OUT STD_LOGIC;
    ddr4_adr : OUT STD_LOGIC_VECTOR(16 DOWNTO 0);
    ddr4_ba : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    ddr4_bg : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    ddr4_c : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    ddr4_cke : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    ddr4_odt : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    ddr4_cs_n : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    ddr4_ck_t : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    ddr4_ck_c : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    ddr4_reset_n : OUT STD_LOGIC;
    ddr4_dm_dbi_n : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    mcal_CK_c : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    mcal_CK_t : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    ddr4_dq : INOUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    ddr4_dqs_c : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    ddr4_dqs_t : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    mcal_BG : IN STD_LOGIC_VECTOR(15 DOWNTO 0) 
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------

-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
your_instance_name : ddr4_0_phy
  PORT MAP (
    sys_clk_p => sys_clk_p,
    sys_clk_n => sys_clk_n,
    mmcm_lock => mmcm_lock,
    pllGate => pllGate,
    div_clk => div_clk,
    div_clk_rst => div_clk_rst,
    riu_clk => riu_clk,
    riu_clk_rst => riu_clk_rst,
    pll_lock => pll_lock,
    sys_clk_in => sys_clk_in,
    mmcm_clk_in => mmcm_clk_in,
    mcal_ACT_n => mcal_ACT_n,
    mcal_CAS_n => mcal_CAS_n,
    mcal_RAS_n => mcal_RAS_n,
    mcal_WE_n => mcal_WE_n,
    mcal_ADR => mcal_ADR,
    mcal_BA => mcal_BA,
    mcal_C => mcal_C,
    mcal_CKE => mcal_CKE,
    mcal_CS_n => mcal_CS_n,
    mcal_ODT => mcal_ODT,
    mcal_PAR => mcal_PAR,
    ch0_mcal_DMOut_n => ch0_mcal_DMOut_n,
    ch0_mcal_DQOut => ch0_mcal_DQOut,
    ch0_mcal_DQSOut => ch0_mcal_DQSOut,
    ch0_mcal_clb2phy_rden_upp => ch0_mcal_clb2phy_rden_upp,
    ch0_mcal_clb2phy_rden_low => ch0_mcal_clb2phy_rden_low,
    ch0_mcal_clb2phy_wrcs0_upp => ch0_mcal_clb2phy_wrcs0_upp,
    ch0_mcal_clb2phy_wrcs1_upp => ch0_mcal_clb2phy_wrcs1_upp,
    ch0_mcal_clb2phy_wrcs0_low => ch0_mcal_clb2phy_wrcs0_low,
    ch0_mcal_clb2phy_wrcs1_low => ch0_mcal_clb2phy_wrcs1_low,
    ch0_mcal_clb2phy_rdcs0_upp => ch0_mcal_clb2phy_rdcs0_upp,
    ch0_mcal_clb2phy_rdcs1_upp => ch0_mcal_clb2phy_rdcs1_upp,
    ch0_mcal_clb2phy_rdcs0_low => ch0_mcal_clb2phy_rdcs0_low,
    ch0_mcal_clb2phy_rdcs1_low => ch0_mcal_clb2phy_rdcs1_low,
    ch0_mcal_clb2phy_odt_upp => ch0_mcal_clb2phy_odt_upp,
    ch0_mcal_clb2phy_odt_low => ch0_mcal_clb2phy_odt_low,
    ch0_mcal_clb2phy_t_b_low => ch0_mcal_clb2phy_t_b_low,
    ch0_mcal_clb2phy_t_b_upp => ch0_mcal_clb2phy_t_b_upp,
    mcal_rd_vref_value => mcal_rd_vref_value,
    ch1_mcal_DMOut_n => ch1_mcal_DMOut_n,
    ch1_mcal_DQOut => ch1_mcal_DQOut,
    ch1_mcal_DQSOut => ch1_mcal_DQSOut,
    ch1_mcal_clb2phy_rden_upp => ch1_mcal_clb2phy_rden_upp,
    ch1_mcal_clb2phy_rden_low => ch1_mcal_clb2phy_rden_low,
    ch1_mcal_clb2phy_wrcs0_upp => ch1_mcal_clb2phy_wrcs0_upp,
    ch1_mcal_clb2phy_wrcs1_upp => ch1_mcal_clb2phy_wrcs1_upp,
    ch1_mcal_clb2phy_wrcs0_low => ch1_mcal_clb2phy_wrcs0_low,
    ch1_mcal_clb2phy_wrcs1_low => ch1_mcal_clb2phy_wrcs1_low,
    ch1_mcal_clb2phy_rdcs0_upp => ch1_mcal_clb2phy_rdcs0_upp,
    ch1_mcal_clb2phy_rdcs1_upp => ch1_mcal_clb2phy_rdcs1_upp,
    ch1_mcal_clb2phy_rdcs0_low => ch1_mcal_clb2phy_rdcs0_low,
    ch1_mcal_clb2phy_rdcs1_low => ch1_mcal_clb2phy_rdcs1_low,
    ch1_mcal_clb2phy_odt_upp => ch1_mcal_clb2phy_odt_upp,
    ch1_mcal_clb2phy_odt_low => ch1_mcal_clb2phy_odt_low,
    ch1_mcal_clb2phy_t_b_low => ch1_mcal_clb2phy_t_b_low,
    ch1_mcal_clb2phy_t_b_upp => ch1_mcal_clb2phy_t_b_upp,
    ch0_mcal_clb2phy_fifo_rden => ch0_mcal_clb2phy_fifo_rden,
    ch1_mcal_clb2phy_fifo_rden => ch1_mcal_clb2phy_fifo_rden,
    mcal_DMIn_n => mcal_DMIn_n,
    mcal_DQIn => mcal_DQIn,
    phy_ready_riuclk => phy_ready_riuclk,
    bisc_complete_riuclk => bisc_complete_riuclk,
    phy2clb_rd_dq_bits => phy2clb_rd_dq_bits,
    bisc_byte => bisc_byte,
    cal_RESET_n => cal_RESET_n,
    en_vtc_riuclk => en_vtc_riuclk,
    ub_rst_out_riuclk => ub_rst_out_riuclk,
    riu2clb_vld_read_data => riu2clb_vld_read_data,
    riu_nibble_8 => riu_nibble_8,
    riu_addr_cal => riu_addr_cal,
    riu2clb_valid_riuclk => riu2clb_valid_riuclk,
    io_addr_strobe_clb2riu_riuclk => io_addr_strobe_clb2riu_riuclk,
    io_address_riuclk => io_address_riuclk,
    io_write_data_riuclk => io_write_data_riuclk,
    io_write_strobe_riuclk => io_write_strobe_riuclk,
    phy2clb_fixdly_rdy_low_riuclk => phy2clb_fixdly_rdy_low_riuclk,
    phy2clb_fixdly_rdy_upp_riuclk => phy2clb_fixdly_rdy_upp_riuclk,
    phy2clb_phy_rdy_upp_riuclk => phy2clb_phy_rdy_upp_riuclk,
    phy2clb_phy_rdy_low_riuclk => phy2clb_phy_rdy_low_riuclk,
    dbg_bus => dbg_bus,
    ddr4_act_n => ddr4_act_n,
    ddr4_adr => ddr4_adr,
    ddr4_ba => ddr4_ba,
    ddr4_bg => ddr4_bg,
    ddr4_c => ddr4_c,
    ddr4_cke => ddr4_cke,
    ddr4_odt => ddr4_odt,
    ddr4_cs_n => ddr4_cs_n,
    ddr4_ck_t => ddr4_ck_t,
    ddr4_ck_c => ddr4_ck_c,
    ddr4_reset_n => ddr4_reset_n,
    ddr4_dm_dbi_n => ddr4_dm_dbi_n,
    mcal_CK_c => mcal_CK_c,
    mcal_CK_t => mcal_CK_t,
    ddr4_dq => ddr4_dq,
    ddr4_dqs_c => ddr4_dqs_c,
    ddr4_dqs_t => ddr4_dqs_t,
    mcal_BG => mcal_BG
  );
-- INST_TAG_END ------ End INSTANTIATION Template ---------

-- You must compile the wrapper file ddr4_0_phy.vhd when simulating
-- the core, ddr4_0_phy. When compiling the wrapper file, be sure to
-- reference the VHDL simulation library.




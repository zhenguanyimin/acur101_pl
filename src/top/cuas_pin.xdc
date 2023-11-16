
########### ADC3663 ###########################################################
set_property PACKAGE_PIN K12 [get_ports spi_adc3663_pdn_o]
set_property PACKAGE_PIN K11 [get_ports spi_adc3663_sen_o]
set_property PACKAGE_PIN K13 [get_ports spi_adc3663_sdio]
set_property PACKAGE_PIN J12 [get_ports spi_adc3663_sclk_o]
set_property PACKAGE_PIN G13 [get_ports adc_rst]
# set_property PACKAGE_PIN AJ1 [get_ports spi_adc3663_reset_o]


set_property IOSTANDARD LVCMOS18 [get_ports spi_adc3663_pdn_o]
set_property IOSTANDARD LVCMOS18 [get_ports spi_adc3663_sen_o]
set_property IOSTANDARD LVCMOS18 [get_ports spi_adc3663_sdio]
set_property IOSTANDARD LVCMOS18 [get_ports spi_adc3663_sclk_o]
set_property IOSTANDARD LVCMOS18 [get_ports adc_rst]
# set_property IOSTANDARD LVCMOS18 [get_ports spi_adc3663_reset_o]




########### CHC2442 ##########################################################

set_property PACKAGE_PIN A17 [get_ports spi_chc2442_sen_o]
set_property PACKAGE_PIN B16 [get_ports spi_chc2442_sdata_o]
set_property PACKAGE_PIN C17 [get_ports spi_chc2442_sclk_o]
set_property PACKAGE_PIN A16 [get_ports spi_chc2442_sdata_i]

set_property IOSTANDARD LVCMOS33 [get_ports spi_chc2442_sen_o]
set_property IOSTANDARD LVCMOS33 [get_ports spi_chc2442_sdata_o]
set_property IOSTANDARD LVCMOS33 [get_ports spi_chc2442_sclk_o]
set_property IOSTANDARD LVCMOS33 [get_ports spi_chc2442_sdata_i]

############ LMX2492 ##########################################################

set_property PACKAGE_PIN C16 [get_ports lmx2492_mod_o]
set_property PACKAGE_PIN F15 [get_ports spi_lmx2492_sen_o]
set_property PACKAGE_PIN L15 [get_ports spi_lmx2492_sdata_o]
set_property PACKAGE_PIN F16 [get_ports spi_lmx2492_sclk_o]
set_property PACKAGE_PIN D16 [get_ports spi_lmx2492_sdata_i]
set_property PACKAGE_PIN E17 [get_ports spi_lmx2492_ce_o]

# #MUXout,Readback
set_property IOSTANDARD LVCMOS33 [get_ports lmx2492_mod_o]
set_property IOSTANDARD LVCMOS33 [get_ports spi_lmx2492_sen_o]
set_property IOSTANDARD LVCMOS33 [get_ports spi_lmx2492_sdata_o]
set_property IOSTANDARD LVCMOS33 [get_ports spi_lmx2492_sclk_o]
set_property IOSTANDARD LVCMOS33 [get_ports spi_lmx2492_sdata_i]
set_property IOSTANDARD LVCMOS33 [get_ports spi_lmx2492_ce_o]

set_property PACKAGE_PIN A15 [get_ports spi_lmx2492_TRIG1]
set_property IOSTANDARD LVCMOS33 [get_ports spi_lmx2492_TRIG1]
#set_property PACKAGE_PIN D15 [get_ports spi_lmx2492_TRIG2]
#set_property IOSTANDARD LVCMOS33 [get_ports spi_lmx2492_TRIG2]

# ########################awmf0165###############################
## group0

set_property PACKAGE_PIN AC7 [get_ports {awmf_sdi_i[0]}]
set_property PACKAGE_PIN AB11 [get_ports {awmf_sdo_o[0]}]
set_property PACKAGE_PIN C12 [get_ports {awmf_pdo_o[0]}]
set_property PACKAGE_PIN B14 [get_ports {awmf_ldb_o[0]}]
set_property PACKAGE_PIN B12 [get_ports {awmf_csb_o[0]}]
set_property PACKAGE_PIN A14 [get_ports {awmf_clk_o[0]}]

set_property IOSTANDARD LVCMOS18 [get_ports {awmf_sdi_i[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {awmf_sdo_o[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {awmf_pdo_o[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {awmf_ldb_o[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {awmf_csb_o[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {awmf_clk_o[0]}]

set_property PACKAGE_PIN E12 [get_ports {awmf_mode_o[0]}]
set_property PACKAGE_PIN F12 [get_ports {awmf_mode_o[1]}]

set_property IOSTANDARD LVCMOS18 [get_ports {awmf_mode_o[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {awmf_mode_o[1]}]


# set_property IOSTANDARD LVCMOS18 [get_ports awmf_mode_o]


## group1
set_property PACKAGE_PIN AC11 [get_ports {awmf_sdi_i[1]}]
set_property PACKAGE_PIN A13 [get_ports {awmf_sdo_o[1]}]
set_property PACKAGE_PIN D14 [get_ports {awmf_pdo_o[1]}]
set_property PACKAGE_PIN D12 [get_ports {awmf_ldb_o[1]}]
set_property PACKAGE_PIN C14 [get_ports {awmf_csb_o[1]}]
set_property PACKAGE_PIN C13 [get_ports {awmf_clk_o[1]}]

set_property IOSTANDARD LVCMOS18 [get_ports {awmf_sdi_i[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {awmf_sdo_o[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {awmf_pdo_o[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {awmf_ldb_o[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {awmf_csb_o[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {awmf_clk_o[1]}]

set_property PACKAGE_PIN AD9 [get_ports {awmf_mode_o[2]}]
set_property PACKAGE_PIN A12 [get_ports {awmf_mode_o[3]}]


set_property IOSTANDARD LVCMOS18 [get_ports {awmf_mode_o[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {awmf_mode_o[3]}]


## group2
set_property PACKAGE_PIN AB3 [get_ports {awmf_sdi_i[2]}]
set_property PACKAGE_PIN AE2 [get_ports {awmf_sdo_o[2]}]
set_property PACKAGE_PIN AE4 [get_ports {awmf_pdo_o[2]}]
set_property PACKAGE_PIN AD4 [get_ports {awmf_ldb_o[2]}]
set_property PACKAGE_PIN AD5 [get_ports {awmf_csb_o[2]}]
set_property PACKAGE_PIN G14 [get_ports {awmf_clk_o[2]}]

set_property IOSTANDARD LVCMOS18 [get_ports {awmf_sdi_i[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {awmf_sdo_o[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {awmf_pdo_o[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {awmf_ldb_o[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {awmf_csb_o[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {awmf_clk_o[2]}]


set_property PACKAGE_PIN AA3 [get_ports {awmf_mode_o[4]}]
set_property PACKAGE_PIN AD2 [get_ports {awmf_mode_o[5]}]

set_property IOSTANDARD LVCMOS18 [get_ports {awmf_mode_o[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {awmf_mode_o[5]}]


## group3
set_property PACKAGE_PIN AC4 [get_ports {awmf_sdi_i[3]}]
set_property PACKAGE_PIN AE3 [get_ports {awmf_sdo_o[3]}]
set_property PACKAGE_PIN AD6 [get_ports {awmf_pdo_o[3]}]
set_property PACKAGE_PIN AC6 [get_ports {awmf_ldb_o[3]}]
set_property PACKAGE_PIN H14 [get_ports {awmf_csb_o[3]}]
set_property PACKAGE_PIN AE5 [get_ports {awmf_clk_o[3]}]

set_property IOSTANDARD LVCMOS18 [get_ports {awmf_sdi_i[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {awmf_sdo_o[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {awmf_pdo_o[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {awmf_ldb_o[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {awmf_csb_o[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {awmf_clk_o[3]}]

set_property PACKAGE_PIN AB4 [get_ports {awmf_mode_o[6]}]
set_property PACKAGE_PIN AC3 [get_ports {awmf_mode_o[7]}]

set_property IOSTANDARD LVCMOS18 [get_ports {awmf_mode_o[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {awmf_mode_o[7]}]


## U8
set_property PACKAGE_PIN AC2 [get_ports {awmf_sdi_i[4]}]
set_property PACKAGE_PIN AA2 [get_ports {awmf_sdo_o[4]}]
set_property PACKAGE_PIN AE1 [get_ports {awmf_pdo_o[4]}]
set_property PACKAGE_PIN AD1 [get_ports {awmf_ldb_o[4]}]
set_property PACKAGE_PIN AC1 [get_ports {awmf_csb_o[4]}]
set_property PACKAGE_PIN AB1 [get_ports {awmf_clk_o[4]}]

set_property IOSTANDARD LVCMOS18 [get_ports {awmf_sdi_i[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {awmf_sdo_o[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {awmf_pdo_o[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {awmf_ldb_o[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {awmf_csb_o[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {awmf_clk_o[4]}]

set_property PACKAGE_PIN AA1 [get_ports {awmf_mode_o[8]}]
set_property PACKAGE_PIN Y1 [get_ports {awmf_mode_o[9]}]

set_property IOSTANDARD LVCMOS18 [get_ports {awmf_mode_o[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {awmf_mode_o[9]}]


#########################adc##################################

set_property PACKAGE_PIN AD7 [get_ports adc3663_fclk_p]
set_property PACKAGE_PIN AE7 [get_ports adc3663_fclk_n]
set_property IOSTANDARD LVDS [get_ports adc3663_fclk_p]
set_property IOSTANDARD LVDS [get_ports adc3663_fclk_n]

set_property PACKAGE_PIN AA8 [get_ports adc3663_dclk_p]
set_property PACKAGE_PIN AB8 [get_ports adc3663_dclk_n]
set_property IOSTANDARD LVDS [get_ports adc3663_dclk_p]
set_property IOSTANDARD LVDS [get_ports adc3663_dclk_n]

set_property PACKAGE_PIN W8 [get_ports adc3663_da0_p]
set_property PACKAGE_PIN Y8 [get_ports adc3663_da0_n]
set_property IOSTANDARD LVDS [get_ports adc3663_da0_p]
set_property IOSTANDARD LVDS [get_ports adc3663_da0_n]

set_property PACKAGE_PIN Y10 [get_ports adc3663_da1_p]
set_property PACKAGE_PIN AA10 [get_ports adc3663_da1_n]
set_property IOSTANDARD LVDS [get_ports adc3663_da1_p]
set_property IOSTANDARD LVDS [get_ports adc3663_da1_n]

set_property PACKAGE_PIN Y7 [get_ports adc3663_db0_p]
set_property PACKAGE_PIN AA7 [get_ports adc3663_db0_n]
set_property IOSTANDARD LVDS [get_ports adc3663_db0_p]
set_property IOSTANDARD LVDS [get_ports adc3663_db0_n]

set_property PACKAGE_PIN AA6 [get_ports adc3663_db1_p]
set_property PACKAGE_PIN AA5 [get_ports adc3663_db1_n]
set_property IOSTANDARD LVDS [get_ports adc3663_db1_p]
set_property IOSTANDARD LVDS [get_ports adc3663_db1_n]

set_property PACKAGE_PIN AB6 [get_ports adc3663_dclk_o_p]
set_property PACKAGE_PIN AB5 [get_ports adc3663_dclk_o_n]
set_property IOSTANDARD LVDS [get_ports adc3663_dclk_o_p]
set_property IOSTANDARD LVDS [get_ports adc3663_dclk_o_n]

set_property PACKAGE_PIN AC8 [get_ports pl_clk_40m]
set_property IOSTANDARD LVCMOS18 [get_ports pl_clk_40m]


##################################################################

set_property PACKAGE_PIN H16 [get_ports gps_uart_tx]
set_property PACKAGE_PIN J16 [get_ports gps_uart_rx]
set_property PACKAGE_PIN J14 [get_ports gps_pps]

set_property IOSTANDARD LVCMOS33 [get_ports gps_uart_tx]
set_property IOSTANDARD LVCMOS33 [get_ports gps_uart_rx]
set_property IOSTANDARD LVCMOS33 [get_ports gps_pps]

##################################################################################

set_property PACKAGE_PIN AA12 [get_ports acc_i2c_scl]
set_property PACKAGE_PIN AD12 [get_ports acc_i2c_sda]
set_property PACKAGE_PIN AC12 [get_ports acc_magint]
set_property PACKAGE_PIN AA11 [get_ports acc_cs]
set_property PACKAGE_PIN AC9 [get_ports acc_int2_xl]
set_property PACKAGE_PIN W9 [get_ports acc_int1_xl]

set_property IOSTANDARD LVCMOS18 [get_ports acc_i2c_scl]
set_property IOSTANDARD LVCMOS18 [get_ports acc_i2c_sda]
set_property IOSTANDARD LVCMOS18 [get_ports acc_magint]
set_property IOSTANDARD LVCMOS18 [get_ports acc_cs]
set_property IOSTANDARD LVCMOS18 [get_ports acc_int2_xl]
set_property IOSTANDARD LVCMOS18 [get_ports acc_int1_xl]

##################################################################################

set_property PACKAGE_PIN K14  [get_ports IMU_RX]
set_property PACKAGE_PIN L14  [get_ports IMU_TX]
set_property PACKAGE_PIN AD11 [get_ports CP_UART3_TX_1V8]
set_property PACKAGE_PIN AD10 [get_ports CP_UART3_RX_1V8]
# set_property PACKAGE_PIN AD10 [get_ports BT_UART_RXD]
# set_property PACKAGE_PIN AB10 [get_ports BT_UART_TXD]
set_property PACKAGE_PIN G15 [get_ports MCU_WDG_TX]
set_property PACKAGE_PIN G16 [get_ports MCU_WDG_RX]
set_property PACKAGE_PIN D17 [get_ports TC_OE_3V3]

set_property PACKAGE_PIN J15 [get_ports PS_UART1_INT_N]

#set_property PACKAGE_PIN J15 [get_ports PS_UART1_INT_N]

set_property IOSTANDARD LVCMOS33 [get_ports IMU_RX]
set_property IOSTANDARD LVCMOS33 [get_ports IMU_TX]
set_property IOSTANDARD LVCMOS18 [get_ports CP_UART3_RX_1V8]
set_property IOSTANDARD LVCMOS18 [get_ports CP_UART3_TX_1V8]
set_property IOSTANDARD LVCMOS18 [get_ports BT_UART_TXD]
set_property IOSTANDARD LVCMOS18 [get_ports BT_UART_RXD]
set_property IOSTANDARD LVCMOS33 [get_ports MCU_WDG_TX]
set_property IOSTANDARD LVCMOS33 [get_ports MCU_WDG_RX]
set_property IOSTANDARD LVCMOS33 [get_ports TC_OE_3V3]


#########################################################################
set_property PACKAGE_PIN E15 [get_ports PLI2C_1_SDA]
set_property PACKAGE_PIN B15 [get_ports PLI2C_1_SCL]
set_property PACKAGE_PIN H12 [get_ports PLI2C_2_SDA]
set_property PACKAGE_PIN H13 [get_ports PLI2C_2_SCL]
set_property PACKAGE_PIN AG19 [get_ports PLI2C3_SDA_1V2]
set_property PACKAGE_PIN AC19 [get_ports PLI2C3_SCL_1V2]

set_property IOSTANDARD LVCMOS33 [get_ports PLI2C_1_SDA]
set_property IOSTANDARD LVCMOS33 [get_ports PLI2C_1_SCL]
set_property IOSTANDARD LVCMOS18 [get_ports PLI2C_2_SDA]
set_property IOSTANDARD LVCMOS18 [get_ports PLI2C_2_SCL]
set_property IOSTANDARD LVCMOS12 [get_ports PLI2C3_SDA_1V2]
set_property IOSTANDARD LVCMOS12 [get_ports PLI2C3_SCL_1V2]
set_property DRIVE 4 [get_ports PLI2C3_SDA_1V2]
set_property DRIVE 4 [get_ports PLI2C3_SCL_1V2]

#########################################################################


#########################################################################
set_property PACKAGE_PIN AF18 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS12 [get_ports {led[0]}]

set_property PACKAGE_PIN AE18 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS12 [get_ports {led[1]}]

set_property PACKAGE_PIN AH18 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS12 [get_ports {led[2]}]

set_property PACKAGE_PIN AG18 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS12 [get_ports {led[3]}]

set_property PACKAGE_PIN AK18 [get_ports {led[4]}]
set_property IOSTANDARD LVCMOS12 [get_ports {led[4]}]

set_property PACKAGE_PIN AK17 [get_ports {led[5]}]
set_property IOSTANDARD LVCMOS12 [get_ports {led[5]}]
set_property DRIVE 4 [get_ports {led[5]}]
set_property DRIVE 4 [get_ports {led[4]}]
set_property DRIVE 4 [get_ports {led[3]}]
set_property DRIVE 4 [get_ports {led[2]}]
set_property DRIVE 4 [get_ports {led[1]}]
set_property DRIVE 4 [get_ports {led[0]}]


######-------------------------------------------DDR4--------------------------------------------------

set_property PACKAGE_PIN AK9 [get_ports {ddr4_dm_n[1]}]
set_property PACKAGE_PIN AK3 [get_ports {ddr4_dm_n[2]}]
set_property PACKAGE_PIN AH6 [get_ports {ddr4_dm_n[3]}]
set_property PACKAGE_PIN AA13 [get_ports {ddr4_dm_n[0]}]

set_property PACKAGE_PIN AG13 [get_ports {ddr4_adr[0]}]
set_property PACKAGE_PIN AH13 [get_ports {ddr4_adr[1]}]
set_property PACKAGE_PIN AK13 [get_ports {ddr4_adr[2]}]
set_property PACKAGE_PIN AK12 [get_ports {ddr4_adr[3]}]
set_property PACKAGE_PIN AJ14 [get_ports {ddr4_adr[4]}]
set_property PACKAGE_PIN AK14 [get_ports {ddr4_adr[5]}]
set_property PACKAGE_PIN AG14 [get_ports {ddr4_adr[6]}]
set_property PACKAGE_PIN AH14 [get_ports {ddr4_adr[7]}]
set_property PACKAGE_PIN AF15 [get_ports {ddr4_adr[8]}]
set_property PACKAGE_PIN AG15 [get_ports {ddr4_adr[9]}]
set_property PACKAGE_PIN AD17 [get_ports {ddr4_adr[10]}]
set_property PACKAGE_PIN AE17 [get_ports {ddr4_adr[11]}]
set_property PACKAGE_PIN AC16 [get_ports {ddr4_adr[12]}]
set_property PACKAGE_PIN AD16 [get_ports {ddr4_adr[13]}]
set_property PACKAGE_PIN AA16 [get_ports {ddr4_adr[14]}]
set_property PACKAGE_PIN AB16 [get_ports {ddr4_adr[15]}]
set_property PACKAGE_PIN AC17 [get_ports {ddr4_adr[16]}]

set_property PACKAGE_PIN AK16 [get_ports ddr4_act_n]

set_property PACKAGE_PIN AC18 [get_ports {ddr4_ba[0]}]
set_property PACKAGE_PIN AD19 [get_ports {ddr4_ba[1]}]
set_property PACKAGE_PIN AE19 [get_ports {ddr4_bg[0]}]
set_property PACKAGE_PIN AJ15 [get_ports {ddr4_ck_t[0]}]
set_property PACKAGE_PIN AK15 [get_ports {ddr4_ck_c[0]}]

set_property PACKAGE_PIN AH16 [get_ports {ddr4_cke[0]}]
set_property PACKAGE_PIN AG16 [get_ports {ddr4_cs_n[0]}]
set_property PACKAGE_PIN AE14 [get_ports {ddr4_dq[0]}]
set_property PACKAGE_PIN AF8 [get_ports {ddr4_dq[10]}]
set_property PACKAGE_PIN AF7 [get_ports {ddr4_dq[11]}]
set_property PACKAGE_PIN AG8 [get_ports {ddr4_dq[12]}]
set_property PACKAGE_PIN AH8 [get_ports {ddr4_dq[13]}]
set_property PACKAGE_PIN AH7 [get_ports {ddr4_dq[14]}]
set_property PACKAGE_PIN AJ7 [get_ports {ddr4_dq[15]}]
set_property PACKAGE_PIN AJ2 [get_ports {ddr4_dq[16]}]
set_property PACKAGE_PIN AJ1 [get_ports {ddr4_dq[17]}]
set_property PACKAGE_PIN AH3 [get_ports {ddr4_dq[18]}]
set_property PACKAGE_PIN AH2 [get_ports {ddr4_dq[19]}]
set_property PACKAGE_PIN AE13 [get_ports {ddr4_dq[1]}]
set_property PACKAGE_PIN AG1 [get_ports {ddr4_dq[20]}]
set_property PACKAGE_PIN AH1 [get_ports {ddr4_dq[21]}]
set_property PACKAGE_PIN AF3 [get_ports {ddr4_dq[22]}]
set_property PACKAGE_PIN AF2 [get_ports {ddr4_dq[23]}]
set_property PACKAGE_PIN AG6 [get_ports {ddr4_dq[24]}]
set_property PACKAGE_PIN AG5 [get_ports {ddr4_dq[25]}]
set_property PACKAGE_PIN AK7 [get_ports {ddr4_dq[26]}]
set_property PACKAGE_PIN AK6 [get_ports {ddr4_dq[27]}]
set_property PACKAGE_PIN AJ4 [get_ports {ddr4_dq[28]}]
set_property PACKAGE_PIN AK4 [get_ports {ddr4_dq[29]}]
set_property PACKAGE_PIN AC14 [get_ports {ddr4_dq[2]}]
set_property PACKAGE_PIN AF6 [get_ports {ddr4_dq[30]}]
set_property PACKAGE_PIN AF5 [get_ports {ddr4_dq[31]}]
set_property PACKAGE_PIN AD14 [get_ports {ddr4_dq[3]}]
set_property PACKAGE_PIN AA15 [get_ports {ddr4_dq[4]}]
set_property PACKAGE_PIN AB15 [get_ports {ddr4_dq[5]}]
set_property PACKAGE_PIN AD15 [get_ports {ddr4_dq[6]}]
set_property PACKAGE_PIN AE15 [get_ports {ddr4_dq[7]}]
set_property PACKAGE_PIN AH9 [get_ports {ddr4_dq[8]}]
set_property PACKAGE_PIN AJ9 [get_ports {ddr4_dq[9]}]
set_property PACKAGE_PIN AA14 [get_ports {ddr4_dqs_t[0]}]
set_property PACKAGE_PIN AB14 [get_ports {ddr4_dqs_c[0]}]
set_property PACKAGE_PIN AE9 [get_ports {ddr4_dqs_t[1]}]
set_property PACKAGE_PIN AE8 [get_ports {ddr4_dqs_c[1]}]
set_property PACKAGE_PIN AG4 [get_ports {ddr4_dqs_t[2]}]
set_property PACKAGE_PIN AG3 [get_ports {ddr4_dqs_c[2]}]
set_property PACKAGE_PIN AJ5 [get_ports {ddr4_dqs_t[3]}]
set_property PACKAGE_PIN AK5 [get_ports {ddr4_dqs_c[3]}]
set_property PACKAGE_PIN AJ16 [get_ports {ddr4_odt[0]}]

set_property PACKAGE_PIN AH17 [get_ports ddr4_reset_n]

set_property PACKAGE_PIN AF16 [get_ports sys_clk_p]
set_property PACKAGE_PIN AF17 [get_ports sys_clk_n]
# set_property IOSTANDARD LVCMOS12 [get_ports sys_clk_p]
# set_property IOSTANDARD LVCMOS12 [get_ports sys_clk_n]


#set_property PACKAGE_PIN AF10 [get_ports PL_DDR_PAR]
#set_property PACKAGE_PIN AK10 [get_ports PL_DDR_TEN]
#set_property PACKAGE_PIN AJ10 [get_ports PL_DDR_ALERT_N]

#set_property IOSTANDARD LVCMOS12 [get_ports PL_DDR_PAR]
#set_property IOSTANDARD LVCMOS12 [get_ports PL_DDR_TEN]
#set_property IOSTANDARD LVCMOS12 [get_ports PL_DDR_ALERT_N]

set_property PACKAGE_PIN AF1 [get_ports TC_SHIFT_OE_1V2]
set_property IOSTANDARD LVCMOS12 [get_ports TC_SHIFT_OE_1V2]
set_property DRIVE 4 [get_ports TC_SHIFT_OE_1V2]
set_property PACKAGE_PIN AK8 [get_ports ANT_EN_1V2]
set_property IOSTANDARD LVCMOS12 [get_ports ANT_EN_1V2]
set_property DRIVE 4 [get_ports ANT_EN_1V2]
set_property PACKAGE_PIN AG9 [get_ports ANT_CTRL_1V2]
set_property IOSTANDARD LVCMOS12 [get_ports ANT_CTRL_1V2]
set_property DRIVE 4 [get_ports ANT_CTRL_1V2]
set_property PACKAGE_PIN AK11 [get_ports TC_DGB_BOOT_1V2]
set_property IOSTANDARD LVCMOS12 [get_ports TC_DGB_BOOT_1V2]
set_property DRIVE 4 [get_ports TC_DGB_BOOT_1V2]
set_property PACKAGE_PIN AJ11 [get_ports TC_PIO_RFU_1V2]
set_property IOSTANDARD LVCMOS12 [get_ports TC_PIO_RFU_1V2]
set_property DRIVE 4 [get_ports TC_PIO_RFU_1V2]
set_property PACKAGE_PIN AH11 [get_ports USBMUX_OEN_1V2]
set_property IOSTANDARD LVCMOS12 [get_ports USBMUX_OEN_1V2]
set_property DRIVE 4 [get_ports USBMUX_OEN_1V2]
set_property PACKAGE_PIN AG11 [get_ports USB_SEL_1V2]
set_property IOSTANDARD LVCMOS12 [get_ports USB_SEL_1V2]
set_property DRIVE 4 [get_ports USB_SEL_1V2]

set_property PACKAGE_PIN AB10 [get_ports BT_UART_RTS_N]
set_property IOSTANDARD LVCMOS18 [get_ports BT_UART_RTS_N]
set_property PACKAGE_PIN AB9 [get_ports BT_UART_CTS]
set_property IOSTANDARD LVCMOS18 [get_ports BT_UART_CTS]


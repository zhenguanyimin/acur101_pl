
# creat clk
create_clock -period 12.500 -name adc3663_dclk_p [get_ports adc3663_dclk_p]
create_generated_clock -name clk_10m -source [get_pins per_config/adc_3663_ctr/ps_clk_100m] -divide_by 10 [get_pins per_config/clk_10m_reg]
create_generated_clock -name clk_25m -source [get_pins per_config/adc_3663_ctr/ps_clk_100m] -divide_by 4 [get_pins per_config/awmf_0165_top/clk_25m]

# asynchronous timing
#set_max_delay -datapath_only -from [get_clocks adc3663_dclk_p] -to [get_clocks clk_pl_0] 10.0
#set_max_delay -datapath_only -from [get_clocks -of_objects [get_pins per_config/BUFGCE_DIV_inst/O]] -to [get_clocks clk_25m] 50.0
#set_max_delay -datapath_only -from [get_clocks clk_pl_0] -to [get_clocks -of_objects [get_pins per_config/BUFGCE_DIV_inst/O]] 50.0
#set_max_delay -datapath_only -from [get_clocks clk_10m] -to [get_clocks clk_pl_0] 100.0
#set_max_delay -datapath_only -from [get_clocks clk_25m] -to [get_clocks clk_pl_0] 40.0
#set_max_delay -datapath_only -from [get_clocks clk_pl_0] -to [get_clocks adc3663_dclk_p] 10.0

set_max_delay -datapath_only -from [get_clocks -of_objects [get_pins per_config/BUFGCE_DIV_inst/O]] -to [get_clocks adc3663_dclk_p] 50.000
set_max_delay -datapath_only -from [get_clocks adc3663_dclk_p] -to [get_clocks -of_objects [get_pins clk_rst_ctr/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT0]] 12.500
set_max_delay -datapath_only -from [get_clocks -of_objects [get_pins per_config/BUFGCE_DIV_inst/O]] -to [get_clocks clk_25m] 50.000
set_max_delay -datapath_only -from [get_clocks clk_10m] -to [get_clocks clk_pl_0] 100.000
set_max_delay -datapath_only -from [get_clocks clk_25m] -to [get_clocks clk_pl_0] 10.000
set_max_delay -datapath_only -from [get_clocks clk_pl_0] -to [get_clocks adc3663_dclk_p] 10.000
set_max_delay -datapath_only -from [get_clocks clk_pl_0] -to [get_clocks -of_objects [get_pins per_config/BUFGCE_DIV_inst/O]] 50.000
set_max_delay -datapath_only -from [get_clocks clk_pl_0] -to [get_clocks clk_10m] 100.000
set_max_delay -datapath_only -from [get_clocks clk_pl_0] -to [get_clocks clk_25m] 40.000
set_max_delay -datapath_only -from [get_clocks clk_pl_0] -to [get_clocks -of_objects [get_pins clk_rst_ctr/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT0]] 10.000
set_max_delay -datapath_only -from [get_pins clk_rst_ctr/sys_rst_reg/C] -to [get_pins ddr_top/ddr_axi_interface/s_axi_wvalid_reg/D] 10.0
set_max_delay -from [get_clocks -of_objects [get_pins clk_rst_ctr/clk_wiz_0/inst/mmcme4_adv_inst/CLKOUT0]] -to [get_clocks clk_pl_0] 10.000
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

##############################################################################################################################################
set_input_delay -clock [get_clocks adc3663_dclk_p] -rise -max 2.425 [get_ports {adc3663_da0_p adc3663_da1_p}]
set_input_delay -clock [get_clocks adc3663_dclk_p] -rise -min -add_delay 2.225 [get_ports {adc3663_da0_p adc3663_da1_p}]

set_input_delay -clock [get_clocks adc3663_dclk_p] -clock_fall -fall -max 2.425 [get_ports {adc3663_da0_p adc3663_da1_p}]
set_input_delay -clock [get_clocks adc3663_dclk_p] -clock_fall -fall -min -add_delay 2.225 [get_ports {adc3663_da0_p adc3663_da1_p}]

# set_input_delay -clock [get_clocks adc3663_dclk_p] -rise -max 5.850 [get_ports adc3663_fclk_p]
# set_input_delay -clock [get_clocks adc3663_dclk_p] -rise -min -add_delay 5.650 [get_ports adc3663_fclk_p]

set_input_delay -clock [get_clocks adc3663_dclk_p] -rise -max 0.800 [get_ports adc3663_fclk_p]
set_input_delay -clock [get_clocks adc3663_dclk_p] -rise -min -add_delay 0.600 [get_ports adc3663_fclk_p]

##############################################################################################################################################

### V2
##############################################################################################################################################
# set_input_delay -clock [get_clocks adc3663_dclk_p] -rise -max -1.2 [get_ports {adc3663_da0_p adc3663_da1_p}]
# set_input_delay -clock [get_clocks adc3663_dclk_p] -rise -min -add_delay 2.25 [get_ports {adc3663_da0_p adc3663_da1_p}]

# set_input_delay -clock [get_clocks adc3663_dclk_p] -clock_fall -fall -max -1.2 [get_ports {adc3663_da0_p adc3663_da1_p}]
# set_input_delay -clock [get_clocks adc3663_dclk_p] -clock_fall -fall -min -add_delay 2.25 [get_ports {adc3663_da0_p adc3663_da1_p}]

# set_input_delay -clock [get_clocks adc3663_dclk_p] -rise -max -1.2 [get_ports {adc3663_db0_p adc3663_db1_p}]
# set_input_delay -clock [get_clocks adc3663_dclk_p] -rise -min -add_delay 2.25 [get_ports {adc3663_db0_p adc3663_db1_p}]

# set_input_delay -clock [get_clocks adc3663_dclk_p] -clock_fall -fall -max -1.2 [get_ports {adc3663_db0_p adc3663_db1_p}]
# set_input_delay -clock [get_clocks adc3663_dclk_p] -clock_fall -fall -min -add_delay 2.25 [get_ports {adc3663_db0_p adc3663_db1_p}]

# set_input_delay -clock [get_clocks adc3663_dclk_p] -rise -max -1 [get_ports adc3663_fclk_p]
# set_input_delay -clock [get_clocks adc3663_dclk_p] -rise -min -add_delay 5.650 [get_ports adc3663_fclk_p]

##############################################################################################################################################
### V3
##############################################################################################################################################
# set_input_delay -clock [get_clocks adc3663_dclk_p] -rise -max -0.8 [get_ports {adc3663_da0_p adc3663_da1_p}]
# set_input_delay -clock [get_clocks adc3663_dclk_p] -rise -min -add_delay -1.2 [get_ports {adc3663_da0_p adc3663_da1_p}]

# set_input_delay -clock [get_clocks adc3663_dclk_p] -clock_fall -fall -max -0.8 [get_ports {adc3663_da0_p adc3663_da1_p}]
# set_input_delay -clock [get_clocks adc3663_dclk_p] -clock_fall -fall -min -add_delay -1.2 [get_ports {adc3663_da0_p adc3663_da1_p}]

# set_input_delay -clock [get_clocks adc3663_dclk_p] -rise -max -0.8 [get_ports {adc3663_db0_p adc3663_db1_p}]
# set_input_delay -clock [get_clocks adc3663_dclk_p] -rise -min -add_delay -1.2 [get_ports {adc3663_db0_p adc3663_db1_p}]

# set_input_delay -clock [get_clocks adc3663_dclk_p] -clock_fall -fall -max -0.8 [get_ports {adc3663_db0_p adc3663_db1_p}]
# set_input_delay -clock [get_clocks adc3663_dclk_p] -clock_fall -fall -min -add_delay -1.2 [get_ports {adc3663_db0_p adc3663_db1_p}]

# set_input_delay -clock [get_clocks adc3663_dclk_p] -rise -max -1 [get_ports adc3663_fclk_p]
# # set_input_delay -clock [get_clocks adc3663_dclk_p] -rise -min -add_delay 5.650 [get_ports adc3663_fclk_p]

##############################################################################################################################################


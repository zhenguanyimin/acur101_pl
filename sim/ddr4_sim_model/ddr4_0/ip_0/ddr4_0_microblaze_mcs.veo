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

// IP VLNV: xilinx.com:ip:microblaze_mcs:3.0
// IP Revision: 20

// The following must be inserted into your Verilog file for this
// core to be instantiated. Change the instance name and port connections
// (in parentheses) to your own signal names.

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
ddr4_0_microblaze_mcs your_instance_name (
  .Clk(Clk),                                        // input wire Clk
  .Reset(Reset),                                    // input wire Reset
  .TRACE_data_access(TRACE_data_access),            // output wire TRACE_data_access
  .TRACE_data_address(TRACE_data_address),          // output wire [0 : 31] TRACE_data_address
  .TRACE_data_byte_enable(TRACE_data_byte_enable),  // output wire [0 : 3] TRACE_data_byte_enable
  .TRACE_data_read(TRACE_data_read),                // output wire TRACE_data_read
  .TRACE_data_write(TRACE_data_write),              // output wire TRACE_data_write
  .TRACE_data_write_value(TRACE_data_write_value),  // output wire [0 : 31] TRACE_data_write_value
  .TRACE_dcache_hit(TRACE_dcache_hit),              // output wire TRACE_dcache_hit
  .TRACE_dcache_rdy(TRACE_dcache_rdy),              // output wire TRACE_dcache_rdy
  .TRACE_dcache_read(TRACE_dcache_read),            // output wire TRACE_dcache_read
  .TRACE_dcache_req(TRACE_dcache_req),              // output wire TRACE_dcache_req
  .TRACE_delay_slot(TRACE_delay_slot),              // output wire TRACE_delay_slot
  .TRACE_ex_piperun(TRACE_ex_piperun),              // output wire TRACE_ex_piperun
  .TRACE_exception_kind(TRACE_exception_kind),      // output wire [0 : 4] TRACE_exception_kind
  .TRACE_exception_taken(TRACE_exception_taken),    // output wire TRACE_exception_taken
  .TRACE_icache_hit(TRACE_icache_hit),              // output wire TRACE_icache_hit
  .TRACE_icache_rdy(TRACE_icache_rdy),              // output wire TRACE_icache_rdy
  .TRACE_icache_req(TRACE_icache_req),              // output wire TRACE_icache_req
  .TRACE_instruction(TRACE_instruction),            // output wire [0 : 31] TRACE_instruction
  .TRACE_jump_hit(TRACE_jump_hit),                  // output wire TRACE_jump_hit
  .TRACE_jump_taken(TRACE_jump_taken),              // output wire TRACE_jump_taken
  .TRACE_mb_halted(TRACE_mb_halted),                // output wire TRACE_mb_halted
  .TRACE_mem_piperun(TRACE_mem_piperun),            // output wire TRACE_mem_piperun
  .TRACE_msr_reg(TRACE_msr_reg),                    // output wire [0 : 14] TRACE_msr_reg
  .TRACE_new_reg_value(TRACE_new_reg_value),        // output wire [0 : 31] TRACE_new_reg_value
  .TRACE_of_piperun(TRACE_of_piperun),              // output wire TRACE_of_piperun
  .TRACE_pc(TRACE_pc),                              // output wire [0 : 31] TRACE_pc
  .TRACE_pid_reg(TRACE_pid_reg),                    // output wire [0 : 7] TRACE_pid_reg
  .TRACE_reg_addr(TRACE_reg_addr),                  // output wire [0 : 4] TRACE_reg_addr
  .TRACE_reg_write(TRACE_reg_write),                // output wire TRACE_reg_write
  .TRACE_valid_instr(TRACE_valid_instr),            // output wire TRACE_valid_instr
  .IO_addr_strobe(IO_addr_strobe),                  // output wire IO_addr_strobe
  .IO_address(IO_address),                          // output wire [31 : 0] IO_address
  .IO_byte_enable(IO_byte_enable),                  // output wire [3 : 0] IO_byte_enable
  .IO_read_data(IO_read_data),                      // input wire [31 : 0] IO_read_data
  .IO_read_strobe(IO_read_strobe),                  // output wire IO_read_strobe
  .IO_ready(IO_ready),                              // input wire IO_ready
  .IO_write_data(IO_write_data),                    // output wire [31 : 0] IO_write_data
  .IO_write_strobe(IO_write_strobe)                // output wire IO_write_strobe
);
// INST_TAG_END ------ End INSTANTIATION Template ---------

// You must compile the wrapper file ddr4_0_microblaze_mcs.v when simulating
// the core, ddr4_0_microblaze_mcs. When compiling the wrapper file, be sure to
// reference the Verilog simulation library.


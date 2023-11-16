module sysmon
(
    input             clk ,
    input             rst ,

    input   [15:0]    VAUXN       ,     
    input   [15:0]    VAUXP       ,

    output  reg [15:0]    temperature ,

    output  reg [15:0]    ADC_DATA_CH0,
    output  reg [15:0]    ADC_DATA_CH1,
    output  reg [15:0]    ADC_DATA_CH2,
    output  reg [15:0]    ADC_DATA_CH3,
    output  reg [15:0]    ADC_DATA_CH4,
    output  reg [15:0]    ADC_DATA_CH5,
    output  reg [15:0]    ADC_DATA_CH6,
    output  reg [15:0]    ADC_DATA_CH7,
    output  reg [15:0]    ADC_DATA_CH8,
    output  reg [15:0]    ADC_DATA_CH9,
    output  reg [15:0]    ADC_DATA_CH10,
    output  reg [15:0]    ADC_DATA_CH11,
    output  reg [15:0]    ADC_DATA_CH12,
    output  reg [15:0]    ADC_DATA_CH13,
    output  reg [15:0]    ADC_DATA_CH14,
    output  reg [15:0]    ADC_DATA_CH15

);

 wire [15:0] adc_data       ;
 reg  [5 :0] addr_drp       ;
 reg         den_drp        ;
 wire        drdy_drp       ;
 wire [15:0] adc_data_debug ;
 wire  [5:0]  CHANNEL       ;
 wire         EOC           ;


 SYSMONE4 #(
      // INIT_40 - INIT_44: SYSMON configuration registers
      .INIT_40(16'h9000),
      .INIT_41(16'h2fdc),
      .INIT_42(16'h0A00),
      .INIT_43(16'h0000),
      .INIT_44(16'h0000),
      .INIT_45(16'h0000),              // Analog Bus Register.
      // INIT_46 - INIT_4F: Sequence Registers
      .INIT_46(16'h000f),
      .INIT_47(16'hffff),
      .INIT_48(16'hffff),
      .INIT_49(16'hffff),
      .INIT_4A(16'h0000),
      .INIT_4B(16'h0000),
      .INIT_4C(16'h0000),
      .INIT_4D(16'h0000),
      .INIT_4E(16'h0000),
      .INIT_4F(16'h0000),
      // INIT_50 - INIT_5F: Alarm Limit Registers
      .INIT_50(16'h0000),
      .INIT_51(16'h0000),
      .INIT_52(16'h0000),
      .INIT_53(16'h0000),
      .INIT_54(16'h0000),
      .INIT_55(16'h0000),
      .INIT_56(16'h0000),
      .INIT_57(16'h0000),
      .INIT_58(16'h0000),
      .INIT_59(16'h0000),
      .INIT_5A(16'h0000),
      .INIT_5B(16'h0000),
      .INIT_5C(16'h0000),
      .INIT_5D(16'h0000),
      .INIT_5E(16'h0000),
      .INIT_5F(16'h0000),
      // INIT_60 - INIT_6F: User Supply Alarms
      .INIT_60(16'h0000),
      .INIT_61(16'h0000),
      .INIT_62(16'h0000),
      .INIT_63(16'h0000),
      .INIT_64(16'h0000),
      .INIT_65(16'h0000),
      .INIT_66(16'h0000),
      .INIT_67(16'h0000),
      .INIT_68(16'h0000),
      .INIT_69(16'h0000),
      .INIT_6A(16'h0000),
      .INIT_6B(16'h0000),
      .INIT_6C(16'h0000),
      .INIT_6D(16'h0000),
      .INIT_6E(16'h0000),
      .INIT_6F(16'h0000),
      // Primitive attributes: Primitive Attributes
      .COMMON_N_SOURCE(16'hffff),      // Sets the auxiliary analog input that is used for the Common-N input.
      // Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion on
      // specific pins
      .IS_CONVSTCLK_INVERTED(1'b0),    // Optional inversion for CONVSTCLK, 0-1
      .IS_DCLK_INVERTED(1'b0),         // Optional inversion for DCLK, 0-1
      // Simulation attributes: Set for proper simulation behavior
      .SIM_DEVICE("ZYNQ_ULTRASCALE"),  // Sets the correct target device for simulation functionality.
      .SIM_MONITOR_FILE("adc_sim.csv"), // Analog simulation data file name
      // User Voltage Monitor: SYSMON User voltage monitor
      .SYSMON_VUSER0_BANK(0),          // Specify IO Bank for User0
      .SYSMON_VUSER0_MONITOR("NONE"),  // Specify Voltage for User0
      .SYSMON_VUSER1_BANK(0),          // Specify IO Bank for User1
      .SYSMON_VUSER1_MONITOR("NONE"),  // Specify Voltage for User1
      .SYSMON_VUSER2_BANK(0),          // Specify IO Bank for User2
      .SYSMON_VUSER2_MONITOR("NONE"),  // Specify Voltage for User2
      .SYSMON_VUSER3_MONITOR("NONE")   // Specify Voltage for User3
   )
   SYSMONE4_inst (
      // ALARMS outputs: ALM, OTaddr_drpDC_DATA
      .ADC_DATA(adc_data_debug),         // 16-bit output: Direct Data Out
      // Dynamic Reconfiguration Port (DRP) outputs: Dynamic Reconfiguration Ports
      .DO(adc_data),                     // 16-bit output: DRP output data bus
      .DRDY(drdy_drp),                 // 1-bit output: DRP data ready
      // I2C Interface outputs: Ports used with the I2C DRP interface
      .I2C_SCLK_TS(I2C_SCLK_TS),   // 1-bit output: I2C_SCLK output port
      .I2C_SDA_TS(I2C_SDA_TS),     // 1-bit output: I2C_SDA_TS output port
      .SMBALERT_TS(SMBALERT_TS),   // 1-bit output: Output control signal for SMBALERT.
      // STATUS outputs: SYSMON status ports
      .BUSY(BUSY),                 // 1-bit output: System Monitor busy output
      .CHANNEL(CHANNEL),           // 6-bit output: Channel selection outputs
      .EOC(EOC),                   // 1-bit output: End of Conversion
      .EOS(EOS),                   // 1-bit output: End of Sequence
      .JTAGBUSY(JTAGBUSY),         // 1-bit output: JTAG DRP transaction in progress output
      .JTAGLOCKED(JTAGLOCKED),     // 1-bit output: JTAG requested DRP port lock
      .JTAGMODIFIED(JTAGMODIFIED), // 1-bit output: JTAG Write to the DRP has occurred
      .MUXADDR(MUXADDR),           // 5-bit output: External MUX channel decode
      // Auxiliary Analog-Input Pairs inputs: VAUXP[15:0], VAUXN[15:0]
      .VAUXN(VAUXN),               // 16-bit input: N-side auxiliary analog input
      .VAUXP(VAUXP),               // 16-bit input: P-side auxiliary analog input
      // CONTROL and CLOCK inputs: addr_drpReset, conversion start and clock inputs
      .CONVST(1'd1),             // 1-bit input: Convert start input
      .CONVSTCLK(clk),       // 1-bit input: Convert start input
      .RESET(rst),               // 1-bit input: Active-High reset
      // Dedicated Analog Input Pair inputs: VP/VN
      .VN('d0),                     // 1-bit input: N-side analog input
      .VP('d0),                     // 1-bit input: P-side analog input
      // Dynamic Reconfiguration Port (DRP) inputs: Dynamic Reconfiguration Ports
      .DADDR(addr_drp),               // 8-bit input: DRP address bus
      .DCLK(clk),                 // 1-bit input: DRP clock
      .DEN(den_drp),                   // 1-bit input: DRP enable signal
      .DI('d0),                     // 16-bit input: DRP input data bus
      .DWE('d0),                   // 1-bit input: DRP write enable
      // I2C Interface inputs: Ports used with the I2C DRP interface
      .I2C_SCLK('d0),         // 1-bit input: I2C_SCLK input port
      .I2C_SDA('d0)            // 1-bit input: I2C_SDA input port
   );


always @(posedge clk) begin
    if(rst)
        den_drp <= 'd0 ;
    else if(EOC)
        den_drp <= 'd1 ;
    else 
        den_drp <= 'd0 ;
end

always @(posedge clk) begin
    if(rst)
        addr_drp <= 'd0 ;
    else if(EOC)
        addr_drp <=  CHANNEL;
    else 
        addr_drp <= addr_drp ;
end

always @(posedge clk) begin
    if(drdy_drp)
        case (addr_drp)
            'd0 : temperature <=  adc_data_debug ;
            'd16: ADC_DATA_CH0 <= adc_data_debug ;
            'd17: ADC_DATA_CH1 <= adc_data_debug ;
            'd18: ADC_DATA_CH2 <= adc_data_debug ;            
            'd19: ADC_DATA_CH3 <= adc_data_debug ;
            'd20: ADC_DATA_CH4 <= adc_data_debug ;
            'd21: ADC_DATA_CH5 <= adc_data_debug ;
            'd22: ADC_DATA_CH6 <= adc_data_debug ;
            'd23: ADC_DATA_CH7 <= adc_data_debug ;
            'd24: ADC_DATA_CH8 <= adc_data_debug ;
            'd25: ADC_DATA_CH9 <= adc_data_debug ;
            'd26: ADC_DATA_CH10<= adc_data_debug ;
            'd27: ADC_DATA_CH11<= adc_data_debug ;
            'd28: ADC_DATA_CH12<= adc_data_debug ;
            'd29: ADC_DATA_CH13<= adc_data_debug ;
            'd30: ADC_DATA_CH14<= adc_data_debug ;
            'd31: ADC_DATA_CH15<= adc_data_debug ;
                default: 
                ;
        endcase
    else 
        ;
end

endmodule
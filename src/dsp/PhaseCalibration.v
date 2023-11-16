module PhaseCalibration
( 
    input           sys_clk ,
    input           rst     ,

    input           adc_data_cha_sop     ,
    input           adc_data_cha_eop     ,
    input [15:0]    adc_data_cha         ,
    input           adc_data_cha_valid   ,

    input           adc_data_chb_sop     ,
    input           adc_data_chb_eop     ,
    input [15:0]    adc_data_chb         ,
    input           adc_data_chb_valid   ,

    input [31:0]    Calibration_IQCHA    ,
    input [31:0]    Calibration_IQCHB    ,  

    output  reg          adc_data_sub_sop     ,
    output  reg          adc_data_sub_eop     ,
    output  reg  [31:0]  adc_data_sub         ,
    output  reg          adc_data_sub_valid   ,

    output  reg          adc_data_sum_sop     ,
    output  reg          adc_data_sum_eop     ,
    output  reg  [31:0]  adc_data_sum         ,
    output  reg          adc_data_sum_valid
);

reg [15:0]    adc_data_cha_sop_shift   ='d0 ;
reg [15:0]    adc_data_cha_eop_shift   ='d0 ;
reg [15:0]    adc_data_cha_d1          ='d0 ;
reg [15:0]    adc_data_cha_d2          ='d0 ;
reg [15:0]    adc_data_cha_valid_shift ='d0 ;

reg [15:0]    adc_data_chb_sop_shift   ='d0 ;
reg [15:0]    adc_data_chb_eop_shift   ='d0 ;
reg [15:0]    adc_data_chb_d1          ='d0 ;
reg [15:0]    adc_data_chb_d2          ='d0 ;
reg [15:0]    adc_data_chb_valid_shift ='d0 ;

reg [31:0]    Calibration_IQCHA_d1 ='d0 ;
reg [31:0]    Calibration_IQCHA_d2 ='d0 ;
reg [31:0]    Calibration_IQCHB_d1 ='d0 ;
reg [31:0]    Calibration_IQCHB_d2 ='d0 ; 

always @(posedge sys_clk) begin
    adc_data_cha_sop_shift <= {adc_data_cha_sop_shift[14:0],adc_data_cha_sop};
    adc_data_cha_eop_shift <= {adc_data_cha_eop_shift[14:0],adc_data_cha_eop};
    adc_data_cha_valid_shift <= {adc_data_cha_valid_shift[14:0],adc_data_cha_valid};
    adc_data_cha_d1 <= adc_data_cha ;
    adc_data_cha_d2 <= adc_data_cha_d1 ;
end

always @(posedge sys_clk) begin
    adc_data_chb_sop_shift <= {adc_data_chb_sop_shift[14:0],adc_data_chb_sop};
    adc_data_chb_eop_shift <= {adc_data_chb_eop_shift[14:0],adc_data_chb_eop};
    adc_data_chb_valid_shift <= {adc_data_chb_valid_shift[14:0],adc_data_chb_valid};
    adc_data_chb_d1 <= adc_data_chb ;
    adc_data_chb_d2 <= adc_data_chb_d1 ;
end

always @(posedge sys_clk) begin
    Calibration_IQCHA_d1 <= Calibration_IQCHA ;
    Calibration_IQCHA_d2 <= Calibration_IQCHA_d1 ;
end

always @(posedge sys_clk) begin
    Calibration_IQCHB_d1 <= Calibration_IQCHB ;
    Calibration_IQCHB_d2 <= Calibration_IQCHB_d1 ;
end

wire [79:0] m_axis_dout_tdata_cha;
wire [79:0] m_axis_dout_tdata_chb;

complex_mult_s16_s16_d6 complex_mult_s16_s16_d6_cha
(
    .aclk                   (sys_clk                ),
    .s_axis_a_tvalid        (1'b1                   ),
    .s_axis_a_tdata         ({16'd0,adc_data_cha_d2}),
    .s_axis_b_tvalid        (1'b1                   ),
    .s_axis_b_tdata         (Calibration_IQCHA_d2   ),
    .m_axis_dout_tvalid     (),
    .m_axis_dout_tdata      (m_axis_dout_tdata_cha  )
);

complex_mult_s16_s16_d6 complex_mult_s16_s16_d6_chb
(
    .aclk                   (sys_clk                ),
    .s_axis_a_tvalid        (1'b1                   ),
    .s_axis_a_tdata         ({16'd0,adc_data_chb_d2}),
    .s_axis_b_tvalid        (1'b1                   ),
    .s_axis_b_tdata         (Calibration_IQCHB_d2   ),
    .m_axis_dout_tvalid     (),
    .m_axis_dout_tdata      (m_axis_dout_tdata_chb  )
);

reg [33:0]  Calibration_sum ;
reg [33:0]  Calibration_sub ; 

// 需要注意符号位
// always @(posedge sys_clk) begin
//     Calibration_sum[16: 0] <= {m_axis_dout_tdata_cha[32],m_axis_dout_tdata_cha[32:16]} + {m_axis_dout_tdata_chb[32],m_axis_dout_tdata_chb[32:16]} ;
//     Calibration_sum[33:17] <= {m_axis_dout_tdata_cha[72],m_axis_dout_tdata_cha[32+40:16+40]} + {m_axis_dout_tdata_chb[72],m_axis_dout_tdata_chb[32+40:16+40]};
// end

// always @(posedge sys_clk) begin
//     Calibration_sub[16: 0] <= {m_axis_dout_tdata_cha[32],m_axis_dout_tdata_cha[32:16]} - {m_axis_dout_tdata_chb[32],m_axis_dout_tdata_chb[32:16]} ;
//     Calibration_sub[33:17] <= {m_axis_dout_tdata_cha[72],m_axis_dout_tdata_cha[32+40:16+40]} - {m_axis_dout_tdata_chb[72],m_axis_dout_tdata_chb[32+40:16+40]};
// end

always @(posedge sys_clk) begin
    Calibration_sum[16: 0] <= {m_axis_dout_tdata_cha[32],m_axis_dout_tdata_cha[27:12]} + {m_axis_dout_tdata_chb[32],m_axis_dout_tdata_chb[27:12]} ;
    Calibration_sum[33:17] <= {m_axis_dout_tdata_cha[72],m_axis_dout_tdata_cha[27+40:12+40]} + {m_axis_dout_tdata_chb[72],m_axis_dout_tdata_chb[27+40:12+40]};
end

always @(posedge sys_clk) begin
    Calibration_sub[16: 0] <= {m_axis_dout_tdata_cha[32],m_axis_dout_tdata_cha[27:12]} - {m_axis_dout_tdata_chb[32],m_axis_dout_tdata_chb[27:12]} ;
    Calibration_sub[33:17] <= {m_axis_dout_tdata_cha[72],m_axis_dout_tdata_cha[27+40:12+40]} - {m_axis_dout_tdata_chb[72],m_axis_dout_tdata_chb[27+40:12+40]};
end

// output  
// cha 
always @(posedge sys_clk) begin
    if(rst)
        adc_data_sub_sop <= 'd0 ;
    else 
        adc_data_sub_sop <= adc_data_cha_sop_shift[8];
end

always @(posedge sys_clk) begin
    if(rst)
        adc_data_sub_eop <= 'd0 ;
    else 
        adc_data_sub_eop <= adc_data_cha_eop_shift[8];
end

always @(posedge sys_clk) begin
    if(rst)
        adc_data_sub_valid <= 'd0 ;
    else 
        adc_data_sub_valid <= adc_data_cha_valid_shift[8];
end

always @(posedge sys_clk) begin
    if(rst)
        adc_data_sub <= 'd0 ;
    else 
        adc_data_sub <= {Calibration_sub[33:18],Calibration_sub[16:1]} ;
end

// chb
always @(posedge sys_clk) begin
    if(rst)
        adc_data_sum_sop <= 'd0 ;
    else 
        adc_data_sum_sop <= adc_data_chb_sop_shift[8];
end

always @(posedge sys_clk) begin
    if(rst)
        adc_data_sum_eop <= 'd0 ;
    else 
        adc_data_sum_eop <= adc_data_chb_eop_shift[8];
end

always @(posedge sys_clk) begin
    if(rst)
        adc_data_sum_valid <= 'd0 ;
    else 
        adc_data_sum_valid <= adc_data_chb_valid_shift[8];
end

always @(posedge sys_clk) begin
    if(rst)
        adc_data_sum <= 'd0 ;
    else 
        adc_data_sum <= {Calibration_sum[33:18],Calibration_sum[16:1]} ;
end

endmodule 
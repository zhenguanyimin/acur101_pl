module serila_lvds_adc3663
(
      input   wire        rst                ,
      input   wire        clk_dclk_o         ,
      input   wire        sys_clk            ,           // 200m
      input   wire        clk_300m           ,

      input   wire [8:0]  tap_out_int0       ,
      input   wire [8:0]  tap_out_int1       ,
      input   wire [8:0]  tap_out_int2       ,

      input   wire        idelay_d0_load     ,
      input   wire        idelay_d1_load     ,
      input   wire        idelay_d2_load     ,

      input   wire        adc3663_fclk_p     ,
      input   wire        adc3663_fclk_n     ,

      input   wire        adc3663_dclk_p     ,
      input   wire        adc3663_dclk_n     ,

      input   wire        adc3663_da0_p      ,
      input   wire        adc3663_da0_n      ,
      input   wire        adc3663_da1_p      ,
      input   wire        adc3663_da1_n      ,

      input   wire        adc3663_db0_p      ,
      input   wire        adc3663_db0_n      ,
      input   wire        adc3663_db1_p      ,
      input   wire        adc3663_db1_n      ,

      output  wire        adc3663_dclk_o_p   ,
      output  wire        adc3663_dclk_o_n   ,

//------------------------sys_clk------------------------------------------------------------
      output  wire [15:0] adc_data_cha       ,
      output  wire [15:0] adc_data_chb       ,
      output  wire        adc_data_valid

);

//-------------------------------------adc3663_fclk------------------------------------------
// wire    adc3663_dclk                 ;      
// wire [8:0]  tap_out_int0        ;
// wire [8:0]  tap_out_int1       ;
// wire [8:0]  tap_out_int2       ;
// wire        idelay_d0_load     ;
// wire        idelay_d1_load     ;
// wire        idelay_d2_load     ;

//vio_0  vio_0(
//.clk           (clk_300m         ),
//.probe_out0    (tap_out_int0     ),
//.probe_out1    (tap_out_int1     ),
//.probe_out2    (tap_out_int2     ),
//.probe_out3    (idelay_d0_load   ),
//.probe_out4    (idelay_d1_load   ),
//.probe_out5    (idelay_d2_load   )
//);

wire    adc_fclk                     ;
wire    adc_fclk_ibuf_o              ;

IBUFDS #(
          .DIFF_TERM   ("TRUE"   ), // Differential Termination
          .IBUF_LOW_PWR("TRUE"   ), // Low power="TRUE", Highest performance="FALSE" 
          .IOSTANDARD  ("LVDS_18")  // Specify the input I/O standard
        ) 
IBUFDS_FCLK 
(
   .O (adc_fclk_ibuf_o ), // Buffer output
   .I (adc3663_fclk_p  ), // Diff_p buffer input (connect directly to top-level port)
   .IB(adc3663_fclk_n  )  // Diff_n buffer input (connect directly to top-level port)
);

wire        adc_fclk_idelay_o;



wire [8:0]  CNTVALUEOUT     ;
IDELAYE3 #(
   .CASCADE            ("NONE"            ),  // Cascade setting (MASTER, NONE, SLAVE_END, SLAVE_MIDDLE)
   .DELAY_FORMAT       ("COUNT"           ),  // Units of the DELAY_VALUE (COUNT, TIME)
   .DELAY_SRC          ("IDATAIN"         ),  // Delay input (DATAIN, IDATAIN)
   .DELAY_TYPE         ("VAR_LOAD"        ),  // Set the type of tap delay line (FIXED, VARIABLE, VAR_LOAD)
   .DELAY_VALUE        ('d0               ),  // Input delay value setting
   .IS_CLK_INVERTED    (1'b0              ),  // Optional inversion for CLK
   .IS_RST_INVERTED    (1'b0              ),  // Optional inversion for RST
   .REFCLK_FREQUENCY   (300.0             ),  // IDELAYCTRL clock input frequency in MHz (200.0-800.0)
   .SIM_DEVICE         ("ULTRASCALE_PLUS" ),  // Set the device version for simulation functionality (ULTRASCALE,
                                              // ULTRASCALE_PLUS, ULTRASCALE_PLUS_ES1, ULTRASCALE_PLUS_ES2)
   .UPDATE_MODE("ASYNC")                      // Determines when updates to the delay will take effect (ASYNC, MANUAL,SYNC)
)
IDELAYE3_fclk (
   .CASC_OUT           (                   ), // 1-bit output: Cascade delay output to ODELAY input cascade
   .CNTVALUEOUT        (CNTVALUEOUT        ), // 9-bit output: Counter value output
   .DATAOUT            (adc_fclk_idelay_o  ), // 1-bit output: Delayed data output
   .CASC_IN            (1'b0               ), // 1-bit input: Cascade delay input from slave ODELAY CASCADE_OUT
   .CASC_RETURN        (1'b0               ), // 1-bit input: Cascade delay returning from slave ODELAY DATAOUT
   .CE                 ('d0                ), // 1-bit input: Active-High enable increment/decrement input
   .CLK                (clk_300m           ), // 1-bit input: Clock input
   .CNTVALUEIN         (tap_out_int0       ), // 9-bit input: Counter value input
   .DATAIN             (1'b0               ), // 1-bit input: Data input from the logic
   .EN_VTC             (1'b0               ), // 1-bit input: Keep delay constant over VT
   .IDATAIN            (adc_fclk_ibuf_o    ), // 1-bit input: Data input from the IOBUF
   .INC                ('d0                ), // 1-bit input: Increment / Decrement tap delay input
   .LOAD               (idelay_d0_load     ), // 1-bit input: Load DELAY_VALUE input
   .RST                (1'b0               )  // 1-bit input: Asynchronous Reset to the DELAY_VALUE
   
);

assign   adc_fclk  =  adc_fclk_idelay_o ;

wire     adc_dclk_ibuf_o ;

IBUFDS #(
          .DIFF_TERM   ("TRUE"   ), // Differential Termination
          .IBUF_LOW_PWR("TRUE"   ), // Low power="TRUE", Highest performance="FALSE" 
          .IOSTANDARD  ("LVDS_18")  // Specify the input I/O standard
        ) 
IBUFDS_CLK 
(
   .O (adc_dclk_ibuf_o  ), // Buffer output
   .I (adc3663_dclk_p   ), // Diff_p buffer input (connect directly to top-level port)
   .IB(adc3663_dclk_n   )  // Diff_n buffer input (connect directly to top-level port)
);

 wire    adc_dclk ;

BUFG BUFG_dclk
(
   .O (adc_dclk         ),
   .I (adc_dclk_ibuf_o  )
);


//--------------------------------------------lane0---------------------------------------------------

wire        adc3663_da0_dly_i   ;

IBUFDS #(
          .DIFF_TERM   ("TRUE"   ), // Differential Termination
          .IBUF_LOW_PWR("TRUE"   ), // Low power="TRUE", Highest performance="FALSE" 
          .IOSTANDARD  ("LVDS_18")  // Specify the input I/O standard
        ) 
IBUFDS_DA0 
(
   .O (adc3663_da0_dly_i ), // Buffer output
   .I (adc3663_da0_p     ), // Diff_p buffer input (connect directly to top-level port)
   .IB(adc3663_da0_n     )  // Diff_n buffer input (connect directly to top-level port)
);

wire [8:0] CNTVALUEOUT_dat0;
wire       adc3663_da0_dly_o   ;

IDELAYE3 #(
   .CASCADE            ("NONE"            ),  // Cascade setting (MASTER, NONE, SLAVE_END, SLAVE_MIDDLE)
   .DELAY_FORMAT       ("COUNT"           ),  // Units of the DELAY_VALUE (COUNT, TIME)
   .DELAY_SRC          ("IDATAIN"         ),  // Delay input (DATAIN, IDATAIN)
   .DELAY_TYPE         ("VAR_LOAD"        ),  // Set the type of tap delay line (FIXED, VARIABLE, VAR_LOAD)
   .DELAY_VALUE        ('d0               ),  // Input delay value setting
   .IS_CLK_INVERTED    (1'b0              ),  // Optional inversion for CLK
   .IS_RST_INVERTED    (1'b0              ),  // Optional inversion for RST
   .REFCLK_FREQUENCY   (300.0             ),  // IDELAYCTRL clock input frequency in MHz (200.0-800.0)
   .SIM_DEVICE         ("ULTRASCALE_PLUS" ),  // Set the device version for simulation functionality (ULTRASCALE,
                                              // ULTRASCALE_PLUS, ULTRASCALE_PLUS_ES1, ULTRASCALE_PLUS_ES2)
   .UPDATE_MODE("ASYNC")                      // Determines when updates to the delay will take effect (ASYNC, MANUAL,SYNC)
)
IDELAYE3_da0 (
   .CASC_OUT           (                   ), // 1-bit output: Cascade delay output to ODELAY input cascade
   .CNTVALUEOUT        (CNTVALUEOUT_dat0   ), // 9-bit output: Counter value output
   .DATAOUT            (adc3663_da0_dly_o  ), // 1-bit output: Delayed data output
   .CASC_IN            (1'b0               ), // 1-bit input: Cascade delay input from slave ODELAY CASCADE_OUT
   .CASC_RETURN        (1'b0               ), // 1-bit input: Cascade delay returning from slave ODELAY DATAOUT
   .CE                 ('d0                ), // 1-bit input: Active-High enable increment/decrement input
   .CLK                (clk_300m           ), // 1-bit input: Clock input
   .CNTVALUEIN         (tap_out_int1       ), // 9-bit input: Counter value input
   .DATAIN             (1'b0               ), // 1-bit input: Data input from the logic
   .EN_VTC             (1'b0               ), // 1-bit input: Keep delay constant over VT
   .IDATAIN            (adc3663_da0_dly_i  ), // 1-bit input: Data input from the IOBUF
   .INC                ('d0                ), // 1-bit input: Increment / Decrement tap delay input
   .LOAD               (idelay_d1_load     ), // 1-bit input: Load DELAY_VALUE input
   .RST                (1'b0               )  // 1-bit input: Asynchronous Reset to the DELAY_VALUE

);


wire    DA0_e1 ;
wire    DA0_o1 ;

IDDRE1 #(
   .DDR_CLK_EDGE   ("SAME_EDGE_PIPELINED"), // IDDRE1 mode (OPPOSITE_EDGE, SAME_EDGE, SAME_EDGE_PIPELINED)
   .IS_CB_INVERTED (1'b1                 ), // Optional inversion for CB
   .IS_C_INVERTED  (1'b0                 )  // Optional inversion for C)
)
IDDR_DA0 
(
   .Q1             (DA0_e1                ), // 1-bit output: Registered parallel output 1
   .Q2             (DA0_o1                ), // 1-bit output: Registered parallel output 2
   .C              (adc_dclk             ), // 1-bit input: High-speed clock
   .CB             (adc_dclk             ), // 1-bit input: Inversion of High-speed clock C
   .D              (adc3663_da0_dly_o    ), // 1-bit input: Serial Data Input
   .R              (1'b0                 )  // 1-bit input: Active-High Async Reset
);

//--------------------------------------------lane1--------------------------------------------------- 
wire        adc3663_da1_dly_i   ;
IBUFDS #(
          .DIFF_TERM   ("TRUE"   ), // Differential Termination
          .IBUF_LOW_PWR("TRUE"   ), // Low power="TRUE", Highest performance="FALSE" 
          .IOSTANDARD  ("LVDS_18")  // Specify the input I/O standard
        ) 
IBUFDS_DA1 
(
   .O (adc3663_da1_dly_i ), // Buffer output
   .I (adc3663_da1_p     ), // Diff_p buffer input (connect directly to top-level port)
   .IB(adc3663_da1_n     )  // Diff_n buffer input (connect directly to top-level port)
);

wire [8:0] CNTVALUEOUT_dat1;
wire adc3663_da1_dly_o   ;

IDELAYE3 #(
   .CASCADE            ("NONE"            ),  // Cascade setting (MASTER, NONE, SLAVE_END, SLAVE_MIDDLE)
   .DELAY_FORMAT       ("COUNT"           ),  // Units of the DELAY_VALUE (COUNT, TIME)
   .DELAY_SRC          ("IDATAIN"         ),  // Delay input (DATAIN, IDATAIN)
   .DELAY_TYPE         ("VAR_LOAD"        ),  // Set the type of tap delay line (FIXED, VARIABLE, VAR_LOAD)
   .DELAY_VALUE        ('d0               ),  // Input delay value setting
   .IS_CLK_INVERTED    (1'b0              ),  // Optional inversion for CLK
   .IS_RST_INVERTED    (1'b0              ),  // Optional inversion for RST
   .REFCLK_FREQUENCY   (300.0             ),  // IDELAYCTRL clock input frequency in MHz (200.0-800.0)
   .SIM_DEVICE         ("ULTRASCALE_PLUS" ),  // Set the device version for simulation functionality (ULTRASCALE,
                                              // ULTRASCALE_PLUS, ULTRASCALE_PLUS_ES1, ULTRASCALE_PLUS_ES2)
   .UPDATE_MODE("ASYNC")                      // Determines when updates to the delay will take effect (ASYNC, MANUAL,SYNC)
)
IDELAYE3_da1 (
   .CASC_OUT           (                   ), // 1-bit output: Cascade delay output to ODELAY input cascade
   .CNTVALUEOUT        (CNTVALUEOUT_dat1   ), // 9-bit output: Counter value output
   .DATAOUT            (adc3663_da1_dly_o  ), // 1-bit output: Delayed data output
   .CASC_IN            (1'b0               ), // 1-bit input: Cascade delay input from slave ODELAY CASCADE_OUT
   .CASC_RETURN        (1'b0               ), // 1-bit input: Cascade delay returning from slave ODELAY DATAOUT
   .CE                 ('d0                ), // 1-bit input: Active-High enable increment/decrement input
   .CLK                (clk_300m           ), // 1-bit input: Clock input
   .CNTVALUEIN         (tap_out_int2       ), // 9-bit input: Counter value input
   .DATAIN             (1'b0               ), // 1-bit input: Data input from the logic
   .EN_VTC             (1'b0               ), // 1-bit input: Keep delay constant over VT
   .IDATAIN            (adc3663_da1_dly_i  ), // 1-bit input: Data input from the IOBUF
   .INC                ('d0                ), // 1-bit input: Increment / Decrement tap delay input
   .LOAD               (idelay_d2_load     ), // 1-bit input: Load DELAY_VALUE input
   .RST                (1'b0               )  // 1-bit input: Asynchronous Reset to the DELAY_VALUE

);



wire    DA1_e1 ;
wire    DA1_o1 ;

IDDRE1 #(
   .DDR_CLK_EDGE   ("SAME_EDGE_PIPELINED"), // IDDRE1 mode (OPPOSITE_EDGE, SAME_EDGE, SAME_EDGE_PIPELINED)
   .IS_CB_INVERTED (1'b1                 ), // Optional inversion for CB
   .IS_C_INVERTED  (1'b0                 )  // Optional inversion for C
)
IDDR_DA1 
(                         
   .Q1             (DA1_e1                ), // 1-bit output: Registered parallel output 1
   .Q2             (DA1_o1                ), // 1-bit output: Registered parallel output 2
   .C              (adc_dclk             ), // 1-bit input: High-speed clock
   .CB             (adc_dclk             ), // 1-bit input: Inversion of High-speed clock C
   .D              (adc3663_da1_dly_o    ), // 1-bit input: Serial Data Input
   .R              (1'b0                 )  // 1-bit input: Active-High Async Reset
);

//-------------------------------------------------------------------------------------------
reg [15:0]  adc3663_data_cha ;
reg [15:0]  adc3663_data_chb ;

reg [15:0]  shift_reg_da0_e ;
reg [15:0]  shift_reg_da0_o ;
reg [15:0]  shift_reg_da1_e ;
reg [15:0]  shift_reg_da1_o ;

always @(posedge adc_dclk) begin
   begin
      shift_reg_da0_e <= {shift_reg_da0_e[14:0],DA0_e1} ;
      shift_reg_da0_o <= {shift_reg_da0_o[14:0],DA0_o1} ;
      shift_reg_da1_e <= {shift_reg_da1_e[14:0],DA1_e1} ;
      shift_reg_da1_o <= {shift_reg_da1_o[14:0],DA1_o1} ;      
   end
end

reg  [15:0]     lvds_data_cha ;


//------------------------------------------------------back--------------------------------------------------------
// always @(posedge adc_dclk) begin
//    if(rst)
//       lvds_data_cha <= 'd0 ;
//    else
//       lvds_data_cha <= { shift_reg_da1_o[11],shift_reg_da0_o[11],shift_reg_da1_e[10],shift_reg_da0_e[10],
//                          shift_reg_da1_o[10],shift_reg_da0_o[10],shift_reg_da1_e[ 9],shift_reg_da0_e[ 9],
//                          shift_reg_da1_o[ 9],shift_reg_da0_o[ 9],shift_reg_da1_e[ 8],shift_reg_da0_e[ 8],
//                          shift_reg_da1_o[ 8],shift_reg_da0_o[ 8],shift_reg_da1_e[ 7],shift_reg_da0_e[ 7]};
// end


//----------------------------------------------------forward-------------------------------------------------------

// always @(posedge adc_dclk) begin
//    if(rst)
//       lvds_data_cha <= 'd0 ;
//    else
//       lvds_data_cha <= { shift_reg_da1_e[10],shift_reg_da0_e[10],shift_reg_da1_o[10],shift_reg_da0_o[10],
//                          shift_reg_da1_e[ 9],shift_reg_da0_e[ 9],shift_reg_da1_o[ 9],shift_reg_da0_o[ 9],
//                          shift_reg_da1_e[ 8],shift_reg_da0_e[ 8],shift_reg_da1_o[ 8],shift_reg_da0_o[ 8],
//                          shift_reg_da1_e[ 7],shift_reg_da0_e[ 7],shift_reg_da1_o[ 7],shift_reg_da0_o[ 7]};
// end

// ----------------------------------------------------forward-------------------------------------------------------

always @(posedge adc_dclk) begin
   if(rst)
      lvds_data_cha <= 'd0 ;
   else
      lvds_data_cha <= { shift_reg_da1_e[11],shift_reg_da0_e[11],shift_reg_da1_o[11],shift_reg_da0_o[11],
                         shift_reg_da1_e[10],shift_reg_da0_e[10],shift_reg_da1_o[10],shift_reg_da0_o[10],
                         shift_reg_da1_e[ 9],shift_reg_da0_e[ 9],shift_reg_da1_o[ 9],shift_reg_da0_o[ 9],
                         shift_reg_da1_e[ 8],shift_reg_da0_e[ 8],shift_reg_da1_o[ 8],shift_reg_da0_o[ 8]};
end


reg adc_fclk_d1 ;
reg adc_fclk_d2 ;
reg adc_fclk_d3 ;

always @(posedge adc_dclk) begin
   adc_fclk_d1 <= adc_fclk    ;
   adc_fclk_d2 <= adc_fclk_d1 ;
   adc_fclk_d3 <= adc_fclk_d2 ;
end


reg  [15:0]     adc_data_pos_cha ;
reg  [15:0]     adc_data_neg_cha ;

always @(posedge adc_dclk) begin
   if(rst)begin 
      adc_data_neg_cha <= 'd0 ;
   end
   else if(~adc_fclk_d2 && adc_fclk_d3) begin
      adc_data_neg_cha <= lvds_data_cha ;
   end
end

always @(posedge adc_dclk) begin
   if(rst)  begin  
      adc_data_pos_cha <= 'd0 ;
   end
   else if(adc_fclk_d2 && ~adc_fclk_d3) begin 
      adc_data_pos_cha <= lvds_data_cha ;
   end
end

reg adc3663_data_valid ;
always @(posedge adc_dclk) begin
   if(rst)
      adc3663_data_valid <= 'd0 ;
   else if((~adc_fclk_d2 && adc_fclk_d3) || (adc_fclk_d2 && ~adc_fclk_d3))
      adc3663_data_valid <= 'd1 ;
   else
      adc3663_data_valid <= 'd0 ;
end


OBUFDS OBUFDS
(
   .O    (adc3663_dclk_o_p ),
   .OB   (adc3663_dclk_o_n ),
   .I    (clk_dclk_o       )
);

// `ifndef SIM
always @(posedge adc_dclk) begin
   if(rst)
      adc3663_data_cha <= 'd0 ;
   else if(~adc_fclk_d2 && adc_fclk_d3)
      adc3663_data_cha <= adc_data_neg_cha ;
   else if(adc_fclk_d2 && ~adc_fclk_d3) 
      adc3663_data_cha <= adc_data_pos_cha ;
   else 
      adc3663_data_cha <= adc3663_data_cha ;
end
// `else 
// `endif

//--------------------------------------------chb-lane0---------------------------------------------------

wire        adc3663_db0_dly_i   ;

IBUFDS #(
          .DIFF_TERM   ("TRUE"   ), // Differential Termination
          .IBUF_LOW_PWR("TRUE"   ), // Low power="TRUE", Highest performance="FALSE" 
          .IOSTANDARD  ("LVDS_18")  // Specify the input I/O standard
        ) 
IBUFDS_DB0 
(
   .O (adc3663_db0_dly_i ), // Buffer output
   .I (adc3663_db0_p     ), // Diff_p buffer input (connect directly to top-level port)
   .IB(adc3663_db0_n     )  // Diff_n buffer input (connect directly to top-level port)
);

// wire [8:0] CNTVALUEOUT_dat0;
wire adc3663_db0_dly_o   ;

IDELAYE3 #(
   .CASCADE            ("NONE"            ),  // Cascade setting (MASTER, NONE, SLAVE_END, SLAVE_MIDDLE)
   .DELAY_FORMAT       ("COUNT"           ),  // Units of the DELAY_VALUE (COUNT, TIME)
   .DELAY_SRC          ("IDATAIN"         ),  // Delay input (DATAIN, IDATAIN)
   .DELAY_TYPE         ("VAR_LOAD"        ),  // Set the type of tap delay line (FIXED, VARIABLE, VAR_LOAD)
   .DELAY_VALUE        ('d0               ),  // Input delay value setting
   .IS_CLK_INVERTED    (1'b0              ),  // Optional inversion for CLK
   .IS_RST_INVERTED    (1'b0              ),  // Optional inversion for RST
   .REFCLK_FREQUENCY   (300.0             ),  // IDELAYCTRL clock input frequency in MHz (200.0-800.0)
   .SIM_DEVICE         ("ULTRASCALE_PLUS" ),  // Set the device version for simulation functionality (ULTRASCALE,
                                              // ULTRASCALE_PLUS, ULTRASCALE_PLUS_ES1, ULTRASCALE_PLUS_ES2)
   .UPDATE_MODE("ASYNC")                      // Determines when updates to the delay will take effect (ASYNC, MANUAL,SYNC)
)
IDELAYE3_db0 (
   .CASC_OUT           (                   ), // 1-bit output: Cascade delay output to ODELAY input cascade
   .CNTVALUEOUT        (                   ), // 9-bit output: Counter value output
   .DATAOUT            (adc3663_db0_dly_o  ), // 1-bit output: Delayed data output
   .CASC_IN            (1'b0               ), // 1-bit input: Cascade delay input from slave ODELAY CASCADE_OUT
   .CASC_RETURN        (1'b0               ), // 1-bit input: Cascade delay returning from slave ODELAY DATAOUT
   .CE                 ('d0                ), // 1-bit input: Active-High enable increment/decrement input
   .CLK                (clk_300m           ), // 1-bit input: Clock input
   .CNTVALUEIN         (tap_out_int1       ), // 9-bit input: Counter value input
   .DATAIN             (1'b0               ), // 1-bit input: Data input from the logic
   .EN_VTC             (1'b0               ), // 1-bit input: Keep delay constant over VT
   .IDATAIN            (adc3663_db0_dly_i  ), // 1-bit input: Data input from the IOBUF
   .INC                ('d0                ), // 1-bit input: Increment / Decrement tap delay input
   .LOAD               (idelay_d1_load     ), // 1-bit input: Load DELAY_VALUE input
   .RST                (1'b0               )  // 1-bit input: Asynchronous Reset to the DELAY_VALUE

);


wire    DB0_e1 ;
wire    DB0_o1 ;

IDDRE1 #(
   .DDR_CLK_EDGE   ("SAME_EDGE_PIPELINED"), // IDDRE1 mode (OPPOSITE_EDGE, SAME_EDGE, SAME_EDGE_PIPELINED)
   .IS_CB_INVERTED (1'b1                 ), // Optional inversion for CB
   .IS_C_INVERTED  (1'b0                 )  // Optional inversion for C)
)
IDDR_DB0 
(
   .Q1             (DB0_e1                ), // 1-bit output: Registered parallel output 1
   .Q2             (DB0_o1                ), // 1-bit output: Registered parallel output 2
   .C              (adc_dclk             ), // 1-bit input: High-speed clock
   .CB             (adc_dclk             ), // 1-bit input: Inversion of High-speed clock C
   .D              (adc3663_db0_dly_o    ), // 1-bit input: Serial Data Input
   .R              (1'b0                 )  // 1-bit input: Active-High Async Reset
);

//--------------------------------------------lane1--------------------------------------------------- 
wire        adc3663_db1_dly_i   ;
IBUFDS #(
          .DIFF_TERM   ("TRUE"   ), // Differential Termination
          .IBUF_LOW_PWR("TRUE"   ), // Low power="TRUE", Highest performance="FALSE" 
          .IOSTANDARD  ("LVDS_18")  // Specify the input I/O standard
        ) 
IBUFDS_DB1 
(
   .O (adc3663_db1_dly_i ), // Buffer output
   .I (adc3663_db1_p     ), // Diff_p buffer input (connect directly to top-level port)
   .IB(adc3663_db1_n     )  // Diff_n buffer input (connect directly to top-level port)
);


wire adc3663_db1_dly_o   ;

IDELAYE3 #(
   .CASCADE            ("NONE"            ),  // Cascade setting (MASTER, NONE, SLAVE_END, SLAVE_MIDDLE)
   .DELAY_FORMAT       ("COUNT"           ),  // Units of the DELAY_VALUE (COUNT, TIME)
   .DELAY_SRC          ("IDATAIN"         ),  // Delay input (DATAIN, IDATAIN)
   .DELAY_TYPE         ("VAR_LOAD"        ),  // Set the type of tap delay line (FIXED, VARIABLE, VAR_LOAD)
   .DELAY_VALUE        ('d0               ),  // Input delay value setting
   .IS_CLK_INVERTED    (1'b0              ),  // Optional inversion for CLK
   .IS_RST_INVERTED    (1'b0              ),  // Optional inversion for RST
   .REFCLK_FREQUENCY   (300.0             ),  // IDELAYCTRL clock input frequency in MHz (200.0-800.0)
   .SIM_DEVICE         ("ULTRASCALE_PLUS" ),  // Set the device version for simulation functionality (ULTRASCALE,
                                              // ULTRASCALE_PLUS, ULTRASCALE_PLUS_ES1, ULTRASCALE_PLUS_ES2)
   .UPDATE_MODE("ASYNC")                      // Determines when updates to the delay will take effect (ASYNC, MANUAL,SYNC)
)
IDELAYE3_db1 (
   .CASC_OUT           (                   ), // 1-bit output: Cascade delay output to ODELAY input cascade
   .CNTVALUEOUT        (                   ), // 9-bit output: Counter value output
   .DATAOUT            (adc3663_db1_dly_o  ), // 1-bit output: Delayed data output
   .CASC_IN            (1'b0               ), // 1-bit input: Cascade delay input from slave ODELAY CASCADE_OUT
   .CASC_RETURN        (1'b0               ), // 1-bit input: Cascade delay returning from slave ODELAY DATAOUT
   .CE                 ('d0                ), // 1-bit input: Active-High enable increment/decrement input
   .CLK                (clk_300m           ), // 1-bit input: Clock input
   .CNTVALUEIN         (tap_out_int2       ), // 9-bit input: Counter value input
   .DATAIN             (1'b0               ), // 1-bit input: Data input from the logic
   .EN_VTC             (1'b0               ), // 1-bit input: Keep delay constant over VT
   .IDATAIN            (adc3663_db1_dly_i  ), // 1-bit input: Data input from the IOBUF
   .INC                ('d0                ), // 1-bit input: Increment / Decrement tap delay input
   .LOAD               (idelay_d2_load     ), // 1-bit input: Load DELAY_VALUE input
   .RST                (1'b0               )  // 1-bit input: Asynchronous Reset to the DELAY_VALUE

);



wire    DB1_e1 ;
wire    DB1_o1 ;

IDDRE1 #(
   .DDR_CLK_EDGE   ("SAME_EDGE_PIPELINED"), // IDDRE1 mode (OPPOSITE_EDGE, SAME_EDGE, SAME_EDGE_PIPELINED)
   .IS_CB_INVERTED (1'b1                 ), // Optional inversion for CB
   .IS_C_INVERTED  (1'b0                 )  // Optional inversion for C
)
IDDR_DB1 
(                         
   .Q1             (DB1_e1                ), // 1-bit output: Registered parallel output 1
   .Q2             (DB1_o1                ), // 1-bit output: Registered parallel output 2
   .C              (adc_dclk             ), // 1-bit input: High-speed clock
   .CB             (adc_dclk             ), // 1-bit input: Inversion of High-speed clock C
   .D              (adc3663_db1_dly_o    ), // 1-bit input: Serial Data Input
   .R              (1'b0                 )  // 1-bit input: Active-High Async Reset
);

//-------------------------------------------------------------------------------------------

reg [15:0] shift_reg_db0_e ;
reg [15:0] shift_reg_db0_o ;
reg [15:0] shift_reg_db1_e ;
reg [15:0] shift_reg_db1_o ;

always @(posedge adc_dclk) begin
   begin
      shift_reg_db0_e <= {shift_reg_db0_e[14:0],DB0_e1} ;
      shift_reg_db0_o <= {shift_reg_db0_o[14:0],DB0_o1} ;
      shift_reg_db1_e <= {shift_reg_db1_e[14:0],DB1_e1} ;
      shift_reg_db1_o <= {shift_reg_db1_o[14:0],DB1_o1} ;      
   end
end

reg  [15:0]     lvds_data_chb ;

// always @(posedge adc_dclk) begin
//    if(rst)
//       lvds_data_chb <= 'd0 ;
//    else
//       lvds_data_chb <= { shift_reg_db1_e[10],shift_reg_db0_e[10],shift_reg_db1_o[10],shift_reg_db0_o[10],
//                          shift_reg_db1_e[ 9],shift_reg_db0_e[ 9],shift_reg_db1_o[ 9],shift_reg_db0_o[ 9],
//                          shift_reg_db1_e[ 8],shift_reg_db0_e[ 8],shift_reg_db1_o[ 8],shift_reg_db0_o[ 8],
//                          shift_reg_db1_e[ 7],shift_reg_db0_e[ 7],shift_reg_db1_o[ 7],shift_reg_db0_o[ 7]};
// end

//----------------------------------------------------------------------------------------------------------------------
always @(posedge adc_dclk) begin
   if(rst)
      lvds_data_chb <= 'd0 ;
   else
      lvds_data_chb <= { shift_reg_db1_e[11],shift_reg_db0_e[11],shift_reg_db1_o[11],shift_reg_db0_o[11],
                         shift_reg_db1_e[10],shift_reg_db0_e[10],shift_reg_db1_o[10],shift_reg_db0_o[10],
                         shift_reg_db1_e[ 9],shift_reg_db0_e[ 9],shift_reg_db1_o[ 9],shift_reg_db0_o[ 9],
                         shift_reg_db1_e[ 8],shift_reg_db0_e[ 8],shift_reg_db1_o[ 8],shift_reg_db0_o[ 8]};
end

reg  [15:0]     adc_data_pos_chb ;
reg  [15:0]     adc_data_neg_chb ;

always @(posedge adc_dclk) begin
   if(rst)begin 
      adc_data_neg_chb <= 'd0 ;
   end
   else if(~adc_fclk_d2 && adc_fclk_d3) begin
      adc_data_neg_chb <= lvds_data_chb ;
   end
end

always @(posedge adc_dclk) begin
   if(rst)  begin  
      adc_data_pos_chb <= 'd0 ;
   end
   else if(adc_fclk_d2 && ~adc_fclk_d3) begin 
      adc_data_pos_chb <= lvds_data_chb ;
   end
end


// `ifndef SIM
always @(posedge adc_dclk) begin
   if(rst)
      adc3663_data_chb <= 'd0 ;
   else if(~adc_fclk_d2 && adc_fclk_d3)
      adc3663_data_chb <= adc_data_neg_chb ;
   else if(adc_fclk_d2 && ~adc_fclk_d3) 
      adc3663_data_chb <= adc_data_pos_chb ;
   else 
      adc3663_data_chb <= adc3663_data_chb ;
end
// `else 
// `endif

wire [31:0]    fifo_dout ;
wire           fifo_empty ;

reg  [31:0]    fifo_dout_d1 ;
reg            fifo_empty_d1 ;
reg  [31:0]    fifo_dout_d2 ;
reg            fifo_empty_d2 ;

xfifo_async_w32d32_d0 xfifo_async_w32d32_d0
(
   .rst        (rst                 ),
   .wr_clk     (adc_dclk            ),
   .rd_clk     (sys_clk             ),
   .din        ({adc3663_data_cha,adc3663_data_chb}),
   .wr_en      (adc3663_data_valid  ),
   .rd_en      (1'b1                ),
   .dout       (fifo_dout           ),
   .full       (),
   .empty      (fifo_empty          )
);

always @(posedge sys_clk) begin
   if(rst)  begin  
      fifo_dout_d1 <= 'd0 ;
      fifo_dout_d2 <= 'd0 ;
   end
   else begin
      fifo_dout_d1 <= fifo_dout ;
      fifo_dout_d2 <= fifo_dout_d1 ;
   end
end

always @(posedge sys_clk) begin
   if(rst) begin
      fifo_empty_d1 <= 'd0 ;
      fifo_empty_d2 <= 'd0 ;
   end
   else begin
      fifo_empty_d1 <= fifo_empty ;
      fifo_empty_d2 <= fifo_empty_d1 ;
   end
end
assign adc_data_cha = fifo_dout_d2[31:16] ;
assign adc_data_chb = fifo_dout_d2[15: 0] ;
assign adc_data_valid = ~fifo_empty_d2 ;

endmodule

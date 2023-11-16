module cfar_detection (

    input           clk                 ,
    input           rst                 ,

    input   [15:0]  rdmap_dpl_data      ,
    input           rdmap_dpl_valid     ,
    input           rdmap_dpl_tlast     ,

    input   [15:0]  rdmap_range_data    ,
    input           rdmap_range_valid   ,

    output          cfar_data_valid     ,
	output  [31:0]  cfar_data           ,
	output          cfar_data_last      ,
	output  [15:0]  cfar_data_num       ,

    output          hist_busy
);

wire                histogram_calc_vld    ;
wire    [15:0]      histogram_calc_datath ;

calc_histogram_top  calc_histogram_top 
(
    .reset_n                    (~rst                   ),                  
    .clk_100mhz                 (clk                    ),
    .rdm_m_axis_data_tvalid     (rdmap_dpl_valid        ),
    .rdm_amp_data               ({16'd0,rdmap_dpl_data} ),
    .rdm_m_axis_data_tlast      (rdmap_dpl_tlast        ),
    .histogram_bin_select       ('d0                    ),//00:/256, 01:/512, 10:/1024, 11:/2048
    .threshold_db_value_select  ('d3                    ),//3db - 7db    
    .hist_busy_o                (hist_busy              ),
    .histogram_calc_vld         (histogram_calc_vld     ),
    .histogram_calc_datath      (histogram_calc_datath  )  
);

wire [16*21-1:0]  dpl_win_data          ;
wire              dpl_win_data_vliad    ;

calc_dpl_win calc_dpl_win
(
    .clk                (clk                    ),
    .rst                (rst                    ),
    .dpl_data           (rdmap_dpl_data         ),
    .dpl_data_valid     (rdmap_dpl_valid        ),
    .win_data           (dpl_win_data           ),
    .win_data_vliad     (dpl_win_data_vliad     )
);

                                  
wire        log2_data_vld_o ;
wire [15:0] log2_data_o     ;
         
wire        rng_win_vld ;
wire [15:0] win_data0   ;
wire [15:0] win_data1   ;
wire [15:0] win_data2   ;
wire [15:0] win_data3   ;
wire [15:0] win_data4   ;
wire [15:0] win_data5   ;
wire [15:0] win_data6   ;
wire [15:0] win_data7   ;
wire [15:0] win_data8   ;
wire [15:0] win_data9   ;
wire [15:0] win_data10  ;
wire [15:0] win_data11  ;
wire [15:0] win_data12  ;
wire [15:0] win_data13  ;
wire [15:0] win_data14  ;
wire [15:0] win_data15  ;
wire [15:0] win_data16  ;
wire [15:0] win_data17  ;
wire [15:0] win_data18  ;
wire [15:0] win_data19  ;
wire [15:0] win_data20  ;
wire [15:0] win_data21  ;
wire [15:0] win_data22  ;
wire [15:0] win_data23  ;
wire [15:0] win_data24  ;
wire [15:0] win_data25  ;
wire [15:0] win_data26  ;
wire [15:0] win_data27  ;
wire [15:0] win_data28  ;
wire [15:0] win_data29  ;
wire [15:0] win_data30  ;
wire [15:0] win_data31  ;
wire [15:0] win_data32  ;
wire [15:0] win_data33  ;
wire [15:0] win_data34  ;
wire [15:0] win_data35  ;
wire [15:0] win_data36  ;


calc_rng_win calc_rng_win
(
    .clk                (clk                ),
    .rst                (rst                ),
    .log2_data_vld      (rdmap_range_valid  ),
    .log2_data          (rdmap_range_data   ),
    .log2_data_vld_o    (log2_data_vld_o    ),
    .log2_data_o        (log2_data_o        ),
    .rng_win_vld        (rng_win_vld        ),
    .win_data0          (win_data0          ),
    .win_data1          (win_data1          ),
    .win_data2          (win_data2          ),
    .win_data3          (win_data3          ),
    .win_data4          (win_data4          ),
    .win_data5          (win_data5          ),
    .win_data6          (win_data6          ),
    .win_data7          (win_data7          ),
    .win_data8          (win_data8          ),
    .win_data9          (win_data9          ),
    .win_data10         (win_data10         ),
    .win_data11         (win_data11         ),
    .win_data12         (win_data12         ),
    .win_data13         (win_data13         ),
    .win_data14         (win_data14         ),
    .win_data15         (win_data15         ),
    .win_data16         (win_data16         ),
    .win_data17         (win_data17         ),
    .win_data18         (win_data18         ),
    .win_data19         (win_data19         ),
    .win_data20         (win_data20         ),
    .win_data21         (win_data21         ),
    .win_data22         (win_data22         ),
    .win_data23         (win_data23         ),
    .win_data24         (win_data24         ),
    .win_data25         (win_data25         ),
    .win_data26         (win_data26         ),
    .win_data27         (win_data27         ),
    .win_data28         (win_data28         ),
    .win_data29         (win_data29         ),
    .win_data30         (win_data30         ),
    .win_data31         (win_data31         ),
    .win_data32         (win_data32         ),
    .win_data33         (win_data33         ),
    .win_data34         (win_data34         ),
    .win_data35         (win_data35         ),
    .win_data36         (win_data36         )
);

wire [15:0]   rdmap_range_delay       ;
wire          rdmap_range_delay_vaild ;

wire          rng_gate_data_vld_o ;
wire [15:0]   rng_gate_data_o     ;
wire [15:0]   rng_casogo_data_o   ;

calc_ca_rng calc_ca_rng
(
    .clk                (clk                ),
    .rst                (rst                ),
    .log2_data_vld      (log2_data_vld_o    ),
    .log2_data          (log2_data_o        ),
    .rng_win_vld        (rng_win_vld        ),
    .win_data0          (win_data0          ),
    .win_data1          (win_data1          ),
    .win_data2          (win_data2          ),
    .win_data3          (win_data3          ),
    .win_data4          (win_data4          ),
    .win_data5          (win_data5          ),
    .win_data6          (win_data6          ),
    .win_data7          (win_data7          ),
    .win_data8          (win_data8          ),
    .win_data9          (win_data9          ),
    .win_data10         (win_data10         ),
    .win_data11         (win_data11         ),
    .win_data12         (win_data12         ),
    .win_data13         (win_data13         ),
    .win_data14         (win_data14         ),
    .win_data15         (win_data15         ),
    .win_data16         (win_data16         ),
    .win_data17         (win_data17         ),
    .win_data18         (win_data18         ),
    .win_data19         (win_data19         ),
    .win_data20         (win_data20         ),
    .win_data21         (win_data21         ),
    .win_data22         (win_data22         ),
    .win_data23         (win_data23         ),
    .win_data24         (win_data24         ),
    .win_data25         (win_data25         ),
    .win_data26         (win_data26         ),
    .win_data27         (win_data27         ),
    .win_data28         (win_data28         ),
    .win_data29         (win_data29         ),
    .win_data30         (win_data30         ),
    .win_data31         (win_data31         ),
    .win_data32         (win_data32         ),
    .win_data33         (win_data33         ),
    .win_data34         (win_data34         ),
    .win_data35         (win_data35         ),
    .win_data36         (win_data36         ), 
    .log2_data_vld_o    (rdmap_range_delay_vaild ),   
    .log2_data_o        (rdmap_range_delay  ),
                       
    .rng_gate_data_vld_o(rng_gate_data_vld_o),
    .rng_gate_data_o    (rng_gate_data_o    ),
    .rng_casogo_data_o  (rng_casogo_data_o  )
);

wire  [15:0]      cfar_dpl_map_addr ;
wire  [15:0]      cfar_dpl_map_data ;

calc_ca_dpl calc_ca_dpl
(
    .clk                (clk                ),
    .rst                (rst                ),

    .win_data           (dpl_win_data       ),
    .win_data_vliad     (dpl_win_data_vliad ),
    .cfar_dpl_map_addr  (cfar_dpl_map_addr  ),
    .cfar_dpl_map_data  (cfar_dpl_map_data  )
);

wire  [31:0]	o_cfar_data_tdata	;
wire  [15:0]    o_cfar_data_tnum    ;
wire  		    o_cfar_data_tvalid  ;
wire  		    o_cfar_data_tlast   ;

target_out_jude target_out_jude 
(

    .clk                (clk                ),
    .rst                (rst                ),
    .log2_data_vld_i    (rdmap_range_delay_vaild),
    .log2_data_i        (rdmap_range_delay  ),
    .rng_gate_data_vld_i(rng_gate_data_vld_o),
    .rng_gate_data_i    (rng_gate_data_o    ),
    .rng_casogo_data_i  (rng_casogo_data_o  ),
    
    .hist_bin_i         ('d0                ),//00:/256, 01:/512, 10:/1024, 11:/2048
    .db_value_i         ('d3                ),//3db - 7db    
    .hist_busy_i        (hist_busy          ),
    .hist_calc_vld_i    (histogram_calc_vld ),
    .hist_calc_data_i   (histogram_calc_datath),

    .cfar_dpl_ram_data  (cfar_dpl_map_data  ),
    .cfar_dpl_ram_addr  (cfar_dpl_map_addr  ),

    .cfar_data_tdata    (o_cfar_data_tdata  ),	
    .cfar_data_count    (   ),	
    .cfar_data_tnum     (o_cfar_data_tnum   ),
    .cfar_data_tvalid   (o_cfar_data_tvalid ),
    .cfar_data_tlast    (o_cfar_data_tlast  )
);

cfar_data_segment cfar_data_segment 
(   
    .clk                (clk                ),	
    .rst                (rst                ),
    .cfar_data_valid_i  (o_cfar_data_tvalid ),       
    .cfar_data_i        (o_cfar_data_tdata  ),       
    .cfar_data_last_i   (o_cfar_data_tlast  ),       
    .cfar_data_num_i    (o_cfar_data_tnum   ),

    .cfar_data_valid_o  (cfar_data_valid    ),
    .cfar_data_o        (cfar_data          ),
    .cfar_data_last_o   (cfar_data_last     ),
    .cfar_data_num_o    (cfar_data_num      )
);

endmodule
module adc_rx_top
(
    input   wire        sys_clk              ,
    input   wire        clk_100m             ,
    input   wire        clk_dclk_o           ,
    input   wire        rst                  ,
    input   wire        clk_300m             ,

    input   wire [15:0] SirAddr              ,
    input   wire        SirRead              ,
    input   wire [31:0] SirWdat              ,
    input   wire        SirSel               ,
    output  wire        SirDack              ,
    output  wire [31:0] SirRdat              ,

    input   wire        PRI                  ,
    input   wire        CPIB                 ,
    input   wire        CPIE                 ,
    input   wire        sample_gate          ,

    input   wire        adc3663_fclk_p       ,
    input   wire        adc3663_fclk_n       ,

    input   wire        adc3663_dclk_p       ,
    input   wire        adc3663_dclk_n       ,

    input   wire        adc3663_da0_p        ,
    input   wire        adc3663_da0_n        ,
    input   wire        adc3663_da1_p        ,
    input   wire        adc3663_da1_n        ,

    input   wire        adc3663_db0_p        ,
    input   wire        adc3663_db0_n        ,
    input   wire        adc3663_db1_p        ,
    input   wire        adc3663_db1_n        ,

    output  wire        adc3663_dclk_o_p     ,
    output  wire        adc3663_dclk_o_n     ,

    output  wire        adc_data_sop_cha_o   ,
    output  wire        adc_data_eop_cha_o   ,
    output  wire [15:0] adc_data_cha_o    	 ,
    output  wire        adc_data_valid_cha_o ,		
    
    output  wire        adc_data_sop_chb_o   ,
    output  wire        adc_data_eop_chb_o   ,
    output  wire [15:0] adc_data_chb_o       ,
    output  wire        adc_data_valid_chb_o ,

    output  wire [15:0] sample_num         ,
    output  wire [15:0] chirp_num          ,
    input   wire [15:0] horizontal_pitch   ,
    output  wire [ 7:0] wave_position      ,
    output  wire        scan_mode          ,
    input   wire [15:0] pri_period         ,
    input   wire [15:0] start_sample       ,

    output  wire [63:0] fifo_din_cmd_adc   ,
    output  wire        fifo_wr_en_cmd_adc ,
    input   wire        fifo_full_cmd_adc  ,
    
    output  wire        fifo_wr_en_wr_adc  ,
    output  wire [127:0]fifo_din_wr_adc    ,
    input   wire        fifo_full_wr_adc   ,

    output  wire [63:0] fifo_din_cmd_pil   ,
    output  wire        fifo_wr_en_cmd_pil ,
    input   wire        fifo_full_cmd_pil  ,

    input   wire [127:0]fifo_dout_rd_pil   ,
    output  wire        fifo_rd_en_rd_pil  ,
    input   wire        fifo_empty_rd_pil  ,

    output  wire        adc_abnormal_irp   ,
    output  wire        ps_adc_tx_irq      ,
    output  wire        adc_wr_irp         ,
    output  wire [8*32-1:0] tag_info_o
);

wire [31:0]     adc_ctr_mode        ;
wire            adc_start           ;

wire [15:0]     adc3663_data_cha    ;
wire [15:0]     adc3663_data_chb    ;
wire            adc3663_data_valid  ;
wire            adc3663_dclk        ;
wire [15:0]     adc_threshold       ;
wire [31:0]     adc_abnormal_num_max;
wire [31:0]     adc_abnormal_num    ;
wire [8 :0]     tap_out_int0        ;
wire [8 :0]     tap_out_int1        ;
wire [8 :0]     tap_out_int2        ;

wire            idelay_d0_load     ;
wire            idelay_d1_load     ;
wire            idelay_d2_load     ;
wire            dma_ready          ;
wire            adc_gather_debug   ;
wire [7 :0]     last_position      ;
wire            pil_trigger        ;
wire [31:0]     pil_pri_delay      ;
wire            adc_mux_s          ;

wire [31:0]     waveType           ;
wire [8*8-1:0]  timestamp          ;
wire [15:0]     azimuth            ;
wire [15:0]     elevation          ;
wire [7:0]      aziScanCenter      ;
wire [7:0]      aziScanScope       ;
wire [7:0]      eleScanCenter      ;
wire [7:0]      eleScanScope       ;
wire [7:0]      trackTwsTasFlag    ;
wire [7:0]      last_wave          ;
wire [7:0]      wave_postion       ;

reg [15:0] adc_cha_reg_d0  = 'd0 ;
reg [15:0] adc_chb_reg_d0  = 'd0 ;
reg [15:0] adc_cha_reg_d1  = 'd0 ;
reg [15:0] adc_chb_reg_d1  = 'd0 ;
reg [15:0] adc_cha_reg_d2  = 'd0 ;
reg [15:0] adc_chb_reg_d2  = 'd0 ;

//-----------------------------------跨时钟 ,这里ADC数据给上位机做校准（暂时不处理）------------------------------------
always @(posedge clk_100m) begin
    adc_cha_reg_d0  <= adc3663_data_cha ;
    adc_chb_reg_d0  <= adc3663_data_chb ;
    adc_cha_reg_d1  <= adc_cha_reg_d0 ;
    adc_chb_reg_d1  <= adc_chb_reg_d0 ;
    adc_cha_reg_d2  <= adc_cha_reg_d1 ;
    adc_chb_reg_d2  <= adc_chb_reg_d1 ;
end

csr01 csr01 
(
    .rst                      (rst                      ),
    .clk                      (clk_100m                 ),

    .SirAddr                  (SirAddr                  ),
    .SirRead                  (SirRead                  ),
    .SirWdat                  (SirWdat                  ),
    .SirSel                   (SirSel                   ),
    .SirDack                  (SirDack                  ),
    .SirRdat                  (SirRdat                  ),

    .adc_ctr_mode             (adc_ctr_mode             ),
    .dma_ready                (dma_ready                ),
    .adc_threshold            (adc_threshold            ),
    .adc_abnormal_num_max     (adc_abnormal_num_max     ),
    .adc_abnormal_num         (adc_abnormal_num         ),

    .sample_num               (sample_num               ),
    .chirp_num                (chirp_num                ),
    .adc_gather_debug         (adc_gather_debug         ),
    .wave_position            (wave_position            ),
    .last_position            (last_position            ),
    .scan_mode                (scan_mode                ),
    .pil_trigger              (pil_trigger              ),
    .pil_pri_delay            (pil_pri_delay            ),
    .adc_mux_s                (adc_mux_s                ),
    .adc_cha_ps               (adc_cha_reg_d2           ),
    .adc_chb_ps               (adc_chb_reg_d2           ),

    .tap_out_int0             (tap_out_int0             ),
    .tap_out_int1             (tap_out_int1             ),
    .tap_out_int2             (tap_out_int2             ),
    .idelay_d0_load           (idelay_d0_load           ),
    .idelay_d1_load           (idelay_d1_load           ),
    .idelay_d2_load           (idelay_d2_load           ),


    .waveType                 (waveType                 ),
    .timestamp                (timestamp                ),
    .azimuth                  (azimuth                  ),
    .elevation                (elevation                ),
    .aziScanCenter            (aziScanCenter            ),
    .aziScanScope             (aziScanScope             ),
    .eleScanCenter            (eleScanCenter            ),
    .eleScanScope             (eleScanScope             ),
    .trackTwsTasFlag          (trackTwsTasFlag          ),
    .last_wave                (last_wave                ),

    .axis_test_tvalid_cnt     (axis_test_tvalid_cnt     ),
    .axis_test_tlast_cnt      (axis_test_tlast_cnt      ),
    .axis_adc_data_tvalid_cnt (axis_adc_data_tvalid_cnt ),
    .axis_adc_data_tlast_cnt  (axis_adc_data_tlast_cnt  ),
    .fifo_debug               (fifo_debug               )
);

serila_lvds_adc3663 serila_lvds_adc3663
(
    .rst                    (rst                ),
    .clk_dclk_o             (clk_dclk_o         ),
    .sys_clk                (sys_clk            ),
    .clk_300m               (clk_300m           ),

    .adc3663_fclk_p         (adc3663_fclk_p     ),
    .adc3663_fclk_n         (adc3663_fclk_n     ),

    .adc3663_dclk_p         (adc3663_dclk_p     ),
    .adc3663_dclk_n         (adc3663_dclk_n     ),

    .adc3663_da0_p          (adc3663_da0_p      ),
    .adc3663_da0_n          (adc3663_da0_n      ),
    .adc3663_da1_p          (adc3663_da1_p      ),
    .adc3663_da1_n          (adc3663_da1_n      ),

    .adc3663_db0_p          (adc3663_db0_p      ),
    .adc3663_db0_n          (adc3663_db0_n      ),
    .adc3663_db1_p          (adc3663_db1_p      ),
    .adc3663_db1_n          (adc3663_db1_n      ),

    .adc3663_dclk_o_p       (adc3663_dclk_o_p   ),
    .adc3663_dclk_o_n       (adc3663_dclk_o_n   ),
`ifndef SIM
    .adc_data_cha           (adc3663_data_cha   ),
    .adc_data_chb           (adc3663_data_chb   ),
    .adc_data_valid         (adc3663_data_valid ),
`else
`endif
    .tap_out_int0           (tap_out_int0       ),
    .tap_out_int1           (tap_out_int1       ),
    .tap_out_int2           (tap_out_int2       ),
    .idelay_d0_load         (idelay_d0_load     ),
    .idelay_d1_load         (idelay_d1_load     ),
    .idelay_d2_load         (idelay_d2_load     )
);

wire        adc_data_sop_tmp    ;
wire        adc_data_eop_tmp    ;
wire [15:0] adc_data_tmp        ;
wire        adc_data_valid_tmp  ;

wire        adc_data_sop_cha  	;
wire        adc_data_eop_cha  	;
wire [15:0] adc_data_cha      	;
wire        adc_data_valid_cha	;		

wire        adc_data_sop_chb  	;
wire        adc_data_eop_chb  	;
wire [15:0] adc_data_chb      	;
wire        adc_data_valid_chb	;

adc_ctr adc_ctr
(
    .clk                    (sys_clk            ),
    .rst                    (rst                ),
`ifndef SIM 
    .dma_ready              (dma_ready          ),
`else 
    .dma_ready              (1'b1               ),
`endif 
    .sample_num             (sample_num         ),
    .chirp_num              (chirp_num          ),
    .adc_threshold          (adc_threshold      ),
    .adc_abnormal_num       (adc_abnormal_num   ),
    .adc_abnormal_num_max   (adc_abnormal_num_max),
    .adc_abnormal_irp       (adc_abnormal_irp   ),

    .adc_data_cha           (adc3663_data_cha   ),
    .adc_data_chb           (adc3663_data_chb   ),
    .adc_data_valid         (adc3663_data_valid ),
    .PRI                    (PRI                ),
    .CPIB                   (CPIB               ),
    .CPIE                   (CPIE               ),
    .sample_gate            (sample_gate        ),
 
    .adc_data_sop_cha       (adc_data_sop_cha   ),
    .adc_data_eop_cha       (adc_data_eop_cha   ),
    .adc_data_cha_o         (adc_data_cha       ),
    .adc_data_valid_cha     (adc_data_valid_cha ),

    .adc_data_sop_chb       (adc_data_sop_chb   ),
    .adc_data_eop_chb       (adc_data_eop_chb   ),
    .adc_data_chb_o         (adc_data_chb       ),
    .adc_data_valid_chb     (adc_data_valid_chb )

);

adc_gather adc_gather
(
    .clk                (sys_clk            ),
    .rst                (rst                ),

    .PRI                (PRI                ),
    .CPIB               (CPIB               ),
    .CPIE               (CPIE               ),
    .sample_gate        (sample_gate        ),
`ifndef SIM
    .dma_ready          (dma_ready          ),
`else
    .dma_ready          (1'b1               ),
`endif
    .sample_num         (sample_num         ),
    .chirp_num          (chirp_num          ),
    .horizontal_pitch   (horizontal_pitch   ),
    .scan_mode          (scan_mode          ),
    .adc_gather_debug   (adc_gather_debug   ),
    .wave_position      (wave_position      ),
    .last_position      (last_position      ),

    .adc_data_sop_cha   (adc_data_sop_cha   ),
    .adc_data_eop_cha   (adc_data_eop_cha   ),
    .adc_data_cha       (adc_data_cha       ),
    .adc_data_valid_cha (adc_data_valid_cha ),

    .adc_data_sop_chb   (adc_data_sop_chb   ),
    .adc_data_eop_chb   (adc_data_eop_chb   ),
    .adc_data_chb       (adc_data_chb       ),
    .adc_data_valid_chb (adc_data_valid_chb ),

    .fifo_din_cmd_adc   (fifo_din_cmd_adc   ),
    .fifo_wr_en_cmd_adc (fifo_wr_en_cmd_adc ),
    .fifo_full_cmd_adc  (fifo_full_cmd_adc  ),
    
    .fifo_wr_en_wr_adc  (fifo_wr_en_wr_adc  ),
    .fifo_din_wr_adc    (fifo_din_wr_adc    ),
    .fifo_full_wr_adc   (fifo_full_wr_adc   ),
    
    .adc_wr_irp         (adc_wr_irp         )
);


wire [15:0]    adc_pil_data_cha  ;
wire           adc_pil_sop_cha   ;
wire           adc_pil_eop_cha   ;
wire           adc_pil_valid_cha ;

wire [15:0]    adc_pil_data_chb  ;
wire           adc_pil_sop_chb   ;
wire           adc_pil_eop_chb   ;
wire           adc_pil_valid_chb ;

adc_pil adc_pil
(
    .clk                    (sys_clk                ),
    .rst                    (rst                    ),

    .fifo_din_cmd           (fifo_din_cmd_pil       ),
    .fifo_wr_en_cmd         (fifo_wr_en_cmd_pil     ),
    .fifo_full_cmd          (fifo_full_cmd_pil      ),

    .fifo_dout_rd           (fifo_dout_rd_pil       ),
    .fifo_rd_en_rd          (fifo_rd_en_rd_pil      ),
    .fifo_empty_rd          (fifo_empty_rd_pil      ),

    .sample_num             (sample_num             ),
    .chirp_num              (chirp_num              ),
    .wave_position          (wave_position          ),
    .pil_trigger            (pil_trigger            ),
    .pil_pri_delay          (pil_pri_delay          ),

    .adc_sli_data_cha       (adc_pil_data_cha       ),
    .adc_sli_sop_cha        (adc_pil_sop_cha        ),
    .adc_sli_eop_cha        (adc_pil_eop_cha        ),
    .adc_sli_valid_cha      (adc_pil_valid_cha      ),

    .adc_sli_data_chb       (adc_pil_data_chb       ),
    .adc_sli_sop_chb        (adc_pil_sop_chb        ),
    .adc_sli_eop_chb        (adc_pil_eop_chb        ),
    .adc_sli_valid_chb      (adc_pil_valid_chb      )
);

adc_mux adc_mux 
(
    .clk                (sys_clk                    ),
    .rst                (rst                        ),

    .adc_mux_s          (adc_mux_s                  ),
    .adc_ch0_data_cha   (adc_data_cha               ), 
    .adc_ch0_sop_cha    (adc_data_sop_cha           ),
    .adc_ch0_eop_cha    (adc_data_eop_cha           ),
    .adc_ch0_valid_cha  (adc_data_valid_cha         ),

    .adc_ch0_data_chb   (adc_data_chb               ),
    .adc_ch0_sop_chb    (adc_data_sop_chb           ),
    .adc_ch0_eop_chb    (adc_data_eop_chb           ),
    .adc_ch0_valid_chb  (adc_data_valid_chb         ),

    .adc_ch1_data_cha   (adc_pil_data_cha           ),
    .adc_ch1_sop_cha    (adc_pil_sop_cha            ),
    .adc_ch1_eop_cha    (adc_pil_eop_cha            ),
    .adc_ch1_valid_cha  (adc_pil_valid_cha          ),
    
    .adc_ch1_data_chb   (adc_pil_data_chb           ),
    .adc_ch1_sop_chb    (adc_pil_sop_chb            ),
    .adc_ch1_eop_chb    (adc_pil_eop_chb            ),
    .adc_ch1_valid_chb  (adc_pil_valid_chb          ),

    .adc_data_cha       (adc_data_cha_o             ),
    .adc_data_sop_cha   (adc_data_sop_cha_o         ),
    .adc_data_eop_cha   (adc_data_eop_cha_o         ),
    .adc_data_valid_cha (adc_data_valid_cha_o       ),

    .adc_data_chb       (adc_data_chb_o             ),
    .adc_data_sop_chb   (adc_data_sop_chb_o         ),
    .adc_data_eop_chb   (adc_data_eop_chb_o         ),
    .adc_data_valid_chb (adc_data_valid_chb_o       )
);

tag_info_genter tag_info_genter 
(
    .clk                (sys_clk                    ),
    .rst                (rst                        ),

    .pil_mode           (adc_mux_s                  ),
    .pil_triger         (pil_trigger                ),
    .PRI                (PRI                        ),
    .CPIB               (CPIB                       ),
    .CPIE               (CPIE                       ),
    .sample_gate        (sample_gate                ),
    .dma_ready          (dma_ready                  ),

    .waveType           (waveType                   ),
    .timestamp          (timestamp                  ),
    .azimuth            (azimuth                    ),
    .elevation          (elevation                  ),
    .aziScanCenter      (aziScanCenter              ),
    .aziScanScope       (aziScanScope               ),
    .eleScanCenter      (eleScanCenter              ),
    .eleScanScope       (eleScanScope               ),
    .trackTwsTasFlag    (trackTwsTasFlag            ),
    .last_wave          (last_wave                  ),
    .pri_period         (pri_period                 ),
    .start_sample       (start_sample               ),
    .wave_position      (wave_position              ),

    .tag_info_o         (tag_info_o                 )    
);

endmodule

module dsp_top(

    input           clk                 , //! 160mhz clk
	input           rst                 , //! high system rst
    input           i_cpib              , //! timing cpi begin signal peiod ~ ms 
    input           i_cpie              , //! timing cpi end signal period ~
    
    input [15:0]    sample_num          ,
    input [15:0]    chirp_num           ,
    output[15:0]    horizontal_pitch    ,
    input [8*32-1:0]tag_info_i          ,

    input           clk_100m            , //! native csr register interface 
    input  [15:0]   SirAddr             , //! native csr register interface
    input           SirRead             , //! native csr register interface
    input  [31:0]   SirWdat             , //! native csr register interface
    input           SirSel              , //! native csr register interface
    output          SirDack             , //! native csr register interface
    output [31:0]   SirRdat             , //! native csr register interface

    input           adc_data_cha_sop    ,
    input           adc_data_cha_eop    ,
    input   [15:0]  adc_data_cha        ,
    input           adc_data_cha_valid  ,

    input           adc_data_chb_sop    ,
    input           adc_data_chb_eop    ,
    input   [15:0]  adc_data_chb        ,
    input           adc_data_chb_valid  ,

    output  [31:0]  cfar_data_tdata , 
    output    	    cfar_data_valid ,
    output    	    cfar_data_last  ,

    output  [63:0]  fifo_din_cmd_rdmap  ,
    output          fifo_wr_en_cmd_rdmap,
    input           fifo_full_cmd_rdmap ,

    output          fifo_wr_en_wr_rdmap ,
    output  [127:0] fifo_din_wr_rdmap   ,
    input           fifo_full_wr_rdmap  ,
    output 			rdmap_wr_irq        ,

    output  [63:0]  fifo_din_cmd_rdmapIQ    ,
    output          fifo_wr_en_cmd_rdmapIQ  ,
    input           fifo_full_cmd_rdmapIQ   ,

    output          fifo_wr_en_wr_rdmapIQ   ,
    output  [127:0] fifo_din_wr_rdmapIQ     ,
    input           fifo_full_wr_rdmapIQ    ,

    output  [63:0]  fifo_din_cmd_detection  ,
    output          fifo_wr_en_cmd_detection,
    input           fifo_full_cmd_detection ,

    output          fifo_wr_en_wr_detection ,
    output  [127:0] fifo_din_wr_detection   ,
    input           fifo_full_wr_detection  ,
  
    output          rdmapIQ_wr_irp ,
    output          detection_log_irq        
);

wire		    thresh_valid;
wire [15:0]	    thresh_dat  ;
wire		    spect_valid ;
wire [15:0]	    spect_dat   ;
wire		    center_valid;
wire [15:0]	    center_dat  ;

wire [15:0]     recur_coeff       ;
wire [7:0]      cult_mode         ;
wire [7:0]      cult_sch_sw       ;
wire [15:0]     clut_cpi          ;
wire [15:0]     clut_tas_cpi      ;
wire [7:0]      clut_tas_ary      ;	
wire [15:0]     clut_tas_inr      ;    
wire [15:0]     adc_truncation    ;
wire [ 7:0]     rfft_truncation   ; 
wire            fir_enable        ;
wire            histogram_busy    ;
wire  [15:0]    rdmap_range_data  ;
wire            rdmap_range_valid ;  
wire            config_trigger    ;
wire [31:0]     Calibration_IQCHA ;
wire [31:0]     Calibration_IQCHB ;

wire            adc_data_sub_sop  ;
wire            adc_data_sub_eop  ;
wire  [31:0]    adc_data_sub      ;
wire            adc_data_sub_valid;

wire            adc_data_sum_sop  ;
wire            adc_data_sum_eop  ;
wire  [31:0]    adc_data_sum      ;
wire            adc_data_sum_valid;
wire  [7:0]     cur_wave_position ;
csr02 csr02 
(
    .rst            (rst            ),
    .clk            (clk_100m       ),

    .SirAddr        (SirAddr        ),
    .SirRead        (SirRead        ),
    .SirWdat        (SirWdat        ),
    .SirSel         (SirSel         ),
    .SirDack        (SirDack        ),
    .SirRdat        (SirRdat        ),

    .cult_mode      (cult_mode      ),
    .cult_sch_sw    (cult_sch_sw    ),
    .clut_cpi       (clut_cpi       ),
    .clut_tas_cpi   (clut_tas_cpi   ),
    .clut_tas_ary   (clut_tas_ary   ),
    .clut_tas_inr   (clut_tas_inr   ),
    .adc_truncation (adc_truncation ),
    .rfft_truncation(rfft_truncation),
    .fir_enable     (fir_enable     ),
    .config_trigger (config_trigger ),
    .cur_wave_position (cur_wave_position  ),
    .horizontal_pitch  (horizontal_pitch   ),
    .Calibration_IQCHA (Calibration_IQCHA  ),
    .Calibration_IQCHB (Calibration_IQCHB  )
);

wire [31:0] o_rdmap_log2_tdata  ; //! RDMAP data 
wire        o_rdmap_log2_tvalid ; //！RDMAP data valid 
wire        o_rdmap_log2_tlast  ; //！RDMAP data last

wire [31:0] vfft_data_add ;     
wire        vfft_data_valid_add ;
wire        vfft_data_tlast_add ;


PhaseCalibration PhaseCalibration
(
    .sys_clk                (clk                    ),
    .rst                    (rst                    ),

    .adc_data_cha_sop       (adc_data_cha_sop       ),
    .adc_data_cha_eop       (adc_data_cha_eop       ),
    .adc_data_cha           (adc_data_cha           ),
    .adc_data_cha_valid     (adc_data_cha_valid     ),
    
    .adc_data_chb_sop       (adc_data_chb_sop       ),
    .adc_data_chb_eop       (adc_data_chb_eop       ),
    .adc_data_chb           (adc_data_chb           ),
    .adc_data_chb_valid     (adc_data_chb_valid     ),
    
    .Calibration_IQCHA      (Calibration_IQCHA      ),
    .Calibration_IQCHB      (Calibration_IQCHB      ),  

    .adc_data_sub_sop       (adc_data_sub_sop       ),
    .adc_data_sub_eop       (adc_data_sub_eop       ),
    .adc_data_sub           (adc_data_sub           ),
    .adc_data_sub_valid     (adc_data_sub_valid     ),

    .adc_data_sum_sop       (adc_data_sum_sop       ),
    .adc_data_sum_eop       (adc_data_sum_eop       ),
    .adc_data_sum           (adc_data_sum           ),
    .adc_data_sum_valid     (adc_data_sum_valid     )
);

rdmap rdmap_add
(
    .clk                    (clk                    ),
    .rst                    (rst                    ),

    .i_cpib                 (i_cpib                 ),    
    .i_cpie                 (i_cpie                 ),
    .sample_num             (sample_num             ),
    .chirp_num              (chirp_num              ),

    .adc_data_valid         (adc_data_sum_valid     ),
    .adc_data               (adc_data_sum           ),
    .adc_data_sop           (adc_data_sum_sop       ),
    .adc_data_eop           (adc_data_sum_eop       ),

    .adc_truncation         (adc_truncation         ),
    .rfft_truncation        (rfft_truncation        ),

    .vfft_data              (vfft_data_add          ),
    .vfft_data_valid        (vfft_data_valid_add    ),
    .vfft_data_tlast        (vfft_data_tlast_add    ),

    .rdmap_range_data       (rdmap_range_data       ),
    .rdmap_range_valid      (rdmap_range_valid      ),
    .o_rdmap_log2_tdata     (o_rdmap_log2_tdata     ),
    .o_rdmap_log2_tvalid    (o_rdmap_log2_tvalid    ),
    .o_rdmap_log2_tlast     (o_rdmap_log2_tlast     ),

    .fir_enable             (fir_enable             ),
    .horizontal_pitch       (horizontal_pitch       ),
    .histogram_busy         (histogram_busy         ),
    .config_trigger         (config_trigger         )
);

wire [31:0]     vfft_data_sub ;

rdmap rdmap_sub
(

    .clk                    (clk                    ),
    .rst                    (rst                    ),

    .i_cpib                 (i_cpib                 ),    
    .i_cpie                 (i_cpie                 ),
    .sample_num             (sample_num             ),
    .chirp_num              (chirp_num              ),

    .adc_data_valid         (adc_data_sub_valid     ),
    .adc_data               (adc_data_sub           ),
    .adc_data_sop           (adc_data_sub_sop       ),
    .adc_data_eop           (adc_data_sub_eop       ),

    .adc_truncation         (adc_truncation         ),
    .rfft_truncation        (rfft_truncation        ),


    .vfft_data              (vfft_data_sub          ),
    .vfft_data_valid        (),
    .vfft_data_tlast        (),

    // .rdmap_range_data       (rdmap_range_data       ),
    // .rdmap_range_valid      (rdmap_range_valid      ),
    .o_rdmap_log2_tdata     (),
    .o_rdmap_log2_tvalid    (),
    .o_rdmap_log2_tlast     (),

    .fir_enable             (fir_enable             ),
    .horizontal_pitch       (horizontal_pitch       ),
    .histogram_busy         (histogram_busy         ),
    .config_trigger         (config_trigger         )
);

wire    [15:0]      cfar_data_tnum  ;
wire    [15:0]      cfar_data_count	;
wire    [15:0]      cfar_data_num   ;

cfar_detection cfar_detection
(
    .clk                    (clk                    ),
    .rst                    (rst                    ),

    .rdmap_dpl_data         (o_rdmap_log2_tdata     ),
    .rdmap_dpl_valid        (o_rdmap_log2_tvalid    ),
    .rdmap_dpl_tlast        (o_rdmap_log2_tlast     ),

    .rdmap_range_data       (rdmap_range_data       ), 
    .rdmap_range_valid      (rdmap_range_valid      ),

    .cfar_data_valid        (cfar_data_valid        ),
    .cfar_data              (cfar_data_tdata        ),
    .cfar_data_last         (cfar_data_last         ),
    .cfar_data_num          (cfar_data_num          ),
    .hist_busy              (histogram_busy         )
);

// wire [63:0]  fifo_din_cmd_rdmapIQ  ;
// wire         fifo_wr_en_cmd_rdmapIQ;
// wire         fifo_full_cmd_rdmapIQ ;

// wire         fifo_wr_en_wr_rdmapIQ ;
// wire [127:0] fifo_din_wr_rdmapIQ   ;
// wire         fifo_full_wr_rdmapIQ  ;
wire rdmapIQ_wr_irq ;

rdmap_cache_iq rdmap_cache_iq 
(
    .clk                    (clk                    ),
    .rst                    (rst                    ),
    .wave_position          (tag_info_i[8*31-1:8*30]),
    .rdmapIQ_data           ({vfft_data_add,vfft_data_sub}),
    .rdmapIQ_data_tvalid    (vfft_data_valid_add    ),
    .rdmapIQ_data_tlast     (vfft_data_tlast_add    ),

    .fifo_din_cmd_rdmapIQ   (fifo_din_cmd_rdmapIQ   ),
    .fifo_wr_en_cmd_rdmapIQ (fifo_wr_en_cmd_rdmapIQ ),
    .fifo_full_cmd_rdmapIQ  (fifo_full_cmd_rdmapIQ  ),

    .fifo_wr_en_wr_rdmapIQ  (fifo_wr_en_wr_rdmapIQ  ),
    .fifo_din_wr_rdmapIQ    (fifo_din_wr_rdmapIQ    ),
    .fifo_full_wr_rdmapIQ   (fifo_full_wr_rdmapIQ   ),
    .rdmapIQ_wr_irq         (rdmapIQ_wr_irq         )
);

rdmap_cache rdmap_cache
(
    .clk                    (clk                    ),
    .rst                    (rst                    ),

    // .CPIE                   (i_cpie                 ),
    .wave_position          (tag_info_i[8*31-1:8*30]),
    .rdmap_log2_tdata       (o_rdmap_log2_tdata     ),
    .rdmap_log2_tvalid      (o_rdmap_log2_tvalid    ),
    .rdmap_log2_tlast       (o_rdmap_log2_tlast     ),

    .histogram_busy         (),
    .rdmap_range_data       (rdmap_range_data       ),
    .rdmap_range_valid      (rdmap_range_valid      ),

    .fifo_din_cmd_rdmap     (fifo_din_cmd_rdmap     ),
    .fifo_wr_en_cmd_rdmap   (fifo_wr_en_cmd_rdmap   ),
    .fifo_full_cmd_rdmap    (fifo_full_cmd_rdmap    ),
    
    .fifo_wr_en_wr_rdmap    (fifo_wr_en_wr_rdmap    ),
    .fifo_din_wr_rdmap      (fifo_din_wr_rdmap      ),
    .fifo_full_wr_rdmap     (fifo_full_wr_rdmap     ),
    .rdmap_wr_irq           (rdmap_wr_irq           )
);

// wire [63:0]  fifo_din_cmd_detection   ;
// wire         fifo_wr_en_cmd_detection ;
// wire         fifo_full_cmd_detection  ;

// wire          fifo_wr_en_wr_detection ;
// wire  [127:0] fifo_din_wr_detection   ;
// wire          fifo_full_wr_detection  ;
wire          detection_log_busy      ;


detection_log detection_log
(
    .clk                    (clk                   ),
    .rst                    (rst                   ),

    .start_op               (rdmapIQ_wr_irq        ),        // rdmap_ip数据传输完成后开始传输检测点和log信息
    .detection_data         ('d0                   ),
    .detection_valid        ('d0                   ),
    .detection_sop          (o_rdmap_log2_tlast    ),        // 检测点暂时未加 //临时加信号触发
    .detection_eop          ('d0                   ),
    .wave_position          (tag_info_i[8*31-1:8*30]    ),

    .log_data0              (tag_info_i[32*1-1:0]       ),
    .log_data1              (tag_info_i[32*2-1:32*1]    ),
    .log_data2              (tag_info_i[32*3-1:32*2]    ),
    .log_data3              (tag_info_i[32*4-1:32*3]    ),
    .log_data4              (tag_info_i[32*5-1:32*4]    ),
    .log_data5              (tag_info_i[32*6-1:32*5]    ),
    .log_data6              (tag_info_i[32*7-1:32*6]    ),
    .log_data7              (tag_info_i[32*8-1:32*7]    ),
    .log_data8              (32'h5a5a_5a5a  ),
    .log_data9              (32'h5a5a_5a5a  ),
    .log_data10             (32'h5a5a_5a5a  ),
    .log_data11             (32'h5a5a_5a5a  ),
    .log_data12             (32'h5a5a_5a5a  ),
    .log_data13             (32'h5a5a_5a5a  ),
    .log_data14             (32'h5a5a_5a5a  ),
    .log_data15             (32'h5a5a_5a5a  ),
    .cur_wave_position      (cur_wave_position  ),

    .fifo_din_cmd_detection     (fifo_din_cmd_detection   ),
    .fifo_wr_en_cmd_detection   (fifo_wr_en_cmd_detection ),
    .fifo_full_cmd_detection    (fifo_full_cmd_detection  ),
    
    .fifo_wr_en_wr_detection    (fifo_wr_en_wr_detection  ),
    .fifo_din_wr_detection      (fifo_din_wr_detection    ),
    .fifo_full_wr_detection     (fifo_full_wr_detection   ),
    .detection_log_busy         (detection_log_busy       ),
    .detection_log_irq          (detection_log_irq        )
);

// fifo2axi_mux fifo2axi_mux
// (
//     .clk                    (clk                    ),
//     .rst                    (rst                    ),

//     .mux_s                  (detection_log_busy     ),
//     .fifo_din_cmd_ch0       (fifo_din_cmd_rdmapIQ   ),
//     .fifo_wr_en_cmd_ch0     (fifo_wr_en_cmd_rdmapIQ ),
//     .fifo_full_cmd_ch0      (fifo_full_cmd_rdmapIQ  ),
    
//     .fifo_wr_en_wr_ch0      (fifo_wr_en_wr_rdmapIQ  ),
//     .fifo_din_wr_ch0        (fifo_din_wr_rdmapIQ    ),
//     .fifo_full_wr_ch0       (fifo_full_wr_rdmapIQ   ),

//     .fifo_din_cmd_ch1       (fifo_din_cmd_detection     ),
//     .fifo_wr_en_cmd_ch1     (fifo_wr_en_cmd_detection   ),
//     .fifo_full_cmd_ch1      (fifo_full_cmd_detection    ),
    
//     .fifo_wr_en_wr_ch1      (fifo_wr_en_wr_detection    ),
//     .fifo_din_wr_ch1        (fifo_din_wr_detection      ),
//     .fifo_full_wr_ch1       (fifo_full_wr_detection     ),
    
//     .fifo_din_cmd_o         (fifo_din_cmd_mux           ),
//     .fifo_wr_en_cmd_o       (fifo_wr_en_cmd_mux         ),
//     .fifo_full_cmd_i        (fifo_full_cmd_mux          ),
    
//     .fifo_wr_en_wr_o        (fifo_wr_en_wr_mux          ),
//     .fifo_din_wr_o          (fifo_din_wr_mux            ),
//     .fifo_full_wr_i         (fifo_full_wr_mux           )
// );
endmodule

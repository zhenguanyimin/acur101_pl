module rdmap (
    input         clk                 ,  //! 160mhz clk
	input         rst                 ,  //! high system rst

    input         i_cpib              , //! timing cpi begin signal peiod ~ ms 
    input         i_cpie              , //! timing cpi end signal period ~

    input  [15:0] sample_num          ,
    input  [15:0] chirp_num           ,

    input         adc_data_valid      ,
    input  [31:0] adc_data            ,
    input         adc_data_sop        ,
    input         adc_data_eop        ,
    
    input  [15:0] adc_truncation      , //! adc truncation register
    input  [ 7:0] rfft_truncation     ,
    input  [15:0] horizontal_pitch    ,

    input         fir_enable          ,
    input         histogram_busy      ,
    input         config_trigger      ,

    output [15:0] rdmap_range_data    ,
    output        rdmap_range_valid   ,   
    
    output [31:0] vfft_data           ,
    output        vfft_data_valid     ,
    output        vfft_data_tlast     ,

    output [31:0] o_rdmap_log2_tdata  , //! RDMAP data 
    output        o_rdmap_log2_tvalid , //！RDMAP data valid 
    output        o_rdmap_log2_tlast    //！RDMAP data last
     
);

wire       win_tvalid   ;
wire       win_tlast    ;
wire [15:0]win_tdata    ;
wire [ 4:0]win_idx_pri  ;
wire [11:0]win_idx_data ;

wire       rfft_tvalid  ;
wire       rfft_tlast   ;
wire [31:0]rfft_tdata   ;
wire [ 4:0]rfft_idx_pri ;
wire [11:0]rfft_idx_data;

wire       r2c_tvalid   ;
wire       r2c_tlast    ;
wire [31:0]r2c_tdata    ;
wire [ 4:0]r2c_idx_pri  ;
wire [11:0]r2c_idx_data ;

wire        fir_valid   ;
wire        fir_tlast   ;
wire [47:0] fir_tdata   ;

wire        rdamp_tvalid;
wire [47:0] rdamp_tdata ;

wire        win_r_data_valid ;
wire [31:0] win_r_data       ;
wire        win_r_data_sop   ;
wire        win_r_data_eop   ;

win_r win_r (
    .clk                (clk                ),
    .rst                (rst                ),
    
    .sample_num         (sample_num         ),
    .chirp_num          (chirp_num          ),

    .adc_data_valid     (adc_data_valid     ),
    .adc_data           (adc_data           ),
    .adc_data_sop       (adc_data_sop       ),
    .adc_data_eop       (adc_data_eop       ),

    .win_r_data_valid   ( win_r_data_valid  ),
    .win_r_data         ( win_r_data        ),
    .win_r_data_sop     ( win_r_data_sop    ),
    .win_r_data_eop     ( win_r_data_eop    ),

    .adc_truncation     (adc_truncation     )
);

wire            fft_r_data_valid   ;
wire [31:0]     fft_r_data         ;
wire            fft_r_data_sop     ;
wire            fft_r_data_eop     ;


rfft u_rfft(
    .clk                (clk                ),
    .rst                (rst                ),

    .sample_num         (sample_num         ),
    .chirp_num          (chirp_num          ),
    .config_trigger     (config_trigger     ),
    .rfft_truncation    (rfft_truncation    ),

    .win_r_data_valid   (win_r_data_valid   ),
    .win_r_data         (win_r_data         ),
    .win_r_data_sop     (win_r_data_sop     ),
    .win_r_data_eop     (win_r_data_eop     ),

    .fft_r_data_valid   (fft_r_data_valid   ),
    .fft_r_data         (fft_r_data         ),
    .fft_r_data_sop     (fft_r_data_sop     ),
    .fft_r_data_eop     (fft_r_data_eop     )

);

wire            fft_r2d_data_valid      ;
wire    [31:0]  fft_r2d_data            ;
wire            fft_r2d_data_sop        ;
wire            fft_r2d_data_eop        ;   


row_2_clo u_row_2_clo(
    .clk                (clk                ),
    .rst                (rst                ),
    .sample_num         (sample_num         ),
    .chirp_num          (chirp_num          ),

    .fft_r_data_valid   (fft_r_data_valid   ),
    .fft_r_data         (fft_r_data         ),
    .fft_r_data_sop     (fft_r_data_sop     ),
    .fft_r_data_eop     (fft_r_data_eop     ),

    .fft_r2d_data_valid (fft_r2d_data_valid ),
    .fft_r2d_data       (fft_r2d_data       ),
    .fft_r2d_data_sop   (fft_r2d_data_sop   ),
    .fft_r2d_data_eop   (fft_r2d_data_eop   )
);

wire    [15:0]  rfft_re_data_win        ;
wire            rfft_re_data_valid_win  ;
wire            rfft_re_data_eop_win    ;
wire            rfft_re_data_sop_win    ;

win_v win_v_re 
(
    .clk                (clk                    ),
    .rst                (rst                    ),

    .data_in            (fft_r2d_data[15:0]     ),
    .data_valid         (fft_r2d_data_valid     ),
    .data_eop           (fft_r2d_data_eop       ),
    .data_sop           (fft_r2d_data_sop       ),
    .sample_num         (sample_num             ),
    .chirp_num          (chirp_num              ),
    .data_win_o         (rfft_re_data_win       ),
    .data_valid_win_o   (rfft_re_data_valid_win ),
    .data_eop_win_o     (rfft_re_data_eop_win   ),
    .data_sop_win_o     (rfft_re_data_sop_win   )

);

wire    [15:0]  rfft_im_data_win        ;
wire            rfft_im_data_valid_win  ;
wire            rfft_im_data_eop_win    ;
wire            rfft_im_data_sop_win    ;

win_v win_v_im 
(
    .clk                (clk                    ),
    .rst                (rst                    ),

    .data_in            (fft_r2d_data[31:16]    ),
    .data_valid         (fft_r2d_data_valid     ),
    .data_eop           (fft_r2d_data_eop       ),  
    .data_sop           (fft_r2d_data_sop       ),
    .sample_num         (sample_num             ),
    .chirp_num          (chirp_num              ),

    .data_win_o         (rfft_im_data_win       ),
    .data_valid_win_o   (rfft_im_data_valid_win ),
    .data_eop_win_o     (rfft_im_data_eop_win   ),
    .data_sop_win_o     (rfft_im_data_sop_win   )
);
wire [47:0]  rdmap_data  ;
wire         rdmap_valid ;
wire         rdmap_sop   ;
wire         rdmap_eop   ;

v_fft v_fft
(
    .clk                (clk                ),
    .rst                (rst                ),

    .data_in            ({rfft_im_data_win,rfft_re_data_win}),
    .data_valid         (rfft_im_data_valid_win             ),
    .data_sop           (rfft_im_data_sop_win               ),
    .data_eop           (rfft_im_data_eop_win               ),

    .sample_num         (sample_num         ),    
    .chirp_num          (chirp_num          ),    
    .config_trigger     (config_trigger     ),    

    .fft_data_o         (vfft_data          ),
    .fft_data_valid_o   (vfft_data_valid    ),
    .fft_data_tlast_o   (vfft_data_tlast    ),

    .rdmap_data         (rdmap_data         ),
    .rdmap_valid        (rdmap_valid        ),
    .rdmap_sop          (rdmap_sop          ),
    .rdmap_eop          (rdmap_eop          )
);

wire [63:0]     fir_rdmap       ;
wire            fir_rdmap_valid ;

fir_bank_top u_fir_bank_top(
    .sys_clk                (clk                    ),  //时钟
    .rst_n                  (~rst                   ),  //低复位
    .fir_in_valid           (fft_r2d_data_valid     ),  //输入有效标志-有效时间为32的整数倍 32clk*n
    .fir_in_data            (fft_r2d_data           ),  //输入数据 [31:16]虚部+[15:0]实部
    .fir_out_valid          (fir_valid              ),  //输出有效标志
    .fir_out_tlast          (fir_tlast              ),  
    .fir_out_dat            (fir_tdata              ),   //输出数据 [47:24]虚部+[23:0]实部 							  
	.o_rdamp_tlast          (                       ),
	.o_rdamp_tvalid         (fir_rdmap_valid        ),
	.o_rdamp_tdata          (fir_rdmap              )	
);                        

logLn_calc       U_logLn_calc(

    .clk_160mhz            (clk                  ) ,//160MH, 
    .rst                   (rst                  ) ,

    .fir_enable            (fir_enable           ) ,
    .cpie                  (i_cpie               ) ,
    .horizontal_pitch      (horizontal_pitch     ) ,
    .rdm_amp_data_valid    (rdmap_valid          ) ,
    .rdm_amp_data	       ({17'd0,rdmap_data}   ) ,
    .fir_rdmap             (fir_rdmap            ) ,
    .fir_rdmap_valid       (fir_rdmap_valid      ) ,
       
	.rdmap_log2_data_last  ( o_rdmap_log2_tlast  ) ,
    .rdmap_log2_data_valid ( o_rdmap_log2_tvalid ) ,
    .rdmap_log2_data       ( o_rdmap_log2_tdata  ) 
);
//-------------------------------------debug signal-----------------------------------------
reg [4:0]    fft_r_data_sop_cnt ;

always @(posedge clk) begin
    if(rst)
        fft_r_data_sop_cnt <= 'd0 ;
    else if(fft_r_data_sop)
        fft_r_data_sop_cnt <= fft_r_data_sop_cnt + 1'b1 ;
    else 
        fft_r_data_sop_cnt <= fft_r_data_sop_cnt ; 
end

reg [4:0]    rdmap_sop_cnt ;
always @(posedge clk) begin
    if(rst)
        rdmap_sop_cnt <= 'd0 ;
    else if(rdmap_sop)
        rdmap_sop_cnt <= rdmap_sop_cnt + 1'b1 ;
    else 
        rdmap_sop_cnt <= rdmap_sop_cnt ;
end

endmodule
module per_config 
(
//-------------------------clk_rst---------------------------------------------------
	input	wire			    rst	                ,
        input   wire                        clk_160m            ,              // adc system 160m  
	input	wire			    clk_100m		,              // ps clk 100m
//-------------------------寄存器接口-------------------------------------------------
        input   wire    [(16-1):0]          SirAddr             ,
        input   wire                        SirRead             ,
        input   wire    [31:0]              SirWdat             ,
        input   wire                        SirSel              ,
        output  wire                        SirDack             ,
        output  wire    [31:0]              SirRdat             ,
//--------------------------ADC-----------------------------------------------------

        // input   wire                        spi_adc3244_sdata_i ,
        // output  wire                        spi_adc3244_sdata_o ,
        output  wire                        spi_adc3663_sen_o   ,
        output  wire                        spi_adc3663_sclk_o  ,
        output  wire                        spi_adc3663_reset_o ,
        output  wire                        spi_adc3663_pdn_o   ,
        inout   wire                        spi_adc3663_sdio    ,
        output  wire                        spi_adc3663_irp     ,
        output wire                         adc_rst             ,
//-------------------------chc2442--------------------------------------------------
        input   wire                        spi_chc2442_sdata_i ,
        output  wire                        spi_chc2442_sdata_o ,
        output  wire                        spi_chc2442_sen_o   ,
        output  wire                        spi_chc2442_sclk_o  ,  
//---------------------------imx2492------------------------------------------------ 
        output wire                         lmx2492_mod_o       ,
        output wire                         spi_lmx2492_sclk_o  ,
        output wire                         spi_lmx2492_sdata_o ,
        output wire                         spi_lmx2492_sen_o   ,
        input  wire                         spi_lmx2492_sdata_i ,
        output wire                         lmx2492_irp         ,
        input  wire                         pll_ana_ad_p        ,
        input  wire                         pll_ana_ad_n        ,        
//--------------------------- 0808 -------------------------------------------------    
        input  wire  [4:0]                  awmf_sdi_i          ,
        output wire  [4:0]                  awmf_sdo_o          ,
        output wire  [4:0]                  awmf_pdo_o          ,
        output wire  [4:0]                  awmf_ldb_o          ,
        output wire  [4:0]                  awmf_csb_o          ,
        output wire  [4:0]                  awmf_clk_o          ,
        output wire  [9:0]                  awmf_mode_o         ,

        output wire                         PRI                 ,
        output wire                         CPIB                ,
        output wire                         CPIE                ,
        output wire                         sample_gate         ,
        output wire [15:0]                  PRI_PERIOD          ,
        output wire [15:0]                  START_SAMPLE        ,       
        output wire                         wr_irp              ,
        output wire                         rd_irp              
        
);

assign  spi_adc3663_pdn_o = 1'b0 ;
assign  lmx2492_mod_o     = PRI  ;
wire    clk_10m ;
wire    clk_25m ;

clk_div clk_div
(

        .clk_100m       (clk_100m       ),
        .rst            (rst            ),
    
        .clk_10m        (clk_10m        ),
        .clk_25m        (clk_25m        )
);
//-----------------------------------lmx2492------------------------------------------

wire            lmx2492_write_data_valid;
wire [23:0]     lmx2492_write_data      ;
wire [7:0]      lmx2492_batch_wr        ;
wire [3:0]      lmx2492_batch_rd        ;

wire [22:0]     lmx2492_reg0            ;
wire [22:0]     lmx2492_reg1            ;
wire [22:0]     lmx2492_reg2            ;
wire [22:0]     lmx2492_reg3            ;
wire [22:0]     lmx2492_reg4            ;
wire [22:0]     lmx2492_reg5            ;
wire [22:0]     lmx2492_reg6            ;
wire [22:0]     lmx2492_reg7            ;
wire [22:0]     lmx2492_reg8            ;
wire [22:0]     lmx2492_reg9            ;
wire [15:0]     pll_ana_ad              ;
//------------------------------------3244-------------------------------------------
wire            adc_3244_write_data_valid ;
wire [24:0]     adc_3244_write_data       ;
wire [22:0]     adc_3244_reg0             ;

//-----------------------------------chc2442-----------------------------------------
wire            chc2442_write_data_valid ;
wire [24:0]     chc2442_write_data       ;
wire [31:0]     chc2422_reg0             ;

//--------------------------------------awmf-----------------------------------------
wire 	        u0_write_data_en         ;
wire  [31:0]	u0_write_data_in         ;
wire 		u1_write_data_en         ;
wire  [31:0]	u1_write_data_in         ;
wire 		u2_write_data_en         ;
wire  [31:0]	u2_write_data_in         ;
wire 		u3_write_data_en         ;
wire  [31:0]	u3_write_data_in         ;
wire 		u4_write_data_en         ;
wire  [31:0]	u4_write_data_in         ;
wire  [31:0]	awmf0165_ctr             ;
wire  [3 :0]    u8_awmf0165_ctr          ;
wire  [1 :0]    u8_awmf0165_select       ;
wire  [31:0]    awmf0165_select          ;
wire  [255:0]   u0_awmf0165_reg          ;       
wire  [255:0]   u1_awmf0165_reg          ;  
wire  [255:0]   u2_awmf0165_reg          ;  
wire  [255:0]   u3_awmf0165_reg          ;
wire  [255:0]   u4_awmf0165_reg          ;
//------------------------------------timing-----------------------------------------
wire            cpie                     ;
wire    [31:0]  CPI_DELAY                ;
wire    [7:0]   PRI_NUM                  ;
wire    [7:0]   PRI_PULSE_WIDTH          ;
wire    [15:0]  SAMPLE_LENGTH            ;
wire    [7 :0]  WAVE_CODE                ;

wire 	        Rx_En                    ;
wire 	        Tx_En                    ;
wire            awmf0165_pspl_select     ;
wire  [7 :0]    awmf_0165_status         ;
wire            first_chrip_disable      ;
wire  [15:0]    temperature              ;

csr00 csr00
(
        .rst            (rst            ),
        .clk            (clk_100m       ),

        .SirAddr        (SirAddr        ),
        .SirRead        (SirRead        ),
        .SirWdat        (SirWdat        ),
        .SirSel         (SirSel         ),
        .SirDack        (SirDack        ),
        .SirRdat        (SirRdat        ),
//----------------------------lmx2492----------------------------------------------
        .lmx2492_write_data_valid(lmx2492_write_data_valid),
        .lmx2492_write_data      (lmx2492_write_data      ),
        .lmx2492_batch_wr        (lmx2492_batch_wr        ),
        .lmx2492_batch_rd        (lmx2492_batch_rd        ),
        .lmx2492_reg0            (lmx2492_reg0            ),
        .lmx2492_reg1            (lmx2492_reg1            ),
        .lmx2492_reg2            (lmx2492_reg2            ),
        .lmx2492_reg3            (lmx2492_reg3            ),
        .lmx2492_reg4            (lmx2492_reg4            ),
        .lmx2492_reg5            (lmx2492_reg5            ),
        .lmx2492_reg6            (lmx2492_reg6            ),
        .lmx2492_reg7            (lmx2492_reg7            ),
        .lmx2492_reg8            (lmx2492_reg8            ),
        .lmx2492_reg9            (lmx2492_reg9            ),
        .pll_ana_ad              (pll_ana_ad              ),
//--------------------------adc_3244-------------------------------------------------
        .adc_3244_write_data_valid      (adc_3244_write_data_valid),
        .adc_3244_write_data            (adc_3244_write_data      ),
        .adc_3244_reg0                  (adc_3244_reg0            ),

//--------------------------chc2422--------------------------------------------------
        .chc2442_write_data_valid       (chc2442_write_data_valid),
        .chc2442_write_data             (chc2442_write_data      ),      
        .chc2422_reg0                   (chc2422_reg0            ),

//--------------------------awmf0165-------------------------------------------------
        .u8_awmf0165_select             (u8_awmf0165_select      ),
        .awmf0165_ctr                   (awmf0165_ctr            ),
        .u8_awmf0165_ctr                (u8_awmf0165_ctr         ),
        .awmf0165_pspl_select           (awmf0165_pspl_select    ),
        .awmf0165_select                (awmf0165_select         ),
        .u0_write_data_en               (u0_write_data_en        ),
        .u0_write_data_in               (u0_write_data_in        ),
        .u1_write_data_en               (u1_write_data_en        ),
        .u1_write_data_in               (u1_write_data_in        ),
        .u2_write_data_en               (u2_write_data_en        ),
        .u2_write_data_in               (u2_write_data_in        ),
        .u3_write_data_en               (u3_write_data_en        ),
        .u3_write_data_in               (u3_write_data_in        ),
        .u4_write_data_en               (u4_write_data_en        ),
        .u4_write_data_in               (u4_write_data_in        ),
        .u0_awmf0165_reg                (u0_awmf0165_reg         ),
        .u1_awmf0165_reg                (u1_awmf0165_reg         ),
        .u2_awmf0165_reg                (u2_awmf0165_reg         ),
        .u3_awmf0165_reg                (u3_awmf0165_reg         ),
        .u4_awmf0165_reg                (u4_awmf0165_reg         ),
        .awmf_0165_status               (awmf_0165_status        ),
        .temperature                    (temperature             ),
        
//-----------------------------timging----------------------------------------------
        .CPI_DELAY_sync                 (CPI_DELAY               ),
        .PRI_PERIOD_sync                (PRI_PERIOD              ),
        .PRI_NUM_sync                   (PRI_NUM                 ),
        .PRI_PULSE_WIDTH_sync           (PRI_PULSE_WIDTH         ),
        .START_SAMPLE_sync              (START_SAMPLE            ),
        .SAMPLE_LENGTH_sync             (SAMPLE_LENGTH           ),
        .first_chrip_disable            (first_chrip_disable     )
);

//------------------------------lmx2492--------------------------------------------
lmx2492_ctr_top lmx2492_ctr_top
(
        .rst                    (rst                     ),
        .clk                    (clk_100m                ),
        .clk_10m                (clk_10m                 ),
//-----------------------------------------------------------------

        .write_data_valid       (lmx2492_write_data_valid),
        .write_data_in          (lmx2492_write_data      ),
        .lmx2492_batch_wr       (lmx2492_batch_wr        ),
        .lmx2492_batch_rd       (lmx2492_batch_rd        ),
//-----------------------------------------------------------------
        .reg0	                (lmx2492_reg0            ),
        .reg1	                (lmx2492_reg1            ),
        .reg2	                (lmx2492_reg2            ),
        .reg3	                (lmx2492_reg3            ),
        .reg4	                (lmx2492_reg4            ),
        .reg5	                (lmx2492_reg5            ),
        .reg6	                (lmx2492_reg6            ),
        .reg7	                (lmx2492_reg7            ),
        .reg8	                (lmx2492_reg8            ),
        .reg9	                (lmx2492_reg9            ),
        .irp                    (lmx2492_irp             ),
//-----------------------------------------------------------------
        .spi_lmx2492_sclk_o     (spi_lmx2492_sclk_o      ),
        .spi_lmx2492_sdata_o    (spi_lmx2492_sdata_o     ),	 
        .spi_lmx2492_sen_o      (spi_lmx2492_sen_o       ),									    
        .spi_lmx2492_sdata_i    (spi_lmx2492_sdata_i     )
);

//------------------------------adc3244----------------------------
adc_3663_ctr adc_3663_ctr
(
//-----------------------------------------------------------------
        .rst              (rst                  ),
        .clk              (clk_100m             ),
        .clk_10m          (clk_10m              ),
//-----------------------------------------------------------------
        .write_data_valid (adc_3244_write_data_valid),
        .write_data_in    (adc_3244_write_data  ),
//-----------------------------------------------------------------
        .reg0             (adc_3244_reg0        ),
        .irp              (adc_3244_irp         ),
//-----------------------------------------------------------------
        // .spi_sdata_o      (spi_adc3244_sdata_o  ),
        .spi_sen_o        (spi_adc3663_sen_o    ),
        .spi_clk_o        (spi_adc3663_sclk_o   ),
        .spi_reset_o      (spi_adc3663_reset_o  ),
        .spi_sdio         (spi_adc3663_sdio     ),
        .adc_rst          (adc_rst              )
        // .spi_sdout_i      (spi_adc3244_sdata_i  )
);


chc2442_ctr_top chc2442_ctr_top
(
        .rst              (rst                          ),
        .clk              (clk_100m                     ),
        .clk_10m          (clk_10m                      ),
    
        .write_data_valid (chc2442_write_data_valid     ),
        .write_data_in    (chc2442_write_data           ),
    
        .reg0	          (chc2422_reg0                 ),
        .irp              (                             ),
    
        .spi_sdata_o      (spi_chc2442_sdata_o          ),
        .spi_sen_o        (spi_chc2442_sen_o            ),
        .spi_clk_o        (spi_chc2442_sclk_o           ),
        .spi_reset_o      (                             ),
        .spi_sdout_i      (spi_chc2442_sdata_i          )
);

awmf_0165_top awmf_0165_top 
(
        .clk               (clk_100m                    ),
        .rst               (rst                         ),

        .clk_20m           (clk_25m                     ),	
        .cpie_i	           (CPIE                        ),

        .Rx_En             (Rx_En                       ),
        .Tx_En             (Tx_En                       ),
        .awmf0165_pspl_select(awmf0165_pspl_select      ),
        
        .awmf0165_ctr      (awmf0165_ctr                ),
        .u8_awmf0165_ctr   (u8_awmf0165_ctr             ),
        .u8_awmf0165_select(u8_awmf0165_select          ),
        .awmf0165_select   (awmf0165_select             ),
        .u0_write_data_en  (u0_write_data_en            ),
        .u0_write_data_in  (u0_write_data_in            ),
        .u1_write_data_en  (u1_write_data_en            ),
        .u1_write_data_in  (u1_write_data_in            ),
        .u2_write_data_en  (u2_write_data_en            ),
        .u2_write_data_in  (u2_write_data_in            ),
        .u3_write_data_en  (u3_write_data_en            ),
        .u3_write_data_in  (u3_write_data_in            ),
        .u4_write_data_en  (u4_write_data_en            ),
        .u4_write_data_in  (u4_write_data_in            ),

        .awmf_sdi_i        (awmf_sdi_i                  ),
        .awmf_sdo_o        (awmf_sdo_o                  ),
        .awmf_pdo_o        (awmf_pdo_o                  ),
        .awmf_ldb_o        (awmf_ldb_o                  ),
        .awmf_csb_o        (awmf_csb_o                  ),
        .awmf_clk_o        (awmf_clk_o                  ),
        .awmf_mode_o       (awmf_mode_o                 ),
        .u0_awmf0165_reg   (u0_awmf0165_reg             ),
        .u1_awmf0165_reg   (u1_awmf0165_reg             ),
        .u2_awmf0165_reg   (u2_awmf0165_reg             ),
        .u3_awmf0165_reg   (u3_awmf0165_reg             ),
        .u4_awmf0165_reg   (u4_awmf0165_reg             ),
        .wr_irp            (wr_irp                      ),
        .rd_irp            (rd_irp                      ),
        .awmf_0165_status  (awmf_0165_status            )  
                  
);
wire adc_clk_20m ;

BUFGCE_DIV #(
        .BUFGCE_DIVIDE(8),              // 1-8
        // Programmable Inversion Attributes: Specifies built-in programmable inversion on specific pins
        .IS_CE_INVERTED(1'b0),          // Optional inversion for CE
        .IS_CLR_INVERTED(1'b0),         // Optional inversion for CLR
        .IS_I_INVERTED(1'b0),           // Optional inversion for I
        .SIM_DEVICE("ULTRASCALE_PLUS")  // ULTRASCALE, ULTRASCALE_PLUS
     )
     BUFGCE_DIV_inst (
        .O      (adc_clk_20m          ),     // 1-bit output: Buffer
        .CE     (1'b1                 ),   // 1-bit input: Buffer enable
        .CLR    (1'b0                 ), // 1-bit input: Asynchronous clear
        .I      (clk_160m             )      // 1-bit input: Buffer
     );

timing timing_inst(
    .sys_clk                (adc_clk_20m                ),//20MHz,from ADC3244
    .rstn                   (  ~rst                     ),
    .CPI_DELAY              (  CPI_DELAY                ),//CPI延时周期数
    .PRI_PERIOD             (  PRI_PERIOD               ),//PRT周期数
    .PRI_NUM                (  PRI_NUM                  ),//每个处理周期内pri个数
    .PRI_PULSE_WIDTH        (  PRI_PULSE_WIDTH          ),//PRI脉冲宽度
    .first_chrip_disable    (first_chrip_disable        ),
    .PRI                    (  PRI                      ),//每个重复周期的起始时刻//235us,一帧中的chirp开始信号
    .CPIB                   (  CPIB                     ),//CPI BEGIN  在新的状态参数下，新的处理周期开始
    .CPIE                   (  CPIE                     ),//CPI END ，用于触发波控数据传输，并更新 
    .START_SAMPLE           (  START_SAMPLE             ),//ADC起始采样点
    .SAMPLE_LENGTH          (  SAMPLE_LENGTH            ),//ADC采样深度
    .sample_gate            (  sample_gate              ),//采样波门，4096个时钟
    .Tx_En                  (  Tx_En                    ),//发射使能信号
    .Rx_En                  (  Rx_En                    ),//接收使能信号
    .WAVE_CODE              (  WAVE_CODE                )

);
`ifndef SIM
sysmon sysmon
(
    .clk                (clk_100m       ),
    .rst                (rst            ),
    .VAUXN              ({7'd0,pll_ana_ad_n,8'd0}),
    .VAUXP              ({7'd0,pll_ana_ad_p,8'd0}),
    .temperature        (temperature    ),
    .ADC_DATA_CH0       (               ),
    .ADC_DATA_CH1       (               ),
    .ADC_DATA_CH2       (               ),
    .ADC_DATA_CH3       (               ),
    .ADC_DATA_CH4       (               ),
    .ADC_DATA_CH5       (               ),
    .ADC_DATA_CH6       (               ),
    .ADC_DATA_CH7       (               ),
    .ADC_DATA_CH8       (pll_ana_ad     ),
    .ADC_DATA_CH9       (               ),
    .ADC_DATA_CH10      (               ),
    .ADC_DATA_CH11      (               ),
    .ADC_DATA_CH12      (               ),
    .ADC_DATA_CH13      (               ),
    .ADC_DATA_CH14      (               ),
    .ADC_DATA_CH15      (               )
);
`else
`endif
endmodule

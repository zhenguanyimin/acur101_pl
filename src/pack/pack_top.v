module pack_top
(

//----------------------------------clk_rst-------------------------------
	input	wire	            rst		        ,
	input	wire	            clk		        ,
        input   wire                ps_clk_200m         ,
        input   wire                clk_100m            ,

        input   wire                pri                 ,
        input   wire                cpib                ,
        input   wire                cpie                ,
   
        output  wire                ddr_test_start      ,
        output  wire    [31:0]      test_len            ,


        input   wire    [15:0]      SirAddr             ,
        input   wire                SirRead             ,
        input   wire    [31:0]      SirWdat             ,
        input   wire                SirSel              ,
        output  wire                SirDack             ,
        output  wire    [31:0]      SirRdat             ,

//-------------------------------------dsp--------------------------------

        input   wire    [31:0]      s_axis_pl2ps_rdm_tdata   ,
        input                       s_axis_pl2ps_rdm_tlast   ,
        input                       s_axis_pl2ps_rdm_tvalid  ,

        input   wire    [31:0]      s_axis_pl2ps_adc_tdata   ,
        input                       s_axis_pl2ps_adc_tlast   ,
        input                       s_axis_pl2ps_adc_tvalid  ,

        input   wire    [31:0]      s_axis_pl2ps_ch0_tdata   ,
        input                       s_axis_pl2ps_ch0_tlast   ,
        input                       s_axis_pl2ps_ch0_tvalid  ,

        input   wire    [31:0]      s_axis_pl2ps_ch1_tdata   ,
        input                       s_axis_pl2ps_ch1_tlast   ,
        input                       s_axis_pl2ps_ch1_tvalid  ,

        input   wire    [31:0]      s_axis_pl2ps_ch2_tdata   ,
        input                       s_axis_pl2ps_ch2_tlast   ,
        input                       s_axis_pl2ps_ch2_tvalid  ,

        input   wire    [31:0]      s_axis_pl2ps_ch3_tdata   ,
        input                       s_axis_pl2ps_ch3_tlast   ,
        input                       s_axis_pl2ps_ch3_tvalid  ,

        input   wire    [31:0]      s_axis_pl2ps_ch4_tdata   ,
        input                       s_axis_pl2ps_ch4_tlast   ,
        input                       s_axis_pl2ps_ch4_tvalid  ,

        input   wire    [31:0]      s_axis_pl2ps_ch5_tdata   ,
        input                       s_axis_pl2ps_ch5_tlast   ,
        input                       s_axis_pl2ps_ch5_tvalid  ,
//------------------------------ps2pl----------------------------------------

        output   wire    [31:0]     m_axis_ps2pl_tdata       ,
        output   wire    [3 :0]     m_axis_ps2pl_tkeep       ,
        output                      m_axis_ps2pl_tlast       ,
        input                       m_axis_ps2pl_tready      ,
        output                      m_axis_ps2pl_tvalid      ,    


//---------------------------------output-------------------------------
        output   wire    [31:0]      m_axis_pl2ps_dma0_tdata ,
        output   wire    [3 :0]      m_axis_pl2ps_dma0_tkeep ,
        output                       m_axis_pl2ps_dma0_tlast ,
        input                        m_axis_pl2ps_dma0_tready,
        output                       m_axis_pl2ps_dma0_tvalid,

        output   wire    [31:0]      m_axis_pl2ps_dma1_tdata ,
        output   wire    [3 :0]      m_axis_pl2ps_dma1_tkeep ,
        output                       m_axis_pl2ps_dma1_tlast ,
        input                        m_axis_pl2ps_dma1_tready,
        output                       m_axis_pl2ps_dma1_tvalid,

        input   wire    [31:0]       s_axis_ps2pl_dma0_tdata ,
        input   wire    [3 :0]       s_axis_ps2pl_dma0_tkeep ,
        input                        s_axis_ps2pl_dma0_tlast ,
        output                       s_axis_ps2pl_dma0_tready,
        input                        s_axis_ps2pl_dma0_tvalid,

        input   wire    [31:0]       s_axis_ps2pl_dma1_tdata ,
        input   wire    [3 :0]       s_axis_ps2pl_dma1_tkeep ,
        input                        s_axis_ps2pl_dma1_tlast ,
        output                       s_axis_ps2pl_dma1_tready,
        input                        s_axis_ps2pl_dma1_tvalid     

);

wire    [15:0]  mux_ctr     ;
wire            dma_restart ;

pl2ps_axis_engine pl2ps_axis_engine
(
        .rst                            (rst                    ),
        .clk                            (clk                    ),
        .ps_clk_200m                    (ps_clk_200m            ),

        .mux_ctr                        (mux_ctr                ),
        .pri                            (pri                    ),
        .cpib                           (cpib                   ),
        .cpie                           (cpie                   ),
        .dma_restart                    (dma_restart            ),

        .s_axis_pl2ps_adc_tdata         (s_axis_pl2ps_adc_tdata ),
        .s_axis_pl2ps_adc_tlast         (s_axis_pl2ps_adc_tlast ),
        .s_axis_pl2ps_adc_tvalid        (s_axis_pl2ps_adc_tvalid),   
        
        .s_axis_pl2ps_rdm_tdata         (s_axis_pl2ps_rdm_tdata ),
        .s_axis_pl2ps_rdm_tlast         (s_axis_pl2ps_rdm_tlast ),
        .s_axis_pl2ps_rdm_tvalid        (s_axis_pl2ps_rdm_tvalid),

        .s_axis_pl2ps_ch0_tdata         (s_axis_pl2ps_ch0_tdata ),
        .s_axis_pl2ps_ch0_tlast         (s_axis_pl2ps_ch0_tlast ),
        .s_axis_pl2ps_ch0_tvalid        (s_axis_pl2ps_ch0_tvalid),

        .s_axis_pl2ps_ch1_tdata         (s_axis_pl2ps_ch1_tdata ),
        .s_axis_pl2ps_ch1_tlast         (s_axis_pl2ps_ch1_tlast ),
        .s_axis_pl2ps_ch1_tvalid        (s_axis_pl2ps_ch1_tvalid),

        .s_axis_pl2ps_ch2_tdata         (s_axis_pl2ps_ch2_tdata ),
        .s_axis_pl2ps_ch2_tlast         (s_axis_pl2ps_ch2_tlast ),
        .s_axis_pl2ps_ch2_tvalid        (s_axis_pl2ps_ch2_tvalid),

        .s_axis_pl2ps_ch3_tdata         (s_axis_pl2ps_ch3_tdata ),
        .s_axis_pl2ps_ch3_tlast         (s_axis_pl2ps_ch3_tlast ),
        .s_axis_pl2ps_ch3_tvalid        (s_axis_pl2ps_ch3_tvalid),

        .s_axis_pl2ps_ch4_tdata         (s_axis_pl2ps_ch4_tdata ),
        .s_axis_pl2ps_ch4_tlast         (s_axis_pl2ps_ch4_tlast ),
        .s_axis_pl2ps_ch4_tvalid        (s_axis_pl2ps_ch4_tvalid),

        .s_axis_pl2ps_ch5_tdata         (s_axis_pl2ps_ch5_tdata ),
        .s_axis_pl2ps_ch5_tlast         (s_axis_pl2ps_ch5_tlast ),
        .s_axis_pl2ps_ch5_tvalid        (s_axis_pl2ps_ch5_tvalid),

        .m_axis_pl2ps_dma0_tdata        (m_axis_pl2ps_dma0_tdata ),
        .m_axis_pl2ps_dma0_tkeep        (m_axis_pl2ps_dma0_tkeep ),
        .m_axis_pl2ps_dma0_tlast        (m_axis_pl2ps_dma0_tlast ),
        .m_axis_pl2ps_dma0_tready       (m_axis_pl2ps_dma0_tready),
        .m_axis_pl2ps_dma0_tvalid       (m_axis_pl2ps_dma0_tvalid),

        .m_axis_pl2ps_dma1_tdata        (m_axis_pl2ps_dma1_tdata ),
        .m_axis_pl2ps_dma1_tkeep        (m_axis_pl2ps_dma1_tkeep ),
        .m_axis_pl2ps_dma1_tlast        (m_axis_pl2ps_dma1_tlast ),
        .m_axis_pl2ps_dma1_tready       (m_axis_pl2ps_dma1_tready),
        .m_axis_pl2ps_dma1_tvalid       (m_axis_pl2ps_dma1_tvalid)
);

ps2pl_axis_engine ps2pl_axis_engine
(

        .rst                            (rst                     ),    
        .clk                            (clk                     ),
        .ps_clk_200m                    (ps_clk_200m             ),

        .s_axis_ps2pl_dma0_tdata        (s_axis_ps2pl_dma0_tdata ),
        .s_axis_ps2pl_dma0_tkeep        (s_axis_ps2pl_dma0_tkeep ),
        .s_axis_ps2pl_dma0_tlast        (s_axis_ps2pl_dma0_tlast ),
        .s_axis_ps2pl_dma0_tready       (s_axis_ps2pl_dma0_tready),
        .s_axis_ps2pl_dma0_tvalid       (s_axis_ps2pl_dma0_tvalid),

        .s_axis_ps2pl_dma1_tdata        (s_axis_ps2pl_dma1_tdata ),
        .s_axis_ps2pl_dma1_tkeep        (s_axis_ps2pl_dma1_tkeep ),
        .s_axis_ps2pl_dma1_tlast        (s_axis_ps2pl_dma1_tlast ),
        .s_axis_ps2pl_dma1_tready       (s_axis_ps2pl_dma1_tready),
        .s_axis_ps2pl_dma1_tvalid       (s_axis_ps2pl_dma1_tvalid),
        
        .m_axis_ps2pl_tdata             (m_axis_ps2pl_tdata      ),
        .m_axis_ps2pl_tkeep             (m_axis_ps2pl_tkeep      ),
        .m_axis_ps2pl_tlast             (m_axis_ps2pl_tlast      ),
        .m_axis_ps2pl_tready            (m_axis_ps2pl_tready     ),
        .m_axis_ps2pl_tvalid            (m_axis_ps2pl_tvalid     )


);

csr03 csr03
(
        .rst            (rst                 ),
        .clk            (clk_100m            ),
        .SirAddr        (SirAddr             ),
        .SirRead        (SirRead             ),
        .SirWdat        (SirWdat             ),
        .SirSel         (SirSel              ),
        .SirDack        (SirDack             ),
        .SirRdat        (SirRdat             ),
        .mux_ctr        (mux_ctr             ),
        .dma_restart    (dma_restart         ),
        .ddr_test_start (ddr_test_start      ),
        .test_len       (test_len            )
);

endmodule
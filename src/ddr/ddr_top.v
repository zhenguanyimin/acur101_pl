module ddr_top
(
    input   wire        clk                ,
    input   wire        rst                ,
    input   wire        ddr_clk            ,

    input   wire [63:0] fifo_din_cmd_ch0   ,
    input   wire        fifo_wr_en_cmd_ch0 ,
    output  wire        fifo_full_cmd_ch0  ,
    
    input   wire        fifo_wr_en_wr_ch0  ,
    input   wire [127:0]fifo_din_wr_ch0    ,
    output  wire        fifo_full_wr_ch0   ,

    input   wire [63:0] fifo_din_cmd_ch1   ,
    input   wire        fifo_wr_en_cmd_ch1,
    output  wire        fifo_full_cmd_ch1  ,
    
    input   wire        fifo_wr_en_wr_ch1  ,
    input   wire [127:0]fifo_din_wr_ch1    ,
    output  wire        fifo_full_wr_ch1   ,

    input   wire [63:0] fifo_din_cmd_ch2   ,
    input   wire        fifo_wr_en_cmd_ch2 ,
    output  wire        fifo_full_cmd_ch2  ,
    
    input   wire        fifo_wr_en_wr_ch2  ,
    input   wire [127:0]fifo_din_wr_ch2    ,
    output  wire        fifo_full_wr_ch2   ,

    input   wire [63:0] fifo_din_cmd_ch3   ,
    input   wire        fifo_wr_en_cmd_ch3 ,
    output  wire        fifo_full_cmd_ch3  ,

    output  wire [127:0]fifo_dout_rd_ch3   ,
    input   wire        fifo_rd_en_rd_ch3  ,
    output  wire        fifo_empty_rd_ch3  ,
    output  wire        fifo_full_rd_ch3   ,

    input   wire [63:0] fifo_din_cmd_ch4   ,
    input   wire        fifo_wr_en_cmd_ch4 ,
    output  wire        fifo_full_cmd_ch4  ,
    
    input   wire        fifo_wr_en_wr_ch4  ,
    input   wire [127:0]fifo_din_wr_ch4    ,
    output  wire        fifo_full_wr_ch4   ,

    output [48: 0]      m_axi_araddr   ,
    output [1 : 0]      m_axi_arburst  ,
    output [3 : 0]      m_axi_arcache  ,
    output [5 : 0]      m_axi_arid     ,
    output [7 : 0]      m_axi_arlen    ,
    output              m_axi_arlock   ,
    output [2 : 0]      m_axi_arprot   ,
    output [3 : 0]      m_axi_arqos    ,
    input               m_axi_arready  ,
    output [2:0]        m_axi_arsize   ,
    output              m_axi_aruser   ,
    output              m_axi_arvalid  ,

// aw ch 
    output [48: 0]      m_axi_awaddr    ,
    output [1 : 0]      m_axi_awburst   ,
    output [3 : 0]      m_axi_awcache   ,
    output [5 : 0]      m_axi_awid      ,
    output [7 : 0]      m_axi_awlen     ,
    output              m_axi_awlock    ,
    output [2 : 0]      m_axi_awprot    ,
    output [3 : 0]      m_axi_awqos     ,
    input               m_axi_awready   ,
    output [2 : 0]      m_axi_awsize    ,
    output              m_axi_awuser    ,
    output              m_axi_awvalid   ,

    // response     
    input [5 : 0]       m_axi_bid       ,
    output              m_axi_bready    ,
    input [1 : 0]       m_axi_bresp     ,
    input               m_axi_bvalid    ,

// rd ch 
    input [127: 0]      m_axi_rdata     ,
    input [5 : 0]       m_axi_rid       ,
    input               m_axi_rlast     ,
    output              m_axi_rready    ,
    input [1 : 0]       m_axi_rresp     ,
    input               m_axi_rvalid    ,

// wr ch 
    output [127: 0]     m_axi_wdata     ,
    output              m_axi_wlast     ,
    input               m_axi_wready    ,
    output [15 : 0]     m_axi_wstrb     ,
    output              m_axi_wvalid
);

ps_ddr_top ps_ddr_top
(
    .clk                (clk                ),
    .rst                (rst                ),
    .ddr_clk            (ddr_clk            ),

    .fifo_din_cmd_ch0   (fifo_din_cmd_ch0   ),
    .fifo_wr_en_cmd_ch0 (fifo_wr_en_cmd_ch0 ),
    .fifo_full_cmd_ch0  (fifo_full_cmd_ch0  ),

    .fifo_wr_en_wr_ch0  (fifo_wr_en_wr_ch0  ),
    .fifo_din_wr_ch0    (fifo_din_wr_ch0    ),
    .fifo_full_wr_ch0   (fifo_full_wr_ch0   ),

    .fifo_din_cmd_ch1   (fifo_din_cmd_ch1   ),
    .fifo_wr_en_cmd_ch1 (fifo_wr_en_cmd_ch1 ),
    .fifo_full_cmd_ch1  (fifo_full_cmd_ch1  ),

    .fifo_wr_en_wr_ch1  (fifo_wr_en_wr_ch1  ),
    .fifo_din_wr_ch1    (fifo_din_wr_ch1    ),
    .fifo_full_wr_ch1   (fifo_full_wr_ch1   ),

    .fifo_din_cmd_ch2   (fifo_din_cmd_ch2   ),
    .fifo_wr_en_cmd_ch2 (fifo_wr_en_cmd_ch2 ),
    .fifo_full_cmd_ch2  (fifo_full_cmd_ch2  ),

    .fifo_wr_en_wr_ch2  (fifo_wr_en_wr_ch2  ),
    .fifo_din_wr_ch2    (fifo_din_wr_ch2    ),
    .fifo_full_wr_ch2   (fifo_full_wr_ch2   ),

    .fifo_din_cmd_ch3   (fifo_din_cmd_ch3   ),
    .fifo_wr_en_cmd_ch3 (fifo_wr_en_cmd_ch3 ),
    .fifo_full_cmd_ch3  (fifo_full_cmd_ch3  ),

    .fifo_dout_rd_ch3   (fifo_dout_rd_ch3   ),
    .fifo_rd_en_rd_ch3  (fifo_rd_en_rd_ch3  ),
    .fifo_empty_rd_ch3  (fifo_empty_rd_ch3  ),
    .fifo_full_rd_ch3   (fifo_full_rd_ch3   ),

    .fifo_din_cmd_ch4   (fifo_din_cmd_ch4   ),
    .fifo_wr_en_cmd_ch4 (fifo_wr_en_cmd_ch4 ),
    .fifo_full_cmd_ch4  (fifo_full_cmd_ch4  ),

    .fifo_wr_en_wr_ch4  (fifo_wr_en_wr_ch4  ),
    .fifo_din_wr_ch4    (fifo_din_wr_ch4    ),
    .fifo_full_wr_ch4   (fifo_full_wr_ch4   ),
// ar

    .m_axi_araddr       (m_axi_araddr       ),
    .m_axi_arburst      (m_axi_arburst      ),
    .m_axi_arcache      (m_axi_arcache      ),
    .m_axi_arid         (m_axi_arid         ),
    .m_axi_arlen        (m_axi_arlen        ),
    .m_axi_arlock       (m_axi_arlock       ),
    .m_axi_arprot       (m_axi_arprot       ),
    .m_axi_arqos        (m_axi_arqos        ),
    .m_axi_arready      (m_axi_arready      ),
    .m_axi_arsize       (m_axi_arsize       ),
    .m_axi_aruser       (m_axi_aruser       ),
    .m_axi_arvalid      (m_axi_arvalid      ),

// aw ch 
    .m_axi_awaddr       (m_axi_awaddr       ),
    .m_axi_awburst      (m_axi_awburst      ),
    .m_axi_awcache      (m_axi_awcache      ),
    .m_axi_awid         (m_axi_awid         ),
    .m_axi_awlen        (m_axi_awlen        ),
    .m_axi_awlock       (m_axi_awlock       ),
    .m_axi_awprot       (m_axi_awprot       ),
    .m_axi_awqos        (m_axi_awqos        ),
    .m_axi_awready      (m_axi_awready      ),
    .m_axi_awsize       (m_axi_awsize       ),
    .m_axi_awuser       (m_axi_awuser       ),
    .m_axi_awvalid      (m_axi_awvalid      ),

// response     
    .m_axi_bid          (m_axi_bid          ),
    .m_axi_bready       (m_axi_bready       ),
    .m_axi_bresp        (m_axi_bresp        ),
    .m_axi_bvalid       (m_axi_bvalid       ),

// rd ch 
    .m_axi_rdata        (m_axi_rdata        ),
    .m_axi_rid          (m_axi_rid          ),
    .m_axi_rlast        (m_axi_rlast        ),
    .m_axi_rready       (m_axi_rready       ),
    .m_axi_rresp        (m_axi_rresp        ),
    .m_axi_rvalid       (m_axi_rvalid       ),

// wr ch 
    .m_axi_wdata        (m_axi_wdata        ),
    .m_axi_wlast        (m_axi_wlast        ),
    .m_axi_wready       (m_axi_wready       ),
    .m_axi_wstrb        (m_axi_wstrb        ),
    .m_axi_wvalid       (m_axi_wvalid       )
);

endmodule 

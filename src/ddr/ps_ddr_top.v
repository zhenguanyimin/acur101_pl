module ps_ddr_top
(
    input   wire        clk ,
    input   wire        rst , 
    
    input   wire [63:0] fifo_din_cmd_ch0   ,
    input   wire        fifo_wr_en_cmd_ch0 ,
    output  wire        fifo_full_cmd_ch0  ,

    input   wire        fifo_wr_en_wr_ch0  ,
    input   wire [127:0]fifo_din_wr_ch0    ,
    output  wire        fifo_full_wr_ch0   ,

    input   wire [63:0] fifo_din_cmd_ch1   ,
    input   wire        fifo_wr_en_cmd_ch1 ,
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
// ar
    input   wire        ddr_clk        ,
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
assign m_axi_arid[5:3] = 'd0;
assign m_axi_awid[5:3] = 'd0;

//---------------------------ch0--------------------------------------
wire [48: 0]      s_axi_ch0_araddr   ;
wire [1 : 0]      s_axi_ch0_arburst  ;
wire [3 : 0]      s_axi_ch0_arcache  ;
wire [5 : 0]      s_axi_ch0_arid     ;
wire [7 : 0]      s_axi_ch0_arlen    ;
wire              s_axi_ch0_arlock   ;
wire [2 : 0]      s_axi_ch0_arprot   ;
wire [3 : 0]      s_axi_ch0_arqos    ;
wire              s_axi_ch0_arready  ;
wire [2:0]        s_axi_ch0_arsize   ;
wire              s_axi_ch0_aruser   ;
wire              s_axi_ch0_arvalid  ;

wire [48: 0]      s_axi_ch0_awaddr   ;
wire [1 : 0]      s_axi_ch0_awburst  ;
wire [3 : 0]      s_axi_ch0_awcache  ;
wire [5 : 0]      s_axi_ch0_awid     ;
wire [7 : 0]      s_axi_ch0_awlen    ;
wire              s_axi_ch0_awlock   ;
wire [2 : 0]      s_axi_ch0_awprot   ;
wire [3 : 0]      s_axi_ch0_awqos    ;
wire              s_axi_ch0_awready  ;
wire [2 : 0]      s_axi_ch0_awsize   ;
wire              s_axi_ch0_awuser   ;
wire              s_axi_ch0_awvalid  ;

wire [5 : 0]      s_axi_ch0_bid      ;
wire              s_axi_ch0_bready   ;
wire [1 : 0]      s_axi_ch0_bresp    ;
wire              s_axi_ch0_bvalid   ;

wire [127: 0]     s_axi_ch0_rdata    ;
wire [5 : 0]      s_axi_ch0_rid      ;
wire              s_axi_ch0_rlast    ;
wire              s_axi_ch0_rready   ;
wire [1 : 0]      s_axi_ch0_rresp    ;
wire              s_axi_ch0_rvalid   ;

wire [127: 0]     s_axi_ch0_wdata    ;
wire              s_axi_ch0_wlast    ;
wire              s_axi_ch0_wready   ;
wire [15 : 0]     s_axi_ch0_wstrb    ;
wire              s_axi_ch0_wvalid   ;

//---------------------------ch1--------------------------------------
wire [48: 0]      s_axi_ch1_araddr   ;
wire [1 : 0]      s_axi_ch1_arburst  ;
wire [3 : 0]      s_axi_ch1_arcache  ;
wire [5 : 0]      s_axi_ch1_arid     ;
wire [7 : 0]      s_axi_ch1_arlen    ;
wire              s_axi_ch1_arlock   ;
wire [2 : 0]      s_axi_ch1_arprot   ;
wire [3 : 0]      s_axi_ch1_arqos    ;
wire              s_axi_ch1_arready  ;
wire [2:0]        s_axi_ch1_arsize   ;
wire              s_axi_ch1_aruser   ;
wire              s_axi_ch1_arvalid  ;

wire [48: 0]      s_axi_ch1_awaddr   ;
wire [1 : 0]      s_axi_ch1_awburst  ;
wire [3 : 0]      s_axi_ch1_awcache  ;
wire [5 : 0]      s_axi_ch1_awid     ;
wire [7 : 0]      s_axi_ch1_awlen    ;
wire              s_axi_ch1_awlock   ;
wire [2 : 0]      s_axi_ch1_awprot   ;
wire [3 : 0]      s_axi_ch1_awqos    ;
wire              s_axi_ch1_awready  ;
wire [2 : 0]      s_axi_ch1_awsize   ;
wire              s_axi_ch1_awuser   ;
wire              s_axi_ch1_awvalid  ;

wire [5 : 0]      s_axi_ch1_bid      ;
wire              s_axi_ch1_bready   ;
wire [1 : 0]      s_axi_ch1_bresp    ;
wire              s_axi_ch1_bvalid   ;

wire [127: 0]     s_axi_ch1_rdata    ;
wire [5 : 0]      s_axi_ch1_rid      ;
wire              s_axi_ch1_rlast    ;
wire              s_axi_ch1_rready   ;
wire [1 : 0]      s_axi_ch1_rresp    ;
wire              s_axi_ch1_rvalid   ;

wire [127: 0]     s_axi_ch1_wdata    ;
wire              s_axi_ch1_wlast    ;
wire              s_axi_ch1_wready   ;
wire [15 : 0]     s_axi_ch1_wstrb    ;
wire              s_axi_ch1_wvalid   ;

//---------------------------ch2--------------------------------------
wire [48: 0]      s_axi_ch2_araddr   ;
wire [1 : 0]      s_axi_ch2_arburst  ;
wire [3 : 0]      s_axi_ch2_arcache  ;
wire [5 : 0]      s_axi_ch2_arid     ;
wire [7 : 0]      s_axi_ch2_arlen    ;
wire              s_axi_ch2_arlock   ;
wire [2 : 0]      s_axi_ch2_arprot   ;
wire [3 : 0]      s_axi_ch2_arqos    ;
wire              s_axi_ch2_arready  ;
wire [2:0]        s_axi_ch2_arsize   ;
wire              s_axi_ch2_aruser   ;
wire              s_axi_ch2_arvalid  ;

wire [48: 0]      s_axi_ch2_awaddr   ;
wire [1 : 0]      s_axi_ch2_awburst  ;
wire [3 : 0]      s_axi_ch2_awcache  ;
wire [5 : 0]      s_axi_ch2_awid     ;
wire [7 : 0]      s_axi_ch2_awlen    ;
wire              s_axi_ch2_awlock   ;
wire [2 : 0]      s_axi_ch2_awprot   ;
wire [3 : 0]      s_axi_ch2_awqos    ;
wire              s_axi_ch2_awready  ;
wire [2 : 0]      s_axi_ch2_awsize   ;
wire              s_axi_ch2_awuser   ;
wire              s_axi_ch2_awvalid  ;

wire [5 : 0]      s_axi_ch2_bid      ;
wire              s_axi_ch2_bready   ;
wire [1 : 0]      s_axi_ch2_bresp    ;
wire              s_axi_ch2_bvalid   ;

wire [127: 0]     s_axi_ch2_rdata    ;
wire [5 : 0]      s_axi_ch2_rid      ;
wire              s_axi_ch2_rlast    ;
wire              s_axi_ch2_rready   ;
wire [1 : 0]      s_axi_ch2_rresp    ;
wire              s_axi_ch2_rvalid   ;

wire [127: 0]     s_axi_ch2_wdata    ;
wire              s_axi_ch2_wlast    ;
wire              s_axi_ch2_wready   ;
wire [15 : 0]     s_axi_ch2_wstrb    ;
wire              s_axi_ch2_wvalid   ;

//---------------------------ch3--------------------------------------
wire [48: 0]      s_axi_ch3_araddr   ;
wire [1 : 0]      s_axi_ch3_arburst  ;
wire [3 : 0]      s_axi_ch3_arcache  ;
wire [5 : 0]      s_axi_ch3_arid     ;
wire [7 : 0]      s_axi_ch3_arlen    ;
wire              s_axi_ch3_arlock   ;
wire [2 : 0]      s_axi_ch3_arprot   ;
wire [3 : 0]      s_axi_ch3_arqos    ;
wire              s_axi_ch3_arready  ;
wire [2:0]        s_axi_ch3_arsize   ;
wire              s_axi_ch3_aruser   ;
wire              s_axi_ch3_arvalid  ;

wire [48: 0]      s_axi_ch3_awaddr   ;
wire [1 : 0]      s_axi_ch3_awburst  ;
wire [3 : 0]      s_axi_ch3_awcache  ;
wire [5 : 0]      s_axi_ch3_awid     ;
wire [7 : 0]      s_axi_ch3_awlen    ;
wire              s_axi_ch3_awlock   ;
wire [2 : 0]      s_axi_ch3_awprot   ;
wire [3 : 0]      s_axi_ch3_awqos    ;
wire              s_axi_ch3_awready  ;
wire [2 : 0]      s_axi_ch3_awsize   ;
wire              s_axi_ch3_awuser   ;
wire              s_axi_ch3_awvalid  ;

wire [5 : 0]      s_axi_ch3_bid      ;
wire              s_axi_ch3_bready   ;
wire [1 : 0]      s_axi_ch3_bresp    ;
wire              s_axi_ch3_bvalid   ;

wire [127: 0]     s_axi_ch3_rdata    ;
wire [5 : 0]      s_axi_ch3_rid      ;
wire              s_axi_ch3_rlast    ;
wire              s_axi_ch3_rready   ;
wire [1 : 0]      s_axi_ch3_rresp    ;
wire              s_axi_ch3_rvalid   ;

wire [127: 0]     s_axi_ch3_wdata    ;
wire              s_axi_ch3_wlast    ;
wire              s_axi_ch3_wready   ;
wire [15 : 0]     s_axi_ch3_wstrb    ;
wire              s_axi_ch3_wvalid   ;

//---------------------------ch4--------------------------------------
wire [48: 0]      s_axi_ch4_araddr   ;
wire [1 : 0]      s_axi_ch4_arburst  ;
wire [3 : 0]      s_axi_ch4_arcache  ;
wire [5 : 0]      s_axi_ch4_arid     ;
wire [7 : 0]      s_axi_ch4_arlen    ;
wire              s_axi_ch4_arlock   ;
wire [2 : 0]      s_axi_ch4_arprot   ;
wire [3 : 0]      s_axi_ch4_arqos    ;
wire              s_axi_ch4_arready  ;
wire [2:0]        s_axi_ch4_arsize   ;
wire              s_axi_ch4_aruser   ;
wire              s_axi_ch4_arvalid  ;

wire [48: 0]      s_axi_ch4_awaddr   ;
wire [1 : 0]      s_axi_ch4_awburst  ;
wire [3 : 0]      s_axi_ch4_awcache  ;
wire [5 : 0]      s_axi_ch4_awid     ;
wire [7 : 0]      s_axi_ch4_awlen    ;
wire              s_axi_ch4_awlock   ;
wire [2 : 0]      s_axi_ch4_awprot   ;
wire [3 : 0]      s_axi_ch4_awqos    ;
wire              s_axi_ch4_awready  ;
wire [2 : 0]      s_axi_ch4_awsize   ;
wire              s_axi_ch4_awuser   ;
wire              s_axi_ch4_awvalid  ;

wire [5 : 0]      s_axi_ch4_bid      ;
wire              s_axi_ch4_bready   ;
wire [1 : 0]      s_axi_ch4_bresp    ;
wire              s_axi_ch4_bvalid   ;

wire [127: 0]     s_axi_ch4_rdata    ;
wire [5 : 0]      s_axi_ch4_rid      ;
wire              s_axi_ch4_rlast    ;
wire              s_axi_ch4_rready   ;
wire [1 : 0]      s_axi_ch4_rresp    ;
wire              s_axi_ch4_rvalid   ;

wire [127: 0]     s_axi_ch4_wdata    ;
wire              s_axi_ch4_wlast    ;
wire              s_axi_ch4_wready   ;
wire [15 : 0]     s_axi_ch4_wstrb    ;
wire              s_axi_ch4_wvalid   ;

ddr_axi_interface 
#(
    .READ_CH_ENABLE     (0), 
    .WRITE_CH_ENABLE    (1) 
)
ddr_axi_interface_ch0
(
    .clk                (clk                    ),
    .rst                (rst                    ),
    .ddr_clk            (clk                    ),
    .fifo_din_cmd       (fifo_din_cmd_ch0       ),
    .fifo_wr_en_cmd     (fifo_wr_en_cmd_ch0     ),
    .fifo_full_cmd      (fifo_full_cmd_ch0      ),
    .fifo_empty_cmd     (),

    .fifo_wr_en_wr      (fifo_wr_en_wr_ch0      ),
    .fifo_din_wr        (fifo_din_wr_ch0        ),
    .fifo_full_wr       (fifo_full_wr_ch0       ),
    .fifo_empty_wr      (),

    .fifo_dout_rd       (),
    .fifo_rd_en_rd      (1'b0                   ),
    .fifo_empty_rd      (),
    .fifo_full_rd       (),
    .data_rd_valid      (),

    .s_axi_araddr       (s_axi_ch0_araddr       ),
    .s_axi_arburst      (s_axi_ch0_arburst      ),
    .s_axi_arcache      (s_axi_ch0_arcache      ),
    .s_axi_arid         (s_axi_ch0_arid         ),
    .s_axi_arlen        (s_axi_ch0_arlen        ),
    .s_axi_arlock       (s_axi_ch0_arlock       ),
    .s_axi_arprot       (s_axi_ch0_arprot       ),
    .s_axi_arqos        (s_axi_ch0_arqos        ),
    .s_axi_arready      (s_axi_ch0_arready      ),
    .s_axi_arsize       (s_axi_ch0_arsize       ),
    .s_axi_aruser       (s_axi_ch0_aruser       ),
    .s_axi_arvalid      (s_axi_ch0_arvalid      ),

    .s_axi_awaddr       (s_axi_ch0_awaddr       ),
    .s_axi_awburst      (s_axi_ch0_awburst      ),
    .s_axi_awcache      (s_axi_ch0_awcache      ),
    .s_axi_awid         (s_axi_ch0_awid         ),
    .s_axi_awlen        (s_axi_ch0_awlen        ),
    .s_axi_awlock       (s_axi_ch0_awlock       ),
    .s_axi_awprot       (s_axi_ch0_awprot       ),
    .s_axi_awqos        (s_axi_ch0_awqos        ),
    .s_axi_awready      (s_axi_ch0_awready      ),
    .s_axi_awsize       (s_axi_ch0_awsize       ),
    .s_axi_awuser       (s_axi_ch0_awuser       ),
    .s_axi_awvalid      (s_axi_ch0_awvalid      ),

    .s_axi_bid          (s_axi_ch0_bid          ),
    .s_axi_bready       (s_axi_ch0_bready       ),
    .s_axi_bresp        (s_axi_ch0_bresp        ),
    .s_axi_bvalid       (s_axi_ch0_bvalid       ),

    .s_axi_rdata        (s_axi_ch0_rdata        ),
    .s_axi_rid          (s_axi_ch0_rid          ),
    .s_axi_rlast        (s_axi_ch0_rlast        ),
    .s_axi_rready       (s_axi_ch0_rready       ),
    .s_axi_rresp        (s_axi_ch0_rresp        ),
    .s_axi_rvalid       (s_axi_ch0_rvalid       ),

    .s_axi_wdata        (s_axi_ch0_wdata        ),
    .s_axi_wlast        (s_axi_ch0_wlast        ),
    .s_axi_wready       (s_axi_ch0_wready       ),
    .s_axi_wstrb        (s_axi_ch0_wstrb        ),
    .s_axi_wvalid       (s_axi_ch0_wvalid       )
);

ddr_axi_interface 
#(
    .READ_CH_ENABLE     (0), 
    .WRITE_CH_ENABLE    (1) 
)
ddr_axi_interface_ch1
(
    .clk                (clk                    ),
    .rst                (rst                    ),
    .ddr_clk            (clk                    ),
    .fifo_din_cmd       (fifo_din_cmd_ch1       ),
    .fifo_wr_en_cmd     (fifo_wr_en_cmd_ch1     ),
    .fifo_full_cmd      (fifo_full_cmd_ch1      ),
    .fifo_empty_cmd     (),

    .fifo_wr_en_wr      (fifo_wr_en_wr_ch1      ),
    .fifo_din_wr        (fifo_din_wr_ch1       ),
    .fifo_full_wr       (fifo_full_wr_ch1       ),
    .fifo_empty_wr      (),

    .fifo_dout_rd       (),
    .fifo_rd_en_rd      (1'b0                   ),
    .fifo_empty_rd      (),
    .fifo_full_rd       (),
    .data_rd_valid      (),

    .s_axi_araddr       (s_axi_ch1_araddr       ),
    .s_axi_arburst      (s_axi_ch1_arburst      ),
    .s_axi_arcache      (s_axi_ch1_arcache      ),
    .s_axi_arid         (s_axi_ch1_arid         ),
    .s_axi_arlen        (s_axi_ch1_arlen        ),
    .s_axi_arlock       (s_axi_ch1_arlock       ),
    .s_axi_arprot       (s_axi_ch1_arprot       ),
    .s_axi_arqos        (s_axi_ch1_arqos        ),
    .s_axi_arready      (s_axi_ch1_arready      ),
    .s_axi_arsize       (s_axi_ch1_arsize       ),
    .s_axi_aruser       (s_axi_ch1_aruser       ),
    .s_axi_arvalid      (s_axi_ch1_arvalid      ),

    .s_axi_awaddr       (s_axi_ch1_awaddr       ),
    .s_axi_awburst      (s_axi_ch1_awburst      ),
    .s_axi_awcache      (s_axi_ch1_awcache      ),
    .s_axi_awid         (s_axi_ch1_awid         ),
    .s_axi_awlen        (s_axi_ch1_awlen        ),
    .s_axi_awlock       (s_axi_ch1_awlock       ),
    .s_axi_awprot       (s_axi_ch1_awprot       ),
    .s_axi_awqos        (s_axi_ch1_awqos        ),
    .s_axi_awready      (s_axi_ch1_awready      ),
    .s_axi_awsize       (s_axi_ch1_awsize       ),
    .s_axi_awuser       (s_axi_ch1_awuser       ),
    .s_axi_awvalid      (s_axi_ch1_awvalid      ),

    .s_axi_bid          (s_axi_ch1_bid          ),
    .s_axi_bready       (s_axi_ch1_bready       ),
    .s_axi_bresp        (s_axi_ch1_bresp        ),
    .s_axi_bvalid       (s_axi_ch1_bvalid       ),

    .s_axi_rdata        (s_axi_ch1_rdata        ),
    .s_axi_rid          (s_axi_ch1_rid          ),
    .s_axi_rlast        (s_axi_ch1_rlast        ),
    .s_axi_rready       (s_axi_ch1_rready       ),
    .s_axi_rresp        (s_axi_ch1_rresp        ),
    .s_axi_rvalid       (s_axi_ch1_rvalid       ),

    .s_axi_wdata        (s_axi_ch1_wdata        ),
    .s_axi_wlast        (s_axi_ch1_wlast        ),
    .s_axi_wready       (s_axi_ch1_wready       ),
    .s_axi_wstrb        (s_axi_ch1_wstrb        ),
    .s_axi_wvalid       (s_axi_ch1_wvalid       )
);

ddr_axi_interface 
#(
    .READ_CH_ENABLE     (0), 
    .WRITE_CH_ENABLE    (1) 
)
ddr_axi_interface_ch2
(
    .clk                (clk                    ),
    .rst                (rst                    ),
    .ddr_clk            (clk                    ),
    .fifo_din_cmd       (fifo_din_cmd_ch2       ),
    .fifo_wr_en_cmd     (fifo_wr_en_cmd_ch2     ),
    .fifo_full_cmd      (fifo_full_cmd_ch2      ),
    .fifo_empty_cmd     (),

    .fifo_wr_en_wr      (fifo_wr_en_wr_ch2      ),
    .fifo_din_wr        (fifo_din_wr_ch2        ),
    .fifo_full_wr       (fifo_full_wr_ch2       ),
    .fifo_empty_wr      (),

    .fifo_dout_rd       (),
    .fifo_rd_en_rd      (1'b0                   ),
    .fifo_empty_rd      (),
    .fifo_full_rd       (),
    .data_rd_valid      (),

    .s_axi_araddr       (s_axi_ch2_araddr       ),
    .s_axi_arburst      (s_axi_ch2_arburst      ),
    .s_axi_arcache      (s_axi_ch2_arcache      ),
    .s_axi_arid         (s_axi_ch2_arid         ),
    .s_axi_arlen        (s_axi_ch2_arlen        ),
    .s_axi_arlock       (s_axi_ch2_arlock       ),
    .s_axi_arprot       (s_axi_ch2_arprot       ),
    .s_axi_arqos        (s_axi_ch2_arqos        ),
    .s_axi_arready      (s_axi_ch2_arready      ),
    .s_axi_arsize       (s_axi_ch2_arsize       ),
    .s_axi_aruser       (s_axi_ch2_aruser       ),
    .s_axi_arvalid      (s_axi_ch2_arvalid      ),

    .s_axi_awaddr       (s_axi_ch2_awaddr       ),
    .s_axi_awburst      (s_axi_ch2_awburst      ),
    .s_axi_awcache      (s_axi_ch2_awcache      ),
    .s_axi_awid         (s_axi_ch2_awid         ),
    .s_axi_awlen        (s_axi_ch2_awlen        ),
    .s_axi_awlock       (s_axi_ch2_awlock       ),
    .s_axi_awprot       (s_axi_ch2_awprot       ),
    .s_axi_awqos        (s_axi_ch2_awqos        ),
    .s_axi_awready      (s_axi_ch2_awready      ),
    .s_axi_awsize       (s_axi_ch2_awsize       ),
    .s_axi_awuser       (s_axi_ch2_awuser       ),
    .s_axi_awvalid      (s_axi_ch2_awvalid      ),

    .s_axi_bid          (s_axi_ch2_bid          ),
    .s_axi_bready       (s_axi_ch2_bready       ),
    .s_axi_bresp        (s_axi_ch2_bresp        ),
    .s_axi_bvalid       (s_axi_ch2_bvalid       ),

    .s_axi_rdata        (s_axi_ch2_rdata        ),
    .s_axi_rid          (s_axi_ch2_rid          ),
    .s_axi_rlast        (s_axi_ch2_rlast        ),
    .s_axi_rready       (s_axi_ch2_rready       ),
    .s_axi_rresp        (s_axi_ch2_rresp        ),
    .s_axi_rvalid       (s_axi_ch2_rvalid       ),

    .s_axi_wdata        (s_axi_ch2_wdata        ),
    .s_axi_wlast        (s_axi_ch2_wlast        ),
    .s_axi_wready       (s_axi_ch2_wready       ),
    .s_axi_wstrb        (s_axi_ch2_wstrb        ),
    .s_axi_wvalid       (s_axi_ch2_wvalid       )
);

//-------------------------------ch3-------------------------------------
ddr_axi_interface 
#(
    .READ_CH_ENABLE     (1), 
    .WRITE_CH_ENABLE    (0) 
)
ddr_axi_interface_ch3
(
    .clk                (clk                    ),
    .rst                (rst                    ),
    .ddr_clk            (clk                    ),
    .fifo_din_cmd       (fifo_din_cmd_ch3       ),
    .fifo_wr_en_cmd     (fifo_wr_en_cmd_ch3     ),
    .fifo_full_cmd      (fifo_full_cmd_ch3      ),
    .fifo_empty_cmd     (),

    .fifo_wr_en_wr      (),
    .fifo_din_wr        (),
    .fifo_full_wr       (),
    .fifo_empty_wr      (),
    
    .fifo_dout_rd       (fifo_dout_rd_ch3       ),
    .fifo_rd_en_rd      (fifo_rd_en_rd_ch3      ),
    .fifo_empty_rd      (fifo_empty_rd_ch3      ),
    .fifo_full_rd       (fifo_full_rd_ch3       ),
    .data_rd_valid      (data_rd_valid_ch3      ),

    .s_axi_araddr       (s_axi_ch3_araddr       ),
    .s_axi_arburst      (s_axi_ch3_arburst      ),
    .s_axi_arcache      (s_axi_ch3_arcache      ),
    .s_axi_arid         (s_axi_ch3_arid         ),
    .s_axi_arlen        (s_axi_ch3_arlen        ),
    .s_axi_arlock       (s_axi_ch3_arlock       ),
    .s_axi_arprot       (s_axi_ch3_arprot       ),
    .s_axi_arqos        (s_axi_ch3_arqos        ),
    .s_axi_arready      (s_axi_ch3_arready      ),
    .s_axi_arsize       (s_axi_ch3_arsize       ),
    .s_axi_aruser       (s_axi_ch3_aruser       ),
    .s_axi_arvalid      (s_axi_ch3_arvalid      ),

    .s_axi_awaddr       (s_axi_ch3_awaddr       ),
    .s_axi_awburst      (s_axi_ch3_awburst      ),
    .s_axi_awcache      (s_axi_ch3_awcache      ),
    .s_axi_awid         (s_axi_ch3_awid         ),
    .s_axi_awlen        (s_axi_ch3_awlen        ),
    .s_axi_awlock       (s_axi_ch3_awlock       ),
    .s_axi_awprot       (s_axi_ch3_awprot       ),
    .s_axi_awqos        (s_axi_ch3_awqos        ),
    .s_axi_awready      (s_axi_ch3_awready      ),
    .s_axi_awsize       (s_axi_ch3_awsize       ),
    .s_axi_awuser       (s_axi_ch3_awuser       ),
    .s_axi_awvalid      (s_axi_ch3_awvalid      ),

    .s_axi_bid          (s_axi_ch3_bid          ),
    .s_axi_bready       (s_axi_ch3_bready       ),
    .s_axi_bresp        (s_axi_ch3_bresp        ),
    .s_axi_bvalid       (s_axi_ch3_bvalid       ),

    .s_axi_rdata        (s_axi_ch3_rdata        ),
    .s_axi_rid          (s_axi_ch3_rid          ),
    .s_axi_rlast        (s_axi_ch3_rlast        ),
    .s_axi_rready       (s_axi_ch3_rready       ),
    .s_axi_rresp        (s_axi_ch3_rresp        ),
    .s_axi_rvalid       (s_axi_ch3_rvalid       ),

    .s_axi_wdata        (s_axi_ch3_wdata        ),
    .s_axi_wlast        (s_axi_ch3_wlast        ),
    .s_axi_wready       (s_axi_ch3_wready       ),
    .s_axi_wstrb        (s_axi_ch3_wstrb        ),
    .s_axi_wvalid       (s_axi_ch3_wvalid       )
);

//#################################################################################

ddr_axi_interface 
#(
    .READ_CH_ENABLE     (0), 
    .WRITE_CH_ENABLE    (1) 
)
ddr_axi_interface_ch4
(
    .clk                (clk                    ),
    .rst                (rst                    ),
    .ddr_clk            (clk                    ),
    .fifo_din_cmd       (fifo_din_cmd_ch4       ),
    .fifo_wr_en_cmd     (fifo_wr_en_cmd_ch4     ),
    .fifo_full_cmd      (fifo_full_cmd_ch4      ),
    .fifo_empty_cmd     (),

    .fifo_wr_en_wr      (fifo_wr_en_wr_ch4      ),
    .fifo_din_wr        (fifo_din_wr_ch4        ),
    .fifo_full_wr       (fifo_full_wr_ch4       ),
    .fifo_empty_wr      (),

    .fifo_dout_rd       (),
    .fifo_rd_en_rd      (1'b0                   ),
    .fifo_empty_rd      (),
    .fifo_full_rd       (),
    .data_rd_valid      (),

    .s_axi_araddr       (s_axi_ch4_araddr       ),
    .s_axi_arburst      (s_axi_ch4_arburst      ),
    .s_axi_arcache      (s_axi_ch4_arcache      ),
    .s_axi_arid         (s_axi_ch4_arid         ),
    .s_axi_arlen        (s_axi_ch4_arlen        ),
    .s_axi_arlock       (s_axi_ch4_arlock       ),
    .s_axi_arprot       (s_axi_ch4_arprot       ),
    .s_axi_arqos        (s_axi_ch4_arqos        ),
    .s_axi_arready      (s_axi_ch4_arready      ),
    .s_axi_arsize       (s_axi_ch4_arsize       ),
    .s_axi_aruser       (s_axi_ch4_aruser       ),
    .s_axi_arvalid      (s_axi_ch4_arvalid      ),

    .s_axi_awaddr       (s_axi_ch4_awaddr       ),
    .s_axi_awburst      (s_axi_ch4_awburst      ),
    .s_axi_awcache      (s_axi_ch4_awcache      ),
    .s_axi_awid         (s_axi_ch4_awid         ),
    .s_axi_awlen        (s_axi_ch4_awlen        ),
    .s_axi_awlock       (s_axi_ch4_awlock       ),
    .s_axi_awprot       (s_axi_ch4_awprot       ),
    .s_axi_awqos        (s_axi_ch4_awqos        ),
    .s_axi_awready      (s_axi_ch4_awready      ),
    .s_axi_awsize       (s_axi_ch4_awsize       ),
    .s_axi_awuser       (s_axi_ch4_awuser       ),
    .s_axi_awvalid      (s_axi_ch4_awvalid      ),

    .s_axi_bid          (s_axi_ch4_bid          ),
    .s_axi_bready       (s_axi_ch4_bready       ),
    .s_axi_bresp        (s_axi_ch4_bresp        ),
    .s_axi_bvalid       (s_axi_ch4_bvalid       ),

    .s_axi_rdata        (s_axi_ch4_rdata        ),
    .s_axi_rid          (s_axi_ch4_rid          ),
    .s_axi_rlast        (s_axi_ch4_rlast        ),
    .s_axi_rready       (s_axi_ch4_rready       ),
    .s_axi_rresp        (s_axi_ch4_rresp        ),
    .s_axi_rvalid       (s_axi_ch4_rvalid       ),

    .s_axi_wdata        (s_axi_ch4_wdata        ),
    .s_axi_wlast        (s_axi_ch4_wlast        ),
    .s_axi_wready       (s_axi_ch4_wready       ),
    .s_axi_wstrb        (s_axi_ch4_wstrb        ),
    .s_axi_wvalid       (s_axi_ch4_wvalid       )
);

ps_ddr_axi_interconnect ps_ddr_axi_interconnect
(   
    .ACLK                   (clk                    ),
    .ARESETN                (1'b1                   ),
    .M00_ACLK               (ddr_clk                ),
    .M00_ARESETN            (1'b1                   ),

    .M00_AXI_araddr         (m_axi_araddr           ),
    .M00_AXI_arburst        (m_axi_arburst          ),
    .M00_AXI_arcache        (m_axi_arcache          ),
    .M00_AXI_arid           (m_axi_arid[2:0]        ),
    .M00_AXI_arlen          (m_axi_arlen            ),
    .M00_AXI_arlock         (m_axi_arlock           ),
    .M00_AXI_arprot         (m_axi_arprot           ),
    .M00_AXI_arqos          (m_axi_arqos            ),
    .M00_AXI_arready        (m_axi_arready          ),
    .M00_AXI_arregion       (m_axi_arregion         ),
    .M00_AXI_arsize         (m_axi_arsize           ),
    .M00_AXI_arvalid        (m_axi_arvalid          ),
    .M00_AXI_awaddr         (m_axi_awaddr           ),
    .M00_AXI_awburst        (m_axi_awburst          ),
    .M00_AXI_awcache        (m_axi_awcache          ),
    .M00_AXI_awid           (m_axi_awid[2:0]        ),
    .M00_AXI_awlen          (m_axi_awlen            ),
    .M00_AXI_awlock         (m_axi_awlock           ),
    .M00_AXI_awprot         (m_axi_awprot           ),
    .M00_AXI_awqos          (m_axi_awqos            ),
    .M00_AXI_awready        (m_axi_awready          ),
    .M00_AXI_awregion       (m_axi_awregion         ),
    .M00_AXI_awsize         (m_axi_awsize           ),
    .M00_AXI_awvalid        (m_axi_awvalid          ),
    .M00_AXI_bid            (m_axi_bid              ),
    .M00_AXI_bready         (m_axi_bready           ),
    .M00_AXI_bresp          (m_axi_bresp            ), 
    .M00_AXI_bvalid         (m_axi_bvalid           ),
    .M00_AXI_rdata          (m_axi_rdata            ),
    .M00_AXI_rid            (m_axi_rid              ),
    .M00_AXI_rlast          (m_axi_rlast            ),
    .M00_AXI_rready         (m_axi_rready           ),
    .M00_AXI_rresp          (m_axi_rresp            ),
    .M00_AXI_rvalid         (m_axi_rvalid           ),
    .M00_AXI_wdata          (m_axi_wdata            ),
    .M00_AXI_wlast          (m_axi_wlast            ),
    .M00_AXI_wready         (m_axi_wready           ),
    .M00_AXI_wstrb          (m_axi_wstrb            ),
    .M00_AXI_wvalid         (m_axi_wvalid           ),

    .S00_AXI_araddr         (s_axi_ch0_araddr       ),
    .S00_AXI_arburst        (s_axi_ch0_arburst      ),
    .S00_AXI_arcache        (s_axi_ch0_arcache      ),
    .S00_AXI_arlen          (s_axi_ch0_arlen        ),
    .S00_AXI_arlock         (s_axi_ch0_arlock       ),
    .S00_AXI_arprot         (s_axi_ch0_arprot       ),
    .S00_AXI_arqos          (s_axi_ch0_arqos        ),
    .S00_AXI_arready        (s_axi_ch0_arready      ),
    // .S00_AXI_arregion       ('d0                    ),
    .S00_AXI_arsize         (s_axi_ch0_arsize       ),
    .S00_AXI_arvalid        (s_axi_ch0_arvalid      ),
    .S00_AXI_awaddr         (s_axi_ch0_awaddr       ),
    .S00_AXI_awburst        (s_axi_ch0_awburst      ),
    .S00_AXI_awcache        (s_axi_ch0_awcache      ),
    .S00_AXI_awlen          (s_axi_ch0_awlen        ),
    .S00_AXI_awlock         (s_axi_ch0_awlock       ),
    .S00_AXI_awprot         (s_axi_ch0_awprot       ),
    .S00_AXI_awqos          (s_axi_ch0_awqos        ),
    .S00_AXI_awready        (s_axi_ch0_awready      ),
    // .S00_AXI_awregion       ('d0                    ),
    .S00_AXI_awsize         (s_axi_ch0_awsize       ),
    .S00_AXI_awvalid        (s_axi_ch0_awvalid      ),
    .S00_AXI_bready         (s_axi_ch0_bready       ),
    .S00_AXI_bresp          (s_axi_ch0_bresp        ),
    .S00_AXI_bvalid         (s_axi_ch0_bvalid       ),
    .S00_AXI_rdata          (s_axi_ch0_rdata        ),
    .S00_AXI_rlast          (s_axi_ch0_rlast        ),
    .S00_AXI_rready         (s_axi_ch0_rready       ),
    .S00_AXI_rresp          (s_axi_ch0_rresp        ),
    .S00_AXI_rvalid         (s_axi_ch0_rvalid       ),
    .S00_AXI_wdata          (s_axi_ch0_wdata        ),
    .S00_AXI_wlast          (s_axi_ch0_wlast        ),
    .S00_AXI_wready         (s_axi_ch0_wready       ),
    .S00_AXI_wstrb          (s_axi_ch0_wstrb        ),
    .S00_AXI_wvalid         (s_axi_ch0_wvalid       ),

    .S01_AXI_araddr         (s_axi_ch1_araddr       ),
    .S01_AXI_arburst        (s_axi_ch1_arburst      ),
    .S01_AXI_arcache        (s_axi_ch1_arcache      ),
    .S01_AXI_arlen          (s_axi_ch1_arlen        ),
    .S01_AXI_arlock         (s_axi_ch1_arlock       ),
    .S01_AXI_arprot         (s_axi_ch1_arprot       ),
    .S01_AXI_arqos          (s_axi_ch1_arqos        ),
    .S01_AXI_arready        (s_axi_ch1_arready      ),
    // .S01_AXI_arregion       ('d0                    ),
    .S01_AXI_arsize         (s_axi_ch1_arsize       ),
    .S01_AXI_arvalid        (s_axi_ch1_arvalid      ),
    .S01_AXI_awaddr         (s_axi_ch1_awaddr       ),
    .S01_AXI_awburst        (s_axi_ch1_awburst      ),
    .S01_AXI_awcache        (s_axi_ch1_awcache      ),
    .S01_AXI_awlen          (s_axi_ch1_awlen        ),
    .S01_AXI_awlock         (s_axi_ch1_awlock       ),
    .S01_AXI_awprot         (s_axi_ch1_awprot       ),
    .S01_AXI_awqos          (s_axi_ch1_awqos        ),
    .S01_AXI_awready        (s_axi_ch1_awready      ),
    // .S01_AXI_awregion       ('d0                    ),
    .S01_AXI_awsize         (s_axi_ch1_awsize       ),
    .S01_AXI_awvalid        (s_axi_ch1_awvalid      ),
    .S01_AXI_bready         (s_axi_ch1_bready       ),
    .S01_AXI_bresp          (s_axi_ch1_bresp        ),
    .S01_AXI_bvalid         (s_axi_ch1_bvalid       ),
    .S01_AXI_rdata          (s_axi_ch1_rdata        ),
    .S01_AXI_rlast          (s_axi_ch1_rlast        ),
    .S01_AXI_rready         (s_axi_ch1_rready       ),
    .S01_AXI_rresp          (s_axi_ch1_rresp        ),
    .S01_AXI_rvalid         (s_axi_ch1_rvalid       ),
    .S01_AXI_wdata          (s_axi_ch1_wdata        ),
    .S01_AXI_wlast          (s_axi_ch1_wlast        ),
    .S01_AXI_wready         (s_axi_ch1_wready       ),
    .S01_AXI_wstrb          (s_axi_ch1_wstrb        ),
    .S01_AXI_wvalid         (s_axi_ch1_wvalid       ),

    .S02_AXI_araddr         (s_axi_ch2_araddr       ),
    .S02_AXI_arburst        (s_axi_ch2_arburst      ),
    .S02_AXI_arcache        (s_axi_ch2_arcache      ),
    .S02_AXI_arlen          (s_axi_ch2_arlen        ),
    .S02_AXI_arlock         (s_axi_ch2_arlock       ),
    .S02_AXI_arprot         (s_axi_ch2_arprot       ),
    .S02_AXI_arqos          (s_axi_ch2_arqos        ),
    .S02_AXI_arready        (s_axi_ch2_arready      ),
    // .S02_AXI_arregion       ('d0                    ),
    .S02_AXI_arsize         (s_axi_ch2_arsize       ),
    .S02_AXI_arvalid        (s_axi_ch2_arvalid      ),
    .S02_AXI_awaddr         (s_axi_ch2_awaddr       ),
    .S02_AXI_awburst        (s_axi_ch2_awburst      ),
    .S02_AXI_awcache        (s_axi_ch2_awcache      ),
    .S02_AXI_awlen          (s_axi_ch2_awlen        ),
    .S02_AXI_awlock         (s_axi_ch2_awlock       ),
    .S02_AXI_awprot         (s_axi_ch2_awprot       ),
    .S02_AXI_awqos          (s_axi_ch2_awqos        ),
    .S02_AXI_awready        (s_axi_ch2_awready      ),
    // .S02_AXI_awregion       ('d0                    ),
    .S02_AXI_awsize         (s_axi_ch2_awsize       ),
    .S02_AXI_awvalid        (s_axi_ch2_awvalid      ),
    .S02_AXI_bready         (s_axi_ch2_bready       ),
    .S02_AXI_bresp          (s_axi_ch2_bresp        ),
    .S02_AXI_bvalid         (s_axi_ch2_bvalid       ),
    .S02_AXI_rdata          (s_axi_ch2_rdata        ),
    .S02_AXI_rlast          (s_axi_ch2_rlast        ),
    .S02_AXI_rready         (s_axi_ch2_rready       ),
    .S02_AXI_rresp          (s_axi_ch2_rresp        ),
    .S02_AXI_rvalid         (s_axi_ch2_rvalid       ),
    .S02_AXI_wdata          (s_axi_ch2_wdata        ),
    .S02_AXI_wlast          (s_axi_ch2_wlast        ),
    .S02_AXI_wready         (s_axi_ch2_wready       ),
    .S02_AXI_wstrb          (s_axi_ch2_wstrb        ),
    .S02_AXI_wvalid         (s_axi_ch2_wvalid       ),

    .S03_AXI_araddr         (s_axi_ch3_araddr       ),
    .S03_AXI_arburst        (s_axi_ch3_arburst      ),
    .S03_AXI_arcache        (s_axi_ch3_arcache      ),
    .S03_AXI_arlen          (s_axi_ch3_arlen        ),
    .S03_AXI_arlock         (s_axi_ch3_arlock       ),
    .S03_AXI_arprot         (s_axi_ch3_arprot       ),
    .S03_AXI_arqos          (s_axi_ch3_arqos        ),
    .S03_AXI_arready        (s_axi_ch3_arready      ),
    // .S03_AXI_arregion       ('d0                    ),
    .S03_AXI_arsize         (s_axi_ch3_arsize       ),
    .S03_AXI_arvalid        (s_axi_ch3_arvalid      ),
    .S03_AXI_awaddr         (s_axi_ch3_awaddr       ),
    .S03_AXI_awburst        (s_axi_ch3_awburst      ),
    .S03_AXI_awcache        (s_axi_ch3_awcache      ),
    .S03_AXI_awlen          (s_axi_ch3_awlen        ),
    .S03_AXI_awlock         (s_axi_ch3_awlock       ),
    .S03_AXI_awprot         (s_axi_ch3_awprot       ),
    .S03_AXI_awqos          (s_axi_ch3_awqos        ),
    .S03_AXI_awready        (s_axi_ch3_awready      ),
    // .S03_AXI_awregion       ('d0                    ),
    .S03_AXI_awsize         (s_axi_ch3_awsize       ),
    .S03_AXI_awvalid        (s_axi_ch3_awvalid      ),
    .S03_AXI_bready         (s_axi_ch3_bready       ),
    .S03_AXI_bresp          (s_axi_ch3_bresp        ),
    .S03_AXI_bvalid         (s_axi_ch3_bvalid       ),
    .S03_AXI_rdata          (s_axi_ch3_rdata        ),
    .S03_AXI_rlast          (s_axi_ch3_rlast        ),
    .S03_AXI_rready         (s_axi_ch3_rready       ),
    .S03_AXI_rresp          (s_axi_ch3_rresp        ),
    .S03_AXI_rvalid         (s_axi_ch3_rvalid       ),
    .S03_AXI_wdata          (s_axi_ch3_wdata        ),
    .S03_AXI_wlast          (s_axi_ch3_wlast        ),
    .S03_AXI_wready         (s_axi_ch3_wready       ),
    .S03_AXI_wstrb          (s_axi_ch3_wstrb        ),
    .S03_AXI_wvalid         (s_axi_ch3_wvalid       ),

    .S04_AXI_araddr         (s_axi_ch4_araddr       ),
    .S04_AXI_arburst        (s_axi_ch4_arburst      ),
    .S04_AXI_arcache        (s_axi_ch4_arcache      ),
    .S04_AXI_arlen          (s_axi_ch4_arlen        ),
    .S04_AXI_arlock         (s_axi_ch4_arlock       ),
    .S04_AXI_arprot         (s_axi_ch4_arprot       ),
    .S04_AXI_arqos          (s_axi_ch4_arqos        ),
    .S04_AXI_arready        (s_axi_ch4_arready      ),
    // .S03_AXI_arregion       ('d0                    ),
    .S04_AXI_arsize         (s_axi_ch4_arsize       ),
    .S04_AXI_arvalid        (s_axi_ch4_arvalid      ),
    .S04_AXI_awaddr         (s_axi_ch4_awaddr       ),
    .S04_AXI_awburst        (s_axi_ch4_awburst      ),
    .S04_AXI_awcache        (s_axi_ch4_awcache      ),
    .S04_AXI_awlen          (s_axi_ch4_awlen        ),
    .S04_AXI_awlock         (s_axi_ch4_awlock       ),
    .S04_AXI_awprot         (s_axi_ch4_awprot       ),
    .S04_AXI_awqos          (s_axi_ch4_awqos        ),
    .S04_AXI_awready        (s_axi_ch4_awready      ),
    // .S03_AXI_awregion       ('d0                    ),
    .S04_AXI_awsize         (s_axi_ch4_awsize       ),
    .S04_AXI_awvalid        (s_axi_ch4_awvalid      ),
    .S04_AXI_bready         (s_axi_ch4_bready       ),
    .S04_AXI_bresp          (s_axi_ch4_bresp        ),
    .S04_AXI_bvalid         (s_axi_ch4_bvalid       ),
    .S04_AXI_rdata          (s_axi_ch4_rdata        ),
    .S04_AXI_rlast          (s_axi_ch4_rlast        ),
    .S04_AXI_rready         (s_axi_ch4_rready       ),
    .S04_AXI_rresp          (s_axi_ch4_rresp        ),
    .S04_AXI_rvalid         (s_axi_ch4_rvalid       ),
    .S04_AXI_wdata          (s_axi_ch4_wdata        ),
    .S04_AXI_wlast          (s_axi_ch4_wlast        ),
    .S04_AXI_wready         (s_axi_ch4_wready       ),
    .S04_AXI_wstrb          (s_axi_ch4_wstrb        ),
    .S04_AXI_wvalid         (s_axi_ch4_wvalid       )
);

endmodule

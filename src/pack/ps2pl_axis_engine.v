module ps2pl_axis_engine
(
	input	wire	            rst		        ,
	input	wire	            clk		        ,

    input   wire                ps_clk_200m     ,

    output   wire   [31:0]      s_axis_ps2pl_dma0_tdata  ,
    output   wire   [3 :0]      s_axis_ps2pl_dma0_tkeep  ,
    output                      s_axis_ps2pl_dma0_tlast  ,
    input                       s_axis_ps2pl_dma0_tready ,
    output                      s_axis_ps2pl_dma0_tvalid ,

    input   wire    [31:0]      s_axis_ps2pl_dma1_tdata  ,
    input   wire    [3 :0]      s_axis_ps2pl_dma1_tkeep  ,
    input                       s_axis_ps2pl_dma1_tlast  ,
    output                      s_axis_ps2pl_dma1_tready ,
    input                       s_axis_ps2pl_dma1_tvalid ,

    output   wire    [31:0]     m_axis_ps2pl_tdata       ,
    output   wire    [3 :0]     m_axis_ps2pl_tkeep       ,
    output                      m_axis_ps2pl_tlast       ,
    input                       m_axis_ps2pl_tready      ,
    output                      m_axis_ps2pl_tvalid     

);

wire [32:0] fifo_rd_data ;
wire        fifo_rd_en   ;
xfifo_async_w33d2048_d0 xfifo_async_w33d2048_d0 
(
    .rst            (rst                        ),
    .wr_clk         (ps_clk_200m                ),
    .rd_clk         (clk                        ),
    .din            ({s_axis_ps2pl_dma1_tlast,s_axis_ps2pl_dma1_tdata}),
    .wr_en          (s_axis_ps2pl_dma1_tvalid   ),
    .rd_en          (fifo_rd_en                 ),
    .dout           (fifo_rd_data               ),
    .full           (fifo_full                  ),
    .empty          (fifo_empty                 ),
    .wr_rst_busy    (),
    .rd_rst_busy    ()
);
assign fifo_rd_en           = ~fifo_empty             ;
assign m_axis_ps2pl_tvalid  = ~fifo_empty             ;
assign m_axis_ps2pl_tdata   = fifo_rd_data[31:0];
assign m_axis_ps2pl_tlast   = fifo_rd_data[32]  ;
assign s_axis_ps2pl_dma1_tready = 1'b1          ;
endmodule

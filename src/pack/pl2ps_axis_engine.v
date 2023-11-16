module pl2ps_axis_engine
(
	input	wire	            rst		                 ,
	input	wire	            clk		                 ,
    input   wire                ps_clk_200m              ,

    input   wire    [15:0]      mux_ctr                  ,
    input   wire                dma_restart              ,
    input                       pri                      ,
    input                       cpib                     ,
    input                       cpie                     ,

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

    output   wire   [31:0]       m_axis_pl2ps_dma0_tdata ,
    output   wire   [3 :0]       m_axis_pl2ps_dma0_tkeep ,
    output                       m_axis_pl2ps_dma0_tlast ,
    input                        m_axis_pl2ps_dma0_tready,
    output                       m_axis_pl2ps_dma0_tvalid,

    output   wire   [31:0]       m_axis_pl2ps_dma1_tdata ,
    output   wire   [3 :0]       m_axis_pl2ps_dma1_tkeep ,
    output                       m_axis_pl2ps_dma1_tlast ,
    input                        m_axis_pl2ps_dma1_tready,
    output                       m_axis_pl2ps_dma1_tvalid

);

reg [31:0]  s_axis_pl2ps_rdm_tdata_d1   ;
reg         s_axis_pl2ps_rdm_tlast_d1   ;
reg         s_axis_pl2ps_rdm_tvalid_d1  ;
reg [31:0]  s_axis_pl2ps_rdm_tdata_d2   ;
reg         s_axis_pl2ps_rdm_tlast_d2   ;
reg         s_axis_pl2ps_rdm_tvalid_d2  ;


reg [31:0]  s_axis_pl2ps_adc_tdata_d1   ; 
reg         s_axis_pl2ps_adc_tlast_d1   ;
reg         s_axis_pl2ps_adc_tvalid_d1  ;
reg [31:0]  s_axis_pl2ps_adc_tdata_d2   ; 
reg         s_axis_pl2ps_adc_tlast_d2   ;
reg         s_axis_pl2ps_adc_tvalid_d2  ;


reg [31:0]  s_axis_pl2ps_ch0_tdata_d1   ;
reg         s_axis_pl2ps_ch0_tlast_d1   ;
reg         s_axis_pl2ps_ch0_tvalid_d1  ;
reg [31:0]  s_axis_pl2ps_ch0_tdata_d2   ;
reg         s_axis_pl2ps_ch0_tlast_d2   ;
reg         s_axis_pl2ps_ch0_tvalid_d2  ;

reg [31:0]  s_axis_pl2ps_ch1_tdata_d1   ;
reg         s_axis_pl2ps_ch1_tlast_d1   ;
reg         s_axis_pl2ps_ch1_tvalid_d1  ;
reg [31:0]  s_axis_pl2ps_ch1_tdata_d2   ;
reg         s_axis_pl2ps_ch1_tlast_d2   ;
reg         s_axis_pl2ps_ch1_tvalid_d2  ;

reg [31:0]  s_axis_pl2ps_ch2_tdata_d1   ;
reg         s_axis_pl2ps_ch2_tlast_d1   ;
reg         s_axis_pl2ps_ch2_tvalid_d1  ;
reg [31:0]  s_axis_pl2ps_ch2_tdata_d2   ;
reg         s_axis_pl2ps_ch2_tlast_d2   ;
reg         s_axis_pl2ps_ch2_tvalid_d2  ;

reg [31:0]  s_axis_pl2ps_ch3_tdata_d1   ;
reg         s_axis_pl2ps_ch3_tlast_d1   ;
reg         s_axis_pl2ps_ch3_tvalid_d1  ;
reg [31:0]  s_axis_pl2ps_ch3_tdata_d2   ;
reg         s_axis_pl2ps_ch3_tlast_d2   ;
reg         s_axis_pl2ps_ch3_tvalid_d2  ;

reg [31:0]  s_axis_pl2ps_ch4_tdata_d1   ;
reg         s_axis_pl2ps_ch4_tlast_d1   ;
reg         s_axis_pl2ps_ch4_tvalid_d1  ;
reg [31:0]  s_axis_pl2ps_ch4_tdata_d2   ;
reg         s_axis_pl2ps_ch4_tlast_d2   ;
reg         s_axis_pl2ps_ch4_tvalid_d2  ;

reg [31:0]  s_axis_pl2ps_ch5_tdata_d1   ;
reg         s_axis_pl2ps_ch5_tlast_d1   ;
reg         s_axis_pl2ps_ch5_tvalid_d1  ;
reg [31:0]  s_axis_pl2ps_ch5_tdata_d2   ;
reg         s_axis_pl2ps_ch5_tlast_d2   ;
reg         s_axis_pl2ps_ch5_tvalid_d2  ;

always @(posedge clk) begin
    if(rst) begin
        s_axis_pl2ps_rdm_tdata_d1 <= 'd0 ;
        s_axis_pl2ps_rdm_tlast_d1 <= 'd0 ;
        s_axis_pl2ps_rdm_tvalid_d1<= 'd0 ;
        s_axis_pl2ps_rdm_tdata_d2 <= 'd0 ;
        s_axis_pl2ps_rdm_tlast_d2 <= 'd0 ;
        s_axis_pl2ps_rdm_tvalid_d2<= 'd0 ;
    end
    else begin 
        s_axis_pl2ps_rdm_tdata_d1 <= s_axis_pl2ps_rdm_tdata    ; 
        s_axis_pl2ps_rdm_tlast_d1 <= s_axis_pl2ps_rdm_tlast    ;  
        s_axis_pl2ps_rdm_tvalid_d1<= s_axis_pl2ps_rdm_tvalid   ;
        s_axis_pl2ps_rdm_tdata_d2 <= s_axis_pl2ps_rdm_tdata_d1 ;
        s_axis_pl2ps_rdm_tlast_d2 <= s_axis_pl2ps_rdm_tlast_d1 ;
        s_axis_pl2ps_rdm_tvalid_d2<= s_axis_pl2ps_rdm_tvalid_d1;
    end
end

always @(posedge clk) begin
    if(rst) begin
        s_axis_pl2ps_adc_tdata_d1 <= 'd0; 
        s_axis_pl2ps_adc_tlast_d1 <= 'd0; 
        s_axis_pl2ps_adc_tvalid_d1<= 'd0;
        s_axis_pl2ps_adc_tdata_d2 <= 'd0; 
        s_axis_pl2ps_adc_tlast_d2 <= 'd0; 
        s_axis_pl2ps_adc_tvalid_d2<= 'd0;
    end
    else begin 
        s_axis_pl2ps_adc_tdata_d1 <= s_axis_pl2ps_adc_tdata ; 
        s_axis_pl2ps_adc_tlast_d1 <= s_axis_pl2ps_adc_tlast ;
        s_axis_pl2ps_adc_tvalid_d1<= s_axis_pl2ps_adc_tvalid;
        s_axis_pl2ps_adc_tdata_d2 <= s_axis_pl2ps_adc_tdata_d1 ; 
        s_axis_pl2ps_adc_tlast_d2 <= s_axis_pl2ps_adc_tlast_d1 ;
        s_axis_pl2ps_adc_tvalid_d2<= s_axis_pl2ps_adc_tvalid_d1;  
    end
end

always @(posedge clk) begin
    if(rst) begin
        s_axis_pl2ps_ch0_tdata_d1  <= 'd0 ;
        s_axis_pl2ps_ch0_tlast_d1  <= 'd0 ;
        s_axis_pl2ps_ch0_tvalid_d1 <= 'd0 ;
        s_axis_pl2ps_ch0_tdata_d2  <= 'd0 ;
        s_axis_pl2ps_ch0_tlast_d2  <= 'd0 ;
        s_axis_pl2ps_ch0_tvalid_d2 <= 'd0 ;
    end
    else begin
        s_axis_pl2ps_ch0_tdata_d1  <=s_axis_pl2ps_ch0_tdata    ;
        s_axis_pl2ps_ch0_tlast_d1  <=s_axis_pl2ps_ch0_tlast    ;
        s_axis_pl2ps_ch0_tvalid_d1 <=s_axis_pl2ps_ch0_tvalid   ;
        s_axis_pl2ps_ch0_tdata_d2  <=s_axis_pl2ps_ch0_tdata_d1 ;
        s_axis_pl2ps_ch0_tlast_d2  <=s_axis_pl2ps_ch0_tlast_d1 ;
        s_axis_pl2ps_ch0_tvalid_d2 <=s_axis_pl2ps_ch0_tvalid_d1;
    end
end

always @(posedge clk) begin
    if(rst) begin
        s_axis_pl2ps_ch1_tdata_d1  <= 'd0 ;
        s_axis_pl2ps_ch1_tlast_d1  <= 'd0 ;
        s_axis_pl2ps_ch1_tvalid_d1 <= 'd0 ;
        s_axis_pl2ps_ch1_tdata_d2  <= 'd0 ;
        s_axis_pl2ps_ch1_tlast_d2  <= 'd0 ;
        s_axis_pl2ps_ch1_tvalid_d2 <= 'd0 ;
    end
    else begin
        s_axis_pl2ps_ch1_tdata_d1  <=s_axis_pl2ps_ch1_tdata    ;
        s_axis_pl2ps_ch1_tlast_d1  <=s_axis_pl2ps_ch1_tlast    ;
        s_axis_pl2ps_ch1_tvalid_d1 <=s_axis_pl2ps_ch1_tvalid   ;
        s_axis_pl2ps_ch1_tdata_d2  <=s_axis_pl2ps_ch1_tdata_d1 ;
        s_axis_pl2ps_ch1_tlast_d2  <=s_axis_pl2ps_ch1_tlast_d1 ;
        s_axis_pl2ps_ch1_tvalid_d2 <=s_axis_pl2ps_ch1_tvalid_d1;
    end
end

always @(posedge clk) begin
    if(rst) begin
        s_axis_pl2ps_ch2_tdata_d1  <= 'd0 ;
        s_axis_pl2ps_ch2_tlast_d1  <= 'd0 ;
        s_axis_pl2ps_ch2_tvalid_d1 <= 'd0 ;
        s_axis_pl2ps_ch2_tdata_d2  <= 'd0 ;
        s_axis_pl2ps_ch2_tlast_d2  <= 'd0 ;
        s_axis_pl2ps_ch2_tvalid_d2 <= 'd0 ;
    end
    else begin
        s_axis_pl2ps_ch2_tdata_d1  <=s_axis_pl2ps_ch2_tdata    ;
        s_axis_pl2ps_ch2_tlast_d1  <=s_axis_pl2ps_ch2_tlast    ;
        s_axis_pl2ps_ch2_tvalid_d1 <=s_axis_pl2ps_ch2_tvalid   ;
        s_axis_pl2ps_ch2_tdata_d2  <=s_axis_pl2ps_ch2_tdata_d1 ;
        s_axis_pl2ps_ch2_tlast_d2  <=s_axis_pl2ps_ch2_tlast_d1 ;
        s_axis_pl2ps_ch2_tvalid_d2 <=s_axis_pl2ps_ch2_tvalid_d1;
    end
end

always @(posedge clk) begin
    if(rst) begin
        s_axis_pl2ps_ch3_tdata_d1  <= 'd0 ;
        s_axis_pl2ps_ch3_tlast_d1  <= 'd0 ;
        s_axis_pl2ps_ch3_tvalid_d1 <= 'd0 ;
        s_axis_pl2ps_ch3_tdata_d2  <= 'd0 ;
        s_axis_pl2ps_ch3_tlast_d2  <= 'd0 ;
        s_axis_pl2ps_ch3_tvalid_d2 <= 'd0 ;
    end
    else begin
        s_axis_pl2ps_ch3_tdata_d1  <=s_axis_pl2ps_ch3_tdata    ;
        s_axis_pl2ps_ch3_tlast_d1  <=s_axis_pl2ps_ch3_tlast    ;
        s_axis_pl2ps_ch3_tvalid_d1 <=s_axis_pl2ps_ch3_tvalid   ;
        s_axis_pl2ps_ch3_tdata_d2  <=s_axis_pl2ps_ch3_tdata_d1 ;
        s_axis_pl2ps_ch3_tlast_d2  <=s_axis_pl2ps_ch3_tlast_d1 ;
        s_axis_pl2ps_ch3_tvalid_d2 <=s_axis_pl2ps_ch3_tvalid_d1;
    end
end

always @(posedge clk) begin
    if(rst) begin
        s_axis_pl2ps_ch4_tdata_d1  <= 'd0 ;
        s_axis_pl2ps_ch4_tlast_d1  <= 'd0 ;
        s_axis_pl2ps_ch4_tvalid_d1 <= 'd0 ;
        s_axis_pl2ps_ch4_tdata_d2  <= 'd0 ;
        s_axis_pl2ps_ch4_tlast_d2  <= 'd0 ;
        s_axis_pl2ps_ch4_tvalid_d2 <= 'd0 ;
    end
    else begin
        s_axis_pl2ps_ch4_tdata_d1  <=s_axis_pl2ps_ch4_tdata    ;
        s_axis_pl2ps_ch4_tlast_d1  <=s_axis_pl2ps_ch4_tlast    ;
        s_axis_pl2ps_ch4_tvalid_d1 <=s_axis_pl2ps_ch4_tvalid   ;
        s_axis_pl2ps_ch4_tdata_d2  <=s_axis_pl2ps_ch4_tdata_d1 ;
        s_axis_pl2ps_ch4_tlast_d2  <=s_axis_pl2ps_ch4_tlast_d1 ;
        s_axis_pl2ps_ch4_tvalid_d2 <=s_axis_pl2ps_ch4_tvalid_d1;
    end
end

always @(posedge clk) begin
    if(rst) begin
        s_axis_pl2ps_ch5_tdata_d1  <= 'd0 ;
        s_axis_pl2ps_ch5_tlast_d1  <= 'd0 ;
        s_axis_pl2ps_ch5_tvalid_d1 <= 'd0 ;
        s_axis_pl2ps_ch5_tdata_d2  <= 'd0 ;
        s_axis_pl2ps_ch5_tlast_d2  <= 'd0 ;
        s_axis_pl2ps_ch5_tvalid_d2 <= 'd0 ;
    end
    else begin
        s_axis_pl2ps_ch5_tdata_d1  <=s_axis_pl2ps_ch5_tdata    ;
        s_axis_pl2ps_ch5_tlast_d1  <=s_axis_pl2ps_ch5_tlast    ;
        s_axis_pl2ps_ch5_tvalid_d1 <=s_axis_pl2ps_ch5_tvalid   ;
        s_axis_pl2ps_ch5_tdata_d2  <=s_axis_pl2ps_ch5_tdata_d1 ;
        s_axis_pl2ps_ch5_tlast_d2  <=s_axis_pl2ps_ch5_tlast_d1 ;
        s_axis_pl2ps_ch5_tvalid_d2 <=s_axis_pl2ps_ch5_tvalid_d1;
    end
end


reg     [32:0] fifo_wr_data;
reg            fifo_wr_en  ;
wire    [32:0] fifo_rd_data;
wire           fifo_empty  ;
wire           fifo_rd_en  ;


always @(posedge clk) begin
    if(rst) begin
        fifo_wr_data <= 'd0 ;
    end
    else begin
        case (mux_ctr[7:0])
        'd0 :
            fifo_wr_data <= {s_axis_pl2ps_rdm_tlast_d2,s_axis_pl2ps_rdm_tdata_d2};
        'd1 : 
            fifo_wr_data <= {s_axis_pl2ps_adc_tlast_d2,s_axis_pl2ps_adc_tdata_d2};
        'd2 :
            fifo_wr_data <= {s_axis_pl2ps_ch0_tlast_d2,s_axis_pl2ps_ch0_tdata_d2};
        'd3 :
            fifo_wr_data <= {s_axis_pl2ps_ch1_tlast_d2,s_axis_pl2ps_ch1_tdata_d2};
        'd4 :
            fifo_wr_data <= {s_axis_pl2ps_ch2_tlast_d2,s_axis_pl2ps_ch2_tdata_d2};
        'd5 :
            fifo_wr_data <= {s_axis_pl2ps_ch3_tlast_d2,s_axis_pl2ps_ch3_tdata_d2};
        'd6 :
            fifo_wr_data <= {s_axis_pl2ps_ch4_tlast_d2,s_axis_pl2ps_ch4_tdata_d2};
        'd7 :
            fifo_wr_data <= {s_axis_pl2ps_ch5_tlast_d2,s_axis_pl2ps_ch5_tdata_d2};
            default: 
            fifo_wr_data <= {s_axis_pl2ps_rdm_tlast_d2,s_axis_pl2ps_rdm_tdata_d2};
        endcase
    end
end

always @(posedge clk) begin
    if(rst) begin
        fifo_wr_en <= 'd0 ;
    end
    else begin
        case (mux_ctr[7:0])
        'd0 :
            fifo_wr_en <= s_axis_pl2ps_rdm_tvalid_d2 ;
        'd1 :
            fifo_wr_en <= s_axis_pl2ps_adc_tvalid_d2 ;
        'd2 :
            fifo_wr_en <= s_axis_pl2ps_ch0_tvalid_d2 ;
        'd3 :
            fifo_wr_en <= s_axis_pl2ps_ch1_tvalid_d2 ;
        'd4 :
            fifo_wr_en <= s_axis_pl2ps_ch2_tvalid_d2 ;
        'd5 :
            fifo_wr_en <= s_axis_pl2ps_ch3_tvalid_d2 ;
        'd6 :
            fifo_wr_en <= s_axis_pl2ps_ch4_tvalid_d2 ;
        'd7 :
            fifo_wr_en <= s_axis_pl2ps_ch5_tvalid_d2 ;  
        default :
            fifo_wr_en <= s_axis_pl2ps_rdm_tvalid_d2 ;
        endcase
    end
end
(*MARK_DEBUG = "TRUE"*) wire fifo_full  ;
xfifo_async_w33d2048_d0 xfifo_async_w33d2048_d0 
(
    .rst            (rst                    ),
    .wr_clk         (clk                    ),
    .rd_clk         (ps_clk_200m            ),
    .din            (fifo_wr_data           ),
    .wr_en          (fifo_wr_en             ),
    .rd_en          (fifo_rd_en             ),
    .dout           (fifo_rd_data           ),
    .full           (fifo_full              ),
    .empty          (fifo_empty             ),
    .wr_rst_busy    (),
    .rd_rst_busy    ()
);

assign m_axis_pl2ps_dma0_tdata   = fifo_rd_data[31:0]  ;
assign m_axis_pl2ps_dma0_tlast   = fifo_rd_data[32]    ;
assign m_axis_pl2ps_dma0_tvalid  = ~fifo_empty & m_axis_pl2ps_dma0_tready ;
assign fifo_rd_en                = ~fifo_empty & m_axis_pl2ps_dma0_tready ;
assign m_axis_pl2ps_dma0_tkeep   = 'hf                 ;


//--------------------------------dma1--------------------------------------
reg     [32:0] fifo_wr_data_dma1 ;
reg            fifo_wr_en_dma1   ;
wire    [32:0] fifo_rd_data_dma1 ;
wire           fifo_empty_dma1   ;
wire           fifo_rd_en_dma1   ;
wire           fifo_full_dma1    ;

always @(posedge clk) begin
    if(rst) begin
        fifo_wr_data_dma1 <= 'd0 ;
    end
    else begin
        fifo_wr_data_dma1 <= {s_axis_pl2ps_adc_tlast_d2,s_axis_pl2ps_adc_tdata_d2};
    end
end

always @(posedge clk) begin
    if(rst) begin
        fifo_wr_en_dma1 <= 'd0 ;
    end
    else if(mux_ctr[15:8] == 8'h01 )
        fifo_wr_en_dma1 <= s_axis_pl2ps_adc_tvalid_d2 ;
    else
        fifo_wr_en_dma1 <= fifo_wr_en_dma1 ;
end

xfifo_async_w33d2048_d0 xfifo_async_w33d2048_d0_dma1 
(
    .rst            (rst                    ),
    .wr_clk         (clk                    ),
    .rd_clk         (ps_clk_200m            ),
    .din            (fifo_wr_data_dma1      ),
    .wr_en          (fifo_wr_en_dma1        ),
    .rd_en          (fifo_rd_en_dma1        ),
    .dout           (fifo_rd_data_dma1      ),
    .full           (fifo_full_dma1         ),
    .empty          (fifo_empty_dma1        ),
    .wr_rst_busy    (),
    .rd_rst_busy    ()
); 

assign m_axis_pl2ps_dma1_tdata   = fifo_rd_data_dma1[31:0]  ;
assign m_axis_pl2ps_dma1_tlast   = fifo_rd_data_dma1[32]    ;
assign m_axis_pl2ps_dma1_tvalid  = ~fifo_empty_dma1 & m_axis_pl2ps_dma1_tready ;
assign fifo_rd_en_dma1           = ~fifo_empty_dma1 & m_axis_pl2ps_dma1_tready ;
assign m_axis_pl2ps_dma1_tkeep   = 'hf                 ;




endmodule
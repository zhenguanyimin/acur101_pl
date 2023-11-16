module adc_pack
(
    input   wire        clk                  ,

    input   wire        rst                      ,
    input   wire        dma_ready                ,

    input   wire        PRI                      ,
    input   wire        CPIB                     ,
    input   wire        CPIE                     ,
    input   wire        sample_gate              ,

    input   wire [15:0] sample_num               ,
    input   wire [15:0] chirp_num                ,

    input   wire [15:0] adc_data_i               ,
    input   wire        adc_data_valid_i         ,

    output  reg         adc_data_sop             ,
    output  reg         adc_data_eop             ,
    output  reg  [15:0] adc_data                 ,
    output  reg         adc_data_valid           
);

reg         PRI_d1  ;
reg         PRI_d2  ;
reg         PRI_d3  ;
reg         PRI_d4  ;

reg         CPIB_d1 ;
reg         CPIB_d2 ;
reg         CPIB_d3 ;
reg         CPIB_d4 ;

reg         CPIE_d1 ;
reg         CPIE_d2 ;
reg         CPIE_d3 ;
reg         CPIE_d4 ;

reg         sample_gate_d1 ;
reg         sample_gate_d2 ;
reg         sample_gate_d3 ;
reg         sample_gate_d4 ;

reg         dma_ready_d1   ;
reg         dma_ready_d2   ;
reg         dma_ready_d3   ;

//-------------------------跨时钟域----------------------------------

always @(posedge  clk  ) begin
    PRI_d1          <=  PRI            ;
    PRI_d2          <=  PRI_d1         ;
    PRI_d3          <=  PRI_d2         ;
    PRI_d4          <=  PRI_d3         ;
end

always @(posedge  clk  ) begin
    CPIB_d1         <=  CPIB           ;
    CPIB_d2         <=  CPIB_d1        ;
    CPIB_d3         <=  CPIB_d2        ;
    CPIB_d4         <=  CPIB_d3        ;
end

always @(posedge  clk  ) begin
    CPIE_d1         <=  CPIE           ;
    CPIE_d2         <=  CPIE_d1        ;
    CPIE_d3         <=  CPIE_d2        ;
    CPIE_d4         <=  CPIE_d3        ;
end

always @(posedge  clk  ) begin
    sample_gate_d1  <=  sample_gate    ;
    sample_gate_d2  <=  sample_gate_d1 ;
    sample_gate_d3  <=  sample_gate_d2 ;
    sample_gate_d4  <=  sample_gate_d3 ;
end

always @(posedge  clk  ) begin
    dma_ready_d1 <= dma_ready    ;
    dma_ready_d2 <= dma_ready_d1 ;
    dma_ready_d3 <= dma_ready_d2 ;
end

reg  [15:0] adc_data_i_d1         ;
reg         adc_data_valid_i_d1   ;
reg  [15:0] adc_data_i_d2         ;
reg         adc_data_valid_i_d2   ;

always @(posedge  clk   ) begin
    if(rst) begin
        adc_data_i_d1 <= 'd0 ;
        adc_data_i_d2 <= 'd0 ;
    end
    else begin 
        adc_data_i_d1 <= adc_data_i    ;
        adc_data_i_d2 <= adc_data_i_d1 ;
    end
end

always @(posedge  clk   ) begin
    if(rst) begin
        adc_data_valid_i_d1 <= 'd0 ;
        adc_data_valid_i_d2 <= 'd0 ;
    end
    else begin
        adc_data_valid_i_d1 <= adc_data_valid_i    ;
        adc_data_valid_i_d2 <= adc_data_valid_i_d1 ;
    end
end

reg [15:0]  sample_num_d1 ;
reg [15:0]  sample_num_d2 ;

always @(posedge  clk  ) begin
    if(rst) begin
        sample_num_d1 <= 'd0 ;
        sample_num_d2 <= 'd0 ;
    end
    else begin
        sample_num_d1 <= sample_num    ;
        sample_num_d2 <= sample_num_d1 ;
    end
end

//------------------------------------------------------------------

reg             fifo_wr_en         ;
reg             fifo_rd_en         ;
wire            fifo_empty         ;
wire [15:0]     fifo_rd_data       ;
wire            fifo_full          ;
reg  [15:0]     fifo_din           ;
reg  [16:0]     fifo_wr_en_cnt     ;

xfifo_async_w16d4096_d2 xfifo_async_w16d4096_d2
(
    .rst                (rst            ),
    .wr_clk             (clk        ),
    .rd_clk             (clk        ),
    .din                (fifo_din       ),
    .wr_en              (fifo_wr_en     ),
    .rd_en              (fifo_rd_en     ),
    .dout               (fifo_rd_data   ),
    .full               (fifo_full      ),
    .empty              (fifo_empty     ),
    // .rd_data_count      (rd_data_count  ),
    // .wr_data_count      (wr_data_count  ),
    .wr_rst_busy        (               ),
    .rd_rst_busy        (               )
);

//---------------------------------wr----------------------------------

always @(posedge  clk   ) begin
    if(rst)
        fifo_din <= 'd0 ;
    else 
        fifo_din <=  adc_data_i_d2 ;
end

reg     cpib_sync ;
always @(posedge  clk   ) begin
    if(rst)
        cpib_sync <= 'd0 ;
    else if(dma_ready_d3) 
        if(~CPIB_d3 && CPIB_d2 )
            cpib_sync <= 'd1 ;
        else
            cpib_sync <= cpib_sync ;
    else
        cpib_sync <= 'd0 ;
end

always @(posedge  clk   ) begin
    if(rst)
        fifo_wr_en <= 'd0 ;
    else if(cpib_sync && sample_gate_d3 && adc_data_valid_i_d2 )
        fifo_wr_en <= 1'b1 ;
    else 
        fifo_wr_en <= 'd0 ;
end

always @(posedge  clk   ) begin
    if(rst)
        fifo_wr_en_cnt <= 'd0 ;
    else if(fifo_wr_en)
        if(fifo_wr_en_cnt == sample_num_d2 - 1 )
            fifo_wr_en_cnt <= 'd0 ;
        else     
            fifo_wr_en_cnt <= fifo_wr_en_cnt + 1'b1 ;
    else
        fifo_wr_en_cnt <= fifo_wr_en_cnt ;
end

//------------------------------rd--------------------------------------

reg     write_end_flag ;
reg     write_end_flag_d1 ;
reg     write_end_flag_d2 ;

always @(posedge  clk  ) begin
    if(rst)
        write_end_flag <= 'd0 ;
    else if(fifo_wr_en_cnt == sample_num_d2 - 1)
        write_end_flag <= 'd1 ;
    else 
        write_end_flag <= 'd0 ;
end

always @(posedge clk) begin
    if(rst) begin
        write_end_flag_d1 <= 'd0 ;
        write_end_flag_d2 <= 'd0 ; 
    end
    else begin
        write_end_flag_d1 <= write_end_flag ;
        write_end_flag_d2 <= write_end_flag_d1 ; 
    end
end

reg [15:0]  fifo_rd_en_cnt ;

always @(posedge clk ) begin
    if(rst)
        fifo_rd_en_cnt <= 'd0 ;
    else if(fifo_rd_en)
        if(fifo_rd_en_cnt == sample_num_d2 -1  )
            fifo_rd_en_cnt <= 'd0 ;
        else 
            fifo_rd_en_cnt <= fifo_rd_en_cnt + 1'b1;
    else
        fifo_rd_en_cnt <= fifo_rd_en_cnt ;
end

always @(posedge clk ) begin
    if(rst)
        fifo_rd_en <= 'd0 ;
    else if(write_end_flag_d2)
        fifo_rd_en <= 1'b1;
    else if(fifo_rd_en_cnt == sample_num_d2 - 1)
        fifo_rd_en <= 1'd0;
    else 
        fifo_rd_en <= fifo_rd_en ;
end

//---------------------------------output-------------------------------
reg [15:0]      fifo_rd_data_d1 ;
reg [15:0]      fifo_rd_data_d2 ;

reg             fifo_rd_en_d1   ;
reg             fifo_rd_en_d2   ;

always @(posedge clk) begin
    if(rst) begin
        fifo_rd_data_d1 <= 'd0 ;
        fifo_rd_data_d2 <= 'd0 ;
    end
    else begin
        fifo_rd_data_d1 <= fifo_rd_data    ;
        fifo_rd_data_d2 <= fifo_rd_data_d1 ;
    end
end

always @(posedge clk) begin
    if(rst) begin
        fifo_rd_en_d1   <= 'd0 ;
        fifo_rd_en_d2   <= 'd0 ;
    end
    else begin
        fifo_rd_en_d1   <= fifo_rd_en   ;
        fifo_rd_en_d2   <= fifo_rd_en_d1;
    end
end
always @(posedge clk ) begin
    if(rst)
        adc_data_sop <= 'd0 ;
    else if(fifo_rd_en_d1 && ~fifo_rd_en_d2)
        adc_data_sop <= 'd1 ;
    else
        adc_data_sop <= 'd0 ;
end



always @(posedge clk) begin
    if(rst) begin
        adc_data_eop <= 'd0 ;
    end
    else if(~fifo_rd_en && fifo_rd_en_d1)
        adc_data_eop <= 'd1 ;
    else 
        adc_data_eop <= 'd0 ;
end

always @(posedge clk) begin
    if(rst) begin
        adc_data  <= 'd0 ;
    end
    else begin 
        adc_data  <= fifo_rd_data_d1;
    end         
end

always @(posedge clk) begin
    if(rst) begin
        adc_data_valid <= 'd0 ;
    end
    else begin
        adc_data_valid <= fifo_rd_en_d1 ;
    end
end

endmodule
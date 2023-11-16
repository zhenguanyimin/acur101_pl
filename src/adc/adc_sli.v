module adc_sil
(
    input               clk ,
    input               rst ,

    input [31:0]        adc_sli_axis_tdata ,
    input               adc_sli_axis_tvalid,
    input               adc_sli_axis_tlast ,

    input [15:0]        sample_num ,
    input [15:0]        chirp_num ,  

    output reg [15:0]   adc_sli_data ,
    output reg          adc_sli_sop ,
    output reg          adc_sli_eop ,
    output reg          adc_sli_vliad
);

reg [31:0]  adc_sli_axis_tdata_d1 ;
reg [31:0]  adc_sli_axis_tdata_d2 ;
reg [3 :0]  adc_sli_axis_tvalid_shift ;
reg [3 :0]  adc_sli_axis_tlast_shift ;
reg [15:0]  sample_num_d1 ;
reg [15:0]  sample_num_d2 ;
reg [15:0]  chirp_num_d1 ;
reg [15:0]  chirp_num_d2 ;

always @(posedge clk ) begin
    if(rst) begin
        adc_sli_axis_tdata_d1 <= 'd0 ;
        adc_sli_axis_tdata_d2 <= 'd0 ;
    end
    else begin
        adc_sli_axis_tdata_d1 <= adc_sli_axis_tdata ;
        adc_sli_axis_tdata_d2 <= adc_sli_axis_tdata_d1 ;
    end
end

always @(posedge clk ) begin
    if(rst)
        adc_sli_axis_tvalid_shift <= 'd0 ;
    else 
        adc_sli_axis_tvalid_shift <= {adc_sli_axis_tvalid_shift[2:0],adc_sli_axis_tvalid} ;    
end

always @(posedge clk) begin
    if(rst)
        adc_sli_axis_tlast_shift <= 'd0 ;
    else 
        adc_sli_axis_tlast_shift <= {adc_sli_axis_tlast_shift[2:0],adc_sli_axis_tlast} ;
end

always @(posedge clk) begin
    if(rst) begin 
        chirp_num_d1 <= 'd0 ;
        chirp_num_d2 <= 'd0 ;
    end
    else begin
        chirp_num_d1 <= chirp_num ;
        chirp_num_d2 <= chirp_num_d1 ;
    end
end

always @(posedge clk) begin
    if(rst) begin
        sample_num_d1 <= 'd0 ;
        sample_num_d2 <= 'd0 ;
    end
    else begin
        sample_num_d1 <= sample_num ;
        sample_num_d2 <= sample_num_d1 ;
    end
end

reg         fifo_rd_en ;
wire[15:0]  fifo_dout  ;

xfifo_sync_w32d2048_d0 xfifo_sync_w32d2048_d0
(
    .clk            (clk                            ),
    .srst           (rst                            ),
    .din            (adc_sli_axis_tdata_d2          ),
    .wr_en          (adc_sli_axis_tvalid_shift[1]   ),
    .rd_en          (fifo_rd_en                     ),
    .dout           (fifo_dout                      ),
    .full           (),
    .empty          (),
    .wr_rst_busy    (),
    .rd_rst_busy    ()
);

reg [15:0]  fifo_wr_en_cnt ;
always @(posedge clk) begin
    if(rst)
        fifo_wr_en_cnt <= 'd0 ;
    else if(adc_sli_axis_tvalid_shift[1])
        case (sample_num_d2)
            'd4096: fifo_wr_en_cnt <= (fifo_wr_en_cnt == 'd2047) ? 'd0 : fifo_wr_en_cnt + 1'b1 ;
            'd2048: fifo_wr_en_cnt <= (fifo_wr_en_cnt == 'd1023) ? 'd0 : fifo_wr_en_cnt + 1'b1 ;
            'd1024: fifo_wr_en_cnt <= (fifo_wr_en_cnt == 'd511 ) ? 'd0 : fifo_wr_en_cnt + 1'b1 ;
            default: 
                fifo_wr_en_cnt <= fifo_wr_en_cnt ;
        endcase
    else 
        fifo_wr_en_cnt <= fifo_wr_en_cnt; 
end

reg [15:0]  fifo_rd_en_cnt ;
always @(posedge clk ) begin
    if(rst)
        fifo_rd_en_cnt <= 'd0 ;
    else if (fifo_rd_en)
        case (sample_num_d2)
            'd4096: fifo_rd_en_cnt <= (fifo_rd_en_cnt == 'd4095) ? 'd0 : fifo_rd_en_cnt + 1'b1 ;
            'd2048: fifo_rd_en_cnt <= (fifo_rd_en_cnt == 'd2047) ? 'd0 : fifo_rd_en_cnt + 1'b1 ;
            'd1024: fifo_rd_en_cnt <= (fifo_rd_en_cnt == 'd1023) ? 'd0 : fifo_rd_en_cnt + 1'b1 ;
            default: 
                fifo_rd_en_cnt <= fifo_rd_en_cnt ;
        endcase
    else
        fifo_rd_en_cnt <= fifo_rd_en_cnt; 
end

always @(posedge clk) begin
    if(rst)
        fifo_rd_en <= 'd0 ;
    else if((sample_num_d2 == 'd4096 && fifo_wr_en_cnt == 'd2047)||(sample_num_d2 == 'd2048 && fifo_wr_en_cnt == 'd1023) || (sample_num_d2 == 'd1024 && fifo_wr_en_cnt == 'd511))
        fifo_rd_en <= 'd1 ;
    else if((sample_num_d2 == 'd4096 && fifo_rd_en_cnt == 'd4095)||(sample_num_d2 == 'd2048 && fifo_rd_en_cnt == 'd2047) || (sample_num_d2 == 'd1024 && fifo_rd_en_cnt == 'd1023))
        fifo_rd_en <= 'd0 ;
    else 
        fifo_rd_en <= fifo_rd_en ;
end

reg [7:0]   fifo_rd_en_shift ;
always @(posedge clk) begin
    if(rst)
        fifo_rd_en_shift <= 'd0 ;
    else 
        fifo_rd_en_shift <= {fifo_rd_en_shift[6:0],fifo_rd_en};
end

reg [15:0]      fifo_dout_d1 ;
reg [15:0]      fifo_dout_d2 ;


always @(posedge clk) begin
    if(rst) begin
        fifo_dout_d1 <= 'd0 ;
        fifo_dout_d2 <= 'd0 ;
    end
    else begin
        fifo_dout_d1 <= fifo_dout ;
        fifo_dout_d2 <= fifo_dout_d1 ;
    end
end

always @(posedge clk) begin
    if(rst)
        adc_sli_data <= 'd0 ;
    else 
        adc_sli_data <= fifo_dout_d2 ;
end

always @(posedge clk) begin
    if(rst)
        adc_sli_sop <= 'd0 ;
    else if (fifo_rd_en_shift[1] && ~fifo_rd_en_shift[2])
        adc_sli_sop <= 'd1 ;
    else 
        adc_sli_sop <= 'd0 ;
end

always @(posedge clk) begin
    if(rst)
        adc_sli_eop <= 'd0 ;
    else if(~fifo_rd_en_shift[0] && fifo_rd_en_shift[1])
        adc_sli_eop <= 'd1 ;
    else 
        adc_sli_eop <= 'd0 ;
end

always @(posedge clk) begin
    if(rst)
        adc_sli_vliad <= 'd0 ;
    else
        adc_sli_vliad <= fifo_rd_en_shift[1] ;
end

endmodule
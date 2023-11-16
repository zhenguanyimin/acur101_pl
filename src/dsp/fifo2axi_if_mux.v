module fifo2axi_mux
(
    input           clk ,
    input           rst ,

    input           mux_s             ,
    input [63:0]    fifo_din_cmd_ch0  ,
    input           fifo_wr_en_cmd_ch0,
    output          fifo_full_cmd_ch0 ,
    
    input           fifo_wr_en_wr_ch0 ,
    input [127:0]   fifo_din_wr_ch0   ,
    output          fifo_full_wr_ch0  ,

    input [63:0]    fifo_din_cmd_ch1  ,
    input           fifo_wr_en_cmd_ch1,
    output          fifo_full_cmd_ch1 ,
    
    input           fifo_wr_en_wr_ch1 ,
    input [127:0]   fifo_din_wr_ch1   ,
    output          fifo_full_wr_ch1  ,
    
    output  [63:0]  fifo_din_cmd_o  ,
    output          fifo_wr_en_cmd_o,
    input           fifo_full_cmd_i ,
    
    output          fifo_wr_en_wr_o ,
    output  [127:0] fifo_din_wr_o   ,
    input           fifo_full_wr_i  
);

reg  [63:0]  fifo_din_cmd_reg  ;
reg          fifo_wr_en_cmd_reg;
reg          fifo_wr_en_wr_reg ;
reg  [127:0] fifo_din_wr_reg   ;

reg          fifo_full_wr_ch1_reg ;
reg          fifo_full_cmd_ch1_reg;
reg          fifo_full_wr_ch0_reg ;
reg          fifo_full_cmd_ch0_reg;         

always @(posedge clk) begin
    if(rst) begin
        fifo_din_cmd_reg        <= 'd0 ;
        fifo_wr_en_cmd_reg      <= 'd0 ;
        fifo_wr_en_wr_reg       <= 'd0 ;
        fifo_din_wr_reg         <= 'd0 ;
        fifo_full_wr_ch1_reg    <= 'd0 ;
        fifo_full_cmd_ch1_reg   <= 'd0 ;
        fifo_full_wr_ch0_reg    <= 'd0 ;
        fifo_full_cmd_ch0_reg   <= 'd0 ;
    end
    else if(mux_s)  begin
        fifo_din_cmd_reg        <=  fifo_din_cmd_ch1;
        fifo_wr_en_cmd_reg      <=  fifo_wr_en_cmd_ch1;
        fifo_wr_en_wr_reg       <=  fifo_wr_en_wr_ch1;
        fifo_din_wr_reg         <=  fifo_din_wr_ch1;
        fifo_full_wr_ch1_reg    <=  fifo_full_wr_i ;
        fifo_full_cmd_ch1_reg   <=  fifo_full_cmd_i ;
        fifo_full_wr_ch0_reg    <=  'd0 ;
        fifo_full_cmd_ch0_reg   <=  'd0 ;
    end
    else begin
        fifo_din_cmd_reg        <=  fifo_din_cmd_ch0;
        fifo_wr_en_cmd_reg      <=  fifo_wr_en_cmd_ch0;
        fifo_wr_en_wr_reg       <=  fifo_wr_en_wr_ch0;
        fifo_din_wr_reg         <=  fifo_din_wr_ch0;
        fifo_full_wr_ch1_reg    <=  'd0 ;
        fifo_full_cmd_ch1_reg   <=  'd0 ;
        fifo_full_wr_ch0_reg    <=  fifo_full_wr_i ;
        fifo_full_cmd_ch0_reg   <=  fifo_full_cmd_i; 
    end
end

assign fifo_din_cmd_o  = fifo_din_cmd_reg ;
assign fifo_wr_en_cmd_o = fifo_wr_en_cmd_reg ;

assign  fifo_wr_en_wr_o = fifo_wr_en_wr_reg ;
assign  fifo_din_wr_o = fifo_din_wr_reg ;

assign fifo_full_cmd_ch0 = fifo_full_cmd_ch0_reg ;
assign fifo_full_wr_ch0  = fifo_full_wr_ch0_reg ;

assign fifo_full_cmd_ch1 = fifo_full_cmd_ch1_reg ;
assign fifo_full_wr_ch1  = fifo_full_wr_ch1_reg ;

endmodule
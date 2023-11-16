module ps_ddr_test
(
    input   wire        clk            ,
    input   wire        rst            ,

    input   wire [31:0] test_len       ,
    input   wire        ddr_test_start ,

    output  wire [63:0] fifo_din_cmd   ,
    output  reg         fifo_wr_en_cmd ,
    input   wire        fifo_full_cmd  ,
    input   wire        fifo_empty_cmd ,
    
    output  reg         fifo_wr_en_wr  ,
    output  wire [127:0]fifo_din_wr    ,
    input   wire        fifo_full_wr   ,
    input   wire        fifo_empty_wr  ,

    input   wire [127:0]fifo_dout_rd   ,
    output  reg         fifo_rd_en_rd  ,
    input   wire        fifo_empty_rd  ,
    input   wire        data_rd_valid  ,
    input   wire        fifo_full_rd   
);

// parameter  test_len = 'd300;

reg     ddr_test_start_d1 ;
reg     ddr_test_start_d2 ;

always @(posedge clk) begin
    ddr_test_start_d1 <= ddr_test_start     ;
    ddr_test_start_d2 <= ddr_test_start_d1  ;
end

parameter IDLE      = 3'd0 ;
parameter WR        = 3'd1 ;
parameter RD        = 3'd2 ;


reg [127:0]  ddr_data           ;
reg          ddr_data_valid     ;
reg [7  :0]  ddr_data_valid_cnt ;


reg [2 :0]   cur_state          ;
reg [2 :0]   nxt_state          ;

always @(posedge clk) begin
    if(rst)
        cur_state <=    IDLE      ;
    else 
        cur_state <=    nxt_state ;
end

reg [31:0]  fifo_wr_en_cmd_cnt ;

always @(*) begin
    case(cur_state)
    IDLE :
        if(~ddr_test_start_d2 && ddr_test_start_d1 )
            nxt_state = WR  ;
        else 
            nxt_state = IDLE ;
    WR  :
        if(fifo_wr_en_cmd_cnt == test_len && fifo_empty_wr && fifo_empty_cmd)
            nxt_state = RD ;
        else
            nxt_state = WR ;
    RD  :
        if(fifo_wr_en_cmd_cnt == test_len )
            nxt_state = IDLE ;
        else 
            nxt_state = RD ;
    endcase
end

always @(posedge clk) begin
    if(rst)
        fifo_wr_en_cmd_cnt <= 'd0 ;
    else if(cur_state == WR && nxt_state == RD )
        fifo_wr_en_cmd_cnt <= 'd0 ;
    else if(fifo_wr_en_cmd )
        fifo_wr_en_cmd_cnt <= fifo_wr_en_cmd_cnt + 1'b1 ;
    else 
        fifo_wr_en_cmd_cnt <= fifo_wr_en_cmd_cnt ;
end

//----------------------------------------------------------------------------
reg [7 :0]  fifo_wr_en_wr_cnt ;
reg [48:0]  addr              ;

always @(posedge clk) begin
    if(rst)
        addr <= 'h7000_0000 ;
    else if(cur_state == WR && nxt_state == RD )
        addr <= 'h7000_0000 ;
    else if(fifo_wr_en_cmd)
        addr <= addr + 'h1000 ;
    else 
        addr <= addr ;
end



reg  rd_busy ;

always @(posedge clk) begin
    if(rst)
        rd_busy <= 'd0 ;
    else if(fifo_wr_en_cmd == 'd1 && cur_state == RD)
        rd_busy <= 'd1 ;
    else if(ddr_data_valid_cnt == 'd255)
        rd_busy <= 'd0 ;
    else 
        rd_busy <= rd_busy;
end

reg     [31:0]  fifo_wr_en_wr_cnt_d1 ;
always @(posedge clk) begin
    fifo_wr_en_wr_cnt_d1 <= fifo_wr_en_wr_cnt ; 
end

assign fifo_din_cmd = {(cur_state == RD),2'd0,addr,12'hfff};

always @(posedge clk) begin
    if(rst)
        fifo_wr_en_cmd <= 'd0 ;
    else if(cur_state == WR && fifo_wr_en_cmd_cnt <= test_len-1 )
        if(fifo_wr_en_wr_cnt == 'd254 && fifo_wr_en_wr_cnt_d1 == 'd253 )
            fifo_wr_en_cmd <= 'd1 ;
        else 
            fifo_wr_en_cmd <= 'd0 ;
    else if(cur_state == RD && fifo_wr_en_cmd_cnt <= test_len-1  )
        if(~rd_busy && ~fifo_wr_en_cmd )
            fifo_wr_en_cmd <= 'd1 ;
        else 
            fifo_wr_en_cmd <= 'd0 ;
    else
        fifo_wr_en_cmd <=  'd0 ;
end

always @(posedge clk) begin
    if(rst)
        fifo_wr_en_wr_cnt <= 'd0 ;
    else if(fifo_wr_en_wr)
        fifo_wr_en_wr_cnt <= fifo_wr_en_wr_cnt + 1'b1 ;
    else 
        fifo_wr_en_wr_cnt <= fifo_wr_en_wr_cnt; 
end

//-------------------------------------------------------------------------- 

always @(posedge clk) begin
    if(rst)
        fifo_wr_en_wr <= 'd0 ; 
    else if( fifo_wr_en_cmd_cnt == test_len - 1  && fifo_wr_en_wr_cnt == 'd255)
        fifo_wr_en_wr <= 'd0 ;
    else if(cur_state == WR && fifo_wr_en_cmd_cnt <= test_len - 1 )
        if(~fifo_full_wr)
            fifo_wr_en_wr <= 'd1 ; 
        else 
            fifo_wr_en_wr <= 'd0 ;
    else 
        fifo_wr_en_wr <= 'd0 ;
end

reg [31:0]  test_data_0 ;
reg [31:0]  test_data_1 ;
reg [31:0]  test_data_2 ;
reg [31:0]  test_data_3 ;

always @(posedge clk) begin
    if(rst)
        test_data_0 <= 'd0 ;
    else if(fifo_wr_en_wr )
        test_data_0 <= test_data_0 + 'h4 ;
    else 
        test_data_0 <= test_data_0 ;
end

always @(posedge clk) begin
    if(rst)
        test_data_1 <= 'd1 ;
    else if(fifo_wr_en_wr )
        test_data_1 <= test_data_1 + 'h4 ;
    else 
        test_data_1 <= test_data_1 ;
end

always @(posedge clk) begin
    if(rst)
        test_data_2 <= 'd2 ;
    else if(fifo_wr_en_wr )
        test_data_2 <= test_data_2 + 'h4 ;
    else 
        test_data_2 <= test_data_2 ;
end

always @(posedge clk) begin
    if(rst)
        test_data_3 <= 'd3 ;
    else if(fifo_wr_en_wr )
        test_data_3 <= test_data_3 + 'h4 ;
    else 
        test_data_3 <= test_data_3 ;
end

assign fifo_din_wr = {test_data_3,test_data_2,test_data_1,test_data_0} ;

//---------------------------------------------------------------------------

// assign fifo_rd_en_rd = 1'b1 ;

always @(posedge clk) begin
    if(rst)
        fifo_rd_en_rd <= 'd0 ;
    else if(~fifo_empty_rd)
        fifo_rd_en_rd <= 'd1 ;
    else
        fifo_rd_en_rd <= 'd0 ;
end


always @(posedge clk) begin
    if(rst)
        ddr_data <= 'd0 ;
    else if(fifo_rd_en_rd && data_rd_valid )
        ddr_data <= fifo_dout_rd ;
    else 
        ddr_data <= ddr_data ; 
end

always @(posedge clk) begin
    if(rst)
        ddr_data_valid <= 'd0 ;
    else if(fifo_rd_en_rd && data_rd_valid )
        ddr_data_valid <= 'd1 ;
    else 
        ddr_data_valid <= 'd0 ;
end

always @(posedge clk) begin
    if(rst)
        ddr_data_valid_cnt <= 'd0 ;
    else if(ddr_data_valid)
        ddr_data_valid_cnt <= ddr_data_valid_cnt + 1'b1 ;
    else 
        ddr_data_valid_cnt <= ddr_data_valid_cnt ;
end

reg [31:0]  check_data_0 ;
reg [31:0]  check_data_1 ;
reg [31:0]  check_data_2 ;
reg [31:0]  check_data_3 ;

always @(posedge clk) begin
    if(rst)
        check_data_0 <='d0 ;    
    else if(ddr_data_valid)
        check_data_0 <= check_data_0 + 'h4 ;
    else 
        check_data_0 <= check_data_0 ;
end

always @(posedge clk) begin
    if(rst)
        check_data_1 <='d1 ;    
    else if(ddr_data_valid)
        check_data_1 <= check_data_1 + 'h4 ;
    else 
        check_data_1 <= check_data_1 ;
end

always @(posedge clk) begin
    if(rst)
        check_data_2 <='d2 ;    
    else if(ddr_data_valid)
        check_data_2 <= check_data_2 + 'h4 ;
    else 
        check_data_2 <= check_data_2 ;
end

always @(posedge clk) begin
    if(rst)
        check_data_3 <='d3 ;    
    else if(ddr_data_valid)
        check_data_3 <= check_data_3 + 'h4 ;
    else 
        check_data_3 <= check_data_3 ;
end

(* MARK_DEBUG="true" *) reg check_err ;
always @(posedge clk) begin
    if(rst)
        check_err <= 'd0 ;
    else if(ddr_data_valid)
        if(ddr_data != {check_data_3,check_data_2,check_data_1,check_data_0})
            check_err <= 'd1 ;
        else 
            check_err <= 'd0 ;

    else 
        check_err <= check_err;
end

//-------------------------------------debug-----------------------------------------

(* MARK_DEBUG="true" *)reg [31:0]  total_time_wr ;
(* MARK_DEBUG="true" *)reg [31:0]  total_time_rd ;
(* MARK_DEBUG="true" *)reg [31:0]  check_err_cnt ;


always @(posedge clk) begin
    if(rst)
        total_time_wr <= 'd0 ;
    else if(cur_state == WR)
        total_time_wr <= total_time_wr + 1'b1 ;
    else
        total_time_wr <= total_time_wr ;
end

always @(posedge clk) begin
    if(rst)
        total_time_rd <= 'd0 ;
    else if(cur_state == RD)
        total_time_rd <= total_time_rd + 1'b1 ;
    else 
        total_time_rd <= total_time_rd ;
end

always @(posedge clk) begin
    if(rst)
        check_err_cnt <= 'd0 ;
    else if(check_err)
        check_err_cnt <= check_err_cnt + 1'b1 ;
    else 
        check_err_cnt <= check_err_cnt; 
end

endmodule
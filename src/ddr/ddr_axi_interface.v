module  ddr_axi_interface
#(
	parameter READ_CH_ENABLE    = 0, 
	parameter WRITE_CH_ENABLE   = 0
)
(
    input   wire        clk             ,
    input   wire        rst             ,
    input   wire        ddr_clk         ,

    input   wire [63:0] fifo_din_cmd    ,
    input   wire        fifo_wr_en_cmd  ,
    output  wire        fifo_full_cmd   ,
    output  wire        fifo_empty_cmd  ,
    
    input   wire        fifo_wr_en_wr   ,
    input   wire [127:0]fifo_din_wr     ,
    output  wire        fifo_full_wr    ,
    output  wire        fifo_empty_wr   ,

    output  wire [127:0]fifo_dout_rd    ,
    input   wire        fifo_rd_en_rd   ,
    output  wire        fifo_empty_rd   ,
    output  wire        fifo_full_rd    ,
    output  wire        data_rd_valid   ,
    output  reg         op_finish_flag  ,
// ar
    output reg  [48: 0]   s_axi_araddr   ,
    output      [1 : 0]   s_axi_arburst  ,
    output      [3 : 0]   s_axi_arcache  ,
    output      [5 : 0]   s_axi_arid     ,
    output reg  [7 : 0]   s_axi_arlen    ,
    output                s_axi_arlock   ,
    output      [2 : 0]   s_axi_arprot   ,
    output      [3 : 0]   s_axi_arqos    ,
    input                 s_axi_arready  ,
    output      [2:0]     s_axi_arsize   ,
    output                s_axi_aruser   ,
    output  reg           s_axi_arvalid  ,

// aw ch 
    output reg  [48: 0]   s_axi_awaddr    ,
    output      [1 : 0]   s_axi_awburst   ,
    output      [3 : 0]   s_axi_awcache   ,
    output      [5 : 0]   s_axi_awid      ,
    output reg  [7 : 0]   s_axi_awlen     ,
    output                s_axi_awlock    ,
    output      [2 : 0]   s_axi_awprot    ,
    output      [3 : 0]   s_axi_awqos     ,
    input                 s_axi_awready   ,
    output      [2 : 0]   s_axi_awsize    ,
    output                s_axi_awuser    ,
    output reg            s_axi_awvalid   ,

// response     
    input       [5 : 0]   s_axi_bid       ,
    output                s_axi_bready    ,
    input       [1 : 0]   s_axi_bresp     ,
    input                 s_axi_bvalid    ,

// rd ch 
    input       [127: 0]  s_axi_rdata     ,
    input       [5  : 0]  s_axi_rid       ,
    input                 s_axi_rlast     ,
    output reg            s_axi_rready    ,
    input       [1 : 0]   s_axi_rresp     ,
    input                 s_axi_rvalid    ,

// wr ch 
    output      [127: 0]  s_axi_wdata     ,
    output reg            s_axi_wlast     ,
    input                 s_axi_wready    ,
    output reg  [15 : 0]  s_axi_wstrb     ,
    output reg            s_axi_wvalid
);

//-------------------------------------------------------------------------------------------

reg [63:0] fifo_din_cmd_d1    ;
reg        fifo_wr_en_cmd_d1  ;
reg [63:0] fifo_din_cmd_d2    ;
reg        fifo_wr_en_cmd_d2  ;


reg        fifo_wr_en_wr_d1   ;
reg [127:0]fifo_din_wr_d1     ;
reg        fifo_wr_en_wr_d2   ;
reg [127:0]fifo_din_wr_d2     ;

reg        fifo_rd_en_rd_d1   ;
reg        fifo_rd_en_rd_d2   ;
reg        fifo_rd_en_rd_d3   ;
reg        fifo_rd_en_rd_d4   ;

always @(posedge clk) begin
    fifo_din_cmd_d1 <= fifo_din_cmd     ;
    fifo_din_cmd_d2 <= fifo_din_cmd_d1  ;
end

always @(posedge clk) begin
    fifo_wr_en_cmd_d1 <= fifo_wr_en_cmd    ;
    fifo_wr_en_cmd_d2 <= fifo_wr_en_cmd_d1 ;
end

always @(posedge clk) begin
    fifo_wr_en_wr_d1 <= fifo_wr_en_wr      ;
    fifo_wr_en_wr_d2 <= fifo_wr_en_wr_d1   ;
end

always @(posedge clk) begin
    fifo_din_wr_d1 <= fifo_din_wr    ;
    fifo_din_wr_d2 <= fifo_din_wr_d1 ;
end

always @(posedge clk) begin
    fifo_rd_en_rd_d1 <= fifo_rd_en_rd    ;
    fifo_rd_en_rd_d2 <= fifo_rd_en_rd_d1 ;
    fifo_rd_en_rd_d3 <= fifo_rd_en_rd_d2 ;
    fifo_rd_en_rd_d4 <= fifo_rd_en_rd_d3 ;
end


//--------------------------------cmd_data_fifo----------------------------------------------
reg             fifo_rd_en_cmd          ;
wire [63:0]     fifo_dout_cmd           ;
wire            fifo_almost_full_cmd    ;
wire [4 :0]     fifo_rd_data_count_cmd  ;
wire [4 :0]     fifo_wr_data_count_cmd  ;

xfifo_async_w64d32_d0  xfifo_async_w64d32_d0_cmd
(
    .rst            (rst                    ),
    .wr_clk         (clk                    ),
    .rd_clk         (ddr_clk                ),

    .din            (fifo_din_cmd_d2        ),
    .wr_en          (fifo_wr_en_cmd_d2      ),
    .rd_en          (fifo_rd_en_cmd         ),
    .dout           (fifo_dout_cmd          ),
    .full           (                       ),
    .almost_full    (                       ),
    .empty          (fifo_empty_cmd         ),
    .prog_full      (fifo_full_cmd          )
    // .rd_data_count  (fifo_rd_data_count_cmd ),
    // .wr_data_count  (fifo_wr_data_count_cmd )

);

//----------------------------------wr_data_fifo--------------------------------------------

wire            fifo_rd_en_wr           ;
wire [127:0]    fifo_dout_wr            ;
wire            fifo_almost_full_wr     ;
wire [9 :0]     fifo_rd_data_count_wr   ;
wire [9 :0]     fifo_wr_data_count_wr   ;
wire            fifo_prog_full          ;

generate if(WRITE_CH_ENABLE == 1 ) 
    xfifo_async_w128d1024_d0 xfifo_async_w128d1024_d0_wr_data
    (
        .rst             (rst                   ),
        .wr_clk          (clk                   ),
        .rd_clk          (ddr_clk               ),
        .din             (fifo_din_wr_d2        ),
        .wr_en           (fifo_wr_en_wr_d2      ),
        .rd_en           (fifo_rd_en_wr         ),
        .dout            (fifo_dout_wr          ),
        .full            (                      ),
        .almost_full     (                      ),
        .empty           (fifo_empty_wr         ),
        // .rd_data_count   (fifo_rd_data_count_wr ),
        // .wr_data_count   (fifo_wr_data_count_wr ),
        .prog_full       (fifo_full_wr          ),
        .wr_rst_busy     (),
        .rd_rst_busy     ()
    );
endgenerate
//----------------------------------rd_data_fifo--------------------------------------------

wire [127:0]     fifo_din_rd            ;
wire             fifo_wr_en_rd          ;
wire             fifo_almost_full_rd    ;
wire             fifo_rd_data_count_rd  ;
wire             fifo_wr_data_count_rd  ;
wire             fifo_prog_full_rd      ;
wire             fifo_wr_rst_busy_rd    ;
wire             fifo_rd_rst_busy_rd    ;

generate if(READ_CH_ENABLE == 1 )
    xfifo_async_w128d256_d0 xfifo_async_w128d256_d0_rd_data
    (
        .rst             (rst                   ),
        .wr_clk          (ddr_clk               ),
        .rd_clk          (clk                   ),
        .din             (fifo_din_rd           ),
        .wr_en           (fifo_wr_en_rd         ),
        .rd_en           (fifo_rd_en_rd         ),
        .dout            (fifo_dout_rd          ),
        .full            (                      ),
        .almost_full     (fifo_almost_full_rd   ),
        .empty           (fifo_empty_rd         ),
        // .rd_data_count   (fifo_rd_data_count_rd ),
        // .wr_data_count   (fifo_wr_data_count_rd ),
        .prog_full       (fifo_full_rd          ),
        .wr_rst_busy     (fifo_wr_rst_busy_rd   ),
        .rd_rst_busy     (fifo_rd_rst_busy_rd   )
    );
endgenerate

reg [15:0]  axi_wr_data_toal_cnt ;
//-----------------------------------logic---------------------------------------
//                                    FSM

parameter IDLE      = 3'd0 ;
parameter AWADDR_CH = 3'd1 ;
parameter WDATA_CH  = 3'd2 ;
parameter ARADDR_CH = 3'd3 ;
parameter RDATA_CH  = 3'd4 ;
parameter BRESP_CH  = 3'd5 ;

reg [2:0]   cur_state ;
reg [2:0]   nxt_state ;

always @(posedge ddr_clk) begin
    if(rst)
        cur_state <=    IDLE ;
    else 
        cur_state <=    nxt_state ;
end

always @(*) begin
    case(cur_state)
        IDLE     :  
            if(~fifo_empty_cmd)
                nxt_state = (fifo_dout_cmd[63]) ? ARADDR_CH : AWADDR_CH ;
            else
                nxt_state = IDLE ;
        AWADDR_CH:
            if(s_axi_awvalid && s_axi_awready)
                nxt_state = WDATA_CH ;
            else 
                nxt_state = AWADDR_CH;
        WDATA_CH :
            if(s_axi_wvalid && s_axi_wready && axi_wr_data_toal_cnt == s_axi_awlen )
                nxt_state = BRESP_CH ;
            else
                nxt_state = WDATA_CH ;
        BRESP_CH :
            if(s_axi_bready && s_axi_bvalid)
                nxt_state = IDLE     ;
            else 
                nxt_state = BRESP_CH ;
        ARADDR_CH:
            if(s_axi_arvalid & s_axi_arready)
                nxt_state = RDATA_CH ;
            else 
                nxt_state = ARADDR_CH ;
        RDATA_CH :
            if(s_axi_rready && s_axi_rvalid && s_axi_rlast)
                nxt_state = IDLE ;
            else 
                nxt_state = RDATA_CH ;
    default :
        nxt_state = IDLE ;
    endcase
end

//-----------------------------------------AWADDR CH----------------------------------------------

always @(posedge ddr_clk) begin
    if(rst)
        s_axi_awaddr <= 'd0 ;
    else
        s_axi_awaddr <= fifo_dout_cmd[60:12];
end

always @(posedge ddr_clk) begin
    if(rst)
        s_axi_awlen <= 'hff ;
    else 
        s_axi_awlen <= fifo_dout_cmd[11:4];
end

assign  s_axi_awburst = 'd1 ;
assign  s_axi_awcache = 'd0 ;
assign  s_axi_awid    = 'd0 ;
assign  s_axi_awlock  = 'd0 ;
assign  s_axi_awprot  = 'd0 ;
assign  s_axi_awqos   = 'd0 ;
assign  s_axi_awuser  = 'd0 ;
assign  s_axi_awsize  = 'd4 ;

always @(posedge ddr_clk) begin
    if(rst)
        s_axi_awvalid <= 'd0;
    else if(s_axi_awvalid && s_axi_awready )
        s_axi_awvalid <= 'd0 ;
    else if(cur_state == AWADDR_CH )
        s_axi_awvalid <= 1'b1;
    else 
        s_axi_awvalid <= 1'b0; 
end

always @(posedge ddr_clk) begin
    if(rst)
        fifo_rd_en_cmd <= 'd0 ;
    else if((s_axi_awvalid && s_axi_awready) || (s_axi_arready && s_axi_arvalid))
        fifo_rd_en_cmd <= 'd1 ;
    else 
        fifo_rd_en_cmd <= 'd0 ;
end

//--------------------------------WDATA CH-------------------------------------------



always @(posedge ddr_clk) begin
    if(rst)
        axi_wr_data_toal_cnt <= 'd0 ;
    else if(cur_state == BRESP_CH )
        axi_wr_data_toal_cnt <= 'd0 ;
    else if(s_axi_wvalid && s_axi_wready)
        axi_wr_data_toal_cnt <= axi_wr_data_toal_cnt + 1'b1 ;
    else 
        axi_wr_data_toal_cnt <= axi_wr_data_toal_cnt ;
end

assign fifo_rd_en_wr = s_axi_wvalid && s_axi_wready ;

// always @(posedge ddr_clk) begin
//     if(rst)
//         fifo_rd_en_wr <= 'd0 ;
//     else if(s_axi_wvalid && s_axi_wready && axi_wr_data_toal_cnt < s_axi_awlen )
//         fifo_rd_en_wr <= 1'b1 ;
//     else 
//         fifo_rd_en_wr <= 1'b0 ;
// end

always @(posedge ddr_clk) begin
    if(rst)
        s_axi_wvalid <= 'd0 ;
    // else if(cur_state == WDATA_CH)
    else if(cur_state == WDATA_CH )
        if(s_axi_wlast && s_axi_wready  && s_axi_wvalid)
            s_axi_wvalid <= 'd0 ;
        else
            s_axi_wvalid <= 'd1 ;
    else 
        s_axi_wvalid <= 'd0 ;
end

assign s_axi_wdata  = fifo_dout_wr  ;

always @(posedge ddr_clk) begin
    if(rst)
        s_axi_wlast <= 'd0 ;
    else if(cur_state == WDATA_CH  && s_axi_wready  && s_axi_wvalid &&  axi_wr_data_toal_cnt == s_axi_awlen - 1'b1  )
        s_axi_wlast <= 'd1 ;
    else if(cur_state == WDATA_CH  && s_axi_wready  && s_axi_wvalid && s_axi_wlast)
        s_axi_wlast <= 'd0 ;
    else
        s_axi_wlast <= s_axi_wlast ;
end

always @(posedge ddr_clk) begin
    if(rst)
        s_axi_wstrb <= 'd0 ;
    else if(s_axi_awlen == 'd0 || (s_axi_wready && s_axi_wvalid && axi_wr_data_toal_cnt == s_axi_awlen -1'b1 ))
        case(fifo_dout_cmd[3:0])
            'd0 :   s_axi_wstrb <= 16'b0000_0000_0000_0001 ;
            'd1 :   s_axi_wstrb <= 16'b0000_0000_0000_0011 ;
            'd2 :   s_axi_wstrb <= 16'b0000_0000_0000_0111 ;
            'd3 :   s_axi_wstrb <= 16'b0000_0000_0000_1111 ;
            'd4 :   s_axi_wstrb <= 16'b0000_0000_0001_1111 ;
            'd5 :   s_axi_wstrb <= 16'b0000_0000_0011_1111 ;
            'd6 :   s_axi_wstrb <= 16'b0000_0000_0111_1111 ;
            'd7 :   s_axi_wstrb <= 16'b0000_0000_1111_1111 ;
            'd8 :   s_axi_wstrb <= 16'b0000_0001_1111_1111 ;
            'd9 :   s_axi_wstrb <= 16'b0000_0011_1111_1111 ;
            'd10:   s_axi_wstrb <= 16'b0000_0111_1111_1111 ;
            'd11:   s_axi_wstrb <= 16'b0000_1111_1111_1111 ;
            'd12:   s_axi_wstrb <= 16'b0001_1111_1111_1111 ;
            'd13:   s_axi_wstrb <= 16'b0011_1111_1111_1111 ;
            'd14:   s_axi_wstrb <= 16'b0111_1111_1111_1111 ;
            'd15:   s_axi_wstrb <= 16'b1111_1111_1111_1111 ;
        endcase
    else
        s_axi_wstrb <= 16'hffff;
end

//--------------------------------BRESP CH-------------------------------------------

assign s_axi_bready = 1'b1 ;    // 后面可以加诊断


//-----------------------------------AR CH-------------------------------------------

always @(posedge ddr_clk) begin
    if(rst)
        s_axi_araddr <= 'd0 ; 
    else if(cur_state == ARADDR_CH)
        s_axi_araddr <= fifo_dout_cmd[60:12] ;
    else 
        s_axi_araddr <= s_axi_araddr ;
end

assign s_axi_arburst = 'd1 ;
assign s_axi_arcache = 'd0 ;
assign s_axi_arid    = 'd0 ;

always @(posedge ddr_clk) begin
    if(rst)
        s_axi_arlen <= 'd0 ;
    else
        s_axi_arlen <= fifo_dout_cmd[11:4];    
end

always @(posedge ddr_clk) begin
    if(rst)
        s_axi_arvalid <= 'd0 ;
    else if(s_axi_arvalid && s_axi_arready)
        s_axi_arvalid <= 'd0 ;
    else if(cur_state == ARADDR_CH )
        s_axi_arvalid <= 'd1 ;
    else 
        s_axi_arvalid <= 'd0 ;
end

assign s_axi_arlock = 'd0 ;
assign s_axi_arprot = 'd0 ;
assign s_axi_arqos  = 'd0 ;
assign s_axi_arsize = 'd4 ;
assign s_axi_aruser = 'd0 ;

//----------------------------------rd ch -------------------------------------------
always @(posedge ddr_clk) begin
    if(rst)
        s_axi_rready <= 'd0 ;
    else if(fifo_almost_full_rd || s_axi_rlast )
        s_axi_rready <= 'd0 ;
    else if(cur_state == RDATA_CH)
        s_axi_rready <= 'd1 ;
    else 
        s_axi_rready <= 'd0 ;
end

//--------------------------------BRESP CH-------------------------------------------

assign fifo_wr_en_rd    =  s_axi_rready && s_axi_rvalid ;
assign fifo_din_rd      =  s_axi_rdata                  ;

assign data_rd_valid    = ~fifo_empty_rd;

always @(posedge clk) begin
    if(rst)
        op_finish_flag <= 'd0 ;
    else if((cur_state == BRESP_CH && nxt_state == IDLE)||(cur_state == RDATA_CH && nxt_state == IDLE))
        op_finish_flag <= 'd1 ; 
    else 
        op_finish_flag <= 'd0 ;
end

endmodule
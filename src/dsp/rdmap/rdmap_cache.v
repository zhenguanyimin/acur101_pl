module rdmap_cache (

    input               clk                 ,
	input               rst                 ,

    input [7 :0]        wave_position       ,    

    input [31:0]        rdmap_log2_tdata    ,
    input               rdmap_log2_tvalid   ,
    input               rdmap_log2_tlast    ,

    input               histogram_busy      ,
    input [15:0]        rdmap_range_data    ,
    input wire          rdmap_range_valid   ,

    output  reg [63:0]  fifo_din_cmd_rdmap  ,
    output  reg         fifo_wr_en_cmd_rdmap,
    input   wire        fifo_full_cmd_rdmap ,
    
    output  reg         fifo_wr_en_wr_rdmap ,
    output  reg [127:0] fifo_din_wr_rdmap   ,
    input   wire        fifo_full_wr_rdmap  ,
    output 	reg 		rdmap_wr_irq
);

reg [31:0]  rdmap_log2_tdata_d1  ='d0;
reg         rdmap_log2_tvalid_d1 ='d0;
reg         rdmap_log2_tlast_d1  ='d0;

reg [31:0]  rdmap_log2_tdata_d2  ='d0;
reg         rdmap_log2_tvalid_d2 ='d0;
reg         rdmap_log2_tlast_d2  ='d0;
reg         rdmap_log2_tvalid_d3 ='d0;
reg         rdmap_log2_tvalid_d4 ='d0;

reg         histogram_busy_d1   ='d0;
reg [15:0]  rdmap_range_data_d1  ='d0;
reg         histogram_busy_d2   ='d0;
reg [15:0]  rdmap_range_data_d2  ='d0;

always @(posedge clk) begin
    rdmap_log2_tdata_d1  <=  rdmap_log2_tdata ;
    rdmap_log2_tvalid_d1 <=  rdmap_log2_tvalid;
    rdmap_log2_tlast_d1  <=  rdmap_log2_tlast ;
    rdmap_log2_tdata_d2  <=  rdmap_log2_tdata_d1 ;
    rdmap_log2_tvalid_d2 <=  rdmap_log2_tvalid_d1;
    rdmap_log2_tlast_d2  <=  rdmap_log2_tvalid_d1;
    rdmap_log2_tvalid_d3 <=  rdmap_log2_tvalid_d2;
    rdmap_log2_tvalid_d4 <=  rdmap_log2_tvalid_d3;
    histogram_busy_d1    <=  histogram_busy;
    histogram_busy_d2    <=  histogram_busy_d1;
    rdmap_range_data_d1  <=  rdmap_range_data;
    rdmap_range_data_d2  <=  rdmap_range_data_d1;
end

reg             uram_wea    ='d0;
reg             uram_ena    ='d0;
reg [13 :0]     uram_addra  ='d0;
wire[127:0]     uram_douta;
reg [127:0]     uram_dina   =128'd0;
reg             uram_web    ='d0;
reg             uram_enb    ='d0; 
reg [13:0]      uram_addrb  ='d0;
wire[127:0]     uram_doutb      ;
reg [127:0]     uram_dinb   =128'd0;

xpm_memory_tdpram #(
    .ADDR_WIDTH_A(14),               // DECIMAL
    .ADDR_WIDTH_B(14),               // DECIMAL
    .AUTO_SLEEP_TIME(0),            // DECIMAL
    .BYTE_WRITE_WIDTH_A(128),        // DECIMAL
    .BYTE_WRITE_WIDTH_B(128),        // DECIMAL
    .CASCADE_HEIGHT(0),             // DECIMAL
    .CLOCKING_MODE("common_clock"), // String
    .ECC_MODE("no_ecc"),            // String
    .MEMORY_INIT_FILE("none"),      // String
    .MEMORY_INIT_PARAM("0"),        // String
    .MEMORY_OPTIMIZATION("true"),   // String
    .MEMORY_PRIMITIVE("ultra"),      // String
    .MEMORY_SIZE(2097152),             // DECIMAL
    .MESSAGE_CONTROL(0),            // DECIMAL
    .READ_DATA_WIDTH_A(128),         // DECIMAL
    .READ_DATA_WIDTH_B(128),         // DECIMAL
    .READ_LATENCY_A(2),             // DECIMAL
    .READ_LATENCY_B(2),             // DECIMAL
    .READ_RESET_VALUE_A("0"),       // String
    .READ_RESET_VALUE_B("0"),       // String
    .RST_MODE_A("SYNC"),            // String
    .RST_MODE_B("SYNC"),            // String
    .SIM_ASSERT_CHK(0),             // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
    .USE_EMBEDDED_CONSTRAINT(0),    // DECIMAL
    .USE_MEM_INIT(1),               // DECIMAL
    .USE_MEM_INIT_MMI(0),           // DECIMAL
    .WAKEUP_TIME("disable_sleep"),  // String
    .WRITE_DATA_WIDTH_A(128),        // DECIMAL
    .WRITE_DATA_WIDTH_B(128),        // DECIMAL
    .WRITE_MODE_A("no_change"),     // String
    .WRITE_MODE_B("no_change"),     // String
    .WRITE_PROTECT(1)               // DECIMAL
)
xpm_memory_tdpram_inst (

    .clka               (clk                    ),
    .rsta               (rst                    ),
    .wea                (uram_wea               ),
    .ena                (1'b1                   ),
    .addra              (uram_addra             ),
    .douta              (uram_douta             ),
    .dina               (uram_dina              ),

    .clkb               (clk                    ),
    .rstb               (rst                    ),
    .web                (1'b0                   ),
    .enb                (1'b1                   ),
    .addrb              ('d0                    ),        
    .doutb              (uram_doutb             ),
    .dinb               (127'd0                 ),

    .injectdbiterra     ('d0                    ),
    .injectdbiterrb     ('d0                    ),
    .injectsbiterra     ('d0                    ),
    .injectsbiterrb     ('d0                    ),
    .regcea             ('d1                    ),
    .regceb             ('d1                    ),
    .dbiterra           (                       ),
    .dbiterrb           (                       ),
    .sbiterra           (                       ),
    .sbiterrb           (                       ),
    .sleep              ('d0                    )
);

reg [1:0]       div_4_cnt  ;
reg [127:0]     rdmap_shift;
reg             wr_op_end_flag;
reg             wr_op;

always @(posedge clk) begin
    if(rst)
        div_4_cnt <= 'd0 ;
    else if(rdmap_log2_tvalid_d3)
        div_4_cnt <= div_4_cnt + 1'b1 ;
    else 
        div_4_cnt <= 'd0 ;
end

always @(posedge clk) begin
    if(rst)
        rdmap_shift <= 'd0; 
    else if(rdmap_log2_tvalid_d2)
        rdmap_shift <= {rdmap_shift[95:0],rdmap_log2_tdata_d2};
end

always @(posedge clk) begin
    if(rst)
        uram_dina <= 'd0 ;
    else 
        uram_dina <= rdmap_shift ;
end

always @(posedge clk) begin
    if(rst)
        uram_wea  <= 'd0 ;
    else if(div_4_cnt == 'd3)
        uram_wea <= 'd1 ;
    else 
        uram_wea <= 'd0 ;
end


always @(posedge clk) begin
    if(rst)
        wr_op_end_flag <= 'd0 ;
    else if(~rdmap_log2_tvalid_d3 && rdmap_log2_tvalid_d4)
        wr_op_end_flag <= 'd1 ;
    else 
        wr_op_end_flag <= 'd0 ;
end
always @(posedge clk) begin
    if(rst)
        wr_op <= 'd0 ;
    else if(rdmap_log2_tvalid_d1 && ~rdmap_log2_tvalid_d2)
        wr_op <= 'd1 ;
    else if(~rdmap_log2_tvalid_d3 && rdmap_log2_tvalid_d4)
        wr_op <= 'd0 ;
end

//---------------------------------------------------rd_en_cha-------------------------------------------------------

reg			uram_rd_op_flag;
reg [13: 0]	uram_rd_en_cnt ;
reg 		uram_rd_en ;
reg [13: 0]	fifo_wr_en_wr_rdmap_cnt ;
reg [3 : 0] wr_op_end_flag_shift;
reg         rd_op_end_flag;

always @(posedge clk) begin
    wr_op_end_flag_shift <= {wr_op_end_flag_shift[3:0],wr_op_end_flag};
end

always @(posedge clk) begin
    if(rst)
        rd_op_end_flag <= 'd0 ;
	else if(wr_op_end_flag_shift[3])
        rd_op_end_flag <= 'd0 ;
    else if(uram_rd_en_cnt == 'd16383 && uram_rd_en )
        rd_op_end_flag <= 'd1 ;
    else 
        rd_op_end_flag <= rd_op_end_flag;
end

always @(posedge clk) begin
    if(rst)
		uram_rd_op_flag <= 'd0 ;
	else if(wr_op_end_flag_shift[3])
		uram_rd_op_flag <= 'd1 ;
	else if(fifo_wr_en_wr_rdmap_cnt == 'd16383 && fifo_wr_en_wr_rdmap )
		uram_rd_op_flag <= 'd0 ;
	else
		uram_rd_op_flag <= uram_rd_op_flag ;
end

always @(posedge clk) begin
    if(rst)
        uram_rd_en <= 'd0 ;
	else if(uram_rd_en_cnt == 'd16383 && uram_rd_en || rd_op_end_flag)
		uram_rd_en <= 'd0 ;
	else if(uram_rd_op_flag  && ~fifo_full_wr_rdmap )
		uram_rd_en <= 1 ;
	else 
		uram_rd_en <= 'd0 ;
end

always @(posedge clk) begin
    if(rst)
        uram_rd_en_cnt <= 'd0 ;
	else if(wr_op_end_flag_shift[2])
		uram_rd_en_cnt <= 'd0 ;
	else if(uram_rd_en_cnt <'d16383)
		uram_rd_en_cnt <= (uram_rd_en) ? uram_rd_en_cnt + 1'b1 : uram_rd_en_cnt ;
	else 
		uram_rd_en_cnt <= uram_rd_en_cnt ;
end

always @(posedge clk) begin
    if(rst)
        uram_addra <= 'd0 ;
    else if(rdmap_log2_tvalid_d1 && ~rdmap_log2_tvalid_d2)
        uram_addra <= 'd0 ;
    else if(wr_op)
        if(uram_wea == 'd1 )
            uram_addra <= uram_addra + 1'b1 ;
        else 
            uram_addra <= uram_addra ;
    else 
        uram_addra <=  uram_rd_en_cnt ;
end

//--------------------------------------------ddr output------------------------------

reg [7 : 0]     wave_position_d1 = 'd0 ;
reg [7 : 0]     wave_position_d2 = 'd0 ;

reg [31: 0]     wr_base_addr ;
reg [7 : 0]	    uram_rd_en_shift ='d0;

always @(posedge clk) begin
    wave_position_d1 <= wave_position ;
    wave_position_d2 <= wave_position_d1 ;
end

always @(posedge clk) begin
    uram_rd_en_shift <= {uram_rd_en_shift[6:0],uram_rd_en};
end

always @(posedge clk) begin
    if(rst)
        fifo_wr_en_wr_rdmap <= 'd0 ;
    else 
        fifo_wr_en_wr_rdmap <=  uram_rd_en_shift[2];
end

always @(posedge clk) begin
    if(rst)
        fifo_wr_en_wr_rdmap_cnt <= 'd0 ;
    else if(fifo_wr_en_wr_rdmap)
        fifo_wr_en_wr_rdmap_cnt <= fifo_wr_en_wr_rdmap_cnt + 1'b1 ;
    else 
        fifo_wr_en_wr_rdmap_cnt <= fifo_wr_en_wr_rdmap_cnt ;
end


always @(posedge clk) begin
    if(rst)
		fifo_din_wr_rdmap <= 'd0 ;
	else 
		// fifo_din_wr_rdmap <= uram_douta ;
    fifo_din_wr_rdmap <= {uram_douta[31:0],uram_douta[63:32],uram_douta[95:64],uram_douta[127:96]} ;
end


always @(posedge clk) begin
    if(rst) begin 
		fifo_din_cmd_rdmap[62:12] <= 'd0 ;
		fifo_din_cmd_rdmap[63]    <= 'd0 ;
		fifo_din_cmd_rdmap[11:0]  <= 'd4095;
	end
	else if(fifo_wr_en_wr_rdmap_cnt[7:0] == 'd255 && fifo_wr_en_wr_rdmap ) begin
		fifo_din_cmd_rdmap[29:24] <=  fifo_wr_en_wr_rdmap_cnt[13:8];
		fifo_din_cmd_rdmap[63]    <= 'd0 ;
        fifo_din_cmd_rdmap[31]    <= 'b1 ;
		fifo_din_cmd_rdmap[11:0]  <= 'd4095;
        fifo_din_cmd_rdmap[43:30] <=  wr_base_addr[31:18];
	end
	else
		fifo_din_cmd_rdmap <= fifo_din_cmd_rdmap ;
end

always @(posedge clk) begin
    if(rst)
		fifo_wr_en_cmd_rdmap <= 'd0 ;
	else if(fifo_wr_en_wr_rdmap_cnt[7:0] == 'd255 && fifo_wr_en_wr_rdmap ) 
		fifo_wr_en_cmd_rdmap <= 'd1 ;
	else 
		fifo_wr_en_cmd_rdmap <= 'd0 ;
end

always @(posedge clk) begin
    if(rst)
		wr_base_addr <= 32'h6000_0000;
	else begin 
		wr_base_addr[28:21] <= wave_position_d2 ;
		wr_base_addr[20:20] <= 'b1 ;
        wr_base_addr[19:0] <= 'd0 ;
        // wr_base_addr[17: 0] <= 'b0 ;
		wr_base_addr[31:29] <= 3'b011 ;
	end
end

//-----------------------------------------------------------------------------------------
assign rdmap_range_valid = 'd1 ;
assign rdmap_range_data  = 'hffff;

reg			rd_op_flag ;
reg 		rd_op_flag_d1 ='d0;
reg 		rd_op_flag_d2 ='d0;
reg [63:0]	wr_end_shift ;
reg         wr_end_flag ;

always @(posedge clk) begin
	rd_op_flag_d1 <= uram_rd_op_flag ;
	rd_op_flag_d2 <= rd_op_flag_d1 ;
end

always @(posedge clk) begin
	wr_end_shift <= {wr_end_shift[62:0],~rd_op_flag_d1 && rd_op_flag_d2} ;
end

always @(posedge clk) begin
	wr_end_flag <= |wr_end_shift[63:16];
end
always @(posedge clk) begin
    if(rst)
        rdmap_wr_irq <= 'd0 ;
    else 
        rdmap_wr_irq <=  |wr_end_shift[63:40] ;
end

//---------------------------------------------denug signl--------------------------------------
(* MARK_DEBUG="true" *)reg [31:0]	write_time;
(* MARK_DEBUG="true" *)reg [31:0]	write_time_max;

always @(posedge clk) begin
    if(rst)
		write_time <= 'd0 ;
	else if(rd_op_flag_d2)
		write_time <= write_time + 1'd1;
	else
		write_time <= 'd0;
end

always @(posedge clk) begin
	if(rst)
		write_time_max <= 'd0 ;
	else if(~rd_op_flag && rd_op_flag_d1)
		write_time_max <= (write_time_max < write_time) ? write_time: write_time_max;
	else
		write_time_max <= write_time_max;
end

endmodule

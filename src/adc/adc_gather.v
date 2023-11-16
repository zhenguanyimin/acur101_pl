module adc_gather
(
        input   wire        clk,
        input   wire        rst ,

        input   wire        PRI ,
        input   wire        CPIB ,
        input   wire        CPIE ,
        input   wire        sample_gate ,
        input   wire        dma_ready ,

		input   wire [15:0] sample_num ,
        input   wire [15:0] chirp_num ,
		input 	wire [15:0]	horizontal_pitch ,
		input   wire        scan_mode ,
		input 	wire 		adc_gather_debug ,
		input 	wire [7 :0]	wave_position ,
		output 	reg  [7 :0]	last_position ,
		
		input   wire        adc_data_sop_cha  	,
		input   wire        adc_data_eop_cha  	,
		input   wire [15:0] adc_data_cha      	,
		input   wire        adc_data_valid_cha	,		
		
		input   wire        adc_data_sop_chb  	,
		input   wire        adc_data_eop_chb  	,
		input   wire [15:0] adc_data_chb      	,
		input   wire        adc_data_valid_chb	,

		output  reg [63:0]  fifo_din_cmd_adc    ,
		output  reg         fifo_wr_en_cmd_adc  ,
		input   wire        fifo_full_cmd_adc   ,
		
		output  reg         fifo_wr_en_wr_adc   ,
		output  reg [127:0] fifo_din_wr_adc     ,
		input   wire        fifo_full_wr_adc	,	
		output 	reg 		adc_wr_irp			
);

reg			PRI_d1 ='d0;
reg			PRI_d2 ='d0;
reg			PRI_d3 ='d0;
(* MARK_DEBUG="true" *)reg			PRI_d4 ='d0;
reg			CPIB_d1 ='d0;
(* MARK_DEBUG="true" *)reg			CPIB_d2 ='d0;
reg			CPIE_d1 ='d0;
reg			CPIE_d2 ='d0;
reg			CPIE_d3 ='d0;
(* MARK_DEBUG="true" *)reg			CPIE_d4 ='d0;
reg			sample_gate_d1 ='d0;
(* MARK_DEBUG="true" *)reg			sample_gate_d2 ='d0;
reg			dma_ready_d1 ='d0;
reg			dma_ready_d2 ='d0;

reg [15:0] 	sample_num_d1 ='d0;
reg [15:0] 	sample_num_d2 ='d0;
reg [15:0] 	chirp_num_d1 ='d0;
reg [15:0] 	chirp_num_d2 ='d0;
reg [15:0]	horizontal_pitch_d1 ='d0;
reg [15:0]	horizontal_pitch_d2 ='d0;
reg 		adc_gather_debug_d1 ='d0;
reg 		adc_gather_debug_d2 ='d0;

reg [7 :0]	adc_data_sub_sop_shift = 'd0 ;
reg [7 :0]	adc_data_sub_eop_shift = 'd0 ;
reg [15:0]	adc_data_sub_d1 ='d0;
reg [15:0]	adc_data_sub_d2 ='d0;

reg [7 :0]	adc_data_add_eop_shift ='d0 ;
reg [7 :0]	adc_data_add_sop_shift ='d0 ;
reg [15:0] 	adc_data_add_d1 ='d0;
reg [15:0] 	adc_data_add_d2 ='d0;
reg [7 :0]	adc_data_add_valid_shift='d0;
reg		   	fifo_full_cmd_adc_d1 ='d0;
reg		   	fifo_full_cmd_adc_d2 ='d0;
reg 	   	fifo_full_wr_adc_d1 ='d0;
reg 	   	fifo_full_wr_adc_d2 ='d0; 

(* MARK_DEBUG="true" *)reg	[7:0]	pri_cnt	;
(* MARK_DEBUG="true" *)reg	[15:0]	cpie_cnt;

always @(posedge clk) begin 
	PRI_d1 <= PRI ;
	PRI_d2 <= PRI_d1 ;
	PRI_d3 <= PRI_d2 ;
	PRI_d4 <= PRI_d3 ;
end

always @(posedge clk) begin
	CPIB_d1 <= CPIB ;
	CPIB_d2 <= CPIB_d1 ;
end

always @(posedge clk) begin
	CPIE_d1 <= CPIE ;
	CPIE_d2 <= CPIE_d1 ;
	CPIE_d3 <= CPIE_d2 ;
	CPIE_d4 <= CPIE_d3 ;
end

always @(posedge clk) begin
	sample_gate_d1 <= sample_gate ;
	sample_gate_d2 <= sample_gate_d1 ;
end

always @(posedge clk) begin
	dma_ready_d1 <= dma_ready ;
	dma_ready_d2 <= dma_ready_d1 ;
end

always @(posedge clk) begin
	sample_num_d1 <= sample_num ;
	sample_num_d2 <= sample_num_d1 ;
	chirp_num_d1  <= chirp_num ;
	chirp_num_d2  <= chirp_num_d1 ;
	horizontal_pitch_d1 <= horizontal_pitch ;
	horizontal_pitch_d2 <= horizontal_pitch_d1 ;
	adc_gather_debug_d1 <= adc_gather_debug ;
	adc_gather_debug_d2 <= adc_gather_debug_d1 ;
end

always @(posedge clk) begin
	adc_data_sub_sop_shift <= {adc_data_sub_sop_shift[6:0],adc_data_sop_chb};
	adc_data_sub_eop_shift <= {adc_data_sub_eop_shift[6:0],adc_data_eop_chb};
	adc_data_sub_d1 <= adc_data_chb ;
	adc_data_sub_d2 <= adc_data_sub_d1 ;
end


always @(posedge clk) begin
	adc_data_add_sop_shift <= {adc_data_add_sop_shift[6:0],adc_data_sop_cha};
	adc_data_add_eop_shift <= {adc_data_add_eop_shift[6:0],adc_data_eop_cha};
	adc_data_add_d1	<= adc_data_cha ;
	adc_data_add_d2	<= adc_data_add_d1 ;
	adc_data_add_valid_shift <= {adc_data_add_valid_shift[6:0],adc_data_valid_cha};
end

always @(posedge clk) begin
	fifo_full_cmd_adc_d1 <= fifo_full_cmd_adc ;
	fifo_full_cmd_adc_d2 <= fifo_full_cmd_adc_d1 ;
end

always @(posedge clk) begin
	fifo_full_wr_adc_d1 <= fifo_full_wr_adc ;
	fifo_full_wr_adc_d2 <= fifo_full_wr_adc_d1 ;
end

always @(posedge clk) begin
    if(rst)
		pri_cnt <= 'd0 ;
	else if(CPIE_d4 && ~CPIE_d3)
		pri_cnt <= 'd0 ;
	else if(PRI_d4 && ~PRI_d3 )
		pri_cnt <= pri_cnt + 1'b1 ;
	else 
		pri_cnt <= pri_cnt; 
end

always @(posedge clk) begin
    if(rst)
		cpie_cnt <= 'd0 ;
	else if(CPIE_d4 && ~CPIE_d3)
		cpie_cnt <= cpie_cnt + 1'b1 ;
	else 
		cpie_cnt <= cpie_cnt ;
end
//------------------------------------crc-------------------------------

(* MARK_DEBUG="true" *)reg 		adc_data_per_sop = 'd0 ;
reg [31:0]	adc_data_per 	 = 'd0 ;
(* MARK_DEBUG="true" *)reg 		adc_data_per_valid ='d0  ;
(* MARK_DEBUG="true" *)reg 		adc_data_per_eop  ='d0;

(* MARK_DEBUG="true" *)reg 		adc_data_per_sop_d1 = 'd0;
reg [31:0]	adc_data_per_d1 	 = 'd0;
(* MARK_DEBUG="true" *)reg 		adc_data_per_valid_d1 ='d0;
(* MARK_DEBUG="true" *)reg 		adc_data_per_eop_d1  ='d0;

(* MARK_DEBUG="true" *)reg 		adc_data_per_crc_sop = 'd0 ;
reg [31:0]	adc_data_per_crc	 = 'd0 ;
(* MARK_DEBUG="true" *)reg 		adc_data_valid_crc	 = 'd0 ;
(* MARK_DEBUG="true" *)reg  	adc_data_per_crc_eop = 'd0 ;

always @(posedge clk) begin
    if(rst)
		adc_data_per <= 'd0 ;
	else if(adc_data_add_valid_shift[1] && ~adc_data_add_valid_shift[2])
		if(adc_gather_debug_d2)
			adc_data_per <= {16'hffff,cpie_cnt};
		else
			adc_data_per <= {adc_data_add_d2,adc_data_sub_d2};
	else if(adc_data_add_valid_shift[2] && ~adc_data_add_valid_shift[3])
		if(adc_gather_debug_d2)
			adc_data_per <= {pri_cnt,16'd0};
		// adc_data_per <= {16'h5a5a,16'd0};
		else
			adc_data_per <= {adc_data_add_d2,adc_data_sub_d2};
	else
		adc_data_per <= {adc_data_add_d2,adc_data_sub_d2};
end

always @(posedge clk) begin
    if(rst)
		adc_data_per_valid <= 'd0 ;
	else 
		adc_data_per_valid <= adc_data_add_valid_shift[1] ;
end

always @(posedge clk) begin
	adc_data_per_sop <= adc_data_add_sop_shift[1] ;
end

always @(posedge clk) begin
	adc_data_per_eop <= adc_data_add_eop_shift[1] ;
end



wire [31:0]	crc_o;  
wire 		crc_valid ;

crc_32 crc_32
(
	.clk 			(clk				),
	.rst 			(rst				),
	.din_valid		(adc_data_per_valid	),
	.din 			(adc_data_per		),
	.dout_valid		(crc_valid			),
	.dout			(crc_o				)
);

always @(posedge clk) begin
	adc_data_per_sop_d1 <= adc_data_per_sop;
	adc_data_per_eop_d1 <= adc_data_per_eop;
	adc_data_per_d1 <= adc_data_per;
	adc_data_per_valid_d1 <= adc_data_per_valid;
end

(* MARK_DEBUG="true" *)reg	[1:0]	adc_data_per_eop_cnt ; 

always @(posedge clk) begin
	if(rst)
		adc_data_per_eop_cnt <= 'd0;
	else if(adc_data_per_eop_d1)
		adc_data_per_eop_cnt <= adc_data_per_eop_cnt + 1'b1;
	else
		adc_data_per_eop_cnt <= adc_data_per_eop_cnt;
end

always @(posedge clk) begin
	if(rst)
		adc_data_per_crc_sop <= 'd0;
	else if(chirp_num_d2 == 'd32 && adc_data_per_sop_d1)
		adc_data_per_crc_sop <= 'd1;
	else if(chirp_num_d2 == 'd64 && adc_data_per_sop_d1 && adc_data_per_eop_cnt[0] == 1'b0)
		adc_data_per_crc_sop <= 'd1 ;
	else if(chirp_num_d2 == 'd128 && adc_data_per_sop_d1 && adc_data_per_eop_cnt == 2'b00)
		adc_data_per_crc_sop <= 'd1 ;
	else 
		adc_data_per_crc_sop <= 'd0 ;
end

always @(posedge clk) begin
	if(rst)
		adc_data_per_crc_eop <= 'd0;
	else if(chirp_num_d2 == 'd32 && adc_data_per_eop_d1)
		adc_data_per_crc_eop <= 'd1 ;
	else if(chirp_num_d2 == 'd64 && adc_data_per_eop_d1 && adc_data_per_eop_cnt[0] == 1'b1)
		adc_data_per_crc_eop <= 'd1;
	else if(chirp_num_d2 == 'd128 && adc_data_per_eop_d1 && adc_data_per_eop_cnt == 2'b11)
		adc_data_per_crc_eop <= 'd1;
	else
		adc_data_per_crc_eop <= 'd0 ;
end

always @(posedge clk) begin
	if(adc_data_per_eop)
		adc_data_per_crc <=	adc_data_per_d1;
	else 
		adc_data_per_crc <=	adc_data_per_d1;
end

always @(posedge clk) begin
	adc_data_valid_crc <= adc_data_per_valid_d1;
end

//---------------------------------------------------------------------
reg					ram_wen_a ;
reg	 [12 : 0]		ram_waddr_a ;
reg  [31 : 0]		ram_wdata_a ;

wire [10: 0]		ram_raddr_b ;
wire [127: 0]		ram_rdata_b ;

xpm_memory_sdpram #(
.ADDR_WIDTH_A             (13             ),
.ADDR_WIDTH_B             (11             ),
.AUTO_SLEEP_TIME          (0              ),
.BYTE_WRITE_WIDTH_A       (32             ),
.CASCADE_HEIGHT           (0              ),
.CLOCKING_MODE            ("common_clock" ),
.ECC_MODE                 ("no_ecc"       ),
.MEMORY_INIT_FILE         ("none"         ),
.MEMORY_INIT_PARAM        ("0"            ),
.MEMORY_OPTIMIZATION      ("true"         ),
.MEMORY_PRIMITIVE         ("ultra"        ),
.MEMORY_SIZE              (262144         ),//32bit*2048column*(32+2)row
.MESSAGE_CONTROL          (0              ),
.READ_DATA_WIDTH_B        (128            ),
.READ_LATENCY_B           (2              ),
.READ_RESET_VALUE_B       ("0"            ),
.RST_MODE_A               ("SYNC"         ),
.RST_MODE_B               ("SYNC"         ),
.SIM_ASSERT_CHK           (0              ),
.USE_EMBEDDED_CONSTRAINT  (0              ),
.USE_MEM_INIT             (1              ),
.USE_MEM_INIT_MMI         (0              ),
.WAKEUP_TIME              ("disable_sleep"),
.WRITE_DATA_WIDTH_A       (32             ),
.WRITE_MODE_B             ("read_first"   ),
.WRITE_PROTECT            (1              )
)
u_xpm_memory_sdpram_adc (
.clka           (clk            	),
.clkb           (clk            	),
.dbiterrb       (                   ),
.sbiterrb       (                   ),
.ena            (1'b1               ),
.wea            (ram_wen_a          ),
.addra          (ram_waddr_a        ),
.dina           (ram_wdata_a        ),
.enb            (1'b1               ),
.addrb          (ram_raddr_b        ),
.doutb          (ram_rdata_b        ),
.injectdbiterra (1'b0               ),
.injectsbiterra (1'b0               ),
.regceb         (1'b1               ),
.rstb           (1'b0               ),
.sleep          (1'b0               )
);

//-------------------------------------wr------------------------------------

reg     	    wr_pingpang_flag ;
reg	 [12 : 0]	ram_wen_a_cnt ;

always @(posedge clk) begin
    if(rst)
		ram_wen_a <= 'd0 ;
	else 
		ram_wen_a <= adc_data_valid_crc ;
end

always @(posedge clk) begin
    if(rst)
		ram_wen_a_cnt <= 'd0 ;
	else if( ram_wen_a ) 
		ram_wen_a_cnt <=ram_wen_a_cnt + 1'b1 ;
	else 
		ram_wen_a_cnt <= ram_wen_a_cnt ;
end

always @(posedge clk) begin
    if(rst)
		ram_wdata_a <= 'd0 ;
	else 
		ram_wdata_a <=  adc_data_per_crc;
end

always @(posedge clk) begin
    if(rst)
		wr_pingpang_flag <= 'd0 ;
	else if(adc_data_per_crc_eop)
		wr_pingpang_flag <= ~wr_pingpang_flag ;
	else 
		wr_pingpang_flag <= wr_pingpang_flag ;
end

always @(posedge clk) begin
    if(rst)
		ram_waddr_a <= 'd0 ;
	else if(ram_wen_a ) begin
		ram_waddr_a[12] <= wr_pingpang_flag ;
		// ram_waddr_a[12] <= 'd0 ;
		ram_waddr_a[11:0] <= ram_waddr_a + 1;
	end
	else begin 
		ram_waddr_a[12] <= ram_waddr_a[12] ;
		ram_waddr_a[11:0] <= ram_waddr_a[11:0] ;
	end
end

//------------------------------------rd--------------------------------------------

reg			rd_op_flag ;
reg 		rd_op_end_flag ;
reg [9: 0]	rd_en_cnt ;
reg 		rd_en ;
reg [9 : 0]	fifo_wr_en_wr_adc_cnt 	;
(* MARK_DEBUG="true" *)reg [4 : 0] adc_data_add_sop_d2_cnt ;
reg [7 : 0]	rd_en_shift='d0 ;

always @(posedge clk) begin
    if(rst)
		rd_op_flag <= 'd0 ;
	else if(adc_data_per_crc_eop)
		rd_op_flag <= 'd1 ;
	else if(fifo_wr_en_wr_adc_cnt == 'd1023 && fifo_wr_en_wr_adc )
		rd_op_flag <= 'd0 ;
	else
		rd_op_flag <= rd_op_flag ;
end

always @(posedge clk) begin
    if(rst)
        rd_op_end_flag <= 'd0 ;
	else if(adc_data_per_crc_eop)
        rd_op_end_flag <= 'd0 ;
    else if(rd_en_cnt == 'd1023 && rd_en )
        rd_op_end_flag <= 'd1 ;
    else 
        rd_op_end_flag <= rd_op_end_flag;
end

always @(posedge clk) begin
    if(rst)
		rd_en <= 'd0 ;
	else if(rd_en_cnt == 'd1023 && rd_en || rd_op_end_flag)
		rd_en <= 'd0 ;
	else if(rd_op_flag && ~fifo_full_wr_adc)
		rd_en <= 1  ;
	else 
		rd_en <= 'd0 ;
end

always @(posedge clk) begin
    if(rst)
		rd_en_cnt <= 'd0 ;
	else if(adc_data_per_crc_eop)
		rd_en_cnt <= 'd0 ;
	else if(rd_en_cnt <'d1023)
		rd_en_cnt <= (rd_en) ? rd_en_cnt + 1'b1 : rd_en_cnt ;
	else 
		rd_en_cnt <= rd_en_cnt ;
end

assign ram_raddr_b = {~wr_pingpang_flag,rd_en_cnt};
// assign ram_raddr_b = {1'd0,rd_en_cnt};
//-----------------------------------ddr output-------------------------------------------

reg [31: 0] wr_base_addr ;

always @(posedge clk) begin
	rd_en_shift <= {rd_en_shift[6:0],rd_en};
end

always @(posedge clk) begin
    if(rst)
		fifo_wr_en_wr_adc <= 'd0 ;
	else 
		fifo_wr_en_wr_adc <= rd_en_shift[1];
end

always @(posedge clk) begin
    if(rst)
		fifo_wr_en_wr_adc_cnt <= 'd0 ;
	else if(fifo_wr_en_wr_adc)
		fifo_wr_en_wr_adc_cnt <= fifo_wr_en_wr_adc_cnt + 'd1 ;
	else 
		fifo_wr_en_wr_adc_cnt <= fifo_wr_en_wr_adc_cnt ;
end

always @(posedge clk) begin
    if(rst)
		adc_data_add_sop_d2_cnt <= 'd0 ;
	else if(adc_data_per_crc_sop)
		adc_data_add_sop_d2_cnt <= adc_data_add_sop_d2_cnt + 1'b1 ;
	else 
		adc_data_add_sop_d2_cnt <= adc_data_add_sop_d2_cnt ; 	
end

always @(posedge clk) begin
    if(rst)
		fifo_din_wr_adc <= 'd0 ;
	else 
		fifo_din_wr_adc <= ram_rdata_b ;
end

always @(posedge clk) begin
    if(rst) begin 
		fifo_din_cmd_adc[62:12] <= 'd0 ;
		fifo_din_cmd_adc[63]    <= 'd0 ;
		fifo_din_cmd_adc[11:0]  <= 'd4095;
	end
	else if(fifo_wr_en_wr_adc_cnt[7:0] == 'd255 && fifo_wr_en_wr_adc ) begin
		fifo_din_cmd_adc[25:24] <=  fifo_wr_en_wr_adc_cnt[9:8];
		fifo_din_cmd_adc[30:26] <=  adc_data_add_sop_d2_cnt - 1;
		fifo_din_cmd_adc[43:33] <=  wr_base_addr[31:21];
	end
	else
		fifo_din_cmd_adc <= fifo_din_cmd_adc ;
end

always @(posedge clk) begin
    if(rst)
		fifo_wr_en_cmd_adc <= 'd0 ;
	else if(fifo_wr_en_wr_adc_cnt[7:0] == 'd255 && fifo_wr_en_wr_adc ) 
		fifo_wr_en_cmd_adc <= 'd1 ;
	else 
		fifo_wr_en_cmd_adc <= 'd0 ;
end

//------------------------------------------------------------------------------------

reg 		rd_op_flag_d1 ='d0;
reg 		rd_op_flag_d2 ='d0;
reg [7 :0]	wave_position_d1 ='d0;
reg [7 :0]	wave_position_d2 ='d0;
reg [7 :0]	cur_wave_position_sync ;
reg [7 :0]	cur_wave_position ;
reg [63:0]	wr_end_shift ;
reg 		wr_end_flag  ;
reg [4:0]  	rd_op_flag_cnt ;

always @(posedge clk) begin
	rd_op_flag_d1 <= rd_op_flag ;
	rd_op_flag_d2 <= rd_op_flag_d1 ;
end

always @(posedge clk) begin
	wr_end_shift <= {wr_end_shift[30:0],~rd_op_flag_d1 && rd_op_flag_d2} ;
end

always @(posedge clk) begin
	if(rst)
		rd_op_flag_cnt <= 'd0 ;
	else if(~rd_op_flag_d1 && rd_op_flag_d2)
		rd_op_flag_cnt <= rd_op_flag_cnt + 1'b1 ; 
	else 
		rd_op_flag_cnt <= rd_op_flag_cnt ;
end



always @(posedge clk) begin
	wr_end_flag <= |wr_end_shift[63:16];
end

always @(posedge clk) begin
	if(rst)
		adc_wr_irp <= 'd0 ;
	else 
		adc_wr_irp <= wr_end_flag && (rd_op_flag_cnt == 'd0);
end

always @(posedge clk) begin
    if(rst)	begin 
		wave_position_d1 <= 'd0 ;
		wave_position_d2 <= 'd0 ;
	end
	else begin 
		wave_position_d1 <=	wave_position ;
		wave_position_d2 <=	wave_position_d1 ;
	end
end

always @(posedge clk) begin
    if(rst)
		cur_wave_position_sync <= 'd0 ;
	else if(CPIE_d2)
		cur_wave_position_sync <= wave_position_d2 ;
	else 
		cur_wave_position_sync <= cur_wave_position_sync ;
end


always @(posedge clk) begin
    if(rst)
		cur_wave_position <= 'd0 ;
	else if(CPIB_d2)
		cur_wave_position <= cur_wave_position_sync;
	else
		cur_wave_position <= cur_wave_position ; 
end

reg [7:0]	last_position_tmp1='d0 ;
reg [7:0]	last_position_tmp2='d0 ;


always @(posedge clk ) begin
	if(rst)
		last_position_tmp1 <= 'd0 ;	
	else if(wr_end_shift[7])
		last_position_tmp1 <= cur_wave_position ;
	else 
		last_position_tmp1 <= last_position_tmp1 ;
end

always @(posedge clk ) begin
	last_position_tmp2 <= last_position_tmp1 ;
	last_position <= last_position_tmp2 ;
end

always @(posedge clk) begin
    if(rst)
		wr_base_addr <= 32'h6000_0000;
	else begin 
		wr_base_addr[28:21] <= cur_wave_position ;
		wr_base_addr[20:0]  <= 'd0 ;
		wr_base_addr[31:29] <= 3'b011 ;
	end
end

//--------------------------------------debug--------------------------------------------

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

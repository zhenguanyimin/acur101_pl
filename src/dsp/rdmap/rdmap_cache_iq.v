module rdmap_cache_iq (

    input               clk                 ,
	input               rst                 ,

    input [63:0]        rdmapIQ_data        ,
    input               rdmapIQ_data_tvalid ,
    input               rdmapIQ_data_tlast  ,
    input [7 :0]        wave_position       ,

    output  reg [63:0]  fifo_din_cmd_rdmapIQ  ,
    output  reg         fifo_wr_en_cmd_rdmapIQ,
    input               fifo_full_cmd_rdmapIQ ,
    
    output  reg         fifo_wr_en_wr_rdmapIQ ,
    output  reg [127:0] fifo_din_wr_rdmapIQ   ,
    input               fifo_full_wr_rdmapIQ  ,
    output 	reg 		rdmapIQ_wr_irq        
);


reg [63:0]        rdmapIQ_data_d1='d0 ;
reg [63:0]        rdmapIQ_data_d2='d0 ;
reg               rdmapIQ_data_tvalid_d1='d0 ;
reg               rdmapIQ_data_tvalid_d2='d0 ;
reg               rdmapIQ_data_tvalid_d3='d0 ;
reg               rdmapIQ_data_tvalid_d4='d0 ;
reg               rdmapIQ_data_tlast_d1='d0 ; 
reg               rdmapIQ_data_tlast_d2='d0 ;
reg               rdmapIQ_data_tlast_d3='d0 ;
reg [127:0]       tag_info_i_d1 ='d0;
reg [127:0]       tag_info_i_d2 ='d0;

always @(posedge clk) begin
    rdmapIQ_data_d1 <= rdmapIQ_data ;
    rdmapIQ_data_d2 <= rdmapIQ_data_d1 ;
end

always @(posedge clk) begin
    rdmapIQ_data_tvalid_d1 <= rdmapIQ_data_tvalid ;
    rdmapIQ_data_tvalid_d2 <= rdmapIQ_data_tvalid_d1 ;
    rdmapIQ_data_tvalid_d3 <= rdmapIQ_data_tvalid_d2 ;
    rdmapIQ_data_tvalid_d4 <= rdmapIQ_data_tvalid_d3 ;
end

always @(posedge clk) begin
    rdmapIQ_data_tlast_d1 <= rdmapIQ_data_tlast ;
    rdmapIQ_data_tlast_d2 <= rdmapIQ_data_tlast_d1; 
    rdmapIQ_data_tlast_d3 <= rdmapIQ_data_tlast_d2;
end

reg             uram_wea    ='d0;
reg [14:0]      uram_addra  ='d0;
wire[127:0]     uram_dina   ;

reg [14:0]      uram_addrb  ='d0;
wire[127:0]     uram_doutb      ;

xpm_memory_sdpram #(
.ADDR_WIDTH_A             (15             ),
.ADDR_WIDTH_B             (15             ),
.AUTO_SLEEP_TIME          (0              ),
.BYTE_WRITE_WIDTH_A       (128            ),
.CASCADE_HEIGHT           (0              ),
.CLOCKING_MODE            ("common_clock" ),
.ECC_MODE                 ("no_ecc"       ),
.MEMORY_INIT_FILE         ("none"         ),
.MEMORY_INIT_PARAM        ("0"            ),
.MEMORY_OPTIMIZATION      ("true"         ),
.MEMORY_PRIMITIVE         ("ultra"        ),
.MEMORY_SIZE              (4194304        ),//32bit*2048column*(32+2)row
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
.WRITE_DATA_WIDTH_A       (128            ),
.WRITE_MODE_B             ("read_first"   ),
.WRITE_PROTECT            (1              )
)
u_xpm_memory_sdpram_adc (
.clka           (clk                ),
.clkb           (clk                ),
.dbiterrb       (                   ),
.sbiterrb       (                   ),
.ena            (1'b1               ),
.wea            (uram_wea           ),
.addra          (uram_addra         ),
.dina           (uram_dina          ),
.enb            (1'b1               ),
.addrb          (uram_addrb         ),
.doutb          (uram_doutb         ),
.injectdbiterra (1'b0               ),
.injectsbiterra (1'b0               ),
.regceb         (1'b1               ),
.rstb           (1'b0               ),
.sleep          (1'b0               )
);

reg [0:0]       div_2_cnt  ;
reg [127:0]     rdmap_shift;
reg             wr_op_end_flag;
reg             wr_op;

always @(posedge clk) begin
    if(rst)
        div_2_cnt <= 'd0 ;
    else if(rdmapIQ_data_tvalid_d3)
        div_2_cnt <= div_2_cnt + 1'b1 ;
    else 
        div_2_cnt <= 'd0 ;
end

always @(posedge clk) begin
    if(rst)
        rdmap_shift <= 'd0; 
    else
        rdmap_shift <= {rdmap_shift[63:0],rdmapIQ_data_d2};
end

assign uram_dina = rdmap_shift ;

always @(posedge clk) begin
    uram_wea <= rdmapIQ_data_tvalid_d2;
end

always @(posedge clk) begin
    if(rst)
        uram_addra <= 'd0 ;
    else if(rdmapIQ_data_tlast_d3)
        uram_addra <= 'd0 ;
    else if(rdmapIQ_data_tvalid_d3 && div_2_cnt )
        uram_addra <= uram_addra + 1'b1 ;
    else 
        uram_addra <= uram_addra ;            
end

//---------------------------------------------------rd_en_cha-------------------------------------------------------

reg			uram_rd_op_flag;
reg [14: 0]	uram_rd_en_cnt ;
reg 		uram_rd_en ;
reg [14: 0]	fifo_wr_en_wr_rdmap_cnt ;
reg [3 : 0] wr_op_end_flag_shift;
reg         rd_op_end_flag;

always @(posedge clk) begin
    wr_op_end_flag_shift <= {wr_op_end_flag_shift[3:0],rdmapIQ_data_tlast_d2};
end

always @(posedge clk) begin
    if(rst)
        rd_op_end_flag <= 'd0 ;
	else if(wr_op_end_flag_shift[3])
        rd_op_end_flag <= 'd0 ;
    else if(uram_rd_en_cnt == 'd32767 && uram_rd_en )
        rd_op_end_flag <= 'd1 ;
    else 
        rd_op_end_flag <= rd_op_end_flag;
end

always @(posedge clk) begin
    if(rst)
		uram_rd_op_flag <= 'd0 ;
	else if(wr_op_end_flag_shift[3])
		uram_rd_op_flag <= 'd1 ;
	else if(fifo_wr_en_wr_rdmap_cnt == 'd32767 && fifo_wr_en_wr_rdmapIQ )
		uram_rd_op_flag <= 'd0 ;
	else
		uram_rd_op_flag <= uram_rd_op_flag ;
end

always @(posedge clk) begin
    if(rst)
        uram_rd_en <= 'd0 ;
	else if((uram_rd_en_cnt == 'd32767 && uram_rd_en) || rd_op_end_flag)
		uram_rd_en <= 'd0 ;
	else if(uram_rd_op_flag  && ~fifo_full_wr_rdmapIQ )
		uram_rd_en <= 1 ;
	else 
		uram_rd_en <= 'd0 ;
end

always @(posedge clk) begin
    if(rst)
        uram_rd_en_cnt <= 'd0 ;
	else if(wr_op_end_flag_shift[2])
		uram_rd_en_cnt <= 'd0 ;
	else if(uram_rd_en_cnt <'d32767)
		uram_rd_en_cnt <= (uram_rd_en) ? uram_rd_en_cnt + 1'b1 : uram_rd_en_cnt ;
	else 
		uram_rd_en_cnt <= uram_rd_en_cnt ;
end

always @(posedge clk) begin
    if(rst)
        uram_addrb <= 'd0 ;
    else if(rdmapIQ_data_tlast_d2)
        uram_addrb <= 'd0 ;
    else
        uram_addrb <= uram_rd_en_cnt ;      
end

//--------------------------------------------ddr output------------------------------


reg [7 : 0]     wave_position_d1 = 'd0 ;
reg [7 : 0]     wave_position_d2 = 'd0 ;

reg [31: 0]     wr_base_addr ;
reg [7 : 0]	    uram_rd_en_shift ='d0;

always @(posedge clk) begin
    wave_position_d1 <= wave_position ;
    wave_position_d2 <= wave_position_d1;
end

always @(posedge clk) begin
    uram_rd_en_shift <= {uram_rd_en_shift[6:0],uram_rd_en};
end

always @(posedge clk) begin
    if(rst)
        fifo_wr_en_wr_rdmapIQ <= 'd0 ;
    else 
        fifo_wr_en_wr_rdmapIQ <=  uram_rd_en_shift[2];
end

always @(posedge clk) begin
    if(rst)
        fifo_wr_en_wr_rdmap_cnt <= 'd0 ;
    else if(fifo_wr_en_wr_rdmapIQ)
        fifo_wr_en_wr_rdmap_cnt <= fifo_wr_en_wr_rdmap_cnt + 1'b1 ;
    else 
        fifo_wr_en_wr_rdmap_cnt <= fifo_wr_en_wr_rdmap_cnt ;
end


always @(posedge clk) begin
    if(rst)
		fifo_din_wr_rdmapIQ <= 'd0 ;
	else 
		fifo_din_wr_rdmapIQ <= {uram_doutb[63:0],uram_doutb[127:64]} ;
end


always @(posedge clk) begin
    if(rst) begin 
		fifo_din_cmd_rdmapIQ[62:12] <= 'd0 ;
		fifo_din_cmd_rdmapIQ[63]    <= 'd0 ;
		fifo_din_cmd_rdmapIQ[11:0]  <= 'd4095;
	end
	else if(fifo_wr_en_wr_rdmap_cnt[7:0] == 'd255 && fifo_wr_en_wr_rdmapIQ ) begin
		fifo_din_cmd_rdmapIQ[30:24] <=  fifo_wr_en_wr_rdmap_cnt[14:8];
		fifo_din_cmd_rdmapIQ[63]    <= 'd0 ;
		fifo_din_cmd_rdmapIQ[11:0]  <= 'd4095;
        fifo_din_cmd_rdmapIQ[43:31] <=  wr_base_addr[31:19];
	end
	else
		fifo_din_cmd_rdmapIQ <= fifo_din_cmd_rdmapIQ ;
end

always @(posedge clk) begin
    if(rst)
		fifo_wr_en_cmd_rdmapIQ <= 'd0 ;
	else if(fifo_wr_en_wr_rdmap_cnt[7:0] == 'd255 && fifo_wr_en_wr_rdmapIQ ) 
		fifo_wr_en_cmd_rdmapIQ <= 'd1 ;
	else 
		fifo_wr_en_cmd_rdmapIQ <= 'd0 ;
end

always @(posedge clk) begin
    if(rst)
		wr_base_addr <= 32'h6000_0000;
	else begin 
		wr_base_addr[28:21] <= wave_position_d2 ;
		wr_base_addr[20:20] <= 'd0 ;
        wr_base_addr[19:19] <= 'b1 ;
        wr_base_addr[18: 0] <= 'b0 ;
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
        rdmapIQ_wr_irq <= 'd0 ;
    else 
        rdmapIQ_wr_irq <=  |wr_end_shift[63:40] ;
end

//------------------------------------------------debug signal ------------------------------------------------

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

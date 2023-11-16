/*
* 缓存检测点和log信息
*/
module detection_log
(
    input               clk ,
    input               rst ,

    (* MARK_DEBUG="true" *)input               start_op        ,        // rdmap_ip数据传输完成后开始传输检测点和log信息
    input [31:0]        detection_data  ,
    input               detection_valid ,
    input               detection_sop   ,
    input               detection_eop   ,
    input [7 :0]        wave_position   ,
    (* MARK_DEBUG="true" *)output[7 :0]        cur_wave_position,

    input [31:0]        log_data0       ,
    input [31:0]        log_data1       ,
    input [31:0]        log_data2       ,
    input [31:0]        log_data3       ,
    input [31:0]        log_data4       ,
    input [31:0]        log_data5       ,
    input [31:0]        log_data6       ,
    input [31:0]        log_data7       ,
    input [31:0]        log_data8       ,
    input [31:0]        log_data9       ,
    input [31:0]        log_data10      ,
    input [31:0]        log_data11      ,
    input [31:0]        log_data12      ,
    input [31:0]        log_data13      ,
    input [31:0]        log_data14      ,
    input [31:0]        log_data15      ,

    output  reg [63:0]  fifo_din_cmd_detection      ,
    output  reg         fifo_wr_en_cmd_detection    ,
    input   wire        fifo_full_cmd_detection     ,
    
    output  reg         fifo_wr_en_wr_detection     ,
    output  reg [127:0] fifo_din_wr_detection       ,
    input   wire        fifo_full_wr_detection      ,
    output  wire        detection_log_busy          ,
    output  reg         detection_log_irq                         
);

reg [31:0]  detection_data_d1   ='d0;
reg         detection_valid_d1  ='d0;
reg         detection_sop_d1    ='d0;
reg         detection_eop_d1    ='d0;

reg [31:0]  detection_data_d2   ='d0;
reg         detection_valid_d2  ='d0;
reg         detection_sop_d2    ='d0;
reg         detection_eop_d2    ='d0;

reg         start_op_d1         ='d0;
reg         start_op_d2         ='d0;
reg [127:0] tag_info_i_d1       ='d0;
reg [127:0] tag_info_i_d2       ='d0;

always @(posedge clk) begin
    detection_data_d1   <= detection_data ; 
    detection_valid_d1  <= detection_valid;
    detection_sop_d1    <= detection_sop  ;  
    detection_eop_d1    <= detection_eop  ;

    detection_data_d2   <= detection_data_d1 ; 
    detection_valid_d2  <= detection_valid_d1;
    detection_sop_d2    <= detection_sop_d1  ;  
    detection_eop_d2    <= detection_eop_d1  ;
end

always @(posedge clk) begin
    start_op_d1 <= start_op ;
    start_op_d2 <= start_op_d1 ;
end

reg         ram_wea    ;  
reg         ram_wea_d1 ='d0;
reg [9:0]   ram_addra  ;
reg [31:0]  ram_dina   ;

reg [7:0]   ram_addrb  ;
wire[127:0] ram_doutb  ;

xpm_memory_sdpram #(
.ADDR_WIDTH_A             (10             ),
.ADDR_WIDTH_B             (8              ),
.AUTO_SLEEP_TIME          (0              ),
.BYTE_WRITE_WIDTH_A       (32             ),
.CASCADE_HEIGHT           (0              ),
.CLOCKING_MODE            ("common_clock" ),
.ECC_MODE                 ("no_ecc"       ),
.MEMORY_INIT_FILE         ("none"         ),
.MEMORY_INIT_PARAM        ("0"            ),
.MEMORY_OPTIMIZATION      ("true"         ),
.MEMORY_PRIMITIVE         ("ultra"        ),
.MEMORY_SIZE              (32768          ),//32bit*2048column*(32+2)row
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
.clka           (clk                ),
.clkb           (clk                ),
.dbiterrb       (                   ),
.sbiterrb       (                   ),
.ena            (1'b1               ),
.wea            (ram_wea_d1         ),
.addra          (ram_addra          ),
.dina           (ram_dina           ),
.enb            (1'b1               ),
.addrb          (ram_addrb          ),
.doutb          (ram_doutb          ),
.injectdbiterra (1'b0               ),
.injectsbiterra (1'b0               ),
.regceb         (1'b1               ),
.rstb           (1'b0               ),
.sleep          (1'b0               )
);

//----------------------------------------ram write ---------------------------------

reg [10:0]   ram_wea_cnt ;

always @(posedge clk) begin
    if(rst)
        ram_wea <= 'd1023 ; 
    else if(detection_sop_d2)
        ram_wea <= 1'b1 ;
    else if(ram_wea_cnt == 'd1023)
        ram_wea <= 1'b0 ;
    else 
        ram_wea <= ram_wea ;
end

always @(posedge clk) begin
    ram_wea_d1 <= ram_wea ;
end

always @(posedge clk) begin
    if(rst)
        ram_wea_cnt <= 'd0 ;
    else if(detection_sop_d2)
        ram_wea_cnt <= 'd0 ;
    else if(ram_wea_cnt < 'd1023)
        ram_wea_cnt <= ram_wea_cnt + 1'b1 ;
    else
        ram_wea_cnt <= ram_wea_cnt; 
end

always @(posedge clk) begin
    if(rst)
        ram_addra <= 'd0 ;
    else 
        ram_addra <= ram_wea_cnt ;
end

always @(posedge clk) begin
    if(rst)
        ram_dina <= 'd0; 
    // else if(detection_valid_d2)
    else if(ram_wea_cnt[9:8] == 'b11)
        case (ram_wea_cnt[7:0])
        'd0 :   ram_dina <= log_data0 ;   
        'd1 :   ram_dina <= log_data1 ;
        'd2 :   ram_dina <= log_data2 ; 
        'd3 :   ram_dina <= log_data3 ;
        'd4 :   ram_dina <= log_data4 ;
        'd5 :   ram_dina <= log_data5 ;
        'd6 :   ram_dina <= log_data6 ;
        'd7 :   ram_dina <= log_data7 ;
        'd8 :   ram_dina <= log_data8 ;
        'd9 :   ram_dina <= log_data9 ;
        'd10:   ram_dina <= log_data10;
        'd11:   ram_dina <= log_data11;
        'd12:   ram_dina <= log_data12;
        'd13:   ram_dina <= log_data13;
        'd14:   ram_dina <= log_data14;
        'd15:   ram_dina <= log_data15;
            default:
                ram_dina <= 32'h5a5a_5a5a;
        endcase
    else 
        ram_dina <= 32'h5a5a_5a5a; 
end
//---------------------------------------read ram-------------------------------------

reg         ram_rd_op_flag ;
reg         rd_op_end_flag ;
reg [7:0]   ram_rd_en_cnt  ;
reg         ram_rd_en ;
reg [7:0]   fifo_wr_en_wr_detection_cnt ;

always @(posedge clk) begin
    if(rst)
        ram_rd_op_flag <= 'd0 ;
    else if(~start_op_d2 && start_op_d1)
        ram_rd_op_flag <= 'd1 ;
    else if(fifo_wr_en_wr_detection_cnt == 'd255 && fifo_wr_en_wr_detection)
        ram_rd_op_flag <= 'd0 ;
    else 
        ram_rd_op_flag <= ram_rd_op_flag ;
end

always @(posedge clk) begin
    if(rst)
        rd_op_end_flag <= 'd0 ;
    else if(~start_op_d2 && start_op_d1 )
        rd_op_end_flag <= 'd0 ;
    else if(ram_rd_en_cnt == 'd255 && fifo_wr_en_wr_detection)
        rd_op_end_flag <= 'd1 ;
    else 
        rd_op_end_flag <= rd_op_end_flag ;
end

always @(posedge clk) begin
    if(rst)
        ram_rd_en <= 'd0 ;
    else if((ram_rd_en_cnt == 'd255 && ram_rd_en) || rd_op_end_flag)
        ram_rd_en <= 'd0 ;
    else if(ram_rd_op_flag && ~fifo_full_wr_detection)
        ram_rd_en <= 'd1 ;
    else 
        ram_rd_en <= 'd0 ;
end

always @(posedge clk) begin
    if(rst)
        ram_rd_en_cnt <= 'd0 ;
    else if(~start_op_d2 && start_op_d1 )
        ram_rd_en_cnt <= 'd0 ;
    else if(ram_rd_en_cnt < 'd255)
        ram_rd_en_cnt <= (ram_rd_en) ? ram_rd_en_cnt + 1'b1 : ram_rd_en_cnt ;
    else 
        ram_rd_en_cnt <= ram_rd_en_cnt ;
end

always @(posedge clk) begin
    if(rst)
        ram_addrb <= 'd0 ;
    else if(~start_op_d2 && start_op_d1 )
        ram_addrb <= 'd0 ;
    else 
        ram_addrb <= ram_rd_en_cnt ;
end

//---------------------------------------------ddr out-------------------------------------------
reg [7:0]   wave_position_d1 ='d0 ;
reg [7:0]   wave_position_d2 ='d0 ;
(* MARK_DEBUG="true" *)reg [31:0]  wr_base_addr ;
reg [7:0]   ram_rd_en_shift ='d0;

always @(posedge clk) begin
    ram_rd_en_shift <= {ram_rd_en_shift[6:0],ram_rd_en};    
end

always @(posedge clk) begin
    wave_position_d1 <= wave_position ;
    wave_position_d2 <= wave_position_d1 ; 
end

always @(posedge clk) begin
    if(rst)
        fifo_wr_en_wr_detection <= 'd0 ;
    else
        fifo_wr_en_wr_detection <= ram_rd_en_shift[2];
end

always @(posedge clk) begin
    if(rst)
        fifo_wr_en_wr_detection_cnt <= 'd0 ;
    else if(fifo_wr_en_wr_detection)
        fifo_wr_en_wr_detection_cnt <= fifo_wr_en_wr_detection_cnt + 1'b1 ;
    else 
        fifo_wr_en_wr_detection_cnt <= fifo_wr_en_wr_detection_cnt ;
end

always @(posedge clk) begin
    if(rst)
        fifo_din_wr_detection <= 'd0 ;
    else 
        fifo_din_wr_detection <= ram_doutb;
end


always @(posedge clk) begin
    if(rst) begin
        fifo_din_cmd_detection[62:12] <= 'd0 ;
        fifo_din_cmd_detection[63] <= 'd0 ;
        fifo_din_cmd_detection[11:0] <= 'd4095 ;     
    end 
    else if(fifo_wr_en_wr_detection_cnt[7:0] == 'd255 && fifo_wr_en_wr_detection) begin 
        fifo_din_cmd_detection[30:24] <= 'd0;
        fifo_din_cmd_detection[63] <= 'd0 ;
        fifo_din_cmd_detection[11:0]<= 'd4095;
        fifo_din_cmd_detection[43:31]<= wr_base_addr[31:19];
    end
    else 
        fifo_din_cmd_detection <= fifo_din_cmd_detection ;
end

always @(posedge clk) begin
    if(rst)
        fifo_wr_en_cmd_detection <= 'd0 ;
    else if(fifo_wr_en_wr_detection_cnt[7:0]== 'd255 && fifo_wr_en_wr_detection )
        fifo_wr_en_cmd_detection <= 'd1 ;
    else 
        fifo_wr_en_cmd_detection <= 'd0 ;
end

always @(posedge clk) begin
    if(rst)
        wr_base_addr <= 32'h6000_0000;
    else begin 
        wr_base_addr[28:21] <= wave_position_d2 ;
        wr_base_addr[20:20] <= 'd1 ;
        wr_base_addr[19:19] <= 'b1 ;
        wr_base_addr[18:0]  <= 'd0 ;
        wr_base_addr[31:29] <= 3'b011;
    end
end

//-----------------------------------------irq-----------------------------------------

reg         rd_op_flag_d1   ;
reg         rd_op_flag_d2   ;
reg         detection_log_busy_reg ;

reg [31:0]  irq_delay_cnt   ;           // 延迟100us产生中断
always @(posedge clk) begin
    if(rst)
        irq_delay_cnt <= 'd0 ;
    else if(~rd_op_flag_d1 && rd_op_flag_d2)
        irq_delay_cnt <= 'd0  ;
    else if(irq_delay_cnt == 'd320_64)
        irq_delay_cnt <= irq_delay_cnt;
    else
        irq_delay_cnt <= irq_delay_cnt + 1'b1 ;
end

always @(posedge clk) begin
    rd_op_flag_d1 <= ram_rd_op_flag ;
    rd_op_flag_d2 <= rd_op_flag_d1 ;
end

always @(posedge clk) begin
    if(rst)
        detection_log_irq <= 'd0 ;
    else if(irq_delay_cnt == 'd320_00)
        detection_log_irq <= 'd1 ;
    else if(irq_delay_cnt == 'd320_64)
        detection_log_irq <= 'd0 ;
    else 
        detection_log_irq <= detection_log_irq ;
end

always @(posedge clk) begin
    if(rst)
        detection_log_busy_reg <= 'd0 ;
    else
        detection_log_busy_reg <= rd_op_flag_d2 ;
end
reg [7:0]   cur_wave_position_reg ;

always @(posedge clk) begin
    if(rst)
        cur_wave_position_reg <= 'd0 ;
    else 
        cur_wave_position_reg <= wave_position_d2 ; 
end

assign cur_wave_position = cur_wave_position_reg ;
assign detection_log_busy = detection_log_busy_reg ;

//------------------------------------------------debug signal----------------------------------------------

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
	else if(~ram_rd_op_flag && rd_op_flag_d1)
		write_time_max <= (write_time_max < write_time) ? write_time: write_time_max;
	else
		write_time_max <= write_time_max;
end

reg [31:0]  fifo_full_wr_detection_time ;
(* MARK_DEBUG="true" *)reg [31:0]  fifo_full_wr_detection_time_max ;

always @(posedge clk) begin
    if(rst)
        fifo_full_wr_detection_time <= 'd0; 
    else if(~start_op_d2 && start_op_d1)
        fifo_full_wr_detection_time <= 'd0 ;
    else if(fifo_full_wr_detection)
        fifo_full_wr_detection_time <= fifo_full_wr_detection_time + 1'b1 ;
    else 
        fifo_full_wr_detection_time <= fifo_full_wr_detection_time ; 
end

always @(posedge clk) begin
    if(rst)
        fifo_full_wr_detection_time_max <= 'd0 ;
    else if(~start_op_d2 && start_op_d1)
        fifo_full_wr_detection_time_max <= (fifo_full_wr_detection_time_max < fifo_full_wr_detection_time) ? fifo_full_wr_detection_time :fifo_full_wr_detection_time_max;
    else 
        fifo_full_wr_detection_time_max <= fifo_full_wr_detection_time_max ;
end

endmodule

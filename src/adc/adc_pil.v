module adc_pil
(
    input                clk ,
    input                rst ,

    output  reg  [63:0]  fifo_din_cmd   ,
    output  reg          fifo_wr_en_cmd ,
    input   wire         fifo_full_cmd  ,

    input   wire [127:0] fifo_dout_rd   ,
    output  reg          fifo_rd_en_rd  ,
    input   wire         fifo_empty_rd  ,
    
    input [15:0]         sample_num     ,
    input [15:0]         chirp_num      ,
    input [7 :0]         wave_position  ,
    input                pil_trigger    ,
    input [31:0]         pil_pri_delay  ,

    output reg [15:0]    adc_sli_data_cha ,
    output reg           adc_sli_sop_cha  ,
    output reg           adc_sli_eop_cha  ,
    output reg           adc_sli_valid_cha,

    output reg [15:0]    adc_sli_data_chb ,
    output reg           adc_sli_sop_chb  ,
    output reg           adc_sli_eop_chb  ,
    output reg           adc_sli_valid_chb
);

reg [15:0]  sample_num_d1 = 'd0 ;
reg [15:0]  sample_num_d2 = 'd0 ;
reg [15:0]  chirp_num_d1 = 'd0 ;
reg [15:0]  chirp_num_d2 = 'd0 ;
reg [15:0]  wave_position_d1 = 'd0 ;
reg [15:0]  wave_position_d2 = 'd0 ;
reg         pil_trigger_d1 = 'd0 ;
reg         pil_trigger_d2 = 'd0 ;
reg         pil_trigger_d3 = 'd0 ;
reg         pil_trigger_d4 = 'd0 ;
reg [31:0]  pil_pri_delay_d1 = 'd0 ;
reg [31:0]  pil_pri_delay_d2 = 'd0 ;
reg [127:0] fifo_dout_rd_d1 = 'd0 ;
reg [127:0] fifo_dout_rd_d2 = 'd0 ;
reg         fifo_empty_rd_d1= 'd0 ;
reg         fifo_empty_rd_d2= 'd0 ;

always @(posedge clk) begin
    sample_num_d1 <= sample_num ;
    sample_num_d2 <= sample_num_d1 ;
end

always @(posedge clk) begin
    chirp_num_d1 <= chirp_num ;
    chirp_num_d2 <= chirp_num_d1 ;
end

always @(posedge clk) begin
    wave_position_d1 <= wave_position ;
    wave_position_d2 <= wave_position_d1 ;
end

always @(posedge clk) begin
    pil_trigger_d1 <= pil_trigger ;
    pil_trigger_d2 <= pil_trigger_d1 ;
    pil_trigger_d3 <= pil_trigger_d2 ;
    pil_trigger_d4 <= pil_trigger_d3 ;
end


always @(posedge clk) begin
    pil_pri_delay_d1 <= pil_pri_delay ;
    pil_pri_delay_d2 <= pil_pri_delay_d1 ;    
end

always @(posedge clk) begin
    fifo_dout_rd_d1 <= fifo_dout_rd ;
    fifo_dout_rd_d2 <= fifo_dout_rd_d1 ;
end

always @(posedge clk) begin
    fifo_empty_rd_d1 <= fifo_empty_rd ;
    fifo_empty_rd_d2 <= fifo_empty_rd_d1 ;
end

//---------------------------------------------------------------------
reg					ram_wen_a ;
reg	 [9  : 0]		ram_waddr_a ;
reg  [127: 0]		ram_wdata_a ;

reg  [11 : 0]		ram_raddr_b ;
wire [31 : 0]		ram_rdata_b ;

xpm_memory_sdpram #(
.ADDR_WIDTH_A             (10             ),
.ADDR_WIDTH_B             (12             ),
.AUTO_SLEEP_TIME          (0              ),
.BYTE_WRITE_WIDTH_A       (               ),
.CASCADE_HEIGHT           (0              ),
.CLOCKING_MODE            ("common_clock" ),
.ECC_MODE                 ("no_ecc"       ),
.MEMORY_INIT_FILE         ("none"         ),
.MEMORY_INIT_PARAM        ("0"            ),
.MEMORY_OPTIMIZATION      ("true"         ),
.MEMORY_PRIMITIVE         ("block"        ),
.MEMORY_SIZE              (131072         ),//32bit*2048column*(32+2)row
.MESSAGE_CONTROL          (0              ),
.READ_DATA_WIDTH_B        (32             ),
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

//------------------------------FSM--------------------------------------
parameter IDLE  = 4'd0 ;
parameter CACHE = 4'd1 ;
parameter OP    = 4'd2 ;
parameter DELAY = 4'd3 ;

reg [3:0]   cur_state ;
reg [3:0]   nxt_state ;

reg [6:0]   burst_4k_cnt; 
reg         ddr_op_flag ;

reg         ram_rd_flag ;
reg         ram_rd_flag_d1 = 'd0 ;
reg         ram_rd_flag_d2 = 'd0 ;
reg         ram_rd_flag_d3 = 'd0 ;
reg         ram_rd_flag_d4 = 'd0 ;
reg         ram_rd_flag_d5 = 'd0 ;

reg [31:0]  delay_cnt ;
reg         fifo_rd_en_rd_d1 ='d0;
reg         fifo_rd_en_rd_d2 ='d0;

//-----------------------------first FSM --------------------------------
always @(posedge clk) begin
    if(rst)
        cur_state <= IDLE ;
    else 
        cur_state <= nxt_state ;
end

//-----------------------------second FSM--------------------------------
always @(*) begin
    if(rst)
        nxt_state = IDLE ;
    else
        case (cur_state)
            IDLE :
                if(~pil_trigger_d4 && pil_trigger_d3)
                    nxt_state = CACHE;
                else 
                    nxt_state = IDLE;
            CACHE:  
                if(burst_4k_cnt[1:0] == 'd3 && ddr_op_flag)
                    nxt_state = OP;
                else
                    nxt_state = CACHE;
            OP :
                if(~ram_rd_flag_d3 && ram_rd_flag_d4)
                    nxt_state = DELAY;
                else
                    nxt_state = OP;
            DELAY : if(delay_cnt == pil_pri_delay_d2)
                        if(burst_4k_cnt[6:2] == 'd0 )
                            nxt_state = IDLE ;
                        else
                            nxt_state = CACHE;
                    else
                        nxt_state = DELAY ;
            default: 
                    nxt_state = IDLE;
        endcase
end


//---------------------------third FSM-----------------------------------

//----------------------------ram_write-----------------------------------
always @(posedge clk) begin
    if(rst)
        ram_waddr_a <= 'd0 ;
    else if(cur_state == IDLE || cur_state == DELAY)
        ram_waddr_a <= 'd0 ;
    else if(ram_wen_a)
        ram_waddr_a <= ram_waddr_a + 1'b1 ;
    else
        ram_waddr_a <= ram_waddr_a ;
end

always @(posedge clk) begin
    if(rst)
        ram_wdata_a <= 'd0 ;
    else 
        ram_wdata_a <= fifo_dout_rd ;
end


always @(posedge clk) begin
    if(rst)
        ram_wen_a <= 'd0 ;
    else if(fifo_rd_en_rd_d2 && ~fifo_empty_rd_d2)
        ram_wen_a <= 'd1 ;
    else 
        ram_wen_a <= 'd0 ;
end

always @(posedge clk) begin
    fifo_rd_en_rd_d1 <= fifo_rd_en_rd ;
    fifo_rd_en_rd_d2 <= fifo_rd_en_rd_d1 ;
end

always @(posedge clk) begin
    if(rst)
        ddr_op_flag <= 'd0 ;
    else if(ram_waddr_a[7:0]== 'd255 && ram_wen_a)
        ddr_op_flag <= 'd1 ;
    else 
        ddr_op_flag <= 'd0 ;
end
 
always @(posedge clk ) begin
    if(rst)
        burst_4k_cnt <= 'd0 ;
    else if(cur_state == IDLE)
        burst_4k_cnt <= 'd0 ;
    else if(ddr_op_flag)  
        burst_4k_cnt <= burst_4k_cnt + 1'b1 ;
    else 
        burst_4k_cnt <= burst_4k_cnt ;
end

//-----------------------------------------uram-read-------------------------------

always @(posedge clk) begin
    if(rst)
        ram_rd_flag <= 'd0 ;
    else if(cur_state == CACHE && nxt_state == OP)
        ram_rd_flag <= 'd1 ;
    else if(ram_raddr_b == 'd4095)
        ram_rd_flag <= 'd0 ;
    else 
        ram_rd_flag <= ram_rd_flag ;
end

always @(posedge clk) begin
    ram_rd_flag_d1 <= ram_rd_flag ;
    ram_rd_flag_d2 <= ram_rd_flag_d1 ;
    ram_rd_flag_d3 <= ram_rd_flag_d2 ;
    ram_rd_flag_d4 <= ram_rd_flag_d3 ;
end

always @(posedge clk) begin
    if(rst)
        ram_raddr_b <= 'd0 ;
    else if(ram_rd_flag)
        ram_raddr_b <= ram_raddr_b + 1'b1 ;
    else 
        ram_raddr_b <= 'd0 ;
end


//-----------------------------------DDR CMD----------------------------------
reg         ddr_op_flag_d1 = 'd0;
reg         ddr_op_flag_d2 = 'd0;

reg [31:0]  base_addr ;

always @(posedge clk) begin
    ddr_op_flag_d1 <= ddr_op_flag ;
    ddr_op_flag_d2 <= ddr_op_flag_d1 ;
end

always @(posedge clk) begin
    if(rst)
        base_addr <= 32'h6000_0000 ;
    else
        base_addr[28:21]<= wave_position_d2 ;
end

always @(posedge clk) begin
    if(rst) begin
        fifo_din_cmd[62:12] <= 'd0 ;
        fifo_din_cmd[63] <= 'd0 ;
        fifo_din_cmd[11:0] <= 'd4095 ;    
    end    
    else begin 
        fifo_din_cmd[23:12] <= 'd0;
        fifo_din_cmd[31:24] <= burst_4k_cnt;
        fifo_din_cmd[43:33] <= base_addr[31:21];
        fifo_din_cmd[62:45] <= 'd0 ;
        fifo_din_cmd[63]    <= 'd1 ;
    end
end

always @(posedge clk) begin
    if(rst)
        fifo_wr_en_cmd <= 'd0 ;
    else if((cur_state == IDLE && nxt_state == CACHE) ||
            (cur_state == CACHE && burst_4k_cnt[1:0] != 'd0 && ddr_op_flag_d2)||
            (cur_state == DELAY && nxt_state== CACHE)
        )
        fifo_wr_en_cmd <= 'd1 ;
    else 
        fifo_wr_en_cmd <= 'd0 ;
end

always @(posedge clk) begin
    fifo_dout_rd_d1 <= fifo_dout_rd ;
    fifo_dout_rd_d2 <= fifo_dout_rd_d1 ;
end

always @(posedge clk) begin
    if(rst)
        fifo_rd_en_rd <= 'd0 ;
    else if(cur_state == IDLE)
        fifo_rd_en_rd <= 'd0 ;
    else if(~fifo_empty_rd)
        fifo_rd_en_rd <= 1'b1 ;
    else 
        fifo_rd_en_rd <= 1'b0 ;
end

//----------------------------------------pil_data output-------------------------------------
always @(posedge clk) begin
    if(rst)
        adc_sli_sop_cha <= 'd0 ;
    else if(~ram_rd_flag_d3 && ram_rd_flag_d2)
        adc_sli_sop_cha <= 'd1 ;
    else 
        adc_sli_sop_cha <= 'd0 ;
end

always @(posedge clk) begin
    if(rst)
        adc_sli_sop_chb <= 'd0 ;
    else if(~ram_rd_flag_d3 && ram_rd_flag_d2)
        adc_sli_sop_chb <= 'd1 ;
    else 
        adc_sli_sop_chb <= 'd0 ;
end

always @(posedge clk) begin
    if(rst)
        adc_sli_eop_cha <= 'd0 ;
    else if(ram_rd_flag_d2 && ~ram_rd_flag_d1)
        adc_sli_eop_cha <= 'd1 ;
    else 
        adc_sli_eop_cha <= 'd0 ;
end

always @(posedge clk) begin
    if(rst)
        adc_sli_eop_chb <= 'd0 ;
    else if(ram_rd_flag_d2 && ~ram_rd_flag_d1)
        adc_sli_eop_chb <= 'd1 ;
    else 
        adc_sli_eop_chb <= 'd0 ;
end

always @(posedge clk) begin
    if(rst)
        adc_sli_valid_cha <= 'd0 ;
    else 
        adc_sli_valid_cha <= ram_rd_flag_d2 ;
end

always @(posedge clk) begin
    if(rst)
        adc_sli_valid_chb <= 'd0 ;
    else 
        adc_sli_valid_chb <= ram_rd_flag_d2 ;
end

always @(posedge clk) begin
    if(rst)
        adc_sli_data_cha <= 'd0;
    else 
        adc_sli_data_cha <= ram_rdata_b[31:16];
end

always @(posedge clk) begin
    if(rst)
        adc_sli_data_chb <= 'd0;
    else 
        adc_sli_data_chb <= ram_rdata_b[15:0];
end
//------------------------------------------------------------

always @(posedge clk) begin
    if(rst)
        delay_cnt <= 'd0 ;
    else if(cur_state == DELAY)
        delay_cnt <= delay_cnt + 1'b1 ;
    else 
        delay_cnt <= 'd0 ;
end


endmodule

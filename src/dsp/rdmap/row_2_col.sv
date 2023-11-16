//module recieve data from rfft
//input  format 4096x32 (2048x32 not used )
//output format 32x2048

module row_2_clo(
    
input            clk                ,
input            rst                ,

input [15:0]     sample_num         ,
input [15:0]     chirp_num          ,

input            fft_r_data_valid   ,
input [31:0]     fft_r_data         ,
input            fft_r_data_sop     ,
input            fft_r_data_eop     ,

output reg       fft_r2d_data_valid ,
output reg[31:0] fft_r2d_data       ,
output reg       fft_r2d_data_sop   ,
output reg       fft_r2d_data_eop   

);

reg [15:0]     fft_r_data_valid_shift ;
reg [63:0]     fft_r_data_shift       ;
reg [15:0]     fft_r_data_sop_shift   ;
reg [15:0]     fft_r_data_eop_shift   ;

always @(posedge clk) begin
if(rst)
    fft_r_data_valid_shift <= 'd0 ;
else 
    fft_r_data_valid_shift <= {fft_r_data_valid_shift[14:0],fft_r_data_valid} ;
end

always @(posedge clk) begin
if(rst)
    fft_r_data_sop_shift <= 'd0 ;
else 
    fft_r_data_sop_shift <= {fft_r_data_sop_shift[14:0],fft_r_data_sop};
end

always @(posedge clk) begin 
if(rst)
    fft_r_data_eop_shift <= 'd0 ;
else 
    fft_r_data_eop_shift <= {fft_r_data_eop_shift[14:0],fft_r_data_eop};
end

always @(posedge clk) begin 
if(rst) begin
    fft_r_data_shift <= 'd0 ;
end
else begin
    fft_r_data_shift <= {fft_r_data_shift[31:0],fft_r_data};
end
end

reg         fft_r_data_valid_div2;
reg [15:0]  fft_r_data_valid_cnt ;

always @(posedge clk) begin
if(rst)
    fft_r_data_valid_cnt <= 'd0 ;
else if(fft_r_data_eop)
    fft_r_data_valid_cnt <= 'd0 ;
else if(fft_r_data_valid &&  fft_r_data_valid_cnt <2048 && chirp_num == 'd32 ) 
    fft_r_data_valid_cnt <= fft_r_data_valid_cnt + 1'b1 ;
else if(fft_r_data_valid &&  fft_r_data_valid_cnt <1024 && chirp_num == 'd64 )
    fft_r_data_valid_cnt <= fft_r_data_valid_cnt + 1'b1 ;
else if(fft_r_data_valid &&  fft_r_data_valid_cnt <512 && chirp_num == 'd128 )
    fft_r_data_valid_cnt <= fft_r_data_valid_cnt + 1'b1 ;
else 
    fft_r_data_valid_cnt <= fft_r_data_valid_cnt ; 
end


always@(posedge clk) begin
if(rst)
    fft_r_data_valid_div2 <= 'd0 ;
else if(fft_r_data_valid && fft_r_data_valid_cnt <2048 && chirp_num == 'd32 )
    fft_r_data_valid_div2 <= ~fft_r_data_valid_div2 ;
else if(fft_r_data_valid && fft_r_data_valid_cnt <1024 && chirp_num == 'd64 )
    fft_r_data_valid_div2 <= ~fft_r_data_valid_div2 ;
else if(fft_r_data_valid && fft_r_data_valid_cnt <512 && chirp_num == 'd128 )
    fft_r_data_valid_div2 <= ~fft_r_data_valid_div2 ;
else
    fft_r_data_valid_div2 <= 'd0 ;
end

reg [15:0]  sample_num_d1 ;
reg [15:0]  sample_num_d2 ;
reg [15:0]  chirp_num_d1  ;
reg [15:0]  chirp_num_d2  ;

always @(posedge clk) begin
if(rst) begin
    sample_num_d1 <= 'd0 ;
    sample_num_d2 <= 'd0 ;
end
else begin
    sample_num_d1 <= sample_num   ;
    sample_num_d2 <= sample_num_d1;
end
end

always @(posedge clk) begin 
if(rst) begin 
    chirp_num_d1 <= 'd0 ;
    chirp_num_d2 <= 'd0 ;
end
else begin
    chirp_num_d1 <= chirp_num   ;
    chirp_num_d2 <= chirp_num_d1;
end
end

//----//----//----//----//----//----//----//---- ram sig //----//----//----//----//----//----//----//----

reg             ram_wen_a = 'd0;
reg [16:0]      ram_waddr_a = 'd0;
wire[63:0]      ram_wdata_a ;
reg [ 2:0]      ram_ren_b = 'd0;
reg [16:0]      ram_raddr_b = 'd0;
reg [16:0]      ram_raddr_b_d0 = 'd0;
reg [16:0]      ram_raddr_b_d1 = 'd0;
wire[63:0]      ram_rdata_b ;

//----//----//----//----//----//----//----//---- write RAM by ROW//----//----//----//----//----//----//----//----
//only write 2048 into ram
reg             pingpang_flag ;
reg   [7:0]     fft_r_data_sop_cnt ;
reg   [7:0]     fft_r_data_eop_cnt ;
reg   [11:0]    pri_addr ;              // every pri data addr support 512 1024 2048
reg   [6 :0]    cpi_cnt ;              // every cpi addr support 32 64 128 

always @(posedge clk) begin
if(rst)
    fft_r_data_sop_cnt <= 'd0 ;
else if(fft_r_data_sop)
    if(fft_r_data_sop_cnt == chirp_num -1 )
        fft_r_data_sop_cnt <= 'd0 ;
    else 
        fft_r_data_sop_cnt <= fft_r_data_sop_cnt + 1'b1 ;
else 
    fft_r_data_sop_cnt <= fft_r_data_sop_cnt ;
end

always @(posedge clk) begin
if(rst)
    fft_r_data_eop_cnt <= 'd0 ;
else if(fft_r_data_eop )
    if(fft_r_data_eop_cnt == chirp_num - 1)
       fft_r_data_eop_cnt <= 'd0 ;
    else
        fft_r_data_eop_cnt <= fft_r_data_eop_cnt + 1'b1 ;
else
    fft_r_data_eop_cnt <= fft_r_data_eop_cnt;

end


always @(posedge clk) begin
if(rst)
    pingpang_flag <= 'd0 ;
else if(fft_r_data_sop_cnt == chirp_num_d2 -1 &&  fft_r_data_sop)
    pingpang_flag <= ~pingpang_flag ;
else 
    pingpang_flag <= pingpang_flag ; 
end

always @(posedge clk) begin 
if(rst)
    pri_addr <= 'd0 ;
else if(fft_r_data_valid_div2)
    pri_addr <= pri_addr + 1'b1 ;
else 
    pri_addr <= pri_addr ;  
end

always @(posedge clk) begin
if(rst)
    cpi_cnt <= 'd0 ;
else if(fft_r_data_eop)
    if(cpi_cnt == chirp_num_d2 - 1)
        cpi_cnt <= 'd0 ;
    else 
       cpi_cnt <= cpi_cnt + 1'b1 ;
else 
    cpi_cnt <= cpi_cnt ;
end

always @(posedge clk) begin 
if(rst)
    ram_waddr_a <= 'd0 ;
else if(chirp_num_d2 == 'd32) 
    if(cpi_cnt [4:1] == 'd0 )
        ram_waddr_a <= {pingpang_flag,cpi_cnt[4:0],pri_addr[9:0]};
    else
        ram_waddr_a <= {1'b0,cpi_cnt[4:0],pri_addr[9:0]};
else if(chirp_num_d2 == 'd64)
    if(cpi_cnt [5:2] == 'd0)
        ram_waddr_a <= {pingpang_flag,cpi_cnt[5:0],pri_addr[8:0]};
    else
        ram_waddr_a <= {1'b0,cpi_cnt[5:0],pri_addr[9:0]};
else if(chirp_num_d2 == 'd128)
    if(cpi_cnt[6:3] == 'd0)
        ram_waddr_a <= {pingpang_flag,cpi_cnt[6:0],pri_addr[7:0]};
    else
        ram_waddr_a <= {1'b0,cpi_cnt[6:0],pri_addr[7:0]};
else 
    ram_waddr_a <= ram_waddr_a ;
end

assign ram_wdata_a = fft_r_data_shift ;

always @(posedge clk) begin
if(rst)
    ram_wen_a <= 'd0 ;
else 
    ram_wen_a <= fft_r_data_valid_div2 ;
end

//----//----//----//----//----//----//----//----  URAM //----//----//----//----//----//----//----//----
xpm_memory_sdpram #(
.ADDR_WIDTH_A             (16             ),
.ADDR_WIDTH_B             (16             ),
.AUTO_SLEEP_TIME          (0              ),
.BYTE_WRITE_WIDTH_A       (64             ),
.CASCADE_HEIGHT           (0              ),
.CLOCKING_MODE            ("common_clock" ),
.ECC_MODE                 ("no_ecc"       ),
.MEMORY_INIT_FILE         ("none"         ),
.MEMORY_INIT_PARAM        ("0"            ),
.MEMORY_OPTIMIZATION      ("true"         ),
.MEMORY_PRIMITIVE         ("ultra"        ),
.MEMORY_SIZE              (2228224        ),//32bit*2048column*(32+2)row
.MESSAGE_CONTROL          (0              ),
.READ_DATA_WIDTH_B        (64             ),
.READ_LATENCY_B           (2              ),
.READ_RESET_VALUE_B       ("0"            ),
.RST_MODE_A               ("SYNC"         ),
.RST_MODE_B               ("SYNC"         ),
.SIM_ASSERT_CHK           (0              ),
.USE_EMBEDDED_CONSTRAINT  (0              ),
.USE_MEM_INIT             (1              ),
.USE_MEM_INIT_MMI         (0              ),
.WAKEUP_TIME              ("disable_sleep"),
.WRITE_DATA_WIDTH_A       (64             ),
.WRITE_MODE_B             ("read_first"   ),
.WRITE_PROTECT            (1              )
)
u_xpm_memory_sdpram_32x2048 (
.clka           (clk          ),
.clkb           (clk          ),
.dbiterrb       (             ),
.sbiterrb       (             ),
.ena            (1'b1         ),
.wea            (ram_wen_a    ),
.addra          (ram_waddr_a  ),
.dina           (ram_wdata_a  ),
.enb            (1'b1         ),
.addrb          (ram_raddr_b  ),
.doutb          (ram_rdata_b  ),
.injectdbiterra (1'b0         ),
.injectsbiterra (1'b0         ),
.regceb         (1'b1         ),
.rstb           (1'b0         ),
.sleep          (1'b0         )
);

//----//----//----//----//----//----//----//---- output //----//----//----//----

//-------------------------------------------------------------------------------

reg         read_en_flag       ;
reg [15:0]  read_en_flag_shift ;
reg         read_en_flag_div2  ;

reg [23:0]  read_en_flag_cnt   ;
reg [23:0]  read_en_flag_cnt_d1;
reg [23:0]  read_en_flag_cnt_d2;
reg [23:0]  read_en_flag_cnt_d3;

always @(posedge clk) begin
if(rst)
    read_en_flag_shift <= 'd0 ;
else 
    read_en_flag_shift <= {read_en_flag_shift[14:0],read_en_flag};
end

always @(posedge clk) begin
if(rst)
    read_en_flag <= 'd0 ;
else if(fft_r_data_eop && fft_r_data_eop_cnt == chirp_num_d2 - 1)
    read_en_flag <= 'd1 ;
else if(read_en_flag_cnt == 32*2048-1 )
    read_en_flag <= 'd0 ;
else 
    read_en_flag <= read_en_flag ;
end

always @(posedge clk) begin
if(rst)
    read_en_flag_div2 <= 'd0 ;
else if(read_en_flag)
    read_en_flag_div2 <= ~read_en_flag_div2 ;
else 
    read_en_flag_div2 <= 'd0;
end

always @(posedge clk) begin
if(rst)
    read_en_flag_cnt <= 'd0 ;
else if(read_en_flag)
    if(read_en_flag_cnt == 32*2048-1)
        read_en_flag_cnt <= 'd0 ;
    else 
        read_en_flag_cnt <= read_en_flag_cnt + 1'b1;
else
    read_en_flag_cnt <= 'd0 ;
end

always @(posedge clk) begin 
if(rst) begin 
    read_en_flag_cnt_d1 <= 'd0 ;
    read_en_flag_cnt_d2 <= 'd0 ;
    read_en_flag_cnt_d3 <= 'd0 ;
end
else begin
    read_en_flag_cnt_d1 <= read_en_flag_cnt ; 
    read_en_flag_cnt_d2 <= read_en_flag_cnt_d1 ;
    read_en_flag_cnt_d3 <= read_en_flag_cnt_d2 ;
end
end


always @(posedge clk) begin 
if(rst)
    ram_raddr_b <= 'd0 ;
else if(chirp_num_d2 == 'd32)
    if(pingpang_flag)
        ram_raddr_b <= {1'b0,read_en_flag_cnt[4:0],read_en_flag_cnt[15:6]} ;
    else
        ram_raddr_b <= (read_en_flag_cnt[4:1] =='d0 )?{1'b1,read_en_flag_cnt[4:0],read_en_flag_cnt[15:6]}:
                        {1'b0,read_en_flag_cnt[4:0],read_en_flag_cnt[15:6]} ;
else if(chirp_num_d2 == 'd64)
    if(pingpang_flag)
        ram_raddr_b <= {1'b0,read_en_flag_cnt[5:0],read_en_flag_cnt[15:7]} ;
    else
        ram_raddr_b <= (read_en_flag_cnt[5:2] =='d0 )?{1'b1,read_en_flag_cnt[5:0],read_en_flag_cnt[15:7]}:
                        {1'b0,read_en_flag_cnt[5:0],read_en_flag_cnt[15:7]};
else if(chirp_num_d2 == 'd128)
    if(pingpang_flag)
        ram_raddr_b <= {1'b0,read_en_flag_cnt[6:0],read_en_flag_cnt[15:8]};
    else
        ram_raddr_b <= (read_en_flag_cnt[6:3] =='d0 )?{1'b1,read_en_flag_cnt[6:0],read_en_flag_cnt[15:8]}:
                        {1'b0,read_en_flag_cnt[6:0],read_en_flag_cnt[15:8]} ;
else
    ram_raddr_b <= ram_raddr_b ;
end

always @(posedge clk) begin
if(rst)
    fft_r2d_data <= 'd0; 
else if(chirp_num_d2 == 'd32)                       // 32  chirp 
    if(read_en_flag_cnt_d3[5])
        fft_r2d_data <= ram_rdata_b[31:0];
    else 
        fft_r2d_data <= ram_rdata_b[63:32];
else if(chirp_num_d2 == 'd64)                       // 64  chirp 
    if(read_en_flag_cnt_d3[6])
        fft_r2d_data <= ram_rdata_b[31:0];
    else 
        fft_r2d_data <= ram_rdata_b[63:32];
else if(chirp_num_d2 == 'd128)                       // 128 chirp 
    if(read_en_flag_cnt_d3[7])
        fft_r2d_data <= ram_rdata_b[31:0];
    else 
        fft_r2d_data <= ram_rdata_b[63:32];
else 
    fft_r2d_data <= fft_r2d_data ;
end

always @(posedge clk) begin
if(rst)
    fft_r2d_data_valid <= 'd0 ;
else 
    fft_r2d_data_valid <= read_en_flag_shift[2];
end

always@(posedge clk) begin
if(rst)
    fft_r2d_data_sop <= 'd0 ;
else if(chirp_num_d2 == 'd32 && read_en_flag_cnt_d1[4:0] == 'd2 )
        fft_r2d_data_sop <= 'd1 ;
else if(chirp_num_d2 == 'd64 && read_en_flag_cnt_d1[5:0] == 'd2 )
        fft_r2d_data_sop <= 'd1 ;
else if(chirp_num_d2 == 'd128&& read_en_flag_cnt_d1[6:0] == 'd2 )
        fft_r2d_data_sop <= 'd1 ;
else 
    fft_r2d_data_sop  <= 'd0 ; 
end

always@(posedge clk) begin
if(rst)
    fft_r2d_data_eop <= 'd0 ;
else if(chirp_num_d2 == 'd32 && read_en_flag_cnt_d3[4:0] == 'd31)
    fft_r2d_data_eop <= 'd1 ;
else if(chirp_num_d2 == 'd64 && read_en_flag_cnt_d3[5:0] == 'd63)
    fft_r2d_data_eop <= 'd1 ;
else if(chirp_num_d2 == 'd128&& read_en_flag_cnt_d3[6:0] == 'd127)
    fft_r2d_data_eop <= 'd1 ;
else 
    fft_r2d_data_eop <= 'd0 ;
end

endmodule
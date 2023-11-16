`timescale 1ns / 1ps

module target_out_jude(

	input  	            clk                 ,
    input  	            rst                 ,
                                            
    input  wire         log2_data_vld_i     ,
    input  wire [15:0]  log2_data_i         ,
                                           
    input  wire         rng_gate_data_vld_i ,
    input  wire [15:0]  rng_gate_data_i     ,
    input  wire [15:0]  rng_casogo_data_i   ,
    
	input  wire [1:0]   hist_bin_i          ,//00:/256, 01:/512, 10:/1024, 11:/2048
	input  wire [2:0]   db_value_i          ,//3db - 7db    
    
    input  wire         hist_busy_i         ,//1:busy,0:idle.   
    input  wire         hist_calc_vld_i     ,
    input  wire [15:0]  hist_calc_data_i    ,
    
    input  wire	[15:0]  cfar_dpl_ram_data   ,
	output reg			cfar_dpl_ram_rden   ,
	output reg  [15:0]	cfar_dpl_ram_addr   ,
                                                                                       
	output 	reg [31:0]	cfar_data_tdata	 = 0,
    output  reg [15:0]  cfar_data_tnum   = 0,
	output  reg [15:0]  cfar_data_count	 = 0,
	output 	reg 		cfar_data_tvalid = 0,
	output 	reg			cfar_data_tlast  = 0

    );
    


parameter       SNR_CFAR_DPL_Dis1      =  16'd1615; // 2~10
parameter       SNR_CFAR_DPL_Dis2      =  16'd1275; // 11~40
parameter       SNR_CFAR_DPL_Dis3      =  16'd1020; // 41~54
parameter       SNR_CFAR_DPL_Dis4      =  16'd935 ; // 55~150
parameter       SNR_CFAR_DPL_Dis5      =  16'd8500; // 151~430
parameter       SNR_CFAR_DPL_Dis6      =  16'd8500; // 430~2048


parameter       SNR_CFAR_GAL_Dis1      =  16'd1190; // 2~10
parameter       SNR_CFAR_GAL_Dis2      =  16'd935 ; // 11~40
parameter       SNR_CFAR_GAL_Dis3      =  16'd935 ; // 41~54
parameter       SNR_CFAR_GAL_Dis4      =  16'd935 ; // 55~150
parameter       SNR_CFAR_GAL_Dis5      =  16'd7650; // 151~430
parameter       SNR_CFAR_GAL_Dis6      =  16'd7650; // 430~2048




reg log2_data_vld_c1 = 0;
reg log2_data_vld_c2 = 0;
reg log2_data_vld_c3 = 0;
reg log2_data_vld_c4 = 0;
reg log2_data_vld_c5 = 0;
reg log2_data_vld_c6 = 0;
reg log2_data_vld_c7 = 0;
reg log2_data_vld_c8 = 0;

reg [15:0] log2_data_c1 = 0;
reg [15:0] log2_data_c2 = 0;
reg [15:0] log2_data_c3 = 0;
reg [15:0] log2_data_c4 = 0;
reg [15:0] log2_data_c5 = 0;
reg [15:0] log2_data_c6 = 0;
reg [15:0] log2_data_c7 = 0;
reg [15:0] log2_data_c8 = 0;
reg [15:0] log2_data_c9 = 0;
reg [15:0] log2_data_c10= 0;

    
reg rng_data_vld_c1 = 0;
reg rng_data_vld_c2 = 0;
reg rng_data_vld_c3 = 0;
reg rng_data_vld_c4 = 0;
reg rng_data_vld_c5 = 0;
reg rng_data_vld_c6 = 0;
reg rng_data_vld_c7 = 0;
reg rng_data_vld_c8 = 0;


reg [15:0] rng_gate_data_c1 = 0;
reg [15:0] rng_gate_data_c2 = 0;
reg [15:0] rng_gate_data_c3 = 0;
reg [15:0] rng_gate_data_c4 = 0;
reg [15:0] rng_gate_data_c5 = 0;
reg [15:0] rng_gate_data_c6 = 0;
reg [15:0] rng_gate_data_c7 = 0;
reg [15:0] rng_gate_data_c8 = 0;


reg [15:0] rng_casogo_data_c1 = 0;
reg [15:0] rng_casogo_data_c2 = 0;
reg [15:0] rng_casogo_data_c3 = 0;
reg [15:0] rng_casogo_data_c4 = 0;
reg [15:0] rng_casogo_data_c5 = 0;
reg [15:0] rng_casogo_data_c6 = 0;
reg [15:0] rng_casogo_data_c7 = 0;
reg [15:0] rng_casogo_data_c8 = 0;
reg [15:0] rng_casogo_data_c9 = 0;


reg rng_peak_bitmap = 0;
reg rng_peak_bitmap_c0 = 0;
reg rng_peak_bitmap_c1 = 0;
reg rng_peak_bitmap_c2 = 0;
reg rng_peak_bitmap_c3 = 0;
reg rng_peak_bitmap_c4 = 0;


always @(posedge clk)
begin
    rng_data_vld_c1     <= rng_gate_data_vld_i;
    rng_data_vld_c2     <= rng_data_vld_c1    ;
    rng_data_vld_c3     <= rng_data_vld_c2    ;
    rng_data_vld_c4     <= rng_data_vld_c3    ;
    rng_data_vld_c5     <= rng_data_vld_c4    ;
    rng_data_vld_c6     <= rng_data_vld_c5    ;
    rng_data_vld_c7     <= rng_data_vld_c6    ;
    rng_data_vld_c8     <= rng_data_vld_c7    ;    
                        
    rng_gate_data_c1    <= rng_gate_data_i    ;
    rng_gate_data_c2    <= rng_gate_data_c1   ;
    rng_gate_data_c3    <= rng_gate_data_c2   ;
    rng_gate_data_c4    <= rng_gate_data_c3   ;
    rng_gate_data_c5    <= rng_gate_data_c4   ;
    rng_gate_data_c6    <= rng_gate_data_c5   ;
    rng_gate_data_c7    <= rng_gate_data_c6   ;
    rng_gate_data_c8    <= rng_gate_data_c7   ;    
    
    rng_casogo_data_c1  <= rng_casogo_data_i  ;
    rng_casogo_data_c2  <= rng_casogo_data_c1 ;
    rng_casogo_data_c3  <= rng_casogo_data_c2 ;
    rng_casogo_data_c4  <= rng_casogo_data_c3 ;
    rng_casogo_data_c5  <= rng_casogo_data_c4 ;
    rng_casogo_data_c6  <= rng_casogo_data_c5 ;
    rng_casogo_data_c7  <= rng_casogo_data_c6 ;
    rng_casogo_data_c8  <= rng_casogo_data_c7 ;
    rng_casogo_data_c9  <= rng_casogo_data_c8 ;
    
    log2_data_vld_c1    <= log2_data_vld_i    ;
    log2_data_vld_c2    <= log2_data_vld_c1   ;
    log2_data_vld_c3    <= log2_data_vld_c2   ;
    log2_data_vld_c4    <= log2_data_vld_c3   ;
    log2_data_vld_c5    <= log2_data_vld_c4   ;
    log2_data_vld_c6    <= log2_data_vld_c5   ;
    log2_data_vld_c7    <= log2_data_vld_c6   ;
    log2_data_vld_c8    <= log2_data_vld_c7   ;    
                        
    log2_data_c1        <= log2_data_i        ;
    log2_data_c2        <= log2_data_c1       ;
    log2_data_c3        <= log2_data_c2       ;
    log2_data_c4        <= log2_data_c3       ;
    log2_data_c5        <= log2_data_c4       ;
    log2_data_c6        <= log2_data_c5       ;
    log2_data_c7        <= log2_data_c6       ;
    log2_data_c8        <= log2_data_c7       ;
    log2_data_c9        <= log2_data_c8       ;    
end

wire rng_data_vld_pos;
assign rng_data_vld_pos = ~rng_data_vld_c2 && rng_data_vld_c1;

wire rng_data_vld_neg;
assign rng_data_vld_neg = ~rng_data_vld_c1 && rng_data_vld_c2;

reg [15:0] cnt_distance_data = 0;     
reg [7:0]  cnt_channel       = 0;  

reg [15:0] cnt_distance_data_c1 = 0;     
reg [7:0]  cnt_channel_c1       = 0;
reg [15:0] cnt_distance_data_c2 = 0;     
reg [7:0]  cnt_channel_c2       = 0;
reg [15:0] cnt_distance_data_c3 = 0;     
reg [7:0]  cnt_channel_c3       = 0;
reg [15:0] cnt_distance_data_c4 = 0;     
reg [7:0]  cnt_channel_c4       = 0;
reg [15:0] cnt_distance_data_c5 = 0;     
reg [7:0]  cnt_channel_c5       = 0;
reg [15:0] cnt_distance_data_c6 = 0;     
reg [7:0]  cnt_channel_c6       = 0;
reg [15:0] cnt_distance_data_c7 = 0;     
reg [7:0]  cnt_channel_c7       = 0;
reg [15:0] cnt_distance_data_c8 = 0;     
reg [7:0]  cnt_channel_c8       = 0;
reg [15:0] cnt_distance_data_c9 = 0;     
reg [7:0]  cnt_channel_c9       = 0;


reg [15:0] cnt_distance_data_o = 0;     
reg [7:0]  cnt_channel_o       = 0;



always @ (posedge clk)
begin
    if(cnt_channel == 'd32 && rng_data_vld_pos == 1'b1)
      begin
          cnt_channel <= 'd1;
      end
    else if(rng_data_vld_pos == 1'b1)
      begin
          cnt_channel <= cnt_channel + 1'b1;
      end
    else
      begin
          cnt_channel <= cnt_channel;
      end
end


always @ (posedge clk)
begin
    if(rng_data_vld_c1 == 1'b1)
      begin
          cnt_distance_data <= cnt_distance_data + 1'b1;
      end
    else
      begin
          cnt_distance_data <= 'd0;
      end
end   

always @ (posedge clk)
begin
    cnt_distance_data_c1 <= cnt_distance_data    ;
    cnt_distance_data_c2 <= cnt_distance_data_c1 ;  
    cnt_distance_data_c3 <= cnt_distance_data_c2 ;
    cnt_distance_data_c4 <= cnt_distance_data_c3 ;
    cnt_distance_data_c5 <= cnt_distance_data_c4 ;
    cnt_distance_data_c6 <= cnt_distance_data_c5 ;
    cnt_distance_data_c7 <= cnt_distance_data_c6 ;
    cnt_distance_data_c8 <= cnt_distance_data_c7 ;
    cnt_distance_data_c9 <= cnt_distance_data_c8 ;    
    
    cnt_distance_data_o  <= cnt_distance_data_c6 ;  

    cnt_channel_c1       <= cnt_channel          ;
    cnt_channel_c2       <= cnt_channel_c1       ;
    cnt_channel_c3       <= cnt_channel_c2       ;
    cnt_channel_c4       <= cnt_channel_c3       ;
    cnt_channel_c5       <= cnt_channel_c4       ;
    cnt_channel_c6       <= cnt_channel_c5       ;
    cnt_channel_c7       <= cnt_channel_c6       ;
    cnt_channel_c8       <= cnt_channel_c7       ;
    cnt_channel_c9       <= cnt_channel_c8       ;
    
    cnt_channel_o        <= cnt_channel_c6       ;
end                                         


reg [15:0] snr_cfar_dpl = 0;
reg [15:0] snr_cfar_gal = 0;

always @ (posedge clk) 
begin		 
    if( cnt_distance_data_c3 == 'd2)
      begin
		  snr_cfar_dpl <= SNR_CFAR_DPL_Dis1;
          snr_cfar_gal <= SNR_CFAR_GAL_Dis1;
      end
    else if(cnt_distance_data_c3 == 'd10)
      begin
		  snr_cfar_dpl <= SNR_CFAR_DPL_Dis2;
          snr_cfar_gal <= SNR_CFAR_GAL_Dis2;
      end
    else if(cnt_distance_data_c3 == 'd70)
      begin
		  snr_cfar_dpl <= SNR_CFAR_DPL_Dis3;
          snr_cfar_gal <= SNR_CFAR_GAL_Dis3;
      end
    else if(cnt_distance_data_c3 == 'd135)
      begin
		  snr_cfar_dpl <= SNR_CFAR_DPL_Dis4;
          snr_cfar_gal <= SNR_CFAR_GAL_Dis4;
      end
    else if(cnt_distance_data_c3 == 'd300)
      begin
		  snr_cfar_dpl <= SNR_CFAR_DPL_Dis5;
          snr_cfar_gal <= SNR_CFAR_GAL_Dis5;
      end
    else if(cnt_distance_data_c3 == 'd430)
      begin
		  snr_cfar_dpl <= SNR_CFAR_DPL_Dis6;
          snr_cfar_gal <= SNR_CFAR_GAL_Dis6;
      end
    else 
      begin
		  snr_cfar_dpl <= snr_cfar_dpl;
          snr_cfar_gal <= snr_cfar_gal;
      end
end 


reg [15:0] hist_threshold = 0;
always @ (posedge clk)
begin
    if(hist_bin_i == 2'b00)
      begin
          hist_threshold <= (db_value_i - 1)*256;
      end
    else if(hist_bin_i == 2'b01)
      begin
          hist_threshold <= (db_value_i - 1)*512;
      end
    else if(hist_bin_i == 2'b10)
      begin
          hist_threshold <= (db_value_i - 1)*1024;
      end
    else
      begin
          hist_threshold <= (db_value_i - 1)*2048;
      end
end


always @ (posedge clk)
begin
    if(cnt_channel == 'd1 || cnt_channel == 'd32)
      begin
          rng_peak_bitmap <= 1'b0;
      end
    else if(log2_data_vld_c1 == 1'b1 && log2_data_vld_c3 == 1'b1)
      begin
          if( log2_data_c2 > log2_data_c1 && log2_data_c2 > log2_data_c3)
            begin
                rng_peak_bitmap <= 1'b1;
            end
          else
            begin
                rng_peak_bitmap <= 1'b0;
            end
      end
    else
      begin
          rng_peak_bitmap <= 1'b0;
      end
end
     

always @ (posedge clk)
begin
    if(log2_data_vld_c3 == 1'b1)
      begin
          rng_peak_bitmap_c0 <= rng_peak_bitmap  ;
      end
    else
      begin
          rng_peak_bitmap_c0 <= 1'b0;
      end
end

always @ (posedge clk)
begin
    rng_peak_bitmap_c1 <= rng_peak_bitmap_c0 ;
    rng_peak_bitmap_c2 <= rng_peak_bitmap_c1 ;
    rng_peak_bitmap_c3 <= rng_peak_bitmap_c2 ;
    rng_peak_bitmap_c4 <= rng_peak_bitmap_c3 ;
end



reg [10:0] ncol = 0;
reg [7:0] nrow = 0;

always @ (posedge clk)
begin
    if(nrow == 'd31 && rng_data_vld_neg == 1'b1)
      begin
          nrow <= 'd0;
      end
    else if(rng_data_vld_neg == 1'b1)
      begin
          nrow <= nrow + 1'b1;
      end
    else
      begin
          nrow <= nrow;
      end
end

always @ (posedge clk)
begin
    if(rng_data_vld_c1 == 1'b1)
      begin
          ncol <= ncol + 1'b1;
      end
    else
      begin
          ncol <= 'd0;
      end
end      
    
    
always @ (posedge clk)
begin
    if(rst )
      begin
          cfar_dpl_ram_addr <= 'd0;
      end
    else if(rng_data_vld_c1 == 1'b1)
      begin
          cfar_dpl_ram_addr <= {ncol,5'b0} + nrow;
      end
    else
      begin
          cfar_dpl_ram_addr <= cfar_dpl_ram_addr;
      end
end
    
    
always @ (posedge clk)
begin
    if(rst )
      begin   
          cfar_dpl_ram_rden <= 1'b0;
      end
    else if(rng_data_vld_c1 == 1'b1)
      begin
          cfar_dpl_ram_rden <= 1'b1;
      end
    else
      begin
          cfar_dpl_ram_rden <= 'd0;
      end
end      
    
    
   

reg hist_rd_en = 0;
reg [15:0] hist_addrb = 0;

always @ (posedge clk)
begin
    if(hist_busy_i == 1'b0)
      begin
          if(rng_data_vld_c1 == 1'b1)
            begin
                hist_addrb <= hist_addrb + 1'b1;            
                hist_rd_en <= 1'b1;
            end
           else
            begin
                hist_rd_en <= 1'b0;
                hist_addrb <= 'd0;
            end
      end
    else
      begin
          hist_rd_en <= 1'b0;
          hist_addrb <= 'd0;
      end
end      
    
    
    
  
reg hist_wr_en = 0;
reg [15:0] hist_data = 0;
reg [15:0] hist_addra = 0;

always @(posedge clk)
begin
    if(hist_busy_i == 1'b1)
      begin
          if(hist_calc_vld_i == 1'b1)
            begin
                hist_wr_en <= 1'b1;
                hist_data  <= hist_calc_data_i;
                hist_addra <= hist_addra + 1'b1;
            end
          else
            begin
                hist_wr_en <= 'b0;
                hist_data  <= 'd0;
                hist_addra <= hist_addra;
            end
      end
    else
      begin
          hist_wr_en <= 'b0;
          hist_data  <= 'd0;
          hist_addra <= 'd0;
      end
end
          

            
wire [15:0] hist_data_dout;           
    
reg [14:0] cfar_dpl_ram_data_c1 = 0;
reg [14:0] cfar_dpl_ram_data_c2 = 0;
reg [14:0] cfar_dpl_ram_data_c3 = 0;
reg [14:0] cfar_dpl_ram_data_c4 = 0;
reg [14:0] cfar_dpl_ram_data_c5 = 0;
reg        dpl_peak_bitmap_c1   = 0;
reg        dpl_peak_bitmap_c2   = 0;
reg        dpl_peak_bitmap_c3   = 0;
reg        dpl_peak_bitmap_c4   = 0;

always @(posedge clk)
begin    
    cfar_dpl_ram_data_c1 <= cfar_dpl_ram_data[14:0];
    cfar_dpl_ram_data_c2 <= cfar_dpl_ram_data_c1   ;
    cfar_dpl_ram_data_c3 <= cfar_dpl_ram_data_c2   ;
    cfar_dpl_ram_data_c4 <= cfar_dpl_ram_data_c3   ;
    cfar_dpl_ram_data_c5 <= cfar_dpl_ram_data_c4   ;
    
    dpl_peak_bitmap_c1   <= cfar_dpl_ram_data[15]  ;
    dpl_peak_bitmap_c2   <= dpl_peak_bitmap_c1     ;
    dpl_peak_bitmap_c3   <= dpl_peak_bitmap_c2     ;
    dpl_peak_bitmap_c4   <= dpl_peak_bitmap_c3     ;
end



wire [16:0] dpl_gate_data;

u16_add_u16 ugate_data_dpl (
  .A  ({1'b0,cfar_dpl_ram_data_c1} ),  // input wire [15 : 0] A
  .B  (snr_cfar_dpl                ),  // input wire [15 : 0] B
  .CLK(clk                         ),  // input wire CLK
  .S  (dpl_gate_data               )   // output wire [16 : 0] S
);


reg [16:0] dpl_gate_data_c1 = 0;
always @(posedge clk)
begin
    dpl_gate_data_c1 <= dpl_gate_data;
end


reg [15:0] hist_data_dout_c1 = 0; 
reg [15:0] hist_data_dout_c2 = 0; 
reg [15:0] hist_data_dout_c3 = 0; 
reg [15:0] hist_data_dout_c4 = 0; 
reg [15:0] hist_data_dout_c5 = 0; 

always @(posedge clk)
begin
    hist_data_dout_c1 <= hist_data_dout   ; 
    hist_data_dout_c2 <= hist_data_dout_c1;
    hist_data_dout_c3 <= hist_data_dout_c2;
    hist_data_dout_c4 <= hist_data_dout_c3;    
    hist_data_dout_c5 <= hist_data_dout_c4;
end
    
    
    
wire [16:0] gal_gate_data;

u16_add_u16 ugate_data_gal (
  .A  (hist_data_dout_c1 ),  // input wire [15 : 0] A
  .B  (snr_cfar_gal      ),  // input wire [15 : 0] B
  .CLK(clk               ),  // input wire CLK
  .S  (gal_gate_data     )   // output wire [16 : 0] S
);                      
    
    
reg [15:0]  hist_data_gal_c1 = 0;   
always @(posedge clk)
begin
    hist_data_gal_c1 <= gal_gate_data - hist_threshold;//sync hist_data_dout_c4
end 
    
  
    
reg  cfar_valid = 0 ;    
always @(posedge clk)
begin
    if(log2_data_vld_c8 == 1'b1)
      begin
          if( (log2_data_c8 > rng_gate_data_c8) && (log2_data_c8 > dpl_gate_data_c1) && (log2_data_c8 > hist_data_gal_c1) &&
              (rng_peak_bitmap_c4 == 1'b1) && (dpl_peak_bitmap_c4 == 1'b1)   )
            begin
                cfar_valid <= 1'b1;
            end
          else
            begin
                cfar_valid <= 1'b0;
            end
      end
    else
      begin
          cfar_valid <= 1'b0;
      end
end
      

reg [15:0] rng_snr_data = 0;  
reg [15:0] dpl_snr_data = 0;
reg [15:0] gal_snr_data = 0;
 
always @ (posedge clk)
begin
    if(log2_data_vld_c8 == 1'b1)
      begin
          rng_snr_data <= log2_data_c8 - rng_casogo_data_c8;
          dpl_snr_data <= log2_data_c8 - cfar_dpl_ram_data_c4;
          gal_snr_data <= (log2_data_c8 + hist_threshold) - hist_data_dout_c4; 
      end
    else
      begin
          rng_snr_data <= 'd0;
          dpl_snr_data <= 'd0;
          gal_snr_data <= 'd0;
      end
end


wire cfar_full ;
wire cfar_empty;
wire [95:0] cfar_data_dout;
reg  [95:0] cfar_data_dout_c1;
reg  [95:0] cfar_data_dout_c2;

reg [95:0]cfar_data_din = 0;
always @ (posedge clk)
begin
    if(cfar_valid == 1'b1) 
	  begin 
		  cfar_data_din	<= {16'd0,gal_snr_data[15:0],dpl_snr_data[15:0],rng_snr_data[15:0],log2_data_c9[15:0],cnt_channel_o[4:0],cnt_distance_data_o[10:0]};				
	  end 
    else;
end	

reg cfar_data_wren = 0;
always @ (posedge clk)
begin
    if(cfar_full == 1'b0)
      begin
          cfar_data_wren <= cfar_valid;
      end
    else
      begin
          cfar_data_wren <= 1'b0;
      end
end    
    
reg [1:0] cfar_data_rden_cnt = 0;      
reg cfar_data_rden_flag = 0;    
always@(posedge clk)
begin
    if(cnt_channel_c9 == 'd32 && cnt_distance_data_c9 == 'd2048 && cfar_empty == 1'b0)
      begin
          cfar_data_rden_flag <= 1'b1;
      end
	else if(cfar_empty == 1'b1 && cfar_data_rden_cnt == 'd3)
      begin
		  cfar_data_rden_flag <= 1'b0;
      end
	else  
      begin
	      cfar_data_rden_flag <= cfar_data_rden_flag;
      end		
end    
    

reg cfar_data_rden_flag_c1 = 0;
always @ (posedge clk)
begin
    cfar_data_rden_flag_c1 <= cfar_data_rden_flag;
end

wire cfar_data_rden_flag_pos;
assign cfar_data_rden_flag_pos = ~cfar_data_rden_flag_c1 && cfar_data_rden_flag;

always @ (posedge clk)
begin
    if(cfar_data_rden_flag_pos == 1)
      begin
          cfar_data_tnum <= {cfar_data_count,1'b0} + cfar_data_count;
      end
    else if(cfar_data_tlast == 1'b1)
      begin
          cfar_data_tnum <= 'd0;
      end
    else;
end


reg cfar_data_tvalid_t = 0;
always @ (posedge clk)   
begin
    cfar_data_tvalid_t <=  cfar_data_rden_flag && cfar_data_rden_flag_c1;
    cfar_data_tvalid   <=  cfar_data_tvalid_t                           ;
    cfar_data_tlast    <= ~cfar_data_rden_flag && cfar_data_rden_flag_c1;
end

      
always @ (posedge clk)  
begin
    if(cfar_data_rden_flag == 1'b1)
      begin
          if(cfar_empty == 1'b0)
            begin
                if( &cfar_data_rden_cnt[1:0] == 1'b1)
                  begin
                      cfar_data_rden_cnt <= 'd1;
                  end
                else
                  begin
                      cfar_data_rden_cnt <= cfar_data_rden_cnt + 1'b1;
                  end
            end
          else
            begin
                cfar_data_rden_cnt <= 'd0;
            end
      end 
    else
      begin
          cfar_data_rden_cnt <= 'd0;
      end
end      
    
reg cfar_data_rden = 0;
always @ (posedge clk) 
begin
    if(cfar_empty == 1'b0)
      begin
          if(cfar_data_rden_cnt == 'd1)
            begin
                cfar_data_rden <= 1'b1;
            end
          else
            begin
                cfar_data_rden <= 1'b0;
            end
      end
    else
      begin
          cfar_data_rden <= 1'b0;
      end
end
    
reg [1:0] cfar_data_rden_cnt_c1 = 0;
reg [1:0] cfar_data_rden_cnt_c2 = 0;
    
always @ (posedge clk)
begin
    cfar_data_rden_cnt_c1 <= cfar_data_rden_cnt   ;
    cfar_data_rden_cnt_c2 <= cfar_data_rden_cnt_c1;
end    
    


always @ (posedge clk) 
begin
    if(cfar_data_tlast == 1'b1)
      begin
		  cfar_data_count <= 16'd0;
      end
	else if(cfar_valid == 1'b1) 
	  begin
          cfar_data_count <= cfar_data_count + 16'd1;				
	  end 
    else;
end


always @ (posedge clk) 
begin
    cfar_data_dout_c1 <= cfar_data_dout    ;
    cfar_data_dout_c2 <= cfar_data_dout_c1 ;
end

always @ (posedge clk) 
begin
    if(cfar_data_tvalid_t == 1'b1)
      begin
          if(cfar_data_rden_cnt_c1 == 'd1)
            begin
                cfar_data_tdata <= cfar_data_dout_c2[31:0];
            end
          else if(cfar_data_rden_cnt_c1 == 'd2)
            begin
                cfar_data_tdata <= cfar_data_dout_c2[63:32];   
            end
          else if(cfar_data_rden_cnt_c1 == 'd3)      
            begin
                cfar_data_tdata <= cfar_data_dout_c2[95:64];   
            end
          else;
      end
    else;      
end


   
    
histogram_blk_mem_gen  uhist_ram (
  .clka  (clk            ),  // input wire clka
  .ena   (1'b1           ),  // input wire ena
  .wea   (hist_wr_en     ),  // input wire [0 : 0] wea
  .addra (hist_addra     ),  // input wire [10 : 0] addra
  .dina  (hist_data      ),  // input wire [15 : 0] dina
  .clkb  (clk            ),  // input wire clkb
  .enb   (hist_rd_en     ),  // input wire enb
  .addrb (hist_addrb     ),  // input wire [10 : 0] addrb
  .doutb (hist_data_dout )   // output wire [15 : 0] doutb
);    
    
    




cfar_data_out_fifo ucfar_data_out_fifo (
  .rst    (1'b0),            // input wire rst
  .wr_clk (clk ),            // input wire wr_clk
  .rd_clk (clk ),            // input wire rd_clk
  .din    (cfar_data_din  ), // input wire [95 : 0] din
  .wr_en  (cfar_data_wren ), // input wire wr_en
  .rd_en  (cfar_data_rden ), // input wire rd_en
  .dout   (cfar_data_dout ), // output wire [95 : 0] dout
  .full   (cfar_full      ), // output wire full
  .empty  (cfar_empty     ), // output wire empty
  .wr_rst_busy( ),           // output wire wr_rst_busy
  .rd_rst_busy( )            // output wire rd_rst_busy
);





  
    
/*  
histogram_fifo uhistogram_fifo (
  .rst        (1'b0            ),  // input wire rst
  .wr_clk     (clk             ),  // input wire wr_clk
  .rd_clk     (clk             ),  // input wire rd_clk
  .din        (hist_data       ),  // input wire [15 : 0] din
  .wr_en      (hist_wr_en      ),  // input wire wr_en
  .rd_en      (hist_rd_en      ),  // input wire rd_en
  .dout       (hist_data_dout  ),  // output wire [15 : 0] dout
  .full       (hist_full       ),  // output wire full
  .empty      (hist_empty      ),  // output wire empty
  .wr_rst_busy( ),                 // output wire wr_rst_busy
  .rd_rst_busy( )                  // output wire rd_rst_busy
);    
*/  
    
    
    
    
    
endmodule    
    
	
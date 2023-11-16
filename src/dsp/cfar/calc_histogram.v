
//////////////////////////////////////////////////////////////////////////////////
// Company: Autel
// Engineer: A22475
// 
// Create Date: 2022/10/25 10:30:28
// Design Name: calc_histogram
// Module Name: calc_histogram
// Project Name: ACUR100
// Target Devices: ZYNQ7000-XC7Z100FFG900-1
// Tool Versions: Vivado 2021.1
// Description:   histogram statistics and threshold calculation
// 
// Dependencies:  
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



`timescale 1 ps / 1 ps

module calc_histogram(

    input  wire        reset_n                 ,//pll_locked
    input  wire        clk_100mhz              ,//100MHz,from PL    
    input  wire        rdm_data_tvalid         ,     
    input  wire [7:0]  rdm_amp_data            ,
	input  wire        rdm_fifo_empty          ,
	
	output reg         hist_result_data_valid  ,
	output reg [5:0]   hist_result_data        ,
	output reg [7:0]   hist_result_index       ,

	output reg         histogram_calc_vld      ,
    output reg [7:0]   histogram_calc_datath   ,
	
	output reg [11:0]  row_num  
	);
	

							 
wire ram_fifo_rden;
assign ram_fifo_rden = rdm_data_tvalid;


reg ram_fifo_rden_dly = 0;
reg rdm_fifo_empty_dly = 0;


always @ (posedge clk_100mhz)
begin
    rdm_fifo_empty_dly <= rdm_fifo_empty;
    ram_fifo_rden_dly <= ram_fifo_rden;
	
	if(reset_n == 1'b0)
	  begin
	      row_num <= 0;
	  end
    else if(ram_fifo_rden_dly == 1'b0 && ram_fifo_rden == 1'b1)
	  begin
	      row_num <= row_num + 1;
	  end
	else if(rdm_fifo_empty_dly == 1 && rdm_fifo_empty == 0)
	  begin
	      row_num <= 0;
	  end
	else
	  begin
	      row_num <= row_num;
	  end
end




reg   [7:0]    rd_addr_porta             ; 
reg            rd_en_porta               ;
reg            rd_we_porta               ;
wire  [5:0]    rd_dout_porta             ;  
reg   [5:0]    rd_din_porta              ;  
										  
reg   [7:0]    wr_addr_portb  = 0        ;
reg            wr_we_portb    = 0        ;
reg   [5:0]    wr_din_portb   = 0        ;  
wire  [5:0]    wr_dout_portb             ;  

reg            write_data_into_ram_valid ;
reg   [7:0]    rd_addr_cnt = 0           ;
reg            rd_statistics_start = 0   ;


reg [7:0] rdm_data_pipe0 = 0;
reg [7:0] rdm_data_pipe0_tmp = 0;

always @ (posedge clk_100mhz)
begin
	rdm_data_pipe0_tmp <= rdm_data_pipe0;

    if(ram_fifo_rden == 1'b1)
	  begin
          rdm_data_pipe0 <= rdm_amp_data;
	  end
	else
	  begin
	      rdm_data_pipe0 <= 'd0;
	  end
end


reg rdm_data_valid_pipe0 = 0;

always @ (posedge clk_100mhz)
begin
    rdm_data_valid_pipe0 <= ram_fifo_rden;
end


reg   rdm_data_valid_pipe0_tmp1 = 0;

always @ (posedge clk_100mhz)
begin
    if(reset_n == 1'b0)
	  begin
	      rdm_data_valid_pipe0_tmp1 <= 1'b0;
	  end
	else
	  begin
	      if(rdm_data_valid_pipe0 == 1'b1)
		    begin
			    if(rdm_data_valid_pipe0_tmp1 == 1'b0)
				  begin
				      rdm_data_valid_pipe0_tmp1 <= 1'b1;
				  end
			    else
				  begin
				      if(rdm_data_pipe0_tmp == rdm_data_pipe0)
					    begin
						    rdm_data_valid_pipe0_tmp1 <= 1'b0;
					    end
					  else
					    begin
						    rdm_data_valid_pipe0_tmp1 <= 1'b1;
						end
				  end
			end
		  else
		    begin
			    rdm_data_valid_pipe0_tmp1 <= 1'b0;
			end
	  end
end
					

reg [1:0] rdm_data_cnt_tmp = 0;

always @ (posedge clk_100mhz)
begin
    if(reset_n == 1'b0)
	  begin
	      rdm_data_cnt_tmp <= 2'd1;
	  end
	else
	  begin
	      if( (rdm_data_valid_pipe0 == 1'b1) && (rdm_data_valid_pipe0_tmp1 == 1'b1) && (rdm_data_pipe0_tmp == rdm_data_pipe0) )
		    begin
			    rdm_data_cnt_tmp <= 2'd2;
			end
		  else
		    begin
			    rdm_data_cnt_tmp <= 2'd1;
		    end
	  end
end
			


wire        data_statistics_valid         ;
wire [7:0]  data_new_statistics           ;
wire [1:0]  data_statistics_cnt_type      ;


assign   data_statistics_valid    =   rdm_data_valid_pipe0_tmp1 ;
assign   data_new_statistics      =   rdm_data_pipe0_tmp[7:0]   ;  
assign   data_statistics_cnt_type =   rdm_data_cnt_tmp          ; 


reg  [1:0]  data_statistics_cnt_type_dly  = 2'd1;

always @ (posedge clk_100mhz)
begin
    if(reset_n == 1'b0)
	  begin
	      data_statistics_cnt_type_dly <= 2'd1;
	  end
	else
	  begin
          data_statistics_cnt_type_dly  <=  data_statistics_cnt_type  ;   
	  end
end



always @(posedge clk_100mhz)
begin
    if(reset_n == 1'b0)
	  begin
	      rd_addr_porta   <=  'd0  ;
		  rd_en_porta     <=  1'b0 ;
		  rd_we_porta     <=  1'b0 ;    
		  rd_din_porta    <=  'd0  ;
		  
		  write_data_into_ram_valid <=  1'b0; 
      end
    else if(data_statistics_valid == 1'b1)  
	  begin
	      rd_addr_porta   <=  data_new_statistics[7:0] ; 
		  rd_en_porta     <=  1'b1;
		  rd_we_porta     <=  1'b0;
		  rd_din_porta    <=  'd0 ;
		  
		  write_data_into_ram_valid <=  1'b1;
      end
	else if(rd_statistics_start == 1'b1)  
	  begin
	      rd_addr_porta   <=  rd_addr_cnt[7:0];
		  rd_en_porta     <=  1'b1;
		  rd_we_porta     <=  1'b1; 
		  rd_din_porta    <=  'd0 ;			 
		  
		  write_data_into_ram_valid <=  1'b0;			 
	  end	 
    else 
	  begin
	      rd_addr_porta   <=  'd0 ;
		  rd_en_porta     <=  1'b0;
		  rd_we_porta     <=  1'b0;	
		  rd_din_porta    <=  'd0 ;				 
		  
		  write_data_into_ram_valid <=  1'b0;			 	   
		 end
end
  
  
reg         sum_cnt_isvalid = 0; 
reg  [7:0]  sum_cnt = 0; 
reg         sum_addr_valid = 0 ;
wire [5:0]  sum_rd_data        ;  
                                  
always @(posedge clk_100mhz)
begin
    sum_addr_valid      <=  rd_we_porta    ;
	sum_cnt_isvalid     <=  sum_addr_valid ;
end

assign sum_rd_data  =  rd_dout_porta;


reg   write_data_into_ram_valid_dly;
reg  [7:0] write_addr_dly;


always @(posedge clk_100mhz)   
begin
    write_data_into_ram_valid_dly <=  write_data_into_ram_valid;
	write_addr_dly                <=  rd_addr_porta;
end
   
  
always @(*)   
begin
    wr_addr_portb  <=  write_addr_dly;
	wr_we_portb    <=  write_data_into_ram_valid_dly; 
	wr_din_portb   <=  rd_dout_porta  +  data_statistics_cnt_type_dly;
end  



////////////////     

assign rdm_valid_in_ndg = ( rdm_data_valid_pipe0 && ~ram_fifo_rden ) ?  1'b1 :  1'b0  ;

reg [7:0]  rdm_valid_in_ndg_pipe = 0;

always @(posedge clk_100mhz)  
begin
    rdm_valid_in_ndg_pipe   <=  {rdm_valid_in_ndg_pipe[6:0],rdm_valid_in_ndg}  ;
end  

always @(posedge clk_100mhz)
begin
    if(rdm_valid_in_ndg_pipe[7] == 1'b1)//each line statistics end 
	   rd_statistics_start  <=  1'b1;
	else if(rd_addr_cnt == 8'd32)  
	   rd_statistics_start  <=  1'b0;
    else ;	   
end  





  
always @(posedge clk_100mhz)
begin
    if(reset_n == 1'b0)
	   rd_addr_cnt  <=  'd0  ;
	else if(rd_statistics_start == 1'b1)
	   rd_addr_cnt  <=   rd_addr_cnt + 'd1 ;
	else
	   rd_addr_cnt  <=  'd0  ;	
 end 




always @(posedge clk_100mhz)
begin
    if(reset_n == 1'b0)
	  begin
	      sum_cnt <= 'd0 ;
	  end	  
    else if(sum_addr_valid == 1'b1)
	  begin
	      sum_cnt <=  sum_cnt + sum_rd_data  ;
	  end
    else
	  begin
          sum_cnt <= 'd0  ;
      end	 	 
end


//always@(posedge clk_100mhz)
//begin
//    if(reset_n == 1'b0)
//	  begin
//	      histogram_calc_vld     <= 'd0;
//          histogram_calc_datath  <= 'd0;
//	  end
//	else
//	  begin
//	      //histogram_calc_vld     <= ram_fifo_rden    ;
//          //histogram_calc_datath  <= {8'd0,rdm_dout } ;
//		  
//		  histogram_calc_vld    <= ( (sum_addr_valid == 1'b1) && (write_addr_dly >= 1) );
//		  if((sum_addr_valid == 1'b1) && (write_addr_dly >= 1) )
//		    begin
//		        histogram_calc_datath <= sum_rd_data;
//		    end
//		  else
//		    begin
//			    histogram_calc_datath <= 'd0;
//			end
//	  end
//end


reg [7:0] histogram_calc_datat_index = 0;

always@(posedge clk_100mhz)
begin
    if((sum_addr_valid == 1'b1) && (write_addr_dly >= 1) )
	  begin
          histogram_calc_datat_index <= write_addr_dly;
	  end
	else
	  begin
	      histogram_calc_datat_index <= 'd0;
	  end
end


always @ (posedge clk_100mhz)
begin
    if(reset_n == 1'b0)
	  begin
	      hist_result_data_valid <= 1'b0 ;
          hist_result_data       <=  'd0 ;
          hist_result_index      <=  'd0 ;
	  end
    else if((sum_addr_valid == 1'b1) && (write_addr_dly >= 1) )
	  begin
	      hist_result_data_valid <= 1'b1           ;
		  hist_result_data       <= sum_rd_data    ;
		  hist_result_index      <= write_addr_dly ;
	  end
	else
	  begin
	      hist_result_data_valid <= 1'b0 ;
          hist_result_data       <=  'd0 ;
          hist_result_index      <=  'd0 ;
	  end
end


reg  [5:0]  hist_perow_max_data = 0;
reg  [7:0]  hist_perow_max_ddata_index = 0;

always @ (posedge clk_100mhz)
begin
    if(ram_fifo_rden_dly == 1'b0 && ram_fifo_rden == 1'b1)
      begin
	      hist_perow_max_data <= 'd0;
          hist_perow_max_ddata_index <= 'd0;
	  end
    else if(hist_result_data_valid == 1'b1)
	  begin
	      if(hist_perow_max_data < hist_result_data)
		    begin
			    hist_perow_max_data <= hist_result_data;
				hist_perow_max_ddata_index <= hist_result_index;
			end
		  else
		    begin
			    hist_perow_max_data <= hist_perow_max_data;
				hist_perow_max_ddata_index <= hist_perow_max_ddata_index;
			end
	  end
	else
	  begin
	      hist_perow_max_data <= hist_perow_max_data;
		  hist_perow_max_ddata_index <= hist_perow_max_ddata_index;
	  end
end


reg hist_result_data_valid_r1 = 0;
reg hist_result_data_valid_r2 = 0;
reg hist_result_data_valid_r3 = 0;

always @ (posedge clk_100mhz)
begin
    hist_result_data_valid_r1 <= hist_result_data_valid   ;
	hist_result_data_valid_r2 <= hist_result_data_valid_r1;
	hist_result_data_valid_r3 <= hist_result_data_valid_r2;
end

wire hist_result_data_valid_ne;
assign hist_result_data_valid_ne = ~hist_result_data_valid_r2 && hist_result_data_valid_r3;


//always@(posedge clk_100mhz)
//begin
//    if(reset_n == 1'b0)
//	  begin
//	      histogram_calc_vld     <= 'd0;
//          histogram_calc_datath  <= 'd0;
//	  end
//	else
//	  begin
//	      if(hist_result_data_valid_ne == 1'b1)
//		    begin
//			    histogram_calc_vld <= 1'b1;
//		        histogram_calc_datath <= hist_perow_max_ddata_index;
//			end
//		  else
//		    begin
//			    histogram_calc_vld <= 1'b0;
//				histogram_calc_datath <= histogram_calc_datath;
//			end
//	  end
//end



always@(posedge clk_100mhz)
begin
    if(reset_n == 1'b0)
	  begin
	      histogram_calc_vld     <= 'd0;
          histogram_calc_datath  <= 'd0;
	  end
	else
	  begin
	      if(hist_result_data_valid_ne == 1'b1)
		    begin
			    histogram_calc_vld <= 1'b1;
		        histogram_calc_datath <= hist_perow_max_ddata_index[7:0]; 
            end
		  else
		    begin
			    histogram_calc_vld <= 1'b0;
				histogram_calc_datath <= histogram_calc_datath;
			end
	  end
end




/////////
wire [0 : 0]  wea    ;     
wire [7 : 0]  addra  ;
wire [5 : 0]  dina   ;  
wire [5 : 0]  douta  ;  

wire [0 : 0]  web    ;
wire [7 : 0]  addrb  ;
wire [5 : 0]  dinb   ;  
wire [5 : 0]  doutb  ;  

// porta
assign  addra = rd_addr_porta ;
assign  wea   = rd_we_porta   ;
assign  dina  = rd_din_porta  ;
							  

assign rd_dout_porta = douta  ;         

  
// portb
assign addrb         = wr_addr_portb ;
assign web           = wr_we_portb   ;
assign dinb          = wr_din_portb  ;
assign wr_dout_portb = doutb         ;




rdmdata_histogram_statistics_bram_w6xd64 U_rdmdata_histogram_statistics_bram_w6xd256 (
        .clka (clk_100mhz),    // input wire clka
        .ena  (1'b1      ),    // input wire ena
        .wea  (wea       ),    // input wire [0 : 0] wea
        .addra(addra     ),    // input wire [7 : 0] addra
        .dina (dina      ),    // input wire [5 : 0] dina
        .douta(douta     ),    // output wire [5 : 0] douta
        .clkb (clk_100mhz),    // input wire clkb
        .enb  (1'b1      ),    // input wire enb
        .web  (web       ),    // input wire [0 : 0] web
        .addrb(addrb     ),    // input wire [7 : 0] addrb
        .dinb (dinb      ),    // input wire [5 : 0] dinb
        .doutb(doutb     )     // output wire [5 : 0] doutb
);














endmodule





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

module calc_histogram_top(

    input wire        reset_n                  ,//pll_locked
    input wire        clk_100mhz               ,//100MHz,from PL    
    input wire        rdm_m_axis_data_tvalid   ,
    input wire [31:0] rdm_amp_data             ,
	input wire        rdm_m_axis_data_tlast    ,
	input wire [1:0]  histogram_bin_select     ,//00:/256, 01:/512, 10:/1024, 11:/2048
	input wire [2:0]  threshold_db_value_select,//3db - 7db
	
    output reg        hist_busy_o              ,//1:busy,0:idle.
	output wire       hist_result_valid_o      ,//histogram statistics output
	output wire [5:0] hist_result_data_o       ,//quantity
											   
	output reg        histogram_calc_vld       ,//threshold calculation output
    output reg [15:0] histogram_calc_datath    
	
	);
	
	

	
reg [3:0] state = 0;
reg ram_fifo_rden_odd = 0;
reg ram_fifo_rden_even = 0;
reg [3:0] rd_data_delay = 0;
reg [7:0] rd_data_count = 0;

wire [7:0] rdm_dout;
wire rdm_fifo_full;
wire rdm_fifo_empty;
reg  rdm_fifo_empty_r1 = 0;
wire [14:0] data_count;//16384
   
always@(posedge clk_100mhz)
begin
    if(reset_n == 1'b0)
	  begin
	      state <= 0;
		  ram_fifo_rden_odd <= 0;
		  ram_fifo_rden_even <= 0;
          rd_data_count <= 0;
          rd_data_delay <= 0;
	  end
	else
	  begin
          case(state)
		      0:begin
			        if(rdm_fifo_empty == 1'b0 && data_count >= 'd10) 
					  begin
                          state <= 1;
                      end
                    else 
	      			  begin
                          state <= 0;
                      end
                 end
			   1:begin
                     if(rd_data_delay == 8'd8) 
                       begin
                           rd_data_delay <= 8'd0;
						   state <= 2;
					   end
					 else
					   begin
					       rd_data_delay <= rd_data_delay + 1'b1;
				           state <= 1;
					   end
				 end

               2:begin
                     if(rd_data_count == 8'd32) 
	      			   begin
	      			       ram_fifo_rden_odd <= 1'b0;
						   ram_fifo_rden_even <= 1'b0;
                           rd_data_count <= 8'd0;
	      				   state <= 3;
                       end
                     else 
	      			   begin
	      			       ram_fifo_rden_odd <= 1'b1;
						   ram_fifo_rden_even <= 1'b0;
                           rd_data_count <= rd_data_count + 1'b1;                   
                           state <= 2;
                       end
                  end       
               3:begin
                     if(rd_data_delay == 8'd8) 
	      			    begin
                            rd_data_delay <= 8'd0;
                            state <= 4;
                        end
                     else 
	      			   begin
                           rd_data_delay <= rd_data_delay + 1'b1;
                           state <= 3;
                       end
                 end
			   4:begin
			         if(rd_data_count == 8'd32) 
					   begin
					       ram_fifo_rden_odd <= 1'b0;
						   ram_fifo_rden_even <= 1'b0;
					       rd_data_count <= 8'd0;
						   state <= 0;
					   end
					  else
					    begin
						    ram_fifo_rden_odd <= 1'b0;
							ram_fifo_rden_even <= 1'b1;
							rd_data_count <= rd_data_count + 1'b1;
							state <= 4;
					    end
				 end
 
         default:begin state <= 0; end
          endcase  
      end		  
end


reg rdm_wr_en = 0;
reg [7:0] rdm_din= 0;


reg [1:0] histogram_bin_select_dly = 0;

always @ (posedge clk_100mhz)
begin
    if(reset_n == 1'b0)
	  begin
	      histogram_bin_select_dly <= 'b0;
	  end
    else if(rdm_m_axis_data_tlast == 1'b1)
	  begin
          histogram_bin_select_dly <= histogram_bin_select;
	  end
	else
	  begin
	      histogram_bin_select_dly <= histogram_bin_select_dly;
	  end
end


reg [2:0] db_value_dly = 0;

always @ (posedge clk_100mhz)
begin
    if(reset_n == 1'b0)
	  begin
	      db_value_dly <= 'b0;
	  end
	else if(rdm_m_axis_data_tlast == 1'b1)
	  begin
	      if(threshold_db_value_select <= 3'b11)
		    begin
			    db_value_dly <= 'd2;//'d3
		    end
		  else
		    begin
	            db_value_dly <= threshold_db_value_select - 1;
			end
	  end
	else
	  begin
	      db_value_dly <= db_value_dly;
	  end
end



always@(posedge clk_100mhz)
begin
    rdm_wr_en <= rdm_m_axis_data_tvalid;
	//rdm_din <= rdm_amp_data[15:8] + 1;//rdm_amp_data[7:0];

    if(histogram_bin_select_dly == 2'b00)
	  begin
          rdm_din   <= rdm_amp_data[15:8] + 1'b1 ;//divider 256, add 1
	  end
	else if(histogram_bin_select_dly == 2'b01)
	  begin
	      rdm_din   <= rdm_amp_data[16:9] + 1'b1 ;//divider 512, add 1
	  end
	else if(histogram_bin_select_dly == 2'b10)
	  begin
	      rdm_din   <= rdm_amp_data[17:10] + 1'b1 ;//divider 1024, add 1
	  end
	else
	  begin
	      rdm_din   <= rdm_amp_data[18:11] + 1'b1 ;//divider 2048, add 1
	  end  
    
end


reg ram_fifo_rden = 0;

always@(posedge clk_100mhz)
begin
    ram_fifo_rden <= ram_fifo_rden_odd || ram_fifo_rden_even;
end

reg ram_fifo_rden_odd_dly = 0;
reg rdm_data_valid_odd = 0;
reg [7:0] rdm_data_odd = 0;

always@(posedge clk_100mhz)
begin
    ram_fifo_rden_odd_dly <= ram_fifo_rden_odd  ;
	
	if(ram_fifo_rden_odd_dly == 1'b1)
	  begin
	      rdm_data_valid_odd <= 1'b1;
		  rdm_data_odd <= rdm_dout[7:0];
	  end
	else
	  begin
	      rdm_data_valid_odd <= 1'b0;
		  rdm_data_odd <= 'd0;
	  end
end


reg ram_fifo_rden_even_dly = 0;
reg rdm_data_valid_even = 0;
reg [7:0] rdm_data_even = 0;

always@(posedge clk_100mhz)
begin
    ram_fifo_rden_even_dly <= ram_fifo_rden_even  ;
	
	if(ram_fifo_rden_even_dly == 1'b1)
	  begin
	      rdm_data_valid_even <= 1'b1;
		  rdm_data_even <= rdm_dout[7:0];
	  end
	else
	  begin
	      rdm_data_valid_even <= 1'b0;
		  rdm_data_even <= 'd0;
	  end
end




wire         hist_result_data_valid_odd;
wire [5:0]   hist_result_data_odd;      
wire [7:0]   hist_result_index_odd;     

wire histogram_calc_vld_odd;
wire [7:0] histogram_calc_datath_odd;

wire [11:0] row_num_odd;

calc_histogram U_calc_histogram_odd(

      .reset_n                ( reset_n                     ),//pll_locked
      .clk_100mhz             ( clk_100mhz                  ),//100MHz,from PL    
      .rdm_data_tvalid        ( rdm_data_valid_odd          ),     
      .rdm_amp_data           ( rdm_data_odd                ),
	  .rdm_fifo_empty         ( rdm_fifo_empty              ),
								 						   
	  .hist_result_data_valid ( hist_result_data_valid_odd  ),
	  .hist_result_data       ( hist_result_data_odd        ),
	  .hist_result_index      ( hist_result_index_odd       ),
							  
	  .histogram_calc_vld     ( histogram_calc_vld_odd      ),
      .histogram_calc_datath  ( histogram_calc_datath_odd   ),
	  .row_num                ( row_num_odd                 )
	  
);




wire         hist_result_data_valid_even;
wire [5:0]   hist_result_data_even;      
wire [7:0]   hist_result_index_even;     

wire histogram_calc_vld_even;
wire [7:0] histogram_calc_datath_even;

wire [11:0] row_num_even;


calc_histogram U_calc_histogram_even(
													         
      .reset_n                ( reset_n                      ),//pll_locked
      .clk_100mhz             ( clk_100mhz                   ),//100MHz,from PL    
      .rdm_data_tvalid        ( rdm_data_valid_even          ),     
      .rdm_amp_data           ( rdm_data_even                ),
	  .rdm_fifo_empty         ( rdm_fifo_empty               ),
							  
	  .hist_result_data_valid ( hist_result_data_valid_even  ),
	  .hist_result_data       ( hist_result_data_even        ),
	  .hist_result_index      ( hist_result_index_even       ),	  
							  
	  .histogram_calc_vld     ( histogram_calc_vld_even      ),
      .histogram_calc_datath  ( histogram_calc_datath_even   ),
	  .row_num                ( row_num_even                 )
	  
);



reg         hist_result_data_valid = 0; 
reg [5:0]   hist_result_data = 0;       
reg [7:0]   hist_result_index = 0;

always@(posedge clk_100mhz)    
begin
    if(hist_result_data_valid_odd == 1'b1)
	  begin
	      hist_result_data_valid <= 1'b1                 ;
		  hist_result_data       <= hist_result_data_odd ;
		  hist_result_index      <= hist_result_index_odd;
	  end
	else if(hist_result_data_valid_even == 1'b1)
	  begin
	      hist_result_data_valid <= 1'b1;
		  hist_result_data       <= hist_result_data_even;
		  hist_result_index      <= hist_result_index_even;
	  end
	else
	  begin
	      hist_result_data_valid <= 1'b0;
		  hist_result_data       <= 6'd0;
		  hist_result_index      <= 8'd0;
	  end
end


//always@(posedge clk_100mhz) 
//begin
//    if(reset_n == 1'b0)
//	  begin
//	      histogram_calc_vld    <= 1'b0;
//		  histogram_calc_datath <=  'd0;
//	  end
//	else if(histogram_calc_vld_odd == 1'b1)
//	  begin
//	      histogram_calc_vld    <= 1'b1;
//          histogram_calc_datath <= {8'b0,histogram_calc_datath_odd[7:0]};
//	  end
//	else if(histogram_calc_vld_even == 1'b1)
//	  begin
//	      histogram_calc_vld    <= 1'b1;
//          histogram_calc_datath <= {8'b0,histogram_calc_datath_even[7:0]};
//      end
//	else
//	  begin
//	      histogram_calc_vld    <= 1'b0;
//		  histogram_calc_datath <= histogram_calc_datath;
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
	      if(histogram_calc_vld_odd == 1'b1)
		    begin
			    histogram_calc_vld <= 1'b1;
				
				if(histogram_bin_select_dly == 2'b00)
				  begin
		              histogram_calc_datath <= {histogram_calc_datath_odd[7:0],8'b0} + {db_value_dly,8'b0};   //(db_value_dly - 'd1)*256;  
				  end
				else if(histogram_bin_select_dly == 2'b01)
				  begin
				      histogram_calc_datath <= {histogram_calc_datath_odd[6:0],9'b0} + {db_value_dly,9'b0};   //(db_value_dly - 'd1)*512; 
				  end
				else if(histogram_bin_select_dly == 2'b10)
				  begin
				      histogram_calc_datath <= {histogram_calc_datath_odd[5:0],10'b0} + {db_value_dly,10'b0}; //(db_value_dly - 'd1)*1024; 
				  end
				else
				  begin
				      histogram_calc_datath <= {histogram_calc_datath_odd[4:0],11'b0} + {db_value_dly,11'b0}; //(db_value_dly - 'd1)*2048; 
				  end				      
			end
		  else if(histogram_calc_vld_even == 1'b1)
		     begin
			    histogram_calc_vld <= 1'b1;
				
				if(histogram_bin_select_dly == 2'b00)
				  begin
		              histogram_calc_datath <= {histogram_calc_datath_even[7:0],8'b0} + {db_value_dly,8'b0};   //(db_value_dly - 'd1)*256;  
				  end                                                                   
				else if(histogram_bin_select_dly == 2'b01)                              
				  begin                                                                 
				      histogram_calc_datath <= {histogram_calc_datath_even[6:0],9'b0} + {db_value_dly,9'b0};   //(db_value_dly - 'd1)*512; 
				  end                                                                   
				else if(histogram_bin_select_dly == 2'b10)                              
				  begin                                                                 
				      histogram_calc_datath <= {histogram_calc_datath_even[5:0],10'b0} + {db_value_dly,10'b0}; //(db_value_dly - 'd1)*1024; 
				  end                                                                   
				else                                                                    
				  begin                                                                 
				      histogram_calc_datath <= {histogram_calc_datath_even[4:0],11'b0} + {db_value_dly,11'b0}; //(db_value_dly - 'd1)*2048; 
				  end			  
			 end
		  else
		    begin
			    histogram_calc_vld <= 1'b0;
				histogram_calc_datath <= histogram_calc_datath;
			end
	  end
end







reg [11:0] row_num = 0;
reg hist_valid_r1 = 0;

always@ (posedge clk_100mhz) 
begin
    hist_valid_r1 <= hist_result_data_valid;
	rdm_fifo_empty_r1 <= rdm_fifo_empty;
end

always@ (posedge clk_100mhz) 
begin
	if(reset_n == 1'b0)
	  begin
	      row_num <= 0;
	  end
    else if(hist_valid_r1 == 1'b0 && hist_result_data_valid == 1'b1)
	  begin
	      row_num <= row_num + 1;
	  end
	else if(rdm_fifo_empty_r1 == 1 && rdm_fifo_empty == 0)
	  begin
	      row_num <= 0;
	  end
	else
	  begin
	      row_num <= row_num;
	  end
end


reg [11:0] threshold_num = 0;

always@ (posedge clk_100mhz)
begin
    if(reset_n == 1'b0)
	  begin
	      threshold_num <= 'd0;
	  end
	else if(histogram_calc_vld == 1'b1)
	  begin
	      threshold_num <= threshold_num + 1'b1;
	  end
	else if(rdm_fifo_empty_r1 == 1 && rdm_fifo_empty == 0)
	  begin
	      threshold_num <= 0;
	  end
	else
	  begin
	      threshold_num <= threshold_num;
	  end
end


always @ (posedge clk_100mhz)
begin
    if(reset_n == 1'b0)
      begin
          hist_busy_o <= 1'b0;
      end
    else if(threshold_num >= 'd2048)
      begin
          hist_busy_o <= 1'b0;
      end
    else
      begin
          hist_busy_o <= 1'b1;
      end
end


assign hist_result_valid_o = hist_result_data_valid ; 
assign hist_result_data_o  = hist_result_data       ;







xilinx_afifo_generator_w32xd65536 U_xilinx_afifo_generator_w32xd65536 (
  .clk       (clk_100mhz     ),            // input wire clk
  .srst      (1'b0           ),            // input wire srst
  .din       (rdm_din        ),            // input wire [7 : 0] din
  .wr_en     (rdm_wr_en      ),            // input wire wr_en
  .rd_en     (ram_fifo_rden  ),            // input wire rd_en
  .dout      (rdm_dout       ),            // output wire [7 : 0] dout
  .full      (rdm_fifo_full  ),            // output wire full
  .empty     (rdm_fifo_empty ),            // output wire empty
  .data_count(data_count     )             // output wire [14 : 0] data_count
);

// output wire [16 : 0] data_count //65536
// output wire [14 : 0] data_count //16384










	
	
	
	
endmodule	




`timescale 1 ps / 1 ps
module lmx2492_write_data_buffer(

         input wire         sys_rst              ,//pll_locked
		 input wire         write_clk            ,
		 input wire         write_data_en        ,
		 input wire [23:0]  write_data_in        ,//bit23,0:write,1:read
										         
		 input wire         read_clk             ,
		 input wire         read_data_en         ,
		 
         output wire        adsdata_fifo_empty   ,
         output wire [24:0] read_data_o  	 

);


reg write_data_en_r1 = 0;
reg write_data_en_r2 = 0;
 reg write_data_wren  = 0;
	
always @ (posedge write_clk)
begin
    write_data_en_r1 <= write_data_en    ; 
    write_data_en_r2 <= write_data_en_r1 ;
    write_data_wren  <= write_data_en_r2 ;
end


 reg [24:0] write_data_ads = 0;
always @ (posedge write_clk)
begin
    if(write_data_en_r2 == 1'b1)
	  begin
	      if(write_data_in[23] == 1'b0)
		    begin
	            write_data_ads[24] <= 1'b1;//spi_config
		        write_data_ads[23] <= 1'b0;//0:write,1:read
		        
		        write_data_ads[22:0] <= write_data_in[22:0];
		    end
		  else
		    begin
	            write_data_ads[24] <= 1'b1;//spi_config
		        write_data_ads[23] <= 1'b1;//0:write,1:read
		        
		        write_data_ads[22:0] <= write_data_in[22:0];
            end	
	  end
	else
	  begin
	      write_data_ads[24] <= 1'b0;//spi_config
		  write_data_ads[23] <= 1'b0;//0:write,1:read
		  
		  write_data_ads[22:0] <= write_data_in[22:0];
	  end	  
end		  

wire full                   ;
wire almost_full            ;
wire empty                  ;
wire almost_empty           ;
wire [6 : 0] rd_data_count  ;
wire [6 : 0] wr_data_count  ;


xfifo_async_w25d128_d0 xfifo_async_w25d128_d0 (
  .rst           (1'b0                ),                // input wire rst
  .wr_clk        (write_clk           ),                // input wire wr_clk
  .rd_clk        (read_clk            ),                // input wire rd_clk
  .din           (write_data_ads      ),                // input wire [24 : 0] din
  .wr_en         (write_data_wren     ),                // input wire wr_en
  .rd_en         (read_data_en        ),                // input wire rd_en
  .dout          (read_data_o         ),                // output wire [24 : 0] dout
  .full          (full                ),                // output wire full
  .empty         (adsdata_fifo_empty  ),                // output wire empty
  .rd_data_count (rd_data_count       ),                // output wire [6 : 0] rd_data_count
  .wr_data_count (wr_data_count       )                 // output wire [6 : 0] wr_data_count
);



endmodule
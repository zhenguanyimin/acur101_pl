`timescale 1 ps / 1 ps
module awmf0165_write_data_buffer(

    input wire          sys_rst              ,//pll_locked
    input wire          write_clk            ,
    input wire          write_data_en        ,
    input wire [31:0]   write_data_in        ,// 
							 			         
    input wire          read_clk             ,
    input wire          read_data_en         ,
							 
    output wire         adsdata_fifo_empty   ,
    output wire [255:0] read_data_o  	 

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


reg [31:0] write_data_ads = 0;
always @ (posedge write_clk)
begin
    if(write_data_en_r2 == 1'b1)
	  begin
	      write_data_ads  <= write_data_in  ;
	  end
	else
	  begin		  
		  write_data_ads  <= write_data_ads ;
	  end	  
end		  


//wire [5 : 0] rd_data_count_0165_gp2345  ;
//wire [6 : 0] wr_data_count_0165_gp2345  ;
wire full                   ;
wire wr_rst_busy            ;
wire rd_rst_busy            ;

xfifo_async_w32d1024_d0 xfifo_async_w32d1024_d0 (
  .rst           (sys_rst                ),      // input wire rst
  .wr_clk        (write_clk              ),      // input wire wr_clk
  .rd_clk        (read_clk               ),      // input wire rd_clk
  .din           (write_data_ads         ),      // input wire [31 : 0] din
  .wr_en         (write_data_wren        ),      // input wire wr_en
  .rd_en         (read_data_en           ),      // input wire rd_en
  .dout          (read_data_o            ),      // output wire [255 : 0] dout
  .full          (full                   ),      // output wire full
  .empty         (adsdata_fifo_empty     ),      // output wire empty
  .rd_data_count (  ),      // output wire [5 : 0] rd_data_count
  .wr_data_count (  ),      // output wire [8 : 0] wr_data_count
  .wr_rst_busy   (wr_rst_busy            ),      // output wire wr_rst_busy
  .rd_rst_busy   (rd_rst_busy            )       // output wire rd_rst_busy
);












endmodule
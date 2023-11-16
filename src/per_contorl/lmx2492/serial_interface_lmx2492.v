`timescale 1 ps / 1 ps
module serial_interface_lmx2492(

input wire         sys_rst     ,//pll_locked
input wire         sys_clk     ,//100mhz
input wire         spi_clk_in  ,//10mhz
input wire         spi_rw_flag ,//0:write,1:read


input wire         lmx2492_interrupt,
input wire [7:0]   lmx2492_batch_wr,
input wire [3:0]   lmx2492_batch_rd,
input wire         spi_config  ,//from PS
input wire [22:0]  lmx2492_data,//from PS, reg addr(15bit) + reg data(8bit)

output wire        spi_port_io_select,//no use
output reg         lmx2492_mod_o,
input  wire        lmxfifo_empty,

output reg         spi_wr_ack_o,
output reg         spi_rd_ack_o,
output reg         spi_rdata_vd_o,
output reg         spi_wdata_vd_o,

output reg [14:0]  spi_paddr_o ,
output reg [7:0]   spi_pdata_o ,
output reg [3:0]   spi_rdata_cnt_o,
output reg [7:0]   spi_wdata_cnt_o,

input  wire        spi_sdata_i ,
output reg         spi_sdata_o ,
output reg         spi_sen_o   ,
output reg         spi_clk_o   ,

output reg [22:0]  reg0  	   ,
output reg [22:0]  reg1  	   ,
output reg [22:0]  reg2  	   ,
output reg [22:0]  reg3  	   ,
output reg [22:0]  reg4  	   ,
output reg [22:0]  reg5  	   ,
output reg [22:0]  reg6  	   ,
output reg [22:0]  reg7  	   ,
output reg [22:0]  reg8  	   ,
output reg [22:0]  reg9  	   ,
output wire  	   irp



);

//reg         spi_sdata_o = 0;
//reg         spi_sen_o = 0;
//reg         spi_clk_o = 0;  
//
//reg spi_clk_o_r1 = 0;
//reg spi_sdata_o_r1 = 0;
//reg spi_sen_o_r1 = 0;
//
//reg spi_clk_o_r2 = 0;
//reg spi_sdata_o_r2 = 0;
//reg spi_sen_o_r2 = 0;
//
//reg spi_clk_o_r3 = 0;
//reg spi_sdata_o_r3 = 0;
//reg spi_sen_o_r3 = 0;
//
//reg spi_clk_o_r4 = 0;
//reg spi_sdata_o_r4 = 0;
//
//
//
//always @ (posedge clk_500khz)
//begin
//    spi_clk_o_r1    <=  spi_clk_o    ;  
//    spi_sdata_o_r1 <=  spi_sdata_o  ;
//
//    spi_clk_o_r2    <=  spi_clk_o_r1    ;  
//    spi_sdata_o_r2 <=  spi_sdata_o_r1 ;	
//	
//    spi_clk_o_r3    <=  spi_clk_o_r2    ;  
//    spi_sdata_o_r3 <=  spi_sdata_o_r2 ;	
//
//    spi_clk_out    <=  spi_clk_o_r3    ;  
//    spi_sdata_out <=  spi_sdata_o_r3 ;	
//	
//	
//end
//
//always @ (posedge clk_500khz)
//begin
//	spi_sen_o_r1    <=  spi_sen_o    ;
//    spi_sen_o_r2    <=  spi_sen_o_r1    ;
//end


//wire spi_sen_o_r3 = spi_sen_o_r1 || spi_sen_o_r2;


reg [7:0] mod_cnt = 0;
always @ (posedge spi_clk_in)
begin
    if(mod_cnt == 8'd250)
	  begin
	      mod_cnt <= 8'd1;
	  end
	else
	  begin
	      mod_cnt <= mod_cnt + 1'b1;
	  end
end

always @ (posedge spi_clk_in)
begin
    if(mod_cnt == 8'd1)
	  begin
	      lmx2492_mod_o <= 1'b1;
	  end
	else
	  begin
	      lmx2492_mod_o <= 1'b0;
	  end
end


//wire       spi_sdout    ;//from adc
//reg        spi_sdata_o  ;
reg        spi_tri_en   ;/*三态转换*/
reg [7:0]  spi_reg_data ;
reg [14:0] spi_addr_data;
reg        spi_sdata    ;
reg        spi_sen      ;

reg        spi_clk_en;
reg [3:0]  state;
reg [3:0]  start_delay_cnt;
reg [3:0]  tx_end_delay_cnt;
reg [3:0]  rx_end_delay_cnt;
reg [3:0]  read_wait_cnt;
reg [4:0]  write_cnt;
reg [3:0]  read_cnt;
reg [7:0]  read_adc_data;

//assign spi_sdout = spi_sdata_io;/*spi_tri_en为低电平时, spi_data_io作为输入*/
//assign spi_sdata_io = (spi_tri_en == 1'b1) ? spi_sdata_o : 1'bz;/*spi_tri_en为高电平时，spi_data_io为输出 */

assign spi_port_io_select = spi_tri_en;

parameter IDLE = 4'd0;

parameter START_DELAY = 4'd1;
parameter WRITE_STATE = 4'd2;
parameter TX_STATE = 4'd3;
parameter TX_END_DELAY = 4'd4;

parameter READ_STATE = 4'd5;
parameter READ_WAIT = 4'd6;
parameter RX_STATE = 4'd7;
parameter RX_END_DELAY = 4'd8;

parameter FINISH = 4'd9;

parameter DATA_WIDTH = 23;

reg [DATA_WIDTH-1:0] lmx2492_data_rdy;
reg                  spi_rw_flag_rdy;
reg [14:0]           lmx2492_addr_rdy;

reg reset_s = 0;
reg [3:0] count = 0;

always @ (posedge spi_clk_in)
begin
    if( &count[3:0] == 1'b1 )
	  begin
	      count <= count;
	  end
	else if(sys_rst == 1'b1)
	  begin
	      count <= count + 1'b1;
	  end
	else
	  begin
	      count <= 'd0;
	  end
end   

always @ (posedge spi_clk_in)
begin
    if( (count >= 4'ha) && (count <= 4'he) )
	  begin
	      reset_s <= 1'b1;
	  end
	else
	  begin
	      reset_s <= 1'b0;
	  end
end


//always @ (posedge clk_500khz)
//begin
//    if(state == TX_STATE)
//	  spi_sen_out <= spi_sen_o_r1 || spi_sen_o_r2;
//	else if(state == TX_END_DELAY)
//	  spi_sen_out <= spi_sen_o_r1  ;// && spi_sen_o_r2;
//	else
//	  spi_sen_out <= spi_sen_o_r1;
//	  
//    if(state == READ_WAIT)
//	  spi_sen_out <= spi_sen_o_r1 || spi_sen_o_r2;
//	else if(state == RX_END_DELAY)
//	  spi_sen_out <= spi_sen_o_r1 ;//&& spi_sen_o_r2;
//	else
//	  spi_sen_out <= spi_sen_o_r2;    
//	
//	
//	
//
//end


wire lmxfifo_empty_ne;
reg lmxfifo_empty_r1;
reg lmxfifo_empty_r2;

always @ (posedge spi_clk_in)
begin
    lmxfifo_empty_r1 <= lmxfifo_empty   ;
	lmxfifo_empty_r2 <= lmxfifo_empty_r1;
end

assign lmxfifo_empty_ne = ~lmxfifo_empty_r1 && lmxfifo_empty_r2;
 


always @ (posedge spi_clk_in)
begin
    if(reset_s == 1'b1)
	  begin
	      state <= IDLE;
		  spi_sdata <= 1'b0;
		  spi_sen <= 1'b1;
		  spi_clk_en <= 1'b0;
		  lmx2492_data_rdy <= 'd0;
		  lmx2492_addr_rdy <= 'd0;
		  spi_rw_flag_rdy <= 'b0;
		  read_adc_data <= 'd0;
		  //spi_reg_data <= 'd0;
	  end
	else
	  begin
	  
	      case(state)
		       IDLE:begin
			            if(lmxfifo_empty == 1'b1)
						  begin
						      state <= IDLE;
						  end
						else
						  begin
						      state <= START_DELAY;
						  end
				    end 					
			
        START_DELAY:begin
		                if(spi_config == 1'b1)
                          begin
						      spi_rw_flag_rdy <= spi_rw_flag;
			                  if(start_delay_cnt == 4'd5)//15
					            begin
						            if(spi_rw_flag_rdy == 1'b0)//w
					                  state <= WRITE_STATE;
						      	  else
						      	    state <= READ_STATE;
						        end
					          else
						        state <= START_DELAY;	
                          end
                        else
                          begin
						      spi_rw_flag_rdy <= 'b0;
						      state <= START_DELAY;
						  end				
		
		                if(spi_config == 1'b1)
						  begin
		                      if(start_delay_cnt == 4'd1)
							    begin
						            lmx2492_data_rdy <= lmx2492_data;//PS must ready for PL during ack time(800ns)
									lmx2492_addr_rdy <= lmx2492_data[22:8];
								end
						      else
						        lmx2492_data_rdy <= lmx2492_data_rdy;
						  end
						else
						  begin
						      lmx2492_data_rdy <= lmx2492_data_rdy;
						  end
                        
						if(spi_config == 1'b1)//PS must set 0,after receive ack(active high during 800ns)
						  begin
					          if(start_delay_cnt == 4'd4)//14
					            spi_sen <= 1'b0;
					          else
                                spi_sen <= spi_sen;
                          end
                        else
                          begin
                              spi_sen <= 1'b1;
                          end						  
				    end	
					
        WRITE_STATE:begin
		                spi_clk_en <= 1'b1;
						spi_sdata <= 1'b0;

						if(spi_rw_flag_rdy == 1'b0)
						  state <= TX_STATE;
						else if(read_wait_cnt == 4'd14)
						  state <= RX_STATE;
						else
						  state <= READ_WAIT;						

				    end
					
	       TX_STATE:begin
		   				//if(write_cnt == 8'd23)
                        //  begin
                        //      spi_sen <= 1'b1;
                        //  end
                        //else;					  					 						 
						 
		   				if(write_cnt == 8'd23)//22
						  begin
						      spi_clk_en <= 1'b0;
		   				      state <= TX_END_DELAY;
						  end
		   				else
						  begin
		   				      state <= TX_STATE;
							  spi_clk_en <= spi_clk_en;
						  end
		   				  
                        spi_sdata <= lmx2492_data_rdy[DATA_WIDTH-1];
                        lmx2492_data_rdy[DATA_WIDTH-1:0] <= {lmx2492_data_rdy[DATA_WIDTH-2:0], 1'b0};		  
		            end
					
		  TX_END_DELAY:begin
                        if(tx_end_delay_cnt == 4'd3)//15
						  begin 
							  state <= FINISH;//START_DELAY;
						  end
						else
						  begin
							  state <= TX_END_DELAY;
						  end
						  
						if(tx_end_delay_cnt == 4'd1)//10  
						  begin
						      spi_sen <= 1'b1;
						  end
						else;	  
					end									
					
		 READ_STATE:begin
		                spi_clk_en <= 1'b1;
                        spi_sdata <= 1'b1;
                        state <= READ_WAIT;
                    end
					
          READ_WAIT:begin
		                if(read_wait_cnt == 4'd15)//14
						  state <= RX_STATE;
						else
						  state <= READ_WAIT;

		   				//only reg addr send
                        spi_sdata <= lmx2492_data_rdy[DATA_WIDTH-1];
                        lmx2492_data_rdy[DATA_WIDTH-1:0] <= {lmx2492_data_rdy[DATA_WIDTH-2:0], 1'b0};							  
					end
					
		   RX_STATE:begin
		                //spi_sdata <= 1'b1;//don't care
						
						//if(read_cnt == 8'd7)
						//  begin
						//      spi_sen <= 1'b1;
						//  end
						//else;
						
						
						spi_sdata <= lmx2492_data_rdy[DATA_WIDTH-1];
                        lmx2492_data_rdy[DATA_WIDTH-1:0] <= {lmx2492_data_rdy[DATA_WIDTH-2:0], 1'b0};//continue send Register Data, Don't Care							
						
                        if(read_cnt == 8'd7)
						  begin
						      //spi_reg_data <= read_adc_data;
						      state <= RX_END_DELAY;
							  spi_clk_en <= 1'b0;
						  end
						else
						  begin
						      spi_clk_en <= spi_clk_en;
						      state <= RX_STATE;
							  read_adc_data <= read_adc_data;
						  end
						  
						read_adc_data[7:0] <= {read_adc_data[6:0],spi_sdata_i};	
                    end						
					
		  RX_END_DELAY:begin
                        if(rx_end_delay_cnt == 4'd3)//15
						  begin 
							  state <= FINISH;//START_DELAY;
						  end
						else
						  begin
							  state <= RX_END_DELAY;
						  end
						  
						if(rx_end_delay_cnt == 4'd1)//10  
						  begin
						      spi_sen <= 1'b1;
						  end
						else;	  
					end
					
		     FINISH:begin
                        state <= IDLE;
                    end
			default:;
          endcase				
	  end	  
			  
end			  

	  
	
	
always @ (posedge spi_clk_in)
begin
    if(reset_s == 1'b1)
	  begin
	      start_delay_cnt <= 4'd0;
	  end
	else 
	  begin
	      if( (state == START_DELAY) && (spi_config == 1'b1) ) 
		    begin
			    start_delay_cnt <= start_delay_cnt + 1'b1;
		    end
	      else
		    begin
			    start_delay_cnt <= 4'd0;
		    end
	  end
end
	
	
always @ (posedge spi_clk_in)
begin
    if(reset_s == 1'b1)
	  begin
	      tx_end_delay_cnt <= 4'd0;
	  end
	else 
	  begin
	      if(state == TX_END_DELAY)  
		    begin
			    tx_end_delay_cnt <= tx_end_delay_cnt + 1'b1;
		    end
	      else
		    begin
			    tx_end_delay_cnt <= 4'd0;
		    end
	  end
end	
	
	
always @ (posedge spi_clk_in)
begin
    if(reset_s == 1'b1)
	  begin
	      rx_end_delay_cnt <= 4'd0;
	  end
	else 
	  begin
	      if(state == RX_END_DELAY)  
		    begin
			    rx_end_delay_cnt <= rx_end_delay_cnt + 1'b1;
		    end
	      else
		    begin
			    rx_end_delay_cnt <= 4'd0;
		    end
	  end
end			
	
	
always @ (posedge spi_clk_in)
begin
    if(reset_s == 1'b1)
	  begin
	      read_wait_cnt <= 4'd0;
	  end
	else
	  begin	
          if(state == READ_WAIT)
		    begin
                read_wait_cnt <= read_wait_cnt + 1'b1;
			end
          else
		    begin
                read_wait_cnt <= 4'd0;	
            end
      end
end	  
	
	
always @ (posedge spi_clk_in)
begin
    if(reset_s == 1'b1)
      begin
          write_cnt <= 5'd0;
      end
    else
      begin
          if(state == TX_STATE)
            begin
                write_cnt <= write_cnt + 1'b1;
            end
          else
            begin
                write_cnt <= 5'd0;
            end
      end
end	  
	
	
always @ (posedge spi_clk_in)
begin
    if(reset_s == 1'b1)	
	  begin
	      read_cnt <= 4'd0;
	  end
	else
	  begin
	      if(state == RX_STATE)
		    begin
			    read_cnt <= read_cnt + 1'b1;
		    end
		  else
		    begin
			    read_cnt <= 4'd0;
			end
	  end
end
	
	
wire spi_clk_out_temp;
assign spi_clk_out_temp = spi_clk_en ?  spi_clk_in : 1'b0;
//assign spi_clk_out_temp = spi_clk_en ?  spi_clk_in : (state == TX_END_DELAY) ? 1'b1 : 1'b0;

 
always @ (posedge spi_clk_in)
begin
    if(reset_s == 1'b1)	
	  begin	
	      spi_addr_data<= 15'd0;
	      spi_reg_data <= 8'd0;
	  end
	else
	  begin
	      if(read_cnt == 8'd8)
		    begin
			    spi_addr_data<= lmx2492_addr_rdy; 
                spi_reg_data <= read_adc_data;	
		    end
		  else
		    begin
			    spi_addr_data<= spi_addr_data;
			    spi_reg_data <= spi_reg_data;
		    end
	  end
end
	
	
always @ (posedge spi_clk_in)
begin
    if(reset_s == 1'b1)	
	  begin		
          spi_rdata_cnt_o <= 4'd0;
      end
	else if(lmx2492_interrupt == 1'b1)
	  begin
	      spi_rdata_cnt_o <= 4'd0;
	  end
    else if( (spi_rdata_cnt_o == lmx2492_batch_rd) && (read_cnt == 8'd8) )
      begin
       	  spi_rdata_cnt_o <= spi_rdata_cnt_o;
	  end
	else if(read_cnt == 8'd8)
	  begin
	      spi_rdata_cnt_o <= spi_rdata_cnt_o + 1'b1; //4'd1;/* Only one read and write operation*/ //spi_rdata_cnt_o + 1'b1;/* batch read */
	  end
	else
	  begin
	      spi_rdata_cnt_o <= spi_rdata_cnt_o;
	  end
end	
	
	
always @ (posedge spi_clk_in)
begin
    if(reset_s == 1'b1)	
	  begin		
          spi_wdata_cnt_o <= 8'd0;
      end
	else if(lmx2492_interrupt == 1'b1)
	  begin
	      spi_wdata_cnt_o <= 4'd0;
	  end	  
    else if( (spi_wdata_cnt_o == lmx2492_batch_wr) && (write_cnt == 8'd23) )
      begin
       	  spi_wdata_cnt_o <= spi_wdata_cnt_o;
	  end	   
	else if(write_cnt == 8'd23)
	  begin
	      spi_wdata_cnt_o <= spi_wdata_cnt_o + 1'b1;
	  end
	else 
	  begin
	      spi_wdata_cnt_o <= spi_wdata_cnt_o;
	  end
end
	
	
	

/*
Tri_en信号即为三态控制信号，在写操作中，该信号必须置高；然而在读操作中，
该信号在写地址的前半段需置高，当完成写地址操作后，ADC的SDIO接口由输入变输出，
此时FPGA控制Tri_en信号拉低，将FPGA端的SDIO管脚由输出变为输入，从而正常接收ADC的SDIO口输出的寄存器数值。
*/


always @ (posedge sys_clk)
begin
    if(reset_s == 1'b1)
	  begin  
          spi_tri_en <= 1'b1;
      end
    else if(state == RX_STATE)//8 || 9
      begin
          spi_tri_en <= 1'b0;//input 	  
	  end
	else
	  begin
	      spi_tri_en <= 1'b1;
	  end
end



reg [14:0] spi_addr_data_r1 = 0;   
reg [7:0]  spi_reg_data_r1 = 0;    
reg        spi_sdata_r1 = 0;       
reg        spi_sen_r1 = 0;         
reg        spi_clk_out_temp_r1 = 0;


reg [14:0] spi_addr_data_r2 = 0;   
reg [7:0]  spi_reg_data_r2 = 0;    
reg        spi_sdata_r2 = 0;       
reg        spi_sen_r2 = 0;         
reg        spi_clk_out_temp_r2 = 0;





always @ (posedge sys_clk)
begin
    if(reset_s == 1'b1)
	  begin
	      spi_pdata_o   <= 'd0  ;
		  spi_paddr_o   <= 'd0  ;
          spi_sdata_o   <= 'd0  ;
          spi_sen_o     <= 'd1  ;
          spi_clk_o     <= 'd1  ;
	  end
	else
	  begin
	    //  spi_paddr_o   <= spi_addr_data    ;
	    //  spi_pdata_o   <= spi_reg_data     ;     //spi_pdata_r2 ;
        //  spi_sdata_o   <= spi_sdata        ;     //spi_sdata_r2 ;
        //  spi_sen_o     <= spi_sen          ;     //spi_sen_r2   ;
        //  spi_clk_o     <= spi_clk_out_temp ;     //spi_clk_r2   ;
		  
		spi_addr_data_r1    <= spi_addr_data    ;     
		spi_reg_data_r1     <= spi_reg_data     ;      
		spi_sdata_r1        <= spi_sdata        ;         
		spi_sen_r1          <= spi_sen          ;         
		spi_clk_out_temp_r1 <= !spi_clk_out_temp ; 
		
		spi_addr_data_r2    <= spi_addr_data_r1    ;
		spi_reg_data_r2     <= spi_reg_data_r1     ;
		spi_sdata_r2        <= spi_sdata_r1        ;
		spi_sen_r2          <= spi_sen_r1          ;
		spi_clk_out_temp_r2 <= spi_clk_out_temp_r1 ;
		
		spi_paddr_o         <= spi_addr_data_r2    ;
		spi_pdata_o         <= spi_reg_data_r2     ;
		spi_sdata_o         <= spi_sdata_r2        ;
		spi_sen_o           <= spi_sen_r2          ;//~spi_clk_en         ;//spi_sen_r2          ; 
		spi_clk_o           <= spi_clk_out_temp_r2 ; 
		  
	  end
end


//always @ (negedge spi_clk_in)
//always @ (posedge spi_clk_in)
//begin
//    if(reset_s == 1'b1)
//	  begin
//	      spi_sen_o <= 'd1;
//	  end
//	else
//	  begin
//	      spi_sen_o <= spi_sen;
//	  end
//end








always @ (posedge spi_clk_in)
begin
    if(reset_s == 1'b1)
	  begin
	      spi_wr_ack_o <= 1'b0;
	  end
	else
	  begin
	      if( tx_end_delay_cnt == 4'h1)//CTRL ack duration,Make sure the FIFO is empty the next time the state machine starts
		    begin
			    spi_wr_ack_o <= 1'b1;
		    end
		  else
		    begin
			    spi_wr_ack_o <= 1'b0;
			end
	  end
end


always @ (posedge spi_clk_in)
begin
    if(reset_s == 1'b1)
	  begin
	      spi_wdata_vd_o <= 1'b0;
	  end
	else
	  begin
	      if( tx_end_delay_cnt == 4'h4) 
		    begin
			    spi_wdata_vd_o <= 1'b1;
		    end
		  else
		    begin
			    spi_wdata_vd_o <= 1'b0;
			end
	  end
end




always @ (posedge spi_clk_in)
begin
    if(reset_s == 1'b1)
	  begin
	      spi_rd_ack_o <= 1'b0;
	  end
	else
	  begin
	      if( rx_end_delay_cnt == 4'h1)//CTRL ack duration,Make sure the FIFO is empty the next time the state machine starts
		    begin
			    spi_rd_ack_o <= 1'b1;
		    end
		  else
		    begin
			    spi_rd_ack_o <= 1'b0;
			end
	  end
end




always @ (posedge spi_clk_in)
begin
    if(reset_s == 1'b1)
	  begin
	      spi_rdata_vd_o <= 1'b0;
	  end
	else
	  begin
	      if( rx_end_delay_cnt == 4'h4)//CTRL ack duration
		    begin
			    spi_rdata_vd_o <= 1'b1;
		    end
		  else
		    begin
			    spi_rdata_vd_o <= 1'b0;
			end
	  end
end


// irp 中断

reg        pl_write_complete_2492 = 0;
reg        pl_write_complete_cnt_valid  = 0;
reg [7:0]  pl_write_complete_cnt = 0;
reg spi_wdata_vd_o_r1 = 0;
reg spi_wdata_vd_o_r2 = 0;
reg spi_wdata_vd_o_r3 = 0;

always @ (posedge spi_clk_in)
begin
    spi_wdata_vd_o_r1 <= spi_wdata_vd_o    ;//first read,after empty
    spi_wdata_vd_o_r2 <= spi_wdata_vd_o_r1 ;
    spi_wdata_vd_o_r3 <= spi_wdata_vd_o_r2 ;
end


always @ (posedge spi_clk_in)
begin
	//if( (spi_wdata_vd_o_r3 == 1'b1) && (lmxdata_fifo_empty == 1'b1) )
	if( (spi_wdata_vd_o_r3 == 1'b1) && (spi_wdata_cnt_o == lmx2492_batch_wr) )	
	  begin
	      pl_write_complete_cnt_valid <= 1'b1;
	  end
	else if(pl_write_complete_cnt == 8'hf)
	  begin
	      pl_write_complete_cnt_valid <= 1'b0;
	  end
	else
	  begin
	      pl_write_complete_cnt_valid <= pl_write_complete_cnt_valid;
	  end
end

always @ (posedge spi_clk_in)
begin
    if(pl_write_complete_cnt_valid == 1'b1)
	  begin
	      pl_write_complete_cnt <= pl_write_complete_cnt + 1'b1;
	  end
	else
	  begin
	      pl_write_complete_cnt <= 8'd0;
	  end
end

always @ (posedge spi_clk_in)
begin	
	if(pl_write_complete_cnt >= 8'd1)  
	  begin
	       pl_write_complete_2492 <= 1'b1;
	  end
	else
	  begin
	       pl_write_complete_2492 <= 1'b0;
	  end
end




reg     pl_read_complete_2492 = 0;
reg spi_rdata_vd_o_r1 = 0;
reg spi_rdata_vd_o_r2 = 0;
reg spi_rdata_vd_o_r3 = 0;
reg        pl_read_complete_cnt_valid  = 0;
reg [7:0]  pl_read_complete_cnt = 0;




always @ (posedge spi_clk_in)
begin
    spi_rdata_vd_o_r1 <= spi_rdata_vd_o    ;//first read,after empty
    spi_rdata_vd_o_r2 <= spi_rdata_vd_o_r1 ;
    spi_rdata_vd_o_r3 <= spi_rdata_vd_o_r2 ;
end


always @ (posedge spi_clk_in)
begin
	//if( (spi_rdata_vd_o_r3 == 1'b1) && (lmxdata_fifo_empty == 1'b1) )
	if( (spi_rdata_vd_o_r3 == 1'b1) && (spi_rdata_cnt_o == lmx2492_batch_rd) )
	  begin
	      pl_read_complete_cnt_valid <= 1'b1;
	  end
	else if(pl_read_complete_cnt == 8'hf)
	  begin
	      pl_read_complete_cnt_valid <= 1'b0;
	  end
	else
	  begin
	      pl_read_complete_cnt_valid <= pl_read_complete_cnt_valid;
	  end
end

always @ (posedge spi_clk_in)
begin
    if(pl_read_complete_cnt_valid == 1'b1)
	  begin
	      pl_read_complete_cnt <= pl_read_complete_cnt + 1'b1;
	  end
	else
	  begin
	      pl_read_complete_cnt <= 8'd0;
	  end
end
		

always @ (posedge spi_clk_in)
begin	
	//if( (pl_read_complete_cnt >= 8'd1) && (spi_rdata_cnt_o == lmx2492_batch_read_num) )
	if(pl_read_complete_cnt >= 8'd1) 
	  begin
	       pl_read_complete_2492 <= 1'b1;
	  end
	else
	  begin
	       pl_read_complete_2492 <= 1'b0;
	  end
end


assign irp = pl_read_complete_2492 || pl_write_complete_2492 ;

// data output
reg	[7:0]	addr ; 

always @(posedge spi_clk_in) begin
	if(sys_rst)
		addr <= 'd0 ;
	else if (addr == lmx2492_batch_rd )
		addr = 'd0 ;
	else if (spi_rdata_vd_o == 1'b1)
		addr <= addr + 1'b1 ;
	else 
		addr <= addr ;
end

always @(spi_clk_in) begin
	if(sys_rst)	begin
		reg0 <= 'd0 ;
		reg1 <= 'd0 ;
		reg2 <= 'd0 ;
		reg3 <= 'd0 ;
		reg4 <= 'd0 ;
		reg5 <= 'd0 ;
		reg6 <= 'd0 ;
		reg7 <= 'd0 ;
		reg8 <= 'd0 ;
		reg9 <= 'd0 ;
	end 
	else if(spi_rdata_vd_o)
		case (addr)	 
			'd0	: reg0 <= {spi_paddr_o,spi_pdata_o};
			'd1 : reg1 <= {spi_paddr_o,spi_pdata_o};
			'd2	: reg2 <= {spi_paddr_o,spi_pdata_o};
			'd3 : reg3 <= {spi_paddr_o,spi_pdata_o};
			'd4	: reg4 <= {spi_paddr_o,spi_pdata_o};
			'd5 : reg5 <= {spi_paddr_o,spi_pdata_o};
			'd6	: reg6 <= {spi_paddr_o,spi_pdata_o};
			'd7 : reg7 <= {spi_paddr_o,spi_pdata_o};
			'd8	: reg8 <= {spi_paddr_o,spi_pdata_o};
			'd9 : reg9 <= {spi_paddr_o,spi_pdata_o};
		default : ;
		endcase
	else 
		;
end





endmodule			  
			  
			  

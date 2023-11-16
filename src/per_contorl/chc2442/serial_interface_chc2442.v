`timescale 1 ps / 1 ps
module serial_interface_chc2442(

input wire         sys_rst     ,//pll_locked
input wire         sys_clk     ,//100mhz
input wire         spi_clk_in  ,//10mhz
input wire         spi_rw_flag ,//0:write,1:read

input wire         clk_500khz  ,

input wire         spi_config  ,//from PS
input wire [23:0]  chc2442_data,//from PS, reg addr(15bit) + reg data(8bit)

output wire        spi_port_io_select,
input wire         chcfifo_empty,

output reg         spi_wr_ack_o,
output reg         spi_rd_ack_o,
output reg         spi_rdata_vd_o,

output reg [31:0]  reg0		,
output wire 	   irp		,

output reg [3:0]   spi_rdata_cnt_o,
output reg [23:0]  spi_pdata_o ,
input  wire        spi_sdata_i ,
output reg         spi_sdata_o ,
output reg         spi_sen_o   ,
output reg         spi_clk_o   

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








//wire       spi_sdout    ;//from adc
//reg        spi_sdata_o  ;
reg        spi_tri_en   ;/*三态转换*/
reg [23:0] spi_reg_data ;

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
reg [23:0]  read_adc_data = 0;

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

parameter DATA_WIDTH = 24;

reg [DATA_WIDTH-1:0] chc2442_data_rdy;
reg                  spi_rw_flag_rdy;

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












always @ (negedge spi_clk_in)
begin
    if(reset_s == 1'b1)
	  begin
	      state <= IDLE;
		  spi_sdata <= 1'b0;
		  spi_sen <= 1'b1;
		  spi_clk_en <= 1'b0;
		  chc2442_data_rdy <= 'd0;
		  spi_rw_flag_rdy <= 'b0;
		  //read_adc_data <= 'd0;
		  //spi_reg_data <= 'd0;
	  end
	else
	  begin
	      case(state)
		       IDLE:begin
			            if(chcfifo_empty == 1'b1)
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
						            chc2442_data_rdy <= chc2442_data;//PS must ready for PL during ack time(800ns)
								end
						      else
						        chc2442_data_rdy <= chc2442_data_rdy;
						  end
						else
						  begin
						      chc2442_data_rdy <= chc2442_data_rdy;
						  end
                        
						//if(spi_config == 1'b1)//PS must set 0,after receive ack(active high during 800ns)
						//  begin
					    //      if(start_delay_cnt == 4'd4)//14
					    //        spi_sen <= 1'b0;
					    //      else
                        //        spi_sen <= spi_sen;
                        //  end
                        //else
                        //  begin
                        //      spi_sen <= 1'b1;
                        //  end						  
				    end	
					
        WRITE_STATE:begin
		                spi_sen <= 1'b0;
		                //spi_clk_en <= 1'b1;
						spi_sdata <= 1'b0;

						if(spi_rw_flag_rdy == 1'b0)
						  state <= TX_STATE;
						else if(read_wait_cnt == 4'd14)
						  state <= RX_STATE;
						else
						  state <= READ_WAIT;						

				    end
					
	       TX_STATE:begin

		   				if(write_cnt == 8'd25)
                          begin
                              spi_sen <= 1'b1;
                          end
                        else;

		   				if(write_cnt == 8'd25)//22
						  begin
						      spi_clk_en <= 1'b0;
		   				      state <= TX_END_DELAY;
						  end
		   				else
						  begin
		   				      state <= TX_STATE;
							  spi_clk_en <= 1'b1;//spi_clk_en;
						  end
		   				  
                        spi_sdata <= chc2442_data_rdy[DATA_WIDTH-1];
                        chc2442_data_rdy[DATA_WIDTH-1:0] <= {chc2442_data_rdy[DATA_WIDTH-2:0], 1'b0};	

                        //read_adc_data[23:0] <= {read_adc_data[22:0],spi_sdata_i};	

						
		            end
					
		  TX_END_DELAY:begin
		  
		                   
		                   state <= FINISH;
		  
                        //if(tx_end_delay_cnt == 4'd3)//15
						//  begin 
						//	  state <= FINISH;//START_DELAY;
						//  end
						//else
						//  begin
						//	  state <= TX_END_DELAY;
						//  end
						  
						//if(tx_end_delay_cnt == 4'd1)//10  
						//  begin
						//      spi_sen <= 1'b1;
						//  end
						//else;	  
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
assign spi_clk_out_temp = spi_clk_en ?  ~spi_clk_in : 1'b0;
//assign spi_clk_out_temp = spi_clk_en ?  spi_clk_in : (state == TX_END_DELAY) ? 1'b1 : 1'b0;

 
always @ (negedge spi_clk_o)
begin
    if(reset_s == 1'b1)	
	  begin	
	      spi_reg_data <= 8'd0;
	  end
	else
	  begin
	      if(write_cnt == 8'd25)
		    begin
                spi_reg_data <= read_adc_data;	
		    end
		  else
		    begin
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
    else if( (spi_rdata_cnt_o == 4'd4) && (read_cnt == 8'd8) )
      begin
       	  spi_rdata_cnt_o <= 4'd1;
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



//reg [14:0] spi_addr_data_r1 = 0;   
//reg [7:0]  spi_reg_data_r1 = 0;    
//reg        spi_sdata_r1 = 0;       
//reg        spi_sen_r1 = 0;         
//reg        spi_clk_out_temp_r1 = 0;
//
//
//reg [14:0] spi_addr_data_r2 = 0;   
//reg [7:0]  spi_reg_data_r2 = 0;    
//reg        spi_sdata_r2 = 0;       
//reg        spi_sen_r2 = 0;         
//reg        spi_clk_out_temp_r2 = 0;


reg spi_sen_r1 = 0;
always @ (negedge spi_clk_in)
begin
    spi_sen_r1 <= spi_sen;
end



always @ (posedge sys_clk)
begin
    if(reset_s == 1'b1)
	  begin
	      spi_pdata_o   <= 'd0  ;
          spi_sdata_o   <= 'd0  ;
          spi_sen_o     <= 'd1  ;
          spi_clk_o     <= 'd0  ;
	  end
	else
	  begin

	      spi_pdata_o   <= spi_reg_data     ;     //spi_pdata_r2 ;
          spi_sdata_o   <= spi_sdata        ;     //spi_sdata_r2 ;
          spi_sen_o     <= spi_sen          ;     //spi_sen_r2   ;
          spi_clk_o     <= spi_clk_out_temp ;     //spi_clk_r2   ;
		  
		//spi_addr_data_r1    <= spi_addr_data    ;     
		//spi_reg_data_r1     <= spi_reg_data     ;      
		//spi_sdata_r1        <= spi_sdata        ;         
		//spi_sen_r1          <= spi_sen          ;         
		//spi_clk_out_temp_r1 <= spi_clk_out_temp ; 
		//
		//spi_addr_data_r2    <= spi_addr_data_r1    ;
		//spi_reg_data_r2     <= spi_reg_data_r1     ;
		//spi_sdata_r2        <= spi_sdata_r1        ;
		//spi_sen_r2          <= spi_sen_r1          ;
		//spi_clk_out_temp_r2 <= spi_clk_out_temp_r1 ;
		//
		//spi_paddr_o         <= spi_addr_data_r2    ;
		//spi_pdata_o         <= spi_reg_data_r2     ;
		//spi_sdata_o         <= spi_sdata_r2        ;
		//spi_sen_o           <= spi_sen_r2          ; 
		//spi_clk_o           <= spi_clk_out_temp_r2 ; 
		//  
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
	      if( tx_end_delay_cnt == 4'h1)//CTRL ack duration
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
	      spi_rd_ack_o <= 1'b0;
	  end
	else
	  begin
	      if( rx_end_delay_cnt == 4'h4)//CTRL ack duration
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
	      if( tx_end_delay_cnt == 4'h1)//CTRL ack duration
		    begin
			    spi_rdata_vd_o <= 1'b1;
		    end
		  else
		    begin
			    spi_rdata_vd_o <= 1'b0;
			end
	  end
end



always @ (posedge spi_clk_o)
begin
    if(spi_sen_o == 1'b0)
	  begin
	      if(state == TX_STATE)
		    begin
			    read_adc_data[23:0] <= {read_adc_data[22:0],spi_sdata_i};	
		    end
		  else;
	  end
	else;
end
		  

always @ (posedge sys_clk)//interaction
begin
	if(sys_rst)
		reg0 <= 'd0 ; 
    else if( spi_rdata_vd_o == 1'b1 )
	  begin
	    reg0 <= spi_pdata_o;
	  end
	else;
end

reg        pl_read_complete_cnt_valid_2442  = 0;
reg [7:0]  pl_read_complete_cnt_2442 = 0;
reg        spi_rdata_vd_o_2442_r1 = 0;
reg        spi_rdata_vd_o_2442_r2 = 0;
reg        spi_rdata_vd_o_2442_r3 = 0;
reg    	   pl_read_complete_2442 = 0;

always @ (posedge spi_clk_o)
begin
    spi_rdata_vd_o_2442_r1 <= spi_rdata_vd_o	     ;//first read,after empty
    spi_rdata_vd_o_2442_r2 <= spi_rdata_vd_o_2442_r1 ;
    spi_rdata_vd_o_2442_r3 <= spi_rdata_vd_o_2442_r2 ;
end

always @ (posedge spi_clk_o)
begin
	if( (spi_rdata_vd_o_2442_r3 == 1'b1) && (chcfifo_empty == 1'b1) )
	  begin
	      pl_read_complete_cnt_valid_2442 <= 1'b1;
	  end
	else if(pl_read_complete_cnt_2442 == 8'hf)//8'hf //8'h64
	  begin
	      pl_read_complete_cnt_valid_2442 <= 1'b0;
	  end
	else
	  begin
	      pl_read_complete_cnt_valid_2442 <= pl_read_complete_cnt_valid_2442;
	  end
end

always @ (posedge spi_clk_o)
begin
    if(pl_read_complete_cnt_valid_2442 == 1'b1)
	  begin
	      pl_read_complete_cnt_2442 <= pl_read_complete_cnt_2442 + 1'b1;
	  end
	else
	  begin
	      pl_read_complete_cnt_2442 <= 8'd0;
	  end
end
		  

always @ (posedge spi_clk_o)
begin	
	if(pl_read_complete_cnt_2442 >= 8'd1)  
	  begin
	       pl_read_complete_2442 <= 1'b1;
	  end
	else
	  begin
	       pl_read_complete_2442 <= 1'b0;
	  end
end


assign irp = pl_read_complete_2442 ;









endmodule			  
			  
			  

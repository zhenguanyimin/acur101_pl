`timescale 1 ps / 1 ps
module serial_interface_adc3663(

input wire         sys_rst     ,//pll_locked
input wire         sys_clk     ,//100mhz
input wire         spi_clk_in  ,//10mhz
input wire         spi_rw_flag ,//0:write,1:read
input wire         spi_config  ,//from PS
input wire [21:0]  adc3244_data,//from PS, reg addr(14bit) + reg data(8bit)

input  wire        adcfifo_empty,

output reg         spi_wr_ack_o,
output reg         spi_rd_ack_o,
output reg         spi_rdata_vd_o,
output reg [13:0]  spi_paddr_o ,
output reg [7:0]   spi_pdata_o ,
output reg [3:0]   spi_rdata_cnt_o,
output reg [22:0]  reg0,

// input wire         spi_sdout_i ,//from adc3244
// output reg         spi_sdata_o ,

inout  wire		   spi_sdio	   ,
output reg         spi_sen_o   ,
output reg         spi_clk_o   ,
output reg         spi_reset_o ,
output wire 	   irp			

);

reg spi_clk_o_inv;

//reg [31:0]  spi_config_cnt = 0;
//
//always @ (posedge spi_clk_in)
//begin
//    if(spi_config_cnt == 32'h0000_00ff)
//	  begin
//	      spi_config_cnt <= spi_config_cnt;
//	  end
//	else  
//	  begin
//	      spi_config_cnt <= spi_config_cnt + 1'b1;
//	  end
//end
//
//wire spi_config = (spi_config_cnt == 32'h0000_00ff);


reg [7:0]  spi_reg_data ;
reg [13:0] spi_addr_data;
reg        spi_sdata    ;
reg        spi_sen      ;
reg        spi_reset    ;

reg       spi_clk_en;
 reg [3:0] state;
reg [3:0] start_delay_cnt;
reg [3:0] tx_end_delay_cnt;
reg [3:0] rx_end_delay_cnt;
reg [3:0] read_wait_cnt;
reg [4:0] write_cnt;
reg [3:0] read_cnt;
reg [7:0] read_adc_data;
reg [7:0] spi_rst_delay_cnt;
wire 	  spi_sdata_i ;
reg	      spi_sdata_o ;

parameter IDLE = 4'd0;
parameter SPI_RESET = 4'd11;
parameter RESET_DELAY = 4'd12;
parameter RESET_FINISH = 4'd13;

parameter TRANSFER_IDLE = 4'd14;

parameter START_DELAY = 4'd1;
parameter WRITE_STATE = 4'd2;
parameter WRITE1_STATE = 4'd3;
parameter TX_STATE = 4'd4;
parameter TX_END_DELAY = 4'd5;
parameter READ_STATE = 4'd6;
parameter READ_WAIT = 4'd7;
parameter RX_STATE = 4'd8;
parameter RX_END_DELAY = 4'd9;
parameter FINISH = 4'd10;

parameter DATA_WIDTH = 20;

reg [DATA_WIDTH-1:0] adc324x_data_rdy;
reg                  spi_rw_flag_rdy;
reg [13:0]           adc324x_addr_rdy;

reg reset_s = 0;
reg [3:0] count = 0;
reg [3:0] WRITE1_STATE_cnt ;


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


always @ (posedge spi_clk_in)
begin
    if(reset_s == 1'b1)
	  begin
	      state <= IDLE;
		  spi_sdata <= 1'b0;
		  spi_sen <= 1'b1;
		  spi_clk_en <= 1'b0;
		  adc324x_data_rdy <= 'd0;
		  adc324x_addr_rdy <= 'd0;
		  spi_rw_flag_rdy <= 'b0;
		  read_adc_data <= 'd0;
		  //spi_reg_data <= 'd0;
		  spi_reset <= 1'b0;
		//   WRITE1_STATE_cnt <= 'd0 ;
	  end
	else
	  begin
	      case(state)
		       IDLE:begin
			            state <= SPI_RESET;
			            //if(reset_s == 1'b0)
						//  begin
						//      state <= SPI_RESET;
						//  end
						//else
						//  begin
						//      state <= IDLE;
						//  end
				    end
					
		  SPI_RESET:begin
		                state <= RESET_DELAY;
				    end

		RESET_DELAY:begin
		                if(spi_rst_delay_cnt == 8'd100)//CTRL RESET t3,reg write delay
						  begin
						      state <= RESET_FINISH;
						  end
						else
						  begin
						      state <= RESET_DELAY;
						  end
						  
						if(spi_rst_delay_cnt == 8'd51)//CTRL RESET t2,active high
                          begin
                              spi_reset <= 1'b1;
						  end
                        else if(spi_rst_delay_cnt == 8'd54)
                          begin
                              spi_reset <= 1'b0;
                          end
                        else
                          begin
                              spi_reset <= spi_reset;
                          end							  	  
				    end


	   RESET_FINISH:begin		
	                    state <= TRANSFER_IDLE;
				    end	
					
	 TRANSFER_IDLE:begin
			            if(adcfifo_empty == 1'b1)
						  begin
						      state <= TRANSFER_IDLE;
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
			                  if(start_delay_cnt == 4'd5)
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
						            adc324x_data_rdy <= adc3244_data;//PS must ready for PL during ack time(800ns)
									adc324x_addr_rdy <= adc3244_data[21:8];
								end
						      else
						        adc324x_data_rdy <= adc324x_data_rdy;
						  end
						else
						  begin
						      adc324x_data_rdy <= adc324x_data_rdy;
						  end
                        
						if(spi_config == 1'b1)//PS must set 0,after receive ack(active high during 800ns)
						  begin
					          if(start_delay_cnt == 4'd4)
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
						state <= WRITE1_STATE;
				    end
											
       WRITE1_STATE:begin
	                    spi_sdata <= 1'b0;
						if(WRITE1_STATE_cnt == 'd2 )
						begin 
							if(spi_rw_flag_rdy == 1'b0)
							  state <= TX_STATE;
							else if(read_wait_cnt == 4'd14)
							  state <= RX_STATE;
							else
							  state <= READ_WAIT;
						end
						else 
							state <= WRITE1_STATE ;
					end	
					
	       TX_STATE:begin
		   				spi_sen <= 1'b0;
		   				if(write_cnt == 8'd20)
						  begin
						      spi_clk_en <= 1'b0;
		   				      state <= TX_END_DELAY;
						  end
		   				else
						  begin
		   				      state <= TX_STATE;
							  spi_clk_en <= spi_clk_en;
						  end
		   				  
                        spi_sdata <= adc324x_data_rdy[DATA_WIDTH-1];
                        adc324x_data_rdy[DATA_WIDTH-1:0] <= {adc324x_data_rdy[DATA_WIDTH-2:0], 1'b0};		  
		            end
					
		  TX_END_DELAY:begin
                        if(tx_end_delay_cnt == 4'd3)
						  begin 
							  state <= FINISH;//START_DELAY; 
						  end
						else
						  begin
							  state <= TX_END_DELAY;
						  end
						  
						if(tx_end_delay_cnt == 4'd1)  
						  begin
						      spi_sen <= 1'b1;
						  end
						else;	  
					end									
					
		 READ_STATE:begin
		                spi_clk_en <= 1'b1;
                        spi_sdata <= 1'b1;
                        state <= WRITE1_STATE;
                    end
					
          READ_WAIT:begin
		                if(read_wait_cnt == 4'd12)
						  state <= RX_STATE;
						else
						  state <= READ_WAIT;

		   				//only reg addr send
                        spi_sdata <= adc324x_data_rdy[DATA_WIDTH-1];
                        adc324x_data_rdy[DATA_WIDTH-1:0] <= {adc324x_data_rdy[DATA_WIDTH-2:0], 1'b0};							  
					end
					
		   RX_STATE:begin
		                //spi_sdata <= 1'b1;//don't care
						
						spi_sdata <= adc324x_data_rdy[DATA_WIDTH-1];
                        adc324x_data_rdy[DATA_WIDTH-1:0] <= {adc324x_data_rdy[DATA_WIDTH-2:0], 1'b0};//continue send Register Data, Don't Care							
						
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
                        if(rx_end_delay_cnt == 4'd3)
						  begin 
							  state <= FINISH;//START_DELAY; 
						  end
						else
						  begin
							  state <= RX_END_DELAY;
						  end
						  
						if(rx_end_delay_cnt == 4'd1)  
						  begin
						      spi_sen <= 1'b1;
						  end
						else;	  
					end
					
		     FINISH:begin
                        state <= TRANSFER_IDLE;
                    end
			default:;
          endcase				
	  end	  
			  
end			  


always @ (posedge spi_clk_in)
begin
    if(reset_s == 1'b1)
	  begin
	      spi_rst_delay_cnt <= 4'd0;
	  end
	else
	  begin
	      if(state == RESET_DELAY)
		    begin
			    spi_rst_delay_cnt <= spi_rst_delay_cnt + 1'b1;
		    end
		  else
		    begin
			    spi_rst_delay_cnt <= 4'd0;
		    end
	  end
end			  
	
always @ (posedge spi_clk_in)
begin
	if(reset_s == 1'b1)
		WRITE1_STATE_cnt <= 'd0 ;
	else if(state == WRITE1_STATE)
		WRITE1_STATE_cnt <= WRITE1_STATE_cnt + 1'b1 ;
	else 
		WRITE1_STATE_cnt <= 'd0 ;
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
assign spi_clk_out_temp = spi_clk_en ? ~spi_clk_in : 1'b0;

 
always @ (posedge spi_clk_in)
begin
    if(reset_s == 1'b1)	
	  begin	
	      spi_addr_data<= 14'd0;
	      spi_reg_data <= 8'd0;
	  end
	else
	  begin
	      if(read_cnt == 8'd8)
		    begin
			    spi_addr_data<= adc324x_addr_rdy; 
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
    else if( (spi_rdata_cnt_o == 4'd4) && (read_cnt == 8'd8) )
      begin
       	  spi_rdata_cnt_o <= 4'd1;
	  end
	else if(read_cnt == 8'd8)
	  begin
	      spi_rdata_cnt_o <= 4'd1;//spi_rdata_cnt_o + 1'b1; //4'd1;/* Only one read and write operation*/ //spi_rdata_cnt_o + 1'b1;/* batch read */
	  end
	else
	  begin
	      spi_rdata_cnt_o <= spi_rdata_cnt_o;
	  end
end	
	

	

//reg [7:0] spi_pdata_r1 ;
//reg       spi_sdata_r1 ;
//reg       spi_sen_r1   ;
//reg       spi_clk_r1   ;
//reg       spi_reset_r1 ;
//
//reg [7:0] spi_pdata_r2 ;
//reg       spi_sdata_r2 ;
//reg       spi_sen_r2   ;
//reg       spi_clk_r2   ;
//reg       spi_reset_r2 ;
//
//
//always @ (posedge sys_clk)
//begin
//    spi_pdata_r1   <= spi_reg_data     ;
//    spi_sdata_r1   <= spi_sdata        ;
//    spi_sen_r1     <= spi_sen          ;
//    spi_clk_r1     <= spi_clk_out_temp ;
//    spi_reset_r1   <= spi_reset        ;
//
//    spi_pdata_r2   <= spi_pdata_r1     ;
//    spi_sdata_r2   <= spi_sdata_r1     ;
//    spi_sen_r2     <= spi_sen_r1       ;
//	spi_clk_r2     <= spi_clk_r1       ;
//    spi_reset_r2   <= spi_reset_r1     ;
//end


always @ (posedge sys_clk)
begin
    if(reset_s == 1'b1)
	  begin
	      spi_pdata_o   <= 'd0  ;
		  spi_paddr_o   <= 'd0  ;
          spi_sdata_o   <= 'd0  ;
          spi_sen_o     <= 'd1  ;
          spi_clk_o     <= 'd0  ;
          spi_reset_o   <= 'd0  ;
		  spi_clk_o_inv <= 'd0  ;
	  end
	else
	  begin
	      spi_paddr_o   <= spi_addr_data    ;
	      spi_pdata_o   <= spi_reg_data     ;     //spi_pdata_r2 ;
          spi_sdata_o   <= spi_sdata        ;     //spi_sdata_r2 ;
          spi_sen_o     <= spi_sen          ;     //spi_sen_r2   ;
          spi_clk_o     <= spi_clk_out_temp ;     //spi_clk_r2   ;
          spi_reset_o   <= spi_reset        ;     //spi_reset_r2 ;
		  spi_clk_o_inv <=!spi_clk_out_temp ;
	  end
end


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


always @ (posedge spi_clk_in)//interaction
begin
	if(sys_rst)
		reg0 <= 'd0 ; 
    if( (spi_rdata_cnt_o == 4'd1) && (spi_rdata_vd_o == 1'b1) )
	  begin
	    reg0[21:0] <= {spi_paddr_o[13:0],spi_pdata_o[7:0]};
	  end
	else;

end
wire	spi_sdio_t;	//三态控制
assign 	spi_sdio_t = (state == RX_STATE ) ;



IOBUF #(
	.DRIVE(12), // Specify the output drive strength
	.IBUF_LOW_PWR("TRUE"),  // Low Power - "TRUE", High Performance = "FALSE" 
	.IOSTANDARD("DEFAULT"), // Specify the I/O standard
	.SLEW("SLOW") // Specify the output slew rate
 ) IOBUF_inst (
	.O(spi_sdata_i),     // Buffer output
	.IO(spi_sdio),   // Buffer inout port (connect directly to top-level port)
	.I(spi_sdata_o),     // Buffer input
	.T(spi_sdio_t)      // 3-state enable input, high=input, low=output
 );

endmodule			  
			  
			  

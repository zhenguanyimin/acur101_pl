
`timescale 1 ps / 1 ps

module cfar_data_segment(

    input wire         rst                  	,//pll_locked
    input wire         clk               		,//100MHz,from PL    
    input wire         cfar_data_valid_i        ,
    input wire [31:0]  cfar_data_i              ,
	input wire         cfar_data_last_i         ,
    input wire [15:0]  cfar_data_num_i          ,
					   
	output reg         cfar_data_valid_o        , 
	output reg [31:0]  cfar_data_o              , 
	output reg         cfar_data_last_o         ,
	output reg [15:0]  cfar_data_num_o          
	
	);
	
	
reg        cfar_data_valid_i_r1 = 0;
reg [31:0] cfar_data_i_r1 = 0;
reg [15:0] cfar_data_count = 1;

always @ (posedge clk)
begin
    if(cfar_data_valid_i == 1'b1)
	  begin
	      cfar_data_count <= cfar_data_count + 1'b1;
	  end
	else
	  begin
	      cfar_data_count <= 'd0;
	  end
end



always @ (posedge clk)
begin
    cfar_data_valid_i_r1 <= cfar_data_valid_i ;
	cfar_data_i_r1       <= cfar_data_i       ;
end

wire cfar_data_valid_i_pe;
wire cfar_data_valid_i_ne;

assign cfar_data_valid_i_pe = ~cfar_data_valid_i_r1 &&  cfar_data_valid_i;
assign cfar_data_valid_i_ne =  cfar_data_valid_i_r1 && ~cfar_data_valid_i;

reg [23:0] cfar_frame_cnt = 0;

always @ (posedge clk)
begin
    if(cfar_data_valid_i_pe == 1'b1)
	  begin
	      cfar_frame_cnt <= cfar_frame_cnt + 1;
	  end
	else
	  begin
	      cfar_frame_cnt <= cfar_frame_cnt;
	  end
end




reg [15:0] cfar_valid_data_num = 0;

always @ (posedge clk)
begin
    if(cfar_data_valid_i_pe == 1'b1)
	  begin
	      if(|cfar_data_num_i[15:8] == 1'b1)
            begin
			    cfar_valid_data_num <= 255;
			end
		  else
		    begin
			    cfar_valid_data_num <= cfar_data_num_i;
			end
	  end
	else
	  begin
	      cfar_valid_data_num <= cfar_valid_data_num;
	  end
end



reg [9:0] cfar_data_filled_num = 0;

always @ (posedge clk)
begin
    if(cfar_data_valid_i_pe == 1'b1)
	  begin
	      if(|cfar_data_num_i[15:10] == 1'b1)
		    begin
			    cfar_data_filled_num <= 'd0;
		    end
	      else if(|cfar_data_num_i[9:0] == 1'b1)
	        begin
	            cfar_data_filled_num <= ~cfar_data_num_i[9:0] + 1;
	        end
		  else
		    begin
			    cfar_data_filled_num <= 'd0;/*1024的整数倍,不用补0*/
		    end
	  end
	else
	  begin
	      cfar_data_filled_num <= cfar_data_filled_num;
	  end
end


reg cfar_data_filled_valid = 0;
reg [9:0] cfar_data_filled_count = 1;

always @ (posedge clk)
begin
    if(|cfar_data_filled_num[9:0] == 1'b0)
	  begin
	      cfar_data_filled_valid <= 1'b0;
	  end	  
    else if(cfar_data_valid_i_ne == 1'b1)
	  begin
	      cfar_data_filled_valid <= 1'b1;
	  end
	else if(cfar_data_filled_count == cfar_data_filled_num)
	  begin
	      cfar_data_filled_valid <= 1'b0;
	  end
	else
	  begin
	      cfar_data_filled_valid <= cfar_data_filled_valid;
	  end
end
	
	
always @ (posedge clk)
begin
    if(cfar_data_filled_valid == 1'b1)
	  begin
	      cfar_data_filled_count <= cfar_data_filled_count + 1'b1;
	  end
	else
	  begin
	      cfar_data_filled_count <= 'd1;
	  end
end
	

reg cfar_wr_en = 0;

always @ (posedge clk)
begin
    if(cfar_data_count <= 1024)
	  begin
          cfar_wr_en <= cfar_data_valid_i_r1 || cfar_data_filled_valid;
	  end
	else 
	  begin
	      cfar_wr_en <= 1'b0;
	  end
end

reg [31:0] cfar_din = 0;
always @ (posedge clk)
begin
    if(cfar_data_valid_i_r1 == 1'b1)
	  begin
	      cfar_din <= cfar_data_i_r1;
	  end
	else
	  begin
	      cfar_din <= 'd0;
	  end
end



reg [3:0] state = 0;
reg ram_fifo_rden = 0;
reg ram_fifo_data_last = 0;
reg [7:0] rd_data_delay = 0;
reg [11:0] rd_data_count = 0;  

wire [31:0] cfar_dout;
wire cfar_fifo_full;
wire cfar_fifo_empty;
wire [10:0] data_count;
   
always@(posedge clk)
begin
    if(rst)
	  begin
	      state <= 0;
		  ram_fifo_rden <= 0;
          rd_data_count <= 0;
          rd_data_delay <= 0;
	  end
	else
	  begin
          case(state)
		      0:begin
			        if(cfar_fifo_empty == 1'b0 && data_count >= 'd64) 
					  begin
                          state <= 1;
                      end
                    else 
	      			  begin
                          state <= 0;
                      end
                 end
			   1:begin
                     if(rd_data_delay == 8'd32) 
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
			         if(rd_data_count == 12'd1023)
					   begin
					       ram_fifo_data_last <= 1'b1;
					   end
					 else
					   begin
					       ram_fifo_data_last <= 1'b0;
					   end

                     if(rd_data_count == 12'd1024) 
	      			   begin
	      			       ram_fifo_rden <= 1'b0;
                           rd_data_count <= 8'd0;
	      				   state <= 3;
                       end
                     else 
	      			   begin
	      			       ram_fifo_rden <= 1'b1;
                           rd_data_count <= rd_data_count + 1'b1;                   
                           state <= 2;
                       end
                  end       
               3:begin state <= 0; end
 
         default:begin state <= 0; end
          endcase  
      end		  
end



reg         cfar_data_valid_pipe0 = 0 ; 
reg [31:0]  cfar_data_pipe0       = 0 ; 
reg         cfar_data_last_pipe0  = 0 ; 
reg [15:0]  cfar_data_num_pipe0   = 0 ; 


reg         cfar_data_valid_pipe1 = 0 ; 
reg [31:0]  cfar_data_pipe1       = 0 ; 
reg         cfar_data_last_pipe1  = 0 ; 
reg [15:0]  cfar_data_num_pipe1   = 0 ; 


reg         cfar_data_valid_pipe2 = 0 ; 
reg [31:0]  cfar_data_pipe2       = 0 ; 
reg         cfar_data_last_pipe2  = 0 ; 
reg [15:0]  cfar_data_num_pipe2   = 0 ; 


reg         cfar_data_valid_pipe3 = 0 ; 
reg [31:0]  cfar_data_pipe3       = 0 ; 
reg         cfar_data_last_pipe3  = 0 ; 
reg [15:0]  cfar_data_num_pipe3   = 0 ; 

reg         cfar_data_valid_pipe4 = 0 ; 



always@(posedge clk)
begin
    cfar_data_valid_pipe0  <= ram_fifo_rden         ;
    cfar_data_pipe0        <= cfar_dout             ;
    cfar_data_last_pipe0   <= ram_fifo_data_last    ;
    cfar_data_num_pipe0    <= cfar_data_num_i       ;
	
	cfar_data_valid_pipe1  <= cfar_data_valid_pipe0 ;
	cfar_data_pipe1        <= cfar_data_pipe0       ;
	cfar_data_last_pipe1   <= cfar_data_last_pipe0  ;
	cfar_data_num_pipe1    <= cfar_data_num_pipe0   ;
	
	cfar_data_valid_pipe2  <= cfar_data_valid_pipe1 ;
	cfar_data_pipe2        <= cfar_data_pipe1       ;
	cfar_data_last_pipe2   <= cfar_data_last_pipe1  ;
	cfar_data_num_pipe2    <= cfar_data_num_pipe1   ;	
	
	cfar_data_valid_pipe3  <= cfar_data_valid_pipe2 ;
	cfar_data_pipe3        <= cfar_data_pipe2       ;
	cfar_data_last_pipe3   <= cfar_data_last_pipe2  ;
	cfar_data_num_pipe3    <= cfar_data_num_pipe2   ;	
	
	cfar_data_valid_pipe4  <= cfar_data_valid_pipe3 ;
	
end


wire cfar_data_valid_pipe0_pe;
wire cfar_data_valid_pipe1_pe;
wire cfar_data_valid_pipe2_ne;
wire cfar_data_valid_pipe3_ne;

assign cfar_data_valid_pipe0_pe =  cfar_data_valid_pipe0 && ~cfar_data_valid_pipe1;
assign cfar_data_valid_pipe1_pe =  cfar_data_valid_pipe1 && ~cfar_data_valid_pipe2;
assign cfar_data_valid_pipe2_ne = ~cfar_data_valid_pipe2 &&  cfar_data_valid_pipe3;
assign cfar_data_valid_pipe3_ne = ~cfar_data_valid_pipe3 &&  cfar_data_valid_pipe4;






reg         cfar_data_valid_out_pipe0 = 0 ; 
reg [31:0]  cfar_data_out_pipe0       = 0 ; 
reg         cfar_data_last_out_pipe0  = 0 ; 
reg [15:0]  cfar_data_num_out_pipe0   = 0 ; 

always@(posedge clk)
begin
    if(cfar_data_valid_pipe0_pe == 12'd1)
	  begin
	   cfar_data_out_pipe0 <= 32'ha5a5_a5a5;
	  end
    else if(cfar_data_valid_pipe1_pe == 12'd1)
	  begin
	      cfar_data_out_pipe0[31:24] <= cfar_valid_data_num[7:0];
	      cfar_data_out_pipe0[23:0]  <= cfar_frame_cnt[23:0];
	  end
	else if(cfar_data_valid_pipe2 == 1'b1)  
	  begin
	      cfar_data_out_pipe0 <= cfar_data_pipe2[31:0];
	  end	
 
	else if(cfar_data_valid_pipe2_ne == 1'b1 || cfar_data_valid_pipe3_ne == 1'b1)
	  begin
		  cfar_data_out_pipe0 <= 32'hf0f0_f0f0;
	  end
	else
	  begin
	      cfar_data_out_pipe0 <= 'd0;
	  end
end
			

always@(posedge clk)
begin
    cfar_data_num_out_pipe0   <= cfar_data_num_pipe2;
    cfar_data_last_out_pipe0  <= cfar_data_valid_pipe3_ne;
    cfar_data_valid_out_pipe0 <= cfar_data_valid_pipe0_pe || cfar_data_valid_pipe1_pe || 
                                 cfar_data_valid_pipe2_ne || cfar_data_valid_pipe3_ne ||
								 cfar_data_valid_pipe2;
end
								








always@(posedge clk)
begin
    if(rst)
	  begin
	      cfar_data_valid_o <= 'd0;
	      cfar_data_o       <= 'd0;
	      cfar_data_last_o  <= 'd0;
		  cfar_data_num_o   <= 'd0;
	  end
	else
	  begin
	      cfar_data_valid_o <= cfar_data_valid_out_pipe0 ;
          cfar_data_o       <= cfar_data_out_pipe0       ;
          cfar_data_last_o  <= cfar_data_last_out_pipe0  ;
		  cfar_data_num_o   <= cfar_data_num_out_pipe0   ;
	  end
end











xilinx_afifo_generator_w32xd1024 U_xilinx_afifo_generator_w32xd1024 (
  .clk       (clk      ),   // input wire clk
  .srst      (1'b0            ),   // input wire srst
  .din       (cfar_din        ),   // input wire [31 : 0] din
  .wr_en     (cfar_wr_en      ),   // input wire wr_en
  .rd_en     (ram_fifo_rden   ),   // input wire rd_en
  .dout      (cfar_dout       ),   // output wire [31 : 0] dout
  .full      (cfar_fifo_full  ),   // output wire full
  .empty     (cfar_fifo_empty ),   // output wire empty
  .data_count(data_count      ),   // output wire [10 : 0] data_count
  .wr_rst_busy( ),                 // output wire wr_rst_busy
  .rd_rst_busy( )                  // output wire rd_rst_busy
);







	
	
	
	
	
endmodule





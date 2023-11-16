`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/28/2022 08:41:10 AM
// Design Name: 
// Module Name: awmf_chain_ctrl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module awmf_chain_ctrl(
input clk_i,
input rst_i,
input cpie_i,
//input [1:0] mode_ctrl_i, //connected to chain module directly
input [0:0] fifo_empty_i,
output [0:0] fifo_rd_o,
output [0:0] fifo_wr_o,
output [0:0] busy_o,
output [0:0] chain_wr_en,
input [255:0] chain_data_i,
output[239:0] chain_data_o,
input [239:0] chain_data_o_i,
output [255:0] chain_rd_data_o,
input [0:0] chain_busy_i ,
input [0:0] chain_wr_i, //H:write L:Read

output reg rd_complete_o,
output reg wr_complete_o,
output wire awmf_0165_busy 

    );

localparam      INTERRUPT_LENGTH = 8'h1f;
parameter [7:0] ST_IDLE = 8'h01; //waiting for data to write
parameter [7:0] ST_DATA_TX = 8'h02;
parameter [7:0] ST_DATA_RX = 8'h03;
parameter [7:0] ST_WAIT_TX = 8'h04 ;
parameter [7:0] ST_WAIT_TX_DONE = 8'h05 ;
parameter [7:0] ST_LD_FIFO_DATA = 8'h06 ;
parameter [7:0] ST_WAIT_RX = 8'h07 ;
parameter [7:0] ST_WAIT_RX_DONE = 8'h08;

reg [0:0] reg_busy_tx;
reg [7:0] reg_cst;
reg [7:0] reg_cst_c1;
//reg [239:0] reg_data_i ;
reg [239:0] reg_data_o ;
reg [0:0] reg_rd;   
reg [0:0] reg_chain_en;
reg [255:0] reg_chain_rd_data;
reg [0:0] reg_fifo_wr;
wire [239:0] data_i;

reg cpie_i_r1 = 0;
reg cpie_i_r2 = 0;
reg cpie_i_r3 = 0;
always @(posedge clk_i)
begin
    cpie_i_r1 <= cpie_i    ;
    cpie_i_r2 <= cpie_i_r1 ;
    cpie_i_r3 <= cpie_i_r2 ;
end

wire cpie_i_pe;
assign cpie_i_pe = ~cpie_i_r3 && cpie_i_r2;


reg up_date = 0;

always@(posedge clk_i)
begin
    if(cpie_i_pe == 1'b1)
	  up_date <= 1'b1;
	else
	  up_date <= up_date;
end
	   




reg  read_flag = 0;
always@(posedge clk_i)
begin
    if(chain_wr_i == 1'b1)
	  begin
          if(cpie_i_pe == 1'b1 && fifo_empty_i == 1'b0 ) 			
	        read_flag <= 1'b1;
          else if(fifo_empty_i == 1'b1)  	
	        read_flag <= 1'b0;
          else  
	        read_flag <= read_flag ;
      end
	else  
	  begin
	      read_flag <= ~fifo_empty_i;
	  end
end 


assign data_i = {chain_data_i[251:192],chain_data_i[187:128],chain_data_i[123:64],chain_data_i[59:0]};
//reg [59:0] reg_tx ;
always @(negedge clk_i) begin
    if( 1 == rst_i ) begin
        reg_cst <= ST_IDLE ;
        reg_rd <= 0 ;
        reg_chain_en <= 0;
        reg_busy_tx <= 0 ;
        reg_fifo_wr <= 0 ;
    end else
        case (reg_cst)
        ST_IDLE:begin
            if( read_flag == 1'b1 || ( up_date == 1'b0 && fifo_empty_i == 1'b0 ) ) begin //data already ok!
                reg_data_o <= data_i ;
                reg_chain_en <= 1 ;
                reg_cst <= ST_DATA_TX ;
                reg_busy_tx <= 1 ;
            end
            else begin
                reg_cst <= ST_IDLE ;
                reg_busy_tx <= 0 ;
            end     
            reg_fifo_wr <= 0;
        end
        
        ST_DATA_TX:begin
            reg_chain_en <= 0 ;
            reg_cst <= ST_WAIT_TX ;
        end
        
        ST_WAIT_TX:begin
            if ( 0 == chain_busy_i )
                reg_cst <= ST_WAIT_TX ;
            else 
                reg_cst <= ST_WAIT_TX_DONE;
        end
        
        ST_WAIT_TX_DONE:begin
            if ( 1 == chain_busy_i )
                reg_cst <= ST_WAIT_TX_DONE ;
            else begin
                reg_cst <= ST_LD_FIFO_DATA ;
                reg_rd <= 1;
            end
        end
        
        ST_LD_FIFO_DATA:begin 
            reg_rd <= 0;
            if( 1 == chain_wr_i ) begin//write
                reg_cst <= ST_IDLE ;
            end
            else begin
                reg_cst <= ST_WAIT_RX ; //read
                reg_chain_en <= 1 ;
            end
        end
        
        ST_WAIT_RX: begin
            reg_chain_en <= 0 ;
            if ( 0 == chain_busy_i )
                reg_cst <= ST_WAIT_RX ;
            else 
                reg_cst <= ST_WAIT_RX_DONE;
        end
        
        ST_WAIT_RX_DONE:begin
            if ( 1 == chain_busy_i )
                reg_cst <= ST_WAIT_RX_DONE ;
            else begin
                reg_fifo_wr <= 1 ; //write to fifo 
                reg_chain_rd_data <= { 4'b0,chain_data_o_i[59:0],
                                       4'b0,chain_data_o_i[119:60],
                                       4'b0,chain_data_o_i[179:120],
                                       4'b0,chain_data_o_i[239:180]};
                reg_cst <= ST_IDLE ; 
            end
        end

        default:;
        endcase
end

always @(negedge clk_i) 
begin
    if(rst_i == 1'b1) 
	  begin
	      reg_cst_c1 <= ST_IDLE ;
	  end
	else
	  begin
	      reg_cst_c1 <= reg_cst ;
	  end
end

reg rd_complete_c0 = 0;
reg wr_complete_c0 = 0;
reg rd_complete_c1 = 0;
reg wr_complete_c1 = 0;
reg rd_complete_c2 = 0;
reg wr_complete_c2 = 0;


always @(negedge clk_i) 
begin
    rd_complete_c0 <= (reg_cst == ST_IDLE) && (reg_cst_c1 == ST_WAIT_RX_DONE);
	wr_complete_c0 <= (reg_cst == ST_IDLE) && (reg_cst_c1 == ST_LD_FIFO_DATA);	
end

always @(posedge clk_i) 
begin
    rd_complete_c1 <= rd_complete_c0 ;
    wr_complete_c1 <= wr_complete_c0 ;
    rd_complete_c2 <= rd_complete_c1 ;
    wr_complete_c2 <= wr_complete_c1 ;	
end

reg       rd_interrupt_valid = 0;
reg [7:0] rd_interrupt_count = 0;

always @(posedge clk_i) 
begin
    if(rd_complete_c2 == 1'b1)
	  begin
	      rd_interrupt_valid <= 1'b1;
	  end
	else if(rd_interrupt_count == INTERRUPT_LENGTH)
	  begin
	      rd_interrupt_valid <= 1'b0;
	  end
	else
	  begin
	      rd_interrupt_valid <= rd_interrupt_valid;
	  end
end

always @(posedge clk_i) 
begin
    if(rd_interrupt_valid == 1'b1)
	  begin
	      rd_interrupt_count <= rd_interrupt_count + 1'b1;
	  end
	else
	  begin
	      rd_interrupt_count <= 8'd0;
	  end
end


reg       wr_interrupt_valid = 0;
reg [7:0] wr_interrupt_count = 0;

always @(posedge clk_i) 
begin
    if(wr_complete_c2 == 1'b1)
	  begin
	      wr_interrupt_valid <= 1'b1;
	  end
	else if(wr_interrupt_count == INTERRUPT_LENGTH)
	  begin
	      wr_interrupt_valid <= 1'b0;
	  end
	else
	  begin
	      wr_interrupt_valid <= wr_interrupt_valid;
	  end
end

always @(posedge clk_i) 
begin
    if(wr_interrupt_valid == 1'b1)
	  begin
	      wr_interrupt_count <= wr_interrupt_count + 1'b1;
	  end
	else
	  begin
	      wr_interrupt_count <= 8'd0;
	  end
end

always @(posedge clk_i) 
begin
    rd_complete_o <= rd_interrupt_valid ;
	wr_complete_o <= wr_interrupt_valid ;
end





assign chain_wr_en = reg_chain_en ;
assign chain_data_o = reg_data_o ;   
assign fifo_rd_o = reg_rd ;
assign busy_o = reg_busy_tx ;
assign fifo_wr_o = reg_fifo_wr ;
assign chain_rd_data_o =  reg_chain_rd_data  ;

assign awmf_0165_busy = (reg_cst != ST_IDLE ) ? 1'b1 : 1'b0 ;

//-------------------------------------debug------------------------------------------------
reg     [31:0]  read_flag_cnt_debug = 'd0;
reg cpie_i_d1 = 'd0 ;
reg cpie_i_d2 = 'd0 ;
reg [31:0]  cpie_i_cnt= 'd0 ;

always @(posedge clk_i) begin
    cpie_i_d1 <= cpie_i ;
    cpie_i_d2 <= cpie_i_d1;
end

always @(posedge clk_i) begin
    if(~cpie_i_d1 && cpie_i_d2)
        cpie_i_cnt <= cpie_i_cnt + 1'b1 ;
    else 
        cpie_i_cnt <= cpie_i_cnt; 
end

always @(posedge clk_i)
begin
    if(read_flag)
        read_flag_cnt_debug <= read_flag_cnt_debug + 1'b1 ; 
    else 
        read_flag_cnt_debug <= read_flag_cnt_debug ;
end

endmodule

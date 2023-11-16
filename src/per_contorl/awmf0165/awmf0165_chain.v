`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/25/2022 09:32:02 AM
// Design Name: 
// Module Name: awmf0165_chain
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


module awmf0165_chain(
    input clk_i,//10~100M
    input rst_i,// 1 for reset 
    input tx_en_i, // rising edge for latch sending data
    input [1:0] tx_mode_i, //01:for 60*4bits send , 11 for 60bits send ,10:for 34bits parallel mode
    input  [239:0] tx_data_i,//for update tx data
    output [239:0] rx_data_o, //serial to parallel data
    output tx_busy,//1 for busy ,0 for idle
    input awmf_sdi_i, //serial input 
    output awmf_sdi_o, //serial out
    output awmf_pdi_o, //parallel data out,34bits mode
    output awmf_ldb_o,
    output awmf_csb_o,
    output awmf_clk_o
    );
    
//     wire [239:0] tx_data_test;
//    assign tx_data_test = tx_data_i ;
//     wire awmf_sdi_i_test;
//    assign awmf_sdi_i_test = awmf_sdi_i ;
        
    parameter [7:0] CS_CLK_DELAY = 8'd10 -1 ;
    parameter [7:0] CLK_CS_DELAY = 8'd5 -1;
    parameter [7:0] CS_LDB_DELAY = 8'd7-1;
    parameter [7:0] LDB_DELAY = 8'd9-1;
    
    parameter [7:0] SEND_DELAY = 8'd5 -1; //Delay between bytes
   // parameter [7:0] SEND_DELAY = 0;
    parameter [7:0] PER_BYTE_BITS =8'd10 -1 ;
    
    parameter [2:0] SEND_IDLE_ST = 3'h00 ;
    parameter [2:0] SEND_START_ST = 3'h01;
    parameter [2:0] CLK_DELAY_ST  = 3'h02;
    parameter [2:0] SEND_BYTE_ST =  3'h03;
    parameter [2:0] SEND_DELAY_ST = 3'h04;
    parameter [2:0] SEND_END_ST  = 3'h05;
    
    parameter [1:0] CHAIN_SERIAL = 2'b01;
    parameter [1:0] PARALLEL_TX  = 2'b10 ;
    parameter [1:0] SINGLE_SERIAL_TX = 2'b11;

    reg [239:0] reg_tx_data;
    reg [239:0] reg_rx_data;
     reg [239:0] rx_data;
     reg [1:0] reg_tx_mode;
     reg [0:0] reg_tx_busy;
     reg [0:0] reg_tx_en;
     reg [0:0] reg_tx_csb;
     reg [0:0] reg_tx_sdo;
    reg [0:0] reg_tx_pdi;
     reg [0:0] reg_tx_ldb;
     reg [0:0] reg_clk_start; //for input
    reg [0:0] reg_rx_cap_cur;
    reg [0:0] reg_rx_cap_pre;
    reg [7:0] reg_delay_cnt;
    
    reg [2:0] reg_tx_cst;
    reg [2:0] reg_tx_nst;
    
    reg [7:0] tx_bits_cnt ; //tx bits
    reg [7:0] reg_tx_cnt;
    reg [7:0] reg_tx_add;
//     input  [239:0] tx_data_i;
    
    always @(negedge clk_i) begin
        if( 1 == rst_i ) begin
//            reg_tx_data <= 0;
            reg_tx_mode <= 0 ;
            reg_tx_en <= 0;
        end 
        else 
            if(  1 == tx_en_i ) begin
                reg_tx_mode <= tx_mode_i;
                reg_tx_en <= 1 ;
            end
            else if ( 1 == reg_tx_busy ) //data has been sending
                reg_tx_en <= 0 ;
            else ;
    end
    
    always @(*) begin // todo:when tx_bits_cnt setted value in latch block,this bock will not work?
        case (reg_tx_mode)
            CHAIN_SERIAL:tx_bits_cnt=60*4;
            PARALLEL_TX:tx_bits_cnt=34;
            SINGLE_SERIAL_TX:tx_bits_cnt=60;
            default:
            tx_bits_cnt = 0 ;
        endcase
    end
    
    always @(negedge clk_i) begin
        if( 1==rst_i ) begin
            reg_tx_cst <= SEND_IDLE_ST ;
        end
        else
            reg_tx_cst <= reg_tx_nst ;
        
    end
    
    always @(*) begin
        case (reg_tx_cst)
            SEND_IDLE_ST:
                if( reg_tx_en == 1) 
                    reg_tx_nst = SEND_START_ST ;
                else 
                    reg_tx_nst = SEND_IDLE_ST ;
                    
            SEND_START_ST: 
                reg_tx_nst = CLK_DELAY_ST ;
                
            CLK_DELAY_ST: 
                if( reg_delay_cnt == CS_CLK_DELAY)
                    reg_tx_nst = SEND_BYTE_ST ;
                else
                    reg_tx_nst = CLK_DELAY_ST ;
                    
            SEND_BYTE_ST: 
                if ( tx_bits_cnt == reg_tx_add )  
                    reg_tx_nst =  SEND_END_ST ;
                else if( ( PER_BYTE_BITS == reg_tx_cnt ) && ( 0 != SEND_DELAY ) ) 
                    reg_tx_nst = SEND_DELAY_ST ;
                else 
                    reg_tx_nst = SEND_BYTE_ST ;
                    
            SEND_DELAY_ST: 
               if( SEND_DELAY == reg_delay_cnt ) 
                    reg_tx_nst = SEND_BYTE_ST ;
               else
                    reg_tx_nst = SEND_DELAY_ST ;
                    
            SEND_END_ST:
                if( reg_delay_cnt > LDB_DELAY ) 
                    reg_tx_nst = SEND_IDLE_ST ;
                else 
                    reg_tx_nst = SEND_END_ST ;
            
            default: ;    
            endcase
    end
    
    always @(negedge clk_i) begin
        if( 1==rst_i ) begin
            reg_tx_csb <= 1 ;
            reg_tx_ldb <= 1 ;
            reg_delay_cnt <= 0 ;
            reg_tx_cnt <= 0 ;
            reg_tx_add <= 0 ;
            reg_tx_busy <= 0 ;
			reg_tx_pdi <= 0 ;
            reg_clk_start <= 'd0 ;
        end else 
        case (reg_tx_cst)
            SEND_IDLE_ST:begin
                reg_tx_csb <= 1 ;
                reg_tx_ldb <= 1 ;
                reg_delay_cnt <= 0 ;
                reg_tx_cnt <= 0;
                reg_tx_add <= 0 ;
                reg_tx_busy <= 0;
                reg_tx_sdo <= 0;
				reg_tx_pdi <= 0;
            end
            
            SEND_START_ST:begin
                reg_tx_csb <= 0 ;
                reg_tx_busy <= 1 ;
                reg_tx_data <= tx_data_i ;
//                reg_tx_en <= 0 ;
            end
                
            CLK_DELAY_ST:begin
                reg_delay_cnt <= reg_delay_cnt +1 ;
                if( CS_CLK_DELAY == reg_delay_cnt )begin
                    reg_delay_cnt <= 0 ;
                end
                else 
                    reg_clk_start <=0 ;
            end  
                  
            SEND_BYTE_ST:begin
                if ( tx_bits_cnt != reg_tx_add ) begin 
                     reg_clk_start <= 1 ; 
                     case (reg_tx_mode)
                        CHAIN_SERIAL:begin
                            reg_tx_sdo <= reg_tx_data[239];
                            reg_tx_data <= {reg_tx_data[238:0],reg_tx_data[239]};
                            reg_tx_cnt <= reg_tx_cnt+1;
                            reg_tx_add <= reg_tx_add+1;
                        end
                        
                        PARALLEL_TX:begin
                            reg_tx_pdi <= reg_tx_data[33];
                            reg_tx_data <= { reg_tx_data[32:0],reg_tx_data[33]};
                            reg_tx_cnt <= reg_tx_cnt+1;
                            reg_tx_add <= reg_tx_add+1;
                        end
                        
                        SINGLE_SERIAL_TX: begin
                            reg_tx_sdo <= reg_tx_data[59];
                            reg_tx_data <= { reg_tx_data[58:0],reg_tx_data[59]};
                            reg_tx_cnt <= reg_tx_cnt+1;
                            reg_tx_add <= reg_tx_add+1;
                        end
                        default:begin
                            reg_tx_sdo <= reg_tx_data[59];
                            reg_tx_data <= { reg_tx_data[58:0],reg_tx_data[59]};
                            reg_tx_cnt <= reg_tx_cnt+1;
                            reg_tx_add <= reg_tx_add+1;
                        end
                       endcase 
                  end
                  else 
                    reg_clk_start <= 0 ;       
            end
            
            SEND_DELAY_ST:begin
                if( SEND_DELAY == reg_delay_cnt ) begin
                    reg_delay_cnt <= 0;
                end
                else begin
                    reg_clk_start <= 0 ;
                    reg_tx_cnt <= 0 ;
                    reg_delay_cnt <= reg_delay_cnt +1 ;                
                end
            end 
            
            SEND_END_ST:begin
                reg_clk_start <= 0 ;
                reg_delay_cnt <= reg_delay_cnt +1 ;
                if( CLK_CS_DELAY == reg_delay_cnt ) begin
                    reg_tx_csb <= 1 ;
                    reg_tx_data <= 0 ;
                end
                else if ( CS_LDB_DELAY == reg_delay_cnt ) 
                    reg_tx_ldb <= 0 ;
            end   
        default:begin
                reg_tx_csb <= 1 ;
                reg_tx_ldb <= 1 ;
                reg_delay_cnt <= 0 ;
                reg_tx_cnt <= 0;
                reg_tx_add <= 0 ;
                reg_tx_busy <= 0;
                reg_tx_sdo <= 1;
        end
        endcase
    end
    
    always @(negedge clk_i) begin
        reg_rx_cap_cur <= reg_tx_csb;
        reg_rx_cap_pre <= reg_rx_cap_cur ;
    end
    
     wire cs_falling = ( ( reg_rx_cap_cur == 0 ) && ( reg_rx_cap_pre == 1 ) );
     wire cs_rising = ( ( reg_rx_cap_cur == 1 ) && ( reg_rx_cap_pre == 0 ) );
    reg reg_sdi_temp;
    
    always @(negedge clk_i) begin
        if( 1 == rst_i ) begin
            rx_data <= 0 ;
            reg_sdi_temp <= 0;
        end
        else if( reg_clk_start == 1) begin
            reg_sdi_temp <= awmf_sdi_i ;
            rx_data <= { rx_data[238:0],reg_sdi_temp};
        end 
        else if( 1 == cs_falling )  
            rx_data <= 0 ;        
    end
    
    always @(negedge clk_i) begin
        if( 1 == rst_i )
            reg_rx_data <= 0 ;
        else if( 1 == cs_rising )    
          reg_rx_data <= rx_data ;       
    end
    
    assign awmf_clk_o = reg_clk_start & clk_i ;
    assign awmf_sdi_o = reg_tx_sdo ;
    assign awmf_pdi_o = reg_tx_pdi ;
    assign awmf_ldb_o = reg_tx_ldb ;   
    assign awmf_csb_o = reg_tx_csb ; 
    assign tx_busy = reg_tx_busy ;
    assign rx_data_o = reg_rx_data ;
    
endmodule

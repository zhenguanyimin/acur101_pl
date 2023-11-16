`timescale 1ns / 1ps


module calc_rng_win
(
	input             clk                 ,
    input             rst               ,
                                          
    input             log2_data_vld       ,
    input      [15:0] log2_data           ,
                                      
    output reg        log2_data_vld_o = 0 ,
    output reg [15:0] log2_data_o     = 0 ,
             
    output reg        rng_win_vld = 0 ,
    output reg [15:0] win_data0   = 0 ,
    output reg [15:0] win_data1   = 0 ,
    output reg [15:0] win_data2   = 0 ,
    output reg [15:0] win_data3   = 0 ,
    output reg [15:0] win_data4   = 0 ,
    output reg [15:0] win_data5   = 0 ,
    output reg [15:0] win_data6   = 0 ,
    output reg [15:0] win_data7   = 0 ,
    output reg [15:0] win_data8   = 0 ,
    output reg [15:0] win_data9   = 0 ,
    output reg [15:0] win_data10  = 0 ,
    output reg [15:0] win_data11  = 0 ,
    output reg [15:0] win_data12  = 0 ,
    output reg [15:0] win_data13  = 0 ,
    output reg [15:0] win_data14  = 0 ,
    output reg [15:0] win_data15  = 0 ,
    output reg [15:0] win_data16  = 0 ,
    output reg [15:0] win_data17  = 0 ,
    output reg [15:0] win_data18  = 0 ,
    output reg [15:0] win_data19  = 0 ,
    output reg [15:0] win_data20  = 0 ,
    output reg [15:0] win_data21  = 0 ,
    output reg [15:0] win_data22  = 0 ,
    output reg [15:0] win_data23  = 0 ,
    output reg [15:0] win_data24  = 0 ,
    output reg [15:0] win_data25  = 0 ,
    output reg [15:0] win_data26  = 0 ,
    output reg [15:0] win_data27  = 0 ,
    output reg [15:0] win_data28  = 0 ,
    output reg [15:0] win_data29  = 0 ,
    output reg [15:0] win_data30  = 0 ,
    output reg [15:0] win_data31  = 0 ,
    output reg [15:0] win_data32  = 0 ,
    output reg [15:0] win_data33  = 0 ,
    output reg [15:0] win_data34  = 0 ,
    output reg [15:0] win_data35  = 0 ,
    output reg [15:0] win_data36  = 0 
    
    
	
);

parameter CFAR_MODE = 4'd2;//0:CA;1:SO;2:GO;
parameter CALCULATE_NUM = 5'd4;//4/8/16;


reg log2_data_vld_c1 = 0;
reg log2_data_vld_c2 = 0;
reg log2_data_vld_c3 = 0;
reg log2_data_vld_c4 = 0;
reg log2_data_vld_c5 = 0;
reg log2_data_vld_c6 = 0;
reg log2_data_vld_c7 = 0;
reg log2_data_vld_c8 = 0;
reg log2_data_vld_c9 = 0;
reg log2_data_vld_c10= 0;
reg log2_data_vld_c11= 0;
reg log2_data_vld_c12= 0;
reg log2_data_vld_c13= 0;
reg log2_data_vld_c14= 0;
reg log2_data_vld_c15= 0;
reg log2_data_vld_c16= 0;
reg log2_data_vld_c17= 0;
reg log2_data_vld_c18= 0;
reg log2_data_vld_c19= 0;
reg log2_data_vld_c20= 0;
reg log2_data_vld_c21= 0;
reg log2_data_vld_c22= 0;
reg log2_data_vld_c23= 0;
reg log2_data_vld_c24= 0;
reg log2_data_vld_c25= 0;
reg log2_data_vld_c26= 0;
reg log2_data_vld_c27= 0;
reg log2_data_vld_c28= 0;
reg log2_data_vld_c29= 0;
reg log2_data_vld_c30= 0;
reg log2_data_vld_c31= 0;
reg log2_data_vld_c32= 0;
reg log2_data_vld_c33= 0;
reg log2_data_vld_c34= 0;
reg log2_data_vld_c35= 0;
reg log2_data_vld_c36= 0;
reg log2_data_vld_c37= 0;





reg [15:0] log2_data_c1 = 0;
reg [15:0] log2_data_c2 = 0;
reg [15:0] log2_data_c3 = 0;
reg [15:0] log2_data_c4 = 0;
reg [15:0] log2_data_c5 = 0;
reg [15:0] log2_data_c6 = 0;
reg [15:0] log2_data_c7 = 0;
reg [15:0] log2_data_c8 = 0;
reg [15:0] log2_data_c9 = 0;
reg [15:0] log2_data_c10= 0;
reg [15:0] log2_data_c11= 0;
reg [15:0] log2_data_c12= 0;
reg [15:0] log2_data_c13= 0;
reg [15:0] log2_data_c14= 0;
reg [15:0] log2_data_c15= 0;
reg [15:0] log2_data_c16= 0;
reg [15:0] log2_data_c17= 0;
reg [15:0] log2_data_c18= 0;
reg [15:0] log2_data_c19= 0;
reg [15:0] log2_data_c20= 0;
reg [15:0] log2_data_c21= 0;
reg [15:0] log2_data_c22= 0;
reg [15:0] log2_data_c23= 0;
reg [15:0] log2_data_c24= 0;
reg [15:0] log2_data_c25= 0;
reg [15:0] log2_data_c26= 0;
reg [15:0] log2_data_c27= 0;
reg [15:0] log2_data_c28= 0;
reg [15:0] log2_data_c29= 0;
reg [15:0] log2_data_c30= 0;
reg [15:0] log2_data_c31= 0;
reg [15:0] log2_data_c32= 0;
reg [15:0] log2_data_c33= 0;
reg [15:0] log2_data_c34= 0;
reg [15:0] log2_data_c35= 0;
reg [15:0] log2_data_c36= 0;
reg [15:0] log2_data_c37= 0;












wire vld_pos;
assign vld_pos = ~log2_data_vld_c2 && log2_data_vld_c1;

reg [7:0] row_num = 0;
always @ (posedge clk)
begin
    if(row_num == 32 && vld_pos == 1'b1)
      begin
          row_num <= 'd1;
      end
    else if(vld_pos == 1'b1)
      begin
          row_num <= row_num + 1'b1;
      end
    else
      begin
          row_num <= row_num;
      end
end
          

reg [15:0] col_num = 0;
always @ (posedge clk)
begin
    if(log2_data_vld_c1 == 1'b1)
      begin
          col_num <= col_num + 1'b1;
      end
    else
      begin
          col_num <= 'd0;
      end
end



always @ (posedge clk)
begin
    if(log2_data_vld == 1'b1)
      begin
          log2_data_c1 <= log2_data;
      end
    else
      begin
          log2_data_c1 <= 'd0;
      end
end



always @ (posedge clk)
begin
    log2_data_c2  <= log2_data_c1  ;
    log2_data_c3  <= log2_data_c2  ;
    log2_data_c4  <= log2_data_c3  ;
    log2_data_c5  <= log2_data_c4  ;
    log2_data_c6  <= log2_data_c5  ;
    log2_data_c7  <= log2_data_c6  ;
    log2_data_c8  <= log2_data_c7  ;
    log2_data_c9  <= log2_data_c8  ;
    log2_data_c10 <= log2_data_c9  ;
    log2_data_c11 <= log2_data_c10 ;
    log2_data_c12 <= log2_data_c11 ;
    log2_data_c13 <= log2_data_c12 ;   
    log2_data_c14 <= log2_data_c13 ;   
    log2_data_c15 <= log2_data_c14 ;
    log2_data_c16 <= log2_data_c15 ;
    log2_data_c17 <= log2_data_c16 ;
    log2_data_c18 <= log2_data_c17 ;
    log2_data_c19 <= log2_data_c18 ;   
    log2_data_c20 <= log2_data_c19 ;   
    log2_data_c21 <= log2_data_c20 ;   
    log2_data_c22 <= log2_data_c21 ;   
    log2_data_c23 <= log2_data_c22 ;   
    log2_data_c24 <= log2_data_c23 ;   
    log2_data_c25 <= log2_data_c24 ;   
    log2_data_c26 <= log2_data_c25 ;   
    log2_data_c27 <= log2_data_c26 ;   
    log2_data_c28 <= log2_data_c27 ;   
    log2_data_c29 <= log2_data_c28 ;   
    log2_data_c30 <= log2_data_c29 ;   
    log2_data_c31 <= log2_data_c30 ;   
    log2_data_c32 <= log2_data_c31 ;   
    log2_data_c33 <= log2_data_c32 ;   
    log2_data_c34 <= log2_data_c33 ;   
    log2_data_c35 <= log2_data_c34 ;   
    log2_data_c36 <= log2_data_c35 ;   
    log2_data_c37 <= log2_data_c36 ;    
end


always @ (posedge clk)
begin
    log2_data_vld_c1  <= log2_data_vld     ;
    log2_data_vld_c2  <= log2_data_vld_c1  ;
    log2_data_vld_c3  <= log2_data_vld_c2  ;
    log2_data_vld_c4  <= log2_data_vld_c3  ;
    log2_data_vld_c5  <= log2_data_vld_c4  ;
    log2_data_vld_c6  <= log2_data_vld_c5  ;
    log2_data_vld_c7  <= log2_data_vld_c6  ;
    log2_data_vld_c8  <= log2_data_vld_c7  ;
    log2_data_vld_c9  <= log2_data_vld_c8  ;
    log2_data_vld_c10 <= log2_data_vld_c9  ;
    log2_data_vld_c11 <= log2_data_vld_c10 ;
    log2_data_vld_c12 <= log2_data_vld_c11 ;   
    log2_data_vld_c13 <= log2_data_vld_c12 ;   
    log2_data_vld_c14 <= log2_data_vld_c13 ;   
    log2_data_vld_c15 <= log2_data_vld_c14 ;   
    log2_data_vld_c16 <= log2_data_vld_c15 ;   
    log2_data_vld_c17 <= log2_data_vld_c16 ;   
    log2_data_vld_c18 <= log2_data_vld_c17 ;   
    log2_data_vld_c19 <= log2_data_vld_c18 ;   
    log2_data_vld_c20 <= log2_data_vld_c19 ;   
    log2_data_vld_c21 <= log2_data_vld_c20 ;   
    log2_data_vld_c22 <= log2_data_vld_c21 ;   
    log2_data_vld_c23 <= log2_data_vld_c22 ;   
    log2_data_vld_c24 <= log2_data_vld_c23 ;   
    log2_data_vld_c25 <= log2_data_vld_c24 ;   
    log2_data_vld_c26 <= log2_data_vld_c25 ;   
    log2_data_vld_c27 <= log2_data_vld_c26 ;   
    log2_data_vld_c28 <= log2_data_vld_c27 ;   
    log2_data_vld_c29 <= log2_data_vld_c28 ;   
    log2_data_vld_c30 <= log2_data_vld_c29 ;   
    log2_data_vld_c31 <= log2_data_vld_c30 ;   
    log2_data_vld_c32 <= log2_data_vld_c31 ;   
    log2_data_vld_c33 <= log2_data_vld_c32 ;   
    log2_data_vld_c34 <= log2_data_vld_c33 ;   
    log2_data_vld_c35 <= log2_data_vld_c34 ;   
    log2_data_vld_c36 <= log2_data_vld_c35 ;   
    log2_data_vld_c37 <= log2_data_vld_c36 ;   
    
    
end


always @ (posedge clk)
begin
    case(CALCULATE_NUM)
    5'd4:begin
             if(log2_data_vld_c7 == 1'b1)
               begin
                   log2_data_vld_o <= 1'b1         ;
                   log2_data_o     <= log2_data_c7 ;              
               
                   rng_win_vld <=  1'b1          ;
                   win_data0   <=  log2_data_c13 ;
                   win_data1   <=  log2_data_c12 ;
                   win_data2   <=  log2_data_c11 ;
                   win_data3   <=  log2_data_c10 ;
                   win_data4   <=  log2_data_c9  ;
                   win_data5   <=  log2_data_c8  ;
                   win_data6   <=  log2_data_c7  ;
                   win_data7   <=  log2_data_c6  ;
                   win_data8   <=  log2_data_c5  ;
                   win_data9   <=  log2_data_c4  ;
                   win_data10  <=  log2_data_c3  ;
                   win_data11  <=  log2_data_c2  ;
                   win_data12  <=  log2_data_c1  ;             
               end
             else
               begin
                   log2_data_vld_o <= 'd0;
                   log2_data_o     <= 'd0;               
                             
                   rng_win_vld <=  'd0;
                   win_data0   <=  'd0;
                   win_data1   <=  'd0;
                   win_data2   <=  'd0;
                   win_data3   <=  'd0;
                   win_data4   <=  'd0;
                   win_data5   <=  'd0;
                   win_data6   <=  'd0;
                   win_data7   <=  'd0;
                   win_data8   <=  'd0;
                   win_data9   <=  'd0;
                   win_data10  <=  'd0;
                   win_data11  <=  'd0;
                   win_data12  <=  'd0;               
               end
         end            
    
    5'd8:begin
             if(log2_data_vld_c11 == 1'b1)
               begin
                   log2_data_vld_o <= 1'b1         ;
                   log2_data_o     <= log2_data_c11;                

                   rng_win_vld <=  1'b1          ;
                   win_data0   <=  log2_data_c21 ;
                   win_data1   <=  log2_data_c20 ;
                   win_data2   <=  log2_data_c19 ;
                   win_data3   <=  log2_data_c18 ;
                   win_data4   <=  log2_data_c17 ;
                   win_data5   <=  log2_data_c16 ;
                   win_data6   <=  log2_data_c15 ;
                   win_data7   <=  log2_data_c14 ;
                   win_data8   <=  log2_data_c13 ;
                   win_data9   <=  log2_data_c12 ;
                   win_data10  <=  log2_data_c11 ;
                   win_data11  <=  log2_data_c10 ;
                   win_data12  <=  log2_data_c9  ;  
                   win_data13  <=  log2_data_c8  ;
                   win_data14  <=  log2_data_c7  ;
                   win_data15  <=  log2_data_c6  ;
                   win_data16  <=  log2_data_c5  ;        
                   win_data17  <=  log2_data_c4  ;        
                   win_data18  <=  log2_data_c3  ;        
                   win_data19  <=  log2_data_c2  ;        
                   win_data20  <=  log2_data_c1  ; 
   
               end
             else
               begin
                   log2_data_vld_o <= 'd0;
                   log2_data_o     <= 'd0;                              
               
                   rng_win_vld <=  'd0;
                   win_data0   <=  'd0;
                   win_data1   <=  'd0;
                   win_data2   <=  'd0;
                   win_data3   <=  'd0;
                   win_data4   <=  'd0;
                   win_data5   <=  'd0;
                   win_data6   <=  'd0;
                   win_data7   <=  'd0;
                   win_data8   <=  'd0;
                   win_data9   <=  'd0;
                   win_data10  <=  'd0;
                   win_data11  <=  'd0;
                   win_data12  <=  'd0;     
                   win_data13  <=  'd0;
                   win_data14  <=  'd0;
                   win_data15  <=  'd0;
                   win_data16  <=  'd0;
                   win_data17  <=  'd0;
                   win_data18  <=  'd0;
                   win_data19  <=  'd0;
                   win_data20  <=  'd0;  
               end
         end      
         
    5'd16:begin
             if(log2_data_vld_c19 == 1'b1)
               begin
                   log2_data_vld_o <= 1'b1         ;
                   log2_data_o     <= log2_data_c19;                
                              
                   rng_win_vld <=  1'b1          ;
                   win_data0   <=  log2_data_c37 ;
                   win_data1   <=  log2_data_c36 ;
                   win_data2   <=  log2_data_c35 ;
                   win_data3   <=  log2_data_c34 ;
                   win_data4   <=  log2_data_c33 ;
                   win_data5   <=  log2_data_c32 ;
                   win_data6   <=  log2_data_c31 ;
                   win_data7   <=  log2_data_c30 ;
                   win_data8   <=  log2_data_c29 ;
                   win_data9   <=  log2_data_c28 ;
                   win_data10  <=  log2_data_c27 ;
                   win_data11  <=  log2_data_c26 ;
                   win_data12  <=  log2_data_c25 ;          
                   win_data13  <=  log2_data_c24 ;
                   win_data14  <=  log2_data_c23 ;
                   win_data15  <=  log2_data_c22 ;
                   win_data16  <=  log2_data_c21 ;        
                   win_data17  <=  log2_data_c20 ;        
                   win_data18  <=  log2_data_c19 ;        
                   win_data19  <=  log2_data_c18 ;        
                   win_data20  <=  log2_data_c17 ;        
                   win_data21  <=  log2_data_c16 ;        
                   win_data22  <=  log2_data_c15 ;        
                   win_data23  <=  log2_data_c14 ;        
                   win_data24  <=  log2_data_c13 ;        
                   win_data25  <=  log2_data_c12 ;        
                   win_data26  <=  log2_data_c11 ;        
                   win_data27  <=  log2_data_c10 ;        
                   win_data28  <=  log2_data_c9  ;        
                   win_data29  <=  log2_data_c8  ;        
                   win_data30  <=  log2_data_c7  ;        
                   win_data31  <=  log2_data_c6  ;        
                   win_data32  <=  log2_data_c5  ;        
                   win_data33  <=  log2_data_c4  ;        
                   win_data34  <=  log2_data_c3  ;        
                   win_data35  <=  log2_data_c2  ;        
                   win_data36  <=  log2_data_c1  ;                                            
               end
             else
               begin
                   log2_data_vld_o <= 'd0;
                   log2_data_o     <= 'd0;                 

                   rng_win_vld <=  'd0;
                   win_data0   <=  'd0;
                   win_data1   <=  'd0;
                   win_data2   <=  'd0;
                   win_data3   <=  'd0;
                   win_data4   <=  'd0;
                   win_data5   <=  'd0;
                   win_data6   <=  'd0;
                   win_data7   <=  'd0;
                   win_data8   <=  'd0;
                   win_data9   <=  'd0;
                   win_data10  <=  'd0;
                   win_data11  <=  'd0;
                   win_data12  <=  'd0;              
                   win_data13  <=  'd0;
                   win_data14  <=  'd0;
                   win_data15  <=  'd0;
                   win_data16  <=  'd0;
                   win_data17  <=  'd0;
                   win_data18  <=  'd0;
                   win_data19  <=  'd0;
                   win_data20  <=  'd0;
                   win_data21  <=  'd0;
                   win_data22  <=  'd0;
                   win_data23  <=  'd0;
                   win_data24  <=  'd0;
                   win_data25  <=  'd0;
                   win_data26  <=  'd0;
                   win_data27  <=  'd0;
                   win_data28  <=  'd0;
                   win_data29  <=  'd0;
                   win_data30  <=  'd0;
                   win_data31  <=  'd0;
                   win_data32  <=  'd0;
                   win_data33  <=  'd0;
                   win_data34  <=  'd0;
                   win_data35  <=  'd0;
                   win_data36  <=  'd0;  
               end
          end
          
    default:;
    endcase    
            
end







endmodule




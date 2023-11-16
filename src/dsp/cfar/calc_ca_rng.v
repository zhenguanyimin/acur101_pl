`timescale 1ns / 1ps
/*
计算窗口内参考单元的平均值,
分别计算窗口内左右平均值,
然后再计算最终的窗口内参考元素的平均值,
left_aver=fix(sum_left/num),right_aver=fix(sum_right/num),
ca=fix(left_aver+right_aver)/2
go=max(left_aver,right_aver)
so=min(left_aver,right_aver)
*/

module calc_ca_rng
(
	input              clk           ,
    input              rst           ,   

    input wire         log2_data_vld ,
    input wire  [15:0] log2_data     ,
              
    input wire         rng_win_vld   ,
    input wire  [15:0] win_data0     ,
    input wire  [15:0] win_data1     ,
    input wire  [15:0] win_data2     ,
    input wire  [15:0] win_data3     ,
    input wire  [15:0] win_data4     ,
    input wire  [15:0] win_data5     ,
    input wire  [15:0] win_data6     ,
    input wire  [15:0] win_data7     ,
    input wire  [15:0] win_data8     ,
    input wire  [15:0] win_data9     ,
    input wire  [15:0] win_data10    ,
    input wire  [15:0] win_data11    ,
    input wire  [15:0] win_data12    ,
    input wire  [15:0] win_data13    ,
    input wire  [15:0] win_data14    ,
    input wire  [15:0] win_data15    ,
    input wire  [15:0] win_data16    ,
    input wire  [15:0] win_data17    ,
    input wire  [15:0] win_data18    ,
    input wire  [15:0] win_data19    ,
    input wire  [15:0] win_data20    ,
    input wire  [15:0] win_data21    ,
    input wire  [15:0] win_data22    ,
    input wire  [15:0] win_data23    ,
    input wire  [15:0] win_data24    ,
    input wire  [15:0] win_data25    ,
    input wire  [15:0] win_data26    ,
    input wire  [15:0] win_data27    ,
    input wire  [15:0] win_data28    ,
    input wire  [15:0] win_data29    ,
    input wire  [15:0] win_data30    ,
    input wire  [15:0] win_data31    ,
    input wire  [15:0] win_data32    ,
    input wire  [15:0] win_data33    ,
    input wire  [15:0] win_data34    ,
    input wire  [15:0] win_data35    ,
    input wire  [15:0] win_data36    ,  
    
    output reg         log2_data_vld_o     ,
    output reg  [15:0] log2_data_o         ,   
                                                
    output reg         rng_gate_data_vld_o ,
    output reg  [15:0] rng_gate_data_o     ,
    output reg  [15:0] rng_casogo_data_o
);


parameter CFAR_MODE = 4'd2;//0:CA;1:SO;2:GO;
parameter CALCULATE_NUM = 5'd4;//4/8/16;


parameter SNR_CFAR_Dis1 = 16'd1871; // 2~10
parameter SNR_CFAR_Dis2 = 16'd1275; // 11~40
parameter SNR_CFAR_Dis3 = 16'd1020; // 41~54
parameter SNR_CFAR_Dis4 = 16'd935 ; // 55~150
parameter SNR_CFAR_Dis5 = 16'd7650; // 151~430
parameter SNR_CFAR_Dis6 = 16'd7650; // 430~2048

reg [15:0] cnt_distance_data_o = 0;     
reg [7:0]  cnt_channel_o       = 0;   

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
end


always @ (posedge clk)
begin
    log2_data_c1  <= log2_data     ;
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
end


reg rng_win_vld_c1 = 0;
reg rng_win_vld_c2 = 0;
always @ (posedge clk)
begin
    rng_win_vld_c1 <= rng_win_vld   ;
    rng_win_vld_c2 <= rng_win_vld_c1;
end


wire vld_pos;
assign vld_pos = ~rng_win_vld_c2 && rng_win_vld_c1;

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
    if(rng_win_vld_c1 == 1'b1)
      begin
          col_num <= col_num + 1'b1;
      end
    else
      begin
          col_num <= 'd0;
      end
end






reg [39:0] rng_win_vld_dly = 0;

always @ (posedge clk)
begin
    rng_win_vld_dly <= {rng_win_vld_dly[38:0],rng_win_vld};
end



reg [15:0] left_data1 = 0;
reg [15:0] left_data2 = 0;
reg [15:0] left_data3 = 0;
reg [15:0] left_data4 = 0;//CALCULATE_NUM = 4
reg [15:0] left_data5 = 0;
reg [15:0] left_data6 = 0;
reg [15:0] left_data7 = 0;
reg [15:0] left_data8 = 0;//CALCULATE_NUM = 8
reg [15:0] left_data9 = 0;
reg [15:0] left_data10= 0;
reg [15:0] left_data11= 0;
reg [15:0] left_data12= 0;
reg [15:0] left_data13= 0;
reg [15:0] left_data14= 0;
reg [15:0] left_data15= 0;
reg [15:0] left_data16= 0;//CALCULATE_NUM = 16


reg [15:0] right_data1 = 0;
reg [15:0] right_data2 = 0;
reg [15:0] right_data3 = 0;
reg [15:0] right_data4 = 0;//CALCULATE_NUM = 4
reg [15:0] right_data5 = 0;
reg [15:0] right_data6 = 0;
reg [15:0] right_data7 = 0;
reg [15:0] right_data8 = 0;//CALCULATE_NUM = 8
reg [15:0] right_data9 = 0;
reg [15:0] right_data10= 0;
reg [15:0] right_data11= 0;
reg [15:0] right_data12= 0;
reg [15:0] right_data13= 0;
reg [15:0] right_data14= 0;
reg [15:0] right_data15= 0;
reg [15:0] right_data16= 0;//CALCULATE_NUM = 16



always @ (posedge clk)
begin
    case(CALCULATE_NUM)
    5'd4:begin
             left_data1  <= win_data0 ;
             left_data2  <= win_data1 ;
             left_data3  <= win_data2 ;
             left_data4  <= win_data3 ;
             
             right_data1 <= win_data9 ;
             right_data2 <= win_data10;
             right_data3 <= win_data11;
             right_data4 <= win_data12;
         end
        
    5'd8:begin
             left_data1  <= win_data0 ;    
             left_data2  <= win_data1 ;
             left_data3  <= win_data2 ;
             left_data4  <= win_data3 ;
             left_data5  <= win_data4 ;
             left_data6  <= win_data5 ;
             left_data7  <= win_data6 ;
             left_data8  <= win_data7 ;
             
             right_data1 <= win_data13;
             right_data2 <= win_data14;
             right_data3 <= win_data15;
             right_data4 <= win_data16;
             right_data5 <= win_data17;
             right_data6 <= win_data18;
             right_data7 <= win_data19;
             right_data8 <= win_data20;
         end
             
   5'd16:begin
             left_data1  <= win_data0 ;
             left_data2  <= win_data1 ;
             left_data3  <= win_data2 ;
             left_data4  <= win_data3 ;
             left_data5  <= win_data4 ;
             left_data6  <= win_data5 ;
             left_data7  <= win_data6 ;
             left_data8  <= win_data7 ;             
             left_data9  <= win_data8 ;
             left_data10 <= win_data9 ;
             left_data11 <= win_data10;
             left_data12 <= win_data11;
             left_data13 <= win_data12;
             left_data14 <= win_data13;
             left_data15 <= win_data14;
             left_data16 <= win_data15;
             
             
             right_data1 <= win_data21;
             right_data2 <= win_data22;
             right_data3 <= win_data23;
             right_data4 <= win_data24;
             right_data5 <= win_data25;
             right_data6 <= win_data26;
             right_data7 <= win_data27;
             right_data8 <= win_data28;            
             right_data9 <= win_data29;
             right_data10<= win_data30;
             right_data11<= win_data31;
             right_data12<= win_data32;
             right_data13<= win_data33;
             right_data14<= win_data34;
             right_data15<= win_data35;
             right_data16<= win_data36;
         end   
    
    default:;
    endcase
end   

//CALCULATE_NUM = 4
wire [16:0] left_add_data12;
u16_add_u16 uleft_add12 (
  .A  (left_data1     ),  // input wire [15 : 0] A
  .B  (left_data2     ),  // input wire [15 : 0] B
  .CLK(clk            ),  // input wire CLK
  .S  (left_add_data12)   // output wire [16 : 0] S
);


wire [16:0] left_add_data34;
u16_add_u16 uleft_add34 (
  .A  (left_data3     ),  // input wire [15 : 0] A
  .B  (left_data4     ),  // input wire [15 : 0] B
  .CLK(clk            ),  // input wire CLK
  .S  (left_add_data34)   // output wire [16 : 0] S
);

//CALCULATE_NUM = 8
wire [16:0] left_add_data56;
u16_add_u16 uleft_add56 (
  .A  (left_data5     ),  // input wire [15 : 0] A
  .B  (left_data6     ),  // input wire [15 : 0] B
  .CLK(clk            ),  // input wire CLK
  .S  (left_add_data56)   // output wire [16 : 0] S
);


wire [16:0] left_add_data78;
u16_add_u16 uleft_add78 (
  .A  (left_data7     ),  // input wire [15 : 0] A
  .B  (left_data8     ),  // input wire [15 : 0] B
  .CLK(clk            ),  // input wire CLK
  .S  (left_add_data78)   // output wire [16 : 0] S
);

//CALCULATE_NUM = 16
wire [16:0] left_add_data910;
u16_add_u16 uleft_add910 (
  .A  (left_data9      ),  // input wire [15 : 0] A
  .B  (left_data10     ),  // input wire [15 : 0] B
  .CLK(clk             ),  // input wire CLK
  .S  (left_add_data910)   // output wire [16 : 0] S
);

wire [16:0] left_add_data1112;
u16_add_u16 uleft_add1112 (
  .A  (left_data11      ),  // input wire [15 : 0] A
  .B  (left_data12      ),  // input wire [15 : 0] B
  .CLK(clk              ),  // input wire CLK
  .S  (left_add_data1112)   // output wire [16 : 0] S
);

wire [16:0] left_add_data1314;
u16_add_u16 uleft_add1314 (
  .A  (left_data13      ),  // input wire [15 : 0] A
  .B  (left_data14      ),  // input wire [15 : 0] B
  .CLK(clk              ),  // input wire CLK
  .S  (left_add_data1314)   // output wire [16 : 0] S
);


wire [16:0] left_add_data1516;
u16_add_u16 uleft_add1516 (
  .A  (left_data15      ),  // input wire [15 : 0] A
  .B  (left_data16      ),  // input wire [15 : 0] B
  .CLK(clk              ),  // input wire CLK
  .S  (left_add_data1516)   // output wire [16 : 0] S
);




wire [17:0] left_add_data1234;
u17_add_u17 uleft_add1234 (
  .A  (left_add_data12     ),  // input wire [16 : 0] A
  .B  (left_add_data34     ),  // input wire [16 : 0] B
  .CLK(clk                 ),  // input wire CLK
  .S  (left_add_data1234   )   // output wire [17 : 0] S
);


wire [17:0] left_add_data5678;
u17_add_u17 uleft_add5678 (
  .A  (left_add_data56     ),  // input wire [16 : 0] A
  .B  (left_add_data78     ),  // input wire [16 : 0] B
  .CLK(clk                 ),  // input wire CLK
  .S  (left_add_data5678   )   // output wire [17 : 0] S
);


wire [17:0] left_add_data9101112;
u17_add_u17 uleft_add9101112 (
  .A  (left_add_data910     ),  // input wire [16 : 0] A
  .B  (left_add_data1112    ),  // input wire [16 : 0] B
  .CLK(clk                  ),  // input wire CLK
  .S  (left_add_data9101112 )   // output wire [17 : 0] S
);


wire [17:0] left_add_data13141516;
u17_add_u17 uleft_add13141516 (
  .A  (left_add_data1314     ),  // input wire [16 : 0] A
  .B  (left_add_data1516     ),  // input wire [16 : 0] B
  .CLK(clk                   ),  // input wire CLK
  .S  (left_add_data13141516 )   // output wire [17 : 0] S
);



wire [18:0] left_add_data_sum1_8;
u18_add_u18 uleft_sum1_8 (
  .A  (left_add_data1234     ),  // input wire [17 : 0] A
  .B  (left_add_data5678     ),  // input wire [17 : 0] B
  .CLK(clk                   ),  // input wire CLK
  .S  (left_add_data_sum1_8  )   // output wire [18 : 0] S
);


wire [18:0] left_add_data_sum9_16;
u18_add_u18 uleft_sum9_16 (
  .A  (left_add_data9101112  ),  // input wire [17 : 0] A
  .B  (left_add_data13141516 ),  // input wire [17 : 0] B
  .CLK(clk                   ),  // input wire CLK
  .S  (left_add_data_sum9_16 )   // output wire [18 : 0] S
);


wire [19:0] left_add_data_sum1_16;
u19_add_u19 uleft_sum1_16 (
  .A  (left_add_data_sum1_8  ),  // input wire [18 : 0] A
  .B  (left_add_data_sum9_16 ),  // input wire [18 : 0] B
  .CLK(clk                   ),  // input wire CLK
  .S  (left_add_data_sum1_16 )   // output wire [19 : 0] S
);





reg [15:0] rng_ca_left = 0;

always @ (posedge clk)
begin
    case(CALCULATE_NUM)
    5'd4:begin
             rng_ca_left <= left_add_data1234[17:2];
         end
         
    5'd8:begin
             rng_ca_left <= left_add_data_sum1_8[18:3];
         end
         
   5'd16:begin
             rng_ca_left <= left_add_data_sum1_16[19:4];
         end
         
         
    default:;
    endcase
end


//CALCULATE_NUM = 4
wire [16:0] right_add_data12;
u16_add_u16 uright_add12 (
  .A  (right_data1     ),  // input wire [15 : 0] A
  .B  (right_data2     ),  // input wire [15 : 0] B
  .CLK(clk             ),  // input wire CLK
  .S  (right_add_data12)   // output wire [16 : 0] S
);


wire [16:0] right_add_data34;
u16_add_u16 uright_add34 (
  .A  (right_data3     ),  // input wire [15 : 0] A
  .B  (right_data4     ),  // input wire [15 : 0] B
  .CLK(clk             ),  // input wire CLK
  .S  (right_add_data34)   // output wire [16 : 0] S
);


//CALCULATE_NUM = 8

wire [16:0] right_add_data56;
u16_add_u16 uright_add56 (
  .A  (right_data5     ),  // input wire [15 : 0] A
  .B  (right_data6     ),  // input wire [15 : 0] B
  .CLK(clk             ),  // input wire CLK
  .S  (right_add_data56)   // output wire [16 : 0] S
);


wire [16:0] right_add_data78;
u16_add_u16 uright_add78 (
  .A  (right_data7     ),  // input wire [15 : 0] A
  .B  (right_data8     ),  // input wire [15 : 0] B
  .CLK(clk             ),  // input wire CLK
  .S  (right_add_data78)   // output wire [16 : 0] S
);


wire [16:0] right_add_data910;
u16_add_u16 uright_add910 (
  .A  (right_data9      ),  // input wire [15 : 0] A
  .B  (right_data10     ),  // input wire [15 : 0] B
  .CLK(clk              ),  // input wire CLK
  .S  (right_add_data910)   // output wire [16 : 0] S
);


wire [16:0] right_add_data1112;
u16_add_u16 uright_add1112 (
  .A  (right_data11      ),  // input wire [15 : 0] A
  .B  (right_data12      ),  // input wire [15 : 0] B
  .CLK(clk               ),  // input wire CLK
  .S  (right_add_data1112)   // output wire [16 : 0] S
);


wire [16:0] right_add_data1314;
u16_add_u16 uright_add1314 (
  .A  (right_data13      ),  // input wire [15 : 0] A
  .B  (right_data14      ),  // input wire [15 : 0] B
  .CLK(clk               ),  // input wire CLK
  .S  (right_add_data1314)   // output wire [16 : 0] S
);


wire [16:0] right_add_data1516;
u16_add_u16 uright_add1516 (
  .A  (right_data15      ),  // input wire [15 : 0] A
  .B  (right_data16      ),  // input wire [15 : 0] B
  .CLK(clk               ),  // input wire CLK
  .S  (right_add_data1516)   // output wire [16 : 0] S
);




wire [17:0] right_add_data1234;
u17_add_u17 uright_add1234 (
  .A  (right_add_data12     ),  // input wire [16 : 0] A
  .B  (right_add_data34     ),  // input wire [16 : 0] B
  .CLK(clk                  ),  // input wire CLK
  .S  (right_add_data1234   )   // output wire [17 : 0] S
);


wire [17:0] right_add_data5678;
u17_add_u17 uright_add5678 (
  .A  (right_add_data56     ),  // input wire [16 : 0] A
  .B  (right_add_data78     ),  // input wire [16 : 0] B
  .CLK(clk                  ),  // input wire CLK
  .S  (right_add_data5678   )   // output wire [17 : 0] S
);


wire [17:0] right_add_data9101112;
u17_add_u17 uright_add9101112 (
  .A  (right_add_data910     ),  // input wire [16 : 0] A
  .B  (right_add_data1112    ),  // input wire [16 : 0] B
  .CLK(clk                   ),  // input wire CLK
  .S  (right_add_data9101112 )   // output wire [17 : 0] S
);


wire [17:0] right_add_data13141516;
u17_add_u17 uright_add13141516 (
  .A  (right_add_data1314     ),  // input wire [16 : 0] A
  .B  (right_add_data1516     ),  // input wire [16 : 0] B
  .CLK(clk                    ),  // input wire CLK
  .S  (right_add_data13141516 )   // output wire [17 : 0] S
);



wire [18:0] right_add_data_sum1_8;
u18_add_u18 uright_sum1_8 (
  .A  (right_add_data1234     ),  // input wire [17 : 0] A
  .B  (right_add_data5678     ),  // input wire [17 : 0] B
  .CLK(clk                    ),  // input wire CLK
  .S  (right_add_data_sum1_8  )   // output wire [18 : 0] S
);


wire [18:0] right_add_data_sum9_16;
u18_add_u18 uright_sum9_16 (
  .A  (right_add_data9101112  ),  // input wire [17 : 0] A
  .B  (right_add_data13141516 ),  // input wire [17 : 0] B
  .CLK(clk                    ),  // input wire CLK
  .S  (right_add_data_sum9_16 )   // output wire [18 : 0] S
);


wire [19:0] right_add_data_sum1_16;
u19_add_u19 uright_sum1_16 (
  .A  (right_add_data_sum1_8  ),  // input wire [18 : 0] A
  .B  (right_add_data_sum9_16 ),  // input wire [18 : 0] B
  .CLK(clk                    ),  // input wire CLK
  .S  (right_add_data_sum1_16 )   // output wire [19 : 0] S
);




reg [15:0] rng_ca_right = 0;

always @ (posedge clk)
begin
    case(CALCULATE_NUM)
    5'd4:begin
             rng_ca_right <= right_add_data1234[17:2];
         end
         
    5'd8:begin
             rng_ca_right <= right_add_data_sum1_8[18:3];
         end             
                
   5'd16:begin
             rng_ca_right <= right_add_data_sum1_16[19:4];             
         end   
         
         
         
    default:;
    endcase
end





wire [16:0] ca_add_data;
u16_add_u16 uca_add (
  .A  (rng_ca_left     ),  // input wire [15 : 0] A
  .B  (rng_ca_right    ),  // input wire [15 : 0] B
  .CLK(clk             ),  // input wire CLK
  .S  (ca_add_data     )   // output wire [16 : 0] S
);


reg rng_casogo_data_vld = 0;
reg [15:0] rng_casogo_data = 0;

reg log2_data_vld_dly = 0;
reg [15:0] log2_data_dly = 0;    

always @ (posedge clk)
begin
    case(CALCULATE_NUM)
    5'd4:begin
             case(CFAR_MODE)
             2'd0:begin//ca
                      if(rng_win_vld_dly[7] == 1'b1)
                        begin
                            rng_casogo_data_vld <= 1'b1;
                            rng_casogo_data     <= ca_add_data[16:1];
                            
                            log2_data_vld_dly <= 1'b1  ;
                            log2_data_dly     <= log2_data_c8;                           
                        end
                      else
                        begin
                            rng_casogo_data_vld <= 'd0;
                            rng_casogo_data     <= 'd0;
                            
                            log2_data_vld_dly   <= 'd0;
                            log2_data_dly       <= 'd0;
                        end
                  end
                  
             2'd1:begin//so
                      if(rng_win_vld_dly[5] == 1'b1)
                        begin
                            rng_casogo_data_vld <= 1'b1;
                            rng_casogo_data     <= rng_ca_left > rng_ca_right ? rng_ca_right : rng_ca_left;
                            
                            log2_data_vld_dly <= 1'b1  ;
                            log2_data_dly     <= log2_data_c6;
                        end
                      else
                        begin
                            rng_casogo_data_vld <= 'd0;
                            rng_casogo_data     <= 'd0;
                            
                            log2_data_vld_dly   <= 'd0;
                            log2_data_dly       <= 'd0;             
                        end            
                  end
             
                  
             2'd2:begin//go
                      if(rng_win_vld_dly[5] == 1'b1)
                        begin
                            rng_casogo_data_vld <= 1'b1;
                            rng_casogo_data     <= rng_ca_left > rng_ca_right ? rng_ca_left : rng_ca_right;
                            
                            log2_data_vld_dly <= 1'b1  ;
                            log2_data_dly     <= log2_data_c6;                            
                        end
                      else
                        begin
                            rng_casogo_data_vld <= 'd0;
                            rng_casogo_data     <= 'd0;
                            
                            log2_data_vld_dly   <= 'd0;
                            log2_data_dly       <= 'd0;                            
                        end
                  end
             
             
             
 
             default:;
             endcase
               
         end

    5'd8:begin
             case(CFAR_MODE)             
             2'd0:begin//ca
                      if(rng_win_vld_dly[9] == 1'b1)
                        begin
                            rng_casogo_data_vld <= 1'b1;
                            rng_casogo_data     <= ca_add_data[16:1];
                            
                            log2_data_vld_dly <= 1'b1  ;
                            log2_data_dly     <= log2_data_c10;                            
                        end
                      else
                        begin
                            rng_casogo_data_vld <= 'd0;
                            rng_casogo_data     <= 'd0;
                            
                            log2_data_vld_dly   <= 'd0;
                            log2_data_dly       <= 'd0; 
                        end
                  end

             2'd1:begin//so
                      if(rng_win_vld_dly[7] == 1'b1)
                        begin
                            rng_casogo_data_vld <= 1'b1;
                            rng_casogo_data     <= rng_ca_left > rng_ca_right ? rng_ca_right : rng_ca_left;
                            
                            log2_data_vld_dly <= 1'b1  ;
                            log2_data_dly     <= log2_data_c8;
                        end
                      else
                        begin
                            rng_casogo_data_vld <= 'd0;
                            rng_casogo_data     <= 'd0;
                            
                            log2_data_vld_dly   <= 'd0;
                            log2_data_dly       <= 'd0;
                        end
                  end            
             
             2'd2:begin//go
                      if(rng_win_vld_dly[7] == 1'b1)
                        begin
                            rng_casogo_data_vld <= 1'b1;
                            rng_casogo_data     <= rng_ca_left > rng_ca_right ? rng_ca_left : rng_ca_right;
                            
                            log2_data_vld_dly <= 1'b1  ;
                            log2_data_dly     <= log2_data_c8;
                        end
                      else
                        begin
                            rng_casogo_data_vld <= 'd0;
                            rng_casogo_data     <= 'd0;
                            
                            log2_data_vld_dly   <= 'd0;
                            log2_data_dly       <= 'd0;
                        end
                  end
             
             
             
             default:;
             endcase
         end


   5'd16:begin
             case(CFAR_MODE)
             2'd0:begin//ca
                      if(rng_win_vld_dly[11] == 1'b1)
                        begin
                            rng_casogo_data_vld <= 1'b1;
                            rng_casogo_data     <= ca_add_data[16:1];
                            
                            log2_data_vld_dly <= 1'b1  ;
                            log2_data_dly     <= log2_data_c12;                           
                        end
                      else
                        begin
                            rng_casogo_data_vld <= 'd0;
                            rng_casogo_data     <= 'd0;
                            
                            log2_data_vld_dly   <= 'd0;
                            log2_data_dly       <= 'd0;
                        end
                  end
             
             2'd1:begin//so
                      if(rng_win_vld_dly[9] == 1'b1)
                        begin
                            rng_casogo_data_vld <= 1'b1;
                            rng_casogo_data     <= rng_ca_left > rng_ca_right ? rng_ca_right : rng_ca_left;
                            
                            log2_data_vld_dly <= 1'b1  ;
                            log2_data_dly     <= log2_data_c10;                             
                        end
                      else
                        begin
                            rng_casogo_data_vld <= 'd0;
                            rng_casogo_data     <= 'd0;
                            
                            log2_data_vld_dly   <= 'd0;
                            log2_data_dly       <= 'd0;
                        end             
                  end
 
             2'd2:begin//go
                      if(rng_win_vld_dly[9] == 1'b1)
                        begin
                            rng_casogo_data_vld <= 1'b1;
                            rng_casogo_data     <= rng_ca_left > rng_ca_right ? rng_ca_left : rng_ca_right;
                            
                            log2_data_vld_dly <= 1'b1  ;
                            log2_data_dly     <= log2_data_c10; 
                        end
                      else
                        begin
                            rng_casogo_data_vld <= 'd0;
                            rng_casogo_data     <= 'd0;
                            
                            log2_data_vld_dly   <= 'd0;
                            log2_data_dly       <= 'd0;
                        end            
                  end
                  
             default:;
             endcase
         end
    
    default:;
    endcase
              
end


reg rng_casogo_data_vld_c1 = 0;
reg rng_casogo_data_vld_c2 = 0;
reg rng_casogo_data_vld_c3 = 0;

reg [15:0] rng_casogo_data_c1 = 0;
reg [15:0] rng_casogo_data_c2 = 0;
reg [15:0] rng_casogo_data_c3 = 0;


always @ (posedge clk)
begin
    rng_casogo_data_vld_c1 <= rng_casogo_data_vld   ;
    rng_casogo_data_vld_c2 <= rng_casogo_data_vld_c1;
    rng_casogo_data_vld_c3 <= rng_casogo_data_vld_c2;
    
    rng_casogo_data_c1     <= rng_casogo_data       ;
    rng_casogo_data_c2     <= rng_casogo_data_c1    ;   
    rng_casogo_data_c3     <= rng_casogo_data_c2    ;    
end

reg log2_data_vld_dly_c1 = 0;
reg log2_data_vld_dly_c2 = 0;
reg log2_data_vld_dly_c3 = 0;

reg [15:0] log2_data_dly_c1 = 0;  
reg [15:0] log2_data_dly_c2 = 0;  
reg [15:0] log2_data_dly_c3 = 0;  

always @ (posedge clk)
begin
    log2_data_vld_dly_c1 <= log2_data_vld_dly   ;
    log2_data_vld_dly_c2 <= log2_data_vld_dly_c1;
    log2_data_vld_dly_c3 <= log2_data_vld_dly_c2;
    
    log2_data_dly_c1     <= log2_data_dly       ;
    log2_data_dly_c2     <= log2_data_dly_c1    ;
    log2_data_dly_c3     <= log2_data_dly_c2    ;
end


wire rng_casogo_vld_pos;
assign rng_casogo_vld_pos = ~rng_casogo_data_vld_c1 && rng_casogo_data_vld;


reg [15:0] cnt_distance_data = 0;
always @ (posedge clk)
begin
    if(rng_casogo_data_vld == 1'b1)
      begin
          cnt_distance_data <= cnt_distance_data + 1'b1;
      end
    else
      begin
          cnt_distance_data <= 'd0;
      end
end


reg [7:0] cnt_channel = 0;
always @ (posedge clk)
begin
    if(cnt_channel == 'd32 && rng_casogo_vld_pos == 1'b1)
      begin
          cnt_channel <= 'd1;
      end
    else if(rng_casogo_vld_pos == 1'b1)
      begin
          cnt_channel <= cnt_channel + 1'b1;
      end
    else
      begin
          cnt_channel <= cnt_channel;
      end
end
          
          
reg [15:0] cnt_distance_data_c1 = 0;    
reg [15:0] cnt_distance_data_c2 = 0;       
reg [7:0] cnt_channel_c1 = 0;          
reg [7:0] cnt_channel_c2 = 0;      

          
always @ (posedge clk)
begin
    cnt_distance_data_c1 <= cnt_distance_data   ;
    cnt_distance_data_c2 <= cnt_distance_data_c1; 
    cnt_distance_data_o  <= cnt_distance_data_c2;
    
    cnt_channel_c1       <= cnt_channel         ;
    cnt_channel_c2       <= cnt_channel_c1      ;
    cnt_channel_o        <= cnt_channel_c2      ;
end    



reg [15:0] snr_cfar = 0;

always @ (posedge clk) 
begin		 
    if( cnt_distance_data == 'd2)
      begin
		  snr_cfar <= SNR_CFAR_Dis1;
      end
    else if(cnt_distance_data == 'd10)
      begin
		  snr_cfar <= SNR_CFAR_Dis2;
      end
    else if(cnt_distance_data == 'd70)
      begin
		  snr_cfar <= SNR_CFAR_Dis3;
      end
    else if(cnt_distance_data == 'd135)
      begin
		  snr_cfar <= SNR_CFAR_Dis4;
      end
    else if(cnt_distance_data == 'd300)
      begin
		  snr_cfar <= SNR_CFAR_Dis5;
      end
    else if(cnt_distance_data == 'd430)
      begin
		  snr_cfar <= SNR_CFAR_Dis6;
      end
    else 
      begin
		  snr_cfar <= snr_cfar;
      end
end 



wire [16:0] rng_gate_data;

u16_add_u16 ugate_data (
  .A  (rng_casogo_data_c1 ),  // input wire [15 : 0] A
  .B  (snr_cfar           ),  // input wire [15 : 0] B
  .CLK(clk                ),  // input wire CLK
  .S  (rng_gate_data      )   // output wire [16 : 0] S
);



always @ (posedge clk)
begin
    if(rng_casogo_data_vld_c3 == 1'b1)
      begin
          rng_gate_data_vld_o <= 1'b1;
          rng_gate_data_o     <= rng_gate_data[15:0];//discard
          rng_casogo_data_o   <= rng_casogo_data_c3 ;
      end
    else
      begin
          rng_gate_data_vld_o <= 'd0;
          rng_gate_data_o     <= 'd0;
          rng_casogo_data_o   <= 'd0;
      end
end



always @ (posedge clk)
begin
    if(log2_data_vld_dly_c3 == 1'b1)
      begin
          log2_data_vld_o <= 1'b1;
          log2_data_o     <= log2_data_dly_c3;
      end
    else
      begin
          log2_data_vld_o <= 'd0;
          log2_data_o     <= 'd0;
      end
end















endmodule






module calc_ca_dpl
(
    input               clk ,
    input               rst ,

    input   [16*21-1:0] win_data        ,
    input               win_data_vliad  ,

    input   [15:0]      cfar_dpl_map_addr,
    output  [15:0]      cfar_dpl_map_data

);


reg [16*21-1:0] win_data_d1 ;
reg [16*21-1:0] win_data_d2 ;
always @(posedge clk) 
begin
    if(rst) begin
        win_data_d1 <= 'd0    ;
        win_data_d2 <= 'd0    ;
    end
    else begin
        win_data_d1 <= win_data    ;
        win_data_d2 <= win_data_d1 ; 
    end 
        
end

reg [31:0]  win_data_vliad_shift ;
always @(posedge clk) 
begin
    if(rst)
        win_data_vliad_shift <= 'd0 ;
    else 
        win_data_vliad_shift <= {win_data_vliad_shift[30:0],win_data_vliad};
end


reg [16:0]   sum0_tmp0 ;
reg [16:0]   sum1_tmp0 ;
reg [16:0]   sum2_tmp0 ;
reg [16:0]   sum3_tmp0 ;
reg [16:0]   sum4_tmp0 ;
reg [16:0]   sum5_tmp0 ;

reg [16:0]   sum0_tmp1 ;
reg [16:0]   sum1_tmp1 ;

reg [16:0]   sum_result;

always @(posedge clk)
begin
    if(rst) begin
        sum0_tmp0 <= 'd0 ;
        sum1_tmp0 <= 'd0 ;
        sum2_tmp0 <= 'd0 ;
        sum3_tmp0 <= 'd0 ;
        sum4_tmp0 <= 'd0 ;
        sum5_tmp0 <= 'd0 ;       
    end
    else begin
        sum0_tmp0 <= win_data[16*1-1:0]      + win_data[16*2-1:16*1] ; 
        sum1_tmp0 <= win_data[16*3-1:16*2]   + win_data[16*4-1:16*3] ;
        sum2_tmp0 <= win_data[16*5-1:16*4]   + win_data[16*6-1:16*5] ; 
        sum3_tmp0 <= win_data[16*16-1:16*15] + win_data[16*17-1:16*16] ;
        sum4_tmp0 <= win_data[16*18-1:16*17] + win_data[16*19-1:16*18] ; 
        sum5_tmp0 <= win_data[16*20-1:16*19] + win_data[16*21-1:16*20] ;        
    end
end

always @(posedge clk)
begin
    if(rst) begin
        sum0_tmp1 <= 'd0 ;
        sum1_tmp1 <= 'd0 ;
    end
    else begin
        sum0_tmp1 <= sum0_tmp0 + sum1_tmp0 + sum2_tmp0;
        sum1_tmp1 <= sum3_tmp0 + sum4_tmp0 + sum5_tmp0;       
    end
end

always @(posedge clk)
begin
    if(rst)
        sum_result <= 'd0 ;
    else 
        sum_result <= sum0_tmp1 + sum1_tmp1 ; 
end

//--------------------------------sort-----------------------------


reg [11:0]    sort_reg0 ;
reg [11:0]    sort_reg1 ;
reg [11:0]    sort_reg2 ;
reg [11:0]    sort_reg3 ;
reg [11:0]    sort_reg4 ;
reg [11:0]    sort_reg5 ;
reg [11:0]    sort_reg6 ;
reg [11:0]    sort_reg7 ;
reg [11:0]    sort_reg8 ;
reg [11:0]    sort_reg9 ;
reg [11:0]    sort_rega ;
reg [11:0]    sort_regb ;

reg          sort_reg00;
reg          sort_reg01;
reg          sort_reg02;
reg          sort_reg03;
reg          sort_reg04;
reg          sort_reg05;
reg          sort_reg06;
reg          sort_reg07;
reg          sort_reg08;
reg          sort_reg09;
reg          sort_reg0a;
reg          sort_reg0b;

reg          sort_reg10;
reg          sort_reg11;
reg          sort_reg12;
reg          sort_reg13;
reg          sort_reg14;
reg          sort_reg15;
reg          sort_reg16;
reg          sort_reg17;
reg          sort_reg18;
reg          sort_reg19;
reg          sort_reg1a;
reg          sort_reg1b;

reg          sort_reg20;
reg          sort_reg21;
reg          sort_reg22;
reg          sort_reg23;
reg          sort_reg24;
reg          sort_reg25;
reg          sort_reg26;
reg          sort_reg27;
reg          sort_reg28;
reg          sort_reg29;
reg          sort_reg2a;
reg          sort_reg2b;

reg          sort_reg30;
reg          sort_reg31;
reg          sort_reg32;
reg          sort_reg33;
reg          sort_reg34;
reg          sort_reg35;
reg          sort_reg36;
reg          sort_reg37;
reg          sort_reg38;
reg          sort_reg39;
reg          sort_reg3a;
reg          sort_reg3b;

reg          sort_reg40;
reg          sort_reg41;
reg          sort_reg42;
reg          sort_reg43;
reg          sort_reg44;
reg          sort_reg45;
reg          sort_reg46;
reg          sort_reg47;
reg          sort_reg48;
reg          sort_reg49;
reg          sort_reg4a;
reg          sort_reg4b;

reg          sort_reg50;
reg          sort_reg51;
reg          sort_reg52;
reg          sort_reg53;
reg          sort_reg54;
reg          sort_reg55;
reg          sort_reg56;
reg          sort_reg57;
reg          sort_reg58;
reg          sort_reg59;
reg          sort_reg5a;
reg          sort_reg5b;

reg          sort_reg60;
reg          sort_reg61;
reg          sort_reg62;
reg          sort_reg63;
reg          sort_reg64;
reg          sort_reg65;
reg          sort_reg66;
reg          sort_reg67;
reg          sort_reg68;
reg          sort_reg69;
reg          sort_reg6a;
reg          sort_reg6b;

reg          sort_reg70;
reg          sort_reg71;
reg          sort_reg72;
reg          sort_reg73;
reg          sort_reg74;
reg          sort_reg75;
reg          sort_reg76;
reg          sort_reg77;
reg          sort_reg78;
reg          sort_reg79;
reg          sort_reg7a;
reg          sort_reg7b;

reg          sort_reg80;
reg          sort_reg81;
reg          sort_reg82;
reg          sort_reg83;
reg          sort_reg84;
reg          sort_reg85;
reg          sort_reg86;
reg          sort_reg87;
reg          sort_reg88;
reg          sort_reg89;
reg          sort_reg8a;
reg          sort_reg8b;

reg          sort_reg90;
reg          sort_reg91;
reg          sort_reg92;
reg          sort_reg93;
reg          sort_reg94;
reg          sort_reg95;
reg          sort_reg96;
reg          sort_reg97;
reg          sort_reg98;
reg          sort_reg99;
reg          sort_reg9a;
reg          sort_reg9b;

reg          sort_rega0;
reg          sort_rega1;
reg          sort_rega2;
reg          sort_rega3;
reg          sort_rega4;
reg          sort_rega5;
reg          sort_rega6;
reg          sort_rega7;
reg          sort_rega8;
reg          sort_rega9;
reg          sort_regaa;
reg          sort_regab;

reg          sort_regb0;
reg          sort_regb1;
reg          sort_regb2;
reg          sort_regb3;
reg          sort_regb4;
reg          sort_regb5;
reg          sort_regb6;
reg          sort_regb7;
reg          sort_regb8;
reg          sort_regb9;
reg          sort_regba;
reg          sort_regbb;

always @(posedge clk )
begin 
    sort_reg00 <= (win_data[16*1-1:0] >= win_data[16*1-1:0])? 1 : 0 ;
    sort_reg01 <= (win_data[16*1-1:0] >= win_data[16*2-1:16*1])? 1 : 0 ;
    sort_reg02 <= (win_data[16*1-1:0] >= win_data[16*3-1:16*2])? 1 : 0 ;
    sort_reg03 <= (win_data[16*1-1:0] >= win_data[16*4-1:16*3])? 1 : 0 ;
    sort_reg04 <= (win_data[16*1-1:0] >= win_data[16*5-1:16*4])? 1 : 0 ;
    sort_reg05 <= (win_data[16*1-1:0] >= win_data[16*6-1:16*5])? 1 : 0 ;
    sort_reg06 <= (win_data[16*1-1:0] >= win_data[16*16-1:16*15])? 1 : 0 ;
    sort_reg07 <= (win_data[16*1-1:0] >= win_data[16*17-1:16*16])? 1 : 0 ;
    sort_reg08 <= (win_data[16*1-1:0] >= win_data[16*18-1:16*17])? 1 : 0 ;
    sort_reg09 <= (win_data[16*1-1:0] >= win_data[16*19-1:16*18])? 1 : 0 ;
    sort_reg0a <= (win_data[16*1-1:0] >= win_data[16*20-1:16*19])? 1 : 0 ;
    sort_reg0b <= (win_data[16*1-1:0] >= win_data[16*21-1:16*20])? 1 : 0 ;

    sort_reg10 <= (win_data[16*2-1:16*1] >= win_data[16*1-1:0])? 1 : 0 ;
    sort_reg11 <= (win_data[16*2-1:16*1] >= win_data[16*2-1:16*1])? 1 : 0 ;
    sort_reg12 <= (win_data[16*2-1:16*1] >= win_data[16*3-1:16*2])? 1 : 0 ;
    sort_reg13 <= (win_data[16*2-1:16*1] >= win_data[16*4-1:16*3])? 1 : 0 ;
    sort_reg14 <= (win_data[16*2-1:16*1] >= win_data[16*5-1:16*4])? 1 : 0 ;
    sort_reg15 <= (win_data[16*2-1:16*1] >= win_data[16*6-1:16*5])? 1 : 0 ;
    sort_reg16 <= (win_data[16*2-1:16*1] >= win_data[16*16-1:16*15])? 1 : 0 ;
    sort_reg17 <= (win_data[16*2-1:16*1] >= win_data[16*17-1:16*16])? 1 : 0 ;
    sort_reg18 <= (win_data[16*2-1:16*1] >= win_data[16*18-1:16*17])? 1 : 0 ;
    sort_reg19 <= (win_data[16*2-1:16*1] >= win_data[16*19-1:16*18])? 1 : 0 ;
    sort_reg1a <= (win_data[16*2-1:16*1] >= win_data[16*20-1:16*19])? 1 : 0 ;
    sort_reg1b <= (win_data[16*2-1:16*1] >= win_data[16*21-1:16*20])? 1 : 0 ;


    sort_reg20 <= (win_data[16*3-1:16*2] >= win_data[16*1-1:0])? 1 : 0 ;
    sort_reg21 <= (win_data[16*3-1:16*2] >= win_data[16*2-1:16*1])? 1 : 0 ;
    sort_reg22 <= (win_data[16*3-1:16*2] >= win_data[16*3-1:16*2])? 1 : 0 ;
    sort_reg23 <= (win_data[16*3-1:16*2] >= win_data[16*4-1:16*3])? 1 : 0 ;
    sort_reg24 <= (win_data[16*3-1:16*2] >= win_data[16*5-1:16*4])? 1 : 0 ;
    sort_reg25 <= (win_data[16*3-1:16*2] >= win_data[16*6-1:16*5])? 1 : 0 ;
    sort_reg26 <= (win_data[16*3-1:16*2] >= win_data[16*16-1:16*15])? 1 : 0 ;
    sort_reg27 <= (win_data[16*3-1:16*2] >= win_data[16*17-1:16*16])? 1 : 0 ;
    sort_reg28 <= (win_data[16*3-1:16*2] >= win_data[16*18-1:16*17])? 1 : 0 ;
    sort_reg29 <= (win_data[16*3-1:16*2] >= win_data[16*19-1:16*18])? 1 : 0 ;
    sort_reg2a <= (win_data[16*3-1:16*2] >= win_data[16*20-1:16*19])? 1 : 0 ;
    sort_reg2b <= (win_data[16*3-1:16*2] >= win_data[16*21-1:16*20])? 1 : 0 ;

    sort_reg30 <= (win_data[16*4-1:16*3] >= win_data[16*1-1:0])? 1 : 0 ;
    sort_reg31 <= (win_data[16*4-1:16*3] >= win_data[16*2-1:16*1])? 1 : 0 ;
    sort_reg32 <= (win_data[16*4-1:16*3] >= win_data[16*3-1:16*2])? 1 : 0 ;
    sort_reg33 <= (win_data[16*4-1:16*3] >= win_data[16*4-1:16*3])? 1 : 0 ;
    sort_reg34 <= (win_data[16*4-1:16*3] >= win_data[16*5-1:16*4])? 1 : 0 ;
    sort_reg35 <= (win_data[16*4-1:16*3] >= win_data[16*6-1:16*5])? 1 : 0 ;
    sort_reg36 <= (win_data[16*4-1:16*3] >= win_data[16*16-1:16*15])? 1 : 0 ;
    sort_reg37 <= (win_data[16*4-1:16*3] >= win_data[16*17-1:16*16])? 1 : 0 ;
    sort_reg38 <= (win_data[16*4-1:16*3] >= win_data[16*18-1:16*17])? 1 : 0 ;
    sort_reg39 <= (win_data[16*4-1:16*3] >= win_data[16*19-1:16*18])? 1 : 0 ;
    sort_reg3a <= (win_data[16*4-1:16*3] >= win_data[16*20-1:16*19])? 1 : 0 ;
    sort_reg3b <= (win_data[16*4-1:16*3] >= win_data[16*21-1:16*20])? 1 : 0 ;

    sort_reg40 <= (win_data[16*5-1:16*4] >= win_data[16*1-1:0])? 1 : 0 ;
    sort_reg41 <= (win_data[16*5-1:16*4] >= win_data[16*2-1:16*1])? 1 : 0 ;
    sort_reg42 <= (win_data[16*5-1:16*4] >= win_data[16*3-1:16*2])? 1 : 0 ;
    sort_reg43 <= (win_data[16*5-1:16*4] >= win_data[16*4-1:16*3])? 1 : 0 ;
    sort_reg44 <= (win_data[16*5-1:16*4] >= win_data[16*5-1:16*4])? 1 : 0 ;
    sort_reg45 <= (win_data[16*5-1:16*4] >= win_data[16*6-1:16*5])? 1 : 0 ;
    sort_reg46 <= (win_data[16*5-1:16*4] >= win_data[16*16-1:16*15])? 1 : 0 ;
    sort_reg47 <= (win_data[16*5-1:16*4] >= win_data[16*17-1:16*16])? 1 : 0 ;
    sort_reg48 <= (win_data[16*5-1:16*4] >= win_data[16*18-1:16*17])? 1 : 0 ;
    sort_reg49 <= (win_data[16*5-1:16*4] >= win_data[16*19-1:16*18])? 1 : 0 ;
    sort_reg4a <= (win_data[16*5-1:16*4] >= win_data[16*20-1:16*19])? 1 : 0 ;
    sort_reg4b <= (win_data[16*5-1:16*4] >= win_data[16*21-1:16*20])? 1 : 0 ;

    sort_reg50 <= (win_data[16*6-1:16*5] >= win_data[16*1-1:0])? 1 : 0 ;
    sort_reg51 <= (win_data[16*6-1:16*5] >= win_data[16*2-1:16*1])? 1 : 0 ;
    sort_reg52 <= (win_data[16*6-1:16*5] >= win_data[16*3-1:16*2])? 1 : 0 ;
    sort_reg53 <= (win_data[16*6-1:16*5] >= win_data[16*4-1:16*3])? 1 : 0 ;
    sort_reg54 <= (win_data[16*6-1:16*5] >= win_data[16*5-1:16*4])? 1 : 0 ;
    sort_reg55 <= (win_data[16*6-1:16*5] >= win_data[16*6-1:16*5])? 1 : 0 ;
    sort_reg56 <= (win_data[16*6-1:16*5] >= win_data[16*16-1:16*15])? 1 : 0 ;
    sort_reg57 <= (win_data[16*6-1:16*5] >= win_data[16*17-1:16*16])? 1 : 0 ;
    sort_reg58 <= (win_data[16*6-1:16*5] >= win_data[16*18-1:16*17])? 1 : 0 ;
    sort_reg59 <= (win_data[16*6-1:16*5] >= win_data[16*19-1:16*18])? 1 : 0 ;
    sort_reg5a <= (win_data[16*6-1:16*5] >= win_data[16*20-1:16*19])? 1 : 0 ;
    sort_reg5b <= (win_data[16*6-1:16*5] >= win_data[16*21-1:16*20])? 1 : 0 ;

    sort_reg60 <= (win_data[16*16-1:16*15] >= win_data[16*1-1:0])? 1 : 0 ;
    sort_reg61 <= (win_data[16*16-1:16*15] >= win_data[16*2-1:16*1])? 1 : 0 ;
    sort_reg62 <= (win_data[16*16-1:16*15] >= win_data[16*3-1:16*2])? 1 : 0 ;
    sort_reg63 <= (win_data[16*16-1:16*15] >= win_data[16*4-1:16*3])? 1 : 0 ;
    sort_reg64 <= (win_data[16*16-1:16*15] >= win_data[16*5-1:16*4])? 1 : 0 ;
    sort_reg65 <= (win_data[16*16-1:16*15] >= win_data[16*6-1:16*5])? 1 : 0 ;
    sort_reg66 <= (win_data[16*16-1:16*15] >= win_data[16*16-1:16*15])? 1 : 0 ;
    sort_reg67 <= (win_data[16*16-1:16*15] >= win_data[16*17-1:16*16])? 1 : 0 ;
    sort_reg68 <= (win_data[16*16-1:16*15] >= win_data[16*18-1:16*17])? 1 : 0 ;
    sort_reg69 <= (win_data[16*16-1:16*15] >= win_data[16*19-1:16*18])? 1 : 0 ;
    sort_reg6a <= (win_data[16*16-1:16*15] >= win_data[16*20-1:16*19])? 1 : 0 ;
    sort_reg6b <= (win_data[16*16-1:16*15] >= win_data[16*21-1:16*20])? 1 : 0 ;


    sort_reg70 <= (win_data[16*17-1:16*16] >= win_data[16*1-1:0])? 1 : 0 ;
    sort_reg71 <= (win_data[16*17-1:16*16] >= win_data[16*2-1:16*1])? 1 : 0 ;
    sort_reg72 <= (win_data[16*17-1:16*16] >= win_data[16*3-1:16*2])? 1 : 0 ;
    sort_reg73 <= (win_data[16*17-1:16*16] >= win_data[16*4-1:16*3])? 1 : 0 ;
    sort_reg74 <= (win_data[16*17-1:16*16] >= win_data[16*5-1:16*4])? 1 : 0 ;
    sort_reg75 <= (win_data[16*17-1:16*16] >= win_data[16*6-1:16*5])? 1 : 0 ;
    sort_reg76 <= (win_data[16*17-1:16*16] >= win_data[16*16-1:16*15])? 1 : 0 ;
    sort_reg77 <= (win_data[16*17-1:16*16] >= win_data[16*17-1:16*16])? 1 : 0 ;
    sort_reg78 <= (win_data[16*17-1:16*16] >= win_data[16*18-1:16*17])? 1 : 0 ;
    sort_reg79 <= (win_data[16*17-1:16*16] >= win_data[16*19-1:16*18])? 1 : 0 ;
    sort_reg7a <= (win_data[16*17-1:16*16] >= win_data[16*20-1:16*19])? 1 : 0 ;
    sort_reg7b <= (win_data[16*17-1:16*16] >= win_data[16*21-1:16*20])? 1 : 0 ;

    sort_reg80 <= (win_data[16*18-1:16*17] >= win_data[16*1-1:0])? 1 : 0 ;
    sort_reg81 <= (win_data[16*18-1:16*17] >= win_data[16*2-1:16*1])? 1 : 0 ;
    sort_reg82 <= (win_data[16*18-1:16*17] >= win_data[16*3-1:16*2])? 1 : 0 ;
    sort_reg83 <= (win_data[16*18-1:16*17] >= win_data[16*4-1:16*3])? 1 : 0 ;
    sort_reg84 <= (win_data[16*18-1:16*17] >= win_data[16*5-1:16*4])? 1 : 0 ;
    sort_reg85 <= (win_data[16*18-1:16*17] >= win_data[16*6-1:16*5])? 1 : 0 ;
    sort_reg86 <= (win_data[16*18-1:16*17] >= win_data[16*16-1:16*15])? 1 : 0 ;
    sort_reg87 <= (win_data[16*18-1:16*17] >= win_data[16*17-1:16*16])? 1 : 0 ;
    sort_reg88 <= (win_data[16*18-1:16*17] >= win_data[16*18-1:16*17])? 1 : 0 ;
    sort_reg89 <= (win_data[16*18-1:16*17] >= win_data[16*19-1:16*18])? 1 : 0 ;
    sort_reg8a <= (win_data[16*18-1:16*17] >= win_data[16*20-1:16*19])? 1 : 0 ;
    sort_reg8b <= (win_data[16*18-1:16*17] >= win_data[16*21-1:16*20])? 1 : 0 ;

    sort_reg90 <= (win_data[16*19-1:16*18] >= win_data[16*1-1:0])? 1 : 0 ;
    sort_reg91 <= (win_data[16*19-1:16*18] >= win_data[16*2-1:16*1])? 1 : 0 ;
    sort_reg92 <= (win_data[16*19-1:16*18] >= win_data[16*3-1:16*2])? 1 : 0 ;
    sort_reg93 <= (win_data[16*19-1:16*18] >= win_data[16*4-1:16*3])? 1 : 0 ;
    sort_reg94 <= (win_data[16*19-1:16*18] >= win_data[16*5-1:16*4])? 1 : 0 ;
    sort_reg95 <= (win_data[16*19-1:16*18] >= win_data[16*6-1:16*5])? 1 : 0 ;
    sort_reg96 <= (win_data[16*19-1:16*18] >= win_data[16*16-1:16*15])? 1 : 0 ;
    sort_reg97 <= (win_data[16*19-1:16*18] >= win_data[16*17-1:16*16])? 1 : 0 ;
    sort_reg98 <= (win_data[16*19-1:16*18] >= win_data[16*18-1:16*17])? 1 : 0 ;
    sort_reg99 <= (win_data[16*19-1:16*18] >= win_data[16*19-1:16*18])? 1 : 0 ;
    sort_reg9a <= (win_data[16*19-1:16*18] >= win_data[16*20-1:16*19])? 1 : 0 ;
    sort_reg9b <= (win_data[16*19-1:16*18] >= win_data[16*21-1:16*20])? 1 : 0 ;

    sort_rega0 <= (win_data[16*20-1:16*19] >= win_data[16*1-1:0])? 1 : 0 ;
    sort_rega1 <= (win_data[16*20-1:16*19] >= win_data[16*2-1:16*1])? 1 : 0 ;
    sort_rega2 <= (win_data[16*20-1:16*19] >= win_data[16*3-1:16*2])? 1 : 0 ;
    sort_rega3 <= (win_data[16*20-1:16*19] >= win_data[16*4-1:16*3])? 1 : 0 ;
    sort_rega4 <= (win_data[16*20-1:16*19] >= win_data[16*5-1:16*4])? 1 : 0 ;
    sort_rega5 <= (win_data[16*20-1:16*19] >= win_data[16*6-1:16*5])? 1 : 0 ;
    sort_rega6 <= (win_data[16*20-1:16*19] >= win_data[16*16-1:16*15])? 1 : 0 ;
    sort_rega7 <= (win_data[16*20-1:16*19] >= win_data[16*17-1:16*16])? 1 : 0 ;
    sort_rega8 <= (win_data[16*20-1:16*19] >= win_data[16*18-1:16*17])? 1 : 0 ;
    sort_rega9 <= (win_data[16*20-1:16*19] >= win_data[16*19-1:16*18])? 1 : 0 ;
    sort_regaa <= (win_data[16*20-1:16*19] >= win_data[16*20-1:16*19])? 1 : 0 ;
    sort_regab <= (win_data[16*20-1:16*19] >= win_data[16*21-1:16*20])? 1 : 0 ;

    sort_regb0 <= (win_data[16*21-1:16*20] >= win_data[16*1-1:0])? 1 : 0 ;
    sort_regb1 <= (win_data[16*21-1:16*20] >= win_data[16*2-1:16*1])? 1 : 0 ;
    sort_regb2 <= (win_data[16*21-1:16*20] >= win_data[16*3-1:16*2])? 1 : 0 ;
    sort_regb3 <= (win_data[16*21-1:16*20] >= win_data[16*4-1:16*3])? 1 : 0 ;
    sort_regb4 <= (win_data[16*21-1:16*20] >= win_data[16*5-1:16*4])? 1 : 0 ;
    sort_regb5 <= (win_data[16*21-1:16*20] >= win_data[16*6-1:16*5])? 1 : 0 ;
    sort_regb6 <= (win_data[16*21-1:16*20] >= win_data[16*16-1:16*15])? 1 : 0 ;
    sort_regb7 <= (win_data[16*21-1:16*20] >= win_data[16*17-1:16*16])? 1 : 0 ;
    sort_regb8 <= (win_data[16*21-1:16*20] >= win_data[16*18-1:16*17])? 1 : 0 ;
    sort_regb9 <= (win_data[16*21-1:16*20] >= win_data[16*19-1:16*18])? 1 : 0 ;
    sort_regba <= (win_data[16*21-1:16*20] >= win_data[16*20-1:16*19])? 1 : 0 ;
    sort_regbb <= (win_data[16*21-1:16*20] >= win_data[16*21-1:16*20])? 1 : 0 ;

end

always @(posedge clk )
begin
    sort_reg0 <= {sort_reg00,sort_reg01,sort_reg02,sort_reg03,sort_reg04,sort_reg05,sort_reg06,sort_reg07,sort_reg08,sort_reg09,sort_reg0a,sort_reg0b};
    sort_reg1 <= {sort_reg10,sort_reg11,sort_reg12,sort_reg13,sort_reg14,sort_reg15,sort_reg16,sort_reg17,sort_reg18,sort_reg19,sort_reg1a,sort_reg1b};
    sort_reg2 <= {sort_reg20,sort_reg21,sort_reg22,sort_reg23,sort_reg24,sort_reg25,sort_reg26,sort_reg27,sort_reg28,sort_reg29,sort_reg2a,sort_reg2b};
    sort_reg3 <= {sort_reg30,sort_reg31,sort_reg32,sort_reg33,sort_reg34,sort_reg35,sort_reg36,sort_reg37,sort_reg38,sort_reg39,sort_reg3a,sort_reg3b};
    sort_reg4 <= {sort_reg40,sort_reg41,sort_reg42,sort_reg43,sort_reg44,sort_reg45,sort_reg46,sort_reg47,sort_reg48,sort_reg49,sort_reg4a,sort_reg4b};
    sort_reg5 <= {sort_reg50,sort_reg51,sort_reg52,sort_reg53,sort_reg54,sort_reg55,sort_reg56,sort_reg57,sort_reg58,sort_reg59,sort_reg5a,sort_reg5b};
    sort_reg6 <= {sort_reg60,sort_reg61,sort_reg62,sort_reg63,sort_reg64,sort_reg65,sort_reg66,sort_reg67,sort_reg68,sort_reg69,sort_reg6a,sort_reg6b};
    sort_reg7 <= {sort_reg70,sort_reg71,sort_reg72,sort_reg73,sort_reg74,sort_reg75,sort_reg76,sort_reg77,sort_reg78,sort_reg79,sort_reg7a,sort_reg7b};
    sort_reg8 <= {sort_reg80,sort_reg81,sort_reg82,sort_reg83,sort_reg84,sort_reg85,sort_reg86,sort_reg87,sort_reg88,sort_reg89,sort_reg8a,sort_reg8b};
    sort_reg9 <= {sort_reg90,sort_reg91,sort_reg92,sort_reg93,sort_reg94,sort_reg95,sort_reg96,sort_reg97,sort_reg98,sort_reg99,sort_reg9a,sort_reg9b};
    sort_rega <= {sort_rega0,sort_rega1,sort_rega2,sort_rega3,sort_rega4,sort_rega5,sort_rega6,sort_rega7,sort_rega8,sort_rega9,sort_regaa,sort_regab};
    sort_regb <= {sort_regb0,sort_regb1,sort_regb2,sort_regb3,sort_regb4,sort_regb5,sort_regb6,sort_regb7,sort_regb8,sort_regb9,sort_regba,sort_regbb};
end

reg         cur_data_max_flag       ;
reg [15:0]  cur_data_max_flag_shift ;

always @(posedge clk )
begin
    if(rst)
        cur_data_max_flag <= 'd0 ;
    else if(win_data[175:160] > win_data[159:144] && win_data[175:160] > win_data[191:176] )
        cur_data_max_flag <= 'd1 ;
    else 
        cur_data_max_flag <= 'd0 ;
end 

always @(posedge clk) 
begin
    if(rst)
        cur_data_max_flag_shift <= 'd0 ;
    else 
        cur_data_max_flag_shift <= {cur_data_max_flag_shift[14:0],cur_data_max_flag};
end


reg [15:0] data_max ;
always @(posedge clk )
begin
    if(rst)
        data_max <= 'd0 ;
    else if(sort_reg0 == 'hfff)
        data_max <= win_data_d2[16*1-1:0] ;
    else if(sort_reg1 == 'hfff)
        data_max <= win_data_d2[16*2-1:16*1] ;
    else if(sort_reg2 == 'hfff)
        data_max <= win_data_d2[16*3-1:16*2] ;        
    else if(sort_reg3 == 'hfff)
        data_max <= win_data_d2[16*4-1:16*3] ;
    else if(sort_reg4 == 'hfff)
        data_max <= win_data_d2[16*5-1:16*4] ;
    else if(sort_reg5 == 'hfff)
        data_max <= win_data_d2[16*6-1:16*5] ;
    else if(sort_reg6 == 'hfff)
        data_max <= win_data_d2[16*16-1:16*15] ;
    else if(sort_reg7 == 'hfff)
        data_max <= win_data_d2[16*17-1:16*16] ;
    else if(sort_reg8 == 'hfff)
        data_max <= win_data_d2[16*18-1:16*17] ;
    else if(sort_reg9 == 'hfff)
        data_max <= win_data_d2[16*19-1:16*18] ;
    else if(sort_rega == 'hfff)
        data_max <= win_data_d2[16*20-1:16*19] ;
    else if(sort_regb == 'hfff)
        data_max <= win_data_d2[16*21-1:16*20] ;
    else
        data_max <= data_max ;
end

reg [15:0]  sum_result_sub_max ;
always @(posedge clk )
begin
    if(rst)
        sum_result_sub_max <= 'd0 ;
    else 
        sum_result_sub_max <= sum_result - data_max ;
end

//  sum_result_sub_max /11 ~= sum_result_sub_max * 93 / 1024 

wire [31:0] mult_result ;
mult_us16_us8_d3 mult_us16_us8_d3
(
    .CLK        (clk                ),
    .A          (sum_result_sub_max ),
    .B          (16'd5957           ),
    .P          (mult_result        )
);


wire  [15:0]      cfar_map_dpl       ;
wire              cfar_map_dpl_valid ;

assign cfar_map_dpl         = mult_result[31:16]     ;
assign cfar_map_dpl_valid   = win_data_vliad_shift[6];

reg [15:0]  ram_addra ;
reg         ram_wea   ;
reg [15:0]  ram_dina  ;
wire[15:0]  ram_douta ;


ram_w16d65536_w16d65536 ram_w16d65536_w16d65536 
(
    .clka       (clk                    ),
    .ena        (cfar_map_dpl_valid     ),
    .wea        (1'b1                   ),
    .addra      (ram_addra              ),
    .dina       ({cur_data_max_flag_shift[5],cfar_map_dpl[14:0]}),
    .douta      (                       ),

    .clkb       (clk                    ),
    .enb        (1'b1                   ),
    .web        (1'b0                   ),
    .addrb      (cfar_dpl_map_addr      ),
    .dinb       ('d0                    ),
    .doutb      (cfar_dpl_map_data      )
);

always @(posedge clk )
begin
    if(rst)
        ram_addra <= 'd0 ;
    else if(cfar_map_dpl_valid)
        ram_addra <= ram_addra + 1'b1 ;
    else 
        ram_addra <= ram_addra ;
end


//----------------------debug-------------------------
reg [4:0]   win_data_vliad_cnt ;
always @(posedge clk ) 
begin
    if(rst)
        win_data_vliad_cnt <= 'd0 ;
    else if(win_data_vliad)
        win_data_vliad_cnt <= win_data_vliad_cnt + 1'b1 ;
    else 
        win_data_vliad_cnt <= win_data_vliad_cnt ;
end

reg [12:0]   row_cnt ;
always @(posedge clk ) 
begin
    if(rst)
        row_cnt <= 'd0 ;
    else if(win_data_vliad_cnt == 'd31 )
        row_cnt <= row_cnt + 1'b1 ;
    else 
        row_cnt <= row_cnt ;
end




endmodule
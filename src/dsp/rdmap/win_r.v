

module win_r (

    input               clk            ,
    input               rst            ,
    
    input               adc_data_valid ,
    input  [31:0]       adc_data       ,
    input               adc_data_sop   ,
    input               adc_data_eop   ,
    input  [15:0]       sample_num     ,
    input  [15:0]       chirp_num      ,

    output  reg         win_r_data_valid,
    output  reg[31:0]   win_r_data      ,
    output  reg         win_r_data_sop  ,
    output  reg         win_r_data_eop  ,

    input [15:0]        adc_truncation

);



reg [12:0]  cnt_smp_gate = 'd0;

reg [ 6:0]  tvalid_s          = 'd0;
reg [15:0]  data_latch_0      = 'd0;
reg [15:0]  data_latch_1      = 'd0;
wire[31:0]  win_data_im            ;
wire[31:0]  win_data_re            ;
wire[15:0]  hamming_data           ;

reg  [15:0] adc_data_valid_shift ;
reg  [15:0] adc_data_sop_shift   ;
reg  [15:0] adc_data_eop_shift   ;
reg  [31:0] adc_data_d1          ;
reg  [31:0] adc_data_d2          ;
reg  [31:0] adc_data_d3          ;

reg  [15:0] sample_num_d1 ;
reg  [15:0] sample_num_d2 ;

reg  [15:0] chirp_num_d1 ;
reg  [15:0] chirp_num_d2 ;

always @(posedge clk) begin
    if(rst) begin
        sample_num_d1 <= 'd0 ;
        sample_num_d2 <= 'd0 ;
    end
    else begin
        sample_num_d1 <= sample_num ;
        sample_num_d2 <= sample_num_d1 ;
    end
end

always @(posedge clk) begin
    if(rst) begin
        chirp_num_d1 <= 'd0 ;
        chirp_num_d2 <= 'd0 ;
    end
    else begin
        chirp_num_d1 <= chirp_num ;
        chirp_num_d2 <= chirp_num_d1 ;
    end
end

always @(posedge clk) begin
    if(rst)
        adc_data_valid_shift <= 'd0 ;
    else
        adc_data_valid_shift <= {adc_data_valid_shift[14:0],adc_data_valid};
end

always @(posedge clk) begin
    if(rst)
        adc_data_sop_shift <= 'd0 ;
    else 
        adc_data_sop_shift <={adc_data_sop_shift[14:0],adc_data_sop};
end

always @(posedge clk) begin
    if(rst)
        adc_data_eop_shift <= 'd0 ;
    else 
        adc_data_eop_shift <= {adc_data_eop_shift[14:0],adc_data_eop};
end


always @(posedge clk) begin
    if(rst) begin
        adc_data_d1 <= 'd0 ;
        adc_data_d2 <= 'd0 ;
        adc_data_d3 <= 'd0 ;
    end
    else begin
        adc_data_d1 <= adc_data   ;
        adc_data_d2 <= adc_data_d1;
        adc_data_d3 <= adc_data_d2;
    end
end


always @(posedge clk) begin
    if(rst) 
        cnt_smp_gate <= 'd0 ;
    else if(adc_data_eop)
        cnt_smp_gate <= 'd0 ;
    else if(adc_data_valid)
        cnt_smp_gate <= cnt_smp_gate + 1'b1 ;
    else 
        cnt_smp_gate <= 'd0 ;
end

reg [12:0]  win_rom_addr ;
always @(posedge clk) begin
    if(rst)
        win_rom_addr <= 'd0 ;
    else if(chirp_num_d2 == 'd128)
        win_rom_addr <= cnt_smp_gate + 0  ;
    else if(chirp_num_d2 == 'd64)
        win_rom_addr <= cnt_smp_gate + 1024 + 4096;
    else if(chirp_num_d2 == 'd32)
        win_rom_addr <= cnt_smp_gate + 1024 ;
end

Hamming4096_Win16 u_Hamming4096_Win16 (
  .clka (clk            ),
  .ena  (1'b1           ),
  .addra(win_rom_addr   ),   //align tvalid_s[0]
  .douta(hamming_data   )    //align tvalid_s[2]
);


//----//----//----//----//----//----//----//---- data * win //----//----//----//----//----//----//----//----
mult_R  mult_r_inst_re(
    .CLK( clk               ),
    .A  ( adc_data_d3[15:0] ), //align tvalid_s[3]
    .B  ( hamming_data      ), //align tvalid_s[3]
    .P  ( win_data_re       )  //align tvalid_s[4]
);

mult_R  mult_r_inst_im(
    .CLK( clk                ),
    .A  ( adc_data_d3[31:16] ), //align tvalid_s[3]
    .B  ( hamming_data       ), //align tvalid_s[3]
    .P  ( win_data_im        )  //align tvalid_s[4]
);

always @ (posedge clk) begin
    case (adc_truncation)
        'd0:
            win_r_data   <= {win_data_im[15: 0],win_data_re[15: 0]};
        'd1:
            win_r_data   <= {win_data_im[16: 1],win_data_re[16: 1]};
        'd2:
            win_r_data   <= {win_data_im[17: 2],win_data_re[17: 2]};
        'd3:
            win_r_data   <= {win_data_im[18: 3],win_data_re[18: 3]};
        'd4:
            win_r_data   <= {win_data_im[19: 4],win_data_re[19: 4]};
        'd5:
            win_r_data   <= {win_data_im[20: 5],win_data_re[20: 5]};
        'd6:
            win_r_data   <= {win_data_im[21: 6],win_data_re[21: 6]};
        'd7:
            win_r_data   <= {win_data_im[22: 7],win_data_re[22: 7]};
        'd8:
            win_r_data   <= {win_data_im[23: 8],win_data_re[23: 8]};
        'd9:
            win_r_data   <= {win_data_im[24: 9],win_data_re[24: 9]};
        'd10:
            win_r_data   <= {win_data_im[25: 10],win_data_re[25: 10]};
        'd11:
            win_r_data   <= {win_data_im[26: 11],win_data_re[26: 11]};
        'd12:
            win_r_data   <= {win_data_im[27: 12],win_data_re[27: 12]};
        'd13:
            win_r_data   <= {win_data_im[28: 13],win_data_re[28: 13]};
        'd14:
            win_r_data   <= {win_data_im[29: 14],win_data_re[29: 14]};
        'd15:
            win_r_data   <= {win_data_im[30: 15],win_data_re[30: 15]};
        'd16:
            win_r_data   <= {win_data_im[31: 16],win_data_re[31: 16]};
        default: 
            win_r_data   <= {win_data_im[31: 17],win_data_re[31: 17]};
    endcase
end

always @(posedge clk) begin
    if(rst)
        win_r_data_valid <= 'd0 ;
    else 
        win_r_data_valid <= adc_data_valid_shift[5];
end
always @(posedge clk) begin
    if(rst)
        win_r_data_sop <= 'd0 ;
    else 
        win_r_data_sop <= adc_data_sop_shift[5];
end

always @(posedge clk) begin
    if(rst)
        win_r_data_eop <= 'd0 ;
    else 
        win_r_data_eop <= adc_data_eop_shift[5];
end

endmodule
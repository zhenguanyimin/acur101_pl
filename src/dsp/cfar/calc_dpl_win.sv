module calc_dpl_win
(

    input               clk             ,
    input               rst             ,

    input      [15:0]   dpl_data        ,
    input               dpl_data_valid  ,

    input  wire[3:0]    reference_unm   ,
    output reg [16*21-1:0]  win_data    ,
    output reg          win_data_vliad 
);

reg [95:0]  dpl_data_valid_shift ;
reg [15:0]  dpl_data_shift[64]   ;

always @(posedge clk) begin
    if(rst)
        dpl_data_valid_shift <= 'd0 ;
    else 
        dpl_data_valid_shift <= {dpl_data_valid_shift[94:0],dpl_data_valid};
end


integer i ;
generate 
always @(posedge clk ) begin
    for ( i=0 ; i<64 ;i = i + 1 ) begin
        if(i== 0)
            dpl_data_shift[i]   <=dpl_data ;
        else 
            dpl_data_shift[i] <= dpl_data_shift[i-1] ;
    end 
end
endgenerate

reg [4:0]   data_cnt ;
always @(posedge clk)
begin
    if(rst)
        data_cnt <= 'd0 ;
    else if(dpl_data_valid_shift[31])
        data_cnt <= data_cnt + 1'b1 ;
    else 
        data_cnt <= data_cnt ;
end

always @(posedge clk) 
begin
    if(rst) begin
        win_data <= 'd0 ;
    end
    else begin
        case (data_cnt)
            'd0:
                win_data <= 
                            {
                                dpl_data_shift[9],dpl_data_shift[8],dpl_data_shift[7],dpl_data_shift[6],dpl_data_shift[5],
                                dpl_data_shift[4],dpl_data_shift[3],dpl_data_shift[2],dpl_data_shift[1],dpl_data_shift[0],
                                dpl_data_shift[31],
                                dpl_data_shift[30],dpl_data_shift[29],dpl_data_shift[28],dpl_data_shift[27],dpl_data_shift[26],
                                dpl_data_shift[25],dpl_data_shift[24],dpl_data_shift[23],dpl_data_shift[22],dpl_data_shift[21]
                            };
            'd1:
                win_data <=
                            {
                                dpl_data_shift[9],dpl_data_shift[8],dpl_data_shift[7],dpl_data_shift[6],dpl_data_shift[5],
                                dpl_data_shift[4],dpl_data_shift[3],dpl_data_shift[2],dpl_data_shift[1],dpl_data_shift[32],
                                dpl_data_shift[31],
                                dpl_data_shift[30],dpl_data_shift[29],dpl_data_shift[28],dpl_data_shift[27],dpl_data_shift[26],
                                dpl_data_shift[25],dpl_data_shift[24],dpl_data_shift[23],dpl_data_shift[22],dpl_data_shift[21]
                            };
            'd2:
                win_data <=
                            {
                                dpl_data_shift[9],dpl_data_shift[8],dpl_data_shift[7],dpl_data_shift[6],dpl_data_shift[5],
                                dpl_data_shift[4],dpl_data_shift[3],dpl_data_shift[2],dpl_data_shift[33],dpl_data_shift[32],
                                dpl_data_shift[31],
                                dpl_data_shift[30],dpl_data_shift[29],dpl_data_shift[28],dpl_data_shift[27],dpl_data_shift[26],
                                dpl_data_shift[25],dpl_data_shift[24],dpl_data_shift[23],dpl_data_shift[22],dpl_data_shift[21]
                            };

            'd3:
                win_data <=
                            {
                                dpl_data_shift[9],dpl_data_shift[8],dpl_data_shift[7],dpl_data_shift[6],dpl_data_shift[5],
                                dpl_data_shift[4],dpl_data_shift[3],dpl_data_shift[34],dpl_data_shift[35],dpl_data_shift[36],
                                dpl_data_shift[31],
                                dpl_data_shift[30],dpl_data_shift[29],dpl_data_shift[28],dpl_data_shift[27],dpl_data_shift[26],
                                dpl_data_shift[25],dpl_data_shift[24],dpl_data_shift[23],dpl_data_shift[22],dpl_data_shift[21]
                            };
            'd4:
                win_data <=
                            {
                                dpl_data_shift[9],dpl_data_shift[8],dpl_data_shift[7],dpl_data_shift[6],dpl_data_shift[5],
                                dpl_data_shift[4],dpl_data_shift[35],dpl_data_shift[34],dpl_data_shift[33],dpl_data_shift[32],
                                dpl_data_shift[31],
                                dpl_data_shift[30],dpl_data_shift[29],dpl_data_shift[28],dpl_data_shift[27],dpl_data_shift[26],
                                dpl_data_shift[25],dpl_data_shift[24],dpl_data_shift[23],dpl_data_shift[22],dpl_data_shift[21]
                            };
            'd5:
                win_data <=
                            {
                                dpl_data_shift[9],dpl_data_shift[8],dpl_data_shift[7],dpl_data_shift[6],dpl_data_shift[5],
                                dpl_data_shift[36],dpl_data_shift[35],dpl_data_shift[34],dpl_data_shift[33],dpl_data_shift[32],
                                dpl_data_shift[31],
                                dpl_data_shift[30],dpl_data_shift[29],dpl_data_shift[28],dpl_data_shift[27],dpl_data_shift[26],
                                dpl_data_shift[25],dpl_data_shift[24],dpl_data_shift[23],dpl_data_shift[22],dpl_data_shift[21]
                            };
            'd6:
                win_data <=
                            {
                                dpl_data_shift[9],dpl_data_shift[8],dpl_data_shift[7],dpl_data_shift[6],dpl_data_shift[37],
                                dpl_data_shift[36],dpl_data_shift[35],dpl_data_shift[34],dpl_data_shift[33],dpl_data_shift[32],
                                dpl_data_shift[31],
                                dpl_data_shift[30],dpl_data_shift[29],dpl_data_shift[28],dpl_data_shift[27],dpl_data_shift[26],
                                dpl_data_shift[25],dpl_data_shift[24],dpl_data_shift[23],dpl_data_shift[22],dpl_data_shift[21]
                            };

            'd7:
                win_data <=
                            {
                                dpl_data_shift[9],dpl_data_shift[8],dpl_data_shift[7],dpl_data_shift[38],dpl_data_shift[37],
                                dpl_data_shift[36],dpl_data_shift[35],dpl_data_shift[34],dpl_data_shift[33],dpl_data_shift[32],
                                dpl_data_shift[31],
                                dpl_data_shift[30],dpl_data_shift[29],dpl_data_shift[28],dpl_data_shift[27],dpl_data_shift[26],
                                dpl_data_shift[25],dpl_data_shift[24],dpl_data_shift[23],dpl_data_shift[22],dpl_data_shift[21]
                            };

            'd8:
                win_data <=
                            {
                                dpl_data_shift[9],dpl_data_shift[8],dpl_data_shift[39],dpl_data_shift[38],dpl_data_shift[37],
                                dpl_data_shift[36],dpl_data_shift[35],dpl_data_shift[34],dpl_data_shift[33],dpl_data_shift[32],
                                dpl_data_shift[31],
                                dpl_data_shift[30],dpl_data_shift[29],dpl_data_shift[28],dpl_data_shift[27],dpl_data_shift[26],
                                dpl_data_shift[25],dpl_data_shift[24],dpl_data_shift[23],dpl_data_shift[22],dpl_data_shift[21]
                            };
            'd9:
                win_data <=
                            {
                                dpl_data_shift[9],dpl_data_shift[40],dpl_data_shift[39],dpl_data_shift[38],dpl_data_shift[37],
                                dpl_data_shift[36],dpl_data_shift[35],dpl_data_shift[34],dpl_data_shift[33],dpl_data_shift[32],
                                dpl_data_shift[31],
                                dpl_data_shift[30],dpl_data_shift[29],dpl_data_shift[28],dpl_data_shift[27],dpl_data_shift[26],
                                dpl_data_shift[25],dpl_data_shift[24],dpl_data_shift[23],dpl_data_shift[22],dpl_data_shift[21]
                            };

            'd10:
                win_data <=
                            {
                                dpl_data_shift[41],dpl_data_shift[40],dpl_data_shift[39],dpl_data_shift[38],dpl_data_shift[37],
                                dpl_data_shift[36],dpl_data_shift[35],dpl_data_shift[34],dpl_data_shift[33],dpl_data_shift[32],
                                dpl_data_shift[31],
                                dpl_data_shift[30],dpl_data_shift[29],dpl_data_shift[28],dpl_data_shift[27],dpl_data_shift[26],
                                dpl_data_shift[25],dpl_data_shift[24],dpl_data_shift[23],dpl_data_shift[22],dpl_data_shift[21]
                            };
            'd11:
                win_data <=
                            {
                                dpl_data_shift[41],dpl_data_shift[40],dpl_data_shift[39],dpl_data_shift[38],dpl_data_shift[37],
                                dpl_data_shift[36],dpl_data_shift[35],dpl_data_shift[34],dpl_data_shift[33],dpl_data_shift[32],
                                dpl_data_shift[31],
                                dpl_data_shift[30],dpl_data_shift[29],dpl_data_shift[28],dpl_data_shift[27],dpl_data_shift[26],
                                dpl_data_shift[25],dpl_data_shift[24],dpl_data_shift[23],dpl_data_shift[22],dpl_data_shift[21]
                            };
            'd12:
                win_data <=
                            {
                                dpl_data_shift[41],dpl_data_shift[40],dpl_data_shift[39],dpl_data_shift[38],dpl_data_shift[37],
                                dpl_data_shift[36],dpl_data_shift[35],dpl_data_shift[34],dpl_data_shift[33],dpl_data_shift[32],
                                dpl_data_shift[31],
                                dpl_data_shift[30],dpl_data_shift[29],dpl_data_shift[28],dpl_data_shift[27],dpl_data_shift[26],
                                dpl_data_shift[25],dpl_data_shift[24],dpl_data_shift[23],dpl_data_shift[22],dpl_data_shift[21]
                            };
            'd13:
                win_data <=
                            {
                                dpl_data_shift[41],dpl_data_shift[40],dpl_data_shift[39],dpl_data_shift[38],dpl_data_shift[37],
                                dpl_data_shift[36],dpl_data_shift[35],dpl_data_shift[34],dpl_data_shift[33],dpl_data_shift[32],
                                dpl_data_shift[31],
                                dpl_data_shift[30],dpl_data_shift[29],dpl_data_shift[28],dpl_data_shift[27],dpl_data_shift[26],
                                dpl_data_shift[25],dpl_data_shift[24],dpl_data_shift[23],dpl_data_shift[22],dpl_data_shift[21]
                            };
            'd14:
                win_data <=
                            {
                                dpl_data_shift[41],dpl_data_shift[40],dpl_data_shift[39],dpl_data_shift[38],dpl_data_shift[37],
                                dpl_data_shift[36],dpl_data_shift[35],dpl_data_shift[34],dpl_data_shift[33],dpl_data_shift[32],
                                dpl_data_shift[31],
                                dpl_data_shift[30],dpl_data_shift[29],dpl_data_shift[28],dpl_data_shift[27],dpl_data_shift[26],
                                dpl_data_shift[25],dpl_data_shift[24],dpl_data_shift[23],dpl_data_shift[22],dpl_data_shift[21]
                            };
            'd15:
                win_data <=
                            {
                                dpl_data_shift[41],dpl_data_shift[40],dpl_data_shift[39],dpl_data_shift[38],dpl_data_shift[37],
                                dpl_data_shift[36],dpl_data_shift[35],dpl_data_shift[34],dpl_data_shift[33],dpl_data_shift[32],
                                dpl_data_shift[31],
                                dpl_data_shift[30],dpl_data_shift[29],dpl_data_shift[28],dpl_data_shift[27],dpl_data_shift[26],
                                dpl_data_shift[25],dpl_data_shift[24],dpl_data_shift[23],dpl_data_shift[22],dpl_data_shift[21]
                            };
            'd16:
                win_data <=
                            {
                                dpl_data_shift[41],dpl_data_shift[40],dpl_data_shift[39],dpl_data_shift[38],dpl_data_shift[37],
                                dpl_data_shift[36],dpl_data_shift[35],dpl_data_shift[34],dpl_data_shift[33],dpl_data_shift[32],
                                dpl_data_shift[31],
                                dpl_data_shift[30],dpl_data_shift[29],dpl_data_shift[28],dpl_data_shift[27],dpl_data_shift[26],
                                dpl_data_shift[25],dpl_data_shift[24],dpl_data_shift[23],dpl_data_shift[22],dpl_data_shift[21]
                            };
            'd17:
                win_data <=
                            {
                                dpl_data_shift[41],dpl_data_shift[40],dpl_data_shift[39],dpl_data_shift[38],dpl_data_shift[37],
                                dpl_data_shift[36],dpl_data_shift[35],dpl_data_shift[34],dpl_data_shift[33],dpl_data_shift[32],
                                dpl_data_shift[31],
                                dpl_data_shift[30],dpl_data_shift[29],dpl_data_shift[28],dpl_data_shift[27],dpl_data_shift[26],
                                dpl_data_shift[25],dpl_data_shift[24],dpl_data_shift[23],dpl_data_shift[22],dpl_data_shift[21]
                            };
            'd18:
                win_data <=
                            {
                                dpl_data_shift[41],dpl_data_shift[40],dpl_data_shift[39],dpl_data_shift[38],dpl_data_shift[37],
                                dpl_data_shift[36],dpl_data_shift[35],dpl_data_shift[34],dpl_data_shift[33],dpl_data_shift[32],
                                dpl_data_shift[31],
                                dpl_data_shift[30],dpl_data_shift[29],dpl_data_shift[28],dpl_data_shift[27],dpl_data_shift[26],
                                dpl_data_shift[25],dpl_data_shift[24],dpl_data_shift[23],dpl_data_shift[22],dpl_data_shift[21]
                            };
            'd19:
                win_data <=
                            {
                                dpl_data_shift[41],dpl_data_shift[40],dpl_data_shift[39],dpl_data_shift[38],dpl_data_shift[37],
                                dpl_data_shift[36],dpl_data_shift[35],dpl_data_shift[34],dpl_data_shift[33],dpl_data_shift[32],
                                dpl_data_shift[31],
                                dpl_data_shift[30],dpl_data_shift[29],dpl_data_shift[28],dpl_data_shift[27],dpl_data_shift[26],
                                dpl_data_shift[25],dpl_data_shift[24],dpl_data_shift[23],dpl_data_shift[22],dpl_data_shift[21]
                            };
            'd20:
                win_data <=
                            {
                                dpl_data_shift[41],dpl_data_shift[40],dpl_data_shift[39],dpl_data_shift[38],dpl_data_shift[37],
                                dpl_data_shift[36],dpl_data_shift[35],dpl_data_shift[34],dpl_data_shift[33],dpl_data_shift[32],
                                dpl_data_shift[31],
                                dpl_data_shift[30],dpl_data_shift[29],dpl_data_shift[28],dpl_data_shift[27],dpl_data_shift[26],
                                dpl_data_shift[25],dpl_data_shift[24],dpl_data_shift[23],dpl_data_shift[22],dpl_data_shift[21]
                            };

            'd21:
                win_data <=
                            {
                                dpl_data_shift[41],dpl_data_shift[40],dpl_data_shift[39],dpl_data_shift[38],dpl_data_shift[37],
                                dpl_data_shift[36],dpl_data_shift[35],dpl_data_shift[34],dpl_data_shift[33],dpl_data_shift[32],
                                dpl_data_shift[31],
                                dpl_data_shift[30],dpl_data_shift[29],dpl_data_shift[28],dpl_data_shift[27],dpl_data_shift[26],
                                dpl_data_shift[25],dpl_data_shift[24],dpl_data_shift[23],dpl_data_shift[22],dpl_data_shift[21]
                            };
            'd22:
                win_data <=
                            {
                                dpl_data_shift[41],dpl_data_shift[40],dpl_data_shift[39],dpl_data_shift[38],dpl_data_shift[37],
                                dpl_data_shift[36],dpl_data_shift[35],dpl_data_shift[34],dpl_data_shift[33],dpl_data_shift[32],
                                dpl_data_shift[31],
                                dpl_data_shift[30],dpl_data_shift[29],dpl_data_shift[28],dpl_data_shift[27],dpl_data_shift[26],
                                dpl_data_shift[25],dpl_data_shift[24],dpl_data_shift[23],dpl_data_shift[22],dpl_data_shift[53]
                            };

            'd23:
                win_data <=
                            {
                                dpl_data_shift[41],dpl_data_shift[40],dpl_data_shift[39],dpl_data_shift[38],dpl_data_shift[37],
                                dpl_data_shift[36],dpl_data_shift[35],dpl_data_shift[34],dpl_data_shift[33],dpl_data_shift[32],
                                dpl_data_shift[31],
                                dpl_data_shift[30],dpl_data_shift[29],dpl_data_shift[28],dpl_data_shift[27],dpl_data_shift[26],
                                dpl_data_shift[25],dpl_data_shift[24],dpl_data_shift[23],dpl_data_shift[54],dpl_data_shift[53]
                            };
            'd24:
                win_data <=
                            {
                                dpl_data_shift[41],dpl_data_shift[40],dpl_data_shift[39],dpl_data_shift[38],dpl_data_shift[37],
                                dpl_data_shift[36],dpl_data_shift[35],dpl_data_shift[34],dpl_data_shift[33],dpl_data_shift[32],
                                dpl_data_shift[31],
                                dpl_data_shift[30],dpl_data_shift[29],dpl_data_shift[28],dpl_data_shift[27],dpl_data_shift[26],
                                dpl_data_shift[25],dpl_data_shift[24],dpl_data_shift[55],dpl_data_shift[54],dpl_data_shift[53]
                            };
            'd25:
                win_data <=
                            {
                                dpl_data_shift[41],dpl_data_shift[40],dpl_data_shift[39],dpl_data_shift[38],dpl_data_shift[37],
                                dpl_data_shift[36],dpl_data_shift[35],dpl_data_shift[34],dpl_data_shift[33],dpl_data_shift[32],
                                dpl_data_shift[31],
                                dpl_data_shift[30],dpl_data_shift[29],dpl_data_shift[28],dpl_data_shift[27],dpl_data_shift[26],
                                dpl_data_shift[25],dpl_data_shift[56],dpl_data_shift[55],dpl_data_shift[54],dpl_data_shift[53]
                            };

            'd26:
                win_data <=
                            {
                                dpl_data_shift[41],dpl_data_shift[40],dpl_data_shift[39],dpl_data_shift[38],dpl_data_shift[37],
                                dpl_data_shift[36],dpl_data_shift[35],dpl_data_shift[34],dpl_data_shift[33],dpl_data_shift[32],
                                dpl_data_shift[31],
                                dpl_data_shift[30],dpl_data_shift[29],dpl_data_shift[28],dpl_data_shift[27],dpl_data_shift[26],
                                dpl_data_shift[57],dpl_data_shift[56],dpl_data_shift[55],dpl_data_shift[54],dpl_data_shift[53]
                            };
            'd27:
                win_data <=
                            {
                                dpl_data_shift[41],dpl_data_shift[40],dpl_data_shift[39],dpl_data_shift[38],dpl_data_shift[37],
                                dpl_data_shift[36],dpl_data_shift[35],dpl_data_shift[34],dpl_data_shift[33],dpl_data_shift[32],
                                dpl_data_shift[31],
                                dpl_data_shift[30],dpl_data_shift[29],dpl_data_shift[28],dpl_data_shift[27],dpl_data_shift[58],
                                dpl_data_shift[57],dpl_data_shift[56],dpl_data_shift[55],dpl_data_shift[54],dpl_data_shift[53]
                            };

            'd28:
                win_data <=
                            {
                                dpl_data_shift[41],dpl_data_shift[40],dpl_data_shift[39],dpl_data_shift[38],dpl_data_shift[37],
                                dpl_data_shift[36],dpl_data_shift[35],dpl_data_shift[34],dpl_data_shift[33],dpl_data_shift[32],
                                dpl_data_shift[31],
                                dpl_data_shift[30],dpl_data_shift[29],dpl_data_shift[28],dpl_data_shift[59],dpl_data_shift[58],
                                dpl_data_shift[57],dpl_data_shift[56],dpl_data_shift[55],dpl_data_shift[54],dpl_data_shift[53]
                            };

            'd29:
                win_data <=
                            {
                                dpl_data_shift[41],dpl_data_shift[40],dpl_data_shift[39],dpl_data_shift[38],dpl_data_shift[37],
                                dpl_data_shift[36],dpl_data_shift[35],dpl_data_shift[34],dpl_data_shift[33],dpl_data_shift[32],
                                dpl_data_shift[31],
                                dpl_data_shift[30],dpl_data_shift[29],dpl_data_shift[60],dpl_data_shift[59],dpl_data_shift[58],
                                dpl_data_shift[57],dpl_data_shift[56],dpl_data_shift[55],dpl_data_shift[54],dpl_data_shift[53]
                            };
            'd30:
                win_data <=
                            {
                                dpl_data_shift[41],dpl_data_shift[40],dpl_data_shift[39],dpl_data_shift[38],dpl_data_shift[37],
                                dpl_data_shift[36],dpl_data_shift[35],dpl_data_shift[34],dpl_data_shift[33],dpl_data_shift[32],
                                dpl_data_shift[31],
                                dpl_data_shift[30],dpl_data_shift[61],dpl_data_shift[60],dpl_data_shift[59],dpl_data_shift[58],
                                dpl_data_shift[57],dpl_data_shift[56],dpl_data_shift[55],dpl_data_shift[54],dpl_data_shift[53]
                            };
            'd31:
                win_data <=
                            {
                                dpl_data_shift[41],dpl_data_shift[40],dpl_data_shift[39],dpl_data_shift[38],dpl_data_shift[37],
                                dpl_data_shift[36],dpl_data_shift[35],dpl_data_shift[34],dpl_data_shift[33],dpl_data_shift[32],
                                dpl_data_shift[31],
                                dpl_data_shift[62],dpl_data_shift[61],dpl_data_shift[60],dpl_data_shift[59],dpl_data_shift[58],
                                dpl_data_shift[57],dpl_data_shift[56],dpl_data_shift[55],dpl_data_shift[54],dpl_data_shift[53]
                            };
            default:
                win_data <= 'd0 ;
        endcase
    end
end

always @(posedge clk)
begin
    if(rst)
        win_data_vliad <= 'd0 ;
    else
        win_data_vliad <= dpl_data_valid_shift[31] ;
end


endmodule
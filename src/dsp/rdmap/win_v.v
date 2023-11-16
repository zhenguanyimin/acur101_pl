module win_v
(
    input           clk              ,
    input           rst              ,

    input   [15:0]  data_in          ,
    input           data_valid       ,
    input           data_eop         ,
    input           data_sop         ,

    input  [15:0]   sample_num       ,
    input  [15:0]   chirp_num        ,

    output [15:0]   data_win_o       ,
    output          data_valid_win_o ,
    output          data_eop_win_o   ,
    output          data_sop_win_o
);

reg  [15:0]  data_in_d1 ;
reg  [15:0]  data_in_d2 ;
reg  [15:0]  data_in_d3 ;

reg  [15:0] data_valid_shift ;
reg  [15:0] data_eop_shift   ;
reg  [15:0] data_sop_shift   ;

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
    if(rst) begin
        data_in_d1 <= 'd0 ;
        data_in_d2 <= 'd0 ;
        data_in_d3 <= 'd0 ;
    end
    else begin
        data_in_d1 <= data_in    ;
        data_in_d2 <= data_in_d1 ;
        data_in_d3 <= data_in_d2 ;
    end
end

always @(posedge clk ) begin
    if(rst)
        data_valid_shift <= 'd0 ;
    else 
        data_valid_shift <={data_valid_shift[14:0],data_valid};
end

always @(posedge clk) begin
    if(rst)
        data_eop_shift <= 'd0 ;
    else
        data_eop_shift <= {data_eop_shift[14:0],data_eop};
end
always @(posedge clk) begin
    if(rst)
        data_sop_shift <= 'd0 ;
    else
        data_sop_shift <= {data_sop_shift[14:0],data_sop};
end

reg  [7 :0]   addr_offset;
wire [15:0]   rom_data   ;
reg  [7 :0]   addra      ;

rom_wim_v rom_wim_v
(
    .clka   (clk        ),
    .ena    (1'b1       ),
    .addra  (addra      ),
    .douta  (rom_data   )
);

always @(posedge clk) begin
    if(rst)
        addr_offset <= 'd0 ;
    else if(data_valid)
        if(data_eop)
            addr_offset <= 'd0 ;
        else 
            addr_offset <= addr_offset + 1'b1 ;
    else
        addr_offset <= 'd0 ;
end

always @(posedge clk) begin
    if(rst)
        addra <= 'd0 ;
    else 
        case (chirp_num_d2)
            'd32:
                addra <= 'd128 +  addr_offset ;
            'd64:
                addra <= 'd128 + 'd32 + addr_offset ; 
            'd128:
                addra <= 'd0 + addr_offset ;
            default: 
                addra <= addra ; 
        endcase
end

wire [31:0] mult_out ;

mult_s16_s16_d3 mult_s16_s16_d3
(
    .CLK    (clk        ), 
    .A      (data_in_d3 ),
    .B      (rom_data   ),
    .P      (mult_out   )
);

assign data_win_o        = mult_out[31:16]     ;
assign data_valid_win_o  = data_valid_shift[5] ;
assign data_eop_win_o    = data_eop_shift[5] ;
assign data_sop_win_o    = data_sop_shift[5] ;

endmodule
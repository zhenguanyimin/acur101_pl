module v_fft
(
    input               clk              ,
    input               rst              ,

    input   [31:0]      data_in          ,
    input               data_valid       ,
    input               data_sop         ,
    input               data_eop         ,

    input   wire [15:0] sample_num      ,
    input   wire [15:0] chirp_num       ,
    input   wire        config_trigger  ,

    output  reg [31:0]  fft_data_o       ,
    output  reg         fft_data_valid_o ,
    output  reg         fft_data_tlast_o ,

    output  reg [47:0]  rdmap_data        ,
    output  reg         rdmap_valid       ,
    output  reg         rdmap_sop         ,
    output  reg         rdmap_eop       

);

reg [31: 0] data_in_d1 = 'd0;
reg [31: 0] data_in_d2 = 'd0;
reg [31: 0] data_in_d3 = 'd0;

reg [7 : 0] data_valid_shift ;
reg [7 : 0] data_sop_shift   ;
reg [7 : 0] data_eop_shift   ;


reg [15:0]  sample_num_d1 ;
reg [15:0]  sample_num_d2 ;

reg [15:0]  chirp_num_d1 ;
reg [15:0]  chirp_num_d2 ;

reg         config_trigger_d1 ;
reg         config_trigger_d2 ;
reg         config_trigger_d3 ;


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
        config_trigger_d1 <= 'd0 ;
        config_trigger_d2 <= 'd0 ;
        config_trigger_d3 <= 'd0 ;
    end
    else begin
        config_trigger_d1 <= config_trigger ;
        config_trigger_d2 <= config_trigger_d1 ;
        config_trigger_d3 <= config_trigger_d2 ;
    end
end


always @(posedge clk) begin 
    if(rst) begin 
        data_in_d1 <= 'd0 ;
        data_in_d2 <= 'd0 ; 
        data_in_d3 <= 'd0 ;      
    end
    else begin
        data_in_d1 <= data_in   ;
        data_in_d2 <= data_in_d1;
        data_in_d3 <= data_in_d2;
    end
end

always @(posedge clk ) begin
    if(rst)
        data_valid_shift <= 'd0 ;
    else 
        data_valid_shift <= {data_valid_shift[6:0],data_valid} ;
end

always @(posedge clk ) begin
    if(rst)
        data_sop_shift <= 'd0 ;
    else 
        data_sop_shift <= {data_sop_shift[6:0],data_sop};
end

always @(posedge clk) begin
    if(rst)
        data_eop_shift <= 'd0 ;
    else
        data_eop_shift <= {data_eop_shift[6:0],data_eop};
end

wire [47:0] m_axis_data_tdata ;
wire        m_axis_data_tvalid;
wire        m_axis_data_tlast ;

reg [15:0]  config_tdata    ;
wire        config_tvalid   ;
wire        config_tready   ;

reg  op ;
always @(posedge clk) begin
    if(rst)
        op <= 'd0 ;
    else if(~config_trigger_d3 && config_trigger_d2 )
        op <= 'd1 ;
    else if(config_tready && config_tvalid)
        op <= 'd0 ;
    else 
        op <= op ;
end

assign config_tvalid = op ;

always @(posedge clk ) begin 
    if(rst) 
        config_tdata <= 'd0 ;
    else if(chirp_num_d2 == 'd32)
        config_tdata <= {8'd1,8'd5};
    else if(chirp_num_d2 == 'd64)
        config_tdata <= {8'd1,8'd6};
    else if(chirp_num_d2 == 'd128)
        config_tdata <= {8'd1,8'd7};
    else 
        config_tdata <= config_tdata ;
end


vfft vfft (

    .aclk                           (clk                        ),
    .aresetn                        (~rst                       ),
    .s_axis_config_tdata            (config_tdata               ),
    .s_axis_config_tvalid           (config_tvalid              ),//mark 1
    .s_axis_config_tready           (config_tready              ),
    .s_axis_data_tdata              (data_in_d2                 ),
    .s_axis_data_tvalid             (data_valid_shift[1]        ),
    .s_axis_data_tready             (                           ),
    .s_axis_data_tlast              (data_eop_shift[1]          ),
    .m_axis_data_tdata              (m_axis_data_tdata          ),
    .m_axis_data_tuser              (                           ),
    .m_axis_data_tvalid             (m_axis_data_tvalid         ),
    .m_axis_data_tready             (1'b1                       ),//mark 1
    .m_axis_data_tlast              (m_axis_data_tlast          ),
    .event_frame_started            (event_frame_started        ),
    .event_tlast_unexpected         (event_tlast_unexpected     ),
    .event_tlast_missing            (event_tlast_missing        ),
    .event_status_channel_halt      (event_status_channel_halt  ),
    .event_data_in_channel_halt     (event_data_in_channel_halt ),
    .event_data_out_channel_halt    (event_data_out_channel_halt)
);

reg [31:0]  m_axis_data_tvalid_cnt ;

always @(posedge clk) begin
    if(rst)
        m_axis_data_tvalid_cnt <= 'd0 ;
    else if( m_axis_data_tvalid)
        m_axis_data_tvalid_cnt <= m_axis_data_tvalid_cnt + 1'b1 ;
    else 
        m_axis_data_tvalid_cnt <= 'd0 ; 
end

always @(posedge clk) begin
    if(rst)
        fft_data_o <= 'd0 ;
    else 
        fft_data_o <= {m_axis_data_tdata[39:24] ,m_axis_data_tdata[15:0]};
end

always @(posedge clk) begin
    if(rst)
        fft_data_tlast_o <= 'd0 ;
    else if(m_axis_data_tvalid_cnt == 2048*32-1)
        fft_data_tlast_o <= 'd1 ;
    else 
        fft_data_tlast_o <= 'd0 ; 
end

always @(posedge clk) begin
    if(rst)
        fft_data_valid_o <= 'd0 ;
    else if(m_axis_data_tvalid && m_axis_data_tvalid_cnt < 2048*32)
        fft_data_valid_o <= 'd1 ;
    else 
        fft_data_valid_o <= 'd0 ; 
end

reg [23:0]  fft_data_re ;
reg [23:0]  fft_data_im ;

always @(posedge clk ) begin
    if(rst)
        fft_data_re <= 'd0 ;
    else 
        fft_data_re <= m_axis_data_tdata[23:0] ;
end

always @(posedge clk ) begin
    if(rst)
        fft_data_im <= 'd0 ;
    else 
        fft_data_im <= m_axis_data_tdata[47:24] ;
end

wire [47:0] mult_result_re ;
mult_s24_s24_d4 mult_s24_s24_d4_re
(
    .CLK    (clk            ),
    .A      (fft_data_re    ),
    .B      (fft_data_re    ),
    .P      (mult_result_re )
);

wire [47:0] mult_result_im ;
mult_s24_s24_d4 mult_s24_s24_d4_im
(
    .CLK    (clk            ),
    .A      (fft_data_im    ),
    .B      (fft_data_im    ),
    .P      (mult_result_im )
);

always @(posedge clk) begin
    if(rst)
        rdmap_data <= 'd0 ;
    else 
        rdmap_data <= mult_result_re + mult_result_im + 1;
end

reg [15:0]  m_axis_data_tvalid_shift;
always @(posedge clk) begin
    if(rst)
        m_axis_data_tvalid_shift <= 'd0 ;
    else
        m_axis_data_tvalid_shift <= {m_axis_data_tvalid_shift[14:0], fft_data_valid_o};
end

always @(posedge clk) begin
    if(rst)
        rdmap_valid <= 'd0 ;
    else
        rdmap_valid <= m_axis_data_tvalid_shift[3] ;
end

always @(posedge clk) begin
    if(rst)
        rdmap_sop <= 'd0 ;
    else if(m_axis_data_tvalid_shift[1] && ~m_axis_data_tvalid_shift[2])
        rdmap_sop <= 'd1 ;
    else
        rdmap_sop <= 'd0 ;
end

always @(posedge clk) begin
    if(rst)
        rdmap_eop <= 'd0 ;
    else if(~m_axis_data_tvalid_shift[2] && m_axis_data_tvalid_shift[3])
        rdmap_eop <= 'd1 ;
    else 
        rdmap_eop <= 'd0 ;
end


endmodule
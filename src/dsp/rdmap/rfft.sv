`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/06/21 16:44:52
// Design Name: 
// Module Name: fft
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

module rfft(

    input               clk             ,
    input               rst             ,

    input   wire [15:0] sample_num      ,
    input   wire [15:0] chirp_num       ,
    input   wire        config_trigger  ,
    input   wire [7 :0] rfft_truncation ,

    input   wire        win_r_data_valid,
    input   wire [31:0] win_r_data      ,
    input   wire        win_r_data_sop  ,
    input   wire        win_r_data_eop  ,

    output  reg         fft_r_data_valid,
    output  reg [31:0]  fft_r_data      ,
    output  reg         fft_r_data_sop  ,
    output  reg         fft_r_data_eop
);

    reg [15:0]  win_r_data_valid_shift;
    reg [31:0]  win_r_data_d1         ;
    reg [31:0]  win_r_data_d2         ;   
    reg [15:0]  win_r_data_sop_shift  ;
    reg [15:0]  win_r_data_eop_shift  ;

    //----//----//----//----//----//----//----//---- IP-FFT  //----//----//----//----//----//----//----//----
wire          s_axis_config_tready;
reg  [31 : 0] s_axis_data_tdata  ='d0;
reg           s_axis_data_tvalid ='d0;
wire          s_axis_data_tready ;
wire          s_axis_data_tlast  ;
wire [63 : 0] m_axis_data_tdata  ;
wire [15 : 0] m_axis_data_tuser  ;
wire          m_axis_data_tvalid ;
wire          m_axis_data_tlast  ;

wire event_frame_started         ;
wire event_tlast_unexpected      ;
wire event_tlast_missing         ;
wire event_status_channel_halt   ;
wire event_data_in_channel_halt  ;
wire event_data_out_channel_halt ;

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
    if(rst)
        win_r_data_valid_shift <= 'd0 ;
    else 
        win_r_data_valid_shift <= {win_r_data_valid_shift[14:0],win_r_data_valid};
end

always @(posedge clk) begin
    if(rst)
        win_r_data_sop_shift <= 'd0 ;
    else 
        win_r_data_sop_shift <= {win_r_data_sop_shift[14:0],win_r_data_sop};
end

always @(posedge clk) begin
    if(rst)
        win_r_data_eop_shift <= 'd0 ;
    else 
        win_r_data_eop_shift <= {win_r_data_eop_shift[14:0],win_r_data_eop};
end

always @(posedge clk) begin
    if(rst) begin
        win_r_data_d1 <= 'd0 ;
        win_r_data_d2 <= 'd0 ;
    end
    else begin
        win_r_data_d1 <= win_r_data    ;
        win_r_data_d2 <= win_r_data_d1 ;
    end
end


reg [7 :0]  rfft_truncation_d1 ;
reg [7 :0]  rfft_truncation_d2 ;

always @(posedge clk) begin
    if(rst) begin
        rfft_truncation_d1 <= 'd0 ;
        rfft_truncation_d2 <= 'd0 ;
    end
    else begin
        rfft_truncation_d1 <= rfft_truncation ;
        rfft_truncation_d2 <= rfft_truncation_d1 ;            
    end
end


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
        config_tdata <= {8'd1,8'd12};
    else if(chirp_num_d2 == 'd64)
        config_tdata <= {8'd1,8'd11};
    else if(chirp_num_d2 == 'd128)
        config_tdata <= {8'd1,8'd10};
    else 
        config_tdata <= config_tdata ;
end

assign      s_axis_data_tlast = win_r_data_eop ;
//----//----//----//----//----//----//----//---- IP-FFT  //----//----//----//----//----//----//----//----

xfft_0 u_xfft_0 (
    .aclk                           (clk                        ),
    .aresetn                        (1'b1                       ),
    .s_axis_config_tdata            (config_tdata               ),
    .s_axis_config_tvalid           (config_tvalid              ),//mark 1
    .s_axis_config_tready           (config_tready              ),
    .s_axis_data_tdata              (win_r_data                 ),
    .s_axis_data_tvalid             (win_r_data_valid           ),
    .s_axis_data_tready             (                           ),
    .s_axis_data_tlast              (s_axis_data_tlast          ),
    .m_axis_data_tdata              (m_axis_data_tdata          ),
    .m_axis_data_tuser              (m_axis_data_tuser          ),
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

//-------------------------------------fft_config-------------------------------------------------------
reg [3:0]   config_cnt ;
always @(posedge clk) begin
    if(rst)
        config_cnt <= 'd0 ;
    else 
        config_cnt <= 'd0 ;
end

//----//----//----//----//----//----//----//----  input //----//----//----//----//----//----//----//----

reg [63:0]  m_axis_data_tdata_d1 ;
reg [63:0]  m_axis_data_tdata_d2 ;
reg [63:0]  m_axis_data_tdata_d3 ;
reg [3 :0]  m_axis_data_tvalid_shift;

always @(posedge clk) begin 
    if(rst)
        m_axis_data_tvalid_shift <= 'd0 ;
    else 
        m_axis_data_tvalid_shift <= {m_axis_data_tvalid_shift[2:0],m_axis_data_tvalid};
end

always @(posedge clk) begin
    if(rst) begin
        m_axis_data_tdata_d1 <= 'd0 ;
        m_axis_data_tdata_d2 <= 'd0 ;
        m_axis_data_tdata_d3 <= 'd0 ;
    end
    else begin
        m_axis_data_tdata_d1 <= m_axis_data_tdata    ;
        m_axis_data_tdata_d2 <= m_axis_data_tdata_d1 ;
        m_axis_data_tdata_d3 <= m_axis_data_tdata_d2 ;
    end 
end

always @(posedge clk) begin
    if(rst)
        fft_r_data_valid <= 'd0 ;
    else
        fft_r_data_valid <= m_axis_data_tvalid_shift[2] ;
end

always @(posedge clk) begin
    if(rst)
        fft_r_data <= 'd0 ;
    else begin
        case (rfft_truncation_d2)
            'd1 :
                    begin
                        fft_r_data[15: 0] <= m_axis_data_tdata_d3[16   : 1] ;
                        fft_r_data[31:16] <= m_axis_data_tdata_d3[16+32: 1+32] ;
                    end
            'd2 :
                    begin
                        fft_r_data[15: 0] <= m_axis_data_tdata_d3[17   : 2] ;
                        fft_r_data[31:16] <= m_axis_data_tdata_d3[17+32: 2+32] ;
                    end
            'd3 :
                    begin
                        fft_r_data[15: 0] <= m_axis_data_tdata_d3[18   : 3] ;
                        fft_r_data[31:16] <= m_axis_data_tdata_d3[18+32: 3+32] ;
                    end
            'd4 :
                    begin
                        fft_r_data[15: 0] <= m_axis_data_tdata_d3[19   : 4] ;
                        fft_r_data[31:16] <= m_axis_data_tdata_d3[19+32: 4+32] ;
                    end
            'd5 :
                    begin
                        fft_r_data[15: 0] <= m_axis_data_tdata_d3[20   : 5] ;
                        fft_r_data[31:16] <= m_axis_data_tdata_d3[20+32: 5+32] ;
                    end
            'd6 :
                    begin
                        fft_r_data[15: 0] <= m_axis_data_tdata_d3[21   : 6] ;
                        fft_r_data[31:16] <= m_axis_data_tdata_d3[21+32: 6+32] ;
                    end
            'd7 :
                    begin
                        fft_r_data[15: 0] <= m_axis_data_tdata_d3[22   : 7] ;
                        fft_r_data[31:16] <= m_axis_data_tdata_d3[22+32: 7+32] ;
                    end
            'd8 :
                    begin
                        fft_r_data[15: 0] <= m_axis_data_tdata_d3[23   : 8] ;
                        fft_r_data[31:16] <= m_axis_data_tdata_d3[23+32: 8+32] ;
                    end
            'd9:
                    begin
                        fft_r_data[15: 0] <= m_axis_data_tdata_d3[24   : 9] ;
                        fft_r_data[31:16] <= m_axis_data_tdata_d3[24+32: 9+32] ;
                    end
            'd10:
                    begin
                        fft_r_data[15: 0] <= m_axis_data_tdata_d3[25   : 10] ;
                        fft_r_data[31:16] <= m_axis_data_tdata_d3[25+32: 10+32] ;
                    end
            'd11:
                    begin
                        fft_r_data[15: 0] <= m_axis_data_tdata_d3[26   : 11] ;
                        fft_r_data[31:16] <= m_axis_data_tdata_d3[26+32: 11+32] ;
                    end
            'd12:
                    begin
                        fft_r_data[15: 0] <= m_axis_data_tdata_d3[27   : 12] ;
                        fft_r_data[31:16] <= m_axis_data_tdata_d3[27+32: 12+32] ;
                    end
            'd13:
                    begin
                        fft_r_data[15: 0] <= m_axis_data_tdata_d3[28   : 13] ;
                        fft_r_data[31:16] <= m_axis_data_tdata_d3[28+32: 13+32] ;
                    end
            'd14:
                    begin
                        fft_r_data[15: 0] <= m_axis_data_tdata_d3[29   : 14] ;
                        fft_r_data[31:16] <= m_axis_data_tdata_d3[29+32: 14+32] ;
                    end
            'd15:
                    begin
                        fft_r_data[15: 0] <= m_axis_data_tdata_d3[30   : 15] ;
                        fft_r_data[31:16] <= m_axis_data_tdata_d3[30+32: 15+32] ;
                    end
            default:
                    begin
                        fft_r_data[15: 0] <= m_axis_data_tdata_d3[23   : 8] ;
                        fft_r_data[31:16] <= m_axis_data_tdata_d3[23+32: 8+32] ;
                    end
        endcase
    end
end

always @(posedge clk) begin
    if(rst)
        fft_r_data_eop <=  'd0 ;
    else if(~m_axis_data_tvalid_shift[1] && m_axis_data_tvalid_shift[2])
        fft_r_data_eop <= 'd1 ;
    else
        fft_r_data_eop <= 'd0 ;
end

always @(posedge clk) begin
    if(rst)
        fft_r_data_sop <= 'd0 ;
    else if(m_axis_data_tvalid_shift[2] && ~m_axis_data_tvalid_shift[3])
        fft_r_data_sop <= 'd1 ;
    else 
        fft_r_data_sop <= 'd0 ;
end

endmodule

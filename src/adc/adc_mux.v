module adc_mux
(
    input               clk ,
    input               rst ,

    input  wire         adc_mux_s        ,
    input  wire[15:0]   adc_ch0_data_cha ,
    input  wire         adc_ch0_sop_cha  ,
    input  wire         adc_ch0_eop_cha  ,
    input  wire         adc_ch0_valid_cha,
    input  wire[15:0]   adc_ch0_data_chb ,
    input  wire         adc_ch0_sop_chb  ,
    input  wire         adc_ch0_eop_chb  ,
    input  wire         adc_ch0_valid_chb,

    input  wire[15:0]   adc_ch1_data_cha ,
    input  wire         adc_ch1_sop_cha  ,
    input  wire         adc_ch1_eop_cha  ,
    input  wire         adc_ch1_valid_cha,
    input  wire[15:0]   adc_ch1_data_chb ,
    input  wire         adc_ch1_sop_chb  ,
    input  wire         adc_ch1_eop_chb  ,
    input  wire         adc_ch1_valid_chb,

    output reg [15:0]   adc_data_cha ,
    output reg          adc_data_sop_cha  ,
    output reg          adc_data_eop_cha  ,
    output reg          adc_data_valid_cha,
    
    output reg [15:0]   adc_data_chb ,
    output reg          adc_data_sop_chb  ,
    output reg          adc_data_eop_chb  ,
    output reg          adc_data_valid_chb
);

reg     adc_mux_d1 ='d0 ;
reg     adc_mux_d2 ='d0 ;

always @(posedge clk) begin
    adc_mux_d1 <= adc_mux_s ;
    adc_mux_d2 <= adc_mux_d1 ; 
end

always @(posedge clk) begin
    if(rst) begin
        adc_data_cha   <= 'd0 ; 
        adc_data_sop_cha    <= 'd0 ;
        adc_data_eop_cha    <= 'd0 ;
        adc_data_valid_cha  <= 'd0 ;
        
        adc_data_chb   <= 'd0 ; 
        adc_data_sop_chb    <= 'd0 ;
        adc_data_eop_chb    <= 'd0 ;
        adc_data_valid_chb  <= 'd0 ;
    end
    else if (adc_mux_d2 == 'd1 ) begin
        adc_data_cha   <= adc_ch1_data_cha  ; 
        adc_data_sop_cha    <= adc_ch1_sop_cha   ;
        adc_data_eop_cha    <= adc_ch1_eop_cha   ;
        adc_data_valid_cha  <= adc_ch1_valid_cha ;
        adc_data_chb   <= adc_ch1_data_chb  ;
        adc_data_sop_chb    <= adc_ch1_sop_chb   ;
        adc_data_eop_chb    <= adc_ch1_eop_chb   ;
        adc_data_valid_chb  <= adc_ch1_valid_chb ;
    end
    else begin
        adc_data_cha   <= adc_ch0_data_cha  ;
        adc_data_sop_cha    <= adc_ch0_sop_cha   ;
        adc_data_eop_cha    <= adc_ch0_eop_cha   ;
        adc_data_valid_cha  <= adc_ch0_valid_cha ;
        adc_data_chb   <= adc_ch0_data_chb  ;
        adc_data_sop_chb    <= adc_ch0_sop_chb   ;
        adc_data_eop_chb    <= adc_ch0_eop_chb   ;
        adc_data_valid_chb  <= adc_ch0_valid_chb ;
    end
end

endmodule 
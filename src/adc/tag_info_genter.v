
module tag_info_genter (
    input           clk         ,
    input           rst         ,

    input           pil_mode    ,
    input           pil_triger  ,
    input           PRI         ,
    input           CPIB        ,
    input           CPIE        ,
    input           sample_gate ,
    input           dma_ready   ,

    input [31:0]    waveType    ,
    input [8*8-1:0] timestamp   ,
    input [15:0]    azimuth     ,
    input [15:0]    elevation   ,
    input [7:0]     aziScanCenter,
    input [7:0]     aziScanScope ,
    input [7:0]     eleScanCenter,
    input [7:0]     eleScanScope,
    input [7:0]     trackTwsTasFlag,
    input [7:0]     last_wave   ,
    input [15:0]    pri_period  ,
    input [15:0]    start_sample,
    input [7:0]     wave_position,
    output[8*32-1:0]tag_info_o
);

reg [8*32-1:0]tag_info ; 
reg [31:0]    waveType_d1 ='d0 ; 
reg [8*8-1:0] timestamp_d1='d0 ;
reg [15:0]    azimuth_d1='d0 ;  
reg [15:0]    elevation_d1='d0;
reg [7:0]     aziScanCenter_d1='d0;
reg [7:0]     aziScanScope_d1='d0;
reg [7:0]     eleScanCenter_d1='d0;
reg [7:0]     eleScanScope_d1='d0;
reg [7:0]     trackTwsTasFlag_d1='d0;
reg [7:0]     last_wave_d1='d0;
reg [15:0]    pri_period_d1='d0;
reg [15:0]    start_sample_d1='d0;
reg [7:0]     wave_position_d1='d0;

reg [31:0]    waveType_d2 ='d0 ; 
reg [8*8-1:0] timestamp_d2='d0 ;
reg [15:0]    azimuth_d2='d0 ;  
reg [15:0]    elevation_d2='d0;
reg [7:0]     aziScanCenter_d2='d0;
reg [7:0]     aziScanScope_d2='d0;
reg [7:0]     eleScanCenter_d2='d0;
reg [7:0]     eleScanScope_d2='d0;
reg [7:0]     trackTwsTasFlag_d2='d0;
reg [7:0]     last_wave_d2='d0;
reg [15:0]    pri_period_d2='d0;
reg [15:0]    start_sample_d2='d0;
reg [7:0]     wave_position_d2='d0;


reg [31:0]    waveType_sync ='d0 ; 
reg [8*8-1:0] timestamp_sync='d0 ;
reg [15:0]    azimuth_sync='d0 ;  
reg [15:0]    elevation_sync='d0;
reg [7:0]     aziScanCenter_sync='d0;
reg [7:0]     aziScanScope_sync='d0;
reg [7:0]     eleScanCenter_sync='d0;
reg [7:0]     eleScanScope_sync='d0;
reg [7:0]     trackTwsTasFlag_sync='d0;
reg [7:0]     last_wave_sync='d0;
reg [15:0]    pri_period_sync='d0;
reg [15:0]    start_sample_sync='d0;
reg [7:0]     wave_position_sync='d0;

reg           pil_mode_d1 ='d0;
reg           pil_mode_d2 ='d0; 

reg           dma_ready_d1 = 'd0 ;
reg           dma_ready_d2 = 'd0 ;

reg           pil_triger_d1='d0;
reg           pil_triger_d2='d0;
reg           pil_triger_d3='d0;
reg           pil_triger_d4='d0;

always @(posedge clk) begin
    pil_mode_d1 <= pil_mode ;
    pil_mode_d2 <= pil_mode_d1;
end

always @(posedge clk) begin
    dma_ready_d1 <= dma_ready ;
    dma_ready_d2 <= dma_ready_d1 ;
end

always @(posedge clk) begin
    pil_triger_d1 <= pil_triger ;
    pil_triger_d2 <= pil_triger_d1;
    pil_triger_d3 <= pil_triger_d2;
    pil_triger_d4 <= pil_triger_d3;
end

reg [31:0]    frame_id;

always @(posedge clk) begin
    waveType_d1         <=  waveType          ;
    timestamp_d1        <=  timestamp         ;
    azimuth_d1          <=  azimuth           ;
    elevation_d1        <=  elevation         ;
    aziScanCenter_d1    <=  aziScanCenter     ;
    aziScanScope_d1     <=  aziScanScope      ;
    eleScanCenter_d1    <=  eleScanCenter     ;
    eleScanScope_d1     <=  eleScanScope      ;
    trackTwsTasFlag_d1  <=  trackTwsTasFlag   ;
    last_wave_d1        <=  last_wave         ;
    pri_period_d1       <=  pri_period        ;
    start_sample_d1     <=  start_sample      ;
    wave_position_d1    <=  wave_position     ;

    waveType_d2         <=  waveType_d1       ;
    timestamp_d2        <=  timestamp_d1      ;
    azimuth_d2          <=  azimuth_d1        ;
    elevation_d2        <=  elevation_d1      ;
    aziScanCenter_d2    <=  aziScanCenter_d1  ;
    aziScanScope_d2     <=  aziScanScope_d1   ;
    eleScanCenter_d2    <=  eleScanCenter_d1  ;
    eleScanScope_d2     <=  eleScanScope_d1   ;
    trackTwsTasFlag_d2  <=  trackTwsTasFlag_d1;
    last_wave_d2        <=  last_wave_d1      ;
    pri_period_d2       <=  pri_period_d1     ;
    start_sample_d2     <=  start_sample_d1   ;
    wave_position_d2    <=  wave_position_d1  ;
end

// ----------------------------------------------tag_info generate-------------------------------------

reg         CPIE_d1 = 'd0;
reg         CPIE_d2 = 'd0;
reg         CPIE_d3 = 'd0;
reg         CPIE_d4 = 'd0;
reg         cpie_pos     ;

always @(posedge clk) begin
    CPIE_d1 <= CPIE ;
    CPIE_d2 <= CPIE_d1;
    CPIE_d3 <= CPIE_d2;
    CPIE_d4 <= CPIE_d3;
end

always @(posedge clk) begin
    if(rst)
        cpie_pos <= 'd0 ;
    else if(~CPIE_d4 && CPIE_d3 && dma_ready_d2)
        cpie_pos <= 'd1 ;
    else 
        cpie_pos <= 'd0 ;
end

always @(posedge clk) begin
    if(rst) begin
        waveType_sync       <='d0 ; 
        timestamp_sync      <='d0 ;
        azimuth_sync        <='d0 ;  
        elevation_sync      <='d0;
        aziScanCenter_sync  <='d0;
        aziScanScope_sync   <='d0;
        eleScanCenter_sync  <='d0;
        eleScanScope_sync   <='d0;
        trackTwsTasFlag_sync<='d0;
        last_wave_sync      <='d0;
        pri_period_sync     <='d0;
        start_sample_sync   <='d0;
        wave_position_sync  <='d0;
    end
    else if(cpie_pos || pil_mode_d2 ) begin
        waveType_sync       <= waveType_d2       ;
        timestamp_sync      <= timestamp_d2      ;
        azimuth_sync        <= azimuth_d2        ;
        elevation_sync      <= elevation_d2      ;
        aziScanCenter_sync  <= aziScanCenter_d2  ;
        aziScanScope_sync   <= aziScanScope_d2   ;
        eleScanCenter_sync  <= eleScanCenter_d2  ;
        eleScanScope_sync   <= eleScanScope_d2   ;
        trackTwsTasFlag_sync<= trackTwsTasFlag_d2;
        last_wave_sync      <= last_wave_d2      ;
        pri_period_sync     <= pri_period_d2     ;
        start_sample_sync   <= start_sample_d2   ;
        wave_position_sync  <= wave_position_d2  ;
    end
    else begin
        waveType_sync       <= waveType_sync       ;
        timestamp_sync      <= timestamp_sync      ;
        azimuth_sync        <= azimuth_sync        ;
        elevation_sync      <= elevation_sync      ;
        aziScanCenter_sync  <= aziScanCenter_sync  ;
        aziScanScope_sync   <= aziScanScope_sync   ;
        eleScanCenter_sync  <= eleScanCenter_sync  ;
        eleScanScope_sync   <= eleScanScope_sync   ;
        trackTwsTasFlag_sync<= trackTwsTasFlag_sync;
        last_wave_sync      <= last_wave_sync      ;
        pri_period_sync     <= pri_period_sync     ;
        start_sample_sync   <= start_sample_sync   ;
        wave_position_sync  <= wave_position_sync  ; 
    end
end

always @(posedge clk) begin
    if(rst)
        frame_id <= 'd0 ;
    else if(pil_mode_d2)
        if(pil_triger_d3 && ~pil_triger_d4)
            frame_id <= frame_id + 1'b1;
        else 
            frame_id <= frame_id;
    else if(cpie_pos)
        frame_id <= frame_id + 1'b1 ;
    else
        frame_id <= frame_id ;
end

always @(posedge clk) begin
    if(rst)
        tag_info <= 'd0 ;
    else if(cpie_pos || pil_mode_d2) begin
        tag_info[8*4-1:0]       <=  frame_id            ;
        tag_info[8*8-1:8*4]     <=  waveType_sync       ;
        tag_info[8*16-1:8*8]    <=  timestamp_sync      ;
        tag_info[8*18-1:8*16]   <=  azimuth_sync        ;
        tag_info[8*20-1:8*18]   <=  elevation_sync      ;
        tag_info[8*21-1:8*20]   <=  aziScanCenter_sync  ;
        tag_info[8*22-1:8*21]   <=  aziScanScope_sync   ;
        tag_info[8*23-1:8*22]   <=  eleScanCenter_sync  ;
        tag_info[8*24-1:8*23]   <=  eleScanScope_sync   ;
        tag_info[8*25-1:8*24]   <=  trackTwsTasFlag_sync;
        tag_info[8*26-1:8*25]   <=  last_wave_sync      ;
        tag_info[8*28-1:8*26]   <=  pri_period_sync     ;
        tag_info[8*30-1:8*28]   <=  start_sample_sync   ;
        tag_info[8*31-1:8*30]   <=  wave_position_sync  ;
        tag_info[8*32-1:8*31]   <=  8'h5a ;
    end
    else 
        tag_info <= tag_info ;
end

assign tag_info_o = tag_info ;

endmodule

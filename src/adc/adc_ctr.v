module adc_ctr
(
    input   wire        clk                  ,
    input   wire        rst                      ,
    input   wire        dma_ready                ,

    input   wire        PRI                      ,
    input   wire        CPIB                     ,
    input   wire        CPIE                     ,
    input   wire        sample_gate              ,

    input   wire [15:0] sample_num               ,
    input   wire [15:0] chirp_num                ,

    input   wire [15:0] adc_threshold            ,
    output  wire [31:0] adc_abnormal_num_max     ,
    output  wire [31:0] adc_abnormal_num         ,
    output  reg         adc_abnormal_irp         ,

    input   wire [15:0] adc_data_cha             ,
    input   wire [15:0] adc_data_chb             ,
    input   wire        adc_data_valid           ,

    output  wire        adc_data_sop_cha         ,
    output  wire        adc_data_eop_cha         ,
    output  wire [15:0] adc_data_cha_o           ,
    output  wire        adc_data_valid_cha       ,

    output  wire        adc_data_sop_chb         ,
    output  wire        adc_data_eop_chb         ,
    output  wire [15:0] adc_data_chb_o           ,
    output  wire        adc_data_valid_chb                     
);



adc_pack adc_pack_add
(
    .clk                (clk                ),
    .rst                (rst                ),
    .dma_ready          (dma_ready          ),

    .PRI                (PRI                ),
    .CPIB               (CPIB               ),
    .CPIE               (CPIE               ),
    .sample_gate        (sample_gate        ),

    .sample_num         (sample_num         ),
    .chirp_num          (chirp_num          ),

    .adc_data_i         (adc_data_cha       ),
    .adc_data_valid_i   (adc_data_valid     ),

    .adc_data_sop       (adc_data_sop_cha   ),
    .adc_data_eop       (adc_data_eop_cha   ),
    .adc_data           (adc_data_cha_o     ),
    .adc_data_valid     (adc_data_valid_cha )
);

adc_pack adc_pack_sub
(
    .clk                (clk                ),
    .rst                (rst                ),
    .dma_ready          (dma_ready          ),

    .PRI                (PRI                ),
    .CPIB               (CPIB               ),
    .CPIE               (CPIE               ),
    .sample_gate        (sample_gate        ),

    .sample_num         (sample_num         ),
    .chirp_num          (chirp_num          ),

    .adc_data_i         (adc_data_chb       ),
    .adc_data_valid_i   (adc_data_valid     ),

    .adc_data_sop       (adc_data_sop_chb   ),
    .adc_data_eop       (adc_data_eop_chb   ),
    .adc_data           (adc_data_chb_o     ),
    .adc_data_valid     (adc_data_valid_chb )
);


//------------------------------------adc 饱和检测-----------------------------------
reg        adc_data_sop_cha_reg   ='d0;
reg        adc_data_eop_cha_reg   ='d0;
reg [15:0] adc_data_cha_o_reg     ='d0;
reg        adc_data_valid_cha_reg ='d0;

reg        adc_data_sop_chb_reg   ='d0;
reg        adc_data_eop_chb_reg   ='d0;
reg [15:0] adc_data_chb_o_reg     ='d0;
reg        adc_data_valid_chb_reg ='d0;

reg [15:0] adc_threshold_d1 ='d0;
reg [15:0] adc_threshold_d2 ='d0;

always @(posedge clk) begin
    adc_data_sop_cha_reg    <=  adc_data_sop_cha  ; 
    adc_data_eop_cha_reg    <=  adc_data_eop_cha  ; 
    adc_data_cha_o_reg      <=  adc_data_cha_o    ; 
    adc_data_valid_cha_reg  <=  adc_data_valid_cha; 
end

always @(posedge clk) begin
    adc_data_sop_chb_reg    <= adc_data_sop_chb  ;
    adc_data_eop_chb_reg    <= adc_data_eop_chb  ;
    adc_data_chb_o_reg      <= adc_data_chb_o    ;
    adc_data_valid_chb_reg  <= adc_data_valid_chb;
end

always @(posedge clk) begin
    adc_threshold_d1    <=  adc_threshold ; 
    adc_threshold_d2    <=  adc_threshold_d1 ;
end

reg [31:0]  adc_abnormal_cnt ;
reg [31:0]  adc_abnormal_num_cha ;
reg [31:0]  adc_abnormal_num_max_cha;

always @(posedge clk) begin
    if(rst)
        adc_abnormal_cnt <= 'd0 ;
    else if(adc_data_valid_cha_reg)
        if(adc_data_cha_o_reg == 16'h7fff || adc_data_cha_o_reg == 16'h8000)
            adc_abnormal_cnt <= adc_abnormal_cnt + 1'b1 ;
        else 
            adc_abnormal_cnt <= adc_abnormal_cnt ;
    else
        adc_abnormal_cnt <= 'd0 ;
end

always @(posedge clk) begin
    if(rst)
        adc_abnormal_num_cha <= 'd0 ;
    else if(adc_data_eop_cha_reg)
        adc_abnormal_num_cha <= adc_abnormal_cnt ;
    else 
        adc_abnormal_num_cha <= adc_abnormal_num_cha ;
end

assign adc_abnormal_num = adc_abnormal_num_cha ;
assign adc_abnormal_num_max = adc_abnormal_num_max_cha ; 

always @(posedge clk) begin
    if(rst)
        adc_abnormal_num_max_cha <= 'd0 ;
    else if(adc_data_eop_cha_reg && adc_abnormal_num_max_cha >adc_abnormal_num_cha)
        adc_abnormal_num_max_cha <=  adc_abnormal_num_cha ;
    else 
        adc_abnormal_num_max_cha <= adc_abnormal_num_max_cha ;
end
always @(posedge clk) begin
    if(rst)
        adc_abnormal_irp <= 'd0 ;
    else if(adc_data_eop_cha_reg && adc_abnormal_num_cha > adc_threshold_d2)
        adc_abnormal_irp <= 'd1 ;
    else 
        adc_abnormal_irp <= 'd0 ;    
end

endmodule

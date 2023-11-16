//----------------------------------------------------------------------------------------
//
//                              case5 : ADC SLI 数据注入仿真  
//                           SLI 采集模式 :     128*1024
//
//----------------------------------------------------------------------------------------

parameter       CHIRP_NUM  = 16'd128;
parameter       SAMPLE_NUM = 16'd1024 ;
reg [31:0]      adc_tdata ;
reg             adc_tvalid;
reg             adc_tlast ;
// reg             adc_terady;

assign top.M_AXIS_MM2S_dma1_tdata  = adc_tdata ;
assign top.M_AXIS_MM2S_dma1_tlast  = adc_tlast ;
assign top.M_AXIS_MM2S_dma1_tvalid = adc_tvalid ;

reg [31:0]      reg_data ;
reg [15:0]      pri_period ;          
reg [15:0]      cpi_delay ;
reg [7:0]       pri_num ;
reg [7:0]       pri_pulse_width ;
reg [15:0]      sample_length ;
reg [15:0]      start_sample ;
reg [15:0]      index1 ;
reg [15:0]      index0 ;

initial begin

    pri_period = 16'd5300 ;
    cpi_delay = 16'd2000 ;
    pri_num = 8'd64 ;
    pri_pulse_width = 8'd40 ;
    sample_length = 16'd2049;
    start_sample = 16'd1000;

    adc_tdata   = 'd0 ;
    adc_tlast   = 'd0 ;
    adc_tvalid  = 'd0 ;
    index0      = 'd0 ;
    index1      = 'd1 ;

    wait(~top.sys_rst) ;
    #10000 ;
    //----------------------- 设置波形-------------------------------------
    set_register (32'h800203a0,{pri_period,cpi_delay},4'hf);
    set_register (32'h800203a4,{16'd0,pri_pulse_width,pri_num},4'hf);
    set_register (32'h800203a8,{sample_length,start_sample},4'hf);   
    read_register(32'h80021034,reg_data);
    $display("sample num :%d , chirp num : %d \n",reg_data[31:16],reg_data[15:0]);
    set_register (32'h80021034,{SAMPLE_NUM,CHIRP_NUM},4'hf) ;       // 设置波形寄存器
    read_register(32'h80021034,reg_data) ;
    set_register (32'h80021000,'d1,4'hf) ;       // 设置数据注入模式


    $display("sample num :%d , chirp num : %d \n",reg_data[31:16],reg_data[15:0]);
    $display("addr: h8002_0390 data : %h ",reg_data) ;
    $display("-----------------------plat_form sim : case4 ----------------------------\n");
    while (1) begin
        for(int i = 0 ; i < SAMPLE_NUM /2  ; i = i + 1) begin
            adc_tvalid  = 1'b1 ;
            adc_tdata   = {index0,index1};
            index1 = index1 + 2 ;
            index0 = index0 + 2 ;
            if(i == SAMPLE_NUM/2 -1 )
                adc_tlast = 1'b1 ;
            else 
                adc_tlast = 1'b0 ; 
            @(posedge top.ps_clk_200m) ;
        end
        adc_tlast = 1'b0 ;
        adc_tvalid= 1'b0 ;
        index1 = 'd1 ;
        index0 = 'd0 ;      
        repeat (10000) @(posedge top.ps_clk_200m); 
    end
end
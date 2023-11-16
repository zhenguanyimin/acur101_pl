//----------------------------------------------------------------------------------------
//
//                              case3 : ADC 采集模块仿真  
//                           ADC 采集模式 :     2048*64
//
//----------------------------------------------------------------------------------------

reg [15:0]      adc_data ;
assign          top.adc_rx_top.serila_lvds_adc3663.adc3663_data = adc_data ;
reg [31:0]      data ;
reg [15:0]      pri_period ;          
reg [15:0]      cpi_delay ;
reg [7:0]       pri_num ;
reg [7:0]       pri_pulse_width ;
reg [15:0]      sample_length ;
reg [15:0]      start_sample ;

initial begin

    pri_period = 16'd5300 ;
    cpi_delay = 16'd2000 ;
    pri_num = 8'd64 ;
    pri_pulse_width = 8'd40 ;
    sample_length = 16'd2049;
    start_sample = 16'd1000;
    adc_data = 'd0 ;
    wait(~top.sys_rst) ;
    #10000 ;
    //----------------------- 设置波形-------------------------------------
    set_register (32'h800203a0,{pri_period,cpi_delay},4'hf);
    set_register (32'h800203a4,{16'd0,pri_pulse_width,pri_num},4'hf);
    set_register (32'h800203a8,{sample_length,start_sample},4'hf);   
    read_register(32'h80021034,data);
    $display("sample num :%d , chirp num : %d \n",data[31:16],data[15:0]);
    set_register (32'h80021034,{16'd2048,16'd64},4'hf) ;       // 设置波形寄存器
    read_register(32'h80021034,data) ;

    $display("sample num :%d , chirp num : %d \n",data[31:16],data[15:0]);
    $display("addr: h8002_0390 data : %h ",data) ;
    $display("-----------------------plat_form sim : case3 ----------------------------\n");
    while (1) begin
        @(posedge top.adc_rx_top.adc_gather.adc_dclk) ;
        if(top.adc_rx_top.adc_gather.sample_gate && top.adc_rx_top.adc_gather.adc3663_data_valid)
            if(adc_data == 'd4095)
                adc_data = 'd0  ;
            else 
                adc_data = adc_data + 1'b1  ;
        else 
            adc_data = adc_data ;
    end
end
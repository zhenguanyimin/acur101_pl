//----------------------------------------------------------------------------------------
//
//                              case1 : ADC 采集模块仿真  
//                           ADC 采集模式 :  1024*128
//
//----------------------------------------------------------------------------------------

reg [15:0]      adc_data_a ;
reg [15:0]      adc_data_b ;
reg             adc_data_valid;
reg [31:0]      data;
reg [2:0]       adc_data_valid_cnt;

assign          top.adc_rx_top.adc3663_data_cha = adc_data_a;
assign          top.adc_rx_top.adc3663_data_chb = adc_data_b;
assign          top.adc_rx_top.adc3663_data_valid = adc_data_valid;

//-----------------------------------设置波形参数-------------------------------------------

reg [15:0]      pri_period ;          
reg [15:0]      cpi_delay ;
reg [7:0]       pri_num ;
reg [7:0]       pri_pulse_width ;
reg [15:0]      sample_length ;
reg [15:0]      start_sample ;


initial begin
    $display("-----------------------plat_form sim : case1 ----------------------------\n");
    pri_period = 16'd1400 ;
    cpi_delay = 16'd2000 ;
    pri_num = 8'd128 ;
    pri_pulse_width = 8'd40 ;
    sample_length = 16'd1025;
    start_sample = 16'd100;
    adc_data_a = 'd0 ;
    adc_data_b = 'd0 ;
    adc_data_valid ='d0;
    adc_data_valid_cnt ='d0;
    wait(~top.sys_rst) ;
    #10000 ;
    //----------------------- 设置波形-------------------------------------
    set_register (32'h800203a0,{pri_period,cpi_delay},4'hf);
    set_register (32'h800203a4,{16'd0,pri_pulse_width,pri_num},4'hf);
    set_register (32'h800203a8,{sample_length,start_sample},4'hf);   
    read_register(32'h80021034,data);
    $display("sample num :%d , chirp num : %d \n",data[31:16],data[15:0]);
    set_register (32'h80021034,{16'd1024,16'd128},4'hf) ;       // 设置波形寄存器
    read_register(32'h80021034,data) ;
    set_register (32'h80021038,'d1,4'hf);       // 设置 adc_gather_debug
    set_register (32'h8002204c,'d1,4'hf);
    set_register (32'h8002204c,'d0,4'hf);
    while(1) begin 
        @(posedge top.adc_rx_top.sys_clk) ;
        if(top.adc_rx_top.sample_gate) begin
            if(adc_data_valid_cnt=='d0) begin  
                adc_data_valid = 'd1 ;
                adc_data_a = adc_data_a + 1'b1 ;
                adc_data_b = adc_data_b + 1'b1 ;
            end 
            else begin 
                adc_data_a = adc_data_a ;
                adc_data_b = adc_data_b ;
                adc_data_valid = 'd0 ;
            end
            adc_data_valid_cnt = adc_data_valid_cnt + 1'b1;
        end
    end
end
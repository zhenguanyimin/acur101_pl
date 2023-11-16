
//----------------------------------------------------------------------------------------
//
//                  case1 :  系统仿真仿真仿真一帧32*4096 ADC 数据 
//                           ADC 采集模式 : 4096*32
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
reg [31:0]      index ;
reg [15:0]      adc_data_mem[] ;


initial 
begin
    pri_period = 16'd5300 ;
    cpi_delay = 16'd2000 ;
    pri_num = 8'd32 ;
    pri_pulse_width = 8'd40 ;
    sample_length = 16'd4097;
    start_sample = 16'd1000;
    adc_data = 'd0 ;
    index = 'd0 ;
    $readmemh("E:/work/sw/matlab/adc_data/win_data_input_32.dat",adc_data_mem);
    $display("data size : %d" ,adc_data_mem.size);
    $display("------------------------dsp_sim case1 -------------------------\n");
    wait(~top.sys_rst) ;
    set_register (32'h800203a0,{pri_period,cpi_delay},4'hf);
    set_register (32'h800203a4,{16'd0,pri_pulse_width,pri_num},4'hf);
    set_register (32'h800203a8,{sample_length,start_sample},4'hf);   
    read_register(32'h80021034,data);
    $display("sample num :%d , chirp num : %d \n",data[31:16],data[15:0]);
    set_register (32'h80021034,{16'd4096,16'd32},4'hf) ;       // 设置波形寄存器
    read_register(32'h80021034,data) ;
    set_register (32'h8002204c,'d1,4'hf) ;       // 设置波形寄存器
    set_register (32'h8002204c,'d0,4'hf) ;       // 设置波形寄存器;
    $display("sample num :%d , chirp num : %d \n",data[31:16],data[15:0]);
    $display("addr: h8002_0390 data : %h ",data) ;

    @(posedge top.u_dsp_top.clk ) ;
    while (1) begin
        @(posedge top.adc_rx_top.adc_gather.adc_dclk) ;
        if(top.adc_rx_top.adc_gather.sample_gate && top.adc_rx_top.adc_gather.adc3663_data_valid) begin
            // $display("addr :%d ,value :%h \n",index,adc_data_mem[index]);
            adc_data =  adc_data_mem[index];
            index = index + 1'b1 ; 
        end
        if(index == adc_data_mem.size)
            index = 'd0 ;
        else 
            index = index ;
    end
end

//-----------------------保存数据--------------------------------------
integer  rfft_in_im_file_id ;
integer  rfft_in_re_file_id ;

initial begin
    rfft_in_im_file_id = $fopen("../../../../../sim/sim_data/output_data/rfft_in_im.dat","w");
    rfft_in_re_file_id = $fopen("../../../../../sim/sim_data/output_data/rfft_in_re.dat","w");
    while(1) begin
        @(posedge top.u_dsp_top.rdmap.u_rfft.u_xfft_0.aclk ) ;
        if(top.u_dsp_top.rdmap.u_rfft.u_xfft_0.s_axis_data_tvalid) begin
            $fwrite(rfft_in_im_file_id,"%04h \n",top.u_dsp_top.rdmap.u_rfft.u_xfft_0.s_axis_data_tdata[31:16]);
            $fwrite(rfft_in_re_file_id,"%04h \n",top.u_dsp_top.rdmap.u_rfft.u_xfft_0.s_axis_data_tdata[15: 0]);
        end
    end
end
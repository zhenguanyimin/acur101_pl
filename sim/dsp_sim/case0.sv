

reg         i_cpib ;
reg         i_cpie ;
reg [15:0]  adc_data_cha;
reg         adc_data_cha_valid ;
reg         adc_data_cha_sop; 
reg         adc_data_cha_eop;

reg [15:0]  adc_data_chb;
reg         adc_data_chb_valid ;
reg         adc_data_chb_sop; 
reg         adc_data_chb_eop;

reg [15:0]  adc_data_cha_mem[] ;
reg [15:0]  adc_data_chb_mem[] ;

assign top.u_dsp_top.adc_data_cha_sop      = adc_data_cha_sop  ;
assign top.u_dsp_top.adc_data_cha_eop      = adc_data_cha_eop  ;
assign top.u_dsp_top.adc_data_cha          = adc_data_cha      ;
assign top.u_dsp_top.adc_data_cha_valid    = adc_data_cha_valid;

assign top.u_dsp_top.adc_data_chb_sop      = adc_data_chb_sop  ;
assign top.u_dsp_top.adc_data_chb_eop      = adc_data_chb_eop  ;
assign top.u_dsp_top.adc_data_chb          = adc_data_chb      ;
assign top.u_dsp_top.adc_data_chb_valid    = adc_data_chb_valid;

assign top.u_dsp_top.i_cpib                = i_cpib ;
assign top.u_dsp_top.i_cpie                = i_cpie ;

integer adc_sum_win_re_file;
integer adc_sum_win_im_file;

integer rfft_sum_re_file;
integer rfft_sum_im_file;

integer adc_sub_win_re_file;
integer adc_sub_win_im_file;

integer rfft_sub_re_file;
integer rfft_sub_im_file;

initial begin
    i_cpib              = 'd0 ;
    i_cpie              = 'd0 ;
    adc_data_cha        = 'd0 ;
    adc_data_cha_valid  = 'd0 ;
    adc_data_cha_sop    = 'd0 ;
    adc_data_cha_eop    = 'd0 ;

    adc_data_chb        = 'd0 ;
    adc_data_chb_valid  = 'd0 ;
    adc_data_chb_sop    = 'd0 ;
    adc_data_chb_eop    = 'd0 ;
    $readmemh("../../../../../sim/sim_data/adc_data/fpga_cha.dat",adc_data_cha_mem);
    $readmemh("../../../../../sim/sim_data/adc_data/fpga_chb.dat",adc_data_chb_mem);
    $display("cha chb meme size is ：%d %d\n",adc_data_cha_mem.size,adc_data_chb_mem.size);
    $display("------------------------dsp_sim case0 -------------------------\n");
    wait(~top.sys_rst);
    // set_register (32'h800203a0,{pri_period,cpi_delay},4'hf);
    // set_register (32'h800203a4,{16'd0,pri_pulse_width,pri_num},4'hf);
    // set_register (32'h800203a8,{sample_length,start_sample},4'hf);   
    // read_register(32'h80021034,data);
    // $display("sample num :%d , chirp num : %d \n",data[31:16],data[15:0]);
    // set_register (32'h80021034,{16'd4096,16'd32},4'hf) ;       // 设置波形寄存器
    // read_register(32'h80021034,data) ;
    set_register (32'h8002204c,'d1,4'hf) ;       // 设置波形寄存器
    set_register (32'h8002204c,'d0,4'hf) ;       // 设置波形寄存器
    set_register (32'h80022050,{16'd0,16'd32767},4'hf) ;       // 设置矫正系数cha
    set_register (32'h80022054,{16'd65075,16'd17317},4'hf) ;       // 设置矫正系数chb
    #10000;
    @(posedge top.u_dsp_top.clk);
    while(1)    begin
        for(int i = 0 ; i <32 ; i = i + 1 ) begin
            if(i == 0 ) begin
                i_cpib <= 'd1 ;
                i_cpie <= 'd0 ;
            end
            if( i== 31 ) begin
                i_cpib <= 'd0 ;
                i_cpie <= 'd1 ;
            end
            @ (posedge top.u_dsp_top.clk ) ;
            for(int j = 0 ; j < 4096 ; j = j + 1 ) begin
                if(j == 'd0 ) begin
                    adc_data_cha_sop = 'd1 ;
                    adc_data_chb_sop = 'd1 ;
                end
                else begin
                    adc_data_cha_sop = 'd0 ;
                    adc_data_chb_sop = 'd0 ;                    
                end
                if(j == 'd4095 ) begin
                    adc_data_cha_eop = 'd1 ;
                    adc_data_chb_eop = 'd1 ;
                end
                else begin
                    adc_data_cha_eop = 'd0 ;
                    adc_data_chb_eop = 'd0 ;       
                end
                adc_data_cha_valid = 'd1 ;
                adc_data_chb_valid = 'd1 ;
                adc_data_cha = adc_data_cha_mem[i*4096+j];
                adc_data_chb = adc_data_chb_mem[i*4096+j];
                @ (posedge top.u_dsp_top.clk ) ;
            end
            i_cpib              = 'd0 ;
            i_cpie              = 'd0 ;
            adc_data_cha        = 'd0 ; 
            adc_data_cha_valid  = 'd0 ;
            adc_data_cha_sop    = 'd0 ; 
            adc_data_cha_eop    = 'd0 ;
            adc_data_chb        = 'd0 ;
            adc_data_chb_valid  = 'd0 ;
            adc_data_chb_sop    = 'd0 ; 
            adc_data_chb_eop    = 'd0 ;
            repeat(40000) @ (posedge top.u_dsp_top.clk ) ;
        end
    end
end

initial begin
    adc_sum_win_re_file     =   $fopen("../../../../../sim/sim_data/output_data/adc_sum_win_re.dat","w");
    adc_sum_win_im_file     =   $fopen("../../../../../sim/sim_data/output_data/adc_sum_win_im.dat","w");
    rfft_sum_re_file        =   $fopen("../../../../../sim/sim_data/output_data/rfft_sum_re.dat","w");
    rfft_sum_im_file        =   $fopen("../../../../../sim/sim_data/output_data/rfft_sum_im.dat","w"); 
    adc_sub_win_re_file     =   $fopen("../../../../../sim/sim_data/output_data/adc_sub_win_re.dat","w");
    adc_sub_win_im_file     =   $fopen("../../../../../sim/sim_data/output_data/adc_sub_win_im.dat","w"); 
    rfft_sub_re_file        =   $fopen("../../../../../sim/sim_data/output_data/rfft_sub_re.dat","w");
    rfft_sub_im_file        =   $fopen("../../../../../sim/sim_data/output_data/rfft_sub_im.dat","w");
end

always @(posedge top.u_dsp_top.clk) begin
    if(top.u_dsp_top.rdmap_add.win_r.win_r_data_valid) begin
        $fwrite (adc_sum_win_re_file,"%04h \n",top.u_dsp_top.rdmap_add.win_r.win_r_data[15: 0]);
        $fwrite (adc_sum_win_im_file,"%04h \n",top.u_dsp_top.rdmap_add.win_r.win_r_data[31:16]);
    end
end

always @(posedge top.u_dsp_top.clk) begin
    if(top.u_dsp_top.rdmap_sub.win_r.win_r_data_valid) begin
        $fwrite (adc_sub_win_re_file,"%04h \n",top.u_dsp_top.rdmap_sub.win_r.win_r_data[15: 0]);
        $fwrite (adc_sub_win_im_file,"%04h \n",top.u_dsp_top.rdmap_sub.win_r.win_r_data[31:16]);
    end
end

always @(posedge top.u_dsp_top.clk) begin
    if(top.u_dsp_top.rdmap_add.u_rfft.fft_r_data_valid ) begin
        $fwrite (rfft_sum_re_file,"%04h \n",top.u_dsp_top.rdmap_add.u_rfft.fft_r_data[15: 0] );
        $fwrite (rfft_sum_im_file,"%04h \n",top.u_dsp_top.rdmap_add.u_rfft.fft_r_data[31:16] );
    end
end

always @(posedge top.u_dsp_top.clk) begin
    if(top.u_dsp_top.rdmap_sub.u_rfft.fft_r_data_valid ) begin
        $fwrite (rfft_sub_re_file,"%04h \n",top.u_dsp_top.rdmap_sub.u_rfft.fft_r_data[15: 0] );
        $fwrite (rfft_sub_im_file,"%04h \n",top.u_dsp_top.rdmap_sub.u_rfft.fft_r_data[31:16] );
    end
end

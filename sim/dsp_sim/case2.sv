reg             i_cpib     ;
reg             i_cpie     ;
reg             i_pri      ;
reg             i_smp_gate ;

reg             adc_data_valid   ;
reg  [15:0]     adc_data         ;
reg             adc_data_sop     ;
reg             adc_data_eop     ;

reg  [15:0]     adc_data_mem[];

assign  top.u_dsp_top.i_cpib        = i_cpib ; 
assign  top.u_dsp_top.i_cpie        = i_cpie ;
assign  top.u_dsp_top.i_pri         = i_pri  ;
assign  top.u_dsp_top.i_smp_gate    = i_smp_gate;

assign  top.u_dsp_top.sample_num    = 'd1024; 
assign  top.u_dsp_top.chirp_num     = 'd128 ;

assign  top.u_dsp_top.adc_data_valid = adc_data_valid ;
assign  top.u_dsp_top.adc_data       = adc_data       ; 
assign  top.u_dsp_top.adc_data_sop   = adc_data_sop   ; 
assign  top.u_dsp_top.adc_data_eop   = adc_data_eop   ;


initial 
begin

    adc_data_valid  = 'd0 ;
    adc_data        = 'd0 ; 
    adc_data_sop    = 'd0 ;
    adc_data_eop    = 'd0 ;
    i_cpib    = 'd0 ;
    i_cpie    = 'd0 ;
    i_pri     = 'd0 ;
    i_smp_gate= 'd0 ;

    #80_000_000;
    $readmemh("E:/work/sw/matlab/adc_data/win_data_input_128.dat",adc_data_mem);
    $display("data size : %d" ,adc_data_mem.size);
    // i_tvalid  = 'd0 ;
    // i_tdata   = 'd0 ;
    $display("------------------------dsp_sim case0 -------------------------\n"); 
    @(posedge top.u_dsp_top.clk ) ;
    while(1) begin 
        for(int i = 0 ; i < 128 ; i = i + 1 ) begin
            @(posedge top.u_dsp_top.clk ) ;
            i_cpib = 1'b1 ;
            @(posedge top.u_dsp_top.clk ) ;
            i_cpib = 1'b0 ;
            repeat (20) @(posedge top.u_dsp_top.clk ) ;
            i_pri = 1'b1 ;
            @(posedge top.u_dsp_top.clk ) ;
            i_pri = 1'b0 ;
            repeat (20) @(posedge top.u_dsp_top.clk ) ;    
            for (int j = 0 ; j <1024 ; j = j + 1 ) begin
                i_smp_gate = 'd1 ; 
                adc_data_valid   = 'd1 ;
                if(j == 0 )
                    adc_data_sop = 1'b1 ;
                else 
                    adc_data_sop = 1'b0 ;
                if(j == 1023)
                    adc_data_eop = 1'b1 ;
                else 
                    adc_data_eop = 1'b0 ;
                adc_data    = adc_data_mem[i*1024+j] ;
                @(posedge top.u_dsp_top.clk ) ;
                adc_data_valid   = 'd0 ;
            end
            adc_data_eop = 'd0 ;
            adc_data_sop = 'd0 ;
            adc_data_valid = 'd0 ;
            adc_data       = 'd0 ;
            i_smp_gate = 'd0 ; 
            adc_data_valid   = 'd0 ;
            adc_data    = 'd0 ;
            repeat (100) @(posedge top.u_dsp_top.clk ) ;
            i_cpie     = 'd1 ;
            @(posedge top.u_dsp_top.clk ) ;
            i_cpie     = 'd0 ;
            repeat (80_00) @(posedge top.u_dsp_top.clk ) ;
        end
    end
end
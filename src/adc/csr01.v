module csr01
(
    input	wire               rst           ,
    input	wire               clk           ,

    input       wire    [(16-1):0] SirAddr       ,
    input       wire               SirRead       ,
    input       wire    [31:0]     SirWdat       ,
    input       wire               SirSel        ,
    output      reg                SirDack       ,
    output      reg     [31:0]     SirRdat       ,
    
    output      wire    [31:0]     adc_ctr_mode   ,
    output      wire               dma_ready      ,
    output      wire    [15:0]     adc_threshold  ,
    input       wire    [31:0]     adc_abnormal_num_max ,
    input       wire    [31:0]     adc_abnormal_num     ,
    output      wire    [31:0]     test_data      ,
    output      wire    [31:0]     dma_start      ,
    output      wire    [8 :0]     tap_out_int0   ,
    output      wire    [8 :0]     tap_out_int1   ,
    output      wire    [8 :0]     tap_out_int2   ,
    output      wire               idelay_d0_load ,
    output      wire               idelay_d1_load ,
    output      wire               idelay_d2_load ,
    output      wire    [15:0]     sample_num     ,
    output      wire    [15:0]     chirp_num      ,
    output      wire               adc_gather_debug ,
    output      wire    [ 7:0]     wave_position ,
    input       wire    [ 7:0]     last_position ,
    output      wire               scan_mode     ,
    output      wire               pil_trigger   ,
    output      wire    [31:0]     pil_pri_delay ,
    output      wire               adc_mux_s     ,
    input       wire    [15:0]     adc_cha_ps    ,
    input       wire    [15:0]     adc_chb_ps    , 

    output      wire    [31:0]     waveType      ,
    output      wire    [8*8-1:0]  timestamp     ,
    output      wire    [15:0]     azimuth       ,
    output      wire    [15:0]     elevation     ,
    output      wire    [7:0]      aziScanCenter ,
    output      wire    [7:0]      aziScanScope  ,
    output      wire    [7:0]      eleScanCenter ,
    output      wire    [7:0]      eleScanScope  ,
    output      wire    [7:0]      trackTwsTasFlag,
    output      wire    [7:0]      last_wave     ,

    input       wire    [31:0]     axis_test_tvalid_cnt     ,
    input       wire    [31:0]     axis_test_tlast_cnt      ,
    input       wire    [31:0]     axis_adc_data_tvalid_cnt ,
    input       wire    [31:0]     axis_adc_data_tlast_cnt  ,
    input       wire    [31:0]     fifo_debug  
);

parameter       SLAVE_SIZE  = 16            ;

//************************************************************************************
//              地址0x80021000 RW test_mode 测试模式
//************************************************************************************
parameter       ADDR1000   = 16'h1000       ;

wire            SirDack1000     ;
wire    [31:0]  SirRdat1000     ;

wire            SirDack1000r0   ;
wire    [31:0]  SirRdat1000r0   ;
wire    [31:0]  Q1000r0         ;

reg_rw   U_ADDR1000_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat      	),
                .SirDack    (SirDack1000r0      ),
                .SirRdat    (SirRdat1000r0      ),
                .Q          (Q1000r0            )
                );

defparam
U_ADDR1000_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR1000_r0.DATAWIDTH   =    32,
U_ADDR1000_r0.ININTVALUE  = 32'h0,
U_ADDR1000_r0.REGADDRESS  = ADDR1000;

assign adc_ctr_mode = Q1000r0 ;

assign SirDack1000       = SirDack1000r0;
assign SirRdat1000[31:0] = SirRdat1000r0;

//************************************************************************************
//             地址0x80021004 RW adc_threshold 测试模式
//************************************************************************************
parameter       ADDR1004   = 16'h1004       ;

wire            SirDack1004     ;
wire    [31:0]  SirRdat1004     ;

wire            SirDack1004r0   ;
wire    [31:0]  SirRdat1004r0   ;
wire    [31:0]  Q1004r0         ;

reg_rw   U_ADDR1004_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat      	),
                .SirDack    (SirDack1004r0      ),
                .SirRdat    (SirRdat1004r0      ),
                .Q          (Q1004r0            )
);

defparam
U_ADDR1004_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR1004_r0.DATAWIDTH   =    32,
U_ADDR1004_r0.ININTVALUE  = {16'd0,16'h7fff},
U_ADDR1004_r0.REGADDRESS  = ADDR1004;

assign adc_threshold      = Q1004r0[15:0] ;

assign SirDack1004       = SirDack1004r0;
assign SirRdat1004[31:0] = SirRdat1004r0;

//************************************************************************************
//             地址0x80021008 RW  adc_abnormal_num_max
//************************************************************************************
parameter       ADDR1008   = 16'h1008       ;

wire            SirDack1008     ;
wire    [31:0]  SirRdat1008     ;

wire            SirDack1008r0   ;
wire    [31:0]  SirRdat1008r0   ;
wire    [31:0]  Q1008r0         ;

reg_ro   U_ADDR1008_r0(
        .clk        (clk                ),
        .rst        (rst                ),

        .SirSel     (SirSel            	),
        .SirRead    (SirRead            ),
        .SirAddr    (SirAddr            ),
        // .SirWdat    (SirWdat      	),
        .SirDack    (SirDack1008r0      ),
        .SirRdat    (SirRdat1008r0      ),
        .Load       (1'b1               ),  
        .D          (adc_abnormal_num_max   )
);

defparam
U_ADDR1008_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR1008_r0.DATAWIDTH   =    32,
U_ADDR1008_r0.ININTVALUE  = {32'h0},
U_ADDR1008_r0.REGADDRESS  = ADDR1008;

// assign adc_abnormal_num_max = Q1008r0 ;

assign SirDack1008       = SirDack1008r0;
assign SirRdat1008[31:0] = SirRdat1008r0;


//************************************************************************************
//             地址0x8002100c RO adc_abnormal_num 
//************************************************************************************
parameter       ADDR100c   = 16'h100c       ;

wire            SirDack100c     ;
wire    [31:0]  SirRdat100c     ;

wire            SirDack100cr0   ;
wire    [31:0]  SirRdat100cr0   ;
wire    [31:0]  Q100cr0         ;

reg_ro   U_ADDR100c_r0(
        .clk        (clk                ),
        .rst        (rst                ),

        .SirSel     (SirSel            	),
        .SirRead    (SirRead            ),
        .SirAddr    (SirAddr            ),
        // .SirWdat    (SirWdat      	),
        .SirDack    (SirDack100cr0      ),
        .SirRdat    (SirRdat100cr0      ),
        .Load       (1'b1               ),  
        .D          (adc_abnormal_num   )
);

defparam
U_ADDR100c_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR100c_r0.DATAWIDTH   =    32,
U_ADDR100c_r0.ININTVALUE  = 32'h0,
U_ADDR100c_r0.REGADDRESS  = ADDR100c;



assign SirDack100c       = SirDack100cr0;
assign SirRdat100c[31:0] = SirRdat100cr0;


//************************************************************************************
//             地址0x80021010 RO axis_adc_data_tvalid_cnt 
//************************************************************************************
parameter       ADDR1010   = 16'h1010       ;

wire            SirDack1010     ;
wire    [31:0]  SirRdat1010     ;

wire            SirDack1010r0   ;
wire    [31:0]  SirRdat1010r0   ;
wire    [31:0]  Q1010r0         ;

reg_ro   U_ADDR1010_r0(
        .clk        (clk                ),
        .rst        (rst                ),

        .SirSel     (SirSel            	),
        .SirRead    (SirRead            ),
        .SirAddr    (SirAddr            ),
        // .SirWdat    (SirWdat      	),
        .SirDack    (SirDack1010r0      ),
        .SirRdat    (SirRdat1010r0      ),
        .Load       (1'b1               ),  
        .D          (axis_adc_data_tvalid_cnt)
);

defparam
U_ADDR1010_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR1010_r0.DATAWIDTH   =    32,
U_ADDR1010_r0.ININTVALUE  = 32'h0,
U_ADDR1010_r0.REGADDRESS  = ADDR1010;

assign SirDack1010       = SirDack1010r0;
assign SirRdat1010[31:0] = SirRdat1010r0;

//************************************************************************************
//             地址0x80021014 RO axis_adc_data_tlast_cnt
//************************************************************************************
parameter       ADDR1014   = 16'h1014       ;

wire            SirDack1014     ;
wire    [31:0]  SirRdat1014     ;

wire            SirDack1014r0   ;
wire    [31:0]  SirRdat1014r0   ;
wire    [31:0]  Q1014r0         ;

reg_ro   U_ADDR1014_r0(
        .clk        (clk                ),
        .rst        (rst                ),

        .SirSel     (SirSel            	),
        .SirRead    (SirRead            ),
        .SirAddr    (SirAddr            ),
        // .SirWdat    (SirWdat      	),
        .SirDack    (SirDack1014r0      ),
        .SirRdat    (SirRdat1014r0      ),
        .Load       (1'b1               ),  
        .D          (axis_adc_data_tlast_cnt)
);

defparam
U_ADDR1014_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR1014_r0.DATAWIDTH   =    32,
U_ADDR1014_r0.ININTVALUE  = 32'h0,
U_ADDR1014_r0.REGADDRESS  = ADDR1014;

assign SirDack1014       = SirDack1014r0;
assign SirRdat1014[31:0] = SirRdat1014r0;

//************************************************************************************
//             地址0x80021018 RO fifo_debug
//************************************************************************************
parameter       ADDR1018   = 16'h1018       ;

wire            SirDack1018     ;
wire    [31:0]  SirRdat1018     ;

wire            SirDack1018r0   ;
wire    [31:0]  SirRdat1018r0   ;
wire    [31:0]  Q1018r0         ;

reg_ro   U_ADDR1018_r0(
        .clk        (clk                ),
        .rst        (rst                ),

        .SirSel     (SirSel            	),
        .SirRead    (SirRead            ),
        .SirAddr    (SirAddr            ),
        // .SirWdat    (SirWdat      	),
        .SirDack    (SirDack1018r0      ),
        .SirRdat    (SirRdat1018r0      ),
        .Load       (1'b1               ),  
        .D          (fifo_debug         )
);

defparam
U_ADDR1018_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR1018_r0.DATAWIDTH   =    32,
U_ADDR1018_r0.ININTVALUE  = 32'h0,
U_ADDR1018_r0.REGADDRESS  = ADDR1018;

assign SirDack1018       = SirDack1018r0;
assign SirRdat1018[31:0] = SirRdat1018r0;


//************************************************************************************
//             地址0x8002101c RW dma_start 测试模式
//************************************************************************************
parameter       ADDR101c   = 16'h101c       ;

wire            SirDack101c     ;
wire    [31:0]  SirRdat101c     ;

wire            SirDack101cr0   ;
wire    [31:0]  SirRdat101cr0   ;
wire    [31:0]  Q101cr0         ;

reg_rw   U_ADDR101c_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat      	),
                .SirDack    (SirDack101cr0      ),
                .SirRdat    (SirRdat101cr0      ),
                .Q          (Q101cr0            )
);

defparam
U_ADDR101c_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR101c_r0.DATAWIDTH   =    32,
U_ADDR101c_r0.ININTVALUE  = 32'h0,
U_ADDR101c_r0.REGADDRESS  = ADDR101c;

assign dma_start         = Q101cr0 ;

assign SirDack101c       = SirDack101cr0;
assign SirRdat101c[31:0] = SirRdat101cr0;


//************************************************************************************
//             地址0x80021020 RW {tap_out_int1,tap_out_int0}
//************************************************************************************
parameter       ADDR1020   = 16'h1020       ;

wire            SirDack1020     ;
wire    [31:0]  SirRdat1020     ;

wire            SirDack1020r0   ;
wire    [31:0]  SirRdat1020r0   ;
wire    [31:0]  Q1020r0         ;

reg_rw   U_ADDR1020_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat      	),
                .SirDack    (SirDack1020r0      ),
                .SirRdat    (SirRdat1020r0      ),
                .Q          (Q1020r0            )
);

defparam
U_ADDR1020_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR1020_r0.DATAWIDTH   =    32,
U_ADDR1020_r0.ININTVALUE  = 32'h0,
U_ADDR1020_r0.REGADDRESS  = ADDR1020;

// assign tap_out_int0       = Q1020r0[15:0] ;
// assign tap_out_int1       = Q1020r0[31:16];

assign SirDack1020       = SirDack1020r0;
assign SirRdat1020[31:0] = SirRdat1020r0;

//************************************************************************************
//             地址0x80021024 RW {idelay_d1_load,idelay_d0_load}
//************************************************************************************
parameter       ADDR1024   = 16'h1024       ;

wire            SirDack1024     ;
wire    [31:0]  SirRdat1024     ;

wire            SirDack1024r0   ;
wire    [31:0]  SirRdat1024r0   ;
wire    [31:0]  Q1024r0         ;

reg_rw   U_ADDR1024_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat            ),
                .SirDack    (SirDack1024r0      ),
                .SirRdat    (SirRdat1024r0      ),
                // .Clr        (1'b1               ),
                .Q          (Q1024r0            )
);

defparam
U_ADDR1024_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR1024_r0.DATAWIDTH   =    32,
U_ADDR1024_r0.ININTVALUE  = 32'h0,
U_ADDR1024_r0.REGADDRESS  = ADDR1024;

// assign idelay_d0_load       = Q1024r0[0:0] ;
// assign idelay_d1_load       = Q1024r0[1:1];

assign SirDack1024       = SirDack1024r0;
assign SirRdat1024[31:0] = SirRdat1024r0;


//************************************************************************************
//             地址0x80021028 RW {}
//************************************************************************************
parameter       ADDR1028   = 16'h1028       ;

wire            SirDack1028     ;
wire    [31:0]  SirRdat1028     ;

wire            SirDack1028r0   ;
wire    [31:0]  SirRdat1028r0   ;
wire    [31:0]  Q1028r0         ;

reg_rw   U_ADDR1028_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat            ),
                .SirDack    (SirDack1028r0      ),
                .SirRdat    (SirRdat1028r0      ),
                // .Clr        (1'b1               ),
                .Q          (Q1028r0            )
);

defparam
U_ADDR1028_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR1028_r0.DATAWIDTH   =    32,
U_ADDR1028_r0.ININTVALUE  = 32'h0,
U_ADDR1028_r0.REGADDRESS  = ADDR1028;

assign dma_ready         = Q1028r0[31:31] ;
// assign adc_mode          = Q1028r0[3 :0]  ;
assign SirDack1028       = SirDack1028r0;
assign SirRdat1028[31:0] = SirRdat1028r0;

//************************************************************************************
//             地址0x8002102c RW {}
//************************************************************************************
parameter       ADDR102c   = 16'h102c       ;

wire            SirDack102c     ;
wire    [31:0]  SirRdat102c     ;

wire            SirDack102cr0   ;
wire    [31:0]  SirRdat102cr0   ;
wire    [31:0]  Q102cr0         ;

reg_rw   U_ADDR102c_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat            ),
                .SirDack    (SirDack102cr0      ),
                .SirRdat    (SirRdat102cr0      ),
                // .Clr        (1'b1               ),
                .Q          (Q102cr0            )
);

defparam
U_ADDR102c_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR102c_r0.DATAWIDTH   =    32,
U_ADDR102c_r0.ININTVALUE  = 32'h0,
U_ADDR102c_r0.REGADDRESS  = ADDR102c;

assign idelay_d0_load     = Q102cr0[0];
assign idelay_d1_load     = Q102cr0[1];
assign idelay_d2_load     = Q102cr0[2];
assign tap_out_int0       = Q102cr0[24:16];

assign SirDack102c        = SirDack102cr0;
assign SirRdat102c[31:0]  = SirRdat102cr0;

//************************************************************************************
//             地址0x80021030 RW {}
//************************************************************************************
parameter       ADDR1030   = 16'h1030       ;

wire            SirDack1030     ;
wire    [31:0]  SirRdat1030     ;

wire            SirDack1030r0   ;
wire    [31:0]  SirRdat1030r0   ;
wire    [31:0]  Q1030r0         ;

reg_rw   U_ADDR1030_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat            ),
                .SirDack    (SirDack1030r0      ),
                .SirRdat    (SirRdat1030r0      ),
                // .Clr        (1'b1               ),
                .Q          (Q1030r0            )
);

defparam
U_ADDR1030_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR1030_r0.DATAWIDTH   =    32,
U_ADDR1030_r0.ININTVALUE  = 32'h0,
U_ADDR1030_r0.REGADDRESS  = ADDR1030;

assign tap_out_int1       = Q1030r0[8 :0];
assign tap_out_int2       = Q1030r0[24:16];

assign SirDack1030        = SirDack1030r0;
assign SirRdat1030[31:0]  = SirRdat1030r0;


//************************************************************************************
//             地址0x80021034 RW 
//************************************************************************************
parameter       ADDR1034   = 16'h1034       ;

wire            SirDack1034     ;
wire    [31:0]  SirRdat1034     ;

wire            SirDack1034r0   ;
wire    [31:0]  SirRdat1034r0   ;
wire    [31:0]  Q1034r0         ;

reg_rw   U_ADDR1034_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat            ),
                .SirDack    (SirDack1034r0      ),
                .SirRdat    (SirRdat1034r0      ),
                // .Clr        (1'b1               ),
                .Q          (Q1034r0            )
);

defparam
U_ADDR1034_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR1034_r0.DATAWIDTH   =    32,
U_ADDR1034_r0.ININTVALUE  = {16'd4096,16'd32},
U_ADDR1034_r0.REGADDRESS  = ADDR1034;

assign sample_num         = Q1034r0[31:16];
assign chirp_num          = Q1034r0[15: 0];

assign SirDack1034        = SirDack1034r0;
assign SirRdat1034[31:0]  = SirRdat1034r0;

//************************************************************************************
//             地址0x80021038 RW 
//************************************************************************************
parameter       ADDR1038   = 16'h1038       ;

wire            SirDack1038     ;
wire    [31:0]  SirRdat1038     ;

wire            SirDack1038r0   ;
wire    [31:0]  SirRdat1038r0   ;
wire    [31:0]  Q1038r0         ;

reg_rw   U_ADDR1038_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat            ),
                .SirDack    (SirDack1038r0      ),
                .SirRdat    (SirRdat1038r0      ),
                // .Clr        (1'b1               ),
                .Q          (Q1038r0            )
);

defparam
U_ADDR1038_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR1038_r0.DATAWIDTH   =    32,
U_ADDR1038_r0.ININTVALUE  = 'd0,
U_ADDR1038_r0.REGADDRESS  = ADDR1038;

assign adc_gather_debug   = Q1038r0[0:0];

assign SirDack1038        = SirDack1038r0;
assign SirRdat1038[31:0]  = SirRdat1038r0;

//************************************************************************************
//             地址 0x8002103c RW wave_position
//************************************************************************************
parameter       ADDR103c   = 16'h103c       ;

wire            SirDack103c     ;
wire    [31:0]  SirRdat103c     ;

wire            SirDack103cr0   ;
wire    [31:0]  SirRdat103cr0   ;
wire    [31:0]  Q103cr0         ;

reg_rw   U_ADDR103c_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat            ),
                .SirDack    (SirDack103cr0      ),
                .SirRdat    (SirRdat103cr0      ),
                // .Clr        (1'b1               ),
                .Q          (Q103cr0            )
);

defparam
U_ADDR103c_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR103c_r0.DATAWIDTH   =    32,
U_ADDR103c_r0.ININTVALUE  = 'd0,
U_ADDR103c_r0.REGADDRESS  = ADDR103c;

assign wave_position   = Q103cr0[7:0];

assign SirDack103c        = SirDack103cr0;
assign SirRdat103c[31:0]  = SirRdat103cr0;


//************************************************************************************
//             地址0x80021040 RO last_position
//************************************************************************************
parameter       ADDR1040   = 16'h1040       ;

wire            SirDack1040     ;
wire    [31:0]  SirRdat1040     ;

wire            SirDack1040r0   ;
wire    [31:0]  SirRdat1040r0   ;
wire    [31:0]  Q1040r0         ;

reg_ro   U_ADDR1040_r0(
        .clk        (clk                ),
        .rst        (rst                ),

        .SirSel     (SirSel            	),
        .SirRead    (SirRead            ),
        .SirAddr    (SirAddr            ),
        // .SirWdat    (SirWdat      	),
        .SirDack    (SirDack1040r0      ),
        .SirRdat    (SirRdat1040r0      ),
        .Load       (1'b1               ),  
        .D          (last_position      )
);

defparam
U_ADDR1040_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR1040_r0.DATAWIDTH   =    32,
U_ADDR1040_r0.ININTVALUE  = 32'h0,
U_ADDR1040_r0.REGADDRESS  = ADDR1040;

assign SirDack1040       = SirDack1040r0;
assign SirRdat1040[31:0] = SirRdat1040r0;


//************************************************************************************
//             地址 0x80021044 RW scan_mode
//************************************************************************************
parameter       ADDR1044   = 16'h1044       ;

wire            SirDack1044     ;
wire    [31:0]  SirRdat1044     ;

wire            SirDack1044r0   ;
wire    [31:0]  SirRdat1044r0   ;
wire    [31:0]  Q1044r0         ;

reg_rw   U_ADDR1044_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat            ),
                .SirDack    (SirDack1044r0      ),
                .SirRdat    (SirRdat1044r0      ),
                // .Clr        (1'b1               ),
                .Q          (Q1044r0            )
);

defparam
U_ADDR1044_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR1044_r0.DATAWIDTH   =    32,
U_ADDR1044_r0.ININTVALUE  = 'd0,
U_ADDR1044_r0.REGADDRESS  = ADDR1044;

assign scan_mode   = Q1044r0[7:0];

assign SirDack1044        = SirDack1044r0;
assign SirRdat1044[31:0]  = SirRdat1044r0;

//************************************************************************************
//             地址 0x80021048 RW pil_trigger
//************************************************************************************
parameter       ADDR1048   = 16'h1048       ;

wire            SirDack1048     ;
wire    [31:0]  SirRdat1048     ;

wire            SirDack1048r0   ;
wire    [31:0]  SirRdat1048r0   ;
wire    [31:0]  Q1048r0         ;

reg_rw   U_ADDR1048_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat            ),
                .SirDack    (SirDack1048r0      ),
                .SirRdat    (SirRdat1048r0      ),
                // .Clr        (1'b1               ),
                .Q          (Q1048r0            )
);

defparam
U_ADDR1048_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR1048_r0.DATAWIDTH   =    32,
U_ADDR1048_r0.ININTVALUE  = 'd0,
U_ADDR1048_r0.REGADDRESS  = ADDR1048;

assign pil_trigger   = Q1048r0[0:0];

assign SirDack1048        = SirDack1048r0;
assign SirRdat1048[31:0]  = SirRdat1048r0;

//************************************************************************************
//             地址 0x8002104c RW pil_trigger
//************************************************************************************
parameter       ADDR104c   = 16'h104c       ;

wire            SirDack104c     ;
wire    [31:0]  SirRdat104c     ;

wire            SirDack104cr0   ;
wire    [31:0]  SirRdat104cr0   ;
wire    [31:0]  Q104cr0         ;

reg_rw   U_ADDR104c_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat            ),
                .SirDack    (SirDack104cr0      ),
                .SirRdat    (SirRdat104cr0      ),
                // .Clr        (1'b1               ),
                .Q          (Q104cr0            )
);

defparam
U_ADDR104c_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR104c_r0.DATAWIDTH   =    32,
U_ADDR104c_r0.ININTVALUE  = 32'h0000_BB80,
// U_ADDR104c_r0.ININTVALUE  = 32'h0000_1000,
U_ADDR104c_r0.REGADDRESS  = ADDR104c;

assign pil_pri_delay   = Q104cr0[31:0];

assign SirDack104c        = SirDack104cr0;
assign SirRdat104c[31:0]  = SirRdat104cr0;

//************************************************************************************
//             地址 0x80021050 RW pil_trigger
//************************************************************************************
parameter       ADDR1050   = 16'h1050       ;

wire            SirDack1050     ;
wire    [31:0]  SirRdat1050     ;

wire            SirDack1050r0   ;
wire    [31:0]  SirRdat1050r0   ;
wire    [31:0]  Q1050r0         ;

reg_rw   U_ADDR1050_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat            ),
                .SirDack    (SirDack1050r0      ),
                .SirRdat    (SirRdat1050r0      ),
                // .Clr        (1'b1               ),
                .Q          (Q1050r0            )
);

defparam
U_ADDR1050_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR1050_r0.DATAWIDTH   =    32,
U_ADDR1050_r0.ININTVALUE  = 32'h0000_1000,
U_ADDR1050_r0.REGADDRESS  = ADDR1050;

assign adc_mux_s   = Q1050r0[0:0];

assign SirDack1050        = SirDack1050r0;
assign SirRdat1050[31:0]  = SirRdat1050r0;

//************************************************************************************
//             地址0x80021054 RO {adc_cha,adc_chb} 
//************************************************************************************

parameter       ADDR1054   = 16'h1054       ;

wire            SirDack1054     ;
wire    [31:0]  SirRdat1054     ;

wire            SirDack1054r0   ;
wire    [31:0]  SirRdat1054r0   ;
wire    [31:0]  Q1054r0         ;

reg_ro   U_ADDR1054_r0(
        .clk        (clk                ),
        .rst        (rst                ),

        .SirSel     (SirSel            	),
        .SirRead    (SirRead            ),
        .SirAddr    (SirAddr            ),
        // .SirWdat    (SirWdat      	),
        .SirDack    (SirDack1054r0      ),
        .SirRdat    (SirRdat1054r0      ),
        .Load       (1'b1               ),  
        .D          ({adc_chb_ps,adc_cha_ps})
);

defparam
U_ADDR1054_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR1054_r0.DATAWIDTH   =    32,
U_ADDR1054_r0.ININTVALUE  = 32'h0,
U_ADDR1054_r0.REGADDRESS  = ADDR1054;

assign SirDack1054       = SirDack1054r0;
assign SirRdat1054[31:0] = SirRdat1054r0;

//************************************************************************************
//             地址 0x80021058 RW pil_trigger
//************************************************************************************
parameter       ADDR1058   = 16'h1058       ;

wire            SirDack1058     ;
wire    [31:0]  SirRdat1058     ;

wire            SirDack1058r0   ;
wire    [31:0]  SirRdat1058r0   ;
wire    [31:0]  Q1058r0         ;

reg_rw   U_ADDR1058_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat            ),
                .SirDack    (SirDack1058r0      ),
                .SirRdat    (SirRdat1058r0      ),
                // .Clr        (1'b1               ),
                .Q          (Q1058r0            )
);

defparam
U_ADDR1058_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR1058_r0.DATAWIDTH   =    32,
U_ADDR1058_r0.ININTVALUE  = 32'h0000_0000,
U_ADDR1058_r0.REGADDRESS  = ADDR1058;

assign waveType   = Q1058r0[31:0];

assign SirDack1058        = SirDack1058r0;
assign SirRdat1058[31:0]  = SirRdat1058r0;

//************************************************************************************
//             地址 0x8002105c RW pil_trigger
//************************************************************************************
parameter       ADDR105c   = 16'h105c       ;

wire            SirDack105c     ;
wire    [31:0]  SirRdat105c     ;

wire            SirDack105cr0   ;
wire    [31:0]  SirRdat105cr0   ;
wire    [31:0]  Q105cr0         ;

reg_rw   U_ADDR105c_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat            ),
                .SirDack    (SirDack105cr0      ),
                .SirRdat    (SirRdat105cr0      ),
                // .Clr        (1'b1               ),
                .Q          (Q105cr0            )
);

defparam
U_ADDR105c_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR105c_r0.DATAWIDTH   =    32,
U_ADDR105c_r0.ININTVALUE  = 32'h0000_0000,
U_ADDR105c_r0.REGADDRESS  = ADDR105c;

assign timestamp[31:0]   = Q105cr0[31:0];

assign SirDack105c        = SirDack105cr0;
assign SirRdat105c[31:0]  = SirRdat105cr0;

//************************************************************************************
//             地址 0x80021060 RW pil_trigger
//************************************************************************************
parameter       ADDR1060   = 16'h1060       ;

wire            SirDack1060     ;
wire    [31:0]  SirRdat1060     ;

wire            SirDack1060r0   ;
wire    [31:0]  SirRdat1060r0   ;
wire    [31:0]  Q1060r0         ;

reg_rw   U_ADDR1060_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat            ),
                .SirDack    (SirDack1060r0      ),
                .SirRdat    (SirRdat1060r0      ),
                // .Clr        (1'b1               ),
                .Q          (Q1060r0            )
);

defparam
U_ADDR1060_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR1060_r0.DATAWIDTH   =    32,
U_ADDR1060_r0.ININTVALUE  = 32'h0000_0000,
U_ADDR1060_r0.REGADDRESS  = ADDR1060;

assign timestamp[63:32]   = Q1060r0[31:0];

assign SirDack1060        = SirDack1060r0;
assign SirRdat1060[31:0]  = SirRdat1060r0;

//************************************************************************************
//             地址 0x80021064 RW pil_trigger
//************************************************************************************
parameter       ADDR1064   = 16'h1064       ;

wire            SirDack1064     ;
wire    [31:0]  SirRdat1064     ;

wire            SirDack1064r0   ;
wire    [31:0]  SirRdat1064r0   ;
wire    [31:0]  Q1064r0         ;

reg_rw   U_ADDR1064_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat            ),
                .SirDack    (SirDack1064r0      ),
                .SirRdat    (SirRdat1064r0      ),
                // .Clr        (1'b1               ),
                .Q          (Q1064r0            )
);

defparam
U_ADDR1064_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR1064_r0.DATAWIDTH   =    32,
U_ADDR1064_r0.ININTVALUE  = 32'h0000_0000,
U_ADDR1064_r0.REGADDRESS  = ADDR1064;

assign azimuth   = Q1064r0[15:0];

assign SirDack1064        = SirDack1064r0;
assign SirRdat1064[31:0]  = SirRdat1064r0;

//************************************************************************************
//             地址 0x80021068 RW pil_trigger
//************************************************************************************
parameter       ADDR1068   = 16'h1068       ;

wire            SirDack1068     ;
wire    [31:0]  SirRdat1068     ;

wire            SirDack1068r0   ;
wire    [31:0]  SirRdat1068r0   ;
wire    [31:0]  Q1068r0         ;

reg_rw   U_ADDR1068_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat            ),
                .SirDack    (SirDack1068r0      ),
                .SirRdat    (SirRdat1068r0      ),
                // .Clr        (1'b1               ),
                .Q          (Q1068r0            )
);

defparam
U_ADDR1068_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR1068_r0.DATAWIDTH   =    32,
U_ADDR1068_r0.ININTVALUE  = 32'h0000_0000,
U_ADDR1068_r0.REGADDRESS  = ADDR1068;

assign elevation   = Q1068r0[15:0];

assign SirDack1068        = SirDack1068r0;
assign SirRdat1068[31:0]  = SirRdat1068r0;

//************************************************************************************
//             地址 0x8002106c RW pil_trigger
//************************************************************************************
parameter       ADDR106c   = 16'h106c       ;

wire            SirDack106c     ;
wire    [31:0]  SirRdat106c     ;

wire            SirDack106cr0   ;
wire    [31:0]  SirRdat106cr0   ;
wire    [31:0]  Q106cr0         ;

reg_rw   U_ADDR106c_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat            ),
                .SirDack    (SirDack106cr0      ),
                .SirRdat    (SirRdat106cr0      ),
                // .Clr        (1'b1               ),
                .Q          (Q106cr0            )
);

defparam
U_ADDR106c_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR106c_r0.DATAWIDTH   =    32,
U_ADDR106c_r0.ININTVALUE  = 32'h0000_0000,
U_ADDR106c_r0.REGADDRESS  = ADDR106c;

assign aziScanCenter   = Q106cr0[15:0];

assign SirDack106c        = SirDack106cr0;
assign SirRdat106c[31:0]  = SirRdat106cr0;

//************************************************************************************
//             地址 0x80021070 RW pil_trigger
//************************************************************************************
parameter       ADDR1070   = 16'h1070       ;

wire            SirDack1070     ;
wire    [31:0]  SirRdat1070     ;

wire            SirDack1070r0   ;
wire    [31:0]  SirRdat1070r0   ;
wire    [31:0]  Q1070r0         ;

reg_rw   U_ADDR1070_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat            ),
                .SirDack    (SirDack1070r0      ),
                .SirRdat    (SirRdat1070r0      ),
                // .Clr        (1'b1               ),
                .Q          (Q1070r0            )
);

defparam
U_ADDR1070_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR1070_r0.DATAWIDTH   =    32,
U_ADDR1070_r0.ININTVALUE  = 32'h0000_0000,
U_ADDR1070_r0.REGADDRESS  = ADDR1070;

assign aziScanScope   = Q1070r0[15:0];

assign SirDack1070        = SirDack1070r0;
assign SirRdat1070[31:0]  = SirRdat1070r0;

//************************************************************************************
//             地址 0x80021074 RW pil_trigger
//************************************************************************************
parameter       ADDR1074   = 16'h1074       ;

wire            SirDack1074     ;
wire    [31:0]  SirRdat1074     ;

wire            SirDack1074r0   ;
wire    [31:0]  SirRdat1074r0   ;
wire    [31:0]  Q1074r0         ;

reg_rw   U_ADDR1074_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat            ),
                .SirDack    (SirDack1074r0      ),
                .SirRdat    (SirRdat1074r0      ),
                // .Clr        (1'b1               ),
                .Q          (Q1074r0            )
);

defparam
U_ADDR1074_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR1074_r0.DATAWIDTH   =    32,
U_ADDR1074_r0.ININTVALUE  = 32'h0000_0000,
U_ADDR1074_r0.REGADDRESS  = ADDR1074;

assign eleScanCenter   = Q1074r0[15:0];

assign SirDack1074        = SirDack1074r0;
assign SirRdat1074[31:0]  = SirRdat1074r0;

//************************************************************************************
//             地址 0x80021078 RW pil_trigger
//************************************************************************************
parameter       ADDR1078   = 16'h1078       ;

wire            SirDack1078     ;
wire    [31:0]  SirRdat1078     ;

wire            SirDack1078r0   ;
wire    [31:0]  SirRdat1078r0   ;
wire    [31:0]  Q1078r0         ;

reg_rw   U_ADDR1078_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat            ),
                .SirDack    (SirDack1078r0      ),
                .SirRdat    (SirRdat1078r0      ),
                // .Clr        (1'b1               ),
                .Q          (Q1078r0            )
);

defparam
U_ADDR1078_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR1078_r0.DATAWIDTH   =    32,
U_ADDR1078_r0.ININTVALUE  = 32'h0000_0000,
U_ADDR1078_r0.REGADDRESS  = ADDR1078;

assign eleScanScope   = Q1078r0[15:0];

assign SirDack1078        = SirDack1078r0;
assign SirRdat1078[31:0]  = SirRdat1078r0;

//************************************************************************************
//             地址 0x8002107c RW pil_trigger
//************************************************************************************
parameter       ADDR107c   = 16'h107c       ;

wire            SirDack107c     ;
wire    [31:0]  SirRdat107c     ;

wire            SirDack107cr0   ;
wire    [31:0]  SirRdat107cr0   ;
wire    [31:0]  Q107cr0         ;

reg_rw   U_ADDR107c_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat            ),
                .SirDack    (SirDack107cr0      ),
                .SirRdat    (SirRdat107cr0      ),
                // .Clr        (1'b1               ),
                .Q          (Q107cr0            )
);

defparam
U_ADDR107c_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR107c_r0.DATAWIDTH   =    32,
U_ADDR107c_r0.ININTVALUE  = 32'h0000_0000,
U_ADDR107c_r0.REGADDRESS  = ADDR107c;

assign trackTwsTasFlag   = Q107cr0[15:0];

assign SirDack107c        = SirDack107cr0;
assign SirRdat107c[31:0]  = SirRdat107cr0;

//************************************************************************************
//             地址 0x80021080 RW pil_trigger
//************************************************************************************
parameter       ADDR1080   = 16'h1080       ;

wire            SirDack1080     ;
wire    [31:0]  SirRdat1080     ;

wire            SirDack1080r0   ;
wire    [31:0]  SirRdat1080r0   ;
wire    [31:0]  Q1080r0         ;

reg_rw   U_ADDR1080_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat            ),
                .SirDack    (SirDack1080r0      ),
                .SirRdat    (SirRdat1080r0      ),
                // .Clr        (1'b1               ),
                .Q          (Q1080r0            )
);

defparam
U_ADDR1080_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR1080_r0.DATAWIDTH   =    32,
U_ADDR1080_r0.ININTVALUE  = 32'h0000_0000,
U_ADDR1080_r0.REGADDRESS  = ADDR1080;

assign last_wave   = Q1080r0[15:0];

assign SirDack1080        = SirDack1080r0;
assign SirRdat1080[31:0]  = SirRdat1080r0;

//----------------------------------------------------------------------------------------

always @ (posedge clk )
begin
    if (rst == 1'b1)
        SirDack <= 1'b0;
    else
        SirDack <=      
                        SirDack1000 | SirDack1004 | SirDack1008 | SirDack100c | SirDack1010 | SirDack1014 | SirDack1018 | SirDack101c |
                        SirDack1020 | SirDack1024 | SirDack1028 | SirDack102c | SirDack1030 | SirDack1034 | SirDack1038 | SirDack103c |
                        SirDack1040 | SirDack1044 | SirDack1048 | SirDack104c | SirDack1050 | SirDack1054 | SirDack1058 | SirDack105c |   
                        SirDack1060 | SirDack1064 | SirDack1068 | SirDack106c | SirDack1070 | SirDack1074 | SirDack1078 | SirDack107c | 
                        SirDack1080 
                        ;
end       

always @ (posedge clk)
begin
        SirRdat <=      
                        SirRdat1000 | SirRdat1004 | SirRdat1008 | SirRdat100c | SirRdat1010 | SirRdat1014 | SirRdat1018 | SirRdat101c |
                        SirRdat1020 | SirRdat1024 | SirRdat1028 | SirRdat102c | SirRdat1030 | SirRdat1034 | SirRdat1038 | SirRdat103c |
                        SirRdat1040 | SirRdat1044 | SirRdat1048 | SirRdat104c | SirRdat1050 | SirRdat1054 | SirRdat1058 | SirRdat105c | 
                        SirRdat1060 | SirRdat1064 | SirRdat1068 | SirRdat106c | SirRdat1070 | SirRdat1074 | SirRdat1078 | SirRdat107c | 
                        SirRdat1080 
                        ;
end

endmodule

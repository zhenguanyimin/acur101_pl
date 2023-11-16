module csr02
(
    input	wire                   rst       ,
    input	wire                   clk       ,

    input       wire    [(16-1):0] SirAddr   ,
    input       wire               SirRead   ,
    input       wire    [31:0]     SirWdat   ,
    input       wire               SirSel    ,
    output      reg                SirDack   ,
    output      reg     [31:0]     SirRdat   ,

    output      wire    [15:0]     horizontal_pitch,
    output      wire               fir_enable  ,
    output      wire    [7:0]      cult_mode   ,
    output      wire    [7:0]      cult_sch_sw ,
    output      wire    [15:0]     clut_cpi    ,
    output      wire    [15:0]     clut_tas_cpi,
    output      wire    [7:0]      clut_tas_ary,
    output      wire    [15:0]     clut_tas_inr,
    output      wire    [15:0]     adc_truncation,
    output      wire    [ 7:0]     rfft_truncation,
    output      wire               config_trigger,
    output      wire    [31:0]     Calibration_IQCHA,
    output      wire    [31:0]     Calibration_IQCHB,
    input       wire    [7 :0]     cur_wave_position
);

parameter       SLAVE_SIZE  = 16            ;

//************************************************************************************
//          register Horizontal_pitch  addr :0x80022000       
//************************************************************************************
parameter       ADDR2000   = 16'h2000       ;

wire            SirDack2000     ;
wire    [31:0]  SirRdat2000     ;

wire            SirDack2000r0   ;
wire    [31:0]  SirRdat2000r0   ;
wire    [31:0]  Q2000r0         ;

reg_rw   U_ADDR2000_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat      	    ),
                .SirDack    (SirDack2000r0      ),
                .SirRdat    (SirRdat2000r0      ),
                .Q          (Q2000r0            )
                );

defparam
U_ADDR2000_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR2000_r0.DATAWIDTH   =    32,
U_ADDR2000_r0.ININTVALUE  = 32'd1000,
U_ADDR2000_r0.REGADDRESS  = ADDR2000;

assign horizontal_pitch = Q2000r0[15:0] ;

assign SirDack2000       = SirDack2000r0;
assign SirRdat2000[31:0] = SirRdat2000r0;

//************************************************************************************
//         cult_map register clut_cpi   0x80022004      
//************************************************************************************
parameter       ADDR2004   = 16'h2004       ;

wire            SirDack2004     ;
wire    [31:0]  SirRdat2004     ;

wire            SirDack2004r0   ;
wire    [31:0]  SirRdat2004r0   ;
wire    [31:0]  Q2004r0         ;

reg_rw   U_ADDR2004_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat      	),
                .SirDack    (SirDack2004r0      ),
                .SirRdat    (SirRdat2004r0      ),
                .Q          (Q2004r0            )
                );

defparam
U_ADDR2004_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR2004_r0.DATAWIDTH   =    32,
U_ADDR2004_r0.ININTVALUE  = 32'h1,
U_ADDR2004_r0.REGADDRESS  = ADDR2004;

assign clut_cpi = Q2004r0[15:0] ;

assign SirDack2004       = SirDack2004r0;
assign SirRdat2004[31:0] = SirRdat2004r0;


//************************************************************************************
//         cult_map register cult_mode   0x80022008      
//************************************************************************************
parameter       ADDR2008   = 16'h2008       ;

wire            SirDack2008     ;
wire    [31:0]  SirRdat2008     ;

wire            SirDack2008r0   ;
wire    [31:0]  SirRdat2008r0   ;
wire    [31:0]  Q2008r0         ;

reg_rw   U_ADDR2008_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat      	),
                .SirDack    (SirDack2008r0      ),
                .SirRdat    (SirRdat2008r0      ),
                .Q          (Q2008r0            )
                );

defparam
U_ADDR2008_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR2008_r0.DATAWIDTH   =    32,
U_ADDR2008_r0.ININTVALUE  = 32'h0,
U_ADDR2008_r0.REGADDRESS  = ADDR2008;

assign cult_mode = Q2008r0[7 :0] ;

assign SirDack2008       = SirDack2008r0;
assign SirRdat2008[31:0] = SirRdat2008r0;


//************************************************************************************
//         cult_map register cult_sch_sw   0x8002200c      
//************************************************************************************
parameter       ADDR200c   = 16'h200c       ;

wire            SirDack200c     ;
wire    [31:0]  SirRdat200c     ;

wire            SirDack200cr0   ;
wire    [31:0]  SirRdat200cr0   ;
wire    [31:0]  Q200cr0         ;

reg_rw   U_ADDR200c_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat      	),
                .SirDack    (SirDack200cr0      ),
                .SirRdat    (SirRdat200cr0      ),
                .Q          (Q200cr0            )
                );

defparam
U_ADDR200c_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR200c_r0.DATAWIDTH   =    32,
U_ADDR200c_r0.ININTVALUE  = 32'h0,
U_ADDR200c_r0.REGADDRESS  = ADDR200c;

assign cult_sch_sw = Q200cr0[7 :0] ;

assign SirDack200c       = SirDack200cr0;
assign SirRdat200c[31:0] = SirRdat200cr0;

//************************************************************************************
//         cult_map register clut_tas_cpi   0x80022010      
//************************************************************************************
parameter       ADDR2010   = 16'h2010       ;

wire            SirDack2010     ;
wire    [31:0]  SirRdat2010     ;

wire            SirDack2010r0   ;
wire    [31:0]  SirRdat2010r0   ;
wire    [31:0]  Q2010r0         ;

reg_rw   U_ADDR2010_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat      	),
                .SirDack    (SirDack2010r0      ),
                .SirRdat    (SirRdat2010r0      ),
                .Q          (Q2010r0            )
                );

defparam
U_ADDR2010_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR2010_r0.DATAWIDTH   =    32,
U_ADDR2010_r0.ININTVALUE  = 32'h1,
U_ADDR2010_r0.REGADDRESS  = ADDR2010;

assign clut_tas_cpi = Q2010r0[15 :0] ;

assign SirDack2010       = SirDack2010r0;
assign SirRdat2010[31:0] = SirRdat2010r0;

//************************************************************************************
//         cult_map register clut_tas_ary   0x80022014      
//************************************************************************************
parameter       ADDR2014   = 16'h2014       ;

wire            SirDack2014     ;
wire    [31:0]  SirRdat2014     ;

wire            SirDack2014r0   ;
wire    [31:0]  SirRdat2014r0   ;
wire    [31:0]  Q2014r0         ;

reg_rw   U_ADDR2014_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat      	),
                .SirDack    (SirDack2014r0      ),
                .SirRdat    (SirRdat2014r0      ),
                .Q          (Q2014r0            )
                );

defparam
U_ADDR2014_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR2014_r0.DATAWIDTH   =    32,
U_ADDR2014_r0.ININTVALUE  = 32'h0,
U_ADDR2014_r0.REGADDRESS  = ADDR2014;

assign clut_tas_ary = Q2014r0[7 :0] ;

assign SirDack2014       = SirDack2014r0;
assign SirRdat2014[31:0] = SirRdat2014r0;

//************************************************************************************
//         cult_map register clut_tas_inr   0x80022018      
//************************************************************************************
parameter       ADDR2018   = 16'h2018       ;

wire            SirDack2018     ;
wire    [31:0]  SirRdat2018     ;

wire            SirDack2018r0   ;
wire    [31:0]  SirRdat2018r0   ;
wire    [31:0]  Q2018r0         ;

reg_rw   U_ADDR2018_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat      	),
                .SirDack    (SirDack2018r0      ),
                .SirRdat    (SirRdat2018r0      ),
                .Q          (Q2018r0            )
                );

defparam
U_ADDR2018_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR2018_r0.DATAWIDTH   =    32,
U_ADDR2018_r0.ININTVALUE  = 32'd1000,
U_ADDR2018_r0.REGADDRESS  = ADDR2018;

assign clut_tas_inr = Q2018r0[15 :0] ;

assign SirDack2018       = SirDack2018r0;
assign SirRdat2018[31:0] = SirRdat2018r0;




//************************************************************************************
//  fir_enable  register    0x80022048      
//************************************************************************************
parameter       ADDR2048   = 16'h2048       ;

wire            SirDack2048     ;
wire    [31:0]  SirRdat2048     ;

wire            SirDack2048r0   ;
wire    [31:0]  SirRdat2048r0   ;
wire    [31:0]  Q2048r0         ;

reg_rw   U_ADDR2048_r0(
                .clk        (clk                ),
                .rst        (rst                ),                           
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat      	    ),
                .SirDack    (SirDack2048r0      ),
                .SirRdat    (SirRdat2048r0      ),
                .Q          (Q2048r0            )
                );

defparam
U_ADDR2048_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR2048_r0.DATAWIDTH   =    32,
U_ADDR2048_r0.ININTVALUE  =    32'b0,
U_ADDR2048_r0.REGADDRESS  = ADDR2048;

assign fir_enable = Q2048r0[0 :0] ;

assign SirDack2048       = SirDack2048r0;
assign SirRdat2048[31:0] = SirRdat2048r0;

//************************************************************************************
//  fir_enable  register    0x8002204c      
//************************************************************************************
parameter       ADDR204c   = 16'h204c       ;

wire            SirDack204c     ;
wire    [31:0]  SirRdat204c     ;

wire            SirDack204cr0   ;
wire    [31:0]  SirRdat204cr0   ;
wire    [31:0]  Q204cr0         ;

reg_rw   U_ADDR204c_r0(
                .clk        (clk                ),
                .rst        (rst                ),                           
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat      	    ),
                .SirDack    (SirDack204cr0      ),
                .SirRdat    (SirRdat204cr0      ),
                .Q          (Q204cr0            )
                );

defparam
U_ADDR204c_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR204c_r0.DATAWIDTH   =    32,
U_ADDR204c_r0.ININTVALUE  =    32'b0,
U_ADDR204c_r0.REGADDRESS  = ADDR204c;

assign config_trigger = Q204cr0[0 :0] ;

assign SirDack204c       = SirDack204cr0;
assign SirRdat204c[31:0] = SirRdat204cr0;

//************************************************************************************
//  Calibration_IQCHA  register    0x80022050      
//************************************************************************************
parameter       ADDR2050   = 16'h2050       ;

wire            SirDack2050     ;
wire    [31:0]  SirRdat2050     ;

wire            SirDack2050r0   ;
wire    [31:0]  SirRdat2050r0   ;
wire    [31:0]  Q2050r0         ;

reg_rw   U_ADDR2050_r0(
                .clk        (clk                ),
                .rst        (rst                ),                           
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat      	    ),
                .SirDack    (SirDack2050r0      ),
                .SirRdat    (SirRdat2050r0      ),
                .Q          (Q2050r0            )
                );

defparam
U_ADDR2050_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR2050_r0.DATAWIDTH   =    32,
U_ADDR2050_r0.ININTVALUE  =    32'h1000,
U_ADDR2050_r0.REGADDRESS  = ADDR2050;

assign Calibration_IQCHA = Q2050r0[31 :0] ;

assign SirDack2050       = SirDack2050r0;
assign SirRdat2050[31:0] = SirRdat2050r0;

//************************************************************************************
//  Calibration_IQCHB  register    0x80022054      
//************************************************************************************
parameter       ADDR2054   = 16'h2054       ;

wire            SirDack2054     ;
wire    [31:0]  SirRdat2054     ;

wire            SirDack2054r0   ;
wire    [31:0]  SirRdat2054r0   ;
wire    [31:0]  Q2054r0         ;

reg_rw   U_ADDR2054_r0(
                .clk        (clk                ),
                .rst        (rst                ),                           
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat      	    ),
                .SirDack    (SirDack2054r0      ),
                .SirRdat    (SirRdat2054r0      ),
                .Q          (Q2054r0            )
                );

defparam
U_ADDR2054_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR2054_r0.DATAWIDTH   =    32,
U_ADDR2054_r0.ININTVALUE  =    32'hFD780c32,
U_ADDR2054_r0.REGADDRESS  = ADDR2054;

assign Calibration_IQCHB = Q2054r0[31 :0] ;

assign SirDack2054       = SirDack2054r0;
assign SirRdat2054[31:0] = SirRdat2054r0;

//************************************************************************************
//             地址0x80022058 RW  adc_abnormal_num_max
//************************************************************************************
parameter       ADDR2058   = 16'h2058       ;

wire            SirDack2058     ;
wire    [31:0]  SirRdat2058     ;

wire            SirDack2058r0   ;
wire    [31:0]  SirRdat2058r0   ;
wire    [31:0]  Q2058r0         ;

reg_ro   U_ADDR2058_r0(
        .clk        (clk                ),
        .rst        (rst                ),

        .SirSel     (SirSel            	),
        .SirRead    (SirRead            ),
        .SirAddr    (SirAddr            ),
        // .SirWdat    (SirWdat      	),
        .SirDack    (SirDack2058r0      ),
        .SirRdat    (SirRdat2058r0      ),
        .Load       (1'b1               ),  
        .D          (cur_wave_position  )
);

defparam
U_ADDR2058_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR2058_r0.DATAWIDTH   =    32,
U_ADDR2058_r0.ININTVALUE  = 32'h0,
U_ADDR2058_r0.REGADDRESS  = ADDR2058;

assign SirDack2058       = SirDack2058r0;
assign SirRdat2058[31:0] = SirRdat2058r0;


//************************************************************************************
//         adc_truncation register    0x80022f00      
//************************************************************************************
parameter       ADDR2f00   = 16'h2f00       ;

wire            SirDack2f00     ;
wire    [31:0]  SirRdat2f00     ;

wire            SirDack2f00r0   ;
wire    [31:0]  SirRdat2f00r0   ;
wire    [31:0]  Q2f00r0         ;

reg_rw   U_ADDR2f00_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat      	),
                .SirDack    (SirDack2f00r0      ),
                .SirRdat    (SirRdat2f00r0      ),
                .Q          (Q2f00r0            )
                );

defparam
U_ADDR2f00_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR2f00_r0.DATAWIDTH   =    32,
U_ADDR2f00_r0.ININTVALUE  = 32'd11,
U_ADDR2f00_r0.REGADDRESS  = ADDR2f00;

assign adc_truncation = Q2f00r0[15 :0] ;

assign SirDack2f00       = SirDack2f00r0;
assign SirRdat2f00[31:0] = SirRdat2f00r0;


//************************************************************************************
//         rfft_truncation register    0x80022f04      
//************************************************************************************
parameter       ADDR2f04   = 16'h2f04       ;

wire            SirDack2f04     ;
wire    [31:0]  SirRdat2f04     ;

wire            SirDack2f04r0   ;
wire    [31:0]  SirRdat2f04r0   ;
wire    [31:0]  Q2f04r0         ;

reg_rw   U_ADDR2f04_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat      	    ),
                .SirDack    (SirDack2f04r0      ),
                .SirRdat    (SirRdat2f04r0      ),
                .Q          (Q2f04r0            )
                );

defparam
U_ADDR2f04_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR2f04_r0.DATAWIDTH   =    32,
U_ADDR2f04_r0.ININTVALUE  = 32'd8,
U_ADDR2f04_r0.REGADDRESS  = ADDR2f04;

assign rfft_truncation = Q2f04r0[15 :0] ;

assign SirDack2f04       = SirDack2f04r0;
assign SirRdat2f04[31:0] = SirRdat2f04r0;




always @ (posedge clk )
begin
    if (rst == 1'b1)
        SirDack <= 1'b0;
    else
        SirDack <=
                        SirDack2000 | SirDack2004 | SirDack2008 | SirDack200c | SirDack2010 | SirDack2014  | SirDack2018 |
                        SirDack2048 | SirDack204c | SirDack2050 | SirDack2054 | SirDack2058 |
            			SirDack2f00 | SirDack2f04 
			;
end       

always @ (posedge clk)
begin
        SirRdat <=      
                        SirRdat2000 | SirRdat2004 | SirRdat2008 | SirRdat200c | SirRdat2010 | SirRdat2014 | SirRdat2018 |
                        SirRdat2048 | SirRdat204c | SirRdat2050 | SirRdat2054 | SirRdat2058 |
                        SirRdat2f00 | SirRdat2f04 
			;
end 

endmodule

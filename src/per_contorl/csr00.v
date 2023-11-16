`include"../top/define.v"
module csr00
(
    input	wire               rst,
    input	wire               clk,

    input   wire    [15:0]     SirAddr ,
    input   wire               SirRead ,
    input   wire    [31:0]     SirWdat ,
    input   wire               SirSel  ,
    output  reg                SirDack ,
    output  reg     [31:0]     SirRdat ,

    input   wire    [22:0]     lmx2492_reg0 ,
    input   wire    [22:0]     lmx2492_reg1 ,
    input   wire    [22:0]     lmx2492_reg2 ,
    input   wire    [22:0]     lmx2492_reg3 ,
    input   wire    [22:0]     lmx2492_reg4 ,
    input   wire    [22:0]     lmx2492_reg5 ,
    input   wire    [22:0]     lmx2492_reg6 ,
    input   wire    [22:0]     lmx2492_reg7 ,
    input   wire    [22:0]     lmx2492_reg8 ,
    input   wire    [22:0]     lmx2492_reg9 ,
    input   wire    [15:0]     pll_ana_ad   ,

    output  reg                lmx2492_write_data_valid ,
    output  wire    [23:0]     lmx2492_write_data       ,
    output  wire    [7 :0]     lmx2492_batch_wr         ,
    output  wire    [3 :0]     lmx2492_batch_rd         ,

    output  reg                adc_3244_write_data_valid,
    output  wire    [24:0]     adc_3244_write_data      ,
    input   wire    [22:0]     adc_3244_reg0            ,
    
    output  reg                chc2442_write_data_valid ,
    output  wire    [24:0]     chc2442_write_data       ,
    input   wire    [31:0]     chc2422_reg0             ,
    
	output 	wire    [31:0]	   awmf0165_ctr 	        ,
    output  wire    [31:0]     awmf0165_select          ,
    output  wire    [3 :0]     u8_awmf0165_ctr          ,
    output  wire               awmf0165_pspl_select     ,
    output  wire    [1 :0]     u8_awmf0165_select       ,

	output	reg  			   u0_write_data_en         ,
	output	wire    [31:0]	   u0_write_data_in         ,
	output	reg  			   u1_write_data_en         ,
	output	wire    [31:0]	   u1_write_data_in         ,
	output	reg  			   u2_write_data_en         ,
	output	wire    [31:0]	   u2_write_data_in         ,
	output	reg  			   u3_write_data_en         ,
	output	wire    [31:0]	   u3_write_data_in         ,
	output	reg  			   u4_write_data_en         ,
	output	wire    [31:0]	   u4_write_data_in         ,

	input   wire    [255:0]	   u0_awmf0165_reg          ,
	input   wire    [255:0]	   u1_awmf0165_reg          ,
	input   wire    [255:0]	   u2_awmf0165_reg          ,
	input   wire    [255:0]	   u3_awmf0165_reg          ,
	input   wire    [255:0]	   u4_awmf0165_reg          ,
    input   wire    [9 :0]     awmf_0165_status         ,

    output  reg     [31:0]     CPI_DELAY_sync           ,     
    output  reg     [15:0]     PRI_PERIOD_sync          ,
    output  reg     [7 :0]     PRI_NUM_sync             ,
    output  reg     [7 :0]     PRI_PULSE_WIDTH_sync     ,
    output  reg     [15:0]     START_SAMPLE_sync        ,
    output  reg     [15:0]     SAMPLE_LENGTH_sync       ,
    output          [7 :0]     WAVE_CODE                ,
    output                     first_chrip_disable      ,
    input   wire    [15:0]     temperature
);

parameter       SLAVE_SIZE  = 16;
wire            timing_sync;
reg             timing_sync_d0 ='d0;
reg             timing_sync_d1 ='d0;

wire [31:0]     CPI_DELAY      ;     
wire [15:0]     PRI_PERIOD     ;
wire [7 :0]     PRI_NUM        ;
wire [7 :0]     PRI_PULSE_WIDTH;
wire [15:0]     START_SAMPLE   ;
wire [15:0]     SAMPLE_LENGTH  ;

always @(posedge clk) begin
    timing_sync_d0 <= timing_sync;
    timing_sync_d1 <= timing_sync_d0;
end

always @(posedge clk) begin
    if(rst) begin 
        CPI_DELAY_sync          <=16'd2000;
        PRI_PERIOD_sync         <=16'd5300;
        PRI_NUM_sync            <=8'd32;
        PRI_PULSE_WIDTH_sync    <=8'd40;
        START_SAMPLE_sync       <=16'd1000;
        SAMPLE_LENGTH_sync      <=16'd4097;
    end
    else if(~timing_sync_d1 && timing_sync_d0) begin
        CPI_DELAY_sync          <=CPI_DELAY      ;
        PRI_PERIOD_sync         <=PRI_PERIOD     ;
        PRI_NUM_sync            <=PRI_NUM        ;
        PRI_PULSE_WIDTH_sync    <=PRI_PULSE_WIDTH;
        START_SAMPLE_sync       <=START_SAMPLE   ;
        SAMPLE_LENGTH_sync      <=SAMPLE_LENGTH  ;
    end
end

//************************************************************************************
//      addr :0x80020000 RO 32bit 版本号
//************************************************************************************
parameter       ADDR0000   = 16'h0000       ;

wire            SirDack0000     ;
wire    [31:0]  SirRdat0000     ;

wire            SirDack0000r0   ;
wire    [31:0]  SirRdat0000r0   ;


reg_ro   U_ADDR0000_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                // .SirWdat    (SirWdat      		),
                .SirDack    (SirDack0000r0      ),
                .SirRdat    (SirRdat0000r0      ),
                .Load       (1'b1               ),  
                .D          (`VERSION_NUM       )
                );
defparam
U_ADDR0000_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0000_r0.DATAWIDTH   =    32,
U_ADDR0000_r0.ININTVALUE  = 32'h0,
U_ADDR0000_r0.REGADDRESS  = ADDR0000;


assign SirDack0000       = SirDack0000r0;
assign SirRdat0000[31:0] = SirRdat0000r0;

//************************************************************************************
//      addr :0x80020004 RO 32bit 版本号
//************************************************************************************
parameter       ADDR0004   = 16'h0004       ;

wire            SirDack0004     ;
wire    [31:0]  SirRdat0004     ;

wire            SirDack0004r0   ;
wire    [31:0]  SirRdat0004r0   ;


reg_ro   U_ADDR0004_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                // .SirWdat    (SirWdat      		),
                .SirDack    (SirDack0004r0      ),
                .SirRdat    (SirRdat0004r0      ),
                .Load       (1'b1               ),  
                .D          (`COMPILE_TIM2      )
                );
defparam
U_ADDR0004_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0004_r0.DATAWIDTH   =    32,
U_ADDR0004_r0.ININTVALUE  = 32'h0,
U_ADDR0004_r0.REGADDRESS  = ADDR0004;

assign SirDack0004       = SirDack0004r0;
assign SirRdat0004[31:0] = SirRdat0004r0;

//************************************************************************************
//      addr: 0x80020100 32bit rw lmx2492_data 
//************************************************************************************

parameter       ADDR0100   = 16'h0100  ;
wire            SirDack0100     ;
wire    [31:0]  SirRdat0100     ;

wire            SirDack0100r0   ;
wire    [31:0]  SirRdat0100r0   ;
wire    [31:0]  Q0100r0         ;
reg_rw   U_ADDR0100_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat      		),
                .SirDack    (SirDack0100r0      ),
                .SirRdat    (SirRdat0100r0      ),
                .Q          (Q0100r0           )
                );
defparam
U_ADDR0100_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0100_r0.DATAWIDTH   =    32,
U_ADDR0100_r0.ININTVALUE  = 32'h0,
U_ADDR0100_r0.REGADDRESS  = ADDR0100;

assign  lmx2492_write_data = Q0100r0[23:0];

assign SirDack0100       = SirDack0100r0;
assign SirRdat0100[31:0] = SirRdat0100r0;

reg SirSel_d1 ;

always @(posedge clk ) begin
    if(rst)
        SirSel_d1 <= 1'b0 ;
    else 
        SirSel_d1 <= SirSel;
end

always @(posedge clk ) begin
    if(rst)
        lmx2492_write_data_valid <= 1'd0 ;
    else if(SirSel_d1 == 1'b1 && SirSel == 1'b0 && SirRead == 1'b0 && SirAddr == ADDR0100)
        lmx2492_write_data_valid <= 1'b1 ;
    else 
        lmx2492_write_data_valid <= 1'b0 ;
end
//************************************************************************************
//      addr: 0x80020104 32bit rw {lmx2492_batch_rd,lmx2492_batch_wr} 
//************************************************************************************

parameter       ADDR0104   = 16'h0104  ;
wire            SirDack0104     ;
wire    [31:0]  SirRdat0104     ;

wire            SirDack0104r0   ;
wire    [31:0]  SirRdat0104r0   ;
wire    [31:0]  Q0104r0         ;

reg_rw   U_ADDR0104_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat      		),
                .SirDack    (SirDack0104r0      ),
                .SirRdat    (SirRdat0104r0      ),
                .Q          (Q0104r0           )
                );
defparam
U_ADDR0104_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0104_r0.DATAWIDTH   =    32,
U_ADDR0104_r0.ININTVALUE  = 32'h0,
U_ADDR0104_r0.REGADDRESS  = ADDR0104;

assign  lmx2492_batch_wr = Q0104r0[7 :0];
assign  lmx2492_batch_rd = Q0104r0[11:8];

assign SirDack0104       = SirDack0104r0;
assign SirRdat0104[31:0] = SirRdat0104r0;

//************************************************************************************
//      addr: 0x80020108 32bit r0 {lmx2492_reg0} 
//************************************************************************************

parameter       ADDR0108   = 16'h0108  ;
wire            SirDack0108     ;
wire    [31:0]  SirRdat0108     ;

wire            SirDack0108r0   ;
wire    [31:0]  SirRdat0108r0   ;
wire    [31:0]  Q0108r0         ;

reg_ro   U_ADDR0108_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0108r0      ),
                .SirRdat    (SirRdat0108r0      ),
                .Load       (1'b1               ),  
                .D          ({9'b0,lmx2492_reg0})
                );
defparam
U_ADDR0108_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0108_r0.DATAWIDTH   =    32,
U_ADDR0108_r0.ININTVALUE  = 32'h0,
U_ADDR0108_r0.REGADDRESS  = ADDR0108;


assign SirDack0108       = SirDack0108r0;
assign SirRdat0108[31:0] = SirRdat0108r0;

//************************************************************************************
//      addr: 0x43c0010c 32bit r0 {lmx2492_reg1} 
//************************************************************************************

parameter       ADDR010c   = 16'h010c  ;
wire            SirDack010c     ;
wire    [31:0]  SirRdat010c     ;

wire            SirDack010cr0   ;
wire    [31:0]  SirRdat010cr0   ;
wire    [31:0]  Q010cr0         ;

reg_ro   U_ADDR010c_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack010cr0      ),
                .SirRdat    (SirRdat010cr0      ),
                .Load       (1'b1               ),  
                .D          ({9'b0,lmx2492_reg1})
                );
defparam
U_ADDR010c_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR010c_r0.DATAWIDTH   =    32,
U_ADDR010c_r0.ININTVALUE  = 32'h0,
U_ADDR010c_r0.REGADDRESS  = ADDR010c;


assign SirDack010c       = SirDack010cr0;
assign SirRdat010c[31:0] = SirRdat010cr0;

//************************************************************************************
//      addr: 0x43c00110 32bit r0 {lmx2492_reg2} 
//************************************************************************************

parameter       ADDR0110   = 16'h0110  ;
wire            SirDack0110     ;
wire    [31:0]  SirRdat0110     ;

wire            SirDack0110r0   ;
wire    [31:0]  SirRdat0110r0   ;
wire    [31:0]  Q0110r0         ;

reg_ro   U_ADDR0110_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0110r0      ),
                .SirRdat    (SirRdat0110r0      ),
                .Load       (1'b1               ),  
                .D          ({9'b0,lmx2492_reg2})
                );
defparam
U_ADDR0110_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0110_r0.DATAWIDTH   =    32,
U_ADDR0110_r0.ININTVALUE  = 32'h0,
U_ADDR0110_r0.REGADDRESS  = ADDR0110;


assign SirDack0110       = SirDack0110r0;
assign SirRdat0110[31:0] = SirRdat0110r0;

//************************************************************************************
//      addr: 0x43c00114 32bit r0 {lmx2492_reg3} 
//************************************************************************************

parameter       ADDR0114   = 16'h0114  ;
wire            SirDack0114     ;
wire    [31:0]  SirRdat0114     ;

wire            SirDack0114r0   ;
wire    [31:0]  SirRdat0114r0   ;
wire    [31:0]  Q0114r0         ;

reg_ro   U_ADDR0114_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0114r0      ),
                .SirRdat    (SirRdat0114r0      ),
                .Load       (1'b1               ),  
                .D          ({9'b0,lmx2492_reg3})
                );
defparam
U_ADDR0114_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0114_r0.DATAWIDTH   =    32,
U_ADDR0114_r0.ININTVALUE  = 32'h0,
U_ADDR0114_r0.REGADDRESS  = ADDR0110;


assign SirDack0114       = SirDack0114r0;
assign SirRdat0114[31:0] = SirRdat0114r0;

//************************************************************************************
//      addr: 0x43c00118 32bit r0 {lmx2492_reg4} 
//************************************************************************************

parameter       ADDR0118   = 16'h0118  ;
wire            SirDack0118     ;
wire    [31:0]  SirRdat0118     ;

wire            SirDack0118r0   ;
wire    [31:0]  SirRdat0118r0   ;
wire    [31:0]  Q0118r0         ;

reg_ro   U_ADDR0118_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0118r0      ),
                .SirRdat    (SirRdat0118r0      ),
                .Load       (1'b1               ),  
                .D          ({9'b0,lmx2492_reg4})
                );
defparam
U_ADDR0118_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0118_r0.DATAWIDTH   =    32,
U_ADDR0118_r0.ININTVALUE  = 32'h0,
U_ADDR0118_r0.REGADDRESS  = ADDR0118;


assign SirDack0118       = SirDack0118r0;
assign SirRdat0118[31:0] = SirRdat0118r0;

//************************************************************************************
//      addr: 0x43c0011c 32bit r0 {lmx2492_reg5} 
//************************************************************************************

parameter       ADDR011c   = 16'h011c  ;
wire            SirDack011c     ;
wire    [31:0]  SirRdat011c     ;

wire            SirDack011cr0   ;
wire    [31:0]  SirRdat011cr0   ;
wire    [31:0]  Q011cr0         ;

reg_ro   U_ADDR011c_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack011cr0      ),
                .SirRdat    (SirRdat011cr0      ),
                .Load       (1'b1               ),  
                .D          ({9'b0,lmx2492_reg5})
                );
defparam
U_ADDR011c_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR011c_r0.DATAWIDTH   =    32,
U_ADDR011c_r0.ININTVALUE  = 32'h0,
U_ADDR011c_r0.REGADDRESS  = ADDR011c;


assign SirDack011c       = SirDack011cr0;
assign SirRdat011c[31:0] = SirRdat011cr0;

//************************************************************************************
//      addr: 0x43c00120 32bit r0 {lmx2492_reg6} 
//************************************************************************************

parameter       ADDR0120   = 16'h0120  ;
wire            SirDack0120     ;
wire    [31:0]  SirRdat0120     ;

wire            SirDack0120r0   ;
wire    [31:0]  SirRdat0120r0   ;
wire    [31:0]  Q0120r0         ;

reg_ro   U_ADDR0120_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0120r0      ),
                .SirRdat    (SirRdat0120r0      ),
                .Load       (1'b1               ),  
                .D          ({9'b0,lmx2492_reg6})
                );
defparam
U_ADDR0120_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0120_r0.DATAWIDTH   =    32,
U_ADDR0120_r0.ININTVALUE  = 32'h0,
U_ADDR0120_r0.REGADDRESS  = ADDR0120;


assign SirDack0120       = SirDack0120r0;
assign SirRdat0120[31:0] = SirRdat0120r0;

//************************************************************************************
//      addr: 0x43c00124 32bit r0 {lmx2492_reg7} 
//************************************************************************************

parameter       ADDR0124   = 16'h0124  ;
wire            SirDack0124     ;
wire    [31:0]  SirRdat0124     ;

wire            SirDack0124r0   ;
wire    [31:0]  SirRdat0124r0   ;
wire    [31:0]  Q0124r0         ;

reg_ro   U_ADDR0124_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0124r0      ),
                .SirRdat    (SirRdat0124r0      ),
                .Load       (1'b1               ),  
                .D          ({9'b0,lmx2492_reg7})
                );
defparam
U_ADDR0124_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0124_r0.DATAWIDTH   =    32,
U_ADDR0124_r0.ININTVALUE  = 32'h0,
U_ADDR0124_r0.REGADDRESS  = ADDR0124;


assign SirDack0124       = SirDack0124r0;
assign SirRdat0124[31:0] = SirRdat0124r0;


//************************************************************************************
//      addr: 0x43c00128 32bit r0 {lmx2492_reg8} 
//************************************************************************************

parameter       ADDR0128   = 16'h0128  ;
wire            SirDack0128     ;
wire    [31:0]  SirRdat0128     ;

wire            SirDack0128r0   ;
wire    [31:0]  SirRdat0128r0   ;
wire    [31:0]  Q0128r0         ;

reg_ro   U_ADDR0128_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0128r0      ),
                .SirRdat    (SirRdat0128r0      ),
                .Load       (1'b1               ),  
                .D          ({9'b0,lmx2492_reg8})
                );
defparam
U_ADDR0128_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0128_r0.DATAWIDTH   =    32,
U_ADDR0128_r0.ININTVALUE  = 32'h0,
U_ADDR0128_r0.REGADDRESS  = ADDR0128;


assign SirDack0128       = SirDack0128r0;
assign SirRdat0128[31:0] = SirRdat0128r0;

//************************************************************************************
//      addr: 0x43c0012c 32bit r0 {lmx2492_reg9} 
//************************************************************************************

parameter       ADDR012c   = 16'h012c  ;
wire            SirDack012c     ;
wire    [31:0]  SirRdat012c     ;

wire            SirDack012cr0   ;
wire    [31:0]  SirRdat012cr0   ;
wire    [31:0]  Q012cr0         ;

reg_ro   U_ADDR012c_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack012cr0      ),
                .SirRdat    (SirRdat012cr0      ),
                .Load       (1'b1               ),  
                .D          ({9'b0,lmx2492_reg9})
                );
defparam
U_ADDR012c_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR012c_r0.DATAWIDTH   =    32,
U_ADDR012c_r0.ININTVALUE  = 32'h0,
U_ADDR012c_r0.REGADDRESS  = ADDR012c;


assign SirDack012c       = SirDack012cr0;
assign SirRdat012c[31:0] = SirRdat012cr0;

//----------------------------adc_3244----------------------------------

//************************************************************************************
//      addr: 0x80020200 32bit rw adc3663_data 
//************************************************************************************

parameter       ADDR0200   = 16'h0200  ;
wire            SirDack0200     ;
wire    [31:0]  SirRdat0200     ;

wire            SirDack0200r0   ;
wire    [31:0]  SirRdat0200r0   ;
wire    [31:0]  Q0200r0         ;
reg_rw   U_ADDR0200_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat      		),
                .SirDack    (SirDack0200r0      ),
                .SirRdat    (SirRdat0200r0      ),
                .Q          (Q0200r0           )
                );
defparam
U_ADDR0200_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0200_r0.DATAWIDTH   =    32,
U_ADDR0200_r0.ININTVALUE  = 32'h0,
U_ADDR0200_r0.REGADDRESS  = ADDR0200;

assign  adc_3244_write_data = Q0200r0[24:0];

assign SirDack0200       = SirDack0200r0;
assign SirRdat0200[31:0] = SirRdat0200r0;


always @(posedge clk ) begin
    if(rst)
        adc_3244_write_data_valid <= 1'd0 ;
    else if(SirSel_d1 == 1'b1 && SirSel == 1'b0 && SirRead == 1'b0 && SirAddr == ADDR0200)
        adc_3244_write_data_valid <= 1'b1 ;
    else 
        adc_3244_write_data_valid <= 1'b0 ;
end

//************************************************************************************
//      addr: 0x80020204 32bit r0 {adc3244_reg0} 
//************************************************************************************

parameter       ADDR0204   = 16'h0204  ;
wire            SirDack0204     ;
wire    [31:0]  SirRdat0204     ;

wire            SirDack0204cr0  ;
wire    [31:0]  SirRdat0204r0   ;
wire    [31:0]  Q0204r0         ;

reg_ro   U_ADDR0204_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0204r0      ),
                .SirRdat    (SirRdat0204r0      ),
                .Load       (1'b1               ),  
                .D          ({9'b0,adc_3244_reg0})
                );
defparam
U_ADDR0204_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0204_r0.DATAWIDTH   =    32,
U_ADDR0204_r0.ININTVALUE  = 32'h0,
U_ADDR0204_r0.REGADDRESS  = ADDR0204;


assign SirDack0204       = SirDack0204r0;
assign SirRdat0204[31:0] = SirRdat0204r0;


//----------------------------chc_2442----------------------------------

//************************************************************************************
//      addr: 0x80020210 32bit rw chc2442_write_data
//************************************************************************************

parameter       ADDR0210   = 16'h0210  ;
wire            SirDack0210     ;
wire    [31:0]  SirRdat0210     ;

wire            SirDack0210r0   ;
wire    [31:0]  SirRdat0210r0   ;
wire    [31:0]  Q0210r0         ;
reg_rw   U_ADDR0210_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat      		),
                .SirDack    (SirDack0210r0      ),
                .SirRdat    (SirRdat0210r0      ),
                .Q          (Q0210r0           )
                );
defparam
U_ADDR0210_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0210_r0.DATAWIDTH   =    32,
U_ADDR0210_r0.ININTVALUE  = 32'h0,
U_ADDR0210_r0.REGADDRESS  = ADDR0210;

assign  chc2442_write_data = Q0210r0[24:0];

assign SirDack0210       = SirDack0210r0;
assign SirRdat0210[31:0] = SirRdat0210r0;

always @(posedge clk ) begin
    if(rst)
        chc2442_write_data_valid <= 1'd0 ;
    else if(SirSel_d1 == 1'b1 && SirSel == 1'b0 && SirRead == 1'b0 && SirAddr == ADDR0210)
        chc2442_write_data_valid <= 1'b1 ;
    else 
        chc2442_write_data_valid <= 1'b0 ;
end

//************************************************************************************
//      addr: 0x43c0_0214 32bit r0 {chc2442_reg0} 
//************************************************************************************

parameter       ADDR0214   = 16'h0214  ;
wire            SirDack0214     ;
wire    [31:0]  SirRdat0214     ;

wire            SirDack0214cr0  ;
wire    [31:0]  SirRdat0214r0   ;
wire    [31:0]  Q0214r0         ;

reg_ro   U_ADDR0214_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0214r0      ),
                .SirRdat    (SirRdat0214r0      ),
                .Load       (1'b1               ),  
                .D          (chc2422_reg0       )
                );
defparam
U_ADDR0214_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0214_r0.DATAWIDTH   =    32,
U_ADDR0214_r0.ININTVALUE  = 32'h0,
U_ADDR0214_r0.REGADDRESS  = ADDR0214;


assign SirDack0214       = SirDack0214r0;
assign SirRdat0214[31:0] = SirRdat0214r0;


//************************************************************************************
//      addr :0x80020300 RW 32bit AWMF0165 CHAIN0 WRITE DATA 
//************************************************************************************
parameter       ADDR0300   = 16'h0300       ;

wire            SirDack0300     ;
wire    [31:0]  SirRdat0300     ;

wire            SirDack0300r0   ;
wire    [31:0]  SirRdat0300r0   ;
wire    [31:0]  Q0300r0         ;

reg_rw   U_ADDR0300_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat      		),
                .SirDack    (SirDack0300r0      ),
                .SirRdat    (SirRdat0300r0      ),
                .Q          (Q0300r0           )
                );
defparam
U_ADDR0300_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0300_r0.DATAWIDTH   =    32,
U_ADDR0300_r0.ININTVALUE  = 32'h0,
U_ADDR0300_r0.REGADDRESS  = ADDR0300;

assign  u0_write_data_in = Q0300r0 ;

always @(posedge clk ) begin
    if(rst)
        u0_write_data_en <= 1'd0 ;
    else if(SirSel_d1 == 1'b1 && SirSel == 1'b0 && SirRead == 1'b0 && SirAddr == ADDR0300)
        u0_write_data_en <= 1'b1 ;
    else 
        u0_write_data_en <= 1'b0 ;
end


assign SirDack0300       = SirDack0300r0;
assign SirRdat0300[31:0] = SirRdat0300r0;


//************************************************************************************
//      addr :0x80020304 RW 32bit AWMF0165 CHAIN1 WRITE DATA 
//************************************************************************************
parameter       ADDR0304   = 16'h0304       ;

wire            SirDack0304     ;
wire    [31:0]  SirRdat0304     ;

wire            SirDack0304r0   ;
wire    [31:0]  SirRdat0304r0   ;
wire    [31:0]  Q0304r0         ;

reg_rw   U_ADDR0304_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat      		),
                .SirDack    (SirDack0304r0      ),
                .SirRdat    (SirRdat0304r0      ),
                .Q          (Q0304r0           )
                );
defparam
U_ADDR0304_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0304_r0.DATAWIDTH   =    32,
U_ADDR0304_r0.ININTVALUE  = 32'h0,
U_ADDR0304_r0.REGADDRESS  = ADDR0304;

assign  u1_write_data_in = Q0304r0 ;

always @(posedge clk ) begin
    if(rst)
        u1_write_data_en <= 1'd0 ;
    else if(SirSel_d1 == 1'b1 && SirSel == 1'b0 && SirRead == 1'b0 && SirAddr == ADDR0304)
        u1_write_data_en <= 1'b1 ;
    else 
        u1_write_data_en <= 1'b0 ;
end


assign SirDack0304       = SirDack0304r0;
assign SirRdat0304[31:0] = SirRdat0304r0;


//************************************************************************************
//      addr :0x80020308 RW 32bit AWMF0165 CHAIN2 WRITE DATA 
//************************************************************************************
parameter       ADDR0308   = 16'h0308       ;

wire            SirDack0308     ;
wire    [31:0]  SirRdat0308     ;

wire            SirDack0308r0   ;
wire    [31:0]  SirRdat0308r0   ;
wire    [31:0]  Q0308r0         ;

reg_rw   U_ADDR0308_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat      		),
                .SirDack    (SirDack0308r0      ),
                .SirRdat    (SirRdat0308r0      ),
                .Q          (Q0308r0           )
                );
defparam
U_ADDR0308_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0308_r0.DATAWIDTH   =    32,
U_ADDR0308_r0.ININTVALUE  = 32'h0,
U_ADDR0308_r0.REGADDRESS  = ADDR0308;

assign  u2_write_data_in = Q0308r0 ;

always @(posedge clk ) begin
    if(rst)
        u2_write_data_en <= 1'd0 ;
    else if(SirSel_d1 == 1'b1 && SirSel == 1'b0 && SirRead == 1'b0 && SirAddr == ADDR0308)
        u2_write_data_en <= 1'b1 ;
    else 
        u2_write_data_en <= 1'b0 ;
end


assign SirDack0308       = SirDack0308r0;
assign SirRdat0308[31:0] = SirRdat0308r0;

//************************************************************************************
//      addr :0x8002030c RW 32bit AWMF0165 CHAIN3 WRITE DATA 
//************************************************************************************
parameter       ADDR030c  = 16'h030c       ;

wire            SirDack030c     ;
wire    [31:0]  SirRdat030c     ;

wire            SirDack030cr0   ;
wire    [31:0]  SirRdat030cr0   ;
wire    [31:0]  Q030cr0         ;

reg_rw   U_ADDR030c_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat      		),
                .SirDack    (SirDack030cr0      ),
                .SirRdat    (SirRdat030cr0      ),
                .Q          (Q030cr0           )
                );
defparam
U_ADDR030c_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR030c_r0.DATAWIDTH   =    32,
U_ADDR030c_r0.ININTVALUE  = 32'h0,
U_ADDR030c_r0.REGADDRESS  = ADDR030c;

assign  u3_write_data_in = Q030cr0 ;

always @(posedge clk ) begin
    if(rst)
        u3_write_data_en <= 1'd0 ;
    else if(SirSel_d1 == 1'b1 && SirSel == 1'b0 && SirRead == 1'b0 && SirAddr == ADDR030c)
        u3_write_data_en <= 1'b1 ;
    else 
        u3_write_data_en <= 1'b0 ;
end


assign SirDack030c       = SirDack030cr0;
assign SirRdat030c[31:0] = SirRdat030cr0;


// tx_group0
//************************************************************************************
//      addr: 0x80020310 32bit r0 {u0_awmf0165_reg[31:0]} 
//************************************************************************************

parameter       ADDR0310   = 16'h0310  ;
wire            SirDack0310     ;
wire    [31:0]  SirRdat0310     ;

wire            SirDack0310r0   ;
wire    [31:0]  SirRdat0310r0   ;
wire    [31:0]  Q0310r0         ;

reg_ro   U_ADDR0310_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0310r0      ),
                .SirRdat    (SirRdat0310r0      ),
                .Load       (1'b1               ),  
                .D          (u0_awmf0165_reg[31:0])
                );
defparam
U_ADDR0310_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0310_r0.DATAWIDTH   =    32,
U_ADDR0310_r0.ININTVALUE  = 32'h0,
U_ADDR0310_r0.REGADDRESS  = ADDR0310;


assign SirDack0310       = SirDack0310r0;
assign SirRdat0310[31:0] = SirRdat0310r0;

//************************************************************************************
//      addr: 0x80020314 32bit r0 {u0_awmf0165_reg[63:32]} 
//************************************************************************************

parameter       ADDR0314   = 16'h0314  ;
wire            SirDack0314     ;
wire    [31:0]  SirRdat0314     ;

wire            SirDack0314r0  ;
wire    [31:0]  SirRdat0314r0   ;
wire    [31:0]  Q0314r0         ;

reg_ro   U_ADDR0314_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0314r0      ),
                .SirRdat    (SirRdat0314r0      ),
                .Load       (1'b1               ),  
                .D          (u0_awmf0165_reg[63:32])
                );
defparam
U_ADDR0314_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0314_r0.DATAWIDTH   =    32,
U_ADDR0314_r0.ININTVALUE  = 32'h0,
U_ADDR0314_r0.REGADDRESS  = ADDR0314;


assign SirDack0314       = SirDack0314r0;
assign SirRdat0314[31:0] = SirRdat0314r0;


//************************************************************************************
//      addr: 0x80020318 32bit r0 {u0_awmf0165_reg[95:64]} 
//************************************************************************************

parameter       ADDR0318   = 16'h0318  ;
wire            SirDack0318     ;
wire    [31:0]  SirRdat0318     ;

wire            SirDack0318r0  ;
wire    [31:0]  SirRdat0318r0   ;
wire    [31:0]  Q0318r0         ;

reg_ro   U_ADDR0318_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0318r0      ),
                .SirRdat    (SirRdat0318r0      ),
                .Load       (1'b1               ),  
                .D          (u0_awmf0165_reg[95:64])
                );
defparam
U_ADDR0318_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0318_r0.DATAWIDTH   =    32,
U_ADDR0318_r0.ININTVALUE  = 32'h0,
U_ADDR0318_r0.REGADDRESS  = ADDR0318;


assign SirDack0318       = SirDack0318r0;
assign SirRdat0318[31:0] = SirRdat0318r0;


//************************************************************************************
//      addr: 0x8002031c 32bit r0 {u0_awmf0165_reg[127:96]} 
//************************************************************************************

parameter       ADDR031c   = 16'h031c  ;
wire            SirDack031c     ;
wire    [31:0]  SirRdat031c     ;

wire            SirDack031cr0  ;
wire    [31:0]  SirRdat031cr0   ;
wire    [31:0]  Q031cr0         ;

reg_ro   U_ADDR031c_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack031cr0      ),
                .SirRdat    (SirRdat031cr0      ),
                .Load       (1'b1               ),  
                .D          (u0_awmf0165_reg[127:96])
                );
defparam
U_ADDR031c_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR031c_r0.DATAWIDTH   =    32,
U_ADDR031c_r0.ININTVALUE  = 32'h0,
U_ADDR031c_r0.REGADDRESS  = ADDR031c;


assign SirDack031c       = SirDack031cr0;
assign SirRdat031c[31:0] = SirRdat031cr0;

//************************************************************************************
//      addr: 0x80020320 32bit r0 {u0_awmf0165_reg[159:128]} 
//************************************************************************************

parameter       ADDR0320   = 16'h0320  ;
wire            SirDack0320     ;
wire    [31:0]  SirRdat0320     ;

wire            SirDack0320r0  ;
wire    [31:0]  SirRdat0320r0   ;
wire    [31:0]  Q0320r0         ;

reg_ro   U_ADDR0320_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0320r0      ),
                .SirRdat    (SirRdat0320r0      ),
                .Load       (1'b1               ),  
                .D          (u0_awmf0165_reg[159:128])
                );
defparam
U_ADDR0320_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0320_r0.DATAWIDTH   =    32,
U_ADDR0320_r0.ININTVALUE  = 32'h0,
U_ADDR0320_r0.REGADDRESS  = ADDR0320;


assign SirDack0320       = SirDack0320r0;
assign SirRdat0320[31:0] = SirRdat0320r0;


//************************************************************************************
//      addr: 0x80020324 32bit r0 {u0_awmf0165_reg[191:160]} 
//************************************************************************************

parameter       ADDR0324   = 16'h0324  ;
wire            SirDack0324     ;
wire    [31:0]  SirRdat0324     ;

wire            SirDack0324r0  ;
wire    [31:0]  SirRdat0324r0   ;
wire    [31:0]  Q0324r0         ;

reg_ro   U_ADDR0324_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0324r0      ),
                .SirRdat    (SirRdat0324r0      ),
                .Load       (1'b1               ),  
                .D          (u0_awmf0165_reg[191:160])
                );
defparam
U_ADDR0324_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0324_r0.DATAWIDTH   =    32,
U_ADDR0324_r0.ININTVALUE  = 32'h0,
U_ADDR0324_r0.REGADDRESS  = ADDR0324;


assign SirDack0324       = SirDack0324r0;
assign SirRdat0324[31:0] = SirRdat0324r0;

//************************************************************************************
//      addr: 0x80020328 32bit r0 {u0_awmf0165_reg[223:192]} 
//************************************************************************************

parameter       ADDR0328   = 16'h0328  ;
wire            SirDack0328     ;
wire    [31:0]  SirRdat0328     ;

wire            SirDack0328r0   ;
wire    [31:0]  SirRdat0328r0   ;
wire    [31:0]  Q0328r0         ;

reg_ro   U_ADDR0328_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0328r0      ),
                .SirRdat    (SirRdat0328r0      ),
                .Load       (1'b1               ),  
                .D          (u0_awmf0165_reg[223:192])
                );
defparam
U_ADDR0328_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0328_r0.DATAWIDTH   =    32,
U_ADDR0328_r0.ININTVALUE  = 32'h0,
U_ADDR0328_r0.REGADDRESS  = ADDR0328;


assign SirDack0328       = SirDack0328r0;
assign SirRdat0328[31:0] = SirRdat0328r0;

//************************************************************************************
//      addr: 0x8002032c 32bit r0 {u0_awmf0165_reg[255:224]} 
//************************************************************************************

parameter       ADDR032c   = 16'h032c  ;
wire            SirDack032c     ;
wire    [31:0]  SirRdat032c     ;

wire            SirDack032cr0  ;
wire    [31:0]  SirRdat032cr0   ;
wire    [31:0]  Q032cr0         ;

reg_ro   U_ADDR032c_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack032cr0      ),
                .SirRdat    (SirRdat032cr0      ),
                .Load       (1'b1               ),  
                .D          (u0_awmf0165_reg[255:224])
                );
defparam
U_ADDR032c_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR032c_r0.DATAWIDTH   =    32,
U_ADDR032c_r0.ININTVALUE  = 32'h0,
U_ADDR032c_r0.REGADDRESS  = ADDR032c;


assign SirDack032c       = SirDack032cr0;
assign SirRdat032c[31:0] = SirRdat032cr0;

//tx_group1
//************************************************************************************
//      addr: 0x80020330 32bit r0 {u1_awmf0165_reg[31:0]} 
//************************************************************************************

parameter       ADDR0330   = 16'h0330  ;
wire            SirDack0330     ;
wire    [31:0]  SirRdat0330     ;

wire            SirDack0330r0   ;
wire    [31:0]  SirRdat0330r0   ;
wire    [31:0]  Q0330r0         ;

reg_ro   U_ADDR0330_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0330r0      ),
                .SirRdat    (SirRdat0330r0      ),
                .Load       (1'b1               ),  
                .D          (u1_awmf0165_reg[31:0])
                );
defparam
U_ADDR0330_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0330_r0.DATAWIDTH   =    32,
U_ADDR0330_r0.ININTVALUE  = 32'h0,
U_ADDR0330_r0.REGADDRESS  = ADDR0330;


assign SirDack0330       = SirDack0330r0;
assign SirRdat0330[31:0] = SirRdat0330r0;

//************************************************************************************
//      addr: 0x80020334 32bit r0 {u1_awmf0165_reg[63:32]} 
//************************************************************************************

parameter       ADDR0334   = 16'h0334  ;
wire            SirDack0334     ;
wire    [31:0]  SirRdat0334     ;

wire            SirDack0334r0  ;
wire    [31:0]  SirRdat0334r0   ;
wire    [31:0]  Q0334r0         ;

reg_ro   U_ADDR0334_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0334r0      ),
                .SirRdat    (SirRdat0334r0      ),
                .Load       (1'b1               ),  
                .D          (u1_awmf0165_reg[63:32])
                );
defparam
U_ADDR0334_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0334_r0.DATAWIDTH   =    32,
U_ADDR0334_r0.ININTVALUE  = 32'h0,
U_ADDR0334_r0.REGADDRESS  = ADDR0334;


assign SirDack0334       = SirDack0334r0;
assign SirRdat0334[31:0] = SirRdat0334r0;


//************************************************************************************
//      addr: 0x80020338 32bit r0 {u1_awmf0165_reg[95:64]} 
//************************************************************************************

parameter       ADDR0338   = 16'h0338  ;
wire            SirDack0338     ;
wire    [31:0]  SirRdat0338     ;

wire            SirDack0338r0  ;
wire    [31:0]  SirRdat0338r0   ;
wire    [31:0]  Q0338r0         ;

reg_ro   U_ADDR0338_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0338r0      ),
                .SirRdat    (SirRdat0338r0      ),
                .Load       (1'b1               ),  
                .D          (u1_awmf0165_reg[95:64])
                );
defparam
U_ADDR0338_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0338_r0.DATAWIDTH   =    32,
U_ADDR0338_r0.ININTVALUE  = 32'h0,
U_ADDR0338_r0.REGADDRESS  = ADDR0338;


assign SirDack0338       = SirDack0338r0;
assign SirRdat0338[31:0] = SirRdat0338r0;


//************************************************************************************
//      addr: 0x8002033c 32bit r0 {u1_awmf0165_reg[127:96]} 
//************************************************************************************

parameter       ADDR033c   = 16'h033c  ;
wire            SirDack033c     ;
wire    [31:0]  SirRdat033c     ;

wire            SirDack033cr0  ;
wire    [31:0]  SirRdat033cr0   ;
wire    [31:0]  Q033cr0         ;

reg_ro   U_ADDR033c_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack033cr0      ),
                .SirRdat    (SirRdat033cr0      ),
                .Load       (1'b1               ),  
                .D          (u1_awmf0165_reg[127:96])
                );
defparam
U_ADDR033c_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR033c_r0.DATAWIDTH   =    32,
U_ADDR033c_r0.ININTVALUE  = 32'h0,
U_ADDR033c_r0.REGADDRESS  = ADDR033c;


assign SirDack033c       = SirDack033cr0;
assign SirRdat033c[31:0] = SirRdat033cr0;

//************************************************************************************
//      addr: 0x80020340 32bit r0 {u1_awmf0165_reg[159:128]} 
//************************************************************************************

parameter       ADDR0340   = 16'h0340  ;
wire            SirDack0340     ;
wire    [31:0]  SirRdat0340     ;

wire            SirDack0340r0  ;
wire    [31:0]  SirRdat0340r0   ;
wire    [31:0]  Q0340r0         ;

reg_ro   U_ADDR0340_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0340r0      ),
                .SirRdat    (SirRdat0340r0      ),
                .Load       (1'b1               ),  
                .D          (u1_awmf0165_reg[159:128])
                );
defparam
U_ADDR0340_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0340_r0.DATAWIDTH   =    32,
U_ADDR0340_r0.ININTVALUE  = 32'h0,
U_ADDR0340_r0.REGADDRESS  = ADDR0340;


assign SirDack0340       = SirDack0340r0;
assign SirRdat0340[31:0] = SirRdat0340r0;


//************************************************************************************
//      addr: 0x80020344 32bit r0 {u1_awmf0165_reg[191:160]} 
//************************************************************************************

parameter       ADDR0344   = 16'h0344  ;
wire            SirDack0344     ;
wire    [31:0]  SirRdat0344     ;

wire            SirDack0344r0  ;
wire    [31:0]  SirRdat0344r0   ;
wire    [31:0]  Q0344r0         ;

reg_ro   U_ADDR0344_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0344r0      ),
                .SirRdat    (SirRdat0344r0      ),
                .Load       (1'b1               ),  
                .D          (u1_awmf0165_reg[191:160])
                );
defparam
U_ADDR0344_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0344_r0.DATAWIDTH   =    32,
U_ADDR0344_r0.ININTVALUE  = 32'h0,
U_ADDR0344_r0.REGADDRESS  = ADDR0344;


assign SirDack0344       = SirDack0344r0;
assign SirRdat0344[31:0] = SirRdat0344r0;

//************************************************************************************
//      addr: 0x80020348 32bit r0 {u1_awmf0165_reg[223:192]} 
//************************************************************************************

parameter       ADDR0348   = 16'h0348  ;
wire            SirDack0348     ;
wire    [31:0]  SirRdat0348     ;

wire            SirDack0348r0   ;
wire    [31:0]  SirRdat0348r0   ;
wire    [31:0]  Q0348r0         ;

reg_ro   U_ADDR0348_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0348r0      ),
                .SirRdat    (SirRdat0348r0      ),
                .Load       (1'b1               ),  
                .D          (u1_awmf0165_reg[223:192])
                );
defparam
U_ADDR0348_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0348_r0.DATAWIDTH   =    32,
U_ADDR0348_r0.ININTVALUE  = 32'h0,
U_ADDR0348_r0.REGADDRESS  = ADDR0348;


assign SirDack0348       = SirDack0348r0;
assign SirRdat0348[31:0] = SirRdat0348r0;

//************************************************************************************
//      addr: 0x8002034c 32bit r0 {u1_awmf0165_reg[255:224]} 
//************************************************************************************

parameter       ADDR034c   = 16'h034c  ;
wire            SirDack034c     ;
wire    [31:0]  SirRdat034c     ;

wire            SirDack034cr0  ;
wire    [31:0]  SirRdat034cr0   ;
wire    [31:0]  Q034cr0         ;

reg_ro   U_ADDR034c_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack034cr0      ),
                .SirRdat    (SirRdat034cr0      ),
                .Load       (1'b1               ),  
                .D          (u1_awmf0165_reg[255:224])
                );
defparam
U_ADDR034c_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR034c_r0.DATAWIDTH   =    32,
U_ADDR034c_r0.ININTVALUE  = 32'h0,
U_ADDR034c_r0.REGADDRESS  = ADDR034c;


assign SirDack034c       = SirDack034cr0;
assign SirRdat034c[31:0] = SirRdat034cr0;



//rx_group0
//************************************************************************************
//      addr: 0x80020350 32bit r0 {u2_awmf0165_reg[31:0]} 
//************************************************************************************

parameter       ADDR0350   = 16'h0350  ;
wire            SirDack0350     ;
wire    [31:0]  SirRdat0350     ;

wire            SirDack0350r0   ;
wire    [31:0]  SirRdat0350r0   ;
wire    [31:0]  Q0350r0         ;

reg_ro   U_ADDR0350_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0350r0      ),
                .SirRdat    (SirRdat0350r0      ),
                .Load       (1'b1               ),  
                .D          (u2_awmf0165_reg[31:0])
                );
defparam
U_ADDR0350_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0350_r0.DATAWIDTH   =    32,
U_ADDR0350_r0.ININTVALUE  = 32'h0,
U_ADDR0350_r0.REGADDRESS  = ADDR0350;


assign SirDack0350       = SirDack0350r0;
assign SirRdat0350[31:0] = SirRdat0350r0;

//************************************************************************************
//      addr: 0x80020354 32bit r0 {u2_awmf0165_reg[63:32]} 
//************************************************************************************

parameter       ADDR0354   = 16'h0354  ;
wire            SirDack0354     ;
wire    [31:0]  SirRdat0354     ;

wire            SirDack0354r0  ;
wire    [31:0]  SirRdat0354r0   ;
wire    [31:0]  Q0354r0         ;

reg_ro   U_ADDR0354_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0354r0      ),
                .SirRdat    (SirRdat0354r0      ),
                .Load       (1'b1               ),  
                .D          (u2_awmf0165_reg[63:32])
                );
defparam
U_ADDR0354_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0354_r0.DATAWIDTH   =    32,
U_ADDR0354_r0.ININTVALUE  = 32'h0,
U_ADDR0354_r0.REGADDRESS  = ADDR0354;


assign SirDack0354       = SirDack0354r0;
assign SirRdat0354[31:0] = SirRdat0354r0;


//************************************************************************************
//      addr: 0x80020358 32bit r0 {u2_awmf0165_reg[95:64]} 
//************************************************************************************

parameter       ADDR0358   = 16'h0358  ;
wire            SirDack0358     ;
wire    [31:0]  SirRdat0358     ;

wire            SirDack0358r0  ;
wire    [31:0]  SirRdat0358r0   ;
wire    [31:0]  Q0358r0         ;

reg_ro   U_ADDR0358_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0358r0      ),
                .SirRdat    (SirRdat0358r0      ),
                .Load       (1'b1               ),  
                .D          (u2_awmf0165_reg[95:64])
                );
defparam
U_ADDR0358_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0358_r0.DATAWIDTH   =    32,
U_ADDR0358_r0.ININTVALUE  = 32'h0,
U_ADDR0358_r0.REGADDRESS  = ADDR0358;


assign SirDack0358       = SirDack0358r0;
assign SirRdat0358[31:0] = SirRdat0358r0;


//************************************************************************************
//      addr: 0x8002035c 32bit r0 {u2_awmf0165_reg[127:96]} 
//************************************************************************************

parameter       ADDR035c   = 16'h035c  ;
wire            SirDack035c     ;
wire    [31:0]  SirRdat035c     ;

wire            SirDack035cr0  ;
wire    [31:0]  SirRdat035cr0   ;
wire    [31:0]  Q035cr0         ;

reg_ro   U_ADDR035c_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack035cr0      ),
                .SirRdat    (SirRdat035cr0      ),
                .Load       (1'b1               ),  
                .D          (u2_awmf0165_reg[127:96])
                );
defparam
U_ADDR035c_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR035c_r0.DATAWIDTH   =    32,
U_ADDR035c_r0.ININTVALUE  = 32'h0,
U_ADDR035c_r0.REGADDRESS  = ADDR035c;


assign SirDack035c       = SirDack035cr0;
assign SirRdat035c[31:0] = SirRdat035cr0;

//************************************************************************************
//      addr: 0x80020360 32bit r0 {u2_awmf0165_reg[159:128]} 
//************************************************************************************

parameter       ADDR0360   = 16'h0360  ;
wire            SirDack0360     ;
wire    [31:0]  SirRdat0360     ;

wire            SirDack0360r0  ;
wire    [31:0]  SirRdat0360r0   ;
wire    [31:0]  Q0360r0         ;

reg_ro   U_ADDR0360_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0360r0      ),
                .SirRdat    (SirRdat0360r0      ),
                .Load       (1'b1               ),  
                .D          (u2_awmf0165_reg[159:128])
                );
defparam
U_ADDR0360_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0360_r0.DATAWIDTH   =    32,
U_ADDR0360_r0.ININTVALUE  = 32'h0,
U_ADDR0360_r0.REGADDRESS  = ADDR0360;


assign SirDack0360       = SirDack0360r0;
assign SirRdat0360[31:0] = SirRdat0360r0;


//************************************************************************************
//      addr: 0x80020364 32bit r0 {u2_awmf0165_reg[191:160]} 
//************************************************************************************

parameter       ADDR0364   = 16'h0364  ;
wire            SirDack0364     ;
wire    [31:0]  SirRdat0364     ;

wire            SirDack0364r0  ;
wire    [31:0]  SirRdat0364r0   ;
wire    [31:0]  Q0364r0         ;

reg_ro   U_ADDR0364_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0364r0      ),
                .SirRdat    (SirRdat0364r0      ),
                .Load       (1'b1               ),  
                .D          (u2_awmf0165_reg[191:160])
                );
defparam
U_ADDR0364_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0364_r0.DATAWIDTH   =    32,
U_ADDR0364_r0.ININTVALUE  = 32'h0,
U_ADDR0364_r0.REGADDRESS  = ADDR0364;


assign SirDack0364       = SirDack0364r0;
assign SirRdat0364[31:0] = SirRdat0364r0;

//************************************************************************************
//      addr: 0x80020368 32bit r0 {u2_awmf0165_reg[223:192]} 
//************************************************************************************

parameter       ADDR0368   = 16'h0368  ;
wire            SirDack0368     ;
wire    [31:0]  SirRdat0368     ;

wire            SirDack0368r0   ;
wire    [31:0]  SirRdat0368r0   ;
wire    [31:0]  Q0368r0         ;

reg_ro   U_ADDR0368_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0368r0      ),
                .SirRdat    (SirRdat0368r0      ),
                .Load       (1'b1               ),  
                .D          (u2_awmf0165_reg[223:192])
                );
defparam
U_ADDR0368_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0368_r0.DATAWIDTH   =    32,
U_ADDR0368_r0.ININTVALUE  = 32'h0,
U_ADDR0368_r0.REGADDRESS  = ADDR0368;


assign SirDack0368       = SirDack0368r0;
assign SirRdat0368[31:0] = SirRdat0368r0;

//************************************************************************************
//      addr: 0x8002036c 32bit r0 {u2_awmf0165_reg[255:224]} 
//************************************************************************************

parameter       ADDR036c   = 16'h036c  ;
wire            SirDack036c     ;
wire    [31:0]  SirRdat036c     ;

wire            SirDack036cr0  ;
wire    [31:0]  SirRdat036cr0   ;
wire    [31:0]  Q036cr0         ;

reg_ro   U_ADDR036c_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack036cr0      ),
                .SirRdat    (SirRdat036cr0      ),
                .Load       (1'b1               ),  
                .D          (u2_awmf0165_reg[255:224])
                );
defparam
U_ADDR036c_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR036c_r0.DATAWIDTH   =    32,
U_ADDR036c_r0.ININTVALUE  = 32'h0,
U_ADDR036c_r0.REGADDRESS  = ADDR036c;


assign SirDack036c       = SirDack036cr0;
assign SirRdat036c[31:0] = SirRdat036cr0;


//rx_group1
//************************************************************************************
//      addr: 0x80020370 32bit r0 {u3_awmf0165_reg[31:0]} 
//************************************************************************************

parameter       ADDR0370   = 16'h0370  ;
wire            SirDack0370     ;
wire    [31:0]  SirRdat0370     ;

wire            SirDack0370r0   ;
wire    [31:0]  SirRdat0370r0   ;
wire    [31:0]  Q0370r0         ;

reg_ro   U_ADDR0370_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0370r0      ),
                .SirRdat    (SirRdat0370r0      ),
                .Load       (1'b1               ),  
                .D          (u3_awmf0165_reg[31:0])
                );
defparam
U_ADDR0370_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0370_r0.DATAWIDTH   =    32,
U_ADDR0370_r0.ININTVALUE  = 32'h0,
U_ADDR0370_r0.REGADDRESS  = ADDR0370;


assign SirDack0370       = SirDack0370r0;
assign SirRdat0370[31:0] = SirRdat0370r0;

//************************************************************************************
//      addr: 0x80020374 32bit r0 {u3_awmf0165_reg[63:32]} 
//************************************************************************************

parameter       ADDR0374   = 16'h0374  ;
wire            SirDack0374     ;
wire    [31:0]  SirRdat0374     ;

wire            SirDack0374r0  ;
wire    [31:0]  SirRdat0374r0   ;
wire    [31:0]  Q0374r0         ;

reg_ro   U_ADDR0374_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0374r0      ),
                .SirRdat    (SirRdat0374r0      ),
                .Load       (1'b1               ),  
                .D          (u3_awmf0165_reg[63:32])
                );
defparam
U_ADDR0374_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0374_r0.DATAWIDTH   =    32,
U_ADDR0374_r0.ININTVALUE  = 32'h0,
U_ADDR0374_r0.REGADDRESS  = ADDR0374;


assign SirDack0374       = SirDack0374r0;
assign SirRdat0374[31:0] = SirRdat0374r0;


//************************************************************************************
//      addr: 0x80020378 32bit r0 {u3_awmf0165_reg[95:64]} 
//************************************************************************************

parameter       ADDR0378   = 16'h0378  ;
wire            SirDack0378     ;
wire    [31:0]  SirRdat0378     ;

wire            SirDack0378r0  ;
wire    [31:0]  SirRdat0378r0   ;
wire    [31:0]  Q0378r0         ;

reg_ro   U_ADDR0378_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0378r0      ),
                .SirRdat    (SirRdat0378r0      ),
                .Load       (1'b1               ),  
                .D          (u3_awmf0165_reg[95:64])
                );
defparam
U_ADDR0378_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0378_r0.DATAWIDTH   =    32,
U_ADDR0378_r0.ININTVALUE  = 32'h0,
U_ADDR0378_r0.REGADDRESS  = ADDR0378;


assign SirDack0378       = SirDack0378r0;
assign SirRdat0378[31:0] = SirRdat0378r0;


//************************************************************************************
//      addr: 0x8002037c 32bit r0 {u3_awmf0165_reg[127:96]} 
//************************************************************************************

parameter       ADDR037c   = 16'h037c  ;
wire            SirDack037c     ;
wire    [31:0]  SirRdat037c     ;

wire            SirDack037cr0  ;
wire    [31:0]  SirRdat037cr0   ;
wire    [31:0]  Q037cr0         ;

reg_ro   U_ADDR037c_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack037cr0      ),
                .SirRdat    (SirRdat037cr0      ),
                .Load       (1'b1               ),  
                .D          (u3_awmf0165_reg[127:96])
                );
defparam
U_ADDR037c_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR037c_r0.DATAWIDTH   =    32,
U_ADDR037c_r0.ININTVALUE  = 32'h0,
U_ADDR037c_r0.REGADDRESS  = ADDR037c;


assign SirDack037c       = SirDack037cr0;
assign SirRdat037c[31:0] = SirRdat037cr0;

//************************************************************************************
//      addr: 0x80020380 32bit r0 {u3_awmf0165_reg[159:128]} 
//************************************************************************************

parameter       ADDR0380   = 16'h0380  ;
wire            SirDack0380     ;
wire    [31:0]  SirRdat0380     ;

wire            SirDack0380r0  ;
wire    [31:0]  SirRdat0380r0   ;
wire    [31:0]  Q0380r0         ;

reg_ro   U_ADDR0380_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0380r0      ),
                .SirRdat    (SirRdat0380r0      ),
                .Load       (1'b1               ),  
                .D          (u3_awmf0165_reg[159:128])
                );
defparam
U_ADDR0380_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0380_r0.DATAWIDTH   =    32,
U_ADDR0380_r0.ININTVALUE  = 32'h0,
U_ADDR0380_r0.REGADDRESS  = ADDR0380;


assign SirDack0380       = SirDack0380r0;
assign SirRdat0380[31:0] = SirRdat0380r0;


//************************************************************************************
//      addr: 0x80020384 32bit r0 {u3_awmf0165_reg[191:160]} 
//************************************************************************************

parameter       ADDR0384   = 16'h0384  ;
wire            SirDack0384     ;
wire    [31:0]  SirRdat0384     ;

wire            SirDack0384r0  ;
wire    [31:0]  SirRdat0384r0   ;
wire    [31:0]  Q0384r0         ;

reg_ro   U_ADDR0384_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0384r0      ),
                .SirRdat    (SirRdat0384r0      ),
                .Load       (1'b1               ),  
                .D          (u3_awmf0165_reg[191:160])
                );
defparam
U_ADDR0384_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0384_r0.DATAWIDTH   =    32,
U_ADDR0384_r0.ININTVALUE  = 32'h0,
U_ADDR0384_r0.REGADDRESS  = ADDR0384;


assign SirDack0384       = SirDack0384r0;
assign SirRdat0384[31:0] = SirRdat0384r0;

//************************************************************************************
//      addr: 0x80020388 32bit r0 {u3_awmf0165_reg[223:192]} 
//************************************************************************************

parameter       ADDR0388   = 16'h0388  ;
wire            SirDack0388     ;
wire    [31:0]  SirRdat0388     ;

wire            SirDack0388r0   ;
wire    [31:0]  SirRdat0388r0   ;
wire    [31:0]  Q0388r0         ;

reg_ro   U_ADDR0388_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0388r0      ),
                .SirRdat    (SirRdat0388r0      ),
                .Load       (1'b1               ),  
                .D          (u3_awmf0165_reg[223:192])
                );
defparam
U_ADDR0388_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0388_r0.DATAWIDTH   =    32,
U_ADDR0388_r0.ININTVALUE  = 32'h0,
U_ADDR0388_r0.REGADDRESS  = ADDR0388;


assign SirDack0388       = SirDack0388r0;
assign SirRdat0388[31:0] = SirRdat0388r0;

//************************************************************************************
//      addr: 0x8002038c 32bit r0 {u3_awmf0165_reg[255:224]} 
//************************************************************************************

parameter       ADDR038c   = 16'h038c  ;
wire            SirDack038c     ;
wire    [31:0]  SirRdat038c     ;

wire            SirDack038cr0  ;
wire    [31:0]  SirRdat038cr0   ;
wire    [31:0]  Q038cr0         ;

reg_ro   U_ADDR038c_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack038cr0      ),
                .SirRdat    (SirRdat038cr0      ),
                .Load       (1'b1               ),  
                .D          (u3_awmf0165_reg[255:224])
                );
defparam
U_ADDR038c_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR038c_r0.DATAWIDTH   =    32,
U_ADDR038c_r0.ININTVALUE  = 32'h0,
U_ADDR038c_r0.REGADDRESS  = ADDR038c;


assign SirDack038c       = SirDack038cr0;
assign SirRdat038c[31:0] = SirRdat038cr0;  


//------------------------------------------------------------------------------------


//************************************************************************************
//      addr: 0x80020390 32bit RW awmf0165_ctr 
//************************************************************************************

parameter       ADDR0390   = 16'h0390  ;
wire            SirDack0390     ;
wire    [31:0]  SirRdat0390     ;

wire            SirDack0390r0  ;
wire    [31:0]  SirRdat0390r0   ;
wire    [31:0]  Q0390r0         ;

reg_rw  U_ADDR0390_r0(
        .clk        (clk                ),
        .rst        (rst                ),

        .SirSel     (SirSel            	),
        .SirRead    (SirRead            ),
        .SirAddr    (SirAddr            ),
        .SirWdat    (SirWdat      		),
        .SirDack    (SirDack0390r0      ),
        .SirRdat    (SirRdat0390r0      ),
        .Q          (Q0390r0           )
                );
defparam
U_ADDR0390_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0390_r0.DATAWIDTH   =    32,
U_ADDR0390_r0.ININTVALUE  = 32'h0,
U_ADDR0390_r0.REGADDRESS  = ADDR0390;

assign awmf0165_ctr = Q0390r0 ;

assign SirDack0390       = SirDack0390r0;
assign SirRdat0390[31:0] = SirRdat0390r0;

//************************************************************************************
//      addr: 0x80020394 32bit RW awmf0165_ctr 
//************************************************************************************

parameter       ADDR0394   = 16'h0394  ;
wire            SirDack0394     ;
wire    [31:0]  SirRdat0394     ;

wire            SirDack0394r0  ;
wire    [31:0]  SirRdat0394r0   ;
wire    [31:0]  Q0394r0         ;

reg_rw  U_ADDR0394_r0(
        .clk        (clk                ),
        .rst        (rst                ),

        .SirSel     (SirSel            	),
        .SirRead    (SirRead            ),
        .SirAddr    (SirAddr            ),
        .SirWdat    (SirWdat      		),
        .SirDack    (SirDack0394r0      ),
        .SirRdat    (SirRdat0394r0      ),
        .Q          (Q0394r0           )
                );
defparam
U_ADDR0394_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0394_r0.DATAWIDTH   =    32,
U_ADDR0394_r0.ININTVALUE  = 32'h0,
U_ADDR0394_r0.REGADDRESS  = ADDR0394;

assign awmf0165_select = Q0394r0 ;

assign SirDack0394       = SirDack0394r0;
assign SirRdat0394[31:0] = SirRdat0394r0;


//************************************************************************************
//      addr: 0x80020398 32bit RW awmf0165_pspl_select 
//************************************************************************************

parameter       ADDR0398   = 16'h0398  ;
wire            SirDack0398     ;
wire    [31:0]  SirRdat0398     ;

wire            SirDack0398r0  ;
wire    [31:0]  SirRdat0398r0   ;
wire    [31:0]  Q0398r0         ;

reg_rw  U_ADDR0398_r0(
        .clk        (clk                ),
        .rst        (rst                ),

        .SirSel     (SirSel            	),
        .SirRead    (SirRead            ),
        .SirAddr    (SirAddr            ),
        .SirWdat    (SirWdat      		),
        .SirDack    (SirDack0398r0      ),
        .SirRdat    (SirRdat0398r0      ),
        .Q          (Q0398r0           )
                );
defparam
U_ADDR0398_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0398_r0.DATAWIDTH   =    32,
U_ADDR0398_r0.ININTVALUE  = 32'h0,
U_ADDR0398_r0.REGADDRESS  = ADDR0398;

assign awmf0165_pspl_select = Q0398r0[0:0] ;

assign SirDack0398       = SirDack0398r0;
assign SirRdat0398[31:0] = SirRdat0398r0;


//************************************************************************************
//      addr: 0x8002039c 32bit RW awmf0165_pspl_select 
//************************************************************************************

parameter       ADDR039c   = 16'h039c  ;
wire            SirDack039c     ;
wire    [31:0]  SirRdat039c     ;

wire            SirDack039cr0  ;
wire    [31:0]  SirRdat039cr0   ;
wire    [31:0]  Q039cr0         ;

reg_ro  U_ADDR039c_r0(

        .clk        (clk                ),
        .rst        (rst                ),
                                    
        .SirSel     (SirSel            	),
        .SirRead    (SirRead            ),
        .SirAddr    (SirAddr            ),
        // .SirWdat    (SirWdat      		),
        .SirDack    (SirDack039cr0      ),
        .SirRdat    (SirRdat039cr0      ),
        .Load       (1'b1               ),  
        .D          ({22'd0,awmf_0165_status})

        );
defparam
U_ADDR039c_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR039c_r0.DATAWIDTH   =    32,
U_ADDR039c_r0.ININTVALUE  = 32'h0,
U_ADDR039c_r0.REGADDRESS  = ADDR039c;


assign SirDack039c       = SirDack039cr0;
assign SirRdat039c[31:0] = SirRdat039cr0;

//************************************************************************************
//      addr: 0x800203a0 32bit RW {PRI_PERIOD,CPI_DELAY}
//************************************************************************************

parameter       ADDR03a0   = 16'h03a0  ;
wire            SirDack03a0     ;
wire    [31:0]  SirRdat03a0     ;

wire            SirDack03a0r0  ;
wire    [31:0]  SirRdat03a0r0   ;
wire    [31:0]  Q03a0r0         ;

reg_rw  U_ADDR03a0_r0(
        .clk        (clk                ),
        .rst        (rst                ),

        .SirSel     (SirSel            	),
        .SirRead    (SirRead            ),
        .SirAddr    (SirAddr            ),
        .SirWdat    (SirWdat      		),
        .SirDack    (SirDack03a0r0      ),
        .SirRdat    (SirRdat03a0r0      ),
        .Q          (Q03a0r0           )
                );
defparam
U_ADDR03a0_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR03a0_r0.DATAWIDTH   =    32,
U_ADDR03a0_r0.ININTVALUE  = {16'd5300,16'd2000},
U_ADDR03a0_r0.REGADDRESS  = ADDR03a0;

assign CPI_DELAY[15:0]= Q03a0r0[15:0]  ;
assign PRI_PERIOD = Q03a0r0[31:16] ;

assign SirDack03a0       = SirDack03a0r0;
assign SirRdat03a0[31:0] = SirRdat03a0r0;

//************************************************************************************
//      addr: 0x800203a4 32bit RW {PRI_NUM,PRI_PULSE_WIDTH}
//************************************************************************************

parameter       ADDR03a4   = 16'h03a4  ;
wire            SirDack03a4     ;
wire    [31:0]  SirRdat03a4     ;

wire            SirDack03a4r0  ;
wire    [31:0]  SirRdat03a4r0   ;
wire    [31:0]  Q03a4r0         ;

reg_rw  U_ADDR03a4_r0(
        .clk        (clk                ),
        .rst        (rst                ),

        .SirSel     (SirSel            	),
        .SirRead    (SirRead            ),
        .SirAddr    (SirAddr            ),
        .SirWdat    (SirWdat      		),
        .SirDack    (SirDack03a4r0      ),
        .SirRdat    (SirRdat03a4r0      ),
        .Q          (Q03a4r0           )
                );
defparam
U_ADDR03a4_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR03a4_r0.DATAWIDTH   =    32,
U_ADDR03a4_r0.ININTVALUE  = {16'd0,8'd40,8'd32},
U_ADDR03a4_r0.REGADDRESS  = ADDR03a4;

assign PRI_NUM          = Q03a4r0[7:0]  ;
assign PRI_PULSE_WIDTH  = Q03a4r0[15:8] ;
assign CPI_DELAY[31:16] = Q03a4r0[31:15];

assign SirDack03a4       = SirDack03a4r0;
assign SirRdat03a4[31:0] = SirRdat03a4r0;

//************************************************************************************
//      addr: 0x800203a8 32bit RW {START_SAMPLE,SAMPLE_LENGTH}
//************************************************************************************

parameter       ADDR03a8   = 16'h03a8  ;
wire            SirDack03a8     ;
wire    [31:0]  SirRdat03a8     ;

wire            SirDack03a8r0  ;
wire    [31:0]  SirRdat03a8r0   ;
wire    [31:0]  Q03a8r0         ;

reg_rw  U_ADDR03a8_r0(
        .clk        (clk                ),
        .rst        (rst                ),

        .SirSel     (SirSel            	),
        .SirRead    (SirRead            ),
        .SirAddr    (SirAddr            ),
        .SirWdat    (SirWdat      		),
        .SirDack    (SirDack03a8r0      ),
        .SirRdat    (SirRdat03a8r0      ),
        .Q          (Q03a8r0           )
                );
defparam
U_ADDR03a8_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR03a8_r0.DATAWIDTH   =    32,
U_ADDR03a8_r0.ININTVALUE  = {16'd4097,16'd1000},
U_ADDR03a8_r0.REGADDRESS  = ADDR03a8;

assign START_SAMPLE       = Q03a8r0[15:0]  ;
assign SAMPLE_LENGTH      = Q03a8r0[31:16] ;

assign SirDack03a8       = SirDack03a8r0;
assign SirRdat03a8[31:0] = SirRdat03a8r0;


//************************************************************************************
//      addr: 0x800203ac 32bit RW {START_SAMPLE,SAMPLE_LENGTH}
//************************************************************************************

parameter       ADDR03ac   = 16'h03ac  ;
wire            SirDack03ac     ;
wire    [31:0]  SirRdat03ac     ;

wire            SirDack03acr0  ;
wire    [31:0]  SirRdat03acr0   ;
wire    [31:0]  Q03acr0         ;

reg_rw  U_ADDR03ac_r0(
        .clk        (clk                ),
        .rst        (rst                ),

        .SirSel     (SirSel            	),
        .SirRead    (SirRead            ),
        .SirAddr    (SirAddr            ),
        .SirWdat    (SirWdat      		),
        .SirDack    (SirDack03acr0      ),
        .SirRdat    (SirRdat03acr0      ),
        .Q          (Q03acr0           )
                );
defparam
U_ADDR03ac_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR03ac_r0.DATAWIDTH   =    32,
U_ADDR03ac_r0.ININTVALUE  = {24'd0,8'd0},
U_ADDR03ac_r0.REGADDRESS  = ADDR03ac;

assign WAVE_CODE = Q03acr0 [7:0] ;

assign SirDack03ac       = SirDack03acr0;
assign SirRdat03ac[31:0] = SirRdat03acr0;

//************************************************************************************
//      addr: 0x800203b0 32bit RW {first_chrip_disable}
//************************************************************************************

parameter       ADDR03b0   = 16'h03b0  ;
wire            SirDack03b0     ;
wire    [31:0]  SirRdat03b0     ;

wire            SirDack03b0r0  ;
wire    [31:0]  SirRdat03b0r0   ;
wire    [31:0]  Q03b0r0         ;

reg_rw  U_ADDR03b0_r0(
        .clk        (clk                ),
        .rst        (rst                ),

        .SirSel     (SirSel            	),
        .SirRead    (SirRead            ),
        .SirAddr    (SirAddr            ),
        .SirWdat    (SirWdat      		),
        .SirDack    (SirDack03b0r0      ),
        .SirRdat    (SirRdat03b0r0      ),
        .Q          (Q03b0r0           )
                );
defparam
U_ADDR03b0_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR03b0_r0.DATAWIDTH   =    32,
U_ADDR03b0_r0.ININTVALUE  = 'd0 ,
U_ADDR03b0_r0.REGADDRESS  = ADDR03b0;

assign first_chrip_disable = Q03b0r0 [0:0] ;

assign SirDack03b0       = SirDack03b0r0;
assign SirRdat03b0[31:0] = SirRdat03b0r0;


//************************************************************************************
//      addr :0x80020400 RW 32bit AWMF0165 CHAIN4 WRITE DATA 
//************************************************************************************
parameter       ADDR0400  = 16'h0400       ;

wire            SirDack0400     ;
wire    [31:0]  SirRdat0400     ;

wire            SirDack0400r0   ;
wire    [31:0]  SirRdat0400r0   ;
wire    [31:0]  Q0400r0         ;

reg_rw   U_ADDR0400_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat      		),
                .SirDack    (SirDack0400r0      ),
                .SirRdat    (SirRdat0400r0      ),
                .Q          (Q0400r0           )
                );
defparam
U_ADDR0400_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0400_r0.DATAWIDTH   =    32,
U_ADDR0400_r0.ININTVALUE  = 32'h0,
U_ADDR0400_r0.REGADDRESS  = ADDR0400;

assign  u4_write_data_in = Q0400r0 ;

always @(posedge clk ) begin
    if(rst)
        u4_write_data_en <= 1'd0 ;
    else if(SirSel_d1 == 1'b1 && SirSel == 1'b0 && SirRead == 1'b0 && SirAddr == ADDR0400)
        u4_write_data_en <= 1'b1 ;
    else 
        u4_write_data_en <= 1'b0 ;
end


assign SirDack0400       = SirDack0400r0;
assign SirRdat0400[31:0] = SirRdat0400r0;


//************************************************************************************
//      addr: 0x80020404 32bit r0 {u4_awmf0165_reg[31:0]} 
//************************************************************************************

parameter       ADDR0404   = 16'h0404  ;
wire            SirDack0404     ;
wire    [31:0]  SirRdat0404     ;

wire            SirDack0404r0  ;
wire    [31:0]  SirRdat0404r0   ;
wire    [31:0]  Q0404r0         ;

reg_ro   U_ADDR0404_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0404r0      ),
                .SirRdat    (SirRdat0404r0      ),
                .Load       (1'b1               ),  
                .D          (u4_awmf0165_reg[31:0])
                );
defparam
U_ADDR0404_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0404_r0.DATAWIDTH   =    32,
U_ADDR0404_r0.ININTVALUE  = 32'h0,
U_ADDR0404_r0.REGADDRESS  = ADDR0404;


assign SirDack0404       = SirDack0404r0;
assign SirRdat0404[31:0] = SirRdat0404r0;  


//************************************************************************************
//      addr: 0x80020408 32bit r0 {u4_awmf0165_reg[63:32]} 
//************************************************************************************

parameter       ADDR0408   = 16'h0408  ;
wire            SirDack0408     ;
wire    [31:0]  SirRdat0408     ;

wire            SirDack0408r0  ;
wire    [31:0]  SirRdat0408r0   ;
wire    [31:0]  Q0408r0         ;

reg_ro   U_ADDR0408_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0408r0      ),
                .SirRdat    (SirRdat0408r0      ),
                .Load       (1'b1               ),  
                .D          (u4_awmf0165_reg[63:32])
                );
defparam
U_ADDR0408_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0408_r0.DATAWIDTH   =    32,
U_ADDR0408_r0.ININTVALUE  = 32'h0,
U_ADDR0408_r0.REGADDRESS  = ADDR0408;


assign SirDack0408       = SirDack0408r0;
assign SirRdat0408[31:0] = SirRdat0408r0;  


//************************************************************************************
//      addr: 0x8002040c 32bit r0 {u4_awmf0165_reg[95:64]} 
//************************************************************************************

parameter       ADDR040c   = 16'h040c  ;
wire            SirDack040c     ;
wire    [31:0]  SirRdat040c     ;

wire            SirDack040cr0  ;
wire    [31:0]  SirRdat040cr0   ;
wire    [31:0]  Q040cr0         ;

reg_ro   U_ADDR040c_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack040cr0      ),
                .SirRdat    (SirRdat040cr0      ),
                .Load       (1'b1               ),  
                .D          (u4_awmf0165_reg[95:64])
                );
defparam
U_ADDR040c_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR040c_r0.DATAWIDTH   =    32,
U_ADDR040c_r0.ININTVALUE  = 32'h0,
U_ADDR040c_r0.REGADDRESS  = ADDR040c;


assign SirDack040c       = SirDack040cr0;
assign SirRdat040c[31:0] = SirRdat040cr0;  


//************************************************************************************
//      addr: 0x80020410 32bit r0 {u4_awmf0165_reg[127:96]} 
//************************************************************************************

parameter       ADDR0410   = 16'h0410  ;
wire            SirDack0410     ;
wire    [31:0]  SirRdat0410     ;

wire            SirDack0410r0  ;
wire    [31:0]  SirRdat0410r0   ;
wire    [31:0]  Q0410r0         ;

reg_ro   U_ADDR0410_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0410r0      ),
                .SirRdat    (SirRdat0410r0      ),
                .Load       (1'b1               ),  
                .D          (u4_awmf0165_reg[127:96])
                );
defparam
U_ADDR0410_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0410_r0.DATAWIDTH   =    32,
U_ADDR0410_r0.ININTVALUE  = 32'h0,
U_ADDR0410_r0.REGADDRESS  = ADDR0410;


assign SirDack0410       = SirDack0410r0;
assign SirRdat0410[31:0] = SirRdat0410r0;  


//************************************************************************************
//      addr: 0x80020414 32bit r0 {u4_awmf0165_reg[159:128]} 
//************************************************************************************

parameter       ADDR0414   = 16'h0414  ;
wire            SirDack0414     ;
wire    [31:0]  SirRdat0414     ;

wire            SirDack0414r0  ;
wire    [31:0]  SirRdat0414r0   ;
wire    [31:0]  Q0414r0         ;

reg_ro   U_ADDR0414_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0414r0      ),
                .SirRdat    (SirRdat0414r0      ),
                .Load       (1'b1               ),  
                .D          (u4_awmf0165_reg[159:128])
                );
defparam
U_ADDR0414_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0414_r0.DATAWIDTH   =    32,
U_ADDR0414_r0.ININTVALUE  = 32'h0,
U_ADDR0414_r0.REGADDRESS  = ADDR0414;


assign SirDack0414       = SirDack0414r0;
assign SirRdat0414[31:0] = SirRdat0414r0;  


//************************************************************************************
//      addr: 0x80020418 32bit r0 {u4_awmf0165_reg[191:160]} 
//************************************************************************************

parameter       ADDR0418   = 16'h0418  ;
wire            SirDack0418     ;
wire    [31:0]  SirRdat0418     ;

wire            SirDack0418r0  ;
wire    [31:0]  SirRdat0418r0   ;
wire    [31:0]  Q0418r0         ;

reg_ro   U_ADDR0418_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0418r0      ),
                .SirRdat    (SirRdat0418r0      ),
                .Load       (1'b1               ),  
                .D          (u4_awmf0165_reg[191:160])
                );
defparam
U_ADDR0418_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0418_r0.DATAWIDTH   =    32,
U_ADDR0418_r0.ININTVALUE  = 32'h0,
U_ADDR0418_r0.REGADDRESS  = ADDR0418;


assign SirDack0418       = SirDack0418r0;
assign SirRdat0418[31:0] = SirRdat0418r0;  


//************************************************************************************
//      addr: 0x8002041c 32bit r0 {u4_awmf0165_reg[223:192]} 
//************************************************************************************

parameter       ADDR041c   = 16'h041c  ;
wire            SirDack041c     ;
wire    [31:0]  SirRdat041c     ;

wire            SirDack041cr0  ;
wire    [31:0]  SirRdat041cr0   ;
wire    [31:0]  Q041cr0         ;

reg_ro   U_ADDR041c_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack041cr0      ),
                .SirRdat    (SirRdat041cr0      ),
                .Load       (1'b1               ),  
                .D          (u4_awmf0165_reg[223:192])
                );
defparam
U_ADDR041c_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR041c_r0.DATAWIDTH   =    32,
U_ADDR041c_r0.ININTVALUE  = 32'h0,
U_ADDR041c_r0.REGADDRESS  = ADDR041c;


assign SirDack041c       = SirDack041cr0;
assign SirRdat041c[31:0] = SirRdat041cr0; 


//************************************************************************************
//      addr: 0x80020420 32bit r0 {u4_awmf0165_reg[255:224]} 
//************************************************************************************

parameter       ADDR0420   = 16'h0420  ;
wire            SirDack0420     ;
wire    [31:0]  SirRdat0420     ;

wire            SirDack0420r0  ;
wire    [31:0]  SirRdat0420r0   ;
wire    [31:0]  Q0420r0         ;

reg_ro   U_ADDR0420_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),

                .SirDack    (SirDack0420r0      ),
                .SirRdat    (SirRdat0420r0      ),
                .Load       (1'b1               ),  
                .D          (u4_awmf0165_reg[255:224])
                );
defparam
U_ADDR0420_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0420_r0.DATAWIDTH   =    32,
U_ADDR0420_r0.ININTVALUE  = 32'h0,
U_ADDR0420_r0.REGADDRESS  = ADDR0420;


assign SirDack0420       = SirDack0420r0;
assign SirRdat0420[31:0] = SirRdat0420r0; 


//************************************************************************************
//      addr :0x80020424 RW 32bit AWMF0165 CHAIN4 WRITE DATA 
//************************************************************************************
parameter       ADDR0424  = 16'h0424       ;

wire            SirDack0424     ;
wire    [31:0]  SirRdat0424     ;

wire            SirDack0424r0   ;
wire    [31:0]  SirRdat0424r0   ;
wire    [31:0]  Q0424r0         ;

reg_rw   U_ADDR0424_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat      		),
                .SirDack    (SirDack0424r0      ),
                .SirRdat    (SirRdat0424r0      ),
                .Q          (Q0424r0           )
                );
defparam
U_ADDR0424_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0424_r0.DATAWIDTH   =    4,
U_ADDR0424_r0.ININTVALUE  = 32'h0,
U_ADDR0424_r0.REGADDRESS  = ADDR0424;

assign  u8_awmf0165_ctr = Q0424r0 ;

assign SirDack0424       = SirDack0424r0;
assign SirRdat0424[31:0] = SirRdat0424r0; 


//************************************************************************************
//      addr :0x80020428 RW 32bit AWMF0165 u8_awmf0165_select
//************************************************************************************
parameter       ADDR0428  = 16'h0428       ;

wire            SirDack0428     ;
wire    [31:0]  SirRdat0428     ;

wire            SirDack0428r0   ;
wire    [31:0]  SirRdat0428r0   ;
wire    [31:0]  Q0428r0         ;

reg_rw   U_ADDR0428_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat      		),
                .SirDack    (SirDack0428r0      ),
                .SirRdat    (SirRdat0428r0      ),
                .Q          (Q0428r0           )
                );
defparam
U_ADDR0428_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0428_r0.DATAWIDTH   =    2,
U_ADDR0428_r0.ININTVALUE  = 32'h0,
U_ADDR0428_r0.REGADDRESS  = ADDR0428;

assign  u8_awmf0165_select = Q0428r0 ;

assign SirDack0428       = SirDack0428r0;
assign SirRdat0428[31:0] = SirRdat0428r0; 


//************************************************************************************
//      addr :0x8002042c RW 32bit timing  sync
//************************************************************************************
parameter       ADDR042c  = 16'h042c       ;

wire            SirDack042c     ;
wire    [31:0]  SirRdat042c     ;

wire            SirDack042cr0   ;
wire    [31:0]  SirRdat042cr0   ;
wire    [31:0]  Q042cr0         ;

reg_rw   U_ADDR042c_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat      		),
                .SirDack    (SirDack042cr0      ),
                .SirRdat    (SirRdat042cr0      ),
                .Q          (Q042cr0           )
                );
defparam
U_ADDR042c_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR042c_r0.DATAWIDTH   =    2,
U_ADDR042c_r0.ININTVALUE  = 32'h0,
U_ADDR042c_r0.REGADDRESS  = ADDR042c;

assign  timing_sync = Q042cr0 ;

assign SirDack042c       = SirDack042cr0;
assign SirRdat042c[31:0] = SirRdat042cr0; 

//////////////////////////////////////////////////////////////////////////////////////
//************************************************************************************
//      addr :0x80020800 RO 32bit pll_ana_ad
//************************************************************************************
parameter       ADDR0800   = 16'h0800       ;
wire            SirDack0800     ;
wire    [31:0]  SirRdat0800     ;
wire            SirDack0800r0   ;
wire    [31:0]  SirRdat0800r0   ;
reg_ro   U_ADDR0800_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                // .SirWdat    (SirWdat      		),
                .SirDack    (SirDack0800r0      ),
                .SirRdat    (SirRdat0800r0      ),
                .Load       (1'b1               ),  
                .D          ({16'd0,pll_ana_ad} )
                );
defparam
U_ADDR0800_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0800_r0.DATAWIDTH   =    32,
U_ADDR0800_r0.ININTVALUE  = 32'h0,
U_ADDR0800_r0.REGADDRESS  = ADDR0800;
assign SirDack0800       = SirDack0800r0;
assign SirRdat0800[31:0] = SirRdat0800r0;

//************************************************************************************
//      addr :0x80020804 RO 32bit pll_ana_ad
//************************************************************************************

parameter       ADDR0804   = 16'h0804       ;
wire            SirDack0804     ;
wire    [31:0]  SirRdat0804     ;
wire            SirDack0804r0   ;
wire    [31:0]  SirRdat0804r0   ;
reg_ro   U_ADDR0804_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                // .SirWdat    (SirWdat      		),
                .SirDack    (SirDack0804r0      ),
                .SirRdat    (SirRdat0804r0      ),
                .Load       (1'b1               ),  
                .D          ({16'd0,temperature})
                );
defparam
U_ADDR0804_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR0804_r0.DATAWIDTH   =    32,
U_ADDR0804_r0.ININTVALUE  = 32'h0,
U_ADDR0804_r0.REGADDRESS  = ADDR0804;
assign SirDack0804       = SirDack0804r0;
assign SirRdat0804[31:0] = SirRdat0804r0;

always @ (posedge clk )
begin
    if (rst == 1'b1)
        SirDack <= 1'b0;
    else
        SirDack <=      SirDack0000 | SirDack0004 |

                        SirDack0100 | SirDack0104 | SirDack0108 | SirDack010c | SirDack0110 | SirDack0114 | SirDack0118 | SirDack011c |
                        SirDack0120 | SirDack0124 | SirDack0128 | SirDack012c |
                       
                        SirDack0200 | SirDack0204 | SirDack0210 | SirDack0214 |

                        SirDack0300 | SirDack0304 | SirDack0308 | SirDack030c | SirDack0310 | SirDack0314 | SirDack0318 | SirDack031c |
                        SirDack0320 | SirDack0324 | SirDack0328 | SirDack032c | SirDack0330 | SirDack0334 | SirDack0338 | SirDack033c |
                        SirDack0340 | SirDack0344 | SirDack0348 | SirDack034c | SirDack0350 | SirDack0354 | SirDack0358 | SirDack035c |
                        SirDack0360 | SirDack0364 | SirDack0368 | SirDack036c | SirDack0370 | SirDack0374 | SirDack0378 | SirDack037c |
                        SirDack0380 | SirDack0384 | SirDack0388 | SirDack038c | SirDack0390 | SirDack0394 | SirDack0398 | SirDack039c |

                        SirDack03a0 | SirDack03a4 | SirDack03a8 | SirDack03ac | SirDack03b0 |

                        SirDack0400 | SirDack0404 | SirDack0408 | SirDack040c | SirDack0410 | SirDack0414 | SirDack0418 | SirDack041c | 
                        SirDack0420 | SirDack0424 | SirDack0428 | SirDack042c |
            			
                        SirDack0800 | SirDack0804 
                        ;
        
end       

always @ (posedge clk)
begin
        SirRdat <=      SirRdat0000 | SirRdat0004 |

                        SirRdat0100 | SirRdat0104 | SirRdat0108 | SirRdat010c | SirRdat0110 | SirRdat0114 | SirRdat0118 | SirRdat011c |
                        SirRdat0120 | SirRdat0124 | SirRdat0128 | SirRdat012c |
        
                        SirRdat0200 | SirRdat0204 | SirRdat0210 | SirRdat0214 |
                        
                        SirRdat0300 | SirRdat0304 | SirRdat0308 | SirRdat030c | SirRdat0310 | SirRdat0314 | SirRdat0318 | SirRdat031c |
                        SirRdat0320 | SirRdat0324 | SirRdat0328 | SirRdat032c | SirRdat0330 | SirRdat0334 | SirRdat0338 | SirRdat033c |
                        SirRdat0340 | SirRdat0344 | SirRdat0348 | SirRdat034c | SirRdat0350 | SirRdat0354 | SirRdat0358 | SirRdat035c |
                        SirRdat0360 | SirRdat0364 | SirRdat0368 | SirRdat036c | SirRdat0370 | SirRdat0374 | SirRdat0378 | SirRdat037c | 
                        SirRdat0380 | SirRdat0384 | SirRdat0388 | SirRdat038c | SirRdat0390 | SirRdat0394 | SirRdat0398 | SirRdat039c |

                        SirRdat03a0 | SirRdat03a4 | SirRdat03a8 | SirRdat03ac | SirRdat03b0 |

                        SirRdat0400 | SirRdat0404 | SirRdat0408 | SirRdat040c | SirRdat0410 | SirRdat0414 | SirRdat0418 | SirRdat041c |
                        SirRdat0420 | SirRdat0424 | SirRdat0428 | SirRdat042c |
			            
                        SirRdat0800 | SirRdat0804 
                        ;
end
endmodule

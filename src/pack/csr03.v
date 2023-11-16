module csr03
(
    input	wire                   rst         ,
    input	wire                   clk         ,

    input   wire    [15:0]         mux_ctr     ,
    input   wire                   dma_restart ,
    output  wire                   ddr_test_start ,
    output  wire    [31:0]         test_len       ,

    input   wire    [15:0]         SirAddr     ,
    input   wire                   SirRead     ,
    input   wire    [31:0]         SirWdat     ,
    input   wire                   SirSel      ,
    output  reg                    SirDack     ,
    output  reg     [31:0]         SirRdat     

);

parameter       SLAVE_SIZE  = 16            ;

//************************************************************************************
//              
//************************************************************************************
parameter       ADDR3000   = 16'h3000       ;

wire            SirDack3000     ;
wire    [31:0]  SirRdat3000     ;

wire            SirDack3000r0   ;
wire    [31:0]  SirRdat3000r0   ;
wire    [31:0]  Q3000r0         ;

reg_rw   U_ADDR3000_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat      	),
                .SirDack    (SirDack3000r0      ),
                .SirRdat    (SirRdat3000r0      ),
                .Q          (Q3000r0            )
                );

defparam
U_ADDR3000_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR3000_r0.DATAWIDTH   =    32,
U_ADDR3000_r0.ININTVALUE  = 32'h0,
U_ADDR3000_r0.REGADDRESS  = ADDR3000;

assign mux_ctr = Q3000r0[15:0] ;

assign SirDack3000       = SirDack3000r0;
assign SirRdat3000[31:0] = SirRdat3000r0;


//************************************************************************************
//              
//************************************************************************************
parameter       ADDR3004   = 16'h3004       ;

wire            SirDack3004     ;
wire    [31:0]  SirRdat3004     ;

wire            SirDack3004r0   ;
wire    [31:0]  SirRdat3004r0   ;
wire    [31:0]  Q3004r0         ;

reg_rw   U_ADDR3004_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat      	    ),
                .SirDack    (SirDack3004r0      ),
                .SirRdat    (SirRdat3004r0      ),
                .Q          (Q3004r0            )
                );

defparam
U_ADDR3004_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR3004_r0.DATAWIDTH   =    32,
U_ADDR3004_r0.ININTVALUE  = 32'h0,
U_ADDR3004_r0.REGADDRESS  = ADDR3004;

assign dma_restart = Q3004r0[0:0] ;

assign SirDack3004       = SirDack3004r0;
assign SirRdat3004[31:0] = SirRdat3004r0;


//************************************************************************************
//              
//************************************************************************************
parameter       ADDR3008   = 16'h3008       ;

wire            SirDack3008     ;
wire    [31:0]  SirRdat3008     ;

wire            SirDack3008r0   ;
wire    [31:0]  SirRdat3008r0   ;
wire    [31:0]  Q3008r0         ;

reg_rw   U_ADDR3008_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat      	    ),
                .SirDack    (SirDack3008r0      ),
                .SirRdat    (SirRdat3008r0      ),
                .Q          (Q3008r0            )
                );

defparam
U_ADDR3008_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR3008_r0.DATAWIDTH   =    32,
U_ADDR3008_r0.ININTVALUE  = 32'h0,
U_ADDR3008_r0.REGADDRESS  = ADDR3008;

assign ddr_test_start     = Q3008r0[0:0] ;

assign SirDack3008        = SirDack3008r0;
assign SirRdat3008[31:0]  = SirRdat3008r0;


//************************************************************************************
//              
//************************************************************************************
parameter       ADDR300c   = 16'h300c       ;

wire            SirDack300c     ;
wire    [31:0]  SirRdat300c     ;

wire            SirDack300cr0   ;
wire    [31:0]  SirRdat300cr0   ;
wire    [31:0]  Q300cr0         ;

reg_rw   U_ADDR300c_r0(
                .clk        (clk                ),
                .rst        (rst                ),
                                                
                .SirSel     (SirSel            	),
                .SirRead    (SirRead            ),
                .SirAddr    (SirAddr            ),
                .SirWdat    (SirWdat      	    ),
                .SirDack    (SirDack300cr0      ),
                .SirRdat    (SirRdat300cr0      ),
                .Q          (Q300cr0            )
                );

defparam
U_ADDR300c_r0.ADDRWIDTH   = SLAVE_SIZE,
U_ADDR300c_r0.DATAWIDTH   =    32,
U_ADDR300c_r0.ININTVALUE  = 32'h0,
U_ADDR300c_r0.REGADDRESS  = ADDR300c;

assign test_len     = Q300cr0[31:0] ;

assign SirDack300c        = SirDack300cr0;
assign SirRdat300c[31:0]  = SirRdat300cr0;




always @ (posedge clk )
begin
    if (rst == 1'b1)
        SirDack <= 1'b0;
    else
        SirDack <=
                        SirDack3000 | SirDack3004 | SirDack3008 | SirDack300c 
                        ;
end       

always @ (posedge clk)
begin
        SirRdat <=      
                        SirRdat3000 | SirRdat3004 | SirRdat3008 | SirRdat300c 
                        ;
end 

endmodule

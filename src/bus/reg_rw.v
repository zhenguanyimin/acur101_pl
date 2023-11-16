module reg_rw(
                clk         ,
                rst         ,

                SirSel      ,
                SirRead     ,
                SirAddr     ,
                SirWdat     ,
                SirDack     ,
                SirRdat     ,

                Q
                );

parameter   ADDRWIDTH   = 8;
parameter   DATAWIDTH   = 1;
parameter   ININTVALUE  = 1'b0;
parameter   REGADDRESS  = 8'h01;

input                       clk         ;
input                       rst         ;
                            
input                       SirSel      ;
input                       SirRead     ;
input   [(ADDRWIDTH-1):0]   SirAddr     ;
input   [(DATAWIDTH-1):0]   SirWdat     ;
output                      SirDack     ;
output  [(DATAWIDTH-1):0]   SirRdat     ;

output  [(DATAWIDTH-1):0]   Q           ;

/**************************************************************************************************/
wire                        clk         ;
wire                        rst         ;
                            
wire                        SirSel      ;
wire                        SirRead     ;
wire    [(ADDRWIDTH-1):0]   SirAddr     ;
wire    [(DATAWIDTH-1):0]   SirWdat     ;
reg                         SirDack     ;
reg	    [(DATAWIDTH-1):0] SirRdat     ;

reg     [(DATAWIDTH-1):0]   Q           ;

reg                         SirDackL1   ;

/**************************************************************************************************/
always @ (posedge clk)
begin
    if (rst == 1'b1)
       SirDack <= 1'b0;
    else if ((SirSel == 1'b1) && (SirAddr == REGADDRESS))
       SirDack <=  1'b1;
    else
       SirDack <=  1'b0;
end       

always @ (posedge clk)
begin
    if (rst == 1'b1)
       SirDackL1 <= 1'b0;
    else
       SirDackL1 <=  SirDack;
end       

always @ (posedge clk)
begin
    if (rst == 1'b1)
       Q <= ININTVALUE;
 //   else if ((SirSel == 1'b1) && (SirAddr == REGADDRESS) && (SirRead == 1'b0))
    else if ((SirDack == 1'b1) && (SirDackL1 == 1'b0) && (SirRead == 1'b0))
       Q <=  SirWdat;
    else;
end       


always @ (posedge clk)
begin
   if (rst == 1'b1)
   	SirRdat <= {DATAWIDTH{1'b0}};
   else if((SirSel == 1'b1) &&(SirAddr == REGADDRESS) && (SirRead == 1'b1))
   	SirRdat <= Q;
   else
   	SirRdat <= {DATAWIDTH{1'b0}};
end


//assign SirRdat = ((SirSel == 1'b1) && (SirAddr == REGADDRESS) && (SirRead == 1'b1)) ? Q : {DATAWIDTH{1'b0}};



endmodule
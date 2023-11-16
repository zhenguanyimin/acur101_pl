module reg_ro(
                clk         ,
                rst         ,

                SirSel      ,
                SirRead     ,
                SirAddr     ,
                SirDack     ,
                SirRdat     ,

                Load        ,
                D        
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
output                      SirDack     ;
output  [(DATAWIDTH-1):0]   SirRdat     ;

input                       Load        ;
input   [(DATAWIDTH-1):0]   D           ;

/**************************************************************************************************/
wire                        clk         ;
wire                        rst         ;
                            
wire                        SirSel      ;
wire                        SirRead     ;
wire    [(ADDRWIDTH-1):0]   SirAddr     ;
reg                         SirDack     ;
reg	    [(DATAWIDTH-1):0]   SirRdat     ;

wire                        Load        ;
wire    [(DATAWIDTH-1):0]   D           ;
reg     [(DATAWIDTH-1):0]   Q           ;

/**************************************************************************************************/
always @ (posedge clk)
begin
    if (rst == 1'b1)
       Q <= ININTVALUE;
    else if (Load == 1'b1)
       Q <=  D;
    else;
end       

always @ (posedge clk)
begin
    if (rst == 1'b1)
       SirDack <= 1'b0;
    else if ((SirSel == 1'b1) && (SirAddr == REGADDRESS) )
       SirDack <=  1'b1;
    else
       SirDack <=  1'b0;
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



//assign SirRdat = ((SirSel == 1'b1) && (SirAddr == REGADDRESS) && (SirRead == 1'b1)) ? Q :{DATAWIDTH{1'b0}};



endmodule
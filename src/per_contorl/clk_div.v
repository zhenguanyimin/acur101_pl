module clk_div
(

    input   clk_100m   ,
    input   rst        ,
    
    output reg clk_10m ,
    output reg clk_25m
);

reg [2:0]   clk_10m_cnt ; 	// 25M

always @(posedge clk_100m)
begin
	if(rst)
        clk_10m_cnt <='d0 ;
	else if(clk_10m_cnt == 'd4)
		clk_10m_cnt <= 'd0;
    else
        clk_10m_cnt <= clk_10m_cnt + 1'b1;
end
always @(posedge clk_100m)
begin
	if(rst)
        clk_10m <='d0 ;
	else if(clk_10m_cnt == 'd4)
		clk_10m <= ~clk_10m ;
	else
		clk_10m <= clk_10m ;
end

reg		clk_25m_cnt ; 	// 25M

always @(posedge clk_100m)
begin
	if(rst)
		clk_25m_cnt <='d0 ;
	else 
		clk_25m_cnt <= ~clk_25m_cnt; 
end

always @(posedge clk_100m)
begin
	if(rst)
		clk_25m <='d0 ;
	else if(clk_25m_cnt)
		clk_25m <= ~clk_25m ;
	else
		clk_25m <= clk_25m ;
end

endmodule
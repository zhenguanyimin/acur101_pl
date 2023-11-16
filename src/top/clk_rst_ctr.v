`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/21 15:00:40
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module clk_rst_ctr 
(
    input   wire clk40m          ,
    input   wire ps_clk_100m     ,
    output  wire sys_clk         ,
    output  wire clk_dclk_o      ,
    output  wire clk_300m        ,
    output  reg  sys_rst  = 1'b1 ,
    output  wire mmc_lock    
);

clk_wiz_0 clk_wiz_0
(
    .clk_in1    (clk40m             ),
    .clk_out1   (sys_clk            ),
    .clk_out2   (clk_dclk_o         ),
    .clk_out3   (clk_300m           ),
    .locked     (mmc_lock           )
);

reg [11:0]  mmc_lock_cnt = 'd0 ;

always @(posedge ps_clk_100m) begin
    if(mmc_lock_cnt < 12'hfff)
        mmc_lock_cnt <= mmc_lock_cnt + 1'b1 ;
    else 
        mmc_lock_cnt <= mmc_lock_cnt ;
end

always @(posedge ps_clk_100m) begin 
    if (mmc_lock_cnt == 12'hfff)
        sys_rst <= 1'b0 ;
    else 
        sys_rst <= 1'b1 ;
end

endmodule 

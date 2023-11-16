`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/13 16:44:52
// Design Name: 
// Module Name: thresh_tas_top
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
module thresh_tas_top(
    input					sys_clk			,
    input					rst_n			,	
	input	[7:0]			clut_tas_ary	,	
	input	[15:0]			clut_tas_inr	,
			
	input					radmap_rd_vld	,
	input	[15:0]			radmap_rd_din1	,	
	input	[15:0]			radmap_rd_din2	,
	input	[15:0]			radmap_rd_din3	,

	output reg				thresh_valid	,
	output reg	[15:0]		thresh_dat			
    );

/**************************************************************TAS门限计算***********************************************************/
reg 		radmap_rd_vld0;
reg 		radmap_rd_vld1;
reg 		radmap_rd_vld2;
reg 		radmap_rd_vld3;
wire [15:0]	clut_tas_inr1;
wire [31:0]	thresh_mult_dat0;
wire [31:0]	thresh_mult_dat1;

reg 		thresh_add_vld0;
reg [31:0]	thresh_add_dat0;
reg 		thresh_add_vld1;
reg [15:0]	thresh_add_dat1;

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_rd_vld0	 <= 1'b0;	
		radmap_rd_vld1	 <= 1'b0;	
		radmap_rd_vld2	 <= 1'b0;	
		radmap_rd_vld3	 <= 1'b0;			
	end
	else begin
		radmap_rd_vld0	 <= radmap_rd_vld;	
		radmap_rd_vld1	 <= radmap_rd_vld0;	
		radmap_rd_vld2	 <= radmap_rd_vld1;	
		radmap_rd_vld3	 <= radmap_rd_vld2;
	end
end

assign clut_tas_inr1 = 16'd1000 - clut_tas_inr;//1-K

//DELAY 4CLK
mult_clut_t0 u_mult_gen_t0 (
		.CLK						(	sys_clk			)	,  	// input wire CLK
		.A							(	radmap_rd_din2	)	,   // input wire [15 : 0] A
		.B							(	clut_tas_inr	)	,   // input wire [15 : 0] B
		.P							(	thresh_mult_dat0)      // output wire [31 : 0] P
	);

mult_clut_t1 u_mult_gen_t1 (
		.CLK						(	sys_clk			)	,  // input wire CLK
		.A							(	radmap_rd_din3	)	,  // input wire [15 : 0] A
		.B							(	clut_tas_inr1	)	,  // input wire [15 : 0] B
		.P							(	thresh_mult_dat1)      // output wire [31: 0] P
	);

//add
always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		thresh_add_vld0	 <= 1'b0;
		thresh_add_dat0	 <= 32'd0;		
	end
	else begin
		if(radmap_rd_vld3)begin
			thresh_add_vld0	 <= 1'b1;
			thresh_add_dat0	 <= thresh_mult_dat0/1000 + thresh_mult_dat1/1000;			
		end
		else begin
			thresh_add_vld0	 <= 1'b0;
			thresh_add_dat0	 <= thresh_add_dat0;			
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		thresh_add_vld1 <= 1'b0;
		thresh_add_dat1	<= 16'd0;		
	end
	else begin
		if(thresh_add_vld0)begin
			thresh_add_vld1 <= 1'b1;
			thresh_add_dat1	<= thresh_add_dat0[15:0];		
		end
		else begin
			thresh_add_vld1 <= 1'b0;
			thresh_add_dat1	<= thresh_add_dat1;			
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		thresh_valid <= 1'b0;
		thresh_dat	 <= 16'd0;		
	end
	else begin
		if(clut_tas_ary)begin
			thresh_valid <= thresh_add_vld1;
			thresh_dat	 <= thresh_add_dat1;		
		end
		else begin
			thresh_valid <= radmap_rd_vld;
			thresh_dat	 <= radmap_rd_din2;			
		end
	end
end
	
endmodule

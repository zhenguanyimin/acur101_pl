`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/04 16:44:52
// Design Name: 
// Module Name: recur_oper
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
module recur_oper(
    input					sys_clk			,
    input					rst_n			,	
	input	[15:0]			recur_coeff		,//k
			
	input					radmap_rd_vld	,
	input	[15:0]			radmap_rd_din0	,//x(n)
	input	[15:0]			radmap_rd_din2	,//y(n-1)

	output reg				recur_valid		,
	output reg	[15:0]		recur_dat			
    );

/**************************************************************一阶递归运算***********************************************************/
reg 		radmap_rd_vld0;
reg 		radmap_rd_vld1;
reg 		radmap_rd_vld2;
reg 		radmap_rd_vld3;
wire [15:0]	recur_coeff1;
wire [31:0]	recur_mult_dat0;
wire [31:0]	recur_mult_dat1;

reg 		recur_add_vld0;
reg [31:0]	recur_add_dat0;

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

assign recur_coeff1 = 16'd1000 - recur_coeff;//1-K

//DELAY 4CLK
mult_clut_t0 u_mult_gen_t0 (
		.CLK						(	sys_clk			)	,  	// input wire CLK
		.A							(	radmap_rd_din0	)	,   // input wire [15 : 0] A
		.B							(	recur_coeff		)	,   // input wire [15 : 0] B
		.P							(	recur_mult_dat0	)      // output wire [31 : 0] P
	);

mult_clut_t1 u_mult_gen_t1 (
		.CLK						(	sys_clk			)	,  // input wire CLK
		.A							(	radmap_rd_din2	)	,  // input wire [15 : 0] A
		.B							(	recur_coeff1	)	,  // input wire [15 : 0] B
		.P							(	recur_mult_dat1	)      // output wire [31: 0] P
	);

//add
always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		recur_add_vld0	 <= 1'b0;
		recur_add_dat0	 <= 32'd0;		
	end
	else begin
		if(radmap_rd_vld3)begin
			recur_add_vld0	 <= 1'b1;
			recur_add_dat0	 <= recur_mult_dat0/1000 + recur_mult_dat1/1000;			
		end
		else begin
			recur_add_vld0	 <= 1'b0;
			recur_add_dat0	 <= recur_add_dat0;			
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		recur_valid	 <= 1'b0;
		recur_dat	 <= 16'd0;		
	end
	else begin
		if(recur_add_vld0)begin
			recur_valid	 <= 1'b1;
			recur_dat	 <= recur_add_dat0[15:0];		
		end
		else begin
			recur_valid	 <= 1'b0;
			recur_dat	 <= recur_dat;			
		end
	end
end
	
endmodule

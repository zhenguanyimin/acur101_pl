`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/04 16:44:52
// Design Name: 
// Module Name: thresh_top
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
module thresh_top(
    input					sys_clk			,
    input					rst_n			,	
			
	input	[15:0]			clut_cpi		,	
	
	input					radmap_rd_vld	,
	input	[15:0]			radmap_rd_din1	,	
	input	[15:0]			radmap_rd_din2	,		
	input	[15:0]			radmap_rd_din3	,						
	
	output	reg				thresh_valid,
	output	reg	[15:0]		thresh_dat	
    );

/**************************************************************TWS门限计算***********************************************************/
wire		thr_fifo_full_a0;
wire		thr_fifo_rd_en_a0;
wire [15:0]	thr_fifo_dout_a0;
wire 		thr_fifo_empty_a0;
wire		thr_fifo_full_a1;
wire		thr_fifo_rd_en_a1;
wire [15:0]	thr_fifo_dout_a1;
wire 		thr_fifo_empty_a1;
wire		thr_fifo_full_b0;
wire [15:0]	thr_fifo_dout_b0;
wire 		thr_fifo_empty_b0;
wire		thr_fifo_full_b1;
wire [15:0]	thr_fifo_dout_b1;
wire 		thr_fifo_empty_b1;
wire		thr_fifo_full_c0;
wire [15:0]	thr_fifo_dout_c0;
wire 		thr_fifo_empty_c0;
wire		thr_fifo_full_c1;
wire [15:0]	thr_fifo_dout_c1;
wire 		thr_fifo_empty_c1;
reg [63:0]	radmap_rd_d0;

reg			radmap_vld0;
reg	[15:0]	radmap_din1_t1;
reg	[15:0]	radmap_din1_t2;
reg	[15:0]	radmap_din1_t3;
reg	[15:0]	radmap_din2_t1;
reg	[15:0]	radmap_din2_t2;
reg	[15:0]	radmap_din2_t3;
reg	[15:0]	radmap_din3_t1;
reg	[15:0]	radmap_din3_t2;
reg	[15:0]	radmap_din3_t3;

reg			radmap_avld_a0;
reg			radmap_avld_a2;
reg	[15:0]	radmap_din1_a0;
reg	[15:0]	radmap_din1_a1;
reg	[15:0]	radmap_din1_a2;
reg	[15:0]	radmap_din2_a0;
reg	[15:0]	radmap_din2_a1;
reg	[15:0]	radmap_din2_a2;
reg	[15:0]	radmap_din3_a0;
reg	[15:0]	radmap_din3_a1;
reg	[15:0]	radmap_din3_a2;

reg			radmap_avld_b0;
reg			radmap_avld_b2;
reg	[15:0]	radmap_din_b0;
reg	[15:0]	radmap_din_b1;
reg	[15:0]	radmap_din_b2;

cult3_data_fifo  u_cult3_data_fifo_a0(
  .rst			( ~rst_n				),
  .wr_clk		( sys_clk 		   		),
  .din			( radmap_rd_din1     	),
  .wr_en		( radmap_rd_vld			),
  .full			( thr_fifo_full_a0    	),
  .rd_data_count( 						),
  .wr_data_count(   					),
  .rd_clk		( sys_clk       		),
  .rd_en		( thr_fifo_rd_en_a0    	),
  .dout			( thr_fifo_dout_a0     	),
  .empty		( thr_fifo_empty_a0    	)
);

cult3_data_fifo  u_cult3_data_fifo_b0(
  .rst			( ~rst_n				),
  .wr_clk		( sys_clk 		   		),
  .din			( radmap_rd_din2     	),
  .wr_en		( radmap_rd_vld			),
  .full			( thr_fifo_full_b0    	),
  .rd_data_count( 						),
  .wr_data_count(   					),
  .rd_clk		( sys_clk       		),
  .rd_en		( thr_fifo_rd_en_a0    	),
  .dout			( thr_fifo_dout_b0     	),
  .empty		( thr_fifo_empty_b0    	)
);

cult3_data_fifo  u_cult3_data_fifo_c0(
  .rst			( ~rst_n				),
  .wr_clk		( sys_clk 		   		),
  .din			( radmap_rd_din3     	),
  .wr_en		( radmap_rd_vld			),
  .full			( thr_fifo_full_c0    	),
  .rd_data_count( 						),
  .wr_data_count(   					),
  .rd_clk		( sys_clk       		),
  .rd_en		( thr_fifo_rd_en_a0    	),
  .dout			( thr_fifo_dout_c0     	),
  .empty		( thr_fifo_empty_c0    	)
);

assign thr_fifo_rd_en_a0 = radmap_rd_d0[31] ? 1'b1 : 1'b0;

cult3_data_fifo  u_cult3_data_fifo_a1(
  .rst			( ~rst_n				),
  .wr_clk		( sys_clk 		   		),
  .din			( thr_fifo_dout_a0     	),
  .wr_en		( thr_fifo_rd_en_a0		),
  .full			( thr_fifo_full_a1    	),
  .rd_data_count( 						),
  .wr_data_count(   					),
  .rd_clk		( sys_clk       		),
  .rd_en		( thr_fifo_rd_en_a1    	),
  .dout			( thr_fifo_dout_a1     	),
  .empty		( thr_fifo_empty_a1    	)
);

cult3_data_fifo  u_cult3_data_fifo_b1(
  .rst			( ~rst_n				),
  .wr_clk		( sys_clk 		   		),
  .din			( thr_fifo_dout_b0     	),
  .wr_en		( thr_fifo_rd_en_a0		),
  .full			( thr_fifo_full_b1    	),
  .rd_data_count( 						),
  .wr_data_count(   					),
  .rd_clk		( sys_clk       		),
  .rd_en		( thr_fifo_rd_en_a1    	),
  .dout			( thr_fifo_dout_b1     	),
  .empty		( thr_fifo_empty_b1    	)
);

cult3_data_fifo  u_cult3_data_fifo_c1(
  .rst			( ~rst_n				),
  .wr_clk		( sys_clk 		   		),
  .din			( thr_fifo_dout_c0     	),
  .wr_en		( thr_fifo_rd_en_a0		),
  .full			( thr_fifo_full_c1    	),
  .rd_data_count( 						),
  .wr_data_count(   					),
  .rd_clk		( sys_clk       		),
  .rd_en		( thr_fifo_rd_en_a1    	),
  .dout			( thr_fifo_dout_c1     	),
  .empty		( thr_fifo_empty_c1    	)
);

assign thr_fifo_rd_en_a1 = radmap_rd_d0[63] ? 1'b1 : 1'b0;

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_rd_d0	<=	64'b0;
	end
	else begin
		radmap_rd_d0 <= {radmap_rd_d0[62:0],radmap_rd_vld};
	end
end	

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_din1_t1	<= 16'd0;	
		radmap_din2_t1	<= 16'd0;		
		radmap_din3_t1	<= 16'd0;		
	end
	else begin
		if(radmap_rd_vld)begin
			radmap_din1_t1	<= radmap_rd_din1;
			radmap_din2_t1	<= radmap_rd_din2;
			radmap_din3_t1	<= radmap_rd_din3;	
		end
		else begin
			radmap_din1_t1	<= 16'd0;	
			radmap_din2_t1	<= 16'd0;		
			radmap_din3_t1	<= 16'd0;		
		end		
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_vld0		<= 1'b0;	
		radmap_din1_t2	<= 16'd0;
		radmap_din2_t2	<= 16'd0;
		radmap_din3_t2	<= 16'd0;		
	end
	else begin
		if(thr_fifo_rd_en_a0)begin
			radmap_vld0		<= 1'b1;		
			radmap_din1_t2	<= thr_fifo_dout_a0;
			radmap_din2_t2	<= thr_fifo_dout_b0;
			radmap_din3_t2	<= thr_fifo_dout_c0;
		end
		else begin
			radmap_vld0		<= 1'b0;	
			radmap_din1_t2	<= 16'd0;
			radmap_din2_t2	<= 16'd0;
			radmap_din3_t2	<= 16'd0;		
		end		
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_din1_t3	<= 16'd0;		
		radmap_din2_t3	<= 16'd0;		
		radmap_din3_t3	<= 16'd0;	
	end
	else begin
		if(thr_fifo_rd_en_a1)begin
			radmap_din1_t3	<= thr_fifo_dout_a1;
			radmap_din2_t3	<= thr_fifo_dout_b1;
			radmap_din3_t3	<= thr_fifo_dout_c1;
		end
		else begin
			radmap_din1_t3	<= 16'd0;		
			radmap_din2_t3	<= 16'd0;		
			radmap_din3_t3	<= 16'd0;		
		end		
	end
end

//0
always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_din1_a0	<= 16'd0;		
	end
	else begin
		if(clut_cpi <= 16'd4 )begin
			radmap_din1_a0	<= 16'd0;
		end
		else if(radmap_vld0)begin
			if(radmap_din1_t3 >= radmap_din1_t2)begin
				radmap_din1_a0 <= radmap_din1_t3;
			end
			else if(radmap_din1_t2 > radmap_din1_t3)begin
				radmap_din1_a0 <= radmap_din1_t2;
			end
			else begin
				radmap_din1_a0	<= radmap_din1_a0;
			end
		end
		else begin
			radmap_din1_a0	<= 16'd0;
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_din1_a1	<= 16'd0;		
	end
	else begin
		if(clut_cpi <= 16'd4)begin
			radmap_din1_a1	<= 16'd0;
		end
		else if(radmap_vld0)begin
			if(radmap_din1_t2 >= radmap_din1_t1)begin
				radmap_din1_a1 <= radmap_din1_t2;
			end
			else if(radmap_din1_t1 > radmap_din1_t2)begin
				radmap_din1_a1 <= radmap_din1_t1;
			end
			else begin
				radmap_din1_a1	<= radmap_din1_a1;
			end
		end
		else begin
			radmap_din1_a1	<= 16'd0;
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_din1_a2	<= 16'd0;		
	end
	else begin
		if(clut_cpi <= 16'd4)begin
			radmap_din1_a2	<= 16'd0;
		end
		else if(radmap_avld_a0)begin
			if(radmap_din1_a0 >= radmap_din1_a1)begin
				radmap_din1_a2 <= radmap_din1_a0;
			end
			else if(radmap_din1_a1 > radmap_din1_a0)begin
				radmap_din1_a2 <= radmap_din1_a1;
			end
			else begin
				radmap_din1_a2	<= radmap_din1_a2;
			end
		end
		else begin
			radmap_din1_a2	<= 16'd0;
		end
	end
end

//1
always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_avld_a0	<= 1'b0;
		radmap_din2_a0	<= 16'd0;		
	end
	else begin
		if(radmap_vld0)begin
			radmap_avld_a0	<= 1'b1;
			if(radmap_din2_t3 >= radmap_din2_t2)begin
				radmap_din2_a0 <= radmap_din2_t3;
			end
			else if(radmap_din2_t2 > radmap_din2_t3)begin
				radmap_din2_a0 <= radmap_din2_t2;
			end
			else begin
				radmap_din2_a0	<= radmap_din2_a0;
			end
		end
		else begin
			radmap_avld_a0	<= 1'b0;
			radmap_din2_a0	<= 16'd0;
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_din2_a1	<= 16'd0;		
	end
	else begin
		if(radmap_vld0)begin
			if(radmap_din2_t2 >= radmap_din2_t1)begin
				radmap_din2_a1 <= radmap_din2_t2;
			end
			else if(radmap_din2_t1 > radmap_din2_t2)begin
				radmap_din2_a1 <= radmap_din2_t1;
			end
			else begin
				radmap_din2_a1	<= radmap_din2_a1;
			end
		end
		else begin
			radmap_din2_a1	<= 16'd0;		
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_avld_a2	<= 1'b0;
		radmap_din2_a2	<= 16'd0;		
	end
	else begin
		if(radmap_avld_a0)begin
			radmap_avld_a2	<= 1'b1;
			if(radmap_din2_a0 >= radmap_din2_a1)begin
				radmap_din2_a2 <= radmap_din2_a0;
			end
			else if(radmap_din2_a1 > radmap_din2_a0)begin
				radmap_din2_a2 <= radmap_din2_a1;
			end
			else begin
				radmap_din2_a2	<= radmap_din2_a2;
			end
		end
		else begin
			radmap_avld_a2	<= 1'b0;
			radmap_din2_a2	<= 16'd0;
		end
	end
end

//2
always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_din3_a0	<= 16'd0;		
	end
	else begin
		if((clut_cpi >= 16'd117) && (clut_cpi <= 16'd120))begin
			radmap_din3_a0	<= 16'd0;
		end
		else if(radmap_vld0)begin
			if(radmap_din3_t3 >= radmap_din3_t2)begin
				radmap_din3_a0 <= radmap_din3_t3;
			end
			else if(radmap_din3_t2 > radmap_din3_t3)begin
				radmap_din3_a0 <= radmap_din3_t2;
			end
			else begin
				radmap_din3_a0	<= radmap_din3_a0;
			end
		end
		else begin
			radmap_din3_a0	<= 16'd0;
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_din3_a1	<= 16'd0;		
	end
	else begin
		if((clut_cpi >= 16'd117) && (clut_cpi <= 16'd120))begin
			radmap_din3_a1	<= 16'd0;
		end
		else if(radmap_vld0)begin
			if(radmap_din3_t2 >= radmap_din3_t1)begin
				radmap_din3_a1 <= radmap_din3_t2;
			end
			else if(radmap_din3_t1 > radmap_din3_t2)begin
				radmap_din3_a1 <= radmap_din3_t1;
			end
			else begin
				radmap_din3_a1	<= radmap_din3_a1;
			end
		end
		else begin
			radmap_din3_a1	<= 16'd0;		
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_din3_a2	<= 16'd0;		
	end
	else begin
		if((clut_cpi >= 16'd117) && (clut_cpi <= 16'd120))begin
			radmap_din3_a2	<= 16'd0;
		end
		else if(radmap_avld_a0)begin
			if(radmap_din3_a0 >= radmap_din3_a1)begin
				radmap_din3_a2 <= radmap_din3_a0;
			end
			else if(radmap_din3_a1 > radmap_din3_a0)begin
				radmap_din3_a2 <= radmap_din3_a1;
			end
			else begin
				radmap_din3_a2	<= radmap_din3_a2;
			end
		end
		else begin
			radmap_din3_a2	<= 16'd0;
		end
	end
end

//3
always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_avld_b0	<= 1'b0;
		radmap_din_b0	<= 16'd0;		
	end
	else begin
		if(radmap_avld_a2)begin
			radmap_avld_b0	<= 1'b1;		
			if(radmap_din2_a2 >= radmap_din1_a2)begin
				radmap_din_b0 <= radmap_din2_a2;
			end
			else if(radmap_din1_a2 > radmap_din2_a2)begin
				radmap_din_b0 <= radmap_din1_a2;
			end
			else begin
				radmap_din_b0	<= radmap_din_b0;
			end
		end
		else begin
			radmap_avld_b0	<= 1'b0;
			radmap_din_b0	<= 16'd0;		
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_din_b1	<= 16'd0;		
	end
	else begin
		if(radmap_avld_a2)begin
			if(radmap_din3_a2 >= radmap_din2_a2)begin
				radmap_din_b1 <= radmap_din3_a2;
			end
			else if(radmap_din2_a2 > radmap_din3_a2)begin
				radmap_din_b1 <= radmap_din2_a2;
			end
			else begin
				radmap_din_b1	<= radmap_din_b1;
			end
		end
		else begin
			radmap_din_b1	<= 16'd0;
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_avld_b2	<= 1'b0;
		radmap_din_b2	<= 16'd0;		
	end
	else begin
		if(radmap_avld_b0)begin
			radmap_avld_b2	<= 1'b1;
			if(radmap_din_b0 >= radmap_din_b1)begin
				radmap_din_b2 <= radmap_din_b0;
			end
			else if(radmap_din_b1 > radmap_din_b0)begin
				radmap_din_b2 <= radmap_din_b1;
			end
			else begin
				radmap_din_b2	<= radmap_din_b2;
			end
		end
		else begin
			radmap_avld_b2	<= 1'b0;
			radmap_din_b2	<= 16'd0;
		end
	end
end

//out
always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		thresh_valid	<= 1'b0;
		thresh_dat		<= 16'd0;		
	end
	else begin
		if(radmap_avld_b2)begin
			thresh_valid	<= 1'b1;
			thresh_dat		<= radmap_din_b2;
		end
		else begin
			thresh_valid	<= 1'b0;
			thresh_dat		<= 16'd0;
		end
	end
end

	
endmodule

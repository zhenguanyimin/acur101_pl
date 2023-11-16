`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/04 16:44:52
// Design Name: 
// Module Name: spect_top
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
module spect_top(
    input					sys_clk			,
    input					rst_n			,	

	input					radmap_rd_vld	,
	input	[15:0]			radmap_rd_din2	,

	output 	reg				spect_valid		,
	output 	reg [15:0]		spect_dat		,			
	output 	reg				center_valid	,
	output 	reg	[15:0]		center_dat			
	
    );

/**********************************************************谱宽和中心频率计算************************************************/
parameter   radmap_sp = 5'd31;
reg [4:0]	radmap_vld_cnt0;
reg	[4:0]	radmap_vld_cnt1;
reg			radmap_a0_vld0;
reg [10:0]	radmap_sp_cnt;
reg [10:0]	radmap_sp_a0;
reg [10:0]	radmap_sp_a1;
reg [4:0]	radmap_sub_a0;
reg [4:0]	radmap_sub_a1;
reg	[15:0]	radmap_din2_a0;
reg	[15:0]	radmap_din2_a1;
reg			radmap_flag0;
reg			radmap_flag1;

reg			radmap_sub_vld0;
reg			radmap_sub_vld1;
reg			radmap_sub_vld2;
reg			radmap_sub_vld2_r;
reg	[10:0]	radmap_sp_t0;
reg	[10:0]	radmap_sp_t1;
reg	[10:0]	radmap_sp_t2;
reg	[4:0]	radmap_sub_t0;
reg	[4:0]	radmap_sub_t1;
reg	[4:0]	radmap_sub_t2;
reg	[15:0]	radmap_din2_t0;
reg	[15:0]	radmap_din2_t1;
reg	[15:0]	radmap_din2_t2;

reg 		center_clr_en;
reg [9:0]	center_clr_cnt;
reg 		center_clr;
reg	[11:0]	center_sp_cnt;
reg	[10:0]	center_sp;
reg	[4:0]	center_sub;

reg			radmap_add_vld0;
reg			radmap_add_vld1;
reg			radmap_add_vld2;
reg			radmap_add_vld3;
reg	[20:0]	radmap_add_t0;
reg	[20:0]	radmap_add_t1;
reg	[20:0]	radmap_add_t2;
reg	[20:0]	radmap_add_t3;
reg			center_add_vld;
reg			center_add_flag;
reg	[20:0]	center_add_din;

//
wire		spect_fifo_wr0;
wire		spect_fifo_full0;
wire [7:0]	spect_rd_count0;
wire [7:0]	spect_wr_count0;
reg			spect_fifo_rd_en0;
wire [15:0]	spect_fifo_dout0;
wire		spect_fifo_empty0;
wire		spect_fifo_wr1;
wire		spect_fifo_full1;
wire [7:0]	spect_rd_count1;
wire [7:0]	spect_wr_count1;
reg			spect_fifo_rd_en1;
wire [15:0]	spect_fifo_dout1;
wire		spect_fifo_empty1;

reg [4:0] 	spect_rd_cnt0;
reg [4:0] 	spect_rd_cnt1;
reg [4:0] 	spect_rd_addra0;
reg [4:0] 	spect_rd_addra1;
reg [4:0] 	spect_rd_addra2;
reg [4:0] 	spect_rd_addra3;
wire [15:0] spect_rd_dat0;
wire [15:0] spect_rd_dat1;
wire [15:0] spect_rd_dat2;
wire [15:0] spect_rd_dat3;

reg [4:0] 	spect_sub0;
reg [15:0] 	spect_dat0;
reg [20:0] 	spect_add_dat0;
reg [35:0] 	spect_mult_dat0;
reg [4:0] 	spect_sub1;
reg [15:0] 	spect_dat1;
reg [20:0] 	spect_add_dat1;
reg [35:0] 	spect_mult_dat1;

reg			spect_add0_en0;
reg			spect_add0_en1;
reg			spect_add0_en2;
reg			spect_add0_en3;
reg			spect_add0_en4;
reg			spect_add0_en5;
reg			spect_add0_en6;
reg			spect_add0_end0;
reg [4:0] 	spect_add0_cnt0;
reg [20:0] 	spect_add0_dat0;
reg [20:0] 	spect_add0_dat1;
reg [21:0] 	spect_add0_dat2;
reg [4:0] 	spect_width0_cnt0;
reg  		spect_width0_en1;
reg [4:0] 	spect_width0_cnt1;
reg 	 	spect_width0_clr0;

reg			spect_add1_en0;
reg			spect_add1_en1;
reg			spect_add1_en2;
reg			spect_add1_en3;
reg			spect_add1_en4;
reg			spect_add1_en5;
reg			spect_add1_en6;
reg			spect_add1_end0;
reg [4:0] 	spect_add1_cnt0;
reg [20:0] 	spect_add1_dat0;
reg [20:0] 	spect_add1_dat1;
reg [21:0] 	spect_add1_dat2;
reg [4:0] 	spect_width1_cnt0;
reg  		spect_width1_en1;
reg [4:0] 	spect_width1_cnt1;
reg 	 	spect_width1_clr0;

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_vld_cnt0	 <= 5'd0;	
	end
	else begin
		if(radmap_rd_vld)begin
			radmap_vld_cnt0	 <= radmap_vld_cnt0 + 1'b1;			
		end
		else begin
			radmap_vld_cnt0	 <= 5'd0;	
		end
	end
end	

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_flag0	 <= 1'b0;	
	end
	else begin
		if(radmap_vld_cnt0 == radmap_sp)begin
			radmap_flag0	 <= ~radmap_flag0;			
		end
		else begin
			radmap_flag0	 <= radmap_flag0;	
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_sp_cnt	 <= 11'd0;	
	end
	else begin
		if(center_clr)begin
			radmap_sp_cnt	 <= 11'd0;
		end
		else begin
			if(radmap_vld_cnt0 == radmap_sp)begin
				radmap_sp_cnt	 <= radmap_sp_cnt + 1'b1;			
			end
			else begin
				radmap_sp_cnt	 <= radmap_sp_cnt;	
			end
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_a0_vld0	<= 1'b0;
		radmap_sp_a0	<= 11'd0;
		radmap_sub_a0	<= 5'd0;
		radmap_din2_a0	<= 16'd0;		
	end
	else begin
		if(center_clr)begin
			radmap_a0_vld0	<= 1'b0;
			radmap_sp_a0	<= 11'd0;
			radmap_sub_a0	<= 5'd0;
			radmap_din2_a0	<= 16'd0;		
		end
		else if(radmap_rd_vld)begin
			radmap_a0_vld0	<= 1'b1;
			if((radmap_vld_cnt0 == 5'd10) && (radmap_flag0 == 1'b1))begin
				radmap_sp_a0	<= 11'd0;			
				radmap_sub_a0	<= 5'd0;
				radmap_din2_a0	<= 16'd0;				
			end
			else if((radmap_rd_din2 >= radmap_din2_a0) && (radmap_flag0 == 1'b0))begin
				radmap_sp_a0	<= radmap_sp_cnt;
				radmap_sub_a0	<= radmap_vld_cnt0;
				radmap_din2_a0	<= radmap_rd_din2;			
			end
			else begin
				radmap_sp_a0	<= radmap_sp_a0;
				radmap_sub_a0	<= radmap_sub_a0;
				radmap_din2_a0	<= radmap_din2_a0;
			end
		end
		else begin
			radmap_a0_vld0	<= 1'b0;
			radmap_sp_a0	<= radmap_sp_a0;
			radmap_sub_a0	<= radmap_sub_a0;
			radmap_din2_a0	<= radmap_din2_a0;
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_sp_a1	<= 11'd0;
		radmap_sub_a1	<= 5'd0;
		radmap_din2_a1	<= 16'd0;		
	end
	else begin
		if(center_clr)begin
			radmap_sp_a1	<= 11'd0;
			radmap_sub_a1	<= 5'd0;
			radmap_din2_a1	<= 16'd0;			
		end	
		else if(radmap_rd_vld)begin
			if((radmap_vld_cnt0 == 5'd10) && (radmap_flag0 == 1'b0))begin
				radmap_sp_a1	<= 11'd0;			
				radmap_sub_a1	<= 5'd0;
				radmap_din2_a1	<= 16'd0;				
			end		
			else if((radmap_rd_din2 >= radmap_din2_a1) && (radmap_flag0 == 1'b1))begin
				radmap_sp_a1	<= radmap_sp_cnt;
				radmap_sub_a1	<= radmap_vld_cnt0;
				radmap_din2_a1	<= radmap_rd_din2;			
			end
			else begin
				radmap_sp_a1	<= radmap_sp_a1;
				radmap_sub_a1	<= radmap_sub_a1;
				radmap_din2_a1	<= radmap_din2_a1;
			end
		end
		else begin
			radmap_sp_a1	<= radmap_sp_a1;
			radmap_sub_a1	<= radmap_sub_a1;
			radmap_din2_a1	<= radmap_din2_a1;
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_vld_cnt1	 <= 5'd0;	
	end
	else begin
		radmap_vld_cnt1	 <= radmap_vld_cnt0;			
	end
end	

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_flag1	 <= 1'b0;	
	end
	else begin
		radmap_flag1	 <= radmap_flag0;			
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_sub_vld0 <= 1'b0;
		radmap_sp_t0	<= 11'd0;
		radmap_sub_t0	<= 5'd0;
		radmap_din2_t0	<= 16'd0;			
	end
	else begin
		if(center_clr)begin
			radmap_sub_vld0 <= 1'b0;
			radmap_sp_t0	<= 11'd0;
			radmap_sub_t0	<= 5'd0;
			radmap_din2_t0	<= 16'd0;			
		end
		else  if(radmap_a0_vld0 && (radmap_vld_cnt1 == radmap_sp)  && (radmap_flag1 == 1'b0))begin
			radmap_sub_vld0 <= 1'b1;
			radmap_sp_t0	<= radmap_sp_a0;
			radmap_sub_t0	<= radmap_sub_a0;
			radmap_din2_t0	<= radmap_din2_a0;			
		end
		else begin
			radmap_sub_vld0 <= 1'b0;
			radmap_sp_t0	<= radmap_sp_t0;
			radmap_sub_t0	<= radmap_sub_t0;
			radmap_din2_t0	<= radmap_din2_t0;	
		end
	end
end	

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_sub_vld1 <= 1'b0;
		radmap_sp_t1	<= 11'd0;
		radmap_sub_t1	<= 5'd0;	
		radmap_din2_t1	<= 16'd0;			
	end
	else begin
		if(center_clr)begin
			radmap_sub_vld1 <= 1'b0;
			radmap_sp_t1	<= 11'd0;
			radmap_sub_t1	<= 5'd0;	
			radmap_din2_t1	<= 16'd0;			
		end	
		else if(radmap_a0_vld0 && (radmap_vld_cnt1 == radmap_sp)  && (radmap_flag1 == 1'b1))begin
			radmap_sub_vld1 <= 1'b1;
			radmap_sp_t1	<= radmap_sp_a1;
			radmap_sub_t1	<= radmap_sub_a1;
			radmap_din2_t1	<= radmap_din2_a1;			
		end
		else begin
			radmap_sub_vld1 <= 1'b0;
			radmap_sp_t1	<= radmap_sp_t1;
			radmap_sub_t1	<= radmap_sub_t1;
			radmap_din2_t1	<= radmap_din2_t1;	
		end
	end
end	

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_sub_vld2	<= 1'b0;
		radmap_sp_t2	<= 11'd0;
		radmap_sub_t2	<= 5'd0;
		radmap_din2_t2	<= 16'd0;		
	end
	else begin
		if(center_clr)begin
			radmap_sub_vld2	<= 1'b0;
			radmap_sp_t2	<= 11'd0;
			radmap_sub_t2	<= 5'd0;
			radmap_din2_t2	<= 16'd0;				
		end		
		else if(radmap_sub_vld0)begin
			radmap_sub_vld2	<= 1'b1;
			radmap_sp_t2	<= radmap_sp_t0;
			radmap_sub_t2	<= radmap_sub_t0;
			radmap_din2_t2	<= radmap_din2_t0;
		end
		else if(radmap_sub_vld1)begin
			radmap_sub_vld2	<= 1'b1;
			radmap_sp_t2	<= radmap_sp_t1;
			radmap_sub_t2	<= radmap_sub_t1;
			radmap_din2_t2	<= radmap_din2_t1;		
		end
		else begin
			radmap_sub_vld2	<= 1'b0;
			radmap_sp_t2	<= radmap_sp_t2;
			radmap_sub_t2	<= radmap_sub_t2;
			radmap_din2_t2	<= radmap_din2_t2;
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_sub_vld2_r	<= 1'b0;
	end
	else begin
		radmap_sub_vld2_r <= radmap_sub_vld2;
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		center_sp_cnt	<= 12'd0;
	end
	else begin
		if(center_clr)begin
			center_sp_cnt	<= 12'd0;				
		end	
		else if(radmap_sub_vld2)begin
			center_sp_cnt <= center_sp_cnt + 1'b1;
		end
		else begin
			center_sp_cnt <= center_sp_cnt;
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		center_clr_en	<= 1'b0;
		center_clr		<= 1'b0;
	end
	else begin
		if(center_clr_cnt >= 10'd200)begin
			center_clr_en	<= 1'b0;
			center_clr		<= 1'b1;
		end
		else begin
			center_clr		<= 1'b0;
			if((center_sp_cnt == 12'd2048) && radmap_sub_vld2_r)begin
				center_clr_en	<= 1'b1;
			end
			else begin
				center_clr_en <= center_clr_en;
			end
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		center_clr_cnt	<= 10'd0;
	end
	else begin
		if(center_clr_en)begin
			center_clr_cnt	<= center_clr_cnt + 1'b1;
		end
		else begin
			center_clr_cnt	<= 10'd0;
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		center_valid	<= 1'b0;
		center_sp		<= 11'd0;
		center_sub		<= 5'd0;
		center_dat		<= 16'd0;
	end
	else begin
		if(radmap_sub_vld2)begin
			center_valid	<= 1'b1;
			center_sp		<= radmap_sp_t2;
			center_sub		<= radmap_din2_t2[4:0];
			center_dat		<= {11'b0,radmap_sub_t2};
		end
		else begin
			center_valid	<= 1'b0;
			center_sp		<= center_sp;  
			center_sub		<= center_sub; 
			center_dat		<= center_dat;
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_add_vld0	<= 1'b0;
		radmap_add_t0	<= 21'd0;		
	end
	else begin
		if(center_clr)begin
			radmap_add_vld0	<= 1'b0;
			radmap_add_t0	<= 21'd0;	
		end
		else if(radmap_rd_vld && (radmap_vld_cnt0 == 5'd10) && (radmap_flag0 == 1'b1))begin
			radmap_add_vld0	<= 1'b0;
			radmap_add_t0	<= 21'd0;				
		end
		else if(radmap_rd_vld && (radmap_flag0 == 1'b0))begin
			radmap_add_vld0	<= 1'b1;
			radmap_add_t0	<= radmap_add_t0 + radmap_rd_din2;
		end
		else begin
			radmap_add_vld0	<= 1'b0;
			radmap_add_t0	<= radmap_add_t0;
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_add_vld1	<= 1'b0;
		radmap_add_t1	<= 21'd0;		
	end
	else begin
		if(center_clr)begin
			radmap_add_vld1	<= 1'b0;
			radmap_add_t1	<= 21'd0;	
		end
		else if(radmap_rd_vld && (radmap_vld_cnt0 == 5'd10) && (radmap_flag0 == 1'b0))begin
			radmap_add_vld1	<= 1'b0;
			radmap_add_t1	<= 21'd0;					
		end		
		else if(radmap_rd_vld && (radmap_flag0 == 1'b1))begin
			radmap_add_vld1	<= 1'b1;
			radmap_add_t1	<= radmap_add_t1 + radmap_rd_din2;
		end
		else begin
			radmap_add_vld1	<= 1'b0;
			radmap_add_t1	<= radmap_add_t1;
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_add_vld2	<= 1'b0;
		radmap_add_t2	<= 21'd0;		
	end
	else begin
		if(center_clr)begin
			radmap_add_vld2	<= 1'b0;
			radmap_add_t2	<= 21'd0;	
		end
		else if(radmap_add_vld0 && (radmap_vld_cnt1 == radmap_sp))begin
			radmap_add_vld2	<= 1'b1;
			radmap_add_t2	<= radmap_add_t0;
		end
		else begin
			radmap_add_vld2	<= 1'b0;
			radmap_add_t2	<= radmap_add_t2;
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_add_vld3	<= 1'b0;
		radmap_add_t3	<= 21'd0;		
	end
	else begin
		if(center_clr)begin
			radmap_add_vld3	<= 1'b0;
			radmap_add_t3	<= 21'd0;	
		end
		else if(radmap_add_vld1 && (radmap_vld_cnt1 == radmap_sp))begin
			radmap_add_vld3	<= 1'b1;
			radmap_add_t3	<= radmap_add_t1;
		end
		else begin
			radmap_add_vld3	<= 1'b0;
			radmap_add_t3	<= radmap_add_t3;
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		center_add_vld	<= 1'b0;
		center_add_flag <= 1'b0;
		center_add_din	<= 21'd0;		
	end
	else begin
		if(radmap_add_vld2)begin
			center_add_vld	<= 1'b1;
			center_add_flag <= ~center_add_flag;
			center_add_din	<= radmap_add_t2;	
		end
		else if(radmap_add_vld3)begin
			center_add_vld	<= 1'b1;
			center_add_flag <= ~center_add_flag;
			center_add_din	<= radmap_add_t3;
		end
		else begin
			center_add_vld	<= 1'b0;
			center_add_flag <= center_add_flag;
			center_add_din	<= center_add_din;
		end
	end
end


/******************************谱宽*********************************/
assign	spect_fifo_wr0 = (radmap_rd_vld && (radmap_flag0 == 1'b0)) ? 1'b1 : 1'b0;
assign	spect_fifo_wr1 = (radmap_rd_vld && (radmap_flag0 == 1'b1)) ? 1'b1 : 1'b0;

cult2_data_fifo  u_cult2_data_fifo0(
  .rst			( ~rst_n				),
  .wr_clk		( sys_clk 		   		),
  .din			( radmap_rd_din2     	),
  .wr_en		( spect_fifo_wr0		),
  .full			( spect_fifo_full0    	),
  .rd_data_count( spect_rd_count0		),
  .wr_data_count( spect_wr_count0  		),
  .rd_clk		( sys_clk       		),
  .rd_en		( spect_fifo_rd_en0    	),
  .dout			( spect_fifo_dout0     	),
  .empty		( spect_fifo_empty0    	)
  
);
cult2_data_fifo  u_cult2_data_fifo1(
  .rst			( ~rst_n				),
  .wr_clk		( sys_clk 		   		),
  .din			( radmap_rd_din2     	),
  .wr_en		( spect_fifo_wr1   		),
  .full			( spect_fifo_full1    	),
  .rd_data_count( spect_rd_count1		),
  .wr_data_count( spect_wr_count1  		),
  .rd_clk		( sys_clk       		),
  .rd_en		( spect_fifo_rd_en1    	),
  .dout			( spect_fifo_dout1     	),
  .empty		( spect_fifo_empty1    	)
  
);

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		spect_fifo_rd_en0	 <= 1'b0;	
	end
	else begin
		if(spect_rd_cnt0 == radmap_sp)begin
			spect_fifo_rd_en0	 <= 1'b0;
		end
		else begin
				if(center_add_vld && (center_add_flag == 1'b1))begin
					spect_fifo_rd_en0	 <=  1'b1;			
				end
				else begin
					spect_fifo_rd_en0	 <= spect_fifo_rd_en0;	
				end
			end
	end
end	

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		spect_rd_cnt0	 <= 5'd0;	
	end
	else begin
		if(spect_fifo_rd_en0)begin
			spect_rd_cnt0	 <= spect_rd_cnt0 + 1'b1;			
		end
		else begin
			spect_rd_cnt0	 <= 5'd0;	
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		spect_fifo_rd_en1	 <= 1'b0;	
	end
	else begin
		if(spect_rd_cnt1 == radmap_sp)begin
			spect_fifo_rd_en1	 <= 1'b0;
		end
		else begin
				if(center_add_vld && (center_add_flag == 1'b0))begin
					spect_fifo_rd_en1	 <=  1'b1;			
				end
				else begin
					spect_fifo_rd_en1	 <= spect_fifo_rd_en1;	
				end
			end
	end
end	

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		spect_rd_cnt1	 <= 5'd0;	
	end
	else begin
		if(spect_fifo_rd_en1)begin
			spect_rd_cnt1	 <= spect_rd_cnt1 + 1'b1;			
		end
		else begin
			spect_rd_cnt1	 <= 5'd0;	
		end
	end
end

blk_mem_map1 u_blk_mem_spec0(
	.clka							(	sys_clk		 		),    			// input wire clka
	.wea							(	spect_fifo_rd_en0	),      		// input wire [0  : 0] wea
	.addra							(	spect_rd_cnt0 		),  			// input wire [4 : 0] addra
	.dina							(	spect_fifo_dout0	),    			// input wire [15 : 0] dina
	.clkb							(	sys_clk				),    			// input wire clkb
	.enb							(	1'b1				),      		// input wire enb
	.addrb							(	spect_rd_addra0		),  			// input wire [4  : 0] addrb
	.doutb							(	spect_rd_dat0		) 	 			// output wire [15 : 0] doutb
);	

blk_mem_map1 u_blk_mem_spec1(
	.clka							(	sys_clk		 		),    			// input wire clka
	.wea							(	spect_fifo_rd_en0	),      		// input wire [0  : 0] wea
	.addra							(	spect_rd_cnt0 		),  			// input wire [4 : 0] addra
	.dina							(	spect_fifo_dout0	),    			// input wire [15 : 0] dina
	.clkb							(	sys_clk				),    			// input wire clkb
	.enb							(	1'b1				),      		// input wire enb
	.addrb							(	spect_rd_addra1		),  			// input wire [4  : 0] addrb
	.doutb							(	spect_rd_dat1		) 	 			// output wire [15 : 0] doutb
);	

blk_mem_map1 u_blk_mem_spec2(
	.clka							(	sys_clk		 		),    			// input wire clka
	.wea							(	spect_fifo_rd_en1	),      		// input wire [0  : 0] wea
	.addra							(	spect_rd_cnt1 		),  			// input wire [4 : 0] addra
	.dina							(	spect_fifo_dout1	),    			// input wire [15 : 0] dina
	.clkb							(	sys_clk				),    			// input wire clkb
	.enb							(	1'b1				),      		// input wire enb
	.addrb							(	spect_rd_addra2		),  			// input wire [4  : 0] addrb
	.doutb							(	spect_rd_dat2		) 	 			// output wire [15 : 0] doutb
);	

blk_mem_map1 u_blk_mem_spec3(
	.clka							(	sys_clk		 		),    			// input wire clka
	.wea							(	spect_fifo_rd_en1	),      		// input wire [0  : 0] wea
	.addra							(	spect_rd_cnt1 		),  			// input wire [4 : 0] addra
	.dina							(	spect_fifo_dout1	),    			// input wire [15 : 0] dina
	.clkb							(	sys_clk				),    			// input wire clkb
	.enb							(	1'b1				),      		// input wire enb
	.addrb							(	spect_rd_addra3		),  			// input wire [4  : 0] addrb
	.doutb							(	spect_rd_dat3		) 	 			// output wire [15 : 0] doutb
);	

//p
always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		spect_sub0	 	<= 5'd0;
		spect_dat0	 	<= 16'd0;
		spect_add_dat0	<= 21'd0;		
	end
	else begin
		if(spect_rd_cnt0 == 5'd5)begin
			spect_sub0	 	<= center_sub;
			spect_dat0	 	<= center_dat;
			spect_add_dat0	<= center_add_din;			
		end
		else begin
			spect_sub0	 	<= spect_sub0;
			spect_dat0	 	<= spect_dat0;
			spect_add_dat0	<= spect_add_dat0;
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		spect_mult_dat0	<= 36'd0;		
	end
	else begin
		spect_mult_dat0	<= spect_add_dat0 * 9544/10000;	//细微的误差，需考虑
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		spect_add0_en0	<= 1'b0;		
	end
	else begin
		if(spect_add0_end0)begin
			spect_add0_en0	<= 1'b0;
		end
		else begin
			if(spect_fifo_rd_en0 && (spect_rd_cnt0 == 5'd31))begin
				spect_add0_en0	<= 1'b1;		
			end
			else begin
				spect_add0_en0	<= spect_add0_en0;
			end
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		spect_add0_en1	<= 1'b0;
		spect_add0_cnt0	<= 5'd0;		
	end
	else begin
		if(spect_add0_end0)begin
			spect_add0_en1	<= 1'b0;
			spect_add0_cnt0	<= 5'd0;			
		end
		else begin
			if(spect_add0_en0)begin
				spect_add0_en1	<= 1'b1;
				spect_add0_cnt0	<= spect_add0_cnt0 + 1'b1;		
			end
			else begin
				spect_add0_en1	<= 1'b0;
				spect_add0_cnt0	<= 5'd0;
			end
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		spect_add0_en2	<= 1'b0;
		spect_rd_addra0	<= 5'd0;		
	end
	else begin
		if(spect_add0_end0)begin
			spect_add0_en2	<= 1'b0;
			spect_rd_addra0	<= 5'd0;		
		end
		else begin
			if(spect_add0_en1)begin
				spect_add0_en2	<= 1'b1;
				spect_rd_addra0	<= spect_sub0 - spect_add0_cnt0;		
			end
			else begin
				spect_add0_en2	<= 1'b0;
				spect_rd_addra0	<= 5'd0;
			end
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		spect_rd_addra1	<= 5'd0;		
	end
	else begin
		if(spect_add0_end0)begin
			spect_rd_addra1	<= 5'd0;			
		end
		else begin
			if(spect_add0_en1)begin
				spect_rd_addra1	<= spect_sub0 + spect_add0_cnt0;		
			end
			else begin
				spect_rd_addra1	<= 5'd0;
			end
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		spect_add0_en3	<= 1'b0;
		spect_add0_en4	<= 1'b0;		
	end
	else begin
		if(spect_add0_end0)begin
			spect_add0_en3	<= 1'b0;
			spect_add0_en4	<= 1'b0;		
		end
		else begin
			spect_add0_en3	<= spect_add0_en2;
			spect_add0_en4	<= spect_add0_en3;
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		spect_add0_en5	<= 1'b0;	
		spect_add0_dat0	<= 21'd0;		
	end
	else begin
		if(spect_add0_end0)begin
			spect_add0_en5	<= 1'b0;	
			spect_add0_dat0	<= 21'd0;			
		end
		else begin
			if(spect_add0_en4)begin
				spect_add0_en5	<= 1'b1;		
				spect_add0_dat0	<= spect_add0_dat0 + spect_rd_dat0;		
			end
			else begin
				spect_add0_en5	<= 1'b0;		
				spect_add0_dat0	<= 21'd0;
			end
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		spect_add0_dat1	<= 21'd0;		
	end
	else begin
		if(spect_add0_end0)begin
			spect_add0_dat1	<= 21'd0;		
		end
		else begin
			if(spect_add0_en4)begin
				spect_add0_dat1	<= spect_add0_dat1 + spect_rd_dat1;		
			end
			else begin
				spect_add0_dat1	<= 21'd0;
			end
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		spect_add0_en6	<= 1'b0;
		spect_add0_dat2	<= 22'd0;		
	end
	else begin
		if(spect_add0_end0)begin
			spect_add0_en6	<= 1'b0;
			spect_add0_dat2	<= 22'd0;		
		end
		else begin
			if(spect_add0_en5)begin
				spect_add0_en6	<= 1'b1;
				spect_add0_dat2	<= spect_dat0 + spect_add0_dat0 + spect_add0_dat1;		
			end
			else begin
				spect_add0_en6	<= 1'b0;			
				spect_add0_dat2	<= 22'd0;
			end
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		spect_add0_end0	<= 1'b0;	
	end
	else begin
		if(spect_add0_en6 && (spect_add0_dat2 >= spect_mult_dat0))begin
			spect_add0_end0	<= 1'b1;			
		end
		else begin
			spect_add0_end0	<= 1'b0;
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		spect_width0_cnt0	<= 5'd0;	
	end
	else begin
		if(spect_width0_clr0)begin
			spect_width0_cnt0	<= 5'd0;		
		end
		else begin
			if(spect_add0_en6 && (spect_add0_end0 == 1'b0))begin
				spect_width0_cnt0	<= spect_width0_cnt0 + 1'b1;			
			end
			else begin
				spect_width0_cnt0	<= spect_width0_cnt0;
			end
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		spect_width0_en1		<= 1'b0;
		spect_width0_cnt1	<= 5'd0;	
	end
	else begin
		if((spect_add0_en6 == 1'b0) && spect_add0_end0)begin 
			spect_width0_en1		<= 1'b1;
			spect_width0_cnt1	<= spect_width0_cnt0;			
		end
		else begin
			spect_width0_en1		<= 1'b0;
			spect_width0_cnt1	<= spect_width0_cnt1;
		end
	end
end

//q
always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		spect_sub1	 	<= 5'd0;
		spect_dat1	 	<= 16'd0;
		spect_add_dat1	<= 21'd0;		
	end
	else begin
		if(spect_rd_cnt1 == 5'd5)begin
			spect_sub1	 	<= center_sub;
			spect_dat1	 	<= center_dat;
			spect_add_dat1	<= center_add_din;			
		end
		else begin
			spect_sub1	 	<= spect_sub1;
			spect_dat1	 	<= spect_dat1;
			spect_add_dat1	<= spect_add_dat1;
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		spect_mult_dat1	<= 36'd0;		
	end
	else begin
		spect_mult_dat1	<= spect_add_dat1 * 9544/10000;	//细微的误差，需考虑
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		spect_add1_en0	<= 1'b0;		
	end
	else begin
		if(spect_add1_end0)begin
			spect_add1_en0	<= 1'b0;
		end
		else begin
			if(spect_fifo_rd_en1 && (spect_rd_cnt1 == 5'd31))begin
				spect_add1_en0	<= 1'b1;		
			end
			else begin
				spect_add1_en0	<= spect_add1_en0;
			end
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		spect_add1_en1	<= 1'b0;
		spect_add1_cnt0	<= 5'd0;		
	end
	else begin
		if(spect_add1_end0)begin
			spect_add1_en1	<= 1'b0;
			spect_add1_cnt0	<= 5'd0;			
		end
		else begin
			if(spect_add1_en0)begin
				spect_add1_en1	<= 1'b1;
				spect_add1_cnt0	<= spect_add1_cnt0 + 1'b1;		
			end
			else begin
				spect_add1_en1	<= 1'b0;
				spect_add1_cnt0	<= 5'd0;
			end
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		spect_add1_en2	<= 1'b0;
		spect_rd_addra2	<= 5'd0;		
	end
	else begin
		if(spect_add1_end0)begin
			spect_add1_en2	<= 1'b0;
			spect_rd_addra2	<= 5'd0;		
		end
		else begin
			if(spect_add1_en1)begin
				spect_add1_en2	<= 1'b1;
				spect_rd_addra2	<= spect_sub1 - spect_add1_cnt0;		
			end
			else begin
				spect_add1_en2	<= 1'b0;
				spect_rd_addra2	<= 5'd0;
			end
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		spect_rd_addra3	<= 5'd0;		
	end
	else begin
		if(spect_add1_end0)begin
			spect_rd_addra3	<= 5'd0;			
		end
		else begin
			if(spect_add1_en1)begin
				spect_rd_addra3	<= spect_sub1 + spect_add1_cnt0;		
			end
			else begin
				spect_rd_addra3	<= 5'd0;
			end
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		spect_add1_en3	<= 1'b0;
		spect_add1_en4	<= 1'b0;		
	end
	else begin
		if(spect_add1_end0)begin
			spect_add1_en3	<= 1'b0;
			spect_add1_en4	<= 1'b0;		
		end
		else begin
			spect_add1_en3	<= spect_add1_en2;
			spect_add1_en4	<= spect_add1_en3;
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		spect_add1_en5	<= 1'b0;	
		spect_add1_dat0	<= 21'd0;		
	end
	else begin
		if(spect_add1_end0)begin
			spect_add1_en5	<= 1'b0;	
			spect_add1_dat0	<= 21'd0;			
		end
		else begin
			if(spect_add1_en4)begin
				spect_add1_en5	<= 1'b1;		
				spect_add1_dat0	<= spect_add1_dat0 + spect_rd_dat2;		
			end
			else begin
				spect_add1_en5	<= 1'b0;		
				spect_add1_dat0	<= 21'd0;
			end
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		spect_add1_dat1	<= 21'd0;		
	end
	else begin
		if(spect_add1_end0)begin
			spect_add1_dat1	<= 21'd0;		
		end
		else begin
			if(spect_add1_en4)begin
				spect_add1_dat1	<= spect_add1_dat1 + spect_rd_dat3;		
			end
			else begin
				spect_add1_dat1	<= 21'd0;
			end
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		spect_add1_en6	<= 1'b0;
		spect_add1_dat2	<= 22'd0;		
	end
	else begin
		if(spect_add1_end0)begin
			spect_add1_en6	<= 1'b0;
			spect_add1_dat2	<= 22'd0;		
		end
		else begin
			if(spect_add1_en5)begin
				spect_add1_en6	<= 1'b1;
				spect_add1_dat2	<= spect_dat1 + spect_add1_dat0 + spect_add1_dat1;		
			end
			else begin
				spect_add1_en6	<= 1'b0;			
				spect_add1_dat2	<= 22'd0;
			end
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		spect_add1_end0	<= 1'b0;	
	end
	else begin
		if(spect_add1_en6 && (spect_add1_dat2 >= spect_mult_dat1))begin
			spect_add1_end0	<= 1'b1;			
		end
		else begin
			spect_add1_end0	<= 1'b0;
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		spect_width1_cnt0	<= 5'd0;	
	end
	else begin
		if(spect_width1_clr0)begin
			spect_width1_cnt0	<= 5'd0;		
		end
		else begin
			if(spect_add1_en6 && (spect_add1_end0 == 1'b0))begin
				spect_width1_cnt0	<= spect_width1_cnt0 + 1'b1;			
			end
			else begin
				spect_width1_cnt0	<= spect_width1_cnt0;
			end
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		spect_width1_en1	<= 1'b0;
		spect_width1_cnt1	<= 5'd0;	
	end
	else begin
		if((spect_add1_en6 == 1'b0) && spect_add1_end0)begin 
			spect_width1_en1	<= 1'b1;
			spect_width1_cnt1	<= spect_width1_cnt0;			
		end
		else begin
			spect_width1_en1	<= 1'b0;
			spect_width1_cnt1	<= spect_width1_cnt1;
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		spect_width0_clr0 	<= 1'b0;
		spect_width1_clr0 	<= 1'b0;
		spect_valid			<= 1'b0;
		spect_dat			<= 16'd0;	
	end
	else begin
		if(spect_width0_en1)begin 
			spect_width0_clr0 	<= 1'b1;		
			spect_valid			<= 1'b1;
			spect_dat			<= spect_width0_cnt1*2;		
		end
		else if(spect_width1_en1)begin
			spect_width1_clr0 	<= 1'b1;		
			spect_valid			<= 1'b1;
			spect_dat			<= spect_width1_cnt1*2;
		end
		else begin
			spect_width0_clr0 	<= 1'b0;
			spect_width1_clr0 	<= 1'b0;		
			spect_valid			<= 1'b0;
			spect_dat			<= spect_dat;
		end
	end
end


endmodule

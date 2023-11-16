`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/04 16:44:52
// Design Name: 
// Module Name: clutter_map_top
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
// 杂波图建立和更新
//////////////////////////////////////////////////////////////////////////////////
module clutter_map_top(
    input				sys_clk			,//
    input				rst_n			,//
	
    input				clut_in_valid	,//输入使能
    input	[15:0] 		clut_in_data	,//输入一帧数据格式：距离0：0-31   距离1：0-31   距离2：0-31   ......  距离2047：0-31速度
	input	[15:0]		clut_cpi		,//TWS模式波位号，范围1-120	
	input	[15:0]		recur_coeff		,//递归滤波器系数(0-1)*1000
	input	[7:0]		cult_mode		,//模式选择：0-TWS   1-TAS	
	input	[7:0]		cult_sch_sw		,//方案切换：0-正式方案     1-预留方案10波位滑窗运算

	input	[15:0]		clut_tas_cpi	,//TAS模式波位号
	input	[7:0]		clut_tas_ary	,//TAS模式边界 0-单独波位    1-两波位之间
	input	[15:0]		clut_tas_inr	,//TAS模式插值(0-1)*1000	
	
	//命令
    output           	fifo_wr_en_cmd  ,//写DDR命令使能------写命令和写数据对齐
    input            	fifo_full_cmd   ,//写DDR命令有效------0:写有效   1:写无效
    output  [63:0] 		fifo_din_cmd    ,//写DDR命令数据 [63]:W-0/R-1+[62:61]:RSV+[60:12]:地址段+[11:0]长度字段  len  

	//数据
    output           	fifo_wr_en_wr   ,//写DDR使能--------写使能和写数据对齐
	input	 		 	fifo_wr_full	,//写DDR数据有效----0:写有效   1:写无效
    output  [127:0]		fifo_din_wr     ,//写DDR数据
	
    output           	fifo_read_en    ,//读DDR使能--------读使能和读数据对齐
    input            	fifo_read_empty ,//读DDR数据有效----0:读有效   1:读无效
    input  	[127:0]		fifo_read_data  ,//读DDR数据
	
	output	reg			thresh_valid	,//算法输出门限值有效
	output	reg [15:0]	thresh_dat		,//算法输出门限值数据
	output				spect_valid		,//算法输出谱宽有效
	output	[15:0]		spect_dat		,//算法输出谱宽数据
	output				center_valid	,//算法输出中心频率有效
	output	[15:0]		center_dat		 //算法输出中心频率数据
	
    );

/************************************************************************************/
//杂波图建立和更新模块：正常模式数据量：30*4*32*2048*2*8/1024/1024 = 120Mbit=15Mbyte
//30：	方位总计30个波位
//4： 	俯仰共计4个波位
//32：	速度维共计32个滤波器通道
//2048：距离共计2048个距离单元
//2：	若每个杂波单元的幅度以两个字节存储
//		共计120个波位的数据
/************************************************************************************/
//杂波图建立和更新模块：预留模式数据量：10*32*2048*2*8/1024 = 10Mbit
//10个波位滑窗存储  
/************************************************************************************/
reg		[3:0] 		clut_r1_sysclk;
reg		[15:0]		clut_cpi_reg;
reg		[15:0]		recur_coeff_reg;
reg		[7:0]		cult_mode_reg;
reg		[7:0]		cult_sch_sw_reg;
reg		[15:0]		clut_tas_cpi_reg;
reg		[7:0]		clut_tas_ary_reg;
reg		[15:0]		clut_tas_inr_reg;
wire				radmap_rd_vld;
wire 	[15:0]		radmap_rd_din0;	
wire	[15:0]		radmap_rd_din1;	
wire	[15:0]		radmap_rd_din2;	
wire	[15:0]		radmap_rd_din3;
wire 				recur_valid;
wire 	[15:0]		recur_dat;
wire 				thresh_tas_valid;
wire 	[15:0]		thresh_tas_dat;
wire 				thresh_tws_valid;
wire 	[15:0]		thresh_tws_dat;
wire 	[15:0]		clut_cpi_t;	

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		clut_r1_sysclk	<=	4'b0;
	end
	else begin
		clut_r1_sysclk	<=	{clut_r1_sysclk[2:0],clut_in_valid};
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		clut_cpi_reg	<=	16'd0;
		recur_coeff_reg	<=	16'd0;	
		cult_mode_reg	<=	8'd0;
		cult_sch_sw_reg	<=	8'd0;
		
		clut_tas_cpi_reg<=	16'd0;
		clut_tas_ary_reg<=	8'd0;
		clut_tas_inr_reg<=	16'd0;		
	end
	else begin
		if(clut_r1_sysclk == 4'b0011)begin
			clut_cpi_reg	<=	clut_cpi;
			recur_coeff_reg	<=	recur_coeff;		
			cult_mode_reg	<=	cult_mode;
			cult_sch_sw_reg	<=	cult_sch_sw;
			
			clut_tas_cpi_reg<=	clut_tas_cpi;
			clut_tas_ary_reg<=	clut_tas_ary;
			clut_tas_inr_reg<=	clut_tas_inr;			
		end
		else begin
			clut_cpi_reg	<=	clut_cpi_reg;
			recur_coeff_reg	<=	recur_coeff_reg;			
			cult_mode_reg	<=	cult_mode_reg;
			cult_sch_sw_reg	<=	cult_sch_sw_reg;
			
			clut_tas_cpi_reg<=	clut_tas_cpi_reg;
			clut_tas_ary_reg<=	clut_tas_ary_reg;
			clut_tas_inr_reg<=	clut_tas_inr_reg;			
		end
	end
end	

//接口控制
clutter_ctrl u_clutter_ctrl
	(
    .sys_clk		 ( sys_clk			),
    .rst_n			 ( rst_n			),

    .clut_in_valid	 ( clut_in_valid	),
    .clut_in_data	 ( clut_in_data		),
	.clut_cpi	 	 ( clut_cpi_reg		),
	.cult_mode		 ( cult_mode_reg	),
	.cult_sch_sw	 ( cult_sch_sw_reg	),
	.clut_tas_cpi	 ( clut_tas_cpi_reg	),
	
    .fifo_wr_en_cmd  ( fifo_wr_en_cmd	),
    .fifo_full_cmd   ( fifo_full_cmd	),	
    .fifo_din_cmd    ( fifo_din_cmd		), 

	
    .fifo_wr_en_wr   ( fifo_wr_en_wr	),
	.fifo_wr_full	 ( fifo_wr_full		),
    .fifo_din_wr     ( fifo_din_wr		),
	
    .fifo_read_en    ( fifo_read_en		),
	.fifo_read_testen( 	),
    .fifo_read_empty ( fifo_read_empty	),
    .fifo_read_data  ( fifo_read_data	),
	
	.clut_cpi_t		 ( clut_cpi_t		),
	
	.radmap_rd_vld	 ( radmap_rd_vld	),
	.radmap_rd_din0	 ( radmap_rd_din0	),
	.radmap_rd_din1	 ( radmap_rd_din1	),
	.radmap_rd_din2	 ( radmap_rd_din2	),
	.radmap_rd_din3	 ( radmap_rd_din3	),
	
	.recur_valid	 ( recur_valid		),
	.recur_dat		 ( recur_dat		)
    );


//一阶递归运算
recur_oper u_recur_oper
	(
    .sys_clk		( sys_clk			),
    .rst_n			( rst_n				),
	.recur_coeff	( recur_coeff_reg	),

    .radmap_rd_vld	( radmap_rd_vld		),
    .radmap_rd_din0	( radmap_rd_din0	),
	.radmap_rd_din2	( radmap_rd_din2	),

	.recur_valid	( recur_valid		),
	.recur_dat		( recur_dat			)	
    );

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		thresh_valid	<= 1'b0;
		thresh_dat		<= 16'd0;
	end
	else begin
		if((cult_mode_reg == 8'd1) && (clut_cpi_reg == clut_tas_cpi_reg))begin
			thresh_valid	<= thresh_tws_valid;
			thresh_dat		<= thresh_tws_dat;
		end
		else if((cult_mode_reg == 8'd1) && (clut_cpi_reg != clut_tas_cpi_reg)) begin
			thresh_valid	<= thresh_tas_valid;
			thresh_dat		<= thresh_tas_dat;	
		end
		else begin
			thresh_valid	<= thresh_tws_valid;
			thresh_dat		<= thresh_tws_dat;				
		end
	end
end	

//TAS-门限计算
thresh_tas_top u_thresh_tas_top
	(
    .sys_clk		( sys_clk			),
    .rst_n			( rst_n				),
	.clut_tas_ary	( clut_tas_ary_reg	),
	.clut_tas_inr	( clut_tas_inr_reg	),	

    .radmap_rd_vld	( radmap_rd_vld		),
	.radmap_rd_din1	( radmap_rd_din1	),
	.radmap_rd_din2	( radmap_rd_din2	),
	.radmap_rd_din3	( radmap_rd_din3	),	

	.thresh_valid	( thresh_tas_valid	),
	.thresh_dat		( thresh_tas_dat	)
		
    );

//TWS-门限计算
thresh_top u_thresh_top
	(
    .sys_clk		( sys_clk			),
    .rst_n			( rst_n				),
	.clut_cpi		( clut_cpi_t 		),

    .radmap_rd_vld	( radmap_rd_vld		),
	.radmap_rd_din1	( radmap_rd_din1	),
	.radmap_rd_din2	( radmap_rd_din2	),
	.radmap_rd_din3	( radmap_rd_din3	),	

	.thresh_valid	( thresh_tws_valid	),
	.thresh_dat		( thresh_tws_dat	)
		
    );

//谱宽和中频频率
spect_top u_spect_top
	(
    .sys_clk		( sys_clk			),
    .rst_n			( rst_n				),

    .radmap_rd_vld	( radmap_rd_vld		),
	.radmap_rd_din2	( radmap_rd_din2	),	

    .spect_valid	( spect_valid		),
	.spect_dat		( spect_dat			), 
    .center_valid	( center_valid		),
	.center_dat		( center_dat		) 	
	
    );

endmodule

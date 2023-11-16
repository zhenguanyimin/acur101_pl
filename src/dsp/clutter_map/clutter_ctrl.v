`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/04 16:44:52
// Design Name: 
// Module Name: clutter_ctrl
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
module clutter_ctrl(
    input					sys_clk			,
    input					rst_n			,		
	
    input					clut_in_valid	,
    input	[15:0] 			clut_in_data	,	
	input	[15:0] 			clut_cpi		,
	input	[7:0] 			cult_mode		,
	input	[7:0] 			cult_sch_sw		,
	input	[15:0] 			clut_tas_cpi	,	
	
	//CMD
    output  reg         	fifo_wr_en_cmd  ,
    input            		fifo_full_cmd   ,	
    output  reg  [63:0] 	fifo_din_cmd    ,

	//DATA
    output  reg         	fifo_wr_en_wr   ,
	input	 		 		fifo_wr_full	,
    output  reg [127:0]		fifo_din_wr     ,
	
    output           		fifo_read_en    ,
	output					fifo_read_testen,
    input            		fifo_read_empty ,
    input  	[127:0]			fifo_read_data	,

	output	[15:0] 			clut_cpi_t		,
	
	output	reg				radmap_rd_vld,
	output	reg [15:0]		radmap_rd_din0,	
	output	reg [15:0]		radmap_rd_din1,	
	output	reg [15:0]		radmap_rd_din2,	
	output	reg [15:0]		radmap_rd_din3,

	input					recur_valid,
	input	 [15:0]			recur_dat
	
    );


/*******************************************************************杂波图建立和更新-接口控制***********************************************************/
parameter       base_addr0 = 49'h0000_7000_0000;//BASE  ADDR:0x7000_0000~0x7fff_ffff
parameter       base_addr1 = 49'h0000_7100_0000;//BASE  ADDR:0x7000_0000~0x7fff_ffff
reg		[48:0]	base_addr;

parameter   	cult_length 	=  17'd65536;
parameter   	radmap_length 	=  16'd65535;
parameter   	clut0_wr_length =  16'd2048;

reg		[3:0] 	clut_r1_sysclk;
wire			clut_up_sysclk;
reg		[15:0]	clut_cpi_reg;
reg		[15:0] 	clut_cpi_rg;
reg		[15:0] 	clut_cpi_b;
reg		[3:0] 	clut_r2_sysclk;
wire			clut_down_sysclk;
reg		[3:0]	cult_first_flag;
reg				radmap_rd0_flag0;

reg [2:0] 		state0;
reg				clut0_fifo_rd;
reg				clut0_axis_tlast;
reg	[15:0] 		clut0_rd_cnt0;
reg	[15:0] 		clut0_rd_cnt1;
reg	[7:0] 		clut0_cmd_cnt;
reg [7:0]		clut0_addr_cnt;

reg [2:0] 		state1;
reg				clut1_fifo_rd;
reg				clut1_fifo_rd1;
reg				clut1_fifo_rd2;
reg				clut1_axis_tlast;
reg	[15:0] 		clut1_rd_cnt0;
reg	[15:0] 		clut1_rd_cnt1;
reg	[7:0] 		clut1_cmd_cnt;
reg [7:0]		clut1_addr_cnt;

reg				cult_rd_flag;
reg [3:0] 		clut1_rd_cnt;
reg [7:0] 		clut1_del_cnt;
reg	[2:0]		fifo_read_cnt;
wire			cult1_fifo_full;
wire [8:0]		cult1_rd_count;
wire [5:0]		cult1_wr_count;
wire			cult1_fifo_rd_en;
reg				cult1_fifo_rd_en1;
wire [15:0]		cult1_fifo_dout;
wire			cult1_fifo_empty;

wire			fifo_wr_en;
reg [8:0] 		fifo_wr_cnt;
reg 	  		cult_rd_valid;
wire			fifo_read_clr;
wire			cult1_ddr_full;
reg				cult1_ddr_rd_en;
wire [127:0]	cult1_ddr_dout;
wire			cult1_ddr_empty;

wire		   	radmap_wr0;
reg 	[15:0] 	radmap_wr_addra0;
wire 	[15:0] 	radmap_wr_dat0;
wire		   	radmap_rd0;
reg 	[15:0] 	radmap_rd_add0;
wire 	[15:0] 	radmap_rd_addra0;
wire 	[15:0] 	radmap_rd_dat0;
reg		   		radmap_rd0_valid0;
reg		   		radmap_rd0_valid1;
reg		   		radmap_rd0_valid2;
reg		[2:0]	radmap_rd0_cnt;
reg		[127:0] radmap_rd0_dat0;

reg		   		radmap_wr1;
reg 	[15:0] 	radmap_wr_addra1;
reg 	[15:0] 	radmap_wr_dat1;
wire		   	radmap_rd1;
wire 	[15:0] 	radmap_rd_addra1;
wire 	[15:0] 	radmap_rd_dat1;		

reg		   		radmap_wr2;
reg 	[15:0] 	radmap_wr_addra2;
reg 	[15:0] 	radmap_wr_dat2;
wire		   	radmap_rd2;
wire 	[15:0] 	radmap_rd_addra2;
wire 	[15:0] 	radmap_rd_dat2;	

reg		   		radmap_wr3;
reg 	[15:0] 	radmap_wr_addra3;
reg 	[15:0] 	radmap_wr_dat3;
wire		   	radmap_rd3;
wire 	[15:0] 	radmap_rd_addra3;
wire 	[15:0] 	radmap_rd_dat3;	

reg				alg_start;
reg 			alg_begin0;
reg 			alg_begin1;
reg 			alg_begin2;
reg [15:0] 		alg_cnt; 
reg				recur_start;
reg				recur_s_valid;
reg	 [15:0]		recur_s_dat;

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		base_addr	 <= 49'h0000_7000_0000;
		clut_cpi_reg <= 16'd120;
		clut_cpi_b	 <= 16'd0;
	end
	else begin
		if(cult_sch_sw == 8'd1)begin
				base_addr	 <=	base_addr1;
				clut_cpi_reg <= 16'd10;
				clut_cpi_b	 <= clut_cpi_rg;
		end
		else begin
			if(cult_mode == 8'd1)begin
				base_addr	 <=	base_addr0;
				clut_cpi_reg <= 16'd120;
				clut_cpi_b	 <= clut_tas_cpi; 			
			end
			else begin
				base_addr	 <=	base_addr0;
				clut_cpi_reg <= 16'd120;
				clut_cpi_b	 <= clut_cpi;
			end
		end
	end
end

//----------------------- CPI CNT ------------------------------
always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		clut_r1_sysclk	<=	4'b0;
	end
	else begin
		clut_r1_sysclk	<=	{clut_r1_sysclk[2:0],clut_in_valid};
	end
end

assign clut_up_sysclk = (clut_r1_sysclk == 4'b0011) ? 1'b1: 1'b0;   //up

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		clut_cpi_rg <= 16'd0;
	end
	else if((clut_cpi_rg >= clut_cpi_reg) && (state0 == 3) && (clut0_cmd_cnt == 8'd20))begin
		clut_cpi_rg <= 16'd0;
	end
	else if(clut_up_sysclk) begin
		clut_cpi_rg <= clut_cpi_rg + 1'b1;
	end
	else begin
		clut_cpi_rg <= clut_cpi_rg;
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		clut_r2_sysclk	<=	4'b0;
	end
	else begin
		clut_r2_sysclk	<=	{clut_r2_sysclk[2:0],clut_in_valid};
	end
end

assign clut_down_sysclk = (clut_r2_sysclk == 4'b1100) ? 1'b1: 1'b0; //down

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		recur_s_valid 	<= 1'b0;
		recur_s_dat		<= 16'd0;
	end
	else if(cult_mode == 8'd1)begin
		recur_s_valid 	<= 1'b0;
		recur_s_dat		<= 16'd0;
	end
	else begin
		recur_s_valid 	<= recur_valid;
		recur_s_dat		<= recur_dat;
	end
end	

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_wr_addra0 <= 16'd0;
	end
	else if(clut_in_valid || recur_s_valid)begin
		radmap_wr_addra0 <= radmap_wr_addra0 + 1'b1;
	end
	else begin
		radmap_wr_addra0 <= 16'd0;
	end
end	

assign radmap_wr0 		= clut_in_valid ? 1'b1 : (recur_s_valid ? 1'b1 : 1'b0);
assign radmap_wr_dat0 	= clut_in_valid ? clut_in_data : (recur_s_valid ? recur_s_dat : 16'd0);

//---------------------------- URAM ----------------------------
xpm_memory_sdpram #(
    .ADDR_WIDTH_A             (16             ),
    .ADDR_WIDTH_B             (16             ),
    .AUTO_SLEEP_TIME          (0              ),
    .BYTE_WRITE_WIDTH_A       (16             ),
    .CASCADE_HEIGHT           (0              ),
    .CLOCKING_MODE            ("common_clock" ),
    .ECC_MODE                 ("no_ecc"       ),
    .MEMORY_INIT_FILE         ("none"         ),
    .MEMORY_INIT_PARAM        ("0"            ),
    .MEMORY_OPTIMIZATION      ("true"         ),
    .MEMORY_PRIMITIVE         ("ultra"        ),
    .MEMORY_SIZE              (1048576        ),//32bit*2048column*16row
    .MESSAGE_CONTROL          (0              ),
    .READ_DATA_WIDTH_B        (16             ),
    .READ_LATENCY_B           (2              ),
    .READ_RESET_VALUE_B       ("0"            ),
    .RST_MODE_A               ("SYNC"         ),
    .RST_MODE_B               ("SYNC"         ),
    .SIM_ASSERT_CHK           (0              ),
    .USE_EMBEDDED_CONSTRAINT  (0              ),
    .USE_MEM_INIT             (1              ),
    .USE_MEM_INIT_MMI         (0              ),
    .WAKEUP_TIME              ("disable_sleep"),
    .WRITE_DATA_WIDTH_A       (16             ),
    .WRITE_MODE_B             ("read_first"   ),
    .WRITE_PROTECT            (1              )
)
u0_xpm_memory_sdpram_32x2048 (
    .clka           (sys_clk          	),
    .clkb           (sys_clk          	),
    .dbiterrb       (             		),
    .sbiterrb       (             		),
    .ena            (1'b1         		),
    .wea            (radmap_wr0    		),
    .addra          (radmap_wr_addra0  	),
    .dina           (radmap_wr_dat0  	),
    .enb            (radmap_rd0         ),
    .addrb          (radmap_rd_addra0  	),
    .doutb          (radmap_rd_dat0  	),
    .injectdbiterra (1'b0         		),
    .injectsbiterra (1'b0         		),
    .regceb         (1'b1         		),
    .rstb           (1'b0         		),
    .sleep          (1'b0         		)
);

//----------------------- POWER ON 120 DIRECT WR ------------------------------
always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		cult_first_flag	<= 4'd0;
	end
	else begin
		if(cult_first_flag	>= 4'd1)begin
			cult_first_flag	<= 4'd5;
		end
		else begin
			if((clut_cpi_b == clut_cpi_reg) && (state0 == 3) && (clut0_cmd_cnt == 8'd20))begin
				cult_first_flag	<= cult_first_flag + 1'b1;
			end
			else begin
				cult_first_flag	<= cult_first_flag;
			end
		end
	end
end	

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_rd0_flag0	 <= 1'b0;
	end
	else begin
		if(clut0_rd_cnt0 == radmap_length)begin
			radmap_rd0_flag0	 <= 1'b0;
		end
		else begin
			if(clut_down_sysclk && (cult_first_flag <= 4'd1))begin
				radmap_rd0_flag0	 <= 1'b1;
			end
			else begin
				radmap_rd0_flag0	 <= radmap_rd0_flag0;			
			end
		end
	end
end	

//------------------- RECUR WR DRR BEGIN -----------------------------------
always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		recur_start	 <= 1'b0;
	end
	else begin
		if(clut0_rd_cnt0 == radmap_length)begin
			recur_start	 <= 1'b0;
		end
		else begin
			if(recur_s_valid && (radmap_wr_addra0 == radmap_length))begin
				recur_start	 <= 1'b1;
			end
			else begin
				recur_start	 <= recur_start;			
			end
		end
	end
end	

//----------------------- DDR WR STATE MCHINE -------------------------------
always @(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)
	begin        
		clut0_fifo_rd 		<= 1'b0;
		clut0_axis_tlast 	<= 1'b0;
		clut0_rd_cnt0 		<= 16'd0;
		clut0_rd_cnt1 		<= 16'd0;
		clut0_cmd_cnt		<= 8'd0;
		clut0_addr_cnt		<= 8'd0;
		state0 				<= 0;
	end        
	else 
	begin
		case(state0)
				0:begin
					  if(((fifo_wr_full == 1'b0) && radmap_rd0_flag0) || ((fifo_wr_full == 1'b0) && recur_start))
						begin
							clut0_fifo_rd 		<= 1'b0;
							clut0_axis_tlast 	<= 1'b0;							
							clut0_rd_cnt0 		<= 16'd0;
							clut0_rd_cnt1 		<= 16'd0;							
							clut0_cmd_cnt		<= 8'd0;
							clut0_addr_cnt		<= 8'd0;
							state0 				<= 1;
						end
					  else 
						begin
							clut0_fifo_rd 		<= 1'b0;
							clut0_axis_tlast 	<= 1'b0;							
							clut0_rd_cnt0 		<= 16'd0;
							clut0_rd_cnt1 		<= 16'd0;							
							clut0_cmd_cnt		<= 8'd0;
							clut0_addr_cnt		<= 8'd0;
							state0 				<= 0;
						end
				  end
				1:begin
						if(fifo_wr_full == 1'b0) 
						begin 
							 clut0_fifo_rd 	<= 1'b1;
							 clut0_rd_cnt0 	<= clut0_rd_cnt0 + 1'b1;
							 clut0_rd_cnt1 	<= clut0_rd_cnt1 + 1'b1;
							 clut0_cmd_cnt	<= 8'd0;
							 if(clut0_rd_cnt0 == radmap_length)begin
								   clut0_axis_tlast <= 1'b1;
								   clut0_addr_cnt	<= clut0_addr_cnt + 1'b1;
								   state0 			<= 3;
							 end
							 else if(clut0_rd_cnt1 == clut0_wr_length - 1'b1) 				 
							 begin
								   clut0_axis_tlast <= 1'b1;
								   clut0_addr_cnt	<= clut0_addr_cnt + 1'b1;
								   state0 			<= 2;
							 end
							 else 
							 begin
								   clut0_axis_tlast <= 1'b0;
								   state0 			<= 1;
							 end
						end
						else 
						begin
						   clut0_fifo_rd 	<= 1'b0;
						   clut0_rd_cnt0 	<= clut0_rd_cnt0;
						   clut0_rd_cnt1 	<= clut0_rd_cnt1;
						   clut0_cmd_cnt	<= 8'd0;
						   clut0_addr_cnt	<= clut0_addr_cnt;
						   state0 			<= 1;
						end
				  end       
				2:begin                                 
					  if(fifo_full_cmd == 1'b0) 
						begin
							clut0_fifo_rd 		<= 1'b0;
							clut0_axis_tlast 	<= 1'b0;
							clut0_rd_cnt1 		<= 16'd0;
							clut0_cmd_cnt 		<= clut0_cmd_cnt + 1'b1;
							if(clut0_cmd_cnt == 8'd20) 				 
							begin
								state0 			<= 1;
							end
							else 
							begin
								state0 			<= 2;
							end
						end
					  else 
						begin
							clut0_fifo_rd 		<= 1'b0;
							clut0_axis_tlast 	<= 1'b0;
							clut0_rd_cnt1 		<= 16'd0;
							clut0_cmd_cnt		<= 8'd0;
							state0 				<= 2;
						end
				  end
				3:begin                                 
					  if(fifo_full_cmd == 1'b0) 
						begin
							clut0_fifo_rd 		<= 1'b0;
							clut0_axis_tlast 	<= 1'b0;
							clut0_rd_cnt1 		<= 16'd0;
							clut0_cmd_cnt 		<= clut0_cmd_cnt + 1'b1;
							if(clut0_cmd_cnt == 8'd20) 				 
							begin
								state0 			<= 0;
							end
							else 
							begin
								state0 			<= 3;
							end
						end
					  else 
						begin
							clut0_fifo_rd 		<= 1'b0;
							clut0_axis_tlast 	<= 1'b0;
							clut0_rd_cnt1 		<= 16'd0;
							clut0_cmd_cnt		<= 8'd0;
							state0 				<= 3;
						end
				  end
			   default: state0 <= 0;
		endcase           
	end
end

assign radmap_rd0 		= 1'b1;//clut0_fifo_rd
assign radmap_rd_addra0 = alg_begin0 ? alg_cnt : radmap_rd_add0;

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_rd_add0 <= 16'd0;
	end
	else begin
		radmap_rd_add0 <= clut0_rd_cnt0;
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_rd0_valid0 <= 1'b0;
		radmap_rd0_valid1 <= 1'b0;
		radmap_rd0_valid2 <= 1'b0;
	end
	else begin
		radmap_rd0_valid0 <= clut0_fifo_rd;
		radmap_rd0_valid1 <= radmap_rd0_valid0;
		radmap_rd0_valid2 <= radmap_rd0_valid1;
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_rd0_cnt <= 3'd0;
	end
	else begin
		if(radmap_rd0_valid2)begin
			radmap_rd0_cnt <= radmap_rd0_cnt + 1'b1;
		end
		else begin
			radmap_rd0_cnt <= radmap_rd0_cnt;	
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_rd0_dat0 <= 128'd0;
	end
	else begin
		radmap_rd0_dat0 <= {radmap_rd0_dat0[111:0],radmap_rd_dat0};
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		fifo_wr_en_wr 	<= 1'b0;
		fifo_din_wr		<= 128'd0;
	end
	else begin
		if(radmap_rd0_cnt == 3'd7)begin
			fifo_wr_en_wr 	<= 1'b1;
			fifo_din_wr		<= radmap_rd0_dat0;
		end
		else begin
			fifo_wr_en_wr 	<= 1'b0;
			fifo_din_wr		<= fifo_din_wr;
		end
	end
end

//------------------------ DDR RD BEGIN FLAG ---------------------------------
always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		cult_rd_flag	<= 1'b0;
	end
	else begin
		if(clut1_rd_cnt0 == radmap_length  - 8'd128)begin
			cult_rd_flag	<= 1'b0;
		end
		else begin
			if(clut_down_sysclk && (cult_first_flag >= 4'd1))begin
				cult_rd_flag	<= 1'b1;
			end
			else begin
				cult_rd_flag	<= cult_rd_flag;
			end
		end
	end
end

//--------------------------- DDR RD STATE MCHINE -------------------------------------
always @(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)
	begin        
		clut1_fifo_rd 		<= 1'b0;
		clut1_axis_tlast 	<= 1'b0;
		clut1_rd_cnt0 		<= 16'd0;
		clut1_rd_cnt1 		<= 16'd0;
		clut1_cmd_cnt		<= 8'd0;
		clut1_addr_cnt		<= 8'd0;
		clut1_rd_cnt		<= 4'd0;
		clut1_del_cnt		<= 8'd0;
		alg_start 			<= 1'b0;
		state1 				<= 0;
	end        
	else 
	begin
		case(state1)
				0:begin
					  if((fifo_full_cmd == 1'b0) && cult_rd_flag)
						begin
							clut1_fifo_rd 		<= 1'b0;
							clut1_axis_tlast 	<= 1'b0;							
							clut1_rd_cnt0 		<= 16'd0;
							clut1_rd_cnt1 		<= 16'd0;							
							clut1_cmd_cnt		<= 8'd0;
							clut1_addr_cnt		<= 8'd0;
							clut1_rd_cnt		<= 4'd0;
							clut1_del_cnt		<= 8'd0;
							alg_start 			<= 1'b0;
							state1 				<= 1;
						end
					  else 
						begin
							clut1_fifo_rd 		<= 1'b0;
							clut1_axis_tlast 	<= 1'b0;							
							clut1_rd_cnt0 		<= 16'd0;
							clut1_rd_cnt1 		<= 16'd0;							
							clut1_cmd_cnt		<= 8'd0;
							clut1_addr_cnt		<= 8'd0;
							clut1_rd_cnt		<= 4'd0;
							clut1_del_cnt		<= 8'd0;
							alg_start 			<= 1'b0;
							state1 				<= 0;
						end
				  end
				1:begin
					 if(fifo_full_cmd == 1'b0) 
					   begin 
					     clut1_fifo_rd 	<= 1'b0;
						 clut1_rd_cnt1 	<= 16'd0;
						 clut1_cmd_cnt	<= clut1_cmd_cnt + 1'b1;
						 clut1_axis_tlast <= 1'b0;
						 clut1_del_cnt	<= 8'd0;
						 if(clut1_cmd_cnt == 8'd20)begin
							   state1 			<= 2;
						 end
						 else 
						 begin
							   state1 			<= 1;
						 end
					 end
					 else 
					   begin
						   clut1_fifo_rd 	<= 1'b0;
						   clut1_axis_tlast <= 1'b0;
						   clut1_rd_cnt1 	<= 16'd0;
						   clut1_cmd_cnt	<= 8'd0;
						   clut1_del_cnt	<= 8'd0;
						   state1 			<= 1;
					   end
				  end       
				2:begin
					 if(cult_rd_valid) 
					   begin 
					     clut1_fifo_rd 	<= 1'b1;
						 clut1_rd_cnt0 	<= clut1_rd_cnt0 + 1'b1;
						 clut1_rd_cnt1 	<= clut1_rd_cnt1 + 1'b1;
						 clut1_cmd_cnt	<= 8'd0;
						 if(clut1_rd_cnt0 == radmap_length - 8'd128)begin
							   clut1_axis_tlast <= 1'b1;
							   clut1_addr_cnt	<= clut1_addr_cnt + 1'b1;
							   state1 			<= 3;
						 end
						 else if(clut1_rd_cnt1 == clut0_wr_length - 3'd5) 				 
						 begin
							   clut1_axis_tlast <= 1'b1;
							   clut1_addr_cnt	<= clut1_addr_cnt + 1'b1;
							   state1 			<= 1;
						 end
						 else 
						 begin
							   clut1_axis_tlast <= 1'b0;
							   state1 			<= 2;
						 end
					 end
					 else 
					   begin
						   clut1_fifo_rd 	<= 1'b0;
						   clut1_rd_cnt0 	<= clut1_rd_cnt0;
						   clut1_rd_cnt1 	<= clut1_rd_cnt1;
						   clut1_cmd_cnt	<= 8'd0;
						   clut1_addr_cnt	<= clut1_addr_cnt;
						   state1 			<= 2;
					   end
				  end
				3:begin
					 if(fifo_full_cmd == 1'b0) 
					   begin 
					     clut1_fifo_rd 		<= 1'b0;
						 clut1_rd_cnt0 		<= 16'd0;
						 clut1_rd_cnt1 		<= 16'd0;
						 clut1_cmd_cnt		<= 8'd0;
						 clut1_addr_cnt		<= 16'd0;
						 clut1_axis_tlast 	<= 1'b0;
						 clut1_del_cnt 		<= clut1_del_cnt + 1'b1;
						 if(clut1_del_cnt == 16'd50)begin
							clut1_rd_cnt <= clut1_rd_cnt + 1'b1;
							if(clut1_rd_cnt >= 4'd2)begin
								alg_start 		<= 1'b1;
								state1 			<= 0;
							end
							else begin
								alg_start 		<= 1'b0;
								state1 			<= 1;
							end
						 end
						 else begin
							 state1 		<= 3;
						 end
					 end
					 else 
					   begin
						   clut1_fifo_rd 	<= 1'b0;
						   clut1_rd_cnt0 	<= 16'd0;
						   clut1_rd_cnt1 	<= 16'd0;
						   clut1_cmd_cnt	<= 8'd0;
						   clut1_addr_cnt	<= 16'd0;
						   clut1_axis_tlast <= 1'b0;
						   clut1_rd_cnt		<= clut1_rd_cnt;
						   clut1_del_cnt 	<= clut1_del_cnt;
						   alg_start 		<= 1'b0;
						   state1 			<= 3;
					   end
				  end 				  
				  
			   default: state1 <= 0;
		endcase           
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		fifo_read_cnt	<= 3'd0;
	end
	else begin
		if(clut1_fifo_rd)begin
			fifo_read_cnt	<= fifo_read_cnt + 1'b1;
		end
		else begin
			fifo_read_cnt	<= 3'd0;
		end
	end
end

//TEST
always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		clut1_fifo_rd1	<= 1'b0;
		clut1_fifo_rd2	<= 1'b0;		
	end
	else begin
		clut1_fifo_rd1	<= clut1_fifo_rd;
		clut1_fifo_rd2	<= clut1_fifo_rd1;
	end
end
assign fifo_read_testen = clut1_fifo_rd2;
//

assign fifo_read_en = ~fifo_read_empty;
assign	fifo_wr_en	= ~fifo_read_empty;	

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		fifo_wr_cnt 	<= 9'd0;
		cult_rd_valid 	<= 1'b0;
	end
	else begin
		if(fifo_read_clr)begin
			fifo_wr_cnt 	<= 9'd0;
			cult_rd_valid 	<= 1'b0;		
		end
		else begin
			if(fifo_wr_cnt >= 9'd256)begin
				fifo_wr_cnt <= 9'd258;
				cult_rd_valid 	<= 1'b1;
			end
			else begin
				if(fifo_wr_en)begin
					fifo_wr_cnt <= fifo_wr_cnt + 1'b1;
				end
				else begin
					fifo_wr_cnt <= fifo_wr_cnt;
				end
				cult_rd_valid 	<= 1'b0;
			end
		end
	end
end

assign fifo_read_clr = ((clut1_cmd_cnt >= 8'd4) && (clut1_cmd_cnt <= 8'd7)) ? 1'b1 : 1'b0;

cult1_ddr_fifo  u_cult1_ddr_fifo(
  .rst			( ~rst_n				),
  .wr_clk		( sys_clk 		   		),
  .din			( fifo_read_data     	),
  .wr_en		( fifo_wr_en   			),
  .full			( cult1_ddr_full    	),
  .rd_data_count( 						),
  .wr_data_count(   					),
  .rd_clk		( sys_clk       		),
  .rd_en		( cult1_ddr_rd_en    	),
  .dout			( cult1_ddr_dout     	),
  .empty		( cult1_ddr_empty    	)
);


always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		cult1_ddr_rd_en	<= 1'b0;
	end
	else begin
		if(fifo_read_cnt == 3'd1)begin
			cult1_ddr_rd_en	<= 1'b1;
		end
		else begin
			cult1_ddr_rd_en	<= 1'b0;
		end
	end
end

cult1_data_fifo  u_cult1_data_fifo(
  .rst			( ~rst_n				),
  .wr_clk		( sys_clk 		   		),
  .din			( cult1_ddr_dout     	),
  .wr_en		( cult1_ddr_rd_en   	),
  .full			( cult1_fifo_full    	),
  .rd_data_count( cult1_rd_count		),
  .wr_data_count( cult1_wr_count  		),
  .rd_clk		( sys_clk       		),
  .rd_en		( cult1_fifo_rd_en    	),
  .dout			( cult1_fifo_dout     	),
  .empty		( cult1_fifo_empty    	)
  
);

assign cult1_fifo_rd_en = ~cult1_fifo_empty;

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		cult1_fifo_rd_en1 <= 1'b0;
	end
	else begin
		cult1_fifo_rd_en1	<= cult1_fifo_rd_en;
	end
end

//RAM1 WR
always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_wr1		<= 1'b0;
		radmap_wr_dat1	<= 16'd0;
	end
	else begin
		if(cult1_fifo_rd_en && (clut1_rd_cnt == 8'd0))begin
			radmap_wr1		<= 1'b1;
			radmap_wr_dat1	<= cult1_fifo_dout;
		end
		else begin
			radmap_wr1		<= 1'b0;
			radmap_wr_dat1	<= radmap_wr_dat1;
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_wr_addra1	<= 16'd0;
	end
	else begin
		if(cult1_fifo_rd_en1 && (clut1_rd_cnt == 8'd0))begin
			radmap_wr_addra1	<= radmap_wr_addra1 + 1'b1;
		end
		else begin
			radmap_wr_addra1	<= radmap_wr_addra1;
		end
	end
end

//RAM2 WR
always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_wr2		<= 1'b0;
		radmap_wr_dat2	<= 16'd0;
	end
	else begin
		if(cult1_fifo_rd_en && (clut1_rd_cnt == 8'd1))begin
			radmap_wr2		<= 1'b1;
			radmap_wr_dat2	<= cult1_fifo_dout;
		end
		else begin
			radmap_wr2		<= 1'b0;
			radmap_wr_dat2	<= radmap_wr_dat2;
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_wr_addra2	<= 16'd0;
	end
	else begin
		if(cult1_fifo_rd_en1 && (clut1_rd_cnt == 8'd1))begin
			radmap_wr_addra2	<= radmap_wr_addra2 + 1'b1;
		end
		else begin
			radmap_wr_addra2	<= radmap_wr_addra2;
		end
	end
end

//RAM3 WR
always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_wr3		<= 1'b0;
		radmap_wr_dat3	<= 16'd0;
	end
	else begin
		if(cult1_fifo_rd_en && (clut1_rd_cnt == 8'd2))begin
			radmap_wr3		<= 1'b1;
			radmap_wr_dat3	<= cult1_fifo_dout;
		end
		else begin
			radmap_wr3		<= 1'b0;
			radmap_wr_dat3	<= radmap_wr_dat3;
		end
	end
end

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_wr_addra3	<= 16'd0;
	end
	else begin
		if(cult1_fifo_rd_en1 && (clut1_rd_cnt == 8'd2))begin
			radmap_wr_addra3	<= radmap_wr_addra3 + 1'b1;
		end
		else begin
			radmap_wr_addra3	<= radmap_wr_addra3;
		end
	end
end

//-------------------------------- DDR WR ADDR CTRL -----------------------------------
always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		fifo_wr_en_cmd 	<= 1'b0;
		fifo_din_cmd	<= 64'd0;
	end
	else begin
		//WR
		if(clut0_cmd_cnt == 8'd10)begin
			fifo_wr_en_cmd 		<= 1'b1;
			fifo_din_cmd[63:63]	<= 1'b0;
			fifo_din_cmd[62:61]	<= 2'd0;
			fifo_din_cmd[60:12]	<= base_addr + cult_length*2*(clut_cpi_b - 1'b1) + clut0_wr_length*2*(clut0_addr_cnt - 1'b1);
			fifo_din_cmd[11:0]	<= clut0_wr_length*2 - 1'b1;
		end
		//RD
		else if((clut1_cmd_cnt == 8'd10) && (clut1_rd_cnt == 8'd0) && (clut_cpi_b <= 16'd4))begin
			fifo_wr_en_cmd 		<= 1'b1;
			fifo_din_cmd[63:63]	<= 1'b1;
			fifo_din_cmd[62:61]	<= 2'd0;
			fifo_din_cmd[60:12]	<= base_addr + cult_length*2*(clut_cpi_b - 1'b1) + clut0_wr_length*2*clut1_addr_cnt;
			fifo_din_cmd[11:0]	<= clut0_wr_length*2 - 1'b1;	
		end			
		else if((clut1_cmd_cnt == 8'd10) && (clut1_rd_cnt == 8'd0))begin  
			fifo_wr_en_cmd 		<= 1'b1;
			fifo_din_cmd[63:63]	<= 1'b1;
			fifo_din_cmd[62:61]	<= 2'd0;
			fifo_din_cmd[60:12]	<= base_addr + cult_length*2*(clut_cpi_b -3'd4 - 1'b1) + clut0_wr_length*2*clut1_addr_cnt;
			fifo_din_cmd[11:0]	<= clut0_wr_length*2 - 1'b1;	
		end
		//
		else if((clut1_cmd_cnt == 8'd10) && (clut1_rd_cnt == 8'd1))begin
			fifo_wr_en_cmd 		<= 1'b1;
			fifo_din_cmd[63:63]	<= 1'b1;
			fifo_din_cmd[62:61]	<= 2'd0;
			fifo_din_cmd[60:12]	<= base_addr + cult_length*2*(clut_cpi_b - 1'b1) + clut0_wr_length*2*clut1_addr_cnt;
			fifo_din_cmd[11:0]	<= clut0_wr_length*2 - 1'b1;	
		end
		//
		else if((clut1_cmd_cnt == 8'd10) && (clut1_rd_cnt == 8'd2) && (clut_cpi_b >= 16'd117) && (clut_cpi_b <= 16'd120))begin
			fifo_wr_en_cmd 		<= 1'b1;
			fifo_din_cmd[63:63]	<= 1'b1;
			fifo_din_cmd[62:61]	<= 2'd0;
			fifo_din_cmd[60:12]	<= base_addr + cult_length*2*(clut_cpi_b - 1'b1) + clut0_wr_length*2*clut1_addr_cnt;
			fifo_din_cmd[11:0]	<= clut0_wr_length*2 - 1'b1;	
		end	
		else if((clut1_cmd_cnt == 8'd10) && (clut1_rd_cnt == 8'd2))begin
			fifo_wr_en_cmd 		<= 1'b1;
			fifo_din_cmd[63:63]	<= 1'b1;
			fifo_din_cmd[62:61]	<= 2'd0;
			fifo_din_cmd[60:12]	<= base_addr + cult_length*2*(clut_cpi_b + 3'd4 - 1'b1) + clut0_wr_length*2*clut1_addr_cnt;
			fifo_din_cmd[11:0]	<= clut0_wr_length*2 - 1'b1;	
		end
		else begin
			fifo_wr_en_cmd 	<= 1'b0;
			fifo_din_cmd	<= fifo_din_cmd;
		end
	end
end

//---------------------------- URAM ----------------------------
xpm_memory_sdpram #(
    .ADDR_WIDTH_A             (16             ),
    .ADDR_WIDTH_B             (16             ),
    .AUTO_SLEEP_TIME          (0              ),
    .BYTE_WRITE_WIDTH_A       (16             ),
    .CASCADE_HEIGHT           (0              ),
    .CLOCKING_MODE            ("common_clock" ),
    .ECC_MODE                 ("no_ecc"       ),
    .MEMORY_INIT_FILE         ("none"         ),
    .MEMORY_INIT_PARAM        ("0"            ),
    .MEMORY_OPTIMIZATION      ("true"         ),
    .MEMORY_PRIMITIVE         ("ultra"        ),
    .MEMORY_SIZE              (1048576        ),//32bit*2048column*16row
    .MESSAGE_CONTROL          (0              ),
    .READ_DATA_WIDTH_B        (16             ),
    .READ_LATENCY_B           (2              ),
    .READ_RESET_VALUE_B       ("0"            ),
    .RST_MODE_A               ("SYNC"         ),
    .RST_MODE_B               ("SYNC"         ),
    .SIM_ASSERT_CHK           (0              ),
    .USE_EMBEDDED_CONSTRAINT  (0              ),
    .USE_MEM_INIT             (1              ),
    .USE_MEM_INIT_MMI         (0              ),
    .WAKEUP_TIME              ("disable_sleep"),
    .WRITE_DATA_WIDTH_A       (16             ),
    .WRITE_MODE_B             ("read_first"   ),
    .WRITE_PROTECT            (1              )
)
u1_xpm_memory_sdpram_32x2048 (
    .clka           (sys_clk          	),
    .clkb           (sys_clk          	),
    .dbiterrb       (             		),
    .sbiterrb       (             		),
    .ena            (1'b1         		),
    .wea            (radmap_wr1    		),
    .addra          (radmap_wr_addra1  	),
    .dina           (radmap_wr_dat1  	),
    .enb            (radmap_rd1         ),
    .addrb          (radmap_rd_addra1  	),
    .doutb          (radmap_rd_dat1  	),
    .injectdbiterra (1'b0         		),
    .injectsbiterra (1'b0         		),
    .regceb         (1'b1         		),
    .rstb           (1'b0         		),
    .sleep          (1'b0         		)
);

//---------------------------- URAM ----------------------------
xpm_memory_sdpram #(
    .ADDR_WIDTH_A             (16             ),
    .ADDR_WIDTH_B             (16             ),
    .AUTO_SLEEP_TIME          (0              ),
    .BYTE_WRITE_WIDTH_A       (16             ),
    .CASCADE_HEIGHT           (0              ),
    .CLOCKING_MODE            ("common_clock" ),
    .ECC_MODE                 ("no_ecc"       ),
    .MEMORY_INIT_FILE         ("none"         ),
    .MEMORY_INIT_PARAM        ("0"            ),
    .MEMORY_OPTIMIZATION      ("true"         ),
    .MEMORY_PRIMITIVE         ("ultra"        ),
    .MEMORY_SIZE              (1048576        ),//32bit*2048column*16row
    .MESSAGE_CONTROL          (0              ),
    .READ_DATA_WIDTH_B        (16             ),
    .READ_LATENCY_B           (2              ),
    .READ_RESET_VALUE_B       ("0"            ),
    .RST_MODE_A               ("SYNC"         ),
    .RST_MODE_B               ("SYNC"         ),
    .SIM_ASSERT_CHK           (0              ),
    .USE_EMBEDDED_CONSTRAINT  (0              ),
    .USE_MEM_INIT             (1              ),
    .USE_MEM_INIT_MMI         (0              ),
    .WAKEUP_TIME              ("disable_sleep"),
    .WRITE_DATA_WIDTH_A       (16             ),
    .WRITE_MODE_B             ("read_first"   ),
    .WRITE_PROTECT            (1              )
)
u2_xpm_memory_sdpram_32x2048 (
    .clka           (sys_clk          	),
    .clkb           (sys_clk          	),
    .dbiterrb       (             		),
    .sbiterrb       (             		),
    .ena            (1'b1         		),
    .wea            (radmap_wr2    		),
    .addra          (radmap_wr_addra2  	),
    .dina           (radmap_wr_dat2  	),
    .enb            (radmap_rd2         ),
    .addrb          (radmap_rd_addra2  	),
    .doutb          (radmap_rd_dat2  	),
    .injectdbiterra (1'b0         		),
    .injectsbiterra (1'b0         		),
    .regceb         (1'b1         		),
    .rstb           (1'b0         		),
    .sleep          (1'b0         		)
);

//---------------------------- URAM ----------------------------
xpm_memory_sdpram #(
    .ADDR_WIDTH_A             (16             ),
    .ADDR_WIDTH_B             (16             ),
    .AUTO_SLEEP_TIME          (0              ),
    .BYTE_WRITE_WIDTH_A       (16             ),
    .CASCADE_HEIGHT           (0              ),
    .CLOCKING_MODE            ("common_clock" ),
    .ECC_MODE                 ("no_ecc"       ),
    .MEMORY_INIT_FILE         ("none"         ),
    .MEMORY_INIT_PARAM        ("0"            ),
    .MEMORY_OPTIMIZATION      ("true"         ),
    .MEMORY_PRIMITIVE         ("ultra"        ),
    .MEMORY_SIZE              (1048576        ),//32bit*2048column*16row
    .MESSAGE_CONTROL          (0              ),
    .READ_DATA_WIDTH_B        (16             ),
    .READ_LATENCY_B           (2              ),
    .READ_RESET_VALUE_B       ("0"            ),
    .RST_MODE_A               ("SYNC"         ),
    .RST_MODE_B               ("SYNC"         ),
    .SIM_ASSERT_CHK           (0              ),
    .USE_EMBEDDED_CONSTRAINT  (0              ),
    .USE_MEM_INIT             (1              ),
    .USE_MEM_INIT_MMI         (0              ),
    .WAKEUP_TIME              ("disable_sleep"),
    .WRITE_DATA_WIDTH_A       (16             ),
    .WRITE_MODE_B             ("read_first"   ),
    .WRITE_PROTECT            (1              )
)
u3_xpm_memory_sdpram_32x2048 (
    .clka           (sys_clk          	),
    .clkb           (sys_clk          	),
    .dbiterrb       (             		),
    .sbiterrb       (             		),
    .ena            (1'b1         		),
    .wea            (radmap_wr3    		),
    .addra          (radmap_wr_addra3  	),
    .dina           (radmap_wr_dat3  	),
    .enb            (radmap_rd3         ),
    .addrb          (radmap_rd_addra3  	),
    .doutb          (radmap_rd_dat3  	),
    .injectdbiterra (1'b0         		),
    .injectsbiterra (1'b0         		),
    .regceb         (1'b1         		),
    .rstb           (1'b0         		),
    .sleep          (1'b0         		)
);

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		alg_begin0	 <= 1'b0;
	end
	else begin
		if(alg_cnt == 16'd65535)begin
			alg_begin0	 <= 1'b0;
		end
		else begin
			if(alg_start)begin
				alg_begin0	 <= 1'b1;
			end
			else begin
				alg_begin0	 <= alg_begin0;			
			end
		end
	end
end	
	
always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		alg_begin1	 <= 1'b0;
		alg_begin2	 <= 1'b0;
	end
	else begin
		alg_begin1	 <= alg_begin0;
		alg_begin2	 <= alg_begin1;
	end
end		

always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		alg_cnt	 <= 16'd0;
	end
	else begin
		if(alg_begin0)begin
			alg_cnt	 <= alg_cnt + 1'b1;
		end
		else begin
			alg_cnt	 <= 16'd0;
		end
	end
end		

assign 	radmap_rd1 			= (alg_begin0 || alg_begin1) ? 1'b1 : 1'b0;
assign	radmap_rd_addra1 	= alg_begin0 ? alg_cnt : 1'b0;
	
assign 	radmap_rd2 			= (alg_begin0 || alg_begin1) ? 1'b1 : 1'b0;
assign	radmap_rd_addra2 	= alg_begin0 ? alg_cnt : 1'b0;

assign 	radmap_rd3 			= (alg_begin0 || alg_begin1) ? 1'b1 : 1'b0;
assign	radmap_rd_addra3 	= alg_begin0 ? alg_cnt : 1'b0;
	
always@(posedge sys_clk or negedge rst_n)begin
	if(!rst_n)begin
		radmap_rd_vld	 <= 1'b0;
		radmap_rd_din0	 <= 16'd0;
		radmap_rd_din1	 <= 16'd0;
		radmap_rd_din2	 <= 16'd0;
		radmap_rd_din3	 <= 16'd0;		
	end
	else begin
		if(alg_begin2)begin
			radmap_rd_vld	 <= 1'b1;
			radmap_rd_din0	 <= radmap_rd_dat0;
			radmap_rd_din1	 <= radmap_rd_dat1;
			radmap_rd_din2	 <= radmap_rd_dat2;
			radmap_rd_din3	 <= radmap_rd_dat3;			
		end
		else begin
			radmap_rd_vld	 <= 1'b0;
			radmap_rd_din0	 <= radmap_rd_din0;
			radmap_rd_din1	 <= radmap_rd_din1;
			radmap_rd_din2	 <= radmap_rd_din2;
			radmap_rd_din3	 <= radmap_rd_din3;		
		end
	end
end
	
	
assign clut_cpi_t = clut_cpi_b;

endmodule

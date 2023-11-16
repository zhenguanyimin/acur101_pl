`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/04 16:44:52
// Design Name: 
// Module Name: fir_bank_top
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
module fir_bank_top(
    input				sys_clk			,//时钟
    input				rst_n			,//低复位
    input				fir_in_valid	,//输入有效标志-有效时间为32的整数倍 32clk*n
    input	[31:0] 		fir_in_data		,//输入数据 [31:16]虚部+[15:0]实部
	
	output 	reg			fir_out_valid	,//输出有效标志
	output	reg			fir_out_tlast	,
	output	reg [89:0]	fir_out_dat 	,//输出数据 [47:24]虚部+[23:0]实部
	
    output  wire[63:0]  o_rdamp_tdata 	,
    output  wire        o_rdamp_tvalid	,
    output  wire        o_rdamp_tlast 	 

    );

/************************************************************/
//滤波器组设计方案中rom_0-31	对应代码	fir_rom0-31
//滤波器组设计方案中w0-31		对应代码	fir_rom_dat0-31
//滤波器组设计方案中DI0-31		对应代码	fir_in_dat0-31
//滤波器组设计方案中D0-31		对应代码	fir_din1_dat0-31
//滤波器组设计方案中ADD			对应代码	add_din0_dat0-7
//滤波器组设计方案中Add			对应代码	add_din1_dat0-7
//滤波器组设计方案中add			对应代码	add_din2_dat0-7
/************************************************************/

reg		[4:0] 	fir_in_cnt;
reg		[4:0] 	fir_din_cnt;
reg		[31:0]	fir_in_dl;
reg		[4:0]	fir_rom_addr;
wire	[31:0]	fir_rom_dat0 ;
wire	[31:0]	fir_rom_dat1 ;
wire	[31:0]	fir_rom_dat2 ;
wire	[31:0]	fir_rom_dat3 ;
wire	[31:0]	fir_rom_dat4 ;
wire	[31:0]	fir_rom_dat5 ;
wire	[31:0]	fir_rom_dat6 ;
wire	[31:0]	fir_rom_dat7 ;
wire	[31:0]	fir_rom_dat8 ;
wire	[31:0]	fir_rom_dat9 ;
wire	[31:0]	fir_rom_dat10;
wire	[31:0]	fir_rom_dat11;
wire	[31:0]	fir_rom_dat12;
wire	[31:0]	fir_rom_dat13;
wire	[31:0]	fir_rom_dat14;
wire	[31:0]	fir_rom_dat15;
wire	[31:0]	fir_rom_dat16;
wire	[31:0]	fir_rom_dat17;
wire	[31:0]	fir_rom_dat18;
wire	[31:0]	fir_rom_dat19;
wire	[31:0]	fir_rom_dat20;
wire	[31:0]	fir_rom_dat21;
wire	[31:0]	fir_rom_dat22;
wire	[31:0]	fir_rom_dat23;
wire	[31:0]	fir_rom_dat24;
wire	[31:0]	fir_rom_dat25;
wire	[31:0]	fir_rom_dat26;
wire	[31:0]	fir_rom_dat27;
wire	[31:0]	fir_rom_dat28;
wire	[31:0]	fir_rom_dat29;
wire	[31:0]	fir_rom_dat30;
wire	[31:0]	fir_rom_dat31;

reg 	[31:0]	fir_in_dat0 ; 
reg 	[31:0]	fir_in_dat1 ; 
reg 	[31:0]	fir_in_dat2 ; 
reg 	[31:0]	fir_in_dat3 ; 
reg 	[31:0]	fir_in_dat4 ; 
reg 	[31:0]	fir_in_dat5 ; 
reg 	[31:0]	fir_in_dat6 ; 
reg 	[31:0]	fir_in_dat7 ; 
reg 	[31:0]	fir_in_dat8 ; 
reg 	[31:0]	fir_in_dat9 ; 
reg 	[31:0]	fir_in_dat10; 
reg 	[31:0]	fir_in_dat11; 
reg 	[31:0]	fir_in_dat12; 
reg 	[31:0]	fir_in_dat13; 
reg 	[31:0]	fir_in_dat14; 
reg 	[31:0]	fir_in_dat15; 
reg 	[31:0]	fir_in_dat16; 
reg 	[31:0]	fir_in_dat17; 
reg 	[31:0]	fir_in_dat18; 
reg 	[31:0]	fir_in_dat19; 
reg 	[31:0]	fir_in_dat20; 
reg 	[31:0]	fir_in_dat21; 
reg 	[31:0]	fir_in_dat22; 
reg 	[31:0]	fir_in_dat23; 
reg 	[31:0]	fir_in_dat24; 
reg 	[31:0]	fir_in_dat25; 
reg 	[31:0]	fir_in_dat26; 
reg 	[31:0]	fir_in_dat27; 
reg 	[31:0]	fir_in_dat28; 
reg 	[31:0]	fir_in_dat29; 
reg 	[31:0]	fir_in_dat30; 
reg 	[31:0]	fir_in_dat31; 

reg				fir_in_valid0;
reg				fir_din_flag;
reg				fir_din1_valid;
reg 	[31:0]	fir_din1_dat0 ;
reg 	[31:0]	fir_din1_dat1 ;
reg 	[31:0]	fir_din1_dat2 ;
reg 	[31:0]	fir_din1_dat3 ;
reg 	[31:0]	fir_din1_dat4 ;
reg 	[31:0]	fir_din1_dat5 ;
reg 	[31:0]	fir_din1_dat6 ;
reg 	[31:0]	fir_din1_dat7 ;
reg 	[31:0]	fir_din1_dat8 ;
reg 	[31:0]	fir_din1_dat9 ;
reg 	[31:0]	fir_din1_dat10;
reg 	[31:0]	fir_din1_dat11;
reg 	[31:0]	fir_din1_dat12;
reg 	[31:0]	fir_din1_dat13;
reg 	[31:0]	fir_din1_dat14;
reg 	[31:0]	fir_din1_dat15;
reg 	[31:0]	fir_din1_dat16;
reg 	[31:0]	fir_din1_dat17;
reg 	[31:0]	fir_din1_dat18;
reg 	[31:0]	fir_din1_dat19;
reg 	[31:0]	fir_din1_dat20;
reg 	[31:0]	fir_din1_dat21;
reg 	[31:0]	fir_din1_dat22;
reg 	[31:0]	fir_din1_dat23;
reg 	[31:0]	fir_din1_dat24;
reg 	[31:0]	fir_din1_dat25;
reg 	[31:0]	fir_din1_dat26;
reg 	[31:0]	fir_din1_dat27;
reg 	[31:0]	fir_din1_dat28;
reg 	[31:0]	fir_din1_dat29;
reg 	[31:0]	fir_din1_dat30;
reg 	[31:0]	fir_din1_dat31;

wire			complex_vld0;
wire	[79:0]	complex_dat0 ;
wire	[79:0]	complex_dat1 ;
wire	[79:0]	complex_dat2 ;
wire	[79:0]	complex_dat3 ;
wire	[79:0]	complex_dat4 ;
wire	[79:0]	complex_dat5 ;
wire	[79:0]	complex_dat6 ;
wire	[79:0]	complex_dat7 ;
wire	[79:0]	complex_dat8 ;
wire	[79:0]	complex_dat9 ;
wire	[79:0]	complex_dat10;
wire	[79:0]	complex_dat11;
wire	[79:0]	complex_dat12;
wire	[79:0]	complex_dat13;
wire	[79:0]	complex_dat14;
wire	[79:0]	complex_dat15;
wire	[79:0]	complex_dat16;
wire	[79:0]	complex_dat17;
wire	[79:0]	complex_dat18;
wire	[79:0]	complex_dat19;
wire	[79:0]	complex_dat20;
wire	[79:0]	complex_dat21;
wire	[79:0]	complex_dat22;
wire	[79:0]	complex_dat23;
wire	[79:0]	complex_dat24;
wire	[79:0]	complex_dat25;
wire	[79:0]	complex_dat26;
wire	[79:0]	complex_dat27;
wire	[79:0]	complex_dat28;
wire	[79:0]	complex_dat29;
wire	[79:0]	complex_dat30;
wire	[79:0]	complex_dat31;

reg			add_din0_vld0;     
reg	[83:0]	add_din0_dat0 ;
reg	[83:0]	add_din0_dat1 ;
reg	[83:0]	add_din0_dat2 ;
reg	[83:0]	add_din0_dat3 ;
reg	[83:0]	add_din0_dat4 ;
reg	[83:0]	add_din0_dat5 ;
reg	[83:0]	add_din0_dat6 ;
reg	[83:0]	add_din0_dat7 ;

reg			add_din1_vld0 ;
reg	[87:0]	add_din1_dat0 ;
reg	[87:0]	add_din1_dat1 ;

reg			add_din2_vld0 ;
reg	[89:0]	add_din2_dat0 ;

reg	[4:0] 	add_din2_cnt;

//------ROM-----[31:16]虚部---[15:0]实部----
fir_rom0 u_fir_rom0(
      .clka	(sys_clk			),
      .addra(fir_rom_addr[4:0]	), 
      .douta(fir_rom_dat0   	)  
    );

fir_rom1 u_fir_rom1(
      .clka	(sys_clk			),
      .addra(fir_rom_addr[4:0]	), 
      .douta(fir_rom_dat1   	)  
    );

fir_rom2 u_fir_rom2(
      .clka	(sys_clk			),
      .addra(fir_rom_addr[4:0]	), 
      .douta(fir_rom_dat2   	)  
    );

fir_rom3 u_fir_rom3(
      .clka	(sys_clk			),
      .addra(fir_rom_addr[4:0]	), 
      .douta(fir_rom_dat3   	)  
    );

fir_rom4 u_fir_rom4(
      .clka	(sys_clk			),
      .addra(fir_rom_addr[4:0]	), 
      .douta(fir_rom_dat4   	)  
    );

fir_rom5 u_fir_rom5(
      .clka	(sys_clk			),
      .addra(fir_rom_addr[4:0]	), 
      .douta(fir_rom_dat5   	)  
    );

fir_rom6 u_fir_rom6(
      .clka	(sys_clk			),
      .addra(fir_rom_addr[4:0]	), 
      .douta(fir_rom_dat6   	)  
    );

fir_rom7 u_fir_rom7(
      .clka	(sys_clk			),
      .addra(fir_rom_addr[4:0]	), 
      .douta(fir_rom_dat7   	)  
    );

fir_rom8 u_fir_rom8(
      .clka	(sys_clk			),
      .addra(fir_rom_addr[4:0]	), 
      .douta(fir_rom_dat8   	)  
    );

fir_rom9 u_fir_rom9(
      .clka	(sys_clk			),
      .addra(fir_rom_addr[4:0]	), 
      .douta(fir_rom_dat9   	)  
    );

fir_rom10 u_fir_rom10(
      .clka	(sys_clk			),
      .addra(fir_rom_addr[4:0]	), 
      .douta(fir_rom_dat10   	)  
    );

fir_rom11 u_fir_rom11(
      .clka	(sys_clk			),
      .addra(fir_rom_addr[4:0]	), 
      .douta(fir_rom_dat11   	)  
    );

fir_rom12 u_fir_rom12(
      .clka	(sys_clk			),
      .addra(fir_rom_addr[4:0]	), 
      .douta(fir_rom_dat12   	)  
    );

fir_rom13 u_fir_rom13(
      .clka	(sys_clk			),
      .addra(fir_rom_addr[4:0]	), 
      .douta(fir_rom_dat13   	)  
    );

fir_rom14 u_fir_rom14(
      .clka	(sys_clk			),
      .addra(fir_rom_addr[4:0]	), 
      .douta(fir_rom_dat14   	)  
    );

fir_rom15 u_fir_rom15(
      .clka	(sys_clk			),
      .addra(fir_rom_addr[4:0]	), 
      .douta(fir_rom_dat15   	)  
    );

fir_rom16 u_fir_rom16(
      .clka	(sys_clk			),
      .addra(fir_rom_addr[4:0]	), 
      .douta(fir_rom_dat16   	)  
    );

fir_rom17 u_fir_rom17(
      .clka	(sys_clk			),
      .addra(fir_rom_addr[4:0]	), 
      .douta(fir_rom_dat17   	)  
    );

fir_rom18 u_fir_rom18(
      .clka	(sys_clk			),
      .addra(fir_rom_addr[4:0]	), 
      .douta(fir_rom_dat18   	)  
    );

fir_rom19 u_fir_rom19(
      .clka	(sys_clk			),
      .addra(fir_rom_addr[4:0]	), 
      .douta(fir_rom_dat19   	)  
    );

fir_rom20 u_fir_rom20(
      .clka	(sys_clk			),
      .addra(fir_rom_addr[4:0]	), 
      .douta(fir_rom_dat20   	)  
    );

fir_rom21 u_fir_rom21(
      .clka	(sys_clk			),
      .addra(fir_rom_addr[4:0]	), 
      .douta(fir_rom_dat21   	)  
    );

fir_rom22 u_fir_rom22(
      .clka	(sys_clk			),
      .addra(fir_rom_addr[4:0]	), 
      .douta(fir_rom_dat22   	)  
    );

fir_rom23 u_fir_rom23(
      .clka	(sys_clk			),
      .addra(fir_rom_addr[4:0]	), 
      .douta(fir_rom_dat23   	)  
    );

fir_rom24 u_fir_rom24(
      .clka	(sys_clk			),
      .addra(fir_rom_addr[4:0]	), 
      .douta(fir_rom_dat24   	)  
    );

fir_rom25 u_fir_rom25(
      .clka	(sys_clk			),
      .addra(fir_rom_addr[4:0]	), 
      .douta(fir_rom_dat25   	)  
    );

fir_rom26 u_fir_rom26(
      .clka	(sys_clk			),
      .addra(fir_rom_addr[4:0]	), 
      .douta(fir_rom_dat26   	)  
    );

fir_rom27 u_fir_rom27(
      .clka	(sys_clk			),
      .addra(fir_rom_addr[4:0]	), 
      .douta(fir_rom_dat27   	)  
    );

fir_rom28 u_fir_rom28(
      .clka	(sys_clk			),
      .addra(fir_rom_addr[4:0]	), 
      .douta(fir_rom_dat28   	)  
    );

fir_rom29 u_fir_rom29(
      .clka	(sys_clk			),
      .addra(fir_rom_addr[4:0]	), 
      .douta(fir_rom_dat29   	)  
    );

fir_rom30 u_fir_rom30(
      .clka	(sys_clk			),
      .addra(fir_rom_addr[4:0]	), 
      .douta(fir_rom_dat30   	)  
    );

fir_rom31 u_fir_rom31(
      .clka	(sys_clk			),
      .addra(fir_rom_addr[4:0]	), 
      .douta(fir_rom_dat31   	)  
    );

    always@(posedge sys_clk or negedge rst_n)begin
    	if(!rst_n)begin
    		fir_in_cnt	<=	5'd0;
    	end
    	else begin
			if(fir_in_valid)begin
				fir_in_cnt <=	fir_in_cnt + 1'b1;
			end
			else begin
				fir_in_cnt <= fir_in_cnt;
			end
    	end
    end

    always@(posedge sys_clk)begin
		fir_din_cnt <= fir_in_cnt;
    end
	
    always@(posedge sys_clk or negedge rst_n)begin
    	if(!rst_n)begin
    		fir_in_dl	<=	32'b0;
    	end
    	else begin
			fir_in_dl <= {fir_in_dl[30:0],fir_in_valid};
    	end
    end	
	
    always@(posedge sys_clk or negedge rst_n)begin
    	if(!rst_n)begin
    		fir_rom_addr	<=	5'd0;
    	end
    	else begin
			if(fir_in_dl[30])begin
				fir_rom_addr <=	fir_rom_addr + 1'b1;
			end
			else begin
				fir_rom_addr <= fir_rom_addr;
			end
    	end
    end	
	
    always@(posedge sys_clk or negedge rst_n)begin
    	if(!rst_n)begin
			fir_in_dat0  <= 32'h0;
			fir_in_dat1  <= 32'h0;
			fir_in_dat2  <= 32'h0;
			fir_in_dat3  <= 32'h0;
			fir_in_dat4  <= 32'h0;
			fir_in_dat5  <= 32'h0;
			fir_in_dat6  <= 32'h0;
			fir_in_dat7  <= 32'h0;
			fir_in_dat8  <= 32'h0;
			fir_in_dat9  <= 32'h0;
			fir_in_dat10 <= 32'h0;
			fir_in_dat11 <= 32'h0;
			fir_in_dat12 <= 32'h0;
			fir_in_dat13 <= 32'h0;
			fir_in_dat14 <= 32'h0;
			fir_in_dat15 <= 32'h0;
			fir_in_dat16 <= 32'h0;
			fir_in_dat17 <= 32'h0;
			fir_in_dat18 <= 32'h0;
			fir_in_dat19 <= 32'h0;
			fir_in_dat20 <= 32'h0;
			fir_in_dat21 <= 32'h0;
			fir_in_dat22 <= 32'h0;
			fir_in_dat23 <= 32'h0;
			fir_in_dat24 <= 32'h0;
			fir_in_dat25 <= 32'h0;
			fir_in_dat26 <= 32'h0;
			fir_in_dat27 <= 32'h0;
			fir_in_dat28 <= 32'h0;
			fir_in_dat29 <= 32'h0;
			fir_in_dat30 <= 32'h0;
			fir_in_dat31 <= 32'h0;
    	end
    	else begin
			if(fir_in_valid)begin
				fir_in_dat0  <= fir_in_data;
				fir_in_dat1  <= fir_in_dat0 ;
				fir_in_dat2  <= fir_in_dat1 ;
				fir_in_dat3  <= fir_in_dat2 ;
				fir_in_dat4  <= fir_in_dat3 ;
				fir_in_dat5  <= fir_in_dat4 ;
				fir_in_dat6  <= fir_in_dat5 ;
				fir_in_dat7  <= fir_in_dat6 ;
				fir_in_dat8  <= fir_in_dat7 ;
				fir_in_dat9  <= fir_in_dat8 ;
				fir_in_dat10 <= fir_in_dat9 ;
				fir_in_dat11 <= fir_in_dat10;
				fir_in_dat12 <= fir_in_dat11;
				fir_in_dat13 <= fir_in_dat12;
				fir_in_dat14 <= fir_in_dat13;
				fir_in_dat15 <= fir_in_dat14;
				fir_in_dat16 <= fir_in_dat15;
				fir_in_dat17 <= fir_in_dat16;
				fir_in_dat18 <= fir_in_dat17;
				fir_in_dat19 <= fir_in_dat18;
				fir_in_dat20 <= fir_in_dat19;
				fir_in_dat21 <= fir_in_dat20;
				fir_in_dat22 <= fir_in_dat21;
				fir_in_dat23 <= fir_in_dat22;
				fir_in_dat24 <= fir_in_dat23;
				fir_in_dat25 <= fir_in_dat24;
				fir_in_dat26 <= fir_in_dat25;
				fir_in_dat27 <= fir_in_dat26;
				fir_in_dat28 <= fir_in_dat27;
				fir_in_dat29 <= fir_in_dat28;
				fir_in_dat30 <= fir_in_dat29;
				fir_in_dat31 <= fir_in_dat30;
			end
			else begin
				fir_in_dat0  <= fir_in_dat0 ;
				fir_in_dat1  <= fir_in_dat1 ;
				fir_in_dat2  <= fir_in_dat2 ;
				fir_in_dat3  <= fir_in_dat3 ;
				fir_in_dat4  <= fir_in_dat4 ;
				fir_in_dat5  <= fir_in_dat5 ;
				fir_in_dat6  <= fir_in_dat6 ;
				fir_in_dat7  <= fir_in_dat7 ;
				fir_in_dat8  <= fir_in_dat8 ;
				fir_in_dat9  <= fir_in_dat9 ;
				fir_in_dat10 <= fir_in_dat10;
				fir_in_dat11 <= fir_in_dat11;
				fir_in_dat12 <= fir_in_dat12;
				fir_in_dat13 <= fir_in_dat13;
				fir_in_dat14 <= fir_in_dat14;
				fir_in_dat15 <= fir_in_dat15;
				fir_in_dat16 <= fir_in_dat16;
				fir_in_dat17 <= fir_in_dat17;
				fir_in_dat18 <= fir_in_dat18;
				fir_in_dat19 <= fir_in_dat19;
				fir_in_dat20 <= fir_in_dat20;
				fir_in_dat21 <= fir_in_dat21;
				fir_in_dat22 <= fir_in_dat22;
				fir_in_dat23 <= fir_in_dat23;
				fir_in_dat24 <= fir_in_dat24;
				fir_in_dat25 <= fir_in_dat25;
				fir_in_dat26 <= fir_in_dat26;
				fir_in_dat27 <= fir_in_dat27;
				fir_in_dat28 <= fir_in_dat28;
				fir_in_dat29 <= fir_in_dat29;
				fir_in_dat30 <= fir_in_dat30;
				fir_in_dat31 <= fir_in_dat31;			
			end
    	end
    end

    always@(posedge sys_clk or negedge rst_n)begin
    	if(!rst_n)begin
			fir_din_flag  <= 1'b0;
			fir_din1_dat0  <= 32'h0;
			fir_din1_dat1  <= 32'h0;
			fir_din1_dat2  <= 32'h0;
			fir_din1_dat3  <= 32'h0;
			fir_din1_dat4  <= 32'h0;
			fir_din1_dat5  <= 32'h0;
			fir_din1_dat6  <= 32'h0;
			fir_din1_dat7  <= 32'h0;
			fir_din1_dat8  <= 32'h0;
			fir_din1_dat9  <= 32'h0;
			fir_din1_dat10 <= 32'h0;
			fir_din1_dat11 <= 32'h0;
			fir_din1_dat12 <= 32'h0;
			fir_din1_dat13 <= 32'h0;
			fir_din1_dat14 <= 32'h0;
			fir_din1_dat15 <= 32'h0;
			fir_din1_dat16 <= 32'h0;
			fir_din1_dat17 <= 32'h0;
			fir_din1_dat18 <= 32'h0;
			fir_din1_dat19 <= 32'h0;
			fir_din1_dat20 <= 32'h0;
			fir_din1_dat21 <= 32'h0;
			fir_din1_dat22 <= 32'h0;
			fir_din1_dat23 <= 32'h0;
			fir_din1_dat24 <= 32'h0;
			fir_din1_dat25 <= 32'h0;
			fir_din1_dat26 <= 32'h0;
			fir_din1_dat27 <= 32'h0;
			fir_din1_dat28 <= 32'h0;
			fir_din1_dat29 <= 32'h0;
			fir_din1_dat30 <= 32'h0;
			fir_din1_dat31 <= 32'h0;
    	end
    	else begin
			if(fir_din_cnt == 5'd31)begin
				fir_din_flag  <= 1'b1;
				fir_din1_dat0  <= fir_in_dat0 ;
				fir_din1_dat1  <= fir_in_dat1 ;
				fir_din1_dat2  <= fir_in_dat2 ;
				fir_din1_dat3  <= fir_in_dat3 ;
				fir_din1_dat4  <= fir_in_dat4 ;
				fir_din1_dat5  <= fir_in_dat5 ;
				fir_din1_dat6  <= fir_in_dat6 ;
				fir_din1_dat7  <= fir_in_dat7 ;
				fir_din1_dat8  <= fir_in_dat8 ;
				fir_din1_dat9  <= fir_in_dat9 ;
				fir_din1_dat10 <= fir_in_dat10;
				fir_din1_dat11 <= fir_in_dat11;
				fir_din1_dat12 <= fir_in_dat12;
				fir_din1_dat13 <= fir_in_dat13;
				fir_din1_dat14 <= fir_in_dat14;
				fir_din1_dat15 <= fir_in_dat15;
				fir_din1_dat16 <= fir_in_dat16;
				fir_din1_dat17 <= fir_in_dat17;
				fir_din1_dat18 <= fir_in_dat18;
				fir_din1_dat19 <= fir_in_dat19;
				fir_din1_dat20 <= fir_in_dat20;
				fir_din1_dat21 <= fir_in_dat21;
				fir_din1_dat22 <= fir_in_dat22;
				fir_din1_dat23 <= fir_in_dat23;
				fir_din1_dat24 <= fir_in_dat24;
				fir_din1_dat25 <= fir_in_dat25;
				fir_din1_dat26 <= fir_in_dat26;
				fir_din1_dat27 <= fir_in_dat27;
				fir_din1_dat28 <= fir_in_dat28;
				fir_din1_dat29 <= fir_in_dat29;
				fir_din1_dat30 <= fir_in_dat30;
				fir_din1_dat31 <= fir_in_dat31;
			end
			else begin
				fir_din_flag  <= 1'b0;
				fir_din1_dat0  <= fir_din1_dat0 ;
				fir_din1_dat1  <= fir_din1_dat1 ;
				fir_din1_dat2  <= fir_din1_dat2 ;
				fir_din1_dat3  <= fir_din1_dat3 ;
				fir_din1_dat4  <= fir_din1_dat4 ;
				fir_din1_dat5  <= fir_din1_dat5 ;
				fir_din1_dat6  <= fir_din1_dat6 ;
				fir_din1_dat7  <= fir_din1_dat7 ;
				fir_din1_dat8  <= fir_din1_dat8 ;
				fir_din1_dat9  <= fir_din1_dat9 ;
				fir_din1_dat10 <= fir_din1_dat10;
				fir_din1_dat11 <= fir_din1_dat11;
				fir_din1_dat12 <= fir_din1_dat12;
				fir_din1_dat13 <= fir_din1_dat13;
				fir_din1_dat14 <= fir_din1_dat14;
				fir_din1_dat15 <= fir_din1_dat15;
				fir_din1_dat16 <= fir_din1_dat16;
				fir_din1_dat17 <= fir_din1_dat17;
				fir_din1_dat18 <= fir_din1_dat18;
				fir_din1_dat19 <= fir_din1_dat19;
				fir_din1_dat20 <= fir_din1_dat20;
				fir_din1_dat21 <= fir_din1_dat21;
				fir_din1_dat22 <= fir_din1_dat22;
				fir_din1_dat23 <= fir_din1_dat23;
				fir_din1_dat24 <= fir_din1_dat24;
				fir_din1_dat25 <= fir_din1_dat25;
				fir_din1_dat26 <= fir_din1_dat26;
				fir_din1_dat27 <= fir_din1_dat27;
				fir_din1_dat28 <= fir_din1_dat28;
				fir_din1_dat29 <= fir_din1_dat29;
				fir_din1_dat30 <= fir_din1_dat30;
				fir_din1_dat31 <= fir_din1_dat31;			
			end
    	end
    end	

    always@(posedge sys_clk or negedge rst_n)begin
    	if(!rst_n)begin 
			fir_in_valid0	<= 1'b0;  
			fir_din1_valid  <= 1'b0;
    	end
    	else begin
			fir_in_valid0   <= fir_in_dl[30] ;
			fir_din1_valid  <= fir_in_valid0 ;
    	end
    end	

//---complex-mult-----[31:16]虚部---[15:0]实部----
complex_mult u_complex_mult0(
      .aclk					(sys_clk		),
      .s_axis_a_tvalid		(fir_din1_valid	), 
      .s_axis_a_tdata		(fir_din1_dat0  ), 
      .s_axis_b_tvalid		(fir_din1_valid	), 
      .s_axis_b_tdata		(fir_rom_dat0   ),
      .m_axis_dout_tvalid	(complex_vld0	), 
      .m_axis_dout_tdata	(complex_dat0  	)
    );
complex_mult u_complex_mult1(
      .aclk					(sys_clk		),
      .s_axis_a_tvalid		(fir_din1_valid	), 
      .s_axis_a_tdata		(fir_din1_dat1  ), 
      .s_axis_b_tvalid		(fir_din1_valid	), 
      .s_axis_b_tdata		(fir_rom_dat1   ),
      .m_axis_dout_tvalid	(	), 
      .m_axis_dout_tdata	(complex_dat1  	)
    );
complex_mult u_complex_mult2(
      .aclk					(sys_clk		),
      .s_axis_a_tvalid		(fir_din1_valid	), 
      .s_axis_a_tdata		(fir_din1_dat2  ), 
      .s_axis_b_tvalid		(fir_din1_valid	), 
      .s_axis_b_tdata		(fir_rom_dat2   ),
      .m_axis_dout_tvalid	(	), 
      .m_axis_dout_tdata	(complex_dat2  	)
    );
complex_mult u_complex_mult3(
      .aclk					(sys_clk		),
      .s_axis_a_tvalid		(fir_din1_valid	), 
      .s_axis_a_tdata		(fir_din1_dat3  ), 
      .s_axis_b_tvalid		(fir_din1_valid	), 
      .s_axis_b_tdata		(fir_rom_dat3   ),
      .m_axis_dout_tvalid	(	), 
      .m_axis_dout_tdata	(complex_dat3  	)
    );
complex_mult u_complex_mult4(
      .aclk					(sys_clk		),
      .s_axis_a_tvalid		(fir_din1_valid	), 
      .s_axis_a_tdata		(fir_din1_dat4  ), 
      .s_axis_b_tvalid		(fir_din1_valid	), 
      .s_axis_b_tdata		(fir_rom_dat4   ),
      .m_axis_dout_tvalid	(	), 
      .m_axis_dout_tdata	(complex_dat4  	)
    );
complex_mult u_complex_mult5(
      .aclk					(sys_clk		),
      .s_axis_a_tvalid		(fir_din1_valid	), 
      .s_axis_a_tdata		(fir_din1_dat5  ), 
      .s_axis_b_tvalid		(fir_din1_valid	), 
      .s_axis_b_tdata		(fir_rom_dat5   ),
      .m_axis_dout_tvalid	(	), 
      .m_axis_dout_tdata	(complex_dat5  	)
    );
complex_mult u_complex_mult6(
      .aclk					(sys_clk		),
      .s_axis_a_tvalid		(fir_din1_valid	), 
      .s_axis_a_tdata		(fir_din1_dat6  ), 
      .s_axis_b_tvalid		(fir_din1_valid	), 
      .s_axis_b_tdata		(fir_rom_dat6   ),
      .m_axis_dout_tvalid	(	), 
      .m_axis_dout_tdata	(complex_dat6  	)
    );
complex_mult u_complex_mult7(
      .aclk					(sys_clk		),
      .s_axis_a_tvalid		(fir_din1_valid	), 
      .s_axis_a_tdata		(fir_din1_dat7  ), 
      .s_axis_b_tvalid		(fir_din1_valid	), 
      .s_axis_b_tdata		(fir_rom_dat7   ),
      .m_axis_dout_tvalid	(	), 
      .m_axis_dout_tdata	(complex_dat7  	)
    );
complex_mult u_complex_mult8(
      .aclk					(sys_clk		),
      .s_axis_a_tvalid		(fir_din1_valid	), 
      .s_axis_a_tdata		(fir_din1_dat8  ), 
      .s_axis_b_tvalid		(fir_din1_valid	), 
      .s_axis_b_tdata		(fir_rom_dat8   ),
      .m_axis_dout_tvalid	(	), 
      .m_axis_dout_tdata	(complex_dat8  	)
    );
complex_mult u_complex_mult9(
      .aclk					(sys_clk		),
      .s_axis_a_tvalid		(fir_din1_valid	), 
      .s_axis_a_tdata		(fir_din1_dat9  ), 
      .s_axis_b_tvalid		(fir_din1_valid	), 
      .s_axis_b_tdata		(fir_rom_dat9   ),
      .m_axis_dout_tvalid	(	), 
      .m_axis_dout_tdata	(complex_dat9  	)
    );
complex_mult u_complex_mult10(
      .aclk					(sys_clk		),
      .s_axis_a_tvalid		(fir_din1_valid	), 
      .s_axis_a_tdata		(fir_din1_dat10 ), 
      .s_axis_b_tvalid		(fir_din1_valid	), 
      .s_axis_b_tdata		(fir_rom_dat10  ),
      .m_axis_dout_tvalid	(	), 
      .m_axis_dout_tdata	(complex_dat10  )
    );
complex_mult u_complex_mult11(
      .aclk					(sys_clk		),
      .s_axis_a_tvalid		(fir_din1_valid	), 
      .s_axis_a_tdata		(fir_din1_dat11 ), 
      .s_axis_b_tvalid		(fir_din1_valid	), 
      .s_axis_b_tdata		(fir_rom_dat11  ),
      .m_axis_dout_tvalid	(	), 
      .m_axis_dout_tdata	(complex_dat11  )
    );
complex_mult u_complex_mult12(
      .aclk					(sys_clk		),
      .s_axis_a_tvalid		(fir_din1_valid	), 
      .s_axis_a_tdata		(fir_din1_dat12 ), 
      .s_axis_b_tvalid		(fir_din1_valid	), 
      .s_axis_b_tdata		(fir_rom_dat12  ),
      .m_axis_dout_tvalid	(	), 
      .m_axis_dout_tdata	(complex_dat12  )
    );
complex_mult u_complex_mult13(
      .aclk					(sys_clk		),
      .s_axis_a_tvalid		(fir_din1_valid	), 
      .s_axis_a_tdata		(fir_din1_dat13 ), 
      .s_axis_b_tvalid		(fir_din1_valid	), 
      .s_axis_b_tdata		(fir_rom_dat13  ),
      .m_axis_dout_tvalid	(	), 
      .m_axis_dout_tdata	(complex_dat13  )
    );
complex_mult u_complex_mult14(
      .aclk					(sys_clk		),
      .s_axis_a_tvalid		(fir_din1_valid	), 
      .s_axis_a_tdata		(fir_din1_dat14 ), 
      .s_axis_b_tvalid		(fir_din1_valid	), 
      .s_axis_b_tdata		(fir_rom_dat14  ),
      .m_axis_dout_tvalid	(	), 
      .m_axis_dout_tdata	(complex_dat14  )
    );
complex_mult u_complex_mult15(
      .aclk					(sys_clk		),
      .s_axis_a_tvalid		(fir_din1_valid	), 
      .s_axis_a_tdata		(fir_din1_dat15 ), 
      .s_axis_b_tvalid		(fir_din1_valid	), 
      .s_axis_b_tdata		(fir_rom_dat15  ),
      .m_axis_dout_tvalid	(	), 
      .m_axis_dout_tdata	(complex_dat15  )
    );
complex_mult u_complex_mult16(
      .aclk					(sys_clk		),
      .s_axis_a_tvalid		(fir_din1_valid	), 
      .s_axis_a_tdata		(fir_din1_dat16 ), 
      .s_axis_b_tvalid		(fir_din1_valid	), 
      .s_axis_b_tdata		(fir_rom_dat16  ),
      .m_axis_dout_tvalid	(	), 
      .m_axis_dout_tdata	(complex_dat16  )
    );
complex_mult u_complex_mult17(
      .aclk					(sys_clk		),
      .s_axis_a_tvalid		(fir_din1_valid	), 
      .s_axis_a_tdata		(fir_din1_dat17 ), 
      .s_axis_b_tvalid		(fir_din1_valid	), 
      .s_axis_b_tdata		(fir_rom_dat17  ),
      .m_axis_dout_tvalid	(	), 
      .m_axis_dout_tdata	(complex_dat17  )
    );
complex_mult u_complex_mult18(
      .aclk					(sys_clk		),
      .s_axis_a_tvalid		(fir_din1_valid	), 
      .s_axis_a_tdata		(fir_din1_dat18 ), 
      .s_axis_b_tvalid		(fir_din1_valid	), 
      .s_axis_b_tdata		(fir_rom_dat18  ),
      .m_axis_dout_tvalid	(	), 
      .m_axis_dout_tdata	(complex_dat18  )
    );
complex_mult u_complex_mult19(
      .aclk					(sys_clk		),
      .s_axis_a_tvalid		(fir_din1_valid	), 
      .s_axis_a_tdata		(fir_din1_dat19 ), 
      .s_axis_b_tvalid		(fir_din1_valid	), 
      .s_axis_b_tdata		(fir_rom_dat19  ),
      .m_axis_dout_tvalid	(	), 
      .m_axis_dout_tdata	(complex_dat19  )
    );
complex_mult u_complex_mult20(
      .aclk					(sys_clk		),
      .s_axis_a_tvalid		(fir_din1_valid	), 
      .s_axis_a_tdata		(fir_din1_dat20 ), 
      .s_axis_b_tvalid		(fir_din1_valid	), 
      .s_axis_b_tdata		(fir_rom_dat20  ),
      .m_axis_dout_tvalid	(	), 
      .m_axis_dout_tdata	(complex_dat20  )
    );
complex_mult u_complex_mult21(
      .aclk					(sys_clk		),
      .s_axis_a_tvalid		(fir_din1_valid	), 
      .s_axis_a_tdata		(fir_din1_dat21 ), 
      .s_axis_b_tvalid		(fir_din1_valid	), 
      .s_axis_b_tdata		(fir_rom_dat21  ),
      .m_axis_dout_tvalid	(	), 
      .m_axis_dout_tdata	(complex_dat21  )
    );
complex_mult u_complex_mult22(
      .aclk					(sys_clk		),
      .s_axis_a_tvalid		(fir_din1_valid	), 
      .s_axis_a_tdata		(fir_din1_dat22 ), 
      .s_axis_b_tvalid		(fir_din1_valid	), 
      .s_axis_b_tdata		(fir_rom_dat22  ),
      .m_axis_dout_tvalid	(	), 
      .m_axis_dout_tdata	(complex_dat22  )
    );
complex_mult u_complex_mult23(
      .aclk					(sys_clk		),
      .s_axis_a_tvalid		(fir_din1_valid	), 
      .s_axis_a_tdata		(fir_din1_dat23 ), 
      .s_axis_b_tvalid		(fir_din1_valid	), 
      .s_axis_b_tdata		(fir_rom_dat23  ),
      .m_axis_dout_tvalid	(	), 
      .m_axis_dout_tdata	(complex_dat23  )
    );
complex_mult u_complex_mult24(
      .aclk					(sys_clk		),
      .s_axis_a_tvalid		(fir_din1_valid	), 
      .s_axis_a_tdata		(fir_din1_dat24 ), 
      .s_axis_b_tvalid		(fir_din1_valid	), 
      .s_axis_b_tdata		(fir_rom_dat24  ),
      .m_axis_dout_tvalid	(	), 
      .m_axis_dout_tdata	(complex_dat24  )
    );
complex_mult u_complex_mult25(
      .aclk					(sys_clk		),
      .s_axis_a_tvalid		(fir_din1_valid	), 
      .s_axis_a_tdata		(fir_din1_dat25 ), 
      .s_axis_b_tvalid		(fir_din1_valid	), 
      .s_axis_b_tdata		(fir_rom_dat25  ),
      .m_axis_dout_tvalid	(	), 
      .m_axis_dout_tdata	(complex_dat25  )
    );
complex_mult u_complex_mult26(
      .aclk					(sys_clk		),
      .s_axis_a_tvalid		(fir_din1_valid	), 
      .s_axis_a_tdata		(fir_din1_dat26 ), 
      .s_axis_b_tvalid		(fir_din1_valid	), 
      .s_axis_b_tdata		(fir_rom_dat26  ),
      .m_axis_dout_tvalid	(	), 
      .m_axis_dout_tdata	(complex_dat26  )
    );
complex_mult u_complex_mult27(
      .aclk					(sys_clk		),
      .s_axis_a_tvalid		(fir_din1_valid	), 
      .s_axis_a_tdata		(fir_din1_dat27 ), 
      .s_axis_b_tvalid		(fir_din1_valid	), 
      .s_axis_b_tdata		(fir_rom_dat27  ),
      .m_axis_dout_tvalid	(	), 
      .m_axis_dout_tdata	(complex_dat27  )
    );
complex_mult u_complex_mult28(
      .aclk					(sys_clk		),
      .s_axis_a_tvalid		(fir_din1_valid	), 
      .s_axis_a_tdata		(fir_din1_dat28 ), 
      .s_axis_b_tvalid		(fir_din1_valid	), 
      .s_axis_b_tdata		(fir_rom_dat28  ),
      .m_axis_dout_tvalid	(	), 
      .m_axis_dout_tdata	(complex_dat28  )
    );
complex_mult u_complex_mult29(
      .aclk					(sys_clk		),
      .s_axis_a_tvalid		(fir_din1_valid	), 
      .s_axis_a_tdata		(fir_din1_dat29 ), 
      .s_axis_b_tvalid		(fir_din1_valid	), 
      .s_axis_b_tdata		(fir_rom_dat29  ),
      .m_axis_dout_tvalid	(	), 
      .m_axis_dout_tdata	(complex_dat29  )
    );
complex_mult u_complex_mult30(
      .aclk					(sys_clk		),
      .s_axis_a_tvalid		(fir_din1_valid	), 
      .s_axis_a_tdata		(fir_din1_dat30 ), 
      .s_axis_b_tvalid		(fir_din1_valid	), 
      .s_axis_b_tdata		(fir_rom_dat30  ),
      .m_axis_dout_tvalid	(	), 
      .m_axis_dout_tdata	(complex_dat30  )
    );
complex_mult u_complex_mult31(
      .aclk					(sys_clk		),
      .s_axis_a_tvalid		(fir_din1_valid	), 
      .s_axis_a_tdata		(fir_din1_dat31 ), 
      .s_axis_b_tvalid		(fir_din1_valid	), 
      .s_axis_b_tdata		(fir_rom_dat31  ),
      .m_axis_dout_tvalid	(	), 
      .m_axis_dout_tdata	(complex_dat31  )
    );

	//---add0-----------各+2bit---------------
    always@(posedge sys_clk or negedge rst_n)begin
    	if(!rst_n)begin
    		add_din0_vld0	<=	1'b0;
			add_din0_dat0	<=	84'h0;
    	end
    	else begin
			if(complex_vld0)begin
				add_din0_vld0	<=	1'b1;
				add_din0_dat0[41:0]	 <=  {{2{complex_dat0[39]}},complex_dat0[39:0]} + {{2{complex_dat1[39]}},complex_dat1[39:0]} + {{2{complex_dat2[39]}},complex_dat2[39:0]} + {{2{complex_dat3[39]}},complex_dat3[39:0]};
				add_din0_dat0[83:42] <=  {{2{complex_dat0[79]}},complex_dat0[79:40]} + {{2{complex_dat1[79]}},complex_dat1[79:40]} + {{2{complex_dat2[79]}},complex_dat2[79:40]} + {{2{complex_dat3[79]}},complex_dat3[79:40]};
			end
			else begin
				add_din0_vld0	<=	1'b0;
				add_din0_dat0	<=	add_din0_dat0;
			end
    	end
    end
    always@(posedge sys_clk or negedge rst_n)begin
    	if(!rst_n)begin
			add_din0_dat1	<=	84'h0;
    	end
    	else begin
			if(complex_vld0)begin
				add_din0_dat1[41:0]	 <=  {{2{complex_dat4[39]}},complex_dat4[39:0]} + {{2{complex_dat5[39]}},complex_dat5[39:0]} + {{2{complex_dat6[39]}},complex_dat6[39:0]} + {{2{complex_dat7[39]}},complex_dat7[39:0]};
				add_din0_dat1[83:42] <=  {{2{complex_dat4[79]}},complex_dat4[79:40]} + {{2{complex_dat5[79]}},complex_dat5[79:40]} + {{2{complex_dat6[79]}},complex_dat6[79:40]} + {{2{complex_dat7[79]}},complex_dat7[79:40]};
			end
			else begin
				add_din0_dat1	<=	add_din0_dat1;
			end
    	end
    end
    always@(posedge sys_clk or negedge rst_n)begin
    	if(!rst_n)begin
			add_din0_dat2	<=	84'h0;
    	end
    	else begin
			if(complex_vld0)begin
				add_din0_dat2[41:0]	 <=  {{2{complex_dat8[39]}},complex_dat8[39:0]} + {{2{complex_dat9[39]}},complex_dat9[39:0]} + {{2{complex_dat10[39]}},complex_dat10[39:0]} + {{2{complex_dat11[39]}},complex_dat11[39:0]};
				add_din0_dat2[83:42] <=  {{2{complex_dat8[79]}},complex_dat8[79:40]} + {{2{complex_dat9[79]}},complex_dat9[79:40]} + {{2{complex_dat10[79]}},complex_dat10[79:40]} + {{2{complex_dat11[79]}},complex_dat11[79:40]};
			end
			else begin
				add_din0_dat2	<=	add_din0_dat2;
			end
    	end
    end
    always@(posedge sys_clk or negedge rst_n)begin
    	if(!rst_n)begin
			add_din0_dat3	<=	84'h0;
    	end
    	else begin
			if(complex_vld0)begin
				add_din0_dat3[41:0]	 <=  {{2{complex_dat12[39]}},complex_dat12[39:0]} + {{2{complex_dat13[39]}},complex_dat13[39:0]} + {{2{complex_dat14[39]}},complex_dat14[39:0]} + {{2{complex_dat15[39]}},complex_dat15[39:0]};
				add_din0_dat3[83:42] <=  {{2{complex_dat12[79]}},complex_dat12[79:40]} + {{2{complex_dat13[79]}},complex_dat13[79:40]} + {{2{complex_dat14[79]}},complex_dat14[79:40]} + {{2{complex_dat15[79]}},complex_dat15[79:40]};
			end
			else begin
				add_din0_dat3	<=	add_din0_dat3;
			end
    	end
    end
    always@(posedge sys_clk or negedge rst_n)begin
    	if(!rst_n)begin
			add_din0_dat4	<=	84'h0;
    	end
    	else begin
			if(complex_vld0)begin
				add_din0_dat4[41:0]	 <=  {{2{complex_dat16[39]}},complex_dat16[39:0]} + {{2{complex_dat17[39]}},complex_dat17[39:0]} + {{2{complex_dat18[39]}},complex_dat18[39:0]} + {{2{complex_dat19[39]}},complex_dat19[39:0]};
				add_din0_dat4[83:42] <=  {{2{complex_dat16[79]}},complex_dat16[79:40]} + {{2{complex_dat17[79]}},complex_dat17[79:40]} + {{2{complex_dat18[79]}},complex_dat18[79:40]} + {{2{complex_dat19[79]}},complex_dat19[79:40]};
			end
			else begin
				add_din0_dat4	<=	add_din0_dat4;
			end
    	end
    end
    always@(posedge sys_clk or negedge rst_n)begin
    	if(!rst_n)begin
			add_din0_dat5	<=	84'h0;
    	end
    	else begin
			if(complex_vld0)begin
				add_din0_dat5[41:0]	 <=  {{2{complex_dat20[39]}},complex_dat20[39:0]} + {{2{complex_dat21[39]}},complex_dat21[39:0]} + {{2{complex_dat22[39]}},complex_dat22[39:0]} + {{2{complex_dat23[39]}},complex_dat23[39:0]};
				add_din0_dat5[83:42] <=  {{2{complex_dat20[79]}},complex_dat20[79:40]} + {{2{complex_dat21[79]}},complex_dat21[79:40]} + {{2{complex_dat22[79]}},complex_dat22[79:40]} + {{2{complex_dat23[79]}},complex_dat23[79:40]};
			end
			else begin
				add_din0_dat5	<=	add_din0_dat5;
			end
    	end
    end
    always@(posedge sys_clk or negedge rst_n)begin
    	if(!rst_n)begin
			add_din0_dat6	<=	84'h0;
    	end
    	else begin
			if(complex_vld0)begin
				add_din0_dat6[41:0]	 <=  {{2{complex_dat24[39]}},complex_dat24[39:0]} + {{2{complex_dat25[39]}},complex_dat25[39:0]} + {{2{complex_dat26[39]}},complex_dat26[39:0]} + {{2{complex_dat27[39]}},complex_dat27[39:0]};
				add_din0_dat6[83:42] <=  {{2{complex_dat24[79]}},complex_dat24[79:40]} +{{2{complex_dat25[79]}},complex_dat25[79:40]} + {{2{complex_dat26[79]}},complex_dat26[79:40]} + {{2{complex_dat27[79]}},complex_dat27[79:40]};
			end
			else begin
				add_din0_dat6	<=	add_din0_dat6;
			end
    	end
    end
    always@(posedge sys_clk or negedge rst_n)begin
    	if(!rst_n)begin
			add_din0_dat7	<=	84'h0;
    	end
    	else begin
			if(complex_vld0)begin
				add_din0_dat7[41:0]	 <=  {{2{complex_dat28[39]}},complex_dat28[39:0]} + {{2{complex_dat29[39]}},complex_dat29[39:0]} + {{2{complex_dat30[39]}},complex_dat30[39:0]} + {{2{complex_dat31[39]}},complex_dat31[39:0]};
				add_din0_dat7[83:42] <=  {{2{complex_dat28[79]}},complex_dat28[79:40]} + {{2{complex_dat29[79]}},complex_dat29[79:40]} +{{2{complex_dat30[79]}},complex_dat30[79:40]} +{{2{complex_dat31[79]}},complex_dat31[79:40]};
			end
			else begin
				add_din0_dat7	<=	add_din0_dat7;
			end
    	end
    end

	//---add1---------各+2bit-----------------
    always@(posedge sys_clk or negedge rst_n)begin
    	if(!rst_n)begin
			add_din1_vld0	<= 	1'b0;
			add_din1_dat0	<=	88'h0;
    	end
    	else begin
			if(add_din0_vld0)begin
				add_din1_vld0		 <=  1'b1;			
				add_din1_dat0[43:0]	 <=  {{2{add_din0_dat0[41]}},add_din0_dat0[41:0]} + {{2{add_din0_dat1[41]}},add_din0_dat1[41:0]} + {{2{add_din0_dat2[39]}},add_din0_dat2[41:0]} + {{2{add_din0_dat3[41]}},add_din0_dat3[41:0]};
				add_din1_dat0[87:44] <=  {{2{add_din0_dat0[83]}},add_din0_dat0[83:42]} + {{2{add_din0_dat1[83]}},add_din0_dat1[83:42]} + {{2{add_din0_dat2[83]}},add_din0_dat2[83:42]} + {{2{add_din0_dat3[83]}},add_din0_dat3[83:42]};
			end
			else begin
				add_din1_vld0	<= 	1'b0;
				add_din1_dat0	<=	add_din1_dat0;
			end
    	end
    end
    always@(posedge sys_clk or negedge rst_n)begin
    	if(!rst_n)begin
			add_din1_dat1	<=	88'h0;
    	end
    	else begin
			if(complex_vld0)begin		
				add_din1_dat1[43:0]	 <=  {{2{add_din0_dat4[41]}},add_din0_dat4[41:0]} + {{2{add_din0_dat5[41]}},add_din0_dat5[41:0]} + {{2{add_din0_dat6[41]}},add_din0_dat6[41:0]} + {{2{add_din0_dat7[41]}},add_din0_dat7[41:0]};
				add_din1_dat1[87:44] <=  {{2{add_din0_dat4[83]}},add_din0_dat4[83:42]} + {{2{add_din0_dat5[83]}},add_din0_dat5[83:42]} + {{2{add_din0_dat6[83]}},add_din0_dat6[83:42]} + {{2{add_din0_dat7[83]}},add_din0_dat7[83:42]};
			end
			else begin
				add_din1_dat1	<=	add_din1_dat1;
			end
    	end
    end

	//---add2------------各+1bit--------------
    always@(posedge sys_clk or negedge rst_n)begin
    	if(!rst_n)begin
			add_din2_vld0	<= 	1'b0;
			add_din2_dat0	<=	90'h0;
    	end
    	else begin
			if(add_din1_vld0)begin
				add_din2_vld0		 <=  1'b1;			
				add_din2_dat0[44:0]	 <=  {add_din1_dat0[43],add_din1_dat0[43:0]} + {add_din1_dat1[43],add_din1_dat1[43:0]};
				add_din2_dat0[89:45] <=  {add_din1_dat0[87],add_din1_dat0[87:44]} + {add_din1_dat1[87],add_din1_dat1[87:44]};
			end
			else begin
				add_din2_vld0	<= 	1'b0;
				add_din2_dat0	<=	add_din2_dat0;
			end
    	end
    end

	//----------------------------------------
    always@(posedge sys_clk or negedge rst_n)begin
    	if(!rst_n)begin
    		add_din2_cnt	<=	5'd0;
    	end
    	else begin
			if(add_din2_vld0)begin
				add_din2_cnt <=	add_din2_cnt + 1'b1;
			end
			else begin
				add_din2_cnt <= add_din2_cnt;
			end
    	end
    end
	
    always@(posedge sys_clk or negedge rst_n)begin
    	if(!rst_n)begin
			fir_out_tlast	<= 	1'b0;
    	end
    	else begin
			if(add_din2_cnt == 5'd31)begin
				fir_out_tlast	<= 	1'b1;
			end
			else begin
				fir_out_tlast	<= 	1'b0;
			end
    	end
    end	
	
    always@(posedge sys_clk or negedge rst_n)begin
    	if(!rst_n)begin
			fir_out_valid	<= 	1'b0;
			fir_out_dat		<=	90'h0;
    	end
    	else begin
			if(add_din2_vld0)begin
				fir_out_valid		 <=  1'b1;			
				fir_out_dat[44:0]	 <=  add_din2_dat0[44:0] ;	//add_din2_dat0[44:0]  实部		有效位-add_din2_dat0[37:0]
				fir_out_dat[89:45] 	 <=  add_din2_dat0[89:45];	//add_din2_dat0[89:45] 虚部		有效位-add_din2_dat0[82:45]	
			end
			else begin
				fir_out_valid	<= 	1'b0;
				fir_out_dat		<=	fir_out_dat;
			end
    	end
    end	
	

//2022/12/10
wire overflow_protect_real;
assign overflow_protect_real = (fir_out_dat[21:18] == 4'b1111)|(fir_out_dat[21:18] == 4'b0000);

wire overflow_protect_imag;
assign overflow_protect_imag =(fir_out_dat[45:42] == 4'b1111)|(fir_out_dat[45:42] == 4'b0000);

reg [44:0]fir_tdata_real = 0;
reg [44:0]fir_tdata_imag = 0;

// always@(posedge sys_clk)begin
//     if(overflow_protect_real)
//         fir_tdata_real <= fir_out_dat[21:6];
//     else
//         fir_tdata_real <= {{fir_out_dat[21]},{15{~fir_out_dat[21]}}};
// end

always@(posedge sys_clk)begin
	if(!rst_n)
        fir_tdata_real <= 'd0;
    else
        fir_tdata_real <= fir_out_dat[44:0];
end


// always@(posedge sys_clk )begin
//     if(overflow_protect_imag)
//         fir_tdata_imag <= fir_out_dat[45:30];
//     else
//         fir_tdata_imag <= {{fir_out_dat[45]},{15{~fir_out_dat[45]}}};
// end

always@(posedge sys_clk )begin
	if(!rst_n)
        fir_tdata_imag <= 'd0;
    else
        fir_tdata_imag <= fir_out_dat[89:45];
end

//get the true data
wire     s_axis_cartesian_tvalid;

wire [44:0] re_data_i;
wire [44:0] im_data_i;
wire [89:0] mult_re_result;
wire [89:0] mult_im_result;
reg [90:0] add_result;

assign re_data_i = fir_tdata_real;
assign im_data_i = fir_tdata_imag;
assign s_axis_cartesian_tvalid = fir_out_valid;

mult_gen_0 mult_re (

		.CLK(	sys_clk   	   ),  	// input wire CLK
		.A	(	re_data_i	   ),   // input wire [15 : 0] A
		.B	(	re_data_i	   ),   // input wire [15 : 0] B
		.P	(	mult_re_result )  	// output wire [31 : 0] P
	);

mult_gen_1 mult_im (

		.CLK(	sys_clk    	    ),  // input wire CLK
		.A	(	im_data_i	    ),  // input wire [15 : 0] A
		.B	(	im_data_i	    ),  // input wire [15 : 0] B
		.P	(	mult_im_result	)   // output wire [31: 0] P
	);


// c_addsub_0 add (

// 		.A	(	mult_re_result  ) ,  // input wire [31 : 0] A
// 		.B	(	mult_im_result  ) ,  // input wire [31 : 0] B
// 		.CLK(	sys_clk    	    ) ,  //input wire CLK
// 		.S	(	add_result	    )    // output wire [32 : 0] S
// 	);
always@(posedge sys_clk )begin
	if(!rst_n)
		add_result <= 'd0 ;
	else 
		add_result <= mult_im_result + mult_re_result ;
end

reg 	m_axis_amp_tvalid_r  = 1'b0	;
reg 	m_axis_amp_tvalid_r1 = 1'b0 ;
reg 	m_axis_amp_tvalid_r2 = 1'b0 ; 
reg 	m_axis_amp_tvalid_r3 = 1'b0 ;
reg 	m_axis_amp_tvalid_r4 = 1'b0 ;
reg 	m_axis_amp_tvalid_r5 = 1'b0 ;



always@(posedge sys_clk)
begin 
	m_axis_amp_tvalid_r  <= s_axis_cartesian_tvalid	;
	m_axis_amp_tvalid_r1 <= m_axis_amp_tvalid_r 	;
	m_axis_amp_tvalid_r2 <= m_axis_amp_tvalid_r1 	; 
	m_axis_amp_tvalid_r3 <= m_axis_amp_tvalid_r2 	;
	m_axis_amp_tvalid_r4 <= m_axis_amp_tvalid_r3 	;
	m_axis_amp_tvalid_r5 <= m_axis_amp_tvalid_r4 	;
end 

assign o_rdamp_tlast	= 	m_axis_amp_tvalid_r4 && (~m_axis_amp_tvalid_r3)	;
assign o_rdamp_tvalid 	=	m_axis_amp_tvalid_r4	                        ;
assign o_rdamp_tdata 	= 	add_result[63:0]	                            ;



endmodule

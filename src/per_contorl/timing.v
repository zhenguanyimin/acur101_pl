`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Autel
// Engineer: A22530
// 
// Create Date: 2022/08/05 10:37:14
// Design Name: timing
// Module Name: timing
// Project Name: ARAU100
// Target Devices: ZYNQ7100
// Tool Versions: ViVado 2021.1
// Description:  Timing Radar Working with parameters
// 
// Dependencies: Wave_code,work_mode
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module timing(

   input sys_clk                    ,//100MH
   input rstn                       ,
   input [31:0] CPI_DELAY            ,//CPI��ʱ������ , ��Ϊ32λ�Ӵ�delay ʱ��
   input [15:0] PRI_PERIOD          ,//PRT������
   input [7:0] PRI_NUM              ,//ÿ������������pri����
   input [7:0] PRI_PULSE_WIDTH      ,//PRI�������
   input [15:0] START_SAMPLE        ,//��ʼ������
   input [15:0] SAMPLE_LENGTH       ,//�������

   input       first_chrip_disable  ,
   output reg  PRI                  ,// ÿ���ظ����ڵ���ʼʱ��
   output reg  CPIB                 ,//CPI BEGIN  ���µ�״̬�����£��µĴ������ڿ�ʼ
   output reg CPIE                  ,//CPI END �����ڴ����������ݴ��䣬������ 
   output reg sample_gate              ,
   output reg Tx_En                 ,//����ʹ���ź�
   output reg Rx_En                 ,//����ʹ���ź�
   input[7:0]WAVE_CODE              
);


reg [31:0] CPI_DELAY_d0      = 'd0;//CPI��ʱ������ , ��Ϊ32λ�Ӵ�delay ʱ��
reg [15:0] PRI_PERIOD_d0     = 'd0;//PRT������
reg [7:0]  PRI_NUM_d0        = 'd0;//ÿ������������pri����
reg [7:0]  PRI_PULSE_WIDTH_d0= 'd0;//PRI�������
reg [15:0] START_SAMPLE_d0   = 'd0;//��ʼ������
reg [15:0] SAMPLE_LENGTH_d0  = 'd0;//�������

reg [31:0] CPI_DELAY_d1      = 'd0;//CPI��ʱ������ , ��Ϊ32λ�Ӵ�delay ʱ��
reg [15:0] PRI_PERIOD_d1     = 'd0;//PRT������
reg [7:0]  PRI_NUM_d1        = 'd0;//ÿ������������pri����
reg [7:0]  PRI_PULSE_WIDTH_d1= 'd0;//PRI�������
reg [15:0] START_SAMPLE_d1   = 'd0;//��ʼ������
reg [15:0] SAMPLE_LENGTH_d1  = 'd0;//�������

localparam [15:0] CPI_DELAY_PARA        = 16'd750;
localparam [15:0] PRI_PERIOD_PARA       = 16'd5275;
localparam [15:0] START_SAMPLE_PARA        = 16'd1000;
localparam [15:0] SAMPLE_LENGTH_PARA       = 16'd4125;
localparam [7:0]  PRI_NUM_PARA          = 8'd32;
localparam [7:0] PRI_PULSE_WIDTH_PARA   = 8'd50;

reg [31:0] cpi_delay_reg;
reg [15:0] pri_period_reg;
reg [15:0] start_sample_reg;
reg [15:0] sample_length_reg;
reg [7:0]  pri_num_reg          ;
reg [7:0]  pri_pulse_width_reg  ;

reg        first_chrip_disable_d1 ;
reg        first_chrip_disable_d2 ;

always @(posedge sys_clk) begin
    CPI_DELAY_d0       <= CPI_DELAY;       
    PRI_PERIOD_d0      <= PRI_PERIOD;        
    PRI_NUM_d0         <= PRI_NUM;        
    PRI_PULSE_WIDTH_d0 <= PRI_PULSE_WIDTH; 
    START_SAMPLE_d0    <= START_SAMPLE;    
    SAMPLE_LENGTH_d0   <= SAMPLE_LENGTH;   
end
always @(posedge sys_clk) begin
    CPI_DELAY_d1       <= CPI_DELAY_d0;       
    PRI_PERIOD_d1      <= PRI_PERIOD_d0;        
    PRI_NUM_d1         <= PRI_NUM_d0;        
    PRI_PULSE_WIDTH_d1 <= PRI_PULSE_WIDTH_d0; 
    START_SAMPLE_d1    <= START_SAMPLE_d0;    
    SAMPLE_LENGTH_d1   <= SAMPLE_LENGTH_d0;   
end

always@(posedge sys_clk or negedge rstn)
    if(!rstn) begin 
        first_chrip_disable_d1 <= 'd0 ;
        first_chrip_disable_d2 <= 'd0 ;
    end
    else begin
        first_chrip_disable_d1 <= first_chrip_disable ;
        first_chrip_disable_d2 <= first_chrip_disable_d1 ;
    end
//*************************************************************
always@(posedge sys_clk or negedge rstn)
if(!rstn) begin 
    cpi_delay_reg       <=  CPI_DELAY_PARA -1'b1          ; 
    pri_period_reg      <=  PRI_PERIOD_PARA   -1'b1       ;
    start_sample_reg    <=  START_SAMPLE_PARA -1'b1        ;
    sample_length_reg   <=  SAMPLE_LENGTH_PARA-1'b1        ;
    pri_num_reg         <=  PRI_NUM_PARA  -1'b1           ;
    pri_pulse_width_reg <=  PRI_PULSE_WIDTH_PARA -1'b1    ;
    
end 
else if( CPIB ) begin
    cpi_delay_reg       <=  CPI_DELAY_d1 -1'b1          ; 
    pri_period_reg      <=  PRI_PERIOD_d1  -1'b1        ;
    start_sample_reg    <=  START_SAMPLE_d1 -1'b1       ;
    sample_length_reg   <=  SAMPLE_LENGTH_d1 -1'b1      ;
    pri_num_reg         <=  PRI_NUM_d1  -1'b1           ;
    pri_pulse_width_reg <=  PRI_PULSE_WIDTH_d1 -1'b1    ;
   end 
else  begin
    cpi_delay_reg       <=  cpi_delay_reg          ; 
    pri_period_reg      <=  pri_period_reg         ;
    start_sample_reg    <=  start_sample_reg      ;
    sample_length_reg   <=  sample_length_reg      ;  
    pri_num_reg         <=  pri_num_reg            ;
    pri_pulse_width_reg <=  pri_pulse_width_reg    ;
end 
//*************************************************
reg[21:0]pri_cnt;

reg [7:0]pri_num_cnt;

always@(posedge sys_clk or negedge rstn)begin
    if(!rstn) begin 
        pri_cnt <= 16'd0;
    end 
    else if((pri_cnt == pri_period_reg + cpi_delay_reg+1) && (pri_num_cnt == pri_num_reg)) 
        pri_cnt <= 16'd0;
    else if((pri_cnt == pri_period_reg) && (pri_num_cnt < pri_num_reg)) 
        pri_cnt <= 16'd0;
    else 
        pri_cnt <= pri_cnt + 16'd1;
end
//*****************************************
always@(posedge sys_clk or negedge rstn)begin
    if(!rstn) begin 
        pri_num_cnt <= 8'd0;
    end 
    else if(pri_num_cnt == pri_num_reg && pri_cnt == pri_period_reg + cpi_delay_reg+1 )
        pri_num_cnt  <=  8'd0;
    else if(pri_num_cnt < pri_num_reg && pri_cnt == pri_period_reg) 
        pri_num_cnt <= pri_num_cnt + 8'd1;
    else 
        pri_num_cnt <= pri_num_cnt;
end
//**********output CPIB***********************************************
always@(posedge sys_clk or negedge rstn)
    if(!rstn) begin 
        CPIB <= 1'd0;
    end 
    else if((pri_num_cnt == 8'd0 )&& ( pri_cnt <= pri_pulse_width_reg) )
        CPIB  <=  1'd1;
    else 
        CPIB  <=  1'b0;
//**********output CPIE***********************************************
always@(posedge sys_clk or negedge rstn)
    if(!rstn) begin 
        CPIE <= 1'd0;
    end 
    else if((pri_num_cnt == pri_num_reg )&&( pri_cnt == pri_period_reg+1) )
        CPIE  <=  1'd1;
    else if(pri_num_cnt == pri_num_reg && pri_cnt == pri_period_reg + pri_pulse_width_reg +2)
        CPIE  <=  1'b0;
    else 
        CPIE  <=  CPIE;
//*******************PRI*********************************************
//**********output PRI***********************************************

reg         PRI_d1  ;
reg         PRI_d2  ;
reg         CPIB_d1 ;
reg         CPIB_d2 ;
reg [8:0]   PRI_cnt ;

always@(posedge sys_clk or negedge rstn)
    if(!rstn) begin
        PRI_d1 <= 'd0 ;
        PRI_d2 <= 'd0 ;
    end
    else begin
        PRI_d1 <= PRI ;
        PRI_d2 <= PRI_d1 ;
    end

always@(posedge sys_clk or negedge rstn)
    if(!rstn) begin
        CPIB_d1 <= 'd0 ;
        CPIB_d2 <= 'd0 ;
    end
    else begin
        CPIB_d1 <= CPIB ;
        CPIB_d2 <= CPIB_d1 ;
    end

always@(posedge sys_clk or negedge rstn)
    if(!rstn)
        PRI_cnt <= 'd0 ;
    else if(~CPIB_d2 && CPIB_d1)
        PRI_cnt <= 'd0 ;
    else if(PRI_d2 && ~ PRI_d1)
        PRI_cnt <= PRI_cnt + 1'b1 ;
    else 
        PRI_cnt <= PRI_cnt ;

always@(posedge sys_clk or negedge rstn)
    if(!rstn) begin 
        PRI <= 1'd0;
    end 
    else if( pri_cnt == 8'd0 )
        PRI  <=  1'd1;
    else if( pri_cnt >= pri_pulse_width_reg+1  )
        PRI  <=  1'b0;
    else 
        PRI <= PRI;
//***************************************************************************

always@(posedge sys_clk or negedge rstn)
    if(!rstn) begin 
        Tx_En <= 1'd0;
        Rx_En <= 1'd0;
    end 
    else if( pri_cnt == 16'd0 )begin 
        Tx_En <= 1'd1;
        Rx_En <= 1'd1;
    end 
//else if( pri_cnt == 16'd20500  )begin 
    else if( pri_cnt == start_sample_reg +  sample_length_reg + 2)begin 
        Tx_En <= 1'd0;
        Rx_En <= 1'd0;
    end 
    else begin 
        Tx_En <= Tx_En;
        Rx_En <= Rx_En;
    end 
//***************************************************************************
always@(posedge sys_clk or negedge rstn)
    if(!rstn) begin 
        sample_gate <= 1'd0;
    end 
    else if(first_chrip_disable_d2 && (PRI_cnt == 'd1 || PRI_cnt == 'd2))
        sample_gate <= 'd0 ;
    else if( pri_cnt == start_sample_reg )
        sample_gate  <=  1'd1;
//else if( pri_cnt == start_sample_reg +  sample_length_reg - 28)//adc sim data 16384
    else if( pri_cnt == start_sample_reg +  sample_length_reg )
        sample_gate  <=  1'b0;
    else 
        sample_gate <= sample_gate;
//***************************************************************************

//----------------------------------debug_signal------------------------------------
endmodule
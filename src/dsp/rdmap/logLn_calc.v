`timescale 1 ps / 1 ps

module logLn_calc(

   input wire        clk_160mhz         ,//100MH
   input wire 		   rst     			      ,

   input wire        cpie               ,
   input wire        fir_enable         ,
   input wire [15:0] horizontal_pitch   ,  

   input wire        rdm_amp_data_valid ,
   input wire [63:0] rdm_amp_data	      , 


   input      [63:0] fir_rdmap          ,   
   input             fir_rdmap_valid    ,

   output reg        rdmap_log2_data_last = 0,
   output reg        rdmap_log2_data_valid = 0,
   output reg [31:0] rdmap_log2_data = 0

);
//calc log2(x) = Ln(x)/Ln(2)


reg   fir_enable_d1 ;
reg   fir_enable_d2 ;

reg   cpie_d1 ;
reg   cpie_d2 ;
always @(posedge clk_160mhz ) begin
    if(rst) begin
      fir_enable_d1 <= 'd0  ;
      fir_enable_d2 <= 'd0  ; 
    end  
    else begin
      fir_enable_d1 <= fir_enable   ;
      fir_enable_d2 <= fir_enable_d1;
    end
end
always @(posedge clk_160mhz) begin
  if(rst) begin
    cpie_d1  <= 'd0 ;
    cpie_d2  <= 'd0 ;
  end
  else begin
    cpie_d1  <= cpie    ;
    cpie_d2  <= cpie_d1 ;
  end
end

reg   fir_enable_sync ;
always @(posedge clk_160mhz ) begin
    if(rst)
      fir_enable_sync <= 'd0 ;
    // else if(cpie_d2)
    else
      fir_enable_sync <= fir_enable_d2 ;
end

reg           s_axis_a_tvalid ;
reg   [63:0]  s_axis_a_tdata  ;

always @(posedge clk_160mhz) begin
    if(rst)
      s_axis_a_tvalid <= 'd0 ;
    else if(fir_enable_sync)
      s_axis_a_tvalid <= fir_rdmap_valid ;
    else
      s_axis_a_tvalid <= rdm_amp_data_valid ;
end

always @(posedge clk_160mhz) begin
    if(rst)
      s_axis_a_tdata <= 'd0 ;
    else if(fir_enable_sync)
      s_axis_a_tdata <= fir_rdmap ;
    else 
      s_axis_a_tdata <= rdm_amp_data ;
end

reg [15:0]  horizontal_pitch_d1 ;
reg [15:0]  horizontal_pitch_d2 ;

always @(posedge clk_160mhz) begin
    if(rst) begin
      horizontal_pitch_d1 <= 'd0 ;
      horizontal_pitch_d2 <= 'd0 ;
    end
    else begin
      horizontal_pitch_d1 <= horizontal_pitch   ;
      horizontal_pitch_d2 <= horizontal_pitch_d1;
    end
end

reg [15:0]  horizontal_pitch_sync ;

always @(posedge clk_160mhz) begin
    if(rst) begin
      horizontal_pitch_sync <= 'd0 ;
    end
    else if(cpie_d2) begin 
      horizontal_pitch_sync <= horizontal_pitch_d2 ;
    end
end

wire s_axis_a_tready_fix2float;
wire m_axis_result_tvalid_fix2float;
wire [31:0] m_axis_result_tdata_fix2float;

floating_point_fix2float U_floating_point_fix2float (
  .aclk                 (clk_160mhz                     ),        // input wire aclk
  .aresetn				      (~rst    						            ),
  .s_axis_a_tvalid      (s_axis_a_tvalid                ),        // input wire s_axis_a_tvalid
  .s_axis_a_tready      (s_axis_a_tready_fix2float      ),        // output wire s_axis_a_tready
  .s_axis_a_tdata       (s_axis_a_tdata                 ),        // input wire [31 : 0] s_axis_a_tdata
  .m_axis_result_tvalid (m_axis_result_tvalid_fix2float ),        // output wire m_axis_result_tvalid
  .m_axis_result_tready (1'B1                           ),        // input wire m_axis_result_tready
  .m_axis_result_tdata  (m_axis_result_tdata_fix2float  )         // output wire [31 : 0] m_axis_result_tdata
);





wire s_axis_a_tready_logLn;
wire m_axis_result_tvalid_logLn;
wire [31:0] m_axis_result_tdata_logLn;

floating_point_logLn U_floating_point_logLn (
  .aclk                 (clk_160mhz                     ),         // input wire aclk
  .s_axis_a_tvalid      (m_axis_result_tvalid_fix2float ),         // input wire s_axis_a_tvalid
  .s_axis_a_tready      (s_axis_a_tready_logLn          ),         // output wire s_axis_a_tready
  .s_axis_a_tdata       (m_axis_result_tdata_fix2float  ),         // input wire [31 : 0] s_axis_a_tdata
  .m_axis_result_tvalid (m_axis_result_tvalid_logLn     ),         // output wire m_axis_result_tvalid
  .m_axis_result_tready (s_axis_a_tready_fix2float      ),         // input wire m_axis_result_tready
  .m_axis_result_tdata  (m_axis_result_tdata_logLn      )          // output wire [31 : 0] m_axis_result_tdata
);




wire s_axis_a_tready_float2fix;
wire m_axis_result_tvalid_float2fix;
wire [31:0] m_axis_result_tdata_float2fix;

floating_point_float2fix U_floating_point_float2fix (
  .aclk                 (clk_160mhz                     ),        // input wire aclk
  .s_axis_a_tvalid      (m_axis_result_tvalid_logLn     ),        // input wire s_axis_a_tvalid
  .s_axis_a_tready      (s_axis_a_tready_float2fix      ),        // output wire s_axis_a_tready
  .s_axis_a_tdata       (m_axis_result_tdata_logLn      ),        // input wire [31 : 0] s_axis_a_tdata
  .m_axis_result_tvalid (m_axis_result_tvalid_float2fix ),        // output wire m_axis_result_tvalid
  .m_axis_result_tready (s_axis_a_tready_logLn          ),        // input wire m_axis_result_tready
  .m_axis_result_tdata  (m_axis_result_tdata_float2fix  )         // output wire [31 : 0] m_axis_result_tdata
);



wire [63:0] P52;
mult_log U_mult_Ln (
  .CLK(clk_160mhz                  ),  // input wire CLK
  .A(32'd387270501                 ),  // input wire [31 : 0] A
  .B(m_axis_result_tdata_float2fix ),  // input wire [31 : 0] B
  .P(P52                           )   // output wire [63 : 0] P
);





reg [19:0] log2_result_data = 0;
always @ (posedge clk_160mhz)
begin
    log2_result_data <= P52[63:44] + &P52[43:33];//8
end






reg log2_result_tvalid_r1 = 0;
reg log2_result_tvalid_r2 = 0;
reg log2_result_tvalid_r3 = 0;
reg log2_result_tvalid_r4 = 0;
reg log2_result_tvalid_r5 = 0;
reg log2_result_tvalid_r6 = 0;
reg log2_result_tvalid_r7 = 0;
reg log2_result_tvalid_r8 = 0;
reg log2_result_tvalid_r9 = 0;
reg log2_result_tvalid_r10 = 0;
reg log2_result_tvalid_r11 = 0;
reg log2_result_tvalid_r12 = 0;


always @ (posedge clk_160mhz)
begin
    log2_result_tvalid_r1 <= m_axis_result_tvalid_float2fix ;
    log2_result_tvalid_r2 <= log2_result_tvalid_r1          ;
    log2_result_tvalid_r3 <= log2_result_tvalid_r2          ;
    log2_result_tvalid_r4 <= log2_result_tvalid_r3          ;
    log2_result_tvalid_r5 <= log2_result_tvalid_r4          ;
    log2_result_tvalid_r6 <= log2_result_tvalid_r5          ;
	log2_result_tvalid_r7 <= log2_result_tvalid_r6          ;
	
	log2_result_tvalid_r8 <= log2_result_tvalid_r7          ;
	log2_result_tvalid_r9 <= log2_result_tvalid_r8          ;
	log2_result_tvalid_r10 <= log2_result_tvalid_r9         ;
	log2_result_tvalid_r11 <= log2_result_tvalid_r10        ;
	log2_result_tvalid_r12 <= log2_result_tvalid_r11        ;
end


wire vsync_pe = log2_result_tvalid_r1 && ~log2_result_tvalid_r2;


reg [31:0] frame_cnt = 0;
always @ (posedge clk_160mhz)
begin
    if(vsync_pe == 1'b1)
	  begin
	      frame_cnt <= frame_cnt + 1;
	  end
	else
	  begin
	      frame_cnt <= frame_cnt;
	  end
end


wire frame_start_flag  ;
assign frame_start_flag = log2_result_tvalid_r7 && ~log2_result_tvalid_r11;

wire frame_cnt_flag  ;
assign frame_cnt_flag = log2_result_tvalid_r11 && ~log2_result_tvalid_r12;


wire frame_end_flag  ;
assign frame_end_flag = ~log2_result_tvalid_r3 && log2_result_tvalid_r7;


always @ (posedge clk_160mhz)
begin
    if(log2_result_tvalid_r7 == 1'b1)
	  begin
	      rdmap_log2_data_valid <= 1'b1;
		  
		  if(frame_start_flag == 1'b1)
		    begin
			    rdmap_log2_data <= {16'hffff,horizontal_pitch_sync};
		    end
	      else if(frame_cnt_flag == 1'b1)
		    begin
			    rdmap_log2_data <= frame_cnt;
			end
		  else if(frame_end_flag == 1'b1)
		    begin
			    rdmap_log2_data <= 32'h3a5a_3a5a;
			end
		  else
		    begin
			    rdmap_log2_data <= {log2_result_data[15:2],2'd0};//8
			end
	  end
	else
	  begin
	      rdmap_log2_data_valid <= 'd0;
          rdmap_log2_data       <= 'd0;
	  end
end

always @ (posedge clk_160mhz)
begin
    if(log2_result_tvalid_r6 == 1'b0 && log2_result_tvalid_r7 == 1'b1)
	  begin
	      rdmap_log2_data_last <= 1'b1;
	  end
	else
	  begin
	      rdmap_log2_data_last <= 1'b0;
	  end
end



















endmodule


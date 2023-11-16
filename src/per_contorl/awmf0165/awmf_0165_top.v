module awmf_0165_top
(

    input 	wire            clk		         ,
    input 	wire            rst		         ,

	input 	wire 			clk_20m			 ,
	input	wire  			cpie_i			 ,
	
	input	wire 			Rx_En			 ,
	input 	wire 			Tx_En 			 ,

	input 	wire  [31:0]	awmf0165_ctr 	 ,
	input 	wire  [3 :0]	u8_awmf0165_ctr	 ,
	input 	wire  [31:0]	awmf0165_select  ,
	input 	wire  [1:0]		u8_awmf0165_select,
	input 	wire 			awmf0165_pspl_select ,


	input 	wire 			u0_write_data_en ,
	input 	wire  [31:0]	u0_write_data_in ,

	input 	wire 			u1_write_data_en ,
	input 	wire  [31:0]	u1_write_data_in ,

	input 	wire 			u2_write_data_en ,
	input 	wire  [31:0]	u2_write_data_in ,

	input 	wire 			u3_write_data_en ,
	input 	wire  [31:0]	u3_write_data_in ,

	input 	wire 			u4_write_data_en ,
	input 	wire  [31:0]	u4_write_data_in ,

	input	wire  [4 :0]    awmf_sdi_i  	 ,
	output	wire  [4 :0]    awmf_sdo_o  	 ,
	output	wire  [4 :0]    awmf_pdo_o  	 ,
	output	wire  [4 :0]    awmf_ldb_o  	 ,
	output	wire  [4 :0]    awmf_csb_o  	 ,
	output	wire  [4 :0]    awmf_clk_o  	 ,
	output	wire  [9 :0]    awmf_mode_o 	 ,

	output  reg   [255:0]	u0_awmf0165_reg  ,
	output  reg   [255:0]	u1_awmf0165_reg  ,
	output  reg   [255:0]	u2_awmf0165_reg  ,
	output  reg   [255:0]	u3_awmf0165_reg  ,
 	output  reg   [255:0]	u4_awmf0165_reg  ,

	output 	wire 			wr_irp		     ,
	output 	wire  			rd_irp 			 ,
	output 	reg   [9:0]		awmf_0165_status  

);

//---------------------------------group0----------------------------------
wire	[255:0]		u0_read_data_o  		;
wire 				u0_adsdata_fifo_empty	;
wire				u0_chain_wr_en			;
// wire 	[255:0]		u0_chain_data_i			;
wire	[239:0]		u0_chain_data_o			;
wire 	[239:0] 	u0_chain_data_o_i		;
wire				u0_chain_busy_i			;
wire 				u0_chain_wr_i			;
wire    [1 :0] 		u0_tx_mode_i			;

wire 				u0_fifo_wr_o			;
wire 	[255:0]		u0_chain_rd_data_o		;
wire 				u0_busy_o				;
wire 				u0_read_data_en			;
// reg 	[255:0] 	u0_awmf0165_reg			;
wire 				u0_rd_complete_o		;
wire 				u0_wr_complete_o		;
wire 				u0_awmf_0165_busy		;

awmf0165_write_data_buffer u0_awmf0165_write_data_buffer
(
	.sys_rst				(rst					),
	.write_clk				(clk					),
	.write_data_en			(u0_write_data_en		),
	.write_data_in			(u0_write_data_in		),
	.read_clk				(clk_20m				),
	.read_data_en			(u0_read_data_en		),
	.adsdata_fifo_empty		(u0_adsdata_fifo_empty	),
	.read_data_o			(u0_read_data_o			)

);

awmf_chain_ctrl u0_awmf_chain_ctrl
(
	.clk_i			(clk_20m				),
	.rst_i			(rst					),

	.cpie_i			(cpie_i					),
	.fifo_empty_i	(u0_adsdata_fifo_empty	),
	.fifo_rd_o		(u0_read_data_en		),
	.fifo_wr_o		(u0_fifo_wr_o			),
	.chain_rd_data_o(u0_chain_rd_data_o		),
	.busy_o			(u0_busy_o				),
	.chain_wr_en	(u0_chain_wr_en			),
	.chain_data_i	(u0_read_data_o			),
	.chain_data_o	(u0_chain_data_o		),
	.chain_data_o_i	(u0_chain_data_o_i		),
	.chain_busy_i	(u0_chain_busy_i		),
	.chain_wr_i		(u0_chain_wr_i			),
	.rd_complete_o	(u0_rd_complete_o		),
	.wr_complete_o	(u0_wr_complete_o		),
	.awmf_0165_busy	(u0_awmf_0165_busy		)

);

awmf0165_chain u0_awmf0165_chain
(

	.clk_i			(clk_20m				),
	.rst_i			(rst					),
	.tx_en_i		(u0_chain_wr_en			),
	.tx_mode_i		(u0_tx_mode_i			),
	.tx_data_i		(u0_chain_data_o		),
	.rx_data_o		(u0_chain_data_o_i		),
	.tx_busy		(u0_chain_busy_i		),
	.awmf_sdi_i		(awmf_sdi_i[0]			),
	.awmf_sdi_o		(awmf_sdo_o[0]			),
	.awmf_pdi_o		(awmf_pdo_o[0]			),
	.awmf_ldb_o		(awmf_ldb_o[0]			),
	.awmf_csb_o		(awmf_csb_o[0]			),
	.awmf_clk_o		(awmf_clk_o[0]			)
);

always @ (posedge clk_20m)	begin
	if(rst)
		u0_awmf0165_reg <= 'd0;
	else if(u0_fifo_wr_o == 1'b1 )
		u0_awmf0165_reg <= u0_chain_rd_data_o;
	else
		u0_awmf0165_reg <= u0_awmf0165_reg;
end
assign u0_chain_wr_i = awmf0165_ctr[0]	;
assign u0_tx_mode_i  = awmf0165_ctr[2:1];


//---------------------------------group1----------------------------------
wire	[255:0]		u1_read_data_o  		;
wire 				u1_adsdata_fifo_empty	;
wire				u1_chain_wr_en			;
wire 	[255:0]		u1_chain_data_i			;
wire	[239:0]		u1_chain_data_o			;
wire 	[239:0] 	u1_chain_data_o_i		;
wire				u1_chain_busy_i			;
wire 				u1_chain_wr_i			;
wire    [1 :0] 		u1_tx_mode_i			;

wire 				u1_fifo_wr_o			;
wire 	[255:0]		u1_chain_rd_data_o		;
wire 				u1_busy_o				;
// reg 	[255:0] 	u1_awmf0165_reg			;
wire 				u1_rd_complete_o		;
wire 				u1_wr_complete_o		;
wire 				u1_awmf_0165_busy		;
wire 				u1_read_data_en 		;

awmf0165_write_data_buffer u1_awmf0165_write_data_buffer
(
	.sys_rst				(rst					),			
	.write_clk				(clk					), 	   
	.write_data_en			(u1_write_data_en		),
	.write_data_in			(u1_write_data_in		),
	.read_clk				(clk_20m				),
	.read_data_en			(u1_read_data_en		),
	.adsdata_fifo_empty		(u1_adsdata_fifo_empty	),
	.read_data_o			(u1_read_data_o			)	

);

awmf_chain_ctrl u1_awmf_chain_ctrl
(
	.clk_i			(clk_20m				),
	.rst_i			(rst					),

	.cpie_i			(cpie_i					),
	.fifo_empty_i	(u1_adsdata_fifo_empty	),
	.fifo_rd_o		(u1_read_data_en		),
	.fifo_wr_o		(u1_fifo_wr_o			),
	.chain_rd_data_o(u1_chain_rd_data_o		),
	.busy_o			(u1_busy_o				),
	.chain_wr_en	(u1_chain_wr_en			),
	.chain_data_i	(u1_read_data_o			),
	.chain_data_o	(u1_chain_data_o		),
	.chain_data_o_i	(u1_chain_data_o_i		),
	.chain_busy_i	(u1_chain_busy_i		),
	.chain_wr_i		(u1_chain_wr_i			),
	.rd_complete_o	(u1_rd_complete_o		),
	.wr_complete_o	(u1_wr_complete_o		),
	.awmf_0165_busy	(u1_awmf_0165_busy		)

);

awmf0165_chain u1_awmf0165_chain
(

	.clk_i			(clk_20m				),
	.rst_i			(rst					),
	.tx_en_i		(u1_chain_wr_en			),
	.tx_mode_i		(u1_tx_mode_i			),
	.tx_data_i		(u1_chain_data_o		),
	.rx_data_o		(u1_chain_data_o_i		),
	.tx_busy		(u1_chain_busy_i		),
	.awmf_sdi_i		(awmf_sdi_i[1]			),
	.awmf_sdi_o		(awmf_sdo_o[1]			),
	.awmf_pdi_o		(awmf_pdo_o[1]			),
	.awmf_ldb_o		(awmf_ldb_o[1]			),
	.awmf_csb_o		(awmf_csb_o[1]			),
	.awmf_clk_o		(awmf_clk_o[1]			)
);

always @ (posedge clk_20m)	begin
	if(rst)
		u1_awmf0165_reg <= 'd0;
	else if(u1_fifo_wr_o == 1'b1 )
		u1_awmf0165_reg <= u1_chain_rd_data_o;
	else
		u1_awmf0165_reg <= u1_awmf0165_reg;
end
assign u1_chain_wr_i = awmf0165_ctr[4]	;
assign u1_tx_mode_i  = awmf0165_ctr[6:5];


//---------------------------------group2----------------------------------
wire	[255:0]		u2_read_data_o  		;
wire 				u2_adsdata_fifo_empty	;
wire				u2_chain_wr_en			;
wire 	[255:0]		u2_chain_data_i			;
wire	[239:0]		u2_chain_data_o			;
wire 	[239:0] 	u2_chain_data_o_i		;
wire				u2_chain_busy_i			;
wire 				u2_chain_wr_i			;
wire    [1 :0] 		u2_tx_mode_i			;

wire 				u2_fifo_wr_o			;
wire 	[255:0]		u2_chain_rd_data_o		;
wire 				u2_busy_o				;
// reg 	[255:0] 	u2_awmf0165_reg			;
wire 				u2_rd_complete_o		;
wire 				u2_wr_complete_o		;
wire  				u2_awmf_0165_busy		;
wire u2_read_data_en		;

awmf0165_write_data_buffer u2_awmf0165_write_data_buffer
(
	.sys_rst				(rst					),			
	.write_clk				(clk					), 	   
	.write_data_en			(u2_write_data_en		),
	.write_data_in			(u2_write_data_in		),
	.read_clk				(clk_20m				),
	.read_data_en			(u2_read_data_en		),
	.adsdata_fifo_empty		(u2_adsdata_fifo_empty	),
	.read_data_o			(u2_read_data_o			)	

);

awmf_chain_ctrl u2_awmf_chain_ctrl
(
	.clk_i			(clk_20m				),
	.rst_i			(rst					),

	.cpie_i			(cpie_i					),
	.fifo_empty_i	(u2_adsdata_fifo_empty	),
	.fifo_rd_o		(u2_read_data_en		),
	.fifo_wr_o		(u2_fifo_wr_o			),
	.chain_rd_data_o(u2_chain_rd_data_o		),
	.busy_o			(u2_busy_o				),
	.chain_wr_en	(u2_chain_wr_en			),
	.chain_data_i	(u2_read_data_o			),
	.chain_data_o	(u2_chain_data_o		),
	.chain_data_o_i	(u2_chain_data_o_i		),
	.chain_busy_i	(u2_chain_busy_i		),
	.chain_wr_i		(u2_chain_wr_i			),
	.rd_complete_o	(u2_rd_complete_o		),
	.wr_complete_o	(u2_wr_complete_o		),
	.awmf_0165_busy	(u2_awmf_0165_busy		)

);

awmf0165_chain u2_awmf0165_chain
(

	.clk_i			(clk_20m				),
	.rst_i			(rst					),
	.tx_en_i		(u2_chain_wr_en			),
	.tx_mode_i		(u2_tx_mode_i			),
	.tx_data_i		(u2_chain_data_o		),
	.rx_data_o		(u2_chain_data_o_i		),
	.tx_busy		(u2_chain_busy_i		),
	.awmf_sdi_i		(awmf_sdi_i[2]			),
	.awmf_sdi_o		(awmf_sdo_o[2]			),
	.awmf_pdi_o		(awmf_pdo_o[2]			),
	.awmf_ldb_o		(awmf_ldb_o[2]			),
	.awmf_csb_o		(awmf_csb_o[2]			),
	.awmf_clk_o		(awmf_clk_o[2]			)
);

always @ (posedge clk_20m)	begin
	if(rst)
		u2_awmf0165_reg <= 'd0;
	else if(u2_fifo_wr_o == 1'b1 )
		u2_awmf0165_reg <= u2_chain_rd_data_o;
	else
		u2_awmf0165_reg <= u2_awmf0165_reg;
end
assign u2_chain_wr_i = awmf0165_ctr[8]	;
assign u2_tx_mode_i  = awmf0165_ctr[10:9];

//---------------------------------group3----------------------------------
wire	[255:0]		u3_read_data_o  		;
wire 				u3_adsdata_fifo_empty	;
wire				u3_chain_wr_en			;
wire 	[255:0]		u3_chain_data_i			;
wire	[239:0]		u3_chain_data_o			;
wire 	[239:0] 	u3_chain_data_o_i		;
wire				u3_chain_busy_i			;
wire 				u3_chain_wr_i			;
wire    [1 :0] 		u3_tx_mode_i			;

wire 				u3_fifo_wr_o			;
wire 	[255:0]		u3_chain_rd_data_o		;
wire 				u3_busy_o				;
// reg 	[255:0] 	u3_awmf0165_reg			;
wire 				u3_rd_complete_o		;
wire 				u3_wr_complete_o		;
wire 				u3_awmf_0165_busy		;
 wire u3_read_data_en ;

awmf0165_write_data_buffer u3_awmf0165_write_data_buffer
(
	.sys_rst				(rst					),			
	.write_clk				(clk					), 	   
	.write_data_en			(u3_write_data_en		),
	.write_data_in			(u3_write_data_in		),
	.read_clk				(clk_20m				),
	.read_data_en			(u3_read_data_en		),
	.adsdata_fifo_empty		(u3_adsdata_fifo_empty	),
	.read_data_o			(u3_read_data_o			)	

);

awmf_chain_ctrl u3_awmf_chain_ctrl
(
	.clk_i			(clk_20m				),
	.rst_i			(rst					),

	.cpie_i			(cpie_i					),
	.fifo_empty_i	(u3_adsdata_fifo_empty	),
	.fifo_rd_o		(u3_read_data_en		),
	.fifo_wr_o		(u3_fifo_wr_o			),
	.chain_rd_data_o(u3_chain_rd_data_o		),
	.busy_o			(u3_busy_o				),
	.chain_wr_en	(u3_chain_wr_en			),
	.chain_data_i	(u3_read_data_o			),
	.chain_data_o	(u3_chain_data_o		),
	.chain_data_o_i	(u3_chain_data_o_i		),
	.chain_busy_i	(u3_chain_busy_i		),
	.chain_wr_i		(u3_chain_wr_i			),
	.rd_complete_o	(u3_rd_complete_o		),
	.wr_complete_o	(u3_wr_complete_o		),
	.awmf_0165_busy	(u3_awmf_0165_busy		)

);

awmf0165_chain u3_awmf0165_chain
(

	.clk_i			(clk_20m				),
	.rst_i			(rst					),
	.tx_en_i		(u3_chain_wr_en			),
	.tx_mode_i		(u3_tx_mode_i			),
	.tx_data_i		(u3_chain_data_o		),
	.rx_data_o		(u3_chain_data_o_i		),
	.tx_busy		(u3_chain_busy_i		),
	.awmf_sdi_i		(awmf_sdi_i[3]			),
	.awmf_sdi_o		(awmf_sdo_o[3]			),
	.awmf_pdi_o		(awmf_pdo_o[3]			),
	.awmf_ldb_o		(awmf_ldb_o[3]			),
	.awmf_csb_o		(awmf_csb_o[3]			),
	.awmf_clk_o		(awmf_clk_o[3]			)
);

always @ (posedge clk_20m)	begin
	if(rst)
		u3_awmf0165_reg <= 'd0;
	else if(u3_fifo_wr_o == 1'b1 )
		u3_awmf0165_reg <= u3_chain_rd_data_o;
	else
		u3_awmf0165_reg <= u3_awmf0165_reg;
end
assign u3_chain_wr_i = awmf0165_ctr[12]		;
assign u3_tx_mode_i  = awmf0165_ctr[14:13]	;

//---------------------------------group4----------------------------------
wire	[255:0]		u4_read_data_o  		;
wire 				u4_adsdata_fifo_empty	;
wire				u4_chain_wr_en			;
wire 	[255:0]		u4_chain_data_i			;
wire	[239:0]		u4_chain_data_o			;
wire 	[239:0] 	u4_chain_data_o_i		;
wire				u4_chain_busy_i			;
wire 				u4_chain_wr_i			;
wire    [1 :0] 		u4_tx_mode_i			;

wire 				u4_fifo_wr_o			;
wire 	[255:0]		u4_chain_rd_data_o		;
wire 				u4_busy_o				;
// reg 	[255:0] 	u4_awmf0165_reg			;
wire 				u4_rd_complete_o		;
wire 				u4_wr_complete_o		;
wire 				u4_awmf_0165_busy		;
 wire u4_read_data_en;

awmf0165_write_data_buffer u4_awmf0165_write_data_buffer
(
	.sys_rst				(rst					),			
	.write_clk				(clk					), 	   
	.write_data_en			(u4_write_data_en		),
	.write_data_in			(u4_write_data_in		),
	.read_clk				(clk_20m				),
	.read_data_en			(u4_read_data_en		),
	.adsdata_fifo_empty		(u4_adsdata_fifo_empty	),
	.read_data_o			(u4_read_data_o			)	

);

awmf_chain_ctrl u4_awmf_chain_ctrl
(
	.clk_i			(clk_20m				),
	.rst_i			(rst					),

	.cpie_i			(cpie_i					),
	.fifo_empty_i	(u4_adsdata_fifo_empty	),
	.fifo_rd_o		(u4_read_data_en		),
	.fifo_wr_o		(u4_fifo_wr_o			),
	.chain_rd_data_o(u4_chain_rd_data_o		),
	.busy_o			(u4_busy_o				),
	.chain_wr_en	(u4_chain_wr_en			),
	.chain_data_i	(u4_read_data_o			),
	.chain_data_o	(u4_chain_data_o		),
	.chain_data_o_i	(u4_chain_data_o_i		),
	.chain_busy_i	(u4_chain_busy_i		),
	.chain_wr_i		(u4_chain_wr_i			),
	.rd_complete_o	(u4_rd_complete_o		),
	.wr_complete_o	(u4_wr_complete_o		),
	.awmf_0165_busy	(u4_awmf_0165_busy		)

);

awmf0165_chain u4_awmf0165_chain
(

	.clk_i			(clk_20m				),
	.rst_i			(rst					),
	.tx_en_i		(u4_chain_wr_en			),
	.tx_mode_i		(u4_tx_mode_i			),
	.tx_data_i		(u4_chain_data_o		),
	.rx_data_o		(u4_chain_data_o_i		),
	.tx_busy		(u4_chain_busy_i		),
	.awmf_sdi_i		(awmf_sdi_i[4]			),
	.awmf_sdi_o		(awmf_sdo_o[4]			),
	.awmf_pdi_o		(awmf_pdo_o[4]			),
	.awmf_ldb_o		(awmf_ldb_o[4]			),
	.awmf_csb_o		(awmf_csb_o[4]			),
	.awmf_clk_o		(awmf_clk_o[4]			)
);

always @ (posedge clk_20m)	begin
	if(rst)
		u4_awmf0165_reg <= 'd0;
	else if(u4_fifo_wr_o == 1'b1 )
		u4_awmf0165_reg <= u4_chain_rd_data_o;
	else
		u4_awmf0165_reg <= u4_awmf0165_reg;
end
assign u4_chain_wr_i = u8_awmf0165_ctr[0]	;
assign u4_tx_mode_i  = u8_awmf0165_ctr[2:1]	;


assign wr_irp = u4_wr_complete_o | u3_wr_complete_o | u2_wr_complete_o | u1_wr_complete_o | u0_wr_complete_o ;
assign rd_irp = u4_rd_complete_o | u3_rd_complete_o | u2_rd_complete_o | u1_rd_complete_o | u0_rd_complete_o ;

assign awmf_mode_o = awmf0165_pspl_select ? {Rx_En,1'b0,Rx_En,1'b0,Rx_En,1'b0,Rx_En,1'b0,Rx_En,1'b0,Rx_En,1'b0,Rx_En,1'b0,Rx_En,1'b0,
                                                1'b0,Tx_En,1'b0,Tx_En,1'b0,Tx_En,1'b0,Tx_En,1'b0,Tx_En,1'b0,Tx_En,1'b0,Tx_En,1'b0,Tx_En} : {22'd0,u8_awmf0165_select[1:0],awmf0165_select[7:0]};



reg		u0_awmf_0165_busy_d1 ;
reg		u1_awmf_0165_busy_d1 ;
reg		u2_awmf_0165_busy_d1 ;
reg		u3_awmf_0165_busy_d1 ;
reg		u4_awmf_0165_busy_d1 ;

reg		u0_awmf_0165_busy_d2 ;
reg		u1_awmf_0165_busy_d2 ;
reg		u2_awmf_0165_busy_d2 ;
reg		u3_awmf_0165_busy_d2 ;
reg		u4_awmf_0165_busy_d2 ;


reg		u0_adsdata_fifo_empty_d1 ;
reg		u1_adsdata_fifo_empty_d1 ;
reg		u2_adsdata_fifo_empty_d1 ;
reg		u3_adsdata_fifo_empty_d1 ;
reg		u4_adsdata_fifo_empty_d1 ;


reg		u0_adsdata_fifo_empty_d2 ;
reg		u1_adsdata_fifo_empty_d2 ;
reg		u2_adsdata_fifo_empty_d2 ;
reg		u3_adsdata_fifo_empty_d2 ;
reg		u4_adsdata_fifo_empty_d2 ;

always @ (posedge clk)	begin
	u0_awmf_0165_busy_d1 <= u0_awmf_0165_busy 	;
	u1_awmf_0165_busy_d1 <= u1_awmf_0165_busy 	;
	u2_awmf_0165_busy_d1 <= u2_awmf_0165_busy 	;
	u3_awmf_0165_busy_d1 <= u3_awmf_0165_busy 	;
	u4_awmf_0165_busy_d1 <= u4_awmf_0165_busy 	;

	u0_awmf_0165_busy_d2 <= u0_awmf_0165_busy_d1;
	u1_awmf_0165_busy_d2 <= u1_awmf_0165_busy_d1;
	u2_awmf_0165_busy_d2 <= u2_awmf_0165_busy_d1;
	u3_awmf_0165_busy_d2 <= u3_awmf_0165_busy_d1;
	u4_awmf_0165_busy_d2 <= u4_awmf_0165_busy_d1;

end

always @ (posedge clk)	begin
	u0_adsdata_fifo_empty_d1 <= u0_adsdata_fifo_empty 	;
	u1_adsdata_fifo_empty_d1 <= u1_adsdata_fifo_empty 	;
	u2_adsdata_fifo_empty_d1 <= u2_adsdata_fifo_empty 	;
	u3_adsdata_fifo_empty_d1 <= u3_adsdata_fifo_empty 	;
	u4_adsdata_fifo_empty_d1 <= u4_adsdata_fifo_empty 	;


	u0_adsdata_fifo_empty_d2 <= u0_adsdata_fifo_empty_d1 ;
	u1_adsdata_fifo_empty_d2 <= u1_adsdata_fifo_empty_d1 ;
	u2_adsdata_fifo_empty_d2 <= u2_adsdata_fifo_empty_d1 ;
	u3_adsdata_fifo_empty_d2 <= u3_adsdata_fifo_empty_d1 ;
	u4_adsdata_fifo_empty_d2 <= u4_adsdata_fifo_empty_d1 ;

end
always @ (posedge clk)	begin
	if(rst)
		awmf_0165_status <= 'd0 ;
	else 
		awmf_0165_status <= { 
								u4_adsdata_fifo_empty_d2,u4_awmf_0165_busy_d2,
								u3_adsdata_fifo_empty_d2,u3_awmf_0165_busy_d2,
								u2_adsdata_fifo_empty_d2,u2_awmf_0165_busy_d2,
								u1_adsdata_fifo_empty_d2,u1_awmf_0165_busy_d2,
								u0_adsdata_fifo_empty_d2,u0_awmf_0165_busy_d2} ;
end

endmodule
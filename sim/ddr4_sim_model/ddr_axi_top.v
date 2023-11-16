module ddr_axi_top
(

    output              ddr4_clk            ,
    output              ddr4_rst            ,
    output              init_calib_complete ,

  input  wire [3:0]      ddr4_s_axi_awid      ,
  input  wire [31 : 0]   ddr4_s_axi_awaddr    ,
  input  wire [7 : 0]    ddr4_s_axi_awlen     ,
  input  wire [2 : 0]    ddr4_s_axi_awsize    ,
  input  wire [1 : 0]    ddr4_s_axi_awburst   ,
  input  wire [0 : 0]    ddr4_s_axi_awlock    ,
  input  wire [3 : 0]    ddr4_s_axi_awcache   ,
  input  wire [2 : 0]    ddr4_s_axi_awprot    ,
  input  wire [3 : 0]    ddr4_s_axi_awqos     ,
  input  wire            ddr4_s_axi_awvalid   ,
  output wire            ddr4_s_axi_awready   ,
  input  wire [127 : 0]  ddr4_s_axi_wdata     ,
  input  wire [15 : 0]   ddr4_s_axi_wstrb     ,
  input  wire            ddr4_s_axi_wlast     ,
  input  wire            ddr4_s_axi_wvalid    ,
  output wire            ddr4_s_axi_wready    ,
  input  wire            ddr4_s_axi_bready    ,
  output wire [3 : 0]    ddr4_s_axi_bid       ,
  output wire [1 : 0]    ddr4_s_axi_bresp     ,
  output wire            ddr4_s_axi_bvalid    ,
  input  wire [3 : 0]    ddr4_s_axi_arid      ,
  input  wire [31: 0]    ddr4_s_axi_araddr    ,
  input  wire [7 : 0]    ddr4_s_axi_arlen     ,
  input  wire [2 : 0]    ddr4_s_axi_arsize    ,
  input  wire [1 : 0]    ddr4_s_axi_arburst   ,
  input  wire [0 : 0]    ddr4_s_axi_arlock    ,
  input  wire [3 : 0]    ddr4_s_axi_arcache   ,
  input  wire [2 : 0]    ddr4_s_axi_arprot    ,
  input  wire [3 : 0]    ddr4_s_axi_arqos     ,
  input  wire            ddr4_s_axi_arvalid   ,
  output wire            ddr4_s_axi_arready   ,
  input  wire            ddr4_s_axi_rready    ,
  output wire            ddr4_s_axi_rlast     ,
  output wire            ddr4_s_axi_rvalid    ,
  output wire [1 : 0]    ddr4_s_axi_rresp     ,
  output wire [3 : 0]    ddr4_s_axi_rid       ,
  output wire [127 : 0]  ddr4_s_axi_rdata 
);

wire                 sys_rst          ;
wire                 c0_sys_clk_p     ;
wire                 c0_sys_clk_n     ;
wire                 c0_ddr4_act_n    ;
wire [16:0]          c0_ddr4_adr      ;
wire [1:0]           c0_ddr4_ba       ;
wire [1:0]           c0_ddr4_bg       ;
wire [0:0]           c0_ddr4_cke      ;
wire [0:0]           c0_ddr4_odt      ;
wire [0:0]           c0_ddr4_cs_n     ;
wire [0:0]           c0_ddr4_ck_t     ;
wire [0:0]           c0_ddr4_ck_c     ;
wire                 c0_ddr4_reset_n  ;
wire  [7:0]          c0_ddr4_dm_dbi_n ;
wire  [63:0]         c0_ddr4_dq       ;
wire  [7:0]          c0_ddr4_dqs_t    ;
wire  [7:0]          c0_ddr4_dqs_c    ;


ddr4_sim_model ddr4_sim_model
(
    .sys_rst            (sys_rst            ),       
    .c0_sys_clk_p       (c0_sys_clk_p       ), 
    .c0_sys_clk_n       (c0_sys_clk_n       ), 
    .c0_ddr4_act_n      (c0_ddr4_act_n      ), 
    .c0_ddr4_adr        (c0_ddr4_adr        ), 
    .c0_ddr4_ba         (c0_ddr4_ba         ), 
    .c0_ddr4_bg         (c0_ddr4_bg         ), 
    .c0_ddr4_cke        (c0_ddr4_cke        ),
    .c0_ddr4_odt        (c0_ddr4_odt        ), 
    .c0_ddr4_cs_n       (c0_ddr4_cs_n       ),
    .c0_ddr4_ck_t       (c0_ddr4_ck_t       ), 
    .c0_ddr4_ck_c       (c0_ddr4_ck_c       ), 
    .c0_ddr4_reset_n    (c0_ddr4_reset_n    ), 
    .c0_ddr4_dm_dbi_n   (c0_ddr4_dm_dbi_n   ),
    .c0_ddr4_dq         (c0_ddr4_dq         ), 
    .c0_ddr4_dqs_t      (c0_ddr4_dqs_t      ),
    .c0_ddr4_dqs_c      (c0_ddr4_dqs_c      )
);


ddr4_0 ddr4_0
(
    .sys_rst                    (sys_rst            ),

    .c0_sys_clk_p               (c0_sys_clk_p       ),
    .c0_sys_clk_n               (c0_sys_clk_n       ),
 
    .c0_ddr4_act_n              (c0_ddr4_act_n      ),
    .c0_ddr4_adr                (c0_ddr4_adr        ),
    .c0_ddr4_ba                 (c0_ddr4_ba         ),
    .c0_ddr4_bg                 (c0_ddr4_bg         ),
    .c0_ddr4_cke                (c0_ddr4_cke        ),
    .c0_ddr4_odt                (c0_ddr4_odt        ),
    .c0_ddr4_cs_n               (c0_ddr4_cs_n       ),
    .c0_ddr4_ck_t               (c0_ddr4_ck_t       ),
    .c0_ddr4_ck_c               (c0_ddr4_ck_c       ),
    .c0_ddr4_reset_n            (c0_ddr4_reset_n    ),
    .c0_ddr4_dm_dbi_n           (c0_ddr4_dm_dbi_n   ),
    .c0_ddr4_dq                 (c0_ddr4_dq         ),
    .c0_ddr4_dqs_c              (c0_ddr4_dqs_c      ),
    .c0_ddr4_dqs_t              (c0_ddr4_dqs_t      ),
 
    .c0_init_calib_complete     (init_calib_complete),
    .c0_ddr4_ui_clk             (ddr4_clk           ),
    .c0_ddr4_ui_clk_sync_rst    (ddr4_rst           ),
    .dbg_clk                    (),
 
    .c0_ddr4_aresetn            (1'b1               ),
    .c0_ddr4_s_axi_awid         (ddr4_s_axi_awid    ),
    .c0_ddr4_s_axi_awaddr       (ddr4_s_axi_awaddr  ),
    .c0_ddr4_s_axi_awlen        (ddr4_s_axi_awlen   ),
    .c0_ddr4_s_axi_awsize       (ddr4_s_axi_awsize  ),
    .c0_ddr4_s_axi_awburst      (ddr4_s_axi_awburst ),
    .c0_ddr4_s_axi_awlock       (ddr4_s_axi_awlock  ),
    .c0_ddr4_s_axi_awcache      (ddr4_s_axi_awcache ),
    .c0_ddr4_s_axi_awprot       (ddr4_s_axi_awprot  ),
    .c0_ddr4_s_axi_awqos        (ddr4_s_axi_awqos   ),
    .c0_ddr4_s_axi_awvalid      (ddr4_s_axi_awvalid ),
    .c0_ddr4_s_axi_awready      (ddr4_s_axi_awready ),
    // Slave Interface Write Data Ports
    .c0_ddr4_s_axi_wdata        (ddr4_s_axi_wdata  ),
    .c0_ddr4_s_axi_wstrb        (ddr4_s_axi_wstrb  ),
    .c0_ddr4_s_axi_wlast        (ddr4_s_axi_wlast  ),
    .c0_ddr4_s_axi_wvalid       (ddr4_s_axi_wvalid ),
    .c0_ddr4_s_axi_wready       (ddr4_s_axi_wready ),
    // Slave Interface Write Response Ports
    .c0_ddr4_s_axi_bready       (ddr4_s_axi_bready ),
    .c0_ddr4_s_axi_bid          (ddr4_s_axi_bid    ),
    .c0_ddr4_s_axi_bresp        (ddr4_s_axi_bresp  ),
    .c0_ddr4_s_axi_bvalid       (ddr4_s_axi_bvalid ),
    // Slave Interface Read Address Ports
    .c0_ddr4_s_axi_arid         (ddr4_s_axi_arid   ),
    .c0_ddr4_s_axi_araddr       (ddr4_s_axi_araddr ),
    .c0_ddr4_s_axi_arlen        (ddr4_s_axi_arlen  ),
    .c0_ddr4_s_axi_arsize       (ddr4_s_axi_arsize ),
    .c0_ddr4_s_axi_arburst      (ddr4_s_axi_arburst),
    .c0_ddr4_s_axi_arlock       (ddr4_s_axi_arlock ),
    .c0_ddr4_s_axi_arcache      (ddr4_s_axi_arcache),
    .c0_ddr4_s_axi_arprot       (ddr4_s_axi_arprot ),
    .c0_ddr4_s_axi_arqos        (ddr4_s_axi_arqos  ),
    .c0_ddr4_s_axi_arvalid      (ddr4_s_axi_arvalid),
    .c0_ddr4_s_axi_arready      (ddr4_s_axi_arready),
    // Slave Interface Read Data Ports
    .c0_ddr4_s_axi_rready       (ddr4_s_axi_rready ),
    .c0_ddr4_s_axi_rid          (ddr4_s_axi_rid    ),
    .c0_ddr4_s_axi_rdata        (ddr4_s_axi_rdata  ),
    .c0_ddr4_s_axi_rresp        (ddr4_s_axi_rresp  ),
    .c0_ddr4_s_axi_rlast        (ddr4_s_axi_rlast  ),
    .c0_ddr4_s_axi_rvalid       (ddr4_s_axi_rvalid ),
    // Debug Port
    .dbg_bus                    ()
    );

endmodule 
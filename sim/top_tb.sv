`timescale 1ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/24 09:09:00
// Design Name: 
// Module Name: top_tb
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

`define SIM 


module top_tb;

    reg     clk_100m ;
    reg     clk_200m ;
    reg     pl_rst_n ;

    reg     adc3663_dclk_p ;
    wire    adc3663_dclk_n ;

    
    reg     adc3663_fclk_p ;
    wire    adc3663_fclk_n ;

    wire    adc3663_da0_p ;
    wire    adc3663_da1_p ;
    wire    adc3663_da0_n ;
    wire    adc3663_da1_n ;

    wire    adc3663_db0_p ;
    wire    adc3663_db1_p ;
    wire    adc3663_db0_n ;
    wire    adc3663_db1_n ;

    assign  adc3663_da0_n = ~ adc3663_da0_p ;
    assign  adc3663_da1_n = ~ adc3663_da1_p ;

    assign  adc3663_db0_n = ~ adc3663_db0_p ;
    assign  adc3663_db1_n = ~ adc3663_db1_p ;


    assign  top.ps_clk_100m = clk_100m ;

    reg [1:0] dclk_cnt = 0 ;
    always @(posedge adc3663_dclk_p) begin
        dclk_cnt <= dclk_cnt + 1'b1 ;
    end

    initial
    begin
        clk_100m = 1'b0 ;
        forever begin
            #5000 clk_100m = ~clk_100m ;  
        end
    end 
    initial begin
        clk_200m = 1'b0 ;
        forever begin
            #2500 clk_200m  = ~ clk_200m ;
        end
    end
    assign top.ps_clk_200m  = clk_200m ;
    initial begin
        #1000 adc3663_dclk_p = 1'b1 ;
        forever begin
            // #3125 adc3663_dclk_p = ~ adc3663_dclk_p ;
            #6250 adc3663_dclk_p = ~ adc3663_dclk_p ;
            // #5000 adc3663_dclk_p = ~ adc3663_dclk_p ;
            // #1400 adc3663_dclk_p = ~ adc3663_dclk_p ;
        end
    end
    assign adc3663_dclk_n = ~adc3663_dclk_p ;

    initial begin
        #15000 adc3663_fclk_p = 1'b0 ;
        forever begin
            // #25000 adc3663_fclk_p = ~ adc3663_fclk_p ;
            // #40000 adc3663_fclk_p = ~ adc3663_fclk_p ;
            #50000 adc3663_fclk_p = ~ adc3663_fclk_p ;
        end
    end
    assign adc3663_fclk_n = ~adc3663_fclk_p ;

    reg pl_clk_40m ;
    initial begin
        pl_clk_40m = 1'b0 ;
        forever begin 
            // #10000 pl_clk_40m = ~pl_clk_40m ;
            // #8333 pl_clk_40m = ~pl_clk_40m ;
            #12500pl_clk_40m = ~pl_clk_40m ;
        end
    end

    initial begin
        pl_rst_n = 1'b0 ;
        #5000 ; 
        pl_rst_n = 1'b1 ;
    end
// end

    assign    #10000 adc3663_da0_p  = (dclk_cnt == 'd0 )?1'b0 : 1'b1 ;    // forword
    assign    #10000 adc3663_da1_p  = (dclk_cnt == 'd0 )?1'b0 : 1'b1 ;

    assign    #10000 adc3663_db0_p  = (dclk_cnt == 'd0 )?1'b0 : 1'b1 ;
    assign    #10000 adc3663_db1_p  = (dclk_cnt == 'd0 )?1'b0 : 1'b1 ;

    // assign   #1000 adc3663_da0_p  = 'd0;    // forword
    // assign   #1000 adc3663_da1_p  = 'd0;
    // assign   #1000 adc3663_db0_p  = 'd0;
    // assign   #1000 adc3663_db1_p  = 'd0;


    `include"../../../../../sim/function/axi_lite_driver.sv"
    assign  axil_clk = clk_100m ;
// address write channel 
    assign  top.m_axi_pl_awaddr  = m_axil_awaddr    ;
    assign  top.m_axi_pl_awprot  = m_axil_awprot    ;
    assign  top.m_axi_pl_awvalid = m_axil_awvalid   ;
    assign  m_axil_awready = top.m_axi_pl_awready   ;
// // data wirte channel 
    assign  top.m_axi_pl_wdata  = m_axil_wdata      ;
    assign  top.m_axi_pl_wstrb  = m_axil_wstrb      ;
    assign  top.m_axi_pl_wvalid = m_axil_wvalid     ;
    assign  m_axil_wready = top.m_axi_pl_wready     ;
// response channel 
    assign  m_axil_bvalid  = top.m_axi_pl_bvalid   ;
    assign  m_axil_bresp   = top.m_axi_pl_bresp    ;
    assign  top.m_axi_pl_bready=m_axil_bready      ;
// addres read channel 
    assign  top.m_axi_pl_araddr  = m_axil_araddr   ;
    assign  top.m_axi_pl_arprot  = m_axil_arprot   ;
    assign  top.m_axi_pl_arvalid = m_axil_arvalid  ;
    assign  m_axil_arready = top.m_axi_pl_arready  ;
// rdata channel 
    assign  m_axil_rdata= top.m_axi_pl_rdata        ;    
    assign  top.m_axi_pl_rresp  =  m_axil_rresp    ;    
    assign  m_axil_rvalid     =top.m_axi_pl_rvalid ; 
    assign  top.m_axi_pl_rready =  m_axil_rready   ;
    assign  top_tb.top.per_config.lmx2492_ctr_top.spi_lmx2492_sdata_i = 1'b1;

//-------------------------------ddr_signal-------------------------------------

wire [48: 0]      s_axi_araddr   ;
wire [1 : 0]      s_axi_arburst  ;
wire [3 : 0]      s_axi_arcache  ;
wire [5 : 0]      s_axi_arid     ;
wire [7 : 0]      s_axi_arlen    ;
wire              s_axi_arlock   ;
wire [2 : 0]      s_axi_arprot   ;
wire [3 : 0]      s_axi_arqos    ;
wire              s_axi_arready  ;
wire [2:0]        s_axi_arsize   ;
wire              s_axi_aruser   ;
wire              s_axi_arvalid  ;

// aw ch 
wire [48: 0]      s_axi_awaddr   ;
wire [1 : 0]      s_axi_awburst  ;
wire [3 : 0]      s_axi_awcache  ;
wire [5 : 0]      s_axi_awid     ;
wire [7 : 0]      s_axi_awlen    ;
wire              s_axi_awlock   ;
wire [2 : 0]      s_axi_awprot   ;
wire [3 : 0]      s_axi_awqos    ;
wire              s_axi_awready  ;
wire [2 : 0]      s_axi_awsize   ;
wire              s_axi_awuser   ;
wire              s_axi_awvalid  ;

// response     
wire[5 : 0]       s_axi_bid      ;
wire              s_axi_bready   ;
wire[1 : 0]       s_axi_bresp    ;
wire              s_axi_bvalid   ;

// rd ch 
wire[127: 0]      s_axi_rdata    ;
wire[5 : 0]       s_axi_rid      ;
wire              s_axi_rlast    ;
wire              s_axi_rready   ;
wire[1 : 0]       s_axi_rresp    ;
wire              s_axi_rvalid   ;

// wr ch 
wire [127: 0]     s_axi_wdata    ;
wire              s_axi_wlast    ;
wire              s_axi_wready   ;
wire [15 : 0]     s_axi_wstrb    ;
wire              s_axi_wvalid   ;


top top
(
    .pl_clk_40m     (pl_clk_40m    ),

    .adc3663_fclk_p (adc3663_fclk_p),
    .adc3663_fclk_n (adc3663_fclk_n),
    
    .adc3663_dclk_p (adc3663_dclk_p),
    .adc3663_dclk_n (adc3663_dclk_n),
    
    .adc3663_da0_p  (adc3663_da0_p),
    .adc3663_da0_n  (adc3663_da0_n),
    
    .adc3663_da1_p  (adc3663_da1_p),
    .adc3663_da1_n  (adc3663_da1_n),

    .adc3663_db0_p  (adc3663_db0_p),
    .adc3663_db0_n  (adc3663_db0_n),
    
    .adc3663_db1_p  (adc3663_db1_p),
    .adc3663_db1_n  (adc3663_db1_n)
);


wire    ddr4_clk            ;
wire    ddr4_rst            ;
wire    init_calib_complete ;

// `ifdef DDR_SIM
ddr_axi_top ddr_axi_top
(
    .ddr4_clk           (ddr4_clk               ),
    .ddr4_rst           (ddr4_rst               ),
    .init_calib_complete(init_calib_complete    ),

    .ddr4_s_axi_awid    (s_axi_awid             ),
    .ddr4_s_axi_awaddr  (s_axi_awaddr           ),
    .ddr4_s_axi_awlen   (s_axi_awlen            ),
    .ddr4_s_axi_awsize  (s_axi_awsize           ),
    .ddr4_s_axi_awburst (s_axi_awburst          ),
    .ddr4_s_axi_awlock  (s_axi_awlock           ),
    .ddr4_s_axi_awcache (s_axi_awcache          ),
    .ddr4_s_axi_awprot  (s_axi_awprot           ),
    .ddr4_s_axi_awqos   (s_axi_awqos            ),
    .ddr4_s_axi_awvalid (s_axi_awvalid          ),
    .ddr4_s_axi_awready (s_axi_awready          ),

    .ddr4_s_axi_wdata   (s_axi_wdata            ),
    .ddr4_s_axi_wstrb   (s_axi_wstrb            ),
    .ddr4_s_axi_wlast   (s_axi_wlast            ),
    .ddr4_s_axi_wvalid  (s_axi_wvalid           ),
    .ddr4_s_axi_wready  (s_axi_wready           ),
        
    .ddr4_s_axi_bready  (s_axi_bready           ),
    .ddr4_s_axi_bid     (s_axi_bid              ),
    .ddr4_s_axi_bresp   (s_axi_bresp            ),
    .ddr4_s_axi_bvalid  (s_axi_bvalid           ),
        
    .ddr4_s_axi_arid    (s_axi_arid             ),
    .ddr4_s_axi_araddr  (s_axi_araddr           ),
    .ddr4_s_axi_arlen   (s_axi_arlen            ),
    .ddr4_s_axi_arsize  (s_axi_arsize           ),
    .ddr4_s_axi_arburst (s_axi_arburst          ),
    .ddr4_s_axi_arlock  (s_axi_arlock           ),
    .ddr4_s_axi_arcache (s_axi_arcache          ),
    .ddr4_s_axi_arprot  (s_axi_arprot           ),
    .ddr4_s_axi_arqos   (s_axi_arqos            ),
    .ddr4_s_axi_arvalid (s_axi_arvalid          ),
    .ddr4_s_axi_arready (s_axi_arready          ),
        
    .ddr4_s_axi_rready  (s_axi_rready           ),
    .ddr4_s_axi_rlast   (s_axi_rlast            ),
    .ddr4_s_axi_rvalid  (s_axi_rvalid           ),
    .ddr4_s_axi_rresp   (s_axi_rresp            ),
    .ddr4_s_axi_rid     (s_axi_rid              ),
    .ddr4_s_axi_rdata   (s_axi_rdata            )
);

//-------------------------------ddr axi signal-----------------------------------

    assign   s_axi_araddr  = top.s_axi_ps_ddr_ch0_araddr ;
    assign   s_axi_arburst = top.s_axi_ps_ddr_ch0_arburst; 
    assign   s_axi_arcache = top.s_axi_ps_ddr_ch0_arcache; 
    assign   s_axi_arid    = top.s_axi_ps_ddr_ch0_arid   ; 
    assign   s_axi_arlen   = top.s_axi_ps_ddr_ch0_arlen  ; 
    assign   s_axi_arlock  = top.s_axi_ps_ddr_ch0_arlock ; 
    assign   s_axi_arprot  = top.s_axi_ps_ddr_ch0_arprot ; 
    assign   s_axi_arqos   = top.s_axi_ps_ddr_ch0_arqos  ; 
    assign   top.s_axi_ps_ddr_ch0_arready =s_axi_arready ; 
    assign   s_axi_arsize  = top.s_axi_ps_ddr_ch0_arsize ; 
    assign   s_axi_aruser  = top.s_axi_ps_ddr_ch0_aruser ; 
    assign   s_axi_arvalid = top.s_axi_ps_ddr_ch0_arvalid; 

    assign   s_axi_awaddr  = top.s_axi_ps_ddr_ch0_awaddr ; 
    assign   s_axi_awburst = top.s_axi_ps_ddr_ch0_awburst; 
    assign   s_axi_awcache = top.s_axi_ps_ddr_ch0_awcache; 
    assign   s_axi_awid    = top.s_axi_ps_ddr_ch0_awid   ; 
    assign   s_axi_awlen   = top.s_axi_ps_ddr_ch0_awlen  ; 
    assign   s_axi_awlock  = top.s_axi_ps_ddr_ch0_awlock ; 
    assign   s_axi_awprot  = top.s_axi_ps_ddr_ch0_awprot ; 
    assign   s_axi_awqos   = top.s_axi_ps_ddr_ch0_awqos  ; 
    assign   top.s_axi_ps_ddr_ch0_awready = s_axi_awready; 
    assign   s_axi_awsize  = top.s_axi_ps_ddr_ch0_awsize ; 
    assign   s_axi_awuser  = top.s_axi_ps_ddr_ch0_awuser ; 
    assign   s_axi_awvalid = top.s_axi_ps_ddr_ch0_awvalid; 

    assign top.s_axi_ps_ddr_ch0_bid     =  s_axi_bid     ;
    assign s_axi_bready = top.s_axi_ps_ddr_ch0_bready    ;
    assign top.s_axi_ps_ddr_ch0_bresp   =  s_axi_bresp   ;
    assign top.s_axi_ps_ddr_ch0_bvalid  =  s_axi_bvalid  ;

    assign top.s_axi_ps_ddr_ch0_rdata   =  s_axi_rdata   ;
    assign top.s_axi_ps_ddr_ch0_rid     =  s_axi_rid     ;
    assign top.s_axi_ps_ddr_ch0_rlast   =  s_axi_rlast   ;
    assign s_axi_rready = top.s_axi_ps_ddr_ch0_rready    ;
    assign top.s_axi_ps_ddr_ch0_rresp   =  s_axi_rresp   ;
    assign top.s_axi_ps_ddr_ch0_rvalid  =  s_axi_rvalid  ;

    assign s_axi_wdata  = top.s_axi_ps_ddr_ch0_wdata     ;
    assign s_axi_wlast  = top.s_axi_ps_ddr_ch0_wlast     ;
    assign top.s_axi_ps_ddr_ch0_wready = s_axi_wready    ;
    assign s_axi_wstrb  = top.s_axi_ps_ddr_ch0_wstrb     ;
    assign s_axi_wvalid = top.s_axi_ps_ddr_ch0_wvalid    ;
    assign top.ddr_top.ddr_clk      =   ddr4_clk         ;
// `else
// `endif

initial begin 
    axil_init ;
    $display("axi lite init \n");
end

// `define PLATFORM_SIM
`define PLATFORM_SIM
`define case2

`ifdef PLATFORM_SIM
    `ifdef case0
        `include"../../../../../sim/platform_sim/case0.sv"
    `endif

    `ifdef case1
        `include"../../../../../sim/platform_sim/case1.sv"
    `endif

    `ifdef case2
        `include"../../../../../sim/platform_sim/case2.sv"
    `endif
    `ifdef case3
        `include"../../../../../sim/platform_sim/case3.sv"
    `endif
    `ifdef case4
        `include"../../../../../sim/platform_sim/case4.sv"
    `endif
    `ifdef case5
        `include"../../../../../sim/platform_sim/case5.sv"
    `endif

`else
    `ifdef case0
        `include"../../../../../sim/dsp_sim/case0.sv"
    `endif

    `ifdef case1
        `include"../../../../../sim/dsp_sim/case1.sv"
    `endif
`endif


// reg [31:0]  rdmap_data ;
// reg         rdmap_valid;
// reg         rdmap_tlast;
// reg [17:0]  index ;

// assign top.u_dsp_top.rdmap_cache.rdmap_log2_tdata  = rdmap_data  ;
// assign top.u_dsp_top.rdmap_cache.rdmap_log2_tvalid = rdmap_valid ;
// assign top.u_dsp_top.rdmap_cache.rdmap_log2_tlast  = rdmap_tlast ;

// initial begin
//     rdmap_data  = 'd0 ;
//     rdmap_valid = 'd0 ;
//     rdmap_tlast = 'd0 ;
//     wait(~top.u_dsp_top.rdmap_cache.rst );
//     while(1) begin
//     @(posedge top.u_dsp_top.rdmap_cache.sys_clk);
//     for( index = 0 ; index < 65536 ; index = index + 1 ) begin 
//         if(index == 65535 )
//             rdmap_tlast = 'd1 ;
//         else
//             rdmap_tlast = 'd0 ;
//         rdmap_data = {index[15:0],index[15:0]}; 
//         rdmap_valid = 'd1 ;
//         @(posedge top.u_dsp_top.rdmap_cache.sys_clk);
//     end
//     rdmap_data  = 'd0 ;
//     rdmap_valid = 'd0 ;
//     rdmap_tlast = 'd0 ;
//     #300000000;
//     @(posedge top.u_dsp_top.rdmap_cache.sys_clk);
//     end
// end

endmodule

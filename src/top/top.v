`include "define.v"
//`include "sim_define.vh"
//`define  "SIM"
 `define AI

module top
(
    output wire         lmx2492_mod_o       ,// to lmx2492,MOD(TP7,0x261f) as input MOD
    output wire         spi_lmx2492_sclk_o  ,// to lmx2492
	output wire         spi_lmx2492_sdata_o ,// to lmx2492	 
	output wire         spi_lmx2492_sen_o   ,// to lmx2492										    
    output wire         spi_lmx2492_ce_o    ,// to lmx2492	
    input  wire         spi_lmx2492_sdata_i ,// from lmx2492,TRIG2(TP2,0x253a) as output readback
    inout  wire         spi_lmx2492_TRIG1   ,
    
    input  wire         spi_chc2442_sdata_i ,
    output wire         spi_chc2442_sdata_o ,
    output wire         spi_chc2442_sen_o   ,
    output wire         spi_chc2442_sclk_o  ,

    inout  wire         spi_adc3663_sdio    ,
    output wire         spi_adc3663_sen_o   ,
    output wire         spi_adc3663_sclk_o  ,
	output wire         spi_adc3663_pdn_o   ,

//------------------ lvds signal --------------------------------

    input   wire        adc3663_fclk_p      ,
    input   wire        adc3663_fclk_n      ,
    input   wire        adc3663_dclk_p      ,
    input   wire        adc3663_dclk_n      ,

    input   wire        adc3663_da0_p       ,
    input   wire        adc3663_da0_n       ,
    input   wire        adc3663_da1_p       ,
    input   wire        adc3663_da1_n       ,

    input   wire        adc3663_db0_p       ,
    input   wire        adc3663_db0_n       ,
    input   wire        adc3663_db1_p       ,
    input   wire        adc3663_db1_n       ,

    output  wire        adc3663_dclk_o_p    ,
    output  wire        adc3663_dclk_o_n    ,
    output  wire        adc_rst             ,

//----------------- 0808 ----------------------------------------    

    input   wire  [4 :0] awmf_sdi_i         ,
    output  wire  [4 :0] awmf_sdo_o         ,
    output  wire  [4 :0] awmf_pdo_o         ,
    output  wire  [4 :0] awmf_ldb_o         ,
    output  wire  [4 :0] awmf_csb_o         ,
    output  wire  [4 :0] awmf_clk_o         ,
    output  wire  [9 :0] awmf_mode_o        ,

//---------------------------------------------------------------

    input   wire        gps_uart_rx         ,           //uart1 ps
    output  wire        gps_uart_tx         ,
    inout   wire        gps_pps             ,           //emio6
//---------------------------------------------------------------

    inout   wire        acc_i2c_scl         ,           //i2c1 ps 
    inout   wire        acc_i2c_sda         ,
    inout   wire        acc_cs              ,
    inout   wire        acc_magint          ,
    inout   wire        acc_int2_xl         ,
    inout   wire        acc_int1_xl         ,
    input   wire        pl_clk_40m          ,
    
//---------------------------------------------------------------
    
    // output              AP_UART2_TX_1V2     ,
    // input               AP_UART2_RX_1V2     ,
    output              IMU_TX     ,
    input               IMU_RX     ,
    // output              CP_UART3_TX_1V2     ,
    // input               CP_UART3_RX_1V2     ,
    output              CP_UART3_TX_1V8     ,
    input               CP_UART3_RX_1V8     ,
    // input               BT_UART_RXD         ,
    // output              BT_UART_TXD         ,
    inout               BT_UART_CTS         ,
    inout               BT_UART_RTS_N       ,
    output              MCU_WDG_TX          ,
    input               MCU_WDG_RX          ,

    inout               PLI2C_1_SDA         ,
    inout               PLI2C_1_SCL         ,
    inout               PLI2C_2_SDA         ,
    inout               PLI2C_2_SCL         ,
    inout               PLI2C3_SDA_1V2      ,
    inout               PLI2C3_SCL_1V2      ,

    inout               TC_SHIFT_OE_1V2     ,
    inout               ANT_EN_1V2          ,
    inout               ANT_CTRL_1V2        ,
    inout               TC_DGB_BOOT_1V2     ,
    inout               TC_PIO_RFU_1V2      ,
    inout               TC_OE_3V3           ,
    inout               USBMUX_OEN_1V2      ,
    inout               USB_SEL_1V2         ,
    input               sys_clk_n           ,
    input               sys_clk_p           ,
    output              ddr4_act_n          ,
    output [16:0]       ddr4_adr            ,
    output [1:0]        ddr4_ba             ,
    output [0:0]        ddr4_bg             ,
    output [0:0]        ddr4_ck_c           ,
    output [0:0]        ddr4_ck_t           ,
    output [0:0]        ddr4_cke            ,
    output [0:0]        ddr4_cs_n           ,
    inout [3:0]         ddr4_dm_n           ,
    inout [31:0]        ddr4_dq             ,
    inout [3:0]         ddr4_dqs_c          ,
    inout [3:0]         ddr4_dqs_t          ,
    output [0:0]        ddr4_odt            ,
    output              ddr4_reset_n        ,
    inout  [5:0]        led

);

wire            mmc_lock;

wire            ps_clk_100m             ;
wire            ps_clk_200m             ;
wire            pl_rst_n                ;
wire            clk_300m                ;

wire [31:0]     S_AXIS_S2MM_dma0_tdata  ;
wire [3 :0]     S_AXIS_S2MM_dma0_tkeep  ;
wire            S_AXIS_S2MM_dma0_tlast  ;
wire            S_AXIS_S2MM_dma0_tready ;
wire            S_AXIS_S2MM_dma0_tvalid ;

wire [31:0]     S_AXIS_S2MM_dma1_tdata  ;
wire [3 :0]     S_AXIS_S2MM_dma1_tkeep  ;
wire            S_AXIS_S2MM_dma1_tlast  ;
wire            S_AXIS_S2MM_dma1_tready ;
wire            S_AXIS_S2MM_dma1_tvalid ;

wire [31:0]     M_AXIS_MM2S_dma0_tdata  ;
wire [3 :0]     M_AXIS_MM2S_dma0_tkeep  ;
wire            M_AXIS_MM2S_dma0_tlast  ;
wire            M_AXIS_MM2S_dma0_tready ;
wire            M_AXIS_MM2S_dma0_tvalid ;

wire [31:0]     M_AXIS_MM2S_dma1_tdata  ;
wire [3 :0]     M_AXIS_MM2S_dma1_tkeep  ;
wire            M_AXIS_MM2S_dma1_tlast  ;
wire            M_AXIS_MM2S_dma1_tready ;
wire            M_AXIS_MM2S_dma1_tvalid ;

wire [39:0]     m_axi_pl_araddr         ;
wire [2 :0]     m_axi_pl_arprot         ;
wire [0 :0]     m_axi_pl_arready        ;
wire [0 :0]     m_axi_pl_arvalid        ;
wire [39:0]     m_axi_pl_awaddr         ;
wire [2 :0]     m_axi_pl_awprot         ;
wire [0 :0]     m_axi_pl_awready        ;
wire [0 :0]     m_axi_pl_awvalid        ;
wire [0 :0]     m_axi_pl_bready         ;
wire [1 :0]     m_axi_pl_bresp          ;
wire [0 :0]     m_axi_pl_bvalid         ;
wire [31:0]     m_axi_pl_rdata          ;
wire [0 :0]     m_axi_pl_rready         ;
wire [1 :0]     m_axi_pl_rresp          ;
wire [0 :0]     m_axi_pl_rvalid         ;
wire [31:0]     m_axi_pl_wdata          ;
wire [0 :0]     m_axi_pl_wready         ;
wire [3 :0]     m_axi_pl_wstrb          ;
wire [0 :0]     m_axi_pl_wvalid         ;
wire            wr_irp                  ;
wire            rd_irp                  ;
wire [19:0]     GPIO_0_tri_io           ;
wire            adc_abnormal_irp        ;
wire            ps_adc_tx_irq           ;

wire            UART_2_rxd              ;
wire            UART_2_txd              ;
wire            UART_3_rxd              ;
wire            UART_3_txd              ;
wire            UART_4_rxd              ;
wire            UART_4_txd              ;

wire            SPI_0_io0_io            ;
wire            SPI_0_io1_io            ;
wire            SPI_0_sck_io            ;
wire            SPI_0_ss_io             ;


wire [48:0]     S_AXI_DDR4_araddr   ;
wire [1 :0]     S_AXI_DDR4_arburst  ;
wire [3 :0]     S_AXI_DDR4_arcache  ;
wire [5 :0]     S_AXI_DDR4_arid     ;
wire [7 :0]     S_AXI_DDR4_arlen    ;
wire            S_AXI_DDR4_arlock   ;
wire [2 :0]     S_AXI_DDR4_arprot   ;
wire [3 :0]     S_AXI_DDR4_arqos    ;
wire            S_AXI_DDR4_arready  ;
wire [2 :0]     S_AXI_DDR4_arsize   ;
wire            S_AXI_DDR4_aruser   ;
wire            S_AXI_DDR4_arvalid  ;
wire [48:0]     S_AXI_DDR4_awaddr   ;
wire [1 :0]     S_AXI_DDR4_awburst  ;
wire [3 :0]     S_AXI_DDR4_awcache  ;
wire [5 :0]     S_AXI_DDR4_awid     ;
wire [7 :0]     S_AXI_DDR4_awlen    ;
wire            S_AXI_DDR4_awlock   ;
wire [2 :0]     S_AXI_DDR4_awprot   ;
wire [3 :0]     S_AXI_DDR4_awqos    ;
wire            S_AXI_DDR4_awready  ;
wire [2 :0]     S_AXI_DDR4_awsize   ;
wire            S_AXI_DDR4_awuser   ;
wire            S_AXI_DDR4_awvalid  ;
wire [5 :0]     S_AXI_DDR4_bid      ;
wire            S_AXI_DDR4_bready   ;
wire [1 :0]     S_AXI_DDR4_bresp    ;
wire            S_AXI_DDR4_bvalid   ;
wire [127:0]    S_AXI_DDR4_rdata    ;
wire [5 :0]     S_AXI_DDR4_rid      ;
wire            S_AXI_DDR4_rlast    ;
wire            S_AXI_DDR4_rready   ;
wire [1 :0]     S_AXI_DDR4_rresp    ;
wire            S_AXI_DDR4_rvalid   ;
wire [127:0]    S_AXI_DDR4_wdata    ;
wire            S_AXI_DDR4_wlast    ;
wire            S_AXI_DDR4_wready   ;
wire [15:0]     S_AXI_DDR4_wstrb    ;
wire            S_AXI_DDR4_wvalid   ;

wire            PRI                 ;
wire            CPIB                ;
wire            CPIE                ;
wire            sample_gate         ;

wire [39:0]     m_pl_ddr_axi_araddr ;
wire [1 :0]     m_pl_ddr_axi_arburst;
wire [3 :0]     m_pl_ddr_axi_arcache;
wire [15:0]     m_pl_ddr_axi_arid   ;
wire [7 :0]     m_pl_ddr_axi_arlen  ;
wire            m_pl_ddr_axi_arlock ;
wire [2 :0]     m_pl_ddr_axi_arprot ;
wire [3 :0]     m_pl_ddr_axi_arqos  ;
wire            m_pl_ddr_axi_arready;
wire [2 :0]     m_pl_ddr_axi_arsize ;
wire [15:0]     m_pl_ddr_axi_aruser ;
wire            m_pl_ddr_axi_arvalid;
wire [39:0]     m_pl_ddr_axi_awaddr ;
wire [1 :0]     m_pl_ddr_axi_awburst;
wire [3 :0]     m_pl_ddr_axi_awcache;
wire [15:0]     m_pl_ddr_axi_awid   ;
wire [7 :0]     m_pl_ddr_axi_awlen  ;
wire            m_pl_ddr_axi_awlock ;
wire [2 :0]     m_pl_ddr_axi_awprot ;
wire [3 :0]     m_pl_ddr_axi_awqos  ;
wire            m_pl_ddr_axi_awready;
wire [2 :0]     m_pl_ddr_axi_awsize ;
wire [15:0]     m_pl_ddr_axi_awuser ;
wire            m_pl_ddr_axi_awvalid;
wire [15:0]     m_pl_ddr_axi_bid    ;
wire            m_pl_ddr_axi_bready ;
wire [1 :0]     m_pl_ddr_axi_bresp  ;
wire            m_pl_ddr_axi_bvalid ;
wire [31:0]     m_pl_ddr_axi_rdata  ;
wire [15:0]     m_pl_ddr_axi_rid    ;
wire            m_pl_ddr_axi_rlast  ;
wire            m_pl_ddr_axi_rready ;
wire [1 :0]     m_pl_ddr_axi_rresp  ;
wire            m_pl_ddr_axi_rvalid ;
wire [31:0]     m_pl_ddr_axi_wdata  ;
wire            m_pl_ddr_axi_wlast  ;
wire            m_pl_ddr_axi_wready ;
wire [3 :0]     m_pl_ddr_axi_wstrb  ;
wire            m_pl_ddr_axi_wvalid ;
wire            pl_ddr_clk ;

wire [48:0]     s_axi_ps_ddr_ch0_araddr ;
wire [1 :0]     s_axi_ps_ddr_ch0_arburst;
wire [3 :0]     s_axi_ps_ddr_ch0_arcache;
wire [5 :0]     s_axi_ps_ddr_ch0_arid   ;
wire [7 :0]     s_axi_ps_ddr_ch0_arlen  ;
wire            s_axi_ps_ddr_ch0_arlock ;
wire [2 :0]     s_axi_ps_ddr_ch0_arprot ;
wire [3 :0]     s_axi_ps_ddr_ch0_arqos  ;
wire            s_axi_ps_ddr_ch0_arready;
wire [2 :0]     s_axi_ps_ddr_ch0_arsize ;
wire            s_axi_ps_ddr_ch0_aruser ;
wire            s_axi_ps_ddr_ch0_arvalid;
wire [48:0]     s_axi_ps_ddr_ch0_awaddr ;
wire [1 :0]     s_axi_ps_ddr_ch0_awburst;
wire [3 :0]     s_axi_ps_ddr_ch0_awcache;
wire [5 :0]     s_axi_ps_ddr_ch0_awid   ;
wire [7 :0]     s_axi_ps_ddr_ch0_awlen  ;
wire            s_axi_ps_ddr_ch0_awlock ;
wire [2 :0]     s_axi_ps_ddr_ch0_awprot ;
wire [3 :0]     s_axi_ps_ddr_ch0_awqos  ;
wire            s_axi_ps_ddr_ch0_awready;
wire [2 :0]     s_axi_ps_ddr_ch0_awsize ;
wire            s_axi_ps_ddr_ch0_awuser ;
wire            s_axi_ps_ddr_ch0_awvalid;
wire [5 :0]     s_axi_ps_ddr_ch0_bid    ;
wire            s_axi_ps_ddr_ch0_bready ;
wire [1 :0]     s_axi_ps_ddr_ch0_bresp  ;
wire            s_axi_ps_ddr_ch0_bvalid ;
wire [127:0]    s_axi_ps_ddr_ch0_rdata  ;
wire [5 :0]     s_axi_ps_ddr_ch0_rid    ;
wire            s_axi_ps_ddr_ch0_rlast  ;
wire            s_axi_ps_ddr_ch0_rready ;
wire [1 :0]     s_axi_ps_ddr_ch0_rresp  ;
wire            s_axi_ps_ddr_ch0_rvalid ;
wire [127:0]    s_axi_ps_ddr_ch0_wdata  ;
wire            s_axi_ps_ddr_ch0_wlast  ;
wire            s_axi_ps_ddr_ch0_wready ;
wire [15:0]     s_axi_ps_ddr_ch0_wstrb  ;
wire            s_axi_ps_ddr_ch0_wvalid ;

wire [39:0]     DPU0_M_AXI_DATA0_araddr ;
wire [1 :0]     DPU0_M_AXI_DATA0_arburst;
wire [3 :0]     DPU0_M_AXI_DATA0_arcache;
wire [1 :0]     DPU0_M_AXI_DATA0_arid   ;
wire [7 :0]     DPU0_M_AXI_DATA0_arlen  ;
wire [0 :0]     DPU0_M_AXI_DATA0_arlock ;
wire [2 :0]     DPU0_M_AXI_DATA0_arprot ;
wire [3 :0]     DPU0_M_AXI_DATA0_arqos  ;
wire            DPU0_M_AXI_DATA0_arready;
wire [2 :0]     DPU0_M_AXI_DATA0_arsize ;
wire [0 :0]     DPU0_M_AXI_DATA0_aruser ;
wire            DPU0_M_AXI_DATA0_arvalid;
wire [39:0]     DPU0_M_AXI_DATA0_awaddr ;
wire [1 :0]     DPU0_M_AXI_DATA0_awburst;
wire [3 :0]     DPU0_M_AXI_DATA0_awcache;
wire [1 :0]     DPU0_M_AXI_DATA0_awid   ;
wire [7 :0]     DPU0_M_AXI_DATA0_awlen  ;
wire [0 :0]     DPU0_M_AXI_DATA0_awlock ;
wire [2 :0]     DPU0_M_AXI_DATA0_awprot ;
wire [3 :0]     DPU0_M_AXI_DATA0_awqos  ;
wire            DPU0_M_AXI_DATA0_awready;
wire [2 :0]     DPU0_M_AXI_DATA0_awsize ;
wire [0 :0]     DPU0_M_AXI_DATA0_awuser ;
wire            DPU0_M_AXI_DATA0_awvalid;
wire [5 :0]     DPU0_M_AXI_DATA0_bid    ;
wire            DPU0_M_AXI_DATA0_bready ;
wire [1 :0]     DPU0_M_AXI_DATA0_bresp  ;
wire            DPU0_M_AXI_DATA0_bvalid ;
wire [127:0]    DPU0_M_AXI_DATA0_rdata  ;
wire [5 :0]     DPU0_M_AXI_DATA0_rid    ;
wire            DPU0_M_AXI_DATA0_rlast  ;
wire            DPU0_M_AXI_DATA0_rready ;
wire [1 :0]     DPU0_M_AXI_DATA0_rresp  ;
wire            DPU0_M_AXI_DATA0_rvalid ;
wire [127:0]    DPU0_M_AXI_DATA0_wdata  ;
wire [5 :0]     DPU0_M_AXI_DATA0_wid    ;
wire            DPU0_M_AXI_DATA0_wlast  ;
wire            DPU0_M_AXI_DATA0_wready ;
wire [15:0]     DPU0_M_AXI_DATA0_wstrb  ;
wire            DPU0_M_AXI_DATA0_wvalid ;

wire [39:0]     DPU0_M_AXI_DATA1_araddr ;
wire [1 :0]     DPU0_M_AXI_DATA1_arburst;
wire [3 :0]     DPU0_M_AXI_DATA1_arcache;
wire [1 :0]     DPU0_M_AXI_DATA1_arid   ;
wire [7 :0]     DPU0_M_AXI_DATA1_arlen  ;
wire [0 :0]     DPU0_M_AXI_DATA1_arlock ;
wire [2 :0]     DPU0_M_AXI_DATA1_arprot ;
wire [3 :0]     DPU0_M_AXI_DATA1_arqos  ;
wire            DPU0_M_AXI_DATA1_arready;
wire [2 :0]     DPU0_M_AXI_DATA1_arsize ;
wire [0 :0]     DPU0_M_AXI_DATA1_aruser ;
wire            DPU0_M_AXI_DATA1_arvalid;
wire [39:0]     DPU0_M_AXI_DATA1_awaddr ;
wire [1 :0]     DPU0_M_AXI_DATA1_awburst;
wire [3 :0]     DPU0_M_AXI_DATA1_awcache;
wire [1 :0]     DPU0_M_AXI_DATA1_awid   ;
wire [7 :0]     DPU0_M_AXI_DATA1_awlen  ;
wire [0 :0]     DPU0_M_AXI_DATA1_awlock ;
wire [2 :0]     DPU0_M_AXI_DATA1_awprot ;
wire [3 :0]     DPU0_M_AXI_DATA1_awqos  ;
wire            DPU0_M_AXI_DATA1_awready;
wire [2 :0]     DPU0_M_AXI_DATA1_awsize ;
wire [0 :0]     DPU0_M_AXI_DATA1_awuser ;
wire            DPU0_M_AXI_DATA1_awvalid;
wire [5 :0]     DPU0_M_AXI_DATA1_bid    ;
wire            DPU0_M_AXI_DATA1_bready ;
wire [1 :0]     DPU0_M_AXI_DATA1_bresp  ;
wire            DPU0_M_AXI_DATA1_bvalid ;
wire [127:0]    DPU0_M_AXI_DATA1_rdata  ;
wire [5 :0]     DPU0_M_AXI_DATA1_rid    ;
wire            DPU0_M_AXI_DATA1_rlast  ;
wire            DPU0_M_AXI_DATA1_rready ;
wire [1 :0]     DPU0_M_AXI_DATA1_rresp  ;
wire            DPU0_M_AXI_DATA1_rvalid ;
wire [127:0]    DPU0_M_AXI_DATA1_wdata  ;
wire [5 :0]     DPU0_M_AXI_DATA1_wid    ;
wire            DPU0_M_AXI_DATA1_wlast  ;
wire            DPU0_M_AXI_DATA1_wready ;
wire [15:0]     DPU0_M_AXI_DATA1_wstrb  ;
wire            DPU0_M_AXI_DATA1_wvalid ;
wire [39:0]     DPU0_M_AXI_INSTR_araddr ;
wire [1 :0]     DPU0_M_AXI_INSTR_arburst;
wire [3 :0]     DPU0_M_AXI_INSTR_arcache;
wire [1 :0]     DPU0_M_AXI_INSTR_arid   ;
wire [7 :0]     DPU0_M_AXI_INSTR_arlen  ;
wire [0 :0]     DPU0_M_AXI_INSTR_arlock ;
wire [2 :0]     DPU0_M_AXI_INSTR_arprot ;
wire [3 :0]     DPU0_M_AXI_INSTR_arqos  ;
wire            DPU0_M_AXI_INSTR_arready;
wire [2 :0]     DPU0_M_AXI_INSTR_arsize ;
wire [0 :0]     DPU0_M_AXI_INSTR_aruser ;
wire            DPU0_M_AXI_INSTR_arvalid;
wire [39:0]     DPU0_M_AXI_INSTR_awaddr ;
wire [1 :0]     DPU0_M_AXI_INSTR_awburst;
wire [3 :0]     DPU0_M_AXI_INSTR_awcache;
wire [1 :0]     DPU0_M_AXI_INSTR_awid   ;
wire [7 :0]     DPU0_M_AXI_INSTR_awlen  ;
wire [0 :0]     DPU0_M_AXI_INSTR_awlock ;
wire [2 :0]     DPU0_M_AXI_INSTR_awprot ;
wire [3 :0]     DPU0_M_AXI_INSTR_awqos  ;
wire            DPU0_M_AXI_INSTR_awready;
wire [2 :0]     DPU0_M_AXI_INSTR_awsize ;
wire [0 :0]     DPU0_M_AXI_INSTR_awuser ;
wire            DPU0_M_AXI_INSTR_awvalid;
wire [5 :0]     DPU0_M_AXI_INSTR_bid    ;
wire            DPU0_M_AXI_INSTR_bready ;
wire [1 :0]     DPU0_M_AXI_INSTR_bresp  ;
wire            DPU0_M_AXI_INSTR_bvalid ;
wire [31:0]     DPU0_M_AXI_INSTR_rdata  ;
wire [5 :0]     DPU0_M_AXI_INSTR_rid    ;
wire            DPU0_M_AXI_INSTR_rlast  ;
wire            DPU0_M_AXI_INSTR_rready ;
wire [1 :0]     DPU0_M_AXI_INSTR_rresp  ; 
wire            DPU0_M_AXI_INSTR_rvalid ;
wire  [31:0]    DPU0_M_AXI_INSTR_wdata  ; 
wire  [5:0]     DPU0_M_AXI_INSTR_wid    ;
wire            DPU0_M_AXI_INSTR_wlast  ;
wire            DPU0_M_AXI_INSTR_wready ;
wire  [3:0]     DPU0_M_AXI_INSTR_wstrb  ;
wire            DPU0_M_AXI_INSTR_wvalid ;
wire            dpu0_interrupt          ;
wire            dpu_2x_clk              ;
wire            dpu_2x_resetn           ;
wire            m_axi_dpu_aclk          ;
wire            m_axi_dpu_aresetn       ;
wire            s_axi_aclk_dpu          ;
wire            s_axi_aresetn_dpu       ;
wire   [31:0]   s_axi_dpu_araddr        ;
wire   [1:0]    s_axi_dpu_arburst       ;
wire   [3:0]    s_axi_dpu_arcache       ;
wire   [15:0]   s_axi_dpu_arid          ;
wire   [7:0]    s_axi_dpu_arlen         ;
wire   [1:0]    s_axi_dpu_arlock        ;
wire   [2:0]    s_axi_dpu_arprot        ;
wire   [3:0]    s_axi_dpu_arqos         ;
wire            s_axi_dpu_arready       ;
wire   [3:0]    s_axi_dpu_arregion      ;
wire   [2:0]    s_axi_dpu_arsize        ;
wire   [15:0]   s_axi_dpu_aruser        ;
wire            s_axi_dpu_arvalid       ;
wire   [31:0]   s_axi_dpu_awaddr        ;
wire   [1:0]    s_axi_dpu_awburst       ;
wire   [3:0]    s_axi_dpu_awcache       ;
wire   [15:0]   s_axi_dpu_awid          ;
wire   [7:0]    s_axi_dpu_awlen         ;
wire   [1:0]    s_axi_dpu_awlock        ;
wire   [2:0]    s_axi_dpu_awprot        ;
wire   [3:0]    s_axi_dpu_awqos         ;
wire            s_axi_dpu_awready       ;
wire   [3:0]    s_axi_dpu_awregion      ;
wire   [2:0]    s_axi_dpu_awsize        ;
wire   [15:0]   s_axi_dpu_awuser        ;
wire            s_axi_dpu_awvalid       ;
wire   [15:0]   s_axi_dpu_bid           ;
wire            s_axi_dpu_bready        ;
wire   [1:0]    s_axi_dpu_bresp         ;
wire            s_axi_dpu_bvalid        ;
wire   [31:0]   s_axi_dpu_rdata         ;
wire   [15:0]   s_axi_dpu_rid           ;
wire            s_axi_dpu_rlast         ;
wire            s_axi_dpu_rready        ;
wire   [1:0]    s_axi_dpu_rresp         ;
wire            s_axi_dpu_rvalid        ;
wire   [31:0]   s_axi_dpu_wdata         ;
wire   [15:0]   s_axi_dpu_wid           ;
wire            s_axi_dpu_wlast         ;
wire            s_axi_dpu_wready        ;
wire   [3:0]    s_axi_dpu_wstrb         ;
wire            s_axi_dpu_wvalid        ;
wire            dpu_irp                 ;
wire            clk_ai_250m             ;
wire            clk_ai_500m             ;
wire            adc_wr_irp              ;
wire 		    rdmap_wr_irq	        ;
wire            rdmapIQ_wr_irq          ;
(* MARK_DEBUG="true" *)wire            detection_log_irq;
wire    [8*32-1:0] tag_info             ;

`ifndef SIM
system_wrapper system_wrapper (
    .m_axi_pl_araddr            (m_axi_pl_araddr            ),
    .m_axi_pl_arprot            (m_axi_pl_arprot            ),
    .m_axi_pl_arready           (m_axi_pl_arready           ),
    .m_axi_pl_arvalid           (m_axi_pl_arvalid           ),
    .m_axi_pl_awaddr            (m_axi_pl_awaddr            ),
    .m_axi_pl_awprot            (m_axi_pl_awprot            ),
    .m_axi_pl_awready           (m_axi_pl_awready           ),
    .m_axi_pl_awvalid           (m_axi_pl_awvalid           ),
    .m_axi_pl_bready            (m_axi_pl_bready            ),
    .m_axi_pl_bresp             (m_axi_pl_bresp             ),
    .m_axi_pl_bvalid            (m_axi_pl_bvalid            ),
    .m_axi_pl_rdata             (m_axi_pl_rdata             ),
    .m_axi_pl_rready            (m_axi_pl_rready            ),
    .m_axi_pl_rresp             (m_axi_pl_rresp             ),
    .m_axi_pl_rvalid            (m_axi_pl_rvalid            ),
    .m_axi_pl_wdata             (m_axi_pl_wdata             ),
    .m_axi_pl_wready            (m_axi_pl_wready            ),
    .m_axi_pl_wstrb             (m_axi_pl_wstrb             ),
    .m_axi_pl_wvalid            (m_axi_pl_wvalid            ),

    .m_pl_ddr_axi_araddr        (m_pl_ddr_axi_araddr        ),
    .m_pl_ddr_axi_arburst       (m_pl_ddr_axi_arburst       ),
    .m_pl_ddr_axi_arcache       (m_pl_ddr_axi_arcache       ),
    .m_pl_ddr_axi_arid          (m_pl_ddr_axi_arid          ),
    .m_pl_ddr_axi_arlen         (m_pl_ddr_axi_arlen         ),
    .m_pl_ddr_axi_arlock        (m_pl_ddr_axi_arlock        ),
    .m_pl_ddr_axi_arprot        (m_pl_ddr_axi_arprot        ),
    .m_pl_ddr_axi_arqos         (m_pl_ddr_axi_arqos         ),
    .m_pl_ddr_axi_arready       (m_pl_ddr_axi_arready       ),
    .m_pl_ddr_axi_arsize        (m_pl_ddr_axi_arsize        ),
    .m_pl_ddr_axi_aruser        (m_pl_ddr_axi_aruser        ),
    .m_pl_ddr_axi_arvalid       (m_pl_ddr_axi_arvalid       ),
    .m_pl_ddr_axi_awaddr        (m_pl_ddr_axi_awaddr        ),
    .m_pl_ddr_axi_awburst       (m_pl_ddr_axi_awburst       ),
    .m_pl_ddr_axi_awcache       (m_pl_ddr_axi_awcache       ),
    .m_pl_ddr_axi_awid          (m_pl_ddr_axi_awid          ),
    .m_pl_ddr_axi_awlen         (m_pl_ddr_axi_awlen         ),
    .m_pl_ddr_axi_awlock        (m_pl_ddr_axi_awlock        ),
    .m_pl_ddr_axi_awprot        (m_pl_ddr_axi_awprot        ),
    .m_pl_ddr_axi_awqos         (m_pl_ddr_axi_awqos         ),
    .m_pl_ddr_axi_awready       (m_pl_ddr_axi_awready       ),
    .m_pl_ddr_axi_awsize        (m_pl_ddr_axi_awsize        ),
    .m_pl_ddr_axi_awuser        (m_pl_ddr_axi_awuser        ),
    .m_pl_ddr_axi_awvalid       (m_pl_ddr_axi_awvalid       ),
    .m_pl_ddr_axi_bid           (m_pl_ddr_axi_bid           ),
    .m_pl_ddr_axi_bready        (m_pl_ddr_axi_bready        ),
    .m_pl_ddr_axi_bresp         (m_pl_ddr_axi_bresp         ),
    .m_pl_ddr_axi_bvalid        (m_pl_ddr_axi_bvalid        ),
    .m_pl_ddr_axi_rdata         (m_pl_ddr_axi_rdata         ),
    .m_pl_ddr_axi_rid           ({12'd0,m_pl_ddr_axi_rid}   ),
    .m_pl_ddr_axi_rlast         (m_pl_ddr_axi_rlast         ),
    .m_pl_ddr_axi_rready        (m_pl_ddr_axi_rready        ),
    .m_pl_ddr_axi_rresp         (m_pl_ddr_axi_rresp         ),
    .m_pl_ddr_axi_rvalid        (m_pl_ddr_axi_rvalid        ),
    .m_pl_ddr_axi_wdata         (m_pl_ddr_axi_wdata         ),
    .m_pl_ddr_axi_wlast         (m_pl_ddr_axi_wlast         ),
    .m_pl_ddr_axi_wready        (m_pl_ddr_axi_wready        ),
    .m_pl_ddr_axi_wstrb         (m_pl_ddr_axi_wstrb         ),
    .m_pl_ddr_axi_wvalid        (m_pl_ddr_axi_wvalid        ),
    .pl_ddr_clk                 (pl_ddr_clk                 ),

    .s_axi_ps_ddr_ch0_araddr    (s_axi_ps_ddr_ch0_araddr    ),
    .s_axi_ps_ddr_ch0_arburst   (s_axi_ps_ddr_ch0_arburst   ),
    .s_axi_ps_ddr_ch0_arcache   (s_axi_ps_ddr_ch0_arcache   ),
    .s_axi_ps_ddr_ch0_arid      (s_axi_ps_ddr_ch0_arid      ),
    .s_axi_ps_ddr_ch0_arlen     (s_axi_ps_ddr_ch0_arlen     ),
    .s_axi_ps_ddr_ch0_arlock    (s_axi_ps_ddr_ch0_arlock    ),
    .s_axi_ps_ddr_ch0_arprot    (s_axi_ps_ddr_ch0_arprot    ),
    .s_axi_ps_ddr_ch0_arqos     (s_axi_ps_ddr_ch0_arqos     ),
    .s_axi_ps_ddr_ch0_arready   (s_axi_ps_ddr_ch0_arready   ),
    .s_axi_ps_ddr_ch0_arsize    (s_axi_ps_ddr_ch0_arsize    ),
    .s_axi_ps_ddr_ch0_aruser    (s_axi_ps_ddr_ch0_aruser    ),
    .s_axi_ps_ddr_ch0_arvalid   (s_axi_ps_ddr_ch0_arvalid   ),
    .s_axi_ps_ddr_ch0_awaddr    (s_axi_ps_ddr_ch0_awaddr    ),
    .s_axi_ps_ddr_ch0_awburst   (s_axi_ps_ddr_ch0_awburst   ),
    .s_axi_ps_ddr_ch0_awcache   (s_axi_ps_ddr_ch0_awcache   ),
    .s_axi_ps_ddr_ch0_awid      (s_axi_ps_ddr_ch0_awid      ),
    .s_axi_ps_ddr_ch0_awlen     (s_axi_ps_ddr_ch0_awlen     ),
    .s_axi_ps_ddr_ch0_awlock    (s_axi_ps_ddr_ch0_awlock    ),
    .s_axi_ps_ddr_ch0_awprot    (s_axi_ps_ddr_ch0_awprot    ),
    .s_axi_ps_ddr_ch0_awqos     (s_axi_ps_ddr_ch0_awqos     ),
    .s_axi_ps_ddr_ch0_awready   (s_axi_ps_ddr_ch0_awready   ),
    .s_axi_ps_ddr_ch0_awsize    (s_axi_ps_ddr_ch0_awsize    ),
    .s_axi_ps_ddr_ch0_awuser    (s_axi_ps_ddr_ch0_awuser    ),
    .s_axi_ps_ddr_ch0_awvalid   (s_axi_ps_ddr_ch0_awvalid   ),
    .s_axi_ps_ddr_ch0_bid       (s_axi_ps_ddr_ch0_bid       ),
    .s_axi_ps_ddr_ch0_bready    (s_axi_ps_ddr_ch0_bready    ),
    .s_axi_ps_ddr_ch0_bresp     (s_axi_ps_ddr_ch0_bresp     ),
    .s_axi_ps_ddr_ch0_bvalid    (s_axi_ps_ddr_ch0_bvalid    ),
    .s_axi_ps_ddr_ch0_rdata     (s_axi_ps_ddr_ch0_rdata     ),
    .s_axi_ps_ddr_ch0_rid       (s_axi_ps_ddr_ch0_rid       ),
    .s_axi_ps_ddr_ch0_rlast     (s_axi_ps_ddr_ch0_rlast     ),
    .s_axi_ps_ddr_ch0_rready    (s_axi_ps_ddr_ch0_rready    ),
    .s_axi_ps_ddr_ch0_rresp     (s_axi_ps_ddr_ch0_rresp     ),
    .s_axi_ps_ddr_ch0_rvalid    (s_axi_ps_ddr_ch0_rvalid    ),
    .s_axi_ps_ddr_ch0_wdata     (s_axi_ps_ddr_ch0_wdata     ),
    .s_axi_ps_ddr_ch0_wlast     (s_axi_ps_ddr_ch0_wlast     ),
    .s_axi_ps_ddr_ch0_wready    (s_axi_ps_ddr_ch0_wready    ),
    .s_axi_ps_ddr_ch0_wstrb     (s_axi_ps_ddr_ch0_wstrb     ),
    .s_axi_ps_ddr_ch0_wvalid    (s_axi_ps_ddr_ch0_wvalid    ),

    .m_axi_ai_araddr            (s_axi_dpu_araddr           ),
    .m_axi_ai_arburst           (s_axi_dpu_arburst          ),
    .m_axi_ai_arcache           (s_axi_dpu_arcache          ),
    .m_axi_ai_arid              (s_axi_dpu_arid             ),
    .m_axi_ai_arlen             (s_axi_dpu_arlen            ),
    .m_axi_ai_arlock            (s_axi_dpu_arlock           ),
    .m_axi_ai_arprot            (s_axi_dpu_arprot           ),
    .m_axi_ai_arqos             (s_axi_dpu_arqos            ),
    .m_axi_ai_arready           (s_axi_dpu_arready          ),
    .m_axi_ai_arsize            (s_axi_dpu_arsize           ),
    .m_axi_ai_aruser            (s_axi_dpu_aruser           ),
    .m_axi_ai_arvalid           (s_axi_dpu_arvalid          ),
    .m_axi_ai_awaddr            (s_axi_dpu_awaddr           ),
    .m_axi_ai_awburst           (s_axi_dpu_awburst          ),
    .m_axi_ai_awcache           (s_axi_dpu_awcache          ),
    .m_axi_ai_awid              (s_axi_dpu_awid             ),
    .m_axi_ai_awlen             (s_axi_dpu_awlen            ),
    .m_axi_ai_awlock            (s_axi_dpu_awlock           ),
    .m_axi_ai_awprot            (s_axi_dpu_awprot           ),
    .m_axi_ai_awqos             (s_axi_dpu_awqos            ),
    .m_axi_ai_awready           (s_axi_dpu_awready          ),
    .m_axi_ai_awsize            (s_axi_dpu_awsize           ),
    .m_axi_ai_awuser            (s_axi_dpu_awuser           ),
    .m_axi_ai_awvalid           (s_axi_dpu_awvalid          ),
    .m_axi_ai_bid               (s_axi_dpu_bid              ),
    .m_axi_ai_bready            (s_axi_dpu_bready           ),
    .m_axi_ai_bresp             (s_axi_dpu_bresp            ),
    .m_axi_ai_bvalid            (s_axi_dpu_bvalid           ),
    .m_axi_ai_rdata             (s_axi_dpu_rdata            ),
    .m_axi_ai_rid               (s_axi_dpu_rid              ),
    .m_axi_ai_rlast             (s_axi_dpu_rlast            ),
    .m_axi_ai_rready            (s_axi_dpu_rready           ),
    .m_axi_ai_rresp             (s_axi_dpu_rresp            ),
    .m_axi_ai_rvalid            (s_axi_dpu_rvalid           ),
    .m_axi_ai_wdata             (s_axi_dpu_wdata            ),
    .m_axi_ai_wlast             (s_axi_dpu_wlast            ),
    .m_axi_ai_wready            (s_axi_dpu_wready           ),
    .m_axi_ai_wstrb             (s_axi_dpu_wstrb            ),
    .m_axi_ai_wvalid            (s_axi_dpu_wvalid           ),

    .s_axi_ai_ch0_araddr        (DPU0_M_AXI_DATA0_araddr    ),
    .s_axi_ai_ch0_arburst       (DPU0_M_AXI_DATA0_arburst   ),
    .s_axi_ai_ch0_arcache       (DPU0_M_AXI_DATA0_arcache   ),
    .s_axi_ai_ch0_arid          (DPU0_M_AXI_DATA0_arid      ),
    .s_axi_ai_ch0_arlen         (DPU0_M_AXI_DATA0_arlen     ),
    .s_axi_ai_ch0_arlock        (DPU0_M_AXI_DATA0_arlock    ),
    .s_axi_ai_ch0_arprot        (DPU0_M_AXI_DATA0_arprot    ),
    .s_axi_ai_ch0_arqos         (DPU0_M_AXI_DATA0_arqos     ),
    .s_axi_ai_ch0_arready       (DPU0_M_AXI_DATA0_arready   ),
    .s_axi_ai_ch0_arsize        (DPU0_M_AXI_DATA0_arsize    ),
    .s_axi_ai_ch0_aruser        (DPU0_M_AXI_DATA0_aruser    ),
    .s_axi_ai_ch0_arvalid       (DPU0_M_AXI_DATA0_arvalid   ),
    .s_axi_ai_ch0_awaddr        (DPU0_M_AXI_DATA0_awaddr    ),
    .s_axi_ai_ch0_awburst       (DPU0_M_AXI_DATA0_awburst   ),
    .s_axi_ai_ch0_awcache       (DPU0_M_AXI_DATA0_awcache   ),
    .s_axi_ai_ch0_awid          (DPU0_M_AXI_DATA0_awid      ),
    .s_axi_ai_ch0_awlen         (DPU0_M_AXI_DATA0_awlen     ),
    .s_axi_ai_ch0_awlock        (DPU0_M_AXI_DATA0_awlock    ),
    .s_axi_ai_ch0_awprot        (DPU0_M_AXI_DATA0_awprot    ),
    .s_axi_ai_ch0_awqos         (DPU0_M_AXI_DATA0_awqos     ),
    .s_axi_ai_ch0_awready       (DPU0_M_AXI_DATA0_awready   ),
    .s_axi_ai_ch0_awsize        (DPU0_M_AXI_DATA0_awsize    ),
    .s_axi_ai_ch0_awuser        (DPU0_M_AXI_DATA0_awuser    ),
    .s_axi_ai_ch0_awvalid       (DPU0_M_AXI_DATA0_awvalid   ),
    .s_axi_ai_ch0_bid           (DPU0_M_AXI_DATA0_bid       ),
    .s_axi_ai_ch0_bready        (DPU0_M_AXI_DATA0_bready    ),
    .s_axi_ai_ch0_bresp         (DPU0_M_AXI_DATA0_bresp     ),
    .s_axi_ai_ch0_bvalid        (DPU0_M_AXI_DATA0_bvalid    ),
    .s_axi_ai_ch0_rdata         (DPU0_M_AXI_DATA0_rdata     ),
    .s_axi_ai_ch0_rid           (DPU0_M_AXI_DATA0_rid       ),
    .s_axi_ai_ch0_rlast         (DPU0_M_AXI_DATA0_rlast     ),
    .s_axi_ai_ch0_rready        (DPU0_M_AXI_DATA0_rready    ),
    .s_axi_ai_ch0_rresp         (DPU0_M_AXI_DATA0_rresp     ),
    .s_axi_ai_ch0_rvalid        (DPU0_M_AXI_DATA0_rvalid    ),
    .s_axi_ai_ch0_wdata         (DPU0_M_AXI_DATA0_wdata     ),
    .s_axi_ai_ch0_wlast         (DPU0_M_AXI_DATA0_wlast     ),
    .s_axi_ai_ch0_wready        (DPU0_M_AXI_DATA0_wready    ),
    .s_axi_ai_ch0_wstrb         (DPU0_M_AXI_DATA0_wstrb     ),
    .s_axi_ai_ch0_wvalid        (DPU0_M_AXI_DATA0_wvalid    ),

    .s_axi_ai_ch1_araddr        (DPU0_M_AXI_DATA1_araddr    ),
    .s_axi_ai_ch1_arburst       (DPU0_M_AXI_DATA1_arburst   ),
    .s_axi_ai_ch1_arcache       (DPU0_M_AXI_DATA1_arcache   ),
    .s_axi_ai_ch1_arid          (DPU0_M_AXI_DATA1_arid      ),
    .s_axi_ai_ch1_arlen         (DPU0_M_AXI_DATA1_arlen     ),
    .s_axi_ai_ch1_arlock        (DPU0_M_AXI_DATA1_arlock    ),
    .s_axi_ai_ch1_arprot        (DPU0_M_AXI_DATA1_arprot    ),
    .s_axi_ai_ch1_arqos         (DPU0_M_AXI_DATA1_arqos     ),
    .s_axi_ai_ch1_arready       (DPU0_M_AXI_DATA1_arready   ),
    .s_axi_ai_ch1_arsize        (DPU0_M_AXI_DATA1_arsize    ),
    .s_axi_ai_ch1_aruser        (DPU0_M_AXI_DATA1_aruser    ),
    .s_axi_ai_ch1_arvalid       (DPU0_M_AXI_DATA1_arvalid   ),
    .s_axi_ai_ch1_awaddr        (DPU0_M_AXI_DATA1_awaddr    ),
    .s_axi_ai_ch1_awburst       (DPU0_M_AXI_DATA1_awburst   ),
    .s_axi_ai_ch1_awcache       (DPU0_M_AXI_DATA1_awcache   ),
    .s_axi_ai_ch1_awid          (DPU0_M_AXI_DATA1_awid      ),
    .s_axi_ai_ch1_awlen         (DPU0_M_AXI_DATA1_awlen     ),
    .s_axi_ai_ch1_awlock        (DPU0_M_AXI_DATA1_awlock    ),
    .s_axi_ai_ch1_awprot        (DPU0_M_AXI_DATA1_awprot    ),
    .s_axi_ai_ch1_awqos         (DPU0_M_AXI_DATA1_awqos     ),
    .s_axi_ai_ch1_awready       (DPU0_M_AXI_DATA1_awready   ),
    .s_axi_ai_ch1_awsize        (DPU0_M_AXI_DATA1_awsize    ),
    .s_axi_ai_ch1_awuser        (DPU0_M_AXI_DATA1_awuser    ),
    .s_axi_ai_ch1_awvalid       (DPU0_M_AXI_DATA1_awvalid   ),
    .s_axi_ai_ch1_bid           (DPU0_M_AXI_DATA1_bid       ),
    .s_axi_ai_ch1_bready        (DPU0_M_AXI_DATA1_bready    ),
    .s_axi_ai_ch1_bresp         (DPU0_M_AXI_DATA1_bresp     ),
    .s_axi_ai_ch1_bvalid        (DPU0_M_AXI_DATA1_bvalid    ),
    .s_axi_ai_ch1_rdata         (DPU0_M_AXI_DATA1_rdata     ),
    .s_axi_ai_ch1_rid           (DPU0_M_AXI_DATA1_rid       ),
    .s_axi_ai_ch1_rlast         (DPU0_M_AXI_DATA1_rlast     ),
    .s_axi_ai_ch1_rready        (DPU0_M_AXI_DATA1_rready    ),
    .s_axi_ai_ch1_rresp         (DPU0_M_AXI_DATA1_rresp     ),
    .s_axi_ai_ch1_rvalid        (DPU0_M_AXI_DATA1_rvalid    ),
    .s_axi_ai_ch1_wdata         (DPU0_M_AXI_DATA1_wdata     ),
    .s_axi_ai_ch1_wlast         (DPU0_M_AXI_DATA1_wlast     ),
    .s_axi_ai_ch1_wready        (DPU0_M_AXI_DATA1_wready    ),
    .s_axi_ai_ch1_wstrb         (DPU0_M_AXI_DATA1_wstrb     ),
    .s_axi_ai_ch1_wvalid        (DPU0_M_AXI_DATA1_wvalid    ),

    .s_axi_ai_inest_araddr      (DPU0_M_AXI_INSTR_araddr    ),
    .s_axi_ai_inest_arburst     (DPU0_M_AXI_INSTR_arburst   ),
    .s_axi_ai_inest_arcache     (DPU0_M_AXI_INSTR_arcache   ),
    .s_axi_ai_inest_arid        (DPU0_M_AXI_INSTR_arid      ),
    .s_axi_ai_inest_arlen       (DPU0_M_AXI_INSTR_arlen     ),
    .s_axi_ai_inest_arlock      (DPU0_M_AXI_INSTR_arlock    ),
    .s_axi_ai_inest_arprot      (DPU0_M_AXI_INSTR_arprot    ),
    .s_axi_ai_inest_arqos       (DPU0_M_AXI_INSTR_arqos     ),
    .s_axi_ai_inest_arready     (DPU0_M_AXI_INSTR_arready   ),
    .s_axi_ai_inest_arsize      (DPU0_M_AXI_INSTR_arsize    ),
    .s_axi_ai_inest_aruser      (DPU0_M_AXI_INSTR_aruser    ),
    .s_axi_ai_inest_arvalid     (DPU0_M_AXI_INSTR_arvalid   ),
    .s_axi_ai_inest_awaddr      (DPU0_M_AXI_INSTR_awaddr    ),
    .s_axi_ai_inest_awburst     (DPU0_M_AXI_INSTR_awburst   ),
    .s_axi_ai_inest_awcache     (DPU0_M_AXI_INSTR_awcache   ),
    .s_axi_ai_inest_awid        (DPU0_M_AXI_INSTR_awid      ),
    .s_axi_ai_inest_awlen       (DPU0_M_AXI_INSTR_awlen     ),
    .s_axi_ai_inest_awlock      (DPU0_M_AXI_INSTR_awlock    ),
    .s_axi_ai_inest_awprot      (DPU0_M_AXI_INSTR_awprot    ),
    .s_axi_ai_inest_awqos       (DPU0_M_AXI_INSTR_awqos     ),
    .s_axi_ai_inest_awready     (DPU0_M_AXI_INSTR_awready   ),
    .s_axi_ai_inest_awsize      (DPU0_M_AXI_INSTR_awsize    ),
    .s_axi_ai_inest_awuser      (DPU0_M_AXI_INSTR_awuser    ),
    .s_axi_ai_inest_awvalid     (DPU0_M_AXI_INSTR_awvalid   ),
    .s_axi_ai_inest_bid         (DPU0_M_AXI_INSTR_bid       ),
    .s_axi_ai_inest_bready      (DPU0_M_AXI_INSTR_bready    ),
    .s_axi_ai_inest_bresp       (DPU0_M_AXI_INSTR_bresp     ),
    .s_axi_ai_inest_bvalid      (DPU0_M_AXI_INSTR_bvalid    ),
    .s_axi_ai_inest_rdata       (DPU0_M_AXI_INSTR_rdata     ),
    .s_axi_ai_inest_rid         (DPU0_M_AXI_INSTR_rid       ),
    .s_axi_ai_inest_rlast       (DPU0_M_AXI_INSTR_rlast     ),
    .s_axi_ai_inest_rready      (DPU0_M_AXI_INSTR_rready    ),
    .s_axi_ai_inest_rresp       (DPU0_M_AXI_INSTR_rresp     ),
    .s_axi_ai_inest_rvalid      (DPU0_M_AXI_INSTR_rvalid    ),
    .s_axi_ai_inest_wdata       (DPU0_M_AXI_INSTR_wdata     ),
    .s_axi_ai_inest_wlast       (DPU0_M_AXI_INSTR_wlast     ),
    .s_axi_ai_inest_wready      (DPU0_M_AXI_INSTR_wready    ),
    .s_axi_ai_inest_wstrb       (DPU0_M_AXI_INSTR_wstrb     ),
    .s_axi_ai_inest_wvalid      (DPU0_M_AXI_INSTR_wvalid    ),

    .clk_ai_250m                (clk_ai_250m                ),
    .clk_ai_500m                (clk_ai_500m                ),
    .ps_clk_100m                (ps_clk_100m                ),
    .ps_clk_200m                (ps_clk_200m                ),
    .pl_rst_n                   (pl_rst_n                   ),

    .GPIO_0_tri_io              (GPIO_0_tri_io              ),
    .IIC0_scl_io                (PLI2C_1_SCL                ),
    .IIC0_sda_io                (PLI2C_1_SDA                ),
    .IIC1_scl_io                (PLI2C_2_SCL                ),
    .IIC1_sda_io                (PLI2C_2_SDA                ),
    .IIC2_scl_io                (PLI2C3_SCL_1V2             ),
    .IIC2_sda_io                (PLI2C3_SDA_1V2             ),
    .IIC3_scl_io                (acc_i2c_scl                ),
    .IIC3_sda_io                (acc_i2c_sda                ),    
    // .UART0_rxd                  (AP_UART2_RX_1V2            ),
    // .UART0_txd                  (AP_UART2_TX_1V2            ),
    .UART0_rxd                  (IMU_RX                     ),
    .UART0_txd                  (IMU_TX                     ),
    .UART1_rxd                  (CP_UART3_RX_1V8            ),
    .UART1_txd                  (CP_UART3_TX_1V8            ),
    .UART2_rxd                  (                ),
    .UART2_txd                  (                ),
    .UART3_rxd                  (MCU_WDG_RX                 ),
    .UART3_txd                  (MCU_WDG_TX                 ),
    .UART4_rxd                  (gps_uart_rx                ),
    .UART4_txd                  (gps_uart_tx                ),

    .irp0                       (wr_irp                     ),
    .irp1                       (rd_irp                     ),
    .irp2                       (                           ),

    // .irq5                       (rdmapIQ_wr_irq             ),
    .irq5                       (detection_log_irq             ),
    .irp6                       (CPIB                       ),
    .irp7                       (adc_abnormal_irp           )
);

assign spi_lmx2492_TRIG1    = GPIO_0_tri_io[0] ;
assign TC_SHIFT_OE_1V2      = GPIO_0_tri_io[1] ;
assign ANT_EN_1V2           = GPIO_0_tri_io[2] ;
assign ANT_CTRL_1V2         = GPIO_0_tri_io[3] ;
assign TC_DGB_BOOT_1V2      = GPIO_0_tri_io[4] ;
assign TC_PIO_RFU_1V2       = GPIO_0_tri_io[5] ;
assign USBMUX_OEN_1V2       = GPIO_0_tri_io[6] ;
assign USB_SEL_1V2          = GPIO_0_tri_io[7] ;
assign acc_int2_xl          = GPIO_0_tri_io[8] ;
assign acc_int1_xl          = GPIO_0_tri_io[9] ;
assign gps_pps              = GPIO_0_tri_io[10];
assign BT_UART_CTS          = GPIO_0_tri_io[11];
assign BT_UART_RTS_N        = GPIO_0_tri_io[12];
assign led[0]               = GPIO_0_tri_io[13];
assign led[1]               = GPIO_0_tri_io[14];
assign led[2]               = GPIO_0_tri_io[15];
assign led[3]               = GPIO_0_tri_io[16];
assign acc_cs               = GPIO_0_tri_io[17];
assign acc_magint           = GPIO_0_tri_io[18];
assign TC_OE_3V3            = GPIO_0_tri_io[19];

`else
`endif

wire clk_dclk_o ;
clk_rst_ctr clk_rst_ctr 
(
    .clk40m         (pl_clk_40m         ),
    .sys_clk        (sys_clk            ),
    .sys_rst        (sys_rst            ),
    .ps_clk_100m    (ps_clk_100m        ),
    .clk_300m       (clk_300m           ),
    .clk_dclk_o     (clk_dclk_o         )
);

wire				sir_sel	            ;
wire	[15:0]		sir_addr            ;
wire				sir_read            ;
wire	[31:0]		sir_wdat            ;
wire	[31:0]		sir_rdat            ;
wire				sir_dack            ;

wire                sir_dack00          ;
wire    [31:0]      sir_rdat00          ;
wire                sir_dack01          ;
wire    [31:0]      sir_rdat01          ;
wire                sir_dack02          ;
wire    [31:0]      sir_rdat02          ;
wire                sir_dack03          ;
wire    [31:0]      sir_rdat03          ;

wire    [15:0]      sample_num          ;
wire    [15:0]      chirp_num           ;
wire    [15:0]      PRI_PERIOD          ;
wire    [15:0]      START_SAMPLE        ;
bus_top bus_top
(
   .clk                (ps_clk_100m         ),
   .rst                (sys_rst             ),

   .m_axil_clk         (ps_clk_100m         ),
   .m_axil_rst_n       (pl_rst_n            ),
   .m_axil_awaddr      (m_axi_pl_awaddr[31:0]),
   .m_axil_awvalid     (m_axi_pl_awvalid    ),
   .m_axil_awready     (m_axi_pl_awready    ),

   .m_axil_wdata       (m_axi_pl_wdata      ),
   .m_axil_wstrb       (m_axi_pl_wstrb      ),
   .m_axil_wvalid      (m_axi_pl_wvalid     ),
   .m_axil_wready      (m_axi_pl_wready     ),

   .m_axil_bvalid      (m_axi_pl_bvalid     ),
   .m_axil_bresp       (m_axi_pl_bresp      ),
   .m_axil_bready      (m_axi_pl_bready     ),

   .m_axil_araddr      (m_axi_pl_araddr[31:0]),
   .m_axil_arvalid     (m_axi_pl_arvalid    ),
   .m_axil_arready     (m_axi_pl_arready    ),

   .m_axil_rdata       (m_axi_pl_rdata      ),
   .m_axil_rresp       (m_axi_pl_rresp      ),
   .m_axil_rvalid      (m_axi_pl_rvalid     ),
   .m_axil_rready      (m_axi_pl_rready     ),

   .sir_sel            (sir_sel             ),
   .sir_addr           (sir_addr            ),
   .sir_read           (sir_read            ),
   .sir_wdat           (sir_wdat            ),
   .sir_rdat           (sir_rdat            ),
   .sir_dack           (sir_dack            )
);

per_config per_config 
(
    .rst                    (sys_rst             ),
    .clk_100m               (ps_clk_100m         ),
    .clk_160m               (sys_clk             ),
    .SirAddr                (sir_addr	         ),
    .SirRead                (sir_read            ),
    .SirWdat                (sir_wdat            ),
    .SirSel                 (sir_sel             ),
    .SirDack                (sir_dack00          ),
    .SirRdat                (sir_rdat00          ),

    .lmx2492_mod_o          (lmx2492_mod_o       ),
    .spi_lmx2492_sclk_o     (spi_lmx2492_sclk_o  ),
    .spi_lmx2492_sdata_o    (spi_lmx2492_sdata_o ),
    .spi_lmx2492_sen_o      (spi_lmx2492_sen_o   ),
    .spi_lmx2492_sdata_i    (spi_lmx2492_sdata_i ),
    .pll_ana_ad_p           ('d0                 ),
    .pll_ana_ad_n           ('d0                 ),
    .spi_adc3663_sdio       (spi_adc3663_sdio    ),
    .spi_adc3663_sen_o      (spi_adc3663_sen_o   ),
    .spi_adc3663_sclk_o     (spi_adc3663_sclk_o  ),
    // .spi_adc3663_reset_o    (spi_adc3663_reset_o ),
    .spi_adc3663_pdn_o      (spi_adc3663_pdn_o   ),
    .adc_rst                (adc_rst             ),   

    .spi_chc2442_sdata_i    (spi_chc2442_sdata_i ),
    .spi_chc2442_sdata_o    (spi_chc2442_sdata_o ),
    .spi_chc2442_sen_o      (spi_chc2442_sen_o   ),
    .spi_chc2442_sclk_o     (spi_chc2442_sclk_o  ),
    
    .awmf_sdi_i             (awmf_sdi_i          ),
    .awmf_sdo_o             (awmf_sdo_o          ),
    .awmf_pdo_o             (awmf_pdo_o          ),
    .awmf_ldb_o             (awmf_ldb_o          ),
    .awmf_csb_o             (awmf_csb_o          ),
    .awmf_clk_o             (awmf_clk_o          ),
    .awmf_mode_o            (awmf_mode_o         ),

    .PRI                    (PRI                 ),
    .CPIB                   (CPIB                ),
    .CPIE                   (CPIE                ),
    .sample_gate            (sample_gate         ),
    .PRI_PERIOD             (PRI_PERIOD          ),
    .START_SAMPLE           (START_SAMPLE        ),
    .wr_irp                 (wr_irp              ),
    .rd_irp                 (rd_irp              )
);

wire    [31:0]      s_axis_adc_tdata  ;
wire    [3 :0]      s_axis_adc_tkeep  ;
wire                s_axis_adc_tlast  ;
wire                s_axis_adc_tready ;
wire                s_axis_adc_tvalid ;

wire [31:0]         adc_sli_axis_tdata ;
wire                adc_sli_axis_tvalid;
wire                adc_sli_axis_tlast ;

wire                adc_data_sop_cha   ;
wire                adc_data_eop_cha   ;
wire [15:0]         adc_data_cha       ;
wire                adc_data_valid_cha ;

wire                adc_data_sop_chb   ;
wire                adc_data_eop_chb   ;
wire [15:0]         adc_data_chb       ;
wire                adc_data_valid_chb ;

wire [31:0]         rdmap_log2_data       ;
wire                rdmap_log2_data_valid ;
wire                rdmap_log2_data_last  ;

wire [63:0]         fifo_din_cmd_adc   ;
wire                fifo_wr_en_cmd_adc ;
wire                fifo_full_cmd_adc  ;

wire                fifo_wr_en_wr_adc  ;
wire [127:0]        fifo_din_wr_adc    ;
wire                fifo_full_wr_adc   ;

wire  [63:0]        fifo_din_cmd_rdmap  ;
wire                fifo_wr_en_cmd_rdmap;
wire                fifo_full_cmd_rdmap ;

wire                fifo_wr_en_wr_rdmap ;
wire  [127:0]       fifo_din_wr_rdmap   ;
wire                fifo_full_wr_rdmap  ;


// wire  [63:0]        fifo_din_cmd_mux   ;
// wire                fifo_wr_en_cmd_mux ;
// wire                fifo_full_cmd_mux  ;

// wire                fifo_wr_en_wr_mux  ;
// wire  [127:0]       fifo_din_wr_mux    ;
// wire                fifo_full_wr_mux   ;

wire [63:0]         fifo_din_cmd_pil   ;
wire                fifo_wr_en_cmd_pil ;
wire                fifo_full_cmd_pil  ;

wire [127:0]        fifo_dout_rd_pil   ;
wire                fifo_rd_en_rd_pil  ;
wire                fifo_empty_rd_pil  ;

wire  [63:0]        fifo_din_cmd_rdmapIQ  ;
wire                fifo_wr_en_cmd_rdmapIQ;
wire                fifo_full_cmd_rdmapIQ ;

wire                fifo_wr_en_wr_rdmapIQ ;
wire  [127:0]       fifo_din_wr_rdmapIQ   ;
wire                fifo_full_wr_rdmapIQ  ;

wire  [63:0]        fifo_din_cmd_detection  ;
wire                fifo_wr_en_cmd_detection;
wire                fifo_full_cmd_detection ;

wire                fifo_wr_en_wr_detection ;
wire  [127:0]       fifo_din_wr_detection   ;
wire                fifo_full_wr_detection  ;

adc_rx_top adc_rx_top
(
    .sys_clk                (sys_clk                ),
    .clk_100m               (ps_clk_100m            ),
    .clk_dclk_o             (clk_dclk_o             ),
    .rst                    (sys_rst                ),
    .clk_300m               (clk_300m               ),

    .PRI                    (PRI                    ),
    .CPIB                   (CPIB                   ),
    .CPIE                   (CPIE                   ),
    .sample_gate            (sample_gate            ),

    .sample_num             (sample_num             ),
    .chirp_num              (chirp_num              ),
    .horizontal_pitch       (horizontal_pitch       ),
    .pri_period             (PRI_PERIOD             ),
    .start_sample           (START_SAMPLE           ),

    .SirAddr                (sir_addr	            ),
    .SirRead                (sir_read               ),
    .SirWdat                (sir_wdat               ),
    .SirSel                 (sir_sel                ),
    .SirDack                (sir_dack01             ),
    .SirRdat                (sir_rdat01             ),

    .adc3663_fclk_p         (adc3663_fclk_p         ),
    .adc3663_fclk_n         (adc3663_fclk_n         ),
    .adc3663_dclk_p         (adc3663_dclk_p         ),
    .adc3663_dclk_n         (adc3663_dclk_n         ),

    .adc3663_da0_p          (adc3663_da0_p          ),
    .adc3663_da0_n          (adc3663_da0_n          ),
    .adc3663_da1_p          (adc3663_da1_p          ),
    .adc3663_da1_n          (adc3663_da1_n          ),

    .adc3663_db0_p          (adc3663_db0_p          ),
    .adc3663_db0_n          (adc3663_db0_n          ),
    .adc3663_db1_p          (adc3663_db1_p          ),
    .adc3663_db1_n          (adc3663_db1_n          ),

    .adc3663_dclk_o_p       (adc3663_dclk_o_p       ),
    .adc3663_dclk_o_n       (adc3663_dclk_o_n       ),

    .adc_data_sop_cha_o     (adc_data_sop_cha       ),
    .adc_data_eop_cha_o     (adc_data_eop_cha       ),
    .adc_data_cha_o    	    (adc_data_cha           ),
    .adc_data_valid_cha_o   (adc_data_valid_cha     ),

    .adc_data_sop_chb_o     (adc_data_sop_chb       ),
    .adc_data_eop_chb_o     (adc_data_eop_chb       ),
    .adc_data_chb_o         (adc_data_chb           ),
    .adc_data_valid_chb_o   (adc_data_valid_chb     ),

    .fifo_din_cmd_adc       (fifo_din_cmd_adc       ),
    .fifo_wr_en_cmd_adc     (fifo_wr_en_cmd_adc     ),
    .fifo_full_cmd_adc      (fifo_full_cmd_adc      ),
    
    .fifo_wr_en_wr_adc      (fifo_wr_en_wr_adc      ),
    .fifo_din_wr_adc        (fifo_din_wr_adc        ),
    .fifo_full_wr_adc       (fifo_full_wr_adc       ),

    .fifo_din_cmd_pil       (fifo_din_cmd_pil       ),
    .fifo_wr_en_cmd_pil     (fifo_wr_en_cmd_pil     ),
    .fifo_full_cmd_pil      (fifo_full_cmd_pil      ),

    .fifo_dout_rd_pil       (fifo_dout_rd_pil       ),
    .fifo_rd_en_rd_pil      (fifo_rd_en_rd_pil      ),
    .fifo_empty_rd_pil      (fifo_empty_rd_pil      ),

    .tag_info_o             (tag_info               ),
    .adc_wr_irp             (adc_wr_irp             ),
    .adc_abnormal_irp       (adc_abnormal_irp       ),
    .ps_adc_tx_irq          (ps_adc_tx_irq          )
);

dsp_top   u_dsp_top(

    .clk                    (sys_clk                 ),
	.rst                    (sys_rst                 ),

    .sample_num             (sample_num              ),
    .chirp_num              (chirp_num               ),
    .horizontal_pitch       (horizontal_pitch        ),
// `ifndef SIM
    .i_cpib                 (CPIB                    ),
    .i_cpie                 (CPIE                    ),
    .adc_data_chb_sop       (adc_data_sop_chb        ),
    .adc_data_chb_eop       (adc_data_eop_chb        ),
    .adc_data_chb           (adc_data_chb            ),
    .adc_data_chb_valid     (adc_data_valid_chb      ),

    .adc_data_cha_sop       (adc_data_sop_cha        ),
    .adc_data_cha_eop       (adc_data_eop_cha        ),
    .adc_data_cha           (adc_data_cha            ),
    .adc_data_cha_valid     (adc_data_valid_cha      ),
    .tag_info_i             (tag_info                ),
// `else

// `endif
    .clk_100m               (ps_clk_100m             ),
    .SirAddr                (sir_addr	             ),
    .SirRead                (sir_read                ),
    .SirWdat                (sir_wdat                ),
    .SirSel                 (sir_sel                 ),
    .SirDack                (sir_dack02              ),
    .SirRdat                (sir_rdat02              ),

    .cfar_data_tdata        (cfar_data_tdata         ),
    .cfar_data_valid        (cfar_data_tvalid        ),
    .cfar_data_last         (cfar_data_tlast         ),

    .fifo_din_cmd_rdmap     (fifo_din_cmd_rdmap      ),
    .fifo_wr_en_cmd_rdmap   (fifo_wr_en_cmd_rdmap    ),
    .fifo_full_cmd_rdmap    (fifo_full_cmd_rdmap     ),

    .fifo_wr_en_wr_rdmap    (fifo_wr_en_wr_rdmap     ),
    .fifo_din_wr_rdmap      (fifo_din_wr_rdmap       ),
    .fifo_full_wr_rdmap     (fifo_full_wr_rdmap      ),

    .fifo_din_cmd_rdmapIQ   (fifo_din_cmd_rdmapIQ    ),
    .fifo_wr_en_cmd_rdmapIQ (fifo_wr_en_cmd_rdmapIQ  ),
    .fifo_full_cmd_rdmapIQ  (fifo_full_cmd_rdmapIQ   ),

    .fifo_wr_en_wr_rdmapIQ  (fifo_wr_en_wr_rdmapIQ   ),
    .fifo_din_wr_rdmapIQ    (fifo_din_wr_rdmapIQ     ),
    .fifo_full_wr_rdmapIQ   (fifo_full_wr_rdmapIQ    ),

    .fifo_din_cmd_detection     (fifo_din_cmd_detection  ),
    .fifo_wr_en_cmd_detection   (fifo_wr_en_cmd_detection),
    .fifo_full_cmd_detection    (fifo_full_cmd_detection ),

    .fifo_wr_en_wr_detection    (fifo_wr_en_wr_detection ),
    .fifo_din_wr_detection      (fifo_din_wr_detection   ),
    .fifo_full_wr_detection     (fifo_full_wr_detection  ),

    .rdmap_wr_irq		    (rdmap_wr_irq		     ),
    // .rdmapIQ_wr_irq         (rdmapIQ_wr_irq          ),
    .detection_log_irq      (detection_log_irq       )

);

ddr_top ddr_top
(
    .clk                    (sys_clk                ),
    .rst                    (sys_rst                ),
`ifdef SIM
    .ddr_clk                (ddr_clk                ),
`else
    .ddr_clk                (ps_clk_200m            ),
`endif
    .fifo_din_cmd_ch0       (fifo_din_cmd_adc       ),
    .fifo_wr_en_cmd_ch0     (fifo_wr_en_cmd_adc     ),
    .fifo_full_cmd_ch0      (fifo_full_cmd_adc      ),
    
    .fifo_wr_en_wr_ch0      (fifo_wr_en_wr_adc      ),
    .fifo_din_wr_ch0        (fifo_din_wr_adc        ),
    .fifo_full_wr_ch0       (fifo_full_wr_adc       ),

    .fifo_din_cmd_ch1       (fifo_din_cmd_rdmap     ),
    .fifo_wr_en_cmd_ch1     (fifo_wr_en_cmd_rdmap   ),
    .fifo_full_cmd_ch1      (fifo_full_cmd_rdmap    ),
    
    .fifo_wr_en_wr_ch1      (fifo_wr_en_wr_rdmap    ),
    .fifo_din_wr_ch1        (fifo_din_wr_rdmap      ),
    .fifo_full_wr_ch1       (fifo_full_wr_rdmap     ),

    .fifo_din_cmd_ch2       (fifo_din_cmd_rdmapIQ   ),
    .fifo_wr_en_cmd_ch2     (fifo_wr_en_cmd_rdmapIQ ),
    .fifo_full_cmd_ch2      (fifo_full_cmd_rdmapIQ  ),
    
    .fifo_wr_en_wr_ch2      (fifo_wr_en_wr_rdmapIQ  ),
    .fifo_din_wr_ch2        (fifo_din_wr_rdmapIQ    ),
    .fifo_full_wr_ch2       (fifo_full_wr_rdmapIQ   ),

    .fifo_din_cmd_ch3       (fifo_din_cmd_pil       ),
    .fifo_wr_en_cmd_ch3     (fifo_wr_en_cmd_pil     ),
    .fifo_full_cmd_ch3      (fifo_full_cmd_pil      ),

    .fifo_dout_rd_ch3       (fifo_dout_rd_pil       ),
    .fifo_rd_en_rd_ch3      (fifo_rd_en_rd_pil      ),
    .fifo_empty_rd_ch3      (fifo_empty_rd_pil      ),
    .fifo_full_rd_ch3       (),

    .fifo_din_cmd_ch4       (fifo_din_cmd_detection  ),
    .fifo_wr_en_cmd_ch4     (fifo_wr_en_cmd_detection),
    .fifo_full_cmd_ch4      (fifo_full_cmd_detection ),
    
    .fifo_wr_en_wr_ch4      (fifo_wr_en_wr_detection ),
    .fifo_din_wr_ch4        (fifo_din_wr_detection   ),
    .fifo_full_wr_ch4       (fifo_full_wr_detection  ),

    .m_axi_araddr           (s_axi_ps_ddr_ch0_araddr ),
    .m_axi_arburst          (s_axi_ps_ddr_ch0_arburst),
    .m_axi_arcache          (s_axi_ps_ddr_ch0_arcache),
    .m_axi_arid             (s_axi_ps_ddr_ch0_arid   ),
    .m_axi_arlen            (s_axi_ps_ddr_ch0_arlen  ),
    .m_axi_arlock           (s_axi_ps_ddr_ch0_arlock ),
    .m_axi_arprot           (s_axi_ps_ddr_ch0_arprot ),
    .m_axi_arqos            (s_axi_ps_ddr_ch0_arqos  ),
    .m_axi_arready          (s_axi_ps_ddr_ch0_arready),
    .m_axi_arsize           (s_axi_ps_ddr_ch0_arsize ),
    .m_axi_aruser           (s_axi_ps_ddr_ch0_aruser ),
    .m_axi_arvalid          (s_axi_ps_ddr_ch0_arvalid),

// aw ch 
    .m_axi_awaddr           (s_axi_ps_ddr_ch0_awaddr ),
    .m_axi_awburst          (s_axi_ps_ddr_ch0_awburst),
    .m_axi_awcache          (s_axi_ps_ddr_ch0_awcache),
    .m_axi_awid             (s_axi_ps_ddr_ch0_awid   ),
    .m_axi_awlen            (s_axi_ps_ddr_ch0_awlen  ),
    .m_axi_awlock           (s_axi_ps_ddr_ch0_awlock ),
    .m_axi_awprot           (s_axi_ps_ddr_ch0_awprot ),
    .m_axi_awqos            (s_axi_ps_ddr_ch0_awqos  ),
    .m_axi_awready          (s_axi_ps_ddr_ch0_awready),
    .m_axi_awsize           (s_axi_ps_ddr_ch0_awsize ),
    .m_axi_awuser           (s_axi_ps_ddr_ch0_awuser ),
    .m_axi_awvalid          (s_axi_ps_ddr_ch0_awvalid),

    // response     
    .m_axi_bid              (s_axi_ps_ddr_ch0_bid   ),
    .m_axi_bready           (s_axi_ps_ddr_ch0_bready),
    .m_axi_bresp            (s_axi_ps_ddr_ch0_bresp ),
    .m_axi_bvalid           (s_axi_ps_ddr_ch0_bvalid),

// rd ch 
    .m_axi_rdata            (s_axi_ps_ddr_ch0_rdata ),
    .m_axi_rid              (s_axi_ps_ddr_ch0_rid   ),
    .m_axi_rlast            (s_axi_ps_ddr_ch0_rlast ),
    .m_axi_rready           (s_axi_ps_ddr_ch0_rready),
    .m_axi_rresp            (s_axi_ps_ddr_ch0_rresp ),
    .m_axi_rvalid           (s_axi_ps_ddr_ch0_rvalid),

// wr ch 
    .m_axi_wdata            (s_axi_ps_ddr_ch0_wdata ),
    .m_axi_wlast            (s_axi_ps_ddr_ch0_wlast ),
    .m_axi_wready           (s_axi_ps_ddr_ch0_wready),
    .m_axi_wstrb            (s_axi_ps_ddr_ch0_wstrb ),
    .m_axi_wvalid           (s_axi_ps_ddr_ch0_wvalid)
);
`ifndef SIM 
ddr4_0 ddr4_0
(
    .sys_rst                 (sys_rst               ),
    .c0_sys_clk_p            (sys_clk_p             ),
    .c0_sys_clk_n            (sys_clk_n             ),
    .c0_ddr4_act_n           (ddr4_act_n            ),
    .c0_ddr4_adr             (ddr4_adr              ),
    .c0_ddr4_ba              (ddr4_ba               ),
    .c0_ddr4_bg              (ddr4_bg               ),
    .c0_ddr4_cke             (ddr4_cke              ),
    .c0_ddr4_odt             (ddr4_odt              ),
    .c0_ddr4_cs_n            (ddr4_cs_n             ),
    .c0_ddr4_ck_t            (ddr4_ck_t             ),
    .c0_ddr4_ck_c            (ddr4_ck_c             ),
    .c0_ddr4_reset_n         (ddr4_reset_n          ),
    .c0_ddr4_dm_dbi_n        (ddr4_dm_n             ),
    .c0_ddr4_dq              (ddr4_dq               ),
    .c0_ddr4_dqs_c           (ddr4_dqs_c            ),
    .c0_ddr4_dqs_t           (ddr4_dqs_t            ),

    .c0_init_calib_complete  (                      ),
    .c0_ddr4_ui_clk          (pl_ddr_clk            ),
    .c0_ddr4_ui_clk_sync_rst (                      ),
    .dbg_clk                 (                      ),

    .c0_ddr4_aresetn         (1'b0                  ),
    .c0_ddr4_s_axi_awid      (m_pl_ddr_axi_awid     ),
    .c0_ddr4_s_axi_awaddr    (m_pl_ddr_axi_awaddr   ),
    .c0_ddr4_s_axi_awlen     (m_pl_ddr_axi_awlen    ),
    .c0_ddr4_s_axi_awsize    (m_pl_ddr_axi_awsize   ),
    .c0_ddr4_s_axi_awburst   (m_pl_ddr_axi_awburst  ),
    .c0_ddr4_s_axi_awlock    (m_pl_ddr_axi_awlock   ),
    .c0_ddr4_s_axi_awcache   (m_pl_ddr_axi_awcache  ),
    .c0_ddr4_s_axi_awprot    (m_pl_ddr_axi_awprot   ),
    .c0_ddr4_s_axi_awqos     (m_pl_ddr_axi_awqos    ),
    .c0_ddr4_s_axi_awvalid   (m_pl_ddr_axi_awvalid  ),
    .c0_ddr4_s_axi_awready   (m_pl_ddr_axi_awready  ),
   // Slave Interface Write Data Ports

    .c0_ddr4_s_axi_wdata     (m_pl_ddr_axi_wdata    ),
    .c0_ddr4_s_axi_wstrb     (m_pl_ddr_axi_wstrb    ),
    .c0_ddr4_s_axi_wlast     (m_pl_ddr_axi_wlast    ),
    .c0_ddr4_s_axi_wvalid    (m_pl_ddr_axi_wvalid   ),
    .c0_ddr4_s_axi_wready    (m_pl_ddr_axi_wready   ),

   // Slave Interface Write Response Ports
    .c0_ddr4_s_axi_bready    (m_pl_ddr_axi_bready   ),
    .c0_ddr4_s_axi_bid       (m_pl_ddr_axi_bid      ),
    .c0_ddr4_s_axi_bresp     (m_pl_ddr_axi_bresp    ),
    .c0_ddr4_s_axi_bvalid    (m_pl_ddr_axi_bvalid   ),
   // Slave Interface Read Address Ports
    .c0_ddr4_s_axi_arid      (m_pl_ddr_axi_arid     ),
    .c0_ddr4_s_axi_araddr    (m_pl_ddr_axi_araddr   ),
    .c0_ddr4_s_axi_arlen     (m_pl_ddr_axi_arlen    ),
    .c0_ddr4_s_axi_arsize    (m_pl_ddr_axi_arsize   ),
    .c0_ddr4_s_axi_arburst   (m_pl_ddr_axi_arburst  ),
    .c0_ddr4_s_axi_arlock    (m_pl_ddr_axi_arlock   ),
    .c0_ddr4_s_axi_arcache   (m_pl_ddr_axi_arcache  ),
    .c0_ddr4_s_axi_arprot    (m_pl_ddr_axi_arprot   ),
    .c0_ddr4_s_axi_arqos     (m_pl_ddr_axi_arqos    ),
    .c0_ddr4_s_axi_arvalid   (m_pl_ddr_axi_arvalid  ),
    .c0_ddr4_s_axi_arready   (m_pl_ddr_axi_arready  ),
   // Slave Interface Read Data Ports
    .c0_ddr4_s_axi_rready    (m_pl_ddr_axi_rready   ),
    .c0_ddr4_s_axi_rid       (m_pl_ddr_axi_rid      ),
    .c0_ddr4_s_axi_rdata     (m_pl_ddr_axi_rdata    ),
    .c0_ddr4_s_axi_rresp     (m_pl_ddr_axi_rresp    ),
    .c0_ddr4_s_axi_rlast     (m_pl_ddr_axi_rlast    ),
    .c0_ddr4_s_axi_rvalid    (m_pl_ddr_axi_rvalid   ),

   // Debug Port
    .dbg_bus                 ()
);
`else 
`endif 

`ifdef AI
`ifndef SIM
dpu_bd_top dpu_bd_top
(   
    .DPU0_M_AXI_DATA0_araddr    (DPU0_M_AXI_DATA0_araddr    ),
    .DPU0_M_AXI_DATA0_arburst   (DPU0_M_AXI_DATA0_arburst   ),
    .DPU0_M_AXI_DATA0_arcache   (DPU0_M_AXI_DATA0_arcache   ),
    .DPU0_M_AXI_DATA0_arid      (DPU0_M_AXI_DATA0_arid      ),
    .DPU0_M_AXI_DATA0_arlen     (DPU0_M_AXI_DATA0_arlen     ),
    .DPU0_M_AXI_DATA0_arlock    (DPU0_M_AXI_DATA0_arlock    ),
    .DPU0_M_AXI_DATA0_arprot    (DPU0_M_AXI_DATA0_arprot    ),
    .DPU0_M_AXI_DATA0_arqos     (DPU0_M_AXI_DATA0_arqos     ),
    .DPU0_M_AXI_DATA0_arready   (DPU0_M_AXI_DATA0_arready   ),
    .DPU0_M_AXI_DATA0_arsize    (DPU0_M_AXI_DATA0_arsize    ),
    .DPU0_M_AXI_DATA0_aruser    (DPU0_M_AXI_DATA0_aruser    ),
    .DPU0_M_AXI_DATA0_arvalid   (DPU0_M_AXI_DATA0_arvalid   ),
    .DPU0_M_AXI_DATA0_awaddr    (DPU0_M_AXI_DATA0_awaddr    ),
    .DPU0_M_AXI_DATA0_awburst   (DPU0_M_AXI_DATA0_awburst   ),
    .DPU0_M_AXI_DATA0_awcache   (DPU0_M_AXI_DATA0_awcache   ),
    .DPU0_M_AXI_DATA0_awid      (DPU0_M_AXI_DATA0_awid      ),
    .DPU0_M_AXI_DATA0_awlen     (DPU0_M_AXI_DATA0_awlen     ),
    .DPU0_M_AXI_DATA0_awlock    (DPU0_M_AXI_DATA0_awlock    ),
    .DPU0_M_AXI_DATA0_awprot    (DPU0_M_AXI_DATA0_awprot    ),
    .DPU0_M_AXI_DATA0_awqos     (DPU0_M_AXI_DATA0_awqos     ),
    .DPU0_M_AXI_DATA0_awready   (DPU0_M_AXI_DATA0_awready   ),
    .DPU0_M_AXI_DATA0_awsize    (DPU0_M_AXI_DATA0_awsize    ),
    .DPU0_M_AXI_DATA0_awuser    (DPU0_M_AXI_DATA0_awuser    ),
    .DPU0_M_AXI_DATA0_awvalid   (DPU0_M_AXI_DATA0_awvalid   ),
    .DPU0_M_AXI_DATA0_bid       (DPU0_M_AXI_DATA0_bid       ),
    .DPU0_M_AXI_DATA0_bready    (DPU0_M_AXI_DATA0_bready    ),
    .DPU0_M_AXI_DATA0_bresp     (DPU0_M_AXI_DATA0_bresp     ),
    .DPU0_M_AXI_DATA0_bvalid    (DPU0_M_AXI_DATA0_bvalid    ),
    .DPU0_M_AXI_DATA0_rdata     (DPU0_M_AXI_DATA0_rdata     ),
    .DPU0_M_AXI_DATA0_rid       (DPU0_M_AXI_DATA0_rid       ),
    .DPU0_M_AXI_DATA0_rlast     (DPU0_M_AXI_DATA0_rlast     ),
    .DPU0_M_AXI_DATA0_rready    (DPU0_M_AXI_DATA0_rready    ),
    .DPU0_M_AXI_DATA0_rresp     (DPU0_M_AXI_DATA0_rresp     ),
    .DPU0_M_AXI_DATA0_rvalid    (DPU0_M_AXI_DATA0_rvalid    ),
    .DPU0_M_AXI_DATA0_wdata     (DPU0_M_AXI_DATA0_wdata     ),
    .DPU0_M_AXI_DATA0_wid       (DPU0_M_AXI_DATA0_wid       ),
    .DPU0_M_AXI_DATA0_wlast     (DPU0_M_AXI_DATA0_wlast     ),
    .DPU0_M_AXI_DATA0_wready    (DPU0_M_AXI_DATA0_wready    ),
    .DPU0_M_AXI_DATA0_wstrb     (DPU0_M_AXI_DATA0_wstrb     ),
    .DPU0_M_AXI_DATA0_wvalid    (DPU0_M_AXI_DATA0_wvalid    ),

    .DPU0_M_AXI_DATA1_araddr    (DPU0_M_AXI_DATA1_araddr    ),
    .DPU0_M_AXI_DATA1_arburst   (DPU0_M_AXI_DATA1_arburst   ),
    .DPU0_M_AXI_DATA1_arcache   (DPU0_M_AXI_DATA1_arcache   ),
    .DPU0_M_AXI_DATA1_arid      (DPU0_M_AXI_DATA1_arid      ),
    .DPU0_M_AXI_DATA1_arlen     (DPU0_M_AXI_DATA1_arlen     ),
    .DPU0_M_AXI_DATA1_arlock    (DPU0_M_AXI_DATA1_arlock    ),
    .DPU0_M_AXI_DATA1_arprot    (DPU0_M_AXI_DATA1_arprot    ),
    .DPU0_M_AXI_DATA1_arqos     (DPU0_M_AXI_DATA1_arqos     ),
    .DPU0_M_AXI_DATA1_arready   (DPU0_M_AXI_DATA1_arready   ),
    .DPU0_M_AXI_DATA1_arsize    (DPU0_M_AXI_DATA1_arsize    ),
    .DPU0_M_AXI_DATA1_aruser    (DPU0_M_AXI_DATA1_aruser    ),
    .DPU0_M_AXI_DATA1_arvalid   (DPU0_M_AXI_DATA1_arvalid   ),
    .DPU0_M_AXI_DATA1_awaddr    (DPU0_M_AXI_DATA1_awaddr    ),
    .DPU0_M_AXI_DATA1_awburst   (DPU0_M_AXI_DATA1_awburst   ),
    .DPU0_M_AXI_DATA1_awcache   (DPU0_M_AXI_DATA1_awcache   ),
    .DPU0_M_AXI_DATA1_awid      (DPU0_M_AXI_DATA1_awid      ),
    .DPU0_M_AXI_DATA1_awlen     (DPU0_M_AXI_DATA1_awlen     ),
    .DPU0_M_AXI_DATA1_awlock    (DPU0_M_AXI_DATA1_awlock    ),
    .DPU0_M_AXI_DATA1_awprot    (DPU0_M_AXI_DATA1_awprot    ),
    .DPU0_M_AXI_DATA1_awqos     (DPU0_M_AXI_DATA1_awqos     ),
    .DPU0_M_AXI_DATA1_awready   (DPU0_M_AXI_DATA1_awready   ),
    .DPU0_M_AXI_DATA1_awsize    (DPU0_M_AXI_DATA1_awsize    ),
    .DPU0_M_AXI_DATA1_awuser    (DPU0_M_AXI_DATA1_awuser    ),
    .DPU0_M_AXI_DATA1_awvalid   (DPU0_M_AXI_DATA1_awvalid   ),
    .DPU0_M_AXI_DATA1_bid       (DPU0_M_AXI_DATA1_bid       ),
    .DPU0_M_AXI_DATA1_bready    (DPU0_M_AXI_DATA1_bready    ),
    .DPU0_M_AXI_DATA1_bresp     (DPU0_M_AXI_DATA1_bresp     ),
    .DPU0_M_AXI_DATA1_bvalid    (DPU0_M_AXI_DATA1_bvalid    ),
    .DPU0_M_AXI_DATA1_rdata     (DPU0_M_AXI_DATA1_rdata     ),
    .DPU0_M_AXI_DATA1_rid       (DPU0_M_AXI_DATA1_rid       ),
    .DPU0_M_AXI_DATA1_rlast     (DPU0_M_AXI_DATA1_rlast     ),
    .DPU0_M_AXI_DATA1_rready    (DPU0_M_AXI_DATA1_rready    ),
    .DPU0_M_AXI_DATA1_rresp     (DPU0_M_AXI_DATA1_rresp     ),
    .DPU0_M_AXI_DATA1_rvalid    (DPU0_M_AXI_DATA1_rvalid    ),
    .DPU0_M_AXI_DATA1_wdata     (DPU0_M_AXI_DATA1_wdata     ),
    .DPU0_M_AXI_DATA1_wid       (DPU0_M_AXI_DATA1_wid       ),
    .DPU0_M_AXI_DATA1_wlast     (DPU0_M_AXI_DATA1_wlast     ),
    .DPU0_M_AXI_DATA1_wready    (DPU0_M_AXI_DATA1_wready    ),
    .DPU0_M_AXI_DATA1_wstrb     (DPU0_M_AXI_DATA1_wstrb     ),
    .DPU0_M_AXI_DATA1_wvalid    (DPU0_M_AXI_DATA1_wvalid    ),

    .DPU0_M_AXI_INSTR_araddr    (DPU0_M_AXI_INSTR_araddr    ),
    .DPU0_M_AXI_INSTR_arburst   (DPU0_M_AXI_INSTR_arburst   ),
    .DPU0_M_AXI_INSTR_arcache   (DPU0_M_AXI_INSTR_arcache   ),
    .DPU0_M_AXI_INSTR_arid      (DPU0_M_AXI_INSTR_arid      ),
    .DPU0_M_AXI_INSTR_arlen     (DPU0_M_AXI_INSTR_arlen     ),
    .DPU0_M_AXI_INSTR_arlock    (DPU0_M_AXI_INSTR_arlock    ),
    .DPU0_M_AXI_INSTR_arprot    (DPU0_M_AXI_INSTR_arprot    ),
    .DPU0_M_AXI_INSTR_arqos     (DPU0_M_AXI_INSTR_arqos     ),
    .DPU0_M_AXI_INSTR_arready   (DPU0_M_AXI_INSTR_arready   ),
    .DPU0_M_AXI_INSTR_arsize    (DPU0_M_AXI_INSTR_arsize    ),
    .DPU0_M_AXI_INSTR_aruser    (DPU0_M_AXI_INSTR_aruser    ),
    .DPU0_M_AXI_INSTR_arvalid   (DPU0_M_AXI_INSTR_arvalid   ),
    .DPU0_M_AXI_INSTR_awaddr    (DPU0_M_AXI_INSTR_awaddr    ),
    .DPU0_M_AXI_INSTR_awburst   (DPU0_M_AXI_INSTR_awburst   ),
    .DPU0_M_AXI_INSTR_awcache   (DPU0_M_AXI_INSTR_awcache   ),
    .DPU0_M_AXI_INSTR_awid      (DPU0_M_AXI_INSTR_awid      ),
    .DPU0_M_AXI_INSTR_awlen     (DPU0_M_AXI_INSTR_awlen     ),
    .DPU0_M_AXI_INSTR_awlock    (DPU0_M_AXI_INSTR_awlock    ),
    .DPU0_M_AXI_INSTR_awprot    (DPU0_M_AXI_INSTR_awprot    ),
    .DPU0_M_AXI_INSTR_awqos     (DPU0_M_AXI_INSTR_awqos     ),
    .DPU0_M_AXI_INSTR_awready   (DPU0_M_AXI_INSTR_awready   ),
    .DPU0_M_AXI_INSTR_awsize    (DPU0_M_AXI_INSTR_awsize    ),
    .DPU0_M_AXI_INSTR_awuser    (DPU0_M_AXI_INSTR_awuser    ),
    .DPU0_M_AXI_INSTR_awvalid   (DPU0_M_AXI_INSTR_awvalid   ),
    .DPU0_M_AXI_INSTR_bid       (DPU0_M_AXI_INSTR_bid       ),
    .DPU0_M_AXI_INSTR_bready    (DPU0_M_AXI_INSTR_bready    ),
    .DPU0_M_AXI_INSTR_bresp     (DPU0_M_AXI_INSTR_bresp     ),
    .DPU0_M_AXI_INSTR_bvalid    (DPU0_M_AXI_INSTR_bvalid    ),
    .DPU0_M_AXI_INSTR_rdata     (DPU0_M_AXI_INSTR_rdata     ),
    .DPU0_M_AXI_INSTR_rid       (DPU0_M_AXI_INSTR_rid       ),
    .DPU0_M_AXI_INSTR_rlast     (DPU0_M_AXI_INSTR_rlast     ),
    .DPU0_M_AXI_INSTR_rready    (DPU0_M_AXI_INSTR_rready    ),
    .DPU0_M_AXI_INSTR_rresp     (DPU0_M_AXI_INSTR_rresp     ),
    .DPU0_M_AXI_INSTR_rvalid    (DPU0_M_AXI_INSTR_rvalid    ),
    .DPU0_M_AXI_INSTR_wdata     (DPU0_M_AXI_INSTR_wdata     ),
    .DPU0_M_AXI_INSTR_wid       (DPU0_M_AXI_INSTR_wid       ),
    .DPU0_M_AXI_INSTR_wlast     (DPU0_M_AXI_INSTR_wlast     ),
    .DPU0_M_AXI_INSTR_wready    (DPU0_M_AXI_INSTR_wready    ),
    .DPU0_M_AXI_INSTR_wstrb     (DPU0_M_AXI_INSTR_wstrb     ),
    .DPU0_M_AXI_INSTR_wvalid    (DPU0_M_AXI_INSTR_wvalid    ),

    .dpu0_interrupt             (dpu_irp                    ),
    .dpu_2x_clk                 (clk_ai_500m                ),
    .dpu_2x_resetn              (pl_rst_n                   ),
    .m_axi_dpu_aclk             (clk_ai_250m                ),
    .m_axi_dpu_aresetn          (pl_rst_n                   ),

    .s_axi_aclk_dpu             (s_axi_aclk_dpu             ),
    .s_axi_aresetn_dpu          (s_axi_aresetn_dpu          ),
    .s_axi_dpu_araddr           (s_axi_dpu_araddr           ),
    .s_axi_dpu_arburst          (s_axi_dpu_arburst          ),
    .s_axi_dpu_arcache          (s_axi_dpu_arcache          ),
    .s_axi_dpu_arid             (s_axi_dpu_arid             ),
    .s_axi_dpu_arlen            (s_axi_dpu_arlen            ),
    .s_axi_dpu_arlock           (s_axi_dpu_arlock           ),
    .s_axi_dpu_arprot           (s_axi_dpu_arprot           ),
    .s_axi_dpu_arqos            (s_axi_dpu_arqos            ),
    .s_axi_dpu_arready          (s_axi_dpu_arready          ),
    .s_axi_dpu_arregion         (s_axi_dpu_arregion         ),
    .s_axi_dpu_arsize           (s_axi_dpu_arsize           ),
    .s_axi_dpu_aruser           (s_axi_dpu_aruser           ),
    .s_axi_dpu_arvalid          (s_axi_dpu_arvalid          ),
    .s_axi_dpu_awaddr           (s_axi_dpu_awaddr           ),
    .s_axi_dpu_awburst          (s_axi_dpu_awburst          ),
    .s_axi_dpu_awcache          (s_axi_dpu_awcache          ),
    .s_axi_dpu_awid             (s_axi_dpu_awid             ),
    .s_axi_dpu_awlen            (s_axi_dpu_awlen            ),
    .s_axi_dpu_awlock           (s_axi_dpu_awlock           ),
    .s_axi_dpu_awprot           (s_axi_dpu_awprot           ),
    .s_axi_dpu_awqos            (s_axi_dpu_awqos            ),
    .s_axi_dpu_awready          (s_axi_dpu_awready          ),
    .s_axi_dpu_awregion         (s_axi_dpu_awregion         ),
    .s_axi_dpu_awsize           (s_axi_dpu_awsize           ),
    .s_axi_dpu_awuser           (s_axi_dpu_awuser           ),
    .s_axi_dpu_awvalid          (s_axi_dpu_awvalid          ),
    .s_axi_dpu_bid              (s_axi_dpu_bid              ),
    .s_axi_dpu_bready           (s_axi_dpu_bready           ),
    .s_axi_dpu_bresp            (s_axi_dpu_bresp            ),
    .s_axi_dpu_bvalid           (s_axi_dpu_bvalid           ),
    .s_axi_dpu_rdata            (s_axi_dpu_rdata            ),
    .s_axi_dpu_rid              (s_axi_dpu_rid              ),
    .s_axi_dpu_rlast            (s_axi_dpu_rlast            ),
    .s_axi_dpu_rready           (s_axi_dpu_rready           ),
    .s_axi_dpu_rresp            (s_axi_dpu_rresp            ),
    .s_axi_dpu_rvalid           (s_axi_dpu_rvalid           ),
    .s_axi_dpu_wdata            (s_axi_dpu_wdata            ),
    .s_axi_dpu_wid              (s_axi_dpu_wid              ),
    .s_axi_dpu_wlast            (s_axi_dpu_wlast            ),
    .s_axi_dpu_wready           (s_axi_dpu_wready           ),
    .s_axi_dpu_wstrb            (s_axi_dpu_wstrb            ),
    .s_axi_dpu_wvalid           (s_axi_dpu_wvalid           )
);
`else
`endif
`else
`endif

assign sir_rdat         = sir_rdat00 | sir_rdat01 |  sir_rdat02 | sir_rdat03 ;
assign sir_dack         = sir_dack00 | sir_dack01 |  sir_dack02 | sir_dack03 ;

// assign PL_DDR_PAR = 'd0 ;
// assign PL_DDR_TEN = 'd0 ;
// assign PL_DDR_ALERT_N = 'd0 ;
endmodule

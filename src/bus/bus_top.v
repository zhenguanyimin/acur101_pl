module bus_top (
        	input	wire				rst			    ,
		    input	wire				clk			    ,
            input   wire                m_axil_clk      ,
            input   wire                m_axil_rst_n    ,
//-- AXI Master Write Address Channel           
            input	wire [31:0] 		m_axil_awaddr   ,                     
            input 	wire				m_axil_awvalid  ,          
            output	wire				m_axil_awready  ,          
     	                                               
//-- AXI Master Write Data Channel             
            input	wire [31:0] 	    m_axil_wdata    ,         
            input	wire [3:0]  	    m_axil_wstrb    ,         
            input	wire 			    m_axil_wvalid   ,         
            output	wire 			    m_axil_wready   ,         
//-- AXI Master Write Response Channel      	   
            output	wire 		        m_axil_bvalid   ,
            output	wire [1:0]          m_axil_bresp    ,       
            input	wire 		        m_axil_bready   ,   
     	                                            	
//-- AXI Master Read Address Channel        	   
            input 	wire[31:0] 		    m_axil_araddr   ,                    
            input 	wire			    m_axil_arvalid  ,          
            output  wire	            m_axil_arready  ,
//-- AXI Master Read Data Channel           	   
            output	wire [31:0] 	    m_axil_rdata    ,
            output  wire [1:0]          m_axil_rresp    ,
            output  wire			    m_axil_rvalid   ,
            input	wire 			    m_axil_rready   ,
     
//csr interface				
            output	wire			    sir_sel		    ,
            output	wire	[15:0]	    sir_addr	    ,
            output	wire		        sir_read	    ,
            output	wire	[31:0]	    sir_wdat	    ,
            input	wire	[31:0]	    sir_rdat	    ,
            input	wire			    sir_dack		

);


        wire [31:0]     s_axil_awaddr    	;
        wire		    s_axil_awvalid   	;
        wire		    s_axil_awready   	;
        wire [31:0]     s_axil_wdata     	;
        wire [3 :0]     s_axil_wstrb     	;
        wire 		    s_axil_wvalid    	;
        wire 		    s_axil_wready    	;
        wire 		    s_axil_bvalid    	;
        wire [1 :0]  	s_axil_bresp     	;
        wire 		    s_axil_bready    	;
        wire [31:0] 	s_axil_araddr    	;
        wire		    s_axil_arvalid   	;
        wire	        s_axil_arready   	;
        wire [31:0] 	s_axil_rdata     	;
        wire [1 :0]  	s_axil_rresp     	;
        wire		    s_axil_rvalid    	;
        wire 		    s_axil_rready    	;

axi_interconnect axi_interconnect_wrapper
(
    .ACLK               (clk            ),
    .ARESETN            (~rst           ),
    
    .M00_ACLK           (clk            ),
    .M00_ARESETN        (~rst           ),

    .M00_AXI_araddr     (s_axil_araddr  ),
    .M00_AXI_arprot     (               ),
    .M00_AXI_arready    (s_axil_arready ),
    .M00_AXI_arvalid    (s_axil_arvalid ),
    .M00_AXI_awaddr     (s_axil_awaddr  ),
    .M00_AXI_awprot     (               ),
    .M00_AXI_awready    (s_axil_awready ),
    .M00_AXI_awvalid    (s_axil_awvalid ),
    .M00_AXI_bready     (s_axil_bready  ),
    .M00_AXI_bresp      (s_axil_bresp   ),
    .M00_AXI_bvalid     (s_axil_bvalid  ),
    .M00_AXI_rdata      (s_axil_rdata   ),
    .M00_AXI_rready     (s_axil_rready  ),
    .M00_AXI_rresp      (s_axil_rresp   ),
    .M00_AXI_rvalid     (s_axil_rvalid  ),
    .M00_AXI_wdata      (s_axil_wdata   ),
    .M00_AXI_wready     (s_axil_wready  ),
    .M00_AXI_wstrb      (s_axil_wstrb   ),
    .M00_AXI_wvalid     (s_axil_wvalid  ),

    .M01_AXI_araddr     (               ),
    .M01_AXI_arprot     (               ),
    .M01_AXI_arready    (1'b1           ),
    .M01_AXI_arvalid    (               ),
    .M01_AXI_awaddr     (               ),
    .M01_AXI_awprot     (               ),
    .M01_AXI_awready    (1'b1           ),
    .M01_AXI_awvalid    (               ),
    .M01_AXI_bready     (               ),
    .M01_AXI_bresp      ('d0            ),
    .M01_AXI_bvalid     (1'b1           ),
    .M01_AXI_rdata      (32'hffff_ffff  ),
    .M01_AXI_rready     (               ),
    .M01_AXI_rresp      ('d0            ),
    .M01_AXI_rvalid     (1'b1           ),
    .M01_AXI_wdata      (               ),
    .M01_AXI_wready     (1'b1           ),
    .M01_AXI_wstrb      (               ),
    .M01_AXI_wvalid     (               ),

    .S00_ACLK           (m_axil_clk     ),
    .S00_ARESETN        (m_axil_rst_n   ),
    .S00_AXI_araddr     (m_axil_araddr  ),
    .S00_AXI_arprot     ('d0            ),
    .S00_AXI_arready    (m_axil_arready ),
    .S00_AXI_arvalid    (m_axil_arvalid ),
    .S00_AXI_awaddr     (m_axil_awaddr  ),
    .S00_AXI_awprot     ('d0            ),
    .S00_AXI_awready    (m_axil_awready ),
    .S00_AXI_awvalid    (m_axil_awvalid ),
    .S00_AXI_bready     (m_axil_bready  ),
    .S00_AXI_bresp      (m_axil_bresp   ),
    .S00_AXI_bvalid     (m_axil_bvalid  ),
    .S00_AXI_rdata      (m_axil_rdata   ),
    .S00_AXI_rready     (m_axil_rready  ),
    .S00_AXI_rresp      (m_axil_rresp   ),
    .S00_AXI_rvalid     (m_axil_rvalid  ),
    .S00_AXI_wdata      (m_axil_wdata   ),
    .S00_AXI_wready     (m_axil_wready  ),
    .S00_AXI_wstrb      (m_axil_wstrb   ),
    .S00_AXI_wvalid     (m_axil_wvalid  )
);

csr_pro csr_pro
(
    .rst	        (rst            ),
    .clk	        (clk            ),

    .pcie_link_up   (1'b1           ),

    .m_axil_awaddr  (s_axil_awaddr  ),
    .m_axil_awvalid (s_axil_awvalid ),
    .m_axil_awready (s_axil_awready ),

    .m_axil_wdata   (s_axil_wdata   ),
    .m_axil_wstrb   (s_axil_wstrb   ),
    .m_axil_wvalid  (s_axil_wvalid  ),
    .m_axil_wready  (s_axil_wready  ),

    .m_axil_bvalid  (s_axil_bvalid  ),
    .m_axil_bresp   (s_axil_bresp   ),
    .m_axil_bready  (s_axil_bready  ),

    .m_axil_araddr  (s_axil_araddr  ),
    .m_axil_arvalid (s_axil_arvalid ),
    .m_axil_arready (s_axil_arready ),

    .m_axil_rdata   (s_axil_rdata   ),
    .m_axil_rresp   (s_axil_rresp   ),
    .m_axil_rvalid  (s_axil_rvalid  ),
    .m_axil_rready  (s_axil_rready  ),

    .sir_sel	    (sir_sel        ),
    .sir_addr	    (sir_addr       ),
    .sir_read	    (sir_read       ),
    .sir_wdat	    (sir_wdat       ),
    .sir_rdat	    (sir_rdat       ),
    .sir_dack	    (sir_dack       )
);
    
endmodule
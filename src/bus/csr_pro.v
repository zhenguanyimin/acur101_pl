module csr_pro	(
		input	wire				rst					,
		input	wire				clk					,					
		input	wire				pcie_link_up	    ,
					
//-- AXI Master Write Address Channel           
     	input	wire [31:0] 		m_axil_awaddr    	,                     
     	input 	wire				m_axil_awvalid   	,          
     	output	reg	 				m_axil_awready   	,          
     	                                               
//-- AXI Master Write Data Channel             
     	input	wire [31:0] 		m_axil_wdata     	,         
     	input	wire [3:0]  		m_axil_wstrb     	,         
     	input	wire 				m_axil_wvalid    	,         
     	output	reg 				m_axil_wready    	,         
//-- AXI Master Write Response Channel      	   
     	output	reg 				m_axil_bvalid    	,
     	output	reg [1:0]  			m_axil_bresp     	,       
     	input	wire 				m_axil_bready    	,   
     	                                            	
//-- AXI Master Read Address Channel        	   
     	input 	wire[31:0] 			m_axil_araddr    	,                    
     	input 	wire				m_axil_arvalid   	,          
     	output  reg					m_axil_arready   	,          
//-- AXI Master Read Data Channel           	   
     	output	reg [31:0] 			m_axil_rdata     	,         
     	output  reg	[1:0]  			m_axil_rresp     	,         
     	output  reg					m_axil_rvalid    	,         
     	input	wire 				m_axil_rready    	,     
     
//csr interface
					
	 	output	wire				sir_sel				,
	 	output	wire	[31:0]		sir_addr			,
	 	output	wire				sir_read			,
	 	output	wire	[31:0]		sir_wdat			,
	 	input	wire	[31:0]		sir_rdat			,
	 	input	wire				sir_dack		

             );




parameter		PCIE_INIT	= 7'b0000001	;
parameter		PCIE_IDLE	= 7'b0000010	;
parameter       PCIE_WR_T   = 7'b0000100	;
parameter		PCIE_WR		= 7'b0001000	;
parameter       PCIE_RD_T   = 7'b0010000	;
parameter		PCIE_RD		= 7'b0100000	;
parameter		PCIE_DLY	= 7'b1000000	;

reg		[6:0]		pcie_state			;

reg					sir_sel1		;
reg		[31:0]		sir_addr1		;
reg					sir_read1		;
reg		[31:0]		sir_wdat1		;

wire	[31:0]		sir_rdat1;

//assign sir_rdat1 = {sir_rdat[7:0],sir_rdat[15:8],sir_rdat[23:16],sir_rdat[31:24]};
assign sir_rdat1 = sir_rdat;


reg		[7:0]		sir_rd_cnt	;
reg		[7:0]		sir_wr_cnt;

always @(posedge clk)
begin
	if(rst == 1'b1)
		sir_rd_cnt <=  8'd0;
	else if(pcie_state == PCIE_RD)
		if(sir_rd_cnt == 8'h0c)
			sir_rd_cnt <=  sir_rd_cnt;
		else
			sir_rd_cnt <=  sir_rd_cnt + 1'b1;
	else
		sir_rd_cnt <=  8'd0;
end


always @ (posedge clk) 
begin
    if(rst==1'b1)
 	    sir_wr_cnt	<=  8'h0;
    else if(pcie_state == PCIE_WR)
        if(sir_wr_cnt == 8'h0c)
            sir_wr_cnt <=  sir_wr_cnt;
        else 
            sir_wr_cnt <=  sir_wr_cnt + 1'b1;
    else 
        sir_wr_cnt <=  8'h0;
end

reg        pcie_link_up_r1;
reg        pcie_link_up_r2;

always @ (posedge clk)
begin
   pcie_link_up_r1 <= pcie_link_up;
   pcie_link_up_r2 <= pcie_link_up_r1;
end


always @(posedge clk)
begin
	if(rst==1'b1)
		begin
		pcie_state 		<=  PCIE_INIT;
		sir_sel1		<=  'b0;
		sir_addr1		<=  'b0;
		sir_read1		<=  'b0;
		sir_wdat1		<=  'b0;
		m_axil_bresp	<=  'b0;
		m_axil_awready	<=  'b0;
		m_axil_wready	<=  'b0;
		m_axil_bvalid	<=  'b0;
		m_axil_arready	<=  'b0;
		m_axil_rvalid	<=  'b0;
		m_axil_rdata	<=  'b0;
		m_axil_rresp	<=  2'b0;
		end	
	else
		case(pcie_state)
			PCIE_INIT :
				begin
				if(pcie_link_up_r2==1'b1)
					begin
					pcie_state 		<=  PCIE_IDLE;
					
					m_axil_awready	<=  1'b0;
					m_axil_wready	<=  1'b0;
					m_axil_arready 	<=  1'b0;
					end
				else
					begin
					pcie_state	<=  pcie_state;
					
					m_axil_awready	<=  1'b0;
					m_axil_wready	<=  1'b0;
					m_axil_arready 	<=  1'b0;
					end
				end
				
			PCIE_IDLE :
				begin
				if(m_axil_awvalid == 1'b1)					
					begin
					pcie_state	<=  PCIE_WR_T;
					
					sir_addr1		<=  m_axil_awaddr ;
					m_axil_awready	<=  1'b1;
					m_axil_wready	<=  1'b1;
					m_axil_arready 	<=  1'b0;
					end
				else if (m_axil_arvalid == 1'b1 )
					begin
					pcie_state	<=  PCIE_RD_T;
					
					sir_addr1		<=  m_axil_araddr ;
					m_axil_awready	<=  1'b0;
					m_axil_wready	<=  1'b0;
					m_axil_arready 	<=  1'b1;
					end
			    else
			        begin
					pcie_state	<=  pcie_state;
					
					m_axil_awready	<=  1'b0;
					m_axil_wready	<=  1'b0;
					m_axil_arready 	<=  1'b0;
					end	
			    end				
										
		    PCIE_WR_T   :
		        begin				
				if(m_axil_wvalid == 1'b1 )
					begin
					pcie_state 		<=  PCIE_WR;
					
					m_axil_awready	<=  1'b0;
					m_axil_wready	<=  1'b0;
					m_axil_arready 	<=  1'b0;
					sir_sel1		<=  1'b1;
					sir_wdat1		<=  m_axil_wdata;
					sir_read1		<=  1'b0;
					end
				else
				    begin
					pcie_state	<=  PCIE_WR_T;
					
					sir_addr1		<=  m_axil_awaddr ;
					m_axil_awready	<=  1'b1;
					m_axil_wready	<=  1'b1;
					m_axil_arready 	<=  1'b0;
					end	
			    end

			PCIE_RD_T :		
				begin	
				pcie_state 		<=  PCIE_RD;
				
				m_axil_awready	<=  1'b0;
				m_axil_wready	<=  1'b0;
				m_axil_arready 	<=  1'b0;		
				sir_addr1		<=  m_axil_araddr ;
				sir_sel1		<=  1'b1;
				sir_read1		<=  1'b1;
				end
					
			PCIE_WR :
				begin
                 if(sir_wr_cnt == 8'h0c)begin
                       m_axil_bvalid	<=  1'b1;
                 end
                 else begin
                       m_axil_bvalid	<=  m_axil_bvalid; 
                 end
                 
                 
                    if( m_axil_bready == 1'b1 && m_axil_bvalid)
					    begin
					    pcie_state 		<=  PCIE_DLY;
					    sir_sel1 		<=  1'b0;
						m_axil_bresp	<=  2'b0;
					    end
				    else ;	
				end
			PCIE_RD :
				// begin
				// m_axil_rvalid 	<=  1'b1;							
				// m_axil_rresp	<=  2'b0;
				// m_axil_rdata	<=  sir_rdat1 ;

                // if(sir_rd_cnt == 8'h0c && m_axil_rready == 1'b1 && m_axil_rvalid == 1'b1 ) 
				// 	begin 
				// 		pcie_state 		<=  PCIE_DLY;
				// 		sir_sel1 		<=  1'b0;
				// 	end
				// else
				// 	begin 
				// 		pcie_state 		<=  PCIE_RD ;
				// 		sir_sel1 		<=  1'b1;	
				// 	end

				// end
			begin
                if(sir_rd_cnt == 8'h0c && m_axil_rready == 1'b1 ) 
					    begin
					    pcie_state 		<=  PCIE_DLY;
					    
					    sir_sel1 		<=  1'b0;							
						m_axil_rvalid 	<=  1'b1;
						m_axil_rresp	<=  2'b0;
						m_axil_rdata	<=  sir_rdat1 ;
					    end
					else ;  
				end
			PCIE_DLY :
				begin
				pcie_state 		<=  PCIE_IDLE;
				
				sir_addr1		<=  32'b0; 
				sir_wdat1		<=  32'b0;
				sir_read1		<=  1'b0;
				m_axil_bvalid	<=  1'b0;
				m_axil_rvalid 	<=  1'b0;
				end
			
			default:
			    begin
				pcie_state 		<=  PCIE_IDLE;
				
				m_axil_awready	<=  1'b0;
				m_axil_wready	<=  1'b0;
				m_axil_arready 	<=  1'b0;
				end
		endcase
			
end



assign	sir_sel =  sir_sel1 ;
assign	sir_addr = sir_addr1 ;
assign	sir_read = sir_read1 ;
//assign	sir_wdat = {sir_wdat1[7:0],sir_wdat1[15:8],sir_wdat1[23:16],sir_wdat1[31:24]} ;
assign	sir_wdat = sir_wdat1;

endmodule
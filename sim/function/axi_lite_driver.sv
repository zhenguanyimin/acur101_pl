wire            axil_clk        ;

reg [31 : 0]    m_axil_awaddr   ;
reg [2 : 0]     m_axil_awprot   ;
reg             m_axil_awvalid  ;
wire            m_axil_awready  ;
                                
reg [31 : 0]    m_axil_wdata    ;
reg [3 : 0]     m_axil_wstrb    ;
reg             m_axil_wvalid   ;
wire            m_axil_wready   ;
                               
wire            m_axil_bvalid   ;
wire[1 : 0]     m_axil_bresp    ;
reg             m_axil_bready   ;
                               
reg [31 : 0]    m_axil_araddr   ;
reg [2 : 0]     m_axil_arprot   ;
reg             m_axil_arvalid  ;
wire            m_axil_arready  ;
                                
wire [31 : 0]   m_axil_rdata    ;
wire [1 : 0]    m_axil_rresp    ;
wire            m_axil_rvalid   ;
reg             m_axil_rready   ;
   
integer print_axi_lite_wdata_file;
integer print_axi_lite_rdata_file;
   

   
task axil_init;
    
   m_axil_awaddr    =   32'h0000_0000;
   m_axil_awprot    =   3'b010;
   m_axil_awvalid   =   1'b0;
 
   m_axil_wdata     =   32'd0;
   m_axil_wstrb     =   4'b0000;
   m_axil_wvalid    =   1'b0;

   m_axil_bready    =   1'b0;

   m_axil_araddr    =   32'h0000_0000;
   m_axil_arprot    =   3'b010;
   m_axil_arvalid   =   1'b0;

   m_axil_rready    =   1'b0;
 

   print_axi_lite_wdata_file = $fopen("print_files/lite_wdata.txt","w");
   print_axi_lite_rdata_file = $fopen("print_files/lite_rdata.txt","w");


endtask :   axil_init



task    set_register;
    
    input bit[31:0] axil_awaddr   ;
    input bit[31:0] axil_wdata    ;
    input bit[3:0]  axil_wstrb    ;
    
    // axil_awaddr   =   `axil_awaddr;
    // axil_wdata    =   `axil_wdata;
    // axil_wstrb    =   `axil_wstrb;

    
    // $display("print_axi_lite_wdata_file");
    // print_axi_lite_wdata_file = $fopen("print_files/lite_wdata_input/lite_wdata.txt","w");
    $fwrite (print_axi_lite_wdata_file," \n \n \n This register address is %h\n",axil_awaddr);
    
    fork
        begin
            @(posedge axil_clk);
            m_axil_awaddr   =   axil_awaddr;
            m_axil_awvalid  =   1'b1;
            @(posedge axil_clk);
            wait(m_axil_awready);
            @(posedge axil_clk);    
            m_axil_awvalid  =   1'b0;
        end 
    
        begin
            @(posedge axil_clk);
            m_axil_wdata    =   axil_wdata;
            m_axil_wstrb    =   axil_wstrb;
            $fwrite (print_axi_lite_wdata_file," This register axil_wdata is %h        axil_wstrb is %b\n",axil_wdata,axil_wstrb);
            m_axil_wvalid   =   1;
            m_axil_bready   =   1;
            wait(m_axil_wready);
            @(posedge axil_clk);
            m_axil_wvalid   =   0;
            m_axil_wstrb    =   0;
            

            wait(m_axil_bvalid);
            @(posedge axil_clk);
            m_axil_bready   =   0;
        end 
    join

endtask :   set_register




task read_register;
    
    input bit  [31:0]     axil_araddr;
    
    output bit [31:0]      axil_rdata;
    
    // axil_araddr     =   `axil_araddr;
    
    // $display("print_axi_lite_rdata_file");
    // print_axi_lite_rdata_file = $fopen("print_files/lite_rdata_output/lite_rdata.txt","w");
    $fwrite (print_axi_lite_rdata_file," \n \n \n This register address is %h\n",axil_araddr);
    
    fork
        begin
            @(posedge axil_clk);
            m_axil_araddr   =   axil_araddr;
            m_axil_arvalid  =   1'b1;
            @(posedge axil_clk);
            wait(m_axil_arready);
            @(posedge axil_clk);
            m_axil_arvalid  =   1'b0;
            @(posedge axil_clk);
        end
        
        begin
            @(posedge axil_clk);
            m_axil_rready   =   1;
            @(posedge axil_clk);
            wait(m_axil_rvalid);
            @(posedge axil_clk);
            axil_rdata      =   m_axil_rdata;
            m_axil_rready   =   0;

            $fwrite (print_axi_lite_rdata_file," This register axil_rdata is %h\n",axil_rdata);
        end
    join
    
endtask :   read_register


module lmx2492_ctr_top
(
//-----------------------------------------------------------------
    input	wire            rst                 ,
    input	wire            clk                 ,
    input   wire            clk_10m             ,
//-----------------------------------------------------------------

    input   wire            write_data_valid    ,
    input   wire [23:0]     write_data_in       ,
    input   wire [7:0]      lmx2492_batch_wr    ,
    input   wire [3:0]      lmx2492_batch_rd    ,
//-----------------------------------------------------------------
    output  wire [22:0]     reg0	            ,
    output  wire [22:0]     reg1	            ,
    output  wire [22:0]     reg2	            ,
    output  wire [22:0]     reg3	            ,
    output  wire [22:0]     reg4	            ,
    output  wire [22:0]     reg5	            ,
    output  wire [22:0]     reg6	            ,
    output  wire [22:0]     reg7	            ,
    output  wire [22:0]     reg8	            ,
    output  wire [22:0]     reg9	            ,
    output  wire            irp                 ,
//-----------------------------------------------------------------
    output  wire            spi_lmx2492_sclk_o  ,
    output  wire            spi_lmx2492_sdata_o ,	 
    output  wire            spi_lmx2492_sen_o   ,									    
    input   wire            spi_lmx2492_sdata_i 
      

);

wire            spi_rw_flag         ;
wire            spi_config          ;
wire            lmxdata_fifo_empty  ;
wire            spi_wr_ack_o        ;
wire            spi_rd_ack_o        ;

wire [14:0]     spi_paddr_o         ;
wire [7 :0]     spi_pdata_o         ;

wire [7 :0]     spi_wdata_cnt_o     ;
wire [3 :0]     spi_rdata_cnt_o     ;
wire [24:0]     read_data_o         ;

lmx2492_write_data_buffer lmx2492_write_data_buffer
(
    .sys_rst                (rst                ),        
    .write_clk              (clk                ), 

    .write_data_en          (write_data_valid   ),        
    .write_data_in          (write_data_in      ),

    .read_clk               (clk_10m            ),    
    .read_data_en           (spi_wr_ack_o|spi_rd_ack_o),

    .adsdata_fifo_empty     (lmxdata_fifo_empty ),
    .read_data_o  	        (read_data_o        )

);

assign spi_rw_flag  = read_data_o[23];
assign spi_config   = read_data_o[24];

serial_interface_lmx2492 serial_interface_lmx2492 
(
    .sys_rst                (rst                ),
    .sys_clk                (clk                ),
    .spi_clk_in             (clk_10m            ),
    .spi_rw_flag            (spi_rw_flag        ),

    .lmx2492_batch_wr       (lmx2492_batch_wr   ),
    .lmx2492_batch_rd       (lmx2492_batch_rd   ),
    .spi_config             (spi_config         ),
    .lmx2492_data           (read_data_o[22:0]  ),

    .lmxfifo_empty          (lmxdata_fifo_empty ),
    .spi_wr_ack_o           (spi_wr_ack_o       ),
    .spi_rd_ack_o           (spi_rd_ack_o       ),
    .spi_rdata_vd_o         (spi_rdata_vd_o     ),
    .spi_wdata_vd_o         (spi_wdata_vd_o     ),

    .spi_paddr_o            (spi_paddr_o        ),
    .spi_pdata_o            (spi_pdata_o        ),
    .spi_rdata_cnt_o        (spi_rdata_cnt_o    ),
    .spi_wdata_cnt_o        (spi_wdata_cnt_o    ),

    .spi_sdata_i            (spi_lmx2492_sdata_i),
    .spi_sdata_o            (spi_lmx2492_sdata_o),
    .spi_sen_o              (spi_lmx2492_sen_o  ),
    .spi_clk_o              (spi_lmx2492_sclk_o ),
    .reg0                   (reg0               ),
    .reg1                   (reg1               ),
    .reg2                   (reg2               ),
    .reg3                   (reg3               ),
    .reg4                   (reg4               ),
    .reg5                   (reg5               ),
    .reg6                   (reg6               ),
    .reg7                   (reg7               ),
    .reg8                   (reg8               ),
    .reg9                   (reg9               ),
    .irp                    (irp                )
);

endmodule
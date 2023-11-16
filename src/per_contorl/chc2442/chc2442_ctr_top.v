module chc2442_ctr_top 
(
    input	wire            rst                 ,
    input	wire            clk                 ,
    input   wire            clk_10m             ,

    input   wire            write_data_valid    ,
    input   wire [24:0]     write_data_in       ,

    output  wire [31:0]     reg0	            ,
    output  wire            irp                 ,

    output  wire            spi_sdata_o         ,
    output  wire            spi_sen_o           ,
    output  wire            spi_clk_o           ,
    output  wire            spi_reset_o         ,
    input   wire            spi_sdout_i    

);

wire            spi_rw_flag     ;
wire            spi_config      ;
wire [25:0]     read_data_o_2442;
wire            chcfifo_empty   ;
wire            spi_wr_ack_o    ;
wire            spi_rd_ack_o    ;

serial_interface_chc2442 serial_interface_chc2442 
(
    .sys_rst            (rst            ),//pll_locked
    .sys_clk            (clk            ),//100mhz
    .spi_clk_in         (clk_10m        ),//10mhz

    .spi_rw_flag        (spi_rw_flag    ),
    .spi_config         (spi_config     ),
    .chc2442_data       (read_data_o_2442[23:0]),//from PS, reg addr(15bit) + reg data(8bit)

    .chcfifo_empty      (chcfifo_empty  ),
    
    .spi_wr_ack_o       (spi_wr_ack_o   ),
    .spi_rd_ack_o       (spi_rd_ack_o   ),
    .spi_rdata_vd_o     (),
    .spi_rdata_cnt_o    (),
    .spi_pdata_o        (),
    .irp                (irp            ),
    .reg0               (reg0           ),

    .spi_sdata_i        (spi_sdout_i    ),
    .spi_sdata_o        (spi_sdata_o    ),
    .spi_sen_o          (spi_sen_o      ),
    .spi_clk_o          (spi_clk_o      )

);
chc2442_write_data_buffer chc2442_write_data_buffer 
(
    .sys_rst            (rst            ),
    .write_clk          (clk            ),

    .write_data_en      (write_data_valid   ),
    .write_data_in      (write_data_in      ),
    
    .read_clk           (clk_10m            ),
    .read_data_en       (spi_wr_ack_o       ),
    .adsdata_fifo_empty (chcfifo_empty      ),  
    .read_data_o  	    (read_data_o_2442   )
);

assign spi_config   = read_data_o_2442[25];
assign spi_rw_flag  = read_data_o_2442[24];

endmodule
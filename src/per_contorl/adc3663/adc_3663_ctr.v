module adc_3663_ctr
(
//-----------------------------------------------------------------
    input	wire            rst                 ,
    input	wire            clk                 ,
    input   wire            clk_10m             ,
//-----------------------------------------------------------------
    
    input   wire            write_data_valid    ,
    input   wire [23:0]     write_data_in       ,

//-----------------------------------------------------------------
    output  wire [22:0]     reg0	            ,
    output  wire            irp                 ,
//-------------------------spi--------------------------------------


    output  wire            spi_sen_o           ,
    output  wire            spi_clk_o           ,
    output  wire            spi_reset_o         ,
    inout   wire            spi_sdio            ,
    output  reg             adc_rst     

);

wire            spi_rw_flag ;
wire            spi_config  ;
wire [23:0]     read_data_o ;
wire            adcfifo_empty;
wire            spi_wr_ack_o;
wire            spi_rd_ack_o;

serial_interface_adc3663 serial_interface_adc3244
(
    .sys_rst                (rst            ),
    .sys_clk                (clk            ),
    .spi_clk_in             (clk_10m        ),

    .spi_rw_flag            (spi_rw_flag    ),
    .spi_config             (spi_config     ),
    .adc3244_data           (read_data_o[21:0]),
    .adcfifo_empty          (adcfifo_empty  ),
    .spi_wr_ack_o           (spi_wr_ack_o   ),
    .spi_rd_ack_o           (spi_rd_ack_o   ),
    .spi_paddr_o            (),
    .spi_pdata_o            (),
    .spi_rdata_cnt_o        (),
    .reg0                   (reg0           ),

    // .spi_sdata_o            (spi_sdata_o    ),
    .spi_sen_o              (spi_sen_o      ),
    .spi_clk_o              (spi_clk_o      ),
    .spi_reset_o            (spi_reset_o    ),
    .spi_sdio               (spi_sdio       )
    // .spi_sdout_i            (spi_sdout_i    )

);

adc3663_write_data_buffer adc3244_write_data_buffer
(
    .sys_rst                (rst                ),
    .write_clk              (clk                ),

    .write_data_en          (write_data_valid   ),
    .write_data_in          (write_data_in      ),
    .read_clk               (clk_10m            ),
    .read_data_en           (spi_wr_ack_o|spi_rd_ack_o),
    .adsdata_fifo_empty     (adcfifo_empty      ),
    .read_data_o  	        (read_data_o        )
);

assign spi_rw_flag = read_data_o[22];
assign spi_config  = read_data_o[23];

reg [31:0]  adc_rst_cnt ;

always @(posedge clk) begin
    if(rst)
        adc_rst_cnt <= 'd0 ;
    else if(adc_rst_cnt <= 32'd100_000_000)
        adc_rst_cnt <= adc_rst_cnt + 1'b1 ;
    else 
        adc_rst_cnt <= adc_rst_cnt ;
end

always @(posedge clk) begin
    if(rst)
        adc_rst <= 'd1 ;
    else if(adc_rst_cnt == 32'd100_000_000)
        adc_rst <= 'd0 ;
    else 
        adc_rst <= adc_rst ;
end

endmodule

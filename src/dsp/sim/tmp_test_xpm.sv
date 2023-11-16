//   vlog D:/repo/acur101_pl/src/dsp/*.sv
//   vsim -voptargs=+acc work.tmp_test_xpm -L xpm
//
//
//
//
`timescale 1ns/1ps
module tmp_test_xpm();
reg        clk         ='d0;
reg        ram_ren_b   ='d1;
reg [16:0] ram_raddr_b ='d0;
wire[31:0] ram_rdata_b ;
reg        ram_wen_a   = 4'hf;
reg [16:0] ram_waddr_a =  'd0;
reg [16:0] ram_waddr_a_d0 =  'd0;
reg [31:0] ram_wdata_a =  'd0;

always #3.125 clk = ~clk;
always @ (posedge clk) begin
    ram_waddr_a     <= ram_waddr_a+1;
    ram_waddr_a_d0  <= ram_waddr_a;
    ram_raddr_b     <= ram_waddr_a_d0;
end

//----//----//----//----//----//----//----//----  URAM //----//----//----//----//----//----//----//----
xpm_memory_sdpram #(
    .ADDR_WIDTH_A             (17             ),
    .ADDR_WIDTH_B             (17             ),
    .AUTO_SLEEP_TIME          (0              ),
    .BYTE_WRITE_WIDTH_A       (32             ),
    .CASCADE_HEIGHT           (0              ),
    .CLOCKING_MODE            ("common_clock" ),
    .ECC_MODE                 ("no_ecc"       ),
    .MEMORY_INIT_FILE         ("none"         ),
    .MEMORY_INIT_PARAM        ("0"            ),
    .MEMORY_OPTIMIZATION      ("true"         ),
    .MEMORY_PRIMITIVE         ("ultra"         ), // "ultra"
    .MEMORY_SIZE              (2228224        ),//2048*(32+2)*32
    .MESSAGE_CONTROL          (0              ),
    .READ_DATA_WIDTH_B        (32             ),
    .READ_LATENCY_B           (2              ),
    .READ_RESET_VALUE_B       ("0"            ),
    .RST_MODE_A               ("SYNC"         ),
    .RST_MODE_B               ("SYNC"         ),
    .SIM_ASSERT_CHK           (0              ),
    .USE_EMBEDDED_CONSTRAINT  (0              ),
    .USE_MEM_INIT             (1              ),
    .USE_MEM_INIT_MMI         (0              ),
    .WAKEUP_TIME              ("disable_sleep"),
    .WRITE_DATA_WIDTH_A       (32             ),
    .WRITE_MODE_B             ("read_first"   ),
    .WRITE_PROTECT            (1              )
)
u_xpm_memory_sdpram_32x2048 (
    .dbiterrb       (             ),
    .doutb          (ram_rdata_b  ),
    .sbiterrb       (             ),
    .addra          (ram_waddr_a  ),
    .addrb          (ram_raddr_b  ),
    .clka           (clk          ),
    .clkb           (clk          ),
    .dina           ({15'd0,ram_waddr_a} ),
    .ena            (ram_wen_a    ),
    .enb            (ram_ren_b    ),
    .injectdbiterra (1'b0         ),
    .injectsbiterra (1'b0         ),
    .regceb         (1'b1         ),
    .rstb           (1'b0         ),
    .sleep          (1'b0         ),
    .wea            (ram_wen_a    )
);


endmodule
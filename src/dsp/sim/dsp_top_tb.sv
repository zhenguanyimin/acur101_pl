
module dsp_top_tb();

wire       clk       ;
wire       i_cpib    ;
wire       i_cpie    ;
wire       i_pri     ;
wire       i_smp_gate;
wire       i_tvalid;
wire [15:0]i_tdata    ;

dsp_top_tester u_dsp_top_tester(
    .clk        (clk        ),
    .i_cpib     (i_cpib     ),
    .i_cpie     (i_cpie     ),
    .i_pri      (i_pri      ),
    .i_smp_gate (i_smp_gate ),
    .i_tvalid   (i_tvalid   ),
    .i_tdata    (i_tdata    )
    );

dsp_top   u_dsp_top(
    .clk       (clk        ),
    .i_cpib    (i_cpib     ),
    .i_cpie    (i_cpie     ),
    .i_pri     (i_pri      ),
    .i_smp_gate(i_smp_gate ),
    .i_tvalid  (i_tvalid   ),
    .i_tdata   (i_tdata    )
    );

endmodule
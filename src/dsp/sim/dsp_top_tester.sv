`timescale 1ns/1ps
module dsp_top_tester(
    output reg        clk        = 'd0,
    output reg        i_cpib     = 'd0,
    output reg        i_cpie     = 'd0,
    output reg        i_pri      = 'd0,
    output reg        i_smp_gate = 'd0,
    output reg        i_tvalid   = 'd0,
    output reg  [15:0]i_tdata    = 'd0

    );

// add clock
always #3.125 clk = ~clk;

reg [15:0] st_gen = 16'hFFFF;
always @ (posedge clk) begin
    st_gen[15:1] <= st_gen[14:0] ;
    st_gen[0]    <= st_gen[15] + st_gen[13] + st_gen[2]  + st_gen[4];
end
// gen data vld
reg [2:0] cnt_div8='d0;
always @ (posedge clk) begin
    cnt_div8 <= cnt_div8 + 1;
end
always @ (posedge clk) begin 
    if (cnt_div8 == 3'd4)begin
        i_tvalid <= 1'b1;
        i_tdata <= st_gen;
    end 
    else begin
        i_tvalid <= 1'b0;
        i_tdata <= i_tdata;
    end
end


//----//----//----//----//----//----//----//---- data //----//----//----//----//----//----//----//----

reg [15:0] cnt_vld = 'd0;
reg [15:0] cnt_pri = 'd0;
always @ (posedge clk) begin
    if (i_tvalid)begin 
        if (cnt_vld ==16'd4195)begin
            cnt_vld <= 'd0;
        end
        else begin
            cnt_vld <= cnt_vld +1;
        end
    end
end
always @ (posedge clk) begin
    if (i_tvalid && cnt_vld ==16'd4195)begin 
        cnt_pri <= cnt_pri + 1;
    end
    else begin
        cnt_pri <= cnt_pri;
    end
end


//----//----//----//----//----//----//----//---- timing //----//----//----//----//----//----//----//----
always @ (posedge clk) begin
    if (cnt_pri ==16'd0 && cnt_vld==16'd10)
        i_cpib <= 1'b1;
    else if (cnt_pri ==16'd0 && cnt_vld==16'd13)
        i_cpib <= 1'b0;
end
always @ (posedge clk) begin
    if (cnt_pri ==16'd31 && cnt_vld==16'd4110)
        i_cpie <= 1'b1;
    else if (cnt_pri ==16'd0 && cnt_vld==16'd4113)
        i_cpie <= 1'b0;
end
always @ (posedge clk) begin
    if ( cnt_vld==16'd16)
        i_pri <= 1'b1;
    else if ( cnt_vld==16'd19)
        i_pri <= 1'b0;
end
always @ (posedge clk) begin
    if (cnt_vld == 16'd30)
        i_smp_gate <= 1'b1;
    else if (cnt_vld == 16'd30+4096)
        i_smp_gate <= 1'b0;

end



endmodule
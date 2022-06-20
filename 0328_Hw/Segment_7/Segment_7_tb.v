`timescale 1ns/1ns
module Segment_7_tb;

reg clk_50MHz, res;
wire clk_1Hz;
wire [4:0]out;
wire [3:0]seg_com;
wire [6:0]seg;

Segment_7 U1(.OUT(out), .SEG(seg), .SEG_COM(seg_com), 
.CLK_1Hz(clk_1Hz), .CLK_50MHz(clk_50MHz), .Res(res));

initial clk_50MHz = 1'b0;
always #10 clk_50MHz = ~clk_50MHz;

initial begin
	res = 1'b0;
	#100 res = 1'b1;
end

initial #250000 $stop;
endmodule 
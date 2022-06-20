`timescale 1ns/1ns
module LFSR_tb;

reg Clk_50Mhz;
wire [7:0]rand;
wire [2:0]Out;

LFSR U1(.clk(Clk_50Mhz),
		  .rand_num(rand),
		  .out(Out));
		 
initial begin
	Clk_50Mhz = 1'b0;
end

always #10 Clk_50Mhz = ~Clk_50Mhz;

endmodule 
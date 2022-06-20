`timescale 1ns/1ns
module counter_8bit_tb;
// Input
reg clk_50Mhz, res;
// Output
wire [7:0]led;
wire clk_200khz;

parameter clkper = 20; // 1period = 20ns
// Import Module
counter_8bit U1(.LED(led), .CLK_200KHz(clk_200khz), .CLK_50MHz(clk_50Mhz), .Res(res));
// Initial value
initial begin
	clk_50Mhz = 1'b0;
	res = 1'b0;
	#12000 res = 1'b1;
end
// Generate CLK 50MHz
always #(clkper / 2) clk_50Mhz = ~clk_50Mhz;

endmodule

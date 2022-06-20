`timescale 1ns/1ns
module LED_10Period_tb;
reg clk_50Mhz, sw;
wire led;

LED_10Period U1(.Led(led), .Sw(sw), .Clk_50M(clk_50Mhz));

initial begin
	clk_50Mhz = 1'b0;
	sw = 1'b1;
end

always #10 clk_50Mhz = ~clk_50Mhz;

endmodule 
`timescale 1us/1us
module LED_test_tb;
// input
reg clk_50Mhz, res_n;
// output
wire [7:0]led;

LED_test U1(.LED(led), .CLK_50MHz(clk_50Mhz), .Reset_n(res_n));

// "." use to call pin name of core
initial clk_50Mhz = 1'b1;

always #10 clk_50Mhz = ~clk_50Mhz;

initial 
begin
	res_n = 1'b0;
	#20 res_n = 1'b1;
end

endmodule 
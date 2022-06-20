`timescale 1us/1us
module led_display_tb;
// input
reg CLK_50Mhz, RES_N;
// output
wire [3:0]led;
wire CLK_25Mhz;
wire [7:0]CLK_count;

led_display U1(.LED(led), .clk_50Mhz(CLK_50Mhz), .clk_25Mhz(CLK_25Mhz), 
					.clk_count(CLK_count), .res_n(RES_N));

// "." use to call pin name of core
initial CLK_50Mhz = 1'b1;

always #10 CLK_50Mhz = ~CLK_50Mhz;

initial 
begin
	RES_N = 1'b0;
	#20 RES_N = 1'b1;
end

endmodule 
`timescale 1us/1us
module Traffic_Light_tb;
// Input
reg clk_50Mhz, res_n;
reg [2:0]road_sw;
// Output
wire [4:0]led;
wire counter;

integer count = 0;
// Import Module
Traffic_Light U1(.LED(led), 
					  .Counter(counter), 
					  .CLK_50MHz(clk_50Mhz), 
					  .Road_SW(road_sw), 
					  .Res_n(res_n));
// Initial value
initial begin
	clk_50Mhz = 1'b0;
	res_n = 1'b0;
	road_sw = 3'b100;
	#150 res_n = 1'b1;
	#5000000 road_sw = 3'b010;
	#5000000 road_sw = 3'b001;
end

always #10 clk_50Mhz = ~clk_50Mhz;

endmodule 
`timescale 1ns/1ns
module Traffic_Light_Seg_tb;
// Input
reg clk_50Mhz, res_n;
reg [2:0]road_sw;
// Output
wire [4:0]led;
wire counter;
wire [6:0]seg4, seg3, seg2, seg1;

integer count = 0;
// Import Module
Traffic_Light_Seg U1(.LED(led), 
							.Seg4(seg4),
							.Seg3(seg3),
							.Seg2(seg2),
							.Seg1(seg1),
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
	#10000000 road_sw = 3'b010;
	#10000000 road_sw = 3'b001;
end

always #10 clk_50Mhz = ~clk_50Mhz;

endmodule 
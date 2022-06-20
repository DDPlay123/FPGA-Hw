`timescale 1ns/1ns
module Alarm_Clock_tb;

// Input
reg clk_50Mhz, accel, down, up;
reg [3:0]sw;
// Output
wire [2:0]aled;
wire [6:0]seg6, seg5, seg4, seg3, seg2, seg1;
wire led;

// Import Module
Alarm_Clock U1(.Led(led), 
					.Seg6(seg6), 
					.Seg5(seg5), 
					.Seg4(seg4), 
					.Seg3(seg3),
					.Seg2(seg2),
					.Seg1(seg1),
					.ALed(aled),
					.Sw(sw),
					.Up(up),
					.Down(down),
					.Accel(accel),
					.Clk_50MHz(clk_50Mhz));
// Initial value
initial begin
	clk_50Mhz = 1'b0;
	up = 1'b1;
	down = 1'b1;
	accel = 1'b0;
	sw = 4'b0011;
	#100000 up = 1'b0;
	#1000000 up = 1'b1;
	sw = 4'b0101;
	#100000 up = 1'b0;
	#1000000 up = 1'b1;
	#100000 down = 1'b0;
	#1000000 down = 1'b1;
	sw = 4'b1001;
	#100000 up = 1'b0;
	#1000000 up = 1'b1;
	#100000 down = 1'b0;
	#1000000 down = 1'b1;
	#100000 sw = 4'b0000;
end

always #10 clk_50Mhz = ~clk_50Mhz;

endmodule 
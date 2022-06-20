module VGA_Paint(Red, Green, Blue, 
					  VGA_CLK, VGA_BLANK_N, 
					  VGA_HS, VGA_VS, VGA_SYNC_N,
					  Clk_50MHz, Test);
			  
// IO PORT
output reg [7:0]Red, Green, Blue;
output reg [20:0]Test;
output reg VGA_CLK = 1'b0, 
			  VGA_BLANK_N, VGA_HS, VGA_VS, 
			  VGA_SYNC_N = 1'b0;
input Clk_50MHz;

// 25MHz -> 40ns
always@(posedge Clk_50MHz)begin
	VGA_CLK = ~VGA_CLK;
end

// Screen SCAN
reg [9:0]hor_counter, ver_counter;

always@(posedge VGA_CLK)begin
	// Horizontal Scan
	if(hor_counter == 795) hor_counter = 0;
	else hor_counter = hor_counter + 1;
	// Vertical Scan
	if(ver_counter == 523 && hor_counter == 700) ver_counter = 0;
	else if(hor_counter == 700) ver_counter = ver_counter + 1;
	// Horizontal Signal
	if(hor_counter >= 658 && hor_counter <= 753) VGA_HS = 1'b0;
	else VGA_HS = 1'b1;
	// Vertical Signal
	if(ver_counter >= 491 && ver_counter <= 492) VGA_VS = 1'b0;
	else VGA_VS = 1'b1;
	// Output RGB Data
	if(hor_counter >= 0 && hor_counter <= 639) VGA_BLANK_N = 1'b1;
	else VGA_BLANK_N = 1'b0;
end

function [20:0]Area;
	input [9:0]x1,y1,x2,y2,x3,y3;
	reg [21:0]A;
	begin
		A = ((x1 * (y2 - y3)) + (x2 * (y3 - y1)) + (x3 * (y1 - y2))) / 2;
		if(A[21]) Area = (~A[20:0]) + 1;
		else Area = A[20:0];
	end
endfunction

// Display
always@(*)begin
	// triangle (A(340, 50)、B(120, 450)) => C(340, 450)
	if(Area(340, 50, 120, 450, 340, 450) == (Area(hor_counter, ver_counter, 120, 450, 340, 450) + Area(340, 50, hor_counter, ver_counter, 340, 450) + Area(340, 50, 120, 450, hor_counter, ver_counter)))begin
		Red = 8'd0;
		Green = 8'd255;
		Blue = 8'd0;
	end
	else begin
		Test = Area(340, 50, 120, 450, 340, 450);
		Red = 8'd255;
		Green = 8'd255;
		Blue = 8'd255;
	end
end

endmodule 
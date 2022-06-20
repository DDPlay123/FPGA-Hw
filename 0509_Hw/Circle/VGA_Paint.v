module VGA_Paint(Red, Green, Blue, 
					  VGA_CLK, VGA_BLANK_N, 
					  VGA_HS, VGA_VS, VGA_SYNC_N,
					  Clk_50MHz, Test);
			  
// IO PORT
output reg [7:0]Red, Green, Blue;
output reg VGA_CLK = 1'b0, 
			  VGA_BLANK_N, VGA_HS, VGA_VS, 
			  VGA_SYNC_N = 1'b0;
output reg [20:0]Test;
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

function [9:0]Sub;
	input [9:0]a, b;
	reg [10:0]sub;
	begin
		sub = a - b;
		if(sub[10]) Sub = (~sub[9:0]) + 1;
		else Sub = sub[9:0];
	end
endfunction

function [19:0]Squ;
	input [9:0]a;
	reg [20:0]squ;
	begin
		squ = a * a;
		if(squ[20]) Squ = (~squ[19:0]) + 1;
		else Squ = squ[19:0];
	end
endfunction

// Display
always@(*)begin
	// Circle (320, 240) r = 20
	if(Squ(20) >= Squ(Sub(hor_counter, 340)) + Squ(Sub(ver_counter, 240)))begin
		Red = 8'd0;
		Green = 8'd255;
		Blue = 8'd0;
	end
	else begin
		Test = Squ(Sub(330, 340)) + Squ(Sub(ver_counter, 240));
		Red = 8'd255;
		Green = 8'd255;
		Blue = 8'd255;
	end
end

endmodule 
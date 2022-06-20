module VGA_Paint(Red, Green, Blue, 
					  VGA_CLK, VGA_BLANK_N, 
					  VGA_HS, VGA_VS, VGA_SYNC_N,
					  Clk_50MHz, Key);
			  
// IO PORT
output reg [7:0]Red, Green, Blue;
output reg VGA_CLK = 1'b0, 
			  VGA_BLANK_N, VGA_HS, VGA_VS, 
			  VGA_SYNC_N = 1'b0;
input Clk_50MHz;
input Key;

// 25MHz -> 40ns
always@(posedge Clk_50MHz)begin
	VGA_CLK = ~VGA_CLK;
end

// Screen SCAN
reg [9:0]hor_counter, 
		   ver_counter;

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

// Listener Key to fill RGB to Rectangle
reg [2:0]RGB = 3'd0;
always@(*) begin
	if(!Key)begin
		RGB = RGB + 1;
		if(RGB > 3'd2) RGB = 3'd0;
	end
end

// Get Triangle Area
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
	// ver Line (x = 120, y = 0 ~ 230)
	if(hor_counter == 120 && ver_counter >= 10 && ver_counter <= 230) begin
		Red = 8'd0;
		Green = 8'd200;
		Blue = 8'd0;
	end
	// hor Line (x = 150 ~ 360, y = 120)
	else if(ver_counter == 120 && hor_counter >= 150 && hor_counter <= 360)begin
		Red = 8'd0;
		Green = 8'd200;
		Blue = 8'd0;
	end
	// rectangle (x = 380 ~ 630, y = 10 ~ 230)
	else if(hor_counter >= 380 && hor_counter <= 630 && ver_counter >= 10 && ver_counter <= 230)begin
		case(RGB)
			3'd0:begin
				Red = 8'd0;
				Green = 8'd200;
				Blue = 8'd0;
			end
			3'd1:begin
				Red = 8'd200;
				Green = 8'd0;
				Blue = 8'd0;
			end
			3'd2:begin
				Red = 8'd0;
				Green = 8'd0;
				Blue = 8'd200;
			end
			default:begin
				Red = 8'd0;
				Green = 8'd0;
				Blue = 8'd0;
			end
		endcase
	end
	// bounding
	else if(hor_counter >= 379 && hor_counter <= 631 && ver_counter >= 9 && ver_counter <= 231)begin
		Red = 8'd255;
		Green = 8'd255;
		Blue = 8'd255;
	end
	// triangle (A(120, 250)、B(70, 450)、C(250, 400))
	else if(Area(120, 250, 70, 450, 250, 400) == (
			  Area(hor_counter, ver_counter, 70, 450, 250, 400) + 
			  Area(120, 250, hor_counter, ver_counter, 250, 400) + 
			  Area(120, 250, 70, 450, hor_counter, ver_counter)))begin
		Red = 8'd0;
		Green = 8'd255;
		Blue = 8'd0;
	end
	// other area
	else begin
		Red = 8'd0;
		Green = 8'd0;
		Blue = 8'd0;
	end
end

endmodule 
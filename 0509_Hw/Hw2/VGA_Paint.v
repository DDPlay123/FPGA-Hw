module VGA_Paint(RGB, VGA_CLK, VGA_BLANK_N,
					  VGA_HS, VGA_VS, VGA_SYNC_N,
					  Seg5, Seg4, Seg3, Seg2, Seg1,
					  Clk_50MHz, Sw, Key);		  
// Output for VGA
output reg [23:0]RGB;
output reg VGA_CLK = 1'b0, 
			  VGA_BLANK_N, VGA_HS, VGA_VS, 
			  VGA_SYNC_N = 1'b0;
// Output for Segment 7		  
output reg [6:0]Seg5, Seg4, Seg3, Seg2, Seg1;
// Input for Clock 50MHz
input Clk_50MHz;
// Input for Switch
input [7:0]Sw;
// Input for Key
input [3:0]Key;
//---------------------------------------------------- Generate Clock 4Hz(Setting) or 16Hz(Moving)
reg CLK_2_16 = 1'b0;
reg [27:0]CLK_count = 0;
always@(posedge Clk_50MHz)begin
	if(Sw[6])begin
		if(CLK_count > 1562500)begin // (16Hz)1562500
			CLK_2_16 = ~CLK_2_16; CLK_count = 0;
		end
		else CLK_count = CLK_count + 1;
	end else begin
		if(CLK_count > 6250000)begin // (4Hz)6250000
			CLK_2_16 = ~CLK_2_16; CLK_count = 0;
		end
		else CLK_count = CLK_count + 1;
	end
end
//---------------------------------------------------- VGA Scan Sync
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
//----------------------------------------------------Control
always@(posedge CLK_2_16)begin
	if(Sw[7]) begin
		x1 = 0; y1 = 0; x2 = 0; y2 = 0;
		cx1 = 0; cy1 = 0; cx2 = 0; cy2 = 0;
	end else begin
		// Swap
		cx1 = SwapMax(x1, x2);
		cy1 = SwapMax(y1, y2);
		cx2 = SwapMin(x1, x2);
		cy2 = SwapMin(y1, y2);
		// control
		if(Sw[6]) begin
			// Paint Control
			case(Sw)
				8'd96, 8'd80:begin
					if(!Key[3])begin // Up
						if(cy2 > 0) begin
							y1 = y1 - 1; y2 = y2 - 1;
						end
					end
					if(!Key[2])begin // Down
						if(cy1 < 480)begin
							y1 = y1 + 1; y2 = y2 + 1;
						end
					end
					if(!Key[1])begin // Left
						if(cx2 > 0)begin
							x1 = x1 - 1; x2 = x2 - 1;					
						end
					end
					if(!Key[0])begin // Right
						if(cx1 < 640)begin
							x1 = x1 + 1; x2 = x2 + 1;
						end
					end
				end
			endcase
		end else begin
			case(Sw)
				8'd8:begin
					if(!Key[3] && x1 < 640) x1 = x1 + 1; if(!Key[2] && x1 > 0) x1 = x1 - 1;
					if(!Key[1] && x1 < 640) if(x1 >= 630 && x1 <= 640) x1 = 640;
					else x1 = x1 + 10;
					if(!Key[0] && x1 > 0) if(x1 >= 0 && x1 <= 10) x1 = 0;
					else x1 = x1 - 10;
				end
				8'd4:begin
					if(!Key[3] && y1 < 480) y1 = y1 + 1; if(!Key[2] && y1 > 0) y1 = y1 - 1;
					if(!Key[1] && y1 < 480) if(y1 >= 470 && y1 <= 480) y1 = 480;
					else y1 = y1 + 10;
					if(!Key[0] && y1 > 0) if(y1 >= 0 && y1 <= 10) y1 = 0;
					else y1 = y1 - 10;
				end
				8'd2:begin
					if(!Key[3] && x2 < 640) x2 = x2 + 1; if(!Key[2] && x2 > 0) x2 = x2 - 1;
					if(!Key[1] && x2 < 640) if(x2 >= 630 && x2 <= 640) x2 = 640;
					else x2 = x2 + 10;
					if(!Key[0] && x2 > 0) if(x2 >= 0 && x2 <= 10) x2 = 0;
					else x2 = x2 - 10;
				end
				8'd1:begin
					if(!Key[3] && y2 < 480) y2 = y2 + 1; if(!Key[2] && y2 > 0) y2 = y2 - 1;
					if(!Key[1] && y2 < 480) if(y2 >= 470 && y2 <= 480) y2 = 480;
					else y2 = y2 + 10;
					if(!Key[0] && y2 > 0) if(y2 >= 0 && y2 <= 10) y2 = 0;
					else y2 = y2 - 10;
				end
			endcase
		end
	end
end
//----------------------------------------------------Display
// Coordinate Two point parameter
reg [9:0]x1, y1, x2, y2;
reg [9:0]cx1, cy1, cx2, cy2;
reg [3:0]h, d, b; // 個十百位
always@(*)begin
	if(Sw[7])begin
		// Clear 7-Seg、Coordinate、RGB
		Seg5 = Encoder(4'd15); Seg4 = Encoder(4'd15); Seg3 = Encoder(4'd15); Seg2 = Encoder(4'd15); Seg1 = Encoder(4'd15);
		RGB = 24'h000000;
	end else begin
		if(Sw[6])begin
			// Paint Control
			case(Sw)
				8'd96:begin
					// Triangle
					if(Area(cx1, cy1, cx2, cy2, cx2, cy1) == (
					   Area(hor_counter, ver_counter, cx2, cy2, cx2, cy1) + 
						Area(cx1, cy1, hor_counter, ver_counter, cx2, cy1) + 
						Area(cx1, cy1, cx2, cy2, hor_counter, ver_counter)))
						RGB = 24'h00FF00;
					else RGB = 24'h000000;
				end
				8'd80:begin
					// Rectangle
					if(hor_counter >= cx2 && hor_counter <= cx1 && ver_counter >= cy2 && ver_counter <= cy1)
						RGB = 24'h00FF00;
					else RGB = 24'h000000;
				end
			endcase
		end else begin
			case(Sw)
				// Paint
				8'd32:begin
					// Paint Point
					if(Squ(3) >= Squ(Sub(hor_counter, x1)) + Squ(Sub(ver_counter, y1))) RGB = 24'hFF0000;
					else if(Squ(3) >= Squ(Sub(hor_counter, x2)) + Squ(Sub(ver_counter, y2))) RGB = 24'hFF0000;
					// Paint Triangle
					else if(Area(cx1, cy1, cx2, cy2, cx2, cy1) == (
					        Area(hor_counter, ver_counter, cx2, cy2, cx2, cy1) + 
							  Area(cx1, cy1, hor_counter, ver_counter, cx2, cy1) + 
							  Area(cx1, cy1, cx2, cy2, hor_counter, ver_counter)))
						RGB = 24'h00FF00;
					else RGB = 24'h000000;
				end
				8'd16:begin
					// Paint Point
					if(Squ(3) >= Squ(Sub(hor_counter, x1)) + Squ(Sub(ver_counter, y1))) RGB = 24'hFF0000;
					else if(Squ(3) >= Squ(Sub(hor_counter, x2)) + Squ(Sub(ver_counter, y2))) RGB = 24'hFF0000;
					// Paint Rectangle
					else if(hor_counter >= cx2 && hor_counter <= cx1 && ver_counter >= cy2 && ver_counter <= cy1)
						RGB = 24'h00FF00;
					else RGB = 24'h000000;
				end
				// Coordinate
				8'd8:begin
					// x1
					h = x1/100; d = (x1%100)/10; b = (x1%100)%10;
					Seg5 = Encoder(4'd10); Seg4 = Encoder(4'd1); Seg3 = Encoder(h); Seg2 = Encoder(d); Seg1 = Encoder(b);
				end
				8'd4:begin
					// y1
					h = y1/100; d = (y1%100)/10; b = (y1%100)%10;
					Seg5 = Encoder(4'd12); Seg4 = Encoder(4'd1); Seg3 = Encoder(h); Seg2 = Encoder(d); Seg1 = Encoder(b);
				end
				8'd2:begin
					// x2
					h = x2/100; d = (x2%100)/10; b = (x2%100)%10;
					Seg5 = Encoder(4'd10); Seg4 = Encoder(4'd2); Seg3 = Encoder(h); Seg2 = Encoder(d); Seg1 = Encoder(b);
				end
				8'd1:begin
					// y2
					h = y2/100; d = (y2%100)/10; b = (y2%100)%10;
					Seg5 = Encoder(4'd12); Seg4 = Encoder(4'd2); Seg3 = Encoder(h); Seg2 = Encoder(d); Seg1 = Encoder(b);
				end
				default:begin
					RGB = 24'h000000;
					Seg5 = Encoder(4'd15); Seg4 = Encoder(4'd15); Seg3 = Encoder(4'd15); Seg2 = Encoder(4'd15); Seg1 = Encoder(4'd15);
				end
			endcase
		end
	end
end
//---------------------------------------------------- Application Function
// Binary to Seg
function [6:0]Encoder;
	// input
	input [3:0]In;
	// Converter
	begin
		case(In)
			4'd0:Encoder = 7'b100_0000; 4'd1:Encoder = 7'b111_1001;
			4'd2:Encoder = 7'b010_0100; 4'd3:Encoder = 7'b011_0000;
			4'd4:Encoder = 7'b001_1001; 4'd5:Encoder = 7'b001_0010;
			4'd6:Encoder = 7'b000_0010; 4'd7:Encoder = 7'b111_1000;
			4'd8:Encoder = 7'b000_0000; 4'd9:Encoder = 7'b001_0000;
			4'd10:Encoder = 7'b000_1000;4'd12:Encoder = 7'b100_0110;
			4'd15:Encoder = 7'b011_1111;
		endcase
	end
endfunction
//----------------------------------------------------
// Get Triangle Area
function [20:0]Area;
	// A(x1, y1)、B(x2, y2)、C(x3, y3)
	input [9:0]x1,y1,x2,y2,x3,y3;
	reg [21:0]A;
	// Calcuate
	begin
		A = ((x1 * (y2 - y3)) + (x2 * (y3 - y1)) + (x3 * (y1 - y2))) / 2;
		if(A[21]) Area = (~A[20:0]) + 1;
		else Area = A[20:0];
	end
endfunction
//----------------------------------------------------
// Get Subtraction
function [9:0]Sub;
	input [9:0]a, b;
	reg [10:0]sub;
	begin
		sub = a - b;
		if(sub[10]) Sub = (~sub[9:0]) + 1;
		else Sub = sub[9:0];
	end
endfunction
// Get Square
function [19:0]Squ;
	input [9:0]a;
	begin
		Squ = a * a;
	end
endfunction
//----------------------------------------------------
// Swap Max
function [9:0]SwapMax;
	input [9:0]c1, c2;
	// Swap
	begin
		if(c2 > c1) SwapMax = c2;
		else SwapMax = c1;
	end
endfunction
// Swap Min
function [9:0]SwapMin;
	input [9:0]c1, c2;
	// Swap
	begin
		if(c2 < c1) SwapMin = c2;
		else SwapMin = c1;
	end
endfunction
//----------------------------------------------------
endmodule 
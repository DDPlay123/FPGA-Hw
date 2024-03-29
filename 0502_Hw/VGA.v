module VGA(Red, Green, Blue, 
			  VGA_CLK, VGA_BLANK_N, 
			  VGA_HS, VGA_VS, VGA_SYNC_N,
			  Clk_50MHz, Sw);
			  
// IO PORT
output reg [7:0]Red, Green, Blue;
output reg VGA_CLK = 1'b0, 
			  VGA_BLANK_N, VGA_HS, VGA_VS, 
			  VGA_SYNC_N = 1'b0;
input Clk_50MHz;
input [4:0]Sw;

// 25MHz -> 40ns
always@(posedge Clk_50MHz)begin
	VGA_CLK = ~VGA_CLK;
end

// Screen SCAN
reg [9:0]hor_counter, 
		   ver_counter;
// Horizontal Scan
always@(posedge VGA_CLK)begin
	if(hor_counter == 795) hor_counter = 0;
	else hor_counter = hor_counter + 1;
end
// Vertical Scan
always@(posedge VGA_CLK)begin
	if(ver_counter == 523 && hor_counter == 700) ver_counter = 0;
	else if(hor_counter == 700) ver_counter = ver_counter + 1;
end
// Horizontal Signal
always@(posedge VGA_CLK)begin
	if(hor_counter >= 658 && hor_counter <= 753) VGA_HS = 1'b0;
	else VGA_HS = 1'b1;
end
// Vertical Signal
always@(posedge VGA_CLK)begin
	if(ver_counter >= 491 && ver_counter <= 492) VGA_VS = 1'b0;
	else VGA_VS = 1'b1;
end

// Display
always@(posedge VGA_CLK)begin
	if(hor_counter >= 0 && hor_counter <= 639) VGA_BLANK_N = 1'b1;
	else VGA_BLANK_N = 1'b0;
	case(Sw)
		5'b10000:begin
			Red = 8'd255;
			Green = 8'd0;
			Blue = 8'd0;
		end
		5'b01000:begin
			Red = 8'd0;
			Green = 8'd255;
			Blue = 8'd0;
		end
		5'b00100:begin
			Red = 8'd0;
			Green = 8'd0;
			Blue = 8'd255;
		end
		5'b00010:begin
			Red = 8'd244;
			Green = 8'd201;
			Blue = 8'd188;
		end
		5'b00001:begin
			Red = 8'd118;
			Green = 8'd15;
			Blue = 8'd212;
		end
		default:begin
			Red = 8'd255;
			Green = 8'd255;
			Blue = 8'd255;
		end
	endcase
end

endmodule 
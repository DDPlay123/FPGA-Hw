`timescale 1ns/1ns
module VGA_tb;

reg Clk_50Mhz;
reg [4:0]sw;
wire [7:0]red, green, blue;
wire vga_clk, vga_blank_n, vga_hs, vga_vs, vga_sync_n;

VGA U1(.Red(red), 
		 .Green(green), 
		 .Blue(blue), 
		 .VGA_CLK(vga_clk), 
		 .VGA_BLANK_N(vga_blank_n), 
		 .VGA_HS(vga_hs), 
		 .VGA_VS(vga_vs), 
		 .VGA_SYNC_N(vga_sync_n),
		 .Clk_50MHz(Clk_50Mhz),
		 .Sw(sw));
		 
initial begin
	Clk_50Mhz = 1'b0;
	sw = 5'b10000;
	#1000000 sw = 5'b01000;
	#1000000 sw = 5'b00100;
	#1000000 sw = 5'b00010;
	#1000000 sw = 5'b00001;
end

always #10 Clk_50Mhz = ~Clk_50Mhz;

endmodule 
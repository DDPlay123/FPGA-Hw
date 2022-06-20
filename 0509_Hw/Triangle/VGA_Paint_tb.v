`timescale 1ns/1ns
module VGA_Paint_tb;

reg Clk_50Mhz;
wire [7:0]red, green, blue;
wire [20:0]test;
wire vga_clk, vga_blank_n, vga_hs, vga_vs, vga_sync_n;

VGA_Paint U1(.Red(red), 
				 .Green(green), 
				 .Blue(blue), 
				 .VGA_CLK(vga_clk), 
				 .VGA_BLANK_N(vga_blank_n), 
				 .VGA_HS(vga_hs), 
				 .VGA_VS(vga_vs), 
				 .VGA_SYNC_N(vga_sync_n),
				 .Clk_50MHz(Clk_50Mhz),
				 .Test(test));
		 
initial Clk_50Mhz = 1'b0;

always #10 Clk_50Mhz = ~Clk_50Mhz;

endmodule 
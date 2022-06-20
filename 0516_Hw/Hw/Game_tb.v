`timescale 1ns/1ns
module Game_tb;

reg Clk_50Mhz;
wire [23:0]rgb;
wire vga_clk, vga_blank_n, vga_hs, vga_vs, vga_sync_n;

Game U1(.RGB(rgb), 
		  .VGA_CLK(vga_clk), 
		  .VGA_BLANK_N(vga_blank_n), 
		  .VGA_HS(vga_hs), 
		  .VGA_VS(vga_vs), 
		  .VGA_SYNC_N(vga_sync_n),
		  .Clk_50MHz(Clk_50Mhz));
		  
initial Clk_50Mhz = 1'b0;

always #10 Clk_50Mhz = ~Clk_50Mhz;

endmodule 
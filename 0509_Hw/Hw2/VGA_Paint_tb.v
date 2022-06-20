`timescale 1ns/1ns
module VGA_Paint_tb;

reg Clk_50Mhz;
reg [7:0]sw;
reg [3:0]key;
wire [23:0]rgb;
wire vga_clk, vga_blank_n, vga_hs, vga_vs, vga_sync_n;

VGA_Paint U1(.RGB(rgb),  
				 .VGA_CLK(vga_clk), 
				 .VGA_BLANK_N(vga_blank_n), 
				 .VGA_HS(vga_hs), 
				 .VGA_VS(vga_vs), 
				 .VGA_SYNC_N(vga_sync_n),
				 .Clk_50MHz(Clk_50Mhz),
				 .Sw(sw),
				 .Key(key));
		 
initial begin
	Clk_50Mhz = 1'b0;
	sw 	 = 8'd0;
	key 	 = 4'b1111;
	sw[3]  = 1'b1;
	key[1] = 1'b0;
	#50000
	key[1] = 1'b1;
	#50000 
	sw[3]  = 1'b0;
	sw[2]  = 1'b1;
	key[1] = 1'b0;
	#50000
	key[1] = 1'b1;
	sw 	 = 8'b00010000;
end

always #10 Clk_50Mhz = ~Clk_50Mhz;

endmodule 
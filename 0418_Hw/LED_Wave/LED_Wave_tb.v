`timescale 1ns/1ns
module LED_Wave_tb;
// IO port
reg left, right, sw, clk;
wire [9:0]led;
// import module
LED_Wave U1 (.Led(led), 
				 .Left(left), 
				 .Right(right), 
				 .Sw(sw), 
				 .Clk(clk));
				
initial begin
	clk = 1'b0;
	sw = 1'b1;
	left = 1'b1;
	right = 1'b0;
	# 5000000 left = 1'b0;
	right = 1'b1;
end

always #10 clk = ~clk;

endmodule 
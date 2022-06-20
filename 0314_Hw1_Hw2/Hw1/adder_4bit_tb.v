`timescale 1ns/1ns
module adder_4bit_tb;
// Input
reg [3:0] a, b;
reg cin;
// Output
wire [3:0] s;
wire cout;
// CLK 50MHz
reg clk_50MHz;
parameter clkper = 20; // 1period = 20ns
integer count = 0;
integer cincount = 0;
// Import Module
adder_4bit U1(.S(s), .Cout(cout), .A(a), .B(b), .Cin(cin));
// Initial value
initial begin
	clk_50MHz = 1'b0;
	cin = 1'b0;
	a 	 = 4'd0;
	b 	 = 4'd0;
end
// Generate CLK 50MHz
always begin
	#(clkper / 2) clk_50MHz = ~clk_50MHz;
end
// Modify value when positive edge CLK
always@(posedge clk_50MHz)begin
	b = b + 1;
	count = count + 1;
	cincount = cincount + 1;
	if(count == 16)begin
		a = a + 1;
		count = 0;
	end
	if(cincount == 256)begin
		cin = ~cin;
		cincount = 0;
	end
end

endmodule

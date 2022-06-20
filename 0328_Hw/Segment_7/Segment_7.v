module Segment_7(OUT, SEG, SEG_COM, CLK_1Hz, CLK_50MHz, Res);

output reg [4:0]OUT;
output reg [6:0]SEG = 7'b100_0000;
output reg [3:0]SEG_COM = 4'b1000;
output reg CLK_1Hz;
reg [27:0]CLK_1Hz_count = 0;

input CLK_50MHz, Res;

// 50MHz --> 1Hz = 1ns
always@(posedge CLK_50MHz)begin
	if(CLK_1Hz_count > 25000000)begin // 25000000 or 250
		CLK_1Hz = ~CLK_1Hz;
		CLK_1Hz_count = 0;
	end
	else CLK_1Hz_count = CLK_1Hz_count + 1;
end
// counter 0~9
always@(posedge CLK_1Hz or negedge Res)begin
	if(!Res) OUT <= 5'd0;
	else OUT <= (OUT==5'd9)?5'd0:(OUT + 5'd1);
end
// 7 Segment Display
always@(OUT)begin
	case(OUT) // seg-gfedcba "1" is on. // 0亮
		5'd0:SEG = 7'b100_0000;
		5'd1:SEG = 7'b111_1001;
		5'd2:SEG = 7'b010_0100;
		5'd3:SEG = 7'b011_0000;
		5'd4:SEG = 7'b001_1001;
		5'd5:SEG = 7'b001_0010;
		5'd6:SEG = 7'b000_0010;
		5'd7:SEG = 7'b101_1000;
		5'd8:SEG = 7'b000_0000;
		5'd9:SEG = 7'b001_1000;
		default:SEG = 7'b000_110;
	endcase
end
endmodule 
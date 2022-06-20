//----------------------------------------------------
//Design Name: Segment left
//File Name: Segment_left.v
//Function: 7 Segment shift left
//----------------------------------------------------
module Segment_left(SEG1, SEG2, SEG3, SEG4, SEG5, SEG6,
						  CLK_1Hz, CLK_50MHz, Res);
// output
output reg [6:0]SEG1, SEG2, SEG3, SEG4, SEG5, SEG6;
output reg CLK_1Hz;
// input
input CLK_50MHz, Res;
// register
reg [27:0]CLK_1Hz_count = 0;
// parameter
parameter A = 7'b100_0110, B = 7'b111_1001, C = 7'b100_0000,
			 D = 7'b111_1000, E = 7'b111_1001, F = 7'b011_0000,
			 G = 7'b100_0000, H = 7'b001_1001, I = 7'b000_0000,
			 X = 7'b111_1111;
reg [4:0]count = 5'd0;

// 50MHz --> 1Hz = 1s
always@(posedge CLK_50MHz)begin
	if(CLK_1Hz_count > 25000000)begin // (1Hz)25000000 or (10KHz)5000
		CLK_1Hz = ~CLK_1Hz;
		CLK_1Hz_count = 1'd0;
	end
	else CLK_1Hz_count = CLK_1Hz_count + 1;
end

// 7 Segment Display
always@(posedge CLK_1Hz or negedge Res)begin
	if(!Res)begin
		SEG6 = X;
		SEG5 = X;
		SEG4 = X;
		SEG3 = X;
		SEG2 = X;
		SEG1 = A;
		count = 5'd0;
	end
	else begin
		count = count + 1;
		case(count)
			5'd1:begin
				SEG6 = X;
				SEG5 = X;
				SEG4 = X;
				SEG3 = X;
				SEG2 = X;
				SEG1 = A;
			end
			5'd2:begin
				SEG6 = X;
				SEG5 = X;
				SEG4 = X;
				SEG3 = X;
				SEG2 = A;
				SEG1 = B;
			end
			5'd3:begin
				SEG6 = X;
				SEG5 = X;
				SEG4 = X;
				SEG3 = A;
				SEG2 = B;
				SEG1 = C;
			end
			5'd4:begin
				SEG6 = X;
				SEG5 = X;
				SEG4 = A;
				SEG3 = B;
				SEG2 = C;
				SEG1 = D;
			end
			5'd5:begin
				SEG6 = X;
				SEG5 = A;
				SEG4 = B;
				SEG3 = C;
				SEG2 = D;
				SEG1 = E;
			end
			5'd6:begin
				SEG6 = A;
				SEG5 = B;
				SEG4 = C;
				SEG3 = D;
				SEG2 = E;
				SEG1 = F;
			end
			5'd7:begin
				SEG6 = B;
				SEG5 = C;
				SEG4 = D;
				SEG3 = E;
				SEG2 = F;
				SEG1 = G;
			end
			5'd8:begin
				SEG6 = C;
				SEG5 = D;
				SEG4 = E;
				SEG3 = F;
				SEG2 = G;
				SEG1 = H;
			end
			5'd9:begin
				SEG6 = D;
				SEG5 = E;
				SEG4 = F;
				SEG3 = G;
				SEG2 = H;
				SEG1 = I;
			end
			5'd10:begin
				SEG6 = E;
				SEG5 = F;
				SEG4 = G;
				SEG3 = H;
				SEG2 = I;
				SEG1 = X;
			end
			5'd11:begin
				SEG6 = F;
				SEG5 = G;
				SEG4 = H;
				SEG3 = I;
				SEG2 = X;
				SEG1 = X;
			end
			5'd12:begin
				SEG6 = G;
				SEG5 = H;
				SEG4 = I;
				SEG3 = X;
				SEG2 = X;
				SEG1 = X;
			end
			5'd13:begin
				SEG6 = H;
				SEG5 = I;
				SEG4 = X;
				SEG3 = X;
				SEG2 = X;
				SEG1 = X;
			end
			5'd14:begin
				SEG6 = I;
				SEG5 = X;
				SEG4 = X;
				SEG3 = X;
				SEG2 = X;
				SEG1 = X;
				count = 4'd0;
			end
		endcase
	end
end
endmodule 
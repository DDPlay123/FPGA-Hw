//----------------------------------------------------
//Design Name: Traffic Light
//File Name: Traffic_Light.v
//Function: 紅綠燈
//----------------------------------------------------
module Traffic_Light_Seg(LED, Seg4, Seg3, Seg2, Seg1, Counter, CLK_50MHz, Road_SW, Res_n);
// output
output reg [4:0]LED;
output reg Counter;
output reg [6:0] Seg4 = 7'b100_0000, Seg3 = 7'b100_0000, 
					  Seg2 = 7'b100_0000, Seg1 = 7'b100_0000;
// intput
input	CLK_50MHz, Res_n;
input [2:0]Road_SW;
// reg
reg CLK_1Hz;
reg [24:0]CLK_count;
reg [4:0]count;
reg [3:0]temp1, temp2, temp3;
/******************Encoder******************/
// Binary to Seg
function [6:0]Encoder;
// input
input [3:0]In;
// Converter
begin
	case(In)
		4'd0:Encoder = 7'b100_0000;
		4'd1:Encoder = 7'b111_1001;
		4'd2:Encoder = 7'b010_0100;
		4'd3:Encoder = 7'b011_0000;
		4'd4:Encoder = 7'b001_1001;
		4'd5:Encoder = 7'b001_0010;
		4'd6:Encoder = 7'b000_0010;
		4'd7:Encoder = 7'b111_1000;
		4'd8:Encoder = 7'b000_0000;
		4'd9:Encoder = 7'b001_0000;
		4'd10:Encoder = 7'b000_1000;
		4'd11:Encoder = 7'b000_0011;
		4'd12:Encoder = 7'b100_0110;
		4'd13:Encoder = 7'b010_0001;
		4'd14:Encoder = 7'b000_0110;
		4'd15:Encoder = 7'b000_1110;
	endcase
end
endfunction
/**************************************************/
// 50MHz --> 1Hz(10KHz)
always@(posedge CLK_50MHz or negedge Res_n)begin
	if(!Res_n)begin
		CLK_1Hz = 1'b0;
		CLK_count = 25'd0;
	end
	else begin
		if(CLK_count < 25'd25000000) CLK_count = CLK_count + 25'd1; // (1Hz)25000000 or (10KHz)5000
		else begin
			CLK_1Hz = ~CLK_1Hz;
			CLK_count = 25'd0;
		end
	end
end
/**************************************************/
// LED & 7SEG Display
always@(posedge CLK_1Hz or negedge Res_n)begin
	if(!Res_n)begin
		count = 5'd0;
		Counter = 1'b0;
	end
	else begin
		Counter = ~Counter;
		case(Road_SW)
			// Road A
			3'b100:begin
				Seg4 = Encoder(4'd10);
				case(count)
					5'd0 :begin
						Seg1 = Encoder(4'd0);
						Seg2 = Encoder(4'd5);
						Seg3 = Encoder(4'd0);
						LED = 5'b00011;
						count = count + 1;
					end
					5'd1:begin
						Seg1 = Encoder(4'd0);
						Seg2 = Encoder(4'd4);
						Seg3 = Encoder(4'd0);
						LED = 5'b00011;
						count = count + 1;
					end
					5'd2:begin
						Seg1 = Encoder(4'd0);
						Seg2 = Encoder(4'd3);
						Seg3 = Encoder(4'd0);
						LED = 5'b00011;
						count = count + 1;
					end
					5'd3:begin
						Seg1 = Encoder(4'd0);
						Seg2 = Encoder(4'd2);
						Seg3 = Encoder(4'd0);
						LED = 5'b00011;
						count = count + 1;
					end
					5'd4:begin
						Seg1 = Encoder(4'd0);
						Seg2 = Encoder(4'd1);
						Seg3 = Encoder(4'd0);
						LED = 5'b00011;
						count = count + 1;
					end
					5'd5 :begin
						Seg1 = Encoder(4'd2);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd2);
						LED = 5'b01000;
						count = count + 1;
					end
					5'd6:begin
						Seg1 = Encoder(4'd1);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd1);
						LED = 5'b01000;
						count = count + 1;
					end
					5'd7 :begin
						Seg1 = Encoder(4'd13);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10100;
						count = count + 1;
					end
					5'd8:begin
						Seg1 = Encoder(4'd12);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10100;
						count = count + 1;
					end
					5'd9 :begin
						Seg1 = Encoder(4'd11);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd10:begin
						Seg1 = Encoder(4'd10);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd11:begin
						Seg1 = Encoder(4'd9);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd12:begin
						Seg1 = Encoder(4'd8);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd13:begin
						Seg1 = Encoder(4'd7);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd14:begin
						Seg1 = Encoder(4'd6);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd15:begin
						Seg1 = Encoder(4'd5);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd16:begin
						Seg1 = Encoder(4'd4);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd17:begin
						Seg1 = Encoder(4'd3);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd18:begin
						Seg1 = Encoder(4'd2);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd19:begin
						Seg1 = Encoder(4'd1);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd20:begin
						Seg1 = Encoder(4'd0);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b00011;
						count = 1'b0;
					end
				endcase
			end
			// Road B
			3'b010:begin
				Seg4 = Encoder(4'd11);
				case(count)
					5'd0 :begin
						Seg1 = Encoder(4'd14);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd1:begin
						Seg1 = Encoder(4'd13);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd2:begin
						Seg1 = Encoder(4'd12);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd3:begin
						Seg1 = Encoder(4'd11);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd4:begin
						Seg1 = Encoder(4'd10);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd5 :begin
						Seg1 = Encoder(4'd9);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd6:begin
						Seg1 = Encoder(4'd8);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd7 :begin
						Seg1 = Encoder(4'd7);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd8:begin
						Seg1 = Encoder(4'd6);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd9 :begin
						Seg1 = Encoder(4'd5);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd10:begin
						Seg1 = Encoder(4'd4);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd11:begin
						Seg1 = Encoder(4'd3);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd12:begin
						Seg1 = Encoder(4'd2);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd13:begin
						Seg1 = Encoder(4'd1);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd14:begin
						Seg1 = Encoder(4'd0);
						Seg2 = Encoder(4'd4);
						Seg3 = Encoder(4'd0);
						LED = 5'b00100;
						count = count + 1;
					end
					5'd15:begin
						Seg1 = Encoder(4'd0);
						Seg2 = Encoder(4'd3);
						Seg3 = Encoder(4'd0);
						LED = 5'b00100;
						count = count + 1;
					end
					5'd16:begin
						Seg1 = Encoder(4'd0);
						Seg2 = Encoder(4'd2);
						Seg3 = Encoder(4'd0);
						LED = 5'b00100;
						count = count + 1;
					end
					5'd17:begin
						Seg1 = Encoder(4'd0);
						Seg2 = Encoder(4'd1);
						Seg3 = Encoder(4'd0);
						LED = 5'b00100;
						count = count + 1;
					end
					5'd18:begin
						Seg1 = Encoder(4'd0);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd2);
						LED = 5'b01000;
						count = count + 1;
					end
					5'd19:begin
						Seg1 = Encoder(4'd0);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd1);
						LED = 5'b01000;
						count = count + 1;
					end
					5'd20:begin
						Seg1 = Encoder(4'd0);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = 1'b0;
					end
				endcase
			end
			// Road C
			3'b001:begin
				Seg4 = Encoder(4'd12);
				case(count)
					5'd0:begin
						Seg1 = Encoder(4'd9);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd1:begin
						Seg1 = Encoder(4'd8);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd2:begin
						Seg1 = Encoder(4'd7);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd3:begin
						Seg1 = Encoder(4'd6);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd4:begin
						Seg1 = Encoder(4'd5);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd5:begin
						Seg1 = Encoder(4'd4);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd6:begin
						Seg1 = Encoder(4'd3);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd7:begin
						Seg1 = Encoder(4'd2);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd8:begin
						Seg1 = Encoder(4'd1);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd9:begin
						Seg1 = Encoder(4'd0);
						Seg2 = Encoder(4'd4);
						Seg3 = Encoder(4'd0);
						LED = 5'b00100;
						count = count + 1;
					end
					5'd10:begin
						Seg1 = Encoder(4'd0);
						Seg2 = Encoder(4'd3);
						Seg3 = Encoder(4'd0);
						LED = 5'b00100;
						count = count + 1;
					end
					5'd11:begin
						Seg1 = Encoder(4'd0);
						Seg2 = Encoder(4'd2);
						Seg3 = Encoder(4'd0);
						LED = 5'b00100;
						count = count + 1;
					end
					5'd12:begin
						Seg1 = Encoder(4'd0);
						Seg2 = Encoder(4'd1);
						Seg3 = Encoder(4'd0);
						LED = 5'b00100;
						count = count + 1;
					end
					5'd13:begin
						Seg1 = Encoder(4'd0);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd1);
						LED = 5'b01000;
						count = count + 1;
					end
					5'd14:begin
						Seg1 = Encoder(4'd0);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd15:begin
						Seg1 = Encoder(4'd0);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd16:begin
						Seg1 = Encoder(4'd0);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd17:begin
						Seg1 = Encoder(4'd0);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd18:begin
						Seg1 = Encoder(4'd0);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd19:begin
						Seg1 = Encoder(4'd0);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = count + 1;
					end
					5'd20:begin
						Seg1 = Encoder(4'd0);
						Seg2 = Encoder(4'd0);
						Seg3 = Encoder(4'd0);
						LED = 5'b10000;
						count = 1'b0;
					end
				endcase
			end
		endcase
	end
end
endmodule 
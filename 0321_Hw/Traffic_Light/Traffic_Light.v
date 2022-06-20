//----------------------------------------------------
//Design Name: Traffic Light
//File Name: Traffic_Light.v
//Function: 紅綠燈
//----------------------------------------------------
module Traffic_Light(LED, Counter, CLK_50MHz, Road_SW, Res_n);
// output
output reg [4:0]LED;
output reg Counter;
// intput
input	CLK_50MHz, Res_n;
input [2:0]Road_SW;
// reg
reg CLK_1Hz;
reg [24:0]CLK_count;
reg [4:0]count;


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

// LED Display
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
				case(count)
					5'd0 :begin
						LED = 5'b00011;
						count = count + 1;
					end
					5'd5 :begin
						LED = 5'b01000;
						count = count + 1;
					end
					5'd7 :begin
						LED = 5'b10100;
						count = count + 1;
					end
					5'd9 :begin
						LED = 5'b10000;
						count = count + 1;
					end
					5'd13:begin
						LED = 5'b10000;
						count = count + 1;
					end
					5'd14:begin
						LED = 5'b10000;
						count = count + 1;
					end
					5'd18:begin
						LED = 5'b10000;
						count = count + 1;
					end
					5'd20:begin
						LED = 5'b00011;
						count = 1'b0;
					end
					default:
						count = count + 1;
				endcase
			end
			// Road B
			3'b010:begin
				case(count)
					5'd0 :begin
						LED = 5'b10000;
						count = count + 1;
					end
					5'd5 :begin
						LED = 5'b10000;
						count = count + 1;
					end
					5'd7 :begin
						LED = 5'b10000;
						count = count + 1;
					end
					5'd9 :begin
						LED = 5'b10000;
						count = count + 1;
					end
					5'd13:begin
						LED = 5'b10000;
						count = count + 1;
					end
					5'd14:begin
						LED = 5'b00100;
						count = count + 1;
					end
					5'd18:begin
						LED = 5'b01000;
						count = count + 1;
					end
					5'd20:begin
						LED = 5'b10000;
						count = 1'b0;
					end
					default:
						count = count + 1;
				endcase
			end
			// Road C
			3'b001:begin
				case(count)
					5'd0 :begin
						LED = 5'b10000;
						count = count + 1;
					end
					5'd5 :begin
						LED = 5'b10000;
						count = count + 1;
					end
					5'd7 :begin
						LED = 5'b10000;
						count = count + 1;
					end
					5'd9 :begin
						LED = 5'b00100;
						count = count + 1;
					end
					5'd13:begin
						LED = 5'b01000;
						count = count + 1;
					end
					5'd14:begin
						LED = 5'b10000;
						count = count + 1;
					end
					5'd18:begin
						LED = 5'b10000;
						count = count + 1;
					end
					5'd20:begin
						LED = 5'b10000;
						count = 1'b0;
					end
					default:
						count = count + 1;
				endcase
			end
		endcase
	end
end
endmodule 
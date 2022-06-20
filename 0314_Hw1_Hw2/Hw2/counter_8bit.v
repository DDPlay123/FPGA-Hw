//----------------------------------------------------
//Design Name: 8bit binary counter
//File Name: counter_8bit.v
//Function: 8位元二進制計數器
//----------------------------------------------------
module counter_8bit(LED, CLK_200KHz, CLK_50MHz, Res);

output reg [7:0]LED = 8'd255;
output reg CLK_200KHz;
input CLK_50MHz, Res;
reg [7:0]count = 8'd0;

// 50MHz --> 200KHz
always@(posedge CLK_50MHz) begin
	if(count < 8'd125) count = count + 1;
	else begin
		CLK_200KHz = ~CLK_200KHz;
		count = 8'd0;
	end
end
// Led Show
always@(posedge CLK_200KHz)begin
	case(Res)
		1'b0: LED = 8'd255;
		1'b1: LED = LED - 8'd1;
	endcase
end
endmodule

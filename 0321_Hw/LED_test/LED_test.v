module LED_test(LED, CLK_50MHz, Reset_n);

input  CLK_50MHz, Reset_n;
output reg [7:0]LED;
reg CLK_2Hz;
reg [23:0]CLK_count;

reg [2:0]state;

// 50MHz --> 2Hz
always@(posedge CLK_50MHz or negedge Reset_n)begin
	if(!Reset_n)begin
		CLK_2Hz = 1'd0;
		CLK_count = 24'd0;
	end
	else begin
		if(CLK_count < 12500000) 
			CLK_count = CLK_count + 24'd1;
		else begin
			CLK_2Hz = ~CLK_2Hz;
			CLK_count = 24'd0;
		end
	end
end
// LED Display
always@(posedge CLK_2Hz or negedge Reset_n)begin
	if(!Reset_n) state = 3'd0;
	else
		case(state)
			3'd0:begin LED = 8'b0000_0001;state = 3'd1;end
			3'd1:begin LED = 8'b0000_0010;state = 3'd2;end
			3'd2:begin LED = 8'b0000_0100;state = 3'd3;end
			3'd3:begin LED = 8'b0000_1000;state = 3'd4;end
			3'd4:begin LED = 8'b0001_0000;state = 3'd5;end
			3'd5:begin LED = 8'b0010_0000;state = 3'd6;end
			3'd6:begin LED = 8'b0100_0000;state = 3'd7;end
			3'd7:begin LED = 8'b1000_0000;state = 3'd0;end
		endcase
end

endmodule

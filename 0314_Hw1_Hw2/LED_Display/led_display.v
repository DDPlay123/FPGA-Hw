module led_display(LED, clk_50Mhz, clk_25Mhz, clk_count, res_n);

input  clk_50Mhz, res_n;
output reg [3:0]LED;
output reg clk_25Mhz;
output reg [7:0]clk_count;

reg [3:0]state;

// 50MHz --> 25MHz ，clk_count [0,1]
always@(posedge clk_50Mhz) begin
	if(clk_count < 1)
		clk_count = clk_count + 8'd1;
	else begin
		clk_25Mhz = ~clk_25Mhz;
		clk_count = 8'd0;
	end
end

// LED Display
always@(posedge clk_25Mhz or negedge res_n)begin
if(!res_n) begin 
	state = 4'd0;
	LED = 4'd0;
end
else
	case(state)
		4'd0 : begin LED=4'd0 ; state=4'd1; end 
		4'd1 : begin LED=4'd1 ; state=4'd2; end 
		4'd2 : begin LED=4'd2 ; state=4'd3; end 
		4'd3 : begin LED=4'd3 ; state=4'd4; end 
		4'd4 : begin LED=4'd4 ; state=4'd5; end 
		4'd5 : begin LED=4'd5 ; state=4'd6; end 
		4'd6 : begin LED=4'd6 ; state=4'd7; end 
		4'd7 : begin LED=4'd7 ; state=4'd8; end 
		4'd8 : begin LED=4'd8 ; state=4'd9; end 
		4'd9 : begin LED=4'd9 ; state=4'd10;end 
		4'd10: begin LED=4'd10; state=4'd11;end 
		4'd11: begin LED=4'd11; state=4'd12;end 
		4'd12: begin LED=4'd12; state=4'd13;end 
		4'd13: begin LED=4'd13; state=4'd14;end 
		4'd14: begin LED=4'd14; state=4'd15;end 
		4'd15: begin LED=4'd15; state=4'd0; end 
	endcase
end

endmodule 
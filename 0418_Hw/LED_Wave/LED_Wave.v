module LED_Wave(Led, Left, Right, Sw, Clk);
// IO Port
output reg [9:0]Led;
input Left, Right, Sw, Clk;

// Generate Clock Parameter
reg [18:0]Clk100_count;
reg [27:0]CLKn_count;
reg Clk_100 = 1'b0,
	 Clk_n 	= 1'b0;
	 
// Generate PWM Parameter
reg [20:0]Clk10_count,
			 Clk90_count;
reg Clk_100_10 = 1'b0,
	 Clk_100_90 = 1'b0;
	 
// Generate Clock
//4Hz(6250000) => 20KHz(10000) AND 8Hz(3125000) => 10KHz(5000)
always@(posedge Clk)begin
	if(!Sw)begin
		// 4Hz
		if(CLKn_count > 6250000)begin 
			Clk_n = ~Clk_n;
			CLKn_count = 0;
		end
		else CLKn_count = CLKn_count + 1;
	end
	else begin
		// 8Hz
		if(CLKn_count > 3125000)begin 
			Clk_n = ~Clk_n;
			CLKn_count = 0;
		end
		else CLKn_count = CLKn_count + 1;
	end
	// 100Hz / 50%
	if(Clk100_count > 500000)begin
		Clk_100 = ~Clk_100;
		// Inherit Clock
		Clk_100_10 = ~Clk_100_10;
		Clk_100_90 = ~Clk_100_90;
		Clk100_count = 0;
	end
	else Clk100_count = Clk100_count + 1;
// Generate 10、90% PWM
	// 10%
	if(Clk_100_10 == 1'b1)begin
		if(Clk10_count > 100000)begin
			Clk_100_10 = 1'b0;
			Clk10_count = 0;
		end
		else Clk10_count = Clk10_count + 1;
	end
	// 90%
	if(Clk_100_90 == 1'b0)begin
		Clk_100_90 = 1'b1;
		if(Clk90_count > 400000)begin
			Clk_100_90 = 1'b0;
			Clk90_count = 0;
		end
		else Clk90_count = Clk90_count + 1;
	end
end
// L/R State
reg [1:0]state;
reg [3:0]count = 4'd0;

always@(*)begin
	if(!Left)begin
		state = 3'b10;
	end
	if(!Right) begin
		state = 3'b01;
	end
end

always@(count)begin
	case(count)
		4'd0:begin 
			Led[0] = Clk_100_90;
			Led[9:1] = {9{Clk_100_10}};
		end
		4'd1:begin
			Led[0] = Clk_100_10;
			Led[1] = Clk_100_90;
			Led[9:2] = {8{Clk_100_10}};
		end
		4'd2:begin
			Led[1:0] = {2{Clk_100_10}};
			Led[2] = Clk_100_90;
			Led[9:3] = {7{Clk_100_10}};
		end
		4'd3:begin
			Led[2:0] = {3{Clk_100_10}};
			Led[3] = Clk_100_90;
			Led[9:4] = {6{Clk_100_10}};
		end
		4'd4:begin
			Led[3:0] = {4{Clk_100_10}};
			Led[4] = Clk_100_90;
			Led[9:5] = {5{Clk_100_10}};
		end
		4'd5:begin
			Led[4:0] = {5{Clk_100_10}};
			Led[5] = Clk_100_90;
			Led[9:6] = {4{Clk_100_10}};
		end
		4'd6:begin
			Led[5:0] = {6{Clk_100_10}};
			Led[6] = Clk_100_90;
			Led[9:7] = {3{Clk_100_10}};
		end
		4'd7:begin
			Led[6:0] = {7{Clk_100_10}};
			Led[7] = Clk_100_90;
			Led[9:8] = {2{Clk_100_10}};
		end
		4'd8:begin
			Led[7:0] = {8{Clk_100_10}};
			Led[8] = Clk_100_90;
			Led[9] = Clk_100_10;
		end
		4'd9:begin
			Led[8:0] = {9{Clk_100_10}};
			Led[9] = Clk_100_90;
		end
	endcase
end
// Display LED
always@(posedge Clk_n)begin
	case(state)
		3'b10:begin
			count <= (count == 4'd9) ? 4'd0 : (count + 4'd1);
		end
		3'b01:begin
			count <= (count == 4'd0) ? 4'd9 : (count - 4'd1);
		end
	endcase
end

endmodule 
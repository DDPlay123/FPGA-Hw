module LED_10Period(Led, Sw, Clk_50M);

output reg Led;
input Sw, Clk_50M;

reg [27:0]Clk_count = 0;
reg [22:0]Clk50_count = 0;
reg Clk_50 = 1'b0;

always@(posedge Clk_50M)begin
	// 50MHz --> 50Hz
	if(Clk_count > 1000000)begin // (1Hz)25000000 or (50Hz)1000000
		Clk_50 = ~Clk_50; // 50%
		Clk_count = 0;
	end
	else begin
		Clk_count = Clk_count + 1;
	end
	// 10%
	if(Clk_50 == 1'b1)begin
		if(Clk50_count > 200000)begin
			Clk_50 = 1'b0;
			Clk50_count = 0;
		end
		else
			Clk50_count = Clk50_count + 1;
	end
end

always@(*)begin
	if(!Sw)begin
		Led = 1'b0;
	end
	else begin
		Led = Clk_50;
	end
end

endmodule 
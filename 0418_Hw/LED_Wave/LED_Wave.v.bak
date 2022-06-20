module LED_duty(Led90, Led50, Led10, Key, Clk_50M);

output reg Led90, Led50, Led10;
input Key, Clk_50M;

reg [2:0]Key_count = 3'd0;
reg [27:0]Clk_count = 0;

reg [22:0]Clk10_count = 0;
reg [22:0]Clk90_count = 0;
reg Clk_50 = 1'b0;
reg Clk_10 = 1'b0;
reg Clk_90 = 1'b0;

always@(negedge Key)begin
	if(!Key)begin
		Key_count = Key_count + 3'd1;
		if(Key_count > 3'd3) Key_count = 3'd0;
	end
end

always@(posedge Clk_50M)begin
	// 50MHz --> 100Hz
	if(Clk_count > 500000)begin // (100Hz)500000
		Clk_50 = ~Clk_50; // 50%
		Clk_10 = ~Clk_10;
		Clk_90 = ~Clk_10;
		Clk_count = 0;
	end
	else begin
		Clk_count = Clk_count + 1;
	end
	// 10%
	if(Clk_10 == 1'b1)begin
		if(Clk10_count > 100000)begin
			Clk_10 = 1'b0;
			Clk10_count = 0;
		end
		else
			Clk10_count = Clk10_count + 1;
	end
	// 90%
	if(Clk_90 == 1'b0)begin
		Clk_90 = 1'b1;
		if(Clk90_count > 100000)begin
			Clk_90 = 1'b0;
			Clk90_count = 0;
		end
		else
			Clk90_count = Clk90_count + 1;
	end
end

always@(*)begin
	case(Key_count)
		3'd0:begin
			Led90 = 1'b0;
			Led50 = 1'b0;
			Led10 = 1'b0;
		end
		3'd1:begin
			Led90 = 1'b0;
			Led50 = 1'b0;
			Led10 = Clk_10;
		end
		3'd2:begin
			Led90 = 1'b0;
			Led50 = Clk_50;
			Led10 = Clk_10;
		end
		3'd3:begin
			Led90 = Clk_90;
			Led50 = Clk_50;
			Led10 = Clk_10;
		end
	endcase
end

endmodule 
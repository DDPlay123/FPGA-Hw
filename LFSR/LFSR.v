module LFSR(clk, rand_num, out);

input clk;
output reg [7:0]rand_num = 8'b1001_0111;
output reg [2:0]out = 3'b000;

always@(posedge clk)begin
	rand_num[0] <= rand_num[7];
	rand_num[1] <= rand_num[0];
	rand_num[2] <= rand_num[1];
	rand_num[3] <= rand_num[2];
	rand_num[4] <= rand_num[3]^rand_num[7];
	rand_num[5] <= rand_num[4]^rand_num[7];
	rand_num[6] <= rand_num[5]^rand_num[7];
	rand_num[7] <= rand_num[6];
	if(rand_num % 2 == 0) out[2] = 1;
	else out[2] = 0;
	if(rand_num % 3 == 0) out[1] = 1;
	else out[1] = 0;
	if(rand_num % 5 == 0) out[0] = 1;
	else out[0] = 0;
end

endmodule

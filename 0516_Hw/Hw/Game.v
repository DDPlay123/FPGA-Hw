module Game (RGB, VGA_CLK, VGA_BLANK_N, 
				 VGA_HS, VGA_VS, VGA_SYNC_N,
				 Clk_50MHz);
// Output for VGA
output reg [23:0]RGB;
output reg VGA_CLK = 1'b0, 
			  VGA_BLANK_N, VGA_HS, VGA_VS, 
			  VGA_SYNC_N = 1'b0;
// Input for Clock 50MHz
input Clk_50MHz;
//---------------------------------------------------- Generate Clock 1Hz
reg CLK_1 = 1'b0;
reg [27:0]CLK_count = 0;
always@(posedge Clk_50MHz)begin
	if(CLK_count > 25000000)begin // (1Hz) 25000000
		CLK_1 = ~CLK_1; CLK_count = 0;
	end else CLK_count = CLK_count + 1;
end
//---------------------------------------------------- Background Color
reg [2:0]state = 0;
always@(posedge CLK_1)begin
	state <= (state == 3'd2) ? 3'd0 : (state + 3'd1);
end
//---------------------------------------------------- VGA Scan Sync
// 25MHz -> 40ns
always@(posedge Clk_50MHz)begin
	VGA_CLK = ~VGA_CLK;
end
// Screen SCAN
reg [9:0]hor_counter, 
		   ver_counter;
always@(posedge VGA_CLK)begin
	// Horizontal Scan
	if(hor_counter == 795) hor_counter = 0;
	else hor_counter = hor_counter + 1;
	// Vertical Scan
	if(ver_counter == 523 && hor_counter == 700) ver_counter = 0;
	else if(hor_counter == 700) ver_counter = ver_counter + 1;
	// Horizontal Signal
	if(hor_counter >= 658 && hor_counter <= 753) VGA_HS = 1'b0;
	else VGA_HS = 1'b1;
	// Vertical Signal
	if(ver_counter >= 491 && ver_counter <= 492) VGA_VS = 1'b0;
	else VGA_VS = 1'b1;
	// Output RGB Data
	if(hor_counter >= 0 && hor_counter <= 639) VGA_BLANK_N = 1'b1;
	else VGA_BLANK_N = 1'b0;
	
end
//---------------------------------------------------- Display
reg [9:0]x_Elf, y_Elf, x_Boss, y_Boss, x_Cus, y_Cus;
reg [11:0]X_Elf, Y_Elf;
reg [12:0]X_Boss, Y_Boss;
reg [15:0]Z_Boss, X_Cus;
always@(*)begin
	// 圖形的起始位置，根據位置定義圖形的矩陣。
	if(hor_counter > 10 && ver_counter > 100) begin
		x_Elf = (hor_counter - 11)/5;
		y_Elf = (ver_counter - 101)/5;
		X_Elf = dataX_Elf[x_Elf][y_Elf];
		Y_Elf = dataY_Elf[x_Elf][y_Elf];
		if(hor_counter > 100) begin
			x_Boss = (hor_counter - 101)/5;
			y_Boss = (ver_counter - 101)/5;
			X_Boss = dataX_Boss[x_Boss][y_Boss];
			Y_Boss = dataY_Boss[x_Boss][y_Boss];
			Z_Boss = dataZ_Boss[x_Boss][y_Boss];
			if(hor_counter > 200) begin
				x_Cus = (hor_counter - 201)/5;
				y_Cus = (ver_counter - 101)/5;
				X_Cus = dataX_Cus[x_Cus][y_Cus];
			end
		end
	end 
	// 當座標超過圖形矩陣的範圍時，圖形的矩陣要清空，才不會重複輸出。
	if(x_Elf > 10 || y_Elf > 11) begin
		X_Elf = 0;
		Y_Elf = 0;
	end
	if(x_Boss > 11 || y_Boss > 12) begin
		X_Boss = 0;
		Y_Boss = 0;
		Z_Boss = 0;
	end
	if(x_Cus > 15 || y_Cus > 15) begin
		X_Cus = 0;
	end
	// 根據圖形的矩陣，當矩陣中出現為High時，輸出特定的顏色。
	if(X_Elf == 1) begin
		RGB = 24'hFFFF00;
	end else if(Y_Elf == 1) begin
		RGB = 24'h000000;
	end else if(X_Boss == 1) begin
		RGB = 24'h4F81BD;
	end else if(Y_Boss == 1) begin
		RGB = 24'hD9D9D9;
	end else if(Z_Boss == 1) begin
		RGB = 24'h000000;
	end else if(X_Cus == 1) begin
		RGB = 24'h00FFFF;
	end else begin // 背景顏色
		case(state)
			3'd0:RGB = 24'hAA0000;
			3'd1:RGB = 24'h00AA00;
			3'd2:RGB = 24'h0000AA;
			default:RGB = 24'hFFFFFF;
		endcase
	end
	// 歸零座標。
	x_Elf = 0;
	y_Elf = 0;
	x_Boss = 0;
	y_Boss = 0;
	x_Cus = 0;
	y_Cus = 0;
end
//---------------------------------------------------- Paint SQL
// Elf paint
reg [11:0] dataX_Elf[0:10],
			  dataY_Elf[0:10];
// Boss paint
reg [12:0] dataX_Boss[0:11],
			  dataY_Boss[0:11],
			  dataZ_Boss[0:11];
// Custom paint
reg [15:0] dataX_Cus[0:9];

always@(*)begin
	// Elf Body
	dataX_Elf[0]  = 12'b000011110000;
	dataX_Elf[1]  = 12'b001111111100;
	dataX_Elf[2]  = 12'b011111111110;
	dataX_Elf[3]  = 12'b011111111110;
	dataX_Elf[4]  = 12'b111110011111;
	dataX_Elf[5]  = 12'b111110011111;
	dataX_Elf[6]  = 12'b111100001101;
	dataX_Elf[7]  = 12'b111100001111;
	dataX_Elf[8]  = 12'b011100001110;
	dataX_Elf[9]  = 12'b011000000110;
	dataX_Elf[10] = 12'b001000000100;
	// Elf Eye
	{dataY_Elf[0], dataY_Elf[1], dataY_Elf[2], 
	 dataY_Elf[3], dataY_Elf[4], dataY_Elf[5],
	 dataY_Elf[7], dataY_Elf[8], dataY_Elf[9], dataY_Elf[10]} = {10{12'b000000000000}};
	dataY_Elf[6]  = 12'b000000000010;
	// Boss Body
	{dataX_Boss[0], dataX_Boss[11]} = {2{13'b1111111100000}};
	{dataX_Boss[1], dataX_Boss[10]} = {2{13'b0111011111000}};
	{dataX_Boss[2], dataX_Boss[9]}  = {2{13'b0011101111100}};
	{dataX_Boss[3], dataX_Boss[8]}  = {2{13'b0111101111110}};
	{dataX_Boss[4], dataX_Boss[7]}  = {2{13'b1111011101111}};
	{dataX_Boss[5], dataX_Boss[6]}  = {2{13'b0011101111111}};
	// Boss mouth
	{dataY_Boss[0], dataY_Boss[11]} = {2{13'b0000000000000}};
	{dataY_Boss[1], dataY_Boss[10]} = {2{13'b0000100000000}};
	{dataY_Boss[2], dataY_Boss[9]}  = {2{13'b0000010000000}};
	{dataY_Boss[3], dataY_Boss[8]}  = {2{13'b0000010000000}};
	{dataY_Boss[4], dataY_Boss[7]}  = {2{13'b0000100000000}};
	{dataY_Boss[5], dataY_Boss[6]}  = {2{13'b0000010000000}};
	// Boss eye
	{dataZ_Boss[0], dataZ_Boss[1], dataZ_Boss[2],
	 dataZ_Boss[3], dataZ_Boss[5], dataZ_Boss[6],
	 dataZ_Boss[8], dataZ_Boss[9], dataZ_Boss[10], dataZ_Boss[11]}  = {10{13'b0000000000000}};
	{dataZ_Boss[4], dataZ_Boss[7]}  = {2{13'b0000000010000}};
	// Custom Body
	{dataX_Cus[0], dataX_Cus[9]} = {2{16'b0000_0111_1100_0000}};
	{dataX_Cus[1], dataX_Cus[8]} = {2{16'b1100_1111_1110_0000}};
	{dataX_Cus[2], dataX_Cus[7]} = {2{16'b1110_0001_1110_0110}};
	{dataX_Cus[3], dataX_Cus[6]} = {2{16'b1111_1111_1110_1111}};
	{dataX_Cus[4], dataX_Cus[5]} = {2{16'b0000_1111_1111_1111}};
end

endmodule 
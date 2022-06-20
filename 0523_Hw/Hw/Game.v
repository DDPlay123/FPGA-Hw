module Game (RGB, VGA_CLK, VGA_BLANK_N, 
				 VGA_HS, VGA_VS, VGA_SYNC_N,
				 Clk_50MHz, Key);
// Output for VGA
output reg [23:0]RGB;
output reg VGA_CLK = 1'b0, 
			  VGA_BLANK_N, VGA_HS, VGA_VS, 
			  VGA_SYNC_N = 1'b0;
// Input for Clock 50MHz
input Clk_50MHz;
// Input for Key >>Key[3] = Up, Key[2] = Down, Key[1] = Left, Key[0] = Right
input [3:0]Key;
//---------------------------------------------------- Moving Boss
reg [9:0]xB = 210, yB = 99;
reg [9:0]xBc, yBc;
reg [3:0]state_Boss;
always@(posedge CLK_64)begin
	// Boss State
	if(xB == 210 && yB ==  99) state_Boss = 4'b0001;
	if(xB == 416 && yB ==  99) state_Boss = 4'b0010;
	if(xB == 416 && yB == 296) state_Boss = 4'b0100;
	if(xB == 210 && yB == 296) state_Boss = 4'b1000;
	if(SE == 1'b1) state_Boss = 4'b1111;
	// Get Boss center point
	xBc = xB + 11; yBc = yB + 12;
	case(state_Boss)
		4'b0001: xB = xB + 1;
		4'b0010: yB = yB + 1;
		4'b0100: xB = xB - 1;
		4'b1000: yB = yB - 1;
		4'b1111:begin
			xB = xB; yB = yB;
		end
	endcase
end
//---------------------------------------------------- Moving Control
reg [9:0]x = 220, y = 200;
reg [9:0]xc, yc;
reg [3:0]state;
always@(posedge CLK_64)begin
	// Check Elf eat food
	if((x + 12) >= 251 && (x + 12) <= 273 && (y + 1) >= 201 && (y + 1) <= 223) HF[0] = 1'b1; 
	if((x + 12) >= 282 && (x + 12) <= 304 && (y + 1) >= 201 && (y + 1) <= 223) HF[1] = 1'b1; 
	if((x + 12) >= 310 && (x + 12) <= 342 && (y + 1) >= 201 && (y + 1) <= 223) HF[2] = 1'b1; 
	if((x + 12) >= 347 && (x + 12) <= 369 && (y + 1) >= 201 && (y + 1) <= 223) HF[3] = 1'b1; 
	if((x + 12) >= 377 && (x + 12) <= 399 && (y + 1) >= 201 && (y + 1) <= 223) HF[4] = 1'b1; 
	if((x + 12) >= 310 && (x + 12) <= 342 && (y + 1) >= 137 && (y + 1) <= 159) VF[0] = 1'b1; 
	if((x + 12) >= 310 && (x + 12) <= 342 && (y + 1) >= 170 && (y + 1) <= 192) VF[1] = 1'b1; 
	if((x + 12) >= 310 && (x + 12) <= 342 && (y + 1) >= 232 && (y + 1) <= 254) VF[3] = 1'b1; 
	if((x + 12) >= 310 && (x + 12) <= 342 && (y + 1) >= 265 && (y + 1) <= 287) VF[4] = 1'b1;
	// Get Elf corner
	xc = x + 24; yc = y + 24;
	// Move Elf
	if(SE == 1'b0)begin
		if(!Key[0])begin
			state = 4'b0001;
			//x = (x == 418) ? 418 : (x + 1);
			if((x + 24) == 304 && (y + 24) > 137 && y < 192 ||
				(x + 24) == 304 && (y + 24) > 232 && y < 285 ||
				(x + 24) == 347 && (y + 24) > 137 && y < 192 ||
				(x + 24) == 347 && (y + 24) > 232 && y < 285 ||
				(x + 24) == 442 && (y + 24) >  97 && y < 325   )
				x = x;
			else x = x + 1;
		end else if(!Key[1])begin
			state = 4'b0010;
			//x = (x == 208) ? 208 : (x - 1);
			if(x == 304 && (y + 24) > 137 && y < 192 ||
				x == 304 && (y + 24) > 232 && y < 285 ||
				x == 347 && (y + 24) > 137 && y < 192 ||
				x == 347 && (y + 24) > 232 && y < 285 ||
				x == 208 && (y + 24) >  97 && y < 325   )
				x = x;
			else x = x - 1;
		end else if(!Key[2])begin
			state = 4'b0100;
			//y = (y == 301) ? 301 : (y + 1);
			if((y + 24) == 192 && (x + 24) > 251 && x < 304 ||
				(y + 24) == 232 && (x + 24) > 251 && x < 304 ||
				(y + 24) == 192 && (x + 24) > 347 && x < 399 ||
				(y + 24) == 232 && (x + 24) > 347 && x < 399 ||
				(y + 24) == 325 && (x + 24) > 208 && x < 442   )
				y = y;
			else y = y + 1;
		end else if(!Key[3])begin
			state = 4'b1000;
			//y = (y ==  97) ?  97 : (y - 1);
			if(y == 192 && (x + 24) > 251 && x < 304 ||
				y == 232 && (x + 24) > 251 && x < 304 ||
				y == 192 && (x + 24) > 347 && x < 399 ||
				y == 232 && (x + 24) > 347 && x < 399 ||
				y ==  97 && (x + 24) > 208 && x < 442   )
				y = y;
			else y = y - 1;
		end
	end
end
//---------------------------------------------------- Display
reg SE = 1'b0; // for Check Elf and Boss Coordnate
reg [4:0]HF = 5'b0; // for Check Elf and horizontal Food Coordnate
reg [4:0]VF = 5'b0; // for Check Elf and vertical Food Coordnate
// CCoordnate Data by Elf and Boss and Food
reg [9:0]x_Elf, y_Elf, x_Boss, y_Boss;
reg [9:0]x1_Food_1, y1_Food_1, x2_Food_1, y2_Food_1,
			x1_Food_2, y1_Food_2, x2_Food_2, y2_Food_2,
			x1_Food_3, y1_Food_3, x2_Food_3, y2_Food_3,
			x1_Food_4, y1_Food_4, x2_Food_4, y2_Food_4,
			x1_Food_5, y1_Food_5, x2_Food_5, y2_Food_5;
// Paint Data by Elf and Boss and Food
reg [11:0]X_Elf, Y_Elf;
reg [12:0]X_Boss, Y_Boss, Z_Boss;
reg [10:0]X_Food_1, Y_Food_1, X_Food_2, Y_Food_2, X_Food_3, Y_Food_3, 
			 X_Food_4, Y_Food_4, X_Food_5, Y_Food_5;
always@(*)begin
	//---------------------------------------------------------------
	// Elf
	if(hor_counter > x && ver_counter > y && SE == 1'b0) begin
		x_Elf = (hor_counter - (x + 1))/2;
		y_Elf = (ver_counter - (y + 1))/2;
		case(state)
			4'b0001: X_Elf = dataX_Elf[x_Elf][y_Elf]; Y_Elf = dataY_Elf[x_Elf][y_Elf];
			4'b0010: X_Elf = dataW_Elf[x_Elf][y_Elf]; Y_Elf = dataZ_Elf[x_Elf][y_Elf];
			4'b0100: X_Elf = dataX_Elf[y_Elf][x_Elf]; Y_Elf = dataY_Elf[y_Elf][x_Elf];
			4'b1000: X_Elf = dataW_Elf[y_Elf][x_Elf]; Y_Elf = dataZ_Elf[y_Elf][x_Elf];
		endcase
	end 
	//---------------------------------------------------------------
	// Horizontal Food
	if(hor_counter > 250 && ver_counter > 200)begin
		x1_Food_1 = (hor_counter - 251)/2;
		y1_Food_1 = (ver_counter - 201)/2;
		X_Food_1 = dataX_Food[x1_Food_1][y1_Food_1];
		if(hor_counter > 281) begin
			x1_Food_2 = (hor_counter - 282)/2;
			y1_Food_2 = (ver_counter - 201)/2;
			X_Food_2 = dataX_Food[x1_Food_2][y1_Food_2];
			if(hor_counter > 314) begin
				x1_Food_3 = (hor_counter - 315)/2;
				y1_Food_3 = (ver_counter - 201)/2;
				X_Food_3 = dataX_Food[x1_Food_3][y1_Food_3];
				if(hor_counter > 346) begin
					x1_Food_4 = (hor_counter - 347)/2;
					y1_Food_4 = (ver_counter - 201)/2;
					X_Food_4 = dataX_Food[x1_Food_4][y1_Food_4];
					if(hor_counter > 376) begin
						x1_Food_5 = (hor_counter - 377)/2;
						y1_Food_5 = (ver_counter - 201)/2;
						X_Food_5 = dataX_Food[x1_Food_5][y1_Food_5];
					end
				end
			end
		end
	end
	// Vertical Food
	if(hor_counter > 314 && ver_counter > 136)begin
		x2_Food_1 = (hor_counter - 315)/2;
		y2_Food_1 = (ver_counter - 137)/2;
		Y_Food_1 = dataX_Food[x2_Food_1][y2_Food_1];
		if(ver_counter > 169) begin
			x2_Food_2 = (hor_counter - 315)/2;
			y2_Food_2 = (ver_counter - 170)/2;
			Y_Food_2 = dataX_Food[x2_Food_2][y2_Food_2];
			if(ver_counter > 200) begin
				x2_Food_3 = (hor_counter - 315)/2;
				y2_Food_3 = (ver_counter - 201)/2;
				Y_Food_3 = dataX_Food[x2_Food_3][y2_Food_3];
				if(ver_counter > 231) begin
					x2_Food_4 = (hor_counter - 315)/2;
					y2_Food_4 = (ver_counter - 232)/2;
					Y_Food_4 = dataX_Food[x2_Food_4][y2_Food_4];
					if(ver_counter > 264) begin
						x2_Food_5 = (hor_counter - 315)/2;
						y2_Food_5 = (ver_counter - 265)/2;
						Y_Food_5 = dataX_Food[x2_Food_5][y2_Food_5];
					end
				end
			end
		end
	end
	//---------------------------------------------------------------
	// Boss
	if(hor_counter > xB && ver_counter > yB)begin
		x_Boss = (hor_counter - (xB + 1))/2;
		y_Boss = (ver_counter - (yB + 1))/2;
		X_Boss = dataX_Boss[x_Boss][y_Boss];
		Y_Boss = dataY_Boss[x_Boss][y_Boss];
		Z_Boss = dataZ_Boss[x_Boss][y_Boss];
	end
	//---------------------------------------------------------------
	// Elf touch Boss event
	if(xBc >= x && xBc <= xc && yBc >= y && yBc <= yc) SE = 1'b1;
	else SE = 1'b0;
	//---------------------------------------------------------------
	// Graph range for x or y
	if(x_Elf > 11 || y_Elf > 11) begin
		X_Elf = 0; Y_Elf = 0;
	end
	// Horizontal Food
	if(x1_Food_1 > 10 || y1_Food_1 > 10) begin
		X_Food_1 = 0; 
	end
	if(x1_Food_2 > 10 || y1_Food_2 > 10) begin
		X_Food_2 = 0; 
	end
	if(x1_Food_3 > 10 || y1_Food_3 > 10) begin
		X_Food_3 = 0; 
	end
	if(x1_Food_4 > 10 || y1_Food_4 > 10) begin
		X_Food_4 = 0; 
	end
	if(x1_Food_5 > 10 || y1_Food_5 > 10) begin
		X_Food_5 = 0; 
	end
	// Vertical Food
	if(x2_Food_1 > 10 || y2_Food_1 > 10) begin
		Y_Food_1 = 0;
	end
	if(x2_Food_2 > 10 || y2_Food_2 > 10) begin
		Y_Food_2 = 0;
	end
	if(x2_Food_3 > 10 || y2_Food_3 > 10) begin
		Y_Food_3 = 0;
	end
	if(x2_Food_4 > 10 || y2_Food_4 > 10) begin
		Y_Food_4 = 0;
	end
	if(x2_Food_5 > 10 || y2_Food_5 > 10) begin
		Y_Food_5 = 0;
	end
	if(x_Boss > 11 || y_Boss > 12) begin
		X_Boss = 0; Y_Boss = 0; Z_Boss = 0;
	end
	//---------------------------------------------------------------
	// Graph Color
	if(X_Elf == 1) 	   RGB = 24'hFFFF00;
	else if(Y_Elf == 1)  RGB = 24'h000000;
	else if(X_Boss == 1) RGB = 24'h4F81BD;
	else if(Y_Boss == 1) RGB = 24'hD9D9D9;
	else if(Z_Boss == 1) RGB = 24'h000000;
	else if(X_Food_1 == 1) begin
		if(HF[0] == 1'b1) begin
			RGB = 24'h000000;
		end else begin
			RGB = 24'h92CD50;
		end
	end else if(X_Food_2 == 1) begin
		if(HF[1] == 1'b1) begin
			RGB = 24'h000000;
		end else begin
			RGB = 24'h92CD50;
		end
	end else if(X_Food_3 == 1) begin
		if(HF[2] == 1'b1) begin
			RGB = 24'h000000;
		end else begin
			RGB = 24'h92CD50;
		end
	end else if(X_Food_4 == 1) begin
		if(HF[3] == 1'b1) begin
			RGB = 24'h000000;
		end else begin
			RGB = 24'h92CD50;
		end
	end else if(X_Food_5 == 1) begin
		if(HF[4] == 1'b1) begin
			RGB = 24'h000000;
		end else begin
			RGB = 24'h92CD50;
		end
	end else if(Y_Food_1 == 1) begin
		if(VF[0] == 1'b1) begin
			RGB = 24'h000000;
		end else begin
			RGB = 24'h92CD50;
		end
	end else if(Y_Food_2 == 1) begin
		if(VF[1] == 1'b1) begin
			RGB = 24'h000000;
		end else begin
			RGB = 24'h92CD50;
		end
	end else if(Y_Food_4 == 1) begin
		if(VF[3] == 1'b1) begin
			RGB = 24'h000000;
		end else begin
			RGB = 24'h92CD50;
		end
	end else if(Y_Food_5 == 1) begin
		if(VF[4] == 1'b1) begin
			RGB = 24'h000000;
		end else begin
			RGB = 24'h92CD50;
		end
	//---------------------------------------------------------------
	// Bounding Line Color
	end else if(// Food horizontal Line
					(ver_counter == 192  && hor_counter >= 251 && hor_counter <= 304) || 
					(ver_counter == 192  && hor_counter >= 347 && hor_counter <= 399) || 
					(ver_counter == 232  && hor_counter >= 251 && hor_counter <= 304) || 
					(ver_counter == 232  && hor_counter >= 347 && hor_counter <= 399) || 
					// Food vertical Line
					(hor_counter == 304  && ver_counter >= 137 && ver_counter <= 192) ||   
					(hor_counter == 304  && ver_counter >= 232 && ver_counter <= 285) || 
					(hor_counter == 347  && ver_counter >= 137 && ver_counter <= 192) ||
					(hor_counter == 347  && ver_counter >= 232 && ver_counter <= 285) ||
					// Boss vertical Line
					(hor_counter == 208  && ver_counter >=  97 && ver_counter <  325) ||
					(hor_counter == 442  && ver_counter >=  97 && ver_counter <  325) ||
					// Boss horizontal Line
					(ver_counter ==  97  && hor_counter >= 208 && hor_counter <= 442) ||
					(ver_counter == 325  && hor_counter >= 208 && hor_counter <= 442)
					) begin
		RGB = 24'h2891FA;
	//---------------------------------------------------------------
	// Background Color
	end else begin
		RGB = 24'h000000;
	end
end
//---------------------------------------------------- Generate Clock 64Hz
reg CLK_64 = 1'b0;
reg [27:0]CLK64_count = 0;
always@(posedge Clk_50MHz)begin
	if(CLK64_count > 390625)begin // (64Hz) 390625
		CLK_64 = ~CLK_64; CLK64_count = 0;
	end else CLK64_count = CLK64_count + 1;
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
//---------------------------------------------------- Graph SQL
// Elf graph
reg [11:0] dataX_Elf[0:11],
			  dataY_Elf[0:11],
			  dataW_Elf[0:11],
			  dataZ_Elf[0:11];
// Boss graph
reg [12:0] dataX_Boss[0:11],
			  dataY_Boss[0:11],
			  dataZ_Boss[0:11];
// Food graph
reg [10:0] dataX_Food[0:10];

always@(*)begin
	// Elf Body
	dataX_Elf[0]  = 12'b000000000000; dataW_Elf[0]  = 12'b001000000100;
	dataX_Elf[1]  = 12'b000011110000; dataW_Elf[1]  = 12'b011000000110;
	dataX_Elf[2]  = 12'b001111111100; dataW_Elf[2]  = 12'b011100001110;
	dataX_Elf[3]  = 12'b011111111110; dataW_Elf[3]  = 12'b111100001111;
	dataX_Elf[4]  = 12'b011111111110; dataW_Elf[4]  = 12'b111100001101;
	dataX_Elf[5]  = 12'b111110011111; dataW_Elf[5]  = 12'b111110011111;
	dataX_Elf[6]  = 12'b111110011111; dataW_Elf[6]  = 12'b111110011111;
	dataX_Elf[7]  = 12'b111100001101; dataW_Elf[7]  = 12'b011111111110;
	dataX_Elf[8]  = 12'b111100001111; dataW_Elf[8]  = 12'b011111111110;
	dataX_Elf[9]  = 12'b011100001110; dataW_Elf[9]  = 12'b001111111100;
	dataX_Elf[10] = 12'b011000000110; dataW_Elf[10] = 12'b000011110000;
	dataX_Elf[11] = 12'b001000000100; dataW_Elf[11] = 12'b000000000000;
	// Elf Eye
	dataY_Elf[0]  = 12'b000000000000; dataZ_Elf[0]   = 12'b000000000000;
	dataY_Elf[1]  = 12'b000000000000; dataZ_Elf[1]   = 12'b000000000000;
	dataY_Elf[2]  = 12'b000000000000; dataZ_Elf[2]   = 12'b000000000000;
	dataY_Elf[3]  = 12'b000000000000; dataZ_Elf[3]   = 12'b000000000000;
	dataY_Elf[4]  = 12'b000000000000; dataZ_Elf[4]   = 12'b000000000010;
	dataY_Elf[5]  = 12'b000000000000; dataZ_Elf[5]   = 12'b000000000000;
	dataY_Elf[6]  = 12'b000000000000; dataZ_Elf[6]   = 12'b000000000000;
	dataY_Elf[7]  = 12'b000000000010; dataZ_Elf[7]   = 12'b000000000000;
	dataY_Elf[8]  = 12'b000000000000; dataZ_Elf[8]   = 12'b000000000000;
	dataY_Elf[9]  = 12'b000000000000; dataZ_Elf[9]   = 12'b000000000000;
	dataY_Elf[10] = 12'b000000000000; dataZ_Elf[10]  = 12'b000000000000;
	dataY_Elf[11] = 12'b000000000000; dataZ_Elf[11]  = 12'b000000000000;
	// Boss Body
	dataX_Boss[0]  = 13'b1111111100000;
	dataX_Boss[1]  = 13'b0111011111000;
	dataX_Boss[2]  = 13'b0011101111100;
	dataX_Boss[3]  = 13'b0111101111110;
	dataX_Boss[4]  = 13'b1111011101111;
	dataX_Boss[5]  = 13'b0011101111111;
	dataX_Boss[6]  = 13'b0011101111111;
	dataX_Boss[7]  = 13'b1111011101111;
	dataX_Boss[8]  = 13'b0111101111110;
	dataX_Boss[9]  = 13'b0011101111100;
	dataX_Boss[10] = 13'b0111011111000;
	dataX_Boss[11] = 13'b1111111100000;
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
	 dataZ_Boss[8], dataZ_Boss[9], dataZ_Boss[10], 
	 dataZ_Boss[11]}  = {10{13'b0000000000000}};
	{dataZ_Boss[4], dataZ_Boss[7]}  = {2{13'b0000000010000}};
	// Food Body
	dataX_Food[0]  = 11'b00001110000;
	dataX_Food[1]  = 11'b00111111100;
	dataX_Food[2]  = 11'b01111111110;
	dataX_Food[3]  = 11'b01111111110;
	dataX_Food[4]  = 11'b11111111111;
	dataX_Food[5]  = 11'b11111111111;
	dataX_Food[6]  = 11'b11111111111;
	dataX_Food[7]  = 11'b01111111110;
	dataX_Food[8]  = 11'b01111111110;
	dataX_Food[9]  = 11'b00111111100;
	dataX_Food[10] = 11'b00001110000;
end

endmodule 
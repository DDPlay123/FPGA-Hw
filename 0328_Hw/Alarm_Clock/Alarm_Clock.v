//----------------------------------------------------
//Design Name: Alarm Clock
//File Name: Alarm_Clock.v
//Function: Alarm Clock
//----------------------------------------------------
module Alarm_Clock(Led ,Seg6, Seg5, Seg4, Seg3, Seg2, 
						 Seg1, ALed, Sw, Up, Down, Accel, Clk_50MHz);
//----------------------------------------------------
// output
// 時間到，亮
output reg Led;
// 切換速度指示燈，001:1倍、010:2倍、100:4倍
output reg [2:0]ALed;
// 七段顯示器輸出
output reg [6:0]Seg6 = 7'b100_0000, Seg5 = 7'b100_0000, 
					 Seg4 = 7'b100_0000, Seg3 = 7'b100_0000, 
					 Seg2 = 7'b100_0000, Seg1 = 7'b100_0000;
//----------------------------------------------------
// input
// Sw[0]暫停鬧鐘，Sw[3:1]指定時、分、秒
input [3:0]Sw;
// Up:增加，Down:減少，Accel:切換速度
input Up, Down, Accel, Clk_50MHz;
//----------------------------------------------------
// register
// 除頻後的CLK
reg CLK = 1'b0;
// 暫存除頻用的變數
reg [27:0]CLK_count = 0;
// 暫存速度檔位變數
reg [2:0]Accel_count = 3'd0;

// 暫存用Seg，以兩個為單位，有時、分、秒
reg [3:0]Out6, Out5, Out4, Out3, Out2, Out1;
reg [3:0]In6, In5, In4, In3, In2, In1;
/******************Decoder & Encoder******************/
// Seg to Binary
function [3:0]Decoder;
// input
input [6:0]In;
// Converter
begin	
	case(In)
		7'b100_0000:Decoder = 4'd0;
		7'b111_1001:Decoder = 4'd1;
		7'b010_0100:Decoder = 4'd2;
		7'b011_0000:Decoder = 4'd3;
		7'b001_1001:Decoder = 4'd4;
		7'b001_0010:Decoder = 4'd5;
		7'b000_0010:Decoder = 4'd6;
		7'b111_1000:Decoder = 4'd7;
		7'b000_0000:Decoder = 4'd8;
		7'b001_0000:Decoder = 4'd9;
	endcase
end
endfunction
//----------------------------------------------------
// Binary to Seg
function [6:0]Encoder;
// input
input [3:0]In;

// Converter
begin
	case(In)
		4'd0:Encoder = 7'b100_0000;
		4'd1:Encoder = 7'b111_1001;
		4'd2:Encoder = 7'b010_0100;
		4'd3:Encoder = 7'b011_0000;
		4'd4:Encoder = 7'b001_1001;
		4'd5:Encoder = 7'b001_0010;
		4'd6:Encoder = 7'b000_0010;
		4'd7:Encoder = 7'b111_1000;
		4'd8:Encoder = 7'b000_0000;
		4'd9:Encoder = 7'b001_0000;
	endcase
end
endfunction
/******************Listener Accel******************/
// Accel_count=0 or 1(1_Speed) -> 2(2_Speed) ->3 (4_Speed)
always@(negedge Accel)begin
	if(!Accel)begin
		Accel_count = Accel_count + 3'd1;
		if(Accel_count > 3'd3) Accel_count = 3'd0;
	end
end

/******************Divide Freq*********************/
// 模擬用10KHz
always@(posedge Clk_50MHz)begin
	case(Accel_count)
		// 50MHz --> 1Hz = 1s
		3'd0, 3'd1:begin
			if(CLK_count > 25000000)begin // (1Hz)25000000 or (10KHz)5000
				CLK = ~CLK;
				CLK_count = 0;
				ALed = 3'b001;
			end
			else CLK_count = CLK_count + 1;
		end
		// 50MHz --> 2Hz = 0.5s
		3'd2:begin
			if(CLK_count > 12500000)begin // (2Hz)12500000 or (20KHz)2500
				CLK = ~CLK;
				CLK_count = 0;
				ALed = 3'b010;
			end
			else CLK_count = CLK_count + 1;
		end
		// 50MHz --> 4Hz = 0.25s
		3'd3:begin
			if(CLK_count > 6250000)begin // (4Hz)6250000 or (40KHz)1250
				CLK = ~CLK;
				CLK_count = 0;
				ALed = 3'b100;
			end
			else CLK_count = CLK_count + 1;
		end
	endcase
end


/******************Alarm Clock Setting**********************/
always@(posedge CLK)begin
	if(Sw[0])begin
		case(Sw)
			4'b1001:begin
				if(!Up)begin
					case(Decoder(Seg5))
						4'd8,4'd7,4'd6,4'd5,4'd4,4'd3,4'd2,4'd1,4'd0:begin
							In5 = Decoder(Seg5) + 4'd1;
							Seg5 = Encoder(In5);
						end
						4'd9:begin
							In5 = 4'd0;
							Seg5 = Encoder(In5);
							case(Decoder(Seg6))
								4'd8,4'd7,4'd6,4'd5,4'd4,4'd3,4'd2,4'd1,4'd0:begin
									In6 = Decoder(Seg6) + 4'd1;
									Seg6 = Encoder(In6);
								end
								4'd9:begin
									In5 = 4'd9;
									Seg5 = Encoder(In5);
								end
							endcase
						end
					endcase
				end
				if(!Down)begin
					case(Decoder(Seg5))
						4'd9,4'd8,4'd7,4'd6,4'd5,4'd4,4'd3,4'd2,4'd1:begin
							// Hex4遞減並顯示
							Out5 = Decoder(Seg5) - 1;
							Seg5 = Encoder(Out5);
						end
						4'd0:begin
							// 如果Hex4歸零且Hex5大於零
							case(Decoder(Seg6))
								4'd9,4'd8,4'd7,4'd6,4'd5,4'd4,4'd3,4'd2,4'd1:begin
									// 先顯示Hex4
									Seg5 = Encoder(Out5);
									// Hex5遞減並顯示
									Out6 = Decoder(Seg6) - 1;
									Seg6 = Encoder(Out6);
									// Hex4從9開始
									Out5 = 4'd9;
									Seg5 = Encoder(Out5);
								end
							endcase
						end
					endcase
				end
			end
			4'b0101:begin
				if(!Up)begin
					case(Decoder(Seg3))
						4'd8,4'd7,4'd6,4'd5,4'd4,4'd3,4'd2,4'd1,4'd0:begin
							In3 = Decoder(Seg3) + 4'd1;
							Seg3 = Encoder(In3);
						end
						4'd9:begin
							In3 = 4'd0;
							Seg3 = Encoder(In3);
							case(Decoder(Seg4))
								4'd4,4'd3,4'd2,4'd1,4'd0:begin
									In4 = Decoder(Seg4) + 4'd1;
									Seg4 = Encoder(In4);
								end
								4'd5:begin
									In4 = 4'd0;
									Seg4 = Encoder(In4);
									case(Decoder(Seg5))
										4'd8,4'd7,4'd6,4'd5,4'd4,4'd3,4'd2,4'd1,4'd0:begin
											In5 = Decoder(Seg5) + 4'd1;
											Seg5 = Encoder(In5);
										end
										4'd9:begin
											In5 = 4'd0;
											Seg5 = Encoder(In5);
											case(Encoder(Seg6))
												4'd8,4'd7,4'd6,4'd5,4'd4,4'd3,4'd2,4'd1,4'd0:begin
													In6 = Decoder(Seg6) + 4'd1;
													Seg6 = Encoder(In6);
												end
												4'd9:begin
													In6 = 4'd9;
													Seg6 = Encoder(In6);
												end
											endcase
										end
									endcase
								end
							endcase
						end
					endcase
				end
				if(!Down)begin
					case(Decoder(Seg3))
						4'd9,4'd8,4'd7,4'd6,4'd5,4'd4,4'd3,4'd2,4'd1:begin
							// Hex2遞減並顯示
							Out3 = Decoder(Seg3) - 1;
							Seg3 = Encoder(Out3);
						end
						4'd0:begin
							// 如果Hex2歸零且Hex3大於零
							case(Decoder(Seg4))
								4'd6,4'd5,4'd4,4'd3,4'd2,4'd1:begin
									// 先顯示Hex2
									Seg3 = Encoder(Out3);
									// Hex3遞減並顯示
									Out4 = Decoder(Seg4) - 1;
									Seg4 = Encoder(Out4);
									// Hex2從9開始
									Out3 = 4'd9;
									Seg3 = Encoder(Out3);
								end
								4'd0:begin
									// 時: 最多99小時
									// 如果Hex3歸零且Hex4大於零
									case(Decoder(Seg5))
										4'd9,4'd8,4'd7,4'd6,4'd5,4'd4,4'd3,4'd2,4'd1:begin
											// 先顯示Hex3
											Seg4 = Encoder(Out4);
											// Hex4遞減並顯示
											Out5 = Decoder(Seg5) - 1;
											Seg5 = Encoder(Out5);
											// Hex3從5開始
											Out4 = 4'd5;
											Seg4 = Encoder(Out4);
											// Hex2從9開始
											Out3 = 4'd9;
											Seg3 = Encoder(Out3);
										end
										4'd0:begin
											// 如果Hex4歸零且Hex5大於零
											case(Decoder(Seg6))
												4'd9,4'd8,4'd7,4'd6,4'd5,4'd4,4'd3,4'd2,4'd1:begin
													// 先顯示Hex4
													Seg5 = Encoder(Out5);
													// Hex5遞減並顯示
													Out6 = Decoder(Seg6) - 1;
													Seg6 = Encoder(Out6);
													// Hex4從9開始
													Out5 = 4'd9;
													Seg5 = Encoder(Out5);
													// Hex3從5開始
													Out4 = 4'd5;
													Seg4 = Encoder(Out4);
													// Hex2從9開始
													Out3 = 4'd9;
													Seg3 = Encoder(Out3);
												end
											endcase
										end
									endcase
								end
							endcase
						end
					endcase
				end
			end
			4'b0011:begin
				if(!Up)begin
					case(Decoder(Seg1))
						4'd8,4'd7,4'd6,4'd5,4'd4,4'd3,4'd2,4'd1,4'd0:begin
							In1 = Decoder(Seg1) + 4'd1;
							Seg1 = Encoder(In1);
						end
						4'd9:begin
							In1 = 4'd0;
							Seg1 = Encoder(In1);
							case(Decoder(Seg2))
								4'd4,4'd3,4'd2,4'd1,4'd0:begin
									In2 = Decoder(Seg2) + 4'd1;
									Seg2 = Encoder(In2);
								end
								4'd5:begin
									In2 = 4'd0;
									Seg2 = Encoder(In2);
									case(Decoder(Seg3))
										4'd8,4'd7,4'd6,4'd5,4'd4,4'd3,4'd2,4'd1,4'd0:begin
											In3 = Decoder(Seg3) + 4'd1;
											Seg3 = Encoder(In3);
										end
										4'd9:begin
											In3 = 4'd0;
											Seg3 = Encoder(In3);
											case(Decoder(Seg4))
												4'd4,4'd3,4'd2,4'd1,4'd0:begin
													In4 = Decoder(Seg4) + 4'd1;
													Seg4 = Encoder(In4);
												end
												4'd5:begin
													In4 = 4'd0;
													Seg4 = Encoder(In4);
													case(Decoder(Seg5))
														4'd8,4'd7,4'd6,4'd5,4'd4,4'd3,4'd2,4'd1,4'd0:begin
															In5 = Decoder(Seg5) + 4'd1;
															Seg5 = Encoder(In5);
														end
														4'd9:begin
															In5 = 4'd0;
															Seg5 = Encoder(In5);
															case(Decoder(Seg6))
																4'd8,4'd7,4'd6,4'd5,4'd4,4'd3,4'd2,4'd1,4'd0:begin
																	In6 = Decoder(Seg6) + 4'd1;
																	Seg6 = Encoder(In6);
																end
																4'd9:begin
																	In6 = 4'd9;
																	Seg6 = Encoder(In6);
																end
															endcase
														end
													endcase
												end
											endcase
										end
									endcase
								end
							endcase
						end
					endcase
				end
				if(!Down)begin
					case(Decoder(Seg1))
						4'd9,4'd8,4'd7,4'd6,4'd5,4'd4,4'd3,4'd2,4'd1:begin
							// 9~1: 遞減並顯示
							Out1 = Decoder(Seg1) - 1;
							Seg1 = Encoder(Out1);
						end
						4'd0:begin
							// 如果Hex0歸零且Hex1大於零
							case(Decoder(Seg2))
								4'd6,4'd5,4'd4,4'd3,4'd2,4'd1:begin
									// 先顯示Hex0
									Seg1 = Encoder(Out1);
									// Hex1遞減並顯示
									Out2 = Decoder(Seg2) - 1;
									Seg2 = Encoder(Out2);
									// Hex0從9開始
									Out1 = 4'd9;
									Seg1 = Encoder(Out1);
								end
								4'd0:begin
									// 分: 最多59分
									// 如果Hex1歸零且Hex2大於零
									case(Decoder(Seg3))
										4'd9,4'd8,4'd7,4'd6,4'd5,4'd4,4'd3,4'd2,4'd1:begin
											// 先顯示Hex1
											Seg2 = Encoder(Out2);
											// Hex2遞減並顯示
											Out3 = Decoder(Seg3) - 1;
											Seg3 = Encoder(Out3);
											// Hex1從5開始
											Out2 = 4'd5;
											Seg2 = Encoder(Out2);
											// Hex0從9開始
											Out1 = 4'd9;
											Seg1 = Encoder(Out1);
										end
										4'd0:begin
											// 如果Hex2歸零且Hex3大於零
											case(Decoder(Seg4))
												4'd6,4'd5,4'd4,4'd3,4'd2,4'd1:begin
													// 先顯示Hex2
													Seg3 = Encoder(Out3);
													// Hex3遞減並顯示
													Out4 = Decoder(Seg4) - 1;
													Seg4 = Encoder(Out4);
													// Hex2從9開始
													Out3 = 4'd9;
													Seg3 = Encoder(Out3);
													// Hex1從5開始
													Out2 = 4'd5;
													Seg2 = Encoder(Out2);
													// Hex0從9開始
													Out1 = 4'd9;
													Seg1 = Encoder(Out1);
												end
												4'd0:begin
													// 時: 最多99小時
													// 如果Hex3歸零且Hex4大於零
													case(Decoder(Seg5))
														4'd9,4'd8,4'd7,4'd6,4'd5,4'd4,4'd3,4'd2,4'd1:begin
															// 先顯示Hex3
															Seg4 = Encoder(Out4);
															// Hex4遞減並顯示
															Out5 = Decoder(Seg5) - 1;
															Seg5 = Encoder(Out5);
															// Hex3從5開始
															Out4 = 4'd5;
															Seg4 = Encoder(Out4);
															// Hex2從9開始
															Out3 = 4'd9;
															Seg3 = Encoder(Out3);
															// Hex1從5開始
															Out2 = 4'd5;
															Seg2 = Encoder(Out2);
															// Hex0從9開始
															Out1 = 4'd9;
															Seg1 = Encoder(Out1);
														end
														4'd0:begin
															// 如果Hex4歸零且Hex5大於零
															case(Decoder(Seg6))
																4'd9,4'd8,4'd7,4'd6,4'd5,4'd4,4'd3,4'd2,4'd1:begin
																	// 先顯示Hex4
																	Seg5 = Encoder(Out5);
																	// Hex5遞減並顯示
																	Out6 = Decoder(Seg6) - 1;
																	Seg6 = Encoder(Out6);
																	// Hex4從9開始
																	Out5 = 4'd9;
																	Seg5 = Encoder(Out5);
																	// Hex3從5開始
																	Out4 = 4'd5;
																	Seg4 = Encoder(Out4);
																	// Hex2從9開始
																	Out3 = 4'd9;
																	Seg3 = Encoder(Out3);
																	// Hex1從5開始
																	Out2 = 4'd5;
																	Seg2 = Encoder(Out2);
																	// Hex0從9開始
																	Out1 = 4'd9;
																	Seg1 = Encoder(Out1);
																end
															endcase
														end
													endcase
												end
											endcase
										end
									endcase
								end
							endcase
						end
					endcase
				end
			end
		endcase
	end
	else begin
		if(Decoder(Seg1) == 0 && 
			Decoder(Seg2) == 0 && 
			Decoder(Seg3) == 0 && 
			Decoder(Seg4) == 0 && 
			Decoder(Seg5) == 0 && 
			Decoder(Seg6) == 0)
			Led = 1'b1;
		else
			Led = 1'b0;
		// 秒: 最多59秒
		case(Decoder(Seg1))
			4'd9,4'd8,4'd7,4'd6,4'd5,4'd4,4'd3,4'd2,4'd1:begin
				// 9~1: 遞減並顯示
				Out1 = Decoder(Seg1) - 1;
				Seg1 = Encoder(Out1);
			end
			4'd0:begin
				// 如果Hex0歸零且Hex1大於零
				case(Decoder(Seg2))
					4'd6,4'd5,4'd4,4'd3,4'd2,4'd1:begin
						// 先顯示Hex0
						Seg1 = Encoder(Out1);
						// Hex1遞減並顯示
						Out2 = Decoder(Seg2) - 1;
						Seg2 = Encoder(Out2);
						// Hex0從9開始
						Out1 = 4'd9;
						Seg1 = Encoder(Out1);
					end
					4'd0:begin
						// 分: 最多59分
						// 如果Hex1歸零且Hex2大於零
						case(Decoder(Seg3))
							4'd9,4'd8,4'd7,4'd6,4'd5,4'd4,4'd3,4'd2,4'd1:begin
								// 先顯示Hex1
								Seg2 = Encoder(Out2);
								// Hex2遞減並顯示
								Out3 = Decoder(Seg3) - 1;
								Seg3 = Encoder(Out3);
								// Hex1從5開始
								Out2 = 4'd5;
								Seg2 = Encoder(Out2);
								// Hex0從9開始
								Out1 = 4'd9;
								Seg1 = Encoder(Out1);
							end
							4'd0:begin
								// 如果Hex2歸零且Hex3大於零
								case(Decoder(Seg4))
									4'd6,4'd5,4'd4,4'd3,4'd2,4'd1:begin
										// 先顯示Hex2
										Seg3 = Encoder(Out3);
										// Hex3遞減並顯示
										Out4 = Decoder(Seg4) - 1;
										Seg4 = Encoder(Out4);
										// Hex2從9開始
										Out3 = 4'd9;
										Seg3 = Encoder(Out3);
										// Hex1從5開始
										Out2 = 4'd5;
										Seg2 = Encoder(Out2);
										// Hex0從9開始
										Out1 = 4'd9;
										Seg1 = Encoder(Out1);
									end
									4'd0:begin
										// 時: 最多99小時
										// 如果Hex3歸零且Hex4大於零
										case(Decoder(Seg5))
											4'd9,4'd8,4'd7,4'd6,4'd5,4'd4,4'd3,4'd2,4'd1:begin
												// 先顯示Hex3
												Seg4 = Encoder(Out4);
												// Hex4遞減並顯示
												Out5 = Decoder(Seg5) - 1;
												Seg5 = Encoder(Out5);
												// Hex3從5開始
												Out4 = 4'd5;
												Seg4 = Encoder(Out4);
												// Hex2從9開始
												Out3 = 4'd9;
												Seg3 = Encoder(Out3);
												// Hex1從5開始
												Out2 = 4'd5;
												Seg2 = Encoder(Out2);
												// Hex0從9開始
												Out1 = 4'd9;
												Seg1 = Encoder(Out1);
											end
											4'd0:begin
												// 如果Hex4歸零且Hex5大於零
												case(Decoder(Seg6))
													4'd9,4'd8,4'd7,4'd6,4'd5,4'd4,4'd3,4'd2,4'd1:begin
														// 先顯示Hex4
														Seg5 = Encoder(Out5);
														// Hex5遞減並顯示
														Out6 = Decoder(Seg6) - 1;
														Seg6 = Encoder(Out6);
														// Hex4從9開始
														Out5 = 4'd9;
														Seg5 = Encoder(Out5);
														// Hex3從5開始
														Out4 = 4'd5;
														Seg4 = Encoder(Out4);
														// Hex2從9開始
														Out3 = 4'd9;
														Seg3 = Encoder(Out3);
														// Hex1從5開始
														Out2 = 4'd5;
														Seg2 = Encoder(Out2);
														// Hex0從9開始
														Out1 = 4'd9;
														Seg1 = Encoder(Out1);
													end
												endcase
											end
										endcase
									end
								endcase
							end
						endcase
					end
				endcase
			end
		endcase
	end
end

endmodule

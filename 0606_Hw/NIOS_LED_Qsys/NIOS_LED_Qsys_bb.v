
module NIOS_LED_Qsys (
	clk_clk,
	reset_reset_n,
	led_external_connection_export,
	sw_external_connection_export);	

	input		clk_clk;
	input		reset_reset_n;
	output	[7:0]	led_external_connection_export;
	input		sw_external_connection_export;
endmodule

	component NIOS_LED_Qsys is
		port (
			clk_clk                        : in  std_logic                    := 'X'; -- clk
			reset_reset_n                  : in  std_logic                    := 'X'; -- reset_n
			led_external_connection_export : out std_logic_vector(7 downto 0);        -- export
			sw_external_connection_export  : in  std_logic                    := 'X'  -- export
		);
	end component NIOS_LED_Qsys;

	u0 : component NIOS_LED_Qsys
		port map (
			clk_clk                        => CONNECTED_TO_clk_clk,                        --                     clk.clk
			reset_reset_n                  => CONNECTED_TO_reset_reset_n,                  --                   reset.reset_n
			led_external_connection_export => CONNECTED_TO_led_external_connection_export, -- led_external_connection.export
			sw_external_connection_export  => CONNECTED_TO_sw_external_connection_export   --  sw_external_connection.export
		);


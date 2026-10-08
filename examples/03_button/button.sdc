create_clock -period 50MHz -name clk [get_ports clk]
derive_pll_clocks
derive_clock_uncertainty
set_false_path -from [get_registers {led_state}] -to [get_ports {led}]
set_false_path -from [get_ports {btn}] -to [get_registers {btn_delay*}]

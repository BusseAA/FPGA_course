create_clock -name clk -period 20.000 [get_ports {clk}]
derive_clock_uncertainty
# LEDs have no synchronous external receiver.
set_false_path -to [get_ports {led[*]}]

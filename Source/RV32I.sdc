create_clock -period 37.000 -name CLOCK -waveform {0.000 18.500} [get_ports clk]

set_input_delay -clock CLOCK -max 0.500 [get_ports {BOOT0 BOOT1 rst uart_rx {GPIO_x[*]}}]
set_input_delay -clock CLOCK -min 0.200 [get_ports {BOOT0 BOOT1 rst uart_rx {GPIO_x[*]}}]


set_output_delay -clock CLOCK -max 0.500 [get_ports {uart_tx {GPIO_x[*]}}]
set_output_delay -clock CLOCK -min 0.200 [get_ports {uart_tx {GPIO_x[*]}}]


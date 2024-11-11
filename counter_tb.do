restart -f -nowave
config wave -signalnamewidth 1

add wave -divider "Clocks"
add wave clk
add wave /counter_tb/counter_inst/sec_clk
add wave -divider "Displayed numbers"
add wave -radix unsigned /counter_tb/counter_inst/num
add wave -radix unsigned /counter_tb/counter_inst/Decad
add wave -radix unsigned /counter_tb/counter_inst/tio_pot
add wave -divider "Others"
add wave resetn
add wave SEG
add wave AN
add wave /counter_tb/counter_inst/LED_activate
add wave /counter_tb/counter_inst/refresh



run -all

view signals waves
#wave zoom fill
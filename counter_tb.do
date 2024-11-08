restart -f -nowave
config wave -signalnamewidth 1


add wave clk
add wave reset
add wave SEG
add wave AN
add wave /counter_tb/counter_inst/num
add wave /counter_tb/counter_inst/Decad
add wave /counter_tb/counter_inst/tio_pot
add wave /counter_tb/counter_inst/LED_activate
add wave /counter_tb/counter_inst/refresh
add wave /counter_tb/counter_inst/sec_clk


run -all

view signals waves
#wave zoom fill
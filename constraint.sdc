current_design adder_comb

set clk_name  v_clock
#set clk_port_name clk
set clk_period 2.5
set clk_io_pct 0.2 

# set clk_port [get_ports $clk_port_name]

create_clock -name $clk_name -period $clk_period 

set non_clock_inputs [lsearch -inline -all -not [all_inputs]]

set_input_delay  [expr $clk_period * $clk_io_pct] -clock $clk_name $non_clock_inputs
set_output_delay [expr $clk_period * $clk_io_pct] -clock $clk_name [all_outputs] 

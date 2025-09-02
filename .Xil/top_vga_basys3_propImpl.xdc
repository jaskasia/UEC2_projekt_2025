set_property SRC_FILE_INFO {cfile:/home/student/jjaskowiec/Downloads/UEC2_projekt_2025/fpga/constraints/clk_wiz_project.xdc rfile:../fpga/constraints/clk_wiz_project.xdc id:1} [current_design]
set_property src_info {type:XDC file:1 line:54 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk]] 0.100

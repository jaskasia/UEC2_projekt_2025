# Copyright (C) 2025  AGH University of Science and Technology
# MTM UEC2
# Author: Piotr Kaczmarczyk
# Modified by: Aleksandra Gniadek and Joanna Jaśkowiec
# Description:
# Project detiles required for generate_bitstream.tcl
# Make sure that project_name, top_module and target are correct.
# Provide paths to all the files required for synthesis and implementation.
# Depending on the file type, it should be added in the corresponding section.
# If the project does not use files of some type, leave the corresponding section commented out.

#-----------------------------------------------------#
#                   Project details                   #
#-----------------------------------------------------#
# Project name                                  -- EDIT
set project_name vga_project

# Top module name                               -- EDIT
set top_module top_vga_basys3

# FPGA device
set target xc7a35tcpg236-1

#-----------------------------------------------------#
#                    Design sources                   #
#-----------------------------------------------------#
# Specify .xdc files location                   -- EDIT
set xdc_files {
    constraints/top_vga_basys3.xdc
    constraints/clk_wiz_project.xdc
}

# Specify SystemVerilog design files location   -- EDIT
set sv_files {
    ../rtl/vga_pkg.sv
    ../rtl/vga_timing.sv
    ../rtl/draw/draw_bg.sv
    ../rtl/draw/draw_figures.sv
    ../rtl/draw/draw_platforms.sv
    ../rtl/draw/draw_screens.sv
    ../rtl/top_uart.sv
    ../rtl/top_vga.sv
    ../rtl/move_ctr_fsm.sv
    ../rtl/vga_if.sv
    ../rtl/keyboard/read_keyboard.sv
    rtl/top_vga_basys3.sv
}

# Specify Verilog design files location         -- EDIT
set verilog_files {
    ../fpga/rtl/clk_wiz_project.v
    ../fpga/rtl/clk_wiz_project_clk_wiz.v
    ../rtl/keyboard/debouncer.v
    ../rtl/keyboard/PS2Receiver.v
    ../rtl/uart/list_ch04_11_mod_m_counter.v
    ../rtl/uart/list_ch04_20_fifo.v
    ../rtl/uart/list_ch04_21_fifo_test.v
    ../rtl/uart/list_ch08_01_uart_rx.v
    ../rtl/uart/list_ch08_02_flag_buf.v
    ../rtl/uart/list_ch08_03_uart_tx.v
    ../rtl/uart/list_ch08_04_uart.v
}

# Specify VHDL design files location            -- EDIT
# set vhdl_files {
# }

# Specify files for a memory initialization     -- EDIT
# set mem_files {
#    path/to/file.data
# }

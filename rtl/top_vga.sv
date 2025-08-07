/**
 * San Jose State University
 * EE178 Lab #4
 * Author: prof. Eric Crabilla
 *
 * Modified by:
 * 2025  AGH University of Science and Technology
 * MTM UEC2
 * Piotr Kaczmarczyk
 *
 * Description:
 * The project top module.
 */

 module top_vga (
    input  logic clk40MHz,
    input  logic clk100MHz,
    input  logic rst,
    output logic vs,
    output logic hs,
    output logic [3:0] r,
    output logic [3:0] g,
    output logic [3:0] b,
    inout wire ps2_clk,
    inout wire ps2_data
);

timeunit 1ns;
timeprecision 1ps;


/**
 * Local variables and signals
 */

// VGA - interface name, instnces names
vga_if tim_bg();
vga_if bg_rect();
vga_if rect_out();

/**
 * Signals assignments
 */

assign vs = rect_out.vsync;
assign hs = rect_out.hsync;
assign {r,g,b} = rect_out.rgb;


/**
 * Submodules instances
 */

vga_timing u_vga_timing (
    .clk(clk40MHz),
    .rst,
    .vcount (tim_bg.vcount),
    .vsync  (tim_bg.vsync),
    .vblnk  (tim_bg.vblnk),
    .hcount (tim_bg.hcount),
    .hsync  (tim_bg.hsync),
    .hblnk  (tim_bg.hblnk)
);

draw_bg u_draw_bg (
    .clk(clk40MHz),
    .rst,
    .in(tim_bg.in),
    .out(bg_rect.out)
);

draw_rect u_draw_rect (
    .clk(clk40MHz),
    .rst,
    .in(bg_rect.in),
    .out(rect_out.out)
);

endmodule

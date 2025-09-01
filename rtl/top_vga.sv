/*
* Authors:
* * 2025  AGH University of Science and Technology
* MTM UEC2 Ogień i Woda Infinity Tower
* Aleksandra Gniadek and Joanna Jaśkowiec
*
* Description:
* Game top module connecting all the sub-modules to the clock and together
*/

module top_vga (
    input  logic clk65MHz,
    input  logic rst,
    input  wire ps2_clk,
    input  wire ps2_data,
    
    input logic [7:0] data_in,
    output logic data_ready,
    output logic [7:0] data_out,

    output logic vs,
    output logic hs,
    output logic [3:0] r,
    output logic [3:0] g,
    output logic [3:0] b
);
    
    logic [7:0] rx_data;
    logic o_flag;
    logic key_jump, key_left, key_right;
 
    PS2Receiver ps2_receiver_inst (
        .clk(clk65MHz),
        .kclk(ps2_clk),
        .kdata(ps2_data),
        .keycode(rx_data),
        .oflag(o_flag)
    );
 
    read_keyboard read_keyboard_inst (
        .clk(clk65MHz),
        .rst(rst),
        .keycode(rx_data),
        .oflag(o_flag),
        .newchar(),
        .enter(key_enter),
        .spacebar(key_space),
        .key_w(key_jump),
        .key_a(key_left),
        .key_d(key_right)
    );
 

    logic [11:0] rect_posx, rect_posy;
    move_ctr_fsm player_ctl_inst (
        .clk(clk65MHz),
        .rst(rst),
        .key_w(key_jump),
        .key_a(key_left),
        .key_d(key_right),
        .pos_x(rect_posx),
        .pos_y(rect_posy)
    );
 

    vga_if tim_bg();
    vga_if bg_platform();
    vga_if platform_figures();
    vga_if draw_figures_out();
 
    vga_timing u_vga_timing (
        .clk(clk65MHz),
        .rst,
        .vcount(tim_bg.vcount),
        .vsync(tim_bg.vsync),
        .vblnk(tim_bg.vblnk),
        .hcount(tim_bg.hcount),
        .hsync(tim_bg.hsync),
        .hblnk(tim_bg.hblnk)
    );
 

    logic [11:0] rgb_start;
    draw_screens u_draw_screens (
        .clk(clk65MHz),
        .rst(rst),
        .key_enter(key_enter),
        .key_space(key_space),
        .hcount(tim_bg.hcount),
        .vcount(tim_bg.vcount),
        .rgb_start(rgb_start)
    );
 

    draw_bg u_draw_bg (
        .clk(clk65MHz),
        .rst,
        .in(tim_bg.in),
        .out(bg_platform.out)
    );
 
    draw_platforms u_draw_platforms (
        .clk(clk65MHz),
        .rst,
        .in(bg_platform.in),
        .out(platform_figures.out)
    );
 
    draw_figures u_draw_figures (
        .clk(clk65MHz),
        .rst,
        .rect_posx(rect_posx),
        .rect_posy(rect_posy),
        .in(platform_figures.in),
        .out(draw_figures_out.out)
    );
 

    logic [11:0] rgb_mux;
    assign rgb_mux = rgb_start != 12'h000 ? rgb_start : draw_figures_out.rgb;
 
  
    assign vs = draw_figures_out.vsync;
    assign hs = draw_figures_out.hsync;
    assign {r,g,b} = rgb_mux;
 
endmodule
 
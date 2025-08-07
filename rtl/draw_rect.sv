/**
 * Copyright (C) 2025  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Draw background.
 */

 module draw_rect (
    input  logic clk,
    input  logic rst,
    input logic [11:0] r_xpos,
    input logic [11:0] r_ypos,
    input logic [11:0] rgb_pixel,
    output  logic [11:0] pixel_address,

    vga_if.in in,
    vga_if.out out
);

timeunit 1ns;
timeprecision 1ps;


/**
 * Local variables and signals
 */

localparam RECT_AGH_WIDTH = 48;
localparam RECT_AGH_HEIGHT = 64;

logic [10:0] hcount1, vcount1, vcount2, hcount2;
logic [11:0] rgb_nxt, rgb1, rgb2;
logic hsync1, hsync2, hblnk1, hblnk2, vsync1, vsync2, vblnk1, vblnk2;
logic [5:0] addrx, addry;

/**
 * Internal logic
 */


always_ff @(posedge clk) begin : bg_ff_blk1
    if (rst) begin
        vcount1 <= '0;
        vsync1  <= '0;
        vblnk1  <= '0;
        hcount1 <= '0;
        hsync1  <= '0;
        hblnk1  <= '0;
        rgb1    <= '0;
    end else begin
        vcount1 <= in.vcount;
        vsync1  <= in.vsync;
        vblnk1  <= in.vblnk;
        hcount1 <= in.hcount;
        hsync1  <= in.hsync;
        hblnk1  <= in.hblnk;
        rgb1    <= in.rgb;
    end
end

always_ff @(posedge clk) begin : bg_ff_blk2
    if (rst) begin
        vcount2 <= '0;
        vsync2  <= '0;
        vblnk2  <= '0;
        hcount2 <= '0;
        hsync2  <= '0;
        hblnk2  <= '0;
        rgb2    <= '0;
    end else begin
        vcount2 <= vcount1;
        vsync2  <= vsync1;
        vblnk2  <= vblnk1;
        hcount2 <= hcount1;
        hsync2  <= hsync1;
        hblnk2  <= hblnk1;
        rgb2    <= rgb1;
    end
end

always_ff @(posedge clk) begin : bg_ff_blk3
    if (rst) begin
        out.vcount <= '0;
        out.vsync  <= '0;
        out.vblnk  <= '0;
        out.hcount <= '0;
        out.hsync  <= '0;
        out.hblnk  <= '0;
        out.rgb    <= '0;
        pixel_address <= '0;
    end else begin
        out.vcount <= vcount2;
        out.vsync  <= vsync2;
        out.vblnk  <= vblnk2;
        out.hcount <= hcount2;
        out.hsync  <= hsync2;
        out.hblnk  <= hblnk2;
        out.rgb    <= rgb_nxt;
        pixel_address <= {addry, addrx};
    end
end



always_comb begin : rect_comb_blk
    if (hblnk2 || vblnk2) begin
        rgb_nxt = 12'h000; // czarne tło poza aktywnym obszarem
    end else begin
        if ((hcount2 >= r_xpos) && // Rectangle start position (left side)
            (hcount2 < (r_xpos + RECT_AGH_WIDTH)) && // Rectangle end position (right side)
            (vcount2 >= r_ypos) && // Rectangle start position (top side)
            (vcount2 < (r_ypos + RECT_AGH_HEIGHT))) begin // Rectangle end position (bottom side)
            rgb_nxt = rgb_pixel;
        end else begin
            rgb_nxt = rgb2;
        end
    end
end

always_comb begin
    addry = in.vcount - r_ypos;
    addrx = in.hcount - r_xpos;
end
endmodule

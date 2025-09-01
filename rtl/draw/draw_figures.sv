/*
 * Authors:
 * * 2025  AGH University of Science and Technology
 * MTM UEC2 Ogień i Woda Infinity Tower
 * Aleksandra Gniadek and Joanna Jaśkowiec
 *
 * Description:
 * Draws figures (sprites) on the screen using pixel data from .dat files.
 */

 module draw_figures (
    input  logic clk, rst,
    input  logic [11:0] rect_posx,
    input  logic [11:0] rect_posy,
    input  logic [1:0] game_mode,
    input  logic start_game,

    output logic lose,

    vga_if.in  in,
    vga_if.out out
);

    // sprite: ogień (26x26)
    reg [11:0] fire_figure [0:675];
    // sprite: woda (26x26)
    reg [11:0] water_figure [0:675];
    reg [11:0] figure [0:675];

    initial begin
        $readmemh("../../rtl/graphics/fire_figure.dat",  fire_figure);
        $readmemh("../../rtl/graphics/water_figure.dat", water_figure);
    end

    parameter FIRE_WIDTH   = 26;
    parameter FIRE_HEIGHT  = 26;
    parameter WATER_WIDTH  = 26;
    parameter WATER_HEIGHT = 26;
    parameter BG_COLOR     = 12'h452;
    parameter WATER_COLOR  = 12'hCFF;
    parameter FIRE_COLOR   = 12'hF17;

    logic [3:0] color; // kolor kolizji

    always_comb begin
        if (game_mode[1]) begin
            color = (game_mode[0]) ? WATER_COLOR : FIRE_COLOR;
            figure = (game_mode[0]) ? water_figure : fire_figure;
        end else begin
            color = (start_game) ? WATER_COLOR : FIRE_COLOR;
            figure = (start_game) ? water_figure : fire_figure;
        end
    end

    // zatrzask przegranej
    always_ff @(posedge clk) begin
        if (rst) begin
            out.hcount <= '0;
            out.vcount <= '0;
            out.hsync  <= '0;
            out.vsync  <= '0;
            out.hblnk  <= '0;
            out.vblnk  <= '0;
            out.rgb    <= '0;
            lose      <= 1'b0;
        end else begin
            // kopiujemy sygnały synchronizacji i tła
            out.hcount <= in.hcount;
            out.vcount <= in.vcount;
            out.hsync  <= in.hsync;
            out.vsync  <= in.vsync;
            out.hblnk  <= in.hblnk;
            out.vblnk  <= in.vblnk;
            out.rgb    <= in.rgb;

           
            if ((in.hcount >= rect_posx) && (in.hcount < rect_posx + FIRE_WIDTH*2) &&
                (in.vcount >= rect_posy) && (in.vcount < rect_posy + FIRE_HEIGHT*2)) begin

                int local_x = (in.hcount - rect_posx) >> 1;
                int local_y = (in.vcount - rect_posy) >> 1;
                int sprite_addr = local_y * FIRE_WIDTH + local_x;

                if (sprite_addr < 676 && figure[sprite_addr] != BG_COLOR) begin
                    out.rgb <= figure[sprite_addr];

                    
                    if (!in.hblnk && !in.vblnk && in.rgb == color) begin
                        lose <= 1'b1; 
                    end
                end
            end
        end
    end
endmodule


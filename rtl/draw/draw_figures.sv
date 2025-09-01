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
        input  logic       clk,
        input  logic [11:0] rect_posx,
        input  logic [11:0] rect_posy,

        vga_if.in  in,
        vga_if.out out
    );

    reg [11:0] fire_figure [0:675];


    initial begin
        $readmemh("../../rtl/graphics/fire_figure.dat",  fire_figure);
        // $readmemh("../../rtl/graphics/water_figure.dat", water_figure);
    end


    parameter FIRE_WIDTH   = 26;
    parameter FIRE_HEIGHT  = 26;
    // parameter WATER_WIDTH  = 26;
    // parameter WATER_HEIGHT = 19;
    parameter BG_COLOR     = 12'h452; // kolor tła, który ma być przezroczysty

    always_ff @(posedge clk) begin

        out.hcount <= in.hcount;
        out.vcount <= in.vcount;
        out.hsync  <= in.hsync;
        out.vsync  <= in.vsync;
        out.hblnk  <= in.hblnk;
        out.vblnk  <= in.vblnk;


        out.rgb <= in.rgb;


        if ((in.hcount >= rect_posx) && (in.hcount < rect_posx + FIRE_WIDTH*2) &&
                (in.vcount >= rect_posy) && (in.vcount < rect_posy + FIRE_HEIGHT*2)) begin

            int local_x = (in.hcount - rect_posx) >> 1;
            int local_y = (in.vcount - rect_posy) >> 1;
            int sprite_addr = local_y * FIRE_WIDTH + local_x;

            if (sprite_addr < 676 && fire_figure[sprite_addr] != BG_COLOR) begin
                out.rgb <= fire_figure[sprite_addr];
            end
        end

        /* --- rysowanie wody (zakomentowane) ---
         if ((in.hcount >= rect_posx) && (in.hcount < rect_posx + WATER_WIDTH*2) &&
         (in.vcount >= rect_posy) && (in.vcount < rect_posy + WATER_HEIGHT*2)) begin

         int local_xw = (in.hcount - rect_posx) >> 1;
         int local_yw = (in.vcount - rect_posy) >> 1;
         int sprite_addr_w = local_yw * WATER_WIDTH + local_xw;

         if (sprite_addr_w < 494 && water_figure[sprite_addr_w] != BG_COLOR) begin
         out.rgb <= water_figure[sprite_addr_w];
         end
         end
         */
    end

endmodule

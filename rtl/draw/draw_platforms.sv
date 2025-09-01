<<<<<<< HEAD
/*
* Authors:
* * 2025  AGH University of Science and Technology
* MTM UEC2 Ogień i Woda Infinity Tower
* Aleksandra Gniadek and Joanna Jaśkowiec
*
* Description:
* Draws multiple platforms on the screen using pixel data from .dat files.
*/


module draw_platforms #(
    parameter SCREEN_WIDTH    = 1024,
    parameter SCREEN_HEIGHT   = 768,
    parameter PLATFORM_WIDTH  = 512,
    parameter PLATFORM_HEIGHT = 10,
    parameter N_PLATFORMS    = 10,
    parameter SCALE           = 2 
)(
    input  logic clk, rst,
    vga_if.in  in,
    vga_if.out out
);

    localparam int ROM_SIZE = PLATFORM_WIDTH * PLATFORM_HEIGHT;

    logic [11:0] p0 [0:ROM_SIZE-1];
    logic [11:0] p1 [0:ROM_SIZE-1];
    logic [11:0] p2 [0:ROM_SIZE-1];

    initial begin
        $readmemh("../../rtl/graphics/p0.dat", p0);
        $readmemh("../../rtl/graphics/p1.dat", p1);
        $readmemh("../../rtl/graphics/p2.dat", p2);
    end

    logic [4:0] platform_nr [0:N_PLATFORMS-1];

    initial begin
        platform_nr[0]  = 0;
        platform_nr[1]  = 1;
        platform_nr[2]  = 2;
        platform_nr[3]  = 0;
        platform_nr[4]  = 1;
        platform_nr[5]  = 2;
        platform_nr[6]  = 0;
        platform_nr[7]  = 1;
        platform_nr[8]  = 2;
        platform_nr[9]  = 0;
    end

    localparam int S_WIDTH  = PLATFORM_WIDTH  * SCALE;
    localparam int S_HEIGHT = PLATFORM_HEIGHT * SCALE;

    localparam int X0 = (SCREEN_WIDTH - S_WIDTH) / 2;
    localparam int X1 = X0 + S_WIDTH - 1;

    localparam real GAP = (SCREEN_HEIGHT - N_PLATFORMS*S_HEIGHT) / (N_PLATFORMS-1);

    logic [11:0] rgb_nxt;

    always_comb begin
        rgb_nxt = in.rgb;

        if (!in.hblnk && !in.vblnk && (in.hcount >= X0) && (in.hcount <= X1)) begin
            for (int i = 0; i < N_PLATFORMS; i++) begin
                // równomierne rozmieszczenie od dołu
                int y_start = $rtoi(SCREEN_HEIGHT - S_HEIGHT - i*(S_HEIGHT + GAP));
                int y_end   = y_start + S_HEIGHT - 1;

                if ((in.vcount >= y_start) && (in.vcount <= y_end)) begin
                    int local_x = (in.hcount - X0) / SCALE;
                    int local_y = (in.vcount - y_start) / SCALE;
                    int addr    = local_y * PLATFORM_WIDTH + local_x;

                    case (platform_nr[i])
                        0: rgb_nxt = p0[addr];
                        1: rgb_nxt = p1[addr];
                        2: rgb_nxt = p2[addr];
                        default: ;
                    endcase

                    break;
                end
            end
        end
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            out.hcount <= 0;
            out.vcount <= 0;
            out.hsync  <= 0;
            out.vsync  <= 0;
            out.hblnk  <= 0;
            out.vblnk  <= 0;
            out.rgb    <= 0;
        end else begin
            out.hcount <= in.hcount;
            out.vcount <= in.vcount;
            out.hsync  <= in.hsync;
            out.vsync  <= in.vsync;
            out.hblnk  <= in.hblnk;
            out.vblnk  <= in.vblnk;
            out.rgb    <= rgb_nxt;
        end
    end

endmodule
=======
/**
 * Copyright (C) 2025  AGH University of Science and Technology
 * MTM UEC2
 * Author: Joanna Jaśkowiec & Aleksandra Gniadek
 *
 * Description:
 * Draw platforms figures.
 */

module draw_platforms (
        input  logic clk,
        input  logic [11:0] address,
        input  logic [1:0] platform_type,

        output logic [11:0] rgb
    );

    reg [11:0] platform [0:512];  // 64 x 8 = 512 pixels
    reg [11:0] water [0:490]; // 10 x 49 = 490 pixels
    reg [11:0] fire [0:490];  // 10 x 49 = 490 pixels

    initial begin
        $readmemh("../../rtl/graphics/platform.dat", platform);
        $readmemh("../../rtl/graphics/water.dat", water);
        $readmemh("../../rtl/graphics/fire.dat", fire);
    end

    typedef enum logic [1:0] {
        PLATFORM = 2'b00,
        WATER    = 2'b01,
        FIRE     = 2'b10
    } platform_type_e;

    logic [11:0] rgb_nxt; // - not needed in this module ??

    /**
     * Pixel color output
     */
    always_ff @(posedge clk) begin
        case (platform_type)
            PLATFORM: rgb <= platform[address];
            WATER:    rgb <= water[address];
            FIRE:     rgb <= fire[address];
            default:  rgb <= rgb_nxt; // Default case to avoid latches
        endcase
    end

endmodule 
>>>>>>> origin/main

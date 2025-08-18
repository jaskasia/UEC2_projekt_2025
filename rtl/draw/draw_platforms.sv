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
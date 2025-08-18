/**
 * Copyright (C) 2025  AGH University of Science and Technology
 * MTM UEC2
 * Author: Aleksandra Gniadek & Joanna Jaśkowiec
 *
 * Description:
 * Draw playable figures.
 */

module draw_figures (
        input  logic clk,
        input  logic [11:0] address,

        output logic [11:0] rgb
    );

    reg [11:0] fire_figure [0:676];  // 26 x 26 = 676 pixels
    reg [11:0] water_figure [0:494]; // 26 x 19 = 494 pixels

    initial begin
        $readmemh("../../rtl/graphics/fire_figure.dat", fire_figure);
        $readmemh("../../rtl/graphics/water_figure.dat", water_figure);
    end


    /**
     * Local variables and signals
     */

    logic [11:0] rgb_nxt;


    /**
     * Pixel color output
     */
    always_ff @(posedge clk) begin
        rgb <= fire_figure[address];
    end

endmodule 
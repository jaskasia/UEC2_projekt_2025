/**
 * Copyright (C) 2025  AGH University of Science and Technology
 * MTM UEC2
 * Author: Joanna Jaśkowiec
 *
 * Description:
 * Vga timing controller.
 */

module vga_timing (
        input  logic clk,
        input  logic rst,
        output logic [10:0] vcount,
        output logic vsync,
        output logic vblnk,
        output logic [10:0] hcount,
        output logic hsync,
        output logic hblnk
    );

    timeunit 1ns;
    timeprecision 1ps;

    import vga_pkg::*;

    /**
     * Local variables and signals
     */

// Add your signals and variables here.
    logic [10:0] vcount_nxt, hcount_nxt;
    logic vsync_nxt, vblnk_nxt, hsync_nxt, hblnk_nxt;

    /**
     * Internal logic
     */

// Add your code here.

    always_comb begin: timing_comb
        if (hcount == HOR_TOTAL_TIME - 1) begin
            hcount_nxt = 0;

            if (vcount == VER_TOTAL_TIME - 1) begin
                vcount_nxt = 0;
            end else begin
                vcount_nxt = vcount + 1;
            end
        end else begin
            hcount_nxt = hcount + 1;
            vcount_nxt = vcount;
        end
    end

    always_ff @(posedge clk) begin: timing_ff
        if (rst) begin
            hcount <= 0;
            vcount <= 0;
            hsync <= 0;
            vsync <= 0;
            hblnk <= 0;
            vblnk <= 0;
        end else begin
            hcount <= hcount_nxt;
            vcount <= vcount_nxt;
            hsync <= hsync_nxt;
            vsync <= vsync_nxt;
            hblnk <= hblnk_nxt;
            vblnk <= vblnk_nxt;
        end
    end

    always_comb begin: condition_comb


        hblnk_nxt = (hcount >= HOR_PIXELS - 1 && hcount < HOR_TOTAL_TIME - 1 );
        hsync_nxt = (hcount >= HOR_SYNC_START - 1 && hcount < HOR_SYNC_END);

        if ((hcount == HOR_TOTAL_TIME - 1) && (vcount == VER_PIXELS - 1)) begin
            vblnk_nxt = 1;
        end else if ((hcount == HOR_TOTAL_TIME - 1) && (vcount == VER_TOTAL_TIME - 1)) begin
            vblnk_nxt = 0;
        end else begin
            vblnk_nxt = vblnk;
        end

        if ((hcount == HOR_TOTAL_TIME - 1) && (vcount == VER_SYNC_START - 1)) begin
            vsync_nxt = 1;
        end else if ((hcount == HOR_TOTAL_TIME - 1) && (vcount == VER_SYNC_END)) begin
            vsync_nxt = 0;
        end else begin
            vsync_nxt = vsync;
        end

    end

endmodule

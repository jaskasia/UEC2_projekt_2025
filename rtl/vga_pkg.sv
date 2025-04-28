/**
 * Copyright (C) 2025  AGH University of Science and Technology
 * MTM UEC2
 * Author: Joanna Jaśkowiec
 *
 * Description:
 * Package with vga related constants.
 */

package vga_pkg;

    // Parameters for VGA Display 1024 x 768 @ 60fps using a 40 MHz clock;
    localparam HOR_PIXELS = 1024;
    localparam VER_PIXELS = 768;

    // Add VGA timing parameters here and refer to them in other modules.
    localparam HOR_TOTAL_TIME = 1344;
    localparam VER_TOTAL_TIME = 806;

    localparam HOR_SYNC_START = 1048;
    localparam HOR_SYNC_END = 1183; //136 (Hor Sync Time)

    localparam VER_SYNC_START = 771;
    localparam VER_SYNC_END = 776; //6 (Ver Sync Time)

endpackage

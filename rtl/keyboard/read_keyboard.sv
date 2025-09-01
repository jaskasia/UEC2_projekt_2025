// Copyright (C) 2025  AGH University of Science and Technology
// MTM UEC2
// Author: Katarzyna Morga
// Modified by: Aleksandra Gniadek, Joanna Jaśkowiec
/**
 * Description:
 * Converts PS/2 keycodes to ASCII characters.
 * - Outputs ASCII value for valid keys.
 * - Flags new character with `newchar`.
 * - Detects Enter and Backspace presses.
 * - Ignores key release (break) codes.
 */

`timescale 1ns / 1ps

module read_keyboard(
    input clk,
    input rst,
    input [7:0] keycode,
    input oflag,
    output wire newchar,
    output logic enter = 0,
    output logic spacebar = 0,
    output logic key_w = 0,
    output logic key_a = 0,
    output logic key_d = 0
);

    wire break_code = keycode[7];
    logic char_processed;
    assign newchar = char_processed && (|keycode[7:0]);

    always @(posedge clk) begin
        if (rst) begin
            char_processed <= 0;
            enter <= 0;
            spacebar <= 0; 
            key_w <= 0;
            key_a <= 0;
            key_d <= 0;
        end else if (oflag && !break_code) begin
            if (keycode[7:0] == 8'h5A) enter <= 1; // Enter key
            if (keycode[7:0] == 8'h29) spacebar <= 1; // Spacebar key
            if (keycode[7:0] == 8'h1D) key_w <= 1; // 'W' key
            if (keycode[7:0] == 8'h1C) key_a <= 1; // 'A' key
            if (keycode[7:0] == 8'h23) key_d <= 1; // 'D' key
            char_processed <= 1;
        end else begin
            char_processed <= 0;
            key_w <= 0;
            key_a <= 0;
            key_d <= 0;
            enter <= 0;
            spacebar <= 0;
        end
    end

endmodule
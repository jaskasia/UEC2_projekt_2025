/**
 * Copyright (C) 2025  AGH University of Science and Technology
 * MTM UEC2
 * Author: Joanna Jaśkowiec
 *
 * Description:
 * Handles keyboard input for controlling the game character.
 */

module keyboard_ctl (
        input logic clk,
        input logic rst,
        input logic [7:0] rx_data,
        input logic rx_done_tick,

        output logic key_jump,
        output logic key_left,
        output logic key_right
    );

    timeunit 1ns;
    timeprecision 1ps;

    localparam KEY_W = 8'h1D;
    localparam KEY_A = 8'h1C;
    localparam KEY_D = 8'h23;
    localparam KEY_RELEASE = 8'hF0;

    logic release_flag;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            key_jump <= 1'b0;
            key_left <= 1'b0;
            key_right <= 1'b0;
            release_flag <= 1'b0;
        end else if (rx_done_tick) begin
            if (rx_data == KEY_RELEASE) begin
                release_flag <= 1'b1;
            end else begin
                case (rx_data)
                    KEY_W: key_jump  <= !release_flag;
                    KEY_A: key_left  <= !release_flag;
                    KEY_D: key_right <= !release_flag;
                    default: begin
                        if (release_flag) begin
                            key_jump  <= 1'b0;
                            key_left  <= 1'b0;
                            key_right <= 1'b0;
                        end
                    end
                endcase
                release_flag <= 1'b0;
            end
        end
    end
endmodule
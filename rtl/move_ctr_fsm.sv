/**
 * Copyright (C) 2025  AGH University of Science and Technology
 * MTM UEC2
 * Author: Joanna Jaśkowiec
 *
 * Description:
 * This module is responsible for determining the direction of a character's movement based on user input (keyboard),
 * and outputs a signal representing the current navigation state (STAND, UP, DOWN, LEFT, RIGHT). 
 */

 module move_ctr_fsm (
    input  logic clk,
    input  logic rst,
    input  logic up,        
    input  logic down,     
    input  logic left,     
    input  logic right,
    input  logic on_the_ground,     
    output logic [2:0] nav_state 
);

    // States
    parameter STAND = 3'b000;
    parameter UP = 3'b001;
    parameter DOWN = 3'b010;
    parameter LEFT = 3'b011;
    parameter RIGHT = 3'b100;

    logic [2:0] nav_state_nxt, current_state;

    assign nav_state = current_state;

    // FSM register
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= STAND;
        end else begin
            current_state <= nav_state_nxt;
        end
    end

    // FSM transitions
    always_comb begin
        nav_state_nxt = current_state;
        case (current_state)
            STAND: begin
                if (!on_the_ground) begin
                    nav_state_nxt = DOWN; 
                end else if (up) begin
                    nav_state_nxt = UP;
                end else if (left) begin
                    nav_state_nxt = LEFT;
                end else if (right) begin
                    nav_state_nxt = RIGHT;
                end else begin
                    nav_state_nxt = STAND; 
                end
            end

            UP: begin
                if (!on_the_ground) begin
                    nav_state_nxt = DOWN; 
                end else begin
                    nav_state_nxt = STAND; 
                end
            end

            DOWN: begin
                if (on_the_ground) begin
                    nav_state_nxt = STAND; 
                end else if (left) begin
                    nav_state_nxt = LEFT;
                end else if (right) begin
                    nav_state_nxt = RIGHT;
                end else begin
                    nav_state_nxt = DOWN; 
                end
            end

            LEFT: begin
                if (!on_the_ground) begin
                    nav_state_nxt = DOWN; 
                end else if (up) begin
                    nav_state_nxt = UP;
                end else if (!left) begin
                    nav_state_nxt = STAND; 
                end else begin
                    nav_state_nxt = LEFT;
                end
            end

            RIGHT: begin
                if (!on_the_ground) begin
                    nav_state_nxt = DOWN; 
                end else if (up) begin
                    nav_state_nxt = UP;
                end else if (!right) begin
                    nav_state_nxt = STAND; 
                end else begin
                    nav_state_nxt = RIGHT;
                end
            end

            default: begin
                nav_state_nxt = STAND; 
            end
        endcase
    end

endmodule
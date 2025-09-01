/*
* Authors:
* * 2025  AGH University of Science and Technology
* MTM UEC2 Ogień i Woda Infinity Tower
* Alesandra Gniadek, Joanna Jaskowiec
*
* Description:
* Module to control character movement using FSM
*/


module move_ctr_fsm (
    input  logic        clk,
    input  logic        rst,
    input  logic        key_w,       // skok - przycisk "w" 
    input  logic        key_a,       // ruch w lewo - przycisk "a" 
    input  logic        key_d,       // ruch w prawo - przycisk "d" 
 
    output logic [11:0] pos_x,       
    output logic [11:0] pos_y        
);
    import vga_pkg::*;


    localparam HOR_SPEED   = 3;         
    localparam JUMP_HEIGHT = 100;       
    localparam COUNTER_HOR = 10000;    
    localparam COUNTER_VER = 150000;   
 

    typedef enum logic [2:0] {
        STAND      = 3'b000,
        JUMP       = 3'b001,
        FALL       = 3'b010,
        MOVE_LEFT  = 3'b011,
        MOVE_RIGHT = 3'b100
    } state_t;
 
    state_t state, state_nxt;
 
    logic [11:0] pos_x_nxt, pos_y_nxt;
    logic [11:0] y_jump_start, y_jump_start_nxt;
 
    logic [$clog2(COUNTER_HOR)-1:0] hor_cnt;
    logic [$clog2(COUNTER_VER)-1:0] ver_cnt;
    logic tick_hor, tick_ver;
 
    always_ff @(posedge clk) begin
        if (rst) begin
            hor_cnt <= '0;
            ver_cnt <= '0;
        end else begin
            hor_cnt <= (hor_cnt == COUNTER_HOR-1) ? 0 : hor_cnt + 1;
            ver_cnt <= (ver_cnt == COUNTER_VER-1) ? 0 : ver_cnt + 1;
        end
    end
 
    assign tick_hor = (hor_cnt == 0);
    assign tick_ver = (ver_cnt == 0);
 
    always_ff @(posedge clk) begin
        if (rst) begin
            state        <= STAND;
            pos_x        <= 12'd100;
            pos_y        <= 12'd500;
            y_jump_start <= 12'd500;
        end else begin
            state        <= state_nxt;
            pos_x        <= pos_x_nxt;
            pos_y        <= pos_y_nxt;
            y_jump_start <= y_jump_start_nxt;
        end
    end
 
    always_comb begin
        state_nxt = state;
        case (state)
            STAND: begin
                if (key_w)
                    state_nxt = JUMP;
                else if (key_a)
                    state_nxt = MOVE_LEFT;
                else if (key_d)
                    state_nxt = MOVE_RIGHT;
            end
 
            JUMP: begin
                if (pos_y <= (y_jump_start - JUMP_HEIGHT))
                    state_nxt = FALL;
            end
 
            FALL: begin
                if ( pos_y == y_jump_start - 83)
                    state_nxt = STAND;
            end
 
            MOVE_LEFT: begin
                if (!key_a)
                    state_nxt = STAND;
            end
 
            MOVE_RIGHT: begin
                if (!key_d)
                    state_nxt = STAND;
            end
 
            default: state_nxt = STAND;
        endcase
    end
 
    always_comb begin
        pos_x_nxt        = pos_x;
        pos_y_nxt        = pos_y;
        y_jump_start_nxt = y_jump_start;
 
        case (state)
            STAND: begin
                if (key_a) begin
                    pos_x_nxt = (pos_x > HOR_SPEED) ? pos_x - HOR_SPEED : 12'd0;
                    y_jump_start_nxt = y_jump_start;
                end else if (key_d) begin
                    pos_x_nxt = (pos_x < HOR_PIXELS - HOR_SPEED) ? pos_x + HOR_SPEED : pos_x;
                    y_jump_start_nxt = y_jump_start;
                end
                else if(key_w) begin
                //    pos_y_nxt = (pos_y > 0) ? pos_y - 1 : pos_y;
                    y_jump_start_nxt = pos_y; // ustawienie punktu startowego skoku
                
                end else begin
                    pos_x_nxt = pos_x;
                    y_jump_start_nxt = y_jump_start;
                end
            end
 
            JUMP: begin
                if (tick_hor) begin
                    if (key_a && pos_x > HOR_SPEED)
                        pos_x_nxt = pos_x - HOR_SPEED;
                    else if (key_d && pos_x < HOR_PIXELS - HOR_SPEED)
                        pos_x_nxt = pos_x + HOR_SPEED;
                    else
                        pos_x_nxt = pos_x;
                end

                if (tick_ver) begin
                    pos_y_nxt = (pos_y == 0) ? pos_y : pos_y - 1;
                end
            end
 
            FALL: begin
                if (tick_hor) begin
                    if (key_a && pos_x > HOR_SPEED)
                        pos_x_nxt = pos_x - HOR_SPEED;
                    else if (key_d && pos_x < HOR_PIXELS - HOR_SPEED)
                        pos_x_nxt = pos_x + HOR_SPEED;
                    else
                        pos_x_nxt = pos_x;
                end
 
                if (tick_ver) begin
                    if (pos_y >= y_jump_start)
                        pos_y_nxt = y_jump_start;
                    else
                        pos_y_nxt = pos_y + 1;
                end
            end
 
            MOVE_LEFT: begin
                if (tick_hor && pos_x > HOR_SPEED)
                    pos_x_nxt = pos_x - HOR_SPEED;
            end
 
            MOVE_RIGHT: begin
                if (tick_hor && pos_x < HOR_PIXELS - HOR_SPEED)
                    pos_x_nxt = pos_x + HOR_SPEED;
            end
        endcase
    end
 
endmodule

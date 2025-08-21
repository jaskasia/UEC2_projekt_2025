module player_ctl (
        input  logic        clk,
        input  logic        rst,
        input  logic        key_w,       // skok - przycisk "w"
        input  logic        key_a,       // ruch w lewo - przycisk "a"
        input  logic        key_d,       // ruch w prawo - przycisk "d"
        input  logic        on_the_ground, // sygnał dotknięcia podłoża 

        output logic [11:0] pos_x,       // pozycja X postaci
        output logic [11:0] pos_y        // pozycja Y postaci
    );

    import vga_pkg::*;

    // --- Stałe gry ---
    localparam CLK_FREQ     = 6_500_000;
    localparam TIC     = 100;
    localparam TIC_DURATION      = (CLK_FREQ / TIC) - 1;
    localparam G            = 4;   // grawitacja
    localparam VELOCITY     = 15;  // początkowa prędkość skoku
    localparam SCALE          = 10;  // skalowanie
    localparam HOR_SPEED   = 3;   // prędkość w poziomie

    // --- Stany FSM ---
    typedef enum logic [2:0] {
        STAND = 3'b000,
        JUMP = 3'b001,
        FALL = 3'b010,
        MOVE_LEFT = 3'b011,
        MOVE_RIGHT = 3'b100
    } state_t;

    state_t state, state_nxt;

    // --- Rejestry fizyki ruchu ---
    logic [31:0] vel_time, vel_time_nxt;   // licznik czasu lotu
    logic [11:0] pos_x_nxt, pos_y_nxt;
    logic [11:0] y_jump_start, y_jump_start_nxt;
    logic [31:0] counter, counter_nxt;
    logic        top_reached;

    // --- Blok rejestrów ---
    always_ff @(posedge clk) begin
        if (rst) begin
            state         <= STAND;
            pos_x         <= 12'd100;
            pos_y         <= VER_PIXELS - 50;
            y_jump_start  <= VER_PIXELS - 50;
            vel_time      <= 0;
            counter       <= 0;
        end else begin
            state         <= state_nxt;
            pos_x         <= pos_x_nxt;
            pos_y         <= pos_y_nxt;
            y_jump_start  <= y_jump_start_nxt;
            vel_time      <= vel_time_nxt;
            counter       <= counter_nxt;
        end
    end

    // --- FSM ---
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
                if (top_reached)
                    state_nxt = FALL;
            end

            FALL: begin
                if (on_the_ground)
                    state_nxt = STAND;
            end

            MOVE_LEFT: begin
                if (!key_a)
                    state_nxt = STAND;
                else if (!on_the_ground)
                    state_nxt = FALL;
            end

            MOVE_RIGHT: begin
                if (!key_d)
                    state_nxt = STAND;
                else if (!on_the_ground)
                    state_nxt = FALL;
            end

            default: state_nxt = STAND;
        endcase
    end

    // --- Logika ruchu ---
    always_comb begin
        pos_x_nxt        = pos_x;
        pos_y_nxt        = pos_y;
        y_jump_start_nxt = y_jump_start;
        vel_time_nxt     = vel_time;
        counter_nxt      = counter;
        top_reached      = 1'b0;

        case (state)
            STAND: begin
                vel_time_nxt = 0;
                if (key_a && pos_x > HOR_SPEED)
                    pos_x_nxt = pos_x - HOR_SPEED;
                else if (key_d && pos_x < HOR_PIXELS - HOR_SPEED)
                    pos_x_nxt = pos_x + HOR_SPEED;
                if (key_w) begin
                    y_jump_start_nxt = pos_y;
                    vel_time_nxt     = 0;
                end
            end

            JUMP: begin
                if (counter == TIC_DURATION) begin
                    counter_nxt = 0;
                    vel_time_nxt = vel_time + 1;

                    // obliczenie pozycji pionowej
                    pos_y_nxt = y_jump_start + ((G * vel_time * vel_time) / (2 * SCALE)) - (VELOCITY * vel_time);

                    if ((G * vel_time) >= (VELOCITY * SCALE))
                        top_reached = 1'b1;
                end else begin
                    counter_nxt = counter + 1;
                end

                // ruch w poziomie w locie
                if (key_a && pos_x > HOR_SPEED)
                    pos_x_nxt = pos_x - HOR_SPEED;
                else if (key_d && pos_x < HOR_PIXELS - HOR_SPEED)
                    pos_x_nxt = pos_x + HOR_SPEED;
            end

            FALL: begin
                if (counter == TIC_DURATION) begin
                    counter_nxt = 0;
                    vel_time_nxt = vel_time + 1;

                    pos_y_nxt = pos_y + ((G * vel_time * vel_time) / (2 * SCALE));

                    if (on_the_ground) begin
                        vel_time_nxt = 0;
                    end
                end else begin
                    counter_nxt = counter + 1;
                end

                // ruch w poziomie podczas spadania
                if (key_a && pos_x > HOR_SPEED)
                    pos_x_nxt = pos_x - HOR_SPEED;
                else if (key_d && pos_x < HOR_PIXELS - HOR_SPEED)
                    pos_x_nxt = pos_x + HOR_SPEED;
            end

            MOVE_LEFT: begin
                if (pos_x > HOR_SPEED)
                    pos_x_nxt = pos_x - HOR_SPEED;
            end

            MOVE_RIGHT: begin
                if (pos_x < HOR_PIXELS - HOR_SPEED)
                    pos_x_nxt = pos_x + HOR_SPEED;
            end
        endcase
    end

endmodule



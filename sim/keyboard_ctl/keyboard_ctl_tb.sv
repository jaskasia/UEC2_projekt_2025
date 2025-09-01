module keyboard_ctl_tb;

    // --- Clock parameters ---
    localparam CLK_PERIOD_NS = 20; // 50 MHz clock

    // --- Signals ---
    logic clk, rst;
    logic [7:0] rx_data;
    logic rx_done_tick;
    logic key_jump, key_left, key_right;

    // --- DUT ---
    keyboard_ctl dut (
        .clk(clk),
        .rst(rst),
        .rx_data(rx_data),
        .rx_done_tick(rx_done_tick),
        .key_jump(key_jump),
        .key_left(key_left),
        .key_right(key_right)
    );

    // --- Clock generation ---
    initial begin
        clk = 0;
        forever #(CLK_PERIOD_NS/2) clk = ~clk;
    end

    // --- Task to send one scancode byte ---
    task send_code(input [7:0] code);
        begin
            rx_data = code;
            rx_done_tick = 1;
            @(posedge clk);
            rx_done_tick = 0;
            repeat (2) @(posedge clk); // odstęp czasowy
        end
    endtask

    // --- Test sequence ---
    initial begin
        // --- Init ---
        rst = 1;
        rx_data = 0;
        rx_done_tick = 0;
        repeat (5) @(posedge clk);
        rst = 0;

        // --- Press W ---
        $display("=== Press W (jump) ===");
        send_code(8'h1D); // W make
        repeat (5) @(posedge clk);
        assert(key_jump) else $error("key_jump should be active!");

        // --- Release W ---
        $display("=== Release W ===");
        send_code(8'hF0); // release prefix
        send_code(8'h1D); // W break
        repeat (5) @(posedge clk);
        assert(!key_jump) else $error("key_jump should be inactive!");

        // --- Press A + D simultaneously ---
        $display("=== Press A + D ===");
        send_code(8'h1C); // A make
        send_code(8'h23); // D make
        repeat (5) @(posedge clk);
        assert(key_left && key_right) else $error("A+D should both be active!");

        // --- Release only A ---
        $display("=== Release A ===");
        send_code(8'hF0);
        send_code(8'h1C); // A break
        repeat (5) @(posedge clk);
        assert(!key_left && key_right) else $error("Only D should remain active!");

        // --- Release D ---
        $display("=== Release D ===");
        send_code(8'hF0);
        send_code(8'h23); // D break
        repeat (5) @(posedge clk);
        assert(!key_left && !key_right) else $error("Both keys should be inactive!");

        // --- Press W + D together ---
        $display("=== Press W + D ===");
        send_code(8'h1D); // W make
        send_code(8'h23); // D make
        repeat (5) @(posedge clk);
        assert(key_jump && key_right) else $error("W+D should be active!");

        // --- Release W ---
        $display("=== Release W ===");
        send_code(8'hF0);
        send_code(8'h1D); // W break
        repeat (5) @(posedge clk);
        assert(!key_jump && key_right) else $error("Only D should remain active!");

        // --- Release D ---
        $display("=== Release D ===");
        send_code(8'hF0);
        send_code(8'h23); // D break
        repeat (5) @(posedge clk);
        assert(!key_jump && !key_right) else $error("All keys should be inactive!");

        $display("Simulation complete.");
        $finish;
    end

endmodule

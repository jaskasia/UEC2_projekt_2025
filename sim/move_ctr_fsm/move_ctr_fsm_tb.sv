module move_ctr_fsm_tb;

  // --- Clock parameters ---
  localparam CLK_PERIOD_NS = 15.38; // ~6.5 MHz clock

  // --- Signals ---
  logic clk, rst;
  logic key_a, key_d, key_w;
  logic [11:0] pos_x, pos_y;

  // --- DUT ---
  move_ctr_fsm dut (
    .clk(clk),
    .rst(rst),
    .key_a(key_a),
    .key_d(key_d),
    .key_w(key_w),
    .pos_x(pos_x),
    .pos_y(pos_y)
  );

  // --- Clock generation ---
  initial begin
    clk = 0;
    forever #(CLK_PERIOD_NS/2) clk = ~clk;
  end

  // --- Test sequence ---
  initial begin
    // --- Init ---
    rst   = 1;
    key_a = 0;
    key_d = 0;
    key_w = 0;
    repeat (5) @(posedge clk);
    rst = 0;

    // --- Move right only ---
    $display("=== Move right only ===");
    key_d = 1;
    repeat (40) #200_000;
    key_d = 0;

    // --- Move left only ---
    $display("=== Move left only ===");
    key_a = 1;
    repeat (40) #200_000;
    key_a = 0;


    // --- Jump + Move right ---
    $display("=== Jump + Move right ===");
    key_w = 1;
    key_d = 1;
    repeat (60) #200_000;
    key_w = 0;
    key_d = 0;

    // --- Jump + Move left ---
    $display("=== Jump + Move left ===");
    key_w = 1;
    key_a = 1;
    repeat (60) #20_000;
    key_w = 0;
    key_a = 0;

        // --- Jump only ---
    $display("=== Jump only ===");
    key_w = 1;
    repeat (20) #20_000;
    key_w = 0;

    // --- Idle after actions ---
    repeat (20) #20_000;

    $display("Simulation complete.");
    $finish;
  end

endmodule

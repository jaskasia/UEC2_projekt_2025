/**
 *  Copyright (C) 2025  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk, Joanna Jaśkowiec
 *
 * Description:
 * Testbench for vga_timing module.
 */

 module vga_timing_tb;

    timeunit 1ns;
    timeprecision 1ps;

    import vga_pkg::*;


    /**
     *  Local parameters
     */

    localparam CLK_PERIOD = 25;     // 40 MHz

    /**
     * Local variables and signals
     */

    logic clk;
    logic rst;

    wire [10:0] vcount, hcount;
    wire        vsync,  hsync;
    wire        vblnk,  hblnk;


    /**
     * Clock generation
     */

    initial begin
        clk = 1'b0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end


    /**
     * Reset generation
     */

    initial begin
        rst = 1'b0;
        #(1.25*CLK_PERIOD) rst = 1'b1;
        rst = 1'b1;
        #(2.00*CLK_PERIOD) rst = 1'b0;
    end

    /**
     * Dut placement
     */

    vga_timing dut(
        .clk,
        .rst,
        .vcount,
        .vsync,
        .vblnk,
        .hcount,
        .hsync,
        .hblnk
    );

    /**
     * Tasks and functions
     */

    // Here you can declare tasks with immediate assertions (assert).
    task test_hcount_max;
        assert (hcount <= HOR_TOTAL_TIME - 1) //1055
            $error("The hcount value is wrong");
    endtask

    task test_vcount_max;
        assert (vcount <= VER_TOTAL_TIME - 1) //627
            $error("The vcount value is wrong.");
    endtask

    /**
     * Assertions
     */

    // Here you can declare concurrent assertions (assert property).
    assert property (@(posedge clk) ((hcount >= HOR_PIXELS) && (hcount <= HOR_TOTAL_TIME - 1)) |-> hblnk == 1) else
        $error("Inocrrect hblnk value.");
    
    assert property (@(posedge clk) ((vcount >= VER_PIXELS) && (vcount <= VER_TOTAL_TIME - 1)) |-> vblnk == 1) else
        $error("Incorrect vblnk value.");

    assert property (@(posedge clk) ((hcount >= HOR_SYNC_START) && (hcount <= HOR_SYNC_END)) |-> hsync == 1) else
        $error("Incorrect hsync value.");

    assert property (@(posedge clk) ((vcount >= VER_SYNC_START) && (vcount <= VER_SYNC_END)) |-> vsync == 1) else
        $error("Incorrect vsync value.");

    /**
     * Main test
     */

    initial begin
        @(posedge rst);
        @(negedge rst);

        wait (vsync == 1'b0);
        @(negedge vsync);
        @(negedge vsync);

        $finish;
    end

endmodule

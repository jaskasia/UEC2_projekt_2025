interface vga_if();
    timeunit 1ns;
    timeprecision 1ps;
    logic [10:0] vcount, hcount;
    logic vsync, hsync;
    logic vblnk, hblnk;
    logic [11:0] rgb;

modport in (input hcount, hsync, hblnk, vcount, vsync, vblnk, rgb);
modport out (output hcount, hsync, hblnk, vcount, vsync, vblnk, rgb);

endinterface
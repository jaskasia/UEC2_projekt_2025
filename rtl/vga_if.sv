<<<<<<< HEAD
/*
* Authors:
* * 2025  AGH University of Science and Technology
* MTM UEC2 Ogień i Woda Infinity Tower
* Aleksandra Gniadek and Joanna Jaśkowiec
*
* Description:
* VGA interface definition
*/

=======
>>>>>>> origin/main
interface vga_if();
    timeunit 1ns;
    timeprecision 1ps;
    logic [10:0] vcount, hcount;
    logic vsync, hsync;
    logic vblnk, hblnk;
<<<<<<< HEAD
    logic [11:0] rgb = 12'h000;
=======
    logic [11:0] rgb;
>>>>>>> origin/main

modport in (input hcount, hsync, hblnk, vcount, vsync, vblnk, rgb);
modport out (output hcount, hsync, hblnk, vcount, vsync, vblnk, rgb);

<<<<<<< HEAD
endinterface
=======
endinterface
>>>>>>> origin/main

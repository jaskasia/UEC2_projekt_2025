/**
 * San Jose State University
 * EE178 Lab #4
 * Author: prof. Eric Crabilla
 *
 * Modified by:
 * 2025  AGH University of Science and Technology
 * MTM UEC2
 * Piotr Kaczmarczyk
 *
 * Description:
 * Top level synthesizable module including the project top and all the FPGA-referred modules.
 */

 module top_vga_basys3 (
    input  wire clk,
    input  wire btnC,
    output wire Vsync,
    output wire Hsync,
    output wire [3:0] vgaRed,
    output wire [3:0] vgaGreen,
    output wire [3:0] vgaBlue,
    input wire PS2Clk,
    input wire PS2Data
);

timeunit 1ns;
timeprecision 1ps;

    /**
     * Local variables and signals
     */

     wire clk65MHz;
     wire locked;
 
     /**
      * FPGA submodules placement
      */
     
     // Mirror pclk on a pin for use by the testbench;
     // not functionally required for this design to work.
 
 
     clk_wiz_project u_clk_wiz_project (
         .clk,
         .clk_65MHz(clk65MHz),
         .locked(locked)
         );
         

/**
 *  Project functional top module
 */

top_vga u_top_vga (
    .clk65MHz(clk65MHz),
    .rst(btnC),
    .r(vgaRed),
    .g(vgaGreen),
    .b(vgaBlue),
    .hs(Hsync),
    .vs(Vsync),
    .ps2_clk(PS2Clk),
    .ps2_data(PS2Data)
);


endmodule


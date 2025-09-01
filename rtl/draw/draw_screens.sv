/*
* Authors:
* * 2025  AGH University of Science and Technology
* MTM UEC2 Ogień i Woda Infinity Tower
* Joanna Jaśkowiec
*
* Description:
* Draws the start screen with an image that can be dismissed by pressing Enter or Space.
*/


module draw_screens #(
    parameter H_RES = 1024,
    parameter V_RES = 768,
    parameter START_IMG_W = 256,
    parameter START_IMG_H = 192,
    parameter LOSE_IMG_W = 256,
    parameter LOSE_IMG_H = 192,
    parameter SCALE = 4
)(
    input  logic clk,
    input  logic rst,
    input  logic key_enter,
    input  logic key_space,
    input  logic [11:0] hcount,
    input  logic [11:0] vcount,
    input logic start_game,
    output logic [11:0] rgb_start,
    //
    input  logic lose
);
 
    localparam S_W = START_IMG_W * SCALE;
    localparam S_H = START_IMG_H * SCALE;
 
    localparam X_START = (H_RES - S_W)/2;
    localparam Y_START = (V_RES - S_H)/2;
 
    
    logic [11:0] start_text_full [0:START_IMG_W*START_IMG_H-1];
    logic [11:0] you_lose [0:START_IMG_W*START_IMG_H-1];
    initial $readmemh("../../rtl/graphics/start_text_full.dat", start_text_full);
    initial $readmemh("../../rtl/graphics/next_time.dat", you_lose);
 
    
    wire in_img_area = (hcount >= X_START) && (hcount < X_START+S_W) &&
                       (vcount >= Y_START) && (vcount < Y_START+S_H);
 
    
    logic start_active;
    always_ff @(posedge clk) begin
        if (rst)
            start_active <= 1'b1;
        else if (key_enter || key_space|| start_game)
            start_active <= 1'b0;
     //   
     //   else if (lose)
      //      start_active <= 1'b1;
    end
 
    
    logic [11:0] pixel_rgb;
    always_comb begin
        integer local_x, local_y, addr;
 
        if (in_img_area && start_active) begin
            local_x = (hcount - X_START)/SCALE;
            if (local_x >= START_IMG_W) local_x = START_IMG_W-1;
 
            local_y = (vcount - Y_START)/SCALE;
            if (local_y >= START_IMG_H) local_y = START_IMG_H-1;
 
            addr = local_y * START_IMG_W + local_x;
            pixel_rgb = start_text_full[addr];
        end else begin
            pixel_rgb = 12'h000; 
        end
    end


    /*logic [11:0] pixel_rgb;
    always_comb begin
        integer local_x, local_y, addr;
 
        if (in_img_area && start_active &&) begin
            local_x = (hcount - X_START)/SCALE;
            if (local_x >= START_IMG_W) local_x = START_IMG_W-1;
 
            local_y = (vcount - Y_START)/SCALE;
            if (local_y >= START_IMG_H) local_y = START_IMG_H-1;
 
            addr = local_y * START_IMG_W + local_x;
            pixel_rgb = start_text_full[addr];
        end else begin
            pixel_rgb = 12'h000; 
        end
    end */
 
    assign rgb_start = pixel_rgb;
 
endmodule
 
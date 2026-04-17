`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2026 00:29:13
// Design Name: 
// Module Name: renderer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module renderer(
    input logic [9:0] current_x,
    input logic [9:0] current_y,
    input logic [9:0] camera_x,
    input logic [9:0] camera_y,
    input logic [9:0] player_x,
    input logic [9:0] player_y, 
    input logic [1:0] player_dir,
    output logic [7:0] final_pixel_idx
    );
    
    import world_pkg::*;
   
    logic [5:0] map_tile_x;
    logic [5:0] map_tile_y;
    logic [3:0] tile_px;
    logic [3:0] tile_py;
    logic [7:0] tile_id;
    logic [7:0] tile_pixel_idx;
    
    logic [10:0] sample_world_x;
    logic [10:0] sample_world_y;
    
    assign sample_world_x = camera_x + current_x;
    assign sample_world_y = camera_y + current_y;
    
    assign map_tile_x = sample_world_x[9:4];
    assign map_tile_y = sample_world_y[9:4];
    assign tile_px    = sample_world_x[3:0];
    assign tile_py    = sample_world_y[3:0];
    
    tilemap_rom map_inst (
        .tile_x(map_tile_x),
        .tile_y(map_tile_y),
        .tile_id(tile_id)
    );
    
    tile_rom tile_inst (
        .tile_id(tile_id),
        .tile_px(tile_px),
        .tile_py(tile_py),
        .pixel_idx(tile_pixel_idx)
    );

    
    always_comb begin
        final_pixel_idx = tile_pixel_idx;

        if ((sample_world_x >= player_x) && (sample_world_x <= player_x + PLAYER_SIZE - 1) &&
            (sample_world_y >= player_y) && (sample_world_y <= player_y + PLAYER_SIZE - 1)) begin

            case (player_dir)
                DIR_UP: final_pixel_idx = 8'd3; // player_up
                DIR_DOWN: final_pixel_idx = 8'd4; // player_down
                DIR_LEFT: final_pixel_idx = 8'd5; // player_left
                DIR_RIGHT: final_pixel_idx = 8'd6; // player_right
                default: final_pixel_idx = 8'd3;
            endcase
        end
    end

endmodule

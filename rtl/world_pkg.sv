`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2026 14:33:24
// Design Name: 
// Module Name: world_pkg
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


package world_pkg;

    typedef enum logic [7:0] {
        TILE_GRASS = 8'd0,
        TILE_PATH  = 8'd1,
        TILE_WATER = 8'd2
    } tile_id_t;
    
    typedef enum logic [1:0] {
        DIR_UP    = 2'd0,
        DIR_DOWN  = 2'd1,
        DIR_LEFT  = 2'd2,
        DIR_RIGHT = 2'd3
    } player_dir_t;

    localparam int TILE_SIZE = 16;
    localparam int PLAYER_SIZE = 10;
    localparam int SCREEN_W = 640;
    localparam int SCREEN_H = 480;
    
    localparam int MAP_TILES_W = 64;
    localparam int MAP_TILES_H = 64;
    
    localparam int MAP_PIX_W = MAP_TILES_W * TILE_SIZE;
    localparam int MAP_PIX_H = MAP_TILES_H * TILE_SIZE;
   
    function automatic logic is_blocked_tile(input tile_id_t tile_id);
    begin
        case (tile_id)
            TILE_WATER: is_blocked_tile = 1'b1;
            default:    is_blocked_tile = 1'b0;
        endcase
    end
    endfunction

endpackage

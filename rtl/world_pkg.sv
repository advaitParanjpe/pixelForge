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
        //Grass
        TILE_GRASS = 8'd0,

        //Paths
        TILE_PATH_V  = 8'd1,
        TILE_PATH_H  = 8'd2,
        
        TILE_PATH_DR  = 8'd3,
        TILE_PATH_UR  = 8'd4,
        TILE_PATH_RD  = 8'd5,
        TILE_PATH_RU  = 8'd6,
        
        //Waters
        TILE_WATER_V = 8'd7,
        TILE_WATER_H = 8'd8,
        
        TILE_WATER_DR = 8'd9,
        TILE_WATER_UR = 8'd10,
        TILE_WATER_RD = 8'd11,
        TILE_WATER_RU = 8'd12,
        
        //Bridges
        TILE_BRIDGE_V = 8'd13,
        TILE_BRIDGE_H = 8'd14,
        
        // Trees
        TILE_TREE = 8'd15,
        
        // Ramps
        TILE_RAMP_U = 8'd16,
        
        // Walls
        TILE_WALL_VL = 8'd17,
        TILE_WALL_VR = 8'd18,
        TILE_WALL_H = 8'd19,
        
        TILE_WALL_DL = 8'd20,
        TILE_WALL_DR = 8'd21,
        
        // Key
        TILE_KEY = 8'd22,
        
        // End Point
        TILE_ENDPOINT = 8'd23
        
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
            TILE_WATER_V: is_blocked_tile = 1'b1;
            TILE_WATER_H: is_blocked_tile = 1'b1;
            TILE_WATER_UR: is_blocked_tile = 1'b1;
            TILE_WATER_RD: is_blocked_tile = 1'b1;
            TILE_WATER_RU: is_blocked_tile = 1'b1;
            TILE_WATER_DR: is_blocked_tile = 1'b1;
            
            TILE_WALL_VL: is_blocked_tile = 1'b1;
            TILE_WALL_VR: is_blocked_tile = 1'b1;
            TILE_WALL_H: is_blocked_tile = 1'b1;
            TILE_WALL_DR: is_blocked_tile = 1'b1;
            TILE_WALL_DL: is_blocked_tile = 1'b1;
            
            TILE_TREE: is_blocked_tile = 1'b1;
            default:    is_blocked_tile = 1'b0;
        endcase
    end
    endfunction
    
    function automatic logic is_collectible_tile(input tile_id_t tile_id);
    begin
        case (tile_id)
            TILE_KEY: is_collectible_tile = 1'b1;
            default:  is_collectible_tile = 1'b0;
        endcase
    end
    endfunction
    
    function automatic logic is_goal_tile(input tile_id_t tile_id);
    begin
        case (tile_id)
            TILE_ENDPOINT: is_goal_tile = 1'b1;
            default:       is_goal_tile = 1'b0;
        endcase
    end
    endfunction

endpackage
